; Owner: objects/level_end/s3
; Responsibility: Egg capsule state machine, release children, ending poses and freed-animal movement helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_EggCapsule:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  EggCapsule_Index(pc,d0.w),d1
                move.w  x_pos(a0),-(sp)
                jsr     EggCapsule_Index(pc,d1.w)
                moveq   #$2B,d1
                moveq   #$18,d2
                moveq   #$18,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                jmp     S3RuntimeLifetime_CapsuleCoarseCull_DrawOrSchedulePrivateFlagDeletion(pc)
; ---------------------------------------------------------------------------
EggCapsule_Index:
                dc.w    loc_54514-EggCapsule_Index
                dc.w    loc_5456A-EggCapsule_Index
                dc.w    loc_545B4-EggCapsule_Index
                dc.w    loc_545BC-EggCapsule_Index
                dc.w    loc_545C0-EggCapsule_Index
                dc.w    loc_54640-EggCapsule_Index
                dc.w    loc_54652-EggCapsule_Index
                dc.w    loc_54660-EggCapsule_Index
; ---------------------------------------------------------------------------

loc_54514:
                lea     ObjDat_EggCapsule(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                btst    #1,render_flags(a0)
                bne.s   loc_5452C
                lea     ChildObjDat_54AA6(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_5452C:
                move.b  #8,routine(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                move.w  d0,x_pos(a0)
                move.w  d0,$3E(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$40,d0
                move.w  d0,y_pos(a0)
                move.w  #1,$3A(a0)
                jsr     (Swing_Setup1).l
                lea     ChildObjDat_54AAE(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_54AB6(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_5456A:
                btst    #1,$38(a0)
                beq.s   locret_545B2
                move.b  #4,routine(a0)

; =============== S U B R O U T I N E =======================================

CapsuleS3OpenAndRequestFragmentsAnimalsExplosion:
                cmpi.b  #2,(Current_zone).w
                beq.s   loc_54584
                st      (Ctrl_2_locked).w

loc_54584:
                move.b  #1,mapping_frame(a0)
                move.w  #$40,$2E(a0)
                lea     ChildObjDat_54AC4(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_54AE4(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                move.b  #8,subtype(a1)

locret_545B2:
                rts
; End of function CapsuleS3OpenAndRequestFragmentsAnimalsExplosion

; ---------------------------------------------------------------------------

loc_545B4:
                move.b  #6,d0
                bra.w   CapsuleS3StartResultsWhenP1LandedAfterOpenWait
; ---------------------------------------------------------------------------

loc_545BC:
                bra.w   Check_TailsEndPose
; ---------------------------------------------------------------------------

loc_545C0:
                move.w  (Camera_X_pos).w,d0
                move.w  $3A(a0),d1
                bmi.s   loc_545D8
                addi.w  #$110,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_545E2
                bra.w   loc_545E4
; ---------------------------------------------------------------------------

loc_545D8:
                addi.w  #$30,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_545E4

loc_545E2:
                neg.w   d1

loc_545E4:
                move.w  d1,$3A(a0)
                add.w   d1,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$40,d0
                cmpi.b  #2,(Current_zone).w
                bne.s   loc_54600
                subi.w  #$20,d0

loc_54600:
                move.l  #$4000,d1
                cmp.w   y_pos(a0),d0
                bhi.s   loc_5460E
                neg.l   d1

loc_5460E:
                add.l   d1,y_pos(a0)
                btst    #1,$38(a0)
                beq.s   loc_54636
                move.b  #$A,routine(a0)
                cmpi.b  #2,(Current_zone).w
                bne.s   loc_5462E
                move.b  #$E,routine(a0)

loc_5462E:
                move.w  a1,$44(a0)
                bsr.w   CapsuleS3OpenAndRequestFragmentsAnimalsExplosion

loc_54636:
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_54640:
                move.b  #$C,d0
                bsr.w   CapsuleS3StartResultsWhenP1LandedAfterOpenWait
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_54652:
                bsr.w   Check_TailsEndPose
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_54660:
                move.b  #$C,d0
                bsr.w   CapsuleS3StartResultsForVisibleTailsOrCarriedP1AfterWait
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_54672:
                move.l  #loc_54680,(a0)
                lea     word_54A88(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_54680:
                bsr.w   CapsuleS3ResolveGroundButtonSolid
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_546A2
                move.l  #loc_546A6,(a0)
                addq.w  #8,y_pos(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

loc_546A2:
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_546A6:
                bsr.w   CapsuleS3ResolveGroundButtonSolid
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_546AE:
                move.l  #loc_546C2,(a0)
                bset    #1,render_flags(a0)
                lea     word_54A88(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_546C2:
                jsr     Refresh_ChildPosition(pc)
                moveq   #6,d2
                bsr.w   loc_549A0
                lea     word_54716(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   loc_54712
                tst.w   d0
                beq.s   loc_546F4
                movea.w d0,a1
                tst.w   y_vel(a1)
                bpl.s   loc_546F4
                cmpi.b  #2,anim(a1)
                beq.s   loc_546FE
                cmpi.b  #1,character_id(a1)
                beq.s   loc_546FE

loc_546F4:
                swap    d0
                movea.w d0,a1
                tst.w   y_vel(a1)
                bpl.s   loc_54712

loc_546FE:
                move.l  #loc_5471E,(a0)
                subq.b  #8,child_dy(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

loc_54712:
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------
word_54716:
                dc.w    -$1A,   $34,  -$1C,   $38
; ---------------------------------------------------------------------------

loc_5471E:
                jsr     Refresh_ChildPosition(pc)
                moveq   #5,d2
                bsr.w   loc_549A0
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_5472C:
                lea     ObjDat3_54A8E(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                cmpi.w  #$400,(Current_zone_and_act).w
                bne.s   loc_54742
                move.w  #make_art_tile(ArtTile_EggCapsule-$46,0,0),art_tile(a0)

loc_54742:
                move.l  #Obj_FlickerMove,(a0)
                bsr.w   CapsuleS3SelectFragmentFrameFromSubtype
                moveq   #4,d0
                jsr     Set_IndexedVelocity(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_54758:
                lea     word_54AA0(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_54766,(a0)

loc_54766:
                jsr     Refresh_ChildPosition(pc)
                lea     byte_54B40(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_54776:
                lea     word_54A9A(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_54794,(a0)
                move.b  #8,y_radius(a0)
                bsr.w   CapsuleS3InitializeFreedAnimalBounceSpeciesAndReleaseDelay
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_54794:
                subq.w  #1,$2E(a0)
                bpl.s   loc_547A6
                move.l  #loc_547AA,(a0)
                move.w  #$80,priority(a0)

loc_547A6:
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_547AA:
                jsr     MoveSprite_LightGravity(pc)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_547DE
                add.w   d1,y_pos(a0)
                move.w  $3E(a0),y_vel(a0)
                jsr     Find_SonicTails(pc)
                move.w  #-$200,d1
                tst.b   (_unkFAA8).w
                beq.s   loc_547D6
                tst.w   d0
                beq.s   loc_547D6
                neg.w   d1

loc_547D6:
                move.w  d1,x_vel(a0)
                bsr.w   CapsuleS3SetFreedAnimalHorizontalFlipFromXVelocity

loc_547DE:
                moveq   #0,d0
                btst    #3,(V_int_run_count+3).w
                bne.s   loc_547EA
                moveq   #1,d0

loc_547EA:
                move.b  d0,mapping_frame(a0)
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_547F2:
                jsr     Refresh_ChildPosition(pc)
                subq.w  #1,$2E(a0)
                bpl.s   loc_54808
                move.l  #loc_5480C,(a0)
                move.w  #$80,priority(a0)

loc_54808:
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_5480C:
                lea     (Player_1).w,a1
                move.w  #$300,d0
                move.w  #$100,d1
                moveq   #$10,d2
                move.w  #0,d3
                move.w  #-$30,d4
                sub.b   subtype(a0),d4
                bsr.w   CapsuleS3AccelerateFreedAnimalTowardOffsetPlayerWithRetry
                jsr     (MoveSprite2).l
                bsr.w   CapsuleS3SetFreedAnimalHorizontalFlipFromXVelocity
                tst.b   (_unkFAA8).w
                bne.s   loc_54846
                move.l  #loc_54848,(a0)
                bset    #0,render_flags(a0)

loc_54846:
                bra.s   loc_547DE
; ---------------------------------------------------------------------------

loc_54848:
                subq.w  #2,x_pos(a0)
                bra.s   loc_547DE

; =============== S U B R O U T I N E =======================================

CapsuleS3StartResultsWhenP1LandedAfterOpenWait:
                subq.w  #1,$2E(a0)
                bpl.s   locret_54886
                lea     (Player_1).w,a1
                btst    #7,status(a1)
                bne.s   locret_54886
                btst    #Status_InAir,status(a1)
                bne.s   locret_54886
                cmpi.b  #6,routine(a1)
                bhs.s   locret_54886
                move.b  d0,routine(a0)
                bsr.w   Set_PlayerEndingPose
                jsr     (AllocateObject).l
                bne.s   locret_54886
                move.l  #Obj_LevelResults,(a1)

locret_54886:
                rts
; End of function CapsuleS3StartResultsWhenP1LandedAfterOpenWait

; =============== S U B R O U T I N E =======================================

Check_TailsEndPose:
                tst.b   (_unkFAA8).w
                beq.w   locret_545B2
                cmpi.b  #3,(Current_zone).w
                bne.s   loc_548A0
                lea     (Player_1).w,a1
                bsr.w   Set_PlayerEndingPose

loc_548A0:
                btst    #7,$38(a0)
                bne.w   locret_545B2
                lea     (Player_2).w,a1
                btst    #7,status(a1)
                bne.w   locret_545B2
                btst    #Status_InAir,status(a1)
                bne.w   locret_545B2
                cmpi.b  #6,routine(a1)
                bhs.w   locret_545B2
                bset    #7,$38(a0)
                clr.b   (Ctrl_2_locked).w
                jmp     Set_PlayerEndingPose(pc)
; End of function Check_TailsEndPose

; =============== S U B R O U T I N E =======================================

CapsuleS3StartResultsForVisibleTailsOrCarriedP1AfterWait:
                subq.w  #1,$2E(a0)
                bpl.s   locret_5491A
                lea     (Player_1).w,a1
                cmpi.b  #6,routine(a1)
                bhs.s   locret_5491A
                tst.b   render_flags(a1)
                bpl.s   locret_5491A
                cmpi.b  #1,$38(a1)
                beq.s   loc_54900
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   locret_5491A

loc_54900:
                move.w  #-$100,x_vel(a0)
                move.b  d0,routine(a0)
                jsr     (AllocateObject).l
                bne.s   loc_54918
                move.l  #Obj_LevelResults,(a1)

loc_54918:
                moveq   #1,d0

locret_5491A:
                rts
; End of function CapsuleS3StartResultsForVisibleTailsOrCarriedP1AfterWait

; =============== S U B R O U T I N E =======================================

Set_PlayerEndingPose:
                move.b  #$81,object_control(a1)
                move.b  #$13,anim(a1)
                clr.b   spin_dash_flag(a1)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                bclr    #5,status(a0)
                bclr    #Status_Push,status(a1)
                rts
; End of function Set_PlayerEndingPose

; =============== S U B R O U T I N E =======================================

CapsuleS3AccelerateFreedAnimalTowardOffsetPlayerWithRetry:
                move.w  d2,d5
                move.w  x_pos(a1),d6
                add.w   d3,d6
                cmp.w   x_pos(a0),d6
                bhs.s   loc_54956
                neg.w   d2

loc_54956:
                move.w  x_vel(a0),d6
                add.w   d2,d6
                cmp.w   d0,d6
                bgt.s   loc_5496A
                neg.w   d0
                cmp.w   d0,d6
                blt.s   loc_5496A
                move.w  d6,x_vel(a0)

loc_5496A:
                move.w  y_pos(a1),d6
                add.w   d4,d6
                cmp.w   y_pos(a0),d6
                bhs.s   loc_54978
                neg.w   d5

loc_54978:
                move.w  y_vel(a0),d6
                add.w   d5,d6
                cmp.w   d1,d6
                bgt.s   locret_5498C
                neg.w   d1
                cmp.w   d1,d6
                blt.s   loc_5496A
                move.w  d6,y_vel(a0)

locret_5498C:
                rts
; End of function CapsuleS3AccelerateFreedAnimalTowardOffsetPlayerWithRetry

; ---------------------------------------------------------------------------
; unused
                moveq   #$2B,d1
                moveq   #$18,d2
                moveq   #$18,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l

; =============== S U B R O U T I N E =======================================

CapsuleS3ResolveGroundButtonSolid:
                moveq   #8,d2

loc_549A0:
                moveq   #$1B,d1
                moveq   #9,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function CapsuleS3ResolveGroundButtonSolid

; =============== S U B R O U T I N E =======================================

CapsuleS3SelectFragmentFrameFromSubtype:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  byte_549BE(pc,d0.w),mapping_frame(a0)
                rts
; End of function CapsuleS3SelectFragmentFrameFromSubtype

; ---------------------------------------------------------------------------
byte_549BE:
                dc.b    2,   3,  $A,   4,  $B
                even

; =============== S U B R O U T I N E =======================================

CapsuleS3InitializeFreedAnimalBounceSpeciesAndReleaseDelay:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                andi.w  #6,d0
                lea     word_54A58(pc),a1
                move.w  (a1,d0.w),d2
                move.w  d2,y_vel(a0)
                move.w  d2,$3E(a0)
                movea.w parent3(a0),a1
                btst    #1,render_flags(a1)
                beq.s   loc_549FA
                move.l  #loc_547F2,(a0)
                addq.b  #8,child_dy(a0)
                clr.w   y_vel(a0)

loc_549FA:
                andi.w  #2,d0
                move.w  d0,d2
                cmpi.w  #$400,(Current_zone_and_act).w
                bne.s   loc_54A0A
                addq.w  #4,d2

loc_54A0A:
                move.w  word_54A60(pc,d2.w),art_tile(a0)
                moveq   #0,d2
                move.b  (Current_zone).w,d2
                add.w   d2,d2
                lea     (byte_2BDDA).l,a1
                adda.w  d2,a1
                lsr.w   #1,d0
                move.b  (a1,d0.w),d0
                lsl.w   #3,d0
                lea     (word_2BDF4).l,a2
                move.l  4(a2,d0.w),mappings(a0)
                lsl.w   #2,d1
                move.w  d1,$2E(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a0),d0
                move.w  #$200,d1
                cmp.w   x_pos(a1),d0
                bhs.s   loc_54A4E
                neg.w   d1

loc_54A4E:
                move.w  d1,x_vel(a0)
                bsr.w   CapsuleS3SetFreedAnimalHorizontalFlipFromXVelocity
                rts
; End of function CapsuleS3InitializeFreedAnimalBounceSpeciesAndReleaseDelay

; ---------------------------------------------------------------------------
word_54A58:
                dc.w    -$380, -$300, -$280, -$200
word_54A60:
                dc.w    make_art_tile(ArtTile_Animals1,0,1)
                dc.w    make_art_tile(ArtTile_Animals2,0,1)
                dc.w    make_art_tile(ArtTile_FBZAnimals1,0,1)
                dc.w    make_art_tile(ArtTile_FBZAnimals2,0,1)

; =============== S U B R O U T I N E =======================================

CapsuleS3SetFreedAnimalHorizontalFlipFromXVelocity:
                bclr    #0,render_flags(a0)
                tst.w   x_vel(a0)
                bpl.s   locret_54A7A
                bset    #0,render_flags(a0)

locret_54A7A:
                rts
; End of function CapsuleS3SetFreedAnimalHorizontalFlipFromXVelocity
