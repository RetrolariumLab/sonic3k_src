; Owner: game/level/zones/ssz/sk
; Responsibility: Sky Sanctuary camera transition, character motion, collapsing bridge actors and next-level handoff
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SSZEscape_UpdateControllerAndRumble:
                cmpi.b  #4,routine(a0)
                bhi.s   SSZEscape_DispatchControllerState
                move.w  (Level_frame_counter).w,d0
                andi.w  #$F,d0
                bne.s   SSZEscape_DispatchControllerState
                moveq   #signextendB(sfx_BigRumble),d0
                jsr     (Play_SFX).l

SSZEscape_DispatchControllerState:
                moveq   #0,d0
                move.b  routine(a0),d0
                jmp     SSZEscape_StateBranches(pc,d0.w)
; ---------------------------------------------------------------------------

SSZEscape_StateBranches:
                bra.w   SSZEscape_CountDownBeforeCameraDescent
; ---------------------------------------------------------------------------
                bra.w   SSZEscape_LowerCameraAndStartCollapse
; ---------------------------------------------------------------------------
                bra.w   SSZEscape_DescendToSpiralSetupHeight
; ---------------------------------------------------------------------------
                bra.w   SSZEscape_WaitForCollapseAndSpawnDebris
; ---------------------------------------------------------------------------

SSZEscape_CountDownBeforeCameraDescent:
                subq.w  #1,$2E(a0)
                bne.w   SSZEscape_ReturnFromControllerState
                move.w  #4,$30(a0)
                addq.b  #4,routine(a0)

SSZEscape_LowerCameraAndStartCollapse:
                jsr     StepSsz1EscapeCameraDownward(pc)
                cmpi.w  #$600,(Camera_Y_pos).w
                blo.w   SSZEscape_ReturnFromControllerState
                jsr     DriveSsz1EscapeJumpInputsForPlayers(pc)
                cmpi.w  #$60C,(Camera_Y_pos).w
                blo.w   SSZEscape_ReturnFromControllerState
                lea     (HScroll_table+$E0).w,a1
                lea     SSZEscape_ForegroundStripStartCountdowns(pc),a5
                moveq   #($A/2)-1,d0

SSZEscape_CopyStripCollapseCountdowns:
                move.l  (a5)+,(a1)+
                dbf     d0,SSZEscape_CopyStripCollapseCountdowns
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                addq.b  #4,routine(a0)
                bra.w   SSZEscape_ReturnFromControllerState
; ---------------------------------------------------------------------------

SSZEscape_DescendToSpiralSetupHeight:
                jsr     StepSsz1EscapeCameraDownward(pc)
                jsr     DriveSsz1EscapeJumpInputsForPlayers(pc)
                cmpi.w  #$640,(Camera_Y_pos).w
                blo.w   SSZEscape_ReturnFromControllerState
                move.w  #$10-1,$2E(a0)
                move.w  #8,$30(a0)
                clr.w   $32(a0)
                addq.b  #4,routine(a0)

SSZEscape_WaitForCollapseAndSpawnDebris:
                tst.w   (Events_fg_4).w
                bpl.s   SSZEscape_ReturnFromControllerState
                tst.w   $2E(a0)
                beq.s   SSZEscape_TryUpdateSpiralClimb
                subq.w  #1,$2E(a0)
                bne.s   SSZEscape_ReturnFromControllerState
                jsr     (AllocateObject).l
                bne.s   SSZEscape_TryUpdateSpiralClimb
                move.l  #SSZRampDebris_WaitForEscape,(a1)

SSZEscape_TryUpdateSpiralClimb:
                cmpi.w  #$5C0,(Camera_Y_pos).w
                bhs.s   SSZEscape_SelectTurnCameraTarget
                jsr     UpdateSsz1EscapeSpiralForPlayers(pc)
                move.w  (Level_frame_counter).w,d0
                addq.w  #8,d0
                andi.w  #$F,d0
                bne.s   SSZEscape_SelectTurnCameraTarget
                moveq   #signextendB(sfx_DeathEggRiseLoud),d0
                jsr     (Play_SFX).l

