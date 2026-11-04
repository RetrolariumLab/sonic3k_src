; Owner: objects/shared/sk
; Responsibility: Freed animal state, species movement, enemy score display and product-specific animal spawn helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Animal:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Animal_Index(pc,d0.w),d1
                jmp     Animal_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Animal_Index:
                dc.w    SKAnimal_InitSubtypeOrDefault-Animal_Index
                dc.w    SKAnimal_FallUntilFirstLanding-Animal_Index
                dc.w    SKAnimal_HopAndReloadBounce-Animal_Index
                dc.w    SKAnimal_LightBounceAndTryReverse-Animal_Index
                dc.w    SKAnimal_HopAndReloadBounce-Animal_Index
                dc.w    SKAnimal_HopAndReloadBounce-Animal_Index
                dc.w    SKAnimal_HopAndReloadBounce-Animal_Index
                dc.w    SKAnimal_LightBounceAndTryReverse-Animal_Index
                dc.w    SKAnimal_HopAndReloadBounce-Animal_Index
                dc.w    SKAnimal_LightBounceAndTryReverse-Animal_Index
                dc.w    SKAnimal_HopAndReloadBounce-Animal_Index
                dc.w    SKAnimal_HopAndReloadBounce-Animal_Index
                dc.w    SKAnimal_HopAndReloadBounce-Animal_Index
                dc.w    SKAnimal_HopAndReloadBounce-Animal_Index
                dc.w    SKAnimal_WaitForReleaseAtZero-Animal_Index
                dc.w    SKAnimal_TryStartLightBounce-Animal_Index
                dc.w    SKAnimal_TryStartLightBounce-Animal_Index
                dc.w    SKAnimal_TryLightVerticalBounce-Animal_Index
                dc.w    SKAnimal_TryStartNormalHop-Animal_Index
                dc.w    SKAnimal_TryNormalVerticalBounce-Animal_Index
                dc.w    SKAnimal_HopAndReverseEachImpact-Animal_Index
                dc.w    SKAnimal_TryNormalVerticalBounce-Animal_Index
                dc.w    SKAnimal_HopAndReverseEachImpact-Animal_Index
                dc.w    SKAnimal_TryNormalVerticalBounce-Animal_Index
                dc.w    SKAnimal_LightBounceReverseAlternate-Animal_Index
                dc.w    SKAnimal_HopAndReverseAlternate-Animal_Index
SKAnimal_ZoneSpeciesPairs:
                dc.b    5, 1
                dc.b    0, 3
                dc.b    5, 1
                dc.b    0, 5
                dc.b    6, 5
                dc.b    2, 3
                dc.b    5, 1
                dc.b    6, 1
                dc.b    0, 1
                dc.b    5, 1
                dc.b    0, 5
                dc.b    6, 1
                dc.b    6, 5
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
SKAnimal_DefaultSpeciesRecords:
                dc.w    -$200, -$400
                dc.l    Map_Animals5
                dc.w    -$200, -$300
                dc.l    Map_Animals1
                dc.w    -$180, -$300
                dc.l    Map_Animals5
                dc.w    -$140, -$180
                dc.l    Map_Animals4
                dc.w    -$1C0, -$300
                dc.l    Map_Animals3
                dc.w    -$300, -$400
                dc.l    Map_Animals1
                dc.w    -$280, -$380
                dc.l    Map_Animals2
                dc.w    -$280, -$300
                dc.l    Map_Animals1
                dc.w    -$200, -$380
                dc.l    Map_Animals2
                dc.w    -$2C0, -$300
                dc.l    Map_Animals2
                dc.w    -$140, -$200
                dc.l    Map_Animals2
                dc.w    -$200, -$300
                dc.l    Map_Animals2
SKAnimal_SubtypeLaunchVelocityPairs:
                dc.w    -$440, -$400
                dc.w    -$440, -$400
                dc.w    -$440, -$400
                dc.w    -$300, -$400
                dc.w    -$300, -$400
                dc.w    -$180, -$300
                dc.w    -$180, -$300
                dc.w    -$140, -$180
                dc.w    -$1C0, -$300
                dc.w    -$200, -$300
                dc.w    -$280, -$380
