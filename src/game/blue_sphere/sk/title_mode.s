; Owner: game/blue_sphere/sk
; Responsibility: Blue Sphere title mode, display setup, serial and date text and title helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

BlueSpheresTitle:
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                jsr     (Pal_FadeToBlack).l
                bsr.w   BlueSphereResetSceneVideoQueuesAndRuntimeMemory
                bsr.w   BlueSphereClassifyLockonSerialAndInitializeLevelSelection
                lea     (Target_palette).w,a2
                bsr.w   BlueSphereCopyProgressSelectedFullPalette
                move.l  #vdpComm(tiles_to_bytes(ArtTile_BlueSphere_TitleText),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_CreditsText).l,a0
                jsr     (Nem_Decomp).l
                move.l  #vdpComm(tiles_to_bytes(ArtTile_BlueSphere_BG),VRAM,WRITE),(VDP_control_port).l
                lea     (ArtNem_BlueSphereSKLogo).l,a0
                jsr     (Nem_Decomp).l
                lea     (RAM_start).l,a1
                lea     (ArtKos_BlueSphereChar).l,a0
                jsr     (Kos_Decomp).l
                lea     (ArtKos_BlueSphereCharSprite).l,a0
                jsr     (Kos_Decomp).l
                move.w  a1,d3
                lsr.w   #1,d3
                move.l  #RAM_start&$FFFFFF,d1
                move.w  #0,d2
                jsr     (Add_To_DMA_Queue).l
                lea     (RAM_start+$4000).l,a1
                lea     (ArtKos_BlueSphereNormalText).l,a0
                jsr     (Kos_Decomp).l
                move.l  #(RAM_start+$4000)&$FFFFFF,d1
                move.w  #tiles_to_bytes(ArtTile_BlueSphere_Misc),d2
                move.w  #$6D0,d3
                jsr     (Add_To_DMA_Queue).l
                lea     (Level_layout_header).w,a1
                lea     (MapEni_BlueSphereTitleFG).l,a0
                move.w  #make_art_tile($000,1,0),d0
                jsr     (Eni_Decomp).l
                lea     (Level_layout_header).w,a1
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$380,VRAM,WRITE),d0
                moveq   #40-1,d1
                moveq   #16-1,d2
                jsr     (Plane_Map_To_VRAM).l
                lea     (Level_layout_header).w,a1
                lea     (MapEni_BlueSphereTitleBG).l,a0
                move.w  #make_art_tile(ArtTile_BlueSphere_BG,2,0),d0
                jsr     (Eni_Decomp).l
                lea     (Level_layout_header).w,a1
                move.l  #vdpComm(VRAM_Plane_B_Name_Table+$09C,VRAM,WRITE),d0
                moveq   #12-1,d1
                moveq   #8-1,d2
                jsr     (Plane_Map_To_VRAM).l
                lea     aGetBlueSpheres(pc),a1
                tst.b   (Blue_spheres_menu_flag).w
                bne.s   loc_4CA8C
                lea     aNoWayNoWayNoWa(pc),a1
                move.w  #1,(Player_option).w
                move.l  #$FFF0FFF8,(V_scroll_value).w

loc_4CA8C:
                move.w  #$100,d2
                move.w  #make_art_tile(ArtTile_BlueSphere_TitleText,0,0),d6
                jsr     (SKCreditsBuildAndUploadVariableWidthTwoRowText).l
                tst.b   (Blue_spheres_mode).w
                bne.s   loc_4CAA8
                move.l  #$FFF0FFF8,(V_scroll_value).w

loc_4CAA8:
                move.l  #Obj_SpheresTitle_4CEAA,(Player_1).w
                move.l  #Obj_SpheresTitle_4DA30,(Player_2).w
                move.l  #Obj_SpheresTitle_4D986,(Reserved_object_3).w
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                moveq   #signextendB(mus_Continue),d0
                jsr     (Play_Music).l
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l
                jsr     (Pal_FadeFromBlack).l

