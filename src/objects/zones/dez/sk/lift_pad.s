; Owner: objects/zones/dez/sk
; Responsibility: Lift pad motion, player contact, transport and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZLiftPad:
                move.l  #Map_DEZLiftPad,mappings(a0)
                move.w  #make_art_tile(ArtTile_DEZMisc2+$6,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKDEZLiftPad_InitLiftMotion
                move.l  #Draw_Sprite,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  #$60,width_pixels(a1)
                move.b  #$60,height_pixels(a1)
                move.w  #$280,priority(a1)
                move.w  x_pos(a0),d2
                move.w  d2,x_pos(a1)
                move.w  y_pos(a0),d3
                move.w  d3,y_pos(a1)
                bset    #6,render_flags(a1)
                lea     sub2_x_pos(a1),a2
                move.b  subtype(a0),d1
                andi.w  #$F,d1
                move.w  d1,mainspr_childsprites(a1)
                subq.w  #1,d1

; The loop assumes the subtype's segment count is nonzero
SKDEZLiftPad_InitArmSegments:
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #1,(a2)+
                dbf     d1,SKDEZLiftPad_InitArmSegments
                move.b  #2,sub2_mapframe(a1)
                move.b  #1,mapping_frame(a1)
                move.w  a1,$3E(a0)

SKDEZLiftPad_InitLiftMotion:
                move.w  #0,angle(a0)
                move.w  #0,$32(a0)
                move.b  #-1,$36(a0)
                andi.b  #$F0,subtype(a0)
                move.l  #SKDEZLiftPad_MoveAndCheckTopSolid,(a0)