SKAnimal_SubtypeMappingPointers:
                dc.l    Map_Animals1
                dc.l    Map_Animals1
                dc.l    Map_Animals1
                dc.l    Map_Animals5
                dc.l    Map_Animals5
                dc.l    Map_Animals5
                dc.l    Map_Animals5
                dc.l    Map_Animals4
                dc.l    Map_Animals3
                dc.l    Map_Animals1
                dc.l    Map_Animals2
SKAnimal_SubtypeArtTileWords:
                dc.w    make_art_tile($5A5,0,0)
                dc.w    make_art_tile($5A5,0,0)
                dc.w    make_art_tile($5A5,0,0)
                dc.w    make_art_tile($553,0,0)
                dc.w    make_art_tile($553,0,0)
                dc.w    make_art_tile($573,0,0)
                dc.w    make_art_tile($573,0,0)
                dc.w    make_art_tile($585,0,0)
                dc.w    make_art_tile($593,0,0)
                dc.w    make_art_tile($565,0,0)
                dc.w    make_art_tile($5B3,0,0)
; ---------------------------------------------------------------------------

SKAnimal_InitSubtypeOrDefault:
                tst.b   subtype(a0)
                beq.w   SKAnimal_ChooseDefaultArtBank
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.b  d0,routine(a0)
                subi.w  #$14,d0
                move.w  SKAnimal_SubtypeArtTileWords(pc,d0.w),art_tile(a0)
                add.w   d0,d0
                move.l  SKAnimal_SubtypeMappingPointers(pc,d0.w),mappings(a0)
                lea     SKAnimal_SubtypeLaunchVelocityPairs(pc),a1
                move.w  (a1,d0.w),$32(a0)
                move.w  (a1,d0.w),x_vel(a0)
                move.w  2(a1,d0.w),$34(a0)
                move.w  2(a1,d0.w),y_vel(a0)
                move.b  #$C,y_radius(a0)
                move.b  #4,render_flags(a0)
                bset    #0,render_flags(a0)
                move.w  #$300,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #7,anim_frame_timer(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKAnimal_ChooseDefaultArtBank:
                addq.b  #2,routine(a0)
                jsr     (Random_Number).l
                move.w  #make_art_tile(ArtTile_Animals1,0,0),art_tile(a0)
                andi.w  #1,d0
                beq.s   SKAnimal_InitZoneAnimalAndTryPopup
                move.w  #make_art_tile(ArtTile_Animals2,0,0),art_tile(a0)

SKAnimal_InitZoneAnimalAndTryPopup:
                moveq   #0,d1
                move.b  (Current_zone).w,d1
                add.w   d1,d1
                add.w   d0,d1
                lea     SKAnimal_ZoneSpeciesPairs(pc),a1
                move.b  (a1,d1.w),d0
                move.b  d0,$30(a0)
                lsl.w   #3,d0
                lea     SKAnimal_DefaultSpeciesRecords(pc),a1
                adda.w  d0,a1
                move.w  (a1)+,$32(a0)
                move.w  (a1)+,$34(a0)
                move.l  (a1)+,mappings(a0)
                move.b  #$C,y_radius(a0)
                move.b  #4,render_flags(a0)
                bset    #0,render_flags(a0)
                move.w  #$300,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #7,anim_frame_timer(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #-$400,y_vel(a0)
                tst.b   $38(a0)
                bne.s   SKAnimal_WaitForReleaseCountdown
                jsr     (AllocateObject).l
                bne.s   SKAnimal_DrawNewDefaultAnimal
                move.l  #Obj_EnemyScore,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  $3E(a0),d0
                lsr.w   #1,d0
                move.b  d0,mapping_frame(a1)

SKAnimal_DrawNewDefaultAnimal:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKAnimal_WaitForReleaseCountdown:
                move.b  #$1C,routine(a0)
                clr.w   x_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKAnimal_DeleteAnimalOrScore:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKAnimal_FallUntilFirstLanding:
                tst.b   render_flags(a0)
                bpl.s   SKAnimal_DeleteAnimalOrScore
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   SKAnimal_DrawAfterFirstLanding
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKAnimal_DrawAfterFirstLanding
                add.w   d1,y_pos(a0)
                move.w  $32(a0),x_vel(a0)
                move.w  $34(a0),y_vel(a0)
                move.b  #1,mapping_frame(a0)
                move.b  $30(a0),d0
                add.b   d0,d0
                addq.b  #4,d0
                move.b  d0,routine(a0)
                tst.b   $38(a0)
                beq.s   SKAnimal_DrawAfterFirstLanding
                btst    #4,(V_int_run_count+3).w
                beq.s   SKAnimal_DrawAfterFirstLanding
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

