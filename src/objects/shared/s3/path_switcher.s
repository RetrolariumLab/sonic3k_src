; Owner: objects/shared/s3
; Responsibility: Shared foreground priority and collision-path switcher state and geometric contact helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_PathSwap:
                move.l  #Map_PathSwap,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  subtype(a0),d0
                btst    #2,d0
                beq.s   S3PathSwap_InitXFrameAndP1Side
                andi.w  #7,d0
                move.b  d0,mapping_frame(a0)
                andi.w  #3,d0
                add.w   d0,d0
                move.w  S3PathSwap_PerpendicularHalfSpanWords(pc,d0.w),$32(a0)
                move.w  y_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   S3PathSwap_InitializePlayerTwoYSideLatch
                move.b  #1,$34(a0)

S3PathSwap_InitializePlayerTwoYSideLatch:
                lea     (Player_2).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   S3PathSwap_InstallYCrossingHandlerByMode
                move.b  #1,$35(a0)

S3PathSwap_InstallYCrossingHandlerByMode:
                move.l  #S3PathSwap_CheckNormalYCrossings,(a0)
                tst.w   (Competition_mode).w
                beq.w   S3PathSwap_CheckNormalYCrossings
                move.l  #S3PathSwap_CheckCompetitionYCrossings,(a0)
                move.w  #make_art_tile(ArtTile_2PArt_3+$C,3,0),art_tile(a0)
                bra.w   S3PathSwap_CheckCompetitionYCrossings
; ---------------------------------------------------------------------------
S3PathSwap_PerpendicularHalfSpanWords:
                dc.w    $20,   $40,   $80,  $100
; ---------------------------------------------------------------------------

S3PathSwap_InitXFrameAndP1Side:
                andi.w  #3,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                move.w  S3PathSwap_PerpendicularHalfSpanWords(pc,d0.w),$32(a0)
                move.w  x_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   S3PathSwap_InitializePlayerTwoXSideLatch
                move.b  #1,$34(a0)

S3PathSwap_InitializePlayerTwoXSideLatch:
                lea     (Player_2).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   S3PathSwap_InstallXCrossingHandlerByMode
                move.b  #1,$35(a0)

S3PathSwap_InstallXCrossingHandlerByMode:
                move.l  #S3PathSwap_CheckNormalXCrossings,(a0)
                tst.w   (Competition_mode).w
                beq.s   S3PathSwap_CheckNormalXCrossings
                move.l  #S3PathSwap_CheckCompetitionXCrossings,(a0)
                move.w  #make_art_tile(ArtTile_2PArt_3+$C,3,0),art_tile(a0)
                bra.s   S3PathSwap_CheckCompetitionXCrossings
; ---------------------------------------------------------------------------

S3PathSwap_CheckNormalXCrossings:
                tst.w   (Debug_placement_mode).w
                bne.w   S3PathSwap_FinishNormalXVisibility
                move.w  x_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   SwitchPlayerPathOnXCrossing
                lea     (Player_2).w,a1
                bsr.s   SwitchPlayerPathOnXCrossing

S3PathSwap_FinishNormalXVisibility:
                tst.w   (Debug_mode_flag).w
                beq.w   Delete_Sprite_If_Not_In_Range
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

; Run the crossing worker for both players and the Breathing_bubbles slot
S3PathSwap_CheckCompetitionXCrossings:
                move.w  x_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   SwitchPlayerPathOnXCrossing
                lea     (Player_2).w,a1
                bsr.s   SwitchPlayerPathOnXCrossing
                lea     (Breathing_bubbles).w,a1
                tst.w   (Debug_mode_flag).w
                beq.w   SwitchPlayerPathOnXCrossing
                bsr.s   SwitchPlayerPathOnXCrossing
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

SwitchPlayerPathOnXCrossing:
                tst.b   (a2)+
                bne.w   S3PathSwap_LatchNegativeXAndCheckSpan
                cmp.w   x_pos(a1),d1
                bhi.w   S3PathSwap_ReturnFromXCrossingCheck
                move.b  #1,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   S3PathSwap_ReturnFromXCrossingCheck
                cmp.w   d3,d4
                bge.w   S3PathSwap_ReturnFromXCrossingCheck
                move.b  subtype(a0),d0
                bpl.s   S3PathSwap_MeasurePositiveXCrossing
                btst    #Status_InAir,status(a1)
                bne.w   S3PathSwap_ReturnFromXCrossingCheck

S3PathSwap_MeasurePositiveXCrossing:
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   S3PathSwap_ApplyPositiveXCollisionPath
                neg.w   d2

S3PathSwap_ApplyPositiveXCollisionPath:
                cmpi.w  #$40,d2
                bhs.w   S3PathSwap_ReturnFromXCrossingCheck
                btst    #0,render_flags(a0)
                bne.s   S3PathSwap_ApplyPositiveXTilePriority
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #3,d0
                beq.s   S3PathSwap_ApplyPositiveXTilePriority
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

S3PathSwap_ApplyPositiveXTilePriority:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #5,d0
                beq.w   S3PathSwap_ReturnFromXCrossingCheck
                ori.w   #high_priority,art_tile(a1)
                bra.w   S3PathSwap_ReturnFromXCrossingCheck
; ---------------------------------------------------------------------------

