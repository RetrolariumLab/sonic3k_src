; Owner: objects/shared/s3
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
                beq.s   S3AutoRoll_InitXFrameAndP1Side
                andi.w  #7,d0
                move.b  d0,mapping_frame(a0)
                andi.w  #3,d0
                add.w   d0,d0
                move.w  S3AutoRoll_PerpendicularHalfSpanWords(pc,d0.w),$32(a0)
                move.w  y_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   S3AutoRoll_InitializePlayerTwoYSideLatch
                move.b  #1,$34(a0)

S3AutoRoll_InitializePlayerTwoYSideLatch:
                lea     (Player_2).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   S3AutoRoll_InstallYHandler
                move.b  #1,$35(a0)

S3AutoRoll_InstallYHandler:
                move.l  #S3AutoRoll_CheckPlayersCrossingY,(a0)
                bra.w   S3AutoRoll_CheckPlayersCrossingY
; ---------------------------------------------------------------------------
S3AutoRoll_PerpendicularHalfSpanWords:
                dc.w    $20,   $40,   $80,  $100
; ---------------------------------------------------------------------------

S3AutoRoll_InitXFrameAndP1Side:
                andi.w  #3,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                move.w  S3AutoRoll_PerpendicularHalfSpanWords(pc,d0.w),$32(a0)
                move.w  x_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   S3AutoRoll_InitializePlayerTwoXSideLatch
                move.b  #1,$34(a0)

S3AutoRoll_InitializePlayerTwoXSideLatch:
                lea     (Player_2).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   S3AutoRoll_InstallXHandler
                move.b  #1,$35(a0)

S3AutoRoll_InstallXHandler:
                move.l  #S3AutoRoll_CheckPlayersCrossingX,(a0)

S3AutoRoll_CheckPlayersCrossingX:
                tst.w   (Debug_placement_mode).w
                bne.w   S3AutoRoll_FinishXVisibilityByProfile
                move.w  x_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   UpdateAutoRollOnXCrossing
                lea     (Player_2).w,a1
                cmpi.w  #4,(Tails_CPU_routine).w
                beq.w   S3AutoRoll_FinishXVisibilityByProfile

; =============== S U B R O U T I N E =======================================

UpdateAutoRollOnXCrossing:
                tst.b   (a2)+
                bne.s   S3AutoRoll_LatchNegativeXAndCheckSpan
                cmp.w   x_pos(a1),d1
                bhi.w   S3AutoRoll_FinishXVisibilityByProfile
                move.b  #1,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blo.s   S3AutoRoll_FinishXVisibilityByProfile
                cmp.w   d3,d4
                bhs.s   S3AutoRoll_FinishXVisibilityByProfile
                btst    #0,render_flags(a0)
                bne.s   S3AutoRoll_ReleaseForcedRollPositiveX
                move.w  #$580,ground_vel(a1)
                move.b  #1,spin_dash_flag(a1)
                tst.b   subtype(a0)
                bpl.s   S3AutoRoll_JoinPositiveXRollConversion
                move.b  #$81,spin_dash_flag(a1)

S3AutoRoll_JoinPositiveXRollConversion:
                bra.s   S3AutoRoll_CheckAlreadyRolling
; ---------------------------------------------------------------------------

S3AutoRoll_ReleaseForcedRollPositiveX:
                move.b  #0,spin_dash_flag(a1)
                bra.s   S3AutoRoll_FinishXVisibilityByProfile
; ---------------------------------------------------------------------------

S3AutoRoll_LatchNegativeXAndCheckSpan:
                cmp.w   x_pos(a1),d1
                bls.s   S3AutoRoll_FinishXVisibilityByProfile
                move.b  #0,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blo.s   S3AutoRoll_FinishXVisibilityByProfile
                cmp.w   d3,d4
                bhs.s   S3AutoRoll_FinishXVisibilityByProfile
                btst    #0,render_flags(a0)
                beq.s   S3AutoRoll_ReleaseForcedRollNegativeX
                move.w  #-$580,ground_vel(a1)
                move.b  #1,spin_dash_flag(a1)
                tst.b   subtype(a0)
                bpl.s   S3AutoRoll_JoinNegativeXRollConversion
                move.b  #$81,spin_dash_flag(a1)

S3AutoRoll_JoinNegativeXRollConversion:
                bra.s   S3AutoRoll_CheckAlreadyRolling
