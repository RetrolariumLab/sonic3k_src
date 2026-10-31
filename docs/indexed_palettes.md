# Indexed palette rotation

The alternate `Run_PalRotationScript2` reader is distinct from the palette macro
DSL. Its source catalog is `config/authoring/palette_indexed_formats.json`,
linked by the main content registry. Two 74-byte source groups are registered:
`off_7DD5A` in the Sky Sanctuary shared boss catalog and `off_914CE` in the
Hidden Palace emerald resources. Both apply to SK and its component of S3K. Five
caller sites, six destination cases and eight consumer/source owners are bound
to the contract. Caller changes require review of these bindings.

Each group has the following fixed layout:

| Field          | Representation                                                  |
| -------------- | --------------------------------------------------------------- |
| Palette table  | Absolute longword address of the relative offset table.         |
| Copy width     | Word containing colors minus one; both groups copy two colors.  |
| Sequence       | Twelve palette-index/delay-counter byte pairs.                  |
| Loop           | A negative index byte restarts at pair zero.                    |
| Stored marker  | The following FC byte is retained but is not read as a command. |
| Frame table    | Seven signed word displacements from the frame table base.      |
| Palette frames | Seven sets of two CRAM color words.                             |

The object uses byte counters at offsets 3A and 3B. Advancing adds two to the
sequence cursor before reading; restarting loads the first pair. Delays remain
stored byte-counter values rather than normalized durations. A palette index
must address a registered frame. Unlike the macro DSL, this reader copies color
words directly: color bit 15 does not enter command dispatch. Reserved CRAM bits
remain represented alongside three-bit red, green and blue channels.

The caller supplies the normal-palette RAM destination. The active AS memory
symbols prove color offsets 30, 46, 49 and 62 in the 64-color staging buffer;
the two-color copy at offset 62 ends exactly at its boundary. Destination,
color-width, table-pointer and relative-offset changes are structural edits and
are outside these fixed-footprint packets.

## Shared Hidden Palace bytes

The Hidden Palace initializer also copies the first eight bytes of `off_914CE`
into the ordinary palette rotation RAM state. Interpreting that copy with the
ordinary state layout gives displacement 9, delay 20, counter 238 and script
pointer `0001000F`. This preserves the source's original broken-state
reinterpretation; it is a source-level observation, not a claimed runtime crash
reproduction.

The indexed reader itself uses the same source group as an alternate header. Its
first index/delay pair therefore overlaps the other reader's script pointer. An
edit packet exposes the derived RAM-state view and preserves these first eight
bytes as structural data. Later sequence pairs and all palette colors remain
editable. The Sky Sanctuary group has no such copied-state context and permits
editing its first pair. No game instruction or original bug is changed by this
authoring contract.

## Source edits and verification

`IndexedPaletteCatalog` binds source declarations, profile, component, assembly
base, caller identities and the optional RAM-state overlay. Edits change only
palette indices, byte counters and RGB/reserved color values within their
registered capacities. The negative loop marker, unread marker, counts,
absolute/relative pointers, labels and storage size remain fixed.

The source grammar accepts bounded dc.b, dc.w, dc.l, scoped labels and even
alignment. It shares the safe arithmetic expression parser with raw source
handling and executes no assembler, includes or host expressions. The renderer
preserves symbolic expressions and validates all bytes and qualified labels.

`make check-content-contract` checks every alternate-reader call site and RAM
state-copy declaration against the source catalog without ROMs. The full
`make check-content-zero-edit` additionally checks active AS labels and bytes,
RAM destination bounds and SK/S3K profile views. Palette macro, raw-animation
and indexed-palette fragments enter the common composer together once; the
actual combined source tree is then assembled for all five preservation
containers. The standalone S3 profiles do not claim this SK-only format.
