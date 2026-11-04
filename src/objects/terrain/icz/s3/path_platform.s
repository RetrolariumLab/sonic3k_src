; Owner: objects/terrain/icz/s3
; Responsibility: IceCap path-following platform variants and their shared path controller
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZPathFollowPlatform:
                jsr     (Obj_WaitOffscreen).l

Obj_ICZPathFollowPlatform_2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  ICZPathFollowPlatform_Index(pc,d0.w),d1
                move.w  x_pos(a0),-(sp)
                jsr     ICZPathFollowPlatform_Index(pc,d1.w)
                moveq   #$2B,d1
                moveq   #$14,d2
                moveq   #$14,d3
                move.w  (sp)+,d4
                btst    #7,status(a0)
                bne.s   loc_57796
                jsr     (SolidObjectFull).l
                bsr.w   SetFastVerticalCameraForIczPlatformRider

loc_57796:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
ICZPathFollowPlatform_Index:
                dc.w    loc_577B0-ICZPathFollowPlatform_Index
                dc.w    loc_577E8-ICZPathFollowPlatform_Index
                dc.w    loc_57808-ICZPathFollowPlatform_Index
                dc.w    loc_57824-ICZPathFollowPlatform_Index
                dc.w    loc_57868-ICZPathFollowPlatform_Index
                dc.w    loc_57942-ICZPathFollowPlatform_Index
                dc.w    locret_5799C-ICZPathFollowPlatform_Index
                dc.w    loc_5799E-ICZPathFollowPlatform_Index
                dc.w    loc_579B8-ICZPathFollowPlatform_Index
                dc.w    loc_579D4-ICZPathFollowPlatform_Index
; ---------------------------------------------------------------------------

