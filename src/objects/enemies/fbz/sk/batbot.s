; Owner: objects/enemies/fbz/sk
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
                dc.w    SKBatbot_InitAndSpawnVisuals-Batbot_Index
                dc.w    SKBatbot_WaitForNearbyPlayer-Batbot_Index
                dc.w    SKBatbot_AnimateAndChaseP1-Batbot_Index
; ---------------------------------------------------------------------------

SKBatbot_InitAndSpawnVisuals:
                lea     ObjDat_Batbot(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                lea     SKBatbot_VisualChildRecords(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

SKBatbot_WaitForNearbyPlayer:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                blo.s   SKBatbot_BeginPursuit
                rts
; ---------------------------------------------------------------------------

; The test uses the just-loaded $200 speed, so the initial X velocity is always positive
SKBatbot_BeginPursuit:
                move.b  #4,routine(a0)
                bset    #3,$38(a0)
                move.w  #$200,d0
                tst.w   d0
                bne.s   SKBatbot_SetInitialXSpeed
                neg.w   d0

SKBatbot_SetInitialXSpeed:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKBatbot_AnimateAndChaseP1:
                lea     BatbotSK_Body_UniformPursuitFrames(pc),a1
                jsr     Animate_RawNoSST(pc)
                lea     (Player_1).w,a1
                move.w  #$200,d0
                moveq   #8,d1
                jsr     Chase_Object(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

SKBatbot_UpdateLargeVisual:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKBatbot_LargeVisualStateTable(pc,d0.w),d1
                jsr     SKBatbot_LargeVisualStateTable(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
SKBatbot_LargeVisualStateTable:
                dc.w    SKBatbot_InitLargeVisual-SKBatbot_LargeVisualStateTable
                dc.w    BatbotSK_Visual_WaitForParentPursuitFlag-SKBatbot_LargeVisualStateTable
                dc.w    SKBatbot_AnimateLargeVisual-SKBatbot_LargeVisualStateTable
; ---------------------------------------------------------------------------

SKBatbot_InitLargeVisual:
                lea     BatbotSK_LargeVisual_PartialAttributes(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

BatbotSK_Visual_WaitForParentPursuitFlag:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.s   SKBatbot_ActivateVisual
                rts
; ---------------------------------------------------------------------------

SKBatbot_ActivateVisual:
                move.b  #4,routine(a0)
                addq.b  #1,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

SKBatbot_AnimateLargeVisual:
                lea     BatbotSK_LargeVisual_PairedActiveFrames(pc),a1
                jmp     Animate_RawNoSSTMultiDelay(pc)
; ---------------------------------------------------------------------------

SKBatbot_UpdateSmallVisual:
                jsr     Refresh_ChildPosition(pc)
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKBatbot_SmallVisualStateTable(pc,d0.w),d1
                jsr     SKBatbot_SmallVisualStateTable(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
SKBatbot_SmallVisualStateTable:
                dc.w    SKBatbot_InitSmallVisual-SKBatbot_SmallVisualStateTable
                dc.w    BatbotSK_Visual_WaitForParentPursuitFlag-SKBatbot_SmallVisualStateTable
                dc.w    SKBatbot_HoldSmallVisualFrame-SKBatbot_SmallVisualStateTable
; ---------------------------------------------------------------------------

SKBatbot_InitSmallVisual:
                lea     BatbotSK_SmallVisual_PartialAttributes(pc),a1
                jmp     SetUp_ObjAttributes3(pc)
; ---------------------------------------------------------------------------

SKBatbot_HoldSmallVisualFrame:
                rts
; ---------------------------------------------------------------------------
ObjDat_Batbot:
                dc.l    Map_Batbot
                dc.w    make_art_tile(ArtTile_Batbot,1,1)
                dc.w    $280
                dc.b    $20,   8,   2,  $D
BatbotSK_LargeVisual_PartialAttributes:
                dc.w    $200
                dc.b    8,   8,   3,   0
BatbotSK_SmallVisual_PartialAttributes:
                dc.w    $200
                dc.b    4,   4,   5,   0
SKBatbot_VisualChildRecords:
                dc.w    2-1
                dc.l    SKBatbot_UpdateLargeVisual
                dc.b    0, $10
                dc.l    SKBatbot_UpdateSmallVisual
                dc.b    0,   3
BatbotSK_Body_UniformPursuitFrames:
                dc.b    2,   0,   1,   2,   1, $FC
BatbotSK_LargeVisual_PairedActiveFrames:
                dc.b    3, $1D
                dc.b    4,   2
                dc.b    3,   1
                dc.b    4,   2
                dc.b    3,  $E
                dc.b    4,   2
                dc.b    $FC
                even
