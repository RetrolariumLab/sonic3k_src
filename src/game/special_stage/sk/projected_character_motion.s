; Owner: game/special_stage/sk
; Responsibility: Projected tail and shadow rendering, scalar setup, stage motion and layout-space response
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SStage_9444:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$100,priority(a0)
                move.l  #Map_SStageTailstails,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Player2_Tail,1,1),art_tile(a0)
                move.w  #$A0,$30(a0)
                move.w  #$70,$32(a0)
                move.b  #-1,$3A(a0)
                move.b  #1,mapping_frame(a0)
                move.l  #loc_9488,(a0)

loc_9488:
                movea.w $3E(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.w  #$2AAA,d0
                move.w  (Special_stage_velocity).w,d1
                bmi.s   loc_94A4
                add.w   d1,d0

loc_94A4:
                add.w   d0,anim_frame_timer(a0)
                bcc.s   loc_94BC
                move.b  mapping_frame(a0),d0
                addq.b  #1,d0
                cmpi.b  #$F,d0
                blo.s   loc_94B8
                moveq   #1,d0

loc_94B8:
                move.b  d0,mapping_frame(a0)

loc_94BC:
                jsr     (Draw_Sprite).l
                lea     (PLC_SStageTailstails).l,a2
                move.l  #ArtUnc_SStageTailstails,d6
                move.w  #tiles_to_bytes(ArtTile_SStage_Player2_Tail),d4
                bra.w   SStage_PLCLoad_91A2

; =============== S U B R O U T I N E =======================================

Draw_SSShadows:
                lea     (word_94FC).l,a3
                move.w  (a3)+,(a6)+
                move.b  (a3)+,(a6)+
                addq.w  #1,a3
                addq.w  #1,a6
                move.w  (a3)+,(a6)+
                move.w  (a3)+,(a6)+
                tst.w   (Player_mode).w
                bne.s   locret_94FA
                move.w  (a3)+,(a6)+
                move.b  (a3)+,(a6)+
                addq.w  #1,a3
                addq.w  #1,a6
                move.w  (a3)+,(a6)+
                move.w  (a3)+,(a6)+

locret_94FA:
                rts
; End of function Draw_SSShadows

; ---------------------------------------------------------------------------
word_94FC:
                dc.w    $116, $F0A, make_art_tile(ArtTile_SStage_Shadow,3,1), $110
                dc.w    $127, $F0B, make_art_tile(ArtTile_SStage_Shadow,3,1), $110

; =============== S U B R O U T I N E =======================================

; Refresh the four Q14 sine and cosine pairs used for character projection
SStage_UpdateProjectionScalars:
                move.w  (SStage_scalar_index_2).w,d0
                lea     (SStage_scalar_result_2).w,a1
                bsr.w   GetScalars2
                move.w  (SStage_scalar_index_1).w,d0
                lea     (SStage_scalar_result_1).w,a1
                bsr.w   GetScalars2
                move.w  (SStage_scalar_index_0).w,d0
                lea     (SStage_scalar_result_0).w,a1
                bsr.w   GetScalars2
                move.w  #$E0,d0
                lea     (SStage_scalar_result_3).w,a1
                bsr.w   GetScalars2
                rts
; End of function SStage_UpdateProjectionScalars

; =============== S U B R O U T I N E =======================================

SStage_ProjectCharacterCoordinates:
                move.w  $34(a0),d1
                move.w  $36(a0),d2
                move.w  $38(a0),d0
                bsr.w   SStage_RotateDepthHeight
                bsr.w   SStage_RotateDepthHorizontal
                bsr.w   SStage_RotateHorizontalVertical
                addi.w  #$100,d0
                addi.w  #$980,d2
                bsr.w   SStage_ApplyProjectionViewTilt
                ext.l   d1
                lsl.l   #8,d1
                divs.w  d0,d1
                ext.l   d2
                lsl.l   #8,d2
                divs.w  d0,d2
                add.w   $30(a0),d1
                move.w  d1,x_pos(a0)
                add.w   $32(a0),d2
                move.w  d2,y_pos(a0)
                rts
; End of function SStage_ProjectCharacterCoordinates

; =============== S U B R O U T I N E =======================================

SStage_UpdatePlayerGridMotion:
                tst.b   (Special_stage_fade_timer).w
                beq.s   loc_95AE
                cmpi.b  #$61,(Special_stage_fade_timer).w
                bhs.s   loc_959A
                moveq   #8,d1
                add.b   d1,(Special_stage_angle).w
                addq.b  #1,(Special_stage_fade_timer).w
                rts
; ---------------------------------------------------------------------------

loc_959A:
                move.w  (Special_stage_X_pos).w,d0
                or.w    (Special_stage_Y_pos).w,d0
                andi.w  #$E0,d0
                beq.s   loc_95AE
                move.b  #0,(Special_stage_fade_timer).w

loc_95AE:
                move.w  (Special_stage_X_pos).w,d3
                btst    #6,(Special_stage_angle).w
                bne.s   loc_95BE
                move.w  (Special_stage_Y_pos).w,d3

loc_95BE:
                moveq   #0,d2
                move.b  (Special_stage_turning).w,d1
                beq.s   loc_95F4
                andi.w  #$E0,d3
                bne.s   loc_95F4
                tst.b   (Special_stage_jumping).w
                bmi.s   loc_9600
                add.b   d1,(Special_stage_angle).w
                move.b  (Special_stage_angle).w,d0
                andi.b  #$3F,d0
                bne.w   locret_972C
                move.b  #0,(Special_stage_turning).w
                tst.w   (Special_stage_velocity).w
                beq.s   loc_95F4
                move.b  #1,(Special_stage_turn_lock).w

loc_95F4:
                andi.w  #$E0,d3
                beq.s   loc_9600
                move.b  #0,(Special_stage_turn_lock).w

loc_9600:
                move.b  (Ctrl_1).w,d1
                move.w  (Special_stage_velocity).w,d2
                tst.b   (Special_stage_clear_routine).w
                bne.w   loc_96FA
                tst.b   (Special_stage_bumper_lock).w
                bne.s   loc_9658
                btst    #button_up,d1
                beq.s   loc_9628
                move.b  #1,(Special_stage_advancing).w
                move.b  #1,(Special_stage_started).w

loc_9628:
                tst.b   (Special_stage_advancing).w
                bne.s   loc_964A
                tst.b   (Special_stage_started).w
                beq.s   loc_9658
                tst.w   d2
                bpl.s   loc_964A
                move.w  (Special_stage_rate).w,d3
                neg.w   d3
                subi.w  #$200,d2
                cmp.w   d3,d2
                bgt.s   loc_9658
                move.w  d3,d2
                bra.s   loc_9658
; ---------------------------------------------------------------------------

loc_964A:
                move.w  (Special_stage_rate).w,d3
                addi.w  #$200,d2
                cmp.w   d3,d2
                blt.s   loc_9658
                move.w  d3,d2

loc_9658:
                tst.b   (Special_stage_turn_lock).w
                bne.s   loc_9676
                btst    #button_left,d1
                beq.s   loc_966A
                move.b  #4,(Special_stage_turning).w

loc_966A:
                btst    #button_right,d1
                beq.s   loc_9676
                move.b  #-4,(Special_stage_turning).w

loc_9676:
                move.w  d2,(Special_stage_velocity).w
                tst.b   (Special_stage_bumper_lock).w
                beq.s   loc_96FA
                move.w  (Special_stage_X_pos).w,d0
                btst    #6,(Special_stage_angle).w
                bne.s   loc_9690
                move.w  (Special_stage_Y_pos).w,d0

loc_9690:
                andi.w  #$E0,d0
                bne.s   loc_96D4
                move.w  (Special_stage_X_pos).w,d0
                addi.w  #$80,d0
                lsr.w   #8,d0
                andi.w  #$1F,d0
                move.w  (Special_stage_Y_pos).w,d1
                addi.w  #$80,d1
                lsr.w   #8,d1
                andi.w  #$1F,d1
                lsl.w   #5,d1
                or.b    d0,d1
                cmp.w   (Special_stage_interact).w,d1
                beq.s   loc_96D4
                move.b  #0,(Special_stage_bumper_lock).w
                move.w  (Special_stage_rate).w,d2
                tst.w   (Special_stage_velocity).w
                bmi.s   loc_96CE
                neg.w   d2

loc_96CE:
                move.w  d2,(Special_stage_velocity).w
                rts
; ---------------------------------------------------------------------------

loc_96D4:
                move.w  (Special_stage_velocity).w,d2
                bne.s   loc_96F8
                move.b  #0,(Special_stage_bumper_lock).w
                move.b  #1,(Special_stage_advancing).w
                move.w  (Special_stage_rate).w,d2
                tst.w   (Special_stage_velocity).w
                bmi.s   loc_96F2
                neg.w   d2

loc_96F2:
                move.w  d2,(Special_stage_velocity).w
                bra.s   loc_96FA
; ---------------------------------------------------------------------------

loc_96F8:
                neg.w   d2

loc_96FA:
                cmpi.b  #$81,(Special_stage_jumping).w
                bne.s   loc_9704
                add.w   d2,d2

loc_9704:
                move.b  (Special_stage_angle).w,d0
                jsr     (GetSineCosine).l
                muls.w  d2,d0
                muls.w  d2,d1
                swap    d0
                sub.w   d0,(Special_stage_X_pos).w
                swap    d1
                sub.w   d1,(Special_stage_Y_pos).w
                tst.b   (Special_stage_jumping).w
                bmi.s   locret_972C
                tst.b   (Special_stage_clear_routine).w
                bne.s   locret_972C
                bsr.s   SStage_HandlePlayerGridCell

locret_972C:
                rts
; End of function SStage_UpdatePlayerGridMotion

; =============== S U B R O U T I N E =======================================

SStage_HandlePlayerGridCell:
                lea     (SStage_layout_buffer+$100).w,a1
                move.w  (Special_stage_X_pos).w,d0
                addi.w  #$80,d0
                lsr.w   #8,d0
                andi.w  #$1F,d0
                move.w  (Special_stage_Y_pos).w,d1
                addi.w  #$80,d1
                lsr.w   #8,d1
                andi.w  #$1F,d1
                lsl.w   #5,d1
                or.b    d0,d1
                lea     (a1,d1.w),a1
                move.b  (a1),d2
                beq.w   locret_98AE
                cmpi.b  #1,d2
                bne.s   loc_97AA
                move.w  (Special_stage_X_pos).w,d0
                or.w    (Special_stage_Y_pos).w,d0
                andi.w  #$E0,d0
                bne.s   locret_97A8
                tst.b   (Special_stage_fade_timer).w
                bne.s   locret_97A8
                move.b  #1,(Special_stage_fade_timer).w
                move.b  #GameMode_SpecialStageResults,(Game_mode).w
                tst.b   (Blue_spheres_stage_flag).w
                beq.s   loc_978E
                move.b  #GameMode_BlueSpheresTitle,(Game_mode).w

loc_978E:
                tst.b   (Special_bonus_entry_flag).w
                beq.s   loc_97A0
                move.w  (Saved2_zone_and_act).w,(Current_zone_and_act).w
                ori.b   #$80,(Last_star_post_hit).w

loc_97A0:
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

locret_97A8:
                rts
; ---------------------------------------------------------------------------

loc_97AA:
                cmpi.b  #2,d2
                bne.s   loc_97C8
                bsr.w   Find_SStageCollisionResponseSlot
                bne.s   loc_97BE
                move.b  #2,(a2)
                move.l  a1,4(a2)

loc_97BE:
                moveq   #signextendB(sfx_BlueSphere),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_97C8:
                cmpi.b  #3,d2
                bne.s   loc_97EE
                tst.b   (Special_stage_bumper_lock).w
                bne.s   loc_97EE
                move.w  d1,(Special_stage_interact).w
                move.b  #1,(Special_stage_bumper_lock).w
                move.b  #0,(Special_stage_advancing).w
                moveq   #signextendB(sfx_Bumper),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_97EE:
                cmpi.b  #5,d2
                bne.s   loc_9822
                tst.b   (Special_stage_clear_routine).w
                bne.s   loc_9822
                tst.b   (Special_stage_jumping).w
                bmi.s   loc_9822
                move.b  (Special_stage_angle).w,d0
                andi.b  #$3F,d0
                bne.w   loc_9822
                move.l  #$FFE80000,$40(a0)
                move.b  #$81,(Special_stage_jumping).w
                moveq   #signextendB(sfx_Spring),d0
                jsr     (Play_SFX).l

loc_9822:
                cmpi.b  #4,d2
                bne.w   locret_98AE
                bsr.w   Find_SStageCollisionResponseSlot
                bne.s   loc_9838
                move.b  #1,(a2)
                move.l  a1,4(a2)

loc_9838:
                tst.w   (Special_stage_rings_left).w
                beq.s   loc_984C
                subq.w  #1,(Special_stage_rings_left).w
                bne.s   loc_984C
                moveq   #signextendB(sfx_Perfect),d0
                jsr     (Play_Music).l

loc_984C:
                addi.w  #1,(Special_stage_ring_count).w
                bset    #7,(Special_stage_extra_life_flags).w
                moveq   #signextendB(sfx_RingRight),d0
                tst.b   (Blue_spheres_stage_flag).w
                bne.s   loc_98A6
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.s   loc_987E
                bset    #0,(Special_stage_extra_life_flags).w
                bne.s   loc_987E
                addq.b  #1,(Continue_count).w
                move.w  #signextendB(sfx_Continue),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

loc_987E:
                moveq   #signextendB(sfx_RingRight),d0
                cmpi.w  #100,(Special_stage_ring_count).w
                blo.s   loc_98A6
                bset    #1,(Special_stage_extra_life_flags).w
                beq.s   loc_98A0
                cmpi.w  #200,(Special_stage_ring_count).w
                blo.s   loc_98A6
                bset    #2,(Special_stage_extra_life_flags).w
                bne.s   loc_98A6

loc_98A0:
                addq.b  #1,(Life_count).w
                moveq   #signextendB(sfx_RingLoss),d0

loc_98A6:
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

locret_98AE:
                rts
; End of function SStage_HandlePlayerGridCell
