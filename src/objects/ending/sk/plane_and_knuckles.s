; Owner: objects/ending/sk
; Responsibility: Ending plane and Knuckles pose actors, motion and private state dispatch tables
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

EndKnux_InitPlaneEntrance:
                move.l  #Map_SonicPlaneEnding,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_PlaneExtra,0,0),art_tile(a0)
                move.w  #$380,priority(a0)
                move.b  #1,mapping_frame(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.l  #EndKnux_TryAccentPaletteActor,(a0)
                bset    #0,render_flags(a0)
                move.w  #$220,x_pos(a0)
                move.w  #$B0,y_pos(a0)
                move.w  #-$100,x_vel(a0)
                bsr.w   EndingInitializeGentleVerticalSwing
                moveq   #signextendB(mus_CreditsK),d0
                jsr     (Play_Music).l
                lea     EndData_PlanePoseDetailChildRecord(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     EndingPlaneBlinkDetail_ChildRecord(pc),a2
                jsr     (CreateChild1_Normal).l
                bclr    #0,(SceneSyncFlagsOrMHZState).w
                jsr     (AllocateObject).l
                bne.s   EndKnux_QueuePlaneEntranceArt
                move.l  #EndingMasterEmerald_DispatchStateAndDraw,(a1)
                move.w  a0,parent3(a1)
                move.w  #$190,x_pos(a1)
                move.w  #$DC,y_pos(a1)
                st      subtype(a1)

EndKnux_QueuePlaneEntranceArt:
                lea     (ArtKosM_SonicPlaneEnding).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_PlaneExtra),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

EndKnux_TryAccentPaletteActor:
                cmpi.w  #$EEE,(Normal_palette+$2).w
                bne.s   EndKnux_FlyPlaneLeftThenSwitchActor
                bset    #7,$38(a0)
                bne.s   EndKnux_FlyPlaneLeftThenSwitchActor
                st      (EmeraldPresentationEnableAndPaletteRoute).w
                jsr     (AllocateObject).l
                bne.s   EndKnux_FlyPlaneLeftThenSwitchActor
                move.l  #EndEmerald_CycleAllSuperAccent,(a1)

EndKnux_FlyPlaneLeftThenSwitchActor:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                cmpi.w  #$60,x_pos(a0)
                bhs.s   EndingKnucklesSequence_DrawCurrentActor
                move.l  #EndKnux_DispatchStateAndArt,(a0)
                bset    #4,$38(a0)
                clr.b   5(a0)

EndingKnucklesSequence_DrawCurrentActor:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

EndKnux_DispatchStateAndArt:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  EndKnux_CharacterStateOffsets(pc,d0.w),d1
                jsr     EndKnux_CharacterStateOffsets(pc,d1.w)
                jsr     (SKScene_LoadKnuxArtToSceneTiles).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
EndKnux_CharacterStateOffsets:
                dc.w    EndKnux_InitWalkingCharacter-EndKnux_CharacterStateOffsets
                dc.w    EndKnux_WalkToPoseThreshold-EndKnux_CharacterStateOffsets
                dc.w    EndKnux_WaitThenSignalScene-EndKnux_CharacterStateOffsets
                dc.w    EndKnux_HoldFinalPose-EndKnux_CharacterStateOffsets
; ---------------------------------------------------------------------------

EndKnux_InitWalkingCharacter:
                move.b  #2,routine(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.w  #make_art_tile(ArtTile_CutsceneKnux,0,1),art_tile(a0)
                move.w  #$180,priority(a0)
                move.b  #7,mapping_frame(a0)
                move.w  #$1E0,x_pos(a0)
                move.w  #$E0,y_pos(a0)
                move.w  #-$200,x_vel(a0)
                clr.w   y_vel(a0)
                lea     (Pal_ContinueScreen+$60).l,a1
                lea     (Normal_palette).w,a2
                moveq   #bytesToLcnt($20),d6

EndKnux_CopyCharacterPalette:
                move.l  (a1)+,(a2)+
                dbf     d6,EndKnux_CopyCharacterPalette
                rts
; ---------------------------------------------------------------------------

EndKnux_WalkToPoseThreshold:
                lea     (SKSceneAnim_KnuxTravelLoopDelay4).l,a1
                jsr     (Animate_RawNoSSTCheckResult).l
                jsr     (MoveSprite2).l
                cmpi.w  #$120,x_pos(a0)
                bhs.s   EndKnux_WalkUpdateReturn
                move.b  #4,routine(a0)
                move.b  #$55,mapping_frame(a0)
                move.w  #(2*60)-1,$2E(a0)

EndKnux_WalkUpdateReturn:
                rts
; ---------------------------------------------------------------------------

EndKnux_WaitThenSignalScene:
                subq.w  #1,$2E(a0)
                bpl.w   EndingScene_SharedReturn
                move.b  #6,routine(a0)
                st      (Events_fg_4).w
                clr.b   (EmeraldPresentationEnableAndPaletteRoute).w
                rts
; ---------------------------------------------------------------------------

EndKnux_HoldFinalPose:
                rts
