; Owner: objects/enemies/cnz/sk
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
                dc.w    SKSparkle_Init-Sparkle_Index
                dc.w    SKSparkle_WaitForNearbyPlayer-Sparkle_Index
                dc.w    SKSparkle_AnimateCharge-Sparkle_Index
                dc.w    SparkleSK_Root_RunPreAndPostTeleportWait-Sparkle_Index
                dc.w    SparkleSK_Root_RunPreAndPostTeleportWait-Sparkle_Index
; ---------------------------------------------------------------------------

SKSparkle_Init:
                lea     ObjDat_Sparkle(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

SKSparkle_WaitForNearbyPlayer:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                blo.s   SKSparkle_BeginCharge
                rts
; ---------------------------------------------------------------------------

SKSparkle_BeginCharge:
                move.b  #4,routine(a0)
                move.l  #SKSparkle_ChargeAnim,$30(a0)
                move.l  #SKSparkle_BeginHoldAndSpawnColumn,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)

SKSparkle_ShotTestReturn:
                rts
; ---------------------------------------------------------------------------

SKSparkle_AnimateCharge:
                jmp     Animate_RawGetFaster(pc)
; ---------------------------------------------------------------------------

SKSparkle_BeginHoldAndSpawnColumn:
                move.b  #6,routine(a0)
                move.w  #4,$2E(a0)
                move.l  #SKSparkle_PickTeleportDirection,$34(a0)
                lea     SparkleSK_Root_OneNormalColumnRecord(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

SparkleSK_Root_RunPreAndPostTeleportWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKSparkle_PickTeleportDirection:
                move.b  #8,routine(a0)
                moveq   #$68,d0
                bchg    #1,render_flags(a0)
                bne.s   SKSparkle_TeleportAndTryFirePair
                neg.w   d0

SKSparkle_TeleportAndTryFirePair:
                add.w   d0,y_pos(a0)
                move.w  #$20,$2E(a0)
                move.l  #SparkleSK_Root_RearmPlayerProximityPoll,$34(a0)
                moveq   #signextendB(sfx_Lightning),d0
                jsr     (Play_SFX).l
                tst.b   render_flags(a0)
                bpl.w   SKSparkle_ShotTestReturn
                lea     SKSparkle_ShotPairRecord(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------

SparkleSK_Root_RearmPlayerProximityPoll:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

SKSparkle_UpdateColumn:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SparkleSK_Column_TwoStateRelativeOffsets(pc,d0.w),d1
                jsr     SparkleSK_Column_TwoStateRelativeOffsets(pc,d1.w)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
SparkleSK_Column_TwoStateRelativeOffsets:
                dc.w    SKSparkle_InitColumn-SparkleSK_Column_TwoStateRelativeOffsets
                dc.w    SKSparkle_AnimateColumn-SparkleSK_Column_TwoStateRelativeOffsets
; ---------------------------------------------------------------------------

SKSparkle_InitColumn:
                lea     SKSparkle_ColumnAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bset    #5,shield_reaction(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                moveq   #$34,d0
                btst    #1,render_flags(a1)
                bne.s   SKSparkle_SetColumnOffset
                neg.w   d0

SKSparkle_SetColumnOffset:
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKSparkle_AnimateColumn:
                lea     SKSparkle_ColumnAnim(pc),a1
                jmp     Animate_RawNoSST(pc)
; ---------------------------------------------------------------------------

SKSparkle_UpdateProjectile:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKSparkle_ShotStateTable(pc,d0.w),d1
                jsr     SKSparkle_ShotStateTable(pc,d1.w)
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------
SKSparkle_ShotStateTable:
                dc.w    SKSparkle_InitShot-SKSparkle_ShotStateTable
                dc.w    SKSparkle_AnimateAndBrakeShot-SKSparkle_ShotStateTable
                dc.w    SKSparkle_CoastShot-SKSparkle_ShotStateTable
; ---------------------------------------------------------------------------

SKSparkle_InitShot:
                lea     SKSparkle_ShotAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bset    #5,shield_reaction(a0)
                movea.w parent3(a0),a1
                move.w  #$600,d0
                btst    #1,render_flags(a1)
                bne.s   SKSparkle_SetShotYAndSignX
                neg.w   d0

SKSparkle_SetShotYAndSignX:
                move.w  d0,y_vel(a0)
                move.w  #$600,d0
                tst.b   subtype(a0)
                bne.s   SKSparkle_SetShotX
                neg.w   d0

SKSparkle_SetShotX:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKSparkle_AnimateAndBrakeShot:
                lea     SparkleSK_Projectile_UniformTwoFrameLoop(pc),a1
                jsr     Animate_RawNoSST(pc)
                moveq   #$40,d0
                move.w  x_vel(a0),d1
                bmi.s   SKSparkle_TryBrakeShotX
                neg.w   d0

; If the candidate X speed is within $100 of zero, keep both old speeds
SKSparkle_TryBrakeShotX:
                add.w   d0,d1
                cmpi.w  #-$100,d1
                blt.s   SKSparkle_StoreXAndChooseYBrake
                cmpi.w  #$100,d1
                ble.s   SKSparkle_BeginShotCoast

SKSparkle_StoreXAndChooseYBrake:
                move.w  d1,x_vel(a0)
                moveq   #$40,d0
                move.w  y_vel(a0),d1
                bmi.s   SKSparkle_BrakeYAndMove
                neg.w   d0

SKSparkle_BrakeYAndMove:
                add.w   d0,d1
                move.w  d1,y_vel(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

SKSparkle_BeginShotCoast:
                move.b  #4,routine(a0)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

SKSparkle_CoastShot:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------
ObjDat_Sparkle:
                dc.l    Map_Sparkle
                dc.w    make_art_tile(ArtTile_Sparkle,1,1)
                dc.w    $280
                dc.b    $C,  $C,   0,  $B
SKSparkle_ColumnAttrs:
                dc.w    $200
                dc.b    $C, $40,   2, $AB
SKSparkle_ShotAttrs:
                dc.w    $280
                dc.b    8,   8,   6, $98
SparkleSK_Root_OneNormalColumnRecord:
                dc.w    1-1
                dc.l    SKSparkle_UpdateColumn
                dc.b    0,   0
SKSparkle_ShotPairRecord:
                dc.w    2-1
                dc.l    SKSparkle_UpdateProjectile
                dc.b    0,   0
SKSparkle_ChargeAnim:
                dc.b    9, $10
                dc.b    0,   1
                dc.b    $FC
SKSparkle_ColumnAnim:
                dc.b    0,   2,   8,   3,   8,   4,   8,   5,   8,   2, $F4
SparkleSK_Projectile_UniformTwoFrameLoop:
                dc.b    3,   6,   7, $FC
                even
