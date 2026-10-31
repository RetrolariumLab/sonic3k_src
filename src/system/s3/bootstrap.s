; Owner: system/s3; responsibility: bootstrap
; Source provenance and ranges: config/reconstruction/source_layout.json
; Buildable disassembly imported from Sonic Retro. See docs/provenance.md

; Processor:        68000
; Target Assembler: 680x0 Assembler in MRI compatible mode
; This file should be compiled with "as -M"

; ---------------------------------------------------------------------------
                cpu     68000
                include "src/system/assembly/compiler_setup.s"
                include "src/system/assembly/hardware_helpers.s"
                include "src/system/assembly/data_record_macros.s"
                include "src/audio/shared/bank_and_sample_macros.s"
                include "src/memory/shared/object_offsets.s"
                include "src/memory/shared/hardware.s"
                include "src/memory/shared/sram.s"
                include "src/memory/shared/ram.s"
                include "src/memory/shared/special_stage_overlays.s"
                include "src/memory/shared/art_tiles.s"
                include "src/memory/shared/sound_ids.s"
                include "src/memory/shared/assembly_cursor.s"
                include "src/memory/s3/overrides.s"
; ---------------------------------------------------------------------------
SonicDriverVer: equ     3                               ; Original product-specific Z80 driver ABI

Size_of_Snd_driver_guess:   equ     $1300
Size_of_Snd_driver2_guess:  equ     $843
Size_of_Snd_Bank1:          equ     $E60
; This particular bank has its contents aligned to the end
; ---------------------------------------------------------------------------

StartOfROM:
                if      * <> 0
                fatal   "StartOfROM was $\{*} but it should be 0"
                endif

Vectors:        dc.l    0, EntryPoint, ErrorTrap, ErrorTrap  ; 0
                dc.l    ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap  ; 4
                dc.l    ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap  ; 8
                dc.l    ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap  ; 12
                dc.l    ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap  ; 16
                dc.l    ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap  ; 20
                dc.l    ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap  ; 24
                dc.l    JmpTo_HInt, ErrorTrap, VInt,  ErrorTrap  ; 28
                dc.l    ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap  ; 32
                dc.l    ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap  ; 36
                dc.l    ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap  ; 40
                dc.l    ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap  ; 44
                dc.l    ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap  ; 48
                dc.l    ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap  ; 52
                dc.l    ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap  ; 56
                dc.l    ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap  ; 60
Header:             dc.b    "SEGA GENESIS    "
Copyright:          dc.b    "(C)SEGA 1993.NOV"
Domestic_Name:      dc.b    "SONIC THE             HEDGEHOG 3                "
Overseas_Name:      dc.b    "SONIC THE             HEDGEHOG 3                "
Serial_Number:      dc.b    "GM MK-1079 -00"
Checksum:           dc.w    $A8F2
Input:              dc.b    "J               "
ROMStartLoc:        dc.l    StartOfROM
ROMEndLoc:          dc.l    EndOfROM-1
RAMStartLoc:        dc.l    (RAM_start)&$FFFFFF
RAMEndLoc:          dc.l    (RAM_end-1)&$FFFFFF
CartRAM_Info:       dc.b    "RA"
CartRAM_Type:       dc.w    %1111100000100000           ; Save odd number 8-bit addresses
CartRAMStartLoc:    dc.l    SRAM_start
CartRAMEndLoc:      dc.l    SRAM_end
Modem_Info:         dc.b    "  "
                dc.b    "          "
Unknown_Header: dc.w    1
                dc.b    "      "
                dc.l    EndOfROM
                dc.l    MD_Cartridge_Bus_End-1
                dc.l    SRAM_start
                dc.l    SRAM_end
                dc.b    "                "
Country_Code:   dc.b    S3_Region,"               "
; ---------------------------------------------------------------------------
; Crash/Freeze the 68000. Like Sonic 2 the Z80 will still keep running, so music playback will continue

ErrorTrap:
                nop
                nop
                bra.s   ErrorTrap
; ---------------------------------------------------------------------------

EntryPoint:
                lea     (System_stack).w,sp
                tst.l   (HW_Port_1_Control-1).l
                bne.s   loc_218
                tst.w   (HW_Expansion_Control-1).l

