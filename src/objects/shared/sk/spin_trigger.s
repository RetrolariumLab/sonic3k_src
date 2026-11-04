; Owner: objects/shared/sk
; Responsibility: Automatic player rolling triggers and their shared geometric contact helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AutoSpin:
                move.l  #Map_PathSwap,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$80,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  subtype(a0),d0
                btst    #2,d0
                beq.s   SKAutoRoll_InitXFrameAndP1Side
                andi.w  #7,d0
                move.b  d0,mapping_frame(a0)
                andi.w  #3,d0
                add.w   d0,d0
                move.w  SKAutoRoll_PerpendicularHalfSpanWords(pc,d0.w),$32(a0)
                move.w  y_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   SKAutoRoll_InitializePlayerTwoYSideLatch
                move.b  #1,$34(a0)

SKAutoRoll_InitializePlayerTwoYSideLatch:
                lea     (Player_2).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   SKAutoRoll_InstallYHandler
                move.b  #1,$35(a0)

SKAutoRoll_InstallYHandler:
                move.l  #SKAutoRoll_CheckPlayersCrossingY,(a0)
                bra.w   SKAutoRoll_CheckPlayersCrossingY
; ---------------------------------------------------------------------------
SKAutoRoll_PerpendicularHalfSpanWords:
                dc.w    $20,   $40,   $80,  $100
; ---------------------------------------------------------------------------

SKAutoRoll_InitXFrameAndP1Side:
                andi.w  #3,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                move.w  SKAutoRoll_PerpendicularHalfSpanWords(pc,d0.w),$32(a0)
                move.w  x_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   SKAutoRoll_InitializePlayerTwoXSideLatch
                move.b  #1,$34(a0)

SKAutoRoll_InitializePlayerTwoXSideLatch:
                lea     (Player_2).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   SKAutoRoll_InstallXHandler
                move.b  #1,$35(a0)

SKAutoRoll_InstallXHandler:
                move.l  #SKAutoRoll_CheckPlayersCrossingX,(a0)

SKAutoRoll_CheckPlayersCrossingX:
                tst.w   (Debug_placement_mode).w
                bne.s   SKAutoRoll_DrawXDebugMarker
                move.w  x_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   UpdateAutoRollOnXCrossing
                lea     (Player_2).w,a1
                cmpi.w  #4,(Tails_CPU_routine).w
                beq.w   SKAutoRoll_FinishXVisibilityByProfile
                bsr.s   UpdateAutoRollOnXCrossing

SKAutoRoll_FinishXVisibilityByProfile:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKAutoRoll_DrawXDebugMarker:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdateAutoRollOnXCrossing:
                tst.b   (a2)+
                bne.s   SKAutoRoll_LatchNegativeXAndCheckSpan
                cmp.w   x_pos(a1),d1
                bhi.w   SKAutoRoll_ReturnFromXAutoRollCheck
                move.b  #1,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blo.w   SKAutoRoll_ReturnFromXAutoRollCheck
                cmp.w   d3,d4
                bhs.w   SKAutoRoll_ReturnFromXAutoRollCheck
                btst    #5,subtype(a0)
                beq.s   SKAutoRoll_CheckPositiveXPolicy
                btst    #Status_InAir,status(a1)
                bne.w   SKAutoRoll_ReturnFromXAutoRollCheck

; X flip and subtype bit 4 control whether this crossing forces or releases roll
SKAutoRoll_CheckPositiveXPolicy:
                btst    #0,render_flags(a0)
                bne.s   SKAutoRoll_ReleaseForcedRollPositiveX
                btst    #4,subtype(a0)
                bne.s   SKAutoRoll_JoinPositiveXRollConversion
                move.w  #$580,ground_vel(a1)
                move.b  #1,spin_dash_flag(a1)
                tst.b   subtype(a0)
                bpl.s   SKAutoRoll_JoinPositiveXRollConversion
                move.b  #$81,spin_dash_flag(a1)

SKAutoRoll_JoinPositiveXRollConversion:
                bra.w   SKAutoRoll_CheckAlreadyRolling
; ---------------------------------------------------------------------------

SKAutoRoll_ReleaseForcedRollPositiveX:
                btst    #4,subtype(a0)
                bne.s   SKAutoRoll_ReturnFromXAutoRollCheck
                move.b  #0,spin_dash_flag(a1)
                rts
; ---------------------------------------------------------------------------

SKAutoRoll_LatchNegativeXAndCheckSpan:
                cmp.w   x_pos(a1),d1
                bls.s   SKAutoRoll_ReturnFromXAutoRollCheck
                move.b  #0,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blo.s   SKAutoRoll_ReturnFromXAutoRollCheck
                cmp.w   d3,d4
                bhs.s   SKAutoRoll_ReturnFromXAutoRollCheck
                btst    #5,subtype(a0)
                beq.s   SKAutoRoll_CheckNegativeXPolicy
                btst    #Status_InAir,status(a1)
                bne.w   SKAutoRoll_ReturnFromXAutoRollCheck

; X flip and subtype bit 4 control whether this crossing forces or releases roll
SKAutoRoll_CheckNegativeXPolicy:
                btst    #0,render_flags(a0)
                beq.s   SKAutoRoll_ReleaseForcedRollNegativeX
                btst    #4,subtype(a0)
                bne.s   SKAutoRoll_JoinNegativeXRollConversion
                move.w  #-$580,ground_vel(a1)
                move.b  #1,spin_dash_flag(a1)
                tst.b   subtype(a0)
                bpl.s   SKAutoRoll_JoinNegativeXRollConversion
                move.b  #$81,spin_dash_flag(a1)

