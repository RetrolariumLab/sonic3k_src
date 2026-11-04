; Owner: objects/shared/sk
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
                beq.s   SKPathSwap_InitXFrameAndP1Side
                andi.w  #7,d0
                move.b  d0,mapping_frame(a0)
                andi.w  #3,d0
                add.w   d0,d0
                move.w  SKPathSwap_PerpendicularHalfSpanWords(pc,d0.w),$32(a0)
                move.w  y_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   SKPathSwap_InitializePlayerTwoYSideLatch
                move.b  #1,$34(a0)

SKPathSwap_InitializePlayerTwoYSideLatch:
                lea     (Player_2).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   SKPathSwap_InstallYCrossingHandlerByMode
                move.b  #1,$35(a0)

SKPathSwap_InstallYCrossingHandlerByMode:
                move.l  #SKPathSwap_CheckNormalYCrossings,(a0)
                tst.w   (Competition_mode).w
                beq.w   SKPathSwap_CheckNormalYCrossings
                move.l  #SKPathSwap_CheckCompetitionYCrossings,(a0)
                move.w  #make_art_tile(ArtTile_2PArt_3+$C,3,0),art_tile(a0)
                bra.w   SKPathSwap_CheckCompetitionYCrossings
; ---------------------------------------------------------------------------
SKPathSwap_PerpendicularHalfSpanWords:
                dc.w    $20,   $40,   $80,  $100
; ---------------------------------------------------------------------------

SKPathSwap_InitXFrameAndP1Side:
                andi.w  #3,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                move.w  SKPathSwap_PerpendicularHalfSpanWords(pc,d0.w),$32(a0)
                move.w  x_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   SKPathSwap_InitializePlayerTwoXSideLatch
                move.b  #1,$34(a0)

SKPathSwap_InitializePlayerTwoXSideLatch:
                lea     (Player_2).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   SKPathSwap_InstallXCrossingHandlerByMode
                move.b  #1,$35(a0)

SKPathSwap_InstallXCrossingHandlerByMode:
                move.l  #SKPathSwap_CheckNormalXCrossings,(a0)
                tst.w   (Competition_mode).w
                beq.s   SKPathSwap_CheckNormalXCrossings
                move.l  #SKPathSwap_CheckCompetitionXCrossings,(a0)
                move.w  #make_art_tile(ArtTile_2PArt_3+$C,3,0),art_tile(a0)
                bra.s   SKPathSwap_CheckCompetitionXCrossings
; ---------------------------------------------------------------------------

SKPathSwap_CheckNormalXCrossings:
                tst.w   (Debug_placement_mode).w
                bne.w   SKPathSwap_FinishNormalXVisibility
                move.w  x_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   SwitchPlayerPathOnXCrossing
                lea     (Player_2).w,a1
                bsr.s   SwitchPlayerPathOnXCrossing
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKPathSwap_FinishNormalXVisibility:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

; Run the crossing worker for both players and the Breathing_bubbles slot
SKPathSwap_CheckCompetitionXCrossings:
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
                bne.w   SKPathSwap_LatchNegativeXAndCheckSpan
                cmp.w   x_pos(a1),d1
                bhi.w   SKPathSwap_ReturnFromXCrossingCheck
                move.b  #1,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   SKPathSwap_ReturnFromXCrossingCheck
                cmp.w   d3,d4
                bge.w   SKPathSwap_ReturnFromXCrossingCheck
                move.b  subtype(a0),d0
                bpl.s   SKPathSwap_MeasurePositiveXCrossing
                btst    #Status_InAir,status(a1)
                bne.w   SKPathSwap_ReturnFromXCrossingCheck

SKPathSwap_MeasurePositiveXCrossing:
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   SKPathSwap_ApplyPositiveXCollisionPath
                neg.w   d2

SKPathSwap_ApplyPositiveXCollisionPath:
                cmpi.w  #$40,d2
                bhs.w   SKPathSwap_ReturnFromXCrossingCheck
                btst    #0,render_flags(a0)
                bne.s   SKPathSwap_ApplyPositiveXTilePriority
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #3,d0
                beq.s   SKPathSwap_ApplyPositiveXTilePriority
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

SKPathSwap_ApplyPositiveXTilePriority:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #5,d0
                beq.w   SKPathSwap_ReturnFromXCrossingCheck
                ori.w   #high_priority,art_tile(a1)
                bra.w   SKPathSwap_ReturnFromXCrossingCheck
; ---------------------------------------------------------------------------

SKPathSwap_LatchNegativeXAndCheckSpan:
                cmp.w   x_pos(a1),d1
                bls.w   SKPathSwap_ReturnFromXCrossingCheck
                move.b  #0,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   SKPathSwap_ReturnFromXCrossingCheck
                cmp.w   d3,d4
                bge.w   SKPathSwap_ReturnFromXCrossingCheck
                move.b  subtype(a0),d0
                bpl.s   SKPathSwap_MeasureNegativeXCrossing
                btst    #Status_InAir,status(a1)
                bne.w   SKPathSwap_ReturnFromXCrossingCheck

