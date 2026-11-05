"""Resolve bounded AS numeric aliases while retaining genuine label dependencies."""

import ast
from dataclasses import dataclass
import operator
import re


@dataclass(frozen=True)
class Resolution:
    values: frozenset = frozenset()
    symbolic: bool = False
    unresolved: bool = False


def qualify(expression, scope):
    expression = re.sub(r"\.[wl]$", "", expression.strip(), flags=re.I)
    return re.sub(r"(?<![\w.])\.[A-Za-z_][\w.]*", lambda match: scope + match[0], expression)


def merge_constants(*collections):
    result = {}
    for collection in collections:
        for name, expressions in collection.items():
            values = result.setdefault(name.casefold(), [])
            for expression in expressions:
                if expression not in values:
                    values.append(expression)
    return result


class Resolver:
    def __init__(self, constants):
        self.constants = constants
        self.cache = {}

    def resolve(self, expression, active=frozenset()):
        expression = re.sub(r"\$([0-9a-f]+)", r"0x\1", expression, flags=re.I)
        expression = re.sub(r"\b([0-9][0-9a-f]*)h\b", r"0x\1", expression, flags=re.I)
        expression = re.sub(r"(?<![\w)])%([01]+)", r"0b\1", expression)
        # A phase/current-PC declaration remains tied to assembler storage.
        if re.search(r"(?<![\w)])\*(?=[\s+\-/)&|]|$)|\$(?![\da-f])", expression, re.I):
            return Resolution(symbolic=True)
        # AS labels such as Owner.return can contain Python keywords. Parse
        # opaque placeholders and resolve their original spellings separately.
        names = {}

        def replace_symbol(match):
            token = "__asm_symbol_" + str(len(names))
            names[token] = match[0].casefold()
            return token

        expression = re.sub(r"(?<![\w.])[A-Za-z_][A-Za-z_0-9.]*", replace_symbol, expression)
        try:
            node = ast.parse(expression.strip(), mode="eval").body
        except (SyntaxError, ValueError, RecursionError):
            return Resolution(unresolved=True)
        if len(list(ast.walk(node))) > 128 or len(active) > 32:
            return Resolution(unresolved=True)
        return self._node(node, active, names)

    def _node(self, node, active, names):
        if isinstance(node, ast.Constant) and type(node.value) is int:
            return self._bounded({node.value})
        if isinstance(node, (ast.Name, ast.Attribute)):
            name = names.get(ast.unparse(node), ast.unparse(node)).casefold()
            if name not in self.constants:
                return Resolution(symbolic=True)
            if name in active:
                return Resolution(unresolved=True)
            if name not in self.cache:
                parts = [self.resolve(value, active | {name}) for value in self.constants[name]]
                self.cache[name] = Resolution(
                    frozenset().union(*(part.values for part in parts)),
                    any(part.symbolic for part in parts),
                    any(part.unresolved for part in parts),
                )
            return self.cache[name]
        if isinstance(node, ast.UnaryOp):
            part = self._node(node.operand, active, names)
            operation = {ast.UAdd: operator.pos, ast.USub: operator.neg, ast.Invert: operator.invert}.get(type(node.op))
            if operation:
                return self._bounded({operation(value) for value in part.values}, part.symbolic, part.unresolved)
        if isinstance(node, ast.BinOp):
            left, right = self._node(node.left, active, names), self._node(node.right, active, names)
            operation = {
                ast.Add: operator.add,
                ast.Sub: operator.sub,
                ast.Mult: operator.mul,
                ast.BitAnd: operator.and_,
                ast.BitOr: operator.or_,
                ast.BitXor: operator.xor,
                ast.LShift: operator.lshift,
                ast.RShift: operator.rshift,
            }.get(type(node.op))
            values = set()
            try:
                for first in left.values:
                    for second in right.values:
                        if isinstance(node.op, (ast.LShift, ast.RShift)) and not 0 <= second <= 63:
                            raise ValueError("Unbounded constant shift")
                        if isinstance(node.op, (ast.Div, ast.FloorDiv, ast.Mod)):
                            quotient = (abs(first) // abs(second)) * (-1 if (first < 0) != (second < 0) else 1)
                            value = first - quotient * second if isinstance(node.op, ast.Mod) else quotient
                        elif operation:
                            value = operation(first, second)
                        else:
                            return Resolution(symbolic=left.symbolic or right.symbolic, unresolved=True)
                        values.add(value)
                        if len(values) > 64:
                            raise ValueError("Too many constant alternatives")
            except (ArithmeticError, ValueError):
                return Resolution(symbolic=left.symbolic or right.symbolic, unresolved=True)
            return self._bounded(values, left.symbolic or right.symbolic, left.unresolved or right.unresolved)
        symbolic = any(
            self._node(child, active, names).symbolic
            for child in ast.iter_child_nodes(node)
            if isinstance(child, (ast.Name, ast.Attribute))
        )
        return Resolution(symbolic=symbolic, unresolved=True)

    @staticmethod
    def _bounded(values, symbolic=False, unresolved=False):
        if len(values) > 64 or any(value.bit_length() > 64 for value in values):
            return Resolution(symbolic=symbolic, unresolved=True)
        return Resolution(frozenset(values), symbolic, unresolved)
