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
                bne.s   S3ICZPathPlat_DrawPlatform
                jsr     (SolidObjectFull).l
                bsr.w   SetFastVerticalCameraForIczPlatformRider

S3ICZPathPlat_DrawPlatform:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
ICZPathFollowPlatform_Index:
                dc.w    S3ICZPathPlat_InitAndRegisterPlatform-ICZPathFollowPlatform_Index
                dc.w    S3ICZPathPlat_WaitForP1Standing-ICZPathFollowPlatform_Index
                dc.w    S3ICZPathPlat_ChooseShakeOffset-ICZPathFollowPlatform_Index
                dc.w    S3ICZPathPlat_CheckP1PushInput-ICZPathFollowPlatform_Index
                dc.w    S3ICZPathPlat_TryWrapPlatformY-ICZPathFollowPlatform_Index
                dc.w    S3ICZPathPlat_MoveAirborneAndProbe-ICZPathFollowPlatform_Index
                dc.w    S3ICZPathPlat_HoldInertPlatform-ICZPathFollowPlatform_Index
                dc.w    S3ICZPathPlat_WaitForSagRider-ICZPathFollowPlatform_Index
                dc.w    S3ICZPathPlat_SinkWhileOccupied-ICZPathFollowPlatform_Index
                dc.w    S3ICZPathPlat_RiseTowardSagBase-ICZPathFollowPlatform_Index
; ---------------------------------------------------------------------------

