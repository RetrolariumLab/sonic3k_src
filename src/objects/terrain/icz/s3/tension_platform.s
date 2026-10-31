; Owner: objects/terrain/icz/s3
; Responsibility: IceCap tension platform mechanics, collision helpers and private child construction data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZTensionPlatform:
                lea     ObjDat_ICZTensionPlatform(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_5904E,(a0)
                move.w  y_pos(a0),$30(a0)
                lea     ChildObjDat_59268(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_5904E:
                bsr.w   sub_590E8
                bsr.w   sub_591B4
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_5905A:
                lea     word_59260(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_5908A,(a0)
                tst.b   subtype(a0)
                beq.s   loc_59074
                bset    #0,render_flags(a0)

loc_59074:
                bset    #6,render_flags(a0)
                move.w  #2,mainspr_childsprites(a0)
                bsr.w   sub_59092
                move.b  #8,mapping_frame(a0)

loc_5908A:
                bsr.w   sub_590C8
                jmp     Child_Draw_Sprite(pc)

; =============== S U B R O U T I N E =======================================

sub_59092:
                lea     sub2_x_pos(a0),a1
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                moveq   #0,d2
                moveq   #1,d3

loc_590A2:
                move.w  d0,d4
                move.w  word_590C4(pc,d2.w),d5
                btst    #0,render_flags(a0)
                beq.s   loc_590B2
                neg.w   d5

loc_590B2:
                add.w   d5,d4
                move.w  d4,(a1)+
                move.w  d1,(a1)+
                move.w  #8,(a1)+
                addq.w  #2,d2
                dbf     d3,loc_590A2
                rts
; End of function sub_59092

; ---------------------------------------------------------------------------
word_590C4:
                dc.w    $C,   $18

; =============== S U B R O U T I N E =======================================

sub_590C8:
                movea.w parent3(a0),a1
                lea     sub2_y_pos(a0),a2
                move.w  y_pos(a0),d0
                move.w  y_pos(a1),d1
                move.w  d1,d2
                sub.w   d0,d1
                asr.w   #1,d1
                add.w   d0,d1
                move.w  d1,(a2)
                addq.w  #6,a2
                move.w  d2,(a2)
                rts
; End of function sub_590C8

; =============== S U B R O U T I N E =======================================

sub_590E8:
                btst    #2,$38(a0)
                beq.s   locret_5916E
                move.w  #$80,d0
                move.w  y_pos(a0),d1
                move.w  sub2_y_pos(a0),d2
                move.b  $39(a0),d3
                sub.w   $32(a0),d1
                scs     $39(a0)
                bcs.s   loc_59110
                neg.w   d0
                bra.w   loc_59112
; ---------------------------------------------------------------------------

loc_59110:
                neg.w   d1

loc_59112:
                cmp.b   $39(a0),d3
                beq.s   loc_59142
                add.w   d0,d2
                add.w   d0,d2
                cmpi.w  #-$80,d2
                bge.s   loc_59130
                cmpi.w  #-$400,d2
                bgt.s   loc_59142
                bsr.w   sub_59170
                bra.w   loc_59142
; ---------------------------------------------------------------------------

loc_59130:
                cmpi.w  #$80,d2
                bgt.s   loc_59142
                cmpi.w  #1,d1
                bhi.s   loc_59142
                bclr    #2,$38(a0)

loc_59142:
                add.w   d0,d2
                move.w  #-$900,d3
                cmp.w   d3,d2
                bge.s   loc_59150
                bra.w   loc_59156
; ---------------------------------------------------------------------------

loc_59150:
                neg.w   d3
                cmp.w   d3,d2
                ble.s   loc_59158

loc_59156:
                move.w  d3,d2

loc_59158:
                move.w  d2,y_vel(a0)
                jsr     (MoveSprite2).l
                cmpi.w  #$50,d1
                blo.s   locret_5916E
                move.w  #-$100,y_vel(a0)

locret_5916E:
                rts
; End of function sub_590E8

; =============== S U B R O U T I N E =======================================

sub_59170:
                move.b  $3A(a0),d3
                andi.b  #standing_mask,d3
                beq.s   locret_591B2
                btst    #p1_standing_bit,d3
                beq.s   loc_59188
                lea     (Player_1).w,a1
                bsr.w   sub_59192

loc_59188:
                btst    #p2_standing_bit,d3
                beq.s   locret_591B2
                lea     (Player_2).w,a1
; End of function sub_59170

; =============== S U B R O U T I N E =======================================

sub_59192:
                move.w  d2,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)

locret_591B2:
                rts
; End of function sub_59192

; =============== S U B R O U T I N E =======================================

sub_591B4:
                move.b  status(a0),$3A(a0)
                move.w  (Player_1+y_vel).w,-(sp)
                move.w  (Player_2+y_vel).w,-(sp)
                moveq   #$23,d1
                moveq   #$14,d2
                moveq   #$B,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                move.l  (sp)+,d0
                move.b  status(a0),d1
                move.b  $3A(a0),d2
                move.b  d1,$3A(a0)
                eor.b   d1,d2
                andi.b  #standing_mask,d2
                beq.s   locret_59214
                bsr.w   sub_59236
                bset    #2,$38(a0)
                clr.b   $39(a0)
                moveq   #p1_standing_bit,d4
                btst    d4,d2
                beq.s   loc_59204
                lea     (Player_1).w,a1
                bsr.w   sub_59216

loc_59204:
                moveq   #p2_standing_bit,d4
                btst    d4,d2
                beq.s   locret_59214
                swap    d0
                lea     (Player_2).w,a1
                bsr.w   sub_59216

locret_59214:
                rts
; End of function sub_591B4

; =============== S U B R O U T I N E =======================================

sub_59216:
                move.w  y_vel(a0),d5
                btst    d4,d1
                bne.s   loc_59228
                tst.w   d0
                bpl.s   loc_59228
                add.w   d5,y_vel(a1)
                neg.w   d0

loc_59228:
                add.w   d0,d5
                move.w  d5,d6
                asr.w   #2,d6
                sub.w   d6,d5
                move.w  d5,y_vel(a0)
                rts
; End of function sub_59216

; =============== S U B R O U T I N E =======================================

sub_59236:
                moveq   #0,d5
                btst    #3,d1
                beq.s   loc_59240
                addq.w  #8,d5

loc_59240:
                btst    #4,d1
                beq.s   loc_59248
                addq.w  #8,d5

loc_59248:
                move.w  $30(a0),d3
                add.w   d5,d3
                move.w  d3,$32(a0)
                rts
; End of function sub_59236

; ---------------------------------------------------------------------------
ObjDat_ICZTensionPlatform:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc2,2,0)
                dc.w    $280
                dc.b    $18,  $C, $1F,   0
word_59260:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $40, $40,   8,   0
ChildObjDat_59268:
                dc.w    2-1
                dc.l    loc_5905A
                dc.b    -$38,   0
                dc.l    loc_5905A
                dc.b    $38,   0
