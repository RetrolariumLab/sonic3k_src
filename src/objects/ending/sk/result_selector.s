; Owner: objects/ending/sk
; Responsibility: Select ending result programs by product, character and emerald state, then sequence the palette fade
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_5EF68:
                move.l  #loc_5F144,(a0)
                move.w  #$1FF,$2E(a0)
                clr.b   (Super_palette_status).w
                move.w  (Player_mode).w,d0
                moveq   #0,d1
                andi.w  #3,d0
                subq.w  #2,d0
                bmi.s   loc_5EF90
                beq.s   loc_5EF8C
                addi.w  #$30,d1

loc_5EF8C:
                addi.w  #$30,d1

loc_5EF90:
                tst.w   (SK_alone_flag).w
                bne.s   loc_5EF9A
                addi.w  #$18,d1

loc_5EF9A:
                tst.b   (_unkFA88).w
                bmi.s   loc_5EFAA
                beq.s   loc_5EFA6
                addi.w  #8,d1

loc_5EFA6:
                addi.w  #8,d1

loc_5EFAA:
                lea     off_5EFB6(pc,d1.w),a1
                movea.l (a1)+,a2
                move.l  (a1)+,$34(a0)
                jmp     (a2)
; ---------------------------------------------------------------------------
off_5EFB6:
                dc.l    loc_5F046, loc_5F0E2
                dc.l    loc_5F046, loc_5F106
                dc.l    loc_5F046, loc_5F106
                dc.l    loc_5F05C, loc_5F0E2
                dc.l    loc_5F05C, loc_5F106
                dc.l    loc_5F05C, loc_5F116
                dc.l    loc_5F05C, loc_5F0E2
                dc.l    loc_5F05C, loc_5F106
                dc.l    loc_5F05C, loc_5F116
                dc.l    loc_5F05C, loc_5F0E2
                dc.l    loc_5F05C, loc_5F106
                dc.l    loc_5F05C, loc_5F116
                dc.l    loc_5F090, loc_5F126
                dc.l    loc_5F072, loc_5F0DA
                dc.l    loc_5F072, loc_5F0DA
                dc.l    loc_5F0C4, loc_5F126
                dc.l    loc_5F0A6, loc_5F0DA
                dc.l    loc_5F0A6, loc_5F116
; ---------------------------------------------------------------------------

loc_5F046:
                jsr     (AllocateObject).l
                bne.s   locret_5F05A
                move.l  #loc_5F1AC,(a1)
                move.b  #4,subtype(a1)

locret_5F05A:
                rts
; ---------------------------------------------------------------------------

loc_5F05C:
                jsr     (AllocateObject).l
                bne.s   locret_5F070
                move.l  #loc_5F20A,(a1)
                move.b  #4,subtype(a1)

locret_5F070:
                rts
; ---------------------------------------------------------------------------

loc_5F072:
                jsr     (AllocateObject).l
                bne.s   loc_5F080
                move.l  #loc_5F480,(a1)

loc_5F080:
                jsr     (AllocateObject).l
                bne.s   locret_5F08E
                move.l  #loc_5F1AC,(a1)

locret_5F08E:
                rts
; ---------------------------------------------------------------------------

loc_5F090:
                jsr     (AllocateObject).l
                bne.s   locret_5F0A4
                move.l  #loc_5F1AC,(a1)
                move.b  #8,subtype(a1)

locret_5F0A4:
                rts
; ---------------------------------------------------------------------------

loc_5F0A6:
                jsr     (AllocateObject).l
                bne.s   loc_5F0B4
                move.l  #loc_5F480,(a1)

loc_5F0B4:
                jsr     (AllocateObject).l
                bne.s   locret_5F0C2
                move.l  #loc_5F20A,(a1)

locret_5F0C2:
                rts
; ---------------------------------------------------------------------------

loc_5F0C4:
                jsr     (AllocateObject).l
                bne.s   locret_5F0D8
                move.l  #loc_5F20A,(a1)
                move.b  #8,subtype(a1)

locret_5F0D8:
                rts
; ---------------------------------------------------------------------------

loc_5F0DA:
                move.b  #GameMode_SegaScreen,(Game_mode).w
                rts
; ---------------------------------------------------------------------------

loc_5F0E2:
                jsr     (AllocateObject).l
                bne.s   loc_5F0F0
                move.l  #loc_5F566,(a1)

loc_5F0F0:
                jsr     (AllocateObject).l
                bne.s   locret_5F104
                move.l  #loc_5F8C6,(a1)
                move.b  #4,subtype(a1)

locret_5F104:
                rts
; ---------------------------------------------------------------------------

loc_5F106:
                jsr     (AllocateObject).l
                bne.s   locret_5F114
                move.l  #loc_5F5C2,(a1)

locret_5F114:
                rts
; ---------------------------------------------------------------------------

loc_5F116:
                jsr     (AllocateObject).l
                bne.s   locret_5F124
                move.l  #loc_5FD5A,(a1)

locret_5F124:
                rts
; ---------------------------------------------------------------------------

loc_5F126:
                jsr     (AllocateObject).l
                bne.s   loc_5F134
                move.l  #loc_5F71E,(a1)

loc_5F134:
                jsr     (AllocateObject).l
                bne.s   locret_5F142
                move.l  #loc_5F8C6,(a1)

locret_5F142:
                rts
; ---------------------------------------------------------------------------

loc_5F144:
                subq.w  #1,$2E(a0)
                bmi.s   loc_5F15A
                cmpi.w  #$40,$2E(a0)
                bne.s   locret_5F158
                bset    #2,(_unkFAB8).w

locret_5F158:
                rts
; ---------------------------------------------------------------------------

loc_5F15A:
                move.l  #loc_5F18A,(a0)
                st      (Palette_cycle_counters+$00).w
                jsr     (AllocateObject).l
                bne.s   locret_5F158
                move.w  a1,$44(a0)
                move.l  #Obj_FadeSelectedToBlack,(a1)
                move.w  #5,$3A(a1)
                move.w  #$3F,$3C(a1)
                move.w  #Normal_palette,$30(a1)
                rts
; ---------------------------------------------------------------------------

loc_5F18A:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.w   locret_5FF1A
                move.l  #locret_5F1AA,(a0)
                bset    #3,(_unkFAB8).w
                movea.l $34(a0),a1
                jmp     (a1)
; ---------------------------------------------------------------------------

locret_5F1AA:
                rts
