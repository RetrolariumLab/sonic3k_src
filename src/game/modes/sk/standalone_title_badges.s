; Owner: game/modes/sk
; Responsibility: Standalone title character animation sequences, menu icons and trademark widget
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
SKTitle_AnimSmile:
                dc.b    5,   0,   3,   6, $FE,   1
SKTitle_AnimFinger:
                dc.b    3, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29
                dc.b    $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29,   0,   0, $29, $52, $29,   0, $29
                dc.b    $52, $29,   0, $29, $52, $29, $FF
SKTitle_AnimKnuckle1:
                dc.b    3,   0,   0,   0,   0,   0,   0,   0,   0, $2F, $5E, $2F,   0, $2F, $5E, $2F, $FF
SKTitle_AnimKnuckle2:
                dc.b    3,   0,   0, $14, $28, $14,   0,   0, $FF
                even
; ---------------------------------------------------------------------------

Obj_SKTitle_Icon:
                move.w  #$108,x_pos(a0)
                move.w  #$150,y_pos(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                move.l  #Map_SKTitle_Icon,mappings(a0)
                move.w  #make_art_tile(ArtTile_SKTitle_Menu,0,1),art_tile(a0)
                bset    #6,render_flags(a0)             ; Turn on multi-sprite mode
                lea     sub2_x_pos(a0),a2
                move.w  #2,mainspr_childsprites(a0)
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+                 ; First sprite is the Sonic/Knuckles icon
                move.w  #0,(a2)+
                andi.b  #1,(Title_screen_option).w
                move.b  (Title_screen_option).w,d0
                ror.b   #1,d0
                move.b  d0,angle(a0)
                move.b  #8,$27(a0)
                move.l  #Obj_SKTitle_IconDisplay,(a0)

Obj_SKTitle_IconDisplay:
                moveq   #0,d2
                move.b  (Title_screen_option).w,d2      ; Get current selection
                move.b  angle(a0),d0
                andi.b  #$7F,d0
                bne.s   loc_5B9E                        ; If selection is currently, being rotated, branch
                move.b  (Ctrl_1_pressed).w,d0
                btst    #button_up,d0
                beq.s   loc_5B6E
                subq.b  #8,angle(a0)                    ; if down was pressed, rotate backwards
                move.b  #-8,$27(a0)
                subq.b  #1,d2
                bcc.s   loc_5B6E
                move.b  #1,d2

loc_5B6E:
                btst    #button_down,d0
                beq.s   loc_5B8C
                addq.b  #8,angle(a0)                    ; if up was pressed, rotate forward
                move.b  #8,$27(a0)
                addq.b  #1,d2
                andi.b  #1,d2
                cmpi.b  #3,d2
                blo.s   loc_5B8C
                moveq   #0,d2

loc_5B8C:
                move.b  d2,(Title_screen_option).w      ; Move selection
                andi.b  #3,d0
                beq.s   loc_5B9E
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l                    ; Only play sound if selection was made

loc_5B9E:
                move.b  angle(a0),d0
                andi.b  #$7F,d0
                beq.s   loc_5BB0
                move.b  $27(a0),d0                      ; Perform rotation if necessary
                add.b   d0,angle(a0)

loc_5BB0:
                move.b  angle(a0),d0                    ; Get rotation angle
                addi.b  #$98,d0
                jsr     (GetSineCosine).l
                muls.w  #5,d1
                muls.w  #5,d0
                asr.l   #8,d1
                asr.l   #8,d0                           ; Convert to X/Y coordinates
                move.w  d1,d3
                move.w  d0,d2
                add.w   $44(a0),d1
                add.w   $46(a0),d0
                neg.w   d3
                neg.w   d2
                add.w   $44(a0),d3
                add.w   $46(a0),d2
                moveq   #0,d4
                moveq   #2,d5
                move.b  angle(a0),d6
                subi.b  #$A0,d6
                bpl.s   loc_5BF6
                exg     d1,d3                           ; Exchange attributes of Sonic/Knuckles text sprites depending on the rotation angle
                exg     d0,d2
                exg     d4,d5

loc_5BF6:
                addq.b  #1,d5
                lea     sub2_x_pos(a0),a2
                move.w  d1,(a2)+                        ; sub2_x_pos
                move.w  d0,(a2)+                        ; sub2_y_pos
                move.w  d4,(a2)+                        ; sub2_mapframe
                move.w  d3,(a2)+                        ; sub3_x_pos
                move.w  d2,(a2)+                        ; sub3_y_pos
                move.b  d5,1(a2)                        ; sub3_mapframe
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_SKTitle_Icon2:
                move.w  #$D0,x_pos(a0)
                move.w  #$14C,y_pos(a0)
                move.l  #Map_SKTitle_Icon,mappings(a0)
                move.w  #make_art_tile(ArtTile_SKTitle_Menu,0,1),art_tile(a0)
                move.b  (Title_screen_option).w,d0
                move.b  d0,anim(a0)
                move.b  d0,prev_anim(a0)
                move.b  #1,anim_frame(a0)
                move.l  #Obj_SKTitle_Icon2Display,(a0)

Obj_SKTitle_Icon2Display:
                move.b  (Title_screen_option).w,anim(a0)
                lea     (Ani_SKTitle_Icon).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_SKTitle_Icon:
                include "src/ui/shared/title/animations/sk_icon.s"
; ---------------------------------------------------------------------------

Obj_SKTitle_TM:
                move.l  #Map_SKTitle_TM,mappings(a0)
                move.w  #make_art_tile(ArtTile_SKTitle_Menu,0,1),art_tile(a0)
                move.w  #$1A2,x_pos(a0)
                move.w  #$11D,y_pos(a0)
                move.w  #$80,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.l  #Obj_SKTitle_TMDisplay,(a0)

Obj_SKTitle_TMDisplay:
                tst.b   (Graphics_flags).w
                bpl.s   locret_5CAE
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_5CAE:
                rts
