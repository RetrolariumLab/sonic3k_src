; Owner: rendering/palettes/sk
; Responsibility: Selected object palette fade to black and per-channel decrements
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FadeSelectedToBlack:
                move.l  #loc_8555E,(a0)
                move.b  #7,$39(a0)
                st      (Palette_rotation_disable).w

loc_8555E:
                subq.w  #1,$2E(a0)
                bpl.s   locret_8558E
                move.w  $3A(a0),$2E(a0)
                movea.w $30(a0),a1
                move.w  $3C(a0),d0
                moveq   #$E,d1
                moveq   #-$20,d2

loc_85576:
                bsr.w   DecColor_Obj
                dbf     d0,loc_85576
                subq.b  #1,$39(a0)
                bpl.s   locret_8558E
                clr.b   (Palette_rotation_disable).w
                jsr     (Go_Delete_Sprite).l

locret_8558E:
                rts

; =============== S U B R O U T I N E =======================================

DecColor_Obj:
                move.b  (a1),d3
                and.b   d1,d3
                beq.s   loc_85598
                subq.b  #2,d3

loc_85598:
                move.b  d3,(a1)+
                move.b  (a1),d3
                move.b  d3,d4
                and.b   d2,d3
                beq.s   loc_855A6
                subi.b  #$20,d3

loc_855A6:
                and.b   d1,d4
                beq.s   loc_855AC
                subq.b  #2,d4

loc_855AC:
                or.b    d3,d4
                move.b  d4,(a1)+
                rts
; End of function DecColor_Obj
