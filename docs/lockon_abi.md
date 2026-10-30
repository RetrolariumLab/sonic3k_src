# Second-cartridge ABI

Sonic & Knuckles addresses its attached Sonic 3 cartridge at 0x200000. The
`Lockon S3/LockOn Pointers.s` declarations reserve a virtual address map; they
do not add Sonic 3 bytes to the Sonic & Knuckles image. This external interface
stays fixed when the S&K engine is relocated.

`config/reconstruction/lockon_abi.json` maps every one of its 675 labels to an
independently assembled S3 symbol plus an optional interior-byte addend. 659
names are shared. The remaining aliases name header fields, bootstrap bytes,
ending graphics, and interior bytes in the source-owned Knuckles 2P range. These
interior aliases make no new claim about their consumers.

Run `make verify-all` followed by `make check-lockon`. The check rejects a
missing or duplicate export, a missing target, an out-of-range addend, a moved
target, a mismatched external value, stale source evidence, or an altered built
image. It checks the USA, Europe and Japan S3 profiles separately.

`S3_Level_Solid_Data` is an address-comparison boundary rather than a data
export. It is recorded separately in `config/reconstruction/fixed_regions.json`.
That registry also records vector/header positions, the cartridge bus window,
the preserved Sonic 2 patch-window fields, and 32 KiB Z80 bank constraints. The
Sonic 2 lock-on game profile remains excluded.

Composite relocation keeps the second S3 cartridge on this preservation ABI;
standalone S3 probes may move its source independently. A byte-identical half
image alone does not establish runtime coverage for the composite product.

The eight external entries in `S2K_Sprite_Lists` belong to Sonic 2, not Sonic 3.
They use `S2_External_Sprite_List_*` constants relative to
`S2_Second_Cartridge_Base`. Two bus addresses happen to coincide with S3
interior-byte exports; those names must not be substituted into the Sonic 2
table. Retaining this fixed compatibility table does not add a Sonic 2 profile.

Absolute RAM operands retain their original positive 24-bit long encoding
through `(RAM_start+offset)&$FFFFFF`. The erroneous absolute vector-area reads
in `sub_2636C` and its S&K counterpart remain `Vectors+$30` and `Vectors+$34`;
replacing them with object-relative fields would change preserved behavior.

The preserved attract-ring bug also reads `Vectors+$30`; the Blue Sphere menu
bug tests `Vectors` itself. These are reads of the original vector-area bytes.
Their comments remain in source; the reconstruction does not repair them.
