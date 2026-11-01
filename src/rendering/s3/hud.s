; Owner: rendering/s3
; Responsibility: One and two player HUD drawing, score, rings, time, lives and numeric glyph output
; Source provenance and ranges: config/reconstruction/source_layout.json
Render_HUD_P1:
                tst.w   (Debug_mode_flag).w
                bne.s   Render_HUD
                rts
; End of function Render_HUD_P1

; =============== S U B R O U T I N E =======================================

Render_HUD:
                cmpi.b  #$13,(Current_zone).w
                blo.s   loc_E8E4
                moveq   #8,d4
                btst    #3,(Level_frame_counter+1).w
                bne.s   loc_E900
                tst.w   (Ring_count).w
                bne.s   loc_E900
                addq.w  #2,d4
                bra.s   loc_E900
; ---------------------------------------------------------------------------

loc_E8E4:
                moveq   #0,d4
                btst    #3,(Level_frame_counter+1).w
                bne.s   loc_E900
                tst.w   (Ring_count).w
                bne.s   loc_E8F6
                addq.w  #2,d4

loc_E8F6:
                cmpi.b  #9,(Timer_minute).w
                bne.s   loc_E900
                addq.w  #4,d4

loc_E900:
                move.b  (Level_started_flag).w,d0
                ext.w   d0
                bpl.s   loc_E90E
                addq.w  #8,d0
                move.b  d0,(Level_started_flag).w

loc_E90E:
                addi.w  #$8F,d0
                move.w  #$108,d1
                move.w  #make_art_tile(ArtTile_Ring+$E,0,1),d5
                lea     Map_HUD(pc),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   locret_E92E
                jmp     (RenderMappingPieces).l
; ---------------------------------------------------------------------------

locret_E92E:
                rts
; End of function Render_HUD

; =============== S U B R O U T I N E =======================================

Render_HUD_P2:
                rts
; End of function Render_HUD_P2

; ---------------------------------------------------------------------------
Map_HUD:
                include "src/objects/shared/hud_icon/mappings/hud.s"

; =============== S U B R O U T I N E =======================================

HUD_AddToScore:
                move.b  #1,(Update_HUD_score).w
                lea     (Score).w,a3
                add.l   d0,(a3)                         ; Add to score
                move.l  #999999,d1                      ; 9999990 maximum points
                cmp.l   (a3),d1
                bhi.s   .jump
                move.l  d1,(a3)

                .jump:
                move.l  (a3),d0
                cmp.l   (Next_extra_life_score).w,d0    ; If score is greater than next 50000 point increment
                blo.s   .end
                addi.l  #5000,(Next_extra_life_score).w
                addq.b  #1,(Life_count).w               ; Give an additional extra life
                addq.b  #1,(Update_HUD_life_count).w
                move.w  #mus_ExtraLife,d0               ; Play the 1up song
                jmp     (Play_Music).l

                .end:
                rts
; End of function HUD_AddToScore

; =============== S U B R O U T I N E =======================================

UpdateHUD:
                nop
                lea     (VDP_data_port).l,a6
                tst.w   (Competition_mode).w
                bne.w   loc_EBF2
                tst.w   (Debug_mode_flag).w
                bne.w   loc_EB68
                tst.b   (Update_HUD_score).w
                beq.s   loc_EAB2
                clr.b   (Update_HUD_score).w
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$28),VRAM,WRITE),d0
                move.l  (Score).w,d1
                bsr.w   DrawSixDigitNumber

loc_EAB2:
                tst.b   (Update_HUD_ring_count).w
                beq.s   loc_EAD2
                bpl.s   loc_EABE
                bsr.w   HUD_DrawZeroRings

loc_EABE:
                clr.b   (Update_HUD_ring_count).w
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3E),VRAM,WRITE),d0
                moveq   #0,d1
                move.w  (Ring_count).w,d1
                bsr.w   DrawThreeDigitNumber

