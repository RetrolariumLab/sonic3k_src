; Owner: objects/shared/s3
; Responsibility: Spike orientation, movement, player collision and damage responses with competition variants and mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
S3Spikes_NormalSizePairs:
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
                bne.s   S3Spikes_InitCompGeometryAndHandler
                lea     S3Spikes_NormalSizePairs(pc,d0.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.l  #S3Spikes_UpdateNormalStandingHazard,(a0)
                move.l  #Map_Spikes,mappings(a0)
                move.w  #make_art_tile(ArtTile_SpikesSprings+$8,0,0),art_tile(a0)
                lsr.w   #1,d0
                move.b  d0,mapping_frame(a0)
                cmpi.b  #4,d0
                blo.s   S3Spikes_SelectNormalDangerSide
                move.l  #S3Spikes_UpdateNormalSideContactHazard,(a0)
                move.w  #make_art_tile(ArtTile_SpikesSprings,0,0),art_tile(a0)

S3Spikes_SelectNormalDangerSide:
                btst    #1,status(a0)
                beq.s   S3Spikes_SaveNormalAnchorsAndMode
                move.l  #S3Spikes_CheckNormalUnderside,(a0)

S3Spikes_SaveNormalAnchorsAndMode:
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  subtype(a0),d0
                andi.b  #$F,d0
                add.b   d0,d0
                move.b  d0,subtype(a0)
                rts
; ---------------------------------------------------------------------------
S3Spikes_CompetitionSizePairs:
                dc.b    $C,  $C
                dc.b    $18,  $C
                dc.b    $24,  $C
                dc.b    $30,  $C
                dc.b    $C,  $C
                dc.b    $C, $18
                dc.b    $C, $24
                dc.b    $C, $30
; ---------------------------------------------------------------------------

S3Spikes_InitCompGeometryAndHandler:
                lea     S3Spikes_CompetitionSizePairs(pc,d0.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.l  #S3Spikes_UpdateCompetitionStandingHazard,(a0)
                move.l  #Map_2PSpikes,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PArt_2,0,0),art_tile(a0)
                lsr.w   #1,d0
                move.b  d0,mapping_frame(a0)
                cmpi.b  #4,d0
                blo.s   S3Spikes_CheckCompUndersideOverride
                move.l  #S3Spikes_CheckCompSideContacts,(a0)

S3Spikes_CheckCompUndersideOverride:
                btst    #1,status(a0)
                beq.s   S3Spikes_SaveCompAnchorsAndMode
                move.l  #S3Spikes_CheckCompUndersideContacts,(a0)

S3Spikes_SaveCompAnchorsAndMode:
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  subtype(a0),d0
                andi.b  #$F,d0
                add.b   d0,d0
                move.b  d0,subtype(a0)
                rts
; ---------------------------------------------------------------------------

S3Spikes_UpdateNormalStandingHazard:
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
                beq.s   S3Spikes_CullAndDrawNormalStandingHazard
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   S3Spikes_HurtNormalStandingPlayerTwo
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3Spikes_HurtNormalStandingPlayerTwo:
                andi.b  #p2_standing,d6
                beq.s   S3Spikes_CullAndDrawNormalStandingHazard
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3Spikes_CullAndDrawNormalStandingHazard:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

S3Spikes_UpdateNormalSideContactHazard:
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
                beq.s   S3Spikes_CullAndDrawNormalSideHazard
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   S3Spikes_HurtNormalSideContactPlayerTwo
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard
                bclr    #p1_pushing_bit,status(a0)

S3Spikes_HurtNormalSideContactPlayerTwo:
                andi.b  #2,d6
                beq.s   S3Spikes_CullAndDrawNormalSideHazard
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard
                bclr    #p2_pushing_bit,status(a0)

S3Spikes_CullAndDrawNormalSideHazard:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

S3Spikes_CheckNormalUnderside:
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
                beq.s   S3Spikes_DrawNormalUndersideByAnchor
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   S3Spikes_HurtNormalUndersidePlayerTwo
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3Spikes_HurtNormalUndersidePlayerTwo:
                andi.b  #8,d6
                beq.s   S3Spikes_DrawNormalUndersideByAnchor
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3Spikes_DrawNormalUndersideByAnchor:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

S3Spikes_UpdateCompetitionStandingHazard:
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
                beq.s   S3Spikes_DrawCompetitionStandingHazard
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   S3Spikes_TryHurtCompStandingP2
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3Spikes_TryHurtCompStandingP2:
                andi.b  #p2_standing,d6
                beq.s   S3Spikes_DrawCompetitionStandingHazard
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3Spikes_DrawCompetitionStandingHazard:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Spikes_CheckCompSideContacts:
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
                beq.s   S3Spikes_DrawCompetitionSideHazard
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   S3Spikes_TryHurtCompSideP2
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard
                bclr    #p1_pushing_bit,status(a0)

S3Spikes_TryHurtCompSideP2:
                andi.b  #2,d6
                beq.s   S3Spikes_DrawCompetitionSideHazard
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard
                bclr    #p2_pushing_bit,status(a0)

S3Spikes_DrawCompetitionSideHazard:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Spikes_CheckCompUndersideContacts:
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
                beq.s   S3Spikes_DrawCompetitionUndersideHazard
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   S3Spikes_TryHurtCompUnderP2
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3Spikes_TryHurtCompUnderP2:
                andi.b  #8,d6
                beq.s   S3Spikes_DrawCompetitionUndersideHazard
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3Spikes_DrawCompetitionUndersideHazard:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

HurtPlayerFromSolidHazard:
                btst    #Status_Invincible,status_secondary(a1)
                bne.s   S3Spikes_HazardDamageReturn
                tst.b   invulnerability_timer(a1)
                bne.s   S3Spikes_HazardDamageReturn
                cmpi.b  #4,routine(a1)
                bhs.s   S3Spikes_HazardDamageReturn
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

S3Spikes_HazardDamageReturn:
                rts
; End of function HurtPlayerFromSolidHazard

; =============== S U B R O U T I N E =======================================

UpdateSpikePosition:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  S3Spikes_NormalMovementOffsets(pc,d0.w),d1
                jmp     S3Spikes_NormalMovementOffsets(pc,d1.w)
; End of function UpdateSpikePosition

; ---------------------------------------------------------------------------
S3Spikes_NormalMovementOffsets:
                dc.w    S3Spikes_ReturnFromStationaryMovement-S3Spikes_NormalMovementOffsets
                dc.w    S3Spikes_ApplyNormalVerticalTravel-S3Spikes_NormalMovementOffsets
                dc.w    S3Spikes_ApplyNormalHorizontalTravel-S3Spikes_NormalMovementOffsets
; ---------------------------------------------------------------------------

S3Spikes_ReturnFromStationaryMovement:
                rts
; ---------------------------------------------------------------------------

S3Spikes_ApplyNormalVerticalTravel:
                bsr.w   UpdateSpikeTravel
                moveq   #0,d0
                move.b  $34(a0),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3Spikes_ApplyNormalHorizontalTravel:
                bsr.w   UpdateSpikeTravel
                moveq   #0,d0
                move.b  $34(a0),d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                rts

; =============== S U B R O U T I N E =======================================

UpdateSpikeTravel:
                tst.w   $38(a0)
                beq.s   S3Spikes_AdvanceNormalTravelOrRetract
                subq.w  #1,$38(a0)
                bne.s   S3Spikes_ReturnFromNormalTravelUpdate
                tst.b   render_flags(a0)
                bpl.s   S3Spikes_ReturnFromNormalTravelUpdate
                moveq   #signextendB(sfx_SpikeMove),d0
                jsr     (Play_SFX).l
                bra.s   S3Spikes_ReturnFromNormalTravelUpdate
; ---------------------------------------------------------------------------

S3Spikes_AdvanceNormalTravelOrRetract:
                tst.w   $36(a0)
                beq.s   S3Spikes_ExtendNormalAndPause
                subi.w  #$800,$34(a0)
                bcc.s   S3Spikes_ReturnFromNormalTravelUpdate
                move.w  #0,$34(a0)
                move.w  #0,$36(a0)
                move.w  #60,$38(a0)
                bra.s   S3Spikes_ReturnFromNormalTravelUpdate
; ---------------------------------------------------------------------------

; Advance eight pixels per step and pause at 32 pixels of extension
S3Spikes_ExtendNormalAndPause:
                addi.w  #$800,$34(a0)
                cmpi.w  #$2000,$34(a0)
                blo.s   S3Spikes_ReturnFromNormalTravelUpdate
                move.w  #$2000,$34(a0)
                move.w  #1,$36(a0)
                move.w  #60,$38(a0)

S3Spikes_ReturnFromNormalTravelUpdate:
                rts
; End of function UpdateSpikeTravel

; =============== S U B R O U T I N E =======================================

UpdateCompetitionSpikePosition:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  S3Spikes_CompetitionMovementOffsets(pc,d0.w),d1
                jmp     S3Spikes_CompetitionMovementOffsets(pc,d1.w)
; End of function UpdateCompetitionSpikePosition

; ---------------------------------------------------------------------------
S3Spikes_CompetitionMovementOffsets:
                dc.w    S3Spikes_ReturnFromStationaryMovement-S3Spikes_CompetitionMovementOffsets
                dc.w    S3Spikes_ApplyCompetitionVerticalTravel-S3Spikes_CompetitionMovementOffsets
                dc.w    S3Spikes_MoveCompSpikesX-S3Spikes_CompetitionMovementOffsets
; ---------------------------------------------------------------------------

S3Spikes_ApplyCompetitionVerticalTravel:
                bsr.w   UpdateCompetitionSpikeTravel
                moveq   #0,d0
                move.b  $34(a0),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3Spikes_MoveCompSpikesX:
                bsr.w   UpdateCompetitionSpikeTravel
                moveq   #0,d0
                move.b  $34(a0),d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                rts

; =============== S U B R O U T I N E =======================================

UpdateCompetitionSpikeTravel:
                tst.w   $38(a0)
                beq.s   S3Spikes_TickCompTravel
                subq.w  #1,$38(a0)
                bne.s   S3Spikes_CompTravelReturn
                tst.b   render_flags(a0)
                bpl.s   S3Spikes_CompTravelReturn
                moveq   #signextendB(sfx_SpikeMove),d0
                jsr     (Play_SFX).l
                bra.s   S3Spikes_CompTravelReturn
; ---------------------------------------------------------------------------

S3Spikes_TickCompTravel:
                tst.w   $36(a0)
                beq.s   S3Spikes_ExtendCompAndPause
                subi.w  #$800,$34(a0)
                bcc.s   S3Spikes_CompTravelReturn
                move.w  #0,$34(a0)
                move.w  #0,$36(a0)
                move.w  #60,$38(a0)
                bra.s   S3Spikes_CompTravelReturn
; ---------------------------------------------------------------------------

; Advance eight pixels per step and pause at 24 pixels of extension
S3Spikes_ExtendCompAndPause:
                addi.w  #$800,$34(a0)
                cmpi.w  #$1800,$34(a0)
                blo.s   S3Spikes_CompTravelReturn
                move.w  #$1800,$34(a0)
                move.w  #1,$36(a0)
                move.w  #60,$38(a0)

S3Spikes_CompTravelReturn:
                rts
; End of function UpdateCompetitionSpikeTravel

; ---------------------------------------------------------------------------
Map_Spikes:
                include "src/objects/shared/level_misc/mappings/spikes.s"
Map_2PSpikes:
                include "src/game/competition/shared/mappings/spikes.s"
