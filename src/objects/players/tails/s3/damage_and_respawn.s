; Owner: objects/players/tails/s3
; Responsibility: Tails hurt, death, restart and recovery animation dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

S3TailsRecovery_ReleaseRiderOnHurt:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3TailsRecovery_MoveHurtAndApplyGravity
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

S3TailsRecovery_MoveHurtAndApplyGravity:
                jsr     (MoveSprite2).l
                addi.w  #$30,y_vel(a0)
                btst    #Status_Underwater,status(a0)
                beq.s   S3TailsRecovery_WrapHurtYIfEnabled
                subi.w  #$20,y_vel(a0)

S3TailsRecovery_WrapHurtYIfEnabled:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   S3TailsRecovery_ResolveHurtAndDraw
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

S3TailsRecovery_ResolveHurtAndDraw:
                bsr.w   TailsS3ResolveHurtLandingOrDeathPlane
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Sonic_RecordPos
                bsr.w   TailsS3AnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

TailsS3ResolveHurtLandingOrDeathPlane:
                tst.b   (Disable_death_plane).w
                bne.s   S3TailsRecovery_CheckHurtLandingAndReset
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.w   S3TailsRecovery_KillAtHurtDeathPlane

S3TailsRecovery_CheckHurtLandingAndReset:
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                btst    #Status_InAir,status(a0)
                bne.s   S3TailsRecovery_HurtLandingReturn
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

S3TailsRecovery_HurtLandingReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsRecovery_KillAtHurtDeathPlane:
                jmp     (Kill_Character).l
; End of function TailsS3ResolveHurtLandingOrDeathPlane

; ---------------------------------------------------------------------------

S3TailsRecovery_ReleaseRiderOnDeath:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3TailsRecovery_ResolveDeathAndDraw
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

S3TailsRecovery_ResolveDeathAndDraw:
                bsr.w   PlayerS3FinishDeathWithFollowerResetRestartOrCompetitionRespawn
                jsr     (MoveSprite).l
                bsr.w   Sonic_RecordPos
                bsr.w   TailsS3AnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Request the restart on the decrement to zero. An already-zero timer holds
S3TailsRecovery_TickRestartTimer:
                tst.w   $3E(a0)
                beq.s   S3TailsRecovery_RestartReturn
                subq.w  #1,$3E(a0)
                bne.s   S3TailsRecovery_RestartReturn
                move.w  #1,(Restart_level_flag).w

S3TailsRecovery_RestartReturn:
                rts
; ---------------------------------------------------------------------------

S3TailsRecovery_CheckP2ScrollSettled:
                tst.w   (H_scroll_amount_P2).w
                bne.s   S3TailsRecovery_DrawScrollWaitFrame
                tst.w   (V_scroll_amount_P2).w
                bne.s   S3TailsRecovery_DrawScrollWaitFrame
                move.b  #2,routine(a0)

S3TailsRecovery_DrawScrollWaitFrame:
                bsr.w   TailsS3AnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3TailsRecovery_ReleaseRiderOnDrown:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   S3TailsRecovery_MoveDrowningAndDraw
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

S3TailsRecovery_MoveDrowningAndDraw:
                jsr     (MoveSprite2).l
                addi.w  #$10,y_vel(a0)
                bsr.w   Sonic_RecordPos
                bsr.w   TailsS3AnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

TailsS3AnimateRecoveryStateAndDispatchPatternLoader:
                tst.w   (Competition_mode).w
                bne.s   S3TailsRecovery_AnimateCompAndLoadArt
                bsr.s   Animate_Tails
                bra.w   Tails_Load_PLC
; ---------------------------------------------------------------------------

S3TailsRecovery_AnimateCompAndLoadArt:
                bsr.w   Animate_Tails2P
                bra.w   Tails2P_Load_PLC
; End of function TailsS3AnimateRecoveryStateAndDispatchPatternLoader
