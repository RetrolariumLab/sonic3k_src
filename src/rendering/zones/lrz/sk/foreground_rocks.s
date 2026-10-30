; Owner: rendering/zones/lrz/sk
; Responsibility: Lava Reef foreground rock sprite selection, projection and private sprite piece data
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Draw_LRZ_Special_Rock_Sprites:
                moveq   #0,d0
                move.b  (LRZ_rocks_routine).w,d0
                move.w  Draw_LRZ_Special_Rock_Sprites_Index(pc,d0.w),d0
                jmp     Draw_LRZ_Special_Rock_Sprites_Index(pc,d0.w)
; ---------------------------------------------------------------------------
Draw_LRZ_Special_Rock_Sprites_Index:
                dc.w    loc_1CADE-Draw_LRZ_Special_Rock_Sprites_Index
                dc.w    loc_1CB20-Draw_LRZ_Special_Rock_Sprites_Index
; ---------------------------------------------------------------------------

loc_1CADE:
                addq.b  #2,(LRZ_rocks_routine).w
                lea     (LRZ1_Rock_Placement).l,a1
                tst.b   (Current_act).w
                beq.s   loc_1CAF4
                lea     (LRZ2_Rock_Placement).l,a1

loc_1CAF4:
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   loc_1CB02
                moveq   #1,d4
                bra.s   loc_1CB02
; ---------------------------------------------------------------------------

loc_1CB00:
                addq.l  #6,a1

loc_1CB02:
                cmp.w   2(a1),d4
                bhi.s   loc_1CB00
                move.l  a1,(LRZ_rocks_addr_front).w
                addi.w  #$150,d4
                bra.s   loc_1CB14
; ---------------------------------------------------------------------------

loc_1CB12:
                addq.l  #6,a1

loc_1CB14:
                cmp.w   2(a1),d4
                bhi.s   loc_1CB12
                move.l  a1,(LRZ_rocks_addr_back).w
                rts
; ---------------------------------------------------------------------------

loc_1CB20:
                movea.l (LRZ_rocks_addr_front).w,a1
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   loc_1CB32
                moveq   #1,d4
                bra.s   loc_1CB32
; ---------------------------------------------------------------------------

loc_1CB30:
                addq.l  #6,a1

loc_1CB32:
                cmp.w   2(a1),d4
                bhi.s   loc_1CB30
                bra.s   loc_1CB3C
; ---------------------------------------------------------------------------

loc_1CB3A:
                subq.l  #6,a1

loc_1CB3C:
                cmp.w   -4(a1),d4
                bls.s   loc_1CB3A
                move.l  a1,(LRZ_rocks_addr_front).w
                movea.l (LRZ_rocks_addr_back).w,a2
                addi.w  #$150,d4
                bra.s   loc_1CB52
; ---------------------------------------------------------------------------

loc_1CB50:
                addq.l  #6,a2

loc_1CB52:
                cmp.w   2(a2),d4
                bhi.s   loc_1CB50
                bra.s   loc_1CB5C
; ---------------------------------------------------------------------------

loc_1CB5A:
                subq.l  #6,a2

loc_1CB5C:
                cmp.w   -4(a2),d4
                bls.s   loc_1CB5A
                move.l  a2,(LRZ_rocks_addr_back).w
                rts
; End of function Draw_LRZ_Special_Rock_Sprites

; =============== S U B R O U T I N E =======================================

sub_1CB68:
                movea.l (LRZ_rocks_addr_front).w,a0
                move.l  (LRZ_rocks_addr_back).w,d2
                sub.l   a0,d2
                beq.s   locret_1CBBC
                lea     LRZ_Rock_SpriteData(pc),a1
                move.w  #120,d3
                move.w  4(a3),d4
                move.w  #240,d5

loc_1CB84:
                move.w  4(a0),d1
                sub.w   d4,d1
                addq.w  #8,d1
                cmp.w   d5,d1
                bhs.s   loc_1CBB6
                add.w   d3,d1
                move.w  2(a0),d0
                sub.w   (a3),d0
                addi.w  #128,d0
                move.w  (a0),d6
                lsl.w   #3,d6
                lea     (a1,d6.w),a2
                add.w   (a2)+,d1
                move.w  d1,(a6)+
                move.w  (a2)+,d6
                move.b  d6,(a6)
                addq.w  #2,a6
                move.w  (a2)+,(a6)+
                add.w   (a2)+,d0
                move.w  d0,(a6)+
                subq.w  #1,d7

loc_1CBB6:
                addq.l  #6,a0
                subq.w  #6,d2
                bne.s   loc_1CB84

locret_1CBBC:
                rts
; End of function sub_1CB68

; ---------------------------------------------------------------------------
LRZ_Rock_SpriteData:
                binclude "data/Levels/LRZ/Misc/Rock Sprite Attribute Data.bin"
                even
