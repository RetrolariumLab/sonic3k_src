; Owner: objects/ending/sk
; Responsibility: Ending logo and result banner actors, placement records and input-controlled return to title
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

EndBanner_InitSKPlacementAndPalette:
                lea     EndingSKBanner_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #EndBanner_DrawUntilHandoff,(a0)
                lea     EndingSKBanner_PlacementPairs(pc),a1
                bsr.w   EndingBanner_PlaceAndTryFlash
                lea     (Pal_EndingSKLogo).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

EndBanner_CopySKPaletteAndTryOverlay:
                move.l  (a1)+,(a2)+
                dbf     d6,EndBanner_CopySKPaletteAndTryOverlay
                jsr     (AllocateObject).l
                bne.s   EndingSKBanner_ReturnAfterInitialization
                move.l  #EndPose_InitOverlayIfGraphicsFlag,(a1)
                move.w  a0,parent3(a1)

EndingSKBanner_ReturnAfterInitialization:
                rts
; ---------------------------------------------------------------------------
EndingSKBanner_PlacementPairs:
                dc.w    $120,   $B0
                dc.w    $E0,   $B8
                dc.w    $120,   $F0
; ---------------------------------------------------------------------------

EndBanner_DrawUntilHandoff:
                btst    #3,(SceneSyncFlagsOrMHZState).w
                bne.s   EndingBanner_DeleteAfterProgramHandoff
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndingBanner_DeleteAfterProgramHandoff:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

EndBanner_InitS3KPlacementAndPalette:
                lea     EndingS3KBanner_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #EndBanner_DrawUntilHandoff,(a0)
                lea     EndingS3KBanner_PlacementPairs(pc),a1
                bsr.w   EndingBanner_PlaceAndTryFlash
                lea     (Pal_EndingS3KLogo).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

EndBanner_CopyS3KColorsAndTryOverlay:
                move.l  (a1)+,(a2)+
                dbf     d6,EndBanner_CopyS3KColorsAndTryOverlay
                jsr     (AllocateObject).l
                bne.s   EndingS3KBanner_AttemptOptionalOverlay
                move.l  #EndingBannerFrameZeroOverlay_Initialize,(a1)
                move.w  a0,parent3(a1)

EndingS3KBanner_AttemptOptionalOverlay:
                jsr     (AllocateObject).l
                bne.s   EndBanner_S3KOverlaySpawnReturn
                move.l  #EndPose_InitOverlayIfGraphicsFlag,(a1)
                move.w  a0,parent3(a1)
                move.b  #2,subtype(a1)

EndBanner_S3KOverlaySpawnReturn:
                rts
; ---------------------------------------------------------------------------
EndingS3KBanner_PlacementPairs:
                dc.w    $120,   $B0
                dc.w    $D0,   $B8
                dc.w    $120,   $F0
; ---------------------------------------------------------------------------

EndBanner_InitS3GraphicsProgram:
                lea     EndingS3GraphicsBanner_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #EndBanner_DrawUntilHandoff,(a0)
                tst.b   subtype(a0)
                beq.s   EndBanner_PrepareS3PlacementAndPalette
                move.l  #EndBanner_SignalExitAtTimer64,(a0)
                move.w  #$4AF,$2E(a0)
                bclr    #2,(SceneSyncFlagsOrMHZState).w

EndBanner_PrepareS3PlacementAndPalette:
                lea     EndingS3GraphicsBanner_PlacementPairs(pc),a1
                bsr.w   EndingBanner_PlaceAndTryFlash
                lea     (Pal_EndingS3KLogo).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

EndBanner_CopyS3ColorsAndTryOverlay:
                move.l  (a1)+,(a2)+
                dbf     d6,EndBanner_CopyS3ColorsAndTryOverlay
                jsr     (AllocateObject).l
                bne.s   EndBanner_TryLowerOverlay
                move.l  #EndPose_InitOverlayIfGraphicsFlag,(a1)
                move.w  a0,parent3(a1)
                move.b  #4,subtype(a1)

EndBanner_TryLowerOverlay:
                jsr     (AllocateObject).l
                bne.s   EndBanner_SpawnPoseChildren
                move.l  #EndingBannerFrameOneOverlay_Initialize,(a1)
                move.w  a0,parent3(a1)

EndBanner_SpawnPoseChildren:
                lea     EndData_ThreeCharacterPoseChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------
EndingS3GraphicsBanner_PlacementPairs:
                dc.w    $120,   $F0
                dc.w    $120,   $F0
; ---------------------------------------------------------------------------

EndBanner_SignalExitAtTimer64:
                cmpi.w  #$40,$2E(a0)
                bne.s   EndBanner_DrawUntilStartOrTimeout
                bset    #2,(SceneSyncFlagsOrMHZState).w

EndBanner_DrawUntilStartOrTimeout:
                btst    #button_start,(Ctrl_1_held).w
                bne.s   EndingResultProgram_SelectSegaScreen
                btst    #button_start,(Ctrl_2_held).w
                bne.s   EndingResultProgram_SelectSegaScreen
                subq.w  #1,$2E(a0)
                bmi.s   EndingResultProgram_SelectSegaScreen
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndingResultProgram_SelectSegaScreen:
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
