; Owner: objects/shared/sk
; Responsibility: Spike orientation, movement, player collision and damage responses with competition variants and mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
SKSpikes_NormalSizePairs:
                dc.b    $10, $10
                dc.b    $20, $10
                dc.b    $30, $10
                dc.b    $40, $10
                dc.b    $10, $10
                dc.b    $10, $20
                dc.b    $10, $30
                dc.b    $10, $40
                even
; ---------------------------------------------------------------------------

Obj_Spikes:
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  subtype(a0),d0
                andi.w  #$F0,d0
                lsr.w   #3,d0
                tst.w   (Competition_mode).w
                bne.w   SKSpikes_InitCompGeometryAndHandler
                lea     SKSpikes_NormalSizePairs(pc,d0.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.l  #SKSpikes_UpdateNormalStandingHazard,(a0)
                move.l  #Map_Spikes,mappings(a0)
                move.w  #make_art_tile(ArtTile_SpikesSprings+$8,0,0),art_tile(a0)
                cmpi.b  #4,(Current_zone).w
                bne.s   SKSpikes_SelectNormalFrameAndSideHandler
                move.w  #make_art_tile(ArtTile_FBZSpikes,0,0),art_tile(a0)

SKSpikes_SelectNormalFrameAndSideHandler:
                lsr.w   #1,d0
                move.b  d0,mapping_frame(a0)
                cmpi.b  #4,d0
                blo.s   SKSpikes_SelectNormalDangerSide
                move.l  #SKSpikes_UpdateNormalSideContactHazard,(a0)
                move.w  #make_art_tile(ArtTile_SpikesSprings,0,0),art_tile(a0)

SKSpikes_SelectNormalDangerSide:
                move.b  status(a0),d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKSpikes_TestGravityAdjustedDangerSide
                eori.b  #2,d0

SKSpikes_TestGravityAdjustedDangerSide:
                andi.b  #2,d0
                beq.s   SKSpikes_SaveNormalAnchorsAndMode
                move.l  #SKSpikes_CheckNormalUnderside,(a0)

SKSpikes_SaveNormalAnchorsAndMode:
                move.w  #$20,$3C(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  subtype(a0),d0
                andi.b  #$F,d0
                add.b   d0,d0
                move.b  d0,subtype(a0)
                rts
; ---------------------------------------------------------------------------
SKSpikes_CompetitionSizePairs:
                dc.b    $C,  $C
                dc.b    $18,  $C
                dc.b    $24,  $C
                dc.b    $30,  $C
                dc.b    $C,  $C
                dc.b    $C, $18
                dc.b    $C, $24
                dc.b    $C, $30
; ---------------------------------------------------------------------------

SKSpikes_InitCompGeometryAndHandler:
                lea     SKSpikes_CompetitionSizePairs(pc,d0.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.l  #SKSpikes_UpdateCompetitionStandingHazard,(a0)
                move.l  #Map_2PSpikes,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PArt_2,0,0),art_tile(a0)
                lsr.w   #1,d0
                move.b  d0,mapping_frame(a0)
                cmpi.b  #4,d0
                blo.s   SKSpikes_CheckCompUndersideOverride
                move.l  #SKSpikes_CheckCompSideContacts,(a0)

SKSpikes_CheckCompUndersideOverride:
                btst    #1,status(a0)
                beq.s   SKSpikes_SaveCompAnchorsAndMode
                move.l  #SKSpikes_CheckCompUndersideContacts,(a0)

SKSpikes_SaveCompAnchorsAndMode:
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  subtype(a0),d0
                andi.b  #$F,d0
                add.b   d0,d0
                move.b  d0,subtype(a0)
                rts
; ---------------------------------------------------------------------------

SKSpikes_UpdateNormalStandingHazard:
                bsr.w   UpdateSpikePosition
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull
                move.b  status(a0),d6
                andi.b  #standing_mask,d6
                beq.s   SKSpikes_CullAndDrawNormalStandingHazard
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   SKSpikes_HurtNormalStandingPlayerTwo
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard

SKSpikes_HurtNormalStandingPlayerTwo:
                andi.b  #p2_standing,d6
                beq.s   SKSpikes_CullAndDrawNormalStandingHazard
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard

SKSpikes_CullAndDrawNormalStandingHazard:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

SKSpikes_UpdateNormalSideContactHazard:
                bsr.w   UpdateSpikePosition
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull
                swap    d6
                andi.w  #1|2,d6
                beq.s   SKSpikes_CullAndDrawNormalSideHazard
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   SKSpikes_HurtNormalSideContactPlayerTwo
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard
                bclr    #p1_pushing_bit,status(a0)

SKSpikes_HurtNormalSideContactPlayerTwo:
                andi.b  #2,d6
                beq.s   SKSpikes_CullAndDrawNormalSideHazard
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard
                bclr    #p2_pushing_bit,status(a0)

SKSpikes_CullAndDrawNormalSideHazard:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

SKSpikes_CheckNormalUnderside:
                bsr.w   UpdateSpikePosition
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull
                swap    d6
                andi.w  #4|8,d6
                beq.s   SKSpikes_DrawNormalUndersideByAnchor
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   SKSpikes_HurtNormalUndersidePlayerTwo
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard

SKSpikes_HurtNormalUndersidePlayerTwo:
                andi.b  #8,d6
                beq.s   SKSpikes_DrawNormalUndersideByAnchor
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard

SKSpikes_DrawNormalUndersideByAnchor:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

SKSpikes_UpdateCompetitionStandingHazard:
                bsr.w   UpdateCompetitionSpikePosition
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #7,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull
                move.b  status(a0),d6
                andi.b  #standing_mask,d6
                beq.s   SKSpikes_DrawCompetitionStandingHazard
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   SKSpikes_TryHurtCompStandingP2
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard

SKSpikes_TryHurtCompStandingP2:
                andi.b  #p2_standing,d6
                beq.s   SKSpikes_DrawCompetitionStandingHazard
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard

SKSpikes_DrawCompetitionStandingHazard:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSpikes_CheckCompSideContacts:
                bsr.w   UpdateCompetitionSpikePosition
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #7,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull
                swap    d6
                andi.w  #1|2,d6
                beq.s   SKSpikes_DrawCompetitionSideHazard
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   SKSpikes_TryHurtCompSideP2
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard
                bclr    #p1_pushing_bit,status(a0)

SKSpikes_TryHurtCompSideP2:
                andi.b  #2,d6
                beq.s   SKSpikes_DrawCompetitionSideHazard
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard
                bclr    #p2_pushing_bit,status(a0)

SKSpikes_DrawCompetitionSideHazard:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSpikes_CheckCompUndersideContacts:
                bsr.w   UpdateCompetitionSpikePosition
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #7,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull
                swap    d6
                andi.w  #4|8,d6
                beq.s   SKSpikes_DrawCompetitionUndersideHazard
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   SKSpikes_TryHurtCompUnderP2
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard

SKSpikes_TryHurtCompUnderP2:
                andi.b  #8,d6
                beq.s   SKSpikes_DrawCompetitionUndersideHazard
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard

SKSpikes_DrawCompetitionUndersideHazard:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

HurtPlayerFromSolidHazard:
                btst    #Status_Invincible,status_secondary(a1)
                bne.s   SKSpikes_HazardDamageReturn
                tst.b   invulnerability_timer(a1)
                bne.s   SKSpikes_HazardDamageReturn
                cmpi.b  #4,routine(a1)
                bhs.s   SKSpikes_HazardDamageReturn
                move.l  y_pos(a1),d3
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                sub.l   d0,d3
                move.l  d3,y_pos(a1)
                movea.l a0,a2
                movea.l a1,a0
                jsr     (HurtCharacter).l
                movea.l a2,a0

SKSpikes_HazardDamageReturn:
                rts
; End of function HurtPlayerFromSolidHazard

; =============== S U B R O U T I N E =======================================

UpdateSpikePosition:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SKSpikes_NormalMovementOffsets(pc,d0.w),d1
                jmp     SKSpikes_NormalMovementOffsets(pc,d1.w)
; End of function UpdateSpikePosition

; ---------------------------------------------------------------------------
SKSpikes_NormalMovementOffsets:
                dc.w    SKSpikes_ReturnFromStationaryMovement-SKSpikes_NormalMovementOffsets
                dc.w    SKSpikes_ApplyNormalVerticalTravel-SKSpikes_NormalMovementOffsets
                dc.w    SKSpikes_ApplyNormalHorizontalTravel-SKSpikes_NormalMovementOffsets
                dc.w    SKSpikes_CheckCachedRightPush-SKSpikes_NormalMovementOffsets
; ---------------------------------------------------------------------------

SKSpikes_ReturnFromStationaryMovement:
                rts
; ---------------------------------------------------------------------------

SKSpikes_ApplyNormalVerticalTravel:
                bsr.w   UpdateSpikeTravel
                moveq   #0,d0
                move.b  $34(a0),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKSpikes_ApplyNormalHorizontalTravel:
                bsr.w   UpdateSpikeTravel
                moveq   #0,d0
                move.b  $34(a0),d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                rts

; =============== S U B R O U T I N E =======================================

UpdateSpikeTravel:
                tst.w   $38(a0)
                beq.s   SKSpikes_AdvanceNormalTravelOrRetract
                subq.w  #1,$38(a0)
                bne.s   SKSpikes_ReturnFromNormalTravelUpdate
                tst.b   render_flags(a0)
                bpl.s   SKSpikes_ReturnFromNormalTravelUpdate
                moveq   #signextendB(sfx_SpikeMove),d0
                jsr     (Play_SFX).l
                bra.s   SKSpikes_ReturnFromNormalTravelUpdate
; ---------------------------------------------------------------------------

SKSpikes_AdvanceNormalTravelOrRetract:
                tst.w   $36(a0)
                beq.s   SKSpikes_ExtendNormalAndPause
                subi.w  #$800,$34(a0)
                bcc.s   SKSpikes_ReturnFromNormalTravelUpdate
                move.w  #0,$34(a0)
                move.w  #0,$36(a0)
                move.w  #60,$38(a0)
                bra.s   SKSpikes_ReturnFromNormalTravelUpdate
; ---------------------------------------------------------------------------

; Advance eight pixels per step and pause at 32 pixels of extension
SKSpikes_ExtendNormalAndPause:
                addi.w  #$800,$34(a0)
                cmpi.w  #$2000,$34(a0)
                blo.s   SKSpikes_ReturnFromNormalTravelUpdate
                move.w  #$2000,$34(a0)
                move.w  #1,$36(a0)
                move.w  #60,$38(a0)

SKSpikes_ReturnFromNormalTravelUpdate:
                rts
; End of function UpdateSpikeTravel

; ---------------------------------------------------------------------------

SKSpikes_CheckCachedRightPush:
                move.b  status(a0),d3
                andi.b  #pushing_mask,d3
                beq.s   SKSpikes_CachePlayerStatusesForPushRight
                move.w  x_pos(a0),d2
                lea     (Player_1).w,a1
                move.b  $3E(a0),d0
                moveq   #5,d6
                bsr.s   StepPushableSpikesRightForPlayer
                lea     (Player_2).w,a1
                move.b  $3F(a0),d0
                moveq   #6,d6
                bsr.s   StepPushableSpikesRightForPlayer

SKSpikes_CachePlayerStatusesForPushRight:
                move.b  (Player_1+status).w,$3E(a0)
                move.b  (Player_2+status).w,$3F(a0)
                rts

; =============== S U B R O U T I N E =======================================

StepPushableSpikesRightForPlayer:
                btst    d6,d3
                beq.s   SKSpikes_PushRightReturn
                cmp.w   x_pos(a1),d2
                blo.s   SKSpikes_PushRightReturn
                btst    #5,d0
                beq.s   SKSpikes_PushRightReturn
                subq.w  #1,$3A(a0)
                bpl.s   SKSpikes_PushRightReturn
                move.w  #$10,$3A(a0)
                tst.w   $3C(a0)
                beq.s   SKSpikes_PushRightReturn
                subq.w  #1,$3C(a0)
                addq.w  #1,x_pos(a0)
                addq.w  #1,x_pos(a1)

SKSpikes_PushRightReturn:
                rts
; End of function StepPushableSpikesRightForPlayer

; =============== S U B R O U T I N E =======================================

UpdateCompetitionSpikePosition:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SKSpikes_CompetitionMovementOffsets(pc,d0.w),d1
                jmp     SKSpikes_CompetitionMovementOffsets(pc,d1.w)
; End of function UpdateCompetitionSpikePosition

; ---------------------------------------------------------------------------
SKSpikes_CompetitionMovementOffsets:
                dc.w    SKSpikes_ReturnFromStationaryMovement-SKSpikes_CompetitionMovementOffsets
                dc.w    SKSpikes_ApplyCompetitionVerticalTravel-SKSpikes_CompetitionMovementOffsets
                dc.w    SKSpikes_MoveCompSpikesX-SKSpikes_CompetitionMovementOffsets
; ---------------------------------------------------------------------------

SKSpikes_ApplyCompetitionVerticalTravel:
                bsr.w   UpdateCompetitionSpikeTravel
                moveq   #0,d0
                move.b  $34(a0),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKSpikes_MoveCompSpikesX:
                bsr.w   UpdateCompetitionSpikeTravel
                moveq   #0,d0
                move.b  $34(a0),d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                rts

; =============== S U B R O U T I N E =======================================

UpdateCompetitionSpikeTravel:
                tst.w   $38(a0)
                beq.s   SKSpikes_TickCompTravel
                subq.w  #1,$38(a0)
                bne.s   SKSpikes_CompTravelReturn
                tst.b   render_flags(a0)
                bpl.s   SKSpikes_CompTravelReturn
                moveq   #signextendB(sfx_SpikeMove),d0
                jsr     (Play_SFX).l
                bra.s   SKSpikes_CompTravelReturn
; ---------------------------------------------------------------------------

SKSpikes_TickCompTravel:
                tst.w   $36(a0)
                beq.s   SKSpikes_ExtendCompAndPause
                subi.w  #$800,$34(a0)
                bcc.s   SKSpikes_CompTravelReturn
                move.w  #0,$34(a0)
                move.w  #0,$36(a0)
                move.w  #60,$38(a0)
                bra.s   SKSpikes_CompTravelReturn
; ---------------------------------------------------------------------------

; Advance eight pixels per step and pause at 24 pixels of extension
SKSpikes_ExtendCompAndPause:
                addi.w  #$800,$34(a0)
                cmpi.w  #$1800,$34(a0)
                blo.s   SKSpikes_CompTravelReturn
                move.w  #$1800,$34(a0)
                move.w  #1,$36(a0)
                move.w  #60,$38(a0)

SKSpikes_CompTravelReturn:
                rts
; End of function UpdateCompetitionSpikeTravel

; ---------------------------------------------------------------------------
Map_Spikes:
                include "src/objects/shared/level_misc/mappings/spikes.s"
Map_2PSpikes:
                include "src/game/competition/shared/mappings/spikes.s"
