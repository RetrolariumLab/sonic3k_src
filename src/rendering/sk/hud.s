; Owner: rendering/sk
; Responsibility: One and two player HUD drawing, score, rings, time, lives and numeric glyph output
; Source provenance and ranges: config/reconstruction/source_layout.json
Render_HUD_P1:
                tst.w   (Debug_mode_flag).w
                bne.s   Render_HUD
                rts
; End of function Render_HUD_P1

; =============== S U B R O U T I N E =======================================

Render_HUD:
                cmpi.b  #$16,(Current_zone).w
                bhs.s   loc_DB68
                cmpi.b  #$13,(Current_zone).w
                blo.s   loc_DB68
                moveq   #8,d4
                btst    #3,(Level_frame_counter+1).w
                bne.s   loc_DB84
                tst.w   (Ring_count).w
                bne.s   loc_DB84
                addq.w  #2,d4
                bra.s   loc_DB84
; ---------------------------------------------------------------------------

loc_DB68:
                moveq   #0,d4
                btst    #3,(Level_frame_counter+1).w
                bne.s   loc_DB84
                tst.w   (Ring_count).w
                bne.s   loc_DB7A
                addq.w  #2,d4

loc_DB7A:
                cmpi.b  #9,(Timer_minute).w
                bne.s   loc_DB84
                addq.w  #4,d4

loc_DB84:
                move.b  (Level_started_flag).w,d0
                ext.w   d0
                bpl.s   loc_DB92
                addq.w  #8,d0
                move.b  d0,(Level_started_flag).w

loc_DB92:
                addi.w  #$8F,d0
                move.w  #$108,d1
                move.w  #make_art_tile(ArtTile_Ring+$E,0,1),d5
                lea     Map_HUD(pc),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   locret_DBB2
                jmp     (RenderMappingPieces).l
; ---------------------------------------------------------------------------

locret_DBB2:
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
                bne.w   loc_DE7E
                tst.w   (Debug_placement_mode).w
                bne.w   loc_DDF4
                tst.b   (Update_HUD_score).w
                beq.s   loc_DD36
                clr.b   (Update_HUD_score).w
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$28),VRAM,WRITE),d0
                move.l  (Score).w,d1
                bsr.w   DrawSixDigitNumber

loc_DD36:
                tst.b   (Update_HUD_ring_count).w
                beq.s   loc_DD56
                bpl.s   loc_DD42
                bsr.w   HUD_DrawZeroRings

loc_DD42:
                clr.b   (Update_HUD_ring_count).w
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3E),VRAM,WRITE),d0
                moveq   #0,d1
                move.w  (Ring_count).w,d1
                bsr.w   DrawThreeDigitNumber

loc_DD56:
                tst.b   (Update_HUD_timer).w
                bpl.s   loc_DD64
                move.b  #1,(Update_HUD_timer).w
                bra.s   loc_DD9E
; ---------------------------------------------------------------------------

loc_DD64:
                beq.s   loc_DDBE
                tst.w   (Game_paused).w
                bne.s   loc_DDBE
                lea     (Timer).w,a1
                cmpi.l  #(9<<16)|(59<<8)|59,(a1)+
                beq.w   UpdateHUD_TimeOver
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   loc_DDBE
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   loc_DD9E
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #9,(a1)
                blo.s   loc_DD9E
                move.b  #9,(a1)

loc_DD9E:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$36),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Timer_minute).w,d1
                bsr.w   DrawSingleDigitNumber
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3A),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Timer_second).w,d1
                bsr.w   DrawTwoDigitNumber

loc_DDBE:
                tst.b   (Update_HUD_life_count).w
                beq.s   locret_DDCC
                clr.b   (Update_HUD_life_count).w
                bsr.w   HUD_Lives

locret_DDCC:
                rts
; ---------------------------------------------------------------------------

UpdateHUD_TimeOver:
                clr.b   (Update_HUD_timer).w
                lea     (Player_1).w,a0
                cmpi.b  #6,routine(a0)
                bhs.s   loc_DDEC
                cmpi.b  #$15,(Current_zone).w
                beq.s   loc_DDEC
                movea.l a0,a2
                bsr.w   Kill_Character

loc_DDEC:
                move.b  #1,(Time_over_flag).w
                rts
; ---------------------------------------------------------------------------

loc_DDF4:
                bsr.w   HUD_Debug
                tst.b   (Update_HUD_ring_count).w
                beq.s   loc_DE18
                bpl.s   loc_DE04
                bsr.w   HUD_DrawZeroRings

loc_DE04:
                clr.b   (Update_HUD_ring_count).w
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3E),VRAM,WRITE),d0
                moveq   #0,d1
                move.w  (Ring_count).w,d1
                bsr.w   DrawThreeDigitNumber

