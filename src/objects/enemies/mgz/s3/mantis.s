; Owner: objects/enemies/mgz/s3
; Responsibility: Mantis enemy and projectile states with private child construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Mantis:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Mantis_Index(pc,d0.w),d1
                jsr     Mantis_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Mantis_Index:
                dc.w    S3Mantis_InitRootAndFollower-Mantis_Index
                dc.w    S3Mantis_FaceNearestPlayer-Mantis_Index
                dc.w    S3Mantis_AnimateJumpPrep-Mantis_Index
                dc.w    S3Mantis_MoveAndTryLand-Mantis_Index
                dc.w    S3Mantis_AnimateRecovery-Mantis_Index
; ---------------------------------------------------------------------------

S3Mantis_InitRootAndFollower:
                lea     ObjDat_Mantis(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$29,y_radius(a0)
                lea     MantisS3_Root_OneNormalFollowerRecord(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

S3Mantis_FaceNearestPlayer:
                jsr     Find_SonicTails(pc)
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   S3Mantis_CheckHorizontalJumpRange
                bset    #0,render_flags(a0)

S3Mantis_CheckHorizontalJumpRange:
                cmpi.w  #$40,d2
                blo.s   S3Mantis_BeginJumpPrep
                rts
; ---------------------------------------------------------------------------

S3Mantis_BeginJumpPrep:
                move.b  #4,routine(a0)
                move.l  #MantisS3_Root_StartSixPixelUpwardJump,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Mantis_AnimateJumpPrep:
                lea     S3Mantis_JumpPrepAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   S3Mantis_JumpPrepReturn
                bmi.s   S3Mantis_JumpPrepReturn
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                move.w  S3Mantis_PrepYStepsByFrame(pc,d0.w),d0
                add.w   d0,y_pos(a0)

S3Mantis_JumpPrepReturn:
                rts
; ---------------------------------------------------------------------------
S3Mantis_PrepYStepsByFrame:
                dc.w    0,    -5,  -$13
; ---------------------------------------------------------------------------

MantisS3_Root_StartSixPixelUpwardJump:
                move.b  #6,routine(a0)
                move.w  #-$600,y_vel(a0)
                move.l  #S3Mantis_BeginLandingRecovery,$34(a0)

S3Mantis_JumpReturn:
                rts
; ---------------------------------------------------------------------------

S3Mantis_MoveAndTryLand:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   S3Mantis_JumpReturn
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

S3Mantis_BeginLandingRecovery:
                move.b  #8,routine(a0)
                clr.w   y_vel(a0)
                move.l  #MantisS3_Root_ReturnToNearestPlayerPoll,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Mantis_AnimateRecovery:
                lea     S3Mantis_LandingRecoveryAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   S3Mantis_RecoveryReturn
                bmi.s   S3Mantis_RecoveryReturn
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                move.w  S3Mantis_RecoveryYStepsByFrame(pc,d0.w),d0
                add.w   d0,y_pos(a0)

S3Mantis_RecoveryReturn:
                rts
; ---------------------------------------------------------------------------
S3Mantis_RecoveryYStepsByFrame:
                dc.w    0,   $12,     6,    -1
; ---------------------------------------------------------------------------

MantisS3_Root_ReturnToNearestPlayerPoll:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3Mantis_UpdateFollower:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3Mantis_FollowerStateOffsets(pc,d0.w),d1
                jsr     S3Mantis_FollowerStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
S3Mantis_FollowerStateOffsets:
                dc.w    S3Mantis_InitFollower-S3Mantis_FollowerStateOffsets
                dc.w    S3Mantis_PickFollowerPose-S3Mantis_FollowerStateOffsets
; ---------------------------------------------------------------------------

S3Mantis_InitFollower:
                lea     MantisS3_Follower_PartialAttributePrefix(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

S3Mantis_PickFollowerPose:
                movea.w parent3(a0),a1
                move.b  #5,mapping_frame(a0)
                tst.w   y_vel(a1)
                bmi.s   S3Mantis_FollowerPoseReturn
                move.b  #4,mapping_frame(a0)

S3Mantis_FollowerPoseReturn:
                rts
; ---------------------------------------------------------------------------
ObjDat_Mantis:
                dc.l    Map_Mantis
                dc.w    make_art_tile(ArtTile_Mantis,1,0)
                dc.w    $280
                dc.b    $14, $1C,   0, $1A
MantisS3_Follower_PartialAttributePrefix:
                dc.w    $200
                dc.b    4,   4,   5,   0
MantisS3_Root_OneNormalFollowerRecord:
                dc.w    1-1
                dc.l    S3Mantis_UpdateFollower
                dc.b    -9, -$B
S3Mantis_JumpPrepAnim:
                dc.b    0,   0
                dc.b    1,   2
                dc.b    2,   0
                dc.b    $F4
S3Mantis_LandingRecoveryAnim:
                dc.b    2,   0
                dc.b    1,   2
                dc.b    3,   2
                dc.b    0, $1F
                dc.b    $F4
                even
