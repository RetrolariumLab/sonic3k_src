; Owner: objects/bosses/ddz/sk
; Responsibility: Doomsday asteroid actor variants, movement, collisions, fragments and scene effects
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DDZAsteroid:
                move.l  #loc_821FC,(a0)
                move.l  #Map_DDZMissileAsteroid,mappings(a0)
                move.w  #make_art_tile(ArtTile_DDZMisc,1,1),art_tile(a0)
                move.w  #0,priority(a0)
                bsr.w   sub_83146

loc_821FC:
                tst.w   (Debug_placement_mode).w
                bne.s   loc_82208
                jsr     (MoveSprite2).l

loc_82208:
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   loc_82224
                lea     (Player_1).w,a1
                movea.l $30(a0),a2
                jsr     Check_InMyRange(pc)
                bne.s   loc_8222A

loc_82224:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_8222A:
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                move.w  (_unkFA8E).w,d0
                beq.s   loc_82240
                movea.w d0,a2
                move.w  #-$400,x_vel(a2)

loc_82240:
                move.l  (_unkFA82).w,d0
                move.l  #$10000,d1
                sub.l   d1,d0
                cmp.l   d1,d0
                bhs.s   loc_82252
                move.l  d1,d0

loc_82252:
                move.l  d0,(_unkFA82).w
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.b  #$F0,d0
                cmpi.b  #$20,d0
                bne.s   loc_822D8
                moveq   #0,d1
                move.w  y_pos(a0),d2
                sub.w   (Player_1+y_pos).w,d2
                smi     d3
                bpl.s   loc_82276
                neg.w   d2

loc_82276:
                cmpi.w  #$10,d2
                blo.s   loc_82284
                moveq   #4,d1
                tst.b   d3
                beq.s   loc_82284
                moveq   #8,d1

loc_82284:
                lea     off_82346(pc),a2
                movea.l (a2,d1.w),a2
                moveq   #3-1,d4

loc_8228E:
                jsr     (AllocateObject).l
                bne.w   loc_82334
                move.l  #Obj_DDZAsteroid,(a1)
                move.w  x_pos(a0),d2
                add.w   (a2)+,d2
                move.w  d2,x_pos(a1)
                move.w  y_pos(a0),d3
                add.w   (a2)+,d3
                move.w  d3,y_pos(a1)
                move.b  subtype(a0),d0
                andi.b  #$F,d0
                addi.b  #$10,d0
                move.b  d0,subtype(a1)
                dbf     d4,loc_8228E
                lea     word_82376(pc),a1
                adda.w  d1,a1
                move.w  (a1)+,d1
                add.w   d1,x_pos(a0)
                move.w  (a1)+,d1
                add.w   d1,y_pos(a0)

loc_822D8:
                move.b  subtype(a0),d0
                andi.w  #$10,d0
                lsr.w   #2,d0
                lea     off_82382(pc),a2
                movea.l (a2,d0.w),a2
                move.l  #loc_823EE,d1
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  (a2)+,d4

