"""Bounded context-sensitive SMPS bank control-flow analysis, without song payloads."""

from scripts.authoring.graphics import _bytes, _integer
from scripts.authoring.smps_headers import _abi
from scripts.authoring.smps_tracks import decode_instruction, encode_instruction


def analyze_bank(data, entries, *, abi, max_states=200000, max_call_depth=16):
    _abi(abi)
    raw = _bytes(data)
    if len(raw) != 32768:
        raise ValueError("SMPS analysis needs one complete 32 KiB bank window")
    for limit in (max_states, max_call_depth):
        if isinstance(limit, bool) or not isinstance(limit, int) or limit <= 0:
            raise ValueError("SMPS analysis budgets must be positive integers")
    pending = []
    for entry in entries:
        if set(entry) != {"address", "channel"}:
            raise ValueError("SMPS entry must declare its window address and hardware channel")
        pointer = _integer(entry["address"], 65536, "SMPS entry address")
        if pointer < 32768 or entry["channel"] not in ("fm", "psg", "dac"):
            raise ValueError("SMPS entry escapes its ROM window or channel ABI")
        pending.append((pointer, entry["channel"], False, ()))
    visited, nodes, issues = set(), {}, set()
    deepest = 0
    while pending:
        state = pending.pop()
        if state in visited:
            continue
        address, channel, alternate, stack = state
        if not 32768 <= address < 65536:
            raise ValueError("SMPS control flow escapes its selected ROM bank window")
        if len(visited) >= max_states:
            raise ValueError("SMPS control-flow state budget exceeded")
        visited.add(state)
        deepest = max(deepest, len(stack))
        model, size = decode_instruction(raw, address - 32768, abi=abi, channel=channel, alternate_frequency=alternate)
        encoded = encode_instruction(model, abi=abi, channel=channel, alternate_frequency=alternate)
        if encoded != raw[address - 32768 : address - 32768 + size]:
            raise ValueError("Typed SMPS instruction failed its original-byte round trip")
        nodes[(address, channel, alternate)] = {
            "address": address,
            "channel": channel,
            "alternate_frequency": alternate,
            "size": size,
            "instruction": model,
        }
        operation = model["op"]
        following = address + size
        if operation in ("stop", "silence_stop"):
            continue
        if operation == "return":
            if not stack:
                issues.add((address, "return-without-call"))
            else:
                pending.append((stack[-1], channel, alternate, stack[:-1]))
            continue
        if operation == "call":
            if len(stack) >= max_call_depth:
                raise ValueError("SMPS call-depth analysis budget exceeded")
            pending.append((model["target"], channel, alternate, stack + (following,)))
            continue
        if operation == "jump":
            pending.append((model["target"], channel, alternate, stack))
            continue
        if operation in ("repeat", "conditional_jump", "continuous_sfx_loop"):
            pending.append((model["target"], channel, alternate, stack))
        if operation == "alternate_frequency_mode":
            alternate = model["control"] == 1
        if operation == "copy_track_data":
            # This command attempts a write into the track's storage. A static
            # graph cannot claim to reproduce the resulting code or ROM writes.
            issues.add((address, "dynamic-track-copy"))
            count = model["count"] or 65536
            following += count
        if operation == "fm3_special_mode":
            issues.add((address, "original-fm3-self-modification-bug"))
        pending.append((following, channel, alternate, stack))
    coverage = bytearray(32768)
    for node in nodes.values():
        offset = node["address"] - 32768
        coverage[offset : offset + node["size"]] = bytes([1]) * node["size"]
    return {
        "states": len(visited),
        "maximum_call_depth": deepest,
        "instruction_bytes": sum(coverage),
        "nodes": [nodes[key] for key in sorted(nodes)],
        "issues": [{"address": address, "kind": kind} for address, kind in sorted(issues)],
    }
