; Owner: objects/zones/lrz/sk
; Responsibility: Lava Reef rock crusher mechanism, player collision, fragments, movement helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZRockCrusher:
                lea     word_901B8(pc),a1
                tst.b   subtype(a0)
                beq.s   loc_900FE
                lea     word_901C4(pc),a1

loc_900FE:
                jsr     (Check_CameraInRange).l
                move.l  #loc_901D0,(a0)
                move.w  (Camera_min_Y_pos).w,(Camera_stored_min_Y_pos).w
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  (Camera_min_X_pos).w,(Camera_stored_min_X_pos).w
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  (a1),$1C(a0)
                move.w  (a1)+,(Camera_max_X_pos).w
                move.w  (a1)+,(Camera_target_max_Y_pos).w
                lea     ObjDat_LRZRockCrusher(pc),a1
                jsr     (SetUp_ObjAttributes).l
                clr.b   routine(a0)
                move.b  #-1,collision_property(a0)
                move.b  #$40,y_radius(a0)
                tst.b   subtype(a0)
                beq.s   loc_90154
                bset    #7,art_tile(a0)

loc_90154:
                lea     ChildObjDat_9067A(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_90188
                move.b  #$8B,subtype(a1)
                tst.b   subtype(a0)
                bne.s   loc_9017C
                move.w  #$F40,x_pos(a1)
                move.w  #$760,y_pos(a1)
                bra.w   loc_90188
; ---------------------------------------------------------------------------

loc_9017C:
                move.w  #$540,x_pos(a1)
                move.w  #$860,y_pos(a1)

loc_90188:
                lea     (ArtKosM_LRZRockCrusher).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZRockCrusher),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_BossExplosion).l,a1
                jsr     (Load_PLC_Raw).l
                lea     Pal_LRZRockCrusher(pc),a1
                jsr     (PalLoad_Line1).l
                lea     ChildObjDat_90626(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------
word_901B8:
                dc.w    $5E0,  $740,  $DC0,  $EC0,  $EA0,  $6A0
word_901C4:
                dc.w    $680,  $880,  $400,  $780,  $4A0,  $790
; ---------------------------------------------------------------------------

loc_901D0:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_901EA(pc,d0.w),d1
                jsr     off_901EA(pc,d1.w)
                jsr     (sub_905A8).l
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
off_901EA:
                dc.w    loc_901F4-off_901EA
                dc.w    loc_9026E-off_901EA
                dc.w    loc_902F0-off_901EA
                dc.w    loc_902FE-off_901EA
                dc.w    loc_90338-off_901EA
; ---------------------------------------------------------------------------

loc_901F4:
                btst    #0,$27(a0)
                bne.s   loc_90210
                move.w  (Camera_target_max_Y_pos).w,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                bne.s   loc_90210
                move.w  d0,(Camera_min_Y_pos).w
                bset    #0,$27(a0)

loc_90210:
                btst    #1,$27(a0)
                bne.s   loc_9022E
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                move.w  $1C(a0),d0
                cmp.w   (Camera_X_pos).w,d0
                bhi.s   loc_9022E
                bset    #1,$27(a0)

loc_9022E:
                move.b  $27(a0),d0
                andi.b  #3,d0
                cmpi.b  #3,d0
                bne.s   locret_9026C
                move.b  #2,routine(a0)
                clr.b   $27(a0)
                clr.w   $1C(a0)
                clr.b   $26(a0)
                bset    #2,$38(a0)
                jsr     (AllocateObject).l
                bne.s   locret_9026C
                move.l  #loc_90502,(a1)
                move.b  subtype(a0),subtype(a1)
                move.w  a0,parent3(a1)

locret_9026C:
                rts
; ---------------------------------------------------------------------------

loc_9026E:
                moveq   #signextendB(sfx_BigRumble),d0
                jsr     (Play_SFX_Continuous).l
                moveq   #1,d0
                bchg    #0,$38(a0)
                beq.s   loc_90282
                neg.w   d0

loc_90282:
                add.w   d0,y_pos(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_902BE
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_902B6
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmpi.w  #$200,d0
                bls.w   locret_9026C

loc_902B6:
                clr.b   (Screen_shake_flag).w
                bra.w   loc_90368
; ---------------------------------------------------------------------------

loc_902BE:
                move.b  #4,routine(a0)
                ori.b   #$28,$38(a0)
                move.w  #$27,$2E(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_902EC(pc,d0.w),$3A(a0)
                move.w  (Camera_stored_max_Y_pos).w,(Camera_target_max_Y_pos).w
                lea     Child7_ChangeLevSize(pc),a2
                jmp     (CreateChild7_Normal2).l
; ---------------------------------------------------------------------------
word_902EC:
                dc.w    $850
                dc.w    $950
; ---------------------------------------------------------------------------

loc_902F0:
                subq.w  #1,$2E(a0)
                bpl.s   locret_902FC
                move.b  #6,routine(a0)

locret_902FC:
                rts
; ---------------------------------------------------------------------------

loc_902FE:
                jsr     (MoveSprite).l
                move.w  y_pos(a0),d0
                cmp.w   $3A(a0),d0
                bhs.s   loc_90310
                rts
; ---------------------------------------------------------------------------

loc_90310:
                move.b  #8,routine(a0)
                move.w  #$40,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_90352,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                rts
; ---------------------------------------------------------------------------

loc_90338:
                cmpi.w  #$40,$2E(a0)
                bne.s   loc_90346
                bset    #7,status(a0)

loc_90346:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_90352:
                move.l  #Obj_Wait,(a0)
                move.w  #$BF,$2E(a0)
                move.l  #loc_90368,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_90368:
                lea     (ArtKosM_FirewormSegments).l,a1
                move.w  #tiles_to_bytes(ArtTile_FirewormSegments),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_Iwamodoki).l,a1
                move.w  #tiles_to_bytes(ArtTile_Iwamodoki),d2
                jsr     (Queue_Kos_Module).l
                lea     (Pal_LRZ1).l,a1
                jsr     (PalLoad_Line1).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_9039A:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_903C2(pc,d0.w),d1
                jsr     off_903C2(pc,d1.w)
                cmpi.b  #8,subtype(a0)
                blo.s   loc_903BA
                move.b  #-1,collision_property(a0)
                bsr.w   sub_905A8

loc_903BA:
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
off_903C2:
                dc.w    loc_903CC-off_903C2
                dc.w    loc_903F4-off_903C2
                dc.w    loc_90408-off_903C2
                dc.w    loc_90436-off_903C2
                dc.w    loc_904B4-off_903C2
; ---------------------------------------------------------------------------

loc_903CC:
                lea     word_90614(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.b  subtype(a0),d0
                cmpi.b  #8,d0
                blo.s   loc_903EC
                move.b  #2,mapping_frame(a0)
                move.b  #$12,collision_flags(a0)

loc_903EC:
                andi.b  #4,d0
                move.b  d0,$2E(a0)

loc_903F4:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.w   locret_9026C
                move.b  #4,routine(a0)

loc_90408:
                subq.b  #1,$2E(a0)
                bmi.s   loc_90426
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   loc_90420
                move.b  #8,routine(a0)

loc_90420:
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

loc_90426:
                move.b  #6,routine(a0)
                move.b  #2,$39(a0)
                clr.b   $40(a0)

loc_90436:
                move.b  $40(a0),d0
                add.b   d0,$43(a0)
                subq.b  #1,$2E(a0)
                bpl.s   loc_9048A
                subq.b  #1,$39(a0)
                bmi.s   loc_90490
                move.b  subtype(a0),d3
                andi.w  #8,d3
                bne.s   loc_9046E
                btst    #2,$38(a0)
                beq.s   loc_9046E
                bchg    #1,$38(a0)
                bne.s   loc_9046E
                lea     ChildObjDat_90658(pc),a2
                jsr     (CreateChild3_NormalRepeated).l

loc_9046E:
                lsr.w   #1,d3
                moveq   #0,d1
                bchg    #2,$38(a0)
                beq.s   loc_9047C
                moveq   #2,d1

loc_9047C:
                add.w   d1,d3
                lea     byte_904AC(pc,d3.w),a1
                move.b  (a1)+,$2E(a0)
                move.b  (a1)+,$40(a0)

loc_9048A:
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

loc_90490:
                move.b  #4,routine(a0)
                move.b  subtype(a0),d0
                andi.b  #8,d0
                lsr.b   #1,d0
                addq.b  #4,d0
                move.b  d0,$2E(a0)
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------
byte_904AC:
                dc.b    1,   8
                dc.b    3,  -4
                dc.b    3,  -4
                dc.b    7,   2
                even
; ---------------------------------------------------------------------------

loc_904B4:
                jmp     (Refresh_ChildPosition).l
; ---------------------------------------------------------------------------

loc_904BA:
                lea     ObjDat3_9061A(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_43A6C,(a0)
                bset    #7,render_flags(a0)
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                move.w  #$200,d1
                tst.b   subtype(a0)
                beq.s   loc_904E8
                neg.w   d0
                neg.w   d1

loc_904E8:
                add.w   d1,d0
                move.w  d0,x_vel(a0)
                swap    d0
                andi.w  #$1FF,d0
                move.w  #$300,d1
                add.w   d1,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_90502:
                move.l  #loc_90512,(a0)
                move.w  #(3*60)-1,$2E(a0)
                st      (Screen_shake_flag).w

loc_90512:
                subq.w  #1,$2E(a0)
                bpl.w   locret_9026C
                tst.b   subtype(a0)
                bne.s   loc_9056E
                st      (Events_bg+$0C).w
                clr.b   (Screen_shake_flag).w
                jsr     (AllocateObject).l
                bne.s   loc_90548
                move.l  #Obj_LRZCollapsingBridge,(a1)
                move.b  #1,$32(a1)
                move.w  #$F00,x_pos(a1)
                move.w  #$760,y_pos(a1)

loc_90548:
                jsr     (AllocateObject).l
                bne.s   loc_90568
                move.l  #Obj_LRZCollapsingBridge,(a1)
                move.b  #1,$32(a1)
                move.w  #$F80,x_pos(a1)
                move.w  #$760,y_pos(a1)

loc_90568:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_9056E:
                st      (Events_bg+$0D).w
                jsr     (AllocateObject).l
                bne.s   loc_90592
                move.l  #Obj_LRZCollapsingBridge,(a1)
                move.b  #1,$32(a1)
                move.w  #$540,x_pos(a1)
                move.w  #$860,y_pos(a1)

loc_90592:
                move.w  (Camera_stored_max_Y_pos).w,(Camera_target_max_Y_pos).w
                lea     Child7_ChangeLevSize(pc),a2
                jsr     (CreateChild7_Normal2).l
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_905A8:
                tst.b   collision_flags(a0)
                bne.s   locret_905E6
                tst.b   $20(a0)
                bne.s   loc_905C8
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                move.b  #-1,collision_property(a0)

loc_905C8:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_905D6
                addi.w  #2*3,d0

loc_905D6:
                bsr.w   sub_905E8
                subq.b  #1,$20(a0)
                bne.s   locret_905E6
                move.b  $25(a0),collision_flags(a0)

locret_905E6:
                rts
; End of function sub_905A8

; =============== S U B R O U T I N E =======================================

sub_905E8:
                lea     word_905F6(pc),a1
                lea     word_905FC(pc,d0.w),a2
                jmp     (CopyWordData_3).l
; End of function sub_905E8

; ---------------------------------------------------------------------------
word_905F6:
                dc.w    Normal_palette_line_2+$16, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_905FC:
                dc.w    $20,  $866,  $644
                dc.w    $EEE,  $AAA,  $CCC
ObjDat_LRZRockCrusher:
                dc.l    Map_LRZRockCrusher
                dc.w    make_art_tile(ArtTile_LRZRockCrusher,1,0)
                dc.w    $180
                dc.b    $80, $40,   0, $10
word_90614:
                dc.w    $200
                dc.b    $C, $14,   1, $8B
ObjDat3_9061A:
                dc.l    Map_LRZRockDebris
                dc.w    make_art_tile($0D3,2,1)
                dc.w    0
                dc.b    4,   4,   0,   0
ChildObjDat_90626:
                dc.w    8-1
                dc.l    loc_9039A
                dc.b    -$1C, $1C
                dc.l    loc_9039A
                dc.b    $1C, $1C
                dc.l    loc_9039A
                dc.b    -$24, $1C
                dc.l    loc_9039A
                dc.b    $24, $1C
                dc.l    loc_9039A
                dc.b    -$1C,-$24
                dc.l    loc_9039A
                dc.b    $1C,-$24
                dc.l    loc_9039A
                dc.b    -$24,-$24
                dc.l    loc_9039A
                dc.b    $24,-$24
ChildObjDat_90658:
                dc.w    2-1
                dc.l    loc_904BA
                dc.b    0,  $C
Child7_ChangeLevSize:
                dc.w    4-1
                dc.l    Obj_DecLevStartYGradual
                dc.b    0,   0
                dc.l    Obj_IncLevEndYGradual
                dc.b    0,   0
                dc.l    Obj_DecLevStartXGradual
                dc.b    0,   0
                dc.l    Obj_IncLevEndXGradual
                dc.b    0,   0
ChildObjDat_9067A:
                dc.w    1-1
                dc.l    Obj_SpriteMask
Pal_LRZRockCrusher:
                binclude "data/Levels/LRZ/Palettes/Rock Crusher.bin"
                even
