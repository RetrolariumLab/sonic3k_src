; Owner: objects/shared/s3
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
                dc.w    S3Animal_InitSubtypeOrDefault-Animal_Index
                dc.w    S3Animal_FallUntilFirstLanding-Animal_Index
                dc.w    S3Animal_HopAndReloadBounce-Animal_Index
                dc.w    S3Animal_LightBounceAndTryReverse-Animal_Index
                dc.w    S3Animal_HopAndReloadBounce-Animal_Index
                dc.w    S3Animal_HopAndReloadBounce-Animal_Index
                dc.w    S3Animal_HopAndReloadBounce-Animal_Index
                dc.w    S3Animal_LightBounceAndTryReverse-Animal_Index
                dc.w    S3Animal_HopAndReloadBounce-Animal_Index
                dc.w    S3Animal_LightBounceAndTryReverse-Animal_Index
                dc.w    S3Animal_HopAndReloadBounce-Animal_Index
                dc.w    S3Animal_HopAndReloadBounce-Animal_Index
                dc.w    S3Animal_HopAndReloadBounce-Animal_Index
                dc.w    S3Animal_HopAndReloadBounce-Animal_Index
                dc.w    S3Animal_WaitForReleaseAtZero-Animal_Index
                dc.w    S3Animal_TryStartLightBounce-Animal_Index
                dc.w    S3Animal_TryStartLightBounce-Animal_Index
                dc.w    S3Animal_TryLightVerticalBounce-Animal_Index
                dc.w    S3Animal_TryStartNormalHop-Animal_Index
                dc.w    S3Animal_TryNormalVerticalBounce-Animal_Index
                dc.w    S3Animal_HopAndReverseEachImpact-Animal_Index
                dc.w    S3Animal_TryNormalVerticalBounce-Animal_Index
                dc.w    S3Animal_HopAndReverseEachImpact-Animal_Index
                dc.w    S3Animal_TryNormalVerticalBounce-Animal_Index
                dc.w    S3Animal_LightBounceReverseAlternate-Animal_Index
                dc.w    S3Animal_HopAndReverseAlternate-Animal_Index
S3Animal_ZoneSpeciesPairs:
                dc.b    5, 1
                dc.b    0, 3
                dc.b    5, 1
                dc.b    0, 5
                dc.b    6, 5
                dc.b    2, 3
                dc.b    6, 1
                dc.b    6, 5
                dc.b    6, 5
                dc.b    6, 5
                dc.b    6, 5
                dc.b    6, 5
                dc.b    6, 5
S3Animal_DefaultSpeciesRecords:
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
S3Animal_SubtypeLaunchVelocityPairs:
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
S3Animal_SubtypeMappingPointers:
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
S3Animal_SubtypeArtTileWords:
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

S3Animal_InitSubtypeOrDefault:
                tst.b   subtype(a0)
                beq.w   S3Animal_ChooseDefaultArtBank
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.b  d0,routine(a0)
                subi.w  #$14,d0
                move.w  S3Animal_SubtypeArtTileWords(pc,d0.w),art_tile(a0)
                add.w   d0,d0
                move.l  S3Animal_SubtypeMappingPointers(pc,d0.w),mappings(a0)
                lea     S3Animal_SubtypeLaunchVelocityPairs(pc),a1
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

S3Animal_ChooseDefaultArtBank:
                addq.b  #2,routine(a0)
                jsr     (Random_Number).l
                move.w  #make_art_tile(ArtTile_Animals1,0,0),art_tile(a0)
                andi.w  #1,d0
                beq.s   S3Animal_InitZoneAnimalAndTryPopup
                move.w  #make_art_tile(ArtTile_Animals2,0,0),art_tile(a0)

S3Animal_InitZoneAnimalAndTryPopup:
                moveq   #0,d1
                move.b  (Current_zone).w,d1
                add.w   d1,d1
                add.w   d0,d1
                lea     S3Animal_ZoneSpeciesPairs(pc),a1
                move.b  (a1,d1.w),d0
                move.b  d0,$30(a0)
                lsl.w   #3,d0
                lea     S3Animal_DefaultSpeciesRecords(pc),a1
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
                bne.s   S3Animal_WaitForReleaseCountdown
                jsr     (AllocateObject).l
                bne.s   S3Animal_DrawNewDefaultAnimal
                move.l  #Obj_EnemyScore,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  $3E(a0),d0
                lsr.w   #1,d0
                move.b  d0,mapping_frame(a1)