SKAnimal_DrawAfterFirstLanding:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKAnimal_HopAndReloadBounce:
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   SKAnimal_CullAfterNormalHop
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKAnimal_CullAfterNormalHop
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

SKAnimal_CullAfterNormalHop:
                tst.b   subtype(a0)
                bne.s   SKAnimal_CheckSubtypeCull
                tst.b   render_flags(a0)
                bpl.w   SKAnimal_DeleteAnimalOrScore
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKAnimal_LightBounceAndTryReverse:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.w   y_vel(a0)
                bmi.s   SKAnimal_TickLightBounceFrames
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKAnimal_TickLightBounceFrames
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)
                tst.b   subtype(a0)
                beq.s   SKAnimal_TickLightBounceFrames
                cmpi.b  #$A,subtype(a0)
                beq.s   SKAnimal_TickLightBounceFrames
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

SKAnimal_TickLightBounceFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKAnimal_CullAfterLightBounce
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

SKAnimal_CullAfterLightBounce:
                tst.b   subtype(a0)
                bne.s   SKAnimal_CheckSubtypeCull
                tst.b   render_flags(a0)
                bpl.w   SKAnimal_DeleteAnimalOrScore
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Test borrow from the player-relative X subtraction before the signed ahead-distance check
SKAnimal_CheckSubtypeCull:
                move.w  x_pos(a0),d0
                sub.w   (Player_1+x_pos).w,d0
                bcs.s   SKAnimal_DrawSubtypeAnimal
                subi.w  #$180,d0
                bpl.s   SKAnimal_DrawSubtypeAnimal
                tst.b   render_flags(a0)
                bpl.w   SKAnimal_DeleteAnimalOrScore

SKAnimal_DrawSubtypeAnimal:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Require visibility and release when the word countdown reaches exactly zero
SKAnimal_WaitForReleaseAtZero:
                tst.b   render_flags(a0)
                bpl.w   SKAnimal_DeleteAnimalOrScore
                subq.w  #1,$36(a0)
                bne.w   SKAnimal_DrawWaitingOrReleased
                move.b  #2,routine(a0)
                move.w  #$80,priority(a0)

SKAnimal_DrawWaitingOrReleased:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Start on the unsigned comparison against 184 pixels
SKAnimal_TryStartLightBounce:
                bsr.w   GetAnimalActivationXDifference
                bcc.s   SKAnimal_CullWhileLightBounceWaits
                move.w  $32(a0),x_vel(a0)
                move.w  $34(a0),y_vel(a0)
                move.b  #$E,routine(a0)
                bra.w   SKAnimal_LightBounceAndTryReverse
; ---------------------------------------------------------------------------

SKAnimal_CullWhileLightBounceWaits:
                bra.w   SKAnimal_CheckSubtypeCull
; ---------------------------------------------------------------------------

SKAnimal_TryLightVerticalBounce:
                bsr.w   GetAnimalActivationXDifference
                bpl.s   SKAnimal_CullAfterLightVertical
                clr.w   x_vel(a0)
                clr.w   $32(a0)
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                bsr.w   BounceAnimalOnFloorAndSelectFrame
                bsr.w   SetAnimalFlipFromPlayerSide
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKAnimal_CullAfterLightVertical
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

SKAnimal_CullAfterLightVertical:
                bra.w   SKAnimal_CheckSubtypeCull
; ---------------------------------------------------------------------------

SKAnimal_TryStartNormalHop:
                bsr.w   GetAnimalActivationXDifference
                bpl.s   SKAnimal_CullAfterSubtypeHop
                move.w  $32(a0),x_vel(a0)
                move.w  $34(a0),y_vel(a0)
                move.b  #4,routine(a0)
                bra.w   SKAnimal_HopAndReloadBounce
; ---------------------------------------------------------------------------

