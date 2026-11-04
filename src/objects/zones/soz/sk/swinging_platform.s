; Owner: objects/zones/soz/sk
; Responsibility: Swinging platform coordinated motion, player riding and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZSwingingPlatform:
                move.l  #Map_SOZSwingingPlatform,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKSOZSwingPlatform_InitSwingMotion
                move.l  #Draw_Sprite,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  #4,render_flags(a1)
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

; The loop assumes the subtype's link count is nonzero
SKSOZSwingPlatform_InitChainLinks:
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #1,(a2)+
                dbf     d1,SKSOZSwingPlatform_InitChainLinks
                move.b  #2,sub2_mapframe(a1)
                move.b  #1,mapping_frame(a1)
                move.w  a1,$3C(a0)

SKSOZSwingPlatform_InitSwingMotion:
                move.w  #$4000,angle(a0)
                move.w  #0,$32(a0)
                andi.b  #$F0,subtype(a0)
                move.l  #SKSOZSwingPlatform_MoveAndCheckTopSolid,(a0)

SKSOZSwingPlatform_MoveAndCheckTopSolid:
                move.w  x_pos(a0),-(sp)
                bsr.w   PositionSozSwingPlatformAndChain
                move.w  #$20,d1
                move.w  #$11,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectTop).l
                move.w  $44(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKSOZSwingPlatform_ClearPlacementRespawn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSOZSwingPlatform_ClearPlacementRespawn:
                move.w  respawn_addr(a0),d0
                beq.s   SKSOZSwingPlatform_DeleteChainAndRoot
                movea.w d0,a2
                bclr    #7,(a2)

SKSOZSwingPlatform_DeleteChainAndRoot:
                movea.w $3C(a0),a1
                jsr     (Delete_Referenced_Sprite).l
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

PositionSozSwingPlatformAndChain:
                moveq   #0,d0
                moveq   #0,d1
                move.b  (Oscillating_table+$1A).w,d0
                addi.b  #$80,d0
                tst.b   subtype(a0)
                beq.s   SKSOZSwingPlatform_CheckPhaseChange
                bsr.w   AdvanceRiderDrivenSozSwingAngle

SKSOZSwingPlatform_CheckPhaseChange:
                cmp.b   $36(a0),d0
                beq.w   SKSOZSwingPlatform_GeometryReturn
                move.b  d0,$36(a0)
                btst    #0,status(a0)
                beq.s   SKSOZSwingPlatform_TryMirrorAngleAgain
                neg.w   d0
                addi.w  #$80,d0

SKSOZSwingPlatform_TryMirrorAngleAgain:
                btst    #1,status(a0)
                beq.s   SKSOZSwingPlatform_BuildChainGeometry
                neg.w   d0

; After the first record, place the next link one and a half steps from the origin
SKSOZSwingPlatform_BuildChainGeometry:
                jsr     (GetSineCosine).l
                move.w  $46(a0),d2
                move.w  $44(a0),d3
                moveq   #0,d6
                movea.w $3C(a0),a1
                move.w  mainspr_childsprites(a1),d6
                subq.w  #2,d6
                bcs.w   SKSOZSwingPlatform_GeometryReturn
                swap    d0
                swap    d1
                asr.l   #4,d0
                asr.l   #4,d1
                move.l  d0,d4
                move.l  d1,d5
                asr.l   #1,d4
                asr.l   #1,d5
                add.l   d0,d4
                add.l   d1,d5
                lea     sub3_x_pos(a1),a2

; The chain actor reuses its animation timer and angle words to cache the endpoint
SKSOZSwingPlatform_PlaceRemainingLinks:
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
                dbf     d6,SKSOZSwingPlatform_PlaceRemainingLinks
                movem.l d4-d5,-(sp)
                swap    d4
                swap    d5
                add.w   d2,d4
                add.w   d3,d5
                move.w  anim_frame_timer(a1),d2
                move.w  angle(a1),d3
                move.w  d5,anim_frame_timer(a1)
                move.w  d4,angle(a1)
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                movem.l (sp)+,d4-d5
                asr.l   #1,d0
                asr.l   #1,d1
                add.l   d0,d4
                add.l   d1,d5
                swap    d4
                swap    d5
                add.w   $46(a0),d4
                add.w   $44(a0),d5
                move.w  d4,y_pos(a0)
                tst.b   subtype(a0)
                beq.s   SKSOZSwingPlatform_StorePlatformX
                subi.w  #$18,d5
                btst    #0,status(a0)
                beq.s   SKSOZSwingPlatform_StorePlatformX
                addi.w  #$30,d5

SKSOZSwingPlatform_StorePlatformX:
                move.w  d5,x_pos(a0)

SKSOZSwingPlatform_GeometryReturn:
                rts
; End of function PositionSozSwingPlatformAndChain

; =============== S U B R O U T I N E =======================================

AdvanceRiderDrivenSozSwingAngle:
                tst.w   $34(a0)
                beq.s   SKSOZSwingPlatform_TryStartFromP1
                btst    #3,status(a0)
                bne.s   SKSOZSwingPlatform_ReturnAngleHighByte
                subq.w  #1,$34(a0)
                bra.w   SKSOZSwingPlatform_ReturnAngleHighByte
; ---------------------------------------------------------------------------

SKSOZSwingPlatform_TryStartFromP1:
                tst.b   $31(a0)
                bne.s   SKSOZSwingPlatform_StepPositiveSwing
                btst    #3,status(a0)
                beq.s   SKSOZSwingPlatform_ReturnAngleHighByte
                tst.w   (Debug_placement_mode).w
                bne.w   SKSOZSwingPlatform_ReturnAngleHighByte
                move.b  #1,$31(a0)

SKSOZSwingPlatform_StepPositiveSwing:
                tst.b   $30(a0)
                bne.s   SKSOZSwingPlatform_StepNegativeSwing
                move.w  $32(a0),d0
                addi.w  #8,d0
                move.w  d0,$32(a0)
                add.w   d0,angle(a0)
                tst.w   d0
                bne.s   SKSOZSwingPlatform_TrySwitchToDecel
                move.b  #0,$31(a0)

SKSOZSwingPlatform_TrySwitchToDecel:
                cmpi.b  #$80,angle(a0)
                blo.s   SKSOZSwingPlatform_ReturnAngleHighByte
                move.b  #1,$30(a0)
                bra.s   SKSOZSwingPlatform_ReturnAngleHighByte
; ---------------------------------------------------------------------------

SKSOZSwingPlatform_StepNegativeSwing:
                move.w  $32(a0),d0
                subi.w  #8,d0
                move.w  d0,$32(a0)
                add.w   d0,angle(a0)
                tst.w   d0
                bne.s   SKSOZSwingPlatform_TrySwitchToAccel
                move.w  #$1E,$34(a0)

SKSOZSwingPlatform_TrySwitchToAccel:
                cmpi.b  #$80,angle(a0)
                bhs.s   SKSOZSwingPlatform_ReturnAngleHighByte
                move.b  #0,$30(a0)

SKSOZSwingPlatform_ReturnAngleHighByte:
                move.b  angle(a0),d0
                rts
; End of function AdvanceRiderDrivenSozSwingAngle

; ---------------------------------------------------------------------------
Map_SOZSwingingPlatform:
                include "src/objects/shared/zones/soz/mappings/swinging_platform.s"