SKAutoRoll_JoinNegativeXRollConversion:
                bra.s   SKAutoRoll_CheckAlreadyRolling
; ---------------------------------------------------------------------------

SKAutoRoll_ReleaseForcedRollNegativeX:
                btst    #4,subtype(a0)
                bne.s   SKAutoRoll_ReturnFromXAutoRollCheck
                move.b  #0,spin_dash_flag(a1)

SKAutoRoll_ReturnFromXAutoRollCheck:
                rts
; ---------------------------------------------------------------------------

SKAutoRoll_CheckAlreadyRolling:
                btst    #Status_Roll,status(a1)
                beq.s   SKAutoRoll_SetRollGeometryAndSound
                rts
; ---------------------------------------------------------------------------

SKAutoRoll_SetRollGeometryAndSound:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                addq.w  #5,y_pos(a1)
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                rts
; End of function UpdateAutoRollOnXCrossing

; ---------------------------------------------------------------------------

SKAutoRoll_CheckPlayersCrossingY:
                tst.w   (Debug_placement_mode).w
                bne.s   SKAutoRoll_DrawYDebugMarker
                move.w  y_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   UpdateAutoRollOnYCrossing
                lea     (Player_2).w,a1
                cmpi.w  #4,(Tails_CPU_routine).w
                beq.s   SKAutoRoll_FinishYVisibilityByProfile
                bsr.s   UpdateAutoRollOnYCrossing

SKAutoRoll_FinishYVisibilityByProfile:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKAutoRoll_DrawYDebugMarker:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdateAutoRollOnYCrossing:
                tst.b   (a2)+
                bne.w   SKAutoRoll_LatchNegativeYAndCheckSpan
                cmp.w   y_pos(a1),d1
                bhi.w   SKAutoRoll_ReturnFromYAutoRollCheck
                move.b  #1,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blo.w   SKAutoRoll_ReturnFromYAutoRollCheck
                cmp.w   d3,d4
                bhs.w   SKAutoRoll_ReturnFromYAutoRollCheck
                btst    #5,subtype(a0)
                beq.s   SKAutoRoll_CheckPositiveYPolicy
                btst    #Status_InAir,status(a1)
                bne.w   SKAutoRoll_ReturnFromYAutoRollCheck

; X flip and subtype bit 4 control whether this crossing forces or releases roll
SKAutoRoll_CheckPositiveYPolicy:
                btst    #0,render_flags(a0)
                bne.s   SKAutoRoll_ReleaseForcedRollPositiveY
                btst    #4,subtype(a0)
                bne.s   SKAutoRoll_JoinPositiveYRollConversion
                move.b  #1,spin_dash_flag(a1)
                tst.b   subtype(a0)
                bpl.s   SKAutoRoll_AlignPositiveYRoll
                move.b  #$81,spin_dash_flag(a1)

; Subtype bit 6 clears InAir and sets the vertical angle to $40
SKAutoRoll_AlignPositiveYRoll:
                btst    #6,subtype(a0)
                beq.s   SKAutoRoll_JoinPositiveYRollConversion
                bclr    #Status_InAir,status(a1)
                move.b  #$40,angle(a1)
                move.w  y_vel(a1),ground_vel(a1)
                move.w  #0,x_vel(a1)

SKAutoRoll_JoinPositiveYRollConversion:
                bra.w   SKAutoRoll_CheckAlreadyRolling
; ---------------------------------------------------------------------------

SKAutoRoll_ReleaseForcedRollPositiveY:
                btst    #4,subtype(a0)
                bne.w   SKAutoRoll_ReturnFromYAutoRollCheck
                move.b  #0,spin_dash_flag(a1)
                rts
; ---------------------------------------------------------------------------

SKAutoRoll_LatchNegativeYAndCheckSpan:
                cmp.w   y_pos(a1),d1
                bls.s   SKAutoRoll_ReturnFromYAutoRollCheck
                move.b  #0,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blo.s   SKAutoRoll_ReturnFromYAutoRollCheck
                cmp.w   d3,d4
                bhs.s   SKAutoRoll_ReturnFromYAutoRollCheck
                btst    #5,subtype(a0)
                beq.s   SKAutoRoll_CheckNegativeYPolicy
                btst    #Status_InAir,status(a1)
                bne.w   SKAutoRoll_ReturnFromYAutoRollCheck

; X flip and subtype bit 4 control whether this crossing forces or releases roll
SKAutoRoll_CheckNegativeYPolicy:
                btst    #0,render_flags(a0)
                beq.s   SKAutoRoll_ReleaseForcedRollNegativeY
                btst    #4,subtype(a0)
                bne.s   SKAutoRoll_JoinNegativeYRollConversion
                move.b  #1,spin_dash_flag(a1)
                tst.b   subtype(a0)
                bpl.s   SKAutoRoll_AlignNegativeYRoll
                move.b  #$81,spin_dash_flag(a1)

; Subtype bit 6 clears InAir and sets the vertical angle to $40
SKAutoRoll_AlignNegativeYRoll:
                btst    #6,subtype(a0)
                beq.s   SKAutoRoll_JoinNegativeYRollConversion
                bclr    #Status_InAir,status(a1)
                move.b  #$40,angle(a1)

SKAutoRoll_JoinNegativeYRollConversion:
                bra.w   SKAutoRoll_CheckAlreadyRolling
; ---------------------------------------------------------------------------

SKAutoRoll_ReleaseForcedRollNegativeY:
                btst    #4,subtype(a0)
                bne.s   SKAutoRoll_ReturnFromYAutoRollCheck
                move.b  #0,spin_dash_flag(a1)

SKAutoRoll_ReturnFromYAutoRollCheck:
                rts
; End of function UpdateAutoRollOnYCrossing
