; Owner: objects/enemies/aiz/sk
; Responsibility: Monkey Dude patrol and projectile states, helper callbacks and private child data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MonkeyDude:
                jsr     Obj_WaitOffscreen(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MonkeyDude_Index(pc,d0.w),d1
                jsr     MonkeyDude_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
MonkeyDude_Index:
                dc.w    loc_87172-MonkeyDude_Index
                dc.w    loc_871BC-MonkeyDude_Index
                dc.w    loc_871DA-MonkeyDude_Index
; ---------------------------------------------------------------------------

loc_87172:
                lea     ObjDat_MonkeyDude(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #2,d0
                move.b  d0,subtype(a0)
                lsr.w   #1,d0
                move.b  d0,$39(a0)
                move.l  #byte_876B4,$30(a0)
                move.w  #60-1,$2E(a0)
                move.l  #loc_871C2,$34(a0)
                btst    #0,render_flags(a0)
                bne.w   loc_871B4
                lea     ChildObjDat_87680(pc),a2
                jmp     CreateChild4_LinkListRepeated(pc)
; ---------------------------------------------------------------------------

loc_871B4:
                lea     ChildObjDat_87686(pc),a2
                jmp     CreateChild4_LinkListRepeated(pc)
; ---------------------------------------------------------------------------

loc_871BC:
                jmp     (loc_85652).l
; ---------------------------------------------------------------------------

loc_871C2:
                move.b  #4,routine(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #byte_876B8,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_871DA:
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   locret_87202
                btst    #2,$38(a0)
                bne.s   loc_87204
                cmpi.b  #0,mapping_frame(a0)
                bne.s   locret_87202
                addq.w  #8,y_pos(a0)
                subq.b  #1,$39(a0)
                cmpi.b  #1,$39(a0)
                beq.s   loc_87218

locret_87202:
                rts
; ---------------------------------------------------------------------------

loc_87204:
                cmpi.b  #2,mapping_frame(a0)
                bne.s   locret_87202
                subq.b  #1,$39(a0)
                beq.s   loc_87218
                subq.w  #8,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_87218:
                move.b  #2,routine(a0)
                move.b  subtype(a0),$39(a0)
                bchg    #2,$38(a0)
                move.w  #60-1,$2E(a0)
                move.l  #byte_876B4,$30(a0)
                move.b  #0,mapping_frame(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_87248:
                bset    #3,$38(a0)

loc_8724E:
                lea     word_87666(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                clr.b   routine(a0)
                move.b  subtype(a0),d0
                add.b   d0,d0
                move.b  d0,$3B(a0)
                move.b  d0,$3A(a0)
                tst.b   subtype(a0)
                bne.s   loc_87292
                move.l  #loc_872CC,(a0)
                moveq   #$E,d0
                btst    #3,$38(a0)
                bne.s   loc_87280
                neg.w   d0

loc_87280:
                add.w   d0,x_pos(a0)
                subq.w  #2,y_pos(a0)
                move.w  y_pos(a0),$3E(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_87292:
                cmpi.b  #8,subtype(a0)
                beq.s   loc_872A4
                move.l  #loc_8741C,(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_872A4:
                move.l  #loc_8744C,(a0)
                move.b  #6,mapping_frame(a0)
                movea.w parent3(a0),a1
                movea.w parent3(a1),a1
                move.w  a1,$3E(a0)
                movea.w parent3(a1),a1
                movea.w parent3(a1),a1
                move.w  a1,$44(a0)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_872CC:
                bsr.w   FollowMonkeyArmPivotYFromBodyPose
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_872E2(pc,d0.w),d1
                jsr     off_872E2(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_872E2:
                dc.w    loc_872EE-off_872E2
                dc.w    loc_8732A-off_872E2
                dc.w    loc_87382-off_872E2
                dc.w    loc_873B4-off_872E2
                dc.w    loc_873EA-off_872E2
                dc.w    loc_87330-off_872E2
; ---------------------------------------------------------------------------

loc_872EE:
                move.b  $3C(a0),d0
                btst    #3,$38(a0)
                beq.s   loc_87308
                addq.b  #4,d0
                cmpi.b  #$80,d0
                bhs.s   loc_87316
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

loc_87308:
                subq.b  #4,d0
                cmpi.b  #$80,d0
                bls.s   loc_87316
                move.b  d0,$3C(a0)
                rts
; ---------------------------------------------------------------------------

loc_87316:
                move.b  #2,routine(a0)

loc_8731C:
                bsr.w   RandomizeMonkeyArmIdleStepAndWait
                move.l  #loc_87370,$34(a0)

locret_87328:
                rts
; ---------------------------------------------------------------------------

loc_8732A:
                bsr.w   TestMonkeyDudePlayerInThrowDirection
                beq.s   loc_87374

loc_87330:
                btst    #3,$38(a0)
                beq.s   loc_8734E
                move.b  $41(a0),d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                subi.b  #$20,d0
                cmpi.b  #$60,d0
                bhs.s   loc_87360
                bra.w   loc_8736C
; ---------------------------------------------------------------------------

loc_8734E:
                move.b  $41(a0),d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                subi.b  #$80,d0
                cmpi.b  #$60,d0
                blo.s   loc_8736C

loc_87360:
                neg.w   $40(a0)
                move.b  $41(a0),d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep

loc_8736C:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_87370:
                bra.w   RandomizeMonkeyArmIdleStepAndWait
; ---------------------------------------------------------------------------

loc_87374:
                move.b  #4,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_87382:
                btst    #3,$38(a0)
                beq.s   loc_87398
                moveq   #4,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                cmpi.b  #-$40,d0
                bhs.s   loc_873A6
                rts
; ---------------------------------------------------------------------------

loc_87398:
                moveq   #-4,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                cmpi.b  #$40,d0
                bls.s   loc_873A6
                rts
; ---------------------------------------------------------------------------

loc_873A6:
                move.b  #6,routine(a0)
                bset    #2,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_873B4:
                btst    #3,$38(a0)
                beq.s   loc_873CA
                moveq   #-8,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                moveq   #$60,d1
                cmp.b   d1,d0
                bls.s   loc_873D8
                rts
; ---------------------------------------------------------------------------

loc_873CA:
                moveq   #8,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                moveq   #-$60,d1
                cmp.b   d1,d0
                bhs.s   loc_873D8
                rts
; ---------------------------------------------------------------------------

loc_873D8:
                move.b  #8,routine(a0)
                move.b  d1,$3C(a0)
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_873EA:
                btst    #3,$38(a0)
                bne.s   loc_87400
                moveq   #-2,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                moveq   #-$80,d1
                cmp.b   d1,d0
                bls.s   loc_8740E
                rts
; ---------------------------------------------------------------------------

loc_87400:
                moveq   #2,d1
                bsr.w   AdvanceMonkeyArmAngleByByteStep
                moveq   #-$80,d1
                cmp.b   d1,d0
                bhs.s   loc_8740E
                rts
; ---------------------------------------------------------------------------

loc_8740E:
                move.b  #$A,routine(a0)
                move.b  d1,$3C(a0)
                bra.w   loc_8731C
; ---------------------------------------------------------------------------

loc_8741C:
                bsr.w   CopyMonkeyArmLinkParentPriority
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_87432(pc,d0.w),d1
                jsr     off_87432(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_87432:
                dc.w    loc_87438-off_87432
                dc.w    loc_87442-off_87432
                dc.w    loc_8743E-off_87432
; ---------------------------------------------------------------------------

loc_87438:
                moveq   #2,d1
                bsr.w   ActivateMonkeyArmLinkWhenPredecessorSignals

loc_8743E:
                bra.w   loc_8754C
; ---------------------------------------------------------------------------

loc_87442:
                moveq   #4,d1
                bsr.w   AdvanceMonkeyArmLinkWhenPredecessorFlagClears
                bra.w   loc_8754C
; ---------------------------------------------------------------------------

loc_8744C:
                bsr.w   CopyMonkeyArmLinkParentPriority
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_87462(pc,d0.w),d1
                jsr     off_87462(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_87462:
                dc.w    loc_87468-off_87462
                dc.w    loc_87472-off_87462
                dc.w    loc_8746E-off_87462
; ---------------------------------------------------------------------------

loc_87468:
                moveq   #2,d1
                bsr.w   ActivateMonkeyArmLinkWhenPredecessorSignals

loc_8746E:
                bra.w   loc_8754C
; ---------------------------------------------------------------------------

loc_87472:
                bsr.w   TryThrowMonkeyDudeProjectileAtArmPhase
                moveq   #4,d1
                bsr.w   AdvanceMonkeyArmLinkWhenPredecessorFlagClears
                bra.w   loc_8754C
; ---------------------------------------------------------------------------

loc_87480:
                lea     word_8766C(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_874B6,(a0)
                move.l  #byte_876BD,$30(a0)
                move.l  #loc_874CA,$34(a0)
                move.b  #8,y_radius(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

loc_874B6:
                jsr     (MoveSprite_LightGravity).l
                jsr     Animate_RawMultiDelay(pc)
                jsr     ObjHitFloor_DoRoutine(pc)
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

loc_874CA:
                move.l  #loc_874D2,(a0)
                rts
; ---------------------------------------------------------------------------

loc_874D2:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------
; unused
                movea.w parent3(a0),a1
                move.b  render_flags(a1),d0
                btst    #3,$38(a0)
                beq.s   loc_874EC
                bchg    #0,d0

loc_874EC:
                move.w  #$200,priority(a0)
                btst    #0,d0
                beq.s   locret_874FE
                move.w  #$300,priority(a0)

locret_874FE:
                rts

; =============== S U B R O U T I N E =======================================

FollowMonkeyArmPivotYFromBodyPose:
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                subq.w  #2,d0
                tst.b   mapping_frame(a1)
                beq.s   loc_87512
                subq.w  #2,d0

loc_87512:
                move.w  d0,y_pos(a0)
                rts
; End of function FollowMonkeyArmPivotYFromBodyPose

; =============== S U B R O U T I N E =======================================

CopyMonkeyArmLinkParentPriority:
                movea.w parent3(a0),a1
                move.w  priority(a1),priority(a0)
                rts
; End of function CopyMonkeyArmLinkParentPriority

; =============== S U B R O U T I N E =======================================

TestMonkeyDudePlayerInThrowDirection:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                bhs.s   loc_8753C
                btst    #3,$38(a0)
                beq.s   loc_87538
                subq.w  #2,d0

loc_87538:
                tst.w   d0
                rts
; ---------------------------------------------------------------------------

loc_8753C:
                moveq   #1,d4
                rts
; End of function TestMonkeyDudePlayerInThrowDirection

; =============== S U B R O U T I N E =======================================

AdvanceMonkeyArmAngleByByteStep:
                move.b  $3C(a0),d0
                add.b   d1,d0
                move.b  d0,$3C(a0)
                rts
; End of function AdvanceMonkeyArmAngleByByteStep

; ---------------------------------------------------------------------------

loc_8754C:
                subq.b  #1,$3B(a0)
                bne.s   loc_87562
                move.b  $3A(a0),$3B(a0)
                movea.w parent3(a0),a1
                move.b  $3C(a1),$3C(a0)

loc_87562:
                moveq   #5,d2
                jsr     MoveSprite_CircularSimple(pc)
                rts

; =============== S U B R O U T I N E =======================================

ActivateMonkeyArmLinkWhenPredecessorSignals:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   locret_87590
                move.b  d1,routine(a0)
                bset    #1,$38(a0)
                move.b  $3A(a0),d0
                lsr.b   #1,d0
                move.b  d0,$3A(a0)
                move.b  #1,$3B(a0)

locret_87590:
                rts
; End of function ActivateMonkeyArmLinkWhenPredecessorSignals

; =============== S U B R O U T I N E =======================================

AdvanceMonkeyArmLinkWhenPredecessorFlagClears:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.s   locret_875B2
                move.b  d1,routine(a0)
                move.b  $3A(a0),d0
                add.b   d0,d0
                move.b  d0,$3A(a0)
                move.b  #1,$3B(a0)

locret_875B2:
                rts
; End of function AdvanceMonkeyArmLinkWhenPredecessorFlagClears

; =============== S U B R O U T I N E =======================================

TryThrowMonkeyDudeProjectileAtArmPhase:
                btst    #3,$38(a0)
                beq.s   loc_875E0
                btst    #0,$38(a0)
                bne.w   locret_87328
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                beq.s   locret_875DE
                movea.w $3E(a0),a1
                cmpi.b  #-$7C,$3C(a1)
                blo.s   loc_8760A

locret_875DE:
                rts
; ---------------------------------------------------------------------------

loc_875E0:
                btst    #0,$38(a0)
                bne.w   locret_87328
                movea.w $44(a0),a1
                btst    #2,$38(a1)
                beq.s   locret_875DE
                movea.w $3E(a0),a1
                cmpi.b  #$7C,$3C(a1)
                blo.w   locret_87328
                move.w  #make_art_tile(ArtTile_MonkeyDude,1,0),art_tile(a0)

loc_8760A:
                bset    #0,$38(a0)
                move.b  #4,mapping_frame(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l
                lea     (ChildObjDat_8769C).l,a2
                jsr     CreateChild2_Complex(pc)
                bne.s   locret_875DE
                btst    #3,$38(a0)
                beq.s   locret_875DE
                neg.w   x_vel(a1)
                rts
; End of function TryThrowMonkeyDudeProjectileAtArmPhase

; =============== S U B R O U T I N E =======================================

RandomizeMonkeyArmIdleStepAndWait:
                jsr     (Random_Number).l
                move.w  (RNG_seed).w,d0
                moveq   #1,d1
                btst    #0,d0
                beq.s   loc_8764C
                neg.w   d1

loc_8764C:
                move.w  d1,$40(a0)
                andi.w  #$3C,d0
                move.w  d0,$2E(a0)
                rts
; End of function RandomizeMonkeyArmIdleStepAndWait

; ---------------------------------------------------------------------------
ObjDat_MonkeyDude:
                dc.l    Map_MonkeyDude
                dc.w    make_art_tile(ArtTile_MonkeyDude,1,0)
                dc.w    $280
                dc.b    $20, $20,   0,  $B
word_87666:
                dc.w    $300
                dc.b    4,   4,   3,   0
word_8766C:
                dc.w    make_art_tile(ArtTile_MonkeyDude,1,1)
                dc.w    $280
                dc.b    $20, $20,   6,  $B
ObjDat3_87674:
                dc.l    Map_MonkeyDude
                dc.w    make_art_tile(ArtTile_MonkeyDude,0,0)
                dc.w    $280
                dc.b    $20, $20,   6, $98
ChildObjDat_87680:
                dc.w    5-1
                dc.l    loc_8724E
ChildObjDat_87686:
                dc.w    5-1
                dc.l    loc_87248
                dc.w    1-1
                dc.l    loc_8724E
                dc.b    0,   8
                dc.w    1-1
                dc.l    loc_87480
                dc.b    0,   0
ChildObjDat_8769C:
                dc.w    1-1
                dc.l    loc_86D4A
                dc.l    ObjDat3_87674
                dc.l    0
                dc.l    MoveSprite_LightGravity
                dc.b    0,   0
                dc.w    -$200, -$400
byte_876B4:
                dc.b    7,   0,   1, $FC
byte_876B8:
                dc.b    0,   7
                dc.b    2,   7
                dc.b    $FC
byte_876BD:
                dc.b    8,  $F
                dc.b    8,  $F
                dc.b    9,  $F
                dc.b    $A,  $F
                dc.b    $F8, .jump-byte_876BD

                .jump:
                dc.b    6, $7E
                dc.b    $FC
                even
