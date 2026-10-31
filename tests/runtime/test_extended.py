"""Reject plausible looking observations that do not prove the declared route."""

import copy
import unittest
from unittest.mock import patch

from scripts.build.project import load
from scripts.runtime import extended


class ExtendedRouteTests(unittest.TestCase):
    def fixture(self):
        case = {
            "frames": 1200,
            "step": 30,
            "states": [{"mode": 4}, {"mode": 12}],
            "progress": [{"where": {"mode": 12}, "cell": "x", "distinct": 2}],
        }
        cells = {"mode": {"address": "0xff0000", "length": 1}, "x": {"address": "0xff0010", "length": 2}}
        frames = extended.checkpoints(case)
        spec = {
            "schema": "retrolarium.movie-check",
            "schema_version": 1,
            "cells": cells,
            "frames": frames,
            "expected": {
                str(frame): {"mode": "04" if i == 0 else "0c", "x": format(i, "04x")} for i, frame in enumerate(frames)
            },
        }
        return case, cells, spec

    def test_observations_need_distinct_ordered_states_and_active_progress(self):
        case, cells, spec = self.fixture()
        extended.validate_observations(case, spec, cells)
        wrong = copy.deepcopy(case)
        wrong["states"].reverse()
        with self.assertRaisesRegex(ValueError, "ordered"):
            extended.validate_observations(wrong, spec, cells)
        wrong = copy.deepcopy(spec)
        for values in wrong["expected"].values():
            values["x"] = "0000"
        with self.assertRaisesRegex(ValueError, "progress"):
            extended.validate_observations(case, wrong, cells)

    def test_missing_checkpoint_cell_and_nonzero_tolerance_are_rejected(self):
        case, cells, spec = self.fixture()
        wrong = copy.deepcopy(spec)
        del wrong["expected"]["end"]
        with self.assertRaisesRegex(ValueError, "checkpoints"):
            extended.validate_observations(case, wrong, cells)
        wrong = copy.deepcopy(spec)
        del wrong["expected"]["end"]["x"]
        with self.assertRaisesRegex(ValueError, "RAM values"):
            extended.validate_observations(case, wrong, cells)
        wrong = copy.deepcopy(spec)
        wrong["cells"]["x"]["tolerance"] = 1
        with self.assertRaisesRegex(ValueError, "tolerance"):
            extended.validate_observations(case, wrong, cells)

    def test_sram_cannot_use_a_future_writer_or_another_profiles_writer(self):
        contract = load(extended.CONFIG)
        reloads = [case for case in contract["cases"] if case.get("seed")]
        self.assertTrue(reloads)
        for seed in ("future-writer", "knuckles-sk"):
            wrong = copy.deepcopy(contract)
            next(case for case in wrong["cases"] if case.get("seed"))["seed"] = seed
            with patch.object(extended, "load", return_value=wrong):
                with self.assertRaisesRegex(ValueError, "own declared"):
                    extended.definitions()
        wrong = copy.deepcopy(contract)
        writer = next(case for case in wrong["cases"] if case["id"] == reloads[0]["seed"])
        writer["profiles"] = ["sk"]
        with patch.object(extended, "load", return_value=wrong):
            with self.assertRaisesRegex(ValueError, "own declared"):
                extended.definitions()

    def test_ram_views_are_bound_to_symbols_and_cannot_observe_cartridge_bytes(self):
        contract = {"cells": {"x": {"symbol": "Player", "offset_symbol": "x_pos", "length": 2}}}
        case = {"cells": ["x"]}
        self.assertEqual(
            extended.cell_addresses(contract, case, {"Player": 0xFFFF0000, "x_pos": 16}),
            {"x": {"address": "0xff0010", "length": 2}},
        )
        with self.assertRaisesRegex(ValueError, "work RAM"):
            extended.cell_addresses(contract, case, {"Player": 0x200000, "x_pos": 16})

    def test_noncanonical_movie_is_rejected_before_capture_provenance(self):
        from pathlib import Path
        import tempfile

        from scripts.build.project import ROOT

        base = ROOT / "build/tests"
        base.mkdir(parents=True, exist_ok=True)
        with tempfile.TemporaryDirectory(dir=base) as folder:
            root = Path(folder)
            contract = load(extended.CONFIG)
            movie = root / contract["cases"][0]["movie"]
            movie.parent.mkdir(parents=True)
            movie.write_bytes(b"source mame\r\n")
            with (
                patch.object(extended, "ROOT", root),
                patch.object(extended, "inside", side_effect=lambda name: root / name),
            ):
                with self.assertRaisesRegex(ValueError, "canonical LF"):
                    extended.definitions()
