; Owner: objects/enemies/cnz/s3
; Responsibility: Sparkle controller and child actors with private attributes and construction data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Sparkle:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Sparkle_Index(pc,d0.w),d1
                jsr     Sparkle_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Sparkle_Index:
                dc.w    S3Sparkle_Init-Sparkle_Index
                dc.w    S3Sparkle_WaitForNearbyPlayer-Sparkle_Index
                dc.w    S3Sparkle_AnimateCharge-Sparkle_Index
                dc.w    SparkleS3_Root_RunPreAndPostTeleportWait-Sparkle_Index
                dc.w    SparkleS3_Root_RunPreAndPostTeleportWait-Sparkle_Index
; ---------------------------------------------------------------------------

S3Sparkle_Init:
                lea     ObjDat_Sparkle(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

S3Sparkle_WaitForNearbyPlayer:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                blo.s   S3Sparkle_BeginCharge
                rts
; ---------------------------------------------------------------------------

S3Sparkle_BeginCharge:
                move.b  #4,routine(a0)
                move.l  #S3Sparkle_ChargeAnim,$30(a0)
                move.l  #S3Sparkle_BeginHoldAndSpawnColumn,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)

S3Sparkle_ShotTestReturn:
                rts
; ---------------------------------------------------------------------------

S3Sparkle_AnimateCharge:
                jmp     Animate_RawGetFaster(pc)
; ---------------------------------------------------------------------------

S3Sparkle_BeginHoldAndSpawnColumn:
                move.b  #6,routine(a0)
                move.w  #4,$2E(a0)
                move.l  #S3Sparkle_PickTeleportDirection,$34(a0)
                lea     SparkleS3_Root_OneNormalColumnRecord(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

SparkleS3_Root_RunPreAndPostTeleportWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3Sparkle_PickTeleportDirection:
                move.b  #8,routine(a0)
                moveq   #$68,d0
                bchg    #1,render_flags(a0)
                bne.s   S3Sparkle_TeleportAndTryFirePair
                neg.w   d0

S3Sparkle_TeleportAndTryFirePair:
                add.w   d0,y_pos(a0)
                move.w  #$20,$2E(a0)
                move.l  #SparkleS3_Root_RearmPlayerProximityPoll,$34(a0)
                moveq   #signextendB(sfx_Lightning),d0
                jsr     (Play_SFX).l
                tst.b   render_flags(a0)
                bpl.w   S3Sparkle_ShotTestReturn
                lea     S3Sparkle_ShotPairRecord(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

SparkleS3_Root_RearmPlayerProximityPoll:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

S3Sparkle_UpdateColumn:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SparkleS3_Column_TwoStateRelativeOffsets(pc,d0.w),d1
                jsr     SparkleS3_Column_TwoStateRelativeOffsets(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
SparkleS3_Column_TwoStateRelativeOffsets:
                dc.w    S3Sparkle_InitColumn-SparkleS3_Column_TwoStateRelativeOffsets
                dc.w    S3Sparkle_AnimateColumn-SparkleS3_Column_TwoStateRelativeOffsets
; ---------------------------------------------------------------------------

S3Sparkle_InitColumn:
                lea     S3Sparkle_ColumnAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bset    #5,shield_reaction(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                moveq   #$34,d0
                btst    #1,render_flags(a1)
                bne.s   S3Sparkle_SetColumnOffset
                neg.w   d0

S3Sparkle_SetColumnOffset:
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3Sparkle_AnimateColumn:
                lea     S3Sparkle_ColumnAnim(pc),a1
                jmp     Animate_RawNoSST(pc)
; ---------------------------------------------------------------------------

S3Sparkle_UpdateProjectile:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3Sparkle_ShotStateTable(pc,d0.w),d1
                jsr     S3Sparkle_ShotStateTable(pc,d1.w)
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------
S3Sparkle_ShotStateTable:
                dc.w    S3Sparkle_InitShot-S3Sparkle_ShotStateTable
                dc.w    S3Sparkle_AnimateAndBrakeShot-S3Sparkle_ShotStateTable
                dc.w    S3Sparkle_CoastShot-S3Sparkle_ShotStateTable
; ---------------------------------------------------------------------------

S3Sparkle_InitShot:
                lea     S3Sparkle_ShotAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bset    #5,shield_reaction(a0)
                movea.w parent3(a0),a1
                move.w  #$600,d0
                btst    #1,render_flags(a1)
                bne.s   S3Sparkle_SetShotYAndSignX
                neg.w   d0

S3Sparkle_SetShotYAndSignX:
                move.w  d0,y_vel(a0)
                move.w  #$600,d0
                tst.b   subtype(a0)
                bne.s   S3Sparkle_SetShotX
                neg.w   d0

S3Sparkle_SetShotX:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3Sparkle_AnimateAndBrakeShot:
                lea     SparkleS3_Projectile_UniformTwoFrameLoop(pc),a1
                jsr     Animate_RawNoSST(pc)
                moveq   #$40,d0
                move.w  x_vel(a0),d1
                bmi.s   S3Sparkle_TryBrakeShotX
                neg.w   d0

; If the candidate X speed is within $100 of zero, keep both old speeds
S3Sparkle_TryBrakeShotX:
                add.w   d0,d1
                cmpi.w  #-$100,d1
                blt.s   S3Sparkle_StoreXAndChooseYBrake
                cmpi.w  #$100,d1
                ble.s   S3Sparkle_BeginShotCoast

S3Sparkle_StoreXAndChooseYBrake:
                move.w  d1,x_vel(a0)
                moveq   #$40,d0
                move.w  y_vel(a0),d1
                bmi.s   S3Sparkle_BrakeYAndMove
                neg.w   d0

S3Sparkle_BrakeYAndMove:
                add.w   d0,d1
                move.w  d1,y_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

S3Sparkle_BeginShotCoast:
                move.b  #4,routine(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

S3Sparkle_CoastShot:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------
ObjDat_Sparkle:
                dc.l    Map_Sparkle
                dc.w    make_art_tile(ArtTile_Sparkle,1,1)
                dc.w    $280
                dc.b    $C,  $C,   0,  $B
S3Sparkle_ColumnAttrs:
                dc.w    $200
                dc.b    $C, $40,   2, $AB
S3Sparkle_ShotAttrs:
                dc.w    $280
                dc.b    8,   8,   6, $98
SparkleS3_Root_OneNormalColumnRecord:
                dc.w    1-1
                dc.l    S3Sparkle_UpdateColumn
                dc.b    0,   0
S3Sparkle_ShotPairRecord:
                dc.w    2-1
                dc.l    S3Sparkle_UpdateProjectile
                dc.b    0,   0
S3Sparkle_ChargeAnim:
                dc.b    9, $10
                dc.b    0,   1
                dc.b    $FC
S3Sparkle_ColumnAnim:
                dc.b    0,   2,   8,   3,   8,   4,   8,   5,   8,   2, $F4
SparkleS3_Projectile_UniformTwoFrameLoop:
                dc.b    3,   6,   7, $FC
                even
