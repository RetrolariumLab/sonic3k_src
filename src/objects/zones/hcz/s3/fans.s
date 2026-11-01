; Owner: objects/zones/hcz/s3
; Responsibility: Hydrocity and competition fans, airflow, large-fan states and shared mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZCGZFan:
                tst.w   (Competition_mode).w
                bne.w   loc_2F51C
                movea.l a0,a1
                tst.b   subtype(a0)
                bpl.s   loc_2EFE0
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   locret_2F02A
                move.l  #loc_2F22E,(a0)
                move.w  x_pos(a0),x_pos(a1)
                move.w  x_pos(a0),$40(a0)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$1C,y_pos(a0)
                move.l  #Map_HCZWaterRushBlock,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZMisc+$A,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.w  a1,$3C(a0)
                move.b  subtype(a0),d0
                andi.w  #$30,d0
                add.w   d0,d0
                move.w  d0,$3A(a0)
                move.b  subtype(a0),subtype(a1)
                bclr    #5,subtype(a1)
                bset    #4,subtype(a1)

loc_2EFE0:
                move.l  #Map_HCZFan,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZMisc+$41,1,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.w  #$200,priority(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$C,height_pixels(a1)
                move.w  x_pos(a1),$40(a1)
                move.b  subtype(a1),d0
                andi.w  #$F,d0
                addq.w  #8,d0
                lsl.w   #4,d0
                move.w  d0,$36(a1)
                addi.w  #$30,d0
                move.w  d0,$38(a1)
                move.l  #loc_2F02C,(a1)

locret_2F02A:
                rts
; ---------------------------------------------------------------------------

loc_2F02C:
                move.b  subtype(a0),d0
                btst    #5,d0
                beq.s   loc_2F04A
                tst.b   (Level_trigger_array).w
                beq.w   loc_2F152
                bclr    #5,subtype(a0)
                bset    #4,subtype(a0)

loc_2F04A:
                tst.b   $42(a0)
                bne.s   loc_2F080
                btst    #4,subtype(a0)
                bne.s   loc_2F0A0
                subq.w  #1,$30(a0)
                bpl.s   loc_2F078
                move.w  #0,$34(a0)
                move.w  #2*60,$30(a0)
                bchg    #0,$32(a0)
                beq.s   loc_2F078
                move.w  #3*60,$30(a0)

loc_2F078:
                tst.b   $32(a0)
                beq.w   loc_2F0A0

loc_2F080:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   loc_2F152
                cmpi.w  #$400,$34(a0)
                bhs.w   loc_2F152
                addi.w  #$2A,$34(a0)
                move.b  $34(a0),anim_frame_timer(a0)
                bra.s   loc_2F0BE
; ---------------------------------------------------------------------------

loc_2F0A0:
                lea     (Player_1).w,a1
                bsr.w   ApplyHczFanFieldToPlayer
                lea     (Player_2).w,a1
                bsr.w   ApplyHczFanFieldToPlayer
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   loc_2F0D0
                move.b  #0,anim_frame_timer(a0)

loc_2F0BE:
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #5,mapping_frame(a0)
                blo.s   loc_2F0D0
                move.b  #0,mapping_frame(a0)

loc_2F0D0:
                tst.b   render_flags(a0)
                bpl.s   loc_2F0EA
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #1,d0
                andi.b  #$F,d0
                bne.s   loc_2F0EA
                moveq   #signextendB(sfx_FanSmall),d0
                jsr     (Play_SFX).l

loc_2F0EA:
                btst    #6,subtype(a0)
                beq.s   loc_2F152
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #3,d0
                bne.s   loc_2F152
                jsr     (AllocateObject).l
                bne.s   loc_2F152
                move.l  #loc_2F212,(a1)
                move.l  #Map_Bubbler,mappings(a1)
                move.w  #make_art_tile(ArtTile_Bubbles,0,0),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.b  #4,width_pixels(a1)
; Bug: This is missing the height, and only really repeats what the previous line did
                move.b  #4,width_pixels(a1)
                move.w  #$300,priority(a1)
                move.w  x_pos(a0),x_pos(a1)
                jsr     (Random_Number).l
                andi.w  #$F,d0
                subq.w  #8,d0
                add.w   d0,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  #-$800,y_vel(a1)