loc_4CAE8:
                move.b  #VInt_ID_1A,(V_int_routine).w
                jsr     (Process_Kos_Queue).l
                jsr     (Wait_VSync).l
                bsr.w   BlueSphereScrollFirstSixtyFourForegroundLinesLeftTwo
                jsr     (Process_Sprites).l
                jsr     (Render_Sprites).l
                jsr     (Process_Kos_Module_Queue).l
                cmpi.b  #GameMode_BlueSpheresTitle,(Game_mode).w
                beq.s   loc_4CAE8
                rts

; =============== S U B R O U T I N E =======================================

BlueSphereCopyProgressSelectedFullPalette:
                lea     (Pal_SpheresTitle_2).l,a1
                tst.b   (Blue_spheres_progress_flag).w
                bne.s   loc_4CB2C
                lea     (Pal_SpheresTitle_1).l,a1

loc_4CB2C:
                moveq   #bytesToWcnt($80),d0

loc_4CB2E:
                move.w  (a1)+,(a2)+
                dbf     d0,loc_4CB2E
                rts
; End of function BlueSphereCopyProgressSelectedFullPalette

; ---------------------------------------------------------------------------
Pal_SpheresTitle_1:
                binclude "data/General/Blue Sphere/Palettes/Title 1.bin"
                even
Pal_SpheresTitle_2:
                binclude "data/General/Blue Sphere/Palettes/Title 2.bin"
                even
aNoWayNoWayNoWa:
                dc.b    "NO WAY!    NO WAY!    NO WAY!    NO WAY?   ",0
                even
aGetBlueSpheres:
                dc.b    "GET   BLUE   SPHERES !                            ",0
                even

; =============== S U B R O U T I N E =======================================

BlueSphereScrollFirstSixtyFourForegroundLinesLeftTwo:
                lea     (H_scroll_buffer).w,a1
                moveq   #$40-1,d1

                .loop:
                subq.w  #2,(a1)
                addq.w  #4,a1
                dbf     d1,.loop
                rts
; End of function BlueSphereScrollFirstSixtyFourForegroundLinesLeftTwo

; =============== S U B R O U T I N E =======================================

BlueSphereClassifyLockonSerialAndInitializeLevelSelection:
                lea     (BlueSpheresSerialsText).l,a1
                moveq   #4-1,d1

loc_4CCAE:
                lea     (LockonSerialNumber).l,a0
                moveq   #0,d3
                moveq   #$D-1,d2

loc_4CCB8:
                move.b  (a1)+,d0
                cmp.b   (a0)+,d0
                beq.s   loc_4CCC0
                moveq   #1,d3

loc_4CCC0:
                dbf     d2,loc_4CCB8
                tst.b   d3
                beq.s   loc_4CCDC
                dbf     d1,loc_4CCAE
                move.b  #0,(Blue_spheres_mode).w
                move.b  #-1,(Blue_spheres_progress_flag).w
                bsr.s   BlueSphereDeriveTwentySevenBitLevelFromLockonHeader

locret_4CCDA:
                rts
; ---------------------------------------------------------------------------

loc_4CCDC:
                move.b  #1,(Blue_spheres_mode).w
                tst.b   (Blue_spheres_menu_flag).w
                bne.s   locret_4CCDA
                clr.b   (Blue_spheres_progress_flag).w
                move.l  #0,(Blue_spheres_current_level).w
                move.l  #$10203,(Blue_spheres_current_stage).w
                rts
; End of function BlueSphereClassifyLockonSerialAndInitializeLevelSelection

; ---------------------------------------------------------------------------
BlueSpheresSerialsText:
                dc.b    "GM 00001009-0"                 ; Sonic 1 REV00/1
                dc.b    "GM 00004049-0"
                even

; =============== S U B R O U T I N E =======================================

BlueSphereDeriveTwentySevenBitLevelFromLockonHeader:
                lea     (LockonSerialNumber).l,a1
                moveq   #$B-1,d1

loc_4CD20:
                move.b  (a1),d0
                subi.b  #'0',d0
                beq.s   loc_4CD2E
                cmpi.b  #10,d0
                blo.s   loc_4CD34

loc_4CD2E:
                addq.w  #1,a1
                dbf     d1,loc_4CD20

loc_4CD34:
                moveq   #0,d2

loc_4CD36:
                move.b  (a1)+,d0
                subi.b  #$30,d0
                cmpi.b  #$A,d0
                bhs.s   loc_4CD4C
                andi.b  #$F,d0
                mulu.w  #$A,d2
                add.w   d0,d2

