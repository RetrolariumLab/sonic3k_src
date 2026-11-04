; Owner: rendering/s3
; Responsibility: Prioritized normal sprite display, mapping-piece expansion and orientation-specific rendering helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Render_Sprites:
                tst.w   (Competition_mode).w
                bne.w   Render_Sprites_CompetitionMode
                moveq   #80-1,d7                        ; Number of sprites to render
                moveq   #0,d6
                lea     (Sprite_table_input).w,a5
                lea     (Camera_X_pos_copy).w,a3
                lea     (Sprite_table).w,a6
                tst.b   (Level_started_flag).w
                beq.s   S3SpriteRender_BeginPriorityBucket
                jsr     (Render_HUD).l
                jsr     (Render_Rings).l

S3SpriteRender_BeginPriorityBucket:
                tst.w   (a5)
                beq.w   Render_Sprites_NextLevel
                lea     2(a5),a4

S3SpriteRender_ReadActorAndPickDrawMode:
                movea.w (a4)+,a0                        ; a0=object
                andi.b  #$7F,render_flags(a0)           ; clear on-screen flag
                move.b  render_flags(a0),d6
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                btst    #6,d6                           ; is the multi-draw flag set?
                bne.w   S3SpriteRender_CullScreenParent  ; if it is, branch
                btst    #2,d6                           ; is this to be positioned by screen coordinates?
                beq.s   S3SpriteRender_MarkSingleVisible  ; if it is, branch
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
S3SpriteRender_MarkSingleVisible:
                ori.b   #$80,render_flags(a0)           ; set on-screen flag
                tst.w   d7
                bmi.s   Render_Sprites_NextObj
                movea.l mappings(a0),a1
                moveq   #0,d4
                btst    #5,d6                           ; is the static mappings flag set?
                bne.s   S3SpriteRender_DrawSingleMapping  ; if it is, branch
                move.b  mapping_frame(a0),d4
                add.w   d4,d4
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4                           ; get number of pieces
                bmi.s   Render_Sprites_NextObj          ; if there are 0 pieces, branch

S3SpriteRender_DrawSingleMapping:
                move.w  art_tile(a0),d5
                jsr     RenderMappingPieces(pc)

Render_Sprites_NextObj:
                subq.w  #2,(a5)                         ; decrement object count
                bne.w   S3SpriteRender_ReadActorAndPickDrawMode  ; if there are objects left, repeat

Render_Sprites_NextLevel:
                cmpa.l  #Sprite_table_input,a5
                bne.s   S3SpriteRender_NextPriorityBucket
                cmpi.w  #$900,(Current_zone_and_act).w  ; LRZ Act 1?
                bne.s   S3SpriteRender_NextPriorityBucket
                jsr     (RenderLRZForegroundRockPieces).l

S3SpriteRender_NextPriorityBucket:
                lea     $80(a5),a5                      ; load next priority level
                cmpa.l  #Sprite_table_input_end,a5
                blo.w   S3SpriteRender_BeginPriorityBucket
                move.w  d7,d6
                bmi.s   S3SpriteRender_SaveCountAndCheckMask
                moveq   #0,d0

S3SpriteRender_HideUnusedHardwareSprites:
                move.w  d0,(a6)
                addq.w  #8,a6
                dbf     d7,S3SpriteRender_HideUnusedHardwareSprites

S3SpriteRender_SaveCountAndCheckMask:
                subi.w  #$4F,d6
                neg.w   d6
                move.b  d6,(Sprites_drawn).w
                tst.w   (Spritemask_flag).w
                beq.s   S3SpriteRender_RenderReturn
                clr.w   (Spritemask_flag).w
                lea     (Sprite_table-4).w,a0
                move.w  #$7C0,d0
                moveq   #80-1,d1

