; Owner: objects/enemies/fbz/sk
; Responsibility: Techno Squeek movement and attack states with private child and object resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_TechnoSqueek:
                jsr     (Obj_WaitOffscreen).l

Obj_TechnoSqueek_2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Technosqueek_Index(pc,d0.w),d1
                jsr     Technosqueek_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Technosqueek_Index:
                dc.w    loc_89842-Technosqueek_Index
                dc.w    loc_898DC-Technosqueek_Index
                dc.w    loc_8992E-Technosqueek_Index
                dc.w    loc_8995C-Technosqueek_Index
                dc.w    loc_899A0-Technosqueek_Index
; ---------------------------------------------------------------------------

loc_89842:
                move.w  #$800,$2E(a0)
                move.l  #loc_89926,$34(a0)
                cmpi.b  #4,subtype(a0)
                beq.s   loc_8989E
                lea     ObjDat_89B06(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #byte_89B2C,$30(a0)
                bset    #0,render_flags(a0)
                cmpi.b  #2,subtype(a0)
                bne.s   loc_8987C
                bset    #1,render_flags(a0)

loc_8987C:
                lea     ChildObjDat_89B24(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  #$400,d0
                move.w  d0,$3A(a0)
                move.w  d0,x_vel(a0)
                move.w  #$20,$3C(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_8989E:
                lea     ObjDat3_89B12(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,routine(a0)
                move.l  #byte_89B52,$30(a0)
                bset    #1,render_flags(a0)
                lea     ChildObjDat_89B24(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  #$400,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$20,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_898DC:
                jsr     Animate_RawMultiDelayFlipX(pc)
                tst.w   d2
                beq.s   loc_898F2
                cmpi.b  #6,anim_frame(a0)
                bne.s   loc_898F2
                bset    #1,$38(a0)

loc_898F2:
                jsr     Swing_LeftAndRight(pc)
                tst.w   x_vel(a0)
                beq.s   loc_89906
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_89906:
                move.b  #4,routine(a0)
                move.l  #byte_89B42,$30(a0)
                move.l  #loc_89932,$34(a0)

loc_8991C:
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_89926:
                bclr    #5,$38(a0)

locret_8992C:
                rts
; ---------------------------------------------------------------------------

loc_8992E:
                jmp     Animate_RawAdjustFlipX(pc)
; ---------------------------------------------------------------------------

loc_89932:
                move.b  #2,routine(a0)
                move.l  #byte_89B37,$30(a0)

loc_89940:
                bclr    #1,$38(a0)
                bset    #5,$38(a0)
                move.w  #$10,$2E(a0)
                move.l  #loc_89926,$34(a0)
                bra.s   loc_8991C
; ---------------------------------------------------------------------------

loc_8995C:
                jsr     Animate_RawMultiDelayFlipY(pc)
                tst.w   d2
                beq.s   loc_89972
                cmpi.b  #6,anim_frame(a0)
                bne.s   loc_89972
                bset    #1,$38(a0)

loc_89972:
                jsr     Swing_UpAndDown(pc)
                tst.w   y_vel(a0)
                beq.s   loc_89986
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_89986:
                move.b  #8,routine(a0)
                move.l  #byte_89B68,$30(a0)
                move.l  #loc_899A4,$34(a0)
                bra.w   loc_8991C
; ---------------------------------------------------------------------------

loc_899A0:
                jmp     Animate_RawAdjustFlipY(pc)
; ---------------------------------------------------------------------------

loc_899A4:
                move.b  #6,routine(a0)
                move.l  #byte_89B5D,$30(a0)
                bra.s   loc_89940
; ---------------------------------------------------------------------------

loc_899B4:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_899C6(pc,d0.w),d1
                jsr     off_899C6(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
off_899C6:
                dc.w    loc_899CC-off_899C6
                dc.w    loc_899E8-off_899C6
                dc.w    loc_89A20-off_899C6
; ---------------------------------------------------------------------------

loc_899CC:
                lea     word_89B1E(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                movea.w parent3(a0),a1
                cmpi.b  #4,subtype(a1)
                bne.s   locret_899E6
                move.b  #4,routine(a0)

locret_899E6:
                rts
; ---------------------------------------------------------------------------

loc_899E8:
                lea     byte_89B4D(pc),a1
                jsr     Animate_RawNoSST(pc)
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                btst    #1,$38(a1)
                beq.s   loc_89A04
                moveq   #2,d0

loc_89A04:
                add.w   d0,d0
                move.w  byte_89A1A(pc,d0.w),child_dx(a0)  ; and child_dy
                btst    #5,$38(a1)
                bne.w   locret_8992C
                jmp     Refresh_ChildPositionAdjusted(pc)
; ---------------------------------------------------------------------------
byte_89A1A:
                dc.b    $14,   4
                dc.b    $C,   4
                dc.b    0,   4
                even
; ---------------------------------------------------------------------------

loc_89A20:
                lea     byte_89B73(pc),a1
                jsr     Animate_RawNoSST(pc)
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                subq.w  #5,d0
                btst    #1,$38(a1)
                beq.s   loc_89A3E
                moveq   #2,d0

loc_89A3E:
                add.w   d0,d0
                move.w  byte_89A54(pc,d0.w),child_dx(a0)  ; and child_dy
                btst    #5,$38(a1)
                bne.w   locret_8992C
                jmp     Refresh_ChildPositionAdjusted(pc)
; ---------------------------------------------------------------------------
byte_89A54:
                dc.b    -4, $14
                dc.b    -4,  $C
                dc.b    -4,   0
                even
; ---------------------------------------------------------------------------

loc_89A5A:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_89A6C(pc,d0.w),d1
                jsr     off_89A6C(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
off_89A6C:
                dc.w    loc_89A70-off_89A6C
                dc.w    loc_89AA2-off_89A6C
; ---------------------------------------------------------------------------

loc_89A70:
                lea     ObjDat_89B06(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #7,y_radius(a0)
                move.l  #loc_89AB6,$34(a0)
                move.w  #$90,d0
                jsr     (Set_IndexedVelocity).l
                jsr     (Change_FlipXWithVelocity).l
                clr.b   subtype(a0)
                lea     ChildObjDat_89B24(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_89AA2:
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.w   locret_8992C
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

loc_89AB6:
                move.l  #Obj_TechnoSqueek_2,(a0)
                move.b  #2,routine(a0)
                move.w  #$800,$2E(a0)
                move.l  #loc_89926,$34(a0)
                move.l  #byte_89B2C,$30(a0)
                move.w  #$400,d0
                move.w  d0,$3A(a0)
                bclr    #3,$38(a0)
                btst    #0,render_flags(a0)
                bne.s   loc_89AF6
                neg.w   d0
                bset    #3,$38(a0)

loc_89AF6:
                move.w  d0,x_vel(a0)
                move.w  #$20,$3C(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------
ObjDat_89B06:
                dc.l    Map_TechnoSqueek
                dc.w    make_art_tile(ArtTile_Technosqueek,1,1)
                dc.w    $280
                dc.b    $C,   8,   0,  $B
ObjDat3_89B12:
                dc.l    Map_TechnoSqueek
                dc.w    make_art_tile(ArtTile_Technosqueek,1,1)
                dc.w    $280
                dc.b    8,  $C,   5,  $B
word_89B1E:
                dc.w    $280
                dc.b    8,   4,   2,   0
ChildObjDat_89B24:
                dc.w    1-1
                dc.l    loc_899B4
                dc.b    $14,   4
byte_89B2C:
                dc.b    0,       0
                dc.b    0,     $17
                dc.b    1,       1
                dc.b    1|$40,   1
                dc.b    0,     $1F
                dc.b    $F4
byte_89B37:
                dc.b    0,       0
                dc.b    0,     $37
                dc.b    1,       1
                dc.b    1|$40,   1
                dc.b    0,     $1F
                dc.b    $F4
byte_89B42:
                dc.b    3,   0,   0,   1, 1|$40,   0,   0,   1, 1|$40,   0, $F4
byte_89B4D:
                dc.b    3,   2,   3,   4, $FC
byte_89B52:
                dc.b    5,       0
                dc.b    5,     $17
                dc.b    6,       1
                dc.b    6|$40,   1
                dc.b    0,     $1F
                dc.b    $F4
byte_89B5D:
                dc.b    5,       0
                dc.b    5,     $37
                dc.b    6,       1
                dc.b    6|$40,   1
                dc.b    5,     $1F
                dc.b    $F4
byte_89B68:
                dc.b    3,   5,   5,   6, 6|$40,   5,   5,   6, 6|$40,   5, $F4
byte_89B73:
                dc.b    3,   7,   8,   9, $FC
                even
Map_TechnoSqueek:
                include "src/objects/shared/technosqueek/mappings/technosqueek.s"
; ---------------------------------------------------------------------------

Obj_FBZEggPrison:
                lea     ObjDat_FBZEggPrison(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_89C14,(a0)
                lea     ChildObjDat_89EA8(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  respawn_addr(a0),d0
                beq.s   locret_89C12
                movea.w d0,a2
                btst    #0,(a2)
                beq.s   locret_89C12
                move.l  #loc_89C54,(a0)
                move.b  #1,mapping_frame(a0)
                bset    #5,$38(a0)

locret_89C12:
                rts
; ---------------------------------------------------------------------------

loc_89C14:
                btst    #1,$38(a0)
                beq.s   loc_89C54
                move.l  #loc_89C54,(a0)
                move.b  #1,mapping_frame(a0)
                move.w  respawn_addr(a0),d0
                beq.s   loc_89C34
                movea.w d0,a2
                bset    #0,(a2)

loc_89C34:
                bsr.w   DispatchFbzEggPrisonContentsBySubtype
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_89C4C
                move.b  #8,subtype(a1)

loc_89C4C:
                lea     ChildObjDat_89EB0(pc),a2
                jsr     CreateChild1_Normal(pc)

loc_89C54:
                bsr.w   CollideFbzEggPrisonAsSolidRectangle
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_89C5C:
                lea     (word_86B3E).l,a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_8672A,(a0)
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                beq.s   locret_89C84
                move.l  #loc_86754,(a0)
                move.b  #$C,mapping_frame(a0)

locret_89C84:
                rts
; ---------------------------------------------------------------------------

Obj_FBZSpringPlunger:
                lea     ObjDat_FBZSpringPlunger(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #5,mapping_frame(a0)
                jsr     (CapsuleSKResolveGroundButtonAndSpringPlungerSolid).l
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_89CDE
                move.b  #6,mapping_frame(a0)
                btst    #p1_standing_bit,d0
                beq.s   loc_89CC4
                move.b  #$C,mapping_frame(a0)
                lea     (Player_1).w,a1
                move.w  #-$A00,d0
                jsr     (LaunchPlayerWithSpringVelocity).l

loc_89CC4:
                btst    #p2_standing_bit,d0
                beq.s   loc_89CDE
                move.b  #$C,mapping_frame(a0)
                lea     (Player_2).w,a1
                move.w  #-$A00,d0
                jsr     (LaunchPlayerWithSpringVelocity).l

loc_89CDE:
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_89CE2:
                lea     word_89E96(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_89D02,(a0)
                move.b  #8,y_radius(a0)
                bsr.w   FBZCapsuleAnimal_InitRelease
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_89D02:
                subq.w  #1,$2E(a0)
                bpl.s   loc_89D14
                move.l  #loc_89D18,(a0)
                move.w  #$80,priority(a0)

loc_89D14:
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_89D18:
                jsr     MoveSprite_LightGravity(pc)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_89D30
                add.w   d1,y_pos(a0)
                move.w  $3E(a0),y_vel(a0)

loc_89D30:
                moveq   #0,d0
                btst    #3,(V_int_run_count+3).w
                bne.s   loc_89D3C
                moveq   #1,d0

loc_89D3C:
                move.b  d0,mapping_frame(a0)
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_89D44:
                lea     ObjDat3_89E9C(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #Obj_Bouncing_Ring,(a0)
                move.b  #-1,(Ring_spill_anim_counter).w
                move.b  #8,y_radius(a0)
                move.b  #8,x_radius(a0)
                move.b  #$84,render_flags(a0)
                moveq   #4,d0
                jsr     (Set_IndexedVelocity).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_89D78:
                lea     word_89E90(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                jsr     (CapsuleSKSelectFragmentFrameFromSubtype).l
                moveq   #4,d0
                jsr     (Set_IndexedVelocity).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CollideFbzEggPrisonAsSolidRectangle:
                moveq   #$2B,d1
                moveq   #$18,d2
                moveq   #$18,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function CollideFbzEggPrisonAsSolidRectangle

; =============== S U B R O U T I N E =======================================

DispatchFbzEggPrisonContentsBySubtype:
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  off_89DBC(pc,d0.w),d0
                jmp     off_89DBC(pc,d0.w)
; End of function DispatchFbzEggPrisonContentsBySubtype

; ---------------------------------------------------------------------------
off_89DBC:
                dc.w    loc_89DC4-off_89DBC
                dc.w    loc_89DCC-off_89DBC
                dc.w    loc_89DDE-off_89DBC
                dc.w    set_Hyudoro-off_89DBC
; ---------------------------------------------------------------------------

loc_89DC4:
                lea     ChildObjDat_89ED0(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_89DCC:
                move.w  #signextendB(sfx_RingLoss),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_89EF0(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_89DDE:
                lea     ChildObjDat_89F16(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_89F24(pc),a2
                jmp     CreateChild1_Normal(pc)

; =============== S U B R O U T I N E =======================================

; Use subtype and zone for the species, upward and outward launch and staggered delay
FBZCapsuleAnimal_InitRelease:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                andi.w  #6,d0
                lea     word_89E6C(pc),a1
                move.w  (a1,d0.w),d2
                move.w  d2,y_vel(a0)
                move.w  d2,$3E(a0)
                andi.w  #2,d0
                move.w  d0,d2
                move.w  word_89E74(pc,d2.w),art_tile(a0)
                moveq   #0,d2
                move.b  (Current_zone).w,d2
                add.w   d2,d2
                lea     (byte_2C7BA).l,a1
                adda.w  d2,a1
                lsr.w   #1,d0
                move.b  (a1,d0.w),d0
                lsl.w   #3,d0
                lea     (word_2C7EA).l,a2
                move.l  4(a2,d0.w),mappings(a0)
                lsl.w   #2,d1
                move.w  d1,$2E(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a0),d0
                move.w  #$200,d1
                cmp.w   x_pos(a1),d0
                bhs.s   loc_89E54
                neg.w   d1

loc_89E54:
                move.w  d1,x_vel(a0)
                bclr    #0,render_flags(a0)
                tst.w   x_vel(a0)
                bpl.s   locret_89E6A
                bset    #0,render_flags(a0)

locret_89E6A:
                rts
; End of function FBZCapsuleAnimal_InitRelease

; ---------------------------------------------------------------------------
word_89E6C:
                dc.w    -$380, -$300, -$280, -$200
word_89E74:
                dc.w    make_art_tile(ArtTile_Animals1,0,1)
                dc.w    make_art_tile(ArtTile_Animals2,0,1)
ObjDat_FBZEggPrison:
                dc.l    Map_FBZEggCapsule
                dc.w    make_art_tile($000,0,0)
                dc.w    $200
                dc.b    $20, $28,   0,   0
ObjDat_FBZSpringPlunger:
                dc.l    Map_FBZEggCapsule
                dc.w    make_art_tile($000,0,0)
                dc.w    $180
                dc.b    $10,   8,   5,   0
word_89E90:
                dc.w    $100
                dc.b    8,   8,   2,   0
word_89E96:
                dc.w    $280
                dc.b    $20, $28,   0,   0
ObjDat3_89E9C:
                dc.l    Map_Ring
                dc.w    make_art_tile(ArtTile_Ring,1,1)
                dc.w    $180
                dc.b    8,   8,   0, $47
ChildObjDat_89EA8:
                dc.w    1-1
                dc.l    loc_89C5C
                dc.b    0,-$24
ChildObjDat_89EB0:
                dc.w    5-1
                dc.l    loc_89D78
                dc.b    0,  -8
                dc.l    loc_89D78
                dc.b    -$10,  -8
                dc.l    loc_89D78
                dc.b    $10,  -8
                dc.l    loc_89D78
                dc.b    -$18,  -8
                dc.l    loc_89D78
                dc.b    $18,  -8
ChildObjDat_89ED0:
                dc.w    5-1
                dc.l    loc_89CE2
                dc.b    0,  -4
                dc.l    loc_89CE2
                dc.b    $10,  -4
                dc.l    loc_89CE2
                dc.b    -$10,  -4
                dc.l    loc_89CE2
                dc.b    $1C,  -4
                dc.l    loc_89CE2
                dc.b    -$1C,  -4
ChildObjDat_89EF0:
                dc.w    6-1
                dc.l    loc_89D44
                dc.b    -8,  -4
                dc.l    loc_89D44
                dc.b    8,  -4
                dc.l    loc_89D44
                dc.b    $10,  -4
                dc.l    loc_89D44
                dc.b    -$10,  -4
                dc.l    loc_89D44
                dc.b    $18,  -4
                dc.l    loc_89D44
                dc.b    -$18,  -4
ChildObjDat_89F16:
                dc.w    2-1
                dc.l    loc_89650
                dc.b    -$18,  -4
                dc.l    loc_89650
                dc.b    $18,  -4
ChildObjDat_89F24:
                dc.w    2-1
                dc.l    loc_89A5A
                dc.b    -8,  -4
                dc.l    loc_89A5A
                dc.b    8,  -4