loc_4CD4C:
                dbf     d1,loc_4CD36
                andi.w  #$7FFF,d2
                moveq   #0,d6
                move.w  d2,d6
                andi.w  #$3F,d6
                lea     (BlueSpheresMonthText).l,a2
                move.l  (LockonDate).l,d0
                moveq   #$E,d1

loc_4CD6A:
                cmp.l   (a2)+,d0
                dbeq    d1,loc_4CD6A
                subi.w  #$E,d1
                neg.w   d1
                andi.w  #$F,d1
                lsl.w   #4,d6
                or.b    d1,d6
                move.w  d2,d0
                lsr.w   #6,d0
                andi.w  #$F,d0
                lsl.w   #4,d6
                or.b    d0,d6
                move.b  (SSMagic_TestLoc_200150).l,d1
                andi.b  #1,d1
                lsl.l   #1,d6
                or.b    d1,d6
                lea     (SSMagic_TestLoc_20011A).l,a1
                moveq   #0,d0
                move.b  (a1)+,d0
                subi.b  #$30,d0
                mulu.w  #$A,d0
                move.b  (a1)+,d1
                subi.b  #$30,d1
                add.b   d1,d0
                subi.b  #$58,d0
                andi.b  #7,d0
                lsl.l   #3,d6
                or.b    d0,d6
                rol.w   #6,d2
                andi.w  #$1F,d2
                lsl.l   #5,d6
                or.b    d2,d6
                move.w  (SSMagic_TestLoc_2001A4).l,d0
                lsr.b   #3,d0
                andi.b  #3,d0
                lsl.l   #2,d6
                or.b    d0,d6
                moveq   #0,d1
                cmpi.w  #"EG",(SSMagic_TestLoc_200114).l
                beq.s   loc_4CDE6
                moveq   #1,d1

loc_4CDE6:
                lsl.l   #1,d6
                or.b    d1,d6
                move.b  (Blue_spheres_header_flag).w,d1
                andi.b  #1,d1
                lsl.l   #1,d6
                or.b    d1,d6
                andi.l  #$7FFFFFF,d6
                move.l  d6,(Blue_spheres_current_level).w
                lea     (Blue_spheres_current_stage).w,a2
                move.l  d6,d0
                andi.b  #$7F,d0
                move.b  d0,(a2)+
                move.l  d6,d0
                add.l   d0,d0
                add.l   d6,d0
                addq.l  #1,d0
                moveq   #0,d2
                swap    d0
                move.w  d0,d2
                swap    d0
                divu.w  #$7F,d2
                move.w  d0,d2
                divu.w  #$7F,d2
                swap    d2
                move.b  d2,(a2)+
                move.l  d6,d0
                add.l   d0,d0
                add.l   d0,d0
                add.l   d6,d0
                addq.l  #2,d0
                moveq   #0,d2
                swap    d0
                move.w  d0,d2
                swap    d0
                divu.w  #$7E,d2
                move.w  d0,d2
                divu.w  #$7E,d2
                swap    d2
                move.b  d2,(a2)+
                move.l  d6,d0
                add.l   d0,d0
                add.l   d6,d0
                add.l   d0,d0
                add.l   d6,d0
                addq.l  #3,d0
                moveq   #0,d2
                swap    d0
                move.w  d0,d2
                swap    d0
                divu.w  #$7D,d2
                move.w  d0,d2
                divu.w  #$7D,d2
                swap    d2
                move.b  d2,(a2)+
                rts
; End of function BlueSphereDeriveTwentySevenBitLevelFromLockonHeader

; ---------------------------------------------------------------------------
BlueSpheresMonthText:
                dc.b    ".JAN"
                dc.b    ".FEB"
                dc.b    ".MAR"
                dc.b    ".APR"
                dc.b    ".MAY"
                dc.b    ".JUN"
                dc.b    ".JUL"
                dc.b    ".AUG"
                dc.b    ".SEP"
                dc.b    ".OCT"
                dc.b    ".NOV"
                dc.b    ".DEC"
                dc.b    ".   "
                dc.b    "    "
                dc.b    "...."
