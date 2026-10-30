; Owner: objects/rings/sk
; Responsibility: Dynamic ring objects, collection rewards, bouncing lost rings and attracted ring motion
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Ring:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Ring_Index(pc,d0.w),d1
                jmp     Ring_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Ring_Index:
                dc.w    Obj_RingInit-Ring_Index
                dc.w    Obj_RingAnimate-Ring_Index
                dc.w    Obj_RingCollect-Ring_Index
                dc.w    Obj_RingSparkle-Ring_Index
                dc.w    Obj_RingDelete-Ring_Index
; ---------------------------------------------------------------------------

Obj_RingInit:
                addq.b  #2,routine(a0)
                move.l  #Map_Ring,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,1,1),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$100,priority(a0)
                move.b  #$47,collision_flags(a0)
                move.b  #8,width_pixels(a0)
                tst.w   (Competition_mode).w
                beq.s   Obj_RingAnimate
                move.w  #make_art_tile(ArtTile_2PArt_3+$C,3,0),art_tile(a0)

Obj_RingAnimate:
                move.b  (Rings_frame).w,mapping_frame(a0)
                bra.w   Sprite_CheckDeleteTouch3
; ---------------------------------------------------------------------------

Obj_RingCollect:
                addq.b  #2,routine(a0)
                move.b  #0,collision_flags(a0)
                move.w  #$80,priority(a0)
                bsr.s   GiveRing

Obj_RingSparkle:
                lea     (Ani_RingSparkle).l,a1
                bsr.w   Animate_Sprite
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

Obj_RingDelete:
                bra.w   Delete_Current_Sprite

; =============== S U B R O U T I N E =======================================

GiveRing:
                cmpi.w  #999,(Total_ring_count).w       ; did Sonic collect 999 or more rings?
                bhs.s   GiveRing_1P                     ; if yes, branch
                addq.w  #1,(Total_ring_count).w         ; add 1 to the number of collected rings

GiveRing_1P:
                move.w  #sfx_RingRight,d0               ; prepare to play the ring sound
                cmpi.w  #999,(Ring_count).w             ; does the player 1 have 999 or more rings?
                bhs.s   JmpTo_Play_SFX                  ; if yes, play the ring sound
                addq.w  #1,(Ring_count).w               ; add 1 to the ring count
                ori.b   #1,(Update_HUD_ring_count).w    ; set flag to update the ring counter in the HUD
                cmpi.w  #100,(Ring_count).w             ; does the player 1 have less than 100 rings?
                blo.s   JmpTo_Play_SFX                  ; if yes, play the ring sound
                bset    #1,(Extra_life_flags).w         ; test and set the flag for the first extra life
                beq.s   loc_1A5D8                       ; if it was clear before, branch
                cmpi.w  #200,(Ring_count).w             ; does the player 1 have less than 200 rings?
                blo.s   JmpTo_Play_SFX                  ; if yes, play the ring sound
                bset    #2,(Extra_life_flags).w         ; test and set the flag for the second extra life
                bne.s   JmpTo_Play_SFX                  ; if it was set before, play the ring sound

loc_1A5D8:
                addq.b  #1,(Life_count).w               ; add 1 to the life count
                addq.b  #1,(Update_HUD_life_count).w    ; add 1 to the displayed life count
                moveq   #signextendB(mus_ExtraLife),d0  ; prepare to play the extra life jingle
                jmp     (Play_Music).l                  ; Sonic 2 wound up putting music in the stereo sound queue, this would have fixed it
; ---------------------------------------------------------------------------

JmpTo_Play_SFX:
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------
; unused
                rts
; ---------------------------------------------------------------------------

GiveRing_Tails:
                cmpi.w  #999,(Total_ring_count_P2).w
                bhs.s   loc_1A5FC
                addq.w  #1,(Total_ring_count_P2).w

loc_1A5FC:
                cmpi.w  #999,(Ring_count_P2).w
                bhs.s   loc_1A608
                addq.w  #1,(Ring_count_P2).w

