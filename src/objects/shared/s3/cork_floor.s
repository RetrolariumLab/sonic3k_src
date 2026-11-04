; Owner: objects/shared/s3
; Responsibility: Shared breakable cork floors, player contact, fracture response and zone mapping variants
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CorkFloor:
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.l  #Map_AIZCorkFloor,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.l  #S3Cork_AIZCorkVelocityPairs,$3C(a0)
                cmpi.w  #1,(Current_zone_and_act).w
                bne.s   S3Cork_SelectCNZCorkResources
                move.l  #Map_AIZCorkFloor2,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$2C,height_pixels(a0)

S3Cork_SelectCNZCorkResources:
                cmpi.b  #3,(Current_zone).w
                bne.s   S3Cork_SelectICZProfileOrFlatCork
                move.l  #Map_CNZCorkFloor,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZPlatform,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #S3Cork_CNZLBZCorkVelocityPairs,$3C(a0)

S3Cork_SelectICZProfileOrFlatCork:
                cmpi.b  #5,(Current_zone).w
                bne.s   S3Cork_SelectLBZCorkResources
                move.l  #Map_ICZCorkFloor,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$24,height_pixels(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.b  #$F,d0
                move.b  d0,mapping_frame(a0)
                andi.b  #$10,d1
                bne.s   S3Cork_SelectICZSmallFlatCorkResources
                move.l  #S3Cork_CheckICZProfileAndLayers,(a0)
                bra.w   S3Cork_CheckICZProfileAndLayers
; ---------------------------------------------------------------------------

S3Cork_SelectICZSmallFlatCorkResources:
                move.l  #S3Cork_ICZFlatVelocityPairs,$3C(a0)
                move.w  #make_art_tile(ArtTile_ICZMisc1,2,0),art_tile(a0)
                move.b  #$10,height_pixels(a0)

S3Cork_SelectLBZCorkResources:
                cmpi.b  #6,(Current_zone).w
                bne.s   S3Cork_SelectVerticalOrRollingCorkMode
                move.l  #Map_LBZCorkFloor,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #S3Cork_CNZLBZCorkVelocityPairs,$3C(a0)

S3Cork_SelectVerticalOrRollingCorkMode:
                tst.b   subtype(a0)
                bne.s   S3Cork_InstallRollingCorkTopBreakHandler
                move.l  #S3Cork_UpdateVerticalResponseBreakCork,(a0)
                bra.w   S3Cork_UpdateVerticalResponseBreakCork
; ---------------------------------------------------------------------------

S3Cork_InstallRollingCorkTopBreakHandler:
                move.l  #S3Cork_CachePlayersAndCheckTopBreak,(a0)

