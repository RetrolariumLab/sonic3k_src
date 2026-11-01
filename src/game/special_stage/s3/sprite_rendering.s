; Owner: game/special_stage/s3
; Responsibility: Special stage sprite projection, normal and departing sphere display and product-specific sprite output
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
word_8730:
                dc.w    $18
                dc.w    6
                dc.w    1
                dc.w    $1F
                dc.w    $FFFF
                dc.w    $1F
                dc.w    0
                dc.w    0
                dc.w    8
                dc.w    6
                dc.w    $FFFF
                dc.w    $1F
                dc.w    $FFFF
                dc.w    $1F
                dc.w    0
                dc.w    0
                dc.w    8
                dc.w    $1A
                dc.w    $FFFF
                dc.w    $1F
                dc.w    1
                dc.w    $1F
                dc.w    0
                dc.w    0
                dc.w    $18
                dc.w    $1A
                dc.w    1
                dc.w    $1F
                dc.w    1
                dc.w    $1F
                dc.w    0
                dc.w    0

; =============== S U B R O U T I N E =======================================

Draw_SSSprites:
                move.b  (Special_stage_angle).w,d0
                andi.w  #$C0,d0
                lsr.w   #2,d0
                lea     word_8730(pc,d0.w),a5
                moveq   #0,d1
                move.b  (Special_stage_X_pos).w,d1
                move.w  (Special_stage_X_pos).w,d0
                addi.w  #$100,d0
                move.w  (Special_stage_Y_pos).w,d2
                andi.w  #$100,d2
                add.w   d2,d0
                btst    #6,(Special_stage_angle).w
                bne.s   loc_87B0
                move.b  (Special_stage_Y_pos).w,d1
                move.w  (Special_stage_Y_pos).w,d0
                move.w  (Special_stage_X_pos).w,d2
                andi.w  #$100,d2
                add.w   d2,d0

loc_87B0:
                tst.b   (Special_stage_angle).w
                bmi.s   loc_87C6
                neg.w   d0
                addi.w  #$1F,d0
                move.w  d0,d2
                andi.w  #$E0,d2
                beq.s   loc_87C6
                addq.b  #1,d1

loc_87C6:
                andi.w  #$1E0,d0
                lsr.w   #5,d0
                move.w  d0,(Special_stage_anim_frame).w
                move.b  d0,(Special_stage_palette_frame).w
                move.b  (Special_stage_angle).w,d0
                andi.w  #$38,d0
                beq.s   loc_87E8
                lsr.w   #3,d0
                addi.w  #$F,d0
                move.w  d0,(Special_stage_anim_frame).w

loc_87E8:
                lea     (Draw_SSSprite_Normal).l,a0
                tst.w   (Special_stage_clear_timer).w
                beq.s   loc_87FA
                lea     (Draw_SSSprite_FlyAway).l,a0

loc_87FA:
                btst    #6,(Special_stage_angle).w
                bne.w   loc_88BC
                move.w  2(a5),d5
                add.w   d1,d5
                and.w   $A(a5),d5
                move.w  (Special_stage_anim_frame).w,d0
                add.w   d0,d0
                add.w   d0,d0
                lea     (SStage_PerspectiveMapPtrs).l,a1
                movea.l (a1,d0.w),a1
                lea     (Level_layout_header).w,a2
                lea     (SStage_extra_sprites).w,a4
                lea     (Sprite_table).w,a6
                moveq   #$50-1,d7
                moveq   #0,d6
                move.b  (Sprites_drawn).w,d6
                sub.b   d6,d7
                lsl.w   #3,d6
                adda.w  d6,a6
                moveq   #$10-1,d2

loc_883C:
                move.w  (a5),d4
                moveq   #0,d0
                move.b  (Special_stage_X_pos).w,d0
                add.w   d0,d4
                and.w   6(a5),d4
                moveq   #$F-1,d3

loc_884C:
                move.w  d5,d0
                lsl.w   #5,d0
                or.b    d4,d0
                move.b  (a2,d0.w),d0
                beq.s   loc_88A0
                move.w  (a1),d1
                andi.w  #$7C,d1
                beq.s   loc_88A0
                lsr.w   #2,d1
                subq.w  #6,d1
                cmpi.w  #$10,d1
                bhs.s   loc_88A0
                add.w   d1,d1
                andi.w  #$FF,d0
                lsl.w   #3,d0
                movea.l (a4,d0.w),a3
                move.w  4(a4,d0.w),d6
                cmpi.w  #$54,(a1)
                blo.s   loc_8884
                andi.w  #$7FFF,d6

