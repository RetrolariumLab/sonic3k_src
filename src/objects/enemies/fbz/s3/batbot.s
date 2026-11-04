; Owner: objects/enemies/fbz/s3
; Responsibility: Batbot flight and attack controller with private object and child construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Batbot:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Batbot_Index(pc,d0.w),d1
                jsr     Batbot_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Batbot_Index:
                dc.w    S3Batbot_InitAndSpawnVisuals-Batbot_Index
                dc.w    S3Batbot_WaitForNearbyPlayer-Batbot_Index
                dc.w    S3Batbot_AnimateAndChaseP1-Batbot_Index
; ---------------------------------------------------------------------------

S3Batbot_InitAndSpawnVisuals:
                lea     ObjDat_Batbot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     S3Batbot_VisualChildRecords(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

S3Batbot_WaitForNearbyPlayer:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                blo.s   S3Batbot_BeginPursuit
                rts
; ---------------------------------------------------------------------------

; The test uses the just-loaded $200 speed, so the initial X velocity is always positive
S3Batbot_BeginPursuit:
                move.b  #4,routine(a0)
                bset    #3,$38(a0)
                move.w  #$200,d0
                tst.w   d0
                bne.s   S3Batbot_SetInitialXSpeed
                neg.w   d0

S3Batbot_SetInitialXSpeed:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3Batbot_AnimateAndChaseP1:
                lea     BatbotS3_Body_UniformPursuitFrames(pc),a1
                jsr     Animate_RawNoSST(pc)
                lea     (Player_1).w,a1
                move.w  #$200,d0
                moveq   #8,d1
                jsr     Chase_Object(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

S3Batbot_UpdateLargeVisual:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3Batbot_LargeVisualStateTable(pc,d0.w),d1
                jsr     S3Batbot_LargeVisualStateTable(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
S3Batbot_LargeVisualStateTable:
                dc.w    S3Batbot_InitLargeVisual-S3Batbot_LargeVisualStateTable
                dc.w    BatbotS3_Visual_WaitForParentPursuitFlag-S3Batbot_LargeVisualStateTable
                dc.w    S3Batbot_AnimateLargeVisual-S3Batbot_LargeVisualStateTable
; ---------------------------------------------------------------------------

S3Batbot_InitLargeVisual:
                lea     BatbotS3_LargeVisual_PartialAttributes(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

BatbotS3_Visual_WaitForParentPursuitFlag:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   S3Batbot_ActivateVisual
                rts
; ---------------------------------------------------------------------------

S3Batbot_ActivateVisual:
                move.b  #4,routine(a0)
                addq.b  #1,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

S3Batbot_AnimateLargeVisual:
                lea     BatbotS3_LargeVisual_PairedActiveFrames(pc),a1
                jmp     Animate_RawNoSSTMultiDelay(pc)
; ---------------------------------------------------------------------------

S3Batbot_UpdateSmallVisual:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  S3Batbot_SmallVisualStateTable(pc,d0.w),d1
                jsr     S3Batbot_SmallVisualStateTable(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
S3Batbot_SmallVisualStateTable:
                dc.w    S3Batbot_InitSmallVisual-S3Batbot_SmallVisualStateTable
                dc.w    BatbotS3_Visual_WaitForParentPursuitFlag-S3Batbot_SmallVisualStateTable
                dc.w    S3Batbot_HoldSmallVisualFrame-S3Batbot_SmallVisualStateTable
; ---------------------------------------------------------------------------

S3Batbot_InitSmallVisual:
                lea     BatbotS3_SmallVisual_PartialAttributes(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

S3Batbot_HoldSmallVisualFrame:
                rts
; ---------------------------------------------------------------------------
ObjDat_Batbot:
                dc.l    Map_Batbot
                dc.w    make_art_tile(ArtTile_Batbot,1,1)
                dc.w    $280
                dc.b    $20,   8,   2,  $D
BatbotS3_LargeVisual_PartialAttributes:
                dc.w    $200
                dc.b    8,   8,   3,   0
BatbotS3_SmallVisual_PartialAttributes:
                dc.w    $200
                dc.b    4,   4,   5,   0
S3Batbot_VisualChildRecords:
                dc.w    2-1
                dc.l    S3Batbot_UpdateLargeVisual
                dc.b    0, $10
                dc.l    S3Batbot_UpdateSmallVisual
                dc.b    0,   3
BatbotS3_Body_UniformPursuitFrames:
                dc.b    2,   0,   1,   2,   1, $FC
BatbotS3_LargeVisual_PairedActiveFrames:
                dc.b    3, $1D
                dc.b    4,   2
                dc.b    3,   1
                dc.b    4,   2
                dc.b    3,  $E
                dc.b    4,   2
                dc.b    $FC
                even
