; Owner: rendering/s3
; Responsibility: Prioritized normal sprite display, mapping-piece expansion and orientation-specific rendering helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Render_Sprites:
                tst.w   (Competition_mode).w
                bne.w   Render_Sprites_CompetitionMode
                moveq   #80-1,d7                        ; Number of sprites to render
                moveq   #0,d6
                lea     (Sprite_table_input).w,a5
                lea     (Camera_X_pos_copy).w,a3
                lea     (Sprite_table).w,a6
                tst.b   (Level_started_flag).w
                beq.s   loc_193B8
                jsr     (Render_HUD).l
                jsr     (Render_Rings).l

loc_193B8:
                tst.w   (a5)
                beq.w   Render_Sprites_NextLevel
                lea     2(a5),a4

loc_193C2:
                movea.w (a4)+,a0                        ; a0=object
                andi.b  #$7F,render_flags(a0)           ; clear on-screen flag
                move.b  render_flags(a0),d6
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                btst    #6,d6                           ; is the multi-draw flag set?
                bne.w   loc_194BA                       ; if it is, branch
                btst    #2,d6                           ; is this to be positioned by screen coordinates?
                beq.s   loc_19420                       ; if it is, branch
                moveq   #0,d2
                move.b  width_pixels(a0),d2
                sub.w   (a3),d0
                move.w  d0,d3
                add.w   d2,d3                           ; is the object right edge to the left of the screen?
                bmi.s   Render_Sprites_NextObj          ; if it is, branch
                move.w  d0,d3
                sub.w   d2,d3
                cmpi.w  #320,d3                         ; is the object left edge to the right of the screen?
                bge.s   Render_Sprites_NextObj          ; if it is, branch
                addi.w  #128,d0
                sub.w   4(a3),d1
                move.b  height_pixels(a0),d2
                add.w   d2,d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #224,d2
                cmp.w   d2,d1
                bhs.s   Render_Sprites_NextObj          ; if the object is below the screen
                addi.w  #128,d1
                sub.w   d3,d1

loc_19420:
                ori.b   #$80,render_flags(a0)           ; set on-screen flag
                tst.w   d7
                bmi.s   Render_Sprites_NextObj
                movea.l mappings(a0),a1
                moveq   #0,d4
                btst    #5,d6                           ; is the static mappings flag set?
                bne.s   loc_19446                       ; if it is, branch
                move.b  mapping_frame(a0),d4
                add.w   d4,d4
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4                           ; get number of pieces
                bmi.s   Render_Sprites_NextObj          ; if there are 0 pieces, branch

loc_19446:
                move.w  art_tile(a0),d5
                jsr     RenderMappingPieces(pc)

Render_Sprites_NextObj:
                subq.w  #2,(a5)                         ; decrement object count
                bne.w   loc_193C2                       ; if there are objects left, repeat

Render_Sprites_NextLevel:
                cmpa.l  #Sprite_table_input,a5
                bne.s   loc_1946A
                cmpi.w  #$900,(Current_zone_and_act).w  ; LRZ Act 1?
                bne.s   loc_1946A
                jsr     (RenderLRZForegroundRockPieces).l

loc_1946A:
                lea     $80(a5),a5                      ; load next priority level
                cmpa.l  #Sprite_table_input_end,a5
                blo.w   loc_193B8
                move.w  d7,d6
                bmi.s   loc_19486
                moveq   #0,d0

loc_1947E:
                move.w  d0,(a6)
                addq.w  #8,a6
                dbf     d7,loc_1947E

loc_19486:
                subi.w  #$4F,d6
                neg.w   d6
                move.b  d6,(Sprites_drawn).w
                tst.w   (Spritemask_flag).w
                beq.s   locret_194B8
                clr.w   (Spritemask_flag).w
                lea     (Sprite_table-4).w,a0
                move.w  #$7C0,d0
                moveq   #80-1,d1

loc_194A4:
                addq.w  #8,a0
                cmp.w   (a0),d0
                dbeq    d1,loc_194A4
                bne.s   locret_194B8
                move.w  #1,2(a0)
                clr.w   $A(a0)

locret_194B8:
                rts
; ---------------------------------------------------------------------------

loc_194BA:
                btst    #2,d6                           ; is this to be positioned by screen coordinates?
                bne.s   loc_19504                       ; if it is, branch
                moveq   #0,d2

; check if object is within X bounds
                move.b  width_pixels(a0),d2
                subi.w  #128,d0
                move.w  d0,d3
                add.w   d2,d3
                bmi.w   Render_Sprites_NextObj
                move.w  d0,d3
                sub.w   d2,d3
                cmpi.w  #320,d3
                bge.w   Render_Sprites_NextObj
                addi.w  #128,d0