loc_8884:
                move.w  6(a4,d0.w),d0
                add.w   d0,d0
                bcc.s   loc_888E
                moveq   #0,d1

loc_888E:
                add.w   d0,d1
                adda.w  (a3,d1.w),a3
                move.w  (a3)+,d1
                subq.w  #1,d1
                bmi.s   loc_88A0
                jsr     (a0)
                tst.w   d7
                bmi.s   locret_88BA

loc_88A0:
                addq.w  #6,a1
                add.w   4(a5),d4
                and.w   6(a5),d4
                dbf     d3,loc_884C
                add.w   8(a5),d5
                and.w   $A(a5),d5
                dbf     d2,loc_883C

locret_88BA:
                rts
; ---------------------------------------------------------------------------

loc_88BC:
                move.w  2(a5),d5
                add.w   d1,d5
                and.w   $A(a5),d5
                move.w  (Special_stage_anim_frame).w,d0
                add.w   d0,d0
                add.w   d0,d0
                lea     (SStage_PerspectiveMapPtrs).l,a1
                movea.l (a1,d0.w),a1
                lea     (Level_layout_header).w,a2
                lea     (SStage_extra_sprites).w,a4
                lea     (Sprite_table).w,a6
                moveq   #80-1,d7
                moveq   #0,d6
                move.b  (Sprites_drawn).w,d6
                sub.b   d6,d7
                lsl.w   #3,d6
                adda.w  d6,a6
                moveq   #$10-1,d2

loc_88F4:
                move.w  (a5),d4
                moveq   #0,d0
                move.b  (Special_stage_Y_pos).w,d0
                add.w   d0,d4
                and.w   6(a5),d4
                moveq   #$F-1,d3

loc_8904:
                move.w  d4,d0
                lsl.w   #5,d0
                or.b    d5,d0
                move.b  (a2,d0.w),d0
                beq.s   loc_8958
                move.w  (a1),d1
                andi.w  #$7C,d1
                beq.s   loc_8958
                lsr.w   #2,d1
                subq.w  #6,d1
                cmpi.w  #$10,d1
                bhs.s   loc_8958
                add.w   d1,d1
                andi.w  #$FF,d0
                lsl.w   #3,d0
                movea.l (a4,d0.w),a3
                move.w  4(a4,d0.w),d6
                cmpi.w  #$54,(a1)
                blo.s   loc_893C
                andi.w  #$7FFF,d6

loc_893C:
                move.w  6(a4,d0.w),d0
                add.w   d0,d0
                bcc.s   loc_8946
                moveq   #0,d1

loc_8946:
                add.w   d0,d1
                adda.w  (a3,d1.w),a3
                move.w  (a3)+,d1
                subq.w  #1,d1
                bmi.s   loc_8958
                jsr     (a0)
                tst.w   d7
                bmi.s   locret_8972

loc_8958:
                addq.w  #6,a1
                add.w   4(a5),d4
                and.w   6(a5),d4
                dbf     d3,loc_8904
                add.w   8(a5),d5
                and.w   $A(a5),d5
                dbf     d2,loc_88F4

locret_8972:
                rts
; End of function Draw_SSSprites

; ---------------------------------------------------------------------------

Draw_SSSprite_Normal:
                move.b  (a3)+,d0
                ext.w   d0
                add.w   4(a1),d0
                move.w  d0,(a6)+
                move.b  (a3)+,(a6)+
                addq.w  #1,a6
                move.w  (a3)+,d0
                add.w   d6,d0
                move.w  d0,(a6)+
                move.w  (a3)+,d0
                add.w   2(a1),d0
                move.w  d0,(a6)+
                subq.w  #1,d7
                dbmi    d1,Draw_SSSprite_Normal
                rts
; ---------------------------------------------------------------------------

Draw_SSSprite_FlyAway:
                move.b  (a3)+,d0
                ext.w   d0
                add.w   4(a1),d0
                sub.w   (Special_stage_clear_timer).w,d0
                move.w  d0,(a6)+
                move.b  (a3)+,(a6)+
                addq.w  #1,a6
                move.w  (a3)+,d0
                add.w   d6,d0
                move.w  d0,(a6)+
                move.w  (a3)+,d0
                add.w   2(a1),d0
                move.w  d1,-(sp)
                subi.w  #$120,d0
                move.w  (Special_stage_clear_timer).w,d1
                addi.w  #$100,d1
                muls.w  d1,d0
                asr.l   #8,d0
                addi.w  #$120,d0
                cmpi.w  #$1D0,d0
                blo.s   loc_89D6
                move.w  #1,d0

