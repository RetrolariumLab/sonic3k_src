; Owner: objects/zones/hcz/sk
; Responsibility: Hydrocity hand launcher state, player capture, launch and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_HCZHandLauncher:
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.l  #Map_HCZHandLauncher,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZMisc+$1A,1,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  #6,mapping_frame(a0)
                move.w  #$50,$30(a0)
                bset    #7,status(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKHandLauncher_StartActiveHand
                move.l  #SKHandLauncher_PlaceAndCheckVisualChild,(a1)
                move.l  #Map_HCZHandLauncher,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZMisc+$1A,1,0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.b  #$20,width_pixels(a1)
; Bug: This is missing the height, and it overwrites what the previous line did
                move.b  #$30,width_pixels(a1)
                move.w  #$280,priority(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  a0,$3C(a1)

SKHandLauncher_StartActiveHand:
                move.l  #SKHandLauncher_CheckEitherPlayerNear,(a0)

SKHandLauncher_CheckEitherPlayerNear:
                move.w  x_pos(a0),d1
                subi.w  #$20,d1
                move.w  (Player_1+x_pos).w,d0
                sub.w   d1,d0
                cmpi.w  #$40,d0
                blo.s   SKHandLauncher_PickOccupiedMotion
                move.w  (Player_2+x_pos).w,d0
                sub.w   d1,d0
                cmpi.w  #$40,d0
                bhs.s   SKHandLauncher_ExtendEmptyHand

SKHandLauncher_PickOccupiedMotion:
                tst.b   $34(a0)
                beq.s   SKHandLauncher_ReadyUnoccupiedHand
                move.b  #7,mapping_frame(a0)
                move.w  #$80,priority(a0)
                tst.w   $36(a0)
                beq.s   SKHandLauncher_CompressOccupiedHand
                subq.w  #1,$36(a0)
                bra.s   SKHandLauncher_UpdateBothRiders
; ---------------------------------------------------------------------------

SKHandLauncher_CompressOccupiedHand:
                tst.w   $30(a0)
                beq.s   SKHandLauncher_BeginLaunchHold
                subq.w  #8,$30(a0)
                bra.s   SKHandLauncher_UpdateBothRiders
; ---------------------------------------------------------------------------

SKHandLauncher_BeginLaunchHold:
                move.l  #SKHandLauncher_TickLaunchHold,(a0)
                move.w  #60-1,$36(a0)
                bra.s   SKHandLauncher_UpdateBothRiders
; ---------------------------------------------------------------------------

SKHandLauncher_ReadyUnoccupiedHand:
                move.w  #20-1,$36(a0)
                move.b  #6,mapping_frame(a0)
                move.w  #$200,priority(a0)
                cmpi.w  #$18,$30(a0)
                bls.s   SKHandLauncher_UpdateBothRiders
                subq.w  #8,$30(a0)
                bra.s   SKHandLauncher_PlaceHandAndCheckSolid
; ---------------------------------------------------------------------------

SKHandLauncher_UpdateBothRiders:
                bsr.w   UpdatePlayersOnHczHand
                bra.s   SKHandLauncher_PlaceHandAndCheckSolid
; ---------------------------------------------------------------------------

SKHandLauncher_ExtendEmptyHand:
                cmpi.w  #$50,$30(a0)
                beq.s   SKHandLauncher_PlaceHandAndCheckSolid
                addq.w  #8,$30(a0)

SKHandLauncher_PlaceHandAndCheckSolid:
                move.w  $30(a0),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                move.w  #$20,d1
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKHandLauncher_TickLaunchHold:
                tst.w   $36(a0)
                beq.s   SKHandLauncher_TryFinishLaunch
                subq.w  #1,$36(a0)
                bsr.w   UpdatePlayersOnHczHand
                bra.s   SKHandLauncher_PlaceLaunchingHand
; ---------------------------------------------------------------------------

SKHandLauncher_TryFinishLaunch:
                cmpi.w  #$50,$30(a0)
                bne.s   SKHandLauncher_TryLaunchRiders
                move.b  #0,$34(a0)
                move.l  #SKHandLauncher_CheckEitherPlayerNear,(a0)
                moveq   #signextendB(sfx_Dash),d0
                jsr     (Play_SFX).l
                bra.s   SKHandLauncher_PlaceLaunchingHand
; ---------------------------------------------------------------------------

SKHandLauncher_TryLaunchRiders:
                cmpi.w  #$18,$30(a0)
                bne.s   SKHandLauncher_StepReturnOffset
                bsr.w   LaunchPlayersFromHczHand
                move.b  #6,mapping_frame(a0)
                move.w  #$200,priority(a0)

SKHandLauncher_StepReturnOffset:
                addq.w  #8,$30(a0)

SKHandLauncher_PlaceLaunchingHand:
                move.w  $30(a0),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                cmpi.w  #$18,$30(a0)
                bhi.s   SKHandLauncher_CullOrDrawHand
                move.w  #$20,d1
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l

