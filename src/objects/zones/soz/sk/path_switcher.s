; Owner: objects/zones/soz/sk
; Responsibility: Sandopolis-specific collision-path switcher and its player contact geometry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZPathSwap:
                move.l  #Map_PathSwap,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  subtype(a0),d0
                btst    #2,d0
                beq.s   SKSOZPath_InitXSpanAndP1Side
                andi.w  #7,d0
                move.b  d0,mapping_frame(a0)
                andi.w  #3,d0
                add.w   d0,d0
                move.w  SKSOZPath_CrossingHalfSpans(pc,d0.w),$32(a0)
                move.w  y_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   SKSOZPath_InitP2SideY
                move.b  #1,$34(a0)

SKSOZPath_InitP2SideY:
                lea     (Player_2).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   SKSOZPath_InitYCrossing
                move.b  #1,$35(a0)

SKSOZPath_InitYCrossing:
                move.l  #SKSOZPath_UpdateBothYCrossings,(a0)
                bra.w   SKSOZPath_UpdateBothYCrossings
; ---------------------------------------------------------------------------
SKSOZPath_CrossingHalfSpans:
                dc.w    $20,   $40,   $80,  $100
; ---------------------------------------------------------------------------

SKSOZPath_InitXSpanAndP1Side:
                andi.w  #3,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                move.w  SKSOZPath_CrossingHalfSpans(pc,d0.w),$32(a0)
                move.w  x_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   SKSOZPath_InitP2SideX
                move.b  #1,$34(a0)

SKSOZPath_InitP2SideX:
                lea     (Player_2).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   SKSOZPath_InitXCrossing
                move.b  #1,$35(a0)

SKSOZPath_InitXCrossing:
                move.l  #SKSOZPath_UpdateBothXCrossings,(a0)

SKSOZPath_UpdateBothXCrossings:
                tst.w   (Debug_placement_mode).w
                bne.w   SKSOZPath_DrawDebugXMarker
                move.w  x_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   ApplySozPathChangeOnXCrossing
                lea     (Player_2).w,a1
                bsr.s   ApplySozPathChangeOnXCrossing
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKSOZPath_DrawDebugXMarker:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

ApplySozPathChangeOnXCrossing:
                tst.b   (a2)+
                bne.w   SKSOZPath_LatchLeftCrossing
                cmp.w   x_pos(a1),d1
                bhi.w   SKSOZPath_XCrossingReturn
                move.b  #1,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   SKSOZPath_XCrossingReturn
                cmp.w   d3,d4
                bge.w   SKSOZPath_XCrossingReturn
                move.b  subtype(a0),d0
                bpl.s   SKSOZPath_CalcRightDistance
                btst    #Status_InAir,status(a1)
                bne.w   SKSOZPath_XCrossingReturn

SKSOZPath_CalcRightDistance:
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   SKSOZPath_CheckRightLayerAndPriority
                neg.w   d2

; All four crossing directions require distance below $40. The render flag can limit a crossing to priority changes
SKSOZPath_CheckRightLayerAndPriority:
                cmpi.w  #$40,d2
                bhs.w   SKSOZPath_XCrossingReturn
                btst    #0,render_flags(a0)
                bne.s   SKSOZPath_SetRightPriority
                btst    #3,d0
                bne.s   SKSOZPath_CheckRightAltLayer
                cmpi.b  #$C,top_solid_bit(a1)
                bne.s   SKSOZPath_CountRightDefaultCrossing
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetRightDefaultLayer
; ---------------------------------------------------------------------------

; The second mismatched crossing clears the count and skips the layer change. Priority still updates
SKSOZPath_CountRightDefaultCrossing:
                addq.b  #1,1(a2)
                cmpi.b  #2,1(a2)
                bne.s   SKSOZPath_SetRightDefaultLayer
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetRightPriority
; ---------------------------------------------------------------------------

SKSOZPath_SetRightDefaultLayer:
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                bra.s   SKSOZPath_SetRightPriority
; ---------------------------------------------------------------------------

SKSOZPath_CheckRightAltLayer:
                cmpi.b  #$C,top_solid_bit(a1)
                bne.s   SKSOZPath_CountRightAltCrossing
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetRightPriority
; ---------------------------------------------------------------------------