; Scan at most 80 slots and stop after the first mask tile
S3SpriteRender_ApplyFirstMask:
                addq.w  #8,a0
                cmp.w   (a0),d0
                dbeq    d1,S3SpriteRender_ApplyFirstMask
                bne.s   S3SpriteRender_RenderReturn
                move.w  #1,2(a0)
                clr.w   $A(a0)

S3SpriteRender_RenderReturn:
                rts
; ---------------------------------------------------------------------------

S3SpriteRender_CullScreenParent:
                btst    #2,d6                           ; is this to be positioned by screen coordinates?
                bne.s   S3SpriteRender_ProjectAndCullWorldParent  ; if it is, branch
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
                bra.s   S3SpriteRender_TryDrawParentFrame
; ---------------------------------------------------------------------------

S3SpriteRender_ProjectAndCullWorldParent:
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

S3SpriteRender_TryDrawParentFrame:
                ori.b   #$80,render_flags(a0)
                tst.w   d7
                bmi.w   Render_Sprites_NextObj
                move.w  art_tile(a0),d5
                movea.l mappings(a0),a2
                moveq   #0,d4
                move.b  mapping_frame(a0),d4
                beq.s   S3SpriteRender_BeginEmbeddedChildren
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   S3SpriteRender_BeginEmbeddedChildren
                move.w  d6,d3
                jsr     RenderMappingPiecesClipped(pc)
                move.w  d3,d6
                tst.w   d7
                bmi.w   Render_Sprites_NextObj

S3SpriteRender_BeginEmbeddedChildren:
                move.w  mainspr_childsprites(a0),d3
                subq.w  #1,d3
                bcs.w   Render_Sprites_NextObj
                lea     sub2_x_pos(a0),a0

; World children add the hardware Y bias before wrapping Y
S3SpriteRender_ReadAndProjectChild:
                move.w  (a0)+,d0
                move.w  (a0)+,d1
                btst    #2,d6
                beq.s   S3SpriteRender_DrawChildFrameClipped
                sub.w   (a3),d0
                addi.w  #128,d0
                sub.w   4(a3),d1
                addi.w  #128,d1
                and.w   (Screen_Y_wrap_value).w,d1

S3SpriteRender_DrawChildFrameClipped:
                addq.w  #1,a0
                moveq   #0,d4
                move.b  (a0)+,d4
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   S3SpriteRender_TryNextEmbeddedChild
                move.w  d6,-(sp)
                jsr     RenderMappingPiecesClipped(pc)
                move.w  (sp)+,d6

S3SpriteRender_TryNextEmbeddedChild:
                tst.w   d7
                dbmi    d3,S3SpriteRender_ReadAndProjectChild
                bra.w   Render_Sprites_NextObj
; End of function Render_Sprites

; =============== S U B R O U T I N E =======================================

RenderMappingPieces:
                lsr.b   #1,d6
                bcs.s   S3SpriteRender_PickUnclippedHOrHV
                lsr.b   #1,d6
                bcs.w   S3SpriteRender_DrawUnclippedPieceV

S3SpriteRender_DrawUnclippedPiece:
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
                bne.s   S3SpriteRender_FinishUnclippedPiece
                addq.w  #1,d2

S3SpriteRender_FinishUnclippedPiece:
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,S3SpriteRender_DrawUnclippedPiece
                rts
; ---------------------------------------------------------------------------

S3SpriteRender_PickUnclippedHOrHV:
                lsr.b   #1,d6
                bcs.s   S3SpriteRender_DrawUnclippedPieceHV

