; Owner: objects/enemies/fbz/sk
; Responsibility: Blaster attack and projectile state machines, movement helpers and child resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Blaster:
                jsr     (Obj_WaitOffscreen).l

Obj_Blaster_2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Blaster_Index(pc,d0.w),d1
                jsr     Blaster_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Blaster_Index:
                dc.w    loc_894B6-Blaster_Index
                dc.w    loc_894F2-Blaster_Index
                dc.w    loc_89552-Blaster_Index
                dc.w    loc_8957A-Blaster_Index
                dc.w    loc_895A4-Blaster_Index
                dc.w    loc_895C6-Blaster_Index
                dc.w    loc_895EC-Blaster_Index
                dc.w    loc_895FA-Blaster_Index
; ---------------------------------------------------------------------------

loc_894B6:
                lea     ObjDat_Blaster(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bclr    #1,render_flags(a0)
                beq.s   loc_894CA
                st      $3C(a0)

loc_894CA:
                move.b  #$E,y_radius(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.w  d0,$3A(a0)
                move.l  #loc_8953C,$34(a0)
                move.w  #-$80,d4
                jmp     Set_VelocityXTrackSonic(pc)
; ---------------------------------------------------------------------------

loc_894F2:
                bsr.w   sub_896D6
                jsr     Find_SonicTails(pc)
                tst.w   d1
                bne.s   loc_89512
                cmpi.w  #$80,d2
                bhs.s   loc_89512
                btst    #0,render_flags(a0)
                beq.s   loc_8950E
                subq.w  #2,d0

loc_8950E:
                tst.w   d0
                beq.s   loc_89528

loc_89512:
                lea     byte_8975E(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jsr     (MoveSprite2).l
                jsr     ObjHitFloor2_DoRoutine(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_89528:
                move.b  #6,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.b  #$10,$39(a0)
                rts
; ---------------------------------------------------------------------------

loc_8953C:
                move.b  #4,routine(a0)
                move.w  #$20,$2E(a0)
                move.l  #loc_8955A,$34(a0)

locret_89550:
                rts
; ---------------------------------------------------------------------------

loc_89552:
                bsr.w   sub_896D6
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_8955A:
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  $3A(a0),$2E(a0)

loc_8956A:
                move.b  #2,routine(a0)
                move.l  #loc_8953C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8957A:
                bsr.w   sub_896D6
                subq.b  #1,$39(a0)
                bpl.w   locret_89550
                move.b  #8,routine(a0)
                move.l  #loc_8956A,$34(a0)
                lea     ChildObjDat_89726(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_8972E(pc),a2
                jmp     CreateChild5_ComplexAdjusted(pc)
; ---------------------------------------------------------------------------

loc_895A4:
                bsr.w   sub_896D6
                lea     byte_89768(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   locret_895C4
                cmpi.b  #6,anim_frame(a0)
                bne.s   locret_895C4
                lea     ChildObjDat_89746(pc),a2
                jsr     CreateChild5_ComplexAdjusted(pc)

locret_895C4:
                rts
; ---------------------------------------------------------------------------

loc_895C6:
                addi.w  #-$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   locret_895EA
                add.w   d1,y_pos(a0)
                move.b  #$C,routine(a0)
                clr.w   y_vel(a0)

locret_895EA:
                rts
; ---------------------------------------------------------------------------

loc_895EC:
                tst.b   (_unkF7C1).w
                bne.s   locret_895F8
                move.b  #$E,routine(a0)

locret_895F8:
                rts
; ---------------------------------------------------------------------------

loc_895FA:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   locret_89624
                add.w   d1,y_pos(a0)
                move.b  $3D(a0),routine(a0)
                move.w  $3E(a0),x_vel(a0)
                clr.w   y_vel(a0)

locret_89624:
                rts
; ---------------------------------------------------------------------------

loc_89626:
                lea     word_89708(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_8963E,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8963E:
                jsr     Refresh_ChildPositionAdjusted(pc)
                lea     byte_89763(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_89650:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_89662(pc,d0.w),d1
                jsr     off_89662(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
off_89662:
                dc.w    loc_89666-off_89662
                dc.w    loc_8968A-off_89662
; ---------------------------------------------------------------------------

loc_89666:
                lea     ObjDat_Blaster(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_8969E,$34(a0)
                move.b  #$E,y_radius(a0)
                moveq   #8,d0
                jsr     (Set_IndexedVelocity).l
                jmp     (Change_FlipXWithVelocity).l
; ---------------------------------------------------------------------------

loc_8968A:
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.w   locret_89550
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_8969E:
                move.l  #Obj_Blaster_2,(a0)
                move.b  #2,routine(a0)
                move.w  #$3F,$2E(a0)
                move.w  #$7F,$3A(a0)
                move.l  #loc_8953C,$34(a0)
                move.w  #-$80,d0
                btst    #0,render_flags(a0)
                beq.s   loc_896CC
                neg.w   d0

loc_896CC:
                move.w  d0,x_vel(a0)
                clr.w   y_vel(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_896D6:
                tst.b   $3C(a0)
                beq.s   locret_896FA
                tst.b   (_unkF7C1).w
                beq.s   locret_896FA
                move.b  routine(a0),$3D(a0)
                move.b  #$A,routine(a0)
                move.w  x_vel(a0),$3E(a0)
                clr.w   x_vel(a0)
                addq.w  #4,sp

locret_896FA:
                rts
; End of function sub_896D6

; ---------------------------------------------------------------------------
ObjDat_Blaster:
                dc.l    Map_Blaster
                dc.w    make_art_tile(ArtTile_Blaster,1,1)
                dc.w    $280
                dc.b    $18, $10,   0,  $A
word_89708:
                dc.w    $200
                dc.b    8,   8,   4,   0
ObjDat3_8970E:
                dc.l    Map_Blaster
                dc.w    make_art_tile(ArtTile_Blaster,1,1)
                dc.w    $280
                dc.b    4,   4,   5, $98
ObjDat3_8971A:
                dc.l    Map_Blaster
                dc.w    make_art_tile(ArtTile_Blaster,1,1)
                dc.w    $200
                dc.b    4,   4,   7,   0
ChildObjDat_89726:
                dc.w    1-1
                dc.l    loc_89626
                dc.b    -$1B,-$16
ChildObjDat_8972E:
                dc.w    1-1
                dc.l    loc_86D4A
                dc.l    ObjDat3_8970E
                dc.l    byte_89771
                dc.l    MoveFall_AnimateRaw
                dc.b    -$20,-$20
                dc.w    -$200, -$400
ChildObjDat_89746:
                dc.w    1-1
                dc.l    loc_86D4A
                dc.l    ObjDat3_8971A
                dc.l    byte_89775
                dc.l    MoveFall_AnimateRaw
                dc.b    -$C,  -4
                dc.w    $100, -$200
byte_8975E:
                dc.b    0, $17
                dc.b    1,   2
                dc.b    $FC
byte_89763:
                dc.b    0,   4,   4,   5, $F4
byte_89768:
                dc.b    0,   1
                dc.b    0,   1
                dc.b    2,   5
                dc.b    0, $1F
                dc.b    $F4
byte_89771:
                dc.b    1,   5,   6, $FC
byte_89775:
                dc.b    2,   7,   8,   9,  $A, $FC
                even
Map_Blaster:
                include "src/objects/shared/blaster/mappings/blaster.s"