loc_EAD2:
                tst.b   (Update_HUD_timer).w
                bpl.s   loc_EAE0
                move.b  #1,(Update_HUD_timer).w
                bra.s   loc_EB1A
; ---------------------------------------------------------------------------

loc_EAE0:
                beq.s   loc_EB3A
                tst.w   (Game_paused).w
                bne.s   loc_EB3A
                lea     (Timer).w,a1
                cmpi.l  #(9<<16)|(59<<8)|59,(a1)+
                beq.w   UpdateHUD_TimeOver
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   loc_EB3A
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   loc_EB1A
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #9,(a1)
                blo.s   loc_EB1A
                move.b  #9,(a1)

loc_EB1A:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$36),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Timer_minute).w,d1
                bsr.w   DrawSingleDigitNumber
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3A),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Timer_second).w,d1
                bsr.w   DrawTwoDigitNumber

loc_EB3A:
                tst.b   (Update_HUD_life_count).w
                beq.s   locret_EB48
                clr.b   (Update_HUD_life_count).w
                bsr.w   HUD_Lives

locret_EB48:
                rts
; ---------------------------------------------------------------------------

UpdateHUD_TimeOver:
                clr.b   (Update_HUD_timer).w
                lea     (Player_1).w,a0
                cmpi.b  #6,routine(a0)
                bhs.s   loc_EB60
                movea.l a0,a2
                bsr.w   Kill_Character

loc_EB60:
                move.b  #1,(Time_over_flag).w
                rts
; ---------------------------------------------------------------------------

loc_EB68:
                bsr.w   HUD_Debug
                tst.b   (Update_HUD_ring_count).w
                beq.s   loc_EB8C
                bpl.s   loc_EB78
                bsr.w   HUD_DrawZeroRings

loc_EB78:
                clr.b   (Update_HUD_ring_count).w
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3E),VRAM,WRITE),d0
                moveq   #0,d1
                move.w  (Ring_count).w,d1
                bsr.w   DrawThreeDigitNumber

loc_EB8C:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$36),VRAM,WRITE),d0
                moveq   #0,d1
                move.w  (Lag_frame_count).w,d1
                bsr.w   DrawSingleDigitNumber
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3A),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Sprites_drawn).w,d1
                bsr.w   DrawTwoDigitNumber
                tst.b   (Update_HUD_life_count).w
                beq.s   loc_EBBA
                clr.b   (Update_HUD_life_count).w
                bsr.w   HUD_Lives

loc_EBBA:
                tst.w   (Game_paused).w
                bne.s   locret_EBF0
                lea     (Timer).w,a1
                cmpi.l  #(9<<16)|(59<<8)|59,(a1)+
                nop
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   locret_EBF0
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   locret_EBF0
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #9,(a1)
                blo.s   locret_EBF0
                move.b  #9,(a1)

locret_EBF0:
                rts
; ---------------------------------------------------------------------------

loc_EBF2:
                tst.w   (Debug_mode_flag).w
                bne.w   HUD_Debug
                rts
; End of function UpdateHUD

; =============== S U B R O U T I N E =======================================

HUD_DrawZeroRings:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3E),VRAM,WRITE),(VDP_control_port).l
                lea     HUD_Zero_Rings(pc),a2
                move.w  #3-1,d2
                bra.s   loc_EC32
; End of function HUD_DrawZeroRings

; =============== S U B R O U T I N E =======================================

HUD_DrawInitial:
                lea     (VDP_data_port).l,a6
                bsr.w   HUD_Lives
                tst.w   (Competition_mode).w
                bne.s   locret_EC5E
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$26),VRAM,WRITE),(VDP_control_port).l
                lea     HUD_Initial_Parts(pc),a2
                move.w  #$F-1,d2

loc_EC32:
                lea     ArtUnc_HUDDigits(pc),a1

loc_EC36:
                move.w  #$10-1,d1
                move.b  (a2)+,d0
                bmi.s   loc_EC52
                ext.w   d0
                lsl.w   #5,d0
                lea     (a1,d0.w),a3

