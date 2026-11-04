; Owner: objects/zones/mgz/top_platform/sk
; Responsibility: Marble Garden spinning top terrain contact, slope handling, acceleration and braking
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

ResolveAirborneTopPlatformTerrain:
                move.l  (Primary_collision_addr).w,(Collision_addr).w
                cmpi.b  #$C,top_solid_bit(a0)
                beq.s   SKMGZTopTerrain_DispatchByVelocitySector
                move.l  (Secondary_collision_addr).w,(Collision_addr).w

SKMGZTopTerrain_DispatchByVelocitySector:
                move.b  lrb_solid_bit(a0),d5
                move.w  x_vel(a0),d1
                move.w  y_vel(a0),d2
                jsr     (GetArcTan).l
                subi.b  #$20,d0
                andi.b  #$C0,d0
                cmpi.b  #$40,d0
                beq.w   SKMGZTopTerrain_ProbeLeftWall
                cmpi.b  #$80,d0
                beq.w   SKMGZTopTerrain_ProbeUpSectorLeftWall
                cmpi.b  #-$40,d0
                beq.w   SKMGZTopTerrain_ProbeRightWall
                move.b  #$C,y_radius(a0)
                move.b  #$18,x_radius(a0)
                jsr     (ProbeLeftWallAtBodyExtents).l
                tst.w   d1
                bpl.s   SKMGZTopTerrain_ProbeDefaultRightWall
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKMGZTopTerrain_ProbeDefaultRightWall:
                jsr     (ProbeRightWallAtBodyExtents).l
                tst.w   d1
                bpl.s   SKMGZTopTerrain_ProbeDefaultFloor
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKMGZTopTerrain_ProbeDefaultFloor:
                move.b  #$1F,y_radius(a0)
                move.b  #$A,x_radius(a0)
                jsr     (Sonic_CheckFloor).l
                tst.w   d1
                bpl.s   SKMGZTopTerrain_DefaultContactReturn
                move.b  y_vel(a0),d2
                addq.b  #8,d2
                neg.b   d2
                cmp.b   d2,d1
                bge.s   SKMGZTopTerrain_LandAndClassifySlope
                cmp.b   d2,d0
                blt.s   SKMGZTopTerrain_DefaultContactReturn

SKMGZTopTerrain_LandAndClassifySlope:
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                bclr    #1,status(a0)
                move.b  #0,$2D(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   SKMGZTopTerrain_LandOnSteepSlope
                move.b  d3,d0
                addi.b  #$10,d0
                andi.b  #$20,d0
                beq.s   SKMGZTopTerrain_LandOnFlat
                asr     y_vel(a0)
                bra.s   SKMGZTopTerrain_ProjectLandingSpeed
; ---------------------------------------------------------------------------

SKMGZTopTerrain_LandOnFlat:
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKMGZTopTerrain_LandOnSteepSlope:
                move.w  #0,x_vel(a0)
                cmpi.w  #$FC0,y_vel(a0)
                ble.s   SKMGZTopTerrain_ProjectLandingSpeed
                move.w  #$FC0,y_vel(a0)

SKMGZTopTerrain_ProjectLandingSpeed:
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   SKMGZTopTerrain_DefaultContactReturn
                neg.w   ground_vel(a0)

SKMGZTopTerrain_DefaultContactReturn:
                rts
; ---------------------------------------------------------------------------

SKMGZTopTerrain_ProbeLeftWall:
                move.b  #$C,y_radius(a0)
                move.b  #$18,x_radius(a0)
                jsr     (ProbeLeftWallAtBodyExtents).l
                tst.w   d1
                bpl.s   SKMGZTopTerrain_ProbeLeftSectorCeiling
                sub.w   d1,x_pos(a0)
                addi.b  #$30,d3
                cmpi.b  #$60,d3
                blo.s   SKMGZTopTerrain_ProbeLeftSectorCeiling
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

SKMGZTopTerrain_ProbeLeftSectorCeiling:
                move.b  #$1F,y_radius(a0)
                move.b  #$A,x_radius(a0)
                jsr     (ProbeCeilingWithInsetHorizontalRadius).l
                tst.w   d1
                bpl.s   SKMGZTopTerrain_TryLandInLeftSector
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   SKMGZTopTerrain_LeftCeilingReturn
                move.w  #0,y_vel(a0)

SKMGZTopTerrain_LeftCeilingReturn:
                rts
; ---------------------------------------------------------------------------

SKMGZTopTerrain_TryLandInLeftSector:
                tst.w   y_vel(a0)
                bmi.s   SKMGZTopTerrain_LeftFloorReturn
                jsr     (Sonic_CheckFloor).l
                tst.w   d1
                bpl.s   SKMGZTopTerrain_LeftFloorReturn
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                bclr    #1,status(a0)
                move.b  #0,$2D(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)

