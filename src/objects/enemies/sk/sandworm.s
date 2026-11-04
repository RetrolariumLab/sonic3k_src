; Owner: objects/enemies/sk
; Responsibility: Sandworm enemy, segment movement, collision and private construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Sandworm:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Sandworm_Index(pc,d0.w),d1
                jsr     Sandworm_Index(pc,d1.w)
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
Sandworm_Index:
                dc.w    SKSandworm_InitHeadAndSpawnSegments-Sandworm_Index
                dc.w    SKSandworm_TickLaunchWait-Sandworm_Index
                dc.w    SKSandworm_MoveArcAndCheckSubmerge-Sandworm_Index
                dc.w    SKSandworm_TickLaunchWait-Sandworm_Index
; ---------------------------------------------------------------------------

SKSandworm_InitHeadAndSpawnSegments:
                lea     ObjDat_Sandworm(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #7,$38(a0)
                move.l  #SandwormSK_Head_UniformFrameZeroTwoLoop,$30(a0)
                lea     SandwormSK_Head_FiveSimpleSegmentRecord(pc),a2
                jsr     (CreateChild6_Simple).l

SKSandworm_InitLaunchWaitAndTrails:
                move.w  #$7F,$2E(a0)
                move.l  #SKSandworm_InitArcCollision,$34(a0)
                btst    #7,$38(a0)
                beq.w   SKSandworm_ArcUpdateReturn
                lea     SKSandworm_HeadTrailChildren(pc),a2
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

SKSandworm_TickLaunchWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKSandworm_InitArcCollision:
                move.b  #4,routine(a0)
                move.b  #$8B,collision_flags(a0)
                btst    #7,$38(a0)
                beq.s   SKSandworm_SetArcOriginAndSpeed
                move.b  #$B,collision_flags(a0)

SKSandworm_SetArcOriginAndSpeed:
                move.w  y_pos(a0),$3A(a0)
                move.w  #-$400,y_vel(a0)
                moveq   #-$60,d0
                move.w  #-$200,d1
                btst    #0,render_flags(a0)
                beq.s   SKSandworm_ShiftXAndTryHeadSplash
                neg.w   d0
                neg.w   d1

SKSandworm_ShiftXAndTryHeadSplash:
                add.w   d0,x_pos(a0)
                move.w  d1,x_vel(a0)
                btst    #7,$38(a0)
                beq.w   SKSandworm_ArcUpdateReturn
                moveq   #signextendB(sfx_Splash2),d0
                jsr     (Play_SFX).l
                lea     SandwormSK_Head_ThreeNormalSplashRecords(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKSandworm_MoveArcAndCheckSubmerge:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite_LightGravity).l
                move.w  $3A(a0),d0
                cmp.w   y_pos(a0),d0
                bhi.w   SKSandworm_ArcUpdateReturn
                move.b  #6,routine(a0)
                clr.b   collision_flags(a0)
                move.w  d0,y_pos(a0)
                move.w  #$3F,$2E(a0)
                move.l  #SKSandworm_TurnAndRearmLaunch,$34(a0)
                btst    #7,$38(a0)
                beq.w   SKSandworm_ArcUpdateReturn
                moveq   #signextendB(sfx_Splash2),d0
                jsr     (Play_SFX).l
                lea     SandwormSK_Head_ThreeNormalSplashRecords(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKSandworm_TurnAndRearmLaunch:
                move.b  #2,routine(a0)
                bchg    #0,render_flags(a0)
                bra.w   SKSandworm_InitLaunchWaitAndTrails
; ---------------------------------------------------------------------------

SKSandwormSeg_DispatchSegmentAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKSandwormSeg_SegmentStateOffsets(pc,d0.w),d1
                jsr     SKSandwormSeg_SegmentStateOffsets(pc,d1.w)
                moveq   #0,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
SKSandwormSeg_SegmentStateOffsets:
                dc.w    SKSandwormSeg_InitSegmentAndDelay-SKSandwormSeg_SegmentStateOffsets
                dc.w    SKSandworm_TickLaunchWait-SKSandwormSeg_SegmentStateOffsets
                dc.w    SKSandworm_MoveArcAndCheckSubmerge-SKSandwormSeg_SegmentStateOffsets
                dc.w    SKSandworm_TickLaunchWait-SKSandwormSeg_SegmentStateOffsets
; ---------------------------------------------------------------------------

SKSandwormSeg_InitSegmentAndDelay:
                lea     SKSandwormSeg_SegmentAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKSandwormSeg_SegmentAnimation,$30(a0)
                jsr     (Change_FlipXUseParent).l
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                addq.w  #6,d0
                subq.w  #1,d0
                move.w  d0,$2E(a0)
                move.l  #SKSandworm_InitLaunchWaitAndTrails,$34(a0)

SKSandworm_ArcUpdateReturn:
                rts
; ---------------------------------------------------------------------------

SKSandwormTrail_InitTrailAndSpacing:
                lea     SandwormSK_Trail_ArtFirstAttributeRecord(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #SKSandwormTrail_TickHiddenDelay,(a0)
                move.l  #SKSandwormTrail_BeginTrailRise,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                move.w  d0,d1
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                bne.s   SKSandwormTrail_ApplySpacingAndTick
                neg.w   d0

SKSandwormTrail_ApplySpacingAndTick:
                add.w   d0,x_pos(a0)
                subq.w  #1,d1
                move.w  d1,$2E(a0)

SKSandwormTrail_TickHiddenDelay:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKSandwormTrail_BeginTrailRise:
                move.l  #SKSandwormTrail_MoveAndDrawTrail,(a0)
                move.l  #SKSandwormTrail_TrailAnimation,$30(a0)
                move.w  #-$80,y_vel(a0)
                move.w  #$F,$2E(a0)
                move.l  #SKSandwormTrail_BeginTrailFall,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKSandwormTrail_MoveAndDrawTrail:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSandwormTrail_BeginTrailFall:
                move.w  #$40,y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKSandwormSplash_DispatchSplashAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKSandwormSplash_SplashStateOffsets(pc,d0.w),d1
                jsr     SKSandwormSplash_SplashStateOffsets(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
SKSandwormSplash_SplashStateOffsets:
                dc.w    SKSandwormSplash_InitSplashAndDelay-SKSandwormSplash_SplashStateOffsets
                dc.w    SKSandwormSplash_TickSplashDelay-SKSandwormSplash_SplashStateOffsets
                dc.w    SKSandwormSplash_MoveAndAnimateRise-SKSandwormSplash_SplashStateOffsets
                dc.w    SKSandwormSplash_SelectBobStep-SKSandwormSplash_SplashStateOffsets
                dc.w    SKSandwormSplash_AnimateSplashFade-SKSandwormSplash_SplashStateOffsets
; ---------------------------------------------------------------------------

SKSandwormSplash_InitSplashAndDelay:
                lea     SKSandwormSplash_SplashAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  d0,$2E(a0)
                move.l  #SKSandwormSplash_BeginSplashRise,$34(a0)

SKSandwormSplash_TickSplashDelay:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKSandwormSplash_BeginSplashRise:
                move.b  #4,routine(a0)
                move.l  #SKSandwormSplash_RiseAnimation,$30(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #7,$2E(a0)
                move.l  #SKSandwormSplash_BeginSplashBob,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKSandwormSplash_MoveAndAnimateRise:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKSandwormSplash_BeginSplashBob:
                move.b  #6,routine(a0)
                move.w  #$17,$2E(a0)
                move.l  #SKSandwormSplash_BeginSplashFade,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKSandwormSplash_SelectBobStep:
                moveq   #8,d0
                btst    #0,$2F(a0)
                bne.s   SKSandwormSplash_ApplyBobAndAnimate
                neg.w   d0

SKSandwormSplash_ApplyBobAndAnimate:
                add.w   d0,y_pos(a0)
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKSandwormSplash_BeginSplashFade:
                move.b  #8,routine(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                move.l  #SKSandwormSplash_FadeAnimation,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKSandwormSplash_AnimateSplashFade:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------
ObjDat_Sandworm:
                dc.l    Map_Sandworm
                dc.w    make_art_tile(ArtTile_Sandworm,1,0)
                dc.w    $280
                dc.b    8,  $C,   0,   0
SandwormSK_Trail_ArtFirstAttributeRecord:
                dc.w    make_art_tile(ArtTile_Sandworm,2,0)
                dc.w    $200
                dc.b    8,   4,   3,   0
SKSandwormSplash_SplashAttributes:
                dc.w    make_art_tile(ArtTile_Sandworm,2,0)
                dc.w    $200
                dc.b    4, $10,   5,   0
SKSandwormSeg_SegmentAttributes:
                dc.w    $280
                dc.b    8,   8,   1,   0
SandwormSK_Head_FiveSimpleSegmentRecord:
                dc.w    5-1
                dc.l    SKSandwormSeg_DispatchSegmentAndDraw
SKSandworm_HeadTrailChildren:
                dc.w    8-1
                dc.l    SKSandwormTrail_InitTrailAndSpacing
                dc.b    0,  -8
SandwormSK_Head_ThreeNormalSplashRecords:
                dc.w    3-1
                dc.l    SKSandwormSplash_DispatchSplashAndDraw
                dc.b    0,   4
                dc.l    SKSandwormSplash_DispatchSplashAndDraw
                dc.b    -4,   4
                dc.l    SKSandwormSplash_DispatchSplashAndDraw
                dc.b    4,   4
SKSandwormTrail_TrailAnimation:
                dc.b    1,   3,   4, $FC
SandwormSK_Head_UniformFrameZeroTwoLoop:
                dc.b    9,   0,   2, $FC
SKSandwormSeg_SegmentAnimation:
                dc.b    $7E,   1,   1, $FC
SKSandwormSplash_RiseAnimation:
                dc.b    1,   5,   6, $FC
SKSandwormSplash_FadeAnimation:
                dc.b    7,   3
                dc.b    7,   3
                dc.b    8,   5
                dc.b    $F4
                even
