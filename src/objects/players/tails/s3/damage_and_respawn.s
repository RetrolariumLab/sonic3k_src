; Owner: objects/players/tails/s3
; Responsibility: Tails hurt, death, restart and recovery animation dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

loc_1620A:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_16222
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

loc_16222:
                jsr     (MoveSprite2).l
                addi.w  #$30,y_vel(a0)
                btst    #Status_Underwater,status(a0)
                beq.s   loc_1623C
                subi.w  #$20,y_vel(a0)

loc_1623C:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_1624C
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_1624C:
                bsr.w   TailsS3ResolveHurtLandingOrDeathPlane
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Sonic_RecordPos
                bsr.w   TailsS3AnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

TailsS3ResolveHurtLandingOrDeathPlane:
                tst.b   (Disable_death_plane).w
                bne.s   loc_16278
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.w   loc_162BE

loc_16278:
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                btst    #Status_InAir,status(a0)
                bne.s   locret_162BC
                moveq   #0,d0
                move.w  d0,y_vel(a0)
                move.w  d0,x_vel(a0)
                move.w  d0,ground_vel(a0)
                move.b  d0,object_control(a0)
                move.b  #0,anim(a0)
                move.w  #$100,priority(a0)
                move.b  #2,routine(a0)
                move.b  #2*60,invulnerability_timer(a0)
                move.b  #0,spin_dash_flag(a0)

locret_162BC:
                rts
; ---------------------------------------------------------------------------

loc_162BE:
                jmp     (Kill_Character).l
; End of function TailsS3ResolveHurtLandingOrDeathPlane

; ---------------------------------------------------------------------------

loc_162C4:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_162DC
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

loc_162DC:
                bsr.w   PlayerS3FinishDeathWithFollowerResetRestartOrCompetitionRespawn
                jsr     (MoveSprite).l
                bsr.w   Sonic_RecordPos
                bsr.w   TailsS3AnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_162F4:
                tst.w   $3E(a0)
                beq.s   locret_16306
                subq.w  #1,$3E(a0)
                bne.s   locret_16306
                move.w  #1,(Restart_level_flag).w

locret_16306:
                rts
; ---------------------------------------------------------------------------

loc_16308:
                tst.w   (H_scroll_amount_P2).w
                bne.s   loc_1631A
                tst.w   (V_scroll_amount_P2).w
                bne.s   loc_1631A
                move.b  #2,routine(a0)

loc_1631A:
                bsr.w   TailsS3AnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_16324:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_1633C
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

loc_1633C:
                jsr     (MoveSprite2).l
                addi.w  #$10,y_vel(a0)
                bsr.w   Sonic_RecordPos
                bsr.w   TailsS3AnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

TailsS3AnimateRecoveryStateAndDispatchPatternLoader:
                tst.w   (Competition_mode).w
                bne.s   loc_16362
                bsr.s   Animate_Tails
                bra.w   Tails_Load_PLC
; ---------------------------------------------------------------------------

loc_16362:
                bsr.w   Animate_Tails2P
                bra.w   Tails2P_Load_PLC
; End of function TailsS3AnimateRecoveryStateAndDispatchPatternLoader
