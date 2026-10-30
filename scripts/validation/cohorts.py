"""Derive return sites and physical probe cohorts from AS source."""

from bisect import bisect_left, bisect_right
from collections import Counter, defaultdict
from itertools import islice
import re

from scripts.validation.numeric_operands import code_part, MEMORY_OPS

LABEL = re.compile(r"^([A-Za-z_.][A-Za-z_0-9.]*|[+-]+):\s*")
END = re.compile(r"; End of function\s+(\S+)")
SHORT = re.compile(r"b(?:cc|cs|eq|ge|gt|hi|hs|le|lo|ls|lt|mi|ne|pl|vc|vs)\.s$")
TERMINALS = frozenset(("rts", "rte", "rtr", "jmp", "bra"))
INSTRUCTIONS = MEMORY_OPS | frozenset(
    "abcd bcc bcs beq bge bgt bhi bhs ble blo bls blt bmi bne bpl bra bsr bvc bvs dbcc dbcs dbeq dbf dbge dbgt dbhi dble dblo dbls dblt dbmi dbne dbpl dbra dbt dbvc dbvs illegal jmp jsr link moveq nop reset rte rtr rts stop trap trapv unlk".split()
)


def statements(text):
    result, scope, cpu, saved = [], "", "68000", []
    for number, line in enumerate(text.splitlines(), 1):
        code = code_part(line).strip()
        label = None
        match = LABEL.match(code)
        if match:
            label = match[1]
            if label[0] not in ".+-":
                scope = label
            code = code[match.end() :].strip()
        parts = code.split(None, 1)
        op = parts[0].lower() if parts else ""
        args = parts[1].strip() if len(parts) > 1 else ""
        if op == "save":
            saved.append(cpu)
        elif op == "restore":
            if not saved:
                raise ValueError("Unbalanced AS restore")
            cpu = saved.pop()
        elif op == "cpu":
            cpu = args.lower()
        result.append(
            {
                "line": number,
                "label": label,
                "scope": scope,
                "op": op,
                "args": args,
                "cpu": cpu,
                "code": code,
                "end": END.search(line).group(1) if END.search(line) else None,
            }
        )
    return result


def label_index(rows):
    named = defaultdict(list)
    anonymous = {"+": [], "-": []}
    for row in rows:
        name = row["label"]
        if not name:
            continue
        if name in anonymous:
            anonymous[name].append(row["line"])
        else:
            named[row["scope"] + name if name.startswith(".") else name].append(row["line"])
    return named, anonymous


def resolve(target, row, index):
    named, anonymous = index
    if re.fullmatch(r"\++", target):
        choices = anonymous["+"]
        at = bisect_right(choices, row["line"]) + len(target) - 1
        return choices[at] if at < len(choices) else None
    if re.fullmatch(r"-+", target):
        choices = anonymous["-"]
        at = bisect_left(choices, row["line"]) - len(target)
        return choices[at] if at >= 0 else None
    if not re.fullmatch(r"[A-Za-z_.][A-Za-z_0-9.]*", target):
        return None
    matches = named.get(row["scope"] + target if target.startswith(".") else target, [])
    return matches[0] if len(matches) == 1 else None


def protection_spans(rows):
    spans, tables = [], []
    index = label_index(rows)
    for row in rows:
        if row["cpu"] != "68000":
            continue
        if SHORT.fullmatch(row["op"]):
            target = resolve(row["args"], row, index)
            if target is None:
                raise ValueError("Unresolved short conditional at line " + str(row["line"]))
            lo, hi = sorted((row["line"], target))
            spans.append({"first": lo, "last": hi, "kind": "short-conditional"})
        for operand in re.finditer(
            r"([A-Za-z_.][A-Za-z_0-9.]*)(?:[+-][^(),]*)?\(pc,[da][0-7]\.[wl]\)", row["args"], re.I
        ):
            target = resolve(operand[1], row, index)
            if target is None:
                raise ValueError("Unresolved indexed PC operand at line " + str(row["line"]) + ": " + operand[0])
            lo, hi = sorted((row["line"], target))
            spans.append({"first": lo, "last": hi, "kind": "indexed-pc-byte-displacement"})
        match = re.fullmatch(r"([A-Za-z_][A-Za-z_0-9]*)(?:[+-][^()]*)?\(pc,d[0-7]\.w\)", row["args"], re.I)
        if row["op"] != "jmp" or not match:
            continue
        target = resolve(match[1], row, index)
        if target is None:
            raise ValueError("Unresolved indexed jump table")
        slots = []
        for candidate in islice(rows, target - 1, None):
            if not candidate["op"]:
                continue
            if candidate["op"].split(".")[0] not in ("bra", "bsr", "jmp", "rts", "rte", "nop"):
                break
            slots.append(candidate)
        if len(slots) > 1:
            table = {"first": target, "last": slots[-1]["line"], "kind": "indexed-slots", "target": match[1]}
            tables.append(table)
            spans.append(table)
    return spans, tables


