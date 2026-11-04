; Owner: objects/terrain/icz/sk
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
                dc.w    SKICZCrusher_InitCrusherAndChild-ICZCrushingColumn_Index
                dc.w    SKICZCrusher_WaitForStandingRider-ICZCrushingColumn_Index
                dc.w    SKICZCrusher_TickRiseDelay-ICZCrushingColumn_Index
                dc.w    SKICZCrusher_CheckFastDropApproach-ICZCrushingColumn_Index
                dc.w    SKICZCrusher_TickFastDropDelay-ICZCrushingColumn_Index
                dc.w    SKICZCrusher_CheckKnuckles-ICZCrushingColumn_Index
                dc.w    SKICZCrusher_AccelerateUpToLimit-ICZCrushingColumn_Index
                dc.w    SKICZCrusher_AccelerateDownToLimit-ICZCrushingColumn_Index
                dc.w    SKICZCrusher_StepFastDropAndProbe-ICZCrushingColumn_Index
                dc.w    SKICZCrusher_TickImpactPause-ICZCrushingColumn_Index
                dc.w    SKICZCrusher_ReturnUpTowardBase-ICZCrushingColumn_Index
                dc.w    SKICZCrusher_ReturnDownTowardBase-ICZCrushingColumn_Index
                dc.w    SKICZCrusher_CheckP1ReturnSide-ICZCrushingColumn_Index
; ---------------------------------------------------------------------------

SKICZCrusher_InitCrusherAndChild:
                lea     ObjDat_ICZCrushingColumn(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$70,y_radius(a0)
                move.w  y_pos(a0),$3E(a0)
                move.w  #$1F,$2E(a0)
                cmpi.b  #3,subtype(a0)
                bhs.s   SKICZCrusher_RestoreSubtypeState
                move.b  #$C,mapping_frame(a0)
                lea     SKICZCrusher_LowerVisualChild(pc),a2
                jsr     CreateChild1_Normal(pc)

SKICZCrusher_RestoreSubtypeState:
                move.b  subtype(a0),d0
                add.b   d0,d0
                move.b  d0,routine(a0)

SKICZCrusher_StateReturn:
                rts
; ---------------------------------------------------------------------------

SKICZCrusher_WaitForStandingRider:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   SKICZCrusher_StateReturn

SKICZCrusher_BeginRise:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKICZCrusher_TickRiseDelay:
                subq.w  #1,$2E(a0)
                bmi.s   SKICZCrusher_BeginRise
                rts
; ---------------------------------------------------------------------------

SKICZCrusher_CheckFastDropApproach:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                cmpi.w  #$28,d2
                blo.w   SKICZCrusher_StateReturn
                btst    #0,render_flags(a0)
                beq.s   SKICZCrusher_CheckFastDropSide
                subq.w  #2,d0

SKICZCrusher_CheckFastDropSide:
                tst.w   d0
                beq.s   SKICZCrusher_StateReturn

SKICZCrusher_BeginFastDrop:
                move.b  #$10,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKICZCrusher_TickFastDropDelay:
                subq.w  #1,$2E(a0)
                bmi.s   SKICZCrusher_BeginFastDrop
                rts
; ---------------------------------------------------------------------------

SKICZCrusher_CheckKnuckles:
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   SKICZCrusher_DeleteForNonKnuckles
                rts
; ---------------------------------------------------------------------------

SKICZCrusher_DeleteForNonKnuckles:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SKICZCrusher_AccelerateUpToLimit:
                move.w  y_vel(a0),d0
                addi.w  #-$20,d0
                cmpi.w  #-$400,d0
                ble.s   SKICZCrusher_RiseAndCheckCeiling
                move.w  d0,y_vel(a0)

SKICZCrusher_RiseAndCheckCeiling:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.w   SKICZCrusher_StateReturn

; Correct the impact position and start the pause while retaining Y velocity
SKICZCrusher_BeginImpactPause:
                add.w   d1,y_pos(a0)
                move.b  #$12,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #SKICZCrusher_SelectReturnState,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

SKICZCrusher_AccelerateDownToLimit:
                move.w  y_vel(a0),d0
                addi.w  #$20,d0
                cmpi.w  #$400,d0
                bgt.s   SKICZCrusher_FallAndCheckFloor
                move.w  d0,y_vel(a0)

SKICZCrusher_FallAndCheckFloor:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   SKICZCrusher_BeginImpactPause
                rts
; ---------------------------------------------------------------------------

SKICZCrusher_StepFastDropAndProbe:
                addq.w  #8,y_pos(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   SKICZCrusher_BeginImpactPause
                rts
; ---------------------------------------------------------------------------

SKICZCrusher_TickImpactPause:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKICZCrusher_SelectReturnState:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.b  SKICZCrusher_PostImpactStates-1(pc,d0.w),routine(a0)
                rts
; ---------------------------------------------------------------------------
SKICZCrusher_PostImpactStates:
                dc.b    $16, $16, $18, $14
                even
; ---------------------------------------------------------------------------

SKICZCrusher_ReturnUpTowardBase:
                move.w  y_pos(a0),d0
                subq.w  #1,d0
                cmp.w   $3E(a0),d0
                bls.s   SKICZCrusher_FinishUpwardReturn
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKICZCrusher_FinishUpwardReturn:
                move.w  #$5F,$2E(a0)
                bra.w   SKICZCrusher_RestoreSubtypeState
; ---------------------------------------------------------------------------

SKICZCrusher_ReturnDownTowardBase:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                cmp.w   $3E(a0),d0
                bhs.s   SKICZCrusher_FinishDownwardReturn
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKICZCrusher_FinishDownwardReturn:
                move.w  #$5F,$2E(a0)
                bra.w   SKICZCrusher_RestoreSubtypeState
; ---------------------------------------------------------------------------

SKICZCrusher_CheckP1ReturnSide:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                btst    #0,render_flags(a0)
                beq.s   SKICZCrusher_TryBeginUpwardReturn
                subq.w  #2,d0

SKICZCrusher_TryBeginUpwardReturn:
                tst.w   d0
                bne.w   SKICZCrusher_StateReturn
                move.b  #$14,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKICZCrusher_InitLowerVisual:
                move.l  #SKICZCrusher_FollowParentAndDraw,(a0)
                lea     SKICZCrusher_LowerVisualAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)

SKICZCrusher_FollowParentAndDraw:
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
SKICZCrusher_LowerVisualAttrs:
                dc.w    $280
                dc.b    $20, $40,  $D,   0
SKICZCrusher_LowerVisualChild:
                dc.w    1-1
                dc.l    SKICZCrusher_InitLowerVisual
                dc.b    0,   0