SKAnimal_HopAndReverseAlternate:
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   SKAnimal_CullAfterSubtypeHop
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKAnimal_CullAfterSubtypeHop
                not.b   subtype+1(a0)
                bne.s   SKAnimal_SnapHopAndReloadBounce
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

SKAnimal_SnapHopAndReloadBounce:
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

SKAnimal_CullAfterSubtypeHop:
                bra.w   SKAnimal_CheckSubtypeCull
; ---------------------------------------------------------------------------

SKAnimal_TryNormalVerticalBounce:
                bsr.w   GetAnimalActivationXDifference
                bpl.s   SKAnimal_CullAfterNormalVertical
                clr.w   x_vel(a0)
                clr.w   $32(a0)
                jsr     (MoveSprite).l
                bsr.w   BounceAnimalOnFloorAndSelectFrame
                bsr.w   SetAnimalFlipFromPlayerSide

SKAnimal_CullAfterNormalVertical:
                bra.w   SKAnimal_CheckSubtypeCull
; ---------------------------------------------------------------------------

SKAnimal_HopAndReverseEachImpact:
                bsr.w   GetAnimalActivationXDifference
                bpl.s   SKAnimal_CullAfterEachImpactHop
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   SKAnimal_CullAfterEachImpactHop
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKAnimal_CullAfterEachImpactHop
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

SKAnimal_CullAfterEachImpactHop:
                bra.w   SKAnimal_CheckSubtypeCull
; ---------------------------------------------------------------------------

SKAnimal_LightBounceReverseAlternate:
                bsr.w   GetAnimalActivationXDifference
                bpl.s   SKAnimal_CullAfterAlternateBounce
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.w   y_vel(a0)
                bmi.s   SKAnimal_TickAlternateBounceFrames
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKAnimal_TickAlternateBounceFrames
                not.b   subtype+1(a0)
                bne.s   SKAnimal_SnapAndReloadLightBounce
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

SKAnimal_SnapAndReloadLightBounce:
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

SKAnimal_TickAlternateBounceFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKAnimal_CullAfterAlternateBounce
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

SKAnimal_CullAfterAlternateBounce:
                bra.w   SKAnimal_CheckSubtypeCull

; =============== S U B R O U T I N E =======================================

BounceAnimalOnFloorAndSelectFrame:
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   SKAnimal_FloorFrameReturn
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKAnimal_FloorFrameReturn
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

SKAnimal_FloorFrameReturn:
                rts
; End of function BounceAnimalOnFloorAndSelectFrame

; =============== S U B R O U T I N E =======================================

SetAnimalFlipFromPlayerSide:
                bset    #0,render_flags(a0)
                move.w  x_pos(a0),d0
                sub.w   (Player_1+x_pos).w,d0
                bcc.s   SKAnimal_FacingReturn
                bclr    #0,render_flags(a0)

SKAnimal_FacingReturn:
                rts
; End of function SetAnimalFlipFromPlayerSide

; =============== S U B R O U T I N E =======================================

GetAnimalActivationXDifference:
                move.w  (Player_1+x_pos).w,d0
                sub.w   x_pos(a0),d0
                subi.w  #$B8,d0
                rts
; End of function GetAnimalActivationXDifference

; ---------------------------------------------------------------------------

Obj_EnemyScore:
                move.l  #Map_EnemyScore,mappings(a0)
                move.w  #make_art_tile(ArtTile_StarPost,0,1),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #8,width_pixels(a0)
                move.w  #-$300,y_vel(a0)
                move.l  #SKAnimal_MoveScorePopupToApex,(a0)