SKHandLauncher_CullOrDrawHand:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

LaunchPlayersFromHczHand:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.w   LaunchPlayerFromHczHand
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
; End of function LaunchPlayersFromHczHand

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromHczHand:
                bclr    d6,$35(a0)
                beq.s   SKHandLauncher_TryReleaseUncapturedRider
                move.w  #$1000,ground_vel(a1)
                move.w  #$1000,x_vel(a1)
                move.w  #0,y_vel(a1)
                btst    #0,status(a0)
                beq.s   SKHandLauncher_ClearLaunchedRiderFlags
                neg.w   ground_vel(a1)
                neg.w   x_vel(a1)

SKHandLauncher_ClearLaunchedRiderFlags:
                move.b  #0,anim(a1)
                move.b  #0,object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    d6,status(a0)
                rts
; ---------------------------------------------------------------------------

SKHandLauncher_TryReleaseUncapturedRider:
                bclr    d6,status(a0)
                beq.s   SKHandLauncher_LaunchRiderReturn
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)

SKHandLauncher_LaunchRiderReturn:
                rts
; End of function LaunchPlayerFromHczHand

; =============== S U B R O U T I N E =======================================

UpdatePlayersOnHczHand:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                move.b  (Ctrl_1_pressed_logical).w,d0
                bsr.w   UpdatePlayerOnHczHand
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                move.b  (Ctrl_2_pressed_logical).w,d0
; End of function UpdatePlayersOnHczHand

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnHczHand:
                btst    d6,$35(a0)
                beq.s   SKHandLauncher_CheckCenteredRider
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   SKHandLauncher_EscapeReturn
                bclr    d6,$35(a0)
                bclr    d6,status(a0)
                move.w  #$800,ground_vel(a1)
                move.w  #$800,x_vel(a1)
                move.w  #-$400,y_vel(a1)
                btst    #0,status(a0)
                beq.s   SKHandLauncher_ReleaseEscapingRider
                neg.w   ground_vel(a1)
                neg.w   x_vel(a1)

SKHandLauncher_ReleaseEscapingRider:
                move.b  #0,object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                tst.b   $35(a0)
                bne.s   SKHandLauncher_EscapeReturn
                move.b  #0,$34(a0)

SKHandLauncher_EscapeReturn:
                rts
; ---------------------------------------------------------------------------

SKHandLauncher_CheckCenteredRider:
                btst    d6,status(a0)
                beq.w   SKHandLauncher_CaptureReturn
                tst.b   $34(a0)
                bne.s   SKHandLauncher_TryCaptureRider
                move.w  x_pos(a1),d0
                addi.w  #8,d0
                sub.w   x_pos(a0),d0
                cmpi.w  #2*8,d0
                bhs.s   SKHandLauncher_CaptureReturn

SKHandLauncher_TryCaptureRider:
                tst.b   object_control(a1)
                bne.s   SKHandLauncher_CaptureReturn
                tst.w   (Debug_placement_mode).w
                bne.s   SKHandLauncher_CaptureReturn
                bset    d6,$35(a0)
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                move.b  #0,anim(a1)
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)
                bclr    #Status_Roll,status(a1)
                cmpi.l  #Obj_Tails,(a1)
                bne.s   SKHandLauncher_InitCapturedRider
                move.b  #$F,y_radius(a1)

SKHandLauncher_InitCapturedRider:
                move.b  #1,object_control(a1)
                bclr    #Status_Push,status(a1)
                move.w  x_pos(a0),x_pos(a1)
                subq.w  #2,x_pos(a1)
                move.w  #$1000,ground_vel(a1)
                bclr    #Status_Facing,status(a1)
                btst    #0,status(a0)
                beq.s   SKHandLauncher_MarkHandOccupied
                addq.w  #2*2,x_pos(a1)
                neg.w   ground_vel(a1)
                bset    #Status_Facing,status(a1)

SKHandLauncher_MarkHandOccupied:
                move.b  #1,$34(a0)

SKHandLauncher_CaptureReturn:
                rts
; End of function UpdatePlayerOnHczHand

; ---------------------------------------------------------------------------

SKHandLauncher_PlaceAndCheckVisualChild:
                movea.w $3C(a0),a1
                move.w  y_pos(a1),y_pos(a0)
                cmpi.w  #$18,$30(a1)
                bls.s   SKHandLauncher_AnimateVisualChild
                rts
; ---------------------------------------------------------------------------

SKHandLauncher_AnimateVisualChild:
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #6,mapping_frame(a0)
                blo.s   SKHandLauncher_CullOrDrawVisualChild
                move.b  #0,mapping_frame(a0)

SKHandLauncher_CullOrDrawVisualChild:
                jmp     (Sprite_OnScreen_Test).l
; End of function SKHandLauncher_PlaceAndCheckVisualChild
