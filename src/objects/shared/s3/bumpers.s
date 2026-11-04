; Owner: objects/shared/s3
; Responsibility: Shared bumper response, competition and product-specific bonus variants and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_Bumper:
                move.l  #Map_Bumper,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$13,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  #$D7,collision_flags(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                tst.w   (Competition_mode).w
                beq.s   S3Bumper_SelectFixedOrOrbitHandler
                move.l  #Map_2PBumper,mappings(a0)
                move.w  #make_art_tile(ArtTile_BPZMisc,1,0),art_tile(a0)
                move.l  #S3Bumper_CheckCompetitionContacts,(a0)
                bra.w   S3Bumper_CheckCompetitionContacts
; ---------------------------------------------------------------------------

S3Bumper_SelectFixedOrOrbitHandler:
                move.l  #S3Bumper_HandleNormalContactProperties,(a0)
                move.b  subtype(a0),d0
                beq.s   S3Bumper_HandleNormalContactProperties
                move.b  d0,angle(a0)
                move.l  #S3Bumper_SelectOrbitCounterDirection,(a0)

S3Bumper_SelectOrbitCounterDirection:
                move.b  (Level_frame_counter+1).w,d0
                btst    #0,status(a0)
                beq.s   S3Bumper_ApplyOrbitAroundSavedCenter
                neg.b   d0

S3Bumper_ApplyOrbitAroundSavedCenter:
                add.b   angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d1
                asr.w   #2,d0
                add.w   $30(a0),d1
                add.w   $32(a0),d0
                move.w  d1,x_pos(a0)
                move.w  d0,y_pos(a0)

S3Bumper_HandleNormalContactProperties:
                tst.b   collision_property(a0)
                beq.w   S3Bumper_TickNormalAndCullByAnchorX
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   S3Bumper_TryReboundP2
                bsr.s   ReboundPlayerFromBumperAndAwardScore

S3Bumper_TryReboundP2:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   S3Bumper_ClearNormalContacts
                bsr.s   ReboundPlayerFromBumperAndAwardScore

S3Bumper_ClearNormalContacts:
                clr.b   collision_property(a0)
                bra.w   S3Bumper_TickNormalAndCullByAnchorX

; =============== S U B R O U T I N E =======================================

ReboundPlayerFromBumperAndAwardScore:
                move.w  x_pos(a0),d1
                move.w  y_pos(a0),d2
                sub.w   x_pos(a1),d1
                sub.w   y_pos(a1),d2
                jsr     (GetArcTan).l
                move.b  (Level_frame_counter).w,d1
                andi.w  #3,d1
                add.w   d1,d0
                jsr     (GetSineCosine).l
                muls.w  #-$700,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a1)
                muls.w  #-$700,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                bclr    #Status_Push,status(a1)
                clr.b   jumping(a1)
                move.b  #1,anim(a0)
                moveq   #signextendB(sfx_Bumper),d0
                jsr     (Play_SFX).l
                move.w  respawn_addr(a0),d0
                beq.s   S3Bumper_AwardScoreAndTryPopup
                movea.w d0,a2
                cmpi.b  #$8A,(a2)
                bhs.s   S3Bumper_ReturnAfterScoringReboundOrCap
                addq.b  #1,(a2)

; One stored score unit displays as ten points
S3Bumper_AwardScoreAndTryPopup:
                moveq   #1,d0
                movea.w a1,a3
                jsr     (HUD_AddToScore).l
                jsr     (AllocateObject).l
                bne.s   S3Bumper_ReturnAfterScoringReboundOrCap
                move.l  #Obj_EnemyScore,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  #4,mapping_frame(a1)

S3Bumper_ReturnAfterScoringReboundOrCap:
                rts
; End of function ReboundPlayerFromBumperAndAwardScore

; ---------------------------------------------------------------------------

S3Bumper_TickNormalAndCullByAnchorX:
                lea     (Ani_Bumper).l,a1
                jsr     (Animate_Sprite).l
                move.w  $30(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   S3Bumper_ClearNormalLoadedBit
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Bumper_ClearNormalLoadedBit:
                move.w  respawn_addr(a0),d0
                beq.s   S3Bumper_DeleteOutsideAnchorRange
                movea.w d0,a2
                bclr    #7,(a2)

S3Bumper_DeleteOutsideAnchorRange:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3Bumper_CheckCompetitionContacts:
                tst.b   collision_property(a0)
                beq.w   S3Bumper_TickAndDrawCompetition
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   S3Bumper_TryReboundCompetitionP2
                bsr.s   ReboundPlayerFromCompetitionBumper

S3Bumper_TryReboundCompetitionP2:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   S3Bumper_ClearCompetitionContacts
                bsr.s   ReboundPlayerFromCompetitionBumper

S3Bumper_ClearCompetitionContacts:
                clr.b   collision_property(a0)
                bra.w   S3Bumper_TickAndDrawCompetition

; =============== S U B R O U T I N E =======================================

ReboundPlayerFromCompetitionBumper:
                move.w  x_pos(a0),d1
                move.w  y_pos(a0),d2
                sub.w   x_pos(a1),d1
                sub.w   y_pos(a1),d2
                jsr     (GetArcTan).l
                move.b  (Level_frame_counter).w,d1
                andi.w  #3,d1
                add.w   d1,d0
                jsr     (GetSineCosine).l
                muls.w  #-$700,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a1)
                muls.w  #-$700,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                bclr    #Status_Push,status(a1)
                clr.b   jumping(a1)
                move.b  #1,anim(a0)
                moveq   #signextendB(sfx_SmallBumpers),d0
                jsr     (Play_SFX).l
                rts
; End of function ReboundPlayerFromCompetitionBumper

; ---------------------------------------------------------------------------

S3Bumper_TickAndDrawCompetition:
                lea     (Ani_Bumper).l,a1
                jsr     (Animate_Sprite).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_Bumper:
                include "src/objects/shared/level_misc/animations/bumper.s"
Map_Bumper:
                include "src/objects/shared/level_misc/mappings/bumper.s"
Map_2PBumper:
                include "src/game/competition/shared/mappings/competition_bumper.s"
