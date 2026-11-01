; Owner: game/blue_sphere/sk
; Responsibility: Blue Sphere menu input, stage selection, stage-number widgets and numeric encoding helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SpheresTitle_4CEAA:
                tst.b   (Blue_spheres_menu_flag).w
                bne.s   loc_4CEF8
                move.l  #loc_4CEB6,(a0)

loc_4CEB6:
; Bug: no idea what this was meant to be
                tst.b   (Vectors).w
                bne.s   locret_4CEC6
                move.b  (Ctrl_1).w,d0
                cmpi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   loc_4CEC8

locret_4CEC6:
                rts
; ---------------------------------------------------------------------------

loc_4CEC8:
                clr.b   (Ctrl_1_pressed).w
                moveq   #-1,d0
                move.w  d0,(Special_stage_spheres_left).w
                move.w  d0,(Special_stage_rings_left).w
                moveq   #signextendB(sfx_Starpost),d0
                jsr     (Play_SFX).l
                move    #$2700,sr
                lea     aGetBlueSpheres(pc),a1
                move.w  #$100,d2
                move.w  #make_art_tile(ArtTile_BlueSphere_TitleText,0,0),d6
                jsr     (SKCreditsBuildAndUploadVariableWidthTwoRowText).l
                move    #$2300,sr

loc_4CEF8:
                move.l  #loc_4CF82,(a0)
                move.l  #Obj_SpheresTitle_4D03E,(Dynamic_object_RAM+(object_size*3)).w
                move.w  #$C0,(Dynamic_object_RAM+(object_size*3)+y_pos).w
                move.b  #1,(Blue_spheres_menu_flag).w
                move.b  #0,(Blue_spheres_option).w
                move.l  #Obj_SpheresTitle_4D64E,(Dynamic_object_RAM+(object_size*43)).w
                move.l  #Obj_SpheresTitle_4D64E,(Dynamic_object_RAM+(object_size*44)).w
                bset    #0,(Dynamic_object_RAM+(object_size*44)+render_flags).w
                tst.b   (Blue_spheres_mode).w
                beq.s   loc_4CF66
                move.w  #$B0,(Dynamic_object_RAM+(object_size*3)+y_pos).w
                move.l  #Obj_SpheresTitle_4D2F4,(Dynamic_object_RAM+(object_size*15)).w
                move.w  #$144,(Dynamic_object_RAM+(object_size*15)+y_pos).w
                move.l  #Obj_SpheresTitle_4D302,(Dynamic_object_RAM+(object_size*28)).w
                move.w  #$144,(Dynamic_object_RAM+(object_size*28)+y_pos).w
                move.l  #Obj_SpheresTitle_4D610,(Dynamic_object_RAM+(object_size*42)).w
                move.b  #1,(Blue_spheres_option).w
                rts
; ---------------------------------------------------------------------------

loc_4CF66:
                tst.w   (Special_stage_spheres_left).w
                bne.s   locret_4CF80
                tst.w   (Special_stage_rings_left).w
                bne.s   locret_4CF80
                move.l  #Obj_SpheresTitle_4D302,(Dynamic_object_RAM+(object_size*28)).w
                move.w  #$144,(Dynamic_object_RAM+(object_size*28)+y_pos).w

locret_4CF80:
                rts
; ---------------------------------------------------------------------------

loc_4CF82:
                tst.b   (Blue_spheres_mode).w
                beq.w   loc_4D008
                tst.w   (V_scroll_value).w
                beq.s   loc_4CFB2
                addq.w  #1,(V_scroll_value).w
                btst    #0,(V_scroll_value_FG+1).w
                bne.s   loc_4CFA0
                addq.w  #1,(V_scroll_value_BG).w

loc_4CFA0:
                lea     (Reserved_object_3).w,a1
                moveq   #4-1,d1

loc_4CFA6:
                subq.w  #1,y_pos(a1)
                lea     next_object(a1),a1
                dbf     d1,loc_4CFA6

loc_4CFB2:
                tst.b   (Blue_spheres_menu_flag).w
                bmi.s   loc_4D000
                move.b  (Ctrl_1_pressed).w,d1
                btst    #0,d1
                beq.s   loc_4CFD4
                tst.b   (Blue_spheres_option).w
                beq.s   loc_4CFD4
                subq.b  #1,(Blue_spheres_option).w
                moveq   #signextendB(sfx_WeatherMachine),d0
                jsr     (Play_SFX).l

loc_4CFD4:
                btst    #1,d1
                beq.s   loc_4D000
                cmpi.b  #2,(Blue_spheres_option).w
                bhs.s   loc_4D000
                addq.b  #1,(Blue_spheres_option).w
                moveq   #signextendB(sfx_WeatherMachine),d0
                jsr     (Play_SFX).l
                cmpi.b  #2,(Blue_spheres_option).w
                bne.s   loc_4D000
                ori.b   #$80,(Blue_spheres_menu_flag).w
                clr.b   (Ctrl_1_pressed).w