; check if object is within Y bounds
                move.b  height_pixels(a0),d2
                subi.w  #128,d1
                move.w  d1,d3
                add.w   d2,d3
                bmi.w   Render_Sprites_NextObj
                move.w  d1,d3
                sub.w   d2,d3
                cmpi.w  #224,d3
                bge.w   Render_Sprites_NextObj
                addi.w  #128,d1
                bra.s   loc_19546
; ---------------------------------------------------------------------------

loc_19504:
                moveq   #0,d2
                move.b  width_pixels(a0),d2
                sub.w   (a3),d0
                move.w  d0,d3
                add.w   d2,d3
                bmi.w   Render_Sprites_NextObj
                move.w  d0,d3
                sub.w   d2,d3
                cmpi.w  #320,d3
                bge.w   Render_Sprites_NextObj
                addi.w  #128,d0
                sub.w   4(a3),d1
                move.b  height_pixels(a0),d2
                add.w   d2,d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #224,d2
                cmp.w   d2,d1
                bhs.w   Render_Sprites_NextObj
                addi.w  #128,d1
                sub.w   d3,d1

loc_19546:
                ori.b   #$80,render_flags(a0)
                tst.w   d7
                bmi.w   Render_Sprites_NextObj
                move.w  art_tile(a0),d5
                movea.l mappings(a0),a2
                moveq   #0,d4
                move.b  mapping_frame(a0),d4
                beq.s   loc_1957E
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   loc_1957E
                move.w  d6,d3
                jsr     RenderMappingPiecesClipped(pc)
                move.w  d3,d6
                tst.w   d7
                bmi.w   Render_Sprites_NextObj

loc_1957E:
                move.w  mainspr_childsprites(a0),d3
                subq.w  #1,d3
                bcs.w   Render_Sprites_NextObj
                lea     sub2_x_pos(a0),a0

loc_1958C:
                move.w  (a0)+,d0
                move.w  (a0)+,d1
                btst    #2,d6
                beq.s   loc_195A8
                sub.w   (a3),d0
                addi.w  #128,d0
                sub.w   4(a3),d1
                addi.w  #128,d1
                and.w   (Screen_Y_wrap_value).w,d1

loc_195A8:
                addq.w  #1,a0
                moveq   #0,d4
                move.b  (a0)+,d4
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   loc_195C4
                move.w  d6,-(sp)
                jsr     RenderMappingPiecesClipped(pc)
                move.w  (sp)+,d6

loc_195C4:
                tst.w   d7
                dbmi    d3,loc_1958C
                bra.w   Render_Sprites_NextObj
; End of function Render_Sprites

; =============== S U B R O U T I N E =======================================

RenderMappingPieces:
                lsr.b   #1,d6
                bcs.s   loc_19600
                lsr.b   #1,d6
                bcs.w   loc_1969A

loc_195D8:
                move.b  (a1)+,d2
                ext.w   d2
                add.w   d1,d2
                move.w  d2,(a6)+
                move.b  (a1)+,(a6)+
                addq.w  #1,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                add.w   d0,d2
                andi.w  #$1FF,d2
                bne.s   loc_195F6
                addq.w  #1,d2

loc_195F6:
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,loc_195D8
                rts
; ---------------------------------------------------------------------------

loc_19600:
                lsr.b   #1,d6
                bcs.s   loc_1964A

