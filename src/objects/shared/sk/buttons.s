; Owner: objects/shared/sk
; Responsibility: Shared button collision, trigger state and zone or competition mapping variants
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_Button:
                tst.w   (Competition_mode).w
                bne.w   loc_2C696
                move.l  #Map_Button,mappings(a0)
                move.w  #make_art_tile(ArtTile_GrayButton,0,0),art_tile(a0)
                cmpi.b  #1,(Current_zone).w
                bne.s   loc_2C544
                move.l  #Map_HCZButton,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZButton,1,0),art_tile(a0)

loc_2C544:
                cmpi.b  #3,(Current_zone).w
                bne.s   loc_2C55A
                move.l  #Map_CNZButton,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$C9,2,0),art_tile(a0)

loc_2C55A:
                cmpi.b  #4,(Current_zone).w
                bne.s   loc_2C568
                move.w  #make_art_tile(ArtTile_FBZButton,0,0),art_tile(a0)

loc_2C568:
                cmpi.b  #9,(Current_zone).w
                bne.s   loc_2C58A
                move.l  #Map_LRZButton,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZMisc,3,0),art_tile(a0)
                tst.b   (Current_act).w
                beq.s   loc_2C58A
                move.w  #make_art_tile(ArtTile_LRZ2Misc+$1C,1,0),art_tile(a0)

loc_2C58A:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  #$200,priority(a0)
                addq.w  #4,y_pos(a0)
                btst    #5,subtype(a0)
                beq.s   loc_2C5B8
                move.l  #loc_2C62C,(a0)
                bra.w   loc_2C62C
; ---------------------------------------------------------------------------

loc_2C5B8:
                move.l  #loc_2C5BE,(a0)

loc_2C5BE:
                tst.b   render_flags(a0)
                bpl.s   loc_2C626
                move.w  #$1B,d1
                move.w  #4,d2
                move.w  #5,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.b  #0,mapping_frame(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                moveq   #0,d3
                btst    #6,subtype(a0)
                beq.s   loc_2C5FC
                moveq   #7,d3

loc_2C5FC:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_2C612
                btst    #4,subtype(a0)
                bne.s   loc_2C626
                bclr    d3,(a3)
                bra.s   loc_2C626
; ---------------------------------------------------------------------------

loc_2C612:
                tst.b   (a3)
                bne.s   loc_2C61E
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

loc_2C61E:
                bset    d3,(a3)
                move.b  #1,mapping_frame(a0)

loc_2C626:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2C62C:
                tst.b   render_flags(a0)
                bpl.s   loc_2C690
                move.w  #$10,d1
                move.w  #6,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                move.b  #0,mapping_frame(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                moveq   #0,d3
                btst    #6,subtype(a0)
                beq.s   loc_2C666
                moveq   #7,d3

loc_2C666:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_2C67C
                btst    #4,subtype(a0)
                bne.s   loc_2C690
                bclr    d3,(a3)
                bra.s   loc_2C690
; ---------------------------------------------------------------------------

loc_2C67C:
                tst.b   (a3)
                bne.s   loc_2C688
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

loc_2C688:
                bset    d3,(a3)
                move.b  #1,mapping_frame(a0)

loc_2C690:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2C696:
                move.l  #Map_2PButton,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PArt_1,0,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$C,width_pixels(a0)
                move.w  #$200,priority(a0)
                addq.w  #4,y_pos(a0)
                move.l  #loc_2C6C0,(a0)

loc_2C6C0:
                move.w  #$13,d1
                move.w  #4,d2
                move.w  #5,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.b  #0,mapping_frame(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                moveq   #0,d3
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_2C704
                btst    #4,subtype(a0)
                bne.s   loc_2C718
                bclr    d3,(a3)
                bra.s   loc_2C718
; ---------------------------------------------------------------------------

loc_2C704:
                tst.b   (a3)
                bne.s   loc_2C710
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

loc_2C710:
                bset    d3,(a3)
                move.b  #1,mapping_frame(a0)

loc_2C718:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_Button:
                include "src/objects/shared/buttons/mappings/button.s"
Map_LRZButton:
                include "src/objects/shared/zones/lrz/mappings/button.s"
; End of function Obj_Button
