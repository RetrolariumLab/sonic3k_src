; Owner: game/modes/s3
; Responsibility: Ending and credits mode, scene coordination, logo and text actors and text drawing helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

S3Credits:
                moveq   #signextendB(cmd_Stop),d0
                jsr     (Play_Music).l
                jsr     (Clear_Nem_Queue).l
                jsr     (Pal_FadeToBlack).l
                lea     (VDP_control_port).l,a6
                move.w  #$8004,(a6)
                move.w  #$8230,(a6)
                move.w  #$8407,(a6)
                move.w  #$8700,(a6)
                move.w  #$8B03,(a6)
                move.w  #$8C81,(a6)
                move.w  #$9011,(a6)
                move.w  #$9200,(a6)
                clr.b   (Water_full_screen_flag).w
                clr.w   (Competition_mode).w
                move    #$2700,sr
                move.w  (VDP_reg_1_command).w,d0
                andi.b  #$BF,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Clear_DisplayData).l
; Bug: this should be Sprite_table_End-Sprite_table
                clearRAM Sprite_table,(Sprite_table_end-Sprite_table)+4
; Bug: this should be Collision_response_list_End-H_scroll_buffer
                clearRAM H_scroll_buffer,(Collision_response_list_end-H_scroll_buffer)+4
                clearRAM Sprite_table_input,(Sprite_table_input_end-Sprite_table_input)
                clearRAM Player_1,(Kos_decomp_buffer-Player_1)
                clearRAM RAM_start+$2000,$2000
                clearRAM _unkFA80,(DMA_queue-_unkFA80)
                clr.w   (DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                clr.w   (Player_mode).w
                clr.b   (Current_act_2P).w
                clr.w   (Results_screen_2P).w
                clr.b   (Level_started_flag).w
                clr.w   (Anim_Counters).w
                clr.w   (_unkFF98).w
                clr.w   (Competition_mode).w
                clr.l   (Camera_X_pos).w
                clr.l   (Camera_Y_pos).w
                clr.l   (V_scroll_value).w
                clr.l   (_unkF61A).w
                jsr     (Init_SpriteTable).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_S3Fonts_SmallText),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_S38x16Font).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_S3Fonts_BigText),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_S3CreditsText).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_Ending_Sprites),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_EndingGraphics).l,a0
                jsr     (Nem_Decomp).l
                lea     (ArtKosM_AIZIntroEmeralds).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Emeralds),d2
                jsr     (Queue_Kos_Module).l
                lea     S3CreditsText_Main(pc),a1
                move.w  (a1),d0
                adda.w  d0,a1
                bsr.w   S3Credits_DrawPageAndQueueUpload
                lea     (Pal_Ending).l,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($40),d6

S3Credits_CopyPaletteAndStartDisplay:
                move.l  (a1)+,(a2)+
                dbf     d6,S3Credits_CopyPaletteAndStartDisplay
                moveq   #signextendB(mus_Credits3),d0
                jsr     (Play_Music).l
                move.w  #3*60,(_unkFA82).w
                move.b  #VInt_ID_18,(V_int_routine).w
                jsr     (Wait_VSync).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Pal_FadeFromBlack).l

S3Credits_RunUntilModeChanges:
                move.b  #VInt_ID_18,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                jsr     (Wait_VSync).l
                addq.w  #1,(Level_frame_counter).w
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                bsr.w   S3Credits_DispatchDisplayState
                jsr     (Process_Nem_Queue_Init).l
                jsr     (Process_Kos_Module_Queue).l
                cmpi.b  #GameMode_S3Credits,(Game_mode).w
                beq.w   S3Credits_RunUntilModeChanges
                rts

; =============== S U B R O U T I N E =======================================

S3Credits_DispatchDisplayState:
                move.w  (_unkFA86).w,d0
                move.w  S3Credits_PageStateOffsets(pc,d0.w),d0
                jmp     S3Credits_PageStateOffsets(pc,d0.w)
