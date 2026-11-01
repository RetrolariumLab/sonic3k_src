; Owner: game/blue_sphere/sk
; Responsibility: Blue Sphere level and serial-code entry widgets, digit state and conversion helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
word_4D2DC:
                dc.w    $10C
                dc.w    $114
                dc.w    $11C
                dc.w    $124
                dc.w    $134
                dc.w    $13C
                dc.w    $144
                dc.w    $14C
                dc.w    $15C
                dc.w    $164
                dc.w    $16C
                dc.w    $174
; ---------------------------------------------------------------------------

Obj_SpheresTitle_4D2F4:
                move.l  #loc_4D3CE,(a0)
                move.l  #loc_4D5FA,d2
                bra.s   loc_4D30E
; ---------------------------------------------------------------------------

Obj_SpheresTitle_4D302:
                move.l  #loc_4D362,(a0)
                move.l  #loc_4D5E4,d2

loc_4D30E:
                move.l  #Map_BlueSpheresText,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc,0,1),art_tile(a0)
                move.w  #$D4,x_pos(a0)
                move.w  #$80,priority(a0)
                move.b  #$14,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #2,mapping_frame(a0)
                lea     word_4D2DC(pc),a2
                movea.l a0,a1
                moveq   #$C-1,d1

loc_4D342:
                lea     next_object(a1),a1
                move.l  d2,(a1)
                move.w  (a2)+,x_pos(a1)
                subi.w  #$C,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                dbf     d1,loc_4D342
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4D362:
                tst.b   (Blue_spheres_menu_flag).w
                bpl.s   loc_4D36A
                rts
; ---------------------------------------------------------------------------

loc_4D36A:
                lea     (Stat_table).w,a2
                move.l  (Blue_spheres_current_level).w,(a2)
                tst.b   (Blue_spheres_progress_flag).w
                beq.s   loc_4D37E
                addi.l  #$7654321,(a2)

loc_4D37E:
                andi.l  #$7FFFFFF,(a2)
                moveq   #1,d6
                bsr.w   BlueSphereComputeWordXorSingleShiftCheckValue
                move.w  d4,d0
                andi.w  #$3F,d0
                tst.b   (Blue_spheres_progress_flag).w
                beq.s   loc_4D39A
                ori.w   #$40,d0

loc_4D39A:
                eori.w  #$55,d0
                move.l  (Blue_spheres_current_level).w,d1
                addi.l  #$1234567,d1
                andi.l  #$7FFFFFF,d1
                swap    d1
                lsl.w   #5,d4
                andi.w  #$F800,d4
                or.w    d4,d1
                swap    d1
                ror.l   #6,d1
                eori.l  #$AAAAAAAA,d1
                movea.l a0,a1
                bsr.w   loc_4D240
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4D3CE:
                tst.b   (Blue_spheres_menu_flag).w
                bmi.s   loc_4D3DC
                move.w  #0,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_4D3DC:
                move.b  (Ctrl_1_pressed).w,d0
                cmpi.b  #button_start_mask,d0
                bne.s   loc_4D3EA
                bsr.w   BlueSphereValidateEnteredCodeAndRestoreLevelStageSelection

loc_4D3EA:
                movea.l a0,a1
                move.w  $30(a0),d0
                addq.w  #1,d0
                mulu.w  #object_size,d0
                adda.w  d0,a1
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc,0,1),art_tile(a1)
                move.b  (Ctrl_1_pressed).w,d1
                btst    #button_up,d1
                beq.s   loc_4D414
                subq.b  #1,mapping_frame(a1)
                bcc.s   loc_4D414
                move.b  #9,mapping_frame(a1)

loc_4D414:
                btst    #1,d1
                beq.s   loc_4D42C
                addq.b  #1,mapping_frame(a1)
                cmpi.b  #$A,mapping_frame(a1)
                blo.s   loc_4D42C
                move.b  #0,mapping_frame(a1)

loc_4D42C:
                btst    #2,d1
                beq.s   loc_4D43E
                subq.w  #1,$30(a0)
                bcc.s   loc_4D43E
                move.w  #$B,$30(a0)

loc_4D43E:
                btst    #3,d1
                beq.s   loc_4D456
                addq.w  #1,$30(a0)
                cmpi.w  #$C,$30(a0)
                blo.s   loc_4D456
                move.w  #0,$30(a0)

loc_4D456:
                tst.b   (Blue_spheres_menu_flag).w
                bpl.s   loc_4D470
                movea.l a0,a1
                move.w  $30(a0),d0
                addq.w  #1,d0
                mulu.w  #object_size,d0
                adda.w  d0,a1
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc+$14,0,1),art_tile(a1)

loc_4D470:
                move.b  (Ctrl_1_pressed).w,d1
                andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask,d1
                beq.s   loc_4D482
                moveq   #signextendB(sfx_WeatherMachine),d0
                jsr     (Play_SFX).l

loc_4D482:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

