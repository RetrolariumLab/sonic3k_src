"""Verify the complete reviewed data-emitter macro closure and primitive overrides."""

import hashlib
import re

from scripts.validation.numeric_operands import code_part

DATA_MACROS = frozenset(
    "dbglistobj dbglistinclude palptr plcptr watertransheader levselstr zoneanimstart zoneanimdecl zoneanimend "
    "levartptrs plrlistheader plreq palscriptptr palscripthdr palscriptdata palscriptfile "
    "palscriptrept palscriptloop palscriptrun".split()
)
ALIGNMENT_HELPERS = frozenset("org org0 cnop cnop0 align align0 even".split())
REVIEWED_MACROS = DATA_MACROS | ALIGNMENT_HELPERS
HEADER = re.compile(r"^\s*([A-Za-z_.][A-Za-z_0-9.]*)(?:\s*:\s*|\s+)macro(?:\s|$)", re.I)
LABEL = re.compile(r"^[^\s:]+:\s*")
COMPILE_TIME = frozenset("label equ set shift save restore codepage".split())
DATA_WORDS = frozenset(("dc.b", "dc.w", "dc.l"))
LOOPS = frozenset("while rept irp irpc".split())
CONDITIONS = frozenset("if elseif else endif".split())
DIAGNOSTICS = frozenset("error fatal message".split())
PRIMITIVES = (
    COMPILE_TIME
    | DATA_WORDS
    | LOOPS
    | CONDITIONS
    | DIAGNOSTICS
    | frozenset("include binclude macro endm db dw dd function charset padding listing supmode page".split())
)


def body_statement(line):
    return LABEL.sub("", code_part(line).strip()).strip()


def definition_blocks(text):
    """ENDM closes both macros and iteration blocks in the source dialect."""
    rows, result, first = text.splitlines(), [], 0
    while first < len(rows):
        match = HEADER.match(code_part(rows[first]))
        if not match:
            first += 1
            continue
        name = match[1].lower()
        if name in PRIMITIVES and name not in REVIEWED_MACROS:
            raise ValueError("Unchecked override of a data primitive: " + name)
        stack = ["macro"]
        for last in range(first + 1, len(rows)):
            code = body_statement(rows[last])
            op = code.split(None, 1)[0].lower() if code else ""
            if HEADER.match(code_part(rows[last])) or op == "macro":
                raise ValueError("Nested macro definition")
            if op in LOOPS:
                stack.append(op)
            elif op == "endm":
                stack.pop()
                if not stack:
                    break
        else:
            raise ValueError("Unclosed macro definition: " + name)
        result.append((name, first, last + 1, "\n".join(row.rstrip() for row in rows[first : last + 1]) + "\n"))
        first = last + 1
    return result


def macro_definitions(text):
    result = {}
    for name, first, last, body in definition_blocks(text):
        if name in REVIEWED_MACROS:
            if name in result:
                raise ValueError("Duplicate permitted data macro definition: " + name)
            result[name] = body
    return result


def definition_hash(text):
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def validate_definition(name, text):
    rows = text.splitlines()
    header = HEADER.match(code_part(rows[0])) if rows else None
    if not header or header[1].lower() != name or body_statement(rows[-1]).lower() != "endm":
        raise ValueError("Invalid data macro definition boundary")
    helper = name in ALIGNMENT_HELPERS
    controls, dependencies, saved = [], set(), 0
    for line in rows[1:-1]:
        code = body_statement(line)
        if not code:
            continue
        parts = code.split(None, 1)
        op, args = parts[0].lower(), parts[1] if len(parts) == 2 else ""
        if op == "binclude":
            if name != "palscriptfile" or args != "ALLARGS":
                raise ValueError("Data macro has an unchecked binary include")
            continue
        if op == "include":
            if name != "dbglistinclude" or args != "path":
                raise ValueError("Data macro has an unchecked source include")
            continue
        if op in ALIGNMENT_HELPERS:
            dependencies.add(op)
            continue
        if helper and op in LOOPS | CONDITIONS | {"endm"}:
            if op == "if":
                controls.append(["if", False])
            elif op in LOOPS:
                controls.append(["loop", False])
            elif op in ("else", "elseif"):
                if not controls or controls[-1][0] != "if" or controls[-1][1]:
                    raise ValueError("Unbalanced alignment conditional")
                controls[-1][1] = op == "else"
            else:
                kind = "if" if op == "endif" else "loop"
                if not controls or controls.pop()[0] != kind:
                    raise ValueError("Unbalanced alignment control block")
            continue
        allowed = DATA_WORDS | (frozenset(("label", "equ", "set", "db")) | DIAGNOSTICS if helper else COMPILE_TIME)
        if op not in allowed:
            raise ValueError("Data macro emits executable or unknown syntax: " + op)
        if op == "save":
            saved += 1
        elif op == "restore":
            saved -= 1
            if saved < 0:
                raise ValueError("Unbalanced data macro encoding restore")
        elif op == "codepage" and (not saved or args != "LEVELSELECT"):
            raise ValueError("Data macro has an unbounded or unknown encoding")
    if saved:
        raise ValueError("Unclosed data macro encoding context")
    if controls:
        raise ValueError("Unclosed alignment control block")
    return dependencies


def check_dependencies(graph):
    active, complete = set(), set()

    def visit(name):
        if name in active:
            raise ValueError("Cyclic data-emitter macro dependency")
        if name in complete:
            return
        active.add(name)
        for child in graph[name]:
            if child not in graph:
                raise ValueError("Data-emitter dependency has no reviewed definition")
            visit(child)
        active.remove(name)
        complete.add(name)

    for name in graph:
        visit(name)


def check_data_macros(sources, contract):
    if contract.get("schema_version") != 1:
        raise ValueError("Unsupported data macro contract")
    observed = {(path, name): body for path, text in sources.items() for name, body in macro_definitions(text).items()}
    records = contract.get("definitions", [])
    expected = [(row["source"], row["name"]) for row in records]
    if len(expected) != len(set(expected)) or set(expected) != set(observed):
        raise ValueError("Data macro contract omits, duplicates or adds definitions")
    if {name for _, name in expected} != REVIEWED_MACROS:
        raise ValueError("Data macro contract does not cover the complete emitter closure")
    graph = {name: set() for name in REVIEWED_MACROS}
    for row in records:
        body = observed[(row["source"], row["name"])]
        if not row.get("reason") or row.get("sha256") != definition_hash(body):
            raise ValueError("Data macro differs from its reviewed definition: " + row["name"])
        graph[row["name"]].update(validate_definition(row["name"], body))
    check_dependencies(graph)
    return len(records)