SKSOZPath_CountRightAltCrossing:
                addq.b  #1,1(a2)
                cmpi.b  #2,1(a2)
                bne.s   SKSOZPath_SetRightAltLayer
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetRightPriority
; ---------------------------------------------------------------------------

SKSOZPath_SetRightAltLayer:
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

SKSOZPath_SetRightPriority:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #5,d0
                beq.w   SKSOZPath_XCrossingReturn
                ori.w   #high_priority,art_tile(a1)
                bra.w   SKSOZPath_XCrossingReturn
; ---------------------------------------------------------------------------

; Record the new side before testing the perpendicular span, airborne state and distance
SKSOZPath_LatchLeftCrossing:
                cmp.w   x_pos(a1),d1
                bls.w   SKSOZPath_XCrossingReturn
                move.b  #0,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   SKSOZPath_XCrossingReturn
                cmp.w   d3,d4
                bge.w   SKSOZPath_XCrossingReturn
                move.b  subtype(a0),d0
                bpl.s   SKSOZPath_CalcLeftDistance
                btst    #Status_InAir,status(a1)
                bne.w   SKSOZPath_XCrossingReturn

SKSOZPath_CalcLeftDistance:
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   SKSOZPath_CheckLeftLayerAndPriority
                neg.w   d2

SKSOZPath_CheckLeftLayerAndPriority:
                cmpi.w  #$40,d2
                bhs.w   SKSOZPath_XCrossingReturn
                btst    #0,render_flags(a0)
                bne.s   SKSOZPath_SetLeftPriority
                btst    #4,d0
                bne.s   SKSOZPath_CheckLeftAltLayer
                cmpi.b  #$C,top_solid_bit(a1)
                bne.s   SKSOZPath_CountLeftDefaultCrossing
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetLeftDefaultLayer
; ---------------------------------------------------------------------------

SKSOZPath_CountLeftDefaultCrossing:
                addq.b  #1,1(a2)
                cmpi.b  #2,1(a2)
                bne.s   SKSOZPath_SetLeftDefaultLayer
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetLeftPriority
; ---------------------------------------------------------------------------

SKSOZPath_SetLeftDefaultLayer:
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                bra.s   SKSOZPath_SetLeftPriority
; ---------------------------------------------------------------------------

SKSOZPath_CheckLeftAltLayer:
                cmpi.b  #$C,top_solid_bit(a1)
                bne.s   SKSOZPath_CountLeftAltCrossing
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetLeftPriority
; ---------------------------------------------------------------------------

SKSOZPath_CountLeftAltCrossing:
                addq.b  #1,1(a2)
                cmpi.b  #2,1(a2)
                bne.s   SKSOZPath_SetLeftAltLayer
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetLeftPriority
; ---------------------------------------------------------------------------

SKSOZPath_SetLeftAltLayer:
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

SKSOZPath_SetLeftPriority:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #6,d0
                beq.s   SKSOZPath_XCrossingReturn
                ori.w   #high_priority,art_tile(a1)

SKSOZPath_XCrossingReturn:
                rts
; End of function ApplySozPathChangeOnXCrossing

; ---------------------------------------------------------------------------

SKSOZPath_UpdateBothYCrossings:
                tst.w   (Debug_placement_mode).w
                bne.w   SKSOZPath_DrawDebugYMarker
                move.w  y_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   ApplySozPathChangeOnYCrossing
                lea     (Player_2).w,a1
                bsr.s   ApplySozPathChangeOnYCrossing
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKSOZPath_DrawDebugYMarker:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

ApplySozPathChangeOnYCrossing:
                tst.b   (a2)+
                bne.w   SKSOZPath_LatchUpCrossing
                cmp.w   y_pos(a1),d1
                bhi.w   SKSOZPath_YCrossingReturn
                move.b  #1,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blt.w   SKSOZPath_YCrossingReturn
                cmp.w   d3,d4
                bge.w   SKSOZPath_YCrossingReturn
                move.b  subtype(a0),d0
                bpl.s   SKSOZPath_CalcDownDistance
                btst    #Status_InAir,status(a1)
                bne.w   SKSOZPath_YCrossingReturn

SKSOZPath_CalcDownDistance:
                move.w  y_pos(a1),d2
                sub.w   d1,d2
                bcc.s   SKSOZPath_CheckDownLayerAndPriority
                neg.w   d2

