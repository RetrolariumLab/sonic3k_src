; Owner: objects/effects/sk
; Responsibility: Super Tails bird companions and hyper Sonic or Knuckles after-image trail objects
; Source provenance and ranges: config/reconstruction/source_layout.json

Obj_SuperTailsBirds:
                lea     (ArtKosM_SuperTailsBirds).l,a1
                move.w  #tiles_to_bytes(ArtTile_Player_1),d2
                jsr     (Queue_Kos_Module).l
                lea     (a0),a1
                moveq   #0,d0
                moveq   #4-1,d1

                .loop:
                move.l  #Obj_SuperTailsBirds_Init,(a1)
                move.b  d0,superTailsBirds_angle(a1)
                addi.b  #$40,d0                         ; 90 degrees
                lea     next_object(a1),a1
                dbf     d1,.loop

Obj_SuperTailsBirds_Init:
; Wait for the object's art to finish loading
                tst.b   (Kos_modules_left).w
                beq.s   .art_done_loading
                rts
; ---------------------------------------------------------------------------

                .art_done_loading:
                move.l  #Map_SuperTails_Birds,mappings(a0)
                move.b  #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  #make_art_tile(ArtTile_Player_1,0,1),art_tile(a0)
                move.w  (Player_1+x_pos).w,x_pos(a0)
                move.w  (Player_1+y_pos).w,y_pos(a0)
                subi.w  #$C0,x_pos(a0)
                subi.w  #$C0,y_pos(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,y_vel(a0)
                move.l  #Obj_SuperTailsBirds_Main,(a0)

Obj_SuperTailsBirds_Main:
                tst.b   (Super_Tails_flag).w
                bne.s   .tails_still_super
; Tails has returned to normal - make the birds fly away
                moveq   #0,d0
                move.w  d0,(Player_2+x_pos).w
                move.w  d0,(Player_2+y_pos).w
                move.b  d0,(Player_2+anim).w
                tst.b   superTailsBirds_target_found(a0)
                beq.s   .no_target
                movea.w superTailsBirds_target_address(a0),a1
                move.b  d0,$2D(a1)                      ; Seems to be for indicating whether an object has been 'locked-onto' or not

                .no_target:
                move.b  d0,superTailsBirds_target_found(a0)
                move.b  #60*2,superTailsBirds_search_delay(a0)  ; Only search for enemies every two seconds (probably to reduce lag)
                move.l  #Obj_SuperTailsBirds_FlyAway,(a0)

                .tails_still_super:
                bsr.s   Obj_SuperTailsBirds_GetDestination

                .move:
                bsr.w   Obj_SuperTailsBirds_Move
                addi.b  #2,superTailsBirds_angle(a0)
; Update which way the sprite faces
                tst.w   x_vel(a0)
                beq.s   .x_flip_done
                bpl.s   .face_right

                bset    #0,render_flags(a0)
                bra.s   .x_flip_done
; ---------------------------------------------------------------------------

                .face_right:
                bclr    #0,render_flags(a0)

                .x_flip_done:
; Update whether the sprite should be upside down
                andi.b  #~2,render_flags(a0)
                tst.b   (Reverse_gravity_flag).w
                beq.s   .not_upside_down
                ori.b   #2,render_flags(a0)

                .not_upside_down:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   .timer_not_over
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

                .timer_not_over:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_SuperTailsBirds_FlyAway:
; Set bird's destination to top-left of the screen
                move.w  (Player_1+x_pos).w,d2
                move.w  (Player_1+y_pos).w,d3
                subi.w  #$C0,d2
                subi.w  #$C0,d3

                tst.b   render_flags(a0)
                bmi.s   Obj_SuperTailsBirds_Main.move
                jmp     (Delete_Current_Sprite).l       ; If sprite is off-screen, delete it

; =============== S U B R O U T I N E =======================================

Obj_SuperTailsBirds_GetDestination:
                tst.b   superTailsBirds_target_found(a0)
                bne.s   .fly_towards_enemy
                tst.b   superTailsBirds_search_delay(a0)
                beq.s   .look_for_target
                subq.b  #1,superTailsBirds_search_delay(a0)
                bra.s   .fly_around_tails
