; Owner: objects/interface/blue_sphere/sk
; Responsibility: Blue Sphere difficulty banner, Knuckles wordmark and animated Eggman portrait shared with ending presentation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Difficulty_SKLogo:
                move.l  #Map_SKPoseBanner,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Difficulty,3,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.l  #loc_5FB14,(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$A0,y_pos(a0)
                jsr     (AllocateObject).l
                bne.s   locret_5FB12
                move.l  #loc_5FB1A,(a1)
                move.w  a0,parent3(a1)

locret_5FB12:
                rts
; ---------------------------------------------------------------------------

loc_5FB14:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5FB1A:
                tst.b   (Graphics_flags).w
                bpl.w   loc_5EC36
                move.l  #Map_ANDKnuckles,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Difficulty+$48,3,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.b  #2,mapping_frame(a0)
                move.l  #Child_Draw_Sprite,(a0)
                lea     byte_5F520(pc),a1
                bra.w   loc_5FFD4
; ---------------------------------------------------------------------------

Obj_Difficulty_Eggman:
                move.l  #Map_EndingEyecatchEggman,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Difficulty+$B2,1,0),art_tile(a0)
                bset    #0,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #loc_5FB90,(a0)
                move.w  #$168,x_pos(a0)
                move.w  #$108,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_5FB90:
                lea     AniRaw_602C6(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
