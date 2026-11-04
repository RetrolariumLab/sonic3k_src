; Owner: objects/zones/soz/sk
; Responsibility: Push-switch contact, player pushing, trigger state and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZPushSwitch:
                move.l  #Map_SOZPushSwitch,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZMisc+$8C,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$30,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$300,priority(a0)
                move.b  #1,mapping_frame(a0)
                move.w  x_pos(a0),$44(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),d0
                addi.w  #$10,d0
                btst    #0,status(a0)
                beq.s   SKSOZPushSwitch_InitFaceAndUpdate
                subi.w  #2*$10,d0

SKSOZPushSwitch_InitFaceAndUpdate:
                move.w  d0,(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #0,(a2)+
                move.l  #SKSOZPushSwitch_LoadTravelAndCheckSolid,(a0)

SKSOZPushSwitch_LoadTravelAndCheckSolid:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                moveq   #0,d1
                move.b  (a3),d1
                move.w  d1,$36(a0)
                move.b  (Player_1+status).w,$30(a0)
                move.b  (Player_2+status).w,$31(a0)
                move.w  #$17,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                moveq   #0,d4
                bsr.w   UpdatePlayerPushOrReturnForSozSwitch
                move.w  $36(a0),d0
                lsr.w   #2,d0
                btst    #0,status(a0)
                beq.s   SKSOZPushSwitch_PlaceSwitchAndTryRock
                neg.w   d0

SKSOZPushSwitch_PlaceSwitchAndTryRock:
                add.w   $44(a0),d0
                move.w  d0,x_pos(a0)
                tst.b   subtype(a0)
                bpl.s   SKSOZPushSwitch_PublishTravelAndDraw
                bsr.w   PressSozSwitchWithRegisteredRock

SKSOZPushSwitch_PublishTravelAndDraw:
                move.w  $36(a0),d1
                move.b  d1,(a3)
                move.w  $44(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKSOZPushSwitch_ClearRespawnBit
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSOZPushSwitch_ClearRespawnBit:
                move.w  respawn_addr(a0),d0
                beq.s   SKSOZPushSwitch_DeleteOrRetractOffscreen
                movea.w d0,a2
                bclr    #7,(a2)

SKSOZPushSwitch_DeleteOrRetractOffscreen:
                tst.w   $36(a0)
                bne.s   SKSOZPushSwitch_BeginOffscreenRetraction
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSOZPushSwitch_BeginOffscreenRetraction:
                move.l  #SKSOZPushSwitch_CheckPlacementReload,(a0)

SKSOZPushSwitch_CheckPlacementReload:
                move.w  respawn_addr(a0),d0
                beq.s   SKSOZPushSwitch_RetractOffscreen
                movea.w d0,a2
                tst.b   (a2)
                bpl.s   SKSOZPushSwitch_RetractOffscreen
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSOZPushSwitch_RetractOffscreen:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                moveq   #0,d1
                move.b  (a3),d1
                move.w  d1,$36(a0)
                bsr.w   ReturnSozPushSwitchProgress
                move.w  $36(a0),d1
                move.b  d1,(a3)
                tst.w   $36(a0)
                bne.s   SKSOZPushSwitch_OffscreenReturn
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSOZPushSwitch_OffscreenReturn:
                rts

; =============== S U B R O U T I N E =======================================

UpdatePlayerPushOrReturnForSozSwitch:
                moveq   #0,d5
                move.b  status(a0),d3
                andi.b  #pushing_mask,d3
                beq.w   ReturnSozPushSwitchProgress
                move.w  x_pos(a0),d2
                lea     (Player_1).w,a1
                move.b  $30(a0),d0
                moveq   #p1_pushing_bit,d6
                bsr.s   ApplyPlayerPushToSozSwitch
                tst.w   d5
                bne.s   SKSOZPushSwitch_PlayerPushReturn
                lea     (Player_2).w,a1
                move.b  $31(a0),d0
                moveq   #p2_pushing_bit,d6
                bsr.s   ApplyPlayerPushToSozSwitch
                tst.w   d5
                beq.s   ReturnSozPushSwitchProgress

SKSOZPushSwitch_PlayerPushReturn:
                rts
; End of function UpdatePlayerPushOrReturnForSozSwitch

; =============== S U B R O U T I N E =======================================

ApplyPlayerPushToSozSwitch:
                btst    d6,d3
                beq.s   SKSOZPushSwitch_ApplyPushReturn
                cmp.w   x_pos(a1),d2
                bcc.s   SKSOZPushSwitch_TryPushFromLeft
                btst    #5,d0
                beq.s   SKSOZPushSwitch_ApplyPushReturn
                btst    #0,status(a0)
                beq.s   SKSOZPushSwitch_ApplyPushReturn
                cmpi.w  #$80,$36(a0)
                beq.s   SKSOZPushSwitch_ClaimPlayerPush
                addq.w  #1,$36(a0)
                move.w  $36(a0),d0
                andi.w  #3,d0
                bne.s   SKSOZPushSwitch_ClaimPlayerPush
                subq.w  #1,x_pos(a1)
                moveq   #signextendB(sfx_PushBlock),d0
                jsr     (Play_SFX).l

; Return D5 = 1 even at full travel or when the push does not move the switch this frame
SKSOZPushSwitch_ClaimPlayerPush:
                moveq   #1,d5
                rts
; ---------------------------------------------------------------------------

SKSOZPushSwitch_TryPushFromLeft:
                btst    #5,d0
                beq.s   SKSOZPushSwitch_ApplyPushReturn
                btst    #0,status(a0)
                bne.s   SKSOZPushSwitch_ApplyPushReturn
                cmpi.w  #$80,$36(a0)
                beq.s   SKSOZPushSwitch_ClaimPlayerPush
                addq.w  #1,$36(a0)
                move.w  $36(a0),d0
                andi.w  #3,d0
                bne.s   SKSOZPushSwitch_ClaimPlayerPush
                addq.w  #1,x_pos(a1)
                moveq   #signextendB(sfx_PushBlock),d0
                jsr     (Play_SFX).l
                moveq   #1,d5

SKSOZPushSwitch_ApplyPushReturn:
                rts
; End of function ApplyPlayerPushToSozSwitch

; =============== S U B R O U T I N E =======================================

ReturnSozPushSwitchProgress:
                move.b  subtype(a0),d0
                andi.w  #$70,d0
                bne.s   SKSOZPushSwitch_StepRetraction
                subq.w  #1,$34(a0)
                bpl.s   SKSOZPushSwitch_RetractionReturn
                move.w  #9,$34(a0)

SKSOZPushSwitch_StepRetraction:
                tst.w   $36(a0)
                beq.s   SKSOZPushSwitch_RetractionReturn
                moveq   #signextendB(sfx_DoorClose),d0
                subq.w  #1,$36(a0)
                beq.s   SKSOZPushSwitch_PlayRetractionSound
                subq.b  #1,$3A(a0)
                bpl.s   SKSOZPushSwitch_SetD4RetractionMoved
                move.b  #3,$3A(a0)
                moveq   #signextendB(sfx_DoorMove),d0

SKSOZPushSwitch_PlayRetractionSound:
                jsr     (Play_SFX).l

SKSOZPushSwitch_SetD4RetractionMoved:
                moveq   #1,d4

SKSOZPushSwitch_RetractionReturn:
                rts
; End of function ReturnSozPushSwitchProgress

; =============== S U B R O U T I N E =======================================

PressSozSwitchWithRegisteredRock:
                move.w  (SozRegisteredPushableRockAddress).w,d0
                beq.w   SKSOZPushSwitch_RockPressureReturn
                movea.w d0,a2
                cmpi.l  #SKSOZPushRock_UpdateRegisteredRock,(a2)
                beq.s   SKSOZPushSwitch_CheckRockContact
                move.w  #0,(SozRegisteredPushableRockAddress).w
                rts
; ---------------------------------------------------------------------------

SKSOZPushSwitch_CheckRockContact:
                move.w  x_pos(a2),d2
                sub.w   x_pos(a0),d2
                addi.w  #$1B,d2
                cmpi.w  #$37,d2
                bhs.s   SKSOZPushSwitch_SaveRockX
                move.w  y_pos(a2),d3
                sub.w   y_pos(a0),d3
                addi.w  #$C,d3
                cmpi.w  #$18,d3
                bhs.s   SKSOZPushSwitch_SaveRockX
                move.b  status(a0),d0
                cmpi.w  #$1C,d2
                blo.s   SKSOZPushSwitch_TryPressFromRockSide
                eori.b  #1,d0

SKSOZPushSwitch_TryPressFromRockSide:
                andi.b  #1,d0
                bne.s   SKSOZPushSwitch_CalcRockPressedOffset
                cmpi.w  #$80,$36(a0)
                beq.s   SKSOZPushSwitch_CalcRockPressedOffset
                moveq   #4,d1
                add.w   d4,d1
                move.w  $38(a0),d0
                cmp.w   x_pos(a2),d0
                bne.s   SKSOZPushSwitch_ApplyClampedRockTravel
                moveq   #1,d1

SKSOZPushSwitch_ApplyClampedRockTravel:
                add.w   d1,$36(a0)
                cmpi.w  #$80,$36(a0)
                blo.s   SKSOZPushSwitch_CalcRockPressedOffset
                move.w  #$80,$36(a0)

SKSOZPushSwitch_CalcRockPressedOffset:
                move.w  $36(a0),d0
                lsr.w   #2,d0
                btst    #0,status(a0)
                beq.s   SKSOZPushSwitch_PlaceSwitchAndCalcRockX
                neg.w   d0

SKSOZPushSwitch_PlaceSwitchAndCalcRockX:
                add.w   $44(a0),d0
                move.w  d0,x_pos(a0)
                subi.w  #$1C,d0
                cmpi.w  #$1C,d2
                blo.s   SKSOZPushSwitch_SnapRockToSwitch
                addi.w  #$38,d0

SKSOZPushSwitch_SnapRockToSwitch:
                move.w  d0,x_pos(a2)

SKSOZPushSwitch_SaveRockX:
                move.w  x_pos(a2),$38(a0)

SKSOZPushSwitch_RockPressureReturn:
                rts
; End of function PressSozSwitchWithRegisteredRock

; ---------------------------------------------------------------------------
Map_SOZPushSwitch:
                include "src/objects/shared/zones/soz/mappings/push_switch.s"
