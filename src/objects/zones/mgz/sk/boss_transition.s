; Owner: objects/zones/mgz/sk
; Responsibility: Marble Garden boss transition controller, partner recovery and player carrying setup
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_MGZ2_BossTransition:
                cmpi.w  #2,(Player_mode).w
                beq.w   SKMGZBossTrans_InitSoloTailsRecovery
                move.w  (Camera_X_pos).w,d0
                addi.w  #$40,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$100,d0
                move.w  d0,y_pos(a0)
                lea     (Player_2).w,a1
                tst.b   render_flags(a1)
                bmi.s   SKMGZBossTrans_BeginPartnerRecovery
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subq.w  #1,y_pos(a1)
                move.l  #Obj_Tails,(Player_2).w
                move.w  #$12,(Tails_CPU_routine).w
                move.w  #0,(Flying_carrying_Sonic_flag).w

SKMGZBossTrans_BeginPartnerRecovery:
                move.w  #$168,$30(a0)
                move.l  #SKMGZBossTrans_TickPartnerRecovery,(a0)

SKMGZBossTrans_TickPartnerRecovery:
                subq.w  #1,$30(a0)
                bne.s   SKMGZBossTrans_TryClampUncarriedP1
                move.l  #SKMGZBossTrans_TryClampUncarriedP1,(a0)

SKMGZBossTrans_TryClampUncarriedP1:
                tst.b   (Flying_carrying_Sonic_flag).w
                bne.s   SKMGZBossTrans_TryRecoverP2
                lea     (Player_1).w,a1
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   SKMGZBossTrans_TryRecoverP2
                move.w  d0,y_pos(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #0,spin_dash_flag(a1)
                cmpi.w  #$14,(Tails_CPU_routine).w
                blo.s   SKMGZBossTrans_RestoreP1Routine
                move.w  x_pos(a1),x_pos(a0)

SKMGZBossTrans_RestoreP1Routine:
                move.b  #2,routine(a1)

SKMGZBossTrans_TryRecoverP2:
                tst.b   (Player_1+render_flags).w
                bmi.s   SKMGZBossTrans_PartnerRecoveryReturn
                cmpi.b  #2,(Player_1+routine).w
                bne.s   SKMGZBossTrans_PartnerRecoveryReturn
                lea     (Player_2).w,a1
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   SKMGZBossTrans_PartnerRecoveryReturn
                move.w  #$12,(Tails_CPU_routine).w
                tst.w   $30(a0)
                bne.s   SKMGZBossTrans_PartnerRecoveryReturn
                move.w  d0,y_pos(a1)
                move.b  #2,routine(a1)
                move.b  #0,object_control(a1)
                move.b  #0,spin_dash_flag(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  #$14,(Tails_CPU_routine).w

SKMGZBossTrans_PartnerRecoveryReturn:
                rts
; ---------------------------------------------------------------------------

SKMGZBossTrans_InitSoloTailsRecovery:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$40,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$100,d0
                move.w  d0,y_pos(a0)
                move.w  #$168,$30(a0)
                move.l  #SKMGZBossTrans_TickSoloTailsDelay,(a0)

SKMGZBossTrans_TickSoloTailsDelay:
                subq.w  #1,$30(a0)
                bne.s   SKMGZBossTrans_TryClampSoloTailsY
                move.l  #SKMGZBossTrans_TryClampSoloTailsY,(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)

SKMGZBossTrans_TryClampSoloTailsY:
                lea     (Player_1).w,a1
                move.w  y_pos(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   SKMGZBossTrans_SoloTailsReturn
                move.w  d0,y_pos(a1)
                addq.w  #8,y_pos(a1)
                tst.w   $30(a0)
                bne.s   SKMGZBossTrans_SoloTailsReturn
                move.w  d0,y_pos(a1)
                move.b  #2,routine(a1)
                move.b  #0,object_control(a1)
                move.b  #0,spin_dash_flag(a1)
                move.w  #$1A,(Tails_CPU_routine).w

SKMGZBossTrans_SoloTailsReturn:
                rts
