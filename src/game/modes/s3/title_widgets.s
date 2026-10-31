; Owner: game/modes/s3
; Responsibility: Sonic 3 title frame declarations, banner, text and player widgets plus the preserved level-select input sequence
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
TitleSonic_Frames:
                dc.l    ArtKos_S3TitleSonic1
                dc.l    Pal_TitleSonic1
                dc.l    MapEni_S3TitleSonic1
                dc.l    ArtKos_S3TitleSonic1
                dc.l    Pal_TitleSonic2
                dc.l    MapEni_S3TitleSonic2
                dc.l    ArtKos_S3TitleSonic1
                dc.l    Pal_TitleSonic3
                dc.l    MapEni_S3TitleSonic3
                dc.l    ArtKos_S3TitleSonic1
                dc.l    Pal_TitleSonic4
                dc.l    MapEni_S3TitleSonic4
                dc.l    ArtKos_S3TitleSonic1
                dc.l    Pal_TitleSonic5
                dc.l    MapEni_S3TitleSonic5
                dc.l    ArtKos_S3TitleSonic1
                dc.l    Pal_TitleSonic6
                dc.l    MapEni_S3TitleSonic6
                dc.l    ArtKos_S3TitleSonic1
                dc.l    Pal_TitleSonic7
                dc.l    MapEni_S3TitleSonic7
                dc.l    ArtKos_S3TitleSonic8
                dc.l    Pal_TitleSonic8
                dc.l    MapEni_S3TitleSonic8
                dc.l    ArtKos_S3TitleSonic9
                dc.l    Pal_TitleSonic9
                dc.l    MapEni_S3TitleSonic9
                dc.l    ArtKos_S3TitleSonicA
                dc.l    Pal_TitleSonicA
                dc.l    MapEni_S3TitleSonicA
                dc.l    ArtKos_S3TitleSonicB
                dc.l    Pal_TitleSonicB
                dc.l    MapEni_S3TitleSonicB
                dc.l    ArtKos_S3TitleSonicC
                dc.l    Pal_TitleSonicC
                dc.l    MapEni_S3TitleSonicC
                dc.l    ArtKos_S3TitleSonicD
                dc.l    Pal_TitleSonicD
                dc.l    MapEni_S3TitleSonicD
Pal_Title:
                binclude "data/General/Title/Palettes/S3.bin"
                even
Pal_TitleSonic1:
                binclude "data/General/Title/Palettes/S3 Sonic 1.bin"
                even
Pal_TitleSonic2:
                binclude "data/General/Title/Palettes/S3 Sonic 2.bin"
                even
Pal_TitleSonic3:
                binclude "data/General/Title/Palettes/S3 Sonic 3.bin"
                even
Pal_TitleSonic4:
                binclude "data/General/Title/Palettes/S3 Sonic 4.bin"
                even
Pal_TitleSonic5:
                binclude "data/General/Title/Palettes/S3 Sonic 5.bin"
                even
Pal_TitleSonic6:
                binclude "data/General/Title/Palettes/S3 Sonic 6.bin"
                even
Pal_TitleSonic7:
                binclude "data/General/Title/Palettes/S3 Sonic 7.bin"
                even
Pal_TitleSonic8:
                binclude "data/General/Title/Palettes/S3 Sonic 8.bin"
                even
Pal_TitleSonic9:
                binclude "data/General/Title/Palettes/S3 Sonic 9.bin"
                even
Pal_TitleSonicA:
                binclude "data/General/Title/Palettes/S3 Sonic A.bin"
                even
Pal_TitleSonicB:
                binclude "data/General/Title/Palettes/S3 Sonic B.bin"
                even
Pal_TitleSonicC:
                binclude "data/General/Title/Palettes/S3 Sonic C.bin"
                even
Pal_TitleSonicD:
                binclude "data/General/Title/Palettes/S3 Sonic D.bin"
                even
; ---------------------------------------------------------------------------

Obj_TitleBanner:
                move.l  #Map_S3TitleBanner,mappings(a0)
                move.w  #make_art_tile(ArtTile_Title_Banner,3,1),art_tile(a0)  ; Origin at $A000
                move.w  #$80,priority(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$F0,y_pos(a0)
                move.w  #$400,y_vel(a0)
                move.l  #$FFA00000,$30(a0)
                move.l  #Obj_TitleBanner_Main,(a0)

