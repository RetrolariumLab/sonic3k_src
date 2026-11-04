; Owner: game/special_stage/sk
; Responsibility: Stage icons, moving instruction cues and the primary character state machine with player frame-loading support
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

SStageIcons_Initialize:
                move.b  #$80,width_pixels(a0)
                move.b  #$80,height_pixels(a0)
                move.w  #0,priority(a0)
                move.l  #Map_SSIcons,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Icons,2,1),art_tile(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$94,y_pos(a0)
                move.l  #SStageIcons_Draw,(a0)

SStageIcons_Draw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_SSIcons:
                include "src/game/special_stage/shared/mappings/icons.s"
; ---------------------------------------------------------------------------

SStageCue_InitializePair:
                jsr     (AllocateObjectAfterCurrent_SpecialStage).l
                bne.w   SStageCue_InitializeHalf
                move.l  #SStageCue_InitializeHalf,(a1)
                bset    #0,status(a1)
                move.b  #1,mapping_frame(a1)

SStageCue_InitializeHalf:
                move.b  #$80,width_pixels(a0)
                move.b  #$80,height_pixels(a0)
                move.w  #0,priority(a0)
                move.l  #Map_GetBlueSpheres,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_GetBlueSpheres,1,1),art_tile(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$E8,y_pos(a0)
                move.w  #3*60,$32(a0)
                move.l  #SStageCue_WaitBeforeInitialExit,(a0)

SStageCue_WaitBeforeInitialExit:
                tst.w   $32(a0)
                beq.s   SKSS_FinishEntryAndEnableAdvance
                subq.w  #1,$32(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSS_FinishEntryAndEnableAdvance:
                cmpi.w  #$C0,$30(a0)
                blo.s   SStageCue_IncreaseInitialSeparation
                move.l  #SStageCue_WaitUntilAllRingsCollected,(a0)
                addq.b  #2,mapping_frame(a0)
                tst.w   (Special_stage_velocity).w
                bne.s   SStageCue_SelectInitialExitSide
                move.b  #1,(Special_stage_advancing).w
                move.b  #1,(Special_stage_started).w
                bra.s   SStageCue_SelectInitialExitSide
; ---------------------------------------------------------------------------

SStageCue_IncreaseInitialSeparation:
                addi.w  #$10,$30(a0)

SStageCue_SelectInitialExitSide:
                move.w  $30(a0),d0
                btst    #0,status(a0)
                bne.s   SStageCue_StoreInitialExitXAndDraw
                neg.w   d0

SStageCue_StoreInitialExitXAndDraw:
                addi.w  #$120,d0
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SStageCue_WaitUntilAllRingsCollected:
                tst.w   (Special_stage_rings_left).w
                beq.s   SStageCue_MoveCompletionHalvesInward
                rts
; ---------------------------------------------------------------------------

SStageCue_MoveCompletionHalvesInward:
                subi.w  #$10,$30(a0)
                bne.s   SStageCue_SelectInwardSide
                move.l  #SStageCue_WaitBeforeCompletionExit,(a0)
                move.w  #180,$32(a0)

SStageCue_SelectInwardSide:
                move.w  $30(a0),d0
                btst    #0,status(a0)
                bne.s   SStageCue_StoreInwardXAndDraw
                neg.w   d0

SStageCue_StoreInwardXAndDraw:
                addi.w  #$120,d0
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SStageCue_WaitBeforeCompletionExit:
                tst.w   $32(a0)
                beq.s   SStageCue_IncreaseCompletionSeparation
                subq.w  #1,$32(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SStageCue_IncreaseCompletionSeparation:
                cmpi.w  #$C0,$30(a0)
                bhs.s   SStageCue_SelectCompletionExitSide
                addi.w  #$10,$30(a0)

SStageCue_SelectCompletionExitSide:
                move.w  $30(a0),d0
                btst    #0,status(a0)
                bne.s   SStageCue_StoreCompletionExitXAndDraw
                neg.w   d0