loc_EC46:
                move.l  (a3)+,(a6)
                dbf     d1,loc_EC46

loc_EC4C:
                dbf     d2,loc_EC36
                rts
; ---------------------------------------------------------------------------

loc_EC52:
                move.l  #0,(a6)
                dbf     d1,loc_EC52
                bra.s   loc_EC4C
; ---------------------------------------------------------------------------

locret_EC5E:
                rts
; End of function HUD_DrawInitial

; ---------------------------------------------------------------------------
                charset ' ',$FF
                charset '0',0
                charset '1',2
                charset '2',4
                charset '3',6
                charset '4',8
                charset '5',$A
                charset '6',$C
                charset '7',$E
                charset '8',$10
                charset '9',$12
                charset ':',$14
                charset 'E',$16

HUD_Initial_Parts:
                dc.b    "E      0"
                dc.b    "0:00"
HUD_Zero_Rings:
                dc.b    "  0"                           ; (zero rings)

                charset
                even

; =============== S U B R O U T I N E =======================================

HUD_Debug:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$26),VRAM,WRITE),(VDP_control_port).l
                move.w  (Camera_X_pos).w,d1
                swap    d1
                move.w  (Player_1+x_pos).w,d1
                bsr.s   HUD_WriteDebugCoordinatePair
                move.w  (Camera_Y_pos).w,d1
                swap    d1
                move.w  (Player_1+y_pos).w,d1
; End of function HUD_Debug

; =============== S U B R O U T I N E =======================================

HUD_WriteDebugCoordinatePair:
                moveq   #8-1,d6
                lea     (ArtUnc_DebugDigits).l,a1

loc_EC98:
                rol.w   #4,d1
                move.w  d1,d2
                andi.w  #$F,d2
                cmpi.w  #$A,d2
                blo.s   loc_ECAA
                addi.w  #7,d2

loc_ECAA:
                lsl.w   #5,d2
                lea     (a1,d2.w),a3
                rept    8
                move.l  (a3)+,(a6)
                endm
                swap    d1
                dbf     d6,loc_EC98
                rts
; End of function HUD_WriteDebugCoordinatePair

; =============== S U B R O U T I N E =======================================

DrawThreeDigitNumber:
                lea     (dword_ED94).l,a2
                moveq   #3-1,d6
                bra.s   loc_ECDA
; End of function DrawThreeDigitNumber

; =============== S U B R O U T I N E =======================================

DrawSixDigitNumber:
                lea     (dword_ED88).l,a2
                moveq   #6-1,d6

loc_ECDA:
                moveq   #0,d4
                lea     ArtUnc_HUDDigits(pc),a1

loc_ECE0:
                moveq   #0,d2
                move.l  (a2)+,d3

loc_ECE4:
                sub.l   d3,d1
                bcs.s   loc_ECEC
                addq.w  #1,d2
                bra.s   loc_ECE4
; ---------------------------------------------------------------------------

loc_ECEC:
                add.l   d3,d1
                tst.w   d2
                beq.s   loc_ECF6
                move.w  #1,d4

loc_ECF6:
                tst.w   d4
                beq.s   loc_ED24
                lsl.w   #6,d2
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm

loc_ED24:
                addi.l  #$40<<16,d0
                dbf     d6,loc_ECE0
                rts
; End of function DrawSixDigitNumber

; ---------------------------------------------------------------------------
; unused leftover from Sonic 2
; ContScrCounter:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$40),VRAM,WRITE),(VDP_control_port).l
                lea     (VDP_data_port).l,a6
                lea     (dword_ED98).l,a2
                moveq   #2-1,d6
                moveq   #0,d4
                lea     ArtUnc_HUDDigits(pc),a1

loc_ED4E:
                moveq   #0,d2
                move.l  (a2)+,d3

loc_ED52:
                sub.l   d3,d1
                bcs.s   loc_ED5A
                addq.w  #1,d2
                bra.s   loc_ED52
; ---------------------------------------------------------------------------