loc_4D000:
                cmpi.b  #1,(Blue_spheres_option).w
                bne.s   locret_4D03C

loc_4D008:
                move.b  (Ctrl_1_pressed).w,d0
                cmpi.b  #button_start_mask,d0
                bne.s   locret_4D03C
                move.b  #0,(Special_bonus_entry_flag).w
                move.b  #1,(Blue_spheres_stage_flag).w
                move.w  (Player_option).w,(Player_mode).w
                move.b  #3,(Life_count).w
                move.b  #0,(SK_special_stage_flag).w
                move.b  #0,(Current_special_stage).w
                move.b  #GameMode_SpecialStage,(Game_mode).w

locret_4D03C:
                rts
; ---------------------------------------------------------------------------

Obj_SpheresTitle_4D03E:
                move.l  #Map_BlueSpheresText,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc,0,1),art_tile(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$80,priority(a0)
                move.b  #$14,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  y_pos(a0),d3
                addi.w  #$10,d3
                movea.l a0,a1
                move.b  #$A,next_object+mapping_frame(a1)
                move.w  #$F7,d2
                moveq   #$B-1,d1

loc_4D07A:
                lea     next_object(a1),a1
                move.l  #loc_4D5B4,(a1)
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                addq.w  #8,d2
                dbf     d1,loc_4D07A
                move.b  #$B,mapping_frame(a1)
                move.l  #loc_4D09E,(a0)

loc_4D09E:
                tst.b   (Blue_spheres_mode).w
                beq.s   loc_4D0B0
                tst.b   (Blue_spheres_option).w
                bne.s   loc_4D0D4
                tst.b   (Blue_spheres_progress_flag).w
                bne.s   loc_4D0DA

loc_4D0B0:
                move.l  (Blue_spheres_current_stage).w,d1
                lsl.b   #1,d1
                lsl.w   #1,d1
                swap    d1
                lsl.b   #1,d1
                lsr.w   #1,d1
                swap    d1
                lsr.l   #2,d1
                andi.l  #$FFFFFFF,d1
                bsr.w   BlueSphereSetFixedWidthNineDigitWidget
                move.b  #1,mapping_frame(a0)
                bra.s   loc_4D0F0
; ---------------------------------------------------------------------------

loc_4D0D4:
                tst.b   (Blue_spheres_progress_flag).w
                bne.s   loc_4D0B0

loc_4D0DA:
                move.l  (Blue_spheres_current_level).w,d1
                addq.l  #1,d1
                andi.l  #$7FFFFFF,d1
                bsr.w   BlueSphereSetCenteredSuppressedNineDigitWidget
                move.b  #0,mapping_frame(a0)

loc_4D0F0:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

BlueSphereSetFixedWidthNineDigitWidget:
                andi.l  #$FFFFFFF,d1
                movea.l a0,a1
                lea     next_object(a1),a1
                lea     dword_4D21C(pc),a2
                moveq   #8,d6

loc_4D108:
                lea     next_object(a1),a1
                moveq   #0,d2
                move.l  (a2)+,d3

loc_4D110:
                sub.l   d3,d1
                bcs.s   loc_4D118
                addq.w  #1,d2
                bra.s   loc_4D110
; ---------------------------------------------------------------------------

loc_4D118:
                add.l   d3,d1
                move.b  d2,mapping_frame(a1)
                dbf     d6,loc_4D108
                move.w  #$F7,d2
                moveq   #$A,d1
                movea.l a0,a1

loc_4D12A:
                lea     next_object(a1),a1
                move.w  d2,x_pos(a1)
                addq.w  #8,d2
                dbf     d1,loc_4D12A
                rts
; End of function BlueSphereSetFixedWidthNineDigitWidget

; =============== S U B R O U T I N E =======================================

BlueSphereSetCenteredSuppressedNineDigitWidget:
                andi.l  #$7FFFFFF,d1
                movea.l a0,a1
                lea     next_object(a1),a1
                lea     dword_4D21C(pc),a2
                moveq   #8,d6
                moveq   #0,d4

loc_4D14E:
                lea     next_object(a1),a1
                moveq   #0,d2
                move.l  (a2)+,d3

loc_4D156:
                sub.l   d3,d1
                bcs.s   loc_4D15E
                addq.w  #1,d2
                bra.s   loc_4D156
; ---------------------------------------------------------------------------

loc_4D15E:
                add.l   d3,d1
                tst.w   d2
                beq.s   loc_4D16C
                tst.w   d4
                bne.s   loc_4D16C
                move.w  d6,d4
                addq.w  #1,d4

