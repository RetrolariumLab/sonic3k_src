; Owner: objects/zones/lbz/sk
; Responsibility: Launch Base moving platform states, intangible falling platforms and shared mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
SKLBZMovePlat_GeometryTable:
                dc.b    $20,   8,   0
                even
                dc.b    $20,   8,   1
                even
; ---------------------------------------------------------------------------

Obj_LBZMovingPlatform:
                move.l  #Map_LBZMovingPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZMisc,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$180,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                bpl.s   SKLBZMovePlat_InitGeometryAndMotion
                andi.w  #$7F,d0
                lsl.w   #4,d0
                move.w  d0,$38(a0)
                moveq   #$17,d0
                move.b  d0,subtype(a0)

SKLBZMovePlat_InitGeometryAndMotion:
                lsr.w   #2,d0
                andi.w  #$1C,d0
                lea     SKLBZMovePlat_GeometryTable(pc,d0.w),a2
                move.b  (a2)+,width_pixels(a0)
                move.b  (a2)+,height_pixels(a0)
                move.b  (a2)+,mapping_frame(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  x_pos(a0),$32(a0)
                move.w  y_pos(a0),$34(a0)
                move.b  status(a0),$2E(a0)
                move.w  #$280,$42(a0)
                move.w  x_pos(a0),$44(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                subq.w  #8,d0
                bcs.s   SKLBZMovePlat_StartSubtypeMotion
                cmpi.w  #4,d0
                bhs.s   SKLBZMovePlat_WidenCullWindow
                lsl.w   #2,d0
                lea     (Oscillating_table+$2C).w,a2
                lea     (a2,d0.w),a2
                tst.w   (a2)
                bpl.s   SKLBZMovePlat_StartSubtypeMotion
                bchg    #0,$2E(a0)
                bra.s   SKLBZMovePlat_StartSubtypeMotion
; ---------------------------------------------------------------------------

SKLBZMovePlat_WidenCullWindow:
                move.w  #$380,$42(a0)
                addi.w  #$100,$44(a0)

SKLBZMovePlat_StartSubtypeMotion:
                move.b  subtype(a0),d0
                andi.b  #$F,d0
                add.b   d0,d0
                move.b  d0,subtype(a0)
                move.l  #SKLBZMovePlat_UpdateMotionAndSolid,(a0)

SKLBZMovePlat_UpdateMotionAndSolid:
                move.w  x_pos(a0),-(sp)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  LBZMovingPlatformIndex(pc,d0.w),d1
                jsr     LBZMovingPlatformIndex(pc,d1.w)
                move.w  (sp)+,d4
                tst.b   render_flags(a0)
                bpl.s   SKLBZMovePlat_DrawFromCullAnchor
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  #9,d3
                jsr     (SolidObjectTop).l

SKLBZMovePlat_DrawFromCullAnchor:
                move.w  $44(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmp.w   $42(a0),d0
                bhi.w   SKLBZMovePlat_TryDeleteLinkedBar
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLBZMovePlat_TryDeleteLinkedBar:
                tst.b   $3D(a0)
                beq.s   SKLBZMovePlat_TryClearRespawnBit
                movea.w $3E(a0),a1
                jsr     (Delete_Referenced_Sprite).l

SKLBZMovePlat_TryClearRespawnBit:
                move.w  respawn_addr(a0),d0
                beq.s   SKLBZMovePlat_DeletePlatform
                movea.w d0,a2
                bclr    #7,(a2)

SKLBZMovePlat_DeletePlatform:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
LBZMovingPlatformIndex:
                dc.w    Platform_Stationary-LBZMovingPlatformIndex
                dc.w    Platform_Horizontal64-LBZMovingPlatformIndex
                dc.w    Platform_Horizontal128-LBZMovingPlatformIndex
                dc.w    Platform_Vertical64-LBZMovingPlatformIndex
                dc.w    Platform_Vertical128-LBZMovingPlatformIndex
                dc.w    Platform_DiagonalUp-LBZMovingPlatformIndex
                dc.w    Platform_DiagonalDown-LBZMovingPlatformIndex
                dc.w    Platform_DiagonalLift-LBZMovingPlatformIndex
                dc.w    Platform_Square32-LBZMovingPlatformIndex
                dc.w    Platform_Square96-LBZMovingPlatformIndex
                dc.w    Platform_Square160-LBZMovingPlatformIndex
                dc.w    Platform_Square224-LBZMovingPlatformIndex
                dc.w    Platform_Horizontal256-LBZMovingPlatformIndex
                dc.w    Platform_FallingDelayed-LBZMovingPlatformIndex
                dc.w    Platform_Falling-LBZMovingPlatformIndex
FloatingPlatformIndex:
                dc.w    Platform_Stationary-FloatingPlatformIndex
                dc.w    Platform_Horizontal64-FloatingPlatformIndex
                dc.w    Platform_Horizontal128-FloatingPlatformIndex
                dc.w    Platform_Vertical64-FloatingPlatformIndex
                dc.w    Platform_Vertical128-FloatingPlatformIndex
                dc.w    Platform_DiagonalUp-FloatingPlatformIndex
                dc.w    Platform_DiagonalDown-FloatingPlatformIndex
                dc.w    Platform_Rising-FloatingPlatformIndex
                dc.w    Platform_Square32-FloatingPlatformIndex
                dc.w    Platform_Square96-FloatingPlatformIndex
                dc.w    Platform_Square160-FloatingPlatformIndex
                dc.w    Platform_Square224-FloatingPlatformIndex
                dc.w    Platform_Horizontal256-FloatingPlatformIndex
; ---------------------------------------------------------------------------

Platform_Stationary:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   SKLBZMovePlat_IncreaseSagAngle
                tst.b   $3A(a0)
                beq.s   SKLBZMovePlat_ApplySineSag
                subq.b  #4,$3A(a0)
                bra.s   SKLBZMovePlat_ApplySineSag
; ---------------------------------------------------------------------------

SKLBZMovePlat_IncreaseSagAngle:
                cmpi.b  #$40,$3A(a0)
                beq.s   SKLBZMovePlat_ApplySineSag
                addq.b  #4,$3A(a0)

SKLBZMovePlat_ApplySineSag:
                move.b  $3A(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #6,d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

Platform_Horizontal64:
                move.w  #64,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$0A).w,d0
                bra.s   PositionLbzPlatformHorizontalOscillation
; ---------------------------------------------------------------------------

Platform_Horizontal128:
                move.w  #128,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0

; =============== S U B R O U T I N E =======================================

PositionLbzPlatformHorizontalOscillation:
                btst    #0,status(a0)
                beq.s   SKLBZMovePlat_ApplyOscillationX
                neg.w   d0
                add.w   d1,d0

SKLBZMovePlat_ApplyOscillationX:
                move.w  $30(a0),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                rts
; End of function PositionLbzPlatformHorizontalOscillation

; ---------------------------------------------------------------------------

Platform_Vertical64:
                move.w  #64,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$0A).w,d0
                bra.s   SKLBZMovePlat_TryMirrorOscillationY
; ---------------------------------------------------------------------------

Platform_Vertical128:
                move.w  #128,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0

SKLBZMovePlat_TryMirrorOscillationY:
                btst    #0,status(a0)
                beq.s   SKLBZMovePlat_ApplyOscillationY
                neg.w   d0
                add.w   d1,d0

SKLBZMovePlat_ApplyOscillationY:
                move.w  $34(a0),d1
                sub.w   d0,d1
                move.w  d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

Platform_DiagonalUp:
                move.w  #128,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                bsr.s   PositionLbzPlatformHorizontalOscillation
                move.w  #64,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                lsr.b   #1,d0
                bra.s   SKLBZMovePlat_TryMirrorOscillationY
; ---------------------------------------------------------------------------

Platform_DiagonalDown:
                move.w  #128,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                neg.w   d0
                add.w   d1,d0
                bsr.s   PositionLbzPlatformHorizontalOscillation
                move.w  #64,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                lsr.b   #1,d0
                bra.s   SKLBZMovePlat_TryMirrorOscillationY
; ---------------------------------------------------------------------------

Platform_DiagonalLift:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   SKLBZMovePlat_AdvanceOccupiedLift
                move.w  $38(a0),d2
                move.w  $36(a0),d1
                beq.s   SKLBZMovePlat_DiagonalLiftReturn
                subq.w  #4,d1
                bcc.s   SKLBZMovePlat_SetLiftReturnDistance
                moveq   #0,d1

SKLBZMovePlat_SetLiftReturnDistance:
                move.w  d1,$36(a0)
                bra.s   SKLBZMovePlat_PlaceDiagonalLift
; ---------------------------------------------------------------------------

SKLBZMovePlat_AdvanceOccupiedLift:
                move.w  $38(a0),d2
                move.w  $36(a0),d1
                addq.w  #2,d1
                cmp.w   d2,d1
                blo.s   SKLBZMovePlat_SetOccupiedLiftDistance
                move.w  d2,d1

SKLBZMovePlat_SetOccupiedLiftDistance:
                move.w  d1,$36(a0)

SKLBZMovePlat_PlaceDiagonalLift:
                move.w  $32(a0),d0
                sub.w   d1,d0
                move.w  d0,x_pos(a0)
                move.w  d0,$30(a0)
                lsr.w   #1,d1
                move.w  $34(a0),d0
                sub.w   d1,d0
                move.w  d0,y_pos(a0)

SKLBZMovePlat_DiagonalLiftReturn:
                rts
; ---------------------------------------------------------------------------

Platform_Horizontal256:
                move.w  #$7F,d2
                tst.b   $3C(a0)
                bne.s   SKLBZMovePlat_DecelerateWideTravel
                move.w  $40(a0),d1
                addq.w  #4,d1
                move.w  d1,$40(a0)
                add.w   d1,$36(a0)
                cmp.b   $36(a0),d2
                bhi.s   SKLBZMovePlat_GetWideTravelOffset
                move.b  #1,$3C(a0)
                bra.s   SKLBZMovePlat_GetWideTravelOffset
; ---------------------------------------------------------------------------

SKLBZMovePlat_DecelerateWideTravel:
                move.w  $40(a0),d1
                subq.w  #4,d1
                move.w  d1,$40(a0)
                add.w   d1,$36(a0)
                cmp.b   $36(a0),d2
                bls.s   SKLBZMovePlat_GetWideTravelOffset
                move.b  #0,$3C(a0)

SKLBZMovePlat_GetWideTravelOffset:
                moveq   #0,d0
                move.b  $36(a0),d0
                btst    #0,status(a0)
                beq.s   SKLBZMovePlat_PlaceWidePlatformX
                neg.w   d0
                add.w   d2,d0

SKLBZMovePlat_PlaceWidePlatformX:
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

Platform_FallingDelayed:
                tst.w   $3A(a0)
                bne.s   SKLBZMovePlat_TickDelayAndBeginFall
                move.b  status(a0),d0
                andi.b  #$18,d0
                beq.s   SKLBZMovePlat_FallDelayReturn
                move.w  #30,$3A(a0)

SKLBZMovePlat_FallDelayReturn:
                rts
; ---------------------------------------------------------------------------

SKLBZMovePlat_TickDelayAndBeginFall:
                subq.w  #1,$3A(a0)
                bne.s   SKLBZMovePlat_FallDelayReturn
                move.w  #32,$3A(a0)
                addq.b  #2,subtype(a0)
                rts
; ---------------------------------------------------------------------------

Platform_Falling:
                tst.w   $3A(a0)
                beq.s   SKLBZMovePlat_MoveAndCheckFallDepth
                subq.w  #1,$3A(a0)
                bne.s   SKLBZMovePlat_MoveAndCheckFallDepth
                bclr    #p1_standing_bit,status(a0)
                beq.s   SKLBZMovePlat_TryReleaseFallingP2
                lea     (Player_1).w,a1
                bsr.s   ReleasePlayerFromLbzFallingPlatform

SKLBZMovePlat_TryReleaseFallingP2:
                bclr    #p2_standing_bit,status(a0)
                beq.s   SKLBZMovePlat_BeginIntangibleFall
                lea     (Player_2).w,a1
                bsr.s   ReleasePlayerFromLbzFallingPlatform

SKLBZMovePlat_BeginIntangibleFall:
                move.l  #Obj_FallingPlatformIntangible,(a0)

SKLBZMovePlat_MoveAndCheckFallDepth:
                move.l  y_pos(a0),d3
                move.w  y_vel(a0),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3
                move.l  d3,y_pos(a0)
                addi.w  #$38,y_vel(a0)
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$120,d0
                cmp.w   y_pos(a0),d0
                bhs.s   SKLBZMovePlat_FallMotionReturn
                move.w  #$7F00,x_pos(a0)
                move.w  #$7F00,$44(a0)

SKLBZMovePlat_FallMotionReturn:
                rts

; =============== S U B R O U T I N E =======================================

ReleasePlayerFromLbzFallingPlatform:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                move.w  y_vel(a0),y_vel(a1)
                rts
; End of function ReleasePlayerFromLbzFallingPlatform

; ---------------------------------------------------------------------------

Obj_FallingPlatformIntangible:
                move.l  y_pos(a0),d3
                move.w  y_vel(a0),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3
                move.l  d3,y_pos(a0)
                addi.w  #$38,y_vel(a0)
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$120,d0
                cmp.w   y_pos(a0),d0
                bhs.s   SKLBZMovePlat_DrawIntangiblePlatform
                move.w  #$7F00,x_pos(a0)
                move.w  #$7F00,$44(a0)

SKLBZMovePlat_DrawIntangiblePlatform:
                bra.w   SKLBZMovePlat_DrawFromCullAnchor
; ---------------------------------------------------------------------------

Platform_Rising:
                tst.b   $3C(a0)
                bne.s   SKLBZMovePlat_MoveAndAccelerateRise
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   SKLBZMovePlat_RiseWaitReturn
                move.b  #1,$3C(a0)
                move.b  #$C,y_radius(a0)

SKLBZMovePlat_RiseWaitReturn:
                rts
; ---------------------------------------------------------------------------

SKLBZMovePlat_MoveAndAccelerateRise:
                jsr     (MoveSprite2).l
                moveq   #8,d1
                move.w  $34(a0),d0
                subi.w  #$80,d0
                cmp.w   y_pos(a0),d0
                bhs.s   SKLBZMovePlat_TryStopAtCeiling
                neg.w   d1
                add.w   d1,y_vel(a0)

SKLBZMovePlat_TryStopAtCeiling:
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   SKLBZMovePlat_CheckP1Clearance
                sub.w   d1,y_pos(a0)
                clr.b   $3C(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKLBZMovePlat_CheckP1Clearance:
                btst    #p1_standing_bit,status(a0)
                beq.s   SKLBZMovePlat_CheckP2Clearance
                move.l  a0,-(sp)
                lea     (Player_1).w,a0
                jsr     (CheckPlayerBodyFloorClearance).l
                tst.w   d1
                bpl.s   SKLBZMovePlat_RestorePlatformAfterP1
                jsr     (Kill_Character).l

SKLBZMovePlat_RestorePlatformAfterP1:
                movea.l (sp)+,a0

SKLBZMovePlat_CheckP2Clearance:
                btst    #p2_standing_bit,status(a0)
                beq.s   SKLBZMovePlat_ClearanceReturn
                move.l  a0,-(sp)
                lea     (Player_2).w,a0
                jsr     (CheckPlayerBodyFloorClearance).l
                tst.w   d1
                bpl.s   SKLBZMovePlat_RestorePlatformAfterP2
                jsr     (Kill_Character).l

SKLBZMovePlat_RestorePlatformAfterP2:
                movea.l (sp)+,a0

SKLBZMovePlat_ClearanceReturn:
                rts
; ---------------------------------------------------------------------------

Platform_Square32:
                move.w  #32/2,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$2A).w,d0
                lsr.w   #1,d0
                move.w  (Oscillating_table+$2C).w,d3
                bra.s   SKLBZMovePlat_TryAdvanceSquareSide
; ---------------------------------------------------------------------------

Platform_Square96:
                move.w  #96/2,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$2E).w,d0
                move.w  (Oscillating_table+$30).w,d3
                bra.s   SKLBZMovePlat_TryAdvanceSquareSide
; ---------------------------------------------------------------------------

Platform_Square160:
                move.w  #160/2,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$32).w,d0
                move.w  (Oscillating_table+$34).w,d3
                bra.s   SKLBZMovePlat_TryAdvanceSquareSide
; ---------------------------------------------------------------------------

Platform_Square224:
                move.w  #224/2,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$36).w,d0
                move.w  (Oscillating_table+$38).w,d3

SKLBZMovePlat_TryAdvanceSquareSide:
                tst.w   d3
                bne.s   SKLBZMovePlat_TryPlaceSquareTop
                addq.b  #1,$2E(a0)
                andi.b  #3,$2E(a0)

SKLBZMovePlat_TryPlaceSquareTop:
                move.b  $2E(a0),d2
                andi.b  #3,d2
                bne.s   SKLBZMovePlat_TryPlaceSquareRight
                sub.w   d1,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                neg.w   d1
                add.w   $34(a0),d1
                move.w  d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKLBZMovePlat_TryPlaceSquareRight:
                subq.b  #1,d2
                bne.s   SKLBZMovePlat_TryPlaceSquareBottom
                subq.w  #1,d1
                sub.w   d1,d0
                neg.w   d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                addq.w  #1,d1
                add.w   $30(a0),d1
                move.w  d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKLBZMovePlat_TryPlaceSquareBottom:
                subq.b  #1,d2
                bne.s   SKLBZMovePlat_PlaceSquareLeft
                subq.w  #1,d1
                sub.w   d1,d0
                neg.w   d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                addq.w  #1,d1
                add.w   $34(a0),d1
                move.w  d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKLBZMovePlat_PlaceSquareLeft:
                sub.w   d1,d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                neg.w   d1
                add.w   $30(a0),d1
                move.w  d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------
Map_LBZMovingPlatform:
                include "src/objects/shared/zones/lbz/mappings/moving_platform.s"
