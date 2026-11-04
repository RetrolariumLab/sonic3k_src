; Owner: objects/shared/sk
; Responsibility: Updraft player contact, lift control and movement response
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Updraft:
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                lsl.w   #3,d0
                move.w  d0,$36(a0)
                addi.w  #$10,d0
                move.w  d0,$38(a0)
                move.l  #SKUpdraft_UpdateBothPlayersAndCull,(a0)

SKUpdraft_UpdateBothPlayersAndCull:
                moveq   #0,d2
                lea     (Player_1).w,a1
                bsr.w   ApplyUpdraftToPlayerOrMushroomParachute
                lea     (Player_2).w,a1
                bsr.w   ApplyUpdraftToPlayerOrMushroomParachute
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

ApplyUpdraftToPlayerOrMushroomParachute:
                cmpi.b  #4,routine(a1)
                bhs.w   SKUpdraft_ApplyReturn
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$80,d0
                bhs.w   SKUpdraft_ApplyReturn
                tst.b   object_control(a1)
                bne.w   SKUpdraft_CheckParachuteHandler
                moveq   #0,d1
                move.b  (Oscillating_table+$16).w,d1
                add.w   y_pos(a1),d1
                addi.w  #$40,d1
                sub.w   y_pos(a0),d1
                bcs.s   SKUpdraft_ApplyReturn
                cmpi.w  #$50,d1
                bhs.s   SKUpdraft_ApplyReturn
                subi.w  #$40,d1
                bcs.s   SKUpdraft_LiftAndClearJump
                not.w   d1
                add.w   d1,d1

SKUpdraft_LiftAndClearJump:
                addi.w  #$40,d1
                neg.w   d1
                asr.w   #6,d1
                add.w   d1,y_pos(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.w  #0,y_vel(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                bne.s   SKUpdraft_SelectTumbleOrFloat
                moveq   #signextendB(sfx_WindQuiet),d0
                jsr     (Play_SFX).l

SKUpdraft_SelectTumbleOrFloat:
                tst.b   subtype(a0)
                bmi.s   SKUpdraft_SetFloatingAnim
                move.w  #1,ground_vel(a1)
                tst.b   flip_angle(a1)
                bne.s   SKUpdraft_ApplyReturn
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #$7F,flips_remaining(a1)
                move.b  #8,flip_speed(a1)

SKUpdraft_ApplyReturn:
                rts
; ---------------------------------------------------------------------------

; Only the two mushroom-parachute flight callbacks qualify for controlled lift
SKUpdraft_CheckParachuteHandler:
                movea.w interact(a1),a3
                cmpi.l  #SKMHZParachute_UpdateControlledFlight,(a3)
                beq.s   SKUpdraft_TestConfiguredMushroomLiftBand
                cmpi.l  #SKMHZParachute_UpdateUnoccupiedFlight,(a3)
                bne.s   SKUpdraft_ApplyReturn

SKUpdraft_TestConfiguredMushroomLiftBand:
                moveq   #0,d1
                move.b  (Oscillating_table+$16).w,d1
                add.w   y_pos(a1),d1
                add.w   $36(a0),d1
                sub.w   y_pos(a0),d1
                bcs.s   SKUpdraft_ApplyReturn
                cmp.w   $38(a0),d1
                bhs.s   SKUpdraft_ApplyReturn
                sub.w   $36(a0),d1
                bcs.s   SKUpdraft_LiftRiderAndFirstHost
                not.w   d1
                add.w   d1,d1

; Lift the controlled rider, and update the shared host only for the first admitted rider
SKUpdraft_LiftRiderAndFirstHost:
                add.w   $36(a0),d1
                neg.w   d1
                asr.w   #6,d1
                add.w   d1,y_pos(a1)
                tst.w   d2
                bne.s   SKUpdraft_ApplyReturn
                moveq   #1,d2
                add.w   d1,y_pos(a3)
                rts
; ---------------------------------------------------------------------------

SKUpdraft_SetFloatingAnim:
                move.w  #1,ground_vel(a1)
                move.b  #$F,anim(a1)
                rts
; End of function ApplyUpdraftToPlayerOrMushroomParachute
