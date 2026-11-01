; Owner: objects/terrain/icz/sk
; Responsibility: IceCap swinging platform states, linked children, motion helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZSwingingPlatform:
                lea     ObjDat_ICZSwingingPlatform(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_8AD20,(a0)
                lea     ChildObjDat_8B164(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  a1,parent3(a0)
                rts
; ---------------------------------------------------------------------------

loc_8AD20:
                btst    #3,$38(a0)
                beq.s   loc_8AD3C
                move.l  #loc_8AD40,(a0)
                btst    #0,render_flags(a0)
                beq.s   loc_8AD3C
                move.l  #loc_8ADCA,(a0)

loc_8AD3C:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_8AD40:
                move.w  $3E(a0),d0
                subi.w  #$10,d0
                move.w  d0,$3E(a0)
                move.w  $3C(a0),d1
                add.w   d0,d1
                scc     d2
                tst.w   d0
                bpl.s   loc_8AD5C
                tst.b   d2
                bne.s   loc_8AD82

loc_8AD5C:
                move.w  d1,$3C(a0)
                tst.b   subtype(a0)
                beq.s   loc_8AD72
                cmpi.w  #$4800,d1
                blo.s   loc_8AD72
                cmpi.w  #$200,d0
                bhs.s   loc_8AD9C

loc_8AD72:
                cmpi.w  #$6E00,d1
                bhs.s   loc_8AD7E
                moveq   #1,d2
                jsr     MoveSprite_CircularSimple(pc)

loc_8AD7E:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_8AD82:
                move.l  #loc_8AD20,(a0)
                bclr    #3,$38(a0)
                clr.w   $3C(a0)
                moveq   #1,d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_8AD9C:
                move.l  #loc_8AE0C,(a0)
                bset    #2,$38(a0)
                move.b  #$10,y_radius(a0)
                move.w  #$400,d0
                btst    #0,render_flags(a0)
                beq.s   loc_8ADBC
                neg.w   d0

loc_8ADBC:
                move.w  d0,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_8ADCA:
                move.w  $3E(a0),d0
                addi.w  #$10,d0
                move.w  d0,$3E(a0)
                move.w  $3C(a0),d1
                add.w   d0,d1
                scs     d2
                tst.w   d0
                bmi.s   loc_8ADE6
                tst.b   d2
                bne.s   loc_8AD82

loc_8ADE6:
                move.w  d1,$3C(a0)
                tst.b   subtype(a0)
                beq.s   loc_8ADFC
                cmpi.w  #-$4800,d1
                bhi.s   loc_8ADFC
                cmpi.w  #$200,d0
                bhs.s   loc_8AD9C

loc_8ADFC:
                cmpi.w  #-$6E00,d1
                bls.s   loc_8AE08
                moveq   #1,d2
                jsr     MoveSprite_CircularSimple(pc)

loc_8AE08:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_8AE0C:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   loc_8AE40
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_8AE40
                add.w   d1,y_pos(a0)
                move.w  y_vel(a0),d0
                cmpi.w  #$100,d0
                blo.s   loc_8AE44
                asr.w   #2,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                lea     ChildObjDat_8B17E(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_8AE40:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_8AE44:
                move.l  #loc_8AE62,(a0)
                move.w  #$10,d0
                tst.w   x_vel(a0)
                bmi.s   loc_8AE56
                neg.w   d0

loc_8AE56:
                move.w  d0,$40(a0)
                clr.w   y_vel(a0)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_8AE62:
                move.w  x_vel(a0),d0
                move.w  d0,d1
                add.w   $40(a0),d0
                eor.w   d0,d1
                bmi.s   loc_8AE96
                move.w  d0,x_vel(a0)
                move.w  x_pos(a0),d1
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                eor.w   d0,d1
                btst    #3,d1
                beq.s   loc_8AE92
                lea     ChildObjDat_8B18C(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_8AE92:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_8AE96:
                move.l  #loc_8AEA0,(a0)
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_8AEA0:
                jmp     Sprite_CheckDeleteTouch2(pc)
; ---------------------------------------------------------------------------

loc_8AEA4:
                lea     word_8B158(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_8AEB2,(a0)

loc_8AEB2:
                bsr.w   UpdateIczSwingLedgeCollisionAndRiderImpulse
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_8AEBA:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   loc_8AECC
                move.l  #loc_8AEB2,(a0)

loc_8AECC:
                bsr.w   RefreshAndCollideIczSwingMainLedge
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_8AED4:
                lea     word_8B15E(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_8AEE2,(a0)

loc_8AEE2:
                bsr.w   RefreshAndCollideIczSwingSideLedge
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_8AEEA:
                lea     word_8B144(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_8AF32,(a0)
                subi.w  #$80,y_pos(a0)
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   loc_8AF10
                bset    #0,render_flags(a0)

loc_8AF10:
                bset    #6,render_flags(a0)
                move.w  #7,mainspr_childsprites(a0)
                lea     sub2_mapframe-1(a0),a1
                moveq   #7-1,d6

loc_8AF22:
                move.w  #8,(a1)
                addq.w  #next_subspr,a1
                dbf     d6,loc_8AF22
                move.b  #8,mapping_frame(a0)

loc_8AF32:
                bsr.w   SpawnIczSwingChainDebrisWhenPlatformDetaches
                bsr.w   BuildIczSwingChainIntermediateSpritePositions
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_8AF3E:
                lea     ObjDat3_8B14C(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_8AF9E,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_8AF86(pc,d0.w),d1
                neg.w   d1
                move.w  d1,y_vel(a0)
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                bne.s   loc_8AF6A
                neg.w   d1

loc_8AF6A:
                move.w  d1,x_vel(a0)
                lsr.w   #1,d0
                move.b  byte_8AF96(pc,d0.w),d0
                movea.w parent3(a0),a1
                move.w  (a1,d0.w),x_pos(a0)
                move.w  sub2_y_pos-sub2_x_pos(a1,d0.w),y_pos(a0)
                rts
; ---------------------------------------------------------------------------
word_8AF86:
                dc.w    $80
                dc.w    $100
                dc.w    $180
                dc.w    $200
                dc.w    $280
                dc.w    $300
                dc.w    $380
                dc.w    $400
byte_8AF96:
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

loc_8AF9E:
                jmp     MoveChkDel(pc)

; =============== S U B R O U T I N E =======================================

BuildIczSwingChainIntermediateSpritePositions:
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

loc_8AFC6:
                move.l  d1,d2
                move.w  off_8AFE0(pc,d5.w),d4
                jsr     off_8AFE0(pc,d4.w)
                move.l  d0,(a2)
                swap    d2
                add.l   d2,(a2)+
                addq.w  #2,a2
                addq.w  #2,d5
                dbf     d6,loc_8AFC6
                rts
; End of function BuildIczSwingChainIntermediateSpritePositions

; ---------------------------------------------------------------------------
off_8AFE0:
                dc.w    loc_8AFF0-off_8AFE0
                dc.w    loc_8AFF8-off_8AFE0
                dc.w    loc_8B000-off_8AFE0
                dc.w    loc_8B014-off_8AFE0
                dc.w    loc_8B01C-off_8AFE0
                dc.w    loc_8B030-off_8AFE0
                dc.w    loc_8B044-off_8AFE0
                dc.w    locret_8B052-off_8AFE0
; ---------------------------------------------------------------------------

loc_8AFF0:
                asr.w   #3,d2
                swap    d2
                asr.w   #3,d2
                rts
; ---------------------------------------------------------------------------

loc_8AFF8:
                asr.w   #2,d2
                swap    d2
                asr.w   #2,d2
                rts
; ---------------------------------------------------------------------------

loc_8B000:
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

loc_8B014:
                asr.w   #1,d2
                swap    d2
                asr.w   #1,d2
                rts
; ---------------------------------------------------------------------------

loc_8B01C:
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

loc_8B030:
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

loc_8B044:
                move.w  d2,d3
                asr.w   #3,d3
                sub.w   d3,d2
                swap    d2
                move.w  d2,d3
                asr.w   #3,d3
                sub.w   d3,d2

locret_8B052:
                rts

; =============== S U B R O U T I N E =======================================

RefreshAndCollideIczSwingMainLedge:
                move.w  x_pos(a0),-(sp)
                jsr     Refresh_ChildPosition(pc)
                moveq   #$2B,d1
                moveq   #8,d2
                moveq   #8,d3
                move.w  (sp)+,d4
                jmp     (SolidObjectFull).l
; End of function RefreshAndCollideIczSwingMainLedge

; =============== S U B R O U T I N E =======================================

RefreshAndCollideIczSwingSideLedge:
                move.w  x_pos(a0),-(sp)
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #$F,d1
                moveq   #8,d2
                moveq   #8,d3
                move.w  (sp)+,d4
                jmp     (SolidObjectFull).l
; End of function RefreshAndCollideIczSwingSideLedge

; =============== S U B R O U T I N E =======================================

UpdateIczSwingLedgeCollisionAndRiderImpulse:
                move.b  status(a0),$39(a0)
                bsr.s   RefreshAndCollideIczSwingMainLedge
                move.b  $39(a0),d0
                move.b  status(a0),d1
                andi.b  #standing_mask,d1
                beq.s   locret_8B0AE
                movea.w parent3(a0),a2
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d2
                bsr.w   StartIczPlatformSwingFromRiderHorizontalSpeed
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d2
                bsr.w   StartIczPlatformSwingFromRiderHorizontalSpeed

locret_8B0AE:
                rts
; End of function UpdateIczSwingLedgeCollisionAndRiderImpulse

; =============== S U B R O U T I N E =======================================

StartIczPlatformSwingFromRiderHorizontalSpeed:
                btst    d2,d1
                beq.s   locret_8B0AE
                move.w  x_vel(a1),d3
                smi     d4
                cmpi.w  #-$200,d3
                ble.s   loc_8B0C6
                cmpi.w  #$200,d3
                blt.s   locret_8B0AE

loc_8B0C6:
                btst    d2,d0
                beq.s   loc_8B0CC
                asr.w   #1,d3

loc_8B0CC:
                btst    #0,render_flags(a2)
                beq.s   loc_8B0D6
                not.b   d4

loc_8B0D6:
                tst.b   d4
                bne.s   locret_8B0AE
                move.l  #loc_8AEBA,(a0)
                bset    #3,$38(a2)
                asr.w   #1,d3
                bmi.s   loc_8B0F8
                cmpi.w  #$400,d3
                ble.s   loc_8B102
                move.w  #$400,d3
                bra.w   loc_8B102
; ---------------------------------------------------------------------------

loc_8B0F8:
                cmpi.w  #-$400,d3
                bge.s   loc_8B102
                move.w  #-$400,d3

loc_8B102:
                move.w  d3,$3E(a2)
                asl.w   #1,d3
                move.w  d3,x_vel(a1)
                move.w  d3,ground_vel(a1)
                addq.w  #4,sp

locret_8B112:
                rts
; End of function StartIczPlatformSwingFromRiderHorizontalSpeed

; =============== S U B R O U T I N E =======================================

SpawnIczSwingChainDebrisWhenPlatformDetaches:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   locret_8B112
                move.w  x_pos(a0),sub5_x_pos(a0)
                move.w  y_pos(a0),sub5_y_pos(a0)
                lea     ChildObjDat_8B178(pc),a2
                jsr     CreateChild6_Simple(pc)
                jmp     Go_Delete_Sprite_2(pc)
; End of function SpawnIczSwingChainDebrisWhenPlatformDetaches

; ---------------------------------------------------------------------------
ObjDat_ICZSwingingPlatform:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,1,0)
                dc.w    $80
                dc.b    $20, $10,   7,   0
word_8B144:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    $80, $80,   8,   0
ObjDat3_8B14C:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $280
                dc.b    8,   8,   8,   0
word_8B158:
                dc.w    $300
                dc.b    $20, $10, $27,   0
word_8B15E:
                dc.w    $300
                dc.b    $30,   8, $27,   0
ChildObjDat_8B164:
                dc.w    3-1
                dc.l    loc_8AEA4
                dc.b    0,   8
                dc.l    loc_8AED4
                dc.b    $1C,  -8
                dc.l    loc_8AEEA
                dc.b    0,   0
ChildObjDat_8B178:
                dc.w    8-1
                dc.l    loc_8AF3E
ChildObjDat_8B17E:
                dc.w    2-1
                dc.l    Obj_ICZSnowdust
                dc.b    $1C, $10
                dc.l    Obj_ICZSnowdust
                dc.b    $14, $10
ChildObjDat_8B18C:
                dc.w    1-1
                dc.l    Obj_ICZSnowdust
                dc.b    $1C, $10
