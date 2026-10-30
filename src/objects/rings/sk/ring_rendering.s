; Owner: objects/rings/sk
; Responsibility: Visible ring sprite construction and its private ring mapping table
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Render_Rings:
                movea.l (Ring_start_addr_ROM).w,a0
                move.l  (Ring_end_addr_ROM).w,d2
                sub.l   a0,d2
                beq.s   locret_EBEC
                movea.w (Ring_start_addr_RAM).w,a4
                lea     CMap_Ring(pc),a1
                move.w  4(a3),d4
                move.w  #$F0,d5
                move.w  (Screen_Y_wrap_value).w,d3

loc_EBA6:
                tst.w   (a4)+
                bmi.s   loc_EBE6
                move.w  2(a0),d1
                sub.w   d4,d1
                addq.w  #8,d1
                and.w   d3,d1
                cmp.w   d5,d1
                bhs.s   loc_EBE6
                addi.w  #$78,d1
                move.w  (a0),d0
                sub.w   (a3),d0
                addi.w  #$80,d0
                move.b  -1(a4),d6
                bne.s   loc_EBCE
                move.b  (Rings_frame).w,d6

loc_EBCE:
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

loc_EBE6:
                addq.w  #4,a0
                subq.w  #4,d2
                bne.s   loc_EBA6

locret_EBEC:
                rts
; End of function Render_Rings

; ---------------------------------------------------------------------------
; Custom mappings format. Compare to Map_Ring

; Differences include
; No offset table (each sprite assumed to be 8 bytes)
; No 'sprite pieces per frame' value (hardcoded to 1)
; Sign-extended Y-pos value
; Sign-extended sprite size value

CMap_Ring:
; frame1:
                dc.w    -8
                dc.w    $0005
                dc.w    $0000+make_art_tile(ArtTile_Ring,1,0)
                dc.w    -8

; frame2:
                dc.w    -8
                dc.w    $0005
                dc.w    $0004+make_art_tile(ArtTile_Ring,1,0)
                dc.w    -8

; frame3:
                dc.w    -8
                dc.w    $0001
                dc.w    $0008+make_art_tile(ArtTile_Ring,1,0)
                dc.w    -4

; frame4:
                dc.w    -8
                dc.w    $0005
                dc.w    $0804+make_art_tile(ArtTile_Ring,1,0)
                dc.w    -8

; frame5:
                dc.w    -8
                dc.w    $0005
                dc.w    $000A+make_art_tile(ArtTile_Ring,1,0)
                dc.w    -8

; frame6:
                dc.w    -8
                dc.w    $0005
                dc.w    $180A+make_art_tile(ArtTile_Ring,1,0)
                dc.w    -8

; frame7:
                dc.w    -8
                dc.w    $0005
                dc.w    $080A+make_art_tile(ArtTile_Ring,1,0)
                dc.w    -8

; frame8:
                dc.w    -8
                dc.w    $0005
                dc.w    $100A+make_art_tile(ArtTile_Ring,1,0)
                dc.w    -8

; =============== S U B R O U T I N E =======================================
