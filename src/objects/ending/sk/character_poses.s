; Owner: objects/ending/sk
; Responsibility: Ending Sonic, Tails and Knuckles pose actors, attached display elements and private placement offsets
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

EndingSonicPose_Initialize:
                lea     EndingSonicPose_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                bclr    #2,render_flags(a0)
                move.l  #EndPose_AnimateSonicAndWaitForBanner,(a0)
                lea     EndingSonicPose_PlayerModeSignedOffsets(pc),a1
                bsr.w   EndingOffsetPoseByMaskedPlayerModePair
                lea     (Pal_SonicTails).l,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($20),d6

EndPose_CopySonicPaletteAndTryFlash:
                move.l  (a1)+,(a2)+
                dbf     d6,EndPose_CopySonicPaletteAndTryFlash
                jsr     (AllocateObject).l
                bne.s   EndingSonicPose_ReturnAfterPaletteSetup
                move.l  #EndSprite_InitFlashRaisePasses,(a1)
                move.w  #Normal_palette+2,$30(a1)
                move.w  #Target_palette+2,$32(a1)
                move.w  #$E,$3A(a1)

EndingSonicPose_ReturnAfterPaletteSetup:
                rts
; ---------------------------------------------------------------------------
EndingSonicPose_PlayerModeSignedOffsets:
                dc.b    0, $40
                dc.b    0, $40
                dc.b    -$1C, $2C
                dc.b    -$1C, $2C
                even
; ---------------------------------------------------------------------------

EndPose_AnimateSonicAndWaitForBanner:
                lea     EndData_SonicPoseSignalWaitAnim(pc),a1
                jsr     (Animate_RawNoSST).l
                btst    #2,(_unkFAB8).w
                beq.s   EndingSonicPose_DrawAfterSignalCheck
                move.l  #EndPose_AnimateFinalSonicAndDraw,(a0)
                lea     EndingSonicPose_FinalRawAnimation(pc),a1
                jsr     (Set_Raw_Animation).l

EndingSonicPose_DrawAfterSignalCheck:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndPose_AnimateFinalSonicAndDraw:
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndingTailsPose_InitializeAndCreateTail:
                lea     EndingTailsPose_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                bclr    #2,render_flags(a0)
                move.l  #EndingTailsPose_AnimateAndDraw,(a0)
                lea     EndingTailsPose_PlayerModeSignedOffsets(pc),a1
                bsr.w   EndingOffsetPoseByMaskedPlayerModePair
                lea     EndingTailsPoseTail_NormalChildRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------
EndingTailsPose_PlayerModeSignedOffsets:
                dc.b    $24, $2C
                dc.b    $24, $2C
                dc.b    8, $40
                dc.b    $24, $2C
                even
; ---------------------------------------------------------------------------

EndingTailsPose_AnimateAndDraw:
                lea     EndingTailsPose_RawAnimation(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndingTailsPoseTail_Initialize:
                lea     EndingTailsPoseTail_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bclr    #2,render_flags(a0)
                move.l  #EndingTailsPoseTail_AnimateAndDraw,(a0)

EndingTailsPoseTail_AnimateAndDraw:
                lea     EndingTailsPoseTail_RawAnimation(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndingKnucklesGroupPose_Initialize:
                lea     EndingKnucklesGroupPose_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                move.l  #EndPose_AnimateGroupLoadArtAndDraw,(a0)
                lea     EndPose_SignedPlayerModeOffsets(pc),a1
                bsr.w   EndingOffsetPoseByMaskedPlayerModePair
                lea     (Pal_EndingEyecatchKnuckles).l,a1
                lea     (Target_palette_line_3).w,a2
                moveq   #bytesToLcnt($20),d6

EndPose_CopyGroupPaletteAndTryFlash:
                move.l  (a1)+,(a2)+
                dbf     d6,EndPose_CopyGroupPaletteAndTryFlash
                jsr     (AllocateObject).l
                bne.s   EndPose_GroupPaletteSetupReturn
                move.l  #EndSprite_InitFlashRaisePasses,(a1)
                move.w  #Normal_palette_line_3+2,$30(a1)
                move.w  #Target_palette_line_3+2,$32(a1)
                move.w  #$E,$3A(a1)

EndPose_GroupPaletteSetupReturn:
                rts
; ---------------------------------------------------------------------------
EndPose_SignedPlayerModeOffsets:
                dc.b    -$1C, $2C
                dc.b    -$1C, $2C
                dc.b    $1C, $2C
                dc.b    0, $40
                even
; ---------------------------------------------------------------------------

EndPose_AnimateGroupLoadArtAndDraw:
                lea     (SKSceneAnim_HPZEncounterOpening).l,a1
                jsr     (Animate_Raw2NoSSTMultiDelay).l
                bsr.w   KnucklesEnding_Load_PLC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndingKnucklesSoloPose_Initialize:
                move.l  #EndPose_AnimateKnuxUntilCleanup,(a0)
                move.l  #Map_KnuxEndPose,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_KnuxEndPose,0,0),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$108,y_pos(a0)
                move.l  #EndingKnucklesSoloPose_RawAnimation,$30(a0)
                lea     (Pal_KnuxEndPose).l,a1
                lea     (Normal_palette).w,a2
                moveq   #bytesToLcnt($20),d6

EndPose_CopyKnuxPaletteAndTryCycle:
                move.l  (a1)+,(a2)+
                dbf     d6,EndPose_CopyKnuxPaletteAndTryCycle
                tst.b   (_unkFA88).w
                beq.s   EndPose_SoloPaletteSetupReturn
                bmi.s   EndPose_SoloPaletteSetupReturn
                jsr     (AllocateObject).l
                bne.s   EndPose_SoloPaletteSetupReturn
                move.l  #EndSuperKnuxPal_AdvanceCycle,(a1)

EndPose_SoloPaletteSetupReturn:
                rts
; ---------------------------------------------------------------------------

EndPose_AnimateKnuxUntilCleanup:
                btst    #3,(_unkFAB8).w
                bne.w   EndingBanner_DeleteAfterProgramHandoff
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndPose_InitOverlayIfGraphicsFlag:
                tst.b   (Graphics_flags).w
                bpl.w   EndingChild_DeleteCurrentActor
                lea     EndingBannerOptionalOverlay_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                move.l  #Child_Draw_Sprite,(a0)
                lea     EndPose_OptionalOverlayOffsets(pc),a1
                bra.w   EndSprite_OffsetOverlayBySubtype
; ---------------------------------------------------------------------------
EndPose_OptionalOverlayOffsets:
                dc.b    $48,   8
                dc.b    $34,-$10
                dc.b    $48,-$34
                even
; ---------------------------------------------------------------------------

EndingBannerFrameZeroOverlay_Initialize:
                lea     EndingBannerFrameZeroOverlay_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                move.l  #Child_Draw_Sprite,(a0)
                lea     EndPose_Frame0OverlayOffset(pc),a1
                bra.w   EndSprite_OffsetOverlayBySubtype
; ---------------------------------------------------------------------------
EndPose_Frame0OverlayOffset:
                dc.b    0, $14
                even
; ---------------------------------------------------------------------------

EndingBannerFrameOneOverlay_Initialize:
                lea     EndingBannerFrameOneOverlay_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                move.l  #Child_Draw_Sprite,(a0)
                lea     EndPose_Frame1OverlayOffset(pc),a1
                bra.w   EndSprite_OffsetOverlayBySubtype
; ---------------------------------------------------------------------------
EndPose_Frame1OverlayOffset:
                dc.b    0, $48
                even