SKMGZTopTerrain_LeftFloorReturn:
                rts
; ---------------------------------------------------------------------------

SKMGZTopTerrain_ProbeUpSectorLeftWall:
                move.b  #$C,y_radius(a0)
                move.b  #$18,x_radius(a0)
                jsr     (ProbeLeftWallAtBodyExtents).l
                tst.w   d1
                bpl.s   SKMGZTopTerrain_ProbeUpSectorRightWall
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKMGZTopTerrain_ProbeUpSectorRightWall:
                jsr     (ProbeRightWallAtBodyExtents).l
                tst.w   d1
                bpl.s   SKMGZTopTerrain_CheckCeilingSlope
                add.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKMGZTopTerrain_CheckCeilingSlope:
                move.b  #$1F,y_radius(a0)
                move.b  #$A,x_radius(a0)
                jsr     (ProbeCeilingWithInsetHorizontalRadius).l
                tst.w   d1
                bpl.s   SKMGZTopTerrain_UpSectorReturn
                sub.w   d1,y_pos(a0)
                move.b  d3,d0
                addi.b  #$20,d0
                andi.b  #$40,d0
                bne.s   SKMGZTopTerrain_AttachToCeilingSlope
                move.w  #0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKMGZTopTerrain_AttachToCeilingSlope:
                move.b  d3,angle(a0)
                bclr    #1,status(a0)
                move.b  #0,$2D(a0)
                move.w  y_vel(a0),ground_vel(a0)
                tst.b   d3
                bpl.s   SKMGZTopTerrain_UpSectorReturn
                neg.w   ground_vel(a0)

SKMGZTopTerrain_UpSectorReturn:
                rts
; ---------------------------------------------------------------------------

SKMGZTopTerrain_ProbeRightWall:
                move.b  #$C,y_radius(a0)
                move.b  #$18,x_radius(a0)
                jsr     (ProbeRightWallAtBodyExtents).l
                tst.w   d1
                bpl.s   SKMGZTopTerrain_ProbeRightSectorCeiling
                add.w   d1,x_pos(a0)
                addi.b  #$30,d3
                cmpi.b  #$60,d3
                blo.s   SKMGZTopTerrain_ProbeRightSectorCeiling
                move.w  #0,x_vel(a0)
                move.w  y_vel(a0),ground_vel(a0)

SKMGZTopTerrain_ProbeRightSectorCeiling:
                move.b  #$1F,y_radius(a0)
                move.b  #$A,x_radius(a0)
                jsr     (ProbeCeilingWithInsetHorizontalRadius).l
                tst.w   d1
                bpl.s   SKMGZTopTerrain_TryLandInRightSector
                sub.w   d1,y_pos(a0)
                tst.w   y_vel(a0)
                bpl.s   SKMGZTopTerrain_RightCeilingReturn
                move.w  #0,y_vel(a0)

SKMGZTopTerrain_RightCeilingReturn:
                rts
; ---------------------------------------------------------------------------

SKMGZTopTerrain_TryLandInRightSector:
                tst.w   y_vel(a0)
                bmi.s   SKMGZTopTerrain_RightFloorReturn
                jsr     (Sonic_CheckFloor).l
                tst.w   d1
                bpl.s   SKMGZTopTerrain_RightFloorReturn
                add.w   d1,y_pos(a0)
                move.b  d3,angle(a0)
                bclr    #1,status(a0)
                move.b  #0,$2D(a0)
                move.w  #0,y_vel(a0)
                move.w  x_vel(a0),ground_vel(a0)

SKMGZTopTerrain_RightFloorReturn:
                rts
; End of function ResolveAirborneTopPlatformTerrain

; =============== S U B R O U T I N E =======================================

ControlTopRiderGroundSpeed:
                move.w  #$600,d6
                move.w  #$C,d5
                move.w  #$80,d4
                btst    #$A,d3
                beq.s   SKMGZTopRider_TryAccelerateRight
                bsr.w   AccelerateTopRiderLeft

SKMGZTopRider_TryAccelerateRight:
                btst    #$B,d3
                beq.s   SKMGZTopRider_TryApplyNoInputFriction
                bsr.w   AccelerateTopRiderRight

SKMGZTopRider_TryApplyNoInputFriction:
                move.w  d3,d0
                andi.w  #$C00,d0
                bne.s   SKMGZTopRider_SetMotionFromGroundSpeed
                move.w  ground_vel(a0),d0
                beq.s   SKMGZTopRider_SetMotionFromGroundSpeed
                bmi.s   SKMGZTopRider_ApplyNegativeFriction
                sub.w   d5,d0
                bcc.s   SKMGZTopRider_StorePositiveFriction
                move.w  #0,d0