SStageCue_StoreCompletionExitXAndDraw:
                addi.w  #$120,d0
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_GetBlueSpheres:
                include "src/game/special_stage/shared/mappings/get_blue_spheres.s"
; ---------------------------------------------------------------------------

SStagePlayer_InitializePrimaryCharacter:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.l  #Map_SStageSonic,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Player1,0,1),art_tile(a0)
                cmpi.w  #2,(Player_mode).w
                bne.s   SStagePlayer_SelectKnucklesMappings
                move.l  #Map_SStageTails,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Player2,1,1),art_tile(a0)
                jsr     (AllocateObjectAfterCurrent_SpecialStage).l
                bne.w   SStagePlayer_SelectKnucklesMappings
                move.l  #SStageTailsTail_InitializeAttachment,(a1)
                move.w  a0,$3E(a1)

SStagePlayer_SelectKnucklesMappings:
                cmpi.w  #3,(Player_mode).w
                bne.s   SKSS_InitProjectionAndFrameCache
                move.l  #Map_SStageKnuckles,mappings(a0)
                move.w  #make_art_tile(ArtTile_SStage_Player1,0,1),art_tile(a0)

SKSS_InitProjectionAndFrameCache:
                move.w  #$A0,$30(a0)
                move.w  #$70,$32(a0)
                move.w  #0,$34(a0)
                move.w  #$F800,$36(a0)
                move.w  #0,$38(a0)
                bsr.w   SStage_UpdateProjectionScalars
                move.b  #$FF,$3A(a0)
                move.l  #SStagePlayer_UpdateRateTimerAndTempo,(a0)

SStagePlayer_UpdateRateTimerAndTempo:
                tst.w   (Special_stage_rate_timer).w
                beq.s   SStagePlayer_UpdateGridMotionAndRunCycle
                subq.w  #1,(Special_stage_rate_timer).w
                bne.s   SStagePlayer_UpdateGridMotionAndRunCycle
                move.w  #30*60,(Special_stage_rate_timer).w
                tst.b   (Blue_spheres_stage_flag).w
                beq.s   SStagePlayer_IncreaseRateAndAdjustTempo
                move.w  #45*60,(Special_stage_rate_timer).w

SStagePlayer_IncreaseRateAndAdjustTempo:
                cmpi.w  #$2000,(Special_stage_rate).w
                beq.s   SStagePlayer_UpdateGridMotionAndRunCycle
                addi.w  #$400,(Special_stage_rate).w
                move.b  (Special_stage_rate).w,d0
                subi.b  #$20,d0
                neg.b   d0
                add.b   d0,d0
                addq.b  #8,d0
                jsr     (Change_Music_Tempo).l

SStagePlayer_UpdateGridMotionAndRunCycle:
                bsr.w   SStage_UpdatePlayerGridMotion
                moveq   #$C,d0
                move.w  (Special_stage_velocity).w,d1
                beq.s   SKSS_SelectRunOrJumpFrames
                asr.w   #5,d1
                add.w   d1,anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame_timer(a0),d0
                bpl.s   SStagePlayer_WrapNonnegativeRunCycle
                addi.b  #$C,d0
                bra.s   SKSS_SelectRunOrJumpFrames
; ---------------------------------------------------------------------------

SStagePlayer_WrapNonnegativeRunCycle:
                cmpi.b  #$C,d0
                blo.s   SKSS_SelectRunOrJumpFrames
                subi.b  #$C,d0

SKSS_SelectRunOrJumpFrames:
                move.b  d0,anim_frame_timer(a0)
                lea     (SStagePlayer_RunAndIdleMappingFrames).l,a1
                tst.b   (Special_stage_jumping).w
                bpl.s   SStagePlayer_ApplyFrameAndRequestJump
                lea     (SStagePlayer_JumpMappingFrames).l,a1
                move.w  (Special_stage_velocity).w,d1
                bne.s   SStagePlayer_ApplyFrameAndRequestJump
                move.b  (Level_frame_counter+1).w,d0
                andi.w  #3,d0

