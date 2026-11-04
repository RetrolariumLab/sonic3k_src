; Owner: game/blue_sphere/sk
; Responsibility: Blue Sphere results mode, display setup, pattern-load resources and result text helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

BlueSpheresResults:
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                bsr.w   BlueSphere_ResetVideoAndSceneRAM
                lea     (Pal_SphereResults_012).l,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToWcnt($80),d0

BSResults_CopyPaletteAndLoadScene:
                move.w  (a1)+,(a2)+
                dbf     d0,BSResults_CopyPaletteAndLoadScene
                lea     (RAM_start).l,a1
                lea     (ArtKos_SSResultsGeneral).l,a0
                jsr     (Kos_Decomp).l
                lea     (ArtKos_SSResultsTKIcons).l,a0
                jsr     (Kos_Decomp).l
                move.w  a1,d3
                lsr.w   #1,d3
                move.l  #$FF0000,d1
                move.w  #tiles_to_bytes(ArtTile_BlueSphere_Emeralds),d2
                jsr     (Add_To_DMA_Queue).l
                lea     (RAM_start+$4000).l,a1
                lea     (ArtKos_BlueSphereNormalText).l,a0
                jsr     (Kos_Decomp).l
                move.l  #$FF4000,d1
                move.w  #tiles_to_bytes(ArtTile_BlueSphere_Misc),d2
                move.w  #$6D0,d3
                jsr     (Add_To_DMA_Queue).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_BlueSphere_TitleText),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_CreditsText).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_BlueSphere_BG),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_BlueSphereSKLogo).l,a0
                jsr     (Nem_Decomp).l
                lea     aCongratulation(pc),a1
                move.w  #$30A,d2
                move.w  #make_art_tile(ArtTile_BlueSphere_TitleText,0,1),d6
                jsr     (SKCredits_BuildAndUploadText).l
                lea     (Level_layout_header).w,a1
                lea     (MapEni_BlueSphereTitleBG).l,a0
                move.w  #make_art_tile(ArtTile_BlueSphere_BG,3,0),d0
                jsr     (Eni_Decomp).l
                bsr.w   BlueSphere_TileResultsLogoBg
                move.b  #1,(Blue_spheres_option).w
                move.l  #BSResults_InitExitAndPerfectController,(Player_1).w
                move.l  #BlueSphereResultsInitPlayerDisplayActor,(Player_2).w
                move.l  #BlueSphereNumberRow_Initialize,(Dynamic_object_RAM+(object_size*3)).w
                move.w  #$90,(Dynamic_object_RAM+(object_size*3)+y_pos).w
                move.l  #BSResults_InitSevenEmeraldOrbitActors,(Dynamic_object_RAM+(object_size*26)).w
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                moveq   #signextendB(mus_GotThroughAct),d0
                jsr     (Play_Music).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Pal_FadeFromWhite).l

BSResults_RunSceneAndChooseProgression:
                move.b  #VInt_ID_1A,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                jsr     (Wait_VSync).l
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                jsr     (Process_Kos_Module_Queue).l
                cmpi.b  #GameMode_BlueSpheresResults,(Game_mode).w
                beq.s   BSResults_RunSceneAndChooseProgression
                tst.w   (Special_stage_rings_left).w
                beq.s   BSResults_RebuildPerfectRevealScene
                tst.b   (Blue_spheres_progress_flag).w
                bmi.s   BSResults_NormalProgressionReturn
                tst.b   (Blue_spheres_mode).w
                beq.s   BSResults_NormalProgressionReturn
                addq.l  #1,(Blue_spheres_current_level).w
                lea     (Blue_spheres_current_stage).w,a2
                addi.l  #$01030507,(a2)
                andi.b  #$7F,(a2)
                cmpi.b  #$7F,1(a2)
                blo.s   BSResults_WrapThirdStageByte126
                subi.b  #$7F,1(a2)

BSResults_WrapThirdStageByte126:
                cmpi.b  #$7E,2(a2)
                blo.s   BSResults_WrapFourthStageByte125
                subi.b  #$7E,2(a2)

BSResults_WrapFourthStageByte125:
                cmpi.b  #$7D,3(a2)
                blo.s   BSResults_NormalProgressionReturn
                subi.b  #$7D,3(a2)

BSResults_NormalProgressionReturn:
                rts
; ---------------------------------------------------------------------------