Obj_TitleBanner_Main:
                move.b  $34(a0),d2
                move.w  y_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,$30(a0)
                move.w  $30(a0),d0
                move.b  #0,$34(a0)
                move.w  #$40,d1
                cmpi.w  #0,d0
                blt.s   loc_3F90
                bne.s   loc_3F86
                cmpi.w  #-$5B,y_vel(a0)
                bne.s   loc_3F86
                move.l  #Obj_TitleBanner_Display,(a0)
                move.l  #Obj_TitleTM,(Reserved_object_3).w
                bra.s   loc_3F9E
; ---------------------------------------------------------------------------

loc_3F86:
                move.b  #-1,$34(a0)
                move.w  #-$40,d1

loc_3F90:
                add.w   d1,y_vel(a0)
                cmp.b   $34(a0),d2
                beq.s   loc_3F9E
                asr     y_vel(a0)

loc_3F9E:
                move.w  $30(a0),d0
                neg.w   d0
                addi.w  #$F0,d0
                move.w  d0,y_pos(a0)

Obj_TitleBanner_Display:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_3FC2
                move.b  #9,anim_frame_timer(a0)
                addq.b  #4,anim_frame(a0)
                andi.b  #$1C,anim_frame(a0)

loc_3FC2:
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                move.l  Pal_TitleWaterRot(pc,d0.w),(Target_palette_line_3+$1A).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Pal_TitleWaterRot:
                binclude "data/General/Title/Palettes/S3 Water Anim.bin"
                even
; ---------------------------------------------------------------------------

Obj_TitleTM:
                move.l  #Map_S3TitleBanner,mappings(a0)
                move.w  #make_art_tile(ArtTile_Title_Banner,3,1),art_tile(a0)  ; Start at $A000
                move.w  #$188,x_pos(a0)
                move.w  #$108,y_pos(a0)
                move.w  #$80,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.b  #1,mapping_frame(a0)
                move.l  #Obj_TitleTM_Display,(a0)

Obj_TitleTM_Display:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Dead code
OldDebugCode:
                lea     (OldDebugCodeDat).l,a1
                move.w  (Debug_mode_cheat_counter).w,d0
                adda.w  d0,a1
                move.b  (Ctrl_1_pressed_title).w,d0
                andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   locret_406C
                move.b  (Ctrl_1_held_title).w,d0
                cmp.b   (a1),d0
                bne.s   loc_4066
                addq.w  #1,(Debug_mode_cheat_counter).w
                tst.b   1(a1)
                bne.s   locret_406C
                move.w  #(1<<8)|1,(Debug_cheat_flag).w
                moveq   #signextendB(sfx_RingLoss),d0
                bsr.w   Play_SFX

loc_4066:
                move.w  #0,(Debug_mode_cheat_counter).w

locret_406C:
                rts
; ---------------------------------------------------------------------------
OldDebugCodeDat:
                dc.b    button_C_mask
                dc.b    button_C_mask|button_B_mask
                dc.b    button_C_mask|button_B_mask|button_A_mask
                dc.b    button_B_mask
                dc.b    button_B_mask|button_A_mask
                dc.b    button_B_mask|button_A_mask|button_C_mask
                dc.b    button_A_mask
                dc.b    button_A_mask|button_C_mask
                dc.b    button_A_mask|button_C_mask|button_B_mask
                dc.b    button_A_mask|button_C_mask|button_B_mask|button_up_mask
                dc.b    button_A_mask|button_C_mask|button_B_mask|button_down_mask
                dc.b    0
                even
; ---------------------------------------------------------------------------

Obj_TitleCopyright:
                move.l  #Map_TitleScreenText,mappings(a0)
                move.w  #make_art_tile(ArtTile_Title_Menu,3,1),art_tile(a0)  ; Start at $D000 VRAM
                move.w  #$158,x_pos(a0)
                move.w  #$14C,y_pos(a0)
                move.w  #$80,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.b  #3,mapping_frame(a0)
                move.l  #Obj_TitleCopyright_Display,(a0)

Obj_TitleCopyright_Display:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_TitleSelection:
                move.w  #$F0,x_pos(a0)
                move.w  #$140,y_pos(a0)
                move.l  #Map_TitleScreenText,mappings(a0)
                move.w  #make_art_tile(ArtTile_Title_Menu,2,1),art_tile(a0)  ; Start at $D000 VRAM
                andi.b  #1,(Title_screen_option).w
                move.b  (Title_screen_option).w,mapping_frame(a0)
                move.l  #Obj_TitleSelection_Main,(a0)