SStagePlayer_ApplyFrameAndRequestJump:
                move.b  (a1,d0.w),mapping_frame(a0)
                tst.b   (Special_stage_clear_routine).w
                bne.s   SKSS_StartJumpWhenGridAligned
                move.w  (Ctrl_1).w,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   SKSS_StartJumpWhenGridAligned
                tst.b   (Special_stage_jumping).w
                bmi.s   SKSS_StartJumpWhenGridAligned
                move.b  #1,(Special_stage_jumping).w

SKSS_StartJumpWhenGridAligned:
                move.b  (Special_stage_angle).w,d0
                andi.b  #$3F,d0
                bne.w   SStagePlayer_ProjectDrawAndSelectArt
                cmpi.b  #1,(Special_stage_jumping).w
                bne.s   SStagePlayer_IntegrateActiveJumpHeight
                move.l  #-$100000,$40(a0)
                move.b  #$80,(Special_stage_jumping).w
                move.b  #0,(Special_stage_turning).w
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l

SStagePlayer_IntegrateActiveJumpHeight:
                tst.b   (Special_stage_jumping).w
                bpl.s   SStagePlayer_ProjectDrawAndSelectArt
                move.l  $3C(a0),d0
                add.l   $40(a0),d0
                bmi.s   SStagePlayer_ApplyRateScaledJumpGravity
                moveq   #0,d0
                move.l  d0,$40(a0)
                move.b  d0,(Special_stage_jumping).w

SStagePlayer_ApplyRateScaledJumpGravity:
                move.w  (Special_stage_rate).w,d1
                ext.l   d1
                lsl.l   #4,d1
                add.l   d1,$40(a0)
                move.l  d0,$3C(a0)
                swap    d0
                addi.w  #-$800,d0
                move.w  d0,$36(a0)

SStagePlayer_ProjectDrawAndSelectArt:
                bsr.w   SStage_UpdateProjectionScalars
                bsr.w   SStage_ProjectCharacterCoordinates
                jsr     (Draw_Sprite).l
                lea     (PLC_SStageSonic).l,a2
                move.l  #ArtUnc_SStageSonic,d6
                move.w  #tiles_to_bytes(ArtTile_SStage_Player1),d4
                cmpi.w  #2,(Player_mode).w
                bne.s   SStagePlayer_SelectKnucklesArtAndDPLC
                lea     (PLC_SStageTails).l,a2
                move.l  #ArtUnc_SStageTails,d6
                move.w  #tiles_to_bytes(ArtTile_SStage_Player2),d4
                bra.s   SStagePlayer_QueueArtForChangedFrame
; ---------------------------------------------------------------------------

SStagePlayer_SelectKnucklesArtAndDPLC:
                cmpi.w  #3,(Player_mode).w
                bne.s   SStagePlayer_QueueArtForChangedFrame
                lea     (PLC_SStageKnuckles).l,a2
                move.l  #ArtUnc_SStageKnuckles,d6
                move.w  #tiles_to_bytes(ArtTile_SStage_Player1),d4

SStagePlayer_QueueArtForChangedFrame:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $3A(a0),d0
                beq.s   SStagePlayer_ReturnFromArtUpload
                move.b  d0,$3A(a0)
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   SStagePlayer_ReturnFromArtUpload

SStagePlayer_QueueDPLCDescriptor:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,SStagePlayer_QueueDPLCDescriptor

SStagePlayer_ReturnFromArtUpload:
                rts
; ---------------------------------------------------------------------------
SStagePlayer_RunAndIdleMappingFrames:
                dc.b    2,   6,   7,   8,   7,   6,   2,   3,   4,   5,   4,   3,   1,   0
SStagePlayer_JumpMappingFrames:
                dc.b    9,  $B,  $A,  $B,   9,  $B,  $A,  $B,   9,  $B,  $A,  $B,  $B,   0
SStageTails_JumpMappingFrames:
                dc.b    9,  $A,  $B,   9,  $A,  $B,   9,  $A,  $B,   9,  $A,  $B,  $B,   0
                even
; ---------------------------------------------------------------------------
