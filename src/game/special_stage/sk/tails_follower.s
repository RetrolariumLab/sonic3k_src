; Owner: game/special_stage/sk
; Responsibility: Tails special-stage follower animation, delayed position history and history reset
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_SStage_9212:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$180,priority(a0)
                move.l  #Map_SStageTails,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Player2,1,1),art_tile(a0)
                move.w  #$A0,$30(a0)
                move.w  #$70,$32(a0)
                move.w  #0,$34(a0)
                move.w  #-$800,$36(a0)
                move.w  #-$20,$38(a0)
                move.b  #$FF,$3A(a0)
                bsr.w   sub_93E2
                jsr     (AllocateObjectAfterCurrent_SpecialStage).l
                bne.w   loc_9274
                move.l  #Obj_SStage_9444,(a1)
                move.w  a0,$3E(a1)

loc_9274:
                move.l  #loc_927A,(a0)

loc_927A:
                moveq   #$C,d0
                move.w  (Special_stage_velocity).w,d1
                beq.s   loc_92A0
                asr.w   #5,d1
                add.w   d1,anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame_timer(a0),d0
                bpl.s   loc_9296
                addi.b  #$C,d0
                bra.s   loc_92A0
; ---------------------------------------------------------------------------

loc_9296:
                cmpi.b  #$C,d0
                blo.s   loc_92A0
                subi.b  #$C,d0

loc_92A0:
                move.b  d0,anim_frame_timer(a0)
                lea     (byte_91E8).l,a1
                tst.b   (Special_stage_jumping_P2).w
                beq.s   loc_92C4
                lea     (byte_9204).l,a1
                move.w  (Special_stage_velocity).w,d1
                bne.s   loc_92C4
                move.b  (Level_frame_counter+1).w,d0
                andi.w  #3,d0

loc_92C4:
                move.b  (a1,d0.w),mapping_frame(a0)
                bsr.w   sub_9402
                cmpi.b  #5,$44(a0)
                bne.s   loc_9304
                tst.b   (Special_stage_clear_routine).w
                bne.s   loc_9304
                tst.b   (Special_stage_jumping_P2).w
                bmi.s   loc_9304
                move.b  (Special_stage_angle).w,d0
                andi.b  #$3F,d0
                bne.w   loc_9304
                move.l  #$FFE80000,$40(a0)
                move.b  #$81,(Special_stage_jumping_P2).w
                moveq   #signextendB(sfx_Spring),d0
                jsr     (Play_SFX).l

loc_9304:
                bsr.w   sub_937C
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   loc_932A
                tst.b   (Special_stage_jumping_P2).w
                bne.s   loc_932A
                move.l  #$FFF00000,$40(a0)
                move.b  #$80,(Special_stage_jumping_P2).w
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l

loc_932A:
                tst.b   (Special_stage_jumping_P2).w
                bpl.s   loc_935E
                move.l  $3C(a0),d0
                add.l   $40(a0),d0
                bmi.s   loc_9344
                moveq   #0,d0
                move.l  d0,$40(a0)
                move.b  d0,(Special_stage_jumping_P2).w

loc_9344:
                move.w  (Special_stage_rate).w,d1
                ext.l   d1
                lsl.l   #4,d1
                add.l   d1,$40(a0)
                move.l  d0,$3C(a0)
                swap    d0
                addi.w  #-$800,d0
                move.w  d0,$36(a0)

loc_935E:
                bsr.w   sub_953E
                jsr     (Draw_Sprite).l
                lea     (PLC_SStageTails).l,a2
                move.l  #ArtUnc_SStageTails,d6
                move.w  #tiles_to_bytes(ArtTile_SStage_Player2),d4
                bra.w   SStage_PLCLoad_91A2

; =============== S U B R O U T I N E =======================================

sub_937C:
                move.w  (Pos_table_index).w,d0
                lea     (Pos_table).w,a1
                lea     (a1,d0.w),a1
                move.w  (Ctrl_1).w,(a1)
                move.b  (Special_stage_jumping).w,2(a1)
                addq.b  #4,(Pos_table_index+1).w
                move.b  (Ctrl_2_held).w,d0
                andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   loc_93A6
                move.w  #600,(Tails_CPU_idle_timer).w

loc_93A6:
                tst.w   (Tails_CPU_idle_timer).w
                beq.s   loc_93B6
                subq.w  #1,(Tails_CPU_idle_timer).w
                move.w  (Ctrl_2).w,d0
                rts
; ---------------------------------------------------------------------------

loc_93B6:
                lea     (Pos_table).w,a1
                move.w  #4,d1
                lsl.b   #2,d1
                move.w  (Pos_table_index).w,d0
                sub.b   d1,d0
                move.b  2(a1,d0.w),d2
                subq.b  #4,d0
                move.b  2(a1,d0.w),d1
                moveq   #0,d0
                cmpi.b  #-$7F,d2
                beq.s   locret_93E0
                tst.b   d1
                bpl.s   locret_93E0
                move.w  #$70,d0

locret_93E0:
                rts
; End of function sub_937C

; =============== S U B R O U T I N E =======================================

sub_93E2:
                lea     (Pos_table).w,a2
                move.w  #bytesToLcnt($100),d0

loc_93EA:
                move.l  #0,(a2)+
                dbf     d0,loc_93EA
                move.w  #0,(Pos_table_index).w
                move.w  #0,(Tails_CPU_idle_timer).w
                rts
; End of function sub_93E2

; =============== S U B R O U T I N E =======================================

sub_9402:
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
                lea     $44(a0),a2
                move.b  1(a2),(a2)
                move.b  2(a2),1(a2)
                move.b  3(a2),2(a2)
                move.b  (a1),3(a2)
                rts
; End of function sub_9402