loc_DE18:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$36),VRAM,WRITE),d0
                moveq   #0,d1
                move.w  (Lag_frame_count).w,d1
                bsr.w   DrawSingleDigitNumber
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3A),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Sprites_drawn).w,d1
                bsr.w   DrawTwoDigitNumber
                tst.b   (Update_HUD_life_count).w
                beq.s   loc_DE46
                clr.b   (Update_HUD_life_count).w
                bsr.w   HUD_Lives

loc_DE46:
                tst.w   (Game_paused).w
                bne.s   locret_DE7C
                lea     (Timer).w,a1
                cmpi.l  #(9<<16)|(59<<8)|59,(a1)+
                nop
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   locret_DE7C
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   locret_DE7C
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #9,(a1)
                blo.s   locret_DE7C
                move.b  #9,(a1)

locret_DE7C:
                rts
; ---------------------------------------------------------------------------

loc_DE7E:
                tst.w   (Debug_mode_flag).w
                bne.w   HUD_Debug
                rts
; End of function UpdateHUD

; =============== S U B R O U T I N E =======================================

HUD_DrawZeroRings:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$3E),VRAM,WRITE),(VDP_control_port).l
                lea     HUD_Zero_Rings(pc),a2
                move.w  #3-1,d2
                bra.s   loc_DEBE
; End of function HUD_DrawZeroRings

; =============== S U B R O U T I N E =======================================

HUD_DrawInitial:
                lea     (VDP_data_port).l,a6
                bsr.w   HUD_Lives
                tst.w   (Competition_mode).w
                bne.s   locret_DEEA
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$26),VRAM,WRITE),(VDP_control_port).l
                lea     HUD_Initial_Parts(pc),a2
                move.w  #$F-1,d2

loc_DEBE:
                lea     ArtUnc_HUDDigits(pc),a1

loc_DEC2:
                move.w  #$10-1,d1
                move.b  (a2)+,d0
                bmi.s   loc_DEDE
                ext.w   d0
                lsl.w   #5,d0
                lea     (a1,d0.w),a3

loc_DED2:
                move.l  (a3)+,(a6)
                dbf     d1,loc_DED2

loc_DED8:
                dbf     d2,loc_DEC2
                rts
; ---------------------------------------------------------------------------

loc_DEDE:
                move.l  #0,(a6)
                dbf     d1,loc_DEDE
                bra.s   loc_DED8
; ---------------------------------------------------------------------------

locret_DEEA:
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

loc_DF24:
                rol.w   #4,d1
                move.w  d1,d2
                andi.w  #$F,d2
                cmpi.w  #$A,d2
                blo.s   loc_DF36
                addi.w  #7,d2

loc_DF36:
                lsl.w   #5,d2
                lea     (a1,d2.w),a3
                rept    8
                move.l  (a3)+,(a6)
                endm
                swap    d1
                dbf     d6,loc_DF24
                rts
; End of function HUD_WriteDebugCoordinatePair

; ---------------------------------------------------------------------------
; unused
                lea     (Level_layout_header).w,a1
                move.w  (Player_1+x_pos).w,d3
                move.w  (Player_1+y_pos).w,d2
                move.w  d2,d0
                lsr.w   #5,d0
                and.w   (Layout_row_index_mask).w,d0
                move.w  8(a1,d0.w),d0
                move.w  d3,d1
                lsr.w   #3,d1
                move.w  d1,d4
                lsr.w   #4,d1
                add.w   d1,d0
                moveq   #-1,d1
                clr.w   d1
                movea.w d0,a1
                move.b  (a1),d1
                rts

; =============== S U B R O U T I N E =======================================

DrawThreeDigitNumber:
                lea     (dword_E04C).l,a2
                moveq   #3-1,d6
                bra.s   loc_DF92
; End of function DrawThreeDigitNumber

; =============== S U B R O U T I N E =======================================

DrawSixDigitNumber:
                lea     (dword_E040).l,a2
                moveq   #6-1,d6

loc_DF92:
                moveq   #0,d4
                lea     ArtUnc_HUDDigits(pc),a1

loc_DF98:
                moveq   #0,d2
                move.l  (a2)+,d3

loc_DF9C:
                sub.l   d3,d1
                bcs.s   loc_DFA4
                addq.w  #1,d2
                bra.s   loc_DF9C
; ---------------------------------------------------------------------------

loc_DFA4:
                add.l   d3,d1
                tst.w   d2
                beq.s   loc_DFAE
                move.w  #1,d4

loc_DFAE:
                tst.w   d4
                beq.s   loc_DFDC
                lsl.w   #6,d2
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm

loc_DFDC:
                addi.l  #$40<<16,d0
                dbf     d6,loc_DF98
                rts
; End of function DrawSixDigitNumber