SKMGZTopRider_StorePositiveFriction:
                move.w  d0,ground_vel(a0)
                bra.s   SKMGZTopRider_SetMotionFromGroundSpeed
; ---------------------------------------------------------------------------

SKMGZTopRider_ApplyNegativeFriction:
                add.w   d5,d0
                bcc.s   SKMGZTopRider_StoreNegativeFriction
                move.w  #0,d0

SKMGZTopRider_StoreNegativeFriction:
                move.w  d0,ground_vel(a0)

SKMGZTopRider_SetMotionFromGroundSpeed:
                move.w  ground_vel(a0),x_vel(a0)
                move.w  #0,y_vel(a0)
                rts
; End of function ControlTopRiderGroundSpeed

; =============== S U B R O U T I N E =======================================

AccelerateTopRiderLeft:
                move.w  ground_vel(a0),d0
                beq.s   SKMGZTopRider_FaceLeftForMotion
                bpl.s   SKMGZTopRider_BrakeMovingRight

SKMGZTopRider_FaceLeftForMotion:
                bset    #0,status(a0)
                bne.s   SKMGZTopRider_StepLeftAcceleration
                bclr    #5,status(a0)
                move.b  #1,prev_anim(a0)

SKMGZTopRider_StepLeftAcceleration:
                sub.w   d5,d0
                move.w  d6,d1
                neg.w   d1
                cmp.w   d1,d0
                bgt.s   SKMGZTopRider_StoreLeftSpeedAndPose
                add.w   d5,d0
                cmp.w   d1,d0
                ble.s   SKMGZTopRider_StoreLeftSpeedAndPose
                move.w  d1,d0

SKMGZTopRider_StoreLeftSpeedAndPose:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKMGZTopRider_BrakeMovingRight:
                sub.w   d4,d0
                bcc.s   SKMGZTopRider_StoreBrakeLeftAndTestSkid
                move.w  #-$80,d0

SKMGZTopRider_StoreBrakeLeftAndTestSkid:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   SKMGZTopRider_BrakeLeftReturn
                cmpi.w  #$400,d0
                blt.s   SKMGZTopRider_BrakeLeftReturn
                move.b  #$D,anim(a0)
                bclr    #0,status(a0)
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                movea.l a0,a2
                suba.w  #Player_1,a2
                adda.w  #Dust,a2
                move.b  #6,routine(a2)
                move.b  #$15,mapping_frame(a2)

SKMGZTopRider_BrakeLeftReturn:
                rts
; End of function AccelerateTopRiderLeft

; =============== S U B R O U T I N E =======================================

AccelerateTopRiderRight:
                move.w  ground_vel(a0),d0
                bmi.s   SKMGZTopRider_BrakeMovingLeft
                bclr    #0,status(a0)
                beq.s   SKMGZTopRider_StepRightAcceleration
                bclr    #5,status(a0)
                move.b  #1,prev_anim(a0)

SKMGZTopRider_StepRightAcceleration:
                add.w   d5,d0
                cmp.w   d6,d0
                blt.s   SKMGZTopRider_StoreRightSpeedAndPose
                sub.w   d5,d0
                cmp.w   d6,d0
                bge.s   SKMGZTopRider_StoreRightSpeedAndPose
                move.w  d6,d0

SKMGZTopRider_StoreRightSpeedAndPose:
                move.w  d0,ground_vel(a0)
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKMGZTopRider_BrakeMovingLeft:
                add.w   d4,d0
                bcc.s   SKMGZTopRider_StoreBrakeRightAndTestSkid
                move.w  #$80,d0

SKMGZTopRider_StoreBrakeRightAndTestSkid:
                move.w  d0,ground_vel(a0)
; These three instructions partially overwrite the inertia value in
; 'd0'! This causes the character to trigger their skidding
; animation at different speeds depending on whether they're going
; right or left. To fix this, make these instructions use 'd1'
; instead
                move.b  angle(a0),d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                bne.s   SKMGZTopRider_BrakeRightReturn
                cmpi.w  #-$400,d0
                bgt.s   SKMGZTopRider_BrakeRightReturn
                move.b  #$D,anim(a0)
                bset    #0,status(a0)
                move.w  #sfx_Skid,d0
                jsr     (Play_SFX).l
                movea.l a0,a2
                suba.w  #Player_1,a2
                adda.w  #Dust,a2
                move.b  #6,routine(a2)
                move.b  #$15,mapping_frame(a2)

SKMGZTopRider_BrakeRightReturn:
                rts
; End of function AccelerateTopRiderRight