loc_1A608:
                tst.w   (Competition_mode).w
                beq.s   GiveRing_1P
                ori.b   #1,(_unkFEBE).w
                move.w  #sfx_RingRight,d0
                cmpi.w  #100,(Ring_count_P2).w
                blo.s   loc_1A644
                bset    #1,(Extra_life_flags_P2).w
                beq.s   loc_1A638
                cmpi.w  #200,(Ring_count_P2).w
                blo.s   loc_1A644
                bset    #2,(Extra_life_flags_P2).w
                bne.s   loc_1A644

loc_1A638:
                addq.b  #1,(Life_count_P2).w
                moveq   #signextendB(mus_ExtraLife),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

loc_1A644:
                jmp     (Play_SFX).l
; End of function GiveRing

; ---------------------------------------------------------------------------

Obj_Bouncing_Ring:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Bouncing_Ring_Index(pc,d0.w),d1
                jmp     Bouncing_Ring_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Bouncing_Ring_Index:
                dc.w    loc_1A67A-Bouncing_Ring_Index
                dc.w    loc_1A75C-Bouncing_Ring_Index
                dc.w    loc_1A7C2-Bouncing_Ring_Index
                dc.w    loc_1A7D6-Bouncing_Ring_Index
                dc.w    loc_1A7E4-Bouncing_Ring_Index
; ---------------------------------------------------------------------------

Obj_Bouncing_Ring_Reverse_Gravity:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Bouncing_Ring_Reverse_Gravity_Index(pc,d0.w),d1
                jmp     Bouncing_Ring_Reverse_Gravity_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Bouncing_Ring_Reverse_Gravity_Index:
                dc.w    loc_1A67A-Bouncing_Ring_Reverse_Gravity_Index
                dc.w    loc_1A7E8-Bouncing_Ring_Reverse_Gravity_Index
                dc.w    loc_1A7C2-Bouncing_Ring_Reverse_Gravity_Index
                dc.w    loc_1A7D6-Bouncing_Ring_Reverse_Gravity_Index
                dc.w    loc_1A7E4-Bouncing_Ring_Reverse_Gravity_Index
; ---------------------------------------------------------------------------

loc_1A67A:
                move.l  #Obj_Bouncing_Ring,d6
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_1A68C
                move.l  #Obj_Bouncing_Ring_Reverse_Gravity,d6

loc_1A68C:
                movea.l a0,a1
                moveq   #0,d5
                move.w  (Ring_count).w,d5
                tst.b   $3F(a0)
                beq.s   loc_1A69E
                move.w  (Ring_count_P2).w,d5

loc_1A69E:
                moveq   #$20,d0
                cmp.w   d0,d5
                blo.s   loc_1A6A6
                move.w  d0,d5

loc_1A6A6:
                subq.w  #1,d5
                move.w  #$288,d4
                bra.s   loc_1A6B6
; ---------------------------------------------------------------------------

loc_1A6AE:
                bsr.w   AllocateObjectAfterCurrent
                bne.w   loc_1A738

loc_1A6B6:
                move.l  d6,(a1)
                addq.b  #2,routine(a1)
                move.b  #8,y_radius(a1)
                move.b  #8,x_radius(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_Ring,mappings(a1)
                move.w  #make_art_tile(ArtTile_Ring,1,1),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.w  #$180,priority(a1)
                move.b  #$47,collision_flags(a1)
                move.b  #8,width_pixels(a1)
                move.b  #-1,(Ring_spill_anim_counter).w
                tst.w   d4
                bmi.s   loc_1A728
                move.w  d4,d0
                jsr     (GetSineCosine).l
                move.w  d4,d2
                lsr.w   #8,d2
                asl.w   d2,d0
                asl.w   d2,d1
                move.w  d0,d2
                move.w  d1,d3
                addi.b  #$10,d4
                bcc.s   loc_1A728
                subi.w  #$80,d4
                bcc.s   loc_1A728
                move.w  #$288,d4

loc_1A728:
                move.w  d2,x_vel(a1)
                move.w  d3,y_vel(a1)
                neg.w   d2
                neg.w   d4
                dbf     d5,loc_1A6AE

