; Owner: game/level/zones/lrz/sk
; Responsibility: Lava Reef act-three autoscroll event, bridge or rock actors, movement helpers and private scene resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZ3Autoscroll:
                move.l  #loc_78F82,(a0)
                move.w  #60-1,$2E(a0)
                lea     (ArtKosM_LRZ3DeathEggFlash).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZ3DeathEggFlash),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_LRZ3PlatformDebris).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZ3PlatformDebris),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_78F82:
                st      (Ctrl_1_locked).w
                st      (Ctrl_2_locked).w
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                subq.w  #1,$2E(a0)
                bpl.s   locret_78FAC
                move.l  #loc_78FAE,(a0)
                jsr     (AllocateObject).l
                bne.s   locret_78FAC
                move.l  #loc_793E2,(a1)

locret_78FAC:
                rts
; ---------------------------------------------------------------------------

loc_78FAE:
                btst    #0,(_unkFAB8).w
                beq.s   locret_78FAC
                move.l  #loc_79002,(a0)
                clr.b   (Ctrl_1_locked).w
                clr.b   (Ctrl_2_locked).w
                lea     ObjDat3_795D2(pc),a1
                jsr     (SetUp_ObjAttributes).l
                clr.b   routine(a0)
                move.w  #-$40,x_pos(a0)
                move.w  #$460,y_pos(a0)
                move.w  #$100,x_vel(a0)
                jsr     (Swing_Setup1).l
                move.w  #$11F,$2E(a0)
                move.l  #loc_79034,$34(a0)
                lea     ChildObjDat_7961A(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_79002:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_79016(pc,d0.w),d1
                jsr     off_79016(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_79016:
                dc.w    loc_7901A-off_79016
                dc.w    loc_79022-off_79016
; ---------------------------------------------------------------------------

loc_7901A:
                moveq   #signextendB(sfx_RobotnikSiren),d0
                jsr     (Play_SFX_Continuous).l

loc_79022:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_79034:
                move.b  #2,routine(a0)
                bset    #1,(_unkFAB8).w
                clr.w   x_vel(a0)
                move.w  #$BF,$2E(a0)
                move.l  #loc_79054,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_79054:
                move.l  #loc_79072,(a0)
                st      (Events_fg_4).w
                clr.w   $2E(a0)
                move.w  #$200,x_vel(a0)
                lea     ChildObjDat_79652(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_79072:
                tst.b   render_flags(a0)
                bpl.s   loc_790A6
                moveq   #signextendB(sfx_RobotnikSiren),d0
                jsr     (Play_SFX_Continuous).l
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  $2E(a0),d0
                addq.w  #1,d0
                move.w  d0,$2E(a0)
                cmpi.w  #$1B0,d0
                blo.s   loc_790A0
                addq.w  #1,y_pos(a0)

loc_790A0:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_790A6:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_790AC:
                lea     word_795F0(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_790D8,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_790D0(pc,d0.w),x_pos(a0)
                move.w  #$4C0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
word_790D0:
                dc.w    $108
                dc.w    $208
                dc.w    $308
                dc.w    $3F8
; ---------------------------------------------------------------------------

loc_790D8:
                move.w  (Camera_X_pos).w,d0
                addi.w  #$120,d0
                cmp.w   x_pos(a0),d0
                bhs.s   loc_790E8
                rts
; ---------------------------------------------------------------------------

loc_790E8:
                move.l  #loc_7910A,(a0)
                moveq   #signextendB(sfx_Targeting),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_79672(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     ChildObjDat_79658(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_7910A:
                btst    #1,$38(a0)
                bne.s   loc_79118
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

loc_79118:
                move.w  x_pos(a0),d0
                subi.w  #$40,d0
                move.w  d0,(Events_bg+$0C).w
                move.w  #$480,(Events_bg+$0E).w
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_79686(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_79142:
                lea     word_795F6(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_79192,(a0)
                move.w  x_pos(a0),$3A(a0)
                move.w  y_pos(a0),$3C(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d0
                move.b  RawAni_7917E(pc,d0.w),mapping_frame(a0)
                add.w   d1,d1
                move.l  word_79182(pc,d1.w),x_vel(a0)   ; and y_vel
                move.w  #$B,$2E(a0)
                rts
; ---------------------------------------------------------------------------
RawAni_7917E:
                dc.b    $E,  $F, $10, $11
                even
word_79182:
                dc.w    $100,     0
                dc.w    -$100,     0
                dc.w    0,  $100
                dc.w    0, -$100
; ---------------------------------------------------------------------------

loc_79192:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   loc_791AA
                move.l  #loc_791B0,(a0)
                move.w  #$F,$2E(a0)

loc_791AA:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_791B0:
                subq.w  #1,$2E(a0)
                bpl.s   loc_791CE
                move.l  #loc_79192,(a0)
                move.w  $3A(a0),x_pos(a0)
                move.w  $3C(a0),y_pos(a0)
                move.w  #$B,$2E(a0)

loc_791CE:
                jmp     (Child_CheckParent).l
; ---------------------------------------------------------------------------

loc_791D4:
                lea     word_795FC(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_791FE,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_791FA(pc,d0.w),y_pos(a0)
                lea     ChildObjDat_79678(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------
word_791FA:
                dc.w    $340,  $2C0
; ---------------------------------------------------------------------------

loc_791FE:
                addq.w  #4,y_pos(a0)
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                subi.w  #$10,d0
                cmp.w   y_pos(a0),d0
                bls.s   loc_7921A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7921A:
                move.l  #loc_79266,(a0)
                bclr    #7,render_flags(a0)
                move.b  #$91,collision_flags(a0)
                move.w  #$1F,$2E(a0)
                addq.w  #8,y_pos(a0)
                lea     (ChildObjDat_690D8).l,a2
                jsr     (CreateChild1_Normal).l
                addi.w  #$18,y_pos(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                tst.b   subtype(a0)
                beq.s   locret_79264
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

locret_79264:
                rts
; ---------------------------------------------------------------------------

loc_79266:
                subq.w  #1,$2E(a0)
                bmi.s   loc_79272
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

loc_79272:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_79278:
                lea     word_795E4(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_79290,(a0)
                move.l  #byte_796B5,$30(a0)

loc_79290:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jsr     (Animate_Raw).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_792AC:
                lea     word_795DE(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_792F0,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_792D0(pc,d0.w),$2E(a0)
                move.w  word_792E0(pc,d0.w),x_vel(a0)
                rts
; ---------------------------------------------------------------------------
word_792D0:
                dc.w    $24,   $64,   $18,   $58,    $C,   $4C,     0,   $40
word_792E0:
                dc.w    -$80,   $80,  -$C0,   $C0, -$100,  $100, -$140,  $140
; ---------------------------------------------------------------------------

loc_792F0:
                btst    #1,(_unkFAB8).w
                bne.s   loc_79304
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_79304:
                move.l  #loc_7931E,$34(a0)
                jsr     (Refresh_ChildPosition).l
                jsr     (Obj_Wait).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_7931E:
                move.l  #loc_79334,(a0)
                move.w  #$14,$2E(a0)
                move.l  #loc_79346,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_79334:
                jsr     (MoveSprite_LightGravity).l
                jsr     (Obj_Wait).l
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

loc_79346:
                move.l  #loc_7935E,(a0)
                moveq   #signextendB(sfx_MissileShoot),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_7964C(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_7935E:
                addi.w  #-$40,y_vel(a0)
                jsr     (MoveSprite2).l
                bsr.w   EmitLrz3RisingActorExhaust
                jmp     (Sprite_CheckDeleteXY).l
; ---------------------------------------------------------------------------

loc_79374:
                lea     word_795E4(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_7938C,(a0)
                move.l  #byte_79694,$30(a0)

loc_7938C:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jsr     (Animate_RawMultiDelay).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_793A8:
                lea     word_795EA(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_793C6,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #$100,y_vel(a0)

loc_793C6:
                lea     byte_796B9(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                addi.w  #-$10,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_793E2:
                lea     ObjDat3_79602(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_79406,(a0)
                move.w  #$B0,x_pos(a0)
                move.w  #$449,y_pos(a0)
                move.l  #loc_79416,$34(a0)

loc_79406:
                lea     byte_7968C(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_79416:
                move.l  #loc_79486,(a0)
                move.b  #$80,(Palette_cycle_counters+$00).w
                move.w  #$F,$2E(a0)
                moveq   #signextendB(sfx_SuperTransform),d0
                jsr     (Play_SFX).l
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($20),d6

loc_7943A:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_7943A
                lea     (Pal_LRZBossFire).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($60),d6

loc_7944C:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_7944C
                jsr     (AllocateObject).l
                bne.s   loc_7946A
                move.l  #loc_85E64,(a1)
                move.w  a1,$44(a0)
                move.w  #3,$3A(a1)

loc_7946A:
                lea     (ArtKosM_LRZ3Autoscroll).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZ3Autoscroll),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_BossExplosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

loc_79486:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.w   locret_78FAC
                move.b  #1,(Palette_cycle_counters+$00).w
                bset    #0,(_unkFAB8).w
                st      (Events_fg_4).w
                moveq   #signextendB(sfx_SuperEmerald),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   loc_794BE
                move.l  #loc_85EE6,(a1)
                move.w  a1,$44(a0)

loc_794BE:
                jsr     (AllocateObject).l
                bne.s   loc_794D8
                move.l  #Obj_CollapsingBridge,(a1)
                move.w  #$60,x_pos(a1)
                move.w  #$4D0,y_pos(a1)

loc_794D8:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_794DE:
                lea     ObjDat3_7960E(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #Obj_FlickerMove,(a0)
                bsr.w   InitializeLrz3PlatformDebrisPiece
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

EmitLrz3RisingActorExhaust:
                tst.w   y_vel(a0)
                bpl.w   locret_78FAC
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.w   locret_78FAC
                lea     ChildObjDat_7967E(pc),a2
                jmp     (CreateChild1_Normal).l
; End of function EmitLrz3RisingActorExhaust

; =============== S U B R O U T I N E =======================================

InitializeLrz3PlatformDebrisPiece:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d0
                move.b  byte_79554(pc,d0.w),mapping_frame(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                lea     byte_79566(pc,d1.w),a2
                move.b  (a2)+,d0
                ext.w   d0
                add.w   d0,d2
                move.b  (a2)+,d0
                ext.w   d0
                add.w   d0,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                add.w   d1,d1
                move.l  word_7958A(pc,d1.w),x_vel(a0)   ; and y_vel
                rts
; End of function InitializeLrz3PlatformDebrisPiece

; ---------------------------------------------------------------------------
byte_79554:
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    1
                dc.b    1
                dc.b    1
                dc.b    3
                dc.b    3
                dc.b    2
                dc.b    2
                dc.b    3
                dc.b    2
                dc.b    2
                dc.b    3
                even
byte_79566:
                dc.b    $20,  -8
                dc.b    -$20, $10
                dc.b    0, $10
                dc.b    $20, $10
                dc.b    -$10, $28
                dc.b    $10, $28
                dc.b    -$10, $10
                dc.b    $10, $10
                dc.b    -$28, $28
                dc.b    $28, $28
                dc.b    -$2C,   4
                dc.b    -$10,   4
                dc.b    $10,   4
                dc.b    $2C,   4
                dc.b    -$20, $20
                dc.b    0, $20
                dc.b    $20, $20
                dc.b    0, $2C
word_7958A:
                dc.w    $200, -$200
                dc.w    -$180, -$180
                dc.w    $80, -$100
                dc.w    $180, -$200
                dc.w    -$180, -$200
                dc.w    $100, -$100
                dc.w    -$200, -$280
                dc.w    $200, -$280
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    -$300, -$400
                dc.w    -$200, -$300
                dc.w    $200, -$300
                dc.w    $300, -$400
                dc.w    -$200, -$380
                dc.w    $100, -$200
                dc.w    $200, -$380
                dc.w    $80, -$100
ObjDat3_795D2:
                dc.l    Map_LRZ3Autoscroll
                dc.w    make_art_tile(ArtTile_LRZ3Autoscroll,1,0)
                dc.w    $300
                dc.b    $20, $20,   0,   0
word_795DE:
                dc.w    $280
                dc.b    4, $10,   1,   0
word_795E4:
                dc.w    $280
                dc.b    $10, $10,   2,   0
word_795EA:
                dc.w    $280
                dc.b    8,   8,   7,   0
word_795F0:
                dc.w    $280
                dc.b    $C,  $C,  $D,   0
word_795F6:
                dc.w    $280
                dc.b    4,   4,  $E,   0
word_795FC:
                dc.w    $280
                dc.b    8, $1C,  $C, $92
ObjDat3_79602:
                dc.l    Map_LRZ3DeathEggFlash
                dc.w    make_art_tile(ArtTile_LRZ3DeathEggFlash,1,0)
                dc.w    $300
                dc.b    $2C, $28,   0,   0
ObjDat3_7960E:
                dc.l    Map_LRZ3Debris
                dc.w    make_art_tile(ArtTile_LRZ3PlatformDebris,3,1)
                dc.w    $80
                dc.b    $C,  $C,   0,   0
ChildObjDat_7961A:
                dc.w    8-1
                dc.l    loc_792AC
                dc.b    -$C,  $C
                dc.l    loc_792AC
                dc.b    $C,  $C
                dc.l    loc_792AC
                dc.b    -$14,  $C
                dc.l    loc_792AC
                dc.b    $14,  $C
                dc.l    loc_792AC
                dc.b    -$14,   4
                dc.l    loc_792AC
                dc.b    $14,   4
                dc.l    loc_792AC
                dc.b    -$18,   4
                dc.l    loc_792AC
                dc.b    $18,   4
ChildObjDat_7964C:
                dc.w    1-1
                dc.l    loc_79374
ChildObjDat_79652:
                dc.w    4-1
                dc.l    loc_790AC
ChildObjDat_79658:
                dc.w    4-1
                dc.l    loc_79142
                dc.b    -$10,   0
                dc.l    loc_79142
                dc.b    $10,   0
                dc.l    loc_79142
                dc.b    0,-$10
                dc.l    loc_79142
                dc.b    0, $10
ChildObjDat_79672:
                dc.w    2-1
                dc.l    loc_791D4
ChildObjDat_79678:
                dc.w    1-1
                dc.l    loc_79278
ChildObjDat_7967E:
                dc.w    1-1
                dc.l    loc_793A8
                dc.b    0, $18
ChildObjDat_79686:
                dc.w    $12-1
                dc.l    loc_794DE
byte_7968C:
                dc.b    4,   0,   0,   1,   2,   3,   4, $F4
byte_79694:
                dc.b    2,   1
                dc.b    2,   1
                dc.b    3,   1
                dc.b    2,   1
                dc.b    3,   1
                dc.b    4,   1
                dc.b    3,   1
                dc.b    4,   1
                dc.b    5,   0
                dc.b    4,   1
                dc.b    5,   0
                dc.b    6,   0
                dc.b    5,   0
                dc.b    $F8, .jump-byte_79694

                .jump:
                dc.b    6,   0
                dc.b    $12,   0
                dc.b    $FC
byte_796B5:
                dc.b    0, $12, $13, $FC
byte_796B9:
                dc.b    6,   2
                dc.b    7,   2
                dc.b    8,   3
                dc.b    9,   4
                dc.b    $A,   5
                dc.b    $B,   5
                dc.b    $F4
                even
                binclude "data/Levels/LRZ/Palettes/Boss Act Fire (Unused).bin"
                even
Pal_LRZBossFire:
                binclude "data/Levels/LRZ/Palettes/Boss Act Fire.bin"
                even
