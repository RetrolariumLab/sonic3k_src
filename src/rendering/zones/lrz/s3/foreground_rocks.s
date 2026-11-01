; Owner: rendering/zones/lrz/s3
; Responsibility: Lava Reef foreground rock sprite selection, projection and private sprite piece data
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Draw_LRZ_Special_Rock_Sprites:
                rts
; ---------------------------------------------------------------------------

                moveq   #0,d0
                move.b  (LRZ_rocks_routine).w,d0
                move.w  Draw_LRZ_Special_Rock_Sprites_Index(pc,d0.w),d0
                jmp     Draw_LRZ_Special_Rock_Sprites_Index(pc,d0.w)
; ---------------------------------------------------------------------------
Draw_LRZ_Special_Rock_Sprites_Index:
                dc.w    loc_1AE9C-Draw_LRZ_Special_Rock_Sprites_Index
                dc.w    loc_1AECC-Draw_LRZ_Special_Rock_Sprites_Index
; ---------------------------------------------------------------------------

loc_1AE9C:
                addq.b  #2,(LRZ_rocks_routine).w
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   loc_1AEAE
                moveq   #1,d4
                bra.s   loc_1AEAE
; ---------------------------------------------------------------------------

loc_1AEAC:
                addq.l  #6,a1

loc_1AEAE:
                cmp.w   2(a1),d4
                bhi.s   loc_1AEAC
                move.l  a1,(LRZ_rocks_addr_front).w
                addi.w  #$150,d4
                bra.s   loc_1AEC0
; ---------------------------------------------------------------------------

loc_1AEBE:
                addq.l  #6,a1

loc_1AEC0:
                cmp.w   2(a1),d4
                bhi.s   loc_1AEBE
                move.l  a1,(LRZ_rocks_addr_back).w
                rts
; ---------------------------------------------------------------------------

loc_1AECC:
                movea.l (LRZ_rocks_addr_front).w,a1
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   loc_1AEDE
                moveq   #1,d4
                bra.s   loc_1AEDE
; ---------------------------------------------------------------------------

loc_1AEDC:
                addq.l  #6,a1

loc_1AEDE:
                cmp.w   2(a1),d4
                bhi.s   loc_1AEDC
                bra.s   loc_1AEE8
; ---------------------------------------------------------------------------

loc_1AEE6:
                subq.l  #6,a1

loc_1AEE8:
                cmp.w   -4(a1),d4
                bls.s   loc_1AEE6
                move.l  a1,(LRZ_rocks_addr_front).w
                movea.l (LRZ_rocks_addr_back).w,a2
                addi.w  #$150,d4
                bra.s   loc_1AEFE
; ---------------------------------------------------------------------------

loc_1AEFC:
                addq.l  #6,a2

loc_1AEFE:
                cmp.w   2(a2),d4
                bhi.s   loc_1AEFC
                bra.s   loc_1AF08
; ---------------------------------------------------------------------------

loc_1AF06:
                subq.l  #6,a2

loc_1AF08:
                cmp.w   -4(a2),d4
                bls.s   loc_1AF06
                move.l  a2,(LRZ_rocks_addr_back).w
                rts
; End of function Draw_LRZ_Special_Rock_Sprites

; =============== S U B R O U T I N E =======================================

RenderLRZForegroundRockPieces:
                movea.l (LRZ_rocks_addr_front).w,a0
                move.l  (LRZ_rocks_addr_back).w,d2
                sub.l   a0,d2
                beq.s   locret_1AF68
                lea     LRZ_Rock_SpriteData(pc),a1
                move.w  #120,d3
                move.w  4(a3),d4
                move.w  #240,d5

loc_1AF30:
                move.w  4(a0),d1
                sub.w   d4,d1
                addq.w  #8,d1
                cmp.w   d5,d1
                bhs.s   loc_1AF62
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

loc_1AF62:
                addq.l  #6,a0
                subq.w  #6,d2
                bne.s   loc_1AF30

locret_1AF68:
                rts
; End of function RenderLRZForegroundRockPieces

; ---------------------------------------------------------------------------
LRZ_Rock_SpriteData:
                binclude "data/Levels/LRZ/Misc/Rock Sprite Attribute Data S3.bin"
                even
