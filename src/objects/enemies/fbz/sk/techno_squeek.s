; Owner: objects/enemies/fbz/sk
; Responsibility: Techno Squeek movement and attack states with private child and object resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_TechnoSqueek:
                jsr     (Obj_WaitOffscreen).l

Obj_TechnoSqueek_2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Technosqueek_Index(pc,d0.w),d1
                jsr     Technosqueek_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Technosqueek_Index:
                dc.w    SKTechnoSqueek_InitSwingMode-Technosqueek_Index
                dc.w    SKTechnoSqueek_AnimateHorizontalSwing-Technosqueek_Index
                dc.w    SKTechnoSqueek_AnimateHorizontalTurn-Technosqueek_Index
                dc.w    SKTechnoSqueek_AnimateVerticalSwing-Technosqueek_Index
                dc.w    SKTechnoSqueek_AnimateVerticalTurn-Technosqueek_Index
; ---------------------------------------------------------------------------

SKTechnoSqueek_InitSwingMode:
                move.w  #$800,$2E(a0)
                move.l  #SKTechnoSqueek_UnfreezeVisual,$34(a0)
                cmpi.b  #4,subtype(a0)
                beq.s   SKTechnoSqueek_InitVerticalSwing
                lea     SKTechnoSqueek_HorizontalAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKTechnoSqueek_FirstHorizontalAnim,$30(a0)
                bset    #0,render_flags(a0)
                cmpi.b  #2,subtype(a0)
                bne.s   SKTechnoSqueek_InitHorizontalSwing
                bset    #1,render_flags(a0)

SKTechnoSqueek_InitHorizontalSwing:
                lea     SKTechnoSqueek_VisualChildRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  #$400,d0
                move.w  d0,$3A(a0)
                move.w  d0,x_vel(a0)
                move.w  #$20,$3C(a0)
                bclr    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKTechnoSqueek_InitVerticalSwing:
                lea     SKTechnoSqueek_VerticalAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #6,routine(a0)
                move.l  #SKTechnoSqueek_FirstVerticalAnim,$30(a0)
                bset    #1,render_flags(a0)
                lea     SKTechnoSqueek_VisualChildRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  #$400,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$20,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKTechnoSqueek_AnimateHorizontalSwing:
                jsr     Animate_RawMultiDelayFlipX(pc)
                tst.w   d2
                beq.s   SKTechnoSqueek_StepHorizontalSwing
                cmpi.b  #6,anim_frame(a0)
                bne.s   SKTechnoSqueek_StepHorizontalSwing
                bset    #1,$38(a0)

SKTechnoSqueek_StepHorizontalSwing:
                jsr     Swing_LeftAndRight(pc)
                tst.w   x_vel(a0)
                beq.s   SKTechnoSqueek_BeginHorizontalTurn
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKTechnoSqueek_BeginHorizontalTurn:
                move.b  #4,routine(a0)
                move.l  #SKTechnoSqueek_HorizontalTurnAnim,$30(a0)
                move.l  #SKTechnoSqueek_ResumeHorizontalSwing,$34(a0)

SKTechnoSqueek_ResetAnimCursorAndDelay:
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

SKTechnoSqueek_UnfreezeVisual:
                bclr    #5,$38(a0)

SKTechnoSqueek_SwingReturn:
                rts
; ---------------------------------------------------------------------------

SKTechnoSqueek_AnimateHorizontalTurn:
                jmp     Animate_RawAdjustFlipX(pc)
; ---------------------------------------------------------------------------

SKTechnoSqueek_ResumeHorizontalSwing:
                move.b  #2,routine(a0)
                move.l  #SKTechnoSqueek_RepeatHorizontalAnim,$30(a0)

SKTechnoSqueek_FreezeVisualAndResetAnim:
                bclr    #1,$38(a0)
                bset    #5,$38(a0)
                move.w  #$10,$2E(a0)
                move.l  #SKTechnoSqueek_UnfreezeVisual,$34(a0)
                bra.s   SKTechnoSqueek_ResetAnimCursorAndDelay
; ---------------------------------------------------------------------------

SKTechnoSqueek_AnimateVerticalSwing:
                jsr     Animate_RawMultiDelayFlipY(pc)
                tst.w   d2
                beq.s   SKTechnoSqueek_StepVerticalSwing
                cmpi.b  #6,anim_frame(a0)
                bne.s   SKTechnoSqueek_StepVerticalSwing
                bset    #1,$38(a0)

