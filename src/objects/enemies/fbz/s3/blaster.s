; Owner: objects/enemies/fbz/s3
; Responsibility: Blaster attack and projectile state machines, movement helpers and child resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Blaster:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Blaster_Index(pc,d0.w),d1
                jsr     Blaster_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Blaster_Index:
                dc.w    loc_5726A-Blaster_Index
                dc.w    loc_572B2-Blaster_Index
                dc.w    loc_5731C-Blaster_Index
                dc.w    loc_5731C-Blaster_Index
                dc.w    loc_57362-Blaster_Index
                dc.w    loc_57384-Blaster_Index
                dc.w    loc_573AC-Blaster_Index
                dc.w    loc_573BC-Blaster_Index
; ---------------------------------------------------------------------------

loc_5726A:
                lea     ObjDat_Blaster(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$10,y_radius(a0)
                bset    #1,render_flags(a0)
                bclr    #1,render_flags(a0)
                beq.s   loc_5728A
                st      $3C(a0)

loc_5728A:
                move.b  #$E,y_radius(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.w  d0,$3A(a0)
                move.l  #loc_57306,$34(a0)
                move.w  #-$80,d4
                jmp     Set_VelocityXTrackSonic(pc)
; ---------------------------------------------------------------------------

loc_572B2:
                bsr.w   sub_57414
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.s   loc_572CE
                btst    #0,render_flags(a0)
                beq.s   loc_572CA
                subq.w  #2,d0

loc_572CA:
                tst.w   d0
                beq.s   loc_572E4

loc_572CE:
                lea     byte_5749A(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jsr     (MoveSprite2).l
                jsr     ObjHitFloor2_DoRoutine(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_572E4:
                move.b  #6,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.w  $2E(a0),$3A(a0)
                move.w  #$10,$2E(a0)
                move.l  #loc_57344,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_57306:
                move.b  #4,routine(a0)
                move.w  #$20,$2E(a0)
                move.l  #loc_57324,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_5731C:
                bsr.w   sub_57414
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_57324:
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

loc_5732E:
                move.b  #2,routine(a0)
                move.w  $3A(a0),$2E(a0)
                move.l  #loc_57306,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_57344:
                move.b  #8,routine(a0)
                move.l  #loc_5732E,$34(a0)
                lea     ChildObjDat_57462(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_5746A(pc),a2
                jmp     CreateChild5_ComplexAdjusted(pc)
; ---------------------------------------------------------------------------

loc_57362:
                bsr.w   sub_57414
                lea     byte_574A4(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   locret_57382
                cmpi.b  #6,anim_frame(a0)
                bne.s   locret_57382
                lea     ChildObjDat_57482(pc),a2
                jsr     CreateChild5_ComplexAdjusted(pc)

locret_57382:
                rts
; ---------------------------------------------------------------------------

loc_57384:
                addi.w  #-$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bmi.s   loc_5739C
                rts
; ---------------------------------------------------------------------------

loc_5739C:
                add.w   d1,y_pos(a0)
                move.b  #$C,routine(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_573AC:
                tst.b   (_unkFAA2).w
                beq.s   loc_573B4
                rts
; ---------------------------------------------------------------------------

loc_573B4:
                move.b  #$E,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_573BC:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_573D4
                rts
; ---------------------------------------------------------------------------

loc_573D4:
                add.w   d1,y_pos(a0)
                move.b  $3D(a0),routine(a0)
                move.w  $3E(a0),x_vel(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_573EA:
                lea     word_57444(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_57402,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_57402:
                jsr     Refresh_ChildPositionAdjusted(pc)
                lea     byte_5749F(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_57414:
                tst.b   $3C(a0)
                beq.s   locret_57436
                tst.b   (_unkFAA2).w
                beq.s   locret_57436
                move.b  routine(a0),$3D(a0)
                move.b  #$A,routine(a0)
                move.w  x_vel(a0),$3E(a0)
                clr.w   x_vel(a0)

locret_57436:
                rts
; End of function sub_57414

; ---------------------------------------------------------------------------
ObjDat_Blaster:
                dc.l    Map_Blaster
                dc.w    make_art_tile(ArtTile_Blaster-6,1,1)
                dc.w    $280
                dc.b    $18, $10,   0,  $A
word_57444:
                dc.w    $200
                dc.b    8,   8,   4,   0
ObjDat3_5744A:
                dc.l    Map_Blaster
                dc.w    make_art_tile(ArtTile_Blaster-6,1,1)
                dc.w    $280
                dc.b    4,   4,   5, $18
ObjDat3_57456:
                dc.l    Map_Blaster
                dc.w    make_art_tile(ArtTile_Blaster-6,1,1)
                dc.w    $200
                dc.b    4,   4,   7,   0
ChildObjDat_57462:
                dc.w    1-1
                dc.l    loc_573EA
                dc.b    -$1B,-$16
ChildObjDat_5746A:
                dc.w    1-1
                dc.l    loc_54B46
                dc.l    ObjDat3_5744A
                dc.l    byte_574AD
                dc.l    MoveFall_AnimateRaw
                dc.b    -$20,-$20
                dc.w    -$200, -$400
ChildObjDat_57482:
                dc.w    1-1
                dc.l    loc_54B46
                dc.l    ObjDat3_57456
                dc.l    byte_574B1
                dc.l    MoveFall_AnimateRaw
                dc.b    -$C,  -4
                dc.w    $100, -$200
byte_5749A:
                dc.b    0, $17
                dc.b    1,   2
                dc.b    $FC
byte_5749F:
                dc.b    0,   4,   4,   5, $F4
byte_574A4:
                dc.b    0,   1
                dc.b    0,   1
                dc.b    2,   5
                dc.b    0, $1F
                dc.b    $F4
byte_574AD:
                dc.b    1,   5,   6, $FC
byte_574B1:
                dc.b    2,   7,   8,   9,  $A, $FC
                even
