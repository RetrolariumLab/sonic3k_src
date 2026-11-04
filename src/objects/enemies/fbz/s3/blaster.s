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
                dc.w    S3Blaster_InitAndCheckCeilingFlag-Blaster_Index
                dc.w    S3Blaster_CheckFacingTarget-Blaster_Index
                dc.w    S3Blaster_TickTurnWait-Blaster_Index
                dc.w    S3Blaster_TickTurnWait-Blaster_Index
                dc.w    S3Blaster_AnimateAndTrySecondary-Blaster_Index
                dc.w    S3Blaster_RiseTowardCeiling-Blaster_Index
                dc.w    S3Blaster_WaitAtCeiling-Blaster_Index
                dc.w    S3Blaster_FallTowardFloor-Blaster_Index
; ---------------------------------------------------------------------------

S3Blaster_InitAndCheckCeilingFlag:
                lea     ObjDat_Blaster(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$10,y_radius(a0)
                bset    #1,render_flags(a0)
                bclr    #1,render_flags(a0)
                beq.s   S3Blaster_InitPatrol
                st      $3C(a0)

S3Blaster_InitPatrol:
                move.b  #$E,y_radius(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.w  d0,$3A(a0)
                move.l  #BlasterS3_Body_StartTurnPause,$34(a0)
                move.w  #-$80,d4
                jmp     Set_VelocityXTrackSonic(pc)
; ---------------------------------------------------------------------------

S3Blaster_CheckFacingTarget:
                bsr.w   Blaster_TryRetreatToCeiling
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.s   S3Blaster_AnimateAndPatrol
                btst    #0,render_flags(a0)
                beq.s   S3Blaster_TryAttackFacingSide
                subq.w  #2,d0

S3Blaster_TryAttackFacingSide:
                tst.w   d0
                beq.s   S3Blaster_BeginFireDelay

S3Blaster_AnimateAndPatrol:
                lea     BlasterS3_Body_PairedPatrolFrames(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jsr     (MoveSprite2).l
                jsr     ObjHitFloor2_DoRoutine(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3Blaster_BeginFireDelay:
                move.b  #6,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.w  $2E(a0),$3A(a0)
                move.w  #$10,$2E(a0)
                move.l  #S3Blaster_SpawnMuzzleAndPrimary,$34(a0)
                rts
; ---------------------------------------------------------------------------

BlasterS3_Body_StartTurnPause:
                move.b  #4,routine(a0)
                move.w  #$20,$2E(a0)
                move.l  #BlasterS3_Body_ReverseHorizontalPatrol,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Blaster_TickTurnWait:
                bsr.w   Blaster_TryRetreatToCeiling
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

BlasterS3_Body_ReverseHorizontalPatrol:
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

S3Blaster_ResumePatrol:
                move.b  #2,routine(a0)
                move.w  $3A(a0),$2E(a0)
                move.l  #BlasterS3_Body_StartTurnPause,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Blaster_SpawnMuzzleAndPrimary:
                move.b  #8,routine(a0)
                move.l  #S3Blaster_ResumePatrol,$34(a0)
                lea     BlasterS3_Body_OneNormalMuzzleRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     S3Blaster_PrimaryShotChild(pc),a2
                jmp     CreateChild5_ComplexAdjusted(pc)
; ---------------------------------------------------------------------------

; Try the secondary projectile when animation advances to cursor 6
S3Blaster_AnimateAndTrySecondary:
                bsr.w   Blaster_TryRetreatToCeiling
                lea     S3Blaster_FireAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   S3Blaster_FireEventReturn
                cmpi.b  #6,anim_frame(a0)
                bne.s   S3Blaster_FireEventReturn
                lea     S3Blaster_SecondaryShotChild(pc),a2
                jsr     CreateChild5_ComplexAdjusted(pc)

S3Blaster_FireEventReturn:
                rts
; ---------------------------------------------------------------------------

S3Blaster_RiseTowardCeiling:
                addi.w  #-$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bmi.s   S3Blaster_StopAtCeiling
                rts
; ---------------------------------------------------------------------------

S3Blaster_StopAtCeiling:
                add.w   d1,y_pos(a0)
                move.b  #$C,routine(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3Blaster_WaitAtCeiling:
                tst.b   (_unkFAA2).w
                beq.s   S3Blaster_BeginFallFromCeiling
                rts
; ---------------------------------------------------------------------------

S3Blaster_BeginFallFromCeiling:
                move.b  #$E,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3Blaster_FallTowardFloor:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   S3Blaster_LandAndRestoreState
                rts
; ---------------------------------------------------------------------------

S3Blaster_LandAndRestoreState:
                add.w   d1,y_pos(a0)
                move.b  $3D(a0),routine(a0)
                move.w  $3E(a0),x_vel(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3Blaster_InitMuzzle:
                lea     BlasterS3_Muzzle_PartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #S3Blaster_AnimateAndDrawMuzzle,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Blaster_AnimateAndDrawMuzzle:
                jsr     Refresh_ChildPositionAdjusted(pc)
                lea     S3Blaster_MuzzleAnim(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; The local enable and engine-specific global must both allow retreat. Save the ground state and X velocity
Blaster_TryRetreatToCeiling:
                tst.b   $3C(a0)
                beq.s   S3Blaster_RetreatCheckReturn
                tst.b   (_unkFAA2).w
                beq.s   S3Blaster_RetreatCheckReturn
                move.b  routine(a0),$3D(a0)
                move.b  #$A,routine(a0)
                move.w  x_vel(a0),$3E(a0)
                clr.w   x_vel(a0)

S3Blaster_RetreatCheckReturn:
                rts
; End of function Blaster_TryRetreatToCeiling

; ---------------------------------------------------------------------------
ObjDat_Blaster:
                dc.l    Map_Blaster
                dc.w    make_art_tile(ArtTile_Blaster-6,1,1)
                dc.w    $280
                dc.b    $18, $10,   0,  $A
BlasterS3_Muzzle_PartialAttributes:
                dc.w    $200
                dc.b    8,   8,   4,   0
S3Blaster_PrimaryShotAttrs:
                dc.l    Map_Blaster
                dc.w    make_art_tile(ArtTile_Blaster-6,1,1)
                dc.w    $280
                dc.b    4,   4,   5, $18
S3Blaster_SecondaryShotAttrs:
                dc.l    Map_Blaster
                dc.w    make_art_tile(ArtTile_Blaster-6,1,1)
                dc.w    $200
                dc.b    4,   4,   7,   0
BlasterS3_Body_OneNormalMuzzleRecord:
                dc.w    1-1
                dc.l    S3Blaster_InitMuzzle
                dc.b    -$1B,-$16
S3Blaster_PrimaryShotChild:
                dc.w    1-1
                dc.l    S3CallbackShot_InitDeflectable
                dc.l    S3Blaster_PrimaryShotAttrs
                dc.l    S3Blaster_PrimaryShotAnim
                dc.l    MoveFall_AnimateRaw
                dc.b    -$20,-$20
                dc.w    -$200, -$400
S3Blaster_SecondaryShotChild:
                dc.w    1-1
                dc.l    S3CallbackShot_InitDeflectable
                dc.l    S3Blaster_SecondaryShotAttrs
                dc.l    S3Blaster_SecondaryShotAnim
                dc.l    MoveFall_AnimateRaw
                dc.b    -$C,  -4
                dc.w    $100, -$200
BlasterS3_Body_PairedPatrolFrames:
                dc.b    0, $17
                dc.b    1,   2
                dc.b    $FC
S3Blaster_MuzzleAnim:
                dc.b    0,   4,   4,   5, $F4
S3Blaster_FireAnim:
                dc.b    0,   1
                dc.b    0,   1
                dc.b    2,   5
                dc.b    0, $1F
                dc.b    $F4
S3Blaster_PrimaryShotAnim:
                dc.b    1,   5,   6, $FC
S3Blaster_SecondaryShotAnim:
                dc.b    2,   7,   8,   9,  $A, $FC
                even