loc_2F152:
                move.w  $40(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

ApplyHczFanFieldToPlayer:
                cmpi.b  #4,routine(a1)
                bhs.w   locret_2F1FA
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$18,d0
                cmpi.w  #$30,d0
                bhs.w   locret_2F1FA
                moveq   #0,d1
                move.b  (Oscillating_table+$16).w,d1
                add.w   y_pos(a1),d1
                add.w   $36(a0),d1
                sub.w   y_pos(a0),d1
                bcs.s   locret_2F1FA
                cmp.w   $38(a0),d1
                bhs.s   locret_2F1FA
                tst.b   object_control(a1)
                bne.s   loc_2F1FC
                sub.w   $36(a0),d1
                bcs.s   loc_2F1A4
                not.w   d1
                add.w   d1,d1

loc_2F1A4:
                add.w   $36(a0),d1
                neg.w   d1
                asr.w   #6,d1
                add.w   d1,y_pos(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.w  #0,y_vel(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                btst    #6,subtype(a0)
                bne.s   loc_2F204
                move.w  #1,ground_vel(a1)
                tst.b   flip_angle(a1)
                bne.s   locret_2F1FA
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #$7F,flips_remaining(a1)
                move.b  #8,flip_speed(a1)

locret_2F1FA:
                rts
; ---------------------------------------------------------------------------

loc_2F1FC:
                move.w  #1,ground_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_2F204:
                move.w  #1,ground_vel(a1)
                move.b  #$F,anim(a1)
                rts
; ---------------------------------------------------------------------------

loc_2F212:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_2F228
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2F228:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2F22E:
                movea.w $3C(a0),a1
                move.w  (Player_1+y_pos).w,d0
                sub.w   y_pos(a0),d0
                bcs.s   loc_2F26C
                cmpi.w  #$20,d0
                blt.s   loc_2F296
                tst.b   $42(a1)
                bne.s   loc_2F25C
                move.b  #1,$42(a1)
                move.w  #0,$34(a1)
                moveq   #signextendB(sfx_FanLatch),d0
                jsr     (Play_SFX).l

loc_2F25C:
                move.w  $3A(a0),d1
                cmp.w   $30(a0),d1
                beq.s   loc_2F296
                addq.w  #8,$30(a0)
                bra.s   loc_2F296
; ---------------------------------------------------------------------------

loc_2F26C:
                cmpi.w  #-$30,d0
                bge.s   loc_2F296
                tst.b   $42(a1)
                beq.s   loc_2F28C
                move.b  #0,$42(a1)
                move.b  #0,anim_frame_timer(a1)
                moveq   #signextendB(sfx_FanLatch),d0
                jsr     (Play_SFX).l

loc_2F28C:
                tst.w   $30(a0)
                beq.s   loc_2F296
                subq.w  #8,$30(a0)

loc_2F296:
                move.w  $30(a0),d0
                btst    #0,status(a0)
                beq.s   loc_2F2A4
                neg.w   d0

loc_2F2A4:
                add.w   $40(a0),d0
                move.w  d0,x_pos(a0)
                move.w  d0,x_pos(a1)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.w  $40(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

Obj_HCZLargeFan:
                move.w  (Player_1+x_pos).w,d0
                subi.w  #$20,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_2F2F8
                move.w  (Player_1+y_pos).w,d0
                subi.w  #$20,d0
                sub.w   y_pos(a0),d0
                cmpi.w  #$40,d0
                blo.s   loc_2F304

loc_2F2F8:
                move.b  #3,(_unkF7C7).w
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_2F304:
                lea     (ArtKosM_HCZLargeFan).l,a1
                move.w  #tiles_to_bytes(ArtTile_HCZLargeFan),d2
                jsr     (Queue_Kos_Module).l
                move.l  #loc_2F31A,(a0)

loc_2F31A:
                tst.b   (Kos_modules_left).w
                beq.s   loc_2F322
                rts
; ---------------------------------------------------------------------------

loc_2F322:
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.l  #Map_HCZLargeFan,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZLargeFan,1,0),art_tile(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  #8,$30(a0)
                moveq   #signextendB(sfx_FanLatch),d0
                jsr     (Play_SFX).l
                move.l  #loc_2F35C,(a0)

loc_2F35C:
                tst.w   $30(a0)
                beq.s   loc_2F372
                addq.w  #8,y_pos(a0)
                subq.w  #1,$30(a0)
                bne.s   loc_2F372
                move.b  #0,(_unkF7C7).w

loc_2F372:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   loc_2F384
                moveq   #signextendB(sfx_FanBig),d0
                jsr     (Play_SFX).l

loc_2F384:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   loc_2F3A4
                move.b  #0,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #5,mapping_frame(a0)
                blo.s   loc_2F3A4
                move.b  #0,mapping_frame(a0)

loc_2F3A4:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_HCZFan:
                include "src/objects/shared/zones/hcz/mappings/fan.s"
Map_HCZLargeFan:
                include "src/objects/shared/zones/hcz/mappings/large_fan.s"
; ---------------------------------------------------------------------------

loc_2F51C:
                move.l  #Map_CGZFan,mappings(a0)
                move.w  #make_art_tile(ArtTile_CGZMisc,3,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                addq.w  #8,d0
                lsl.w   #4,d0
                move.w  d0,$36(a0)
                addi.w  #$30,d0
                move.w  d0,$38(a0)
                move.l  #loc_2F560,(a0)

loc_2F560:
                lea     (Player_1).w,a1
                bsr.w   ApplyCgzFanFieldToPlayer
                lea     (Player_2).w,a1
                bsr.w   ApplyCgzFanFieldToPlayer
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   loc_2F582
                move.b  #0,mapping_frame(a0)

loc_2F582:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

ApplyCgzFanFieldToPlayer:
                cmpi.b  #4,routine(a1)
                bhs.w   locret_2F61E
                tst.b   object_control(a1)
                bne.w   locret_2F61E
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$14,d0
                cmpi.w  #$28,d0
                bhs.s   locret_2F61E
                moveq   #0,d1
                move.b  (Oscillating_table+$16).w,d1
                add.w   y_pos(a1),d1
                add.w   $36(a0),d1
                sub.w   y_pos(a0),d1
                bcs.s   locret_2F61E
                cmp.w   $38(a0),d1
                bhs.s   locret_2F61E
                sub.w   $36(a0),d1
                bcs.s   loc_2F5D0
                not.w   d1
                add.w   d1,d1

loc_2F5D0:
                add.w   $36(a0),d1
                neg.w   d1
                asr.w   #6,d1
                add.w   d1,y_pos(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.w  #0,y_vel(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                move.w  #1,ground_vel(a1)
                tst.b   flip_angle(a1)
                bne.s   locret_2F61E
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #$7F,flips_remaining(a1)
                move.b  #8,flip_speed(a1)

locret_2F61E:
                rts
; End of function ApplyCgzFanFieldToPlayer

; ---------------------------------------------------------------------------
Map_CGZFan:
                include "src/objects/shared/zones/cgz/mappings/fan.s"