loc_1A738:
                move.w  #signextendB(sfx_RingLoss),d0
                jsr     (Play_SFX).l
                move.w  #0,(Ring_count).w
                move.b  #$80,(Update_HUD_ring_count).w
                move.b  #0,(Extra_life_flags).w
                tst.b   (Reverse_gravity_flag).w
                bne.w   loc_1A7E8

loc_1A75C:
                move.b  (Ring_spill_anim_frame).w,mapping_frame(a0)
                bsr.w   MoveSprite2
                addi.w  #$18,y_vel(a0)
                bmi.s   loc_1A7B0
                move.b  (V_int_run_count+3).w,d0
                add.b   d7,d0
                andi.b  #7,d0
                bne.s   loc_1A7B0
                tst.b   render_flags(a0)
                bpl.s   loc_1A79C
                jsr     (RingCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_1A79C
                add.w   d1,y_pos(a0)
                move.w  y_vel(a0),d0
                asr.w   #2,d0
                sub.w   d0,y_vel(a0)
                neg.w   y_vel(a0)

loc_1A79C:
                tst.b   (Ring_spill_anim_counter).w
                beq.s   loc_1A7E4
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_1A7E4

loc_1A7B0:
                jsr     (Add_SpriteToCollisionResponseList).l
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

loc_1A7C2:
                addq.b  #2,routine(a0)
                move.b  #0,collision_flags(a0)
                move.w  #$80,priority(a0)
                bsr.w   GiveRing

loc_1A7D6:
                lea     (Ani_RingSparkle).l,a1
                bsr.w   Animate_Sprite
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

loc_1A7E4:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

loc_1A7E8:
                move.b  (Ring_spill_anim_frame).w,mapping_frame(a0)
                bsr.w   MoveSprite_TestGravity2
                addi.w  #$18,y_vel(a0)
                bmi.s   loc_1A83C
                move.b  (V_int_run_count+3).w,d0
                add.b   d7,d0
                andi.b  #7,d0
                bne.s   loc_1A83C
                tst.b   render_flags(a0)
                bpl.s   loc_1A828
                jsr     (RingCheckFloorDist_ReverseGravity).l
                tst.w   d1
                bpl.s   loc_1A828
                sub.w   d1,y_pos(a0)
                move.w  y_vel(a0),d0
                asr.w   #2,d0
                sub.w   d0,y_vel(a0)
                neg.w   y_vel(a0)

loc_1A828:
                tst.b   (Ring_spill_anim_counter).w
                beq.s   loc_1A7E4
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_1A7E4

loc_1A83C:
                jsr     (Add_SpriteToCollisionResponseList).l
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

Obj_Attracted_Ring:
; init
                move.l  #Map_Ring,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,1,1),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$100,priority(a0)
                move.b  #$47,collision_flags(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #8,y_radius(a0)
                move.b  #8,x_radius(a0)
                move.l  #loc_1A88C,(a0)

loc_1A88C:
                tst.b   routine(a0)
                bne.s   AttractedRing_GiveRing
                bsr.w   AttractedRing_Move
                btst    #Status_LtngShield,(Player_1+status_secondary).w  ; Does player still have a lightning shield?
                bne.s   Obj_Attracted_RingAnimate
                move.l  #Obj_Bouncing_Ring,(a0)         ; If not, change object
                move.b  #2,routine(a0)
                move.b  #-1,(Ring_spill_anim_counter).w

Obj_Attracted_RingAnimate:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_1A8C6
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

loc_1A8C6:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_1A8E4
                jsr     (Add_SpriteToCollisionResponseList).l
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

loc_1A8E4:
                move.w  respawn_addr(a0),d0
                beq.s   loc_1A8F0
                movea.w d0,a2
                bclr    #7,(a2)

loc_1A8F0:
; Bug: Probably meant to be $30(a0), as Test_Ring_Collisions_AttractRing
; stores the ring's address in the ring status table there
; This is corrected in Sonic & Knuckles Collection
                move.w  (Vectors+$30).w,d0
                beq.s   loc_1A8FC
                movea.w d0,a2
                move.w  #0,(a2)

loc_1A8FC:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

AttractedRing_GiveRing:
                move.b  #0,collision_flags(a0)
                move.w  #$80,priority(a0)
                subq.w  #1,(Perfect_rings_left).w
                bsr.w   GiveRing
                move.l  #loc_1A920,(a0)
                move.b  #0,routine(a0)

loc_1A920:
                tst.b   routine(a0)
                bne.s   loc_1A934
                lea     (Ani_RingSparkle).l,a1
                bsr.w   Animate_Sprite
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

loc_1A934:
                bra.w   Delete_Current_Sprite

; =============== S U B R O U T I N E =======================================

AttractedRing_Move:
; Move on X axis
                move.w  #$30,d1
                move.w  (Player_1+x_pos).w,d0
                cmp.w   x_pos(a0),d0
                bhs.s   AttractedRing_MoveRight         ; If ring is to the left of the player, branch

                neg.w   d1
                tst.w   x_vel(a0)
                bmi.s   AttractedRing_ApplyMovementX
                add.w   d1,d1
                add.w   d1,d1
                bra.s   AttractedRing_ApplyMovementX
; ---------------------------------------------------------------------------

AttractedRing_MoveRight:
                tst.w   x_vel(a0)
                bpl.s   AttractedRing_ApplyMovementX
                add.w   d1,d1
                add.w   d1,d1

AttractedRing_ApplyMovementX:
                add.w   d1,x_vel(a0)
; Move on Y axis
                move.w  #$30,d1
                move.w  (Player_1+y_pos).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   AttractedRing_MoveUp            ; If ring is below the player, branch

                neg.w   d1
                tst.w   y_vel(a0)
                bmi.s   AttractedRing_ApplyMovementY
                add.w   d1,d1
                add.w   d1,d1
                bra.s   AttractedRing_ApplyMovementY
; ---------------------------------------------------------------------------

AttractedRing_MoveUp:
                tst.w   y_vel(a0)
                bpl.s   AttractedRing_ApplyMovementY
                add.w   d1,d1
                add.w   d1,d1

AttractedRing_ApplyMovementY:
                add.w   d1,y_vel(a0)
                jmp     (MoveSprite2).l
; End of function AttractedRing_Move

; ---------------------------------------------------------------------------
Ani_RingSparkle:
                include "src/objects/shared/ring/anim_ring_sparkle.s"
Map_Ring:
                include "src/objects/shared/ring/map_ring.s"
; ---------------------------------------------------------------------------

Obj_SlotRing:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SlotRing_Index(pc,d0.w),d1
                jmp     SlotRing_Index(pc,d1.w)
; ---------------------------------------------------------------------------
SlotRing_Index:
                dc.w    loc_1AA02-SlotRing_Index
                dc.w    loc_1AA56-SlotRing_Index
                dc.w    loc_1AA62-SlotRing_Index
; ---------------------------------------------------------------------------

loc_1AA02:
                moveq   #0,d1
                move.w  $3C(a0),d1
                swap    d1
                move.l  $34(a0),d0
                sub.l   d1,d0
                asr.l   #4,d0
                sub.l   d0,$34(a0)
                move.w  $34(a0),x_pos(a0)
                moveq   #0,d1
                move.w  $3E(a0),d1
                swap    d1
                move.l  $38(a0),d0
                sub.l   d1,d0
                asr.l   #4,d0
                sub.l   d0,$38(a0)
                move.w  $38(a0),y_pos(a0)
                lea     Ani_Ring(pc),a1
                bsr.w   Animate_Sprite
                subq.w  #1,$40(a0)
                bne.w   Draw_Sprite
                movea.l $2E(a0),a1
                subq.w  #1,(a1)
                bsr.w   GiveRing
                addi.b  #2,routine(a0)

loc_1AA56:
                lea     Ani_RingSparkle(pc),a1
                bsr.w   Animate_Sprite
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

loc_1AA62:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------
Ani_Ring:
                include "src/objects/shared/ring/anim_ring.s"