BSResults_RebuildPerfectRevealScene:
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                jsr     (Pal_FadeToBlack).l
                bsr.w   BlueSphere_ResetVideoAndSceneRAM
                clearRAM _unkFA80,(DMA_queue-_unkFA80)
                lea     (Pal_SonicTails).l,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($20),d6

BSResults_CopySonicAndTailsPalette:
                move.l  (a1)+,(a2)+
                dbf     d6,BSResults_CopySonicAndTailsPalette
                lea     (Pal_Knuckles).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

BSResults_CopyKnucklesPalette:
                move.l  (a1)+,(a2)+
                dbf     d6,BSResults_CopyKnucklesPalette
                lea     (Pal_SphereResults_3).l,a1
                lea     (Target_palette_line_3).w,a2
                moveq   #bytesToLcnt($20),d6

BSResults_CopyResultsPalette:
                move.l  (a1)+,(a2)+
                dbf     d6,BSResults_CopyResultsPalette
                lea     (Pal_EndingSKLogo).l,a1
                lea     (Target_palette_line_4).w,a2
                moveq   #bytesToLcnt($20),d6

BSResults_CopyLogoPalette:
                move.l  (a1)+,(a2)+
                dbf     d6,BSResults_CopyLogoPalette
                move.l  #vdpComm(tiles_to_bytes($000),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_BlueSphereSKLogo).l,a0
                jsr     (Nem_Decomp).l
                lea     PLC_SphereResults(pc),a1
                jsr     (Load_PLC_Immediate).l
                lea     (RAM_start).l,a1
                lea     (ArtKosM_SKPoseBanner+2).l,a0
                jsr     (Kos_Decomp).l
                lea     (ArtKosM_ANDKnuckles+2).l,a0
                jsr     (Kos_Decomp).l
                lea     (ArtKosM_EndingMasterEmerald+2).l,a0
                jsr     (Kos_Decomp).l
                lea     (ArtKosM_RobotnikSmug+2).l,a0
                jsr     (Kos_Decomp).l
                lea     (ArtKosM_EggRoboHead+2).l,a0
                jsr     (Kos_Decomp).l
                move.w  a1,d3
                lsr.w   #1,d3
                move.l  #$FF0000,d1
                move.w  #tiles_to_bytes(ArtTile_BlueSphere_Difficulty),d2
                jsr     (Add_To_DMA_Queue).l
                lea     (Level_layout_header).w,a1
                lea     (MapEni_BlueSphereTitleBG).l,a0
                move.w  #make_art_tile($000,2,0),d0
                jsr     (Eni_Decomp).l
                bsr.w   BlueSphere_TileResultsLogoBg
                move.l  #BlueSphereNumberRow_Initialize,(Player_2).w
                move.w  #$C0,(Player_2+y_pos).w
                move.l  #BSResults_InitDifficultyProgressWidget,(Dynamic_object_RAM+(object_size*10)).w
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                clr.b   (Super_Sonic_Knux_flag).w
                clr.b   (Super_palette_status).w
                move.w  #1,(Player_mode).w
                moveq   #signextendB(mus_Invincibility),d0
                jsr     (Play_Music).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Pal_FadeFromBlack).l

BSResults_WaitForTargetAndNewPress:
                move.b  #VInt_ID_1A,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                jsr     (Wait_VSync).l
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                jsr     (Process_Kos_Module_Queue).l
                jsr     (SuperHyper_PalCycle).l
                move.b  (Blue_spheres_difficulty).w,d1
                cmp.b   (Blue_spheres_target_difficulty).w,d1
                bne.s   BSResults_WaitForTargetAndNewPress
                move.b  (Ctrl_1_pressed).w,d0
                beq.s   BSResults_WaitForTargetAndNewPress
                tst.b   (Blue_spheres_progress_flag).w
                bmi.s   BSResults_PerfectRevealReturn
                tst.b   (Blue_spheres_mode).w
                beq.s   BSResults_PerfectRevealReturn
                lea     (Blue_spheres_current_stage).w,a2
                moveq   #$A-1,d1

BSResults_AdvancePerfectProgressStep:
                addq.l  #1,(Blue_spheres_current_level).w
                addi.l  #$1030507,(a2)
                andi.b  #$7F,(a2)
                cmpi.b  #$7F,1(a2)
                blo.s   BSResults_PerfectWrapThirdStageByte
                subi.b  #$7F,1(a2)

