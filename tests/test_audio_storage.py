"""SMPS storage cannot lose ownership, cross a bank or accept another driver ABI."""

import copy
import unittest

from scripts.validation.audio_storage import resolve_catalog, validate_write


class AudioStorageTests(unittest.TestCase):
    def setUp(self):
        self.registry = {
            "us": {"entry": "s3.s"},
            "eu": {"entry": "s3.s"},
            "sk": {"entry": "sk.s"},
            "combined": {"compose": ["sk", "us"]},
        }
        self.assets = {
            "Sound/SMPS/s3/a.bin": {"image": "us", "offset": 0x9000, "size": 32, "format": "smps3"},
            "Sound/SMPS/sk/a.bin": {"image": "sk", "offset": 0x12000, "size": 24, "format": "smps4"},
        }
        self.policy = {
            "schema_version": 1,
            "bank_bytes": 32768,
            "window_base": 32768,
            "address_space": "z80-rom-window",
            "engines": {
                "us": {"abi": "s3-z80", "profiles": ["us", "eu", "combined"]},
                "sk": {"abi": "sk-z80", "profiles": ["sk", "combined"]},
            },
            "streams": [
                {"id": "s3/a", "asset": "Sound/SMPS/s3/a.bin", "base_symbol": "Song"},
                {"id": "sk/a", "asset": "Sound/SMPS/sk/a.bin", "base_symbol": "Song"},
            ],
        }

    def test_shared_regional_storage_and_composite_owners_are_explicit(self):
        streams = resolve_catalog(self.policy, self.assets, self.registry)
        validate_write(streams[0], "eu", "s3-z80", b"A" * 32)
        validate_write(streams[0], "combined", "s3-z80", b"A" * 32)
        validate_write(streams[1], "combined", "sk-z80", b"B" * 24)
        for profile, abi, data in (
            ("sk", "s3-z80", b"A"),
            ("combined", "sk-z80", b"A"),
            ("us", "s3-z80", b"A" * 33),
            ("us", "s3-z80", b""),
        ):
            with self.subTest(profile=profile, abi=abi), self.assertRaises(ValueError):
                validate_write(streams[0], profile, abi, data)

    def test_duplicate_omitted_and_cross_bank_streams_are_rejected(self):
        variants = []
        policy = copy.deepcopy(self.policy)
        policy["streams"].pop()
        variants.append((policy, self.assets))
        policy = copy.deepcopy(self.policy)
        policy["streams"].append(policy["streams"][0])
        variants.append((policy, self.assets))
        policy = copy.deepcopy(self.policy)
        policy["engines"]["us"]["profiles"].append("sk")
        variants.append((policy, self.assets))
        assets = copy.deepcopy(self.assets)
        assets["Sound/SMPS/s3/a.bin"]["offset"] = 0xFFF0
        variants.append((self.policy, assets))
        assets = copy.deepcopy(self.assets)
        assets["Sound/SMPS/s3/a.bin"]["format"] = "raw"
        variants.append((self.policy, assets))
        for policy, assets in variants:
            with self.subTest(policy=policy, assets=assets), self.assertRaises(ValueError):
                resolve_catalog(policy, assets, self.registry)
