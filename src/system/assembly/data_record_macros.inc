; Owner: system/assembly/data_records
; Responsibility: Level, palette, debug-list and graphics-load record declarations and level-select text encoding
; Source provenance and ranges: config/reconstruction/source_layout.json
; Assembly macro for generating water palette transition tables
watertransheader    macro   {INTLABEL}
__LABEL__:          label   *
; Number of entries in list minus one
                    dc.w    (((__LABEL___End - __LABEL__ - 2) / 2) - 1)
                endm

; Assembly macro for generating level select strings
levselstr       macro   str
                    save
                    codepage LEVELSELECT
                    dc.b    strlen(str)-1, str
                    restore
                endm

; codepage for level select (and save screen)
                save
                codepage LEVELSELECT
                charset '0','9', 16                     ; Add character set for numbers
                charset 'A','Z', 30                     ; Add character set for uppercase letters
                charset 'a','z', 30                     ; Add character set for lowercase letters
                charset '*', 26                         ; Add character for asterisk
                charset '@', 27                         ; Add character for copyright symbol
                charset $A9, 27                         ; Add character for copyright symbol
                charset ':', 28                         ; Add character for colon
                charset '.', 29                         ; Add character for period
                charset '#',$FF                         ; Add character that marks the end of text
                charset ' ',  0                         ; Add character for space
                restore

; macros for defining animated PLC script lists
zoneanimstart   macro   {INTLABEL}
__LABEL__:      label   *
zoneanimcount:  set     0
zoneanimcur:    set     "__LABEL__"
                    dc.w    zoneanimcount___LABEL__     ; Number of scripts for a zone (-1)
                endm

zoneanimend     macro
                    zoneanimcount_{"\{zoneanimcur}"}: equ zoneanimcount-1
                endm

zoneanimdeclanonid: set     0

zoneanimdecl        macro   duration,artaddr,vramaddr,numentries,numvramtiles
zoneanimdeclanonid: set     zoneanimdeclanonid + 1
start:
                    dc.l    (duration&$FF)<<24|artaddr
                    dc.w    tiles_to_bytes(vramaddr)
                    dc.b    numentries, numvramtiles
zoneanimcount:  set     zoneanimcount + 1
                endm

; Assembly macro for declaring a "main level load block" (MLLB)
levartptrs      macro   plc1,plc2,palette,art1,art2,map16x161,map16x162,map128x1281,map128x1282
                    dc.l    (plc1<<24)|art1
                    dc.l    (plc2<<24)|art2
                    dc.l    (palette<<24)|map16x161
                    dc.l    (palette<<24)|map16x162
                    dc.l    map128x1281
                    dc.l    map128x1282
                endm

; Assembly macro for a pattern load request list header
; must be on the same line as a label that has a corresponding _End label later
plrlistheader   macro   {INTLABEL}
__LABEL__:      label   *
                    dc.w    (((__LABEL___End - __LABEL__Plc) / 6) - 1)
__LABEL__Plc:
                endm

; Assembly macro for a pattern load request
plreq           macro   toVRAMaddr,fromROMaddr
                    dc.l    fromROMaddr
                    dc.w    tiles_to_bytes(toVRAMaddr)
                endm

; Assembly macro for a debug object list header
; must be on the same line as a label
dbglistinclude  macro   {INTLABEL},path
__LABEL__:      label   *
                    dc.w    ((__LABEL___End - __LABEL__ - 2) / $A)
                    include path
__LABEL___End:
                endm

; Assembly macro to define debug list object data
dbglistobj      macro   obj, mapaddr, subtype, frame, vram
                    dc.l    frame<<24|obj
                    dc.l    subtype<<24|mapaddr
                    dc.w    vram
                endm

tribyte         macro   val
                    if      "val"<>""
                    dc.b    (val >> 16)&$FF,(val>>8)&$FF,val&$FF
                    shift
                    tribyte ALLARGS
                    endif
                endm

; Assembly macro to define a palette script pointer
palscriptptr    macro   header, data
                    dc.w    data-header, 0
                    dc.l    header
                    ._headpos: set header
                endm

; Assembly macro to define a palette script header
palscripthdr    macro   palette, entries, value
                    dc.w    (palette)&$FFFF
                    dc.b    entries-1, value
                endm

; Assembly macro to define a palette script data
palscriptdata   macro   frames, data
                    .framec: set frames-1
                    shift
                    dc.w    ALLARGS
                    dc.w    .framec
                endm

; Assembly macro to define a palette script data from an external file
palscriptfile   macro   frames, data
                    .framec: set frames-1
                    shift
                    binclude ALLARGS
                    dc.w    .framec
                endm

; Assembly macro to repeat script from start
palscriptrept   macro   header
                    dc.w    -4
                endm

; Assembly macro to define loop from start for x number of times, then initialize with new header
palscriptloop   macro   header
                    dc.w    -8, header-._headpos
                    ._headpos: set header
                endm

; Assembly macro to run the custom script routine
palscriptrun    macro   header
                    dc.w    -$C
                endm
