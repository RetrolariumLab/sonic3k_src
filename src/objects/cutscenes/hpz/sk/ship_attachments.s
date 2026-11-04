; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace ship and crane child attachments, parent-relative offsets and movement responses
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

HPZShipCrane_InitOverlayAndBeam:
                lea     SKHpzSszCrane_LiftingHeadAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #HPZShipCrane_FollowShipUntilLowerSignal,(a0)
                lea     SKSceneData_CraneFollowerChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

HPZShipCrane_FollowShipUntilLowerSignal:
                btst    #0,(_unkFAB8).w
                bne.s   HPZShipCrane_SaveOffsetAndBeginLowering
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZShipCrane_SaveOffsetAndBeginLowering:
                move.l  #HPZShipCrane_CheckEmeraldAndAdvancePhase,(a0)
                move.b  child_dy(a0),$3A(a0)

HPZShipCrane_CheckEmeraldAndAdvancePhase:
                move.w  (_unkFABA).w,d0
                beq.s   HPZShipCrane_FollowShipAndDraw
                movea.w d0,a1
                move.w  y_pos(a1),d0
                subi.w  #$18,d0
                cmp.w   y_pos(a0),d0
                bls.s   HPZShipCrane_AttachEmeraldAndRetract
                move.w  y_vel(a0),d0
                addi.w  #$80,d0
                bmi.s   HPZShipCrane_DeriveOffsetFromPhaseHigh
                move.w  d0,y_vel(a0)

HPZShipCrane_DeriveOffsetFromPhaseHigh:
                move.b  y_vel(a0),d2
                move.b  $3A(a0),d3
                add.b   d2,d3
                move.b  d3,child_dy(a0)

HPZShipCrane_FollowShipAndDraw:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZShipCrane_AttachEmeraldAndRetract:
                move.l  #HPZShipCrane_RetractAndSignalOnUnderflow,(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #$14,(Screen_shake_flag).w
                moveq   #signextendB(sfx_BigRumble),d0
                jsr     (Play_SFX).l
                lea     SKSceneData_HPZEmeraldSparkChildren(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     SKSceneData_HPZEmeraldFragmentChildren(pc),a2
                jsr     (CreateChild6_Simple).l

HPZShipCrane_RetractAndSignalOnUnderflow:
                move.w  y_vel(a0),d2
                subi.w  #$80,d2
                bpl.s   HPZShipCrane_StoreRetractPhaseAndOffset
                move.l  #HPZShipCrane_FollowShipAndCarryEmerald,(a0)
                moveq   #0,d2
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                movea.w (_unkFABA).w,a2
                bset    #7,art_tile(a2)

HPZShipCrane_StoreRetractPhaseAndOffset:
                move.w  d2,y_vel(a0)
                move.b  y_vel(a0),d2
                move.b  $3A(a0),d3
                add.b   d2,d3
                move.b  d3,child_dy(a0)

HPZShipCrane_FollowShipAndCarryEmerald:
                jsr     (Refresh_ChildPositionAdjusted).l
                move.w  (_unkFABA).w,d0
                beq.s   HPZShipCrane_DrawAfterCarry
                movea.w d0,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),d0
                move.b  (_unkFABD).w,d1
                ext.w   d1
                neg.w   d1
                add.w   d1,d0
                move.w  d0,y_pos(a1)

HPZShipCrane_DrawAfterCarry:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZShipCrane_InitCraneOverlay:
                lea     SKSceneData_CraneFrameFollowerPartAttrs(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #HPZShipCrane_SetOverlayFramePlusOne,(a0)

HPZShipCrane_SetOverlayFramePlusOne:
                jsr     (Refresh_ChildPositionAdjusted).l
                move.b  mapping_frame(a1),d0
                addq.b  #1,d0
                move.b  d0,mapping_frame(a0)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

HPZShipCrane_InitCraneBeam:
                lea     SKSceneData_CraneOffsetFollowerPartAttrs(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #HPZShipCrane_SelectBeamFrameByPhase,(a0)

HPZShipCrane_SelectBeamFrameByPhase:
                movea.w parent3(a0),a1
                move.b  y_vel(a1),d0
                lsr.b   #4,d0
                addq.b  #4,d0
                move.b  d0,mapping_frame(a0)
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; End of function HPZShipCrane_InitOverlayAndBeam