SSZEscape_SelectTurnCameraTarget:
                move.w  #$500,d0
                moveq   #0,d1
                move.b  $30(a0),d1
                subq.w  #1,d1
                bcs.s   SSZEscape_ComputeUpwardCameraStep

SSZEscape_SubtractCompletedTurnHeight:
                subi.w  #$70,d0
                dbf     d1,SSZEscape_SubtractCompletedTurnHeight

SSZEscape_ComputeUpwardCameraStep:
                moveq   #0,d1
                move.b  $31(a0),d1
                sub.w   d1,d0
                move.w  (Camera_Y_pos).w,d1
                sub.w   d0,d1
                bcs.s   SSZEscape_ReturnFromControllerState
                cmpi.w  #2,d1
                bls.s   SSZEscape_ApplyCameraRiseAndClampTop
                moveq   #2,d1

SSZEscape_ApplyCameraRiseAndClampTop:
                sub.w   d1,(Camera_Y_pos).w
                cmpi.w  #$110,(Camera_Y_pos).w
                bhs.s   SSZEscape_ReturnFromControllerState
                move.w  #$110,(Camera_Y_pos).w

SSZEscape_ReturnFromControllerState:
                rts

; =============== S U B R O U T I N E =======================================

StepSsz1EscapeCameraDownward:
                cmpi.w  #$618,(Camera_Y_pos).w
                blo.s   SSZEscape_SelectSlowCameraDescentTicks
                btst    #0,(Level_frame_counter+1).w
                beq.s   SSZEscape_ReturnFromCameraDescentStep
                bra.s   SSZEscape_IncrementCameraY
; ---------------------------------------------------------------------------

SSZEscape_SelectSlowCameraDescentTicks:
                move.w  (Level_frame_counter).w,d0
                andi.w  #3,d0
                beq.s   SSZEscape_ReturnFromCameraDescentStep

SSZEscape_IncrementCameraY:
                addq.w  #1,(Camera_Y_pos).w

SSZEscape_ReturnFromCameraDescentStep:
                rts
; End of function StepSsz1EscapeCameraDownward

; =============== S U B R O U T I N E =======================================

DriveSsz1EscapeJumpInputsForPlayers:
                lea     (Player_1).w,a1
                lea     (Ctrl_1_logical).w,a2
                lea     $30(a0),a3
                bsr.s   DriveSsz1EscapeJumpInputAndHidePlayer
                tst.w   (Player_mode).w
                bne.s   SSZEscape_ReturnFromPlayerInputOrSetup
                lea     (Player_2).w,a1
                lea     (Ctrl_2_logical).w,a2
                lea     $31(a0),a3
; End of function DriveSsz1EscapeJumpInputsForPlayers

; =============== S U B R O U T I N E =======================================

DriveSsz1EscapeJumpInputAndHidePlayer:
                tst.b   object_control(a1)
                bne.s   SSZEscape_ReturnFromPlayerInputOrSetup
                tst.b   (a3)
                bmi.s   SSZEscape_HidePlayerAfterJumpApex
                subq.b  #1,(a3)
                bpl.s   SSZEscape_ReturnFromPlayerInputOrSetup
                move.w  #(button_C_mask<<8)|button_C_mask,(a2)
                rts
; ---------------------------------------------------------------------------

SSZEscape_HidePlayerAfterJumpApex:
                tst.w   y_vel(a1)
                bmi.s   SSZEscape_SelectAirborneSteeringButtons
                move.w  #$7FFF,y_pos(a1)
                andi.b  #$FC,render_flags(a1)
                move.b  #3,object_control(a1)
                clr.b   anim(a1)
                bra.s   SSZEscape_ReturnFromPlayerInputOrSetup