BlueSphereValidateEnteredCodeAndRestoreLevelStageSelection:
                bsr.w   loc_4D268
                eori.w  #$55,d0
                move.w  d0,d2
                andi.w  #$3F,d0
                eori.l  #$AAAAAAAA,d1
                rol.l   #6,d1
                swap    d1
                move.w  d1,d3
                andi.w  #$F800,d3
                lsr.w   #5,d3
                or.w    d0,d3
                andi.w  #$7FF,d3
                swap    d1
                subi.l  #$1234567,d1
                andi.w  #$40,d2
                beq.s   loc_4D4C2
                addi.l  #$7654321,d1

loc_4D4C2:
                andi.l  #$7FFFFFF,d1
                move.l  d1,(Stat_table).w
                lea     (Stat_table).w,a2
                moveq   #1,d6
                bsr.w   BlueSphereComputeWordXorSingleShiftCheckValue
                andi.w  #$7FF,d4
                cmp.w   d4,d3
                bne.w   loc_4D58A
                move.b  #0,(Blue_spheres_progress_flag).w
                tst.w   d2
                beq.s   loc_4D4FC
                subi.l  #$7654321,d1
                andi.l  #$7FFFFFF,d1
                move.b  #-1,(Blue_spheres_progress_flag).w

loc_4D4FC:
                move.l  d1,(Blue_spheres_current_level).w
                lea     (Blue_spheres_current_stage).w,a2
                move.l  d1,d0
                andi.b  #$7F,d0
                move.b  d0,(a2)+
                move.l  d1,d0
                add.l   d0,d0
                add.l   d1,d0
                addq.l  #1,d0
                moveq   #0,d2
                swap    d0
                move.w  d0,d2
                swap    d0
                divu.w  #$7F,d2
                move.w  d0,d2
                divu.w  #$7F,d2
                swap    d2
                move.b  d2,(a2)+
                move.l  d1,d0
                add.l   d0,d0
                add.l   d0,d0
                add.l   d1,d0
                addq.l  #2,d0
                moveq   #0,d2
                swap    d0
                move.w  d0,d2
                swap    d0
                divu.w  #$7E,d2
                move.w  d0,d2
                divu.w  #$7E,d2
                swap    d2
                move.b  d2,(a2)+
                move.l  d1,d0
                add.l   d0,d0
                add.l   d1,d0
                add.l   d0,d0
                add.l   d1,d0
                addq.l  #3,d0
                moveq   #0,d2
                swap    d0
                move.w  d0,d2
                swap    d0
                divu.w  #$7D,d2
                move.w  d0,d2
                divu.w  #$7D,d2
                swap    d2
                move.b  d2,(a2)+
                lea     (Normal_palette).w,a2
                bsr.w   BlueSphereCopyProgressSelectedFullPalette
                moveq   #signextendB(sfx_Starpost),d0
                jsr     (Play_SFX).l
                andi.b  #$7F,(Blue_spheres_menu_flag).w
                move.b  #1,(Blue_spheres_option).w
                rts
; ---------------------------------------------------------------------------

loc_4D58A:
                moveq   #signextendB(sfx_Error),d0
                jsr     (Play_SFX).l
                andi.b  #$7F,(Blue_spheres_menu_flag).w
                move.b  #1,(Blue_spheres_option).w
                rts
; End of function BlueSphereValidateEnteredCodeAndRestoreLevelStageSelection

; =============== S U B R O U T I N E =======================================

BlueSphereComputeWordXorSingleShiftCheckValue:
                moveq   #0,d4

loc_4D5A2:
                move.w  (a2)+,d5
                eor.w   d5,d4
                lsr.w   #1,d4
                bcc.s   loc_4D5AE
                eori.w  #$8810,d4

loc_4D5AE:
                dbf     d6,loc_4D5A2
                rts
; End of function BlueSphereComputeWordXorSingleShiftCheckValue

; ---------------------------------------------------------------------------

loc_4D5B4:
                bsr.s   BlueSphereInitializeNumericSpriteMappingsArtAndBounds
                move.l  #loc_4D5BC,(a0)

loc_4D5BC:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

BlueSphereInitializeNumericSpriteMappingsArtAndBounds:
                move.l  #Map_BlueSpheresNum,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc,0,1),art_tile(a0)
                move.w  #$80,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                rts
; End of function BlueSphereInitializeNumericSpriteMappingsArtAndBounds

; ---------------------------------------------------------------------------

loc_4D5E4:
                bsr.s   BlueSphereInitializeNumericSpriteMappingsArtAndBounds
                move.l  #loc_4D5EC,(a0)

loc_4D5EC:
                tst.b   (Blue_spheres_menu_flag).w
                bpl.s   loc_4D5F4
                rts
; ---------------------------------------------------------------------------

loc_4D5F4:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4D5FA:
                bsr.s   BlueSphereInitializeNumericSpriteMappingsArtAndBounds
                move.l  #loc_4D602,(a0)

loc_4D602:
                tst.b   (Blue_spheres_menu_flag).w
                bmi.s   loc_4D60A
                rts
; ---------------------------------------------------------------------------

loc_4D60A:
                jmp     (Draw_Sprite).l
; End of function loc_4D5FA
