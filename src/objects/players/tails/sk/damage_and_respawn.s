; Owner: objects/players/tails/sk
; Responsibility: Tails hurt, death, restart and recovery animation dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

SKTailsRecovery_CheckHurtDebugEntry:
                cmpi.w  #2,(Player_mode).w
                bne.s   SKTailsRecovery_ReleaseRiderOnHurt
                tst.w   (Debug_mode_flag).w
                beq.s   SKTailsRecovery_ReleaseRiderOnHurt
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKTailsRecovery_ReleaseRiderOnHurt
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKTailsRecovery_ReleaseRiderOnHurt:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsRecovery_MoveHurtAndApplyGravity
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

SKTailsRecovery_MoveHurtAndApplyGravity:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$30,y_vel(a0)
                btst    #Status_Underwater,status(a0)
                beq.s   SKTailsRecovery_WrapHurtYIfEnabled
                subi.w  #$20,y_vel(a0)

SKTailsRecovery_WrapHurtYIfEnabled:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   SKTailsRecovery_ResolveHurtAndDraw
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

SKTailsRecovery_ResolveHurtAndDraw:
                bsr.w   TailsSKResolveHurtLandingOrDeathPlane
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Sonic_RecordPos
                bsr.w   SKTails_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

TailsSKResolveHurtLandingOrDeathPlane:
                tst.b   (Disable_death_plane).w
                bne.s   SKTailsRecovery_CheckHurtLandingAndReset
                tst.b   (Reverse_gravity_flag).w
                bne.s   SKTailsRecovery_CheckReverseDeathPlane
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.w   SKTailsRecovery_KillAtHurtDeathPlane
                bra.s   SKTailsRecovery_CheckHurtLandingAndReset
; ---------------------------------------------------------------------------

SKTailsRecovery_CheckReverseDeathPlane:
                move.w  (Camera_min_Y_pos).w,d0
                cmp.w   y_pos(a0),d0
                blt.s   SKTailsRecovery_CheckHurtLandingAndReset
                bra.w   SKTailsRecovery_KillAtHurtDeathPlane
; ---------------------------------------------------------------------------

SKTailsRecovery_CheckHurtLandingAndReset:
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                btst    #Status_InAir,status(a0)
                bne.s   SKTailsRecovery_HurtLandingReturn
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

SKTailsRecovery_HurtLandingReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsRecovery_KillAtHurtDeathPlane:
                jmp     (Kill_Character).l
; End of function TailsSKResolveHurtLandingOrDeathPlane

; ---------------------------------------------------------------------------

SKTailsRecovery_CheckDeathDebugEntry:
                cmpi.w  #2,(Player_mode).w
                bne.s   SKTailsRecovery_ReleaseRiderOnDeath
                tst.w   (Debug_mode_flag).w
                beq.s   SKTailsRecovery_ReleaseRiderOnDeath
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   SKTailsRecovery_ReleaseRiderOnDeath
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

SKTailsRecovery_ReleaseRiderOnDeath:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsRecovery_ResolveDeathAndDraw
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

SKTailsRecovery_ResolveDeathAndDraw:
                bsr.w   SKPlayer_FinishDeath
                jsr     (MoveSprite_TestGravity).l
                bsr.w   Sonic_RecordPos
                bsr.w   SKTails_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Request the restart on the decrement to zero. An already-zero timer holds
SKTailsRecovery_TickRestartTimer:
                tst.w   $3E(a0)
                beq.s   SKTailsRecovery_RestartReturn
                subq.w  #1,$3E(a0)
                bne.s   SKTailsRecovery_RestartReturn
                move.w  #1,(Restart_level_flag).w

SKTailsRecovery_RestartReturn:
                rts
; ---------------------------------------------------------------------------

SKTailsRecovery_CheckP2ScrollSettled:
                tst.w   (H_scroll_amount_P2).w
                bne.s   SKTailsRecovery_DrawScrollWaitFrame
                tst.w   (V_scroll_amount_P2).w
                bne.s   SKTailsRecovery_DrawScrollWaitFrame
                move.b  #2,routine(a0)

SKTailsRecovery_DrawScrollWaitFrame:
                bsr.w   SKTails_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKTailsRecovery_ReleaseRiderOnDrown:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   SKTailsRecovery_MoveDrowningAndDraw
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

SKTailsRecovery_MoveDrowningAndDraw:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$10,y_vel(a0)
                bsr.w   Sonic_RecordPos
                bsr.w   SKTails_AnimateRecoveryAndLoadArt
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Dispatch to the competition animation and pattern loader when enabled. Normal mode mirrors the vertical render flag under reverse gravity
SKTails_AnimateRecoveryAndLoadArt:
                tst.w   (Competition_mode).w
                bne.s   SKTailsRecovery_AnimateCompAndLoadArt
                bsr.s   Animate_Tails
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKTailsRecovery_LoadRecoveryPatterns
                eori.b  #2,render_flags(a0)

SKTailsRecovery_LoadRecoveryPatterns:
                bra.w   Tails_Load_PLC
; ---------------------------------------------------------------------------

SKTailsRecovery_AnimateCompAndLoadArt:
                bsr.w   Animate_Tails2P
                bra.w   Tails2P_Load_PLC
; End of function SKTails_AnimateRecoveryAndLoadArt
