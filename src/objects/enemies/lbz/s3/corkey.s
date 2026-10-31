; Owner: objects/enemies/lbz/s3
; Responsibility: Corkey flying enemy, spawned projectiles and private construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Corkey:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Corkey_Index(pc,d0.w),d1
                jsr     Corkey_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Corkey_Index:
                dc.w    loc_59EC2-Corkey_Index
                dc.w    loc_59F18-Corkey_Index
                dc.w    loc_59F48-Corkey_Index
; ---------------------------------------------------------------------------

loc_59EC2:
                lea     ObjDat_Corkey(pc),a1
                jsr     (SetUp_ObjAttributes).l
                moveq   #-1,d0
                btst    #0,render_flags(a0)
                beq.s   loc_59ED8
                neg.w   d0

loc_59ED8:
                move.w  d0,$40(a0)
                move.b  subtype(a0),d0
                move.b  d0,$2F(a0)
                move.l  #loc_59F38,$34(a0)
                add.b   d0,d0
                move.b  d0,subtype(a0)
                lea     ChildObjDat_5A082(pc),a2
                jsr     (CreateChild1_Normal).l

loc_59EFC:
                jsr     (Random_Number).l
                andi.w  #$3F,d0
                move.w  d0,d1
                andi.w  #$30,d1
                bne.s   loc_59F12
                ori.w   #$30,d0

loc_59F12:
                move.w  d0,$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_59F18:
                subq.w  #1,$3A(a0)
                bmi.s   loc_59F2A
                move.w  $40(a0),d0
                add.w   d0,x_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_59F2A:
                move.b  #4,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_59F38:
                neg.w   $40(a0)
                clr.b   $2E(a0)
                move.b  subtype(a0),$2F(a0)
                rts
; ---------------------------------------------------------------------------

loc_59F48:
                btst    #1,$38(a0)
                beq.s   loc_59F52
                rts
; ---------------------------------------------------------------------------

loc_59F52:
                move.b  #2,routine(a0)
                bra.s   loc_59EFC
; ---------------------------------------------------------------------------

loc_59F5A:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_59F6C(pc,d0.w),d1
                jsr     off_59F6C(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_59F6C:
                dc.w    loc_59F74-off_59F6C
                dc.w    loc_59F7E-off_59F6C
                dc.w    loc_59FA6-off_59F6C
                dc.w    loc_5A020-off_59F6C
; ---------------------------------------------------------------------------

loc_59F74:
                lea     word_5A074(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

loc_59F7E:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   locret_59FA4
                move.b  #4,routine(a0)
                move.l  #loc_5A004,$34(a0)
                move.l  #byte_5A0A2,$30(a0)

locret_59FA4:
                rts
; ---------------------------------------------------------------------------

loc_59FA6:
                jsr     Animate_RawGetFaster(pc)
                tst.w   d2
                bpl.s   locret_59FC6
                cmpi.b  #4,$2F(a0)
                beq.s   loc_59FC8
                cmpi.b  #5,$2F(a0)
                beq.s   loc_59FDC
                cmpi.b  #6,$2F(a0)
                beq.s   loc_59FF0

locret_59FC6:
                rts
; ---------------------------------------------------------------------------

loc_59FC8:
                lea     ChildObjDat_5A08A(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #byte_5A0A7,$30(a1)
                rts
; ---------------------------------------------------------------------------

loc_59FDC:
                lea     ChildObjDat_5A092(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #byte_5A0B0,$30(a1)
                rts
; ---------------------------------------------------------------------------

loc_59FF0:
                lea     ChildObjDat_5A09A(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #byte_5A0B9,$30(a1)
                rts
; ---------------------------------------------------------------------------

loc_5A004:
                move.b  #6,routine(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #7,$2E(a0)
                move.l  #loc_5A024,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5A020:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5A024:
                move.b  #2,routine(a0)
                move.b  #1,mapping_frame(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_5A03C:
                lea     word_5A07A(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_5A05C,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #signextendB(sfx_Laser),d0
                jsr     (Play_SFX).l

loc_5A05C:
                addq.w  #1,$3A(a0)
                jsr     Animate_RawMultiDelay(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
ObjDat_Corkey:
                dc.l    Map_Corkey
                dc.w    make_art_tile(ArtTile_Corkey,1,0)
                dc.w    $280
                dc.b    $10,  $C,   0,  $B
word_5A074:
                dc.w    $280
                dc.b    8,   4,   1,   0
word_5A07A:
                dc.w    make_art_tile(ArtTile_Corkey,0,0)
                dc.w    $280
                dc.b    4, $50,   0, $A0
ChildObjDat_5A082:
                dc.w    1-1
                dc.l    loc_59F5A
                dc.b    0,  $C
ChildObjDat_5A08A:
                dc.w    1-1
                dc.l    loc_5A03C
                dc.b    -4, $54
ChildObjDat_5A092:
                dc.w    1-1
                dc.l    loc_5A03C
                dc.b    4, $54
ChildObjDat_5A09A:
                dc.w    1-1
                dc.l    loc_5A03C
                dc.b    0, $54
byte_5A0A2:
                dc.b    7, $10
                dc.b    1,   3
                dc.b    $FC
byte_5A0A7:
                dc.b    6,   0
                dc.b    6,   0
                dc.b    7,   4
                dc.b    5,   0
                dc.b    $F4
byte_5A0B0:
                dc.b    5,   0
                dc.b    5,   0
                dc.b    7,   4
                dc.b    6,   0
                dc.b    $F4
byte_5A0B9:
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    6,   3
                dc.b    $F4
                even
