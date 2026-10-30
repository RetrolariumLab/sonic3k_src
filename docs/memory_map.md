# Memory and fixed interfaces

The assembler constants and emitted AS symbol tables are authoritative. This map
explains the ownership boundaries; it does not duplicate the complete
per-profile RAM allocation.

| Bus range or address               | Owner and meaning                                                         |
| ---------------------------------- | ------------------------------------------------------------------------- |
| 0x000000-0x0000ff                  | `Vectors`, fixed 68000 vector slots                                       |
| 0x000100-0x0001ff                  | `Header`, fixed cartridge metadata                                        |
| 0x000200-0x1fffff                  | Base cartridge program and content; 2 MiB preserved images                |
| 0x200000-0x3fffff                  | Attached S3 cartridge for S3&K; virtual exports in the S&K source         |
| 0x200001 onward, odd-byte SRAM map | `SRAM_start`; save-state layout is phased in words to skip even addresses |
| 0x300000-0x33ffff                  | Preserved Sonic 2 patch-window interface; excluded game profile           |
| 0xa00000-0xa01fff                  | Z80 RAM window through `Z80_RAM` / `Z80_RAM_end`                          |
| 0xc00000                           | `VDP_data_port`                                                           |
| 0xc00004                           | `VDP_control_port`                                                        |
| 0xc00011                           | `PSG_input`                                                               |
| 0xff0000-0xffffff                  | 68000 work RAM, described from sign-extended `RAM_start`                  |

Cartridge/SRAM address ranges describe different cartridge bus mappings; they
are not a promise that both mappings are simultaneously visible as plain ROM.
The ordinary source uses sign-extended short RAM addresses. Original positive
24-bit long encodings use masked expressions where required for preservation.

The common RAM allocation owns chunks, layouts, blocks, horizontal scrolling,
Nemesis queues, object slots, player objects, collision state, palettes and game
variables. S3 overrides selected competition/special-stage allocations in its
revision constants. Read symbols from the matching profile listing rather than
copying an address between engines. Runtime goldens validate every observed cell
against that matching symbol table.

The Z80 has its own address space: driver constants name YM2612 ports at
0x4000-0x4003, the bank register at 0x6000, PSG at 0x7f11 and the 32 KiB ROM
window at 0x8000. ROM-bank origins and padding remain assembler-computed. The
fixed region registry checks the bank allocation alignment as well as
vector/header positions and external-cartridge boundaries.

Fixed ranges and comparison boundaries are declared in
`config/reconstruction/fixed_regions.json`. They are explicit relocation
constraints, not permission to retain unnamed internal ROM pointers.