S3Cork_CachePlayersAndCheckTopBreak:
                move.w  (Chain_bonus_counter).w,$38(a0)
                move.b  (Player_1+anim).w,$34(a0)
                move.b  (Player_2+anim).w,$36(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.b  status(a0),d0
                andi.w  #standing_mask,d0
                bne.s   S3Cork_CheckRollWithBothRiders

S3Cork_DrawUnbrokenRollingCorkInRange:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

; If both standing bits are set, require a cached rolling animation from at least one rider
S3Cork_CheckRollWithBothRiders:
                cmpi.b  #p1_standing|p2_standing,d0
                bne.s   S3Cork_CheckFirstSingleCorkRiderRolling
                cmpi.b  #2,$34(a0)
                beq.s   S3Cork_ReleaseBothRiders
                cmpi.b  #2,$36(a0)
                bne.s   S3Cork_DrawUnbrokenRollingCorkInRange

S3Cork_ReleaseBothRiders:
                lea     (Player_1).w,a1
                move.b  $34(a0),d0
                bsr.s   ReleaseCorkRiderWithConditionalBounce
                lea     (Player_2).w,a1
                move.b  $36(a0),d0
                bsr.s   ReleaseCorkRiderWithConditionalBounce
                bra.w   S3Cork_RestoreChainAndShatterRollingCork
; ---------------------------------------------------------------------------

S3Cork_CheckFirstSingleCorkRiderRolling:
                move.b  d0,d1
                andi.b  #8,d1
                beq.s   S3Cork_CheckSecondSingleCorkRiderRolling
                cmpi.b  #2,$34(a0)
                bne.s   S3Cork_DrawUnbrokenRollingCorkInRange
                lea     (Player_1).w,a1
                bsr.s   BouncePlayerFromBrokenCorkFloor
                bra.s   S3Cork_RestoreChainAndShatterRollingCork

; =============== S U B R O U T I N E =======================================

ReleaseCorkRiderWithConditionalBounce:
                cmpi.b  #2,d0
                bne.s   S3Cork_FinishGenericCorkAirborneRelease
; End of function ReleaseCorkRiderWithConditionalBounce

; =============== S U B R O U T I N E =======================================

BouncePlayerFromBrokenCorkFloor:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.w  #-$300,y_vel(a1)

S3Cork_FinishGenericCorkAirborneRelease:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                rts
; End of function BouncePlayerFromBrokenCorkFloor

; ---------------------------------------------------------------------------

S3Cork_CheckSecondSingleCorkRiderRolling:
                andi.b  #$10,d0
                beq.w   S3Cork_DrawUnbrokenRollingCorkInRange
                cmpi.b  #2,$36(a0)
                bne.w   S3Cork_DrawUnbrokenRollingCorkInRange
                lea     (Player_2).w,a1
                bsr.s   BouncePlayerFromBrokenCorkFloor

S3Cork_RestoreChainAndShatterRollingCork:
                move.w  $38(a0),(Chain_bonus_counter).w
                andi.b  #$E7,status(a0)
                movea.l $3C(a0),a4
                addq.b  #1,mapping_frame(a0)
                move.l  #S3Cork_MoveFragmentAndApplyGravity,(a0)
                jsr     (BreakObjectToPieces).l

S3Cork_MoveFragmentAndApplyGravity:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.b   render_flags(a0)
                bpl.w   S3Cork_DeleteOffscreenFragment
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3Cork_DeleteOffscreenFragment:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3Cork_UpdateVerticalResponseBreakCork:
                move.w  (Player_1+y_vel).w,$30(a0)
                move.w  (Player_2+y_vel).w,$32(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.w  #4|8,d6
                bne.s   S3Cork_RestoreP1ImpactYVel
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

S3Cork_RestoreP1ImpactYVel:
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   S3Cork_RestoreP2ImpactYVel
                lea     (Player_1).w,a1
                move.w  $30(a0),y_vel(a1)
                andi.b  #8,d6
                beq.s   S3Cork_DetachP1BeforeVerticalBreak
                lea     (Player_2).w,a1
                move.w  $32(a0),y_vel(a1)
                bra.s   S3Cork_DetachP1BeforeVerticalBreak
; ---------------------------------------------------------------------------

S3Cork_RestoreP2ImpactYVel:
                andi.b  #8,d6
                beq.s   S3Cork_DrawVerticalCork
                lea     (Player_2).w,a1
                move.w  $32(a0),y_vel(a1)
                bra.s   S3Cork_DetachP1BeforeVerticalBreak
; ---------------------------------------------------------------------------

S3Cork_DrawVerticalCork:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

S3Cork_DetachP1BeforeVerticalBreak:
                btst    #p1_standing_bit,status(a0)
                beq.s   S3Cork_DetachP2BeforeVerticalBreak
                lea     (Player_1).w,a1
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)

S3Cork_DetachP2BeforeVerticalBreak:
                btst    #p2_standing_bit,status(a0)
                beq.s   S3Cork_ShatterVerticalResponseCork
                lea     (Player_2).w,a1
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)

S3Cork_ShatterVerticalResponseCork:
                movea.l $3C(a0),a4
                addq.b  #1,mapping_frame(a0)
                move.l  #S3Cork_MoveFragmentAndApplyGravity,(a0)
                jsr     (BreakObjectToPieces).l
                bra.w   S3Cork_MoveFragmentAndApplyGravity
