; Owner: objects/zones/hcz/sk
; Responsibility: Hydrocity snake-block initialization, coordinated block motion and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZSnakeBlocks:
                move.l  #Map_HCZFloatingPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZ2BlockPlat,0,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$180,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #1,mapping_frame(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$34(a0)
                move.b  status(a0),$2E(a0)
                moveq   #1,d0
                move.b  subtype(a0),d1
                bpl.s   SKSnakeBlocks_InitSquareMotion
                neg.w   d0

SKSnakeBlocks_InitSquareMotion:
                move.b  d0,$40(a0)
                andi.b  #$7F,d1
                move.b  d1,angle(a0)
                move.w  #$280,$42(a0)
                move.w  x_pos(a0),$44(a0)
                move.l  #SKSnakeBlocks_MoveAndCheckSolid,(a0)

SKSnakeBlocks_MoveAndCheckSolid:
                bsr.s   MoveHczSnakeBlockAlongSquare
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.w  $44(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmp.w   $42(a0),d0
                bhi.w   SKSnakeBlocks_ClearRespawnBit
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSnakeBlocks_ClearRespawnBit:
                move.w  respawn_addr(a0),d0
                beq.s   SKSnakeBlocks_DeleteOutsideAnchorRange
                movea.w d0,a2
                bclr    #7,(a2)

SKSnakeBlocks_DeleteOutsideAnchorRange:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

MoveHczSnakeBlockAlongSquare:
                move.b  $40(a0),d0
                bpl.s   SKSnakeBlocks_StepForwardPhase
                add.b   d0,angle(a0)
                bcs.s   SKSnakeBlocks_ClampReversePhase
                subq.b  #1,$2E(a0)
                andi.b  #3,$2E(a0)

SKSnakeBlocks_ClampReversePhase:
                move.w  #$40,d2
                move.b  angle(a0),d0
                cmpi.b  #$80,d0
                bhs.s   SKSnakeBlocks_PlaceAlongTopEdge
                move.b  #$80,d0
                bra.s   SKSnakeBlocks_PlaceAlongTopEdge
; ---------------------------------------------------------------------------

SKSnakeBlocks_StepForwardPhase:
                add.b   d0,angle(a0)
                bne.s   SKSnakeBlocks_ClampForwardPhase
                addq.b  #1,$2E(a0)
                andi.b  #3,$2E(a0)

SKSnakeBlocks_ClampForwardPhase:
                move.w  #$40,d2
                move.b  angle(a0),d0
                cmpi.b  #$80,d0
                bhs.s   SKSnakeBlocks_PlaceAlongTopEdge
                move.b  #$80,d0

SKSnakeBlocks_PlaceAlongTopEdge:
                jsr     (GetSineCosine).l
                asr.w   #2,d1
                move.b  $2E(a0),d3
                andi.b  #3,d3
                bne.s   SKSnakeBlocks_PlaceAlongRightEdge
                add.w   $30(a0),d1
                move.w  d1,x_pos(a0)
                neg.w   d2
                add.w   $34(a0),d2
                move.w  d2,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKSnakeBlocks_PlaceAlongRightEdge:
                subq.b  #1,d3
                bne.s   SKSnakeBlocks_PlaceAlongBottomEdge
                add.w   $34(a0),d1
                move.w  d1,y_pos(a0)
                add.w   $30(a0),d2
                move.w  d2,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKSnakeBlocks_PlaceAlongBottomEdge:
                subq.b  #1,d3
                bne.s   SKSnakeBlocks_PlaceAlongLeftEdge
                neg.w   d1
                add.w   $30(a0),d1
                move.w  d1,x_pos(a0)
                add.w   $34(a0),d2
                move.w  d2,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKSnakeBlocks_PlaceAlongLeftEdge:
                neg.w   d1
                add.w   $34(a0),d1
                move.w  d1,y_pos(a0)
                neg.w   d2
                add.w   $30(a0),d2
                move.w  d2,x_pos(a0)
                rts
; End of function MoveHczSnakeBlockAlongSquare