loc_218:
                bne.s   Init_SkipPowerOn                ; in case of a soft reset
                lea     SetupValues(pc),a5
                movem.w (a5)+,d5-d7
                movem.l (a5)+,a0-a4
                move.b  HW_Version-Z80_bus_request(a1),d0  ; get hardware version
                andi.b  #$F,d0
                beq.s   SkipSecurity                    ; branch if hardware is older than Genesis III
                move.l  #'SEGA',Security_addr-Z80_bus_request(a1)  ; satisfy the TMSS

SkipSecurity:
                move.w  (a4),d0                         ; check if VDP works
                moveq   #0,d0
                movea.l d0,a6
                move.l  a6,usp                          ; set usp to $0
                moveq   #VDPInitValues_End-VDPInitValues-1,d1

Init_VDPRegs:
                move.b  (a5)+,d5
                move.w  d5,(a4)
                add.w   d7,d5
                dbf     d1,Init_VDPRegs                 ; set all 24 registers

                move.l  (a5)+,(a4)                      ; set VRAM write mode
                move.w  d0,(a3)                         ; clear the screen
                move.w  d7,(a1)                         ; stop the Z80
                move.w  d7,(a2)                         ; reset the Z80

WaitForZ80:
                btst    d0,(a1)                         ; has the Z80 stopped?
                bne.s   WaitForZ80                      ; if not, branch
                moveq   #Z80StartupCodeEnd-Z80StartupCodeBegin-1,d2

Init_SoundRAM:
                move.b  (a5)+,(a0)+
                dbf     d2,Init_SoundRAM
                move.w  d0,(a2)
                move.w  d0,(a1)                         ; start the Z80
                move.w  d7,(a2)                         ; reset the Z80

Init_ClearRAM:
                move.l  d0,-(a6)                        ; Clear normal RAM
                dbf     d6,Init_ClearRAM
                move.l  (a5)+,(a4)                      ; set VDP display mode and increment
                move.l  (a5)+,(a4)                      ; set VDP to CRAM write
                moveq   #bytesToLcnt($80),d3

Init_ClearCRAM:
                move.l  d0,(a3)                         ; Clear CRAM
                dbf     d3,Init_ClearCRAM
                move.l  (a5)+,(a4)
                moveq   #bytesToLcnt($50),d4

Init_ClearVSRAM:
                move.l  d0,(a3)                         ; Clear VSRAM
                dbf     d4,Init_ClearVSRAM
                moveq   #PSGInitValues_End-PSGInitValues-1,d5

Init_InputPSG:
                move.b  (a5)+,PSG_input-VDP_data_port(a3)  ; reset the PSG
                dbf     d5,Init_InputPSG
                move.w  d0,(a2)
                movem.l (a6),d0-a6                      ; clear all registers
                move    #$2700,sr                       ; set the sr

Init_SkipPowerOn:
                bra.s   Test_CountryCode
; ---------------------------------------------------------------------------
SetupValues:
                dc.w    $8000,bytesToLcnt($10000),$100
                dc.l    Z80_RAM
                dc.l    Z80_bus_request
                dc.l    Z80_reset
                dc.l    VDP_data_port, VDP_control_port

; values for VDP registers
VDPInitValues:
                dc.b    4                               ; Command $8004 - HInt off, Enable HV counter read
                dc.b    $14                             ; Command $8114 - Display off, VInt off, DMA on, PAL off
                dc.b    $30                             ; Command $8230 - Scroll A Address $C000
                dc.b    $3C                             ; Command $833C - Window Address $F000
                dc.b    7                               ; Command $8407 - Scroll B Address $E000
                dc.b    $6C                             ; Command $856C - Sprite Table Address $D800
                dc.b    0                               ; Command $8600 - Null
                dc.b    0                               ; Command $8700 - Background color Pal 0 Color 0
                dc.b    0                               ; Command $8800 - Null
                dc.b    0                               ; Command $8900 - Null
                dc.b    $FF                             ; Command $8AFF - Hint timing $FF scanlines
                dc.b    0                               ; Command $8B00 - Ext Int off, VScroll full, HScroll full
                dc.b    $81                             ; Command $8C81 - 40 cell mode, shadow/highlight off, no interlace
                dc.b    $37                             ; Command $8D37 - HScroll Table Address $DC00
                dc.b    0                               ; Command $8E00 - Null
                dc.b    1                               ; Command $8F01 - VDP auto increment 1 byte
                dc.b    1                               ; Command $9001 - 64x32 cell scroll size
                dc.b    0                               ; Command $9100 - Window H left side, Base Point 0
                dc.b    0                               ; Command $9200 - Window V upside, Base Point 0
                dc.b    $FF                             ; Command $93FF - DMA Length Counter $FFFF
                dc.b    $FF                             ; Command $94FF - See above
                dc.b    0                               ; Command $9500 - DMA Source Address $0
                dc.b    0                               ; Command $9600 - See above
                dc.b    $80                             ; Command $9700 - See above + VRAM fill mode
