; Owner: objects/terrain/icz/s3
; Responsibility: IceCap crushing column states and private object or child descriptors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZCrushingColumn:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZCrushingColumn_Index(pc,d0.w),d1
                move.w  x_pos(a0),-(sp)
                jsr     ICZCrushingColumn_Index(pc,d1.w)
                moveq   #$2B,d1
                moveq   #$70,d2
                moveq   #$70,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------
ICZCrushingColumn_Index:
                dc.w    S3ICZCrusher_InitCrusherAndChild-ICZCrushingColumn_Index
                dc.w    S3ICZCrusher_WaitForStandingRider-ICZCrushingColumn_Index
                dc.w    S3ICZCrusher_TickRiseDelay-ICZCrushingColumn_Index
                dc.w    S3ICZCrusher_CheckFastDropApproach-ICZCrushingColumn_Index
                dc.w    S3ICZCrusher_TickFastDropDelay-ICZCrushingColumn_Index
                dc.w    S3ICZCrusher_AccelerateUpToLimit-ICZCrushingColumn_Index
                dc.w    S3ICZCrusher_AccelerateDownToLimit-ICZCrushingColumn_Index
                dc.w    S3ICZCrusher_StepFastDropAndProbe-ICZCrushingColumn_Index
                dc.w    S3ICZCrusher_TickImpactPause-ICZCrushingColumn_Index
                dc.w    S3ICZCrusher_ReturnUpTowardBase-ICZCrushingColumn_Index
                dc.w    S3ICZCrusher_ReturnDownTowardBase-ICZCrushingColumn_Index
                dc.w    S3ICZCrusher_CheckP1ReturnSide-ICZCrushingColumn_Index
; ---------------------------------------------------------------------------

S3ICZCrusher_InitCrusherAndChild:
                lea     ObjDat_ICZCrushingColumn(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$70,y_radius(a0)
                move.w  y_pos(a0),$3E(a0)
                move.w  #$1F,$2E(a0)
                cmpi.b  #3,subtype(a0)
                bhs.s   S3ICZCrusher_RestoreSubtypeState
                move.b  #$C,mapping_frame(a0)
                lea     S3ICZCrusher_LowerVisualChild(pc),a2
                jsr     CreateChild1_Normal(pc)

S3ICZCrusher_RestoreSubtypeState:
                move.b  subtype(a0),d0
                add.b   d0,d0
                move.b  d0,routine(a0)

S3ICZCrusher_StateReturn:
                rts
; ---------------------------------------------------------------------------

S3ICZCrusher_WaitForStandingRider:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   S3ICZCrusher_StateReturn

S3ICZCrusher_BeginRise:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZCrusher_TickRiseDelay:
                subq.w  #1,$2E(a0)
                bmi.s   S3ICZCrusher_BeginRise
                rts
; ---------------------------------------------------------------------------

S3ICZCrusher_CheckFastDropApproach:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                cmpi.w  #$28,d2
                blo.w   S3ICZCrusher_StateReturn
                btst    #0,render_flags(a0)
                beq.s   S3ICZCrusher_CheckFastDropSide
                subq.w  #2,d0

S3ICZCrusher_CheckFastDropSide:
                tst.w   d0
                beq.s   S3ICZCrusher_StateReturn

S3ICZCrusher_BeginFastDrop:
                move.b  #$E,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZCrusher_TickFastDropDelay:
                subq.w  #1,$2E(a0)
                bmi.s   S3ICZCrusher_BeginFastDrop
                rts
; ---------------------------------------------------------------------------

S3ICZCrusher_AccelerateUpToLimit:
                move.w  y_vel(a0),d0
                addi.w  #-$20,d0
                cmpi.w  #-$400,d0
                ble.s   S3ICZCrusher_RiseAndCheckCeiling
                move.w  d0,y_vel(a0)

S3ICZCrusher_RiseAndCheckCeiling:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.w   S3ICZCrusher_StateReturn

; Correct the impact position and start the pause while retaining Y velocity
S3ICZCrusher_BeginImpactPause:
                add.w   d1,y_pos(a0)
                move.b  #$10,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #S3ICZCrusher_SelectReturnState,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

S3ICZCrusher_AccelerateDownToLimit:
                move.w  y_vel(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$400,d0
                bgt.s   S3ICZCrusher_FallAndCheckFloor
                move.w  d0,y_vel(a0)

S3ICZCrusher_FallAndCheckFloor:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   S3ICZCrusher_BeginImpactPause
                rts
; ---------------------------------------------------------------------------

S3ICZCrusher_StepFastDropAndProbe:
                addq.w  #8,y_pos(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   S3ICZCrusher_BeginImpactPause
                rts
; ---------------------------------------------------------------------------

S3ICZCrusher_TickImpactPause:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3ICZCrusher_SelectReturnState:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.b  S3ICZCrusher_PostImpactStates-1(pc,d0.w),routine(a0)
                rts
; ---------------------------------------------------------------------------
S3ICZCrusher_PostImpactStates:
                dc.b    $14, $14, $16, $12
                even
; ---------------------------------------------------------------------------

S3ICZCrusher_ReturnUpTowardBase:
                move.w  y_pos(a0),d0
                subq.w  #1,d0
                cmp.w   $3E(a0),d0
                bls.s   S3ICZCrusher_FinishUpwardReturn
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZCrusher_FinishUpwardReturn:
                move.w  #$5F,$2E(a0)
                bra.w   S3ICZCrusher_RestoreSubtypeState
; ---------------------------------------------------------------------------

S3ICZCrusher_ReturnDownTowardBase:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                cmp.w   $3E(a0),d0
                bhs.s   S3ICZCrusher_FinishDownwardReturn
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZCrusher_FinishDownwardReturn:
                move.w  #$5F,$2E(a0)
                bra.w   S3ICZCrusher_RestoreSubtypeState
; ---------------------------------------------------------------------------

S3ICZCrusher_CheckP1ReturnSide:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                btst    #0,render_flags(a0)
                beq.s   S3ICZCrusher_TryBeginUpwardReturn
                subq.w  #2,d0

S3ICZCrusher_TryBeginUpwardReturn:
                tst.w   d0
                bne.w   S3ICZCrusher_StateReturn
                move.b  #$12,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZCrusher_InitLowerVisual:
                move.l  #S3ICZCrusher_FollowParentAndDraw,(a0)
                lea     S3ICZCrusher_LowerVisualAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)

S3ICZCrusher_FollowParentAndDraw:
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                addi.w  #$B0,d0
                move.w  d0,y_pos(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
ObjDat_ICZCrushingColumn:
                dc.l    Map_ICZWallAndColumn
                dc.w    make_art_tile($001,2,0)
                dc.w    $280
                dc.b    $20, $70,   2,   0
S3ICZCrusher_LowerVisualAttrs:
                dc.w    $280
                dc.b    $20, $40,  $D,   0
S3ICZCrusher_LowerVisualChild:
                dc.w    1-1
                dc.l    S3ICZCrusher_InitLowerVisual
                dc.b    0,   0
