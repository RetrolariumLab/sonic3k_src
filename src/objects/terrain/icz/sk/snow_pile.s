; Owner: objects/terrain/icz/sk
; Responsibility: IceCap snow-pile controller, thrown snow, child helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZSnowPile:
                jsr     Obj_WaitOffscreen(pc)
                moveq   #0,d0
                move.b  subtype(a0),d0
                bclr    #7,d0
                lea     SKICZSnowPile_SubtypeSetupTable(pc),a1
                lea     (a1,d0.w),a2
                move.l  (a2)+,(a0)
                movea.l (a2)+,a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

SKICZSnowPile_UpdatePileContacts:
                lea     SKICZSnowPile_DragPileBounds(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   SKICZSnowPile_DrawIntactPile
                tst.w   d0
                beq.s   SKICZSnowPile_TryP2PileContact
                bsr.w   ApplyIczSnowPileDragOrBreak

SKICZSnowPile_TryP2PileContact:
                swap    d0
                tst.w   d0
                beq.s   SKICZSnowPile_DrawIntactPile
                bsr.w   ApplyIczSnowPileDragOrBreak

SKICZSnowPile_DrawIntactPile:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
SKICZSnowPile_DragPileBounds:
                dc.w    -$28,   $50,  -$18,   $20

; =============== S U B R O U T I N E =======================================

ApplyIczSnowPileDragOrBreak:
                movea.w d0,a3
                move.w  d0,$44(a0)
                cmpi.b  #9,anim(a3)
                beq.s   SKICZSnowPile_BreakAndSkipCaller
                btst    #Status_InAir,status(a3)
                bne.s   SKICZSnowPile_DragReturn
                move.w  x_vel(a3),d2
                move.w  d2,d3
                bpl.s   SKICZSnowPile_BreakOrHalveGroundSpeed
                neg.w   d2

SKICZSnowPile_BreakOrHalveGroundSpeed:
                cmpi.w  #$600,d2
                bhs.s   SKICZSnowPile_BreakAndSkipCaller
                asr.w   #1,d3
                move.w  d3,ground_vel(a3)

SKICZSnowPile_DragReturn:
                rts
; ---------------------------------------------------------------------------

; Discard the caller's return address to skip the remaining contacts and draw
SKICZSnowPile_BreakAndSkipCaller:
                move.w  a3,$44(a0)
                lea     SKICZSnowPile_DragPileFragments(pc),a2
                jsr     CreateChild1_Normal(pc)
                jsr     (Go_Delete_Sprite).l
                addq.w  #4,sp

SKICZSnowPile_BreakOrFlakeReturn:
                rts
; End of function ApplyIczSnowPileDragOrBreak

; ---------------------------------------------------------------------------

SKICZSnowPile_CheckNarrowGateP1:
                lea     SKICZSnowPile_NarrowGateBounds(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.w   d0
                bne.s   SKICZSnowPile_BoostP1ThroughNarrowGate
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

SKICZSnowPile_BoostP1ThroughNarrowGate:
                move.w  d0,$44(a0)
                beq.s   SKICZSnowPile_DeleteNarrowGate
                movea.w d0,a1
                move.w  #$800,x_vel(a1)
                move.w  #$800,ground_vel(a1)
                lea     SKICZSnowPile_NarrowGateFragments(pc),a2
                jsr     CreateChild1_Normal(pc)

SKICZSnowPile_DeleteNarrowGate:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
SKICZSnowPile_NarrowGateBounds:
                dc.w    -8,   $10,  -$10,   $20
; ---------------------------------------------------------------------------

SKICZSnowPile_CheckTransitionGateP1:
                lea     SKICZSnowPile_TransitionGateBounds(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.w   d0
                bne.s   SKICZSnowPile_BoostP1AndTryTransition
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKICZSnowPile_BoostP1AndTryTransition:
                move.w  d0,$44(a0)
                beq.s   SKICZSnowPile_DeleteTransitionGate
                movea.w d0,a1
                move.w  #$800,x_vel(a1)
                move.w  #$800,ground_vel(a1)
                lea     SKICZSnowPile_TransitionGateFragments(pc),a2
                jsr     CreateChild1_Normal(pc)
                btst    #7,subtype(a0)
                beq.s   SKICZSnowPile_DeleteTransitionGate
                move.w  #$600,d0
                jsr     StartNewLevel(pc)

SKICZSnowPile_DeleteTransitionGate:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
SKICZSnowPile_TransitionGateBounds:
                dc.w    -8,   $10,  -$10,   $20
; ---------------------------------------------------------------------------

; Increment the live flake count before attempting allocation
SKICZSnowPile_UpdateCameraSnowEmitter:
                move.w  a0,(SceneActorOrWorldOffset).w
                btst    #5,$38(a0)
                bne.s   SKICZSnowPile_DeleteSnowEmitter
                move.w  (Camera_X_pos_copy).w,x_pos(a0)
                move.w  (Camera_Y_pos_copy).w,y_pos(a0)
                subq.w  #8,y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   SKICZSnowPile_SnowEmitterReturn
                move.w  #8,$2E(a0)
                move.b  (Hyudoro_count).w,d0
                addq.b  #1,d0
                cmpi.b  #$3C,d0
                bhi.s   SKICZSnowPile_SnowEmitterReturn
                move.b  d0,(Hyudoro_count).w
                jsr     (AllocateObject).l
                bne.s   SKICZSnowPile_SnowEmitterReturn
                move.l  #SKICZSnowPile_InitFlakeAndFoldXOffset,(a1)

SKICZSnowPile_SnowEmitterReturn:
                rts
; ---------------------------------------------------------------------------

SKICZSnowPile_DeleteSnowEmitter:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKICZSnowPile_InitFlakeAndFoldXOffset:
                lea     SKICZSnowPile_FlakeAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKICZSnowPile_MoveUntilFirstVisible,(a0)
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                cmpi.w  #$140,d0
                blo.s   SKICZSnowPile_PlaceFlakeAndPickVisual
                andi.w  #$3F,d0
                lsl.w   #2,d0

SKICZSnowPile_PlaceFlakeAndPickVisual:
                add.w   (Camera_X_pos).w,d0
                cmpi.w  #$380,d0
                blo.s   SKICZSnowPile_TryDecrementFlakeCount
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subq.w  #4,d0
                move.w  d0,y_pos(a0)
                swap    d0
                move.w  d0,d1
                andi.w  #3,d0
                move.b  SKICZSnowPile_FlakeFrames(pc,d0.w),mapping_frame(a0)
                add.w   d0,d0
                move.w  SKICZSnowPile_FlakePriorities(pc,d0.w),priority(a0)
                andi.w  #$3C,d1
                subi.w  #$20,d1
                move.w  d1,x_vel(a0)
                move.w  #$100,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
SKICZSnowPile_FlakeFrames:
                dc.b    $B, $10,  $B,  $B
                even
SKICZSnowPile_FlakePriorities:
                dc.w    $80
                dc.w    $380
                dc.w    $80
                dc.w    $80
; ---------------------------------------------------------------------------

SKICZSnowPile_MoveUntilFirstVisible:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bmi.s   SKICZSnowPile_BeginVisibleFlakeState
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKICZSnowPile_BeginVisibleFlakeState:
                move.l  #SKICZSnowPile_MoveAndFlickerFlake,(a0)
                rts
; ---------------------------------------------------------------------------

SKICZSnowPile_MoveAndFlickerFlake:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bpl.s   SKICZSnowPile_TryDecrementFlakeCount
                bchg    #0,$38(a0)
                bne.w   SKICZSnowPile_BreakOrFlakeReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKICZSnowPile_TryDecrementFlakeCount:
                move.b  (Hyudoro_count).w,d0
                subq.b  #1,d0
                bmi.s   SKICZSnowPile_DeleteSnowflake
                move.b  d0,(Hyudoro_count).w

SKICZSnowPile_DeleteSnowflake:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKICZSnowPile_InitSnowFragment:
                lea     SKICZSnowPile_FragmentAttrs(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #SKICZSnowPile_TickFragmentStagger,(a0)
                move.l  #SKICZSnowPile_BeginFragmentFall,$34(a0)
                bsr.w   ICZSnowFragment_InitLaunch
                jsr     Refresh_ChildPositionAdjusted(pc)

SKICZSnowPile_TickFragmentStagger:
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKICZSnowPile_BeginFragmentFall:
                move.l  #SKICZSnowPile_MoveAndCullFragment,(a0)
                rts
; ---------------------------------------------------------------------------

SKICZSnowPile_MoveAndCullFragment:
                jsr     MoveSprite_LightGravity(pc)
                jmp     Sprite_CheckDeleteXY(pc)

; =============== S U B R O U T I N E =======================================

; Set the wait and indexed launch speeds. If the recorded player faces left, mirror both actors and negate the fragment's X velocity
ICZSnowFragment_InitLaunch:
                movea.w parent3(a0),a1
                move.w  $44(a1),d0
                beq.s   SKICZSnowPile_FragmentLaunchReturn
                movea.w d0,a2
                lea     SKICZSnowPile_FragmentLaunchSpeeds(pc),a3
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.l  (a3,d0.w),x_vel(a0)             ; and y_vel
                btst    #0,render_flags(a2)
                beq.s   SKICZSnowPile_FragmentLaunchReturn
                bset    #0,render_flags(a0)
                bset    #0,render_flags(a1)
                neg.w   x_vel(a0)

SKICZSnowPile_FragmentLaunchReturn:
                rts
; End of function ICZSnowFragment_InitLaunch

; ---------------------------------------------------------------------------
SKICZSnowPile_FragmentLaunchSpeeds:
                dc.w    -$300, -$200
                dc.w    -$400, -$300
                dc.w    -$400, -$280
                dc.w    -$280, -$200
                dc.w    -$200, -$180
                dc.w    -$200, -$100
SKICZSnowPile_SubtypeSetupTable:
                dc.l    SKICZSnowPile_UpdatePileContacts
                dc.l    SKICZSnowPile_DragPileAttrs
                dc.l    SKICZSnowPile_CheckNarrowGateP1
                dc.l    SKICZSnowPile_NarrowGateAttrs
                dc.l    SKICZSnowPile_CheckTransitionGateP1
                dc.l    SKICZSnowPile_TransitionGateAttrs
                dc.l    SKICZSnowPile_UpdateCameraSnowEmitter
                dc.l    SKICZSnowPile_FlakeAttrs
SKICZSnowPile_DragPileAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,0)
                dc.w    $80
                dc.b    $18,   8, $20,   0
SKICZSnowPile_NarrowGateAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,1)
                dc.w    $80
                dc.b    8, $10, $21,   0
SKICZSnowPile_TransitionGateAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,1)
                dc.w    $80
                dc.b    $10, $10, $22,   0
SKICZSnowPile_FlakeAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    4,   4,  $B,   0
SKICZSnowPile_FragmentAttrs:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    8,   8,   9,   0
SKICZSnowPile_DragPileFragments:
                dc.w    6-1
                dc.l    SKICZSnowPile_InitSnowFragment
                dc.b    -8,  -8
                dc.l    SKICZSnowPile_InitSnowFragment
                dc.b    8,  -8
                dc.l    SKICZSnowPile_InitSnowFragment
                dc.b    -$18,   0
                dc.l    SKICZSnowPile_InitSnowFragment
                dc.b    -8,   0
                dc.l    SKICZSnowPile_InitSnowFragment
                dc.b    8,   0
                dc.l    SKICZSnowPile_InitSnowFragment
                dc.b    $18,   0
SKICZSnowPile_NarrowGateFragments:
                dc.w    2-1
                dc.l    SKICZSnowPile_InitSnowFragment
                dc.b    0,  -8
                dc.l    SKICZSnowPile_InitSnowFragment
                dc.b    0,   8
SKICZSnowPile_TransitionGateFragments:
                dc.w    4-1
                dc.l    SKICZSnowPile_InitSnowFragment
                dc.b    -8,  -8
                dc.l    SKICZSnowPile_InitSnowFragment
                dc.b    0,   8
                dc.l    SKICZSnowPile_InitSnowFragment
                dc.b    8,  -8
                dc.l    SKICZSnowPile_InitSnowFragment
                dc.b    8,   8
