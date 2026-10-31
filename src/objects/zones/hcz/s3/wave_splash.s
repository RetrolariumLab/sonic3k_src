; Owner: objects/zones/hcz/s3
; Responsibility: Hydrocity wave splash state, sprite animation and mapping storage
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZWaveSplash:
                move.l  #Map_HCZWaveSplash,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZWaveSplash,0,1),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)
                addi.w  #$C0,(a2)+
                move.w  y_pos(a0),(a2)+
                move.l  #loc_1CEA4,(a0)

loc_1CEA4:
                move.w  (Camera_X_pos).w,d1
                andi.w  #$FFE0,d1
                addi.w  #$60,d1
                btst    #0,(Level_frame_counter+1).w
                beq.s   loc_1CEBC
                addi.w  #$20,d1

loc_1CEBC:
                move.w  d1,x_pos(a0)
                move.w  (Water_level).w,d1
                move.w  d1,y_pos(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)
                addi.w  #$C0,(a2)+
                move.w  y_pos(a0),(a2)+
                tst.b   $32(a0)
                bne.s   loc_1CEF6
                tst.b   (Ctrl_1_pressed_logical).w
                bmi.s   loc_1CEEA
                tst.b   (Ctrl_2_pressed_logical).w
                bpl.s   loc_1CF06

loc_1CEEA:
                addq.b  #3,mapping_frame(a0)
                move.b  #1,$32(a0)
                bra.s   loc_1CF24
; ---------------------------------------------------------------------------

loc_1CEF6:
                tst.w   (Game_paused).w
                bne.s   loc_1CF24
                move.b  #0,$32(a0)
                subq.b  #3,mapping_frame(a0)

loc_1CF06:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_1CF24
                move.b  #9,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #4,mapping_frame(a0)
                blo.s   loc_1CF24
                move.b  #1,mapping_frame(a0)

loc_1CF24:
                move.b  mapping_frame(a0),1(a2)
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------
Map_HCZWaveSplash:
                include "src/objects/shared/zones/hcz/mappings/wave_splash.s"
; End of function Obj_HCZWaveSplash