VDPInitValues_End:
                dc.l    vdpComm($0000,VRAM,DMA)         ; value for VRAM write mode

; Z80 instructions (not the sound driver; that gets loaded later)
Z80StartupCodeBegin:
                cpu     Z80                             ; start assembling Z80 code
                phase   0                               ; pretend we're at address 0

                xor     a                               ; clear a to 0
                ld      bc,((Z80_RAM_end-Z80_RAM)-zStartupCodeEndLoc)-1  ; prepare to loop this many times
                ld      de,zStartupCodeEndLoc+1         ; initial destination address
                ld      hl,zStartupCodeEndLoc           ; initial source address
                ld      sp,hl                           ; set the address the stack starts at
                ld      (hl),a                          ; set first byte of the stack to 0
                ldir                                    ; loop to fill the stack (entire remaining available Z80 RAM) with 0
                pop     ix                              ; clear ix
                pop     iy                              ; clear iy
                ld      i,a                             ; clear i
                ld      r,a                             ; clear r
                pop     de                              ; clear de
                pop     hl                              ; clear hl
                pop     af                              ; clear af
                ex      af,af'                          ; swap af with af'
                exx                                     ; swap bc/de/hl with their shadow registers too
                pop     bc                              ; clear bc
                pop     de                              ; clear de
                pop     hl                              ; clear hl
                pop     af                              ; clear af
                ld      sp,hl                           ; clear sp
                di                                      ; clear iff1 (for interrupt handler)
                im      1                               ; interrupt handling mode = 1
                ld      (hl),0E9h                       ; replace the first instruction with a jump to itself
                jp      (hl)                            ; jump to the first instruction (to stay there forever)
zStartupCodeEndLoc:
                dephase                                 ; stop pretending
                cpu     68000
                padding off
Z80StartupCodeEnd:

                dc.w    $8104                           ; value for VDP display mode
                dc.w    $8F02                           ; value for VDP increment
                dc.l    vdpComm($0000,CRAM,WRITE)       ; value for CRAM write mode
                dc.l    vdpComm($0000,VSRAM,WRITE)      ; value for VSRAM write mode
PSGInitValues:
                dc.b    $9F,$BF,$DF,$FF                 ; values for PSG channel volumes
PSGInitValues_End:
; ---------------------------------------------------------------------------
Test_CountryCode:
                tst.w   (VDP_control_port).l
; ---------------------------------------------------------------------------
; Lockout code. The original file can be found at:
; https://techdocs.exodusemulator.com/Console/SegaMegaDrive/Software.html#original-development-tools
; ---------------------------------------------------------------------------
CheckVDP:
                clr.l   d0                              ; must be empty for check to work properly
                move.b  (HW_Version).l,d0               ; read hardware territory ID
                lsr.b   #6,d0                           ; get ID into range 0..3
                andi.b  #3,d0
                lea     CountryCodes(pc),a0             ; point to country code table
                move.b  (a0,d0.w),d0                    ; translate ID to a country code
                tst.b   d0
                beq.w   TrapCheckVDP                    ; illegal hardware ID (tampering?)

                lea     (Country_Code).l,a0             ; point to country codes in ID block
                move.w  #16-1,d1                        ; number of bytes in country field in ID block