; ---------------------------------------------------------------------------

S3Cork_CheckICZProfileAndLayers:
                move.w  (Chain_bonus_counter).w,$38(a0)
                move.b  (Player_1+anim).w,$34(a0)
                move.b  (Player_2+anim).w,$36(a0)
                lea     (S3Cork_ICZCorkSignedHeightProfile).l,a2
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  x_pos(a0),d4
                jsr     (HeightProfile_CollideBothKeepAir).l
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   S3Cork_CheckBothICZCorkRidersEligibility

S3Cork_DrawUnbrokenICZProfileCork:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

S3Cork_CheckBothICZCorkRidersEligibility:
                cmpi.b  #p1_standing|p2_standing,d0
                bne.s   S3Cork_CheckSingleICZRiderP1
                cmpi.b  #2,$34(a0)
                bne.s   S3Cork_ResetP1ICZLayersAndTryP2
                tst.b   subtype(a0)
                bmi.s   S3Cork_ReleaseBothICZRiders
                cmpi.b  #$E,(Player_1+top_solid_bit).w
                beq.s   S3Cork_ReleaseBothICZRiders

S3Cork_ResetP1ICZLayersAndTryP2:
                move.b  #$C,(Player_1+top_solid_bit).w
                move.b  #$D,(Player_1+lrb_solid_bit).w
                cmpi.b  #2,$36(a0)
                bne.s   S3Cork_ResetP2ICZLayers
                tst.b   subtype(a0)
                bmi.s   S3Cork_ReleaseBothICZRiders
                cmpi.b  #$E,(Player_2+top_solid_bit).w
                beq.s   S3Cork_ReleaseBothICZRiders

S3Cork_ResetP2ICZLayers:
                move.b  #$C,(Player_2+top_solid_bit).w
                move.b  #$D,(Player_2+lrb_solid_bit).w
                bra.s   S3Cork_DrawUnbrokenICZProfileCork
; ---------------------------------------------------------------------------

S3Cork_ReleaseBothICZRiders:
                lea     (Player_1).w,a1
                move.b  $34(a0),d0
                bsr.s   ReleaseIczCorkRiderWithConditionalRoll
                lea     (Player_2).w,a1
                move.b  $36(a0),d0
                bsr.s   ReleaseIczCorkRiderWithConditionalRoll
                bra.w   S3Cork_ShatterICZFromFrameVel
; ---------------------------------------------------------------------------

S3Cork_CheckSingleICZRiderP1:
                move.b  d0,d1
                andi.b  #8,d1
                beq.s   S3Cork_CheckSingleICZRiderP2
                cmpi.b  #2,$34(a0)
                bne.s   S3Cork_ResetFirstSingleICZRiderLayers
                tst.b   subtype(a0)
                bmi.s   S3Cork_ReleaseFirstEligibleICZCorkRider
                cmpi.b  #$E,(Player_1+top_solid_bit).w
                beq.s   S3Cork_ReleaseFirstEligibleICZCorkRider

S3Cork_ResetFirstSingleICZRiderLayers:
                move.b  #$C,(Player_1+top_solid_bit).w
                move.b  #$D,(Player_1+lrb_solid_bit).w
                bra.w   S3Cork_DrawUnbrokenICZProfileCork
; ---------------------------------------------------------------------------

S3Cork_ReleaseFirstEligibleICZCorkRider:
                lea     (Player_1).w,a1
                bsr.s   ReleasePlayerFromIczCorkFloor
                bra.s   S3Cork_ShatterICZFromFrameVel

; =============== S U B R O U T I N E =======================================

ReleaseIczCorkRiderWithConditionalRoll:
                cmpi.b  #2,d0
                bne.s   S3Cork_FinishICZCorkAirborneRelease
; End of function ReleaseIczCorkRiderWithConditionalRoll

; =============== S U B R O U T I N E =======================================

ReleasePlayerFromIczCorkFloor:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)

S3Cork_FinishICZCorkAirborneRelease:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                rts
; End of function ReleasePlayerFromIczCorkFloor

