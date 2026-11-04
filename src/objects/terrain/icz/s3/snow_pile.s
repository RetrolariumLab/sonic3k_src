; Owner: objects/terrain/icz/s3
; Responsibility: IceCap snow-pile controller, thrown snow, child helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZSnowPile:
                jsr     Obj_WaitOffscreen(pc)
                moveq   #0,d0
                move.b  subtype(a0),d0
                bclr    #7,d0
                lea     S3ICZSnowPile_SubtypeSetupTable(pc),a1
                lea     (a1,d0.w),a2
                move.l  (a2)+,(a0)
                movea.l (a2)+,a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

S3ICZSnowPile_UpdatePileContacts:
                lea     S3ICZSnowPile_DragPileBounds(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   S3ICZSnowPile_DrawIntactPile
                tst.w   d0
                beq.s   S3ICZSnowPile_TryP2PileContact
                bsr.w   ApplyIczSnowPileDragOrBreak

S3ICZSnowPile_TryP2PileContact:
                swap    d0
                tst.w   d0
                beq.s   S3ICZSnowPile_DrawIntactPile
                bsr.w   ApplyIczSnowPileDragOrBreak

S3ICZSnowPile_DrawIntactPile:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
S3ICZSnowPile_DragPileBounds:
                dc.w    -$28,   $50,  -$18,   $20

; =============== S U B R O U T I N E =======================================

ApplyIczSnowPileDragOrBreak:
                movea.w d0,a3
                move.w  d0,$44(a0)
                cmpi.b  #9,anim(a3)
                beq.s   S3ICZSnowPile_BreakAndSkipCaller
                btst    #Status_InAir,status(a3)
                bne.s   S3ICZSnowPile_DragReturn
                move.w  x_vel(a3),d2
                move.w  d2,d3
                bpl.s   S3ICZSnowPile_BreakOrHalveGroundSpeed
                neg.w   d2

S3ICZSnowPile_BreakOrHalveGroundSpeed:
                cmpi.w  #$600,d2
                bhs.s   S3ICZSnowPile_BreakAndSkipCaller
                asr.w   #1,d3
                move.w  d3,ground_vel(a3)

S3ICZSnowPile_DragReturn:
                rts
; ---------------------------------------------------------------------------

; Discard the caller's return address to skip the remaining contacts and draw
S3ICZSnowPile_BreakAndSkipCaller:
                move.w  a3,$44(a0)
                lea     S3ICZSnowPile_DragPileFragments(pc),a2
                jsr     CreateChild1_Normal(pc)
                jsr     (Go_Delete_Sprite).l
                addq.w  #4,sp

S3ICZSnowPile_BreakOrFlakeReturn:
                rts
; End of function ApplyIczSnowPileDragOrBreak

; ---------------------------------------------------------------------------

S3ICZSnowPile_CheckNarrowGateP1:
                lea     S3ICZSnowPile_NarrowGateBounds(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.w   d0
                bne.s   S3ICZSnowPile_BoostP1ThroughNarrowGate
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

S3ICZSnowPile_BoostP1ThroughNarrowGate:
                move.w  d0,$44(a0)
                beq.s   S3ICZSnowPile_DeleteNarrowGate
                movea.w d0,a1
                move.w  #$800,x_vel(a1)
                move.w  #$800,ground_vel(a1)
                lea     S3ICZSnowPile_NarrowGateFragments(pc),a2
                jsr     CreateChild1_Normal(pc)

S3ICZSnowPile_DeleteNarrowGate:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
S3ICZSnowPile_NarrowGateBounds:
                dc.w    -8,   $10,  -$10,   $20
; ---------------------------------------------------------------------------

S3ICZSnowPile_CheckTransitionGateP1:
                lea     S3ICZSnowPile_TransitionGateBounds(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.w   d0
                bne.s   S3ICZSnowPile_BoostP1AndTryTransition
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

S3ICZSnowPile_BoostP1AndTryTransition:
                move.w  d0,$44(a0)
                beq.s   S3ICZSnowPile_DeleteTransitionGate
                movea.w d0,a1
                move.w  #$800,x_vel(a1)
                move.w  #$800,ground_vel(a1)
                lea     S3ICZSnowPile_TransitionGateFragments(pc),a2
                jsr     CreateChild1_Normal(pc)
                btst    #7,subtype(a0)
                beq.s   S3ICZSnowPile_DeleteTransitionGate
                move.w  #$600,d0
                jsr     StartNewLevel(pc)

S3ICZSnowPile_DeleteTransitionGate:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
S3ICZSnowPile_TransitionGateBounds:
                dc.w    -8,   $10,  -$10,   $20
; ---------------------------------------------------------------------------

; Increment the live flake count before attempting allocation
S3ICZSnowPile_UpdateCameraSnowEmitter:
                move.w  a0,(_unkFAAE).w
                btst    #5,$38(a0)
                bne.s   S3ICZSnowPile_DeleteSnowEmitter
                move.w  (Camera_X_pos_copy).w,x_pos(a0)
                move.w  (Camera_Y_pos_copy).w,y_pos(a0)
                subq.w  #8,y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   S3ICZSnowPile_SnowEmitterReturn
                move.w  #8,$2E(a0)
                move.b  (Hyudoro_count).w,d0
                addq.b  #1,d0
                cmpi.b  #$3C,d0
                bhi.s   S3ICZSnowPile_SnowEmitterReturn
                move.b  d0,(Hyudoro_count).w
                jsr     (AllocateObject).l
                bne.s   S3ICZSnowPile_SnowEmitterReturn
                move.l  #S3ICZSnowPile_InitFlakeAndFoldXOffset,(a1)

S3ICZSnowPile_SnowEmitterReturn:
                rts
; ---------------------------------------------------------------------------

S3ICZSnowPile_DeleteSnowEmitter:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3ICZSnowPile_InitFlakeAndFoldXOffset:
                lea     S3ICZSnowPile_FlakeAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #S3ICZSnowPile_MoveUntilFirstVisible,(a0)
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                cmpi.w  #$140,d0
                blo.s   S3ICZSnowPile_PlaceFlakeAndPickVisual
                andi.w  #$3F,d0
                lsl.w   #2,d0

S3ICZSnowPile_PlaceFlakeAndPickVisual:
                add.w   (Camera_X_pos).w,d0
                cmpi.w  #$380,d0
                blo.s   S3ICZSnowPile_TryDecrementFlakeCount
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subq.w  #4,d0
                move.w  d0,y_pos(a0)
                swap    d0
                move.w  d0,d1
                andi.w  #3,d0
                move.b  S3ICZSnowPile_FlakeFrames(pc,d0.w),mapping_frame(a0)
                add.w   d0,d0
                move.w  S3ICZSnowPile_FlakePriorities(pc,d0.w),priority(a0)
                andi.w  #$3C,d1
                subi.w  #$20,d1
                move.w  d1,x_vel(a0)
                move.w  #$100,y_vel(a0)
                rts
; ---------------------------------------------------------------------------
S3ICZSnowPile_FlakeFrames:
                dc.b    $B, $10,  $B,  $B
                even
S3ICZSnowPile_FlakePriorities:
                dc.w    $80
                dc.w    $380
                dc.w    $80
                dc.w    $80
; ---------------------------------------------------------------------------

S3ICZSnowPile_MoveUntilFirstVisible:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bmi.s   S3ICZSnowPile_BeginVisibleFlakeState
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3ICZSnowPile_BeginVisibleFlakeState:
                move.l  #S3ICZSnowPile_MoveAndFlickerFlake,(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZSnowPile_MoveAndFlickerFlake:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bpl.s   S3ICZSnowPile_TryDecrementFlakeCount
                bchg    #0,$38(a0)
                bne.w   S3ICZSnowPile_BreakOrFlakeReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3ICZSnowPile_TryDecrementFlakeCount:
                move.b  (Hyudoro_count).w,d0
                subq.b  #1,d0
                bmi.s   S3ICZSnowPile_DeleteSnowflake
                move.b  d0,(Hyudoro_count).w

S3ICZSnowPile_DeleteSnowflake:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3ICZSnowPile_InitSnowFragment:
                lea     S3ICZSnowPile_FragmentAttrs(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #S3ICZSnowPile_TickFragmentStagger,(a0)
                move.l  #S3ICZSnowPile_BeginFragmentFall,$34(a0)
                bsr.w   ICZSnowFragment_InitLaunch
                jsr     Refresh_ChildPositionAdjusted(pc)

S3ICZSnowPile_TickFragmentStagger:
                jsr     Obj_Wait(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3ICZSnowPile_BeginFragmentFall:
                move.l  #S3ICZSnowPile_MoveAndCullFragment,(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZSnowPile_MoveAndCullFragment:
                jsr     MoveSprite_LightGravity(pc)
                jmp     Sprite_CheckDeleteXY(pc)

; =============== S U B R O U T I N E =======================================

; Set the wait and indexed launch speeds. If the recorded player faces left, mirror both actors and negate the fragment's X velocity
ICZSnowFragment_InitLaunch:
                movea.w parent3(a0),a1
                move.w  $44(a1),d0
                beq.s   S3ICZSnowPile_FragmentLaunchReturn
                movea.w d0,a2
                lea     S3ICZSnowPile_FragmentLaunchSpeeds(pc),a3
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.l  (a3,d0.w),x_vel(a0)             ; and y_vel
                btst    #0,render_flags(a2)
                beq.s   S3ICZSnowPile_FragmentLaunchReturn
                bset    #0,render_flags(a0)
                bset    #0,render_flags(a1)
                neg.w   x_vel(a0)

S3ICZSnowPile_FragmentLaunchReturn:
                rts
; End of function ICZSnowFragment_InitLaunch

; ---------------------------------------------------------------------------
S3ICZSnowPile_FragmentLaunchSpeeds:
                dc.w    -$300, -$200
                dc.w    -$400, -$300
                dc.w    -$400, -$280
                dc.w    -$280, -$200
                dc.w    -$200, -$180
                dc.w    -$200, -$100
S3ICZSnowPile_SubtypeSetupTable:
                dc.l    S3ICZSnowPile_UpdatePileContacts
                dc.l    S3ICZSnowPile_DragPileAttrs
                dc.l    S3ICZSnowPile_CheckNarrowGateP1
                dc.l    S3ICZSnowPile_NarrowGateAttrs
                dc.l    S3ICZSnowPile_CheckTransitionGateP1
                dc.l    S3ICZSnowPile_TransitionGateAttrs
                dc.l    S3ICZSnowPile_UpdateCameraSnowEmitter
                dc.l    S3ICZSnowPile_FlakeAttrs
S3ICZSnowPile_DragPileAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,0)
                dc.w    $80
                dc.b    $18,   8, $20,   0
S3ICZSnowPile_NarrowGateAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,1)
                dc.w    $80
                dc.b    8, $10, $21,   0
S3ICZSnowPile_TransitionGateAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,1)
                dc.w    $80
                dc.b    $10, $10, $22,   0
S3ICZSnowPile_FlakeAttrs:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    4,   4,  $B,   0
S3ICZSnowPile_FragmentAttrs:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    8,   8,   9,   0
S3ICZSnowPile_DragPileFragments:
                dc.w    6-1
                dc.l    S3ICZSnowPile_InitSnowFragment
                dc.b    -8,  -8
                dc.l    S3ICZSnowPile_InitSnowFragment
                dc.b    8,  -8
                dc.l    S3ICZSnowPile_InitSnowFragment
                dc.b    -$18,   0
                dc.l    S3ICZSnowPile_InitSnowFragment
                dc.b    -8,   0
                dc.l    S3ICZSnowPile_InitSnowFragment
                dc.b    8,   0
                dc.l    S3ICZSnowPile_InitSnowFragment
                dc.b    $18,   0
S3ICZSnowPile_NarrowGateFragments:
                dc.w    2-1
                dc.l    S3ICZSnowPile_InitSnowFragment
                dc.b    0,  -8
                dc.l    S3ICZSnowPile_InitSnowFragment
                dc.b    0,   8
S3ICZSnowPile_TransitionGateFragments:
                dc.w    4-1
                dc.l    S3ICZSnowPile_InitSnowFragment
                dc.b    -8,  -8
                dc.l    S3ICZSnowPile_InitSnowFragment
                dc.b    0,   8
                dc.l    S3ICZSnowPile_InitSnowFragment
                dc.b    8,  -8
                dc.l    S3ICZSnowPile_InitSnowFragment
                dc.b    8,   8
