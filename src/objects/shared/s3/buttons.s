; Owner: objects/shared/s3
; Responsibility: Shared button collision, trigger state and zone or competition mapping variants
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_Button:
                tst.w   (Competition_mode).w
                bne.w   loc_2BC68
                move.l  #Map_Button,mappings(a0)
                move.w  #make_art_tile(ArtTile_GrayButton,0,0),art_tile(a0)
                cmpi.b  #1,(Current_zone).w
                bne.s   loc_2BB4C
                move.l  #Map_HCZButton,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZButton,1,0),art_tile(a0)

loc_2BB4C:
                cmpi.b  #3,(Current_zone).w
                bne.s   loc_2BB62
                move.l  #Map_CNZButton,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$C9,2,0),art_tile(a0)

loc_2BB62:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$200,priority(a0)
                addq.w  #4,y_pos(a0)
                btst    #5,subtype(a0)
                beq.s   loc_2BB8A
                move.l  #loc_2BBFE,(a0)
                bra.w   loc_2BBFE
; ---------------------------------------------------------------------------

loc_2BB8A:
                move.l  #loc_2BB90,(a0)

loc_2BB90:
                tst.b   render_flags(a0)
                bpl.s   loc_2BBF8
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
                beq.s   loc_2BBCE
                moveq   #7,d3

loc_2BBCE:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_2BBE4
                btst    #4,subtype(a0)
                bne.s   loc_2BBF8
                bclr    d3,(a3)
                bra.s   loc_2BBF8
; ---------------------------------------------------------------------------

loc_2BBE4:
                tst.b   (a3)
                bne.s   loc_2BBF0
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

loc_2BBF0:
                bset    d3,(a3)
                move.b  #1,mapping_frame(a0)

loc_2BBF8:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2BBFE:
                tst.b   render_flags(a0)
                bpl.s   loc_2BC62
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
                beq.s   loc_2BC38
                moveq   #7,d3

loc_2BC38:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_2BC4E
                btst    #4,subtype(a0)
                bne.s   loc_2BC62
                bclr    d3,(a3)
                bra.s   loc_2BC62
; ---------------------------------------------------------------------------

loc_2BC4E:
                tst.b   (a3)
                bne.s   loc_2BC5A
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

loc_2BC5A:
                bset    d3,(a3)
                move.b  #1,mapping_frame(a0)

loc_2BC62:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2BC68:
                move.l  #Map_2PButton,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PArt_1,0,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$C,width_pixels(a0)
                move.w  #$200,priority(a0)
                addq.w  #4,y_pos(a0)
                move.l  #loc_2BC92,(a0)

loc_2BC92:
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
                bne.s   loc_2BCD6
                btst    #4,subtype(a0)
                bne.s   loc_2BCEA
                bclr    d3,(a3)
                bra.s   loc_2BCEA
; ---------------------------------------------------------------------------

loc_2BCD6:
                tst.b   (a3)
                bne.s   loc_2BCE2
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

loc_2BCE2:
                bset    d3,(a3)
                move.b  #1,mapping_frame(a0)

loc_2BCEA:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_Button:
                include "src/objects/shared/buttons/map_button.s"
; Map_Button2:
Map_HCZButton:
                include "src/objects/shared/zones/hcz/map_button.s"
Map_CNZButton:
                include "src/objects/shared/zones/cnz/map_button.s"
Map_2PButton:
                include "src/game/competition/shared/2p_zone/map_2p_button.s"
; End of function Obj_Button