; ---------------------------------------------------------------------------

SSZEscape_SelectAirborneSteeringButtons:
                move.w  #$2800,d0
                cmpi.w  #$1A40,x_pos(a1)
                blo.s   SSZEscape_StoreAirborneSteeringButtons
                move.w  #$2400,d0

SSZEscape_StoreAirborneSteeringButtons:
                move.w  d0,(a2)

SSZEscape_ReturnFromPlayerInputOrSetup:
                rts
; End of function DriveSsz1EscapeJumpInputAndHidePlayer

; =============== S U B R O U T I N E =======================================

UpdateSsz1EscapeSpiralForPlayers:
                lea     (Player_1).w,a1
                lea     $30(a0),a2
                moveq   #0,d3
                cmpi.w  #2,(Player_mode).w
                bne.s   SSZEscape_UpdateSpiralRiders
                moveq   #-1,d3

SSZEscape_UpdateSpiralRiders:
                bsr.s   UpdateSsz1EscapeSpiralClimbAndLaunch
                tst.w   (Player_mode).w
                bne.s   SSZEscape_ReturnFromPlayerInputOrSetup
                lea     (Player_2).w,a1
                lea     $32(a0),a2
                moveq   #-1,d3
; End of function UpdateSsz1EscapeSpiralForPlayers

; =============== S U B R O U T I N E =======================================

UpdateSsz1EscapeSpiralClimbAndLaunch:
                tst.w   4(a2)
                bne.w   SSZSpiral_UpdateLaunchFlightOrExitDelay
                cmpi.w  #$910,(a2)
                bne.s   SSZSpiral_AdvanceWithinTurnPhase
                st      4(a2)
                move.b  #1,object_control(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.w  #$800,ground_vel(a1)
                move.w  #$400,x_vel(a1)
                move.w  #-$680,y_vel(a1)
                clr.w   2+x_pos(a1)
                clr.w   2+y_pos(a1)
                moveq   #signextendB(sfx_Jump),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

SSZSpiral_AdvanceWithinTurnPhase:
                moveq   #0,d0
                move.b  1(a2),d0
                addq.b  #1,d0
                cmpi.b  #$70,d0
                blo.s   SSZSpiral_SelectAngleAndArtPriority
                subi.b  #$70,d0
                addq.b  #1,(a2)

SSZSpiral_SelectAngleAndArtPriority:
                move.b  d0,1(a2)
                lea     SSZSpiral_AngleByWithinTurnPhase(pc),a6
                move.b  (a6,d0.w),d0
                move.w  d0,d2
                andi.w  #drawing_mask,art_tile(a1)
                addi.b  #$40,d2
                bmi.s   SSZSpiral_CalcOrbitAndArc
                ori.w   #high_priority,art_tile(a1)

SSZSpiral_CalcOrbitAndArc:
                jsr     (GetSineCosine).l
                muls.w  #$4C00,d0
                swap    d0
                move.w  #$1A40,x_pos(a1)
                add.w   d0,x_pos(a1)
                muls.w  #$1C00,d1
                swap    d1
                subi.b  #$40,d2
                bpl.s   SSZSpiral_ApplyVerticalPhaseCorrection
                neg.w   d1
                subi.w  #$38,d1

SSZSpiral_ApplyVerticalPhaseCorrection:
                move.w  #$570,y_pos(a1)
                add.w   d1,y_pos(a1)
                lea     SSZSpiral_PhaseYCorrections(pc),a6
                moveq   #0,d0
                move.b  1(a2),d0
                move.b  (a6,d0.w),d0
                ext.w   d0
                sub.w   d0,y_pos(a1)
                moveq   #0,d0
                move.b  (a2),d0
                subq.w  #1,d0
                bcs.s   SSZSpiral_ApplyTailsHeightAndPriority

SSZSpiral_RaisePlayerForCompletedTurn:
                subi.w  #$70,y_pos(a1)
                dbf     d0,SSZSpiral_RaisePlayerForCompletedTurn

