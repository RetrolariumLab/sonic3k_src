; Owner: objects/zones/soz/sk
; Responsibility: Pushable rock collision, player pushing, movement and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SOZPushableRock:
                move.l  #Map_SOZPushableRock,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZMisc+$8C,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #$B,y_radius(a0)
                move.w  #$280,priority(a0)

Load_SOZ_Pushable_Rock_Track_Ride_Info:
                lea     (SOZRockRideInfo).l,a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #$1F,d0
                add.w   d0,d0
                add.w   d0,d0
                movea.l (a1,d0.w),a1
                move.w  (a1)+,$3A(a0)
                move.l  a1,$36(a0)
                tst.b   subtype(a0)
                bpl.s   SKSOZPushRock_InitOrdinaryPush
                move.w  a0,(_unkF7C4).w
                move.l  #SKSOZPushRock_UpdateRegisteredRock,(a0)
                bra.s   SKSOZPushRock_UpdateRegisteredRock
; ---------------------------------------------------------------------------

SKSOZPushRock_InitOrdinaryPush:
                move.l  #SKSOZPushRock_CheckSolidAndPush,(a0)

SKSOZPushRock_CheckSolidAndPush:
                move.b  (Player_1+status).w,$30(a0)
                move.b  (Player_2+status).w,$31(a0)
                move.w  #$1B,d1
                move.w  #$C,d2
                move.w  #$D,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                bsr.w   UpdatePlayerPushingSozRock
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKSOZPushRock_UpdateRegisteredRock:
                bra.s   SKSOZPushRock_CheckSolidAndPush
; ---------------------------------------------------------------------------

SKSOZPushRock_FallAndCheckCameraDepth:
                move.w  x_pos(a0),-(sp)
                jsr     (MoveSprite).l
                move.w  (sp)+,d4
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$120,d0
                cmp.w   y_pos(a0),d0
                bgt.s   SKSOZPushRock_SnapYAndReadNextX
                move.w  #$7F00,d4
                move.w  d4,x_pos(a0)

SKSOZPushRock_SnapYAndReadNextX:
                move.w  $3A(a0),d0
                cmp.w   y_pos(a0),d0
                bhs.s   SKSOZPushRock_CheckTrackSolidAndDraw
                move.w  d0,y_pos(a0)
                move.w  #0,y_vel(a0)
                movea.l $36(a0),a1
                move.w  (a1)+,d0
                bpl.s   SKSOZPushRock_BeginHorizontalLeg
                move.l  #SKSOZPushRock_UpdateStoppedTrackRock,(a0)
                bra.s   SKSOZPushRock_CheckTrackSolidAndDraw
; ---------------------------------------------------------------------------

SKSOZPushRock_BeginHorizontalLeg:
                move.w  d0,$3A(a0)
                move.l  a1,$36(a0)
                move.l  #SKSOZPushRock_MoveHorizontalLeg,(a0)
                move.w  #$100,x_vel(a0)
                cmp.w   x_pos(a0),d0
                bhs.s   SKSOZPushRock_CheckTrackSolidAndDraw
                neg.w   x_vel(a0)

SKSOZPushRock_CheckTrackSolidAndDraw:
                move.w  #$1B,d1
                move.w  #$C,d2
                move.w  #$D,d3
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKSOZPushRock_MoveHorizontalLeg:
                move.w  x_pos(a0),-(sp)
                jsr     (MoveSprite2).l
                move.w  (sp)+,d4
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   SKSOZPushRock_CheckRightwardTarget
                moveq   #signextendB(sfx_BlockConveyor),d0
                jsr     (Play_SFX).l

SKSOZPushRock_CheckRightwardTarget:
                tst.w   x_vel(a0)
                bmi.s   SKSOZPushRock_CheckLeftwardTarget
                move.w  $3A(a0),d0
                cmp.w   x_pos(a0),d0
                bhi.s   SKSOZPushRock_DrawMovingTrackRock
                bra.s   SKSOZPushRock_ReadNextYOrStop
; ---------------------------------------------------------------------------

SKSOZPushRock_CheckLeftwardTarget:
                move.w  $3A(a0),d0
                cmp.w   x_pos(a0),d0
                blo.s   SKSOZPushRock_DrawMovingTrackRock

