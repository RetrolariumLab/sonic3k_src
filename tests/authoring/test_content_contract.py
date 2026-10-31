"""Profile, immutable footprint and path failures precede workspace writes."""

import copy
import hashlib
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from scripts.authoring import content_contract as codec
from scripts.authoring import kosinski


def fixture(*, compression="none"):
    raw = bytes.fromhex("00000eee")
    original = raw if compression == "none" else kosinski.encode(raw) + bytes(20)
    asset = {"path": "colors.bin", "size": len(original), "sha1": hashlib.sha1(original).hexdigest()}
    row = {
        "segment": "colors.bin",
        "path": "colors.bin",
        "codec": "palette",
        "compression": compression,
        "parameters": {},
        "round_trip": "exact" if compression == "none" else "original-stream",
        "capacity": {
            "policy": "preservation-fixed-footprint",
            "storage_owner": "asset-manifest",
            "decoded_bytes": len(raw),
        },
        "profiles": ["first", "equivalent"],
        "address_spaces": ["cartridge-rom"],
    }
    catalog = {"schema_version": 1, "scope": "preservation-fixed-footprint", "artifacts": [row]}
    return catalog, {"colors.bin": asset}, original


class ContentContractTests(unittest.TestCase):
    def test_semantic_edit_is_exactly_one_checked_color_word(self):
        spec, assets, original = fixture()
        catalog = codec.ContentCatalog(spec, assets, ["first", "equivalent", "other"])
        packet = catalog.decode("colors.bin", "first", original)
        self.assertEqual(catalog.encode(packet, target_profile="first", original=original), original)
        packet["model"][0]["red"] = 7
        self.assertEqual(catalog.encode(packet, target_profile="first", original=original), bytes.fromhex("000e0eee"))
        # Neither callers nor their copies can mutate the catalog's ABI definitions.
        spec["artifacts"][0]["parameters"] = {"unexpected": 1}
        catalog.rows()[0]["profiles"].append("other")
        self.assertEqual(catalog.encode(packet, target_profile="first", original=original), bytes.fromhex("000e0eee"))

    def test_compressed_edit_retains_fixed_slot_and_unchanged_original_tail(self):
        spec, assets, original = fixture(compression="kosinski")
        catalog = codec.ContentCatalog(spec, assets, ["first", "equivalent"])
        packet = catalog.decode("colors.bin", "first", original)
        self.assertEqual(catalog.encode(packet, target_profile="first", original=original), original)
        packet["model"][1]["blue"] = 0
        encoded = catalog.encode(packet, target_profile="first", original=original)
        self.assertEqual(len(encoded), len(original))
        self.assertEqual(kosinski.decode(encoded), bytes.fromhex("000000ee"))

    def test_wrong_profile_token_original_and_growth_fail_before_write(self):
        spec, assets, original = fixture()
        catalog = codec.ContentCatalog(spec, assets, ["first", "equivalent", "other"])
        packet = catalog.decode("colors.bin", "first", original)
        invalid = []
        altered = copy.deepcopy(packet)
        altered["contract"] = "unknown"
        invalid.append((altered, "first", original))
        invalid.append((packet, "equivalent", original))
        invalid.append((packet, "other", original))
        invalid.append((packet, "first", bytes(4)))
        altered = copy.deepcopy(packet)
        altered["model"].append(altered["model"][0])
        invalid.append((altered, "first", original))
        with tempfile.TemporaryDirectory() as folder, patch.object(codec, "atomic") as write:
            for model, profile, reference in invalid:
                with self.subTest(profile=profile), self.assertRaises(ValueError):
                    catalog.write(Path(folder), model, target_profile=profile, original=reference)
            write.assert_not_called()

    def test_unowned_outputs_and_catalog_path_traversal_fail(self):
        spec, assets, original = fixture()
        catalog = codec.ContentCatalog(spec, assets, ["first", "equivalent"])
        packet = catalog.decode("colors.bin", "first", original)
        with tempfile.TemporaryDirectory() as folder, patch.object(codec, "atomic") as write:
            with self.assertRaisesRegex(ValueError, "ignored build"):
                catalog.write(Path(folder), packet, target_profile="first", original=original)
            write.assert_not_called()
        for name in ("../colors.bin", "C:/colors.bin", "/colors.bin", "a/../colors.bin"):
            altered = copy.deepcopy(spec)
            altered["artifacts"][0]["path"] = altered["artifacts"][0]["segment"] = name
            with self.assertRaises(ValueError):
                codec.ContentCatalog(altered, {name: assets["colors.bin"]}, ["first", "equivalent"])

    def test_incomplete_duplicate_unsupported_and_unsafe_specs_fail(self):
        spec, assets, original = fixture()
        altered = copy.deepcopy(spec)
        altered["artifacts"] *= 2
        with self.assertRaises(ValueError):
            codec.ContentCatalog(altered, assets, ["first", "equivalent"])
        altered = copy.deepcopy(spec)
        altered["artifacts"][0]["parameters"] = {"module": "anything"}
        with self.assertRaises(ValueError):
            codec.ContentCatalog(altered, assets, ["first", "equivalent"])
        with self.assertRaises(ValueError):
            codec.ContentCatalog(spec, assets | {"missing.bin": assets["colors.bin"]}, ["first", "equivalent"])
        altered = copy.deepcopy(spec)
        altered["artifacts"][0]["capacity"]["decoded_bytes"] = True
        with self.assertRaises(ValueError):
            codec.ContentCatalog(altered, assets, ["first", "equivalent"])

    def test_dpcm_context_must_match_the_catalog_codebook_before_encoding(self):
        spec, assets, original = fixture()
        wave = bytes.fromhex("11")
        book = bytes(range(16))
        row = spec["artifacts"][0]
        row["codec"] = "dac-dpcm"
        row["capacity"]["decoded_bytes"] = 1
        assets["colors.bin"].update(size=1, sha1=hashlib.sha1(wave).hexdigest())
        codebook = copy.deepcopy(row)
        codebook["path"] = codebook["segment"] = "Sound/DAC/deltas.bin"
        codebook["codec"] = "dac-codebook"
        codebook["capacity"]["decoded_bytes"] = 16
        spec["artifacts"].append(codebook)
        assets[codebook["path"]] = {"size": 16, "sha1": hashlib.sha1(book).hexdigest()}
        catalog = codec.ContentCatalog(spec, assets, ["first", "equivalent"])
        packet = catalog.decode("colors.bin", "first", wave, context={"codebook": book})
        self.assertEqual(packet["model"], [1, 2])
        self.assertEqual(
            catalog.encode(packet, target_profile="first", original=wave, context={"codebook": book}), wave
        )
        for context in (None, {"codebook": bytes(16)}, {"codebook": list(range(16))}):
            with self.assertRaises(ValueError):
                catalog.encode(packet, target_profile="first", original=wave, context=context)

    def test_composite_collision_writes_cannot_use_s3_upper_shape_indices(self):
        spec, assets, original = fixture()
        original = bytes(3072)
        assets["colors.bin"].update(size=len(original), sha1=hashlib.sha1(original).hexdigest())
        row = spec["artifacts"][0]
        row.update(codec="collision-indices", parameters={"abi": "s3-planar16"}, profiles=["s3-us", "s3k"])
        row["capacity"]["decoded_bytes"] = len(original)
        catalog = codec.ContentCatalog(spec, assets, ["s3-us", "s3k"])
        composite = catalog.decode("colors.bin", "s3k", original)
        composite["model"][0]["path_a"] = 256
        with patch.object(codec, "atomic") as write, tempfile.TemporaryDirectory() as folder:
            with self.assertRaisesRegex(ValueError, "target shape"):
                catalog.write(folder, composite, target_profile="s3k", original=original)
            write.assert_not_called()
        standalone = catalog.decode("colors.bin", "s3-us", original)
        standalone["model"][0]["path_a"] = 511
        self.assertEqual(
            catalog.encode(standalone, target_profile="s3-us", original=original)[:2], bytes.fromhex("01ff")
        )
