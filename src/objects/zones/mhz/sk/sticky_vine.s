; Owner: objects/zones/mhz/sk
; Responsibility: Sticky vine capture, climbing or movement control and player release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZStickyVine:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKMHZStickVine_DeleteWithoutDisplay
                move.l  #SKMHZStickVine_DrawVineDisplay,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_MHZStickyVine,mappings(a1)
                move.w  #make_art_tile(ArtTile_MHZMisc+$C3,2,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.w  #$200,priority(a1)
                move.b  #$80,width_pixels(a1)
                move.b  #$80,height_pixels(a1)
                bset    #6,render_flags(a1)
                moveq   #8,d1
                move.w  d1,mainspr_childsprites(a1)
                subq.b  #1,d1
                lea     sub2_x_pos(a1),a2

SKMHZStickVine_InitDisplaySegments:
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #0,(a2)+
                dbf     d1,SKMHZStickVine_InitDisplaySegments
                move.w  a1,parent3(a0)
                move.l  #SKMHZStickVine_CheckPlayersAndCull,(a0)
                rts
; ---------------------------------------------------------------------------

SKMHZStickVine_DeleteWithoutDisplay:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKMHZStickVine_CheckPlayersAndCull:
                lea     (Player_1).w,a1
                bsr.s   SKMHZStickVine_TrySelectPlayer
                lea     (Player_2).w,a1
                bsr.s   SKMHZStickVine_TrySelectPlayer
                bra.w   SKMHZStickVine_CullInvisibleRoot
; ---------------------------------------------------------------------------

; Track the selected player without taking object control
SKMHZStickVine_TrySelectPlayer:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$C,d0
                cmpi.w  #$18,d0
                bhs.w   SKMHZStickVine_PlayerSelectReturn
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$18,d0
                cmpi.w  #$30,d0
                bhs.w   SKMHZStickVine_PlayerSelectReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKMHZStickVine_PlayerSelectReturn
                cmpi.b  #4,routine(a1)
                bhs.w   SKMHZStickVine_PlayerSelectReturn
                tst.b   object_control(a1)
                bne.w   SKMHZStickVine_PlayerSelectReturn
                move.l  #SKMHZStickVine_TrackPlayerAndCheckDash,(a0)
                move.l  a1,$2E(a0)

SKMHZStickVine_PlayerSelectReturn:
                rts
; ---------------------------------------------------------------------------

SKMHZStickVine_TrackPlayerAndCheckDash:
                movea.l $2E(a0),a1
                tst.b   spin_dash_flag(a1)
                beq.s   SKMHZStickVine_PlaceSegmentsAndPull
                move.b  #1,$3D(a0)
                move.b  #$10,$3E(a0)

SKMHZStickVine_PlaceSegmentsAndPull:
                move.l  x_pos(a1),d0
                move.l  y_pos(a1),d1
                bsr.w   LayOutMhzStickyVineSegments
                bsr.w   ApplyMhzStickyVinePullToPlayer
                bra.w   SKMHZStickVine_CullInvisibleRoot
; ---------------------------------------------------------------------------

SKMHZStickVine_RecoilFromSavedEndpoint:
                movea.l $2E(a0),a1
                move.l  $30(a0),d0
                move.l  $34(a0),d1
                bsr.w   LayOutMhzStickyVineSegments
                move.w  $30(a0),d0
                sub.w   x_pos(a0),d0
                beq.s   SKMHZStickVine_SetEndpointXAndCheckY
                bcc.s   SKMHZStickVine_RetractPositiveX
                addq.w  #2,d0
                bcc.s   SKMHZStickVine_SetEndpointXAndCheckY
                moveq   #0,d0
                bra.s   SKMHZStickVine_SetEndpointXAndCheckY
; ---------------------------------------------------------------------------

SKMHZStickVine_RetractPositiveX:
                subq.w  #2,d0
                bcc.s   SKMHZStickVine_SetEndpointXAndCheckY
                moveq   #0,d0

SKMHZStickVine_SetEndpointXAndCheckY:
                move.w  d0,d2
                add.w   x_pos(a0),d2
                move.w  d2,$30(a0)
                move.w  $34(a0),d1
                sub.w   y_pos(a0),d1
                beq.s   SKMHZStickVine_TryReturnToIdle
                bcc.s   SKMHZStickVine_ReturnFromBelowRoot
                move.w  y_vel(a0),d2
                addi.w  #$38,y_vel(a0)
                ext.l   d2
                asl.l   #8,d2
                add.l   d2,$34(a0)
                move.w  $34(a0),d2
                cmp.w   y_pos(a0),d2
                blo.s   SKMHZStickVine_TryReturnToIdle
                move.w  y_pos(a0),$34(a0)
                move.w  #0,y_vel(a0)
                bra.s   SKMHZStickVine_TryReturnToIdle
; ---------------------------------------------------------------------------

SKMHZStickVine_ReturnFromBelowRoot:
                tst.w   y_vel(a0)
                bpl.s   SKMHZStickVine_RetractBelowRoot
                move.w  y_vel(a0),d2
                addi.w  #$38,y_vel(a0)
                ext.l   d2
                asl.l   #8,d2
                add.l   d2,$34(a0)
                bra.s   SKMHZStickVine_TryReturnToIdle
