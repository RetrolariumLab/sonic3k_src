; Owner: objects/interface/continue/sk
; Responsibility: Continue countdown digit transfer, character child selection and private palette or animation records
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_5CAAE:
                move.b  (_unkFA84).w,d0
                move.b  d0,d1
                andi.w  #$F0,d0
                lsr.w   #3,d0
                andi.w  #$F,d1
                add.w   d1,d1
                move.w  #1,d2
                lea     (RAM_start+$2000).l,a1
                add.w   d2,d0
                move.w  d0,(a1)+
                add.w   d2,d1
                move.w  d1,(a1)+
                addq.w  #1,d0
                move.w  d0,(a1)+
                addq.w  #1,d1
                move.w  d1,(a1)+
                move    #$2700,sr
                lea     (VDP_data_port).l,a6
                move.w  #VRAM_Plane_A_Name_Table+$726,d2
                swap    d2
                clr.w   d2
                swap    d2
                lsl.l   #2,d2
                lsr.w   #2,d2
                ori.w   #$4000,d2
                swap    d2
                move.l  d2,d3
                addi.l  #$80<<16,d3
                lea     (RAM_start+$2000).l,a1
                move.l  d2,VDP_control_port-VDP_data_port(a6)
                move.w  (a1)+,(a6)
                move.w  (a1)+,(a6)
                move.l  d3,VDP_control_port-VDP_data_port(a6)
                move.w  (a1)+,(a6)
                move.w  (a1)+,(a6)
                move    #$2300,sr
                rts
; End of function sub_5CAAE

; =============== S U B R O U T I N E =======================================

sub_5CB1C:
                moveq   #0,d0
                move.b  (Continue_count).w,d0
                beq.s   loc_5CB2A
                cmpi.b  #$A,d0
                bls.s   loc_5CB2C

loc_5CB2A:
                moveq   #$A,d0

loc_5CB2C:
                lea     (Dynamic_object_RAM+(object_size*2)).w,a1
                moveq   #0,d1

loc_5CB32:
                subq.b  #1,d0
                beq.w   locret_5C4D4
                move.l  #loc_5CA1A,(a1)
                move.b  d1,subtype(a1)
                addq.w  #2,d1
                lea     next_object(a1),a1
                bra.s   loc_5CB32
; End of function sub_5CB1C

; =============== S U B R O U T I N E =======================================

sub_5CB4A:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_5CB58(pc,d0.w),x_pos(a0)
                rts
; End of function sub_5CB4A

; ---------------------------------------------------------------------------
word_5CB58:
                dc.w    $120
                dc.w    $138
                dc.w    $108
                dc.w    $150
                dc.w    $F0
                dc.w    $168
                dc.w    $D8
                dc.w    $180
                dc.w    $C0

; =============== S U B R O U T I N E =======================================

sub_5CB6A:
                move.w  (Player_mode).w,d4
                cmpi.b  #2,d4
                bne.s   loc_5CB7E
                lea     ChildObjDat_5CB88(pc),a2
                jsr     (CreateChild6_Simple).l

loc_5CB7E:
                lsl.w   #2,d4
                move.l  off_5CB8E(pc,d4.w),$30(a0)
                rts
; End of function sub_5CB6A

; ---------------------------------------------------------------------------
ChildObjDat_5CB88:
                dc.w    1-1
                dc.l    Obj_5CA78
off_5CB8E:
                dc.l    byte_5CBAE
                dc.l    byte_5CBAE
                dc.l    byte_5CBB0
                dc.l    byte_5CBB2
aCONTINUE:
                dc.b    "C O N T I N U E",0
                even
byte_5CBAE:     dc.b    0
                dc.b    1
byte_5CBB0:     dc.b    2
                dc.b    3
byte_5CBB2:     dc.b    7
                dc.b    8
byte_5CBB4:
                dc.b    2, $21, $22, $23, $24, $FF, $FC
byte_5CBBB:
                dc.b    8,   4,   5,   6, $FC
byte_5CBC0:
                dc.b    $B,   2,   2,   4, $FC
byte_5CBC5:
                dc.b    $B, $BD, $BE, $FF, $FC
                even
Pal_ContinueScreen:
                binclude "data/General/Continue/Palettes/Palette.bin"
                even
