"""Local legacy Sonic 2 placement lists retained in SK, without a Sonic 2 build profile."""

from scripts.authoring import object_placements

ABI = "legacy-s2-placement"


def decode(data, *, max_objects=768):
    # The record widths and flip positions are shared. Bit 15 is respawn-entry
    # selection in this ABI, not S3K's ignore-Y-range flag. Bit 12 requests a
    # normal object RAM slot in two-player mode. Type IDs retain all eight bits.
    model = object_placements.decode(data, max_objects=max_objects)
    if model["end_padding_bytes"] != 4:
        raise ValueError("Legacy S2 local layout requires its six-byte terminal record")
    for row in model["objects"]:
        row["respawn_entry"] = row.pop("ignore_y_range")
        row["normal_ram_in_two_player"] = row.pop("reserved_bit12")
    return dict(model, abi=ABI)


def encode(model, *, target_abi=ABI, max_objects=768):
    if (
        target_abi != ABI
        or model.get("abi") != ABI
        or set(model) != {"abi", "objects", "end_padding_bytes"}
        or model["end_padding_bytes"] != 4
    ):
        raise ValueError("Legacy object model and target have different placement ABIs")
    rows = []
    fields = (object_placements.FIELDS - {"ignore_y_range", "reserved_bit12"}) | {
        "respawn_entry",
        "normal_ram_in_two_player",
    }
    for row in model["objects"]:
        if set(row) != fields:
            raise ValueError("Legacy object fields differ from their respawn/two-player ABI")
        row = dict(row)
        row["ignore_y_range"] = row.pop("respawn_entry")
        row["reserved_bit12"] = row.pop("normal_ram_in_two_player")
        rows.append(row)
    return object_placements.encode({"objects": rows, "end_padding_bytes": 4}, max_objects=max_objects)


def check_respawn_capacity(model, capacity):
    if isinstance(capacity, bool) or not isinstance(capacity, int) or not 0 <= capacity <= 254:
        raise ValueError("Legacy respawn capacity must fit its one-byte index")
    if sum(row["respawn_entry"] for row in model["objects"]) > capacity:
        raise ValueError("Legacy placement exceeds the target respawn table")