; End of function S3Credits_DispatchDisplayState

; ---------------------------------------------------------------------------
S3Credits_PageStateOffsets:
                dc.w    S3Credits_TickPageTimer-S3Credits_PageStateOffsets
                dc.w    S3Credits_ScrollAltPageUntilByteWrap-S3Credits_PageStateOffsets
                dc.w    S3Credits_FinishedCreditsReturn-S3Credits_PageStateOffsets
; ---------------------------------------------------------------------------

S3Credits_TickPageTimer:
                subq.w  #1,(_unkFA82).w
                bmi.s   S3Credits_FadeToNextPageOrEyecatch
                rts
; ---------------------------------------------------------------------------

S3Credits_FadeToNextPageOrEyecatch:
                move.w  #3*60,(_unkFA82).w
                jsr     (Pal_FadeToBlack).l
                clearRAM RAM_start+$2000,$1000
                move.w  (_unkFA84).w,d0
                addq.w  #2,d0
                move.w  d0,(_unkFA84).w
                lea     S3CreditsText_Main(pc),a1
                move.w  (a1,d0.w),d0
                beq.w   S3Credits_BeginEyecatchAndSelectColors
                lea     (a1,d0.w),a1
                bsr.w   S3Credits_DrawPageAndQueueUpload
                move.b  #VInt_ID_18,(V_int_routine).w
                jsr     (Wait_VSync).l
                jmp     (Pal_FadeFromBlack).l
; ---------------------------------------------------------------------------
; unused
                move.w  #2,(_unkFA86).w
                lea     S3CreditsText_Dummy(pc),a1
                move.w  (a1),d0
                adda.w  d0,a1
                bsr.w   S3Credits_DrawPageAndQueueUpload
                lea     (Target_palette).w,a1
                lea     (Normal_palette).w,a2
                moveq   #bytesToLcnt($80),d6

S3Credits_CopyAlternateTargetPalette:
                move.l  (a1)+,(a2)+
                dbf     d6,S3Credits_CopyAlternateTargetPalette
                clr.w   (_unkFA84).w
                rts
; ---------------------------------------------------------------------------

S3Credits_ScrollAltPageUntilByteWrap:
                move.w  (V_scroll_value).w,d0
                addq.w  #1,d0
                move.w  d0,(V_scroll_value).w
                andi.w  #$FF,d0
                beq.s   S3Credits_AdvanceDummyAndSelectHalf
                rts
; ---------------------------------------------------------------------------

S3Credits_AdvanceDummyAndSelectHalf:
                move.w  (_unkFA84).w,d0
                addq.w  #2,d0
                move.w  d0,(_unkFA84).w
                lea     (RAM_start+$2000).l,a2
                btst    #1,d0
                bne.s   S3Credits_Prepare4KHalfClear
                lea     (RAM_start+$3000).l,a2

S3Credits_Prepare4KHalfClear:
                moveq   #0,d2
                move.w  #bytesToLcnt($1000),d3

S3Credits_ClearHalfAndDrawDummyPage:
                move.l  d2,(a2)+
                dbf     d3,S3Credits_ClearHalfAndDrawDummyPage
                lea     S3CreditsText_Dummy(pc),a1
                move.w  (a1,d0.w),d0
                beq.s   S3Credits_BeginEyecatchAndSelectColors
                lea     (a1,d0.w),a1
                bra.w   S3Credits_DrawPageAndQueueUpload
; ---------------------------------------------------------------------------

; Select the logo palette only when the whole Chaos emerald word equals seven
S3Credits_BeginEyecatchAndSelectColors:
                jsr     (Pal_FadeToBlack).l
                move.w  #4,(_unkFA86).w
                lea     Pal_EndingEyecatchKnuckles(pc),a1
                cmpi.w  #7,(Chaos_emerald_count).w
                bne.s   S3Credits_PrepareLowerPaletteLines
                lea     Pal_EndingS3Logo(pc),a1

