"""Context-sensitive SMPS calls, loops, alternate frequencies and strict bank bounds."""

import unittest
from scripts.authoring import smps_graph as codec


def bank(parts):
    output = bytearray(32768)
    for address, packed in parts:
        data = bytes.fromhex(packed)
        output[address - 32768 : address - 32768 + len(data)] = data
    return bytes(output)


class SmpsGraphTests(unittest.TestCase):
    def analyze(self, data, entries=None, **kwargs):
        return codec.analyze_bank(data, entries or [{"address": 0x8000, "channel": "fm"}], abi="smps3", **kwargs)

    def test_call_return_and_conditional_loop_reach_each_typed_instruction(self):
        data = bank([(0x8000, "f81080f700020080f2"), (0x8010, "8106f9")])
        graph = self.analyze(data)
        self.assertEqual(graph["issues"], [])
        self.assertEqual(graph["maximum_call_depth"], 1)
        self.assertEqual({node["address"] for node in graph["nodes"]}, {0x8000, 0x8003, 0x8008, 0x8010, 0x8011, 0x8012})
        self.assertEqual(graph["instruction_bytes"], 12)

    def test_mode_changed_in_subroutine_persists_after_return(self):
        data = bank([(0x8000, "f81080123400fffd00f2"), (0x8010, "fd01f9")])
        graph = self.analyze(data)
        nodes = {row["address"]: row for row in graph["nodes"]}
        self.assertTrue(nodes[0x8003]["alternate_frequency"])
        self.assertEqual(nodes[0x8003]["instruction"]["op"], "literal_frequency")
        self.assertFalse(nodes[0x8009]["alternate_frequency"])

    def test_same_bytes_can_be_notes_or_samples_under_different_channels(self):
        graph = self.analyze(
            bank([(0x8000, "8101f2")]), [{"address": 0x8000, "channel": "fm"}, {"address": 0x8000, "channel": "dac"}]
        )
        self.assertEqual(
            {row["instruction"]["op"] for row in graph["nodes"] if row["address"] == 0x8000}, {"note", "sample"}
        )
        self.assertEqual(graph["instruction_bytes"], 3)

    def test_unbalanced_return_and_original_self_modification_are_explicit(self):
        result = self.analyze(bank([(0x8000, "fe00010203f9")]))
        self.assertEqual(
            [row["kind"] for row in result["issues"]], ["original-fm3-self-modification-bug", "return-without-call"]
        )

    def test_escaped_targets_recursion_and_fallthrough_fail_boundedly(self):
        with self.assertRaisesRegex(ValueError, "escapes"):
            self.analyze(bank([(0x8000, "f60010")]))
        with self.assertRaisesRegex(ValueError, "call-depth"):
            self.analyze(bank([(0x8000, "f80080")]), max_call_depth=2)
        with self.assertRaisesRegex(ValueError, "escapes"):
            self.analyze(bank([(0xFFFF, "80")]), [{"address": 0xFFFF, "channel": "fm"}])
        with self.assertRaisesRegex(ValueError, "state budget"):
            self.analyze(bank([(0x8000, "8101f2")]), max_states=1)