BSResults_PerfectWrapThirdStageByte:
                cmpi.b  #$7E,2(a2)
                blo.s   BSResults_PerfectWrapFourthStageByte
                subi.b  #$7E,2(a2)

BSResults_PerfectWrapFourthStageByte:
                cmpi.b  #$7D,3(a2)
                blo.s   BSResults_RepeatTenPerfectSteps
                subi.b  #$7D,3(a2)

BSResults_RepeatTenPerfectSteps:
                dbf     d1,BSResults_AdvancePerfectProgressStep

BSResults_PerfectRevealReturn:
                rts
; ---------------------------------------------------------------------------
PLC_SphereResults:  plrlistheader
                plreq   ArtTile_BlueSphere_Difficulty+$EF, ArtNem_RobotnikShip
                plreq   ArtTile_BlueSphere_Difficulty+$141, ArtNem_Chicken
                plreq   ArtTile_BlueSphere_Difficulty+$14F, ArtNem_Squirrel
                plreq   ArtTile_BlueSphere_Difficulty+$161, ArtNem_Rabbit
                plreq   ArtTile_BlueSphere_Tails, ArtNem_BlueSphereTails
PLC_SphereResults_End:

Pal_SphereResults_012:
                binclude "data/General/Blue Sphere/Palettes/Results Line 0-2.bin"
                even
Pal_SphereResults_3:
                binclude "data/General/Blue Sphere/Palettes/Results Line 3.bin"
                even
aCongratulation:
                dc.b    "CONGRATULATIONS!",0
                even
aPerfect:
                dc.b    "PERFECT",0
                even

; =============== S U B R O U T I N E =======================================

; Stamp the 12-by-8 map at fourteen plane B destinations and set the initial 16-pixel scroll offset
BlueSphere_TileResultsLogoBg:
                lea     BSResults_LogoPlaneCommandHighWords(pc),a2
                moveq   #$E-1,d5

BSResults_UploadFourteenLogoBlocks:
                lea     (Level_layout_header).w,a1
                move.w  (a2)+,d0
                swap    d0
                move.w  #3,d0
                moveq   #12-1,d1
                moveq   #8-1,d2
                jsr     (Plane_Map_To_VRAM).l
                dbf     d5,BSResults_UploadFourteenLogoBlocks
                move.w  #$10,(V_scroll_value_BG).w
                lea     (H_scroll_buffer+2).w,a1
                move.w  #224-1,d1

BSResults_OffsetBGScrollLeft16:
                subi.w  #$10,(a1)
                addq.w  #4,a1
                dbf     d1,BSResults_OffsetBGScrollLeft16
                rts
; End of function BlueSphere_TileResultsLogoBg

; ---------------------------------------------------------------------------
BSResults_LogoPlaneCommandHighWords:
                dc.w    vdpComm(VRAM_Plane_B_Name_Table+$000,VRAM,WRITE)>>16
                dc.w    vdpComm(VRAM_Plane_B_Name_Table+$020,VRAM,WRITE)>>16
                dc.w    vdpComm(VRAM_Plane_B_Name_Table+$040,VRAM,WRITE)>>16
                dc.w    vdpComm(VRAM_Plane_B_Name_Table+$410,VRAM,WRITE)>>16
                dc.w    vdpComm(VRAM_Plane_B_Name_Table+$430,VRAM,WRITE)>>16
                dc.w    vdpComm(VRAM_Plane_B_Name_Table+$450,VRAM,WRITE)>>16
                dc.w    vdpComm(VRAM_Plane_B_Name_Table+$3F0,VRAM,WRITE)>>16
                dc.w    vdpComm(VRAM_Plane_B_Name_Table+$800,VRAM,WRITE)>>16
                dc.w    vdpComm(VRAM_Plane_B_Name_Table+$820,VRAM,WRITE)>>16
                dc.w    vdpComm(VRAM_Plane_B_Name_Table+$840,VRAM,WRITE)>>16
                dc.w    vdpComm(VRAM_Plane_B_Name_Table+$C10,VRAM,WRITE)>>16
                dc.w    vdpComm(VRAM_Plane_B_Name_Table+$C30,VRAM,WRITE)>>16
                dc.w    vdpComm(VRAM_Plane_B_Name_Table+$C50,VRAM,WRITE)>>16
                dc.w    vdpComm(VRAM_Plane_B_Name_Table+$BF0,VRAM,WRITE)>>16
