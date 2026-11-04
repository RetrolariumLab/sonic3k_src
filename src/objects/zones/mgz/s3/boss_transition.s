; Owner: objects/zones/mgz/s3
; Responsibility: Marble Garden boss transition controller, partner recovery and player carrying setup
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_MGZ2_BossTransition:
                cmpi.w  #2,(Player_mode).w
                beq.w   S3MGZBossTrans_InitSoloTailsRecovery
                move.w  (Camera_X_pos).w,d0
                addi.w  #$40,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$100,d0
                move.w  d0,y_pos(a0)
                lea     (Player_2).w,a1
                tst.b   render_flags(a1)
                bmi.s   S3MGZBossTrans_BeginPartnerRecovery
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subq.w  #1,y_pos(a1)
                move.l  #Obj_Tails,(Player_2).w
                move.w  #$12,(Tails_CPU_routine).w
                move.w  #0,(Flying_carrying_Sonic_flag).w

S3MGZBossTrans_BeginPartnerRecovery:
                move.w  #$168,$30(a0)
                move.l  #S3MGZBossTrans_TickPartnerRecovery,(a0)

S3MGZBossTrans_TickPartnerRecovery:
                subq.w  #1,$30(a0)
                bne.s   S3MGZBossTrans_TryClampUncarriedP1
                move.l  #S3MGZBossTrans_TryClampUncarriedP1,(a0)

S3MGZBossTrans_TryClampUncarriedP1:
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.s   S3MGZBossTrans_TryRecoverP2
                lea     (Player_1).w,a1
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   S3MGZBossTrans_TryRecoverP2
                move.w  d0,y_pos(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #0,spin_dash_flag(a1)
                cmpi.w  #$14,(Tails_CPU_routine).w
                blo.s   S3MGZBossTrans_RestoreP1Routine
                move.w  x_pos(a1),x_pos(a0)

S3MGZBossTrans_RestoreP1Routine:
                move.b  #2,routine(a1)

S3MGZBossTrans_TryRecoverP2:
                tst.b   (Player_1+render_flags).w
                bmi.s   S3MGZBossTrans_PartnerRecoveryReturn
                cmpi.b  #2,(Player_1+routine).w
                bne.s   S3MGZBossTrans_PartnerRecoveryReturn
                lea     (Player_2).w,a1
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   S3MGZBossTrans_PartnerRecoveryReturn
                move.w  #$12,(Tails_CPU_routine).w
                tst.w   $30(a0)
                bne.s   S3MGZBossTrans_PartnerRecoveryReturn
                move.w  d0,y_pos(a1)
                move.b  #2,routine(a1)
                move.b  #0,object_control(a1)
                move.b  #0,spin_dash_flag(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  #$14,(Tails_CPU_routine).w

S3MGZBossTrans_PartnerRecoveryReturn:
                rts
; ---------------------------------------------------------------------------

S3MGZBossTrans_InitSoloTailsRecovery:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$40,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$100,d0
                move.w  d0,y_pos(a0)
                move.w  #$168,$30(a0)
                move.l  #S3MGZBossTrans_TickSoloTailsDelay,(a0)

S3MGZBossTrans_TickSoloTailsDelay:
                subq.w  #1,$30(a0)
                bne.s   S3MGZBossTrans_TryClampSoloTailsY
                move.l  #S3MGZBossTrans_TryClampSoloTailsY,(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)

S3MGZBossTrans_TryClampSoloTailsY:
                lea     (Player_1).w,a1
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   S3MGZBossTrans_SoloTailsReturn
                move.w  d0,y_pos(a1)
                addq.w  #8,y_pos(a1)
                tst.w   $30(a0)
                bne.s   S3MGZBossTrans_SoloTailsReturn
                move.w  d0,y_pos(a1)
                move.b  #2,routine(a1)
                move.b  #0,object_control(a1)
                move.b  #0,spin_dash_flag(a1)
                move.w  #$1A,(Tails_CPU_routine).w

S3MGZBossTrans_SoloTailsReturn:
                rts