CheckCountry:
                cmp.b   (a0),d0                         ; is this the machine's code?
                beq.w   EndCheckVDP                     ; found it, ok to run the game
                addq.l  #1,a0
                dbf     d1,CheckCountry                 ; nope, check the next one?

                lea     (VDP_data_port).l,a4            ; VDP data port
                lea     (VDP_control_port).l,a5         ; VDP control port

                move.w  #$8164,(a5)                     ; enable display, VINT on, DMA off
                move.w  #$8230,(a5)                     ; scroll A map starts at $C000
                move.w  #$8C81,(a5)                     ; 40 column mode
                move.w  #$8F02,(a5)                     ; autoincrement = 2
                move.w  #$9001,(a5)                     ; scroll size = 64x32

                move.l  #vdpComm($0002,CRAM,WRITE),(a5)  ; CRAM write to color #1
                move.w  #$0EEE,(a4)                     ; set color 1 to white

                move.l  #vdpComm($0000,VRAM,WRITE),(a5)  ; VRAM address for chars
                lea     AASCIIchars(pc),a0              ; a0 -> charset for message
                move.w  #59-1,d0                        ; 59 chars

                move.l  #$10000000,d2                   ; set pixel mask

WriteCharSet:
                move.w  #8-1,d6                         ; 8 rows per char

WriteChar:
                move.b  (a0)+,d1                        ; get a row (source is 1 bit per pixel)
                move.l  #0,d4                           ; clear pixel row accumulator
                move.w  #8-1,d5                         ; 8 pixels per row

WritePix:
                rol.l   #4,d2                           ; rotate masks to next pixel position

                ror.b   #1,d1                           ; check next bit in source
                bcc.s   NextPix                         ; if it's 0, don't put a pixel

                or.l    d2,d4                           ; else, put a pixel

NextPix:
                dbf     d5,WritePix                     ; next pixel

WritePixRow:
                move.l  d4,(a4)                         ; put pixel row in VRAM
                dbf     d6,WriteChar                    ; next row

                dbf     d0,WriteCharSet                 ; next char

                move.b  #8,d1                           ; set row for WriteString
                lea     MsgDevelopedFor(pc),a0          ; set string address for WriteString
                move.b  (a0)+,d0                        ; set column for WriteString
                bsr.w   WriteString                     ; write it to the screen

                lea     (Country_Code).l,a1             ; point to territory ID's in ID block

CheckID:
                cmpi.b  #' ',(a1)                       ; if this entry in ID block = ' '
                beq.s   CheckIDDone                     ; we're done

                lea     MsgPtrs(pc),a2                  ; point to list of message ID's & pointers

CheckMsg:
                move.w  (a2)+,d4                        ; get message ID
                tst.b   d4                              ; if message ID = 0
                beq.s   NextID                          ; step to next territory ID
                cmp.b   (a1),d4                         ; else if message ID != territory ID
                bne.s   NoPrint                         ; don't print this message

                cmpi.b  #' ',1(a1)                      ; if this territory ID isn't the last one
                bne.s   PrintMsg                        ; don't print the "&"
                cmpa.l  #Country_Code,a1
                beq.s   PrintMsg

                lea     MsgAnd(pc),a0                   ; else
                move.b  (a0)+,d0                        ; print it
                addq.w  #1,d1
                bsr.w   WriteString

PrintMsg:
                lea     MessageData(pc),a0              ; set string address for WriteString
                adda.l  (a2)+,a0                        ; add offset

                move.b  (a0)+,d0                        ; set column for WriteString
                addq.w  #1,d1                           ; next line
                bsr.w   WriteString                     ; write it to the screen
                bra.s   NextID                          ; check the next territory ID

NoPrint:
                addq.l  #4,a2
                bra.s   CheckMsg

NextID:
                addq.l  #1,a1                           ; point to the next territory ID and
                bra.s   CheckID                         ; check it

CheckIDDone:
                lea     MsgSystems(pc),a0               ; write last line of message
                move.b  (a0)+,d0
                addq.w  #1,d1
                bsr.w   WriteString

TrapCheckVDP:
                bra.s   TrapCheckVDP

WriteString:
                move.b  d1,d2
                andi.l  #$FF,d2
                swap    d2
                lsl.l   #7,d2
                move.b  d0,d3
                andi.l  #$FF,d3
                swap    d3
                asl.l   #1,d3
                add.l   d3,d2
                addi.l  #vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d2
                move.l  d2,(a5)

ws01:
                tst.b   (a0)
                beq.s   ws99
                move.b  (a0)+,d2
                subi.b  #' ',d2
                andi.w  #$FF,d2
                move.w  d2,(a4)
                bra.s   ws01

ws99:
                rts

MessageData:

CountryCodes:
                dc.b    'J',0,'UE'