loc_89D6:
                move.w  (sp)+,d1
                move.w  d0,(a6)+
                subq.w  #1,d7
                dbmi    d1,Draw_SSSprite_FlyAway
                rts

; =============== S U B R O U T I N E =======================================

SStage_UpdateClearSequence:
                move.b  (Special_stage_clear_routine).w,d1
                beq.w   locret_8B58
                subq.b  #1,d1
                bne.w   loc_8AB6
                cmpi.w  #$100,(Special_stage_clear_timer).w
                bhs.s   loc_8A26
                addq.w  #2,(Special_stage_clear_timer).w
                cmpi.w  #2,(Special_stage_clear_timer).w
                bne.s   loc_8A0C
                moveq   #signextendB(sfx_AllSpheres),d0
                jsr     (Play_Music).l

loc_8A0C:
                cmpi.w  #$40,(Special_stage_clear_timer).w
                blo.s   locret_8A24
                addq.w  #1,(Special_stage_clear_timer).w
                cmpi.w  #$80,(Special_stage_clear_timer).w
                blo.s   locret_8A24
                addq.w  #1,(Special_stage_clear_timer).w

locret_8A24:
                rts
; ---------------------------------------------------------------------------

loc_8A26:
                addq.b  #1,(Special_stage_clear_routine).w
                lea     (Level_layout_header).w,a1
                move.w  #bytesToLcnt($400),d0

loc_8A32:
                move.l  #0,(a1)+
                dbf     d0,loc_8A32
                move.b  (Special_stage_angle).w,d0
                jsr     (GetSineCosine).l
                move.w  (Special_stage_X_pos).w,d2
                move.w  (Special_stage_Y_pos).w,d3
                asl.w   #3,d0
                asl.w   #3,d1
                sub.w   d0,d2
                sub.w   d1,d3
                lea     (Level_layout_header).w,a1
                move.w  d2,d0
                addi.w  #$80,d0
                lsr.w   #8,d0
                andi.w  #$1F,d0
                move.w  d3,d1
                addi.w  #$80,d1
                lsr.w   #8,d1
                andi.w  #$1F,d1
                lsl.w   #5,d1
                or.b    d0,d1
                move.b  #$A,(a1,d1.w)
                move.w  d1,(Special_stage_interact).w
                move.w  #$800,(Special_stage_velocity).w
                move.b  #120,(Special_stage_emerald_timer).w
                moveq   #0,d0
                move.b  (Current_special_stage).w,d0
                lea     (Pal_SStage_Emeralds).l,a1
                lsl.w   #3,d0
                lea     (a1,d0.w),a1
                lea     (Normal_palette_line_4+$4).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                lea     (ArtKosM_SStageChaosEmerald).l,a1
                move.w  #tiles_to_bytes(ArtTile_SStage_Emerald),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_8AB6:
                subq.b  #1,d1
                bne.s   loc_8ADA
                tst.b   (Kos_modules_left).w
                bne.s   locret_8AD8
                move.w  #0,(Special_stage_clear_timer).w
                subq.b  #1,(Special_stage_emerald_timer).w
                bne.s   locret_8AD8
                addq.b  #1,(Special_stage_clear_routine).w
                moveq   #signextendB(mus_Emerald),d0
                jsr     (Play_Music).l

locret_8AD8:
                rts
; ---------------------------------------------------------------------------

loc_8ADA:
                subq.b  #1,d1
                bne.s   locret_8B58
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
                bne.s   locret_8B58
                move.w  (Special_stage_X_pos).w,d0
                or.w    (Special_stage_Y_pos).w,d0
                andi.w  #$E0,d0
                bne.s   locret_8B58
                cmpi.w  #7,(Chaos_emerald_count).w
                bhs.s   loc_8B2E
                addq.w  #1,(Chaos_emerald_count).w
                lea     (Collected_emeralds_array).w,a1
                moveq   #0,d0
                move.b  (Current_special_stage).w,d0
                move.b  #1,(a1,d0.w)

loc_8B2E:
                addq.b  #1,(Special_stage_clear_routine).w
                move.b  #1,(Special_stage_fade_timer).w
                move.b  #GameMode_SpecialStageResults,(Game_mode).w
                tst.b   (Special_bonus_entry_flag).w
                beq.s   loc_8B50
                move.w  (Saved2_zone_and_act).w,(Current_zone_and_act).w
                ori.b   #$80,(Last_star_post_hit).w

loc_8B50:
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l

locret_8B58:
                rts
; End of function SStage_UpdateClearSequence