SKTechnoSqueek_StepVerticalSwing:
                jsr     Swing_UpAndDown(pc)
                tst.w   y_vel(a0)
                beq.s   SKTechnoSqueek_BeginVerticalTurn
                jsr     (MoveSprite2).l
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

SKTechnoSqueek_BeginVerticalTurn:
                move.b  #8,routine(a0)
                move.l  #SKTechnoSqueek_VerticalTurnAnim,$30(a0)
                move.l  #SKTechnoSqueek_ResumeVerticalSwing,$34(a0)
                bra.w   SKTechnoSqueek_ResetAnimCursorAndDelay
; ---------------------------------------------------------------------------

SKTechnoSqueek_AnimateVerticalTurn:
                jmp     Animate_RawAdjustFlipY(pc)
; ---------------------------------------------------------------------------

SKTechnoSqueek_ResumeVerticalSwing:
                move.b  #6,routine(a0)
                move.l  #SKTechnoSqueek_RepeatVerticalAnim,$30(a0)
                bra.s   SKTechnoSqueek_FreezeVisualAndResetAnim
; ---------------------------------------------------------------------------

SKTechnoSqueek_UpdateVisual:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKTechnoSqueek_VisualStateTable(pc,d0.w),d1
                jsr     SKTechnoSqueek_VisualStateTable(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
SKTechnoSqueek_VisualStateTable:
                dc.w    SKTechnoSqueek_InitVisual-SKTechnoSqueek_VisualStateTable
                dc.w    SKTechnoSqueek_AnimateHorizontalVisual-SKTechnoSqueek_VisualStateTable
                dc.w    SKTechnoSqueek_AnimateVerticalVisual-SKTechnoSqueek_VisualStateTable
; ---------------------------------------------------------------------------

SKTechnoSqueek_InitVisual:
                lea     TechnoSqueekSK_Visual_PartialAttributes(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                movea.w parent3(a0),a1
                cmpi.b  #4,subtype(a1)
                bne.s   SKTechnoSqueek_VisualReturn
                move.b  #4,routine(a0)

SKTechnoSqueek_VisualReturn:
                rts
; ---------------------------------------------------------------------------

SKTechnoSqueek_AnimateHorizontalVisual:
                lea     SKTechnoSqueek_HorizontalVisualAnim(pc),a1
                jsr     Animate_RawNoSST(pc)
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                btst    #1,$38(a1)
                beq.s   SKTechnoSqueek_UpdateHorizontalOffset
                moveq   #2,d0

SKTechnoSqueek_UpdateHorizontalOffset:
                add.w   d0,d0
                move.w  SKTechnoSqueek_HorizontalOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                btst    #5,$38(a1)
                bne.w   SKTechnoSqueek_SwingReturn
                jmp     Refresh_ChildPositionAdjusted(pc)
; ---------------------------------------------------------------------------
SKTechnoSqueek_HorizontalOffsets:
                dc.b    $14,   4
                dc.b    $C,   4
                dc.b    0,   4
                even
; ---------------------------------------------------------------------------

SKTechnoSqueek_AnimateVerticalVisual:
                lea     SKTechnoSqueek_VerticalVisualAnim(pc),a1
                jsr     Animate_RawNoSST(pc)
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                subq.w  #5,d0
                btst    #1,$38(a1)
                beq.s   SKTechnoSqueek_UpdateVerticalOffset
                moveq   #2,d0

SKTechnoSqueek_UpdateVerticalOffset:
                add.w   d0,d0
                move.w  SKTechnoSqueek_VerticalOffsets(pc,d0.w),child_dx(a0)  ; and child_dy
                btst    #5,$38(a1)
                bne.w   SKTechnoSqueek_SwingReturn
                jmp     Refresh_ChildPositionAdjusted(pc)
; ---------------------------------------------------------------------------
SKTechnoSqueek_VerticalOffsets:
                dc.b    -4, $14
                dc.b    -4,  $C
                dc.b    -4,   0
                even
; ---------------------------------------------------------------------------

SKTechnoSqueek_UpdateCapsuleSpawn:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  SKTechnoSqueek_CapsuleStateTable(pc,d0.w),d1
                jsr     SKTechnoSqueek_CapsuleStateTable(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
SKTechnoSqueek_CapsuleStateTable:
                dc.w    SKTechnoSqueek_InitCapsuleLaunch-SKTechnoSqueek_CapsuleStateTable
                dc.w    SKTechnoSqueek_FallFromCapsule-SKTechnoSqueek_CapsuleStateTable
; ---------------------------------------------------------------------------

SKTechnoSqueek_InitCapsuleLaunch:
                lea     SKTechnoSqueek_HorizontalAttrs(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #7,y_radius(a0)
                move.l  #SKTechnoSqueek_JoinSwingOnLanding,$34(a0)
                move.w  #$90,d0
                jsr     (Set_IndexedVelocity).l
                jsr     (Change_FlipXWithVelocity).l
                clr.b   subtype(a0)
                lea     SKTechnoSqueek_VisualChildRecord(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

SKTechnoSqueek_FallFromCapsule:
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.w   SKTechnoSqueek_SwingReturn
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

SKTechnoSqueek_JoinSwingOnLanding:
                move.l  #Obj_TechnoSqueek_2,(a0)
                move.b  #2,routine(a0)
                move.w  #$800,$2E(a0)
                move.l  #SKTechnoSqueek_UnfreezeVisual,$34(a0)
                move.l  #SKTechnoSqueek_FirstHorizontalAnim,$30(a0)
                move.w  #$400,d0
                move.w  d0,$3A(a0)
                bclr    #3,$38(a0)
                btst    #0,render_flags(a0)
                bne.s   SKTechnoSqueek_SetLandingSwingSpeed
                neg.w   d0
                bset    #3,$38(a0)

SKTechnoSqueek_SetLandingSwingSpeed:
                move.w  d0,x_vel(a0)
                move.w  #$20,$3C(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------
SKTechnoSqueek_HorizontalAttrs:
                dc.l    Map_TechnoSqueek
                dc.w    make_art_tile(ArtTile_Technosqueek,1,1)
                dc.w    $280
                dc.b    $C,   8,   0,  $B
SKTechnoSqueek_VerticalAttrs:
                dc.l    Map_TechnoSqueek
                dc.w    make_art_tile(ArtTile_Technosqueek,1,1)
                dc.w    $280
                dc.b    8,  $C,   5,  $B
TechnoSqueekSK_Visual_PartialAttributes:
                dc.w    $280
                dc.b    8,   4,   2,   0
SKTechnoSqueek_VisualChildRecord:
                dc.w    1-1
                dc.l    SKTechnoSqueek_UpdateVisual
                dc.b    $14,   4
SKTechnoSqueek_FirstHorizontalAnim:
                dc.b    0,       0
                dc.b    0,     $17
                dc.b    1,       1
                dc.b    1|$40,   1
                dc.b    0,     $1F
                dc.b    $F4
SKTechnoSqueek_RepeatHorizontalAnim:
                dc.b    0,       0
                dc.b    0,     $37
                dc.b    1,       1
                dc.b    1|$40,   1
                dc.b    0,     $1F
                dc.b    $F4
SKTechnoSqueek_HorizontalTurnAnim:
                dc.b    3,   0,   0,   1, 1|$40,   0,   0,   1, 1|$40,   0, $F4
SKTechnoSqueek_HorizontalVisualAnim:
                dc.b    3,   2,   3,   4, $FC
SKTechnoSqueek_FirstVerticalAnim:
                dc.b    5,       0
                dc.b    5,     $17
                dc.b    6,       1
                dc.b    6|$40,   1
                dc.b    0,     $1F
                dc.b    $F4
SKTechnoSqueek_RepeatVerticalAnim:
                dc.b    5,       0
                dc.b    5,     $37
                dc.b    6,       1
                dc.b    6|$40,   1
                dc.b    5,     $1F
                dc.b    $F4
SKTechnoSqueek_VerticalTurnAnim:
                dc.b    3,   5,   5,   6, 6|$40,   5,   5,   6, 6|$40,   5, $F4
SKTechnoSqueek_VerticalVisualAnim:
                dc.b    3,   7,   8,   9, $FC
                even
Map_TechnoSqueek:
                include "src/objects/shared/technosqueek/mappings/technosqueek.s"
; ---------------------------------------------------------------------------

Obj_FBZEggPrison:
                lea     ObjDat_FBZEggPrison(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKFBZEggPrison_CheckButtonAndSaveOpened,(a0)
                lea     FBZEggPrisonSK_OneNormalButtonRecord(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.w  respawn_addr(a0),d0
                beq.s   SKFBZEggPrison_InitReturn
                movea.w d0,a2
                btst    #0,(a2)
                beq.s   SKFBZEggPrison_InitReturn
                move.l  #FBZEggPrisonSK_ResolveSolidThenTouchCull,(a0)
                move.b  #1,mapping_frame(a0)
                bset    #5,$38(a0)

SKFBZEggPrison_InitReturn:
                rts
; ---------------------------------------------------------------------------

SKFBZEggPrison_CheckButtonAndSaveOpened:
                btst    #1,$38(a0)
                beq.s   FBZEggPrisonSK_ResolveSolidThenTouchCull
                move.l  #FBZEggPrisonSK_ResolveSolidThenTouchCull,(a0)
                move.b  #1,mapping_frame(a0)
                move.w  respawn_addr(a0),d0
                beq.s   SKFBZEggPrison_ReleaseContentsAndExplode
                movea.w d0,a2
                bset    #0,(a2)

SKFBZEggPrison_ReleaseContentsAndExplode:
                bsr.w   DispatchFbzEggPrisonContentsBySubtype
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   SKFBZEggPrison_TrySpawnFragments
                move.b  #8,subtype(a1)

SKFBZEggPrison_TrySpawnFragments:
                lea     FBZEggPrisonSK_FiveNormalFragmentRecords(pc),a2
                jsr     CreateChild1_Normal(pc)

FBZEggPrisonSK_ResolveSolidThenTouchCull:
                bsr.w   CollideFbzEggPrisonAsSolidRectangle
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKFBZPrisonButton_InitButtonFromParent:
                lea     (SKCapsule_SharedButtonPartialAttributes).l,a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #SKEggCapsule_CheckGroundButtonPress,(a0)
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                beq.s   SKFBZPrisonButton_InitReturn
                move.l  #SKEggCapsule_DrawPressedGroundButton,(a0)
                move.b  #$C,mapping_frame(a0)

SKFBZPrisonButton_InitReturn:
                rts
; ---------------------------------------------------------------------------

Obj_FBZSpringPlunger:
                lea     ObjDat_FBZSpringPlunger(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.b  #5,mapping_frame(a0)
                jsr     (SKCapsule_CollideButtonOrPlunger).l
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   SKFBZPlunger_CullAndDraw
                move.b  #6,mapping_frame(a0)
                btst    #p1_standing_bit,d0
                beq.s   SKFBZPlunger_TryLaunchP2
                move.b  #$C,mapping_frame(a0)
                lea     (Player_1).w,a1
                move.w  #-$A00,d0
                jsr     (LaunchPlayerWithSpringVelocity).l

; Read the P2 standing bit from d0 as it stands after the P1 path
SKFBZPlunger_TryLaunchP2:
                btst    #p2_standing_bit,d0
                beq.s   SKFBZPlunger_CullAndDraw
                move.b  #$C,mapping_frame(a0)
                lea     (Player_2).w,a1
                move.w  #-$A00,d0
                jsr     (LaunchPlayerWithSpringVelocity).l

SKFBZPlunger_CullAndDraw:
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

SKFBZCapsuleAnimal_InitSpeciesAndLaunch:
                lea     FBZCapsuleAnimalSK_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKFBZCapsuleAnimal_TickLaunchStagger,(a0)
                move.b  #8,y_radius(a0)
                bsr.w   FBZCapsuleAnimal_InitRelease
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKFBZCapsuleAnimal_TickLaunchStagger:
                subq.w  #1,$2E(a0)
                bpl.s   FBZCapsuleAnimalSK_CullDrawWithoutMotion
                move.l  #SKFBZCapsuleAnimal_MoveAndBounce,(a0)
                move.w  #$80,priority(a0)

FBZCapsuleAnimalSK_CullDrawWithoutMotion:
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

SKFBZCapsuleAnimal_MoveAndBounce:
                jsr     MoveSprite_LightGravity(pc)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKFBZCapsuleAnimal_ChooseVIntFrame
                add.w   d1,y_pos(a0)
                move.w  $3E(a0),y_vel(a0)

SKFBZCapsuleAnimal_ChooseVIntFrame:
                moveq   #0,d0
                btst    #3,(V_int_run_count+3).w
                bne.s   SKFBZCapsuleAnimal_SetFrameAndDraw
                moveq   #1,d0

SKFBZCapsuleAnimal_SetFrameAndDraw:
                move.b  d0,mapping_frame(a0)
                jmp     Sprite_CheckDelete(pc)
; ---------------------------------------------------------------------------

SKFBZCapsuleRing_InitRingLaunch:
                lea     FBZCapsuleRingSK_FullAttributes(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #Obj_Bouncing_Ring,(a0)
                move.b  #-1,(Ring_spill_anim_counter).w
                move.b  #8,y_radius(a0)
                move.b  #8,x_radius(a0)
                move.b  #$84,render_flags(a0)
                moveq   #4,d0
                jsr     (Set_IndexedVelocity).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKFBZPrisonFrag_InitFragmentLaunch:
                lea     FBZEggPrisonFragmentSK_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Obj_FlickerMove,(a0)
                jsr     (CapsuleSKSelectFragmentFrameFromSubtype).l
                moveq   #4,d0
                jsr     (Set_IndexedVelocity).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CollideFbzEggPrisonAsSolidRectangle:
                moveq   #$2B,d1
                moveq   #$18,d2
                moveq   #$18,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function CollideFbzEggPrisonAsSolidRectangle

; =============== S U B R O U T I N E =======================================

DispatchFbzEggPrisonContentsBySubtype:
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.w  SKFBZEggPrison_ContentsTable(pc,d0.w),d0
                jmp     SKFBZEggPrison_ContentsTable(pc,d0.w)
; End of function DispatchFbzEggPrisonContentsBySubtype

; ---------------------------------------------------------------------------
SKFBZEggPrison_ContentsTable:
                dc.w    FBZEggPrisonSK_TryFiveAnimals-SKFBZEggPrison_ContentsTable
                dc.w    SKFBZEggPrison_ReleaseRings-SKFBZEggPrison_ContentsTable
                dc.w    SKFBZEggPrison_ReleaseEnemies-SKFBZEggPrison_ContentsTable
                dc.w    set_Hyudoro-SKFBZEggPrison_ContentsTable
; ---------------------------------------------------------------------------

FBZEggPrisonSK_TryFiveAnimals:
                lea     FBZEggPrisonSK_FiveNormalAnimalRecords(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

SKFBZEggPrison_ReleaseRings:
                move.w  #signextendB(sfx_RingLoss),d0
                jsr     (Play_SFX).l
                lea     FBZEggPrisonSK_SixNormalRingRecords(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

SKFBZEggPrison_ReleaseEnemies:
                lea     SKFBZEggPrison_BlasterPair(pc),a2
                jsr     CreateChild1_Normal(pc)
                lea     SKFBZEggPrison_TechnoPair(pc),a2
                jmp     CreateChild1_Normal(pc)

; =============== S U B R O U T I N E =======================================

; Use subtype and zone for the species, upward and outward launch and staggered delay
FBZCapsuleAnimal_InitRelease:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                andi.w  #6,d0
                lea     SKFBZCapsuleAnimal_BounceSpeeds(pc),a1
                move.w  (a1,d0.w),d2
                move.w  d2,y_vel(a0)
                move.w  d2,$3E(a0)
                andi.w  #2,d0
                move.w  d0,d2
                move.w  FBZCapsuleAnimalSK_TwoArtTileWords(pc,d2.w),art_tile(a0)
                moveq   #0,d2
                move.b  (Current_zone).w,d2
                add.w   d2,d2
                lea     (SKAnimal_ZoneSpeciesPairs).l,a1
                adda.w  d2,a1
                lsr.w   #1,d0
                move.b  (a1,d0.w),d0
                lsl.w   #3,d0
                lea     (SKAnimal_DefaultSpeciesRecords).l,a2
                move.l  4(a2,d0.w),mappings(a0)
                lsl.w   #2,d1
                move.w  d1,$2E(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a0),d0
                move.w  #$200,d1
                cmp.w   x_pos(a1),d0
                bhs.s   SKFBZCapsuleAnimal_SetOutwardMotion
                neg.w   d1

SKFBZCapsuleAnimal_SetOutwardMotion:
                move.w  d1,x_vel(a0)
                bclr    #0,render_flags(a0)
                tst.w   x_vel(a0)
                bpl.s   SKFBZCapsuleAnimal_FacingReturn
                bset    #0,render_flags(a0)

SKFBZCapsuleAnimal_FacingReturn:
                rts
; End of function FBZCapsuleAnimal_InitRelease

; ---------------------------------------------------------------------------
SKFBZCapsuleAnimal_BounceSpeeds:
                dc.w    -$380, -$300, -$280, -$200
FBZCapsuleAnimalSK_TwoArtTileWords:
                dc.w    make_art_tile(ArtTile_Animals1,0,1)
                dc.w    make_art_tile(ArtTile_Animals2,0,1)
ObjDat_FBZEggPrison:
                dc.l    Map_FBZEggCapsule
                dc.w    make_art_tile($000,0,0)
                dc.w    $200
                dc.b    $20, $28,   0,   0
ObjDat_FBZSpringPlunger:
                dc.l    Map_FBZEggCapsule
                dc.w    make_art_tile($000,0,0)
                dc.w    $180
                dc.b    $10,   8,   5,   0
FBZEggPrisonFragmentSK_PartialAttributes:
                dc.w    $100
                dc.b    8,   8,   2,   0
FBZCapsuleAnimalSK_PartialAttributes:
                dc.w    $280
                dc.b    $20, $28,   0,   0
FBZCapsuleRingSK_FullAttributes:
                dc.l    Map_Ring
                dc.w    make_art_tile(ArtTile_Ring,1,1)
                dc.w    $180
                dc.b    8,   8,   0, $47
FBZEggPrisonSK_OneNormalButtonRecord:
                dc.w    1-1
                dc.l    SKFBZPrisonButton_InitButtonFromParent
                dc.b    0,-$24
FBZEggPrisonSK_FiveNormalFragmentRecords:
                dc.w    5-1
                dc.l    SKFBZPrisonFrag_InitFragmentLaunch
                dc.b    0,  -8
                dc.l    SKFBZPrisonFrag_InitFragmentLaunch
                dc.b    -$10,  -8
                dc.l    SKFBZPrisonFrag_InitFragmentLaunch
                dc.b    $10,  -8
                dc.l    SKFBZPrisonFrag_InitFragmentLaunch
                dc.b    -$18,  -8
                dc.l    SKFBZPrisonFrag_InitFragmentLaunch
                dc.b    $18,  -8
FBZEggPrisonSK_FiveNormalAnimalRecords:
                dc.w    5-1
                dc.l    SKFBZCapsuleAnimal_InitSpeciesAndLaunch
                dc.b    0,  -4
                dc.l    SKFBZCapsuleAnimal_InitSpeciesAndLaunch
                dc.b    $10,  -4
                dc.l    SKFBZCapsuleAnimal_InitSpeciesAndLaunch
                dc.b    -$10,  -4
                dc.l    SKFBZCapsuleAnimal_InitSpeciesAndLaunch
                dc.b    $1C,  -4
                dc.l    SKFBZCapsuleAnimal_InitSpeciesAndLaunch
                dc.b    -$1C,  -4
FBZEggPrisonSK_SixNormalRingRecords:
                dc.w    6-1
                dc.l    SKFBZCapsuleRing_InitRingLaunch
                dc.b    -8,  -4
                dc.l    SKFBZCapsuleRing_InitRingLaunch
                dc.b    8,  -4
                dc.l    SKFBZCapsuleRing_InitRingLaunch
                dc.b    $10,  -4
                dc.l    SKFBZCapsuleRing_InitRingLaunch
                dc.b    -$10,  -4
                dc.l    SKFBZCapsuleRing_InitRingLaunch
                dc.b    $18,  -4
                dc.l    SKFBZCapsuleRing_InitRingLaunch
                dc.b    -$18,  -4
SKFBZEggPrison_BlasterPair:
                dc.w    2-1
                dc.l    SKBlaster_UpdateCapsuleSpawn
                dc.b    -$18,  -4
                dc.l    SKBlaster_UpdateCapsuleSpawn
                dc.b    $18,  -4
SKFBZEggPrison_TechnoPair:
                dc.w    2-1
                dc.l    SKTechnoSqueek_UpdateCapsuleSpawn
                dc.b    -8,  -4
                dc.l    SKTechnoSqueek_UpdateCapsuleSpawn
                dc.b    8,  -4