MsgPtrs:
                dc.b    0,'J'
                dc.l    MsgJapan-MessageData

                dc.b    0,'U'
                dc.l    MsgUSA-MessageData

                dc.b    0,'E'
                dc.l    MsgEurope-MessageData

                dc.w    0

; 0123456789012345678901234567890123456789
MsgDevelopedFor:
                dc.b    6,           'DEVELOPED FOR USE ONLY WITH',0
MsgAnd:
                dc.b    18,                       '&',0
MsgSystems:
                dc.b    15,                   'SYSTEMS.',0
MsgJapan:
                dc.b    12,                'NTSC MEGA DRIVE',0
MsgUSA:
                dc.b    13,                 'NTSC GENESIS',0
MsgEurope:
                dc.b    4,         'PAL AND FRENCH SECAM MEGA DRIVE',0

AASCIIchars:
                dc.l    %00000000000000000000000000000000
                dc.l    %00000000000000000000000000000000  ; ' '
                dc.l    %00011000000110000001100000011000
                dc.l    %00000000000110000001100000000000  ; !
                dc.l    %00110110001101100100100000000000
                dc.l    %00000000000000000000000000000000  ; "
                dc.l    %00010010000100100111111100010010
                dc.l    %01111111001001000010010000000000  ; #
                dc.l    %00001000001111110100100000111110
                dc.l    %00001001011111100000100000000000  ; $
                dc.l    %01110001010100100111010000001000
                dc.l    %00010111001001010100011100000000  ; %
                dc.l    %00011000001001000001100000101001
                dc.l    %01000101010001100011100100000000  ; &
                dc.l    %00110000001100000100000000000000
                dc.l    %00000000000000000000000000000000  ; '
                dc.l    %00001100000100000010000000100000
                dc.l    %00100000000100000000110000000000  ; (
                dc.l    %00110000000010000000010000000100
                dc.l    %00000100000010000011000000000000  ; )
                dc.l    %00000000000010000010101000011100
                dc.l    %00101010000010000000000000000000  ; *
                dc.l    %00001000000010000000100001111111
                dc.l    %00001000000010000000100000000000  ; +
                dc.l    %00000000000000000000000000000000
                dc.l    %00000000001100000011000001000000  ; ,
                dc.l    %00000000000000000000000001111111
                dc.l    %00000000000000000000000000000000  ;-
                dc.l    %00000000000000000000000000000000
                dc.l    %00000000001100000011000000000000  ; Yen glyph
                dc.l    %00000001000000100000010000001000
                dc.l    %00010000001000000100000000000000  ; /
                dc.l    %00011110001100110011001100110011
                dc.l    %00110011001100110001111000000000  ; 0
                dc.l    %00011000001110000001100000011000
                dc.l    %00011000000110000011110000000000  ; 1
                dc.l    %00111110011000110110001100001110
                dc.l    %00111000011000000111111100000000  ; 2
                dc.l    %00111110011000110000001100011110
                dc.l    %00000011011000110011111000000000  ; 3
                dc.l    %00000110000011100001111000110110
                dc.l    %01100110011111110000011000000000  ; 4
                dc.l    %01111110011000000111111001100011
                dc.l    %00000011011000110011111000000000  ; 5
                dc.l    %00111110011000110110000001111110
                dc.l    %01100011011000110011111000000000  ; 6
                dc.l    %00111111011000110000011000000110
                dc.l    %00001100000011000001100000000000  ; 7
                dc.l    %00111110011000110110001100111110
                dc.l    %01100011011000110011111000000000  ; 8
                dc.l    %00111110011000110110001100111111
                dc.l    %00000011011000110011111000000000  ; 9
                dc.l    %00000000000110000001100000000000
                dc.l    %00000000000110000001100000000000  ; :
                dc.l    %00000000000110000001100000000000
                dc.l    %00000000000110000001100000100000  ;;
                dc.l    %00000011000011000011000001000000
                dc.l    %00110000000011000000001100000000  ; <
                dc.l    %00000000000000000111111100000000
                dc.l    %01111111000000000000000000000000  ;=
                dc.l    %01100000000110000000011000000001
                dc.l    %00000110000110000110000000000000  ; >
                dc.l    %00111110011000110000001100011110
                dc.l    %00011000000000000001100000000000  ; ?
                dc.l    %00111100010000100011100101001001
                dc.l    %01001001010010010011011000000000  ; @
                dc.l    %00011100000111000011011000110110
                dc.l    %01111111011000110110001100000000  ; A
                dc.l    %01111110011000110110001101111110
                dc.l    %01100011011000110111111000000000  ; B
                dc.l    %00111110011100110110000001100000
                dc.l    %01100000011100110011111000000000  ; C
                dc.l    %01111110011000110110001101100011
                dc.l    %01100011011000110111111000000000  ; D
                dc.l    %00111111001100000011000000111110
                dc.l    %00110000001100000011111100000000  ; E
                dc.l    %00111111001100000011000000111110
                dc.l    %00110000001100000011000000000000  ; F
                dc.l    %00111110011100110110000001100111
                dc.l    %01100011011100110011111000000000  ; G
                dc.l    %01100110011001100110011001111110
                dc.l    %01100110011001100110011000000000  ; H
                dc.l    %00011000000110000001100000011000
                dc.l    %00011000000110000001100000000000  ; I
                dc.l    %00001100000011000000110000001100
                dc.l    %11001100110011000111100000000000  ; J
                dc.l    %01100011011001100110110001111000
                dc.l    %01101100011001100110001100000000  ; K
                dc.l    %01100000011000000110000001100000
                dc.l    %01100000011000000111111100000000  ; L
                dc.l    %01100011011101110111111101101011
                dc.l    %01101011011000110110001100000000  ; M
                dc.l    %01100011011100110111101101111111
                dc.l    %01101111011001110110001100000000  ; N
                dc.l    %00111110011000110110001101100011
                dc.l    %01100011011000110011111000000000  ; O
                dc.l    %01111110011000110110001101111110
                dc.l    %01100000011000000110000000000000  ; P
                dc.l    %00111110011000110110001101100011
                dc.l    %01101111011000110011111100000000  ; Q
                dc.l    %01111110011000110110001101111110
                dc.l    %01101000011001100110011100000000  ; R
                dc.l    %00111110011000110111000000111110
                dc.l    %00000111011000110011111000000000  ; S
                dc.l    %01111110000110000001100000011000
                dc.l    %00011000000110000001100000000000  ; T
                dc.l    %01100110011001100110011001100110
                dc.l    %01100110011001100011110000000000  ; U
                dc.l    %01100011011000110110001100110110
                dc.l    %00110110000111000001110000000000  ; V
                dc.l    %01101011011010110110101101101011
                dc.l    %01101011011111110011011000000000  ; W
                dc.l    %01100011011000110011011000011100
                dc.l    %00110110011000110110001100000000  ; X
                dc.l    %01100110011001100110011000111100
                dc.l    %00011000000110000001100000000000  ; Y
                dc.l    %01111111000001110000111000011100
                dc.l    %00111000011100000111111100000000  ; Z