SSZSpiral_ApplyTailsHeightAndPriority:
                tst.w   d3
                beq.s   SSZSpiral_SelectRiderFrame
                addq.w  #4,y_pos(a1)
                move.w  #$100,priority(a1)
                tst.b   d2
                bmi.s   SSZSpiral_SelectRiderFrame
                move.w  #$80,priority(a1)

SSZSpiral_SelectRiderFrame:
                addi.w  #$A,d2
                andi.w  #$FF,d2
                move.w  d2,d0
                add.w   d2,d2
                add.w   d0,d2
                lsr.w   #6,d2
                lea     SSZSpiral_CharacterFramesByAngleBand(pc),a2
                move.b  (a2,d2.w),d0
                move.b  d0,mapping_frame(a1)
                jmp     (Perform_Player_DPLC).l
; ---------------------------------------------------------------------------

SSZSpiral_UpdateLaunchFlightOrExitDelay:
                tst.w   4(a2)
                bpl.s   SSZSpiral_TickP1ExitToDeathEgg
                move.w  x_vel(a1),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a1)
                move.w  y_vel(a1),d0
                addi.w  #$38,y_vel(a1)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a1)
                tst.w   y_vel(a1)
                bmi.s   SSZSpiral_ReturnDuringFlightOrExitDelay
                move.b  #3,object_control(a1)
                clr.b   mapping_frame(a1)
                clr.b   anim(a1)
                move.w  #3*60,4(a2)
                bra.s   SSZSpiral_ReturnDuringFlightOrExitDelay
; ---------------------------------------------------------------------------

SSZSpiral_TickP1ExitToDeathEgg:
                cmpa.w  #Player_1,a1
                bne.s   SSZSpiral_ReturnDuringFlightOrExitDelay
                subq.w  #1,4(a2)
                bne.s   SSZSpiral_ReturnDuringFlightOrExitDelay
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #$B00,d0
                jmp     (StartNewLevel).l
; ---------------------------------------------------------------------------

SSZSpiral_ReturnDuringFlightOrExitDelay:
                rts
; End of function UpdateSsz1EscapeSpiralClimbAndLaunch

; ---------------------------------------------------------------------------

SSZSpiralLeftOuterSection_Initialize:
                move.l  #SSZSpiralOuterLeft_CheckBreakHeight,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$1C,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZSpiralRamp,2,1),art_tile(a0)
                move.l  #Map_SSZCollapsingBridge,mappings(a0)
                move.b  #9,mapping_frame(a0)

SSZSpiralOuterLeft_CheckBreakHeight:
                move.w  y_pos(a0),d0
                subi.w  #$24,d0
                cmp.w   (Player_1+y_pos).w,d0
                bhs.w   SSZSpiralSection_ConvertParentToFalling
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZSpiralLeftInnerSection_Initialize:
                move.l  #SSZSpiralInnerLeft_SelectBreakStage,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$20,2,1),art_tile(a0)
                move.l  #Map_SSZCollapsingBridge,mappings(a0)
                move.b  #6,mapping_frame(a0)

SSZSpiralInnerLeft_SelectBreakStage:
                move.w  y_pos(a0),d0
                move.b  mapping_frame(a0),d1
                subq.b  #6,d1
                beq.s   SSZSpiralInnerLeft_SetFirstShard
                subq.b  #1,d1
                beq.s   SSZSpiralInnerLeft_SetSecondShard
                subi.w  #$2C,d0
                cmp.w   (Player_1+y_pos).w,d0
                blo.s   SSZSpiralLeftInnerSection_Draw
                bra.w   SSZSpiralSection_ConvertParentToFalling
; ---------------------------------------------------------------------------

SSZSpiralInnerLeft_SetSecondShard:
                moveq   #-$20,d1
                moveq   #8,d2
                subi.w  #$24,d0
                bra.s   SSZSpiralInnerLeft_TryAdvanceAndSpawn