SKSOZPath_CheckDownLayerAndPriority:
                cmpi.w  #$40,d2
                bhs.w   SKSOZPath_YCrossingReturn
                btst    #0,render_flags(a0)
                bne.s   SKSOZPath_SetDownPriority
                btst    #3,d0
                bne.s   SKSOZPath_CheckDownAltLayer
                cmpi.b  #$C,top_solid_bit(a1)
                bne.s   SKSOZPath_CountDownDefaultCrossing
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetDownDefaultLayer
; ---------------------------------------------------------------------------

SKSOZPath_CountDownDefaultCrossing:
                addq.b  #1,1(a2)
                cmpi.b  #2,1(a2)
                bne.s   SKSOZPath_SetDownDefaultLayer
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetDownPriority
; ---------------------------------------------------------------------------

SKSOZPath_SetDownDefaultLayer:
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                bra.s   SKSOZPath_SetDownPriority
; ---------------------------------------------------------------------------

SKSOZPath_CheckDownAltLayer:
                cmpi.b  #$C,top_solid_bit(a1)
                bne.s   SKSOZPath_CountDownAltCrossing
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetDownPriority
; ---------------------------------------------------------------------------

SKSOZPath_CountDownAltCrossing:
                addq.b  #1,1(a2)
                cmpi.b  #2,1(a2)
                bne.s   SKSOZPath_SetDownAltLayer
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetDownPriority
; ---------------------------------------------------------------------------

SKSOZPath_SetDownAltLayer:
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

SKSOZPath_SetDownPriority:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #5,d0
                beq.w   SKSOZPath_YCrossingReturn
                ori.w   #high_priority,art_tile(a1)
                bra.w   SKSOZPath_YCrossingReturn
; ---------------------------------------------------------------------------

SKSOZPath_LatchUpCrossing:
                cmp.w   y_pos(a1),d1
                bls.w   SKSOZPath_YCrossingReturn
                move.b  #0,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blt.w   SKSOZPath_YCrossingReturn
                cmp.w   d3,d4
                bge.w   SKSOZPath_YCrossingReturn
                move.b  subtype(a0),d0
                bpl.s   SKSOZPath_CalcUpDistance
                btst    #Status_InAir,status(a1)
                bne.w   SKSOZPath_YCrossingReturn

SKSOZPath_CalcUpDistance:
                move.w  y_pos(a1),d2
                sub.w   d1,d2
                bcc.s   SKSOZPath_CheckUpLayerAndPriority
                neg.w   d2

SKSOZPath_CheckUpLayerAndPriority:
                cmpi.w  #$40,d2
                bhs.w   SKSOZPath_YCrossingReturn
                btst    #0,render_flags(a0)
                bne.s   SKSOZPath_SetUpPriority
                btst    #4,d0
                bne.s   SKSOZPath_CheckUpAltLayer
                cmpi.b  #$C,top_solid_bit(a1)
                bne.s   SKSOZPath_CountUpDefaultCrossing
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetUpDefaultLayer
; ---------------------------------------------------------------------------

SKSOZPath_CountUpDefaultCrossing:
                addq.b  #1,1(a2)
                cmpi.b  #2,1(a2)
                bne.s   SKSOZPath_SetUpDefaultLayer
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetUpPriority
; ---------------------------------------------------------------------------

SKSOZPath_SetUpDefaultLayer:
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                bra.s   SKSOZPath_SetUpPriority
; ---------------------------------------------------------------------------

SKSOZPath_CheckUpAltLayer:
                cmpi.b  #$C,top_solid_bit(a1)
                bne.s   SKSOZPath_CountUpAltCrossing
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetUpPriority
; ---------------------------------------------------------------------------

SKSOZPath_CountUpAltCrossing:
                addq.b  #1,1(a2)
                cmpi.b  #2,1(a2)
                bne.s   SKSOZPath_SetUpAltLayer
                move.b  #0,1(a2)
                bra.s   SKSOZPath_SetUpPriority
; ---------------------------------------------------------------------------

SKSOZPath_SetUpAltLayer:
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

SKSOZPath_SetUpPriority:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #6,d0
                beq.s   SKSOZPath_YCrossingReturn
                ori.w   #high_priority,art_tile(a1)

SKSOZPath_YCrossingReturn:
                rts
; End of function ApplySozPathChangeOnYCrossing
