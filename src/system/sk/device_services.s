; Owner: system/sk; responsibility: device services
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Init_Controllers:
                stopZ80
                moveq   #$40,d0
                move.b  d0,(HW_Port_1_Control).l
                move.b  d0,(HW_Port_2_Control).l
                move.b  d0,(HW_Expansion_Control).l
                startZ80
                rts
; End of function Init_Controllers

; =============== S U B R O U T I N E =======================================

Poll_Controllers:
                lea     (Ctrl_1).w,a0
                lea     (HW_Port_1_Data).l,a1
                bsr.s   Poll_Controller                 ; poll first controller
                addq.w  #2,a1                           ; poll second controller
; End of function Poll_Controllers

; =============== S U B R O U T I N E =======================================

Poll_Controller:
                move.b  #0,(a1)                         ; Poll controller data port
                nop
                nop
                move.b  (a1),d0                         ; Get controller port data (start/A)
                lsl.b   #2,d0
                andi.b  #$C0,d0
                move.b  #$40,(a1)                       ; Poll controller data port again
                nop
                nop
                move.b  (a1),d1                         ; Get controller port data (B/C/Dpad)
                andi.b  #$3F,d1
                or.b    d1,d0                           ; Fuse together into one controller bit array
                not.b   d0
                move.b  (a0),d1                         ; Get press button data
                eor.b   d0,d1                           ; Toggle off buttons that are being held
                move.b  d0,(a0)+                        ; Put raw controller input (for held buttons) in F604/F606
                and.b   d0,d1
                move.b  d1,(a0)+                        ; Put pressed controller input in F605/F607
                rts
; End of function Poll_Controller

; =============== S U B R O U T I N E =======================================

Init_VDP:
                lea     (VDP_control_port).l,a0
                lea     (VDP_data_port).l,a1
                lea     (VDP_register_values).l,a2
                moveq   #19-1,d7

                .setRegisters:
                move.w  (a2)+,(a0)
                dbf     d7,.setRegisters
                move.w  (VDP_register_values+2).l,d0    ; get command for register #1
                move.w  d0,(VDP_reg_1_command).w        ; and store it in RAM (for easy display blanking/enabling)
                move.w  #$8A00+224-1,(H_int_counter_command).w
                moveq   #0,d0
                move.l  #vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
                move.w  d0,(a1)
                move.w  d0,(a1)
                move.l  #vdpComm($0000,CRAM,WRITE),(VDP_control_port).l
                move.w  #bytesToWcnt($80),d7

                .clearCRAM:
                move.w  d0,(a1)
                dbf     d7,.clearCRAM
                clr.l   (V_scroll_value).w
                clr.l   (_unkF61A).w
                move.l  d1,-(sp)
                dmaFillVRAM 0,$0000,$10000              ; clear entire VRAM
                move.l  (sp)+,d1
                rts
; End of function Init_VDP

; ---------------------------------------------------------------------------
VDP_register_values:
                dc.w    $8004                           ; H-int disabled
                dc.w    $8134                           ; V-int enabled, display blanked, DMA enabled, 224 line display
                dc.w    $8230                           ; Scroll A PNT base $C000
                dc.w    $8320                           ; Window PNT base $8000
                dc.w    $8407                           ; Scroll B PNT base $E000
                dc.w    $857C                           ; Sprite attribute table base $F800
                dc.w    $8600
                dc.w    $8700                           ; Backdrop color is color 0 of the first palette line
                dc.w    $8800
                dc.w    $8900
                dc.w    $8A00
                dc.w    $8B00                           ; Full-screen horizontal and vertical scrolling
                dc.w    $8C81                           ; 40 cell wide display, no interlace
                dc.w    $8D3C                           ; Horizontal scroll table base $F000
                dc.w    $8E00
                dc.w    $8F02                           ; Auto-increment is 2
                dc.w    $9001                           ; Scroll planes are 64x32 cells
                dc.w    $9100
                dc.w    $9200                           ; Window disabled

; =============== S U B R O U T I N E =======================================

Clear_DisplayData:
                stopZ80
                dmaFillVRAM 0,$0000,$40

                tst.w   (Competition_mode).w
                beq.s   Clear_DisplayData_No2P
                dmaFillVRAM 0,$8000,$4000
                bra.s   Clear_DisplayData_Cont
; ---------------------------------------------------------------------------