S3SpriteRender_DrawUnclippedPieceH:
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
                move.b  S3SpriteRender_UnclippedWidthByVdpSize(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d0,d2
                andi.w  #$1FF,d2
                bne.s   S3SpriteRender_FinishUnclippedPieceH
                addq.w  #1,d2

S3SpriteRender_FinishUnclippedPieceH:
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,S3SpriteRender_DrawUnclippedPieceH
                rts
; ---------------------------------------------------------------------------
S3SpriteRender_UnclippedWidthByVdpSize:
                dc.b    8,   8,   8,   8
                dc.b    $10, $10, $10, $10
                dc.b    $18, $18, $18, $18
                dc.b    $20, $20, $20, $20
                even
; ---------------------------------------------------------------------------

S3SpriteRender_DrawUnclippedPieceHV:
                move.b  (a1)+,d2
                ext.w   d2
                neg.w   d2
                move.b  (a1),d6
                move.b  S3SpriteRender_UnclippedHeightByVdpSize(pc,d6.w),d6
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
                move.b  S3SpriteRender_UnclippedWidthByVdpSize(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d0,d2
                andi.w  #$1FF,d2
                bne.s   S3SpriteRender_FinishUnclippedPieceHV
                addq.w  #1,d2

S3SpriteRender_FinishUnclippedPieceHV:
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,S3SpriteRender_DrawUnclippedPieceHV
                rts
; ---------------------------------------------------------------------------
S3SpriteRender_UnclippedHeightByVdpSize:
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                even
; ---------------------------------------------------------------------------

S3SpriteRender_DrawUnclippedPieceV:
                move.b  (a1)+,d2
                ext.w   d2
                neg.w   d2
                move.b  (a1)+,d6
                move.b  d6,2(a6)
                move.b  S3SpriteRender_UnclippedHeightByVdpSize(pc,d6.w),d6
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
                bne.s   S3SpriteRender_FinishUnclippedPieceV
                addq.w  #1,d2

S3SpriteRender_FinishUnclippedPieceV:
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,S3SpriteRender_DrawUnclippedPieceV
                rts
; End of function RenderMappingPieces

; =============== S U B R O U T I N E =======================================

RenderMappingPiecesClipped:
                lsr.b   #1,d6
                bcs.s   S3SpriteRender_PickClippedHOrHV
                lsr.b   #1,d6
                bcs.w   S3SpriteRender_DrawClippedPieceV

S3SpriteRender_DrawClippedPiece:
                move.b  (a1)+,d2
                ext.w   d2
                add.w   d1,d2
                cmpi.w  #-32+128,d2
                bls.s   S3SpriteRender_RejectClippedY
                cmpi.w  #224+128,d2
                bhs.s   S3SpriteRender_RejectClippedY
                move.w  d2,(a6)+
                move.b  (a1)+,(a6)+
                addq.w  #1,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                add.w   d0,d2
                cmpi.w  #-32+128,d2
                bls.s   S3SpriteRender_RejectClippedX
                cmpi.w  #320+128,d2
                bhs.s   S3SpriteRender_RejectClippedX
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,S3SpriteRender_DrawClippedPiece
                rts
; ---------------------------------------------------------------------------

S3SpriteRender_RejectClippedX:
                subq.w  #6,a6
                dbf     d4,S3SpriteRender_DrawClippedPiece
                rts
; ---------------------------------------------------------------------------

S3SpriteRender_RejectClippedY:
                addq.w  #5,a1
                dbf     d4,S3SpriteRender_DrawClippedPiece
                rts
; ---------------------------------------------------------------------------

S3SpriteRender_PickClippedHOrHV:
                lsr.b   #1,d6
                bcs.s   S3SpriteRender_DrawClippedPieceHV

S3SpriteRender_DrawClippedPieceH:
                move.b  (a1)+,d2
                ext.w   d2
                add.w   d1,d2
                cmpi.w  #-32+128,d2
                bls.s   S3SpriteRender_RejectClippedYH
                cmpi.w  #224+128,d2
                bhs.s   S3SpriteRender_RejectClippedYH
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
                move.b  S3SpriteRender_ClippedWidthByVdpSize(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d0,d2
                cmpi.w  #-32+128,d2
                bls.s   S3SpriteRender_RejectClippedXH
                cmpi.w  #320+128,d2
                bhs.s   S3SpriteRender_RejectClippedXH
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,S3SpriteRender_DrawClippedPieceH
                rts
; ---------------------------------------------------------------------------

S3SpriteRender_RejectClippedXH:
                subq.w  #6,a6
                dbf     d4,S3SpriteRender_DrawClippedPieceH
                rts
; ---------------------------------------------------------------------------

S3SpriteRender_RejectClippedYH:
                addq.w  #5,a1
                dbf     d4,S3SpriteRender_DrawClippedPieceH
                rts
; ---------------------------------------------------------------------------
S3SpriteRender_ClippedWidthByVdpSize:
                dc.b    8,   8,   8,   8
                dc.b    $10, $10, $10, $10
                dc.b    $18, $18, $18, $18
                dc.b    $20, $20, $20, $20
                even
; ---------------------------------------------------------------------------

S3SpriteRender_DrawClippedPieceHV:
                move.b  (a1)+,d2
                ext.w   d2
                neg.w   d2
                move.b  (a1),d6
                move.b  S3SpriteRender_ClippedHeightByVdpSize(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d1,d2
                cmpi.w  #-32+128,d2
                bls.s   S3SpriteRender_RejectClippedYHV
                cmpi.w  #224+128,d2
                bhs.s   S3SpriteRender_RejectClippedYHV
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
                move.b  S3SpriteRender_ClippedWidthByVdpSize(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d0,d2
                cmpi.w  #-32+128,d2
                bls.s   S3SpriteRender_RejectClippedXHV
                cmpi.w  #320+128,d2
                bhs.s   S3SpriteRender_RejectClippedXHV
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,S3SpriteRender_DrawClippedPieceHV
                rts
; ---------------------------------------------------------------------------

S3SpriteRender_RejectClippedXHV:
                subq.w  #6,a6
                dbf     d4,S3SpriteRender_DrawClippedPieceHV
                rts
; ---------------------------------------------------------------------------

S3SpriteRender_RejectClippedYHV:
                addq.w  #5,a1
                dbf     d4,S3SpriteRender_DrawClippedPieceHV
                rts
; ---------------------------------------------------------------------------
S3SpriteRender_ClippedHeightByVdpSize:
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                dc.b    8, $10, $18, $20
                even
; ---------------------------------------------------------------------------

S3SpriteRender_DrawClippedPieceV:
                move.b  (a1)+,d2
                ext.w   d2
                neg.w   d2
                move.b  (a1)+,d6
                move.b  d6,2(a6)
                move.b  S3SpriteRender_ClippedHeightByVdpSize(pc,d6.w),d6
                sub.w   d6,d2
                add.w   d1,d2
                cmpi.w  #-32+128,d2
                bls.s   S3SpriteRender_RejectClippedYV
                cmpi.w  #224+128,d2
                bhs.s   S3SpriteRender_RejectClippedYV
                move.w  d2,(a6)+
                addq.w  #2,a6
                move.w  (a1)+,d2
                add.w   d5,d2
                eori.w  #$1000,d2
                move.w  d2,(a6)+
                move.w  (a1)+,d2
                add.w   d0,d2
                cmpi.w  #-32+128,d2
                bls.s   S3SpriteRender_RejectClippedXV
                cmpi.w  #320+128,d2
                bhs.s   S3SpriteRender_RejectClippedXV
                move.w  d2,(a6)+
                subq.w  #1,d7
                dbmi    d4,S3SpriteRender_DrawClippedPieceV
                rts
; ---------------------------------------------------------------------------

S3SpriteRender_RejectClippedXV:
                subq.w  #6,a6
                dbf     d4,S3SpriteRender_DrawClippedPieceV
                rts
; ---------------------------------------------------------------------------

; Skip four source bytes. The size byte has already been written to the output slot
S3SpriteRender_RejectClippedYV:
                addq.w  #4,a1
                dbf     d4,S3SpriteRender_DrawClippedPieceV
                rts
; End of function RenderMappingPiecesClipped
