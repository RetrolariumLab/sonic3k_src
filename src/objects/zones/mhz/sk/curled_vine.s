; Owner: objects/zones/mhz/sk
; Responsibility: Curled vine player contact, constrained traversal and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZCurledVine:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKMHZCurlVine_DeleteWithoutDisplay
                move.l  #SKMHZCurlVine_DrawVineDisplay,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_MHZCurledVine,mappings(a1)
                move.w  #make_art_tile(ArtTile_MHZMisc+$C,2,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.w  #$280,priority(a1)
                move.b  #$40,width_pixels(a1)
                move.b  #$30,height_pixels(a1)
                bset    #6,render_flags(a1)
                move.w  #8,mainspr_childsprites(a1)
                move.l  #$FFF40000,$32(a0)
                bset    #7,status(a0)
                move.w  a1,parent3(a0)
                move.l  #SKMHZCurlVine_PickShapeFromRiders,(a0)
                bra.s   SKMHZCurlVine_PickShapeFromRiders
; ---------------------------------------------------------------------------

SKMHZCurlVine_DeleteWithoutDisplay:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKMHZCurlVine_PickShapeFromRiders:
                movea.w parent3(a0),a1
                moveq   #0,d1
                moveq   #0,d2
                move.b  status(a0),d1
                andi.b  #standing_mask,d1
                beq.s   SKMHZCurlVine_LoadWidthAndCurvature
                move.b  $36(a0),d1
                move.b  $37(a0),d2
                cmp.b   d1,d2
                blo.s   SKMHZCurlVine_GetRiderShapeIndex
                move.b  d2,d1

SKMHZCurlVine_GetRiderShapeIndex:
                addq.b  #1,d1

SKMHZCurlVine_LoadWidthAndCurvature:
                move.b  SKMHZCurlVine_SupportWidths(pc,d1.w),d2
                move.w  d2,-(sp)
                lsl.w   #2,d1
                move.l  SKMHZCurlVine_CurvatureTargets(pc,d1.w),d0
                bra.s   SKMHZCurlVine_StepTowardCurvature
; ---------------------------------------------------------------------------
SKMHZCurlVine_CurvatureTargets:
                dc.l    $FFF40000
                dc.l    $FFFA0000
                dc.l    $FFFB0000
                dc.l    $FFFC0000
                dc.l    $FFFD0000
                dc.l    $FFFE0000
                dc.l    $FFFF0000
                dc.l    $FFFF0000
                dc.l    $FFFF0000
SKMHZCurlVine_SupportWidths:
                dc.b    $40
                dc.b    $40
                dc.b    $40
                dc.b    $40
                dc.b    $50
                dc.b    $60
                dc.b    $70
                dc.b    $80
                dc.b    $80
                even
; ---------------------------------------------------------------------------

SKMHZCurlVine_StepTowardCurvature:
                move.l  $32(a0),d4
                cmp.l   d0,d4
                beq.s   SKMHZCurlVine_BeginCurveProjection
                bcs.s   SKMHZCurlVine_IncreaseCurvature
                subi.l  #$10000,d4
                bra.s   SKMHZCurlVine_BeginCurveProjection
; ---------------------------------------------------------------------------

SKMHZCurlVine_IncreaseCurvature:
                addi.l  #$10000,d4

SKMHZCurlVine_BeginCurveProjection:
                move.l  d4,$32(a0)
                move.l  d4,d1
                asr.l   #1,d1
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$38,d2
                move.l  #$A0000,d5
                moveq   #8-1,d6
                lea     sub2_x_pos(a1),a2
                move.l  d1,-(sp)
                bra.s   SKMHZCurlVine_PlaceSegmentsAndRiders
; ---------------------------------------------------------------------------

SKMHZCurlVine_StepCurvePoint:
                move.l  d1,-(sp)
                swap    d5
                move.w  d5,d0
                swap    d5
                jsr     (GetSineCosine).l
                asr.w   #4,d1
                asr.w   #4,d0
                add.w   d1,d2
                add.w   d0,d3

SKMHZCurlVine_PlaceSegmentsAndRiders:
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                addq.w  #2,a2
                add.l   d4,d5
                move.l  (sp)+,d1
                add.l   d1,d4
                dbf     d6,SKMHZCurlVine_StepCurvePoint
                move.w  (sp)+,d2
                move.w  #$40,d1
                moveq   #8,d3
                move.w  x_pos(a0),d4
                movea.l a1,a2
                bsr.w   CheckPlayersOnMhzCurledVine
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKMHZCurlVine_ClearVineRespawnBit
                rts
; ---------------------------------------------------------------------------

SKMHZCurlVine_ClearVineRespawnBit:
                move.w  respawn_addr(a0),d0
                beq.s   SKMHZCurlVine_DeleteDisplayAndRoot
                movea.w d0,a2
                bclr    #7,(a2)

SKMHZCurlVine_DeleteDisplayAndRoot:
                movea.w parent3(a0),a1
                jsr     (Delete_Referenced_Sprite).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKMHZCurlVine_DrawVineDisplay:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CheckPlayersOnMhzCurledVine:
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                moveq   #$37,d5
                movem.l d1-d4,-(sp)
                bsr.s   CheckPlayerOnMhzCurledVineSegments
                movem.l (sp)+,d1-d4
                lea     (Player_1).w,a1
                subq.b  #p2_standing_bit-p1_standing_bit,d6
                moveq   #$36,d5
; End of function CheckPlayersOnMhzCurledVine

; =============== S U B R O U T I N E =======================================

CheckPlayerOnMhzCurledVineSegments:
                btst    d6,status(a0)
                beq.s   SKMHZCurlVine_TryLandOnSegment
                btst    #Status_InAir,status(a1)
                bne.s   SKMHZCurlVine_DetachAndClearSegment
                moveq   #0,d0
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKMHZCurlVine_DetachAndClearSegment
                cmp.w   d2,d0
                blo.s   SKMHZCurlVine_PlaceRiderOnSegment

SKMHZCurlVine_DetachAndClearSegment:
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                move.b  #0,(a0,d5.w)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKMHZCurlVine_PlaceRiderOnSegment:
                lsr.w   #4,d0
                move.b  d0,(a0,d5.w)
                add.w   d0,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                move.w  $1A(a2,d0.w),d0
                subq.w  #8,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                move.w  d0,y_pos(a1)
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

SKMHZCurlVine_TryLandOnSegment:
                tst.w   y_vel(a1)
                bmi.s   SKMHZCurlVine_LandingReturn
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   SKMHZCurlVine_LandingReturn
                cmp.w   d2,d0
                bhs.s   SKMHZCurlVine_LandingReturn
                lsr.w   #4,d0
                add.w   d0,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                move.w  $1A(a2,d0.w),d0
                subq.w  #8,d0
                jmp     (SKPlatform_CheckTopAndSnapRider).l
; ---------------------------------------------------------------------------

SKMHZCurlVine_LandingReturn:
                rts
; End of function CheckPlayerOnMhzCurledVineSegments

; ---------------------------------------------------------------------------
Map_MHZCurledVine:
                include "src/objects/shared/zones/mhz/mappings/curled_vine.s"