S3Animal_DrawNewDefaultAnimal:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Animal_WaitForReleaseCountdown:
                move.b  #$1C,routine(a0)
                clr.w   x_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Animal_DeleteAnimalOrScore:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3Animal_FallUntilFirstLanding:
                tst.b   render_flags(a0)
                bpl.s   S3Animal_DeleteAnimalOrScore
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   S3Animal_DrawAfterFirstLanding
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   S3Animal_DrawAfterFirstLanding
                add.w   d1,y_pos(a0)
                move.w  $32(a0),x_vel(a0)
                move.w  $34(a0),y_vel(a0)
                move.b  #1,mapping_frame(a0)
                move.b  $30(a0),d0
                add.b   d0,d0
                addq.b  #4,d0
                move.b  d0,routine(a0)
                tst.b   $38(a0)
                beq.s   S3Animal_DrawAfterFirstLanding
                btst    #4,(V_int_run_count+3).w
                beq.s   S3Animal_DrawAfterFirstLanding
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

S3Animal_DrawAfterFirstLanding:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Animal_HopAndReloadBounce:
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   S3Animal_CullAfterNormalHop
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   S3Animal_CullAfterNormalHop
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

S3Animal_CullAfterNormalHop:
                tst.b   subtype(a0)
                bne.s   S3Animal_CheckSubtypeCull
                tst.b   render_flags(a0)
                bpl.w   S3Animal_DeleteAnimalOrScore
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Animal_LightBounceAndTryReverse:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.w   y_vel(a0)
                bmi.s   S3Animal_TickLightBounceFrames
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   S3Animal_TickLightBounceFrames
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)
                tst.b   subtype(a0)
                beq.s   S3Animal_TickLightBounceFrames
                cmpi.b  #$A,subtype(a0)
                beq.s   S3Animal_TickLightBounceFrames
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

S3Animal_TickLightBounceFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3Animal_CullAfterLightBounce
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

S3Animal_CullAfterLightBounce:
                tst.b   subtype(a0)
                bne.s   S3Animal_CheckSubtypeCull
                tst.b   render_flags(a0)
                bpl.w   S3Animal_DeleteAnimalOrScore
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Test borrow from the player-relative X subtraction before the signed ahead-distance check
S3Animal_CheckSubtypeCull:
                move.w  x_pos(a0),d0
                sub.w   (Player_1+x_pos).w,d0
                bcs.s   S3Animal_DrawSubtypeAnimal
                subi.w  #$180,d0
                bpl.s   S3Animal_DrawSubtypeAnimal
                tst.b   render_flags(a0)
                bpl.w   S3Animal_DeleteAnimalOrScore

S3Animal_DrawSubtypeAnimal:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Require visibility and release when the word countdown reaches exactly zero
S3Animal_WaitForReleaseAtZero:
                tst.b   render_flags(a0)
                bpl.w   S3Animal_DeleteAnimalOrScore
                subq.w  #1,$36(a0)
                bne.w   S3Animal_DrawWaitingOrReleased
                move.b  #2,routine(a0)
                move.w  #$80,priority(a0)

S3Animal_DrawWaitingOrReleased:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Start on the unsigned comparison against 184 pixels
S3Animal_TryStartLightBounce:
                bsr.w   GetAnimalActivationXDifference
                bcc.s   S3Animal_CullWhileLightBounceWaits
                move.w  $32(a0),x_vel(a0)
                move.w  $34(a0),y_vel(a0)
                move.b  #$E,routine(a0)
                bra.w   S3Animal_LightBounceAndTryReverse
; ---------------------------------------------------------------------------

S3Animal_CullWhileLightBounceWaits:
                bra.w   S3Animal_CheckSubtypeCull