S3ICZPathPlat_InitAndRegisterPlatform:
                lea     ObjDat_ICZPathFollowPlatform(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  a0,(SceneControllerObjectAddress).w
                move.b  #$20,x_radius(a0)
                move.b  #$12,y_radius(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                move.b  S3ICZPathPlat_InitialStates(pc,d0.w),routine(a0)
                tst.w   d0
                bne.w   S3ICZPathPlat_SetupReturn
                lea     S3ICZBreakIce_AttachedIcePieceChild(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------
S3ICZPathPlat_InitialStates:
                dc.b    2,   6,  $C,  $E
                even
; ---------------------------------------------------------------------------

S3ICZPathPlat_WaitForP1Standing:
                btst    #p1_standing_bit,status(a0)
                bne.s   S3ICZPathPlat_BeginShakeDelay
                rts
; ---------------------------------------------------------------------------

S3ICZPathPlat_BeginShakeDelay:
                move.b  #4,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #S3ICZPathPlat_BeginFall,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZPathPlat_ChooseShakeOffset:
                moveq   #1,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   S3ICZPathPlat_ShakeAndTickDelay
                neg.w   d0

S3ICZPathPlat_ShakeAndTickDelay:
                add.w   d0,x_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3ICZPathPlat_BeginFall:
                move.b  #$A,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZPathPlat_CheckP1PushInput:
                btst    #p1_pushing_bit,status(a0)
                beq.s   S3ICZPathPlat_ResetPushCount
                move.b  (Ctrl_1_held).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   S3ICZPathPlat_TickPushAndChooseSpeed

S3ICZPathPlat_ResetPushCount:
                clr.b   $39(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZPathPlat_TickPushAndChooseSpeed:
                addq.b  #1,$39(a0)
                cmpi.b  #$10,$39(a0)
                blo.w   S3ICZPathPlat_SetupReturn
                move.b  #8,routine(a0)
                lea     (Player_1).w,a1
                jsr     Find_SonicTails(pc)
                move.w  #$80,d1
                tst.w   d0
                beq.s   S3ICZPathPlat_SetInitialXSpeed
                neg.w   d1

S3ICZPathPlat_SetInitialXSpeed:
                move.w  d1,x_vel(a0)

S3ICZPathPlat_SetupReturn:
                rts
; ---------------------------------------------------------------------------

; Wrap Y only when the camera minimum is exactly -$100
S3ICZPathPlat_TryWrapPlatformY:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   S3ICZPathPlat_MoveAndFollowFloor
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

S3ICZPathPlat_MoveAndFollowFloor:
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                cmpi.w  #8,d1
                bge.s   S3ICZPathPlat_LeaveFloorAndSetYSpeed
                move.b  d3,angle(a0)
                add.w   d1,y_pos(a0)
                move.b  d3,d0
                bpl.s   S3ICZPathPlat_TryApplySlopeAccel
                neg.b   d0

S3ICZPathPlat_TryApplySlopeAccel:
                andi.b  #$F8,d0
                beq.s   S3ICZPathPlat_ProbeGroundRightWall
                move.w  x_vel(a0),d0
                add.w   d3,d3
                ext.w   d3
                asr.w   #1,d3
                add.w   d3,d0
                bsr.w   ICZPathPlatform_TrySetXVel

S3ICZPathPlat_ProbeGroundRightWall:
                tst.w   x_vel(a0)
                bmi.s   S3ICZPathPlat_ProbeGroundLeftWall
                moveq   #$1C,d3
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   S3ICZPathPlat_HandleRightWallImpact
                rts
; ---------------------------------------------------------------------------

S3ICZPathPlat_ProbeGroundLeftWall:
                moveq   #-$1C,d3
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bmi.s   S3ICZPathPlat_HandleLeftWallImpact
                rts
; ---------------------------------------------------------------------------

S3ICZPathPlat_LeaveFloorAndSetYSpeed:
                move.b  #$A,routine(a0)
                bsr.w   ICZPathPlatform_SetDepartureYVel
                rts
; ---------------------------------------------------------------------------

S3ICZPathPlat_HandleRightWallImpact:
                move.b  #$C,routine(a0)
                tst.b   subtype(a0)
                beq.w   S3ICZPathPlat_SetupReturn
                lea     S3ICZBreakIce_PlatformDebrisChildren(pc),a2
                jsr     CreateChild6_Simple(pc)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   S3ICZPathPlat_DisplaceRidersAndDelete
                move.l  #Obj_Spring,(a1)
                move.w  #$5D5A,x_pos(a1)
                move.w  #$27A,y_pos(a1)
                move.b  #0,subtype(a1)

S3ICZPathPlat_DisplaceRidersAndDelete:
                jsr     Displace_PlayerOffObject(pc)
                jmp     S3Cull_ReleaseRespawnForStatusDelete(pc)
; ---------------------------------------------------------------------------

S3ICZPathPlat_HandleLeftWallImpact:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------
; unused
                dc.w    0,     8,   $10,   $18,   $20,   $28,   $30,   $38
                dc.w    -$38,  -$30,  -$28,  -$20,  -$18,  -$10,    -8,     0
; ---------------------------------------------------------------------------

S3ICZPathPlat_MoveAirborneAndProbe:
                bsr.w   ICZPathPlatform_TryApplyGravity
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   S3ICZPathPlat_LandAndConvertYSpeed
                tst.w   x_vel(a0)
                beq.s   S3ICZPathPlat_AirborneReturn
                bmi.s   S3ICZPathPlat_ProbeAirLeftWall
                moveq   #$20,d3
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bmi.s   S3ICZPathPlat_ResolveWallAndStopX
                bra.w   S3ICZPathPlat_AirborneReturn
; ---------------------------------------------------------------------------

S3ICZPathPlat_ProbeAirLeftWall:
                moveq   #-$20,d3
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bpl.s   S3ICZPathPlat_AirborneReturn

S3ICZPathPlat_ResolveWallAndStopX:
                add.w   d1,x_pos(a0)
                clr.w   x_vel(a0)

S3ICZPathPlat_AirborneReturn:
                rts
; ---------------------------------------------------------------------------

; Convert Y speed to signed X speed and enter the grounded state. Position stays as integrated
S3ICZPathPlat_LandAndConvertYSpeed:
                move.b  #8,routine(a0)
                move.w  y_vel(a0),d0
                btst    #6,d3
                beq.s   S3ICZPathPlat_SetLandingXSpeed
                neg.w   d0

S3ICZPathPlat_SetLandingXSpeed:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZPathPlat_HoldInertPlatform:
                rts
; ---------------------------------------------------------------------------

S3ICZPathPlat_WaitForSagRider:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   S3ICZPathPlat_SaveSagBaseAndStart
                rts
; ---------------------------------------------------------------------------

S3ICZPathPlat_SaveSagBaseAndStart:
                move.b  #$10,routine(a0)
                move.w  y_pos(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZPathPlat_SinkWhileOccupied:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   S3ICZPathPlat_BeginSagReturn
                addq.w  #1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZPathPlat_BeginSagReturn:
                move.b  #$12,routine(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZPathPlat_RiseTowardSagBase:
                addi.w  #-$20,y_vel(a0)
                jsr     (MoveSprite2).l
                move.w  y_pos(a0),d0
                cmp.w   $3A(a0),d0
                bls.s   S3ICZPathPlat_SnapToSagBase
                rts
; ---------------------------------------------------------------------------

S3ICZPathPlat_SnapToSagBase:
                move.b  #$E,routine(a0)
                move.w  $3A(a0),y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3ICZPathPlat_InitPlatformDebris:
                lea     S3ICZBreakIce_PlatformDebrisAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #S3ICZBreakIce_PlatformDebrisAnim,$30(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  S3ICZPathPlat_PlatformDebrisOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                jsr     Refresh_ChildPosition(pc)
                moveq   #8,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
S3ICZPathPlat_PlatformDebrisOffsets:
                dc.b    -$14,  -9
                dc.b    $14, -$C
                dc.b    $14,   0
                dc.b    $C,  $C
                dc.b    -8,   9
                dc.b    -4,  -6
                even
; ---------------------------------------------------------------------------

S3ICZPathPlat_InitWallDebris:
                lea     S3ICZBreakIce_WallDebrisAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #S3ICZPathPlat_UpdateWallDebris,(a0)
                move.l  #S3ICZBreakIce_WallDebrisAnim,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                move.w  #$5F,$2E(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  S3ICZPathPlat_WallDebrisOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
S3ICZPathPlat_WallDebrisOffsets:
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

S3ICZPathPlat_UpdateWallDebris:
                jsr     Animate_Raw(pc)
                jsr     (MoveSprite).l
                jsr     Obj_Wait(pc)
                jmp     (Sprite_OnScreen_Test).l
