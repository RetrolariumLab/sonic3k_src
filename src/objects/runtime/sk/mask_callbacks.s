; Owner: objects/runtime/sk
; Responsibility: Sprite mask actors, facing or parent-state helpers and second-player input locking callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SpriteMask:
                bset    #2,render_flags(a0)

SpriteMask_InitializeMappingsAndSubtype:
                clr.w   art_tile(a0)
                move.l  #Map_SpriteMask,mappings(a0)
                move.b  #$20,width_pixels(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.l  #SpriteMask_SetGlobalFlagAndTestOnScreen,(a0)
                btst    #3,d0
                beq.s   SpriteMask_SelectHeightFrameAndPriority
                move.l  #SpriteMask_DrawUntilParentFlagFive,(a0)

SpriteMask_SelectHeightFrameAndPriority:
                move.w  d0,d1
                andi.w  #$F0,d0
                lsr.w   #2,d0
                move.b  d0,height_pixels(a0)
                lsr.w   #2,d0
                move.b  d0,mapping_frame(a0)
                andi.w  #7,d1
                add.w   d1,d1
                move.w  SpriteMask_PriorityBySubtypeLowBits(pc,d1.w),priority(a0)
                rts
; ---------------------------------------------------------------------------

SpriteMask_SetGlobalFlagAndTestOnScreen:
                st      (Spritemask_flag).w
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SpriteMask_DrawUntilParentFlagFive:
                st      (Spritemask_flag).w
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   SpriteMask_DeleteForParentFlagFive
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SpriteMask_DeleteForParentFlagFive:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
SpriteMask_PriorityBySubtypeLowBits:
                dc.w    0,   $80,  $100,  $180,  $200,  $280,  $300,  $380
; ---------------------------------------------------------------------------

; Always set Right in both bytes. While the timer runs, keep A held without pressing it again
SKInput_BuildAutoRightAndJump:
                move.w  #(button_right_mask<<8)|button_right_mask,d0
                tst.w   $2E(a0)
                beq.s   SKInput_PressJumpIfPushing
                subq.w  #1,$2E(a0)
                move.w  #((button_A_mask|button_right_mask)<<8)|button_right_mask,d0

SKInput_PressJumpIfPushing:
                btst    #5,(Player_1+status).w
                beq.s   SKInput_StoreAutoP1Input
                move.w  #$1F,$2E(a0)
                move.w  #((button_A_mask|button_right_mask)<<8)|(button_A_mask|button_right_mask),d0

SKInput_StoreAutoP1Input:
                move.w  d0,(Ctrl_1_logical).w
                rts

; =============== S U B R O U T I N E =======================================

LaunchPlayerWithSpringVelocity:
                move.w  d0,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function LaunchPlayerWithSpringVelocity

; =============== S U B R O U T I N E =======================================

FacePlayersTowardObject:
                lea     (Player_1).w,a1
                bsr.w   FacePlayerTowardObject
                lea     (Player_2).w,a1
                tst.b   render_flags(a1)
                bpl.s   SKFacePlayers_Return
; End of function FacePlayersTowardObject

; =============== S U B R O U T I N E =======================================

FacePlayerTowardObject:
                move.w  x_pos(a0),d0
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                cmp.w   x_pos(a1),d0
                bhs.s   SKFacePlayers_Return
                bset    #0,render_flags(a1)
                bset    #Status_Facing,status(a1)

SKFacePlayers_Return:
                rts
; End of function FacePlayerTowardObject

; ---------------------------------------------------------------------------

SKInput_LockP2IfActive:
                tst.l   (Player_2).w
                beq.s   SKInput_DeleteP2LockActor
                move.b  #1,(Ctrl_2_locked).w
                clr.w   (Tails_CPU_idle_timer).w
                move.l  #SKInput_ClearP2WhileLocked,(a0)

SKInput_ClearP2WhileLocked:
                tst.b   (Ctrl_2_locked).w
                beq.s   SKInput_ClearP2OnUnlock
                clr.w   (Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

SKInput_ClearP2OnUnlock:
                clr.w   (Ctrl_2).w

SKInput_DeleteP2LockActor:
                jmp     (Delete_Current_Sprite).l
; End of function SKInput_LockP2IfActive