; ---------------------------------------------------------------------------

SSZSpiralInnerLeft_SetFirstShard:
                moveq   #-$40,d1
                moveq   #$10,d2
                subi.w  #$1C,d0

SSZSpiralInnerLeft_TryAdvanceAndSpawn:
                cmp.w   (Player_1+y_pos).w,d0
                blo.s   SSZSpiralLeftInnerSection_Draw
                addq.b  #1,mapping_frame(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SSZSpiralLeftInnerSection_Draw
                moveq   #8,d0
                bra.s   SSZSpiralShard_InitFragment
; ---------------------------------------------------------------------------

SSZSpiralLeftInnerSection_Draw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZSpiralRightInnerSection_Initialize:
                move.l  #SSZSpiralInnerRight_SelectBreakStage,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$20,2,0),art_tile(a0)
                move.l  #Map_SSZCollapsingBridge,mappings(a0)
                move.b  #$B,mapping_frame(a0)

SSZSpiralInnerRight_SelectBreakStage:
                move.w  y_pos(a0),d0
                move.b  mapping_frame(a0),d1
                subi.b  #$B,d1
                beq.s   SSZSpiralInnerRight_SetFirstShard
                subq.b  #1,d1
                beq.s   SSZSpiralInnerRight_SetSecondShard
                subi.w  #$2C,d0
                cmp.w   (Player_1+y_pos).w,d0
                blo.s   SSZSpiralRightInnerSection_Draw
                bra.w   SSZSpiralSection_ConvertParentToFalling
; ---------------------------------------------------------------------------

SSZSpiralInnerRight_SetSecondShard:
                moveq   #$20,d1
                moveq   #8,d2
                subi.w  #$24,d0
                bra.s   SSZSpiralInnerRight_TryAdvanceAndSpawn
; ---------------------------------------------------------------------------

SSZSpiralInnerRight_SetFirstShard:
                moveq   #$40,d1
                moveq   #$10,d2
                subi.w  #$1C,d0

SSZSpiralInnerRight_TryAdvanceAndSpawn:
                cmp.w   (Player_1+y_pos).w,d0
                blo.s   SSZSpiralRightInnerSection_Draw
                addq.b  #1,mapping_frame(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SSZSpiralRightInnerSection_Draw
                moveq   #$D,d0

SSZSpiralShard_InitFragment:
                move.l  #SSZSpiralSection_DeleteIfNotRendered,(a1)
                move.b  #$84,render_flags(a1)
                move.b  #$10,height_pixels(a1)
                move.w  priority(a0),priority(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  d0,mapping_frame(a1)
                move.w  x_pos(a0),x_pos(a1)
                add.w   d1,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                add.w   d2,y_pos(a1)

SSZSpiralRightInnerSection_Draw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZSpiralRightOuterSection_Initialize:
                move.l  #SSZSpiralOuterRight_CheckBreakHeight,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$1C,height_pixels(a0)
                move.w  #$100,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZSpiralRamp,2,1),art_tile(a0)
                move.l  #Map_SSZCollapsingBridge,mappings(a0)
                move.b  #$A,mapping_frame(a0)

SSZSpiralOuterRight_CheckBreakHeight:
                move.w  y_pos(a0),d0
                subi.w  #$24,d0
                cmp.w   (Player_1+y_pos).w,d0
                bhs.s   SSZSpiralSection_ConvertParentToFalling
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZSpiralSection_ConvertParentToFalling:
                move.l  #SSZSpiralSection_DeleteIfNotRendered,(a0)

SSZSpiralSection_DeleteIfNotRendered:
                tst.b   render_flags(a0)
                bmi.s   SSZSpiralSection_FallAndDraw
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SSZSpiralSection_FallAndDraw:
                jsr     (MoveSprite).l
                jmp     (Draw_Sprite).l
