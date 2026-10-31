"""Driver payload extraction cannot merge ABIs, lose witnesses or overrun slots."""

import copy
import unittest

from scripts.authoring.driver_payloads import resolve_contract, validate_write
from scripts.validation.audio_source import validate_audio_source
from scripts.validation.private_data import validate_blob


def fixture():
    engines = {"s3-us": {"abi": "smps3-driver"}, "sk": {"abi": "smps4-driver"}}
    registry = {
        "s3-us": {"entry": "s3.s"},
        "s3-eu": {"entry": "s3.s"},
        "sk": {"entry": "sk.s"},
        "s3k": {"compose": ["sk", "s3-us"]},
    }
    source_assets = {"s3.bin": {"image": "s3-us", "size": 1200}, "sk.kos": {"image": "sk", "size": 64}}
    containers = {
        owner: {
            "asset": "s3.bin" if owner == "s3-us" else "sk.kos",
            "codec": "raw" if owner == "s3-us" else "kos",
            "decoded_size": 1200,
            "decoded_sha256": "0" * 64,
            "slot_capacity": 1200,
        }
        for owner in engines
    }
    rows, cursors = [], dict.fromkeys(engines, 0)
    labels = [("ModEnv_" + format(i, "02X"), "modulation-envelope") for i in range(8)]
    labels += [("VolEnv_" + format(i, "02X"), "volume-envelope") for i in range(1, 40)]
    labels.append(("z80_UniVoiceBank", "fm-voice-bank"))
    for label, kind in labels:
        groups = [["s3-us"], ["sk"]] if label == "VolEnv_26" else [list(engines)]
        for owners in groups:
            size = 875 if kind == "fm-voice-bank" else 3 if label == "VolEnv_26" and owners == ["s3-us"] else 2
            row = {
                "path": "Sound/Driver/Payloads/" + owners[0] + "/" + label + ".bin",
                "label": label,
                "format": kind,
                "size": size,
                "sha1": "0" * 40,
                "sha256": "0" * 64,
                "origins": {owner: cursors[owner] for owner in owners},
            }
            for owner in owners:
                cursors[owner] += size
            rows.append(row)
    return (
        {
            "schema_version": 1,
            "address_space": "z80-driver-ram",
            "virtual_base": 0x1300,
            "address_limit": 0x1C00,
            "containers": containers,
            "assets": rows,
        },
        source_assets,
        engines,
        registry,
    )


class DriverPayloadTests(unittest.TestCase):
    def test_shared_origins_and_the_official_variant_keep_distinct_abis(self):
        contract, sources, engines, registry = fixture()
        rows = resolve_contract(contract, sources, engines)
        self.assertEqual(len(rows), 49)
        row = next(r for r in rows if r["label"] == "VolEnv_26" and "s3-us" in r["origins"])
        validate_write(row, "s3-us", "s3-eu", "smps3-driver", b"AB", engines, registry)
        validate_write(row, "s3-us", "s3k", "smps3-driver", b"AB", engines, registry)
        for owner, profile, abi, payload in (
            ("sk", "sk", "smps4-driver", b"A"),
            ("s3-us", "sk", "smps3-driver", b"A"),
            ("s3-us", "s3k", "smps4-driver", b"A"),
            ("s3-us", "missing", "smps3-driver", b"A"),
            ("s3-us", "s3-us", "smps3-driver", b"AAAA"),
        ):
            with self.subTest(owner=owner, profile=profile), self.assertRaises(ValueError):
                validate_write(row, owner, profile, abi, payload, engines, registry)
        bank = next(r for r in rows if r["format"] == "fm-voice-bank")
        with self.assertRaises(ValueError):
            validate_write(bank, "s3-us", "s3-us", "smps3-driver", b"A" * 874, engines, registry)

    def test_missing_duplicate_overlapping_and_escaping_payloads_fail(self):
        contract, sources, engines, registry = fixture()
        changes = [
            lambda c: c["assets"].pop(),
            lambda c: c["assets"].append(copy.deepcopy(c["assets"][0])),
            lambda c: c["assets"][1]["origins"].update({"s3-us": 0}),
            lambda c: c["assets"][0]["origins"].update({"s3-us": 1200}),
            lambda c: c["assets"][0].update(path="Sound/Driver/Payloads/../../escape.bin"),
            lambda c: c["assets"][0].update(size=True),
            lambda c: c["containers"]["sk"].update(decoded_size=0x901),
            lambda c: c["containers"]["sk"].update(codec="unchecked"),
            lambda c: c["containers"]["sk"].update(slot_capacity=True),
        ]
        for change in changes:
            broken = copy.deepcopy(contract)
            change(broken)
            with self.subTest(change=change), self.assertRaises(ValueError):
                resolve_contract(broken, sources, engines)

    def test_legacy_paths_and_renamed_inline_audio_cannot_pass_history_audit(self):
        for path, body in (
            ("Sound/Music/A.asm", "Track: dc.b 1"),
            ("sound/SFX/A.s", " rts"),
            ("Sound/_smps2asm_inc.asm", " smpsHeaderStartSong macro\n endm"),
            ("renamed.s", " smpsVcAlgorithm 7"),
            ("renamed.inc", "VolEnv_26: db 1,2,$83"),
            ("renamed.s", "ModEnv_01:\n db 0"),
            ("renamed.s", "; Voice 00h - Named instrument\n"),
            ("renamed.s", "smpsHeaderStartSong macro\n dc.b 0\n endm"),
        ):
            with self.subTest(path=path, body=body), self.assertRaises(ValueError):
                validate_blob(body.encode(), set(), {}, path)

    def test_executable_tables_and_generic_instrument_helpers_remain_allowed(self):
        body = 'smpsVcAlgorithm macro value\n Field: set value\n endm\nzFMInstrumentRegTable: db $30,$40\nModEnv_01: binclude "data/Sound/Driver/Payloads/shared/modenv_01.bin"\n'
        validate_audio_source(body, "src/driver.s")
        validate_audio_source('example = "smpsVcAlgorithm 7"', "tests/example.py")


if __name__ == "__main__":
    unittest.main()
