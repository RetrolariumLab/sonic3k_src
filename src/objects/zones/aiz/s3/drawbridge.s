; Owner: objects/zones/aiz/s3
; Responsibility: Angel Island drawbridge initialization, coordinated movement, collision and mapping geometry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZDrawBridge:
                move.l  #Map_AIZDrawBridge,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,1),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #$60,height_pixels(a0)
                ori.b   #$80,status(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                subi.w  #$68,y_pos(a0)
                move.b  #-$40,$38(a0)
                moveq   #-$10,d4
                btst    #1,status(a0)
                beq.s   S3Drawbridge_PickRotationSpeed
                addi.w  #$D0,y_pos(a0)
                move.b  #$40,$38(a0)
                neg.w   d4

S3Drawbridge_PickRotationSpeed:
                move.w  #$200,d1
                btst    #0,status(a0)
                beq.s   S3Drawbridge_TryCreateFirstBank
                neg.w   d1

S3Drawbridge_TryCreateFirstBank:
                move.w  d1,$34(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3Drawbridge_StartTriggerWait
                move.l  #S3Drawbridge_DrawBank,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  priority(a0),priority(a1)
                move.b  #4,render_flags(a1)
                bset    #6,render_flags(a1)
                move.b  #$40,width_pixels(a1)
                move.b  #$40,height_pixels(a1)
                move.w  $30(a0),d2
                move.w  $32(a0),d3
                moveq   #8,d1
                move.w  d1,mainspr_childsprites(a1)
                subq.w  #1,d1
                lea     sub2_x_pos(a1),a2

S3Drawbridge_WriteFirstBankSections:
                add.w   d4,d3
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #1,(a2)+
                dbf     d1,S3Drawbridge_WriteFirstBankSections
                move.w  $30(a1),x_pos(a1)
                move.w  $32(a1),y_pos(a1)
                move.w  a1,$3C(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   S3Drawbridge_StartTriggerWait
                move.l  #S3Drawbridge_DrawBank,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  priority(a0),priority(a1)
                move.b  #4,render_flags(a1)
                bset    #6,render_flags(a1)
                move.b  #$40,width_pixels(a1)
                move.b  #$40,height_pixels(a1)
                moveq   #4,d1
                move.w  d1,mainspr_childsprites(a1)
                subq.w  #1,d1
                lea     sub2_x_pos(a1),a2

S3Drawbridge_WriteSecondBankSections:
                add.w   d4,d3
                move.w  d2,(a2)+
                move.w  d3,(a2)+
                move.w  #1,(a2)+
                dbf     d1,S3Drawbridge_WriteSecondBankSections
                move.w  sub2_x_pos(a1),x_pos(a1)
                move.w  sub2_y_pos(a1),y_pos(a1)
                move.w  a1,$3E(a0)

S3Drawbridge_StartTriggerWait:
                move.l  #S3Drawbridge_TryStartRotation,(a0)

S3Drawbridge_TryStartRotation:
                tst.b   (ZoneButtonRequestOrBridgeReleaseSignal).w
                beq.s   S3Drawbridge_CheckRotationPhase
                tst.b   $36(a0)
                bne.s   S3Drawbridge_CheckRotationPhase
                move.b  #1,$36(a0)
                moveq   #signextendB(sfx_FlipBridge),d0
                jsr     (Play_SFX).l
                move.w  #$68,d1
                btst    #0,status(a0)
                beq.s   S3Drawbridge_PlaceHorizontalCollision
                neg.w   d1

S3Drawbridge_PlaceHorizontalCollision:
                move.w  $30(a0),x_pos(a0)
                move.w  $32(a0),y_pos(a0)
                add.w   d1,x_pos(a0)
                move.b  #$60,width_pixels(a0)
                move.b  #8,height_pixels(a0)

S3Drawbridge_CheckRotationPhase:
                tst.b   $36(a0)
                beq.s   S3Drawbridge_PlacePiecesAndCheckSolid
                tst.b   $38(a0)
                beq.s   S3Drawbridge_BeginCollapseWait
                cmpi.b  #$80,$38(a0)
                bne.s   S3Drawbridge_StepRotationPhase

S3Drawbridge_BeginCollapseWait:
                move.b  #0,$36(a0)
                moveq   #signextendB(sfx_FlipBridge),d0
                jsr     (Play_SFX).l
                move.l  #S3Drawbridge_TryCollapseBanks,(a0)
                bra.s   S3Drawbridge_PlacePiecesAndCheckSolid
; ---------------------------------------------------------------------------

S3Drawbridge_StepRotationPhase:
                move.w  $34(a0),d0
                add.w   d0,$38(a0)

S3Drawbridge_PlacePiecesAndCheckSolid:
                bsr.w   PositionAizDrawbridgePieces
                bra.s   S3Drawbridge_PickSolidRectangle
; ---------------------------------------------------------------------------

S3Drawbridge_TryCollapseBanks:
                tst.b   (SceneOutcomeOrActorReadySignal).w
                beq.s   S3Drawbridge_PickSolidRectangle
                move.l  #S3Drawbridge_TickFinalRiderDelay,(a0)
                move.b  #$E,$34(a0)
                move.l  #S3Drawbridge_TickFragmentDelay,d4
                bra.w   S3Drawbridge_TrySplitFirstBank
; ---------------------------------------------------------------------------

S3Drawbridge_PickSolidRectangle:
                move.w  #$13,d1
                move.w  #$60,d2
                move.w  #$61,d3
                move.b  $38(a0),d0
                beq.s   S3Drawbridge_UseHorizontalRectangle
                cmpi.b  #$40,d0
                beq.s   S3Drawbridge_CheckSolidAndCullAtHinge
                cmpi.b  #-$40,d0
                beq.s   S3Drawbridge_CheckSolidAndCullAtHinge

S3Drawbridge_UseHorizontalRectangle:
                move.w  #$6B,d1
                move.w  #8,d2
                move.w  #8,d3

S3Drawbridge_CheckSolidAndCullAtHinge:
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull2).l
                move.w  $30(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   S3Drawbridge_TryDeleteFirstBank
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Drawbridge_TryDeleteFirstBank:
                move.w  $3C(a0),d0
                beq.s   S3Drawbridge_TryDeleteSecondBank
                movea.w d0,a1
                jsr     (Delete_Referenced_Sprite).l

S3Drawbridge_TryDeleteSecondBank:
                move.w  $3E(a0),d0
                beq.s   S3Drawbridge_ClearRespawnBit
                movea.w d0,a1
                jsr     (Delete_Referenced_Sprite).l

S3Drawbridge_ClearRespawnBit:
                move.w  respawn_addr(a0),d0
                beq.s   S3Drawbridge_DeleteAfterBankCleanup
                movea.w d0,a2
                bclr    #7,(a2)

S3Drawbridge_DeleteAfterBankCleanup:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3Drawbridge_DrawBank:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

PositionAizDrawbridgePieces:
                tst.b   $36(a0)
                beq.w   S3Drawbridge_PositionPiecesReturn
                moveq   #0,d0
                moveq   #0,d1
                move.b  $38(a0),d0
                jsr     (GetSineCosine).l
                move.w  $32(a0),d2
                move.w  $30(a0),d3
                moveq   #0,d6
                movea.w $3C(a0),a1
                move.w  mainspr_childsprites(a1),d6
                subq.w  #1,d6
                bcs.s   S3Drawbridge_PositionPiecesReturn
                swap    d0
                swap    d1
                asr.l   #4,d0
                asr.l   #4,d1
                move.l  d0,d4
                move.l  d1,d5
                lea     sub2_x_pos(a1),a2

S3Drawbridge_PositionFirstBank:
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
                dbf     d6,S3Drawbridge_PositionFirstBank
                move.w  $30(a1),x_pos(a1)
                move.w  $32(a1),y_pos(a1)
                moveq   #0,d6
                movea.w $3E(a0),a1
                move.w  mainspr_childsprites(a1),d6
                subq.w  #1,d6
                bcs.s   S3Drawbridge_PositionPiecesReturn
                lea     sub2_x_pos(a1),a2

S3Drawbridge_PositionSecondBank:
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
                dbf     d6,S3Drawbridge_PositionSecondBank
                move.w  sub2_x_pos(a1),x_pos(a1)
                move.w  sub2_y_pos(a1),y_pos(a1)

S3Drawbridge_PositionPiecesReturn:
                rts
; End of function PositionAizDrawbridgePieces

; ---------------------------------------------------------------------------

S3Drawbridge_TickFragmentDelay:
                tst.b   $34(a0)
                beq.s   S3Drawbridge_FallFragment
                subq.b  #1,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Drawbridge_FallFragment:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bpl.s   S3Drawbridge_DeleteFragment
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Drawbridge_DeleteFragment:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3Drawbridge_TickFinalRiderDelay:
                tst.b   $34(a0)
                beq.s   S3Drawbridge_TryReleaseFinalP1
                subq.b  #1,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Drawbridge_TryReleaseFinalP1:
                bclr    #p1_standing_bit,status(a0)
                beq.s   S3Drawbridge_TryReleaseFinalP2
                bclr    #Status_OnObj,(Player_1+status).w
                bset    #Status_InAir,(Player_1+status).w
                move.b  #$1B,(Player_1+anim).w

S3Drawbridge_TryReleaseFinalP2:
                bclr    #p2_standing_bit,status(a0)
                beq.s   S3Drawbridge_DeleteAfterRiderRelease
                bclr    #Status_OnObj,(Player_2+status).w
                bset    #Status_InAir,(Player_2+status).w
                move.b  #$1B,(Player_2+anim).w

S3Drawbridge_DeleteAfterRiderRelease:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3Drawbridge_TrySplitFirstBank:
                move.w  $3C(a0),d0
                beq.s   S3Drawbridge_TrySplitSecondBank
                movea.w d0,a3
                bsr.s   SplitAizDrawbridgeBankWithExplosions

S3Drawbridge_TrySplitSecondBank:
                move.w  $3E(a0),d0
                beq.s   S3Drawbridge_SplitBanksReturn
                movea.w d0,a3
                bsr.s   SplitAizDrawbridgeBankWithExplosions

S3Drawbridge_SplitBanksReturn:
                rts
; ---------------------------------------------------------------------------

SplitAizDrawbridgeBankWithExplosions:
                lea     (S3Drawbridge_FragmentDelays).l,a4
                lea     sub2_x_pos(a3),a2
                move.w  mainspr_childsprites(a3),d6
                subq.w  #1,d6
                bclr    #6,render_flags(a3)
                movea.l a3,a1
                bra.s   S3Drawbridge_InitFragmentAndTryExplosion
; ---------------------------------------------------------------------------

S3Drawbridge_TryAllocateFragment:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   S3Drawbridge_ClearChildCoordsAndSound

S3Drawbridge_InitFragmentAndTryExplosion:
                move.l  d4,(a1)
                move.l  mappings(a3),mappings(a1)
                move.b  render_flags(a3),render_flags(a1)
                move.w  art_tile(a3),art_tile(a1)
                move.w  priority(a3),priority(a1)
                move.b  width_pixels(a3),width_pixels(a1)
                move.b  height_pixels(a3),height_pixels(a1)
                move.w  priority(a3),priority(a1)
                move.w  (a2)+,x_pos(a1)
                move.w  (a2)+,y_pos(a1)
                move.w  (a2)+,d0
                move.b  d0,mapping_frame(a1)
                move.b  (a4)+,$34(a1)
                movea.l a1,a5
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   S3Drawbridge_ClearChildCoordsAndSound
                move.l  #S3Explosion_InitHighPriorityDelayed,(a1)
                move.w  x_pos(a5),x_pos(a1)
                move.w  y_pos(a5),y_pos(a1)
                move.b  -1(a4),anim_frame_timer(a1)
                dbf     d6,S3Drawbridge_TryAllocateFragment

S3Drawbridge_ClearChildCoordsAndSound:
                move.w  #0,sub2_x_pos(a3)
                move.w  #0,sub2_y_pos(a3)
                moveq   #signextendB(sfx_BridgeCollapse),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------
S3Drawbridge_FragmentDelays:
                dc.b    8
                dc.b    $10
                dc.b    $C
                dc.b    $E
                dc.b    6
                dc.b    $A
                dc.b    4
                dc.b    2
                dc.b    8
                dc.b    $10
                dc.b    $C
                dc.b    $E
                dc.b    6
                dc.b    $A
                dc.b    4
                dc.b    2
                even
Map_AIZDrawBridge:
                include "src/objects/shared/zones/aiz/mappings/drawbridge.s"
