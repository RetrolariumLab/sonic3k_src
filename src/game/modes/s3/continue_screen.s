; Owner: game/modes/s3
; Responsibility: Continue screen mode, character and icon actors, countdown display and private art resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

ContinueScreen:
                jsr     (Pal_FadeToBlack).l
                move    #$2700,sr
                move.w  (VDP_reg_1_command).w,d0
                andi.b  #$BF,d0
                move.w  d0,(VDP_control_port).l
                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)
                move.w  #$8700,(a6)
                jsr     (Clear_DisplayData).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Continue_Digits),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_ContinueDigits).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_S3Fonts_BigText),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_S3CreditsText).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Continue_Misc),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_ContinueSprites).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Continue_Icons),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_ContinueIcons).l,a0
                jsr     (Nem_Decomp).l
                clr.b   (Level_started_flag).w
                clr.b   (_unkFAA9).w
                clr.b   (_unkFA88).w
                clearRAM Player_1,(Kos_decomp_buffer-Player_1)
                clearRAM (RAM_start+$2000),$2000
                jsr     (Init_SpriteTable).l
                move.w  #(11*60)-1,(Demo_timer).w
                lea     (Pal_ContinueScreen).l,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($80),d6

S3Continue_CopyPaletteAndInstallActors:
                move.l  (a1)+,(a2)+
                dbf     d6,S3Continue_CopyPaletteAndInstallActors
                lea     aCONTINUE(pc),a1
                jsr     S3Credits_DrawPageAndQueueUpload(pc)
                move.l  #Obj_Continue_SonicWTails,(Player_1).w
                move.l  #Obj_Continue_TailsWSonic,(Player_2).w
                move.l  #S3Continue_KnucklesDispatchAndDraw,(Reserved_object_3).w
                lea     (Dynamic_object_RAM).w,a1
                move.l  #S3Continue_InitCountdownAt10,(a1)
                move.w  a1,(_unkFAA4).w
                move.l  #S3Continue_InitStaticEmblem,(Dynamic_object_RAM+object_size).w
                bsr.w   S3Continue_InitRemainingLifeIcons
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                move.b  #VInt_ID_18,(V_int_routine).w
                jsr     (Wait_VSync).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                moveq   #signextendB(mus_Continue),d0
                jsr     (Play_Music).l
                jsr     (Pal_FadeFromBlack).l

S3Continue_RunUntilOutcome:
                move.b  #VInt_ID_18,(V_int_routine).w
                jsr     (Wait_VSync).l
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                move.b  (_unkFAA9).w,d0
                beq.s   S3Continue_RunUntilOutcome
                subq.b  #1,d0
                beq.s   S3Continue_RestoreStatsAndConsume
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

S3Continue_RestoreStatsAndConsume:
                move.b  #GameMode_Level,(Game_mode).w
                move.b  #3,(Life_count).w
                move.b  #3,(Life_count_P2).w
                moveq   #0,d0
                move.w  d0,(Ring_count).w
                move.l  d0,(Timer).w
                move.l  d0,(Score).w
                move.w  d0,(Ring_count_P2).w
                move.l  d0,(Timer_P2).w
                move.l  d0,(Score_P2).w
                move.l  #5000,(Next_extra_life_score).w
                move.l  #5000,(Next_extra_life_score_P2).w
                subq.b  #1,(Continue_count).w

S3Continue_SetupOrIconReturn:
                rts
; ---------------------------------------------------------------------------

S3Continue_InitCountdownAt10:
                move.l  #S3Continue_CheckStartOrTick,(a0)
                clr.w   (_unkFA82).w
                move.b  #$A,(_unkFA84).w

S3Continue_CheckStartOrTick:
                btst    #button_start,(Ctrl_1_pressed).w
                bne.s   S3Continue_LatchStartAndStopTimer
                btst    #button_start,(Ctrl_2_pressed).w
                bne.s   S3Continue_LatchStartAndStopTimer
                subq.w  #1,(_unkFA82).w
                bpl.s   S3Continue_CountdownReturn
                move.w  #60-1,(_unkFA82).w
                move.b  (_unkFA84).w,d0
                subq.b  #1,d0
                bmi.s   S3Continue_SignalTimeout
                move.b  d0,(_unkFA84).w
                bsr.w   S3Continue_DrawTimerAndQueueUpload

S3Continue_CountdownReturn:
                rts
; ---------------------------------------------------------------------------

S3Continue_SignalTimeout:
                move.b  #2,(_unkFAA9).w
                rts
; ---------------------------------------------------------------------------

S3Continue_LatchStartAndStopTimer:
                move.l  #S3Continue_AcceptedControllerReturn,(a0)
                bset    #3,$38(a0)

S3Continue_AcceptedControllerReturn:
                rts
