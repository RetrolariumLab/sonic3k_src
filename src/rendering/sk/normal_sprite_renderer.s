; Owner: rendering/sk
; Responsibility: Prioritized normal sprite display, mapping-piece expansion and orientation-specific rendering helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Render_Sprites:
                tst.w   (Competition_mode).w
                bne.w   Render_Sprites_CompetitionMode
                moveq   #$50-1,d7
                moveq   #0,d6
                lea     (Sprite_table_input).w,a5
                lea     (Camera_X_pos_copy).w,a3
                lea     (Sprite_table).w,a6
                tst.b   (Level_started_flag).w
                beq.s   SKSpriteRender_BeginPriorityBucket
                jsr     (Render_HUD).l
                jsr     (Render_Rings).l

SKSpriteRender_BeginPriorityBucket:
                tst.w   (a5)
                beq.w   Render_Sprites_NextLevel
                lea     2(a5),a4

SKSpriteRender_ReadActorAndPickDrawMode:
                movea.w (a4)+,a0                        ; a0=object
                andi.b  #$7F,render_flags(a0)           ; clear on-screen flag
                move.b  render_flags(a0),d6
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                btst    #6,d6                           ; is the multi-draw flag set?
                bne.w   SKSpriteRender_CullScreenParent  ; if it is, branch
                btst    #2,d6                           ; is this to be positioned by screen coordinates?
                beq.s   SKSpriteRender_MarkSingleVisible  ; if it is, branch
                moveq   #0,d2
                move.b  width_pixels(a0),d2
                sub.w   (a3),d0
                move.w  d0,d3
                add.w   d2,d3                           ; is the object right edge to the left of the screen?
                bmi.s   Render_Sprites_NextObj          ; if it is, branch
                move.w  d0,d3
                sub.w   d2,d3
                cmpi.w  #320,d3                         ; is the object left edge to the right of the screen?
                bge.s   Render_Sprites_NextObj          ; if it is, branch
                addi.w  #128,d0
                sub.w   4(a3),d1
                move.b  height_pixels(a0),d2
                add.w   d2,d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #224,d2
                cmp.w   d2,d1
                bhs.s   Render_Sprites_NextObj          ; if the object is below the screen
                addi.w  #128,d1
                sub.w   d3,d1

; Set visibility before checking the sprite budget or the mapping frame
SKSpriteRender_MarkSingleVisible:
                ori.b   #$80,render_flags(a0)           ; set on-screen flag
                tst.w   d7
                bmi.s   Render_Sprites_NextObj
                movea.l mappings(a0),a1
                moveq   #0,d4
                btst    #5,d6                           ; is the static mappings flag set?
                bne.s   SKSpriteRender_DrawSingleMapping  ; if it is, branch
                move.b  mapping_frame(a0),d4
                add.w   d4,d4
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4                           ; get number of pieces
                bmi.s   Render_Sprites_NextObj          ; if there are 0 pieces, branch

SKSpriteRender_DrawSingleMapping:
                move.w  art_tile(a0),d5
                jsr     RenderMappingPieces(pc)

Render_Sprites_NextObj:
                subq.w  #2,(a5)                         ; decrement object count
                bne.w   SKSpriteRender_ReadActorAndPickDrawMode  ; if there are objects left, repeat

Render_Sprites_NextLevel:
                cmpa.l  #Sprite_table_input,a5
                bne.s   SKSpriteRender_NextPriorityBucket
                cmpi.b  #9,(Current_zone).w             ; LRZ?
                bne.s   SKSpriteRender_NextPriorityBucket
                jsr     (RenderLRZForegroundRockPieces).l

SKSpriteRender_NextPriorityBucket:
                lea     $80(a5),a5                      ; load next priority level
                cmpa.l  #Sprite_table_input_end,a5
                blo.w   SKSpriteRender_BeginPriorityBucket
                move.w  d7,d6
                bmi.s   SKSpriteRender_SaveCountAndCheckMask
                moveq   #0,d0

SKSpriteRender_HideUnusedHardwareSprites:
                move.w  d0,(a6)
                addq.w  #8,a6
                dbf     d7,SKSpriteRender_HideUnusedHardwareSprites

SKSpriteRender_SaveCountAndCheckMask:
                subi.w  #$4F,d6
                neg.w   d6
                move.b  d6,(Sprites_drawn).w
                tst.w   (Spritemask_flag).w
                beq.s   SKSpriteRender_RenderReturn
                cmpi.b  #6,(Player_1+routine).w
                bhs.s   SKSpriteRender_BeginMaskScan
                clr.w   (Spritemask_flag).w

; Scan 79 slots. Earlier code leaves the mask flag set when P1's routine is 6 or higher
SKSpriteRender_BeginMaskScan:
                lea     (Sprite_table-4).w,a0
                move.w  #$7C0,d0
                moveq   #$4F-1,d1

