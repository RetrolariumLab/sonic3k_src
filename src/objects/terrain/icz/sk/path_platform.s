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
                bne.s   SKICZPathPlat_DrawPlatform
                jsr     (SolidObjectFull).l
                bsr.w   SetFastVerticalCameraForIczPlatformRider

SKICZPathPlat_DrawPlatform:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
ICZPathFollowPlatform_Index:
                dc.w    SKICZPathPlat_InitAndRegisterPlatform-ICZPathFollowPlatform_Index
                dc.w    SKICZPathPlat_WaitForP1Standing-ICZPathFollowPlatform_Index
                dc.w    SKICZPathPlat_ChooseShakeOffset-ICZPathFollowPlatform_Index
                dc.w    SKICZPathPlat_CheckP1PushInput-ICZPathFollowPlatform_Index
                dc.w    SKICZPathPlat_TryWrapPlatformY-ICZPathFollowPlatform_Index
                dc.w    SKICZPathPlat_MoveAirborneAndProbe-ICZPathFollowPlatform_Index
                dc.w    SKICZPathPlat_HoldInertPlatform-ICZPathFollowPlatform_Index
                dc.w    SKICZPathPlat_WaitForSagRider-ICZPathFollowPlatform_Index
                dc.w    SKICZPathPlat_SinkWhileOccupied-ICZPathFollowPlatform_Index
                dc.w    SKICZPathPlat_RiseTowardSagBase-ICZPathFollowPlatform_Index
; ---------------------------------------------------------------------------