S3Credits_PrepareLowerPaletteLines:
                lea     (Target_palette_line_3).w,a2
                moveq   #bytesToLcnt($40),d0

S3Credits_CopyPaletteAndSelectActors:
                move.l  (a1)+,(a2)+
                dbf     d0,S3Credits_CopyPaletteAndSelectActors
                clearRAM RAM_start+$2000,$2000
                bset    #0,(_unkFA88).w
                clr.l   (V_scroll_value).w
                lea     Child6_EndingS3Logo(pc),a1
                cmpi.w  #7,(Chaos_emerald_count).w
                beq.s   S3Credits_ReadActorCountAndBindSlots
                lea     S3CreditsText_TryAgain(pc),a1
                bsr.w   S3Credits_DrawPageAndQueueUpload
                lea     Child6_EndingTryAgain(pc),a1

S3Credits_ReadActorCountAndBindSlots:
                move.w  (a1)+,d0
                lea     (Dynamic_object_RAM+object_size).w,a2

S3Credits_InstallActorsAndFadeIn:
                move.l  (a1)+,(a2)
                lea     next_object(a2),a2
                dbf     d0,S3Credits_InstallActorsAndFadeIn
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                move.b  #VInt_ID_18,(V_int_routine).w
                jsr     (Wait_VSync).l
                jmp     (Pal_FadeFromBlack).l
; ---------------------------------------------------------------------------
Child6_EndingS3Logo:
                dc.w    3-1
                dc.l    S3Credits_InitFallingLogoAndHandle
                dc.l    S3Credits_InitLogoReadyCompanion
                dc.l    S3Credits_InitMirroredCompanion
Child6_EndingTryAgain:
                dc.w    2-1
                dc.l    S3Credits_InitMissingEmeraldThrower
                dc.l    S3Credits_InitTryAgainCompanion
; ---------------------------------------------------------------------------

S3Credits_FinishedCreditsReturn:
                rts
; ---------------------------------------------------------------------------

S3Credits_InitFallingLogoAndHandle:
                move.l  #S3Credits_TickLogoDropDelay,(a0)
                move.w  a0,(_unkFAA4).w
                move.l  #Map_EndingGraphics,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Sprites,2,1),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.b  #0,mapping_frame(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$40,y_pos(a0)
                move.w  #60,$2E(a0)
                rts
; ---------------------------------------------------------------------------

S3Credits_TickLogoDropDelay:
                subq.w  #1,$2E(a0)
                bmi.s   S3Credits_BeginLogoFall
                rts
; ---------------------------------------------------------------------------

S3Credits_BeginLogoFall:
                move.l  #S3Credits_MoveLogoAndCheckFloor,(a0)

S3Credits_MoveLogoAndCheckFloor:
                jsr     (MoveSprite).l
                cmpi.w  #$F0,y_pos(a0)
                bcs.s   S3Credits_DrawFallingLogo
                move.w  y_vel(a0),d0
                bmi.s   S3Credits_DrawFallingLogo
                asr.w   #1,d0
                cmpi.w  #$80,d0
                bcs.s   S3Credits_SettleLogoAndStartFlash
                neg.w   d0
                move.w  d0,y_vel(a0)

S3Credits_DrawFallingLogo:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Credits_SettleLogoAndStartFlash:
                move.l  #S3Credits_TickLogoFlashDelay,(a0)
                move.w  #$F0,y_pos(a0)
                clr.w   $2E(a0)

S3Credits_TickLogoFlashDelay:
                subq.w  #1,$2E(a0)
                bmi.s   S3Credits_AdvanceFlashOrSetReady
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Credits_AdvanceFlashOrSetReady:
                move.w  #1,$2E(a0)
                move.w  $3A(a0),d0
                cmpi.w  #6,d0
                bcc.s   S3Credits_MarkLogoReadyAndHold
                addq.w  #1,$3A(a0)
                lsl.w   #5,d0
                lea     Pal_EndingS3LogoFlash(pc),a1
                adda.w  d0,a1
                lea     (Normal_palette_line_3).w,a2
                moveq   #bytesToLcnt($20),d0