; ---------------------------------------------------------------------------
; unused leftover from Sonic 2
; ContScrCounter:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ring+$40),VRAM,WRITE),(VDP_control_port).l
                lea     (VDP_data_port).l,a6
                lea     (dword_E050).l,a2
                moveq   #2-1,d6
                moveq   #0,d4
                lea     ArtUnc_HUDDigits(pc),a1

loc_E006:
                moveq   #0,d2
                move.l  (a2)+,d3

loc_E00A:
                sub.l   d3,d1
                bcs.s   loc_E012
                addq.w  #1,d2
                bra.s   loc_E00A
; ---------------------------------------------------------------------------

loc_E012:
                add.l   d3,d1
                lsl.w   #6,d2
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm
                dbf     d6,loc_E006
                rts
; ---------------------------------------------------------------------------
dword_E040:     dc.l    100000
                dc.l    10000
dword_E048:     dc.l    1000
dword_E04C:     dc.l    100
dword_E050:     dc.l    10
dword_E054:     dc.l    1

; =============== S U B R O U T I N E =======================================

DrawSingleDigitNumber:
                lea     (dword_E054).l,a2
                moveq   #1-1,d6
                bra.s   loc_E06A
; End of function DrawSingleDigitNumber

; =============== S U B R O U T I N E =======================================

DrawTwoDigitNumber:
                lea     (dword_E050).l,a2
                moveq   #2-1,d6

loc_E06A:
                moveq   #0,d4
                lea     ArtUnc_HUDDigits(pc),a1

loc_E070:
                moveq   #0,d2
                move.l  (a2)+,d3

loc_E074:
                sub.l   d3,d1
                bcs.s   loc_E07C
                addq.w  #1,d2
                bra.s   loc_E074
; ---------------------------------------------------------------------------

loc_E07C:
                add.l   d3,d1
                tst.w   d2
                beq.s   loc_E086
                move.w  #1,d4

loc_E086:
                lsl.w   #6,d2
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm
                addi.l  #$40<<16,d0
                dbf     d6,loc_E070
                rts
; End of function DrawTwoDigitNumber

; ---------------------------------------------------------------------------
; unused leftover from Sonic 2
; Hud_TimeRingBonus:
                lea     (dword_E048).l,a2
                moveq   #4-1,d6
                moveq   #0,d4
                lea     ArtUnc_HUDDigits(pc),a1

loc_E0CA:
                moveq   #0,d2
                move.l  (a2)+,d3

loc_E0CE:
                sub.l   d3,d1
                bcs.s   loc_E0D6
                addq.w  #1,d2
                bra.s   loc_E0CE
; ---------------------------------------------------------------------------

loc_E0D6:
                add.l   d3,d1
                tst.w   d2
                beq.s   loc_E0E0
                move.w  #1,d4

loc_E0E0:
                tst.w   d4
                beq.s   loc_E110
                lsl.w   #6,d2
                lea     (a1,d2.w),a3
                rept    16
                move.l  (a3)+,(a6)
                endm

loc_E10A:
                dbf     d6,loc_E0CA
                rts
; ---------------------------------------------------------------------------

loc_E110:
                moveq   #$10-1,d5

loc_E112:
                move.l  #0,(a6)
                dbf     d5,loc_E112
                bra.s   loc_E10A

; =============== S U B R O U T I N E =======================================

HUD_Lives:
                move.l  #vdpComm(tiles_to_bytes(ArtTile_PlayerLifeIcon+9),VRAM,WRITE),d0
                moveq   #0,d1
                move.b  (Life_count).w,d1
                lea     (dword_E050).l,a2
                moveq   #2-1,d6
                moveq   #0,d4
                lea     ArtUnc_LivesDigits(pc),a1

loc_E138:
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                moveq   #0,d2
                move.l  (a2)+,d3

loc_E140:
                sub.l   d3,d1
                bcs.s   loc_E148
                addq.w  #1,d2
                bra.s   loc_E140
; ---------------------------------------------------------------------------

loc_E148:
                add.l   d3,d1
                tst.w   d2
                beq.s   loc_E152
                move.w  #1,d4

loc_E152:
                tst.w   d4
                beq.s   loc_E178

loc_E156:
                lsl.w   #5,d2
                lea     (a1,d2.w),a3
                rept    8
                move.l  (a3)+,(a6)
                endm

loc_E16C:
                addi.l  #$40<<16,d0
                dbf     d6,loc_E138
                rts
; ---------------------------------------------------------------------------

loc_E178:
                tst.w   d6
                beq.s   loc_E156
                moveq   #8-1,d5

loc_E17E:
                move.l  #0,(a6)
                dbf     d5,loc_E17E
                bra.s   loc_E16C
; End of function HUD_Lives

; ---------------------------------------------------------------------------