SKSpriteRender_ApplyAllMasks:
                addq.w  #8,a0
                cmp.w   (a0),d0
                dbeq    d1,SKSpriteRender_ApplyAllMasks
                bne.s   SKSpriteRender_RenderReturn
                move.w  #1,2(a0)
                clr.w   $A(a0)
                subq.w  #1,d1
                bpl.s   SKSpriteRender_ApplyAllMasks

SKSpriteRender_RenderReturn:
                rts
; ---------------------------------------------------------------------------

SKSpriteRender_CullScreenParent:
                btst    #2,d6                           ; is this to be positioned by screen coordinates?
                bne.s   SKSpriteRender_ProjectAndCullWorldParent  ; if it is, branch
                moveq   #0,d2

; check if object is within X bounds
                move.b  width_pixels(a0),d2
                subi.w  #128,d0
                move.w  d0,d3
                add.w   d2,d3
                bmi.w   Render_Sprites_NextObj
                move.w  d0,d3
                sub.w   d2,d3
                cmpi.w  #320,d3
                bge.w   Render_Sprites_NextObj
                addi.w  #128,d0

; check if object is within Y bounds
                move.b  height_pixels(a0),d2
                subi.w  #128,d1
                move.w  d1,d3
                add.w   d2,d3
                bmi.w   Render_Sprites_NextObj
                move.w  d1,d3
                sub.w   d2,d3
                cmpi.w  #224,d3
                bge.w   Render_Sprites_NextObj
                addi.w  #128,d1
                bra.s   SKSpriteRender_TryDrawParentFrame
; ---------------------------------------------------------------------------

SKSpriteRender_ProjectAndCullWorldParent:
                moveq   #0,d2
                move.b  width_pixels(a0),d2
                sub.w   (a3),d0
                move.w  d0,d3
                add.w   d2,d3
                bmi.w   Render_Sprites_NextObj
                move.w  d0,d3
                sub.w   d2,d3
                cmpi.w  #320,d3
                bge.w   Render_Sprites_NextObj
                addi.w  #128,d0
                sub.w   4(a3),d1
                move.b  height_pixels(a0),d2
                add.w   d2,d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #224,d2
                cmp.w   d2,d1
                bhs.w   Render_Sprites_NextObj
                addi.w  #128,d1
                sub.w   d3,d1

SKSpriteRender_TryDrawParentFrame:
                ori.b   #$80,render_flags(a0)
                tst.w   d7
                bmi.w   Render_Sprites_NextObj
                move.w  art_tile(a0),d5
                movea.l mappings(a0),a2
                moveq   #0,d4
                move.b  mapping_frame(a0),d4
                beq.s   SKSpriteRender_BeginEmbeddedChildren
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   SKSpriteRender_BeginEmbeddedChildren
                move.w  d6,d3
                jsr     RenderMappingPiecesClipped(pc)
                move.w  d3,d6
                tst.w   d7
                bmi.w   Render_Sprites_NextObj

SKSpriteRender_BeginEmbeddedChildren:
                move.w  mainspr_childsprites(a0),d3
                subq.w  #1,d3
                bcs.w   Render_Sprites_NextObj
                lea     sub2_x_pos(a0),a0

; World children add the hardware Y bias before wrapping Y
SKSpriteRender_ReadAndProjectChild:
                move.w  (a0)+,d0
                move.w  (a0)+,d1
                btst    #2,d6
                beq.s   SKSpriteRender_DrawChildFrameClipped
                sub.w   (a3),d0
                addi.w  #128,d0
                sub.w   4(a3),d1
                addi.w  #128,d1
                and.w   (Screen_Y_wrap_value).w,d1

SKSpriteRender_DrawChildFrameClipped:
                addq.w  #1,a0
                moveq   #0,d4
                move.b  (a0)+,d4
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   SKSpriteRender_TryNextEmbeddedChild
                move.w  d6,-(sp)
                jsr     RenderMappingPiecesClipped(pc)
                move.w  (sp)+,d6

SKSpriteRender_TryNextEmbeddedChild:
                tst.w   d7
                dbmi    d3,SKSpriteRender_ReadAndProjectChild
                bra.w   Render_Sprites_NextObj
; End of function Render_Sprites

; =============== S U B R O U T I N E =======================================

RenderMappingPieces:
                lsr.b   #1,d6
                bcs.s   SKSpriteRender_PickUnclippedHOrHV
                lsr.b   #1,d6
                bcs.w   SKSpriteRender_DrawUnclippedPieceV