; ---------------------------------------------------------------------------

SKMHZStickVine_RetractBelowRoot:
                subq.w  #2,$34(a0)
                move.w  $34(a0),d2
                cmp.w   y_pos(a0),d2
                bhs.s   SKMHZStickVine_TryReturnToIdle
                move.w  y_pos(a0),$34(a0)
                move.w  #0,y_vel(a0)

SKMHZStickVine_TryReturnToIdle:
                or.w    d0,d1
                bne.s   SKMHZStickVine_CullInvisibleRoot
                move.l  #SKMHZStickVine_CheckPlayersAndCull,(a0)

SKMHZStickVine_CullInvisibleRoot:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKMHZStickVine_ClearVineRespawnBit
                rts
; ---------------------------------------------------------------------------

SKMHZStickVine_ClearVineRespawnBit:
                move.w  respawn_addr(a0),d0
                beq.s   SKMHZStickVine_DeleteDisplayAndRoot
                movea.w d0,a2
                bclr    #7,(a2)

SKMHZStickVine_DeleteDisplayAndRoot:
                movea.w parent3(a0),a1
                jsr     (Delete_Referenced_Sprite).l
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

LayOutMhzStickyVineSegments:
                movea.w parent3(a0),a2
                move.l  x_pos(a0),d2
                move.l  y_pos(a0),d3
                sub.l   d2,d0
                sub.l   d3,d1
                movem.l d0-d1,-(sp)
                asr.l   #3,d0
                asr.l   #3,d1
                lea     $48(a2),a3
                moveq   #8-1,d6
                bra.s   SKMHZStickVine_PlaceSegmentsBackward
; ---------------------------------------------------------------------------

SKMHZStickVine_StepSegmentPosition:
                add.l   d0,d2
                add.l   d1,d3

SKMHZStickVine_PlaceSegmentsBackward:
                subq.w  #2,a3
                swap    d3
                move.w  d3,-(a3)
                swap    d3
                swap    d2
                move.w  d2,-(a3)
                swap    d2
                dbf     d6,SKMHZStickVine_StepSegmentPosition
                movem.l (sp)+,d1-d2
                rts
; End of function LayOutMhzStickyVineSegments

; =============== S U B R O U T I N E =======================================

ApplyMhzStickyVinePullToPlayer:
                swap    d1
                swap    d2
                move.w  d1,d3
                bpl.s   SKMHZStickVine_CalcAbsPullY
                neg.w   d3

SKMHZStickVine_CalcAbsPullY:
                move.w  d2,d4
                bpl.s   SKMHZStickVine_ApplyDirectionalPull
                neg.w   d4

; Use twice the sum of the absolute deltas as the magnitude and scale X twice as much as Y
SKMHZStickVine_ApplyDirectionalPull:
                add.w   d4,d3
                add.w   d3,d3
                jsr     (GetArcTan).l
                jsr     (GetSineCosine).l
                muls.w  d3,d1
                muls.w  d3,d0
                asl.l   #1,d0
                asl.l   #2,d1
                sub.l   d1,x_pos(a1)
                btst    #Status_InAir,status(a1)
                beq.s   SKMHZStickVine_GetGroundPullMagnitude
                sub.l   d0,y_pos(a1)
                tst.w   y_vel(a1)
                bmi.s   SKMHZStickVine_TickRecoilDelay
                asr     x_vel(a1)
                bra.s   SKMHZStickVine_TickRecoilDelay
; ---------------------------------------------------------------------------

SKMHZStickVine_GetGroundPullMagnitude:
                asr.l   #8,d1
                tst.w   d1
                bpl.s   SKMHZStickVine_GetGroundSpeedMagnitude
                neg.w   d1

SKMHZStickVine_GetGroundSpeedMagnitude:
                move.w  ground_vel(a1),d0
                bpl.s   SKMHZStickVine_TryDampGroundSpeed
                neg.w   d0

SKMHZStickVine_TryDampGroundSpeed:
                cmpi.w  #$200,d0
                blo.s   SKMHZStickVine_TickRecoilDelay
                subi.w  #$10,d0
                cmp.w   d1,d0
                bhs.s   SKMHZStickVine_TickRecoilDelay
                asr     ground_vel(a1)

SKMHZStickVine_TickRecoilDelay:
                tst.b   $3D(a0)
                beq.s   SKMHZStickVine_ClearPlayerPush
                tst.b   spin_dash_flag(a1)
                bne.s   SKMHZStickVine_ClearPlayerPush
                subq.b  #1,$3E(a0)
                bne.s   SKMHZStickVine_ClearPlayerPush
                move.l  x_pos(a1),$30(a0)
                move.l  y_pos(a1),$34(a0)
                move.w  #-$600,y_vel(a0)
                move.b  #0,$3D(a0)
                move.b  #0,$3E(a0)
                move.l  #SKMHZStickVine_RecoilFromSavedEndpoint,(a0)

SKMHZStickVine_ClearPlayerPush:
                bclr    #Status_Push,status(a1)
                rts
; End of function ApplyMhzStickyVinePullToPlayer

; ---------------------------------------------------------------------------

SKMHZStickVine_DrawVineDisplay:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_MHZStickyVine:
                include "src/objects/shared/zones/mhz/mappings/sticky_vine.s"