SKSOZPushRock_ReadNextYOrStop:
                movea.l $36(a0),a1
                move.w  (a1)+,d0
                bpl.s   SKSOZPushRock_BeginNextVerticalLeg
                move.l  #SKSOZPushRock_UpdateStoppedTrackRock,(a0)
                bra.s   SKSOZPushRock_CheckTrackSolidAndDraw
; ---------------------------------------------------------------------------

; Preserve horizontal velocity as the rock starts falling again
SKSOZPushRock_BeginNextVerticalLeg:
                move.w  d0,$3A(a0)
                move.l  a1,$36(a0)
                move.l  #SKSOZPushRock_FallAndCheckCameraDepth,(a0)

SKSOZPushRock_DrawMovingTrackRock:
                bra.s   SKSOZPushRock_CheckTrackSolidAndDraw
; ---------------------------------------------------------------------------

SKSOZPushRock_UpdateStoppedTrackRock:
                move.w  x_pos(a0),d4
                bra.s   SKSOZPushRock_CheckTrackSolidAndDraw

; =============== S U B R O U T I N E =======================================

UpdatePlayerPushingSozRock:
                moveq   #0,d5
                move.b  status(a0),d3
                andi.b  #pushing_mask,d3
                beq.w   SKSOZPushRock_PushSelectionReturn
                move.w  x_pos(a0),d2
                lea     (Player_1).w,a1
                move.b  $30(a0),d0
                moveq   #p1_pushing_bit,d6
                bsr.s   ApplyDelayedPlayerPushToSozRock
                tst.w   d5
                bne.s   SKSOZPushRock_PushSelectionReturn
                lea     (Player_2).w,a1
                move.b  $31(a0),d0
                moveq   #p2_pushing_bit,d6
                bsr.s   ApplyDelayedPlayerPushToSozRock

SKSOZPushRock_PushSelectionReturn:
                rts
; End of function UpdatePlayerPushingSozRock

; =============== S U B R O U T I N E =======================================

ApplyDelayedPlayerPushToSozRock:
                btst    d6,d3
                beq.s   SKSOZPushRock_ApplyPushReturn
                cmp.w   x_pos(a1),d2
                bhs.s   SKSOZPushRock_TryDelayedPushRight
                btst    #5,d0
                beq.s   SKSOZPushRock_ApplyPushReturn
                subq.w  #1,$32(a0)
                bpl.s   SKSOZPushRock_ClaimPushForOnePlayer
                move.w  #4,$32(a0)
                subq.w  #1,x_pos(a0)
                subq.w  #1,x_pos(a1)
                bsr.s   PlaySozRockPushSound
                move.w  x_pos(a0),d3
                addi.w  #$10,d3
                jsr     (ObjCheckFloorDist2).l
                cmpi.w  #$E,d1
                bgt.s   SKSOZPushRock_BeginFallAtEdge
                add.w   d1,y_pos(a0)

SKSOZPushRock_ClaimPushForOnePlayer:
                moveq   #1,d5
                rts
; ---------------------------------------------------------------------------

SKSOZPushRock_TryDelayedPushRight:
                btst    #5,d0
                beq.s   SKSOZPushRock_ApplyPushReturn
                subq.w  #1,$32(a0)
                bpl.s   SKSOZPushRock_ClaimPushForOnePlayer
                move.w  #4,$32(a0)
                addq.w  #1,x_pos(a0)
                addq.w  #1,x_pos(a1)
                bsr.s   PlaySozRockPushSound
                move.w  x_pos(a0),d3
                subi.w  #$10,d3
                jsr     (ObjCheckFloorDist2).l
                cmpi.w  #$E,d1
                bgt.s   SKSOZPushRock_BeginFallAtEdge
                add.w   d1,y_pos(a0)
                moveq   #1,d5

SKSOZPushRock_ApplyPushReturn:
                rts
; ---------------------------------------------------------------------------

SKSOZPushRock_BeginFallAtEdge:
                bset    #1,status(a0)
                move.l  #SKSOZPushRock_FallAndCheckCameraDepth,(a0)
                moveq   #1,d5
                rts
; End of function ApplyDelayedPlayerPushToSozRock

; =============== S U B R O U T I N E =======================================

PlaySozRockPushSound:
                moveq   #signextendB(sfx_PushBlock),d0
                jmp     (Play_SFX).l
; End of function PlaySozRockPushSound

; ---------------------------------------------------------------------------
Map_SOZPushableRock:
                include "src/objects/shared/zones/soz/mappings/pushable_rock.s"