SKDEZLiftPad_MoveAndCheckTopSolid:
                move.w  x_pos(a0),-(sp)
                bsr.w   PositionDezLiftPadAndArmSegments
                move.w  #$18,d1
                move.w  #9,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectTop).l
                move.w  $44(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKDEZLiftPad_ClearPlacementRespawn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKDEZLiftPad_ClearPlacementRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   SKDEZLiftPad_DeleteArmAndRoot
                movea.w d0,a2
                bclr    #7,(a2)

SKDEZLiftPad_DeleteArmAndRoot:
                movea.w $3E(a0),a1
                jsr     (Delete_Referenced_Sprite).l
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

PositionDezLiftPadAndArmSegments:
                moveq   #0,d0
                moveq   #0,d1
                bsr.w   AdvanceDezLiftPadAngularMotion
                cmp.b   $36(a0),d0
                beq.w   SKDEZLiftPad_GeometryReturn
                move.b  d0,$36(a0)
                btst    #4,subtype(a0)
                beq.s   SKDEZLiftPad_TryRemapLiftPhase
                neg.w   d0
                btst    #5,subtype(a0)
                beq.s   SKDEZLiftPad_RotateAndReflectPhase
                neg.w   d0
                addi.w  #$C0,d0
                bra.s   SKDEZLiftPad_RotateAndReflectPhase
; ---------------------------------------------------------------------------

SKDEZLiftPad_TryRemapLiftPhase:
                btst    #5,subtype(a0)
                beq.s   SKDEZLiftPad_RotateAndReflectPhase
                neg.w   d0
                addi.w  #$40,d0

SKDEZLiftPad_RotateAndReflectPhase:
                addi.w  #$80,d0
                btst    #0,status(a0)
                beq.s   SKDEZLiftPad_CalcArmSegmentStep
                neg.w   d0
                addi.w  #$80,d0

SKDEZLiftPad_CalcArmSegmentStep:
                jsr     (GetSineCosine).l
                move.w  $46(a0),d2
                move.w  $44(a0),d3
                moveq   #0,d6
                movea.w $3E(a0),a1
                move.w  mainspr_childsprites(a1),d6
                subq.w  #2,d6
                bcs.w   SKDEZLiftPad_GeometryReturn
                swap    d0
                swap    d1
                asr.l   #4,d0
                asr.l   #4,d1
                move.l  d0,d4
                move.l  d1,d5
                lea     sub3_x_pos(a1),a2

SKDEZLiftPad_PlaceArmSegments:
                movem.l d4-d5,-(sp)
                swap    d4
                swap    d5
                add.w   d2,d4
                add.w   d3,d5
                move.w  d5,(a2)+
                move.w  d4,(a2)+
                movem.l (sp)+,d4-d5
                add.l   d0,d4
                add.l   d1,d5
                addq.w  #2,a2
                dbf     d6,SKDEZLiftPad_PlaceArmSegments
                movem.l d4-d5,-(sp)
                swap    d4
                swap    d5
                add.w   d2,d4
                add.w   d3,d5
                move.w  $24(a1),d2
                move.w  angle(a1),d3
                move.w  d5,$24(a1)
                move.w  d4,angle(a1)
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                movem.l (sp)+,d4-d5
                add.l   d0,d4
                add.l   d1,d5
                swap    d4
                swap    d5
                add.w   $46(a0),d4
                add.w   $44(a0),d5
                move.w  d4,y_pos(a0)
                subi.w  #$20,d5
                btst    #0,status(a0)
                beq.s   SKDEZLiftPad_StoreLiftEndpointX
                addi.w  #$40,d5

SKDEZLiftPad_StoreLiftEndpointX:
                move.w  d5,x_pos(a0)

SKDEZLiftPad_GeometryReturn:
                rts
; End of function PositionDezLiftPadAndArmSegments

; =============== S U B R O U T I N E =======================================

AdvanceDezLiftPadAngularMotion:
                tst.w   $34(a0)
                beq.s   SKDEZLiftPad_TryStartCycleFromP1
                btst    #p1_standing_bit,status(a0)
                bne.w   SKDEZLiftPad_ReturnAngleHighByte
                subq.w  #1,$34(a0)
                bra.w   SKDEZLiftPad_ReturnAngleHighByte
; ---------------------------------------------------------------------------

SKDEZLiftPad_TryStartCycleFromP1:
                tst.b   $31(a0)
                bne.s   SKDEZLiftPad_StepAngularAcceleration
                btst    #p1_standing_bit,status(a0)
                beq.s   SKDEZLiftPad_ReturnAngleHighByte
                tst.w   (Debug_placement_mode).w
                bne.w   SKDEZLiftPad_ReturnAngleHighByte
                move.b  #1,$31(a0)
                moveq   #signextendB(sfx_GravityLift),d0
                jsr     (Play_SFX).l

SKDEZLiftPad_StepAngularAcceleration:
                tst.b   $30(a0)
                bne.s   SKDEZLiftPad_StepAngularDeceleration
                move.w  $32(a0),d0
                addi.w  #8,d0
                move.w  d0,$32(a0)
                add.w   d0,angle(a0)
                tst.w   d0
                bne.s   SKDEZLiftPad_TryBeginDeceleration
                move.b  #0,$31(a0)

SKDEZLiftPad_TryBeginDeceleration:
                cmpi.b  #$20,angle(a0)
                blo.s   SKDEZLiftPad_ReturnAngleHighByte
                move.b  #1,$30(a0)
                bra.s   SKDEZLiftPad_ReturnAngleHighByte
; ---------------------------------------------------------------------------

SKDEZLiftPad_StepAngularDeceleration:
                move.w  $32(a0),d0
                subi.w  #8,d0
                move.w  d0,$32(a0)
                add.w   d0,angle(a0)
                tst.w   d0
                bne.s   SKDEZLiftPad_TryResumeAcceleration
                move.w  #30,$34(a0)

SKDEZLiftPad_TryResumeAcceleration:
                cmpi.b  #$20,angle(a0)
                bhs.s   SKDEZLiftPad_ReturnAngleHighByte
                move.b  #0,$30(a0)

SKDEZLiftPad_ReturnAngleHighByte:
                move.b  angle(a0),d0
                rts
; End of function AdvanceDezLiftPadAngularMotion

; ---------------------------------------------------------------------------
Map_DEZLiftPad:
                include "src/objects/shared/zones/dez/mappings/lift_pad.s"