loc_19604:
                move.b  (a1)+,d2
                ext.w   d2
                add.w   d1,d2
                move.w  d2,(a6)+
                move.b  (a1)+,d6
                move.b  d6,(a6)+
                addq.w  #1,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                eori.w  #$800,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                neg.w   d2
                move.b  byte_1963A(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d0,d2
                andi.w  #$1FF,d2
                bne.s   loc_19630
                addq.w  #1,d2

loc_19630:
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,loc_19604
                rts
; ---------------------------------------------------------------------------
byte_1963A:
                dc.b    8,   8,   8,   8
                dc.b    $10, $10, $10, $10
                dc.b    $18, $18, $18, $18
                dc.b    $20, $20, $20, $20
                even
; ---------------------------------------------------------------------------

loc_1964A:
                move.b  (a1)+,d2
                ext.w   d2
                neg.w   d2
                move.b  (a1),d6
                move.b  byte_1968A(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d1,d2
                move.w  d2,(a6)+
                move.b  (a1)+,d6
                move.b  d6,(a6)+
                addq.w  #1,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                eori.w  #$1800,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                neg.w   d2
                move.b  byte_1963A(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d0,d2
                andi.w  #$1FF,d2
                bne.s   loc_19680
                addq.w  #1,d2

loc_19680:
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,loc_1964A
                rts
; ---------------------------------------------------------------------------
byte_1968A:
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                even
; ---------------------------------------------------------------------------

loc_1969A:
                move.b  (a1)+,d2
                ext.w   d2
                neg.w   d2
                move.b  (a1)+,d6
                move.b  d6,2(a6)
                move.b  byte_1968A(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d1,d2
                move.w  d2,(a6)+
                addq.w  #2,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                eori.w  #$1000,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                add.w   d0,d2
                andi.w  #$1FF,d2
                bne.s   loc_196C8
                addq.w  #1,d2

loc_196C8:
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,loc_1969A
                rts
; End of function RenderMappingPieces

; =============== S U B R O U T I N E =======================================

RenderMappingPiecesClipped:
                lsr.b   #1,d6
                bcs.s   loc_19724
                lsr.b   #1,d6
                bcs.w   loc_197FE

loc_196DC:
                move.b  (a1)+,d2
                ext.w   d2
                add.w   d1,d2
                cmpi.w  #-32+128,d2
                bls.s   loc_1971C
                cmpi.w  #224+128,d2
                bhs.s   loc_1971C
                move.w  d2,(a6)+
                move.b  (a1)+,(a6)+
                addq.w  #1,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                add.w   d0,d2
                cmpi.w  #-32+128,d2
                bls.s   loc_19714
                cmpi.w  #320+128,d2
                bhs.s   loc_19714
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,loc_196DC
                rts
; ---------------------------------------------------------------------------

loc_19714:
                subq.w  #6,a6
                dbf     d4,loc_196DC
                rts
; ---------------------------------------------------------------------------

loc_1971C:
                addq.w  #5,a1
                dbf     d4,loc_196DC
                rts
; ---------------------------------------------------------------------------

loc_19724:
                lsr.b   #1,d6
                bcs.s   loc_1978E

loc_19728:
                move.b  (a1)+,d2
                ext.w   d2
                add.w   d1,d2
                cmpi.w  #-32+128,d2
                bls.s   loc_19776
                cmpi.w  #224+128,d2
                bhs.s   loc_19776
                move.w  d2,(a6)+
                move.b  (a1)+,d6
                move.b  d6,(a6)+
                addq.w  #1,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                eori.w  #$800,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                neg.w   d2
                move.b  byte_1977E(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d0,d2
                cmpi.w  #-32+128,d2
                bls.s   loc_1976E
                cmpi.w  #320+128,d2
                bhs.s   loc_1976E
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,loc_19728
                rts
; ---------------------------------------------------------------------------

loc_1976E:
                subq.w  #6,a6
                dbf     d4,loc_19728
                rts
; ---------------------------------------------------------------------------

loc_19776:
                addq.w  #5,a1
                dbf     d4,loc_19728
                rts
; ---------------------------------------------------------------------------
byte_1977E:
                dc.b    8,   8,   8,   8
                dc.b    $10, $10, $10, $10
                dc.b    $18, $18, $18, $18
                dc.b    $20, $20, $20, $20
                even
; ---------------------------------------------------------------------------

loc_1978E:
                move.b  (a1)+,d2
                ext.w   d2
                neg.w   d2
                move.b  (a1),d6
                move.b  byte_197EE(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d1,d2
                cmpi.w  #-32+128,d2
                bls.s   loc_197E6
                cmpi.w  #224+128,d2
                bhs.s   loc_197E6
                move.w  d2,(a6)+
                move.b  (a1)+,d6
                move.b  d6,(a6)+
                addq.w  #1,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                eori.w  #$1800,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                neg.w   d2
                move.b  byte_1977E(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d0,d2
                cmpi.w  #-32+128,d2
                bls.s   loc_197DE
                cmpi.w  #320+128,d2
                bhs.s   loc_197DE
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,loc_1978E
                rts
; ---------------------------------------------------------------------------

loc_197DE:
                subq.w  #6,a6
                dbf     d4,loc_1978E
                rts
; ---------------------------------------------------------------------------

loc_197E6:
                addq.w  #5,a1
                dbf     d4,loc_1978E
                rts
; ---------------------------------------------------------------------------
byte_197EE:
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                even
; ---------------------------------------------------------------------------

loc_197FE:
                move.b  (a1)+,d2
                ext.w   d2
                neg.w   d2
                move.b  (a1)+,d6
                move.b  d6,2(a6)
                move.b  byte_197EE(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d1,d2
                cmpi.w  #-32+128,d2
                bls.s   loc_1984E
                cmpi.w  #224+128,d2
                bhs.s   loc_1984E
                move.w  d2,(a6)+
                addq.w  #2,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                eori.w  #$1000,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                add.w   d0,d2
                cmpi.w  #-32+128,d2
                bls.s   loc_19846
                cmpi.w  #320+128,d2
                bhs.s   loc_19846
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,loc_197FE
                rts
; ---------------------------------------------------------------------------

loc_19846:
                subq.w  #6,a6
                dbf     d4,loc_197FE
                rts
; ---------------------------------------------------------------------------

loc_1984E:
                addq.w  #4,a1
                dbf     d4,loc_197FE
                rts
; End of function RenderMappingPiecesClipped
