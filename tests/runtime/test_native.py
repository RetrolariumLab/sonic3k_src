"""Fresh emulator state and PID-reuse-safe cleanup on success and failure paths."""

from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import Mock, patch

from scripts.runtime import native, processes


class ProcessOwnershipTests(unittest.TestCase):
    def test_descendants_need_creation_identity_and_foreign_processes_are_not_owned(self):
        owned = {}
        rows = [{"pid": 2, "created": 100, "ancestors": [1]}, {"pid": 3, "created": 101, "ancestors": [9]}]
        processes.remember_owned(rows, 1, owned)
        self.assertEqual(owned, {2: 100})
        self.assertEqual(processes.owned_leftovers(rows, owned), rows[:1])
        self.assertEqual(processes.owned_leftovers([rows[0] | {"created": 102}], owned), [])
        with self.assertRaises(ValueError):
            processes.remember_owned([rows[0] | {"created": None}], 1, {})

    def test_ancestry_handles_orphans_and_cycles_without_inventing_parents(self):
        rows = {1: {"parent": 2}, 2: {"parent": 3}, 3: {"parent": 2}, 4: {"parent": 9}}
        self.assertEqual(processes.ancestry(1, rows), [2, 3])
        self.assertEqual(processes.ancestry(4, rows), [9])

    def test_reused_pid_is_not_terminated_and_exact_identity_uses_one_handle(self):
        api = Mock()
        api.OpenProcess.return_value = 123
        api.WaitForSingleObject.return_value = 0
        with patch.object(processes, "creation_time", return_value=200):
            self.assertFalse(processes.terminate_owned(7, 100, api))
            api.TerminateProcess.assert_not_called()
            self.assertTrue(processes.terminate_owned(7, 200, api))
        api.OpenProcess.assert_called_with(0x101001, False, 7)
        api.TerminateProcess.assert_called_once_with(123, 1)
        api.WaitForSingleObject.assert_called_once_with(123, 5000)
        self.assertEqual(api.CloseHandle.call_count, 2)


class IsolatedMovieTests(unittest.TestCase):
    def setUp(self):
        base = native.ROOT / "build/tests"
        base.mkdir(parents=True, exist_ok=True)
        self.directory = tempfile.TemporaryDirectory(dir=base)
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.stage = self.root / "build/runtime/mame"
        self.stage.mkdir(parents=True)
        self.mame = self.stage / "consoles.exe"
        self.mame.write_bytes(b"synthetic pinned executable")
        self.scope = patch.object(native, "ROOT", self.root)
        self.scope.start()
        self.addCleanup(self.scope.stop)

    def test_every_run_discards_config_nvram_and_states_but_preserves_binary_and_neighbors(self):
        (self.stage / "cfg").mkdir()
        (self.stage / "cfg/genesis.cfg").write_text("prior config")
        (self.stage / "nvram").mkdir()
        (self.stage / "nvram/save").write_text("prior SRAM")
        (self.stage / "prior.sta").write_text("prior state")
        neighbor = self.root / "build/runtime/keep.log"
        neighbor.write_text("evidence")
        native.reset_emulator(self.mame)
        self.assertEqual(list(self.stage.iterdir()), [self.mame])
        self.assertEqual(self.mame.read_bytes(), b"synthetic pinned executable")
        self.assertEqual(neighbor.read_text(), "evidence")
        outside = self.root / "outside.exe"
        outside.write_text("untouched")
        with self.assertRaises(ValueError):
            native.reset_emulator(outside)
        self.assertEqual(outside.read_text(), "untouched")

    def invoke(self, proc, rows):
        return [
            patch.object(native, "load", return_value={"busy_timeout_seconds": 0, "run_timeout_seconds": 1}),
            patch.object(native, "wait_idle"),
            patch.object(native.subprocess, "Popen", return_value=proc),
            patch.object(native, "processes", side_effect=rows),
            patch.object(native, "terminate_owned"),
        ]

    def run_with(self, patches):
        from contextlib import ExitStack

        with ExitStack() as stack:
            mocks = [stack.enter_context(item) for item in patches]
            native.run_movie(["check", "--mame", self.mame], self.root / "build/runtime/test.log")
            return mocks

    def test_success_cannot_hide_owned_leftover_and_preserves_unrelated_process(self):
        proc = Mock(pid=10)
        proc.wait.return_value = 0
        owned = {"pid": 11, "created": 100, "ancestors": [10]}
        foreign = {"pid": 12, "created": 200, "ancestors": [9]}
        patches = self.invoke(proc, [[owned], [owned, foreign]])
        with patch.object(native, "terminate_owned") as terminate:
            patches.pop()
            with self.assertRaisesRegex(RuntimeError, "unrelated processes preserved"):
                self.run_with(patches)
            terminate.assert_called_once_with(11, 100)

    def test_failed_movie_still_checks_ownership_and_does_not_kill_foreign_process(self):
        proc = Mock(pid=10)
        proc.wait.side_effect = OSError("synthetic runner failure")
        foreign = {"pid": 12, "created": 200, "ancestors": [9]}
        patches = self.invoke(proc, [[], [foreign]])
        with patch.object(native, "terminate_owned") as terminate:
            patches.pop()
            with self.assertRaisesRegex(RuntimeError, "unrelated processes preserved"):
                self.run_with(patches)
            terminate.assert_not_called()

    def test_clean_success_leaves_no_process_and_uses_a_hidden_explicit_runner(self):
        proc = Mock(pid=10)
        proc.wait.return_value = 0
        mocks = self.run_with(self.invoke(proc, [[], []]))
        self.assertEqual(mocks[2].call_args.kwargs["cwd"], self.root)
        self.assertEqual(mocks[2].call_args.kwargs["env"]["PYTHONDONTWRITEBYTECODE"], "1")
        mocks[-1].assert_not_called()

    def test_timeout_kills_only_the_owned_runner_and_checks_descendant_cleanup(self):
        proc = Mock(pid=10)
        proc.poll.side_effect = [None, 0]
        proc.wait.side_effect = [subprocess.TimeoutExpired("owned runner", 1), 0]
        patches = self.invoke(proc, [[], []])
        with patch.object(native.time, "monotonic", side_effect=[0, 0, 2]):
            with self.assertRaisesRegex(RuntimeError, "frame/run budget"):
                self.run_with(patches)
        proc.kill.assert_called_once_with()