S3Credits_CopyLogoFlashPalette:
                move.l  (a1)+,(a2)+
                dbf     d0,S3Credits_CopyLogoFlashPalette
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Credits_MarkLogoReadyAndHold:
                move.l  #S3Credits_TickFinalLogoHold,(a0)
                move.w  #6*60,$2E(a0)
                bset    #5,$38(a0)

S3Credits_TickFinalLogoHold:
                subq.w  #1,$2E(a0)
                bmi.s   S3Credits_SelectSegaAfterLogoHold
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Credits_SelectSegaAfterLogoHold:
                move.b  #GameMode_SegaScreen,(Game_mode).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Credits_InitLogoReadyCompanion:
                move.l  #S3Credits_LatchLogoReadyAndDraw,(a0)
                move.l  #Map_EndingGraphics,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Sprites,3,1),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #1,mapping_frame(a0)
                move.w  #$100,x_pos(a0)
                move.w  #$11C,y_pos(a0)
                move.l  #S3CreditsPage_LogoCompanionWaitAnim,$30(a0)

S3Credits_LatchLogoReadyAndDraw:
                bsr.w   S3Ending_TryResumeLogoAnimation
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; When the main logo is ready, reset the side sprite's animation and store the caller's continuation as its handler
S3Ending_TryResumeLogoAnimation:
                movea.w (_unkFAA4).w,a1
                btst    #5,$38(a1)
                beq.s   S3Credits_LogoReadyLatchReturn
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                move.l  #S3CreditsPage_LogoCompanionReadyAnim,$30(a0)
                move.l  (sp),(a0)

S3Credits_LogoReadyLatchReturn:
                rts
; End of function S3Ending_TryResumeLogoAnimation

; ---------------------------------------------------------------------------

S3Credits_InitMirroredCompanion:
                move.l  #S3Credits_AnimateMirroredCompanion,(a0)
                move.l  #Map_EndingGraphics,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Sprites,3,1),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #1,mapping_frame(a0)
                bset    #0,render_flags(a0)
                move.w  #$140,x_pos(a0)
                move.w  #$11C,y_pos(a0)
                lea     S3CreditsPage_MirroredOffsetChildRecord(pc),a2
                jsr     (CreateChild1_Normal).l