SKAnimal_MoveScorePopupToApex:
                tst.w   y_vel(a0)
                bpl.w   SKAnimal_DeleteAnimalOrScore
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_Difficulty_SpawnChickens:
                lea     Child6_DifficultyChicken(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Child6_DifficultyChicken:
                dc.w    4-1
                dc.l    SKDifficultyChicken_InitSwing
; ---------------------------------------------------------------------------

SKDifficultyChicken_InitSwing:
                move.l  #SKDifficultyChicken_TickDelay,(a0)
                move.l  #Map_Animals1,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Difficulty+$141,1,0),art_tile(a0)
                lea     SKDifficultyChicken_ScreenXY(pc),a1
                bsr.w   InitDifficultyAnimalPositionAndDelay
                jmp     (EndingInitializeGentleVerticalSwing).l
; ---------------------------------------------------------------------------
SKDifficultyChicken_ScreenXY:
                dc.w    $C0,   $A0
                dc.w    $A8,   $C8
                dc.w    $D0,   $B8
                dc.w    $D8,   $D0
; ---------------------------------------------------------------------------

SKDifficultyChicken_TickDelay:
                subq.w  #1,$2E(a0)
                bpl.s   SKDifficultyChicken_DrawWaiting
                move.l  #SKDifficultyChicken_SwingAndDraw,(a0)

SKDifficultyChicken_DrawWaiting:
                bsr.w   AnimateDifficultyChickenFrames
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKDifficultyChicken_SwingAndDraw:
                bsr.w   AnimateDifficultyChickenFrames
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_Difficulty_SpawnSquirrels:
                lea     Child6_DifficultySquirrel(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Child6_DifficultySquirrel:
                dc.w    4-1
                dc.l    SKDifficultySquirrel_InitBounce
; ---------------------------------------------------------------------------

SKDifficultySquirrel_InitBounce:
                move.l  #SKDifficultyAnimal_BounceAtSavedY,(a0)
                move.l  #Map_Animals2,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Difficulty+$14F,1,0),art_tile(a0)
                bset    #0,render_flags(a0)
                lea     SKDifficultySquirrel_ScreenXY(pc),a1
                bsr.w   InitDifficultyAnimalPositionAndDelay
                move.w  y_pos(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------
SKDifficultySquirrel_ScreenXY:
                dc.w    $160,  $130
                dc.w    $180,  $120
                dc.w    $1A0,  $128
                dc.w    $178,  $138
; ---------------------------------------------------------------------------

SKDifficultyAnimal_BounceAtSavedY:
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   SKDifficultyAnimal_DrawBounce
                move.b  #0,mapping_frame(a0)
                move.w  y_pos(a0),d0
                cmp.w   $3A(a0),d0
                blo.s   SKDifficultyAnimal_DrawBounce
                move.w  $3A(a0),y_pos(a0)
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                addi.w  #$100,d0
                neg.w   d0
                move.w  d0,y_vel(a0)

SKDifficultyAnimal_DrawBounce:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_Difficulty_SpawnRabbits:
                lea     Child6_DifficultyRabbit(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Child6_DifficultyRabbit:
                dc.w    4-1
                dc.l    SKDifficultyRabbit_InitBounce
; ---------------------------------------------------------------------------

SKDifficultyRabbit_InitBounce:
                move.l  #SKDifficultyAnimal_BounceAtSavedY,(a0)
                move.l  #Map_Animals5,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Difficulty+$161,1,0),art_tile(a0)
                lea     SKDifficultyRabbit_ScreenXY(pc),a1
                bsr.w   InitDifficultyAnimalPositionAndDelay
                move.w  y_pos(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------
SKDifficultyRabbit_ScreenXY:
                dc.w    $C0,  $110
                dc.w    $A8,  $128
                dc.w    $C0,  $130
                dc.w    $D8,  $138

; =============== S U B R O U T I N E =======================================

InitDifficultyAnimalPositionAndDelay:
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                adda.w  d0,a1
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,y_pos(a0)
                add.w   d0,d0
                move.w  d0,$2E(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$200,priority(a0)
                rts
; End of function InitDifficultyAnimalPositionAndDelay

; =============== S U B R O U T I N E =======================================

AnimateDifficultyChickenFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKDifficultyChicken_AnimReturn
                move.b  #2,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

SKDifficultyChicken_AnimReturn:
                rts
; End of function AnimateDifficultyChickenFrames

; ---------------------------------------------------------------------------
Map_Animals1:
                include "src/objects/shared/animals/mappings/set_1.s"
Map_Animals2:
                include "src/objects/shared/animals/mappings/set_2.s"
Map_Animals3:
                include "src/objects/shared/animals/mappings/set_3.s"
Map_Animals4:
                include "src/objects/shared/animals/mappings/set_4.s"
Map_Animals5:
                include "src/objects/shared/animals/mappings/set_5.s"
Map_EnemyScore:
                include "src/objects/shared/enemy_misc/mappings/enemy_points.s"