; ---------------------------------------------------------------------------

                .look_for_target:
                bsr.w   Obj_SuperTailsBirds_FindTarget
                tst.w   d1
                bne.s   .fly_towards_enemy

                .fly_around_tails:
                move.b  superTailsBirds_angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #3,d0
                asr.w   #4,d1
                move.w  (Player_1+x_pos).w,d2
                move.w  (Player_1+y_pos).w,d3
                subi.w  #$20,d3
                tst.b   (Reverse_gravity_flag).w
                beq.s   .not_upside_down
                addi.w  #$20*2,d3

                .not_upside_down:
                add.w   d0,d2
                add.w   d1,d3
                rts
; ---------------------------------------------------------------------------

                .fly_towards_enemy:
                movea.w superTailsBirds_target_address(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                tst.b   render_flags(a1)
                bpl.s   .enemy_off_screen
                move.w  x_pos(a0),d0
                sub.w   d2,d0
                addi.w  #$C,d0
                cmpi.w  #$18,d0
                bhs.s   .enemy_out_of_range
                move.w  y_pos(a0),d1
                sub.w   d3,d1
                addi.w  #$C,d1
                cmpi.w  #$18,d1
                bhs.s   .enemy_out_of_range
                bsr.s   .hit_enemy

                .enemy_off_screen:
                move.b  #0,$2D(a1)
                move.b  #0,superTailsBirds_target_found(a0)
                move.b  #60*2,superTailsBirds_search_delay(a0)

                .enemy_out_of_range:
                rts
; End of function Obj_SuperTailsBirds_GetDestination

; =============== S U B R O U T I N E =======================================

                .hit_enemy:
                move.b  collision_flags(a1),d0
                beq.s   .no_collision                   ; If object has no collision, give up
                andi.b  #$C0,d0
                beq.s   .enemy
                cmpi.b  #$C0,d0
                beq.s   .special

                .no_collision:
                rts
; ---------------------------------------------------------------------------

                .enemy:
                tst.b   collision_property(a1)
                beq.s   .destroy_enemy
; Boss
                move.b  collision_flags(a1),$25(a1)
                move.w  #Player_2,d0
                move.b  d0,$1C(a1)
                move.b  #0,collision_flags(a1)
                subq.b  #1,collision_property(a1)
                bne.s   .skip
                bset    #7,status(a1)

                .skip:
                bra.s   .done
; ---------------------------------------------------------------------------

                .destroy_enemy:
                jmp     (HyperTouch_DestroyEnemy).l
; ---------------------------------------------------------------------------

                .special:
                ori.b   #2,collision_property(a1)

                .done:
                move.w  x_pos(a0),(Player_2+x_pos).w
                move.w  y_pos(a0),(Player_2+y_pos).w
                move.b  #2,(Player_2+anim).w
                rts
; End of function sub_1A31E

; =============== S U B R O U T I N E =======================================

Obj_SuperTailsBirds_Move:
; Update the bird's x_vel
                move.w  #$20,d1
                cmp.w   x_pos(a0),d2
                bge.s   .go_right
                neg.w   d1
                tst.w   x_vel(a0)
                bmi.s   .x_vel_done
; Going the wrong way - make it turn around faster
                add.w   d1,d1
                add.w   d1,d1
                bra.s   .x_vel_done
; ---------------------------------------------------------------------------

                .go_right:
                tst.w   x_vel(a0)
                bpl.s   .x_vel_done
; Going the wrong way - make it turn around faster
                add.w   d1,d1
                add.w   d1,d1

                .x_vel_done:
                add.w   d1,x_vel(a0)
; Update the bird's y_vel
                and.w   (Screen_Y_wrap_value).w,d3
                move.w  #$20,d1
                sub.w   y_pos(a0),d3
                bcc.s   SKSuperBird_CheckDownGap
                cmpi.w  #-$500,d3
                ble.s   SKSuperBird_CheckDownVelLimit

SKSuperBird_CheckUpVelLimit:
                cmpi.w  #-$1000,y_vel(a0)
                ble.s   SKSuperBird_AccelDownAndCheckReversal

SKSuperBird_AccelUpAndCheckReversal:
                neg.w   d1
                tst.w   y_vel(a0)
                bmi.s   SKSuperBird_MoveAndWrap
; Going the wrong way - make it turn around faster
                add.w   d1,d1
                add.w   d1,d1
                bra.s   SKSuperBird_MoveAndWrap
; ---------------------------------------------------------------------------

; The nonborrow path uses a signed word gap threshold of $500
SKSuperBird_CheckDownGap:
                cmpi.w  #$500,d3
                bge.s   SKSuperBird_CheckUpVelLimit

SKSuperBird_CheckDownVelLimit:
                cmpi.w  #$1000,y_vel(a0)
                bge.s   SKSuperBird_AccelUpAndCheckReversal

SKSuperBird_AccelDownAndCheckReversal:
                tst.w   y_vel(a0)
                bpl.s   SKSuperBird_MoveAndWrap
; Going the wrong way - make it turn around faster
                add.w   d1,d1
                add.w   d1,d1

SKSuperBird_MoveAndWrap:
                add.w   d1,y_vel(a0)
                jsr     (MoveSprite2).l
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)
                rts
