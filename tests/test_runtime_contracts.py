"""Exact RAM evidence, cartridge wrappers and emulator pin regressions."""

import copy
import hashlib
import os
import unittest
from unittest.mock import patch

from scripts.build.project import rltool_command
from scripts.runtime.contracts import scenarios, validate_golden, wrap_empty_upper
from scripts.runtime.native import listed_process_ids, validate_executable, wait_idle


class RuntimeContracts(unittest.TestCase):
    def test_originals_cover_every_profile_and_reach_gameplay(self):
        contract, entries = scenarios()
        self.assertEqual(len(entries), 5)
        from scripts.build.project import load

        for entry in entries:
            validate_golden(entry, load(entry["check"]), contract)

    def test_missing_observations_and_non_gameplay_goldens_fail(self):
        from scripts.build.project import load

        contract, entries = scenarios()
        entry = entries[0]
        spec = load(entry["check"])
        wrong = copy.deepcopy(spec)
        del wrong["expected"][str(wrong["frames"][0])]["Score"]
        with self.assertRaises(ValueError):
            validate_golden(entry, wrong, contract)
        wrong = copy.deepcopy(spec)
        for values in wrong["expected"].values():
            values["Game_mode"] = "04"
        with self.assertRaisesRegex(ValueError, "gameplay"):
            validate_golden(entry, wrong, contract)

    def test_wrong_profile_ram_address_and_tolerance_fail(self):
        from scripts.build.project import load

        contract, entries = scenarios()
        entry = entries[0]
        spec = load(entry["check"])
        wrong = copy.deepcopy(spec)
        wrong["cells"]["Score"]["tolerance"] = 1
        with self.assertRaises(ValueError):
            validate_golden(entry, wrong, contract)
        symbols = {name: int(cell["address"], 0) for name, cell in spec["cells"].items()}
        symbols["Score"] += 2
        with self.assertRaisesRegex(ValueError, "source"):
            validate_golden(entry, spec, contract, symbols)

    def test_empty_upper_wrapper_preserves_every_base_byte(self):
        base = bytes(range(256)) * 2
        image = wrap_empty_upper(base, len(base))
        self.assertEqual(image[: len(base)], base)
        self.assertEqual(image[len(base) :], b"\xff" * len(base))
        with self.assertRaises(ValueError):
            wrap_empty_upper(base, len(base) + 2)


class NativeRunnerContracts(unittest.TestCase):
    def test_unpinned_executable_is_rejected_before_launch(self):
        data = b"synthetic test program"
        pin = {"size": len(data), "sha256": hashlib.sha256(data).hexdigest()}
        validate_executable(data, pin)
        with self.assertRaises(ValueError):
            validate_executable(data + b"x", pin)

    def test_busy_emulator_does_not_start_a_second_run(self):
        with patch("scripts.runtime.native.active_processes", return_value=[123]):
            with self.assertRaisesRegex(RuntimeError, "no second run"):
                wait_idle(0)

    def test_hook_style_multiword_rltool_is_an_argv_not_a_shell(self):
        with patch.dict(os.environ, {"RLTOOL": "python -m retrolarium_kit"}):
            self.assertEqual(rltool_command(), ["python", "-m", "retrolarium_kit"])


class WindowsProcessListTests(unittest.TestCase):
    def test_localized_memory_and_status_text_do_not_hide_a_process(self):
        data = b'"consoles.exe","321","Console","1","20 \x88\x81"\r\n'
        self.assertEqual(listed_process_ids(data), [321])
        self.assertEqual(listed_process_ids(b"\x88\x8d\x94\x8e: no matching task\r\n"), [])