EndCheckVDP:
; ---------------------------------------------------------------------------
Test_Checksum:
                move.w  (VDP_control_port).l,d1
                btst    #1,d1
                bne.s   Test_Checksum
                btst    #6,(HW_Expansion_Control).l
                beq.s   loc_6BC
                cmpi.l  #Ref_Checksum_String,(Checksum_string).w
                beq.w   Test_Checksum_Done

loc_6BC:
                movea.l #ErrorTrap,a0
                movea.l #ROMEndLoc,a1
                move.l  (a1),d0
                moveq   #0,d1

ChecksumLoop:
                add.w   (a0)+,d1
                cmp.l   a0,d0
                if      0
                bcc.w   ChecksumLoop
                else
                nop
                nop
                endif
                movea.l #Checksum,a1
                cmp.w   (a1),d1
                if      0
                bne.w   ChecksumError
                else
                nop
                nop
                endif
                lea     (CrossResetRAM).w,a6
                moveq   #0,d7
                move.w  #bytesToLcnt(CrossResetRAM_End-CrossResetRAM),d6

loc_6EA:
                move.l  d7,(a6)+
                dbf     d6,loc_6EA                      ; clear RAM from $FFFE00 to $FFFFFF
                move.b  (HW_Version).l,d0
                andi.b  #$C0,d0
                move.b  d0,(Graphics_flags).w
                move.l  #Ref_Checksum_String,(Checksum_string).w

Test_Checksum_Done:
                bsr.w   DetectPAL
                lea     (RAM_start&$FFFFFF).l,a6
                moveq   #0,d7
                move.w  #bytesToLcnt(CrossResetRAM-RAM_start),d6