loc_ED5A:
                add.l   d3,d1
                lsl.w   #6,d2
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm
                dbf     d6,loc_ED4E
                rts
; ---------------------------------------------------------------------------
dword_ED88:     dc.l    100000
                dc.l    10000
dword_ED90:     dc.l    1000
dword_ED94:     dc.l    100
dword_ED98:     dc.l    10
dword_ED9C:     dc.l    1

; =============== S U B R O U T I N E =======================================

DrawSingleDigitNumber:
                lea     (dword_ED9C).l,a2
                moveq   #1-1,d6
                bra.s   loc_EDB2
; End of function DrawSingleDigitNumber

; =============== S U B R O U T I N E =======================================

DrawTwoDigitNumber:
                lea     (dword_ED98).l,a2
                moveq   #2-1,d6

loc_EDB2:
                moveq   #0,d4
                lea     ArtUnc_HUDDigits(pc),a1

loc_EDB8:
                moveq   #0,d2
                move.l  (a2)+,d3

loc_EDBC:
                sub.l   d3,d1
                bcs.s   loc_EDC4
                addq.w  #1,d2
                bra.s   loc_EDBC
; ---------------------------------------------------------------------------

loc_EDC4:
                add.l   d3,d1
                tst.w   d2
                beq.s   loc_EDCE
                move.w  #1,d4

loc_EDCE:
                lsl.w   #6,d2
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm
                addi.l  #$40<<16,d0
                dbf     d6,loc_EDB8
                rts
; End of function DrawTwoDigitNumber

; ---------------------------------------------------------------------------
; unused leftover from Sonic 2
; Hud_TimeRingBonus:
                lea     (dword_ED90).l,a2
                moveq   #4-1,d6
                moveq   #0,d4
                lea     ArtUnc_HUDDigits(pc),a1

loc_EE12:
                moveq   #0,d2
                move.l  (a2)+,d3

loc_EE16:
                sub.l   d3,d1
                bcs.s   loc_EE1E
                addq.w  #1,d2
                bra.s   loc_EE16
; ---------------------------------------------------------------------------

loc_EE1E:
                add.l   d3,d1
                tst.w   d2
                beq.s   loc_EE28
                move.w  #1,d4

loc_EE28:
                tst.w   d4
                beq.s   loc_EE58
                lsl.w   #6,d2
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm

loc_EE52:
                dbf     d6,loc_EE12
                rts
; ---------------------------------------------------------------------------

loc_EE58:
                moveq   #$10-1,d5

loc_EE5A:
                move.l  #0,(a6)
                dbf     d5,loc_EE5A
                bra.s   loc_EE52

; =============== S U B R O U T I N E =======================================

HUD_Lives:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_PlayerLifeIcon+9),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Life_count).w,d1
                lea     (dword_ED98).l,a2
                moveq   #2-1,d6
                moveq   #0,d4
                lea     ArtUnc_LivesDigits(pc),a1

loc_EE80:
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                moveq   #0,d2
                move.l  (a2)+,d3

loc_EE88:
                sub.l   d3,d1
                bcs.s   loc_EE90
                addq.w  #1,d2
                bra.s   loc_EE88
; ---------------------------------------------------------------------------

loc_EE90:
                add.l   d3,d1
                tst.w   d2
                beq.s   loc_EE9A
                move.w  #1,d4

loc_EE9A:
                tst.w   d4
                beq.s   loc_EEC0

loc_EE9E:
                lsl.w   #5,d2
                lea     (a1,d2.w),a3
                rept    8
                move.l  (a3)+,(a6)
                endm

loc_EEB4:
                addi.l  #$40<<16,d0
                dbf     d6,loc_EE80
                rts
; ---------------------------------------------------------------------------

loc_EEC0:
                tst.w   d6
                beq.s   loc_EE9E
                moveq   #8-1,d5

loc_EEC6:
                move.l  #0,(a6)
                dbf     d5,loc_EEC6
                bra.s   loc_EEB4
; End of function HUD_Lives

; ---------------------------------------------------------------------------