loc_822FA:
                jsr     (AllocateObject).l
                bne.s   loc_82334
                move.l  d1,(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  (a2)+,d5
                ext.w   d5
                add.w   d2,d5
                move.w  d5,x_pos(a1)
                move.b  (a2)+,d5
                ext.w   d5
                add.w   d3,d5
                move.w  d5,y_pos(a1)
                move.w  (a2)+,subtype(a1)
                move.w  (a2)+,x_vel(a1)
                move.w  (a2)+,y_vel(a1)
                dbf     d4,loc_822FA

loc_82334:
                move.w  respawn_addr(a0),d0
                beq.s   loc_82340
                movea.w d0,a2
                bclr    #7,(a2)

loc_82340:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
off_82346:
                dc.l    word_82352
                dc.l    word_8235E
                dc.l    word_8236A
word_82352:
                dc.w    0, $FFE8
                dc.w    $18,     0
                dc.w    0,   $18
word_8235E:
                dc.w    -$18,     0
                dc.w    0,   $18
                dc.w    $18,     0
word_8236A:
                dc.w    -$18,     0
                dc.w    0,  -$18
                dc.w    $18,     0
word_82376:
                dc.w    -$10,     0
                dc.w    0,  -$18
                dc.w    0,   $18
off_82382:
                dc.l    word_8238A
                dc.l    word_823B4
word_8238A:
                dc.w    5-1
                dc.b    -8,   2
                dc.w    0,  -$80,  $140
                dc.b    8,  -4
                dc.w    0,  -$C0, -$100
                dc.b    -4,  -8
                dc.w    $100, -$100, -$200
                dc.b    8,   4
                dc.w    $100, -$200,  $100
                dc.b    4,   8
                dc.w    $100, -$180,  $280
word_823B4:
                dc.w    7-1
                dc.b    -$C,  -4
                dc.w    0,  -$80, -$180
                dc.b    -4,  $C
                dc.w    0, -$100,  $100
                dc.b    6,  -8
                dc.w    0,  -$C0,  -$80
                dc.b    -$C,  $C
                dc.w    $100, -$200,  $100
                dc.b    -4, -$C
                dc.w    $100, -$100,  -$80
                dc.b    8,   8
                dc.w    $100,  -$C0,   $60
                dc.b    0,   0
                dc.w    $100, -$140,   $80
; ---------------------------------------------------------------------------

loc_823EE:
                lea     word_83208(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_82412,(a0)
                move.l  #byte_832A8,$30(a0)
                tst.b   subtype(a0)
                beq.s   loc_82412
                move.l  #byte_832AE,$30(a0)

loc_82412:
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite2).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_8242A:
                lea     ObjDat3_8321A(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_82452,(a0)
                move.b  #6,mapping_frame(a0)
                move.l  #ArtUnc_SuperSonic_Stars,d1
                move.w  #tiles_to_bytes(ArtTile_Shield),d2
                move.w  #$1A0,d3
                jmp     (Add_To_DMA_Queue).l
; ---------------------------------------------------------------------------

loc_82452:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.w   locret_82ABA
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                subq.w  #8,x_pos(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_82494
                move.b  #1,anim_frame_timer(a0)
                move.b  mapping_frame(a0),d0
                addq.b  #1,d0
                cmpi.b  #6,d0
                blo.s   loc_82490
                moveq   #0,d0
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)

loc_82490:
                move.b  d0,mapping_frame(a0)

loc_82494:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8249A:
                lea     ObjDat3_83232(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_824F4,(a0)
                move.w  #$400,x_vel(a0)
                move.b  (V_int_run_count+3).w,d0
                andi.w  #$18,d0
                moveq   #0,d1
                move.b  subtype(a0),d1
                add.w   d1,d0
                move.w  word_824D4(pc,d0.w),y_vel(a0)
                lsl.w   #3,d1
                move.w  d1,$2E(a0)
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------
word_824D4:
                dc.w    -$140
                dc.w    -$120
                dc.w    $100
                dc.w    $E0
                dc.w    -$C0
                dc.w    -$A0
                dc.w    $80
                dc.w    $60
                dc.w    -$80
                dc.w    -$60
                dc.w    $40
                dc.w    $20
                dc.w    -$100
                dc.w    -$E0
                dc.w    $C0
                dc.w    $A0
; ---------------------------------------------------------------------------

loc_824F4:
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.w   locret_82ABA
                move.l  #loc_8253C,(a0)
                move.w  #$10,$2E(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                addi.w  #$20,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),d0
                addi.w  #$20,d0
                move.w  d0,y_pos(a0)
                moveq   #signextendB(sfx_TubeLauncher),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_83294(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_8253C:
                subq.w  #1,$2E(a0)
                bpl.s   loc_82554
                move.l  #loc_8255C,(a0)
                move.w  #$180,priority(a0)
                bset    #7,$38(a0)

loc_82554:
                addq.w  #4,x_pos(a0)
                bra.w   loc_82568
; ---------------------------------------------------------------------------

loc_8255C:
                addi.w  #-$20,x_vel(a0)
                jsr     (MoveSprite2).l

loc_82568:
                lea     byte_832BF(pc),a1
                jsr     Animate_RawNoSST(pc)
                move.w  (_unkFA90).w,d0
                add.w   d0,x_pos(a0)
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                bsr.w   sub_82C28
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_82588:
                move.l  #loc_8259A,(a0)
                lea     word_8323E(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_8259A:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                beq.s   loc_825AC
                move.w  #$100,priority(a0)

loc_825AC:
                lea     byte_832C3(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jsr     Refresh_ChildPosition(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_825BC:
                move.l  #loc_82160,(a0)
                lea     word_831FC(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_825CA:
                lea     ObjDat3_83244(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_82606,(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a0),d0
                addi.w  #$52,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a0),d0
                addi.w  #$5A,d0
                move.w  d0,y_pos(a0)
                move.w  #$200,x_vel(a0)
                move.w  #$200,y_vel(a0)
                move.w  #4,$2E(a0)

loc_82606:
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   loc_82632
                move.l  #loc_82652,(a0)
                move.w  #$80,priority(a0)
                bset    #7,art_tile(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$2E(a0)

loc_82632:
                jsr     (MoveSprite2).l
                move.w  (_unkFA90).w,d0
                add.w   d0,x_pos(a0)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   loc_83038
                jmp     Sprite_CheckDeleteXY(pc)
; ---------------------------------------------------------------------------

loc_82652:
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   loc_82678
                addi.w  #-$40,x_vel(a0)
                move.w  y_vel(a0),d0
                addi.w  #-$20,d0
                bmi.s   loc_8268A
                move.w  d0,y_vel(a0)
                bra.w   loc_8268A
; ---------------------------------------------------------------------------

loc_82678:
                move.b  (V_int_run_count+3).w,d3
                andi.b  #7,d3
                bne.s   loc_8268A
                lea     ChildObjDat_832A2(pc),a2
                jsr     CreateChild6_Simple(pc)

loc_8268A:
                jsr     (MoveSprite2).l
                move.w  (_unkFA90).w,d0
                add.w   d0,x_pos(a0)
                bsr.w   sub_82C28
                jmp     Sprite_CheckDeleteXY(pc)
; ---------------------------------------------------------------------------

loc_826A0:
                lea     word_83202(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_821C2,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$200,y_vel(a0)
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_826CC:
                lea     ObjDat_BossExplosion1(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_826E2,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

loc_826E2:
                movea.w parent3(a0),a1
                tst.b   subtype(a1)
                beq.s   loc_826FC
                move.w  (_unkFAAE).w,d0
                sub.w   d0,x_pos(a0)
                move.w  (_unkFA90).w,d0
                add.w   d0,x_pos(a0)

loc_826FC:
                lea     (AniRaw_BossExplosion).l,a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                move.w  $3A(a0),d0
                add.w   d0,x_vel(a0)
                move.w  $3C(a0),d0
                add.w   d0,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_82722:
                move.w  $3A(a0),d1
                moveq   #0,d0
                cmpi.w  #10,(Ring_count).w
                bhi.s   loc_82732
                moveq   #8,d0

loc_82732:
                cmp.w   d1,d0
                beq.w   locret_82ABA
                move.w  d0,$3A(a0)
                jmp     (Change_Music_Tempo).l