def collect_file(path, text):
    rows = statements(text)
    # Named aliases may precede the actual instruction; preserve all of them.
    code_labels, pending = set(), []
    for row in rows:
        if row["label"] and row["label"][0] not in ".+-":
            pending.append(row["label"])
        if row["op"]:
            if row["cpu"] == "68000" and row["op"].split(".")[0] in INSTRUCTIONS:
                code_labels.update(pending)
            pending = []
    annotated, points, chain = [], {}, []
    previous = 0
    definitions, _ = label_index(rows)
    covered = set()
    for row in rows:
        if not row["end"] or row["cpu"] != "68000":
            continue
        starts = [n for n in definitions.get(row["end"], []) if previous < n < row["line"]]
        begin = starts[-1] if starts else previous + 1
        members = [r for r in rows[begin - 1 : row["line"] - 1] if r["op"]]
        if not members:
            raise ValueError("Procedure marker has no preceding statements")
        last = members[-1]
        instructions = [r for r in members if r["cpu"] == "68000" and r["op"].split(".")[0] in INSTRUCTIONS]
        if not instructions:
            raise ValueError(
                "Procedure marker has no 68000 instructions: " + path + ":" + str(row["line"]) + " " + row["end"]
            )
        terminal = instructions[-1]
        # Data following an unconditional terminal is a private procedure tail.
        kind = terminal["op"].split(".")[0]
        ends = kind in TERMINALS and (last == terminal or last["op"].split(".")[0] not in INSTRUCTIONS)
        item = {"name": row["end"], "first": begin, "last": row["line"], "terminal": ends, "exact_start": bool(starts)}
        if starts:
            code_labels.add(row["end"])
        annotated.append(item)
        chain.append(item["name"])
        covered.update(range(begin, row["line"] + 1))
        if ends:
            points[row["line"]] = {
                "after": row["line"],
                "return": "rte" if kind == "rte" else "rts",
                "members": list(chain),
                "kind": "annotated-terminal",
            }
            chain.clear()
        previous = row["line"]
    if chain:
        raise ValueError("Unterminated annotated fallthrough cohort")
    sites = [r for r in rows if r["cpu"] == "68000" and r["op"] in ("rts", "rte")]
    significant = [r for r in rows if r["op"] or r["label"]]
    next_rows = {}
    for left, right in zip(significant, significant[1:]):
        next_rows[left["line"]] = right
    for row in sites:
        if row["line"] in covered:
            continue
        following = next_rows.get(row["line"])
        if following is None or (following["label"] and following["label"][0] not in ".+-"):
            points[row["line"]] = {
                "after": row["line"],
                "return": row["op"],
                "members": [],
                "kind": "extra-return-boundary",
            }
    if not sites and not annotated:
        return {
            "path": path,
            "points": [],
            "returns": [],
            "procedures": [],
            "merges": [],
            "tables": [],
            "code_labels": sorted(code_labels),
        }
    instructions = [r for r in rows if r["cpu"] == "68000" and r["op"].split(".")[0] in INSTRUCTIONS]
    if instructions:
        terminal = instructions[-1]
        tail = [r for r in rows[terminal["line"] :] if r["op"]]
        # A complete lookup-table owner can end after its terminal instruction.
        # Its own PC-relative data must precede the unreachable guard, rather
        # than force ownership into the next unrelated function or source file.
        data_ops = {"dc.b", "dc.w", "dc.l", "binclude", "even", "align"}
        if terminal["op"].split(".")[0] in TERMINALS and tail and all(r["op"] in data_ops for r in tail):
            if any(r["op"] in {"dc.b", "dc.w", "dc.l", "binclude"} for r in tail):
                points.setdefault(
                    len(rows), {"after": len(rows), "return": "rts", "members": [], "kind": "terminal-data-tail"}
                )
    spans, tables = protection_spans(rows)
    safe = [n for n in sorted(points) if not any(s["first"] <= n < s["last"] for s in spans)]
    if not safe:
        raise ValueError("No safe terminal cohort in " + path)
    merges = []
    for number in sorted(points):
        at = bisect_left(safe, number)
        if at == len(safe):
            raise ValueError("Return boundary has no safe landing")
        landing = safe[at]
        if number != landing:
            merges.append(
                {
                    "from": number,
                    "to": landing,
                    "reason": [s["kind"] for s in spans if s["first"] <= number < s["last"]],
                }
            )
            points[landing]["members"].extend(points[number]["members"])
    returns = []
    for row in sites:
        at = bisect_left(safe, row["line"])
        if at == len(safe):
            raise ValueError("Uncovered return site in " + path)
        returns.append({"line": row["line"], "op": row["op"], "cohort": safe[at]})
    result = {
        "path": path,
        "points": [points[n] for n in safe],
        "returns": returns,
        "procedures": annotated,
        "merges": merges,
        "tables": tables,
        "code_labels": sorted(code_labels),
    }
    for point in result["points"]:
        point["id"] = path + ":" + str(point["after"])
    validate_ownership(result)
    return result


def render(text, points, startup_label=None):
    insertions = {p["after"]: p["return"] for p in points}
    output, startup = [], 0
    for number, line in enumerate(text.splitlines(keepends=True), 1):
        if startup_label and re.match(r"^" + re.escape(startup_label) + r":", line):
            output.append("; Unreachable relocation guard after the fixed header.\n                rts\n")
            startup += 1
        output.append(line)
        if number in insertions:
            if not line.endswith("\n"):
                output.append("\n")
            output.append("                " + insertions[number] + "\n")
    if startup_label and startup != 1:
        raise ValueError("Startup guard anchor is missing or ambiguous")
    return "".join(output)


def table_slot(lines, index):
    # Growing even an unconditional branch changes an indexed slot's stride.
    rows = statements("".join(lines))
    _, tables = protection_spans(rows)
    return any(t["first"] <= index + 1 <= t["last"] for t in tables)


def validate_ownership(document):
    points = document["points"]
    positions = {p["after"] for p in points}
    if len(positions) != len(points) or len({p["id"] for p in points}) != len(points):
        raise ValueError("Duplicate physical cohort ownership")
    expected = Counter(p["name"] for p in document["procedures"])
    actual = Counter(name for point in points for name in point["members"])
    if expected != actual:
        raise ValueError("Annotated procedure ownership is incomplete or duplicated")
    returns = document["returns"]
    if len({r["line"] for r in returns}) != len(returns) or any(
        r["cohort"] not in positions or r["cohort"] < r["line"] for r in returns
    ):
        raise ValueError("Raw return site ownership is incomplete or duplicated")