; ---------------------------------------------------------------------------

S3AutoRoll_ReleaseForcedRollNegativeX:
                move.b  #0,spin_dash_flag(a1)

S3AutoRoll_FinishXVisibilityByProfile:
                tst.w   (Debug_mode_flag).w
                beq.w   Delete_Sprite_If_Not_In_Range
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

S3AutoRoll_CheckAlreadyRolling:
                btst    #Status_Roll,status(a1)
                beq.s   S3AutoRoll_SetRollGeometryAndSound
                rts
; ---------------------------------------------------------------------------

S3AutoRoll_SetRollGeometryAndSound:
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

S3AutoRoll_CheckPlayersCrossingY:
                tst.w   (Debug_placement_mode).w
                bne.w   S3AutoRoll_FinishYVisibilityByProfile
                move.w  y_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   UpdateAutoRollOnYCrossing
                lea     (Player_2).w,a1
                cmpi.w  #4,(Tails_CPU_routine).w
                beq.w   S3AutoRoll_FinishYVisibilityByProfile

; =============== S U B R O U T I N E =======================================

UpdateAutoRollOnYCrossing:
                tst.b   (a2)+
                bne.s   S3AutoRoll_LatchNegativeYAndCheckSpan
                cmp.w   y_pos(a1),d1
                bhi.w   S3AutoRoll_FinishYVisibilityByProfile
                move.b  #1,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blo.w   S3AutoRoll_FinishYVisibilityByProfile
                cmp.w   d3,d4
                bhs.w   S3AutoRoll_FinishYVisibilityByProfile
                btst    #0,render_flags(a0)
                bne.s   S3AutoRoll_ReleaseForcedRollPositiveY
                move.b  #1,spin_dash_flag(a1)
                tst.b   subtype(a0)
                bpl.s   S3AutoRoll_AlignPositiveYRoll
                move.b  #$81,spin_dash_flag(a1)

; Subtype bit 6 clears InAir and sets the vertical angle to $40
S3AutoRoll_AlignPositiveYRoll:
                btst    #6,subtype(a0)
                beq.s   S3AutoRoll_JoinPositiveYRollConversion
                bclr    #Status_InAir,status(a1)
                move.b  #$40,angle(a1)
                move.w  y_vel(a1),ground_vel(a1)
                move.w  #0,x_vel(a1)

S3AutoRoll_JoinPositiveYRollConversion:
                bra.w   S3AutoRoll_CheckAlreadyRolling
; ---------------------------------------------------------------------------

S3AutoRoll_ReleaseForcedRollPositiveY:
                move.b  #0,spin_dash_flag(a1)
                bra.s   S3AutoRoll_FinishYVisibilityByProfile
; ---------------------------------------------------------------------------

S3AutoRoll_LatchNegativeYAndCheckSpan:
                cmp.w   y_pos(a1),d1
                bls.s   S3AutoRoll_FinishYVisibilityByProfile
                move.b  #0,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blo.s   S3AutoRoll_FinishYVisibilityByProfile
                cmp.w   d3,d4
                bhs.s   S3AutoRoll_FinishYVisibilityByProfile
                btst    #0,render_flags(a0)
                beq.s   S3AutoRoll_ReleaseForcedRollNegativeY
                move.b  #1,spin_dash_flag(a1)
                tst.b   subtype(a0)
                bpl.s   S3AutoRoll_AlignNegativeYRoll
                move.b  #$81,spin_dash_flag(a1)

; Subtype bit 6 clears InAir and sets the vertical angle to $40
S3AutoRoll_AlignNegativeYRoll:
                btst    #6,subtype(a0)
                beq.s   S3AutoRoll_JoinNegativeYRollConversion
                bclr    #Status_InAir,status(a1)
                move.b  #$40,angle(a1)

S3AutoRoll_JoinNegativeYRollConversion:
                bra.w   S3AutoRoll_CheckAlreadyRolling
; ---------------------------------------------------------------------------

S3AutoRoll_ReleaseForcedRollNegativeY:
                move.b  #0,spin_dash_flag(a1)

S3AutoRoll_FinishYVisibilityByProfile:
                tst.w   (Debug_mode_flag).w
                beq.w   Delete_Sprite_If_Not_In_Range
                jmp     (Sprite_OnScreen_Test).l
; End of function UpdateAutoRollOnYCrossing