loc_4D16C:
                tst.w   d4
                bne.s   loc_4D172
                moveq   #$A,d2

loc_4D172:
                move.b  d2,mapping_frame(a1)
                dbf     d6,loc_4D14E
                move.w  #$F7,d2
                move.w  d4,d0
                subi.w  #9,d0
                neg.w   d0
                move.w  d0,d1
                lsl.w   #2,d0
                add.w   d0,d2
                movea.l a0,a1

loc_4D18E:
                lea     next_object(a1),a1
                move.w  d2,x_pos(a1)
                dbf     d1,loc_4D18E

loc_4D19A:
                lea     next_object(a1),a1
                addq.w  #8,d2
                move.w  d2,x_pos(a1)
                dbf     d4,loc_4D19A
                rts
; End of function BlueSphereSetCenteredSuppressedNineDigitWidget

; =============== S U B R O U T I N E =======================================

BlueSphereSetCenteredTwoDigitDifficultyWidget:
                andi.l  #$FF,d1
                movea.l a0,a1
                lea     next_object(a1),a1
                lea     dword_4D238(pc),a2
                moveq   #1,d6
                moveq   #0,d4

loc_4D1BE:
                lea     next_object(a1),a1
                moveq   #0,d2
                move.l  (a2)+,d3

loc_4D1C6:
                sub.l   d3,d1
                bcs.s   loc_4D1CE
                addq.w  #1,d2
                bra.s   loc_4D1C6
; ---------------------------------------------------------------------------

loc_4D1CE:
                add.l   d3,d1
                tst.w   d2
                beq.s   loc_4D1DC
                tst.w   d4
                bne.s   loc_4D1DC
                move.w  d6,d4
                addq.w  #1,d4

loc_4D1DC:
                tst.w   d4
                bne.s   loc_4D1E2
                moveq   #$A,d2

loc_4D1E2:
                move.b  d2,$22(a1)
                dbf     d6,loc_4D1BE
                move.w  #$113,d2
                move.w  d4,d0
                subq.w  #2,d0
                neg.w   d0
                move.w  d0,d1
                lsl.w   #2,d0
                add.w   d0,d2
                movea.l a0,a1

loc_4D1FC:
                lea     next_object(a1),a1
                move.w  d2,x_pos(a1)
                dbf     d1,loc_4D1FC

loc_4D208:
                lea     next_object(a1),a1
                addq.w  #8,d2
                move.w  d2,x_pos(a1)
                dbf     d4,loc_4D208
                rts
; End of function BlueSphereSetCenteredTwoDigitDifficultyWidget

; ---------------------------------------------------------------------------
                dc.l    1000000000
dword_4D21C:    dc.l    100000000
                dc.l    10000000
                dc.l    1000000
                dc.l    100000
                dc.l    10000
                dc.l    1000
                dc.l    100
dword_4D238:    dc.l    10
                dc.l    1
; ---------------------------------------------------------------------------

loc_4D240:
                moveq   #$C-1,d6
                lea     word_4D294(pc),a2

loc_4D246:
                lea     next_object(a1),a1
                moveq   #0,d4
                move.w  (a2)+,d2
                move.l  (a2)+,d3

loc_4D250:
                sub.l   d3,d1
                subx.w  d2,d0
                bcs.s   loc_4D25A
                addq.w  #1,d4
                bra.s   loc_4D250
; ---------------------------------------------------------------------------

loc_4D25A:
                add.l   d3,d1
                addx.w  d2,d0
                move.b  d4,mapping_frame(a1)
                dbf     d6,loc_4D246
                rts
; ---------------------------------------------------------------------------

loc_4D268:
                movea.l a0,a1
                moveq   #0,d0
                moveq   #0,d1
                moveq   #$C-1,d6
                lea     word_4D294(pc),a2

loc_4D274:
                lea     next_object(a1),a1
                moveq   #0,d4
                move.b  mapping_frame(a1),d4
                move.w  (a2)+,d2
                move.l  (a2)+,d3
                subq.w  #1,d4
                bcs.s   loc_4D28E

loc_4D286:
                add.l   d3,d1
                addx.w  d2,d0
                dbf     d4,loc_4D286

loc_4D28E:
                dbf     d6,loc_4D274
                rts
; ---------------------------------------------------------------------------
word_4D294:
                dc.w    $17
                dc.l    $4876E800
                dc.w    2
                dc.l    $540BE400
                dc.w    0
                dc.l    1000000000
                dc.w    0
                dc.l    100000000
                dc.w    0
                dc.l    10000000
                dc.w    0
                dc.l    1000000
                dc.w    0
                dc.l    100000
                dc.w    0
                dc.l    10000
                dc.w    0
                dc.l    1000
                dc.w    0
                dc.l    100
                dc.w    0
                dc.l    10
                dc.w    0
                dc.l    1