SKSpriteRender_DrawUnclippedPiece:
                move.b  (a1)+,d2
                ext.w   d2
                add.w   d1,d2
                move.w  d2,(a6)+
                move.b  (a1)+,(a6)+
                addq.w  #1,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                add.w   d0,d2
                andi.w  #$1FF,d2
                bne.s   SKSpriteRender_FinishUnclippedPiece
                addq.w  #1,d2

SKSpriteRender_FinishUnclippedPiece:
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,SKSpriteRender_DrawUnclippedPiece
                rts
; ---------------------------------------------------------------------------

SKSpriteRender_PickUnclippedHOrHV:
                lsr.b   #1,d6
                bcs.s   SKSpriteRender_DrawUnclippedPieceHV

SKSpriteRender_DrawUnclippedPieceH:
                move.b  (a1)+,d2
                ext.w   d2
                add.w   d1,d2
                move.w  d2,(a6)+
                move.b  (a1)+,d6
                move.b  d6,(a6)+
                addq.w  #1,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                eori.w  #$800,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                neg.w   d2
                move.b  SKSpriteRender_UnclippedWidthByVdpSize(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d0,d2
                andi.w  #$1FF,d2
                bne.s   SKSpriteRender_FinishUnclippedPieceH
                addq.w  #1,d2

SKSpriteRender_FinishUnclippedPieceH:
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,SKSpriteRender_DrawUnclippedPieceH
                rts
; ---------------------------------------------------------------------------
SKSpriteRender_UnclippedWidthByVdpSize:
                dc.b    8,   8,   8,   8
                dc.b    $10, $10, $10, $10
                dc.b    $18, $18, $18, $18
                dc.b    $20, $20, $20, $20
                even
; ---------------------------------------------------------------------------

SKSpriteRender_DrawUnclippedPieceHV:
                move.b  (a1)+,d2
                ext.w   d2
                neg.w   d2
                move.b  (a1),d6
                move.b  SKSpriteRender_UnclippedHeightByVdpSize(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d1,d2
                move.w  d2,(a6)+
                move.b  (a1)+,d6
                move.b  d6,(a6)+
                addq.w  #1,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                eori.w  #$1800,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                neg.w   d2
                move.b  SKSpriteRender_UnclippedWidthByVdpSize(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d0,d2
                andi.w  #$1FF,d2
                bne.s   SKSpriteRender_FinishUnclippedPieceHV
                addq.w  #1,d2

SKSpriteRender_FinishUnclippedPieceHV:
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,SKSpriteRender_DrawUnclippedPieceHV
                rts
; ---------------------------------------------------------------------------
SKSpriteRender_UnclippedHeightByVdpSize:
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                even
; ---------------------------------------------------------------------------

SKSpriteRender_DrawUnclippedPieceV:
                move.b  (a1)+,d2
                ext.w   d2
                neg.w   d2
                move.b  (a1)+,d6
                move.b  d6,2(a6)
                move.b  SKSpriteRender_UnclippedHeightByVdpSize(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d1,d2
                move.w  d2,(a6)+
                addq.w  #2,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                eori.w  #$1000,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                add.w   d0,d2
                andi.w  #$1FF,d2
                bne.s   SKSpriteRender_FinishUnclippedPieceV
                addq.w  #1,d2

SKSpriteRender_FinishUnclippedPieceV:
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,SKSpriteRender_DrawUnclippedPieceV
                rts
; End of function RenderMappingPieces

; =============== S U B R O U T I N E =======================================

RenderMappingPiecesClipped:
                lsr.b   #1,d6
                bcs.s   SKSpriteRender_PickClippedHOrHV
                lsr.b   #1,d6
                bcs.w   SKSpriteRender_DrawClippedPieceV

SKSpriteRender_DrawClippedPiece:
                move.b  (a1)+,d2
                ext.w   d2
                add.w   d1,d2
                cmpi.w  #-32+128,d2
                bls.s   SKSpriteRender_RejectClippedY
                cmpi.w  #224+128,d2
                bhs.s   SKSpriteRender_RejectClippedY
                move.w  d2,(a6)+
                move.b  (a1)+,(a6)+
                addq.w  #1,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                add.w   d0,d2
                cmpi.w  #-32+128,d2
                bls.s   SKSpriteRender_RejectClippedX
                cmpi.w  #320+128,d2
                bhs.s   SKSpriteRender_RejectClippedX
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,SKSpriteRender_DrawClippedPiece
                rts
; ---------------------------------------------------------------------------

SKSpriteRender_RejectClippedX:
                subq.w  #6,a6
                dbf     d4,SKSpriteRender_DrawClippedPiece
                rts
; ---------------------------------------------------------------------------

SKSpriteRender_RejectClippedY:
                addq.w  #5,a1
                dbf     d4,SKSpriteRender_DrawClippedPiece
                rts
; ---------------------------------------------------------------------------

SKSpriteRender_PickClippedHOrHV:
                lsr.b   #1,d6
                bcs.s   SKSpriteRender_DrawClippedPieceHV

SKSpriteRender_DrawClippedPieceH:
                move.b  (a1)+,d2
                ext.w   d2
                add.w   d1,d2
                cmpi.w  #-32+128,d2
                bls.s   SKSpriteRender_RejectClippedYH
                cmpi.w  #224+128,d2
                bhs.s   SKSpriteRender_RejectClippedYH
                move.w  d2,(a6)+
                move.b  (a1)+,d6
                move.b  d6,(a6)+
                addq.w  #1,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                eori.w  #$800,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                neg.w   d2
                move.b  SKSpriteRender_ClippedWidthByVdpSize(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d0,d2
                cmpi.w  #-32+128,d2
                bls.s   SKSpriteRender_RejectClippedXH
                cmpi.w  #320+128,d2
                bhs.s   SKSpriteRender_RejectClippedXH
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,SKSpriteRender_DrawClippedPieceH
                rts
; ---------------------------------------------------------------------------

SKSpriteRender_RejectClippedXH:
                subq.w  #6,a6
                dbf     d4,SKSpriteRender_DrawClippedPieceH
                rts
; ---------------------------------------------------------------------------

SKSpriteRender_RejectClippedYH:
                addq.w  #5,a1
                dbf     d4,SKSpriteRender_DrawClippedPieceH
                rts
; ---------------------------------------------------------------------------
SKSpriteRender_ClippedWidthByVdpSize:
                dc.b    8,   8,   8,   8
                dc.b    $10, $10, $10, $10
                dc.b    $18, $18, $18, $18
                dc.b    $20, $20, $20, $20
                even
; ---------------------------------------------------------------------------

SKSpriteRender_DrawClippedPieceHV:
                move.b  (a1)+,d2
                ext.w   d2
                neg.w   d2
                move.b  (a1),d6
                move.b  SKSpriteRender_ClippedHeightByVdpSize(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d1,d2
                cmpi.w  #-32+128,d2
                bls.s   SKSpriteRender_RejectClippedYHV
                cmpi.w  #224+128,d2
                bhs.s   SKSpriteRender_RejectClippedYHV
                move.w  d2,(a6)+
                move.b  (a1)+,d6
                move.b  d6,(a6)+
                addq.w  #1,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                eori.w  #$1800,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                neg.w   d2
                move.b  SKSpriteRender_ClippedWidthByVdpSize(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d0,d2
                cmpi.w  #-32+128,d2
                bls.s   SKSpriteRender_RejectClippedXHV
                cmpi.w  #320+128,d2
                bhs.s   SKSpriteRender_RejectClippedXHV
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,SKSpriteRender_DrawClippedPieceHV
                rts
; ---------------------------------------------------------------------------

SKSpriteRender_RejectClippedXHV:
                subq.w  #6,a6
                dbf     d4,SKSpriteRender_DrawClippedPieceHV
                rts
; ---------------------------------------------------------------------------

SKSpriteRender_RejectClippedYHV:
                addq.w  #5,a1
                dbf     d4,SKSpriteRender_DrawClippedPieceHV
                rts
; ---------------------------------------------------------------------------
SKSpriteRender_ClippedHeightByVdpSize:
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                even
; ---------------------------------------------------------------------------

SKSpriteRender_DrawClippedPieceV:
                move.b  (a1)+,d2
                ext.w   d2
                neg.w   d2
                move.b  (a1)+,d6
                move.b  d6,2(a6)
                move.b  SKSpriteRender_ClippedHeightByVdpSize(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d1,d2
                cmpi.w  #-32+128,d2
                bls.s   SKSpriteRender_RejectClippedYV
                cmpi.w  #224+128,d2
                bhs.s   SKSpriteRender_RejectClippedYV
                move.w  d2,(a6)+
                addq.w  #2,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                eori.w  #$1000,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                add.w   d0,d2
                cmpi.w  #-32+128,d2
                bls.s   SKSpriteRender_RejectClippedXV
                cmpi.w  #320+128,d2
                bhs.s   SKSpriteRender_RejectClippedXV
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,SKSpriteRender_DrawClippedPieceV
                rts
; ---------------------------------------------------------------------------

SKSpriteRender_RejectClippedXV:
                subq.w  #6,a6
                dbf     d4,SKSpriteRender_DrawClippedPieceV
                rts
; ---------------------------------------------------------------------------

; Skip four source bytes. The size byte has already been written to the output slot
SKSpriteRender_RejectClippedYV:
                addq.w  #4,a1
                dbf     d4,SKSpriteRender_DrawClippedPieceV
                rts
; End of function RenderMappingPiecesClipped
