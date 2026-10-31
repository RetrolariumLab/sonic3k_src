; Owner: objects/terrain/icz/s3
; Responsibility: IceCap swinging platform states, linked children, motion helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZSwingingPlatform:
                lea     ObjDat_ICZSwingingPlatform(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_584D8,(a0)
                lea     ChildObjDat_5891C(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  a1,parent3(a0)
                rts
; ---------------------------------------------------------------------------

loc_584D8:
                btst    #3,$38(a0)
                beq.s   loc_584F4
                move.l  #loc_584F8,(a0)
                btst    #0,render_flags(a0)
                beq.s   loc_584F4
                move.l  #loc_58582,(a0)

loc_584F4:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_584F8:
                move.w  $3E(a0),d0
                subi.w  #$10,d0
                move.w  d0,$3E(a0)
                move.w  $3C(a0),d1
                add.w   d0,d1
                scc     d2
                tst.w   d0
                bpl.s   loc_58514
                tst.b   d2
                bne.s   loc_5853A

loc_58514:
                move.w  d1,$3C(a0)
                tst.b   subtype(a0)
                beq.s   loc_5852A
                cmpi.w  #$4800,d1
                blo.s   loc_5852A
                cmpi.w  #$200,d0
                bhs.s   loc_58554

loc_5852A:
                cmpi.w  #$6E00,d1
                bhs.s   loc_58536
                moveq   #1,d2
                jsr     MoveSprite_CircularSimple(pc)

loc_58536:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_5853A:
                move.l  #loc_584D8,(a0)
                bclr    #3,$38(a0)
                clr.w   $3C(a0)
                moveq   #1,d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_58554:
                move.l  #loc_585C4,(a0)
                bset    #2,$38(a0)
                move.b  #$10,y_radius(a0)
                move.w  #$400,d0
                btst    #0,render_flags(a0)
                beq.s   loc_58574
                neg.w   d0

loc_58574:
                move.w  d0,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_58582:
                move.w  $3E(a0),d0
                addi.w  #$10,d0
                move.w  d0,$3E(a0)
                move.w  $3C(a0),d1
                add.w   d0,d1
                scs     d2
                tst.w   d0
                bmi.s   loc_5859E
                tst.b   d2
                bne.s   loc_5853A

loc_5859E:
                move.w  d1,$3C(a0)
                tst.b   subtype(a0)
                beq.s   loc_585B4
                cmpi.w  #-$4800,d1
                bhi.s   loc_585B4
                cmpi.w  #$200,d0
                bhs.s   loc_58554

loc_585B4:
                cmpi.w  #-$6E00,d1
                bls.s   loc_585C0
                moveq   #1,d2
                jsr     MoveSprite_CircularSimple(pc)

loc_585C0:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_585C4:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   loc_585F8
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_585F8
                add.w   d1,y_pos(a0)
                move.w  y_vel(a0),d0
                cmpi.w  #$100,d0
                blo.s   loc_585FC
                asr.w   #2,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                lea     ChildObjDat_58936(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_585F8:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_585FC:
                move.l  #loc_5861A,(a0)
                move.w  #$10,d0
                tst.w   x_vel(a0)
                bmi.s   loc_5860E
                neg.w   d0

loc_5860E:
                move.w  d0,$40(a0)
                clr.w   y_vel(a0)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_5861A:
                move.w  x_vel(a0),d0
                move.w  d0,d1
                add.w   $40(a0),d0
                eor.w   d0,d1
                bmi.s   loc_5864E
                move.w  d0,x_vel(a0)
                move.w  x_pos(a0),d1
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                eor.w   d0,d1
                btst    #3,d1
                beq.s   loc_5864A
                lea     ChildObjDat_58944(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_5864A:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_5864E:
                move.l  #loc_58658,(a0)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_58658:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_5865C:
                lea     word_58910(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_5866A,(a0)

loc_5866A:
                bsr.w   sub_58838
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_58672:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_58684
                move.l  #loc_5866A,(a0)

loc_58684:
                bsr.w   sub_5880C
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_5868C:
                lea     word_58916(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_5869A,(a0)

loc_5869A:
                bsr.w   sub_58822
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_586A2:
                lea     word_588FC(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_586EA,(a0)
                subi.w  #$80,y_pos(a0)
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   loc_586C8
                bset    #0,render_flags(a0)

loc_586C8:
                bset    #6,render_flags(a0)
                move.w  #7,mainspr_childsprites(a0)
                lea     sub2_mapframe-1(a0),a1
                moveq   #7-1,d6

loc_586DA:
                move.w  #8,(a1)
                addq.w  #next_subspr,a1
                dbf     d6,loc_586DA
                move.b  #8,mapping_frame(a0)

loc_586EA:
                bsr.w   sub_588CC
                bsr.w   sub_5875A
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_586F6:
                lea     ObjDat3_58904(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_58756,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_5873E(pc,d0.w),d1
                neg.w   d1
                move.w  d1,y_vel(a0)
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                bne.s   loc_58722
                neg.w   d1

loc_58722:
                move.w  d1,x_vel(a0)
                lsr.w   #1,d0
                move.b  byte_5874E(pc,d0.w),d0
                movea.w parent3(a0),a1
                move.w  (a1,d0.w),x_pos(a0)
                move.w  sub2_y_pos-sub2_x_pos(a1,d0.w),y_pos(a0)
                rts
; ---------------------------------------------------------------------------
word_5873E:
                dc.w    $80
                dc.w    $100
                dc.w    $180
                dc.w    $200
                dc.w    $280
                dc.w    $300
                dc.w    $380
                dc.w    $400
byte_5874E:
                dc.b    sub9_x_pos
                dc.b    sub2_x_pos
                dc.b    sub3_x_pos
                dc.b    sub4_x_pos
                dc.b    sub5_x_pos
                dc.b    sub6_x_pos
                dc.b    sub7_x_pos
                dc.b    sub8_x_pos
                even
; ---------------------------------------------------------------------------

loc_58756:
                jmp     MoveChkDel(pc)

; =============== S U B R O U T I N E =======================================

sub_5875A:
                movea.w parent3(a0),a1
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),d0
                move.w  x_pos(a1),d1
                sub.w   d0,d1
                swap    d0
                swap    d1
                move.w  y_pos(a0),d0
                move.w  y_pos(a1),d1
                sub.w   d0,d1
                moveq   #0,d5
                moveq   #6,d6

loc_5877E:
                move.l  d1,d2
                move.w  off_58798(pc,d5.w),d4
                jsr     off_58798(pc,d4.w)
                move.l  d0,(a2)
                swap    d2
                add.l   d2,(a2)+
                addq.w  #2,a2
                addq.w  #2,d5
                dbf     d6,loc_5877E
                rts
; End of function sub_5875A

; ---------------------------------------------------------------------------
off_58798:
                dc.w    loc_587A8-off_58798
                dc.w    loc_587B0-off_58798
                dc.w    loc_587B8-off_58798
                dc.w    loc_587CC-off_58798
                dc.w    loc_587D4-off_58798
                dc.w    loc_587E8-off_58798
                dc.w    loc_587FC-off_58798
                dc.w    locret_5880A-off_58798
; ---------------------------------------------------------------------------

loc_587A8:
                asr.w   #3,d2
                swap    d2
                asr.w   #3,d2
                rts
; ---------------------------------------------------------------------------

loc_587B0:
                asr.w   #2,d2
                swap    d2
                asr.w   #2,d2
                rts
; ---------------------------------------------------------------------------

loc_587B8:
                asr.w   #2,d2
                move.w  d2,d3
                asr.w   #1,d2
                add.w   d3,d2
                swap    d2
                asr.w   #2,d2
                move.w  d2,d3
                asr.w   #1,d2
                add.w   d3,d2
                rts
; ---------------------------------------------------------------------------

loc_587CC:
                asr.w   #1,d2
                swap    d2
                asr.w   #1,d2
                rts
; ---------------------------------------------------------------------------

loc_587D4:
                asr.w   #1,d2
                move.w  d2,d3
                asr.w   #2,d2
                add.w   d3,d2
                swap    d2
                asr.w   #1,d2
                move.w  d2,d3
                asr.w   #2,d2
                add.w   d3,d2
                rts
; ---------------------------------------------------------------------------

loc_587E8:
                asr.w   #1,d2
                move.w  d2,d3
                asr.w   #1,d2
                add.w   d3,d2
                swap    d2
                asr.w   #1,d2
                move.w  d2,d3
                asr.w   #1,d2
                add.w   d3,d2
                rts
; ---------------------------------------------------------------------------

loc_587FC:
                move.w  d2,d3
                asr.w   #3,d3
                sub.w   d3,d2
                swap    d2
                move.w  d2,d3
                asr.w   #3,d3
                sub.w   d3,d2

locret_5880A:
                rts

; =============== S U B R O U T I N E =======================================

sub_5880C:
                move.w  x_pos(a0),-(sp)
                jsr     Refresh_ChildPosition(pc)
                moveq   #$2B,d1
                moveq   #8,d2
                moveq   #8,d3
                move.w  (sp)+,d4
                jmp     (SolidObjectFull).l
; End of function sub_5880C

; =============== S U B R O U T I N E =======================================

sub_58822:
                move.w  x_pos(a0),-(sp)
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #$F,d1
                moveq   #8,d2
                moveq   #8,d3
                move.w  (sp)+,d4
                jmp     (SolidObjectFull).l
; End of function sub_58822

; =============== S U B R O U T I N E =======================================

sub_58838:
                move.b  status(a0),$39(a0)
                bsr.s   sub_5880C
                move.b  $39(a0),d0
                move.b  status(a0),d1
                andi.b  #standing_mask,d1
                beq.s   locret_58866
                movea.w parent3(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d2
                bsr.w   sub_58868
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d2
                bsr.w   sub_58868

locret_58866:
                rts
; End of function sub_58838

; =============== S U B R O U T I N E =======================================

sub_58868:
                btst    d2,d1
                beq.s   locret_58866
                move.w  x_vel(a1),d3
                smi     d4
                cmpi.w  #-$200,d3
                ble.s   loc_5887E
                cmpi.w  #$200,d3
                blt.s   locret_58866

loc_5887E:
                btst    d2,d0
                beq.s   loc_58884
                asr.w   #1,d3

loc_58884:
                btst    #0,render_flags(a2)
                beq.s   loc_5888E
                not.b   d4

loc_5888E:
                tst.b   d4
                bne.s   locret_58866
                move.l  #loc_58672,(a0)
                bset    #3,$38(a2)
                asr.w   #1,d3
                bmi.s   loc_588B0
                cmpi.w  #$400,d3
                ble.s   loc_588BA
                move.w  #$400,d3
                bra.w   loc_588BA
; ---------------------------------------------------------------------------

loc_588B0:
                cmpi.w  #-$400,d3
                bge.s   loc_588BA
                move.w  #-$400,d3

loc_588BA:
                move.w  d3,$3E(a2)
                asl.w   #1,d3
                move.w  d3,x_vel(a1)
                move.w  d3,ground_vel(a1)
                addq.w  #4,sp

locret_588CA:
                rts
; End of function sub_58868

; =============== S U B R O U T I N E =======================================

sub_588CC:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   locret_588CA
                move.w  x_pos(a0),sub5_x_pos(a0)
                move.w  y_pos(a0),sub5_y_pos(a0)
                lea     ChildObjDat_58930(pc),a2
                jsr     CreateChild6_Simple(pc)
                jmp     Go_Delete_Sprite_2(pc)
; End of function sub_588CC

; ---------------------------------------------------------------------------
ObjDat_ICZSwingingPlatform:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,1,0)
                dc.w    $80
                dc.b    $20, $10,   7,   0
word_588FC:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $80, $80,   8,   0
ObjDat3_58904:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    8,   8,   8,   0
word_58910:
                dc.w    $300
                dc.b    $20, $10, $27,   0
word_58916:
                dc.w    $300
                dc.b    $30,   8, $27,   0
ChildObjDat_5891C:
                dc.w    3-1
                dc.l    loc_5865C
                dc.b    0,   8
                dc.l    loc_5868C
                dc.b    $1C,  -8
                dc.l    loc_586A2
                dc.b    0,   0
ChildObjDat_58930:
                dc.w    8-1
                dc.l    loc_586F6
ChildObjDat_58936:
                dc.w    2-1
                dc.l    Obj_ICZSnowdust
                dc.b    $1C, $10
                dc.l    Obj_ICZSnowdust
                dc.b    $14, $10
ChildObjDat_58944:
                dc.w    1-1
                dc.l    Obj_ICZSnowdust
                dc.b    $1C, $10