Obj_TitleSelection_Main:
                moveq   #0,d2
                move.b  (Title_screen_option).w,d2
                move.b  (Ctrl_1_pressed).w,d0
                or.b    (Ctrl_2_pressed).w,d0
                btst    #button_up,d0
                beq.s   loc_410A
                subq.b  #1,d2
                bcc.s   loc_410A
                move.b  #2,d2
                tst.b   (Level_select_flag).w           ; If level select is on, maximum choices are 3
                bne.s   loc_410A
                move.b  #1,d2

loc_410A:
                btst    #button_down,d0
                beq.s   loc_4124
                addq.b  #1,d2
                tst.b   (Level_select_flag).w           ; See above
                bne.s   loc_411C
                andi.b  #1,d2

loc_411C:
                cmpi.b  #3,d2
                blo.s   loc_4124
                moveq   #0,d2

loc_4124:
                move.b  d2,mapping_frame(a0)
                move.b  d2,(Title_screen_option).w
                andi.b  #3,d0
                beq.s   loc_413A
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l                    ; Only play sound if selection was changed

loc_413A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_TitleSonicFinger:
                move.l  #Map_TitleSonicAnim,mappings(a0)
                move.w  #make_art_tile(ArtTile_Title_Misc,1,1),art_tile(a0)  ; Start at $8000 VRAM
                move.w  #$148,x_pos(a0)
                move.w  #$DC,y_pos(a0)
                move.w  #$180,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$1C,height_pixels(a0)
                move.l  #Obj_TitleSonicFinger_Display,(a0)

Obj_TitleSonicFinger_Display:
                lea     (Ani_TitleSonicFinger).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_TitleSonicFinger:
                include "src/ui/shared/title/animations/s3_sonic_finger.s"
; ---------------------------------------------------------------------------

Obj_TitleSonicWink:
                move.l  #Map_TitleSonicAnim,mappings(a0)
                move.w  #make_art_tile(ArtTile_Title_Misc,1,1),art_tile(a0)  ; Start at $8000 VRAM
                move.w  #$F8,x_pos(a0)
                move.w  #$C8,y_pos(a0)
                move.w  #$180,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.l  #Obj_TitleSonicWink_Display,(a0)

Obj_TitleSonicWink_Display:
                lea     (Ani_TitleSonicWink).l,a1
                jsr     (Animate_SpriteIrregularDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_TitleSonicWink:
                include "src/ui/shared/title/animations/s3_sonic_wink.s"
; ---------------------------------------------------------------------------

Obj_TitleTailsPlane:
                move.l  #Map_TitleTailsPlane,mappings(a0)
                move.w  #make_art_tile(ArtTile_Title_Misc,3,0),art_tile(a0)  ; Start at $8000 VRAM
                move.w  #0,x_pos(a0)
                move.w  #$C0,y_pos(a0)
                move.w  #$380,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.l  #Obj_TitleTailsPlane_Main,(a0)

Obj_TitleTailsPlane_Main:
                tst.b   $30(a0)
                bne.s   loc_424E
                addq.w  #1,x_pos(a0)
                cmpi.w  #$240,x_pos(a0)
                bne.s   loc_424C
                move.b  #1,$30(a0)
                bset    #0,status(a0)
                move.w  #$D0,y_pos(a0)

loc_424C:
                bra.s   loc_426C
; ---------------------------------------------------------------------------

loc_424E:
                subq.w  #1,x_pos(a0)
                cmpi.w  #0,x_pos(a0)
                bne.s   loc_426C
                move.b  #0,$30(a0)
                bclr    #0,status(a0)
                move.w  #$C0,y_pos(a0)

loc_426C:
                lea     (Ani_TitleTailsPlane).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_TitleTailsPlane:
                include "src/ui/shared/title/animations/s3_tails_plane.s"

; =============== S U B R O U T I N E =======================================

S3_Level_Select_Code:
                lea     (LSelect3CodeDat).l,a1
                move.w  (Level_select_cheat_counter).w,d0
                adda.w  d0,a1
                move.b  (Ctrl_1_pressed_title).w,d0
                andi.b  #button_up_mask|button_down_mask|button_left_mask|button_right_mask|button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   locret_42C8
                move.b  (Ctrl_1_held_title).w,d0
                cmp.b   (a1),d0
                bne.s   loc_42C2
                addq.w  #1,(Level_select_cheat_counter).w
                tst.b   1(a1)
                bne.s   locret_42C8
                move.w  #(1<<8)|1,(Level_select_flag).w
                move.w  #(1<<8)|1,(Debug_cheat_flag).w
                moveq   #signextendB(sfx_RingRight),d0
                bsr.w   Play_SFX

loc_42C2:
                move.w  #0,(Level_select_cheat_counter).w

locret_42C8:
                rts
; End of function S3_Level_Select_Code
