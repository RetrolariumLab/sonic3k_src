"""Closed SMPS corpus reconstruction, shared tracks, semantic edits and fixed slots."""

import copy
import unittest
from scripts.authoring import smps_storage as codec


def fixture():
    first = bytes.fromhex("1081010180040a810008ef008106f2f2") + bytes(25)
    second = bytes.fromhex("1081010180050a810009")
    streams = [
        {"id": "first", "bank_offset": 256, "kind": "sfx", "data": first},
        {"id": "second", "bank_offset": 512, "kind": "sfx", "data": second},
    ]
    bank = bytearray(32768)
    for row in streams:
        bank[row["bank_offset"] : row["bank_offset"] + len(row["data"])] = row["data"]
    return streams, bytes(bank)


class SmpsStorageTests(unittest.TestCase):
    def model(self):
        streams, bank = fixture()
        return codec.decode_corpus(streams, bank, abi="smps3")

    def test_shared_track_local_voice_bank_and_dead_stop_are_fully_typed(self):
        streams, bank = fixture()
        model = codec.decode_corpus(streams, bank, abi="smps3")
        self.assertEqual(len(model["voice_banks"]), 1)
        self.assertEqual(model["voice_banks"][0]["bank_offset"], 272)
        self.assertEqual(model["unreachable"][0]["instruction"], {"op": "stop"})
        self.assertEqual(codec.encode_corpus(model, target_abi="smps3"), {row["id"]: row["data"] for row in streams})
        self.assertNotIn("data", model)

    def test_header_duration_and_instrument_edits_have_the_expected_bytes(self):
        streams, bank = fixture()
        model = self.model()
        model["streams"][1]["header"]["tracks"][0]["volume"] = 10
        node = next(row for row in model["instructions"] if row["instruction"]["op"] == "duration")
        node["instruction"]["ticks"] = 7
        model["voice_banks"][0]["voices"][0]["algorithm"] = 3
        result = codec.encode_corpus(model, target_abi="smps3")
        expected = bytearray(streams[0]["data"])
        expected[13], expected[16] = 7, 3
        self.assertEqual(result["first"], expected)
        self.assertEqual(result["second"], streams[1]["data"][:-1] + bytes([10]))

    def test_missing_shared_storage_and_wrong_bank_input_fail(self):
        streams, bank = fixture()
        with self.assertRaisesRegex(ValueError, "escapes"):
            codec.decode_corpus(streams[1:], bank, abi="smps3")
        wrong = bytearray(bank)
        wrong[256] ^= 1
        with self.assertRaisesRegex(ValueError, "differs"):
            codec.decode_corpus(streams, wrong, abi="smps3")

    def test_another_driver_abi_cannot_receive_the_model(self):
        with self.assertRaisesRegex(ValueError, "different"):
            codec.encode_corpus(self.model(), target_abi="smps4")

    def test_instruction_header_voice_and_slot_growth_fail_before_return(self):
        model = self.model()
        voice = next(row for row in model["instructions"] if row["instruction"]["op"] == "set_voice")
        voice["instruction"] = {"op": "set_voice", "index": 128, "song_bank_selector": 129}
        with self.assertRaisesRegex(ValueError, "fixed allocation"):
            codec.encode_corpus(model, target_abi="smps3")
        model = self.model()
        model["voice_banks"][0]["voices"].append(copy.deepcopy(model["voice_banks"][0]["voices"][0]))
        with self.assertRaisesRegex(ValueError, "bank allocation"):
            codec.encode_corpus(model, target_abi="smps3")
        model = self.model()
        model["streams"][0]["header"]["tracks"].append(copy.deepcopy(model["streams"][0]["header"]["tracks"][0]))
        with self.assertRaisesRegex(ValueError, "header.*fixed allocation"):
            codec.encode_corpus(model, target_abi="smps3")
        model = self.model()
        model["streams"][0]["capacity"] -= 1
        with self.assertRaisesRegex(ValueError, "escapes"):
            codec.encode_corpus(model, target_abi="smps3")

    def test_overlapping_alias_edits_cannot_disagree(self):
        model = self.model()
        node = copy.deepcopy(next(row for row in model["instructions"] if row["instruction"]["op"] == "duration"))
        node["instruction"]["ticks"] = 20
        model["instructions"].append(node)
        with self.assertRaisesRegex(ValueError, "disagree"):
            codec.encode_corpus(model, target_abi="smps3")

    def test_missing_semantic_record_or_overlapping_catalog_slots_fail(self):
        model = self.model()
        model["unreachable"] = []
        with self.assertRaisesRegex(ValueError, "without a semantic"):
            codec.encode_corpus(model, target_abi="smps3")
        streams, bank = fixture()
        streams.append(dict(streams[0], id="overlap"))
        with self.assertRaisesRegex(ValueError, "overlap"):
            codec.decode_corpus(streams, bank, abi="smps3")