S3PathSwap_LatchNegativeXAndCheckSpan:
                cmp.w   x_pos(a1),d1
                bls.w   S3PathSwap_ReturnFromXCrossingCheck
                move.b  #0,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   S3PathSwap_ReturnFromXCrossingCheck
                cmp.w   d3,d4
                bge.w   S3PathSwap_ReturnFromXCrossingCheck
                move.b  subtype(a0),d0
                bpl.s   S3PathSwap_MeasureNegativeXCrossing
                btst    #Status_InAir,status(a1)
                bne.w   S3PathSwap_ReturnFromXCrossingCheck

S3PathSwap_MeasureNegativeXCrossing:
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   S3PathSwap_ApplyNegativeXCollisionPath
                neg.w   d2

S3PathSwap_ApplyNegativeXCollisionPath:
                cmpi.w  #$40,d2
                bhs.s   S3PathSwap_ReturnFromXCrossingCheck
                btst    #0,render_flags(a0)
                bne.s   S3PathSwap_ApplyNegativeXTilePriority
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #4,d0
                beq.s   S3PathSwap_ApplyNegativeXTilePriority
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

S3PathSwap_ApplyNegativeXTilePriority:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #6,d0
                beq.s   S3PathSwap_ReturnFromXCrossingCheck
                ori.w   #high_priority,art_tile(a1)

S3PathSwap_ReturnFromXCrossingCheck:
                rts
; End of function SwitchPlayerPathOnXCrossing

; ---------------------------------------------------------------------------

S3PathSwap_CheckNormalYCrossings:
                tst.w   (Debug_placement_mode).w
                bne.w   S3PathSwap_FinishNormalYVisibility
                move.w  y_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   SwitchPlayerPathOnYCrossing
                lea     (Player_2).w,a1
                bsr.s   SwitchPlayerPathOnYCrossing

S3PathSwap_FinishNormalYVisibility:
                tst.w   (Debug_mode_flag).w
                beq.w   Delete_Sprite_If_Not_In_Range
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

; Run the crossing worker for both players and the Breathing_bubbles slot
S3PathSwap_CheckCompetitionYCrossings:
                move.w  y_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   SwitchPlayerPathOnYCrossing
                lea     (Player_2).w,a1
                bsr.s   SwitchPlayerPathOnYCrossing
                lea     (Breathing_bubbles).w,a1
                tst.w   (Debug_mode_flag).w
                beq.w   SwitchPlayerPathOnYCrossing
                bsr.s   SwitchPlayerPathOnYCrossing
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

SwitchPlayerPathOnYCrossing:
                tst.b   (a2)+
                bne.w   S3PathSwap_LatchNegativeYAndCheckSpan
                cmp.w   y_pos(a1),d1
                bhi.w   S3PathSwap_ReturnFromYCrossingCheck
                move.b  #1,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blt.w   S3PathSwap_ReturnFromYCrossingCheck
                cmp.w   d3,d4
                bge.w   S3PathSwap_ReturnFromYCrossingCheck
                move.b  subtype(a0),d0
                bpl.s   S3PathSwap_MeasurePositiveYCrossing
                btst    #Status_InAir,status(a1)
                bne.w   S3PathSwap_ReturnFromYCrossingCheck

S3PathSwap_MeasurePositiveYCrossing:
                move.w  y_pos(a1),d2
                sub.w   d1,d2
                bcc.s   S3PathSwap_ApplyPositiveYCollisionPath
                neg.w   d2

S3PathSwap_ApplyPositiveYCollisionPath:
                cmpi.w  #$40,d2
                bhs.w   S3PathSwap_ReturnFromYCrossingCheck
                btst    #0,render_flags(a0)
                bne.s   S3PathSwap_ApplyPositiveYTilePriority
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #3,d0
                beq.s   S3PathSwap_ApplyPositiveYTilePriority
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

S3PathSwap_ApplyPositiveYTilePriority:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #5,d0
                beq.w   S3PathSwap_ReturnFromYCrossingCheck
                ori.w   #high_priority,art_tile(a1)
                bra.w   S3PathSwap_ReturnFromYCrossingCheck
; ---------------------------------------------------------------------------

S3PathSwap_LatchNegativeYAndCheckSpan:
                cmp.w   y_pos(a1),d1
                bls.w   S3PathSwap_ReturnFromYCrossingCheck
                move.b  #0,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blt.w   S3PathSwap_ReturnFromYCrossingCheck
                cmp.w   d3,d4
                bge.w   S3PathSwap_ReturnFromYCrossingCheck
                move.b  subtype(a0),d0
                bpl.s   S3PathSwap_MeasureNegativeYCrossing
                btst    #Status_InAir,status(a1)
                bne.w   S3PathSwap_ReturnFromYCrossingCheck

S3PathSwap_MeasureNegativeYCrossing:
                move.w  y_pos(a1),d2
                sub.w   d1,d2
                bcc.s   S3PathSwap_ApplyNegativeYCollisionPath
                neg.w   d2

S3PathSwap_ApplyNegativeYCollisionPath:
                cmpi.w  #$40,d2
                bhs.s   S3PathSwap_ReturnFromYCrossingCheck
                btst    #0,render_flags(a0)
                bne.s   S3PathSwap_ApplyNegativeYTilePriority
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #4,d0
                beq.s   S3PathSwap_ApplyNegativeYTilePriority
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

S3PathSwap_ApplyNegativeYTilePriority:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #6,d0
                beq.s   S3PathSwap_ReturnFromYCrossingCheck
                ori.w   #high_priority,art_tile(a1)

S3PathSwap_ReturnFromYCrossingCheck:
                rts
; End of function SwitchPlayerPathOnYCrossing

; ---------------------------------------------------------------------------
Map_PathSwap:
                include "src/objects/shared/level_misc/mappings/path_swap.s"
