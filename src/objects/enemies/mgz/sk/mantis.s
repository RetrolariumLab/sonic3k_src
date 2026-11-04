; Owner: objects/enemies/mgz/sk
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
                dc.w    SKMantis_InitRootAndFollower-Mantis_Index
                dc.w    SKMantis_FaceNearestPlayer-Mantis_Index
                dc.w    SKMantis_AnimateJumpPrep-Mantis_Index
                dc.w    SKMantis_MoveAndTryLand-Mantis_Index
                dc.w    SKMantis_AnimateRecovery-Mantis_Index
; ---------------------------------------------------------------------------

SKMantis_InitRootAndFollower:
                lea     ObjDat_Mantis(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #$29,y_radius(a0)
                lea     MantisSK_Root_OneNormalFollowerRecord(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

SKMantis_FaceNearestPlayer:
                jsr     Find_SonicTails(pc)
                bclr    #0,render_flags(a0)
                tst.w   d0
                beq.s   SKMantis_CheckHorizontalJumpRange
                bset    #0,render_flags(a0)

SKMantis_CheckHorizontalJumpRange:
                cmpi.w  #$40,d2
                blo.s   SKMantis_BeginJumpPrep
                rts
; ---------------------------------------------------------------------------

SKMantis_BeginJumpPrep:
                move.b  #4,routine(a0)
                move.l  #MantisSK_Root_StartSixPixelUpwardJump,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKMantis_AnimateJumpPrep:
                lea     SKMantis_JumpPrepAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   SKMantis_JumpPrepReturn
                bmi.s   SKMantis_JumpPrepReturn
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                move.w  SKMantis_PrepYStepsByFrame(pc,d0.w),d0
                add.w   d0,y_pos(a0)

SKMantis_JumpPrepReturn:
                rts
; ---------------------------------------------------------------------------
SKMantis_PrepYStepsByFrame:
                dc.w    0,    -5,  -$13
; ---------------------------------------------------------------------------

MantisSK_Root_StartSixPixelUpwardJump:
                move.b  #6,routine(a0)
                move.w  #-$600,y_vel(a0)
                move.l  #SKMantis_BeginLandingRecovery,$34(a0)

SKMantis_JumpReturn:
                rts
; ---------------------------------------------------------------------------

SKMantis_MoveAndTryLand:
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   SKMantis_JumpReturn
                jmp     ObjHitFloor_DoRoutine(pc)
; ---------------------------------------------------------------------------

SKMantis_BeginLandingRecovery:
                move.b  #8,routine(a0)
                clr.w   y_vel(a0)
                move.l  #MantisSK_Root_ReturnToNearestPlayerPoll,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKMantis_AnimateRecovery:
                lea     SKMantis_LandingRecoveryAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.s   SKMantis_RecoveryReturn
                bmi.s   SKMantis_RecoveryReturn
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                move.w  SKMantis_RecoveryYStepsByFrame(pc,d0.w),d0
                add.w   d0,y_pos(a0)

SKMantis_RecoveryReturn:
                rts
; ---------------------------------------------------------------------------
SKMantis_RecoveryYStepsByFrame:
                dc.w    0,   $12,     6,    -1
; ---------------------------------------------------------------------------

MantisSK_Root_ReturnToNearestPlayerPoll:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKMantis_UpdateFollower:
                jsr     Refresh_ChildPositionAdjusted(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKMantis_FollowerStateOffsets(pc,d0.w),d1
                jsr     SKMantis_FollowerStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
SKMantis_FollowerStateOffsets:
                dc.w    SKMantis_InitFollower-SKMantis_FollowerStateOffsets
                dc.w    SKMantis_PickFollowerPose-SKMantis_FollowerStateOffsets
; ---------------------------------------------------------------------------

SKMantis_InitFollower:
                lea     MantisSK_Follower_PartialAttributePrefix(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

SKMantis_PickFollowerPose:
                movea.w parent3(a0),a1
                move.b  #5,mapping_frame(a0)
                tst.w   y_vel(a1)
                bmi.s   SKMantis_FollowerPoseReturn
                move.b  #4,mapping_frame(a0)

SKMantis_FollowerPoseReturn:
                rts
; ---------------------------------------------------------------------------
ObjDat_Mantis:
                dc.l    Map_Mantis
                dc.w    make_art_tile(ArtTile_Mantis,1,0)
                dc.w    $280
                dc.b    $14, $1C,   0, $1A
MantisSK_Follower_PartialAttributePrefix:
                dc.w    $200
                dc.b    4,   4,   5,   0
MantisSK_Root_OneNormalFollowerRecord:
                dc.w    1-1
                dc.l    SKMantis_UpdateFollower
                dc.b    -9, -$B
SKMantis_JumpPrepAnim:
                dc.b    0,   0
                dc.b    1,   2
                dc.b    2,   0
                dc.b    $F4
SKMantis_LandingRecoveryAnim:
                dc.b    2,   0
                dc.b    1,   2
                dc.b    3,   2
                dc.b    0, $1F
                dc.b    $F4
                even
