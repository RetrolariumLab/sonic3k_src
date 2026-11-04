; Owner: objects/enemies/fbz/sk
; Responsibility: Blaster attack and projectile state machines, movement helpers and child resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Blaster:
                jsr     (Obj_WaitOffscreen).l

Obj_Blaster_2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Blaster_Index(pc,d0.w),d1
                jsr     Blaster_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Blaster_Index:
                dc.w    SKBlaster_InitAndCheckCeilingFlag-Blaster_Index
                dc.w    SKBlaster_CheckFacingTarget-Blaster_Index
                dc.w    SKBlaster_TickTurnWait-Blaster_Index
                dc.w    SKBlaster_TickDelayAndTryFire-Blaster_Index
                dc.w    SKBlaster_AnimateAndTrySecondary-Blaster_Index
                dc.w    SKBlaster_RiseTowardCeiling-Blaster_Index
                dc.w    SKBlaster_WaitAtCeiling-Blaster_Index
                dc.w    SKBlaster_FallTowardFloor-Blaster_Index
; ---------------------------------------------------------------------------

SKBlaster_InitAndCheckCeilingFlag:
                lea     ObjDat_Blaster(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                bclr    #1,render_flags(a0)
                beq.s   SKBlaster_InitPatrol
                st      $3C(a0)

SKBlaster_InitPatrol:
                move.b  #$E,y_radius(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)
                add.w   d0,d0
                move.w  d0,$3A(a0)
                move.l  #BlasterSK_Body_StartTurnPause,$34(a0)
                move.w  #-$80,d4
                jmp     Set_VelocityXTrackSonic(pc)
; ---------------------------------------------------------------------------

SKBlaster_CheckFacingTarget:
                bsr.w   Blaster_TryRetreatToCeiling
                jsr     Find_SonicTails(pc)
                tst.w   d1
                bne.s   SKBlaster_AnimateAndPatrol
                cmpi.w  #$80,d2
                bhs.s   SKBlaster_AnimateAndPatrol
                btst    #0,render_flags(a0)
                beq.s   SKBlaster_TryAttackFacingSide
                subq.w  #2,d0

SKBlaster_TryAttackFacingSide:
                tst.w   d0
                beq.s   SKBlaster_BeginFireDelay

SKBlaster_AnimateAndPatrol:
                lea     BlasterSK_Body_PairedPatrolFrames(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                jsr     (MoveSprite2).l
                jsr     ObjHitFloor2_DoRoutine(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKBlaster_BeginFireDelay:
                move.b  #6,routine(a0)
                move.b  #0,mapping_frame(a0)
                move.b  #$10,$39(a0)
                rts
; ---------------------------------------------------------------------------

BlasterSK_Body_StartTurnPause:
                move.b  #4,routine(a0)
                move.w  #$20,$2E(a0)
                move.l  #BlasterSK_Body_ReverseHorizontalPatrol,$34(a0)

SKBlaster_WaitOrAirborneReturn:
                rts
; ---------------------------------------------------------------------------

SKBlaster_TickTurnWait:
                bsr.w   Blaster_TryRetreatToCeiling
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

BlasterSK_Body_ReverseHorizontalPatrol:
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  $3A(a0),$2E(a0)

SKBlaster_ResumePatrol:
                move.b  #2,routine(a0)
                move.l  #BlasterSK_Body_StartTurnPause,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKBlaster_TickDelayAndTryFire:
                bsr.w   Blaster_TryRetreatToCeiling
                subq.b  #1,$39(a0)
                bpl.w   SKBlaster_WaitOrAirborneReturn
                move.b  #8,routine(a0)
                move.l  #SKBlaster_ResumePatrol,$34(a0)
                lea     BlasterSK_Body_OneNormalMuzzleRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     SKBlaster_PrimaryShotChild(pc),a2
                jmp     CreateChild5_ComplexAdjusted(pc)
; ---------------------------------------------------------------------------

; Try the secondary projectile when animation advances to cursor 6
SKBlaster_AnimateAndTrySecondary:
                bsr.w   Blaster_TryRetreatToCeiling
                lea     SKBlaster_FireAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   SKBlaster_FireEventReturn
                cmpi.b  #6,anim_frame(a0)
                bne.s   SKBlaster_FireEventReturn
                lea     SKBlaster_SecondaryShotChild(pc),a2
                jsr     CreateChild5_ComplexAdjusted(pc)

SKBlaster_FireEventReturn:
                rts
; ---------------------------------------------------------------------------

SKBlaster_RiseTowardCeiling:
                addi.w  #-$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   SKBlaster_CeilingProbeReturn
                add.w   d1,y_pos(a0)
                move.b  #$C,routine(a0)
                clr.w   y_vel(a0)

SKBlaster_CeilingProbeReturn:
                rts
; ---------------------------------------------------------------------------

SKBlaster_WaitAtCeiling:
                tst.b   (_unkF7C1).w
                bne.s   SKBlaster_CeilingHoldReturn
                move.b  #$E,routine(a0)

SKBlaster_CeilingHoldReturn:
                rts
; ---------------------------------------------------------------------------

SKBlaster_FallTowardFloor:
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKBlaster_FloorProbeReturn
                add.w   d1,y_pos(a0)
                move.b  $3D(a0),routine(a0)
                move.w  $3E(a0),x_vel(a0)
                clr.w   y_vel(a0)

SKBlaster_FloorProbeReturn:
                rts
; ---------------------------------------------------------------------------

SKBlaster_InitMuzzle:
                lea     BlasterSK_Muzzle_PartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #SKBlaster_AnimateAndDrawMuzzle,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKBlaster_AnimateAndDrawMuzzle:
                jsr     Refresh_ChildPositionAdjusted(pc)
                lea     SKBlaster_MuzzleAnim(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKBlaster_UpdateCapsuleSpawn:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKBlaster_CapsuleStateTable(pc,d0.w),d1
                jsr     SKBlaster_CapsuleStateTable(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
SKBlaster_CapsuleStateTable:
                dc.w    SKBlaster_InitCapsuleLaunch-SKBlaster_CapsuleStateTable
                dc.w    SKBlaster_FallFromCapsule-SKBlaster_CapsuleStateTable
; ---------------------------------------------------------------------------

SKBlaster_InitCapsuleLaunch:
                lea     ObjDat_Blaster(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKBlaster_JoinPatrolOnLanding,$34(a0)
                move.b  #$E,y_radius(a0)
                moveq   #8,d0
                jsr     (Set_IndexedVelocity).l
                jmp     (Change_FlipXWithVelocity).l
; ---------------------------------------------------------------------------

SKBlaster_FallFromCapsule:
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.w   SKBlaster_WaitOrAirborneReturn
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

SKBlaster_JoinPatrolOnLanding:
                move.l  #Obj_Blaster_2,(a0)
                move.b  #2,routine(a0)
                move.w  #$3F,$2E(a0)
                move.w  #$7F,$3A(a0)
                move.l  #BlasterSK_Body_StartTurnPause,$34(a0)
                move.w  #-$80,d0
                btst    #0,render_flags(a0)
                beq.s   SKBlaster_SetLandingSpeed
                neg.w   d0

SKBlaster_SetLandingSpeed:
                move.w  d0,x_vel(a0)
                clr.w   y_vel(a0)
                rts

; =============== S U B R O U T I N E =======================================

; The local enable and engine-specific global must both allow retreat. Save the ground state and X velocity
Blaster_TryRetreatToCeiling:
                tst.b   $3C(a0)
                beq.s   SKBlaster_RetreatCheckReturn
                tst.b   (_unkF7C1).w
                beq.s   SKBlaster_RetreatCheckReturn
                move.b  routine(a0),$3D(a0)
                move.b  #$A,routine(a0)
                move.w  x_vel(a0),$3E(a0)
                clr.w   x_vel(a0)
                addq.w  #4,sp

; Starting the ceiling retreat discards the helper's return address and exits the caller
SKBlaster_RetreatCheckReturn:
                rts
; End of function Blaster_TryRetreatToCeiling

; ---------------------------------------------------------------------------
ObjDat_Blaster:
                dc.l    Map_Blaster
                dc.w    make_art_tile(ArtTile_Blaster,1,1)
                dc.w    $280
                dc.b    $18, $10,   0,  $A
BlasterSK_Muzzle_PartialAttributes:
                dc.w    $200
                dc.b    8,   8,   4,   0
SKBlaster_PrimaryShotAttrs:
                dc.l    Map_Blaster
                dc.w    make_art_tile(ArtTile_Blaster,1,1)
                dc.w    $280
                dc.b    4,   4,   5, $98
SKBlaster_SecondaryShotAttrs:
                dc.l    Map_Blaster
                dc.w    make_art_tile(ArtTile_Blaster,1,1)
                dc.w    $200
                dc.b    4,   4,   7,   0
BlasterSK_Body_OneNormalMuzzleRecord:
                dc.w    1-1
                dc.l    SKBlaster_InitMuzzle
                dc.b    -$1B,-$16
SKBlaster_PrimaryShotChild:
                dc.w    1-1
                dc.l    SKCallbackShot_InitDeflectable
                dc.l    SKBlaster_PrimaryShotAttrs
                dc.l    SKBlaster_PrimaryShotAnim
                dc.l    MoveFall_AnimateRaw
                dc.b    -$20,-$20
                dc.w    -$200, -$400
SKBlaster_SecondaryShotChild:
                dc.w    1-1
                dc.l    SKCallbackShot_InitDeflectable
                dc.l    SKBlaster_SecondaryShotAttrs
                dc.l    SKBlaster_SecondaryShotAnim
                dc.l    MoveFall_AnimateRaw
                dc.b    -$C,  -4
                dc.w    $100, -$200
BlasterSK_Body_PairedPatrolFrames:
                dc.b    0, $17
                dc.b    1,   2
                dc.b    $FC
SKBlaster_MuzzleAnim:
                dc.b    0,   4,   4,   5, $F4
SKBlaster_FireAnim:
                dc.b    0,   1
                dc.b    0,   1
                dc.b    2,   5
                dc.b    0, $1F
                dc.b    $F4
SKBlaster_PrimaryShotAnim:
                dc.b    1,   5,   6, $FC
SKBlaster_SecondaryShotAnim:
                dc.b    2,   7,   8,   9,  $A, $FC
                even
Map_Blaster:
                include "src/objects/shared/blaster/mappings/blaster.s"
