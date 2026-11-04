; Owner: game/special_stage/s3
; Responsibility: Projected tail and shadow rendering, scalar setup, stage motion and layout-space response
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SStage_82EE:
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
                move.l  #loc_8332,(a0)

loc_8332:
                movea.w $3E(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.w  #$2AAA,d0
                move.w  (Special_stage_velocity).w,d1
                bmi.s   loc_834E
                add.w   d1,d0

loc_834E:
                add.w   d0,anim_frame_timer(a0)
                bcc.s   loc_8366
                move.b  mapping_frame(a0),d0
                addq.b  #1,d0
                cmpi.b  #$F,d0
                blo.s   loc_8362
                moveq   #1,d0

loc_8362:
                move.b  d0,mapping_frame(a0)

loc_8366:
                jsr     (Draw_Sprite).l
                lea     (PLC_SStageTailstails).l,a2
                move.l  #ArtUnc_SStageTailstails,d6
                move.w  #tiles_to_bytes(ArtTile_SStage_Player2_Tail),d4
                bra.w   loc_80D8
; ---------------------------------------------------------------------------

Obj_SStage_8380:
                move.w  #0,$34(a0)
                move.w  #$F800,$36(a0)
                move.w  #0,$38(a0)

loc_8392:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$380,priority(a0)
                move.l  #Map_SStageShadow,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Shadow,3,1),art_tile(a0)
                move.w  #$A0,$30(a0)
                move.w  #$70,$32(a0)
                move.b  #-1,$3A(a0)
                bsr.w   SStage_ProjectCharacterCoordinates
                move.l  #loc_83D6,(a0)
                rts
; ---------------------------------------------------------------------------

loc_83D6:
                tst.b   (Special_stage_fade_timer).w
                beq.s   loc_83DE
                rts
; ---------------------------------------------------------------------------

loc_83DE:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_SStage_83E4:
                move.w  #0,$34(a0)
                move.w  #$F800,$36(a0)
                move.w  #$FFE0,$38(a0)
                bra.s   loc_8392
; ---------------------------------------------------------------------------
Map_SStageShadow:
                include "src/game/special_stage/shared/mappings/shadow.s"

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
                beq.s   loc_84A4
                cmpi.b  #$61,(Special_stage_fade_timer).w
                bhs.s   loc_8490
                moveq   #8,d1
                add.b   d1,(Special_stage_angle).w
                addq.b  #1,(Special_stage_fade_timer).w
                rts
; ---------------------------------------------------------------------------

loc_8490:
                move.w  (Special_stage_X_pos).w,d0
                or.w    (Special_stage_Y_pos).w,d0
                andi.w  #$E0,d0
                beq.s   loc_84A4
                move.b  #0,(Special_stage_fade_timer).w

loc_84A4:
                move.w  (Special_stage_X_pos).w,d3
                btst    #6,(Special_stage_angle).w
                bne.s   loc_84B4
                move.w  (Special_stage_Y_pos).w,d3

loc_84B4:
                moveq   #0,d2
                move.b  (Special_stage_turning).w,d1
                beq.s   loc_84F0
                andi.w  #$E0,d3
                bne.s   loc_84F0
                tst.b   (Special_stage_jumping).w
                bmi.s   loc_84FC
                add.b   d1,(Special_stage_angle).w
                move.b  (Special_stage_angle).w,d0
                andi.b  #$3F,d0
                bne.w   locret_85FC
                move.b  #0,(Special_stage_turning).w
                move.b  #0,(Special_stage_bumper_lock).w
                tst.w   (Special_stage_velocity).w
                beq.s   loc_84F0
                move.b  #1,(Special_stage_turn_lock).w

loc_84F0:
                andi.w  #$E0,d3
                beq.s   loc_84FC
                move.b  #0,(Special_stage_turn_lock).w

loc_84FC:
                move.b  (Ctrl_1_held).w,d1
                move.w  (Special_stage_velocity).w,d2
                tst.b   (Special_stage_clear_routine).w
                bne.w   loc_85D4
                tst.b   (Special_stage_bumper_lock).w
                bne.s   loc_8532
                btst    #button_up,d1
                beq.s   loc_851E
                move.b  #1,(Special_stage_advancing).w

loc_851E:
                tst.b   (Special_stage_advancing).w
                beq.s   loc_8532
                move.w  (Special_stage_rate).w,d3
                addi.w  #$200,d2
                cmp.w   d3,d2
                blt.s   loc_8532
                move.w  d3,d2

loc_8532:
                tst.b   (Special_stage_turn_lock).w
                bne.s   loc_8550
                btst    #button_left,d1
                beq.s   loc_8544
                move.b  #4,(Special_stage_turning).w

loc_8544:
                btst    #button_right,d1
                beq.s   loc_8550
                move.b  #-4,(Special_stage_turning).w

loc_8550:
                move.w  d2,(Special_stage_velocity).w
                tst.b   (Special_stage_bumper_lock).w
                beq.s   loc_85D4
                move.w  (Special_stage_X_pos).w,d0
                btst    #6,(Special_stage_angle).w
                bne.s   loc_856A
                move.w  (Special_stage_Y_pos).w,d0

loc_856A:
                andi.w  #$E0,d0
                bne.s   loc_85AE
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
                beq.s   loc_85AE
                move.b  #0,(Special_stage_bumper_lock).w
                move.w  (Special_stage_rate).w,d2
                tst.w   (Special_stage_velocity).w
                bmi.s   loc_85A8
                neg.w   d2

loc_85A8:
                move.w  d2,(Special_stage_velocity).w
                rts
; ---------------------------------------------------------------------------

loc_85AE:
                move.w  (Special_stage_velocity).w,d2
                bne.s   loc_85D2
                move.b  #0,(Special_stage_bumper_lock).w
                move.b  #1,(Special_stage_advancing).w
                move.w  (Special_stage_rate).w,d2
                tst.w   (Special_stage_velocity).w
                bmi.s   loc_85CC
                neg.w   d2

loc_85CC:
                move.w  d2,(Special_stage_velocity).w
                bra.s   loc_85D4
; ---------------------------------------------------------------------------

loc_85D2:
                neg.w   d2

loc_85D4:
                move.b  (Special_stage_angle).w,d0
                jsr     (GetSineCosine).l
                muls.w  d2,d0
                muls.w  d2,d1
                swap    d0
                sub.w   d0,(Special_stage_X_pos).w
                swap    d1
                sub.w   d1,(Special_stage_Y_pos).w
                tst.b   (Special_stage_jumping).w
                bmi.s   locret_85FC
                tst.b   (Special_stage_clear_routine).w
                bne.s   locret_85FC
                bsr.s   SStage_HandlePlayerGridCell

locret_85FC:
                rts
; End of function SStage_UpdatePlayerGridMotion

; =============== S U B R O U T I N E =======================================

SStage_HandlePlayerGridCell:
                lea     (Level_layout_header).w,a1
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
                beq.w   locret_872E
                cmpi.b  #1,d2
                bne.s   loc_866E
                move.w  (Special_stage_X_pos).w,d0
                or.w    (Special_stage_Y_pos).w,d0
                andi.w  #$E0,d0
                bne.s   locret_866C
                tst.b   (Special_stage_fade_timer).w
                bne.s   locret_866C
                move.b  #1,(Special_stage_fade_timer).w
                move.b  #GameMode_SpecialStageResults,(Game_mode).w
                tst.b   (Special_bonus_entry_flag).w
                beq.s   loc_8664
                move.w  (Saved2_zone_and_act).w,(Current_zone_and_act).w
                ori.b   #$80,(Last_star_post_hit).w

loc_8664:
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

locret_866C:
                rts
; ---------------------------------------------------------------------------

loc_866E:
                cmpi.b  #2,d2
                bne.s   loc_868C
                bsr.w   Find_SStageCollisionResponseSlot
                bne.s   loc_8682
                move.b  #2,(a2)
                move.l  a1,4(a2)

loc_8682:
                moveq   #signextendB(sfx_BlueSphere),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_868C:
                cmpi.b  #3,d2
                bne.s   loc_86B2
                tst.b   (Special_stage_bumper_lock).w
                bne.s   loc_86B2
                move.w  d1,(Special_stage_interact).w
                move.b  #1,(Special_stage_bumper_lock).w
                move.b  #0,(Special_stage_advancing).w
                moveq   #signextendB(sfx_Bumper),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_86B2:
                cmpi.b  #4,d2
                bne.s   locret_872E
                bsr.w   Find_SStageCollisionResponseSlot
                bne.s   loc_86C6
                move.b  #1,(a2)
                move.l  a1,4(a2)

loc_86C6:
                subq.w  #1,(Special_stage_rings_left).w
                bne.s   loc_86D4
                moveq   #signextendB(sfx_Perfect),d0
                jsr     (Play_Music).l

loc_86D4:
                addi.w  #1,(Special_stage_ring_count).w
                bset    #7,(Special_stage_extra_life_flags).w
                cmpi.w  #50,(Special_stage_ring_count).w
                blo.s   loc_86FE
                bset    #0,(Special_stage_extra_life_flags).w
                bne.s   loc_86FE
                addq.b  #1,(Continue_count).w
                move.w  #signextendB(sfx_Continue),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

loc_86FE:
                moveq   #signextendB(sfx_RingRight),d0
                cmpi.w  #100,(Special_stage_ring_count).w
                blo.s   loc_8726
                bset    #1,(Special_stage_extra_life_flags).w
                beq.s   loc_8720
                cmpi.w  #200,(Special_stage_ring_count).w
                blo.s   loc_8726
                bset    #2,(Special_stage_extra_life_flags).w
                bne.s   loc_8726

loc_8720:
                addq.b  #1,(Life_count).w
                moveq   #signextendB(sfx_RingLoss),d0

loc_8726:
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

locret_872E:
                rts
; End of function SStage_HandlePlayerGridCell