loc_716:
                move.l  d7,(a6)+
                dbf     d6,loc_716
                bsr.w   Init_VDP
                bsr.w   SndDrvInit
                bsr.w   Init_Controllers
                jsr     (SRAM_Load).l
                move.b  #GameMode_SegaScreen,(Game_mode).w

GameLoop:
                move.b  (Game_mode).w,d0
                andi.w  #$7C,d0
                movea.l GameModes(pc,d0.w),a0
                jsr     (a0)
                bra.s   GameLoop
; ---------------------------------------------------------------------------
GameModes:

gmptr:          macro   gamemode,{INTLABEL}
__LABEL__:      label   *-GameModes
                    dc.l    gamemode
                endm

GameMode_SegaScreen:                gmptr   Sega_Screen  ; 0
GameMode_TitleScreen:               gmptr   Title_Screen  ; 4
GameMode_Demo:                      gmptr   Level       ; 8
GameMode_Level:                     gmptr   Level       ; $C
GameMode_SpecialStage_S2:           gmptr   JumpToSegaScreen  ; $10
GameMode_Continue:                  gmptr   ContinueScreen  ; $14
GameMode_2PResults_S2:              gmptr   JumpToSegaScreen  ; $18
GameMode_2PLevelSelect:             gmptr   LevelSelect_S2Options  ; $1C
GameMode_S3Credits:                 gmptr   S3Credits   ; $20
GameMode_OptionsMenu:               gmptr   LevelSelect_S2Options  ; $24
GameMode_LevelSelect:               gmptr   LevelSelect_S2Options  ; $28
GameMode_SpecialStage:              gmptr   SpecialStage  ; $2C
GameMode_SpecialStage2:             gmptr   SpecialStage  ; $30
GameMode_SpecialStage3:             gmptr   SpecialStage  ; $34
GameMode_CompetitionMenu:           gmptr   Competition_Menu  ; $38
GameMode_CompetitionPlayerSelect:   gmptr   Competition_PlayerSelect  ; $3C
GameMode_CompetitionLevelSelect:    gmptr   Competition_LevelSelect  ; $40
GameMode_CompetitionResults:        gmptr   Competition_Results  ; $44
GameMode_SpecialStageResults:       gmptr   SpecialStage_Results  ; $48
GameMode_SaveScreen:                gmptr   SaveScreen  ; $4C
GameMode_TimeAttackRecords:         gmptr   TimeAttack_Records  ; $50
; ---------------------------------------------------------------------------

JumpToSegaScreen:
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------
; unused/dead code
; weird routine, makes the screen go haywire pretty much

ChecksumError2:
                move.l  d1,-(sp)
                bsr.w   Init_VDP
                move.l  (sp)+,d1

ChecksumError2_Loop:
                move.l  #vdpComm($0000,CRAM,WRITE),(VDP_control_port).l
                move.w  d7,(VDP_data_port).l
                addq.w  #1,d7
                bra.s   ChecksumError2_Loop
; ---------------------------------------------------------------------------
; unused/dead code

ChecksumError:
                move.l  #vdpComm($0000,CRAM,WRITE),(VDP_control_port).l
                moveq   #bytesToWcnt($80),d7

                .loop:
                move.w  #$E,(VDP_data_port).l
                dbf     d7,.loop                        ; fill entire CRAM with red

ChecksumError_Loop:
                bra.s   ChecksumError_Loop

; =============== S U B R O U T I N E =======================================

DetectPAL:
                lea     (VDP_control_port).l,a5
                move.w  #$8174,(a5)                     ; VDP Command $8174 - Display on, VInt on, DMA on, PAL off
                moveq   #0,d0

                .waitForVBlankStart:
                move.w  (a5),d1
                andi.w  #8,d1
                beq.s   .waitForVBlankStart

                .waitForVBlankEnd:
                move.w  (a5),d1
                andi.w  #8,d1
                bne.s   .waitForVBlankEnd               ; Wait for VBlank to run once

                .waitForNextVBlank:
                addq.w  #1,d0
                move.w  (a5),d1
                andi.w  #8,d1
                beq.s   .waitForNextVBlank
                move.w  d0,(V_blank_cycles).w           ; Count cycles between VBlanks (likely to detect PAL systems and/or for other timing mechanisms
                rts
; End of function DetectPAL