; ---------------------------------------------------------------------------

Obj_Continue_SonicWTails:
                move.l  #Map_ContinueSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Misc,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.w  #$118,x_pos(a0)
                move.w  #$120,y_pos(a0)
                move.l  #S3Continue_SonicWaitAndBlink,(a0)

S3Continue_SonicWaitAndBlink:
                movea.w (_unkFAA4).w,a1
                btst    #3,$38(a1)
                bne.s   S3Continue_SonicEnterStateDispatch
                move.b  #0,mapping_frame(a0)
                btst    #4,(V_int_run_count+3).w
                beq.s   S3Continue_SonicDrawWaiting
                move.b  #1,mapping_frame(a0)

S3Continue_SonicDrawWaiting:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Continue_SonicEnterStateDispatch:
                move.l  #S3Continue_SonicDispatchAndDraw,(a0)

S3Continue_SonicDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3Continue_SonicStateIndex(pc,d0.w),d1
                jsr     S3Continue_SonicStateIndex(pc,d1.w)
                jsr     (Sonic_Load_PLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
S3Continue_SonicStateIndex:
                dc.w    S3Continue_InitSonicExitMappings-S3Continue_SonicStateIndex
                dc.w    S3Continue_SonicStepFrameAndFlip-S3Continue_SonicStateIndex
                dc.w    S3Continue_SonicAnimateAndTickHold-S3Continue_SonicStateIndex
                dc.w    S3Continue_SonicRunToExit-S3Continue_SonicStateIndex
                dc.w    S3Continue_SonicFinishedReturn-S3Continue_SonicStateIndex
; ---------------------------------------------------------------------------

S3Continue_InitSonicExitMappings:
                addq.b  #2,routine(a0)
                move.l  #Map_Sonic,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                clr.b   (Player_prev_frame).w
                move.b  #$5A,mapping_frame(a0)
                move.b  #6,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3Continue_SonicStepFrameAndFlip:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3Continue_SonicFrameUpdateReturn
                move.b  #6,anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                cmpi.b  #$A,d0
                bhs.s   S3Continue_SonicBeginAnimatedHold
                move.b  d0,anim_frame(a0)
                lea     S3Continue_SonicFrameAndFlipPairs(pc,d0.w),a2
                move.b  (a2)+,mapping_frame(a0)
                bclr    #0,render_flags(a0)
                tst.b   (a2)
                beq.s   S3Continue_SonicFrameUpdateReturn
                bset    #0,render_flags(a0)

S3Continue_SonicFrameUpdateReturn:
                rts
; ---------------------------------------------------------------------------

S3Continue_SonicBeginAnimatedHold:
                move.b  #4,routine(a0)
                move.w  #1,anim(a0)
                move.w  #$600,ground_vel(a0)
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------
S3Continue_SonicFrameAndFlipPairs:
                dc.b    $5A,   1
                dc.b    $59,   1
                dc.b    $55,   0
                dc.b    $56,   0
                dc.b    $57,   0
                even
; ---------------------------------------------------------------------------

S3Continue_SonicAnimateAndTickHold:
                jsr     (Animate_Sonic).l
                subq.w  #1,$2E(a0)
                bmi.s   S3Continue_SonicSelectRun
                rts
; ---------------------------------------------------------------------------

S3Continue_SonicSelectRun:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3Continue_SonicRunToExit:
                jsr     (Animate_Sonic).l
                addq.w  #6,x_pos(a0)
                cmpi.w  #$1E0,x_pos(a0)
                bhs.s   S3Continue_SonicSelectFinished
                rts
; ---------------------------------------------------------------------------

; Tails publishes the accepted outcome for the pair
S3Continue_SonicSelectFinished:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3Continue_SonicFinishedReturn:
                rts
; ---------------------------------------------------------------------------

Obj_Continue_TailsWSonic:
                move.l  #Map_ContinueSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Misc,0,0),art_tile(a0)
                move.w  #$200,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.w  #$12C,x_pos(a0)
                move.w  #$120,y_pos(a0)
                move.l  #S3Continue_TailsWaitAndBlink,(a0)

S3Continue_TailsWaitAndBlink:
                movea.w (_unkFAA4).w,a1
                btst    #3,$38(a1)
                bne.s   S3Continue_TailsInstallExitActors
                move.b  #5,mapping_frame(a0)
                btst    #5,(V_int_run_count+3).w
                beq.s   S3Continue_TailsDrawWaiting
                move.b  #6,mapping_frame(a0)

S3Continue_TailsDrawWaiting:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Continue_TailsInstallExitActors:
                move.l  #S3Continue_TailsDispatchAndDraw,(a0)
                addq.w  #4,y_pos(a0)
                lea     (Tails_tails).w,a1
                move.l  #Obj_Tails_Tail,(a1)
                move.w  a0,$30(a1)
                move.l  #S3Continue_FixTailFlagAndDeleteDust,(Dust).w

S3Continue_TailsDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3Continue_TailsStateIndex(pc,d0.w),d1
                jsr     S3Continue_TailsStateIndex(pc,d1.w)
                jsr     (Tails_Load_PLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
S3Continue_TailsStateIndex:
                dc.w    S3Continue_InitTailsMapAndDelay-S3Continue_TailsStateIndex
                dc.w    S3Continue_TailsWaitThenAnimate-S3Continue_TailsStateIndex
                dc.w    S3Continue_TailsTickDelayBeforeRun-S3Continue_TailsStateIndex
                dc.w    S3Continue_TailsRunAndSignalAccept-S3Continue_TailsStateIndex
; ---------------------------------------------------------------------------

S3Continue_InitTailsMapAndDelay:
                addq.b  #2,routine(a0)
                move.l  #Map_Tails,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                clr.b   (Player_prev_frame_P2).w
                move.w  #5<<8,anim(a0)                  ; and prev_anim
                move.w  #$AD<<8,mapping_frame(a0)       ; and anim_frame
                move.w  #40-1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

S3Continue_TailsWaitThenAnimate:
                subq.w  #1,$2E(a0)
                bpl.w   S3Continue_SetupOrIconReturn
                move.b  #4,routine(a0)
                move.b  #0,anim(a0)
                move.w  #$600,ground_vel(a0)
                move.w  #20-1,$2E(a0)

S3Continue_TailsTickDelayBeforeRun:
                subq.w  #1,$2E(a0)
                bpl.s   S3Continue_TailsAnimateBeforeRun
                move.b  #6,routine(a0)

S3Continue_TailsAnimateBeforeRun:
                jmp     (Animate_Tails).l
; ---------------------------------------------------------------------------

S3Continue_TailsRunAndSignalAccept:
                addq.w  #6,x_pos(a0)
                cmpi.w  #$1E0,x_pos(a0)
                blo.s   S3Continue_TailsAnimateRun
                move.b  #1,(_unkFAA9).w

S3Continue_TailsAnimateRun:
                jmp     (Animate_Tails).l
; ---------------------------------------------------------------------------

S3Continue_FixTailFlagAndDeleteDust:
                bclr    #2,(Tails_tails+render_flags).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3Continue_KnucklesDispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3Continue_KnucklesStateIndex(pc,d0.w),d1
                jsr     S3Continue_KnucklesStateIndex(pc,d1.w)
                lea     (DPLCPtr_CutsceneKnux).l,a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
S3Continue_KnucklesStateIndex:
                dc.w    S3Continue_InitKnucklesExitSprite-S3Continue_KnucklesStateIndex
                dc.w    S3Continue_KnucklesWaitForStart-S3Continue_KnucklesStateIndex
                dc.w    S3Continue_KnucklesRunToExit-S3Continue_KnucklesStateIndex
                dc.w    S3Continue_KnucklesFinishedReturn-S3Continue_KnucklesStateIndex
; ---------------------------------------------------------------------------

S3Continue_InitKnucklesExitSprite:
                lea     (ObjSlot_CutsceneKnux).l,a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  #make_art_tile(ArtTile_CutsceneKnux,3,0),art_tile(a0)
                bclr    #2,render_flags(a0)
                move.w  #$40,x_pos(a0)
                move.w  #$120,y_pos(a0)

S3Continue_KnucklesWaitForStart:
                movea.w (_unkFAA4).w,a1
                btst    #3,$38(a1)
                bne.s   S3Continue_KnucklesBeginRun
                rts
; ---------------------------------------------------------------------------

S3Continue_KnucklesBeginRun:
                move.b  #4,routine(a0)

S3Continue_KnucklesRunToExit:
                move.w  x_pos(a0),d0
                addq.w  #6,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$1E0,d0
                bhs.s   S3Continue_KnucklesSelectFinished
                lea     S3Continue_KnucklesDepartureAnim(pc),a1
                jmp     (Animate_RawNoSST).l
; ---------------------------------------------------------------------------

S3Continue_KnucklesSelectFinished:
                move.b  #6,routine(a0)

S3Continue_KnucklesFinishedReturn:
                rts
; ---------------------------------------------------------------------------

S3Continue_InitStaticEmblem:
                move.l  #Map_ContinueSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Misc,2,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #7,mapping_frame(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$F5,y_pos(a0)
                move.l  #S3Continue_DrawStaticEmblem,(a0)

S3Continue_DrawStaticEmblem:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Continue_InitRemainingIcon:
                move.l  #Map_ContinueIcons,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Icons,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                bsr.w   S3ContinuePositionIconByEvenSubtypeTable
                move.w  #$D8,y_pos(a0)
                move.l  #S3Continue_SelectBlinkPairOffset,(a0)
                bsr.w   S3Continue_SelectCharacterIcon

S3Continue_SelectBlinkPairOffset:
                moveq   #0,d0
                btst    #4,(V_int_run_count+3).w
                beq.s   S3Continue_DrawSelectedIconFrame
                addq.w  #1,d0

S3Continue_DrawSelectedIconFrame:
                movea.l $30(a0),a1
                move.b  (a1,d0.w),mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

ContinueTailsIconChild_Initialize:
                move.l  #Map_ContinueIcons,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Icons,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.l  #ContinueTailsIconChild_AnimateAndDraw,(a0)

ContinueTailsIconChild_AnimateAndDraw:
                lea     ContinueTailsIconChild_RawAnimation(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Use the two countdown nibbles as two-tile-high digits and request a V-int upload
S3Continue_DrawTimerAndQueueUpload:
                move.b  (_unkFA84).w,d0
                move.b  d0,d1
                andi.w  #$F0,d0
                lsr.w   #3,d0
                andi.w  #$F,d1
                add.w   d1,d1
                move.w  #1,d2
                lea     (RAM_start+$2726).l,a1
                add.w   d2,d0
                move.w  d0,(a1)
                addq.w  #1,d0
                move.w  d0,$80(a1)
                add.w   d2,d1
                move.w  d1,2(a1)
                addq.w  #1,d1
                move.w  d1,$82(a1)
                bset    #0,(_unkFA88).w
                rts
; End of function S3Continue_DrawTimerAndQueueUpload

; =============== S U B R O U T I N E =======================================

; Clamp the count to 1 through 10 and initialize count minus one supplementary icons
S3Continue_InitRemainingLifeIcons:
                moveq   #0,d0
                move.b  (Continue_count).w,d0
                beq.s   S3Continue_ClampIconCountTo10
                cmpi.b  #$A,d0
                bls.s   S3Continue_PrepFixedIconSlots

S3Continue_ClampIconCountTo10:
                moveq   #$A,d0
                move.b  d0,(Continue_count).w

S3Continue_PrepFixedIconSlots:
                lea     (Dynamic_object_RAM+(object_size*2)).w,a1
                moveq   #0,d1

S3Continue_SeedCountMinusOneIcons:
                subq.b  #1,d0
                beq.w   S3Continue_SetupOrIconReturn
                move.l  #S3Continue_InitRemainingIcon,(a1)
                move.b  d1,subtype(a1)
                addq.w  #2,d1
                lea     next_object(a1),a1
                bra.s   S3Continue_SeedCountMinusOneIcons
; End of function S3Continue_InitRemainingLifeIcons

; =============== S U B R O U T I N E =======================================

S3ContinuePositionIconByEvenSubtypeTable:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  S3Continue_IconXPositions(pc,d0.w),x_pos(a0)
                rts
; End of function S3ContinuePositionIconByEvenSubtypeTable

; ---------------------------------------------------------------------------
S3Continue_IconXPositions:
                dc.w    $120
                dc.w    $138
                dc.w    $108
                dc.w    $150
                dc.w    $F0
                dc.w    $168
                dc.w    $D8
                dc.w    $180
                dc.w    $C0

; =============== S U B R O U T I N E =======================================

; Select the two-frame sequence by player mode and create a Tails child in mode 2
S3Continue_SelectCharacterIcon:
                move.w  (Player_mode).w,d4
                cmpi.b  #2,d4
                bne.s   S3Continue_SelectModeIconPair
                lea     ContinueTailsIconChild_SimpleSpawnRecord(pc),a2
                jsr     (CreateChild6_Simple).l

S3Continue_SelectModeIconPair:
                lsl.w   #2,d4
                move.l  S3Continue_ModeIconPairPointers(pc,d4.w),$30(a0)
                rts
; End of function S3Continue_SelectCharacterIcon

; ---------------------------------------------------------------------------
ContinueTailsIconChild_SimpleSpawnRecord:
                dc.w    1-1
                dc.l    ContinueTailsIconChild_Initialize
S3Continue_ModeIconPairPointers:
                dc.l    S3Continue_SonicCountIconFramePair
                dc.l    S3Continue_SonicCountIconFramePair
                dc.l    S3Continue_TailsCountIconFramePair
                dc.l    S3Continue_KnucklesCountIconFramePair
aCONTINUE:
                dc.w    0
                dc.w    $292
                dc.b    "C O N T I N U E",0
                even
Pal_ContinueScreen:
                binclude "data/General/Continue/Palettes/Palette S3.bin"
                even
