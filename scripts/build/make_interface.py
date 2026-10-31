"""Read explicit public Make rules through the actual include graph."""

import re


def recipes(root):
    root = root.resolve()
    pending, visited, result = [root / "Makefile"], set(), {}
    while pending:
        path = pending.pop()
        if not path.resolve().is_relative_to(root) or not path.is_file():
            raise ValueError("Missing or escaping Make include")
        if path in visited:
            continue
        visited.add(path)
        active = []
        for line in path.read_text().splitlines():
            if line.startswith("include "):
                pending.extend(root / name for name in line.split()[1:])
            match = re.fullmatch(r"([\w.-]+(?:[ \t]+[\w.-]+)*)\s*:(?!=).*", line)
            if match and not line.startswith((" ", "\t", ".")):
                active = match.group(1).split()
                for target in active:
                    if target in result:
                        raise ValueError("Duplicate public Make rule: " + target)
                    result[target] = []
            elif line.startswith("\t"):
                for target in active:
                    result[target].append(line.strip())
            elif line and not line.startswith("#"):
                active = []
    return result