; ---------------------------------------------------------------------------

S3Animal_TryLightVerticalBounce:
                bsr.w   GetAnimalActivationXDifference
                bpl.s   S3Animal_CullAfterLightVertical
                clr.w   x_vel(a0)
                clr.w   $32(a0)
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                bsr.w   BounceAnimalOnFloorAndSelectFrame
                bsr.w   SetAnimalFlipFromPlayerSide
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3Animal_CullAfterLightVertical
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

S3Animal_CullAfterLightVertical:
                bra.w   S3Animal_CheckSubtypeCull
; ---------------------------------------------------------------------------

S3Animal_TryStartNormalHop:
                bsr.w   GetAnimalActivationXDifference
                bpl.s   S3Animal_CullAfterSubtypeHop
                move.w  $32(a0),x_vel(a0)
                move.w  $34(a0),y_vel(a0)
                move.b  #4,routine(a0)
                bra.w   S3Animal_HopAndReloadBounce
; ---------------------------------------------------------------------------

S3Animal_HopAndReverseAlternate:
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   S3Animal_CullAfterSubtypeHop
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   S3Animal_CullAfterSubtypeHop
                not.b   subtype+1(a0)
                bne.s   S3Animal_SnapHopAndReloadBounce
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

S3Animal_SnapHopAndReloadBounce:
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

S3Animal_CullAfterSubtypeHop:
                bra.w   S3Animal_CheckSubtypeCull
; ---------------------------------------------------------------------------

S3Animal_TryNormalVerticalBounce:
                bsr.w   GetAnimalActivationXDifference
                bpl.s   S3Animal_CullAfterNormalVertical
                clr.w   x_vel(a0)
                clr.w   $32(a0)
                jsr     (MoveSprite).l
                bsr.w   BounceAnimalOnFloorAndSelectFrame
                bsr.w   SetAnimalFlipFromPlayerSide

S3Animal_CullAfterNormalVertical:
                bra.w   S3Animal_CheckSubtypeCull
; ---------------------------------------------------------------------------

S3Animal_HopAndReverseEachImpact:
                bsr.w   GetAnimalActivationXDifference
                bpl.s   S3Animal_CullAfterEachImpactHop
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   S3Animal_CullAfterEachImpactHop
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   S3Animal_CullAfterEachImpactHop
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

S3Animal_CullAfterEachImpactHop:
                bra.w   S3Animal_CheckSubtypeCull
; ---------------------------------------------------------------------------

S3Animal_LightBounceReverseAlternate:
                bsr.w   GetAnimalActivationXDifference
                bpl.s   S3Animal_CullAfterAlternateBounce
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.w   y_vel(a0)
                bmi.s   S3Animal_TickAlternateBounceFrames
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   S3Animal_TickAlternateBounceFrames
                not.b   subtype+1(a0)
                bne.s   S3Animal_SnapAndReloadLightBounce
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

S3Animal_SnapAndReloadLightBounce:
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

S3Animal_TickAlternateBounceFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3Animal_CullAfterAlternateBounce
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

S3Animal_CullAfterAlternateBounce:
                bra.w   S3Animal_CheckSubtypeCull

; =============== S U B R O U T I N E =======================================

BounceAnimalOnFloorAndSelectFrame:
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   S3Animal_FloorFrameReturn
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   S3Animal_FloorFrameReturn
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

S3Animal_FloorFrameReturn:
                rts
; End of function BounceAnimalOnFloorAndSelectFrame

; =============== S U B R O U T I N E =======================================

SetAnimalFlipFromPlayerSide:
                bset    #0,render_flags(a0)
                move.w  x_pos(a0),d0
                sub.w   (Player_1+x_pos).w,d0
                bcc.s   S3Animal_FacingReturn
                bclr    #0,render_flags(a0)

S3Animal_FacingReturn:
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
                move.l  #S3Animal_MoveScorePopupToApex,(a0)

S3Animal_MoveScorePopupToApex:
                tst.w   y_vel(a0)
                bpl.w   S3Animal_DeleteAnimalOrScore
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                jmp     (Draw_Sprite).l
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