SKPathSwap_MeasureNegativeXCrossing:
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   SKPathSwap_ApplyNegativeXCollisionPath
                neg.w   d2

SKPathSwap_ApplyNegativeXCollisionPath:
                cmpi.w  #$40,d2
                bhs.s   SKPathSwap_ReturnFromXCrossingCheck
                btst    #0,render_flags(a0)
                bne.s   SKPathSwap_ApplyNegativeXTilePriority
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #4,d0
                beq.s   SKPathSwap_ApplyNegativeXTilePriority
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

SKPathSwap_ApplyNegativeXTilePriority:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #6,d0
                beq.s   SKPathSwap_ReturnFromXCrossingCheck
                ori.w   #high_priority,art_tile(a1)

SKPathSwap_ReturnFromXCrossingCheck:
                rts
; End of function SwitchPlayerPathOnXCrossing

; ---------------------------------------------------------------------------

SKPathSwap_CheckNormalYCrossings:
                tst.w   (Debug_placement_mode).w
                bne.w   SKPathSwap_FinishNormalYVisibility
                move.w  y_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   SwitchPlayerPathOnYCrossing
                lea     (Player_2).w,a1
                bsr.s   SwitchPlayerPathOnYCrossing
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKPathSwap_FinishNormalYVisibility:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

; Run the crossing worker for both players and the Breathing_bubbles slot
SKPathSwap_CheckCompetitionYCrossings:
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
                bne.w   SKPathSwap_LatchNegativeYAndCheckSpan
                cmp.w   y_pos(a1),d1
                bhi.w   SKPathSwap_ReturnFromYCrossingCheck
                move.b  #1,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blt.w   SKPathSwap_ReturnFromYCrossingCheck
                cmp.w   d3,d4
                bge.w   SKPathSwap_ReturnFromYCrossingCheck
                move.b  subtype(a0),d0
                bpl.s   SKPathSwap_MeasurePositiveYCrossing
                btst    #Status_InAir,status(a1)
                bne.w   SKPathSwap_ReturnFromYCrossingCheck

SKPathSwap_MeasurePositiveYCrossing:
                move.w  y_pos(a1),d2
                sub.w   d1,d2
                bcc.s   SKPathSwap_ApplyPositiveYCollisionPath
                neg.w   d2

SKPathSwap_ApplyPositiveYCollisionPath:
                cmpi.w  #$40,d2
                bhs.w   SKPathSwap_ReturnFromYCrossingCheck
                btst    #0,render_flags(a0)
                bne.s   SKPathSwap_ApplyPositiveYTilePriority
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #3,d0
                beq.s   SKPathSwap_ApplyPositiveYTilePriority
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

SKPathSwap_ApplyPositiveYTilePriority:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #5,d0
                beq.w   SKPathSwap_ReturnFromYCrossingCheck
                ori.w   #high_priority,art_tile(a1)
                bra.w   SKPathSwap_ReturnFromYCrossingCheck
; ---------------------------------------------------------------------------

SKPathSwap_LatchNegativeYAndCheckSpan:
                cmp.w   y_pos(a1),d1
                bls.w   SKPathSwap_ReturnFromYCrossingCheck
                move.b  #0,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blt.w   SKPathSwap_ReturnFromYCrossingCheck
                cmp.w   d3,d4
                bge.w   SKPathSwap_ReturnFromYCrossingCheck
                move.b  subtype(a0),d0
                bpl.s   SKPathSwap_MeasureNegativeYCrossing
                btst    #Status_InAir,status(a1)
                bne.w   SKPathSwap_ReturnFromYCrossingCheck

SKPathSwap_MeasureNegativeYCrossing:
                move.w  y_pos(a1),d2
                sub.w   d1,d2
                bcc.s   SKPathSwap_ApplyNegativeYCollisionPath
                neg.w   d2

SKPathSwap_ApplyNegativeYCollisionPath:
                cmpi.w  #$40,d2
                bhs.s   SKPathSwap_ReturnFromYCrossingCheck
                btst    #0,render_flags(a0)
                bne.s   SKPathSwap_ApplyNegativeYTilePriority
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #4,d0
                beq.s   SKPathSwap_ApplyNegativeYTilePriority
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

SKPathSwap_ApplyNegativeYTilePriority:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #6,d0
                beq.s   SKPathSwap_ReturnFromYCrossingCheck
                ori.w   #high_priority,art_tile(a1)

SKPathSwap_ReturnFromYCrossingCheck:
                rts
; End of function SwitchPlayerPathOnYCrossing

; ---------------------------------------------------------------------------
Map_PathSwap:
                include "src/objects/shared/level_misc/mappings/path_swap.s"