loc_577B0:
                lea     ObjDat_ICZPathFollowPlatform(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  a0,(_unkFAA4).w
                move.b  #$20,x_radius(a0)
                move.b  #$12,y_radius(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  byte_577E4(pc,d0.w),routine(a0)
                tst.w   d0
                bne.w   locret_57866
                lea     ChildObjDat_57C40(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------
byte_577E4:
                dc.b    2,   6,  $C,  $E
                even
; ---------------------------------------------------------------------------

loc_577E8:
                btst    #p1_standing_bit,status(a0)
                bne.s   loc_577F2
                rts
; ---------------------------------------------------------------------------

loc_577F2:
                move.b  #4,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_5781C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_57808:
                moveq   #1,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   loc_57814
                neg.w   d0

loc_57814:
                add.w   d0,x_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_5781C:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_57824:
                btst    #p1_pushing_bit,status(a0)
                beq.s   loc_57836
                move.b  (Ctrl_1_held).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   loc_5783C

loc_57836:
                clr.b   $39(a0)
                rts
; ---------------------------------------------------------------------------

loc_5783C:
                addq.b  #1,$39(a0)
                cmpi.b  #$10,$39(a0)
                blo.w   locret_57866
                move.b  #8,routine(a0)
                lea     (Player_1).w,a1
                jsr     Find_SonicTails(pc)
                move.w  #$80,d1
                tst.w   d0
                beq.s   loc_57862
                neg.w   d1

loc_57862:
                move.w  d1,x_vel(a0)

locret_57866:
                rts
; ---------------------------------------------------------------------------

loc_57868:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_57878
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_57878:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                cmpi.w  #8,d1
                bge.s   loc_578D0
                move.b  d3,angle(a0)
                add.w   d1,y_pos(a0)
                move.b  d3,d0
                bpl.s   loc_57898
                neg.b   d0

loc_57898:
                andi.b  #$F8,d0
                beq.s   loc_578AE
                move.w  x_vel(a0),d0
                add.w   d3,d3
                ext.w   d3
                asr.w   #1,d3
                add.w   d3,d0
                bsr.w   AcceptIczPlatformHorizontalVelocityInRange

loc_578AE:
                tst.w   x_vel(a0)
                bmi.s   loc_578C2
                moveq   #$1C,d3
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   loc_578DC
                rts
; ---------------------------------------------------------------------------

loc_578C2:
                moveq   #-$1C,d3
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bmi.s   loc_5791A
                rts
; ---------------------------------------------------------------------------

loc_578D0:
                move.b  #$A,routine(a0)
                bsr.w   SetIczPlatformDepartureYVelocityFromAngle
                rts
; ---------------------------------------------------------------------------

loc_578DC:
                move.b  #$C,routine(a0)
                tst.b   subtype(a0)
                beq.w   locret_57866
                lea     ChildObjDat_57C34(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_57912
                move.l  #Obj_Spring,(a1)
                move.w  #$5D5A,x_pos(a1)
                move.w  #$27A,y_pos(a1)
                move.b  #0,subtype(a1)

loc_57912:
                jsr     Displace_PlayerOffObject(pc)
                jmp     S3Cull_ReleaseRespawnForStatusDelete(pc)
; ---------------------------------------------------------------------------

loc_5791A:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                dc.w    0,     8,   $10,   $18,   $20,   $28,   $30,   $38
                dc.w    -$38,  -$30,  -$28,  -$20,  -$18,  -$10,    -8,     0
; ---------------------------------------------------------------------------

loc_57942:
                bsr.w   ApplyIczPlatformGravityWithinVelocityRange
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_57984
                tst.w   x_vel(a0)
                beq.s   locret_57982
                bmi.s   loc_5796E
                moveq   #$20,d3
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   loc_5797A
                bra.w   locret_57982
; ---------------------------------------------------------------------------

loc_5796E:
                moveq   #-$20,d3
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bpl.s   locret_57982

loc_5797A:
                add.w   d1,x_pos(a0)
                clr.w   x_vel(a0)

locret_57982:
                rts
; ---------------------------------------------------------------------------

loc_57984:
                move.b  #8,routine(a0)
                move.w  y_vel(a0),d0
                btst    #6,d3
                beq.s   loc_57996
                neg.w   d0

loc_57996:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

locret_5799C:
                rts
; ---------------------------------------------------------------------------

loc_5799E:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_579AA
                rts
; ---------------------------------------------------------------------------

loc_579AA:
                move.b  #$10,routine(a0)
                move.w  y_pos(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_579B8:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_579C8
                addq.w  #1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_579C8:
                move.b  #$12,routine(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_579D4:
                addi.w  #-$20,y_vel(a0)
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $3A(a0),d0
                bls.s   loc_579EC
                rts
; ---------------------------------------------------------------------------

loc_579EC:
                move.b  #$E,routine(a0)
                move.w  $3A(a0),y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_579FA:
                lea     ObjDat3_57C1C(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #byte_57C48,$30(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  byte_57A26(pc,d0.w),child_dx(a0)  ; and child_dy
                jsr     Refresh_ChildPosition(pc)
                moveq   #8,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
byte_57A26:
                dc.b    -$14,  -9
                dc.b    $14, -$C
                dc.b    $14,   0
                dc.b    $C,  $C
                dc.b    -8,   9
                dc.b    -4,  -6
                even
; ---------------------------------------------------------------------------

loc_57A32:
                lea     ObjDat3_57C28(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_57A7E,(a0)
                move.l  #byte_57C4E,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #$5F,$2E(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  byte_57A6C(pc,d0.w),child_dx(a0)  ; and child_dy
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
byte_57A6C:
                dc.b    -$14,-$30
                dc.b    8,-$34
                dc.b    -$C,-$14
                dc.b    $10,-$20
                dc.b    $A,  -4
                dc.b    -$14,  $C
                dc.b    8, $18
                dc.b    -$10, $28
                dc.b    $C, $34
                even
; ---------------------------------------------------------------------------

loc_57A7E:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite).l
                jsr     Obj_Wait(pc)
                jmp     (Sprite_OnScreen_Test).l
