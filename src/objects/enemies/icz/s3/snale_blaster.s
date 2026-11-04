; Owner: objects/enemies/icz/s3
; Responsibility: Snale Blaster locomotion and projectile states with private child or object resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SnaleBlaster:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SnaleBlaster_Index(pc,d0.w),d1
                jsr     SnaleBlaster_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
SnaleBlaster_Index:
                dc.w    S3SnaleBlaster_InitAndSpawnChildren-SnaleBlaster_Index
                dc.w    S3SnaleBlaster_SetContactForWindow-SnaleBlaster_Index
                dc.w    S3SnaleBlaster_SetContactAndAnimateOpen-SnaleBlaster_Index
                dc.w    S3SnaleBlaster_CheckRollAndAnimateMove-SnaleBlaster_Index
                dc.w    S3SnaleBlaster_AnimateRetraction-SnaleBlaster_Index
                dc.w    S3SnaleBlaster_TickRetractedHold-SnaleBlaster_Index
                dc.w    S3SnaleBlaster_TickReemergenceWait-SnaleBlaster_Index
; ---------------------------------------------------------------------------

S3SnaleBlaster_InitAndSpawnChildren:
                lea     ObjDat_SnaleBlaster(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #$20,$2E(a0)
                move.l  #S3SnaleBlaster_BeginOpening,$34(a0)
                lea     S3SnaleBlaster_EmitterAndVisualChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

S3SnaleBlaster_SetContactForWindow:
                move.b  #$1A,collision_flags(a0)
                clr.b   collision_property(a0)
                btst    #1,$38(a0)
                bne.s   S3SnaleBlaster_TickWindowWait
                move.b  #$7F,collision_property(a0)

S3SnaleBlaster_TickWindowWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3SnaleBlaster_BeginOpening:
                move.b  #4,routine(a0)
                move.l  #S3SnaleBlaster_OpeningAnim,$30(a0)
                move.l  #S3SnaleBlaster_BeginUpwardMotion,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3SnaleBlaster_SetContactAndAnimateOpen:
                move.b  #$1A,collision_flags(a0)
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

S3SnaleBlaster_BeginUpwardMotion:
                move.w  #-2,$40(a0)
                move.l  #S3SnaleBlaster_VerticalMoveAnim,$30(a0)

S3SnaleBlaster_ResetMotionAndWindow:
                move.b  #6,routine(a0)
                move.b  #2,$39(a0)
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

S3SnaleBlaster_CheckRollAndAnimateMove:
                move.b  #$1A,collision_flags(a0)
                move.b  #$7F,collision_property(a0)
                bsr.w   SnaleBlaster_TryRetractNearRoll
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   S3SnaleBlaster_MotionEventReturn
                moveq   #3,d0
                tst.w   $40(a0)
                bmi.s   S3SnaleBlaster_StepYOnMatchingFrame
                moveq   #4,d0

S3SnaleBlaster_StepYOnMatchingFrame:
                cmp.b   mapping_frame(a0),d0
                bne.s   S3SnaleBlaster_MotionEventReturn
                move.w  $40(a0),d0
                add.w   d0,y_pos(a0)
                subq.b  #1,$39(a0)
                bmi.s   S3SnaleBlaster_OpenWindowAndReverseY

S3SnaleBlaster_MotionEventReturn:
                rts
; ---------------------------------------------------------------------------

S3SnaleBlaster_OpenWindowAndReverseY:
                move.b  #2,routine(a0)
                move.w  #$90,$2E(a0)
                bset    #1,$38(a0)
                move.l  #S3SnaleBlaster_ResetMotionAndWindow,$34(a0)
                neg.w   $40(a0)
                rts
; ---------------------------------------------------------------------------

S3SnaleBlaster_AnimateRetraction:
                move.b  #$7F,collision_property(a0)
                subq.b  #1,mapping_frame(a0)
                beq.s   S3SnaleBlaster_BeginRetractedHold
                rts
; ---------------------------------------------------------------------------

S3SnaleBlaster_BeginRetractedHold:
                move.b  #$A,routine(a0)
                move.b  #$7F,collision_property(a0)
                move.w  #60-1,$2E(a0)
                move.l  #S3SnaleBlaster_BeginReemergence,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3SnaleBlaster_TickRetractedHold:
                move.b  #$7F,collision_property(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3SnaleBlaster_BeginReemergence:
                move.b  #$C,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #S3SnaleBlaster_StepReemergence,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3SnaleBlaster_TickReemergenceWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3SnaleBlaster_StepReemergence:
                move.b  #$1A,collision_flags(a0)
                move.b  #$7F,collision_property(a0)
                move.w  #2,$2E(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   S3SnaleBlaster_ReemergenceReturn
                move.b  #6,routine(a0)

S3SnaleBlaster_ReemergenceReturn:
                rts
; ---------------------------------------------------------------------------

S3SnaleBlaster_UpdateVisualChild:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3SnaleBlaster_VisualStateTable(pc,d0.w),d1
                jsr     S3SnaleBlaster_VisualStateTable(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
S3SnaleBlaster_VisualStateTable:
                dc.w    S3SnaleBlaster_InitVisualChild-S3SnaleBlaster_VisualStateTable
                dc.w    S3SnaleBlaster_WaitVisualWindow-S3SnaleBlaster_VisualStateTable
                dc.w    Animate_RawMultiDelay-S3SnaleBlaster_VisualStateTable
; ---------------------------------------------------------------------------

S3SnaleBlaster_InitVisualChild:
                lea     S3SnaleBlaster_VisualAttrs(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

S3SnaleBlaster_WaitVisualWindow:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   S3SnaleBlaster_BeginVisualWindowAnim
                rts
; ---------------------------------------------------------------------------

S3SnaleBlaster_BeginVisualWindowAnim:
                move.b  #4,routine(a0)
                move.l  #S3SnaleBlaster_VisualWindowAnim,$30(a0)
                move.l  #S3SnaleBlaster_ClearParentWindow,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3SnaleBlaster_ClearParentWindow:
                move.b  #2,routine(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

S3SnaleBlaster_UpdateEmitter:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3SnaleBlaster_EmitterStateTable(pc,d0.w),d1
                jsr     S3SnaleBlaster_EmitterStateTable(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
S3SnaleBlaster_EmitterStateTable:
                dc.w    S3SnaleBlaster_InitEmitter-S3SnaleBlaster_EmitterStateTable
                dc.w    S3SnaleBlaster_WaitEmitterWindow-S3SnaleBlaster_EmitterStateTable
                dc.w    S3SnaleBlaster_AnimateAndTryFire-S3SnaleBlaster_EmitterStateTable
                dc.w    S3SnaleBlaster_WaitEmitterClose-S3SnaleBlaster_EmitterStateTable
; ---------------------------------------------------------------------------

S3SnaleBlaster_InitEmitter:
                lea     S3SnaleBlaster_EmitterAttrs(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

S3SnaleBlaster_WaitEmitterWindow:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   S3SnaleBlaster_SelectStaggeredFireAnim
                rts
; ---------------------------------------------------------------------------

S3SnaleBlaster_SelectStaggeredFireAnim:
                move.b  #4,routine(a0)
                move.l  #S3SnaleBlaster_FirstEmitterAnim,$30(a0)
                tst.b   subtype(a0)
                beq.s   S3SnaleBlaster_SetFireFinishCallback
                move.l  #S3SnaleBlaster_DelayedEmitterAnim,$30(a0)

S3SnaleBlaster_SetFireFinishCallback:
                move.l  #S3SnaleBlaster_BeginEmitterCloseWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

; Try a shot on a positive animation event at cursor 4 while visible
S3SnaleBlaster_AnimateAndTryFire:
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   S3SnaleBlaster_ShotReturn
                bmi.s   S3SnaleBlaster_ShotReturn
                cmpi.b  #4,anim_frame(a0)
                bne.s   S3SnaleBlaster_ShotReturn
                tst.b   render_flags(a0)
                bpl.s   S3SnaleBlaster_ShotReturn
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     S3SnaleBlaster_StraightShotChild(pc),a2
                jsr     CreateChild2_Complex(pc)
                movea.w parent3(a0),a2
                btst    #0,render_flags(a2)
                beq.s   S3SnaleBlaster_TryReflectShotY
                neg.w   x_vel(a1)

; Like the X reflection above, this uses a1 without checking projectile allocation
S3SnaleBlaster_TryReflectShotY:
                tst.b   subtype(a0)
                beq.s   S3SnaleBlaster_ShotReturn
                neg.w   y_vel(a1)

S3SnaleBlaster_ShotReturn:
                rts
; ---------------------------------------------------------------------------

S3SnaleBlaster_BeginEmitterCloseWait:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3SnaleBlaster_WaitEmitterClose:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   S3SnaleBlaster_RearmEmitter
                rts
; ---------------------------------------------------------------------------

S3SnaleBlaster_RearmEmitter:
                move.b  #2,routine(a0)
                rts

; =============== S U B R O U T I N E =======================================

; Require the horizontally nearest player to be rolling with both separations below $30. Skip the rest of the current movement state on success
SnaleBlaster_TryRetractNearRoll:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$30,d2
                bhs.s   S3SnaleBlaster_RollingCheckReturn
                cmpi.w  #$30,d3
                bhs.s   S3SnaleBlaster_RollingCheckReturn
                cmpi.b  #2,anim(a1)
                beq.s   S3SnaleBlaster_RetractAndSkipMotion

S3SnaleBlaster_RollingCheckReturn:
                rts
; ---------------------------------------------------------------------------

; Discard the caller's return address so movement and animation stop for this update
S3SnaleBlaster_RetractAndSkipMotion:
                move.b  #8,routine(a0)
                move.b  #3,mapping_frame(a0)
                addq.w  #4,sp
                rts
; End of function SnaleBlaster_TryRetractNearRoll

; ---------------------------------------------------------------------------
ObjDat_SnaleBlaster:
                dc.l    Map_SnaleBlaster
                dc.w    make_art_tile(ArtTile_SnaleBlaster,1,0)
                dc.w    $200
                dc.b    $10, $10,   0,  $B
S3SnaleBlaster_VisualAttrs:
                dc.w    $180
                dc.b    4,  $C,   5,   0
S3SnaleBlaster_EmitterAttrs:
                dc.w    $200
                dc.b    4,   4,   7,   0
S3SnaleBlaster_ProjectileAttrs:
                dc.l    Map_SnaleBlaster
                dc.w    make_art_tile(ArtTile_SnaleBlaster,0,1)
                dc.w    $200
                dc.b    4,   4,   9, $98
S3SnaleBlaster_EmitterAndVisualChildren:
                dc.w    3-1
                dc.l    S3SnaleBlaster_UpdateEmitter
                dc.b    -8,   0
                dc.l    S3SnaleBlaster_UpdateEmitter
                dc.b    -8,   7
                dc.l    S3SnaleBlaster_UpdateVisualChild
                dc.b    -8,   4
S3SnaleBlaster_StraightShotChild:
                dc.w    1-1
                dc.l    S3CallbackShot_InitDeflectable
                dc.l    S3SnaleBlaster_ProjectileAttrs
                dc.l    0
                dc.l    MoveSprite2
                dc.b    0,   0
                dc.w    -$200, -$100
S3SnaleBlaster_OpeningAnim:
                dc.b    5,   0,   1,   2,   3,   4,   4,   4,   4, $F4
S3SnaleBlaster_VerticalMoveAnim:
                dc.b    4,  $F
                dc.b    3,  $F
                dc.b    $FC
S3SnaleBlaster_VisualWindowAnim:
                dc.b    5,   2
                dc.b    6,   2
                dc.b    $A, $5F
                dc.b    6,   2
                dc.b    5,   2
                dc.b    $F4
S3SnaleBlaster_FirstEmitterAnim:
                dc.b    7,   2
                dc.b    7, $1F
                dc.b    8,   3
                dc.b    7,   0
                dc.b    $F4
S3SnaleBlaster_DelayedEmitterAnim:
                dc.b    7,   2
                dc.b    7, $2F
                dc.b    8,   3
                dc.b    7,   0
                dc.b    $F4
                even