; ---------------------------------------------------------------------------

S3Cork_CheckSingleICZRiderP2:
                andi.b  #$10,d0
                beq.w   S3Cork_DrawUnbrokenICZProfileCork
                cmpi.b  #2,$36(a0)
                bne.s   S3Cork_ResetSecondSingleICZRiderLayers
                tst.b   subtype(a0)
                bmi.s   S3Cork_ReleaseSecondEligibleICZCorkRider
                cmpi.b  #$E,(Player_2+top_solid_bit).w
                beq.s   S3Cork_ReleaseSecondEligibleICZCorkRider

S3Cork_ResetSecondSingleICZRiderLayers:
                move.b  #$C,(Player_2+top_solid_bit).w
                move.b  #$D,(Player_2+lrb_solid_bit).w
                bra.w   S3Cork_DrawUnbrokenICZProfileCork
; ---------------------------------------------------------------------------

S3Cork_ReleaseSecondEligibleICZCorkRider:
                lea     (Player_2).w,a1
                bsr.s   ReleasePlayerFromIczCorkFloor

S3Cork_ShatterICZFromFrameVel:
                move.w  $38(a0),(Chain_bonus_counter).w
                andi.b  #$E7,status(a0)
                lea     (S3Cork_ICZFrameShiftedVelocityPairs).l,a4
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                addq.b  #1,mapping_frame(a0)
                move.l  d0,d1
                add.w   d0,d0
                add.w   d0,d0
                lea     (a4,d0.w),a4
                move.l  #S3Cork_MoveFragmentAndApplyGravity,(a0)
                jsr     (BreakObjectToPieces).l
                bra.w   S3Cork_MoveFragmentAndApplyGravity
; ---------------------------------------------------------------------------
S3Cork_ICZFrameShiftedVelocityPairs:
                dc.w    -$140, -$A00
                dc.w    $140, -$A00
                dc.w    -$120, -$900
                dc.w    $120, -$900
                dc.w    -$100, -$800
                dc.w    $100, -$800
                dc.w    -$E0, -$700
                dc.w    $E0, -$700
                dc.w    -$C0, -$600
                dc.w    $C0, -$600
                dc.w    -$A0, -$580
                dc.w    $A0, -$580
                dc.w    -$80, -$500
                dc.w    $80, -$500
S3Cork_ICZFlatVelocityPairs:
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    -$100, -$100
                dc.w    $100, -$100
S3Cork_ICZCorkSignedHeightProfile:
                dc.b    $23, $23
                dc.b    $22, $22
                dc.b    $21, $21
                dc.b    $20, $1F
                dc.b    $1F, $1E
                dc.b    $1E, $1D
                dc.b    $1D, $1C
                dc.b    $1B, $1B
                dc.b    $1A, $1A
                dc.b    $19, $19
                dc.b    $17, $16
                dc.b    $15, $15
                dc.b    $14, $14
                dc.b    $13, $13
S3Cork_AIZCorkVelocityPairs:
                dc.w    -$100, -$200
                dc.w    $100, -$200
                dc.w    -$E0, -$1C0
                dc.w    $E0, -$1C0
                dc.w    -$C0, -$180
                dc.w    $C0, -$180
                dc.w    -$A0, -$140
                dc.w    $A0, -$140
                dc.w    -$80, -$100
                dc.w    $80, -$100
                dc.w    -$60,  -$C0
                dc.w    $60,  -$C0
S3Cork_CNZLBZCorkVelocityPairs:
                dc.w    -$400, -$400
                dc.w    -$200, -$400
                dc.w    $200, -$400
                dc.w    $400, -$400
                dc.w    -$3C0, -$3C0
                dc.w    -$1C0, -$3C0
                dc.w    $1C0, -$3C0
                dc.w    $3C0, -$3C0
                dc.w    -$380, -$380
                dc.w    -$180, -$380
                dc.w    $180, -$380
                dc.w    $380, -$380
                dc.w    -$340, -$340
                dc.w    -$140, -$340
                dc.w    $140, -$340
                dc.w    $340, -$340
