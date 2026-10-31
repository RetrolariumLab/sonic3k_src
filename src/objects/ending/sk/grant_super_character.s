; Owner: objects/ending/sk
; Responsibility: Grant or prepare the super character state during the ending sequence
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Ending_Give_SuperSonic:
                addi.w  #50,(Ring_count).w
                move.b  #1,(Super_palette_status).w
                move.b  #$F,(Palette_timer).w
                move.b  #1,(Super_Sonic_Knux_flag).w
                move.w  #60,(Super_frame_count).w
                move.w  #$800,(Max_speed).w
                move.w  #$18,(Acceleration).w
                move.w  #$C0,(Deceleration).w
                move.b  #$1F,(Player_1+anim).w
                cmpi.w  #2,(Player_mode).w
                bne.s   .notTails

                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #1,(Super_Tails_flag).w
                move.b  #$29,(Player_1+anim).w
                move.w  #$800,(Max_speed_P2).w
                move.w  #$18,(Acceleration_P2).w
                move.w  #$C0,(Deceleration_P2).w
                move.l  #Obj_SuperTailsBirds,(Invincibility_stars).w
                bra.s   .continued
; ---------------------------------------------------------------------------

                .notTails:
                bhs.s   .hyperKnuckles
                move.l  #Map_SuperSonic,(Player_1+mappings).w
                move.b  #-1,(Super_Sonic_Knux_flag).w
                move.w  #$A00,(Max_speed).w
                move.w  #$30,(Acceleration).w
                move.w  #$100,(Deceleration).w
                move.l  #Obj_HyperSonic_Stars,(Invincibility_stars).w
; Bug: Sonic turns Hyper after the credits no matter which emeralds he has
; Note that he doesn't get his Hyper after-images even when he should
                bra.s   .continued
; ---------------------------------------------------------------------------

                .hyperKnuckles:
; Bug: Knuckles gets his Hyper after-images, but isn't actually marked as Hyper
                move.l  #Obj_HyperSonicKnux_Trail,(Super_stars).w

                .continued:
                move.b  #$81,(Player_1+object_control).w
                move.b  #0,(Player_1+invincibility_timer).w
                bset    #Status_Invincible,(Player_1+status_secondary).w
                rts