; End of function sub_1A37A

; =============== S U B R O U T I N E =======================================

Obj_SuperTailsBirds_FindTarget:
                moveq   #0,d1
                lea     (Collision_response_list).w,a4
                move.w  (a4)+,d6
                beq.s   .return
                moveq   #0,d0
                addq.b  #2,(_unkF66C).w
                cmp.b   (_unkF66C).w,d6
                bhi.s   .noreset
                move.b  #0,(_unkF66C).w

                .noreset:
                move.b  (_unkF66C).w,d0
                sub.w   d0,d6
                lea     (a4,d0.w),a4

                .loop:
                movea.w (a4)+,a1
                move.b  collision_flags(a1),d0
                beq.s   .ignore_object
                bsr.s   .check_if_object_valid

                .ignore_object:
                subq.w  #2,d6
                bne.s   .loop

                .return:
                rts
; End of function Obj_SuperTailsBirds_FindTarget

; =============== S U B R O U T I N E =======================================

                .check_if_object_valid:
                tst.b   render_flags(a1)
                bpl.s   .invalid
                tst.b   $2D(a1)
                bne.s   .invalid
                andi.b  #$C0,d0
                beq.s   .valid
                cmpi.b  #$C0,d0
                beq.s   .valid

                .invalid:
                rts
; ---------------------------------------------------------------------------

                .valid:
                move.b  #-1,$2D(a1)
                move.w  a1,superTailsBirds_target_address(a0)
                move.b  #1,superTailsBirds_target_found(a0)
                moveq   #1,d1
                moveq   #2,d6
                rts
; End of function sub_1A434

; ---------------------------------------------------------------------------
Map_SuperTails_Birds:
                include "src/objects/shared/tails/mappings/super_tails_birds.s"
; ---------------------------------------------------------------------------
; unused
                dc.l    SKInvincibilityTrail_NearFrames
                dc.b    0,  $B
                dc.l    SKInvincibilityTrail_MiddleFrames
                dc.b    $16,  $D
                dc.l    SKInvincibilityTrail_FarFrames
                dc.b    $2C,  $D
; ---------------------------------------------------------------------------

Obj_HyperSonicKnux_Trail:
; init
                move.l  #Map_Knuckles,mappings(a0)      ; Load Knuckles' mappings
                cmpi.w  #3,(Player_mode).w              ; Are we playing as Knuckles?
                beq.s   .playingasknux                  ; If so, branch
                move.l  #Map_SuperSonic,mappings(a0)    ; If not, you must be Hyper Sonic, load Super/Hyper Sonic mappings

                .playingasknux:
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.l  #Obj_HyperSonicKnux_Trail_Main,(a0)

Obj_HyperSonicKnux_Trail_Main:
                tst.b   (Super_Sonic_Knux_flag).w       ; Are we in non-super/hyper state?
                beq.w   Delete_Current_Sprite           ; If so, branch and delete
                moveq   #$C,d1                          ; This will be subtracted from Pos_table_index, giving the object an older entry
                btst    #0,(Level_frame_counter+1).w    ; Even frame? (Think of it as 'every other number' logic)
                beq.s   .evenframe                      ; If so, branch
                moveq   #$14,d1                         ; On every other frame, use a different number to subtract, giving the object an even older entry

                .evenframe:
                move.w  (Pos_table_index).w,d0
                lea     (Pos_table).w,a1
                sub.b   d1,d0
                lea     (a1,d0.w),a1
                move.w  (a1)+,x_pos(a0)                 ; Use previous player x_pos
                move.w  (a1)+,y_pos(a0)                 ; Use previous player y_pos
                lea     (Stat_table).w,a1
                move.b  3(a1,d0.w),art_tile(a0)
                move.b  (Player_1+mapping_frame).w,mapping_frame(a0)  ; Use player's current mapping_frame
                move.b  (Player_1+render_flags).w,render_flags(a0)  ; Use player's current render_flags
                move.w  (Player_1+priority).w,priority(a0)  ; Use player's current priority
                bra.w   Draw_Sprite
