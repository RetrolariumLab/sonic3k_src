; Owner: game/special_stage/sk
; Responsibility: Special stage decimal number conversion, fixed HUD glyph output and private number graphics
; Source provenance and ranges: config/reconstruction/source_layout.json
Draw_SSNum:
                lea     (SSNum_Precision).l,a2
                moveq   #3-1,d6
                lea     MapUnc_SSNum(pc),a1

loc_8C6A:
                moveq   #0,d2
                move.w  (a2)+,d3

loc_8C6E:
                sub.w   d3,d1
                bcs.s   loc_8C76
                addq.w  #1,d2
                bra.s   loc_8C6E
; ---------------------------------------------------------------------------

loc_8C76:
                add.w   d3,d1
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                add.w   d2,d2
                add.w   d2,d2
                lea     (a1,d2.w),a3
                move.l  (a3),(a6)
                addi.l  #$80<<16,d0
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                move.l  $28(a3),(a6)
                addi.l  #$80<<16,d0
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                move.l  $50(a3),(a6)
                subi.l  #$FC<<16,d0
                dbf     d6,loc_8C6A
                rts
; End of function Draw_SSNum

; ---------------------------------------------------------------------------
SSNum_Precision:
                dc.w    100
                dc.w    10
                dc.w    1
MapUnc_SSNum:
                binclude "data/General/Special Stage/Uncompressed Map/HUD Numbers.bin"
                even
MapUnc_SSNum000:
                binclude "data/General/Special Stage/Uncompressed Map/HUD.bin"
                even

; =============== S U B R O U T I N E =======================================

; Create_New_Sprite2:
