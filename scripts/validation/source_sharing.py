"""Resolve declared, profile-specific views of a shared executable source."""

from dataclasses import dataclass
import json
import re

from scripts.validation.numeric_operands import code_part

LAYOUT = "config/reconstruction/source_layout.json"
PATH = re.compile(r"src/(?:[a-z0-9_]+/)+[a-z0-9_]+\.s")
NAME = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")
SOURCE_TOKEN = re.compile(r'"(?:[^"\n]|"")*"|\'(?:[^\'\n]|\'\')*\'|;[^\n]*|(?<![\w.])\{(\w+)\}(?=[A-Za-z0-9_])')


@dataclass(frozen=True)
class SharedVariant:
    path: str
    historical: str
    include_owner: str
    parameter: str
    prefix: str
    profiles: tuple

    def expand(self, text):
        return SOURCE_TOKEN.sub(lambda token: self.prefix if token[1] == self.parameter else token[0], text)

    def restore_include(self, text, *, historical=False):
        """Consume only the exact literal declaration immediately before the include."""
        lines = text.splitlines(keepends=True)
        include = re.compile(r'include[ \t]+"' + re.escape(self.path) + r'"', re.I)
        positions = [i for i, line in enumerate(lines) if include.fullmatch(code_part(line).strip())]
        if len(positions) != 1 or positions[0] == 0:
            raise ValueError("Shared source requires one registered include: " + self.path)
        index = positions[0]
        declaration = code_part(lines[index - 1]).strip().split(None, 2)
        if declaration != [self.parameter, "equ", '"' + self.prefix + '"']:
            raise ValueError("Shared source requires its exact profile prefix: " + self.include_owner)
        if historical:
            lines[index] = lines[index].replace('"' + self.path + '"', '"' + self.historical + '"', 1)
        del lines[index - 1]
        return "".join(lines)


def shared_sources(root, layout=None):
    if layout is None:
        path = root / LAYOUT
        if not path.is_file():
            return ()
        layout = json.loads(path.read_text(encoding="utf-8"))
    rows = layout.get("shared_sources", [])
    if not isinstance(rows, list):
        raise ValueError("Invalid shared executable source registry")
    if not rows:
        return ()
    owners = {row["path"]: row for row in layout["files"]}
    paths, parameters, historical = set(), set(), set()
    result = []
    for row in rows:
        if not isinstance(row, dict) or set(row) != {"path", "parameter", "variants"}:
            raise ValueError("Invalid shared source owner")
        path, parameter, variants = row["path"], row["parameter"], row["variants"]
        if (
            not isinstance(path, str)
            or not PATH.fullmatch(path)
            or path in paths
            or owners.get(path, {}).get("role") != "code"
            or not (root / path).is_file()
            or not isinstance(parameter, str)
            or not NAME.fullmatch(parameter)
            or parameter.lower() in parameters
            or not isinstance(variants, list)
            or len(variants) < 2
        ):
            raise ValueError("Shared executable source needs a unique owner, parameter and distinct views")
        paths.add(path)
        parameters.add(parameter.lower())
        assigned = set()
        for variant in variants:
            if not isinstance(variant, dict) or set(variant) != {
                "historical",
                "include_owner",
                "prefix",
                "profiles",
                "origin",
            }:
                raise ValueError("Invalid shared source variant")
            old, caller, prefix, profiles, origin = (
                variant[key] for key in ("historical", "include_owner", "prefix", "profiles", "origin")
            )
            if (
                not all(isinstance(item, str) and PATH.fullmatch(item) for item in (old, caller))
                or old in historical
                or old in owners
                or (root / old).exists()
                or not isinstance(prefix, str)
                or not NAME.fullmatch(prefix)
                or not isinstance(profiles, list)
                or not profiles
                or any(not isinstance(p, str) for p in profiles)
                or len(set(profiles)) != len(profiles)
                or assigned.intersection(profiles)
                or owners.get(caller, {}).get("composition_contract") != {"kind": "order", "profiles": profiles}
                or not isinstance(origin, dict)
                or set(origin) != {"commit", "path", "first_line", "last_line", "sha256"}
                or not re.fullmatch(r"[0-9a-f]{40}", origin["commit"])
                or not re.fullmatch(r"[0-9a-f]{64}", origin["sha256"])
                or not origin["path"]
                or not 0 < origin["first_line"] <= origin["last_line"]
            ):
                raise ValueError("Shared source variant differs from its historical or profile scope")
            assigned.update(profiles)
            historical.add(old)
            view = SharedVariant(path, old, caller, parameter, prefix, tuple(profiles))
            view.restore_include((root / caller).read_text(encoding="utf-8"))
            result.append(view)
        emitted = {slot["profile"] for slot in owners[path]["rom_ranges"] if "component" not in slot}
        if assigned != emitted:
            raise ValueError("Shared source views must cover exactly the emitted base profiles")
    return tuple(result)


def project_includes(path, text, variants, *, historical=False):
    for view in variants:
        if view.include_owner == path:
            text = view.restore_include(text, historical=historical)
    return text
