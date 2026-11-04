; Owner: objects/shared/sk
; Responsibility: Shared bumper response, competition and product-specific bonus variants and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_Bumper:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  #$D7,collision_flags(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                cmpi.b  #$14,(Current_zone).w
                bne.s   SKBumper_CheckCompetitionMode
                move.l  #Map_PachinkoBumper,mappings(a0)
                move.w  #make_art_tile(ArtTile_PachinkoMain,3,0),art_tile(a0)
                move.l  #SKBumper_HandlePachinkoContactProperties,(a0)
                bra.w   SKBumper_HandlePachinkoContactProperties
; ---------------------------------------------------------------------------

SKBumper_CheckCompetitionMode:
                tst.w   (Competition_mode).w
                beq.s   SKBumper_SelectFixedOrOrbitHandler
                move.l  #Map_2PBumper,mappings(a0)
                move.w  #make_art_tile(ArtTile_BPZMisc,1,0),art_tile(a0)
                move.l  #SKBumper_CheckCompetitionContacts,(a0)
                bra.w   SKBumper_CheckCompetitionContacts
; ---------------------------------------------------------------------------

SKBumper_SelectFixedOrOrbitHandler:
                move.l  #Map_Bumper,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$13,2,0),art_tile(a0)
                move.l  #SKBumper_HandleNormalContactProperties,(a0)
                move.b  subtype(a0),d0
                beq.s   SKBumper_HandleNormalContactProperties
                move.b  d0,angle(a0)
                move.l  #SKBumper_SelectOrbitCounterDirection,(a0)

SKBumper_SelectOrbitCounterDirection:
                move.b  (Level_frame_counter+1).w,d0
                btst    #0,status(a0)
                beq.s   SKBumper_ApplyOrbitAroundSavedCenter
                neg.b   d0

SKBumper_ApplyOrbitAroundSavedCenter:
                add.b   angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d1
                asr.w   #2,d0
                add.w   $30(a0),d1
                add.w   $32(a0),d0
                move.w  d1,x_pos(a0)
                move.w  d0,y_pos(a0)

SKBumper_HandleNormalContactProperties:
                tst.b   collision_property(a0)
                beq.s   SKBumper_TickNormalAndCullByAnchorX
                bsr.w   ReboundPlayersTouchingBumper

SKBumper_TickNormalAndCullByAnchorX:
                lea     (Ani_Bumper).l,a1
                jsr     (Animate_Sprite).l
                move.w  $30(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   SKBumper_ClearNormalLoadedBit
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKBumper_ClearNormalLoadedBit:
                move.w  respawn_addr(a0),d0
                beq.s   SKBumper_DeleteOutsideAnchorRange
                movea.w d0,a2
                bclr    #7,(a2)

SKBumper_DeleteOutsideAnchorRange:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKBumper_HandlePachinkoContactProperties:
                tst.b   collision_property(a0)
                beq.s   SKBumper_TickPachinkoAndCullY
                bsr.s   ReboundPlayersTouchingBumper

SKBumper_TickPachinkoAndCullY:
                lea     (Ani_Bumper).l,a1
                jsr     (Animate_Sprite).l
                move.w  y_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_Y_pos_coarse_back).w,d0
                cmpi.w  #$200,d0
                bhi.s   SKBumper_ClearPachinkoLoadedBit
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKBumper_ClearPachinkoLoadedBit:
                move.w  respawn_addr(a0),d0
                beq.s   SKBumper_DeletePachinkoOffscreen
                movea.w d0,a2
                bclr    #7,(a2)

SKBumper_DeletePachinkoOffscreen:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

ReboundPlayersTouchingBumper:
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   SKBumper_TryReboundP2
                bsr.s   ReboundPlayerFromBumperAndAwardScore

SKBumper_TryReboundP2:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   SKBumper_ClearNormalContacts
                bsr.s   ReboundPlayerFromBumperAndAwardScore

SKBumper_ClearNormalContacts:
                clr.b   collision_property(a0)
                rts
; End of function ReboundPlayersTouchingBumper

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
                beq.s   SKBumper_AwardScoreAndTryPopup
                movea.w d0,a2
                cmpi.b  #$8A,(a2)
                bhs.s   SKBumper_ReturnAfterScoringReboundOrCap
                addq.b  #1,(a2)

; One stored score unit displays as ten points
SKBumper_AwardScoreAndTryPopup:
                moveq   #1,d0
                movea.w a1,a3
                jsr     (HUD_AddToScore).l
                jsr     (AllocateObject).l
                bne.s   SKBumper_ReturnAfterScoringReboundOrCap
                move.l  #Obj_EnemyScore,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  #4,mapping_frame(a1)

SKBumper_ReturnAfterScoringReboundOrCap:
                rts
; End of function ReboundPlayerFromBumperAndAwardScore

; ---------------------------------------------------------------------------

SKBumper_CheckCompetitionContacts:
                tst.b   collision_property(a0)
                beq.w   SKBumper_TickAndDrawCompetition
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   SKBumper_TryReboundCompetitionP2
                bsr.s   ReboundPlayerFromCompetitionBumper

SKBumper_TryReboundCompetitionP2:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   SKBumper_ClearCompetitionContacts
                bsr.s   ReboundPlayerFromCompetitionBumper

SKBumper_ClearCompetitionContacts:
                clr.b   collision_property(a0)
                bra.w   SKBumper_TickAndDrawCompetition

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

SKBumper_TickAndDrawCompetition:
                lea     (Ani_Bumper).l,a1
                jsr     (Animate_Sprite).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_Bumper:
                include "src/objects/shared/level_misc/animations/bumper.s"
Map_PachinkoBumper:
                include "src/objects/shared/zones/pachinko/mappings/bumper.s"