SKICZPathPlat_InitAndRegisterPlatform:
                lea     ObjDat_ICZPathFollowPlatform(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  a0,(_unkFAA4).w
                move.b  #$20,x_radius(a0)
                move.b  #$12,y_radius(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  SKICZPathPlat_InitialStates(pc,d0.w),routine(a0)
                tst.w   d0
                bne.w   SKICZPathPlat_SetupReturn
                lea     SKICZBreakIce_AttachedIcePieceChild(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------
SKICZPathPlat_InitialStates:
                dc.b    2,   6,  $C,  $E
                even
; ---------------------------------------------------------------------------

SKICZPathPlat_WaitForP1Standing:
                btst    #p1_standing_bit,status(a0)
                bne.s   SKICZPathPlat_BeginShakeDelay
                rts
; ---------------------------------------------------------------------------

SKICZPathPlat_BeginShakeDelay:
                move.b  #4,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #SKICZPathPlat_BeginFall,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKICZPathPlat_ChooseShakeOffset:
                moveq   #1,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   SKICZPathPlat_ShakeAndTickDelay
                neg.w   d0

SKICZPathPlat_ShakeAndTickDelay:
                add.w   d0,x_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKICZPathPlat_BeginFall:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKICZPathPlat_CheckP1PushInput:
                btst    #p1_pushing_bit,status(a0)
                beq.s   SKICZPathPlat_ResetPushCount
                move.b  (Ctrl_1_held).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   SKICZPathPlat_TickPushAndChooseSpeed

SKICZPathPlat_ResetPushCount:
                clr.b   $39(a0)
                rts
; ---------------------------------------------------------------------------

SKICZPathPlat_TickPushAndChooseSpeed:
                addq.b  #1,$39(a0)
                cmpi.b  #$10,$39(a0)
                blo.w   SKICZPathPlat_SetupReturn
                move.b  #8,routine(a0)
                lea     (Player_1).w,a1
                jsr     Find_SonicTails(pc)
                move.w  #$80,d1
                tst.w   d0
                beq.s   SKICZPathPlat_SetInitialXSpeed
                neg.w   d1

SKICZPathPlat_SetInitialXSpeed:
                move.w  d1,x_vel(a0)

SKICZPathPlat_SetupReturn:
                rts
; ---------------------------------------------------------------------------

; Wrap Y only when the camera minimum is exactly -$100
SKICZPathPlat_TryWrapPlatformY:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   SKICZPathPlat_MoveAndFollowFloor
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

SKICZPathPlat_MoveAndFollowFloor:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                cmpi.w  #8,d1
                bge.s   SKICZPathPlat_LeaveFloorAndSetYSpeed
                move.b  d3,angle(a0)
                add.w   d1,y_pos(a0)
                move.b  d3,d0
                bpl.s   SKICZPathPlat_TryApplySlopeAccel
                neg.b   d0

SKICZPathPlat_TryApplySlopeAccel:
                andi.b  #$F8,d0
                beq.s   SKICZPathPlat_ProbeGroundRightWall
                move.w  x_vel(a0),d0
                add.w   d3,d3
                ext.w   d3
                asr.w   #1,d3
                add.w   d3,d0
                bsr.w   ICZPathPlatform_TrySetXVel

SKICZPathPlat_ProbeGroundRightWall:
                tst.w   x_vel(a0)
                bmi.s   SKICZPathPlat_ProbeGroundLeftWall
                moveq   #$1C,d3
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   SKICZPathPlat_HandleRightWallImpact
                rts
; ---------------------------------------------------------------------------

SKICZPathPlat_ProbeGroundLeftWall:
                moveq   #-$1C,d3
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bmi.s   SKICZPathPlat_HandleLeftWallImpact
                rts
; ---------------------------------------------------------------------------

SKICZPathPlat_LeaveFloorAndSetYSpeed:
                move.b  #$A,routine(a0)
                bsr.w   ICZPathPlatform_SetDepartureYVel
                rts
; ---------------------------------------------------------------------------

SKICZPathPlat_HandleRightWallImpact:
                move.b  #$C,routine(a0)
                clr.b   (Fast_V_scroll_flag).w
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                tst.b   subtype(a0)
                beq.w   SKICZPathPlat_SetupReturn
                lea     SKICZBreakIce_PlatformDebrisChildren(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKICZPathPlat_DisplaceRidersAndDelete
                move.l  #Obj_Spring,(a1)
                move.w  #$5D5A,x_pos(a1)
                move.w  #$27A,y_pos(a1)
                move.b  #0,subtype(a1)

SKICZPathPlat_DisplaceRidersAndDelete:
                jsr     Displace_PlayerOffObject(pc)
                jmp     SKCull_ReleaseRespawnForStatusDelete(pc)
; ---------------------------------------------------------------------------

SKICZPathPlat_HandleLeftWallImpact:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                dc.w    0,     8,   $10,   $18,   $20,   $28,   $30,   $38
                dc.w    -$38,  -$30,  -$28,  -$20,  -$18,  -$10,    -8,     0
; ---------------------------------------------------------------------------

SKICZPathPlat_MoveAirborneAndProbe:
                bsr.w   ICZPathPlatform_TryApplyGravity
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   SKICZPathPlat_LandAndConvertYSpeed
                tst.w   x_vel(a0)
                beq.s   SKICZPathPlat_AirborneReturn
                bmi.s   SKICZPathPlat_ProbeAirLeftWall
                moveq   #$20,d3
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   SKICZPathPlat_ResolveWallAndStopX
                bra.w   SKICZPathPlat_AirborneReturn
; ---------------------------------------------------------------------------

SKICZPathPlat_ProbeAirLeftWall:
                moveq   #-$20,d3
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bpl.s   SKICZPathPlat_AirborneReturn

SKICZPathPlat_ResolveWallAndStopX:
                add.w   d1,x_pos(a0)
                clr.w   x_vel(a0)

SKICZPathPlat_AirborneReturn:
                rts
; ---------------------------------------------------------------------------

; Convert Y speed to signed X speed and enter the grounded state. Position stays as integrated
SKICZPathPlat_LandAndConvertYSpeed:
                move.b  #8,routine(a0)
                move.w  y_vel(a0),d0
                btst    #6,d3
                beq.s   SKICZPathPlat_SetLandingXSpeed
                neg.w   d0

SKICZPathPlat_SetLandingXSpeed:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKICZPathPlat_HoldInertPlatform:
                rts
; ---------------------------------------------------------------------------

SKICZPathPlat_WaitForSagRider:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   SKICZPathPlat_SaveSagBaseAndStart
                rts
; ---------------------------------------------------------------------------

SKICZPathPlat_SaveSagBaseAndStart:
                move.b  #$10,routine(a0)
                move.w  y_pos(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------

SKICZPathPlat_SinkWhileOccupied:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   SKICZPathPlat_BeginSagReturn
                addq.w  #1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKICZPathPlat_BeginSagReturn:
                move.b  #$12,routine(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKICZPathPlat_RiseTowardSagBase:
                addi.w  #-$20,y_vel(a0)
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $3A(a0),d0
                bls.s   SKICZPathPlat_SnapToSagBase
                rts
; ---------------------------------------------------------------------------

SKICZPathPlat_SnapToSagBase:
                move.b  #$E,routine(a0)
                move.w  $3A(a0),y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKICZPathPlat_InitPlatformDebris:
                lea     SKICZBreakIce_PlatformDebrisAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #SKICZBreakIce_PlatformDebrisAnim,$30(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SKICZPathPlat_PlatformDebrisOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                jsr     Refresh_ChildPosition(pc)
                moveq   #8,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
SKICZPathPlat_PlatformDebrisOffsets:
                dc.b    -$14,  -9
                dc.b    $14, -$C
                dc.b    $14,   0
                dc.b    $C,  $C
                dc.b    -8,   9
                dc.b    -4,  -6
                even
; ---------------------------------------------------------------------------

SKICZPathPlat_InitWallDebris:
                lea     SKICZBreakIce_WallDebrisAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKICZPathPlat_UpdateWallDebris,(a0)
                move.l  #SKICZBreakIce_WallDebrisAnim,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #$5F,$2E(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  SKICZPathPlat_WallDebrisOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
SKICZPathPlat_WallDebrisOffsets:
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

SKICZPathPlat_UpdateWallDebris:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite).l
                jsr     Obj_Wait(pc)
                jmp     (Sprite_OnScreen_Test).l
