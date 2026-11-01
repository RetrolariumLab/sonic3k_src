; Owner: objects/terrain/icz/sk
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
                bne.s   loc_89F64
                jsr     (SolidObjectFull).l
                bsr.w   SetFastVerticalCameraForIczPlatformRider

loc_89F64:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
ICZPathFollowPlatform_Index:
                dc.w    loc_89F7E-ICZPathFollowPlatform_Index
                dc.w    loc_89FB6-ICZPathFollowPlatform_Index
                dc.w    loc_89FD6-ICZPathFollowPlatform_Index
                dc.w    loc_89FF2-ICZPathFollowPlatform_Index
                dc.w    loc_8A036-ICZPathFollowPlatform_Index
                dc.w    loc_8A11C-ICZPathFollowPlatform_Index
                dc.w    locret_8A176-ICZPathFollowPlatform_Index
                dc.w    loc_8A178-ICZPathFollowPlatform_Index
                dc.w    loc_8A192-ICZPathFollowPlatform_Index
                dc.w    loc_8A1AE-ICZPathFollowPlatform_Index
; ---------------------------------------------------------------------------

loc_89F7E:
                lea     ObjDat_ICZPathFollowPlatform(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  a0,(_unkFAA4).w
                move.b  #$20,x_radius(a0)
                move.b  #$12,y_radius(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  byte_89FB2(pc,d0.w),routine(a0)
                tst.w   d0
                bne.w   locret_8A034
                lea     ChildObjDat_8A436(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------
byte_89FB2:
                dc.b    2,   6,  $C,  $E
                even
; ---------------------------------------------------------------------------

loc_89FB6:
                btst    #p1_standing_bit,status(a0)
                bne.s   loc_89FC0
                rts
; ---------------------------------------------------------------------------

loc_89FC0:
                move.b  #4,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_89FEA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_89FD6:
                moveq   #1,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   loc_89FE2
                neg.w   d0

loc_89FE2:
                add.w   d0,x_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_89FEA:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_89FF2:
                btst    #p1_pushing_bit,status(a0)
                beq.s   loc_8A004
                move.b  (Ctrl_1_held).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   loc_8A00A

loc_8A004:
                clr.b   $39(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A00A:
                addq.b  #1,$39(a0)
                cmpi.b  #$10,$39(a0)
                blo.w   locret_8A034
                move.b  #8,routine(a0)
                lea     (Player_1).w,a1
                jsr     Find_SonicTails(pc)
                move.w  #$80,d1
                tst.w   d0
                beq.s   loc_8A030
                neg.w   d1

loc_8A030:
                move.w  d1,x_vel(a0)

locret_8A034:
                rts
; ---------------------------------------------------------------------------

loc_8A036:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_8A046
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_8A046:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                cmpi.w  #8,d1
                bge.s   loc_8A09E
                move.b  d3,angle(a0)
                add.w   d1,y_pos(a0)
                move.b  d3,d0
                bpl.s   loc_8A066
                neg.b   d0

loc_8A066:
                andi.b  #$F8,d0
                beq.s   loc_8A07C
                move.w  x_vel(a0),d0
                add.w   d3,d3
                ext.w   d3
                asr.w   #1,d3
                add.w   d3,d0
                bsr.w   AcceptIczPlatformHorizontalVelocityInRange

loc_8A07C:
                tst.w   x_vel(a0)
                bmi.s   loc_8A090
                moveq   #$1C,d3
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   loc_8A0AA
                rts
; ---------------------------------------------------------------------------

loc_8A090:
                moveq   #-$1C,d3
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bmi.s   loc_8A0F4
                rts
; ---------------------------------------------------------------------------

loc_8A09E:
                move.b  #$A,routine(a0)
                bsr.w   SetIczPlatformDepartureYVelocityFromAngle
                rts
; ---------------------------------------------------------------------------

loc_8A0AA:
                move.b  #$C,routine(a0)
                clr.b   (Fast_V_scroll_flag).w
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                tst.b   subtype(a0)
                beq.w   locret_8A034
                lea     ChildObjDat_8A42A(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_8A0EC
                move.l  #Obj_Spring,(a1)
                move.w  #$5D5A,x_pos(a1)
                move.w  #$27A,y_pos(a1)
                move.b  #0,subtype(a1)

loc_8A0EC:
                jsr     Displace_PlayerOffObject(pc)
                jmp     loc_85088(pc)
; ---------------------------------------------------------------------------

loc_8A0F4:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                dc.w    0,     8,   $10,   $18,   $20,   $28,   $30,   $38
                dc.w    -$38,  -$30,  -$28,  -$20,  -$18,  -$10,    -8,     0
; ---------------------------------------------------------------------------

loc_8A11C:
                bsr.w   ApplyIczPlatformGravityWithinVelocityRange
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_8A15E
                tst.w   x_vel(a0)
                beq.s   locret_8A15C
                bmi.s   loc_8A148
                moveq   #$20,d3
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   loc_8A154
                bra.w   locret_8A15C
; ---------------------------------------------------------------------------

loc_8A148:
                moveq   #-$20,d3
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bpl.s   locret_8A15C

loc_8A154:
                add.w   d1,x_pos(a0)
                clr.w   x_vel(a0)

locret_8A15C:
                rts
; ---------------------------------------------------------------------------

loc_8A15E:
                move.b  #8,routine(a0)
                move.w  y_vel(a0),d0
                btst    #6,d3
                beq.s   loc_8A170
                neg.w   d0

loc_8A170:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

locret_8A176:
                rts
; ---------------------------------------------------------------------------

loc_8A178:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_8A184
                rts
; ---------------------------------------------------------------------------

loc_8A184:
                move.b  #$10,routine(a0)
                move.w  y_pos(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A192:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_8A1A2
                addq.w  #1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A1A2:
                move.b  #$12,routine(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A1AE:
                addi.w  #-$20,y_vel(a0)
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $3A(a0),d0
                bls.s   loc_8A1C6
                rts
; ---------------------------------------------------------------------------

loc_8A1C6:
                move.b  #$E,routine(a0)
                move.w  $3A(a0),y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A1D4:
                lea     ObjDat3_8A412(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #byte_8A43E,$30(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  byte_8A200(pc,d0.w),child_dx(a0)  ; and child_dy
                jsr     Refresh_ChildPosition(pc)
                moveq   #8,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
byte_8A200:
                dc.b    -$14,  -9
                dc.b    $14, -$C
                dc.b    $14,   0
                dc.b    $C,  $C
                dc.b    -8,   9
                dc.b    -4,  -6
                even
; ---------------------------------------------------------------------------

loc_8A20C:
                lea     ObjDat3_8A41E(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_8A258,(a0)
                move.l  #byte_8A444,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #$5F,$2E(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  byte_8A246(pc,d0.w),child_dx(a0)  ; and child_dy
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
byte_8A246:
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

loc_8A258:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite).l
                jsr     Obj_Wait(pc)
                jmp     (Sprite_OnScreen_Test).l
