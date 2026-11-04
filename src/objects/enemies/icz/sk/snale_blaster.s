; Owner: objects/enemies/icz/sk
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
                dc.w    SKSnaleBlaster_InitAndSpawnChildren-SnaleBlaster_Index
                dc.w    SKSnaleBlaster_SetContactForWindow-SnaleBlaster_Index
                dc.w    SKSnaleBlaster_SetContactAndAnimateOpen-SnaleBlaster_Index
                dc.w    SKSnaleBlaster_CheckRollAndAnimateMove-SnaleBlaster_Index
                dc.w    SKSnaleBlaster_AnimateRetraction-SnaleBlaster_Index
                dc.w    SKSnaleBlaster_TickRetractedHold-SnaleBlaster_Index
                dc.w    SKSnaleBlaster_TickReemergenceWait-SnaleBlaster_Index
; ---------------------------------------------------------------------------

SKSnaleBlaster_InitAndSpawnChildren:
                lea     ObjDat_SnaleBlaster(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #$20,$2E(a0)
                move.l  #SKSnaleBlaster_BeginOpening,$34(a0)
                lea     SKSnaleBlaster_EmitterAndVisualChildren(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

SKSnaleBlaster_SetContactForWindow:
                move.b  #$1A,collision_flags(a0)
                clr.b   collision_property(a0)
                btst    #1,$38(a0)
                bne.s   SKSnaleBlaster_TickWindowWait
                move.b  #$7F,collision_property(a0)

SKSnaleBlaster_TickWindowWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKSnaleBlaster_BeginOpening:
                move.b  #4,routine(a0)
                move.l  #SKSnaleBlaster_OpeningAnim,$30(a0)
                move.l  #SKSnaleBlaster_BeginUpwardMotion,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKSnaleBlaster_SetContactAndAnimateOpen:
                move.b  #$1A,collision_flags(a0)
                jmp     Animate_Raw(pc)
; ---------------------------------------------------------------------------

SKSnaleBlaster_BeginUpwardMotion:
                move.w  #-2,$40(a0)
                move.l  #SKSnaleBlaster_VerticalMoveAnim,$30(a0)

SKSnaleBlaster_ResetMotionAndWindow:
                move.b  #6,routine(a0)
                move.b  #2,$39(a0)
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKSnaleBlaster_CheckRollAndAnimateMove:
                move.b  #$1A,collision_flags(a0)
                move.b  #$7F,collision_property(a0)
                bsr.w   SnaleBlaster_TryRetractNearRoll
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   SKSnaleBlaster_MotionEventReturn
                moveq   #3,d0
                tst.w   $40(a0)
                bmi.s   SKSnaleBlaster_StepYOnMatchingFrame
                moveq   #4,d0

SKSnaleBlaster_StepYOnMatchingFrame:
                cmp.b   mapping_frame(a0),d0
                bne.s   SKSnaleBlaster_MotionEventReturn
                move.w  $40(a0),d0
                add.w   d0,y_pos(a0)
                subq.b  #1,$39(a0)
                bmi.s   SKSnaleBlaster_OpenWindowAndReverseY

SKSnaleBlaster_MotionEventReturn:
                rts
; ---------------------------------------------------------------------------

SKSnaleBlaster_OpenWindowAndReverseY:
                move.b  #2,routine(a0)
                move.w  #$90,$2E(a0)
                bset    #1,$38(a0)
                move.l  #SKSnaleBlaster_ResetMotionAndWindow,$34(a0)
                neg.w   $40(a0)
                rts
; ---------------------------------------------------------------------------

SKSnaleBlaster_AnimateRetraction:
                move.b  #$7F,collision_property(a0)
                subq.b  #1,mapping_frame(a0)
                beq.s   SKSnaleBlaster_BeginRetractedHold
                rts
; ---------------------------------------------------------------------------

SKSnaleBlaster_BeginRetractedHold:
                move.b  #$A,routine(a0)
                move.b  #$7F,collision_property(a0)
                move.w  #60-1,$2E(a0)
                move.l  #SKSnaleBlaster_BeginReemergence,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKSnaleBlaster_TickRetractedHold:
                move.b  #$7F,collision_property(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKSnaleBlaster_BeginReemergence:
                move.b  #$C,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #SKSnaleBlaster_StepReemergence,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKSnaleBlaster_TickReemergenceWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKSnaleBlaster_StepReemergence:
                move.b  #$1A,collision_flags(a0)
                move.b  #$7F,collision_property(a0)
                move.w  #2,$2E(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   SKSnaleBlaster_ReemergenceReturn
                move.b  #6,routine(a0)

SKSnaleBlaster_ReemergenceReturn:
                rts
; ---------------------------------------------------------------------------

SKSnaleBlaster_UpdateVisualChild:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKSnaleBlaster_VisualStateTable(pc,d0.w),d1
                jsr     SKSnaleBlaster_VisualStateTable(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
SKSnaleBlaster_VisualStateTable:
                dc.w    SKSnaleBlaster_InitVisualChild-SKSnaleBlaster_VisualStateTable
                dc.w    SKSnaleBlaster_WaitVisualWindow-SKSnaleBlaster_VisualStateTable
                dc.w    Animate_RawMultiDelay-SKSnaleBlaster_VisualStateTable
; ---------------------------------------------------------------------------

SKSnaleBlaster_InitVisualChild:
                lea     SKSnaleBlaster_VisualAttrs(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

SKSnaleBlaster_WaitVisualWindow:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   SKSnaleBlaster_BeginVisualWindowAnim
                rts
; ---------------------------------------------------------------------------

SKSnaleBlaster_BeginVisualWindowAnim:
                move.b  #4,routine(a0)
                move.l  #SKSnaleBlaster_VisualWindowAnim,$30(a0)
                move.l  #SKSnaleBlaster_ClearParentWindow,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKSnaleBlaster_ClearParentWindow:
                move.b  #2,routine(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

SKSnaleBlaster_UpdateEmitter:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKSnaleBlaster_EmitterStateTable(pc,d0.w),d1
                jsr     SKSnaleBlaster_EmitterStateTable(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
SKSnaleBlaster_EmitterStateTable:
                dc.w    SKSnaleBlaster_InitEmitter-SKSnaleBlaster_EmitterStateTable
                dc.w    SKSnaleBlaster_WaitEmitterWindow-SKSnaleBlaster_EmitterStateTable
                dc.w    SKSnaleBlaster_AnimateAndTryFire-SKSnaleBlaster_EmitterStateTable
                dc.w    SKSnaleBlaster_WaitEmitterClose-SKSnaleBlaster_EmitterStateTable
; ---------------------------------------------------------------------------

SKSnaleBlaster_InitEmitter:
                lea     SKSnaleBlaster_EmitterAttrs(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

SKSnaleBlaster_WaitEmitterWindow:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   SKSnaleBlaster_SelectStaggeredFireAnim
                rts
; ---------------------------------------------------------------------------

SKSnaleBlaster_SelectStaggeredFireAnim:
                move.b  #4,routine(a0)
                move.l  #SKSnaleBlaster_FirstEmitterAnim,$30(a0)
                tst.b   subtype(a0)
                beq.s   SKSnaleBlaster_SetFireFinishCallback
                move.l  #SKSnaleBlaster_DelayedEmitterAnim,$30(a0)

SKSnaleBlaster_SetFireFinishCallback:
                move.l  #SKSnaleBlaster_BeginEmitterCloseWait,$34(a0)
                rts
; ---------------------------------------------------------------------------

; Try a shot on a positive animation event at cursor 4 while visible
SKSnaleBlaster_AnimateAndTryFire:
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   SKSnaleBlaster_ShotReturn
                bmi.s   SKSnaleBlaster_ShotReturn
                cmpi.b  #4,anim_frame(a0)
                bne.s   SKSnaleBlaster_ShotReturn
                tst.b   render_flags(a0)
                bpl.s   SKSnaleBlaster_ShotReturn
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     SKSnaleBlaster_StraightShotChild(pc),a2
                jsr     (CreateChild2_Complex).l
                movea.w parent3(a0),a2
                btst    #0,render_flags(a2)
                beq.s   SKSnaleBlaster_TryReflectShotY
                neg.w   x_vel(a1)

; Like the X reflection above, this uses a1 without checking projectile allocation
SKSnaleBlaster_TryReflectShotY:
                tst.b   subtype(a0)
                beq.s   SKSnaleBlaster_ShotReturn
                neg.w   y_vel(a1)

SKSnaleBlaster_ShotReturn:
                rts
; ---------------------------------------------------------------------------

SKSnaleBlaster_BeginEmitterCloseWait:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKSnaleBlaster_WaitEmitterClose:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   SKSnaleBlaster_RearmEmitter
                rts
; ---------------------------------------------------------------------------

SKSnaleBlaster_RearmEmitter:
                move.b  #2,routine(a0)
                rts

; =============== S U B R O U T I N E =======================================

; Require the horizontally nearest player to be rolling with both separations below $30. Skip the rest of the current movement state on success
SnaleBlaster_TryRetractNearRoll:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$30,d2
                bhs.s   SKSnaleBlaster_RollingCheckReturn
                cmpi.w  #$30,d3
                bhs.s   SKSnaleBlaster_RollingCheckReturn
                cmpi.b  #2,anim(a1)
                beq.s   SKSnaleBlaster_RetractAndSkipMotion

SKSnaleBlaster_RollingCheckReturn:
                rts
; ---------------------------------------------------------------------------

; Discard the caller's return address so movement and animation stop for this update
SKSnaleBlaster_RetractAndSkipMotion:
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
SKSnaleBlaster_VisualAttrs:
                dc.w    $180
                dc.b    4,  $C,   5,   0
SKSnaleBlaster_EmitterAttrs:
                dc.w    $200
                dc.b    4,   4,   7,   0
SKSnaleBlaster_ProjectileAttrs:
                dc.l    Map_SnaleBlaster
                dc.w    make_art_tile(ArtTile_SnaleBlaster,0,1)
                dc.w    $200
                dc.b    4,   4,   9, $98
SKSnaleBlaster_EmitterAndVisualChildren:
                dc.w    3-1
                dc.l    SKSnaleBlaster_UpdateEmitter
                dc.b    -8,   0
                dc.l    SKSnaleBlaster_UpdateEmitter
                dc.b    -8,   7
                dc.l    SKSnaleBlaster_UpdateVisualChild
                dc.b    -8,   4
SKSnaleBlaster_StraightShotChild:
                dc.w    1-1
                dc.l    SKCallbackShot_InitDeflectable
                dc.l    SKSnaleBlaster_ProjectileAttrs
                dc.l    0
                dc.l    MoveSprite2
                dc.b    0,   0
                dc.w    -$200, -$100
SKSnaleBlaster_OpeningAnim:
                dc.b    5,   0,   1,   2,   3,   4,   4,   4,   4, $F4
SKSnaleBlaster_VerticalMoveAnim:
                dc.b    4,  $F
                dc.b    3,  $F
                dc.b    $FC
SKSnaleBlaster_VisualWindowAnim:
                dc.b    5,   2
                dc.b    6,   2
                dc.b    $A, $5F
                dc.b    6,   2
                dc.b    5,   2
                dc.b    $F4
SKSnaleBlaster_FirstEmitterAnim:
                dc.b    7,   2
                dc.b    7, $1F
                dc.b    8,   3
                dc.b    7,   0
                dc.b    $F4
SKSnaleBlaster_DelayedEmitterAnim:
                dc.b    7,   2
                dc.b    7, $2F
                dc.b    8,   3
                dc.b    7,   0
                dc.b    $F4
                even
