; Owner: system/assembly
; Responsibility: Reusable RAM, VDP, Z80 bus and tile-address conversion helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; simplifying macros and functions
; nameless temporary symbols should NOT be used inside macros because they can interfere with the surrounding code
; normal labels should be used instead (which automatically become local to the macro)

; sign-extends a 32-bit integer to 64-bit
; all RAM addresses are run through this function to allow them to work in both 16-bit and 32-bit addressing modes
ramaddr:        function x,(-(x&$80000000)<<1)|x

; makes a VDP command
vdpComm:        function addr,type,rwd,(((type&rwd)&3)<<30)|((addr&$3FFF)<<16)|(((type&rwd)&$FC)<<2)|((addr&$C000)>>14)

; values for the type argument
VRAM:           equ     %100001
CRAM:           equ     %101011
VSRAM:          equ     %100101

; values for the rwd argument
READ:           equ     %001100
WRITE:          equ     %000111
DMA:            equ     %100111

; tells the VDP to copy a region of 68k memory to VRAM or CRAM or VSRAM
dma68kToVDP     macro   source,dest,length,type
                    lea     (VDP_control_port).l,a5
                    move.l  #(($9400|((((length)>>1)&$FF00)>>8))<<16)|($9300|(((length)>>1)&$FF)),(a5)
                    move.l  #(($9600|((((source)>>1)&$FF00)>>8))<<16)|($9500|(((source)>>1)&$FF)),(a5)
                    move.w  #$9700|(((((source)>>1)&$FF0000)>>16)&$7F),(a5)
                    move.w  #(vdpComm(dest,type,DMA)>>16)&$FFFF,(a5)
                    move.w  #vdpComm(dest,type,DMA)&$FFFF,(DMA_trigger_word).w
                    move.w  (DMA_trigger_word).w,(a5)
; From '  section 7  DMA TRANSFER' of https://emu-docs.org/Genesis/sega2f.htm:
;
; "In the case of ROM to VRAM transfers,
; a hardware feature causes occasional failure of DMA unless the
; following two conditions are observed:
;
; --The destination address write (to address $C00004) must be a word
; write
;
; --The final write must use the work RAM
; There are two ways to accomplish this, by copying the DMA program
; into RAM or by doing a final "move.w ram address $C00004""
                endm

; tells the VDP to fill a region of VRAM with a certain byte
dmaFillVRAM     macro   byte,addr,length
                    lea     (VDP_control_port).l,a5
                    move.w  #$8F01,(a5)                 ; VRAM pointer increment: $0001
                    move.l  #(($9400|((((length)-1)&$FF00)>>8))<<16)|($9300|(((length)-1)&$FF)),(a5)  ; DMA length
                    move.w  #$9780,(a5)                 ; VRAM fill
                    move.l  #vdpComm(addr,VRAM,DMA),(a5)  ; Start at
                    move.w  #(byte)|((byte)<<8),(VDP_data_port).l  ; Fill with byte
                    .loop:  move.w (a5),d1
                    btst    #1,d1
                    bne.s   .loop                       ; busy loop until the VDP is finished filling
                    move.w  #$8F02,(a5)                 ; VRAM pointer increment: $0002
                endm

; calculates initial loop counter value for a dbf loop
; that writes n bytes total at 4 bytes per iteration
bytesToLcnt:    function n,n>>2-1

; calculates initial loop counter value for a dbf loop
; that writes n bytes total at 2 bytes per iteration
bytesToWcnt:    function n,n>>1-1

; calculates initial loop counter value for a dbf loop
; that writes n bytes total at x bytes per iteration
bytesToXcnt:    function n,x,n/x-1

; fills a region of 68k RAM with 0
clearRAM        macro   addr,length
                    if      ((addr)&$8000)==0
                    lea     (addr).l,a1
                    else
                    lea     (addr).w,a1
                    endif
                    moveq   #0,d0
                    if      ((addr)&1)
                    move.b  d0,(a1)+
                    endif
                    move.w  #bytesToLcnt(length - ((addr)&1)),d1
                    .loop:  move.l d0,(a1)+
                    dbf     d1,.loop
                    if      ((length - ((addr)&1))&2)
                    move.w  d0,(a1)+
                    endif
                    if      ((length - ((addr)&1))&1)
                    move.b  d0,(a1)+
                    endif
                endm

; tells the Z80 to stop, and waits for it to finish stopping (acquire bus)
stopZ80         macro
                    move.w  #$100,(Z80_bus_request).l   ; stop the Z80
                    .loop:  btst #0,(Z80_bus_request).l
                    bne.s   .loop                       ; loop until it says it's stopped
                endm

; tells the Z80 to start again
startZ80        macro
                    move.w  #0,(Z80_bus_request).l      ; start the Z80
                endm

; function to make a little-endian 16-bit pointer for the Z80 sound driver
z80_ptr:        function x,(x)<<8&$FF00|(x)>>8&$7F|$80

; Assembly macro to declare a little-endian 16-bit pointer for the Z80 sound driver
rom_ptr_z80     macro   addr
                    dc.w    z80_ptr(addr)
                endm

; macros to convert from tile index to art tiles, block mapping or VRAM address
make_art_tile:  function addr,pal,pri,((pri<<15)&high_priority)|((pal<<13)&palette_line_3)|(addr&tile_mask)
tiles_to_bytes: function addr,((addr&tile_mask)<<5)

; function to calculate the location of a tile in plane mappings
planeLoc:       function width,col,line,(((width * line) + col) * 2)

; function to calculate the location of a tile in plane mappings with a width of 40 cells
planeLocH28:    function col,line,planeLoc(40,col,line)
