; Owner: objects/level_end/sk
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
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
EggCapsule_Index:
                dc.w    loc_8657A-EggCapsule_Index
                dc.w    loc_865D0-EggCapsule_Index
                dc.w    loc_8661E-EggCapsule_Index
                dc.w    loc_86626-EggCapsule_Index
                dc.w    loc_8662A-EggCapsule_Index
                dc.w    loc_866BA-EggCapsule_Index
                dc.w    loc_866CC-EggCapsule_Index
                dc.w    loc_866DA-EggCapsule_Index
                dc.w    loc_866EC-EggCapsule_Index
                dc.w    loc_86716-EggCapsule_Index
; ---------------------------------------------------------------------------

loc_8657A:
                lea     ObjDat_EggCapsule(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                btst    #1,render_flags(a0)
                bne.s   loc_86592
                lea     ChildObjDat_86B5C(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_86592:
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
                lea     ChildObjDat_86B64(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_86B6C(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

loc_865D0:
                btst    #1,$38(a0)
                beq.s   locret_8661C
                move.b  #4,routine(a0)

; =============== S U B R O U T I N E =======================================

sub_865DE:
                cmpi.b  #2,(Current_zone).w
                beq.s   loc_865EA
                st      (Ctrl_2_locked).w

loc_865EA:
                move.b  #1,mapping_frame(a0)
                move.w  #$40,$2E(a0)
                st      (_unkFACD).w
                lea     ChildObjDat_86B7A(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     ChildObjDat_86B9A(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                move.b  #8,subtype(a1)

locret_8661C:
                rts
; End of function sub_865DE

; ---------------------------------------------------------------------------

loc_8661E:
                move.b  #6,d0
                bra.w   sub_868F8
; ---------------------------------------------------------------------------

loc_86626:
                bra.w   Check_TailsEndPose
; ---------------------------------------------------------------------------

loc_8662A:
                move.w  (Camera_X_pos).w,d0
                move.w  $3A(a0),d1
                bmi.s   loc_86642
                addi.w  #$110,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_8664C
                bra.w   loc_8664E
; ---------------------------------------------------------------------------

loc_86642:
                addi.w  #$30,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_8664E

loc_8664C:
                neg.w   d1

loc_8664E:
                move.w  d1,$3A(a0)
                add.w   d1,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$40,d0
                cmpi.b  #2,(Current_zone).w
                bne.s   loc_8666A
                subi.w  #$20,d0

loc_8666A:
                move.l  #$4000,d1
                cmp.w   y_pos(a0),d0
                bhi.s   loc_86678
                neg.l   d1

loc_86678:
                add.l   d1,y_pos(a0)
                btst    #1,$38(a0)
                beq.s   loc_86698
                moveq   #0,d0
                move.b  (Current_zone).w,d0
                move.b  byte_866A2(pc,d0.w),routine(a0)
                move.w  a1,$44(a0)
                bsr.w   sub_865DE

loc_86698:
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------
byte_866A2:
                dc.b    $A
                dc.b    $A
                dc.b    $E
                dc.b    $A
                dc.b    $A
                dc.b    $A
                dc.b    $10
                dc.b    $A
                dc.b    $A
                dc.b    $A
                dc.b    $A
                dc.b    $A
                dc.b    $A
                dc.b    $A
                dc.b    $A
                dc.b    $A
                dc.b    $A
                dc.b    $A
                dc.b    $A
                dc.b    $A
                dc.b    $A
                dc.b    $A
                dc.b    $A
                dc.b    $A
                even
; ---------------------------------------------------------------------------

loc_866BA:
                move.b  #$C,d0
                bsr.w   sub_868F8
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_866CC:
                bsr.w   Check_TailsEndPose
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_866DA:
                move.b  #$C,d0
                bsr.w   sub_86984
                jsr     Swing_UpAndDown(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_866EC:
                move.b  #$12,d0
                bsr.w   sub_868F8

loc_866F4:
                jsr     Swing_UpAndDown(pc)
                move.w  (Camera_X_pos).w,d0
                subi.w  #$60,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_8670C
                st      (_unkFAA2).w
                rts
; ---------------------------------------------------------------------------

loc_8670C:
                subq.w  #2,x_pos(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_86716:
                bsr.w   Check_TailsEndPose
                bra.s   loc_866F4
; ---------------------------------------------------------------------------

loc_8671C:
                move.l  #loc_8672A,(a0)
                lea     word_86B3E(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_8672A:
                jsr     (sub_86A3E).l
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_86750
                move.l  #loc_86754,(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)
                move.b  #$C,mapping_frame(a0)

loc_86750:
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_86754:
                bsr.w   sub_86A3E
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_8675C:
                move.l  #loc_86770,(a0)
                bset    #1,render_flags(a0)
                lea     word_86B3E(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

loc_86770:
                jsr     Refresh_ChildPosition(pc)
                bsr.w   sub_86A54
                lea     word_867C2(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   loc_867BE
                tst.w   d0
                beq.s   loc_867A0
                movea.w d0,a1
                tst.w   y_vel(a1)
                bpl.s   loc_867A0
                cmpi.b  #2,anim(a1)
                beq.s   loc_867AA
                cmpi.b  #1,character_id(a1)
                beq.s   loc_867AA

loc_867A0:
                swap    d0
                movea.w d0,a1
                tst.w   y_vel(a1)
                bpl.s   loc_867BE

loc_867AA:
                move.l  #loc_867CA,(a0)
                subq.b  #8,child_dy(a0)
                movea.w parent3(a0),a1
                bset    #1,$38(a1)

loc_867BE:
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
word_867C2:
                dc.w    -$1A,   $34,  -$1C,   $38
; ---------------------------------------------------------------------------

loc_867CA:
                jsr     Refresh_ChildPosition(pc)
                bsr.w   sub_86A54
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_867D6:
                lea     ObjDat3_86B44(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                cmpi.w  #$400,(Current_zone_and_act).w
                bne.s   loc_867EC
                move.w  #make_art_tile(ArtTile_EggCapsule-$46,0,0),art_tile(a0)

loc_867EC:
                move.l  #Obj_FlickerMove,(a0)
                bsr.w   sub_86A64
                moveq   #4,d0
                jsr     Set_IndexedVelocity(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_86802:
                lea     word_86B56(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_86810,(a0)

loc_86810:
                jsr     Refresh_ChildPosition(pc)
                lea     byte_86BF6(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_86820:
                lea     word_86B50(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_8683E,(a0)
                move.b  #8,y_radius(a0)
                bsr.w   sub_86A7A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8683E:
                subq.w  #1,$2E(a0)
                bpl.s   loc_86850
                move.l  #loc_86854,(a0)
                move.w  #$80,priority(a0)

loc_86850:
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_86854:
                jsr     MoveSprite_LightGravity(pc)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_86888
                add.w   d1,y_pos(a0)
                move.w  $3E(a0),y_vel(a0)
                jsr     Find_SonicTails(pc)
                move.w  #-$200,d1
                tst.b   (_unkFAA8).w
                beq.s   loc_86880
                tst.w   d0
                beq.s   loc_86880
                neg.w   d1

loc_86880:
                move.w  d1,x_vel(a0)
                bsr.w   sub_86B1E

loc_86888:
                moveq   #0,d0
                btst    #3,(V_int_run_count+3).w
                bne.s   loc_86894
                moveq   #1,d0

loc_86894:
                move.b  d0,mapping_frame(a0)
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_8689C:
                jsr     Refresh_ChildPosition(pc)
                subq.w  #1,$2E(a0)
                bpl.s   loc_868B2
                move.l  #loc_868B6,(a0)
                move.w  #$80,priority(a0)

loc_868B2:
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

loc_868B6:
                lea     (Player_1).w,a1
                move.w  #$300,d0
                move.w  #$100,d1
                moveq   #$10,d2
                move.w  #0,d3
                move.w  #-$30,d4
                sub.b   subtype(a0),d4
                bsr.w   sub_869F6
                jsr     (MoveSprite2).l
                bsr.w   sub_86B1E
                tst.b   (_unkFAA8).w
                bne.s   loc_868F0
                move.l  #loc_868F2,(a0)
                bset    #0,render_flags(a0)

loc_868F0:
                bra.s   loc_86888
; ---------------------------------------------------------------------------

loc_868F2:
                subq.w  #2,x_pos(a0)
                bra.s   loc_86888

; =============== S U B R O U T I N E =======================================

sub_868F8:
                subq.w  #1,$2E(a0)
                bpl.s   locret_86930
                lea     (Player_1).w,a1
                btst    #7,status(a1)
                bne.s   locret_86930
                btst    #Status_InAir,status(a1)
                bne.s   locret_86930
                cmpi.b  #6,routine(a1)
                bhs.s   locret_86930
                move.b  d0,routine(a0)
                bsr.w   Set_PlayerEndingPose
                jsr     (AllocateObject).l
                bne.s   locret_86930
                move.l  #Obj_LevelResults,(a1)

locret_86930:
                rts
; End of function sub_868F8

; =============== S U B R O U T I N E =======================================

Check_TailsEndPose:
                tst.b   (_unkFAA8).w
                beq.w   locret_8661C
                cmpi.b  #3,(Current_zone).w
                bne.s   loc_8694A
                lea     (Player_1).w,a1
                bsr.w   Set_PlayerEndingPose

loc_8694A:
                btst    #7,$38(a0)
                bne.w   locret_8661C
                lea     (Player_2).w,a1
                btst    #7,status(a1)
                bne.w   locret_8661C
                btst    #Status_InAir,status(a1)
                bne.w   locret_8661C
                cmpi.b  #6,routine(a1)
                bhs.w   locret_8661C
                bset    #7,$38(a0)
                clr.b   (Ctrl_2_locked).w
                jmp     Set_PlayerEndingPose(pc)
; End of function Check_TailsEndPose

; =============== S U B R O U T I N E =======================================

sub_86984:
                subq.w  #1,$2E(a0)
                bpl.s   locret_869C4
                lea     (Player_1).w,a1
                cmpi.b  #6,routine(a1)
                bhs.s   locret_869C4
                tst.b   render_flags(a1)
                bpl.s   locret_869C4
                cmpi.b  #1,$38(a1)
                beq.s   loc_869AA
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   locret_869C4

loc_869AA:
                move.w  #-$100,x_vel(a0)
                move.b  d0,routine(a0)
                jsr     (AllocateObject).l
                bne.s   loc_869C2
                move.l  #Obj_LevelResults,(a1)

loc_869C2:
                moveq   #1,d0

locret_869C4:
                rts
; End of function sub_86984

; =============== S U B R O U T I N E =======================================

Set_PlayerEndingPose:
                move.b  #$81,object_control(a1)
                move.b  #$13,anim(a1)
                clr.b   spin_dash_flag(a1)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                bclr    #5,status(a0)
                bclr    #6,status(a0)
                bclr    #Status_Push,status(a1)
                rts
; End of function Set_PlayerEndingPose

; =============== S U B R O U T I N E =======================================

sub_869F6:
                move.w  d2,d5
                move.w  x_pos(a1),d6
                add.w   d3,d6
                cmp.w   x_pos(a0),d6
                bhs.s   loc_86A06
                neg.w   d2

loc_86A06:
                move.w  x_vel(a0),d6
                add.w   d2,d6
                cmp.w   d0,d6
                bgt.s   loc_86A1A
                neg.w   d0
                cmp.w   d0,d6
                blt.s   loc_86A1A
                move.w  d6,x_vel(a0)

loc_86A1A:
                move.w  y_pos(a1),d6
                add.w   d4,d6
                cmp.w   y_pos(a0),d6
                bhs.s   loc_86A28
                neg.w   d5

loc_86A28:
                move.w  y_vel(a0),d6
                add.w   d5,d6
                cmp.w   d1,d6
                bgt.s   locret_86A3C
                neg.w   d1
                cmp.w   d1,d6
                blt.s   loc_86A1A
                move.w  d6,y_vel(a0)

locret_86A3C:
                rts
; End of function sub_869F6

; =============== S U B R O U T I N E =======================================

sub_86A3E:
                move.w  #$1B,d1
                move.w  #4,d2
                move.w  #6,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function sub_86A3E

; =============== S U B R O U T I N E =======================================

sub_86A54:
                moveq   #5,d2
                moveq   #$1B,d1
                moveq   #9,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function sub_86A54

; =============== S U B R O U T I N E =======================================

sub_86A64:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  byte_86A74(pc,d0.w),mapping_frame(a0)
                rts
; End of function sub_86A64

; ---------------------------------------------------------------------------
byte_86A74:
                dc.b    2,   3,  $A,   4,  $B
                even

; =============== S U B R O U T I N E =======================================

sub_86A7A:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                andi.w  #6,d0
                lea     word_86B0E(pc),a1
                move.w  (a1,d0.w),d2
                move.w  d2,y_vel(a0)
                move.w  d2,$3E(a0)
                movea.w parent3(a0),a1
                btst    #1,render_flags(a1)
                beq.s   loc_86AB0
                move.l  #loc_8689C,(a0)
                addq.b  #8,child_dy(a0)
                clr.w   y_vel(a0)

loc_86AB0:
                andi.w  #2,d0
                move.w  d0,d2
                cmpi.w  #$400,(Current_zone_and_act).w
                bne.s   loc_86AC0
                addq.w  #4,d2

loc_86AC0:
                move.w  word_86B16(pc,d2.w),art_tile(a0)
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
                bhs.s   loc_86B04
                neg.w   d1

loc_86B04:
                move.w  d1,x_vel(a0)
                bsr.w   sub_86B1E
                rts
; End of function sub_86A7A

; ---------------------------------------------------------------------------
word_86B0E:
                dc.w    -$380, -$300, -$280, -$200
word_86B16:
                dc.w    make_art_tile(ArtTile_Animals1,0,1)
                dc.w    make_art_tile(ArtTile_Animals2,0,1)
                dc.w    make_art_tile(ArtTile_FBZAnimals1,0,1)
                dc.w    make_art_tile(ArtTile_FBZAnimals2,0,1)

; =============== S U B R O U T I N E =======================================

sub_86B1E:
                bclr    #0,render_flags(a0)
                tst.w   x_vel(a0)
                bpl.s   locret_86B30
                bset    #0,render_flags(a0)

locret_86B30:
                rts
; End of function sub_86B1E
