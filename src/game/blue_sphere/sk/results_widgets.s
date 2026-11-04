; Owner: game/blue_sphere/sk
; Responsibility: Blue Sphere results timing, perfect message, score elements and interface object states
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

BSResults_InitExitAndPerfectController:
                move.w  #5*60,$30(a0)
                move.l  #BSResults_WaitThenShowPerfect,(a0)

BSResults_WaitThenShowPerfect:
                subq.w  #1,$30(a0)
                bpl.s   BSResults_AllowNonPerfectEarlyExit
                tst.w   (Special_stage_rings_left).w
                bne.s   BlueSphereResults_InstallPostDelayState
                move    #$2700,sr
                lea     aPerfect(pc),a1
                move.w  #$49A,d2
                move.w  #make_art_tile(ArtTile_BlueSphere_TitleText,0,1),d6
                jsr     (SKCredits_BuildAndUploadText).l
                move    #$2300,sr
                moveq   #signextendB(sfx_Continue),d0
                jsr     (Play_SFX).l
                move.w  #5*60,$30(a0)

BlueSphereResults_InstallPostDelayState:
                move.l  #BSResults_TickExitDelayAndFlashScroll,(a0)

BSResults_AllowNonPerfectEarlyExit:
                tst.w   (Special_stage_rings_left).w
                beq.s   BSResults_InitialControllerReturn
                move.b  (Ctrl_1_pressed).w,d0
                beq.s   BSResults_InitialControllerReturn
                move.b  #GameMode_BlueSpheresTitle,(Game_mode).w

BSResults_InitialControllerReturn:
                rts
; ---------------------------------------------------------------------------

BSResults_TickExitDelayAndFlashScroll:
                tst.w   (Special_stage_rings_left).w
                bne.s   BSResults_CheckButtonAfterDelay
                subq.w  #1,$30(a0)
                bmi.s   BlueSphereResults_ReturnToTitleMode

BSResults_CheckButtonAfterDelay:
                move.b  (Ctrl_1_pressed).w,d0
                beq.s   BlueSphereResults_TestScrollFlashCadence

BlueSphereResults_ReturnToTitleMode:
                move.b  #GameMode_BlueSpheresTitle,(Game_mode).w

BlueSphereResults_TestScrollFlashCadence:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                bne.s   BSResults_PostDelayControllerReturn
                lea     (H_scroll_buffer+$120).w,a1
                moveq   #$10-1,d1

BlueSphereResults_ToggleScrollBit8Loop:
                eori.w  #$100,(a1)
                addq.w  #4,a1
                dbf     d1,BlueSphereResults_ToggleScrollBit8Loop

BSResults_PostDelayControllerReturn:
                rts
; ---------------------------------------------------------------------------

BlueSphereResultsInitPlayerDisplayActor:
                move.l  #Map_Sonic,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_1,0,1),art_tile(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$100,y_pos(a0)
                move.w  #$80,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #$13,anim(a0)
                cmpi.w  #1,(Player_mode).w
                beq.s   BSResults_InstallSonicDisplayUpdate
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$24,anim(a0)
                lea     (Pal_Knuckles).l,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($20),d6

BSResults_CopyKnucklesTargetPalette:
                move.l  (a1)+,(a2)+
                dbf     d6,BSResults_CopyKnucklesTargetPalette
                move.l  #BlueSphereResults_UpdateKnucklesDisplay,(a0)
                bra.s   BlueSphereResults_UpdateKnucklesDisplay
; ---------------------------------------------------------------------------

BSResults_InstallSonicDisplayUpdate:
                move.l  #BlueSphereResults_UpdateSonicDisplay,(a0)

BlueSphereResults_UpdateSonicDisplay:
                jsr     (Animate_Sonic).l
                jsr     (Sonic_Load_PLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

BlueSphereResults_UpdateKnucklesDisplay:
                jsr     (Animate_Knuckles).l
                jsr     (Knuckles_Load_PLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

BSResults_InitSevenEmeraldOrbitActors:
                movea.l a0,a1
                moveq   #0,d0
                moveq   #0,d2
                moveq   #7-1,d1

BSResults_SeedEmeraldOrbitActor:
                move.l  #BSResults_UpdateEmeraldOrbitPosition,(a1)
                move.l  #Map_BSResultsEmerald,mappings(a1)
                move.w  #make_art_tile(ArtTile_BlueSphere_Emeralds,0,0),art_tile(a1)
                move.w  #$80,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.b  d0,angle(a1)
                addi.b  #$24,d0
                move.b  d2,mapping_frame(a1)
                addq.b  #1,d2
                lea     next_object(a1),a1
                dbf     d1,BSResults_SeedEmeraldOrbitActor
                move.l  #BSResults_UpdateEmeraldPulseLeader,(a0)

BSResults_UpdateEmeraldPulseLeader:
                move.b  $27(a0),d0
                jsr     (GetSineCosine).l
                asl.w   #4,d0
                addi.w  #$4000,d0
                move.w  d0,(Stat_table).w
                addq.b  #1,$27(a0)

BSResults_UpdateEmeraldOrbitPosition:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                move.w  (Stat_table).w,d2
                muls.w  d2,d1
                muls.w  d2,d0
                swap    d1
                swap    d0
                addi.w  #$120,d1
                addi.w  #$100,d0
                move.w  d1,x_pos(a0)
                move.w  d0,y_pos(a0)
                addq.b  #1,angle(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

BSResults_InitDifficultyProgressWidget:
                move.l  #Map_BlueSpheresText,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc,0,1),art_tile(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$140,y_pos(a0)
                move.w  #$80,priority(a0)
                move.b  #$28,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #4,mapping_frame(a0)
                move.w  y_pos(a0),d3
                addi.w  #$10,d3
                movea.l a0,a1
                move.b  #$A,next_object+mapping_frame(a1)
                move.w  #$114,d2
                moveq   #4-1,d1

BSResults_SeedDifficultyNumberChildren:
                lea     next_object(a1),a1
                move.l  #BSDifficulty_InitResultsNumberSprite,(a1)
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                addq.w  #8,d2
                dbf     d1,BSResults_SeedDifficultyNumberChildren
                move.b  #$B,mapping_frame(a1)
                move.w  #$1D,$30(a0)
                move.l  #BSResults_UpdateDifficultyProgress,(a0)

BSResults_UpdateDifficultyProgress:
                moveq   #0,d1
                move.b  (Blue_spheres_difficulty).w,d1
                addq.b  #1,d1
                bsr.w   BlueSphere_CenterDifficultyDigits
                subq.w  #1,$30(a0)
                bpl.s   BSResults_SelectDifficultyCaption
                move.w  #$1D,$30(a0)
                move.b  (Blue_spheres_difficulty).w,d1
                cmp.b   (Blue_spheres_target_difficulty).w,d1
                beq.s   BSResults_SelectDifficultyCaption
                addq.b  #1,(Blue_spheres_difficulty).w
                bsr.s   Difficulty_Level_Sprites_Display
                moveq   #signextendB(sfx_LaunchReady),d0
                jsr     (Play_SFX).l

BSResults_SelectDifficultyCaption:
                move.b  #4,mapping_frame(a0)
                cmpi.b  #12,(Blue_spheres_difficulty).w
                bne.s   BlueSphereResults_DrawDifficultyCaption
                move.b  #5,mapping_frame(a0)

BlueSphereResults_DrawDifficultyCaption:
                jmp     (Draw_Sprite).l