Clear_DisplayData_No2P:
                dmaFillVRAM 0,$C000,$1000               ; clear plane A PNT
                dmaFillVRAM 0,$E000,$1000               ; clear plane B PNT

Clear_DisplayData_Cont:
                clr.l   (V_scroll_value).w
                clr.l   (_unkF61A).w
; Bug: this should be (Sprite_table_End-Sprite_table)
                clearRAM Sprite_table,(Sprite_table_end-Sprite_table)+4
; Bug: this should be (Collision_response_list_End-H_scroll_buffer)
                clearRAM H_scroll_buffer,(Collision_response_list_end-H_scroll_buffer)+4

                startZ80
                rts
; End of function Clear_DisplayData

; =============== S U B R O U T I N E =======================================

SndDrvInit:
                nop
                move.w  #$100,(Z80_bus_request).l
                move.w  #$100,(Z80_reset).l             ; release Z80 reset

; Load SMPS sound driver
                lea     (Z80_SoundDriver).l,a0
                lea     (Z80_RAM).l,a1
                bsr.w   Kos_Decomp
; Load sound driver data (PSG envelopes, music/sound pointers, FM voice bank)
                lea     (Z80_SoundDriverData).l,a0
                lea     (Z80_RAM+z80_SoundDriverPointers).l,a1
                bsr.w   Kos_Decomp
; Load default variables
                lea     (Z80_DefaultVariables).l,a0
                lea     (Z80_RAM+zDataStart).l,a1
                move.w  #Z80_DefaultVariables_end-Z80_DefaultVariables-1,d0

                -:
                move.b  (a0)+,(a1)+
                dbf     d0,-
; Detect PAL region consoles
                btst    #6,(Graphics_flags).w
                beq.s   +
                move.b  #1,(Z80_RAM+zPalFlag).l

                +:
                move.w  #0,(Z80_reset).l                ; reset Z80
                nop
                nop
                nop
                nop
                move.w  #$100,(Z80_reset).l             ; release reset
                startZ80
                rts
; End of function SndDrvInit

; ---------------------------------------------------------------------------
; Default Z80 variables. These are actually set to more meaningful values
; in other SMPS Z80 drivers
; ---------------------------------------------------------------------------
Z80_DefaultVariables:
                dc.b    0                               ; Unused 1
                dc.b    0                               ; Unused 2
                dc.b    0                               ; zPalFlag
                dc.b    0                               ; Unused 3
                dc.b    0                               ; zPalDblUpdCounter
                dc.b    0                               ; zSoundQueue0
                dc.b    0                               ; zSoundQueue1
                dc.b    0                               ; zSoundQueue2
                dc.b    0                               ; zTempoSpeedup
                dc.b    0                               ; zNextSound
                dc.b    0                               ; zMusicNumber
                dc.b    0                               ; zSFXNumber0
                dc.b    0                               ; zSFXNumber1
                dc.b    0                               ; zFadeOutTimeout
                dc.b    0                               ; zFadeDelay
                dc.b    0                               ; zFadeDelayTimeout
Z80_DefaultVariables_end:

; ---------------------------------------------------------------------------
; Always replaces an index previous passed to this function
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Play_Music:
                stopZ80
                move.b  d0,(Z80_RAM+zMusicNumber).l
                startZ80
                rts
; End of function Play_Music

; ---------------------------------------------------------------------------
; plays a sound if the source object is on-screen
; unused/dead code, left over from Sonic 2

Play_SFX_Local:
                tst.b   render_flags(a0)
                bpl.s   Play_SFX_Done

; ---------------------------------------------------------------------------
; Can handle up to two different indexes in one frame
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Play_SFX:
                stopZ80
                cmp.b   (Z80_RAM+zSFXNumber0).l,d0
                beq.s   ++
                tst.b   (Z80_RAM+zSFXNumber0).l
                bne.s   +
                move.b  d0,(Z80_RAM+zSFXNumber0).l
                startZ80
                rts

                +:
                move.b  d0,(Z80_RAM+zSFXNumber1).l

                +:
                startZ80

Play_SFX_Done:
                rts
; End of function Play_SFX

; =============== S U B R O U T I N E =======================================

Change_Music_Tempo:
                stopZ80
                move.b  d0,(Z80_RAM+zTempoSpeedup).l
                startZ80
                rts
; End of function Change_Music_Tempo