S3Credits_AnimateMirroredCompanion:
                lea     S3CreditsPage_MirroredCompanionAnim(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Credits_InitMirroredOffsetChild:
                move.l  #S3Credits_AnimateMirroredOffsetChild,(a0)
                move.l  #Map_EndingGraphics,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Sprites,3,1),art_tile(a0)
                move.w  #$180,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #1,mapping_frame(a0)
                bset    #0,render_flags(a0)

S3Credits_AnimateMirroredOffsetChild:
                lea     S3CreditsPage_MirroredOffsetChildAnim(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Credits_InitMissingEmeraldThrower:
                move.l  #S3Credits_AnimateThrowerForward,(a0)
                move.l  #Map_EndingGraphics,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Sprites,2,1),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.b  #$C,mapping_frame(a0)
                move.w  #$12C,x_pos(a0)
                move.w  #$E8,y_pos(a0)
                move.l  #S3Credits_SetWaitAndTryEmeralds,$34(a0)

S3Credits_AnimateThrowerForward:
                lea     S3CreditsPage_EmeraldThrowerForwardAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Credits_SetWaitAndTryEmeralds:
                move.l  #S3Credits_WaitForLastEmerald,(a0)
                bra.w   S3Credits_PrepareSevenEmeraldChecks
; ---------------------------------------------------------------------------

; The saved handle is dereferenced without a zero check
S3Credits_WaitForLastEmerald:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.s   S3Credits_DrawWaitingThrower
                move.l  #S3Credits_AnimateThrowerReverse,(a0)
                move.l  #S3Credits_RearmForwardThrow,$34(a0)

S3Credits_DrawWaitingThrower:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Credits_AnimateThrowerReverse:
                lea     S3CreditsPage_EmeraldThrowerReverseAnim(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Credits_RearmForwardThrow:
                move.l  #S3Credits_AnimateThrowerForward,(a0)
                move.l  #S3Credits_SetWaitAndTryEmeralds,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Credits_InitEmeraldSubtypeDelay:
                move.l  #S3Credits_WaitThenSetEmeraldVelocity,(a0)
                move.l  #Map_AIZIntroEmeralds,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Emeralds,3,1),art_tile(a0)
                move.w  #$80,priority(a0)
                move.b  #4,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)

S3Credits_WaitThenSetEmeraldVelocity:
                subq.w  #1,$2E(a0)
                bpl.s   S3Credits_DrawWaitingEmerald
                move.l  #S3Credits_MoveEmeraldAndCheckParentY,(a0)
                move.w  #-$300,y_vel(a0)

S3Credits_DrawWaitingEmerald:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Credits_MoveEmeraldAndCheckParentY:
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.s   S3Credits_DrawEmeraldAfterDeleteMark
                movea.w $46(a0),a1
                move.w  y_pos(a1),d0
                subq.w  #4,d0
                cmp.w   y_pos(a0),d0
                bhi.s   S3Credits_DrawEmeraldAfterDeleteMark
                jsr     (Go_Delete_Sprite).l

S3Credits_DrawEmeraldAfterDeleteMark:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Credits_InitTryAgainCompanion:
                move.l  #S3Credits_AnimateTryAgainAndTickHold,(a0)
                move.l  #Map_EndingGraphics,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Sprites,2,1),art_tile(a0)
                move.w  #$180,priority(a0)
                move.b  #$14,width_pixels(a0)
                move.b  #$1C,height_pixels(a0)
                move.b  #$E,mapping_frame(a0)
                move.w  #$118,x_pos(a0)
                move.w  #$E0,y_pos(a0)
                move.w  #6*60,$2E(a0)

S3Credits_AnimateTryAgainAndTickHold:
                subq.w  #1,$2E(a0)
                bmi.s   S3Credits_SelectSegaAfterTryAgain
                lea     S3CreditsPage_TryAgainCompanionAnim(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Credits_SelectSegaAfterTryAgain:
                move.b  #GameMode_SegaScreen,(Game_mode).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Credits_PrepareSevenEmeraldChecks:
                lea     (Collected_emeralds_array).w,a2
                moveq   #0,d1
                moveq   #0,d2
                moveq   #7-1,d3

; Keep the last successfully allocated actor's handle for the thrower
S3Credits_TryMissingEmeraldActor:
                tst.b   (a2)+
                bne.s   S3Credits_AdvanceEmeraldFrameIndex
                jsr     (AllocateObject).l
                bne.s   S3Credits_AdvanceEmeraldFrameIndex
                move.l  #S3Credits_InitEmeraldSubtypeDelay,(a1)
                move.b  d1,mapping_frame(a1)
                move.b  d2,subtype(a1)
                move.w  x_pos(a0),d4
                addi.w  #$C,d4
                move.w  d4,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  a0,$46(a1)
                addq.b  #2,d2
                move.w  a1,$44(a0)

S3Credits_AdvanceEmeraldFrameIndex:
                addq.b  #1,d1
                dbf     d3,S3Credits_TryMissingEmeraldActor
                rts

; =============== S U B R O U T I N E =======================================

S3Credits_DrawPageAndQueueUpload:
                move.w  (a1)+,d6

S3Credits_DrawStringsAndUpload8K:
                bsr.w   S3Credits_DrawPositionedText
                dbf     d6,S3Credits_DrawStringsAndUpload8K
                bset    #0,(_unkFA88).w
                rts
; End of function S3Credits_DrawPageAndQueueUpload

; =============== S U B R O U T I N E =======================================

; Use 8-by-16 lowercase and variable-width 24-pixel-high uppercase glyphs. Wrap addresses within the 8 KB plane buffer
S3Credits_DrawPositionedText:
                lea     (RAM_start+$2000).l,a2
                move.w  (a1)+,d0
                adda.w  d0,a2

S3Credits_DecodeNextTextGlyph:
                moveq   #0,d0
                move.b  (a1)+,d0
                beq.w   S3Credits_AlignNextStringRecord
                move.w  d0,d1
                subi.b  #"a",d0
                bcs.s   S3Credits_MapLargeSpace
                lea     (S3Credits_PlaneMapSmall).l,a3
                lsl.w   #2,d0
                adda.w  d0,a3
                move.w  (a3)+,(a2)+
                move.l  a2,d2
                addi.w  #$7E,d2
                andi.l  #$FFFF3FFF,d2
                ori.l   #$2000,d2
                movea.l d2,a4
                move.w  (a3)+,(a4)
                bra.s   S3Credits_DecodeNextTextGlyph
; ---------------------------------------------------------------------------

S3Credits_MapLargeSpace:
                cmpi.b  #" ",d1
                bne.s   S3Credits_MapLargePeriod
                moveq   #$1D,d1
                bra.w   S3Credits_BindLargeGlyphWidth
; ---------------------------------------------------------------------------

S3Credits_MapLargePeriod:
                cmpi.b  #".",d1
                bne.s   S3Credits_MapLargeLeftParen
                moveq   #$1A,d1
                bra.w   S3Credits_BindLargeGlyphWidth
; ---------------------------------------------------------------------------

S3Credits_MapLargeLeftParen:
                cmpi.b  #"(",d1
                bne.s   S3Credits_MapLargeRightParen
                moveq   #$1B,d1
                bra.w   S3Credits_BindLargeGlyphWidth
; ---------------------------------------------------------------------------

S3Credits_MapLargeRightParen:
                cmpi.b  #")",d1
                bne.s   S3Credits_IndexLargeUppercaseGlyph
                moveq   #$1C,d1
                bra.w   S3Credits_BindLargeGlyphWidth
; ---------------------------------------------------------------------------

S3Credits_IndexLargeUppercaseGlyph:
                subi.b  #"A",d1

S3Credits_BindLargeGlyphWidth:
                add.w   d1,d1
                lea     (S3Credits_PlaneMapLarge).l,a3
                move.w  (a3,d1.w),d1
                lea     (a3,d1.w),a3
                move.w  (a3)+,d0
                movea.l a2,a4
                moveq   #2,d3

S3Credits_PrepareLargeGlyphRow:
                move.w  d0,d1
                movea.l a4,a5

S3Credits_CopyLargeGlyphRow:
                move.w  (a3)+,(a5)+
                dbf     d1,S3Credits_CopyLargeGlyphRow
                move.l  a4,d2
                addi.w  #$80,d2
                andi.l  #$FFFF3FFF,d2
                ori.l   #$2000,d2
                movea.l d2,a4
                dbf     d3,S3Credits_PrepareLargeGlyphRow
                addq.w  #1,d0
                add.w   d0,d0
                adda.w  d0,a2
                bra.w   S3Credits_DecodeNextTextGlyph
; ---------------------------------------------------------------------------

S3Credits_AlignNextStringRecord:
                move.l  a1,d0
                btst    #0,d0
                beq.s   S3Credits_PositionedStringReturn
                addq.l  #1,a1

S3Credits_PositionedStringReturn:
                rts
; End of function S3Credits_DrawPositionedText
