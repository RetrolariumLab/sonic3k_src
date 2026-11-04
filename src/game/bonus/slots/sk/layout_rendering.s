; Owner: game/bonus/slots/sk
; Responsibility: Rotating slot bonus layout rendering, transformed tile lookup, collision and private mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Slots_RenderLayout:
                bsr.w   Slots_UpdateCellFrames
                bsr.w   SlotsAdvanceAllTransientCellAnimations
                lea     (Chunk_table+$7800).l,a1
                move.b  (Stat_table).w,d0
                andi.b  #$FC,d0
                jsr     (GetSineCosine).l
                move.w  d0,d4
                move.w  d1,d5
                muls.w  #$18,d4
                muls.w  #$18,d5
                moveq   #0,d2
                move.w  (Camera_X_pos).w,d2
                divu.w  #$18,d2
                swap    d2
                neg.w   d2
                addi.w  #-$B4,d2
                moveq   #0,d3
                move.w  (Camera_Y_pos).w,d3
                divu.w  #$18,d3
                swap    d3
                neg.w   d3
                addi.w  #-$B4,d3
                move.w  #$10-1,d7

SlotsLayout_TransformSampleRow:
                movem.w d0-d2,-(sp)
                movem.w d0-d1,-(sp)
                neg.w   d0
                muls.w  d2,d1
                muls.w  d3,d0
                move.l  d0,d6
                add.l   d1,d6
                movem.w (sp)+,d0-d1
                muls.w  d2,d0
                muls.w  d3,d1
                add.l   d0,d1
                move.l  d6,d2
                move.w  #$10-1,d6

SlotsLayout_Store16CoordinatePairs:
                move.l  d2,d0
                asr.l   #8,d0
                move.w  d0,(a1)+
                move.l  d1,d0
                asr.l   #8,d0
                move.w  d0,(a1)+
                add.l   d5,d2
                add.l   d4,d1
                dbf     d6,SlotsLayout_Store16CoordinatePairs
                movem.w (sp)+,d0-d2
                addi.w  #$18,d3
                dbf     d7,SlotsLayout_TransformSampleRow
                lea     (RAM_start+$3000).l,a0
                moveq   #0,d0
                move.w  (Camera_Y_pos).w,d0
                divu.w  #$18,d0
                mulu.w  #$80,d0
                adda.l  d0,a0
                moveq   #0,d0
                move.w  (Camera_X_pos).w,d0
                divu.w  #$18,d0
                adda.w  d0,a0
                lea     (Chunk_table+$7800).l,a4
                lea     (Sprite_table).w,a2
                moveq   #0,d5
                move.b  (Sprites_drawn).w,d5
                move.w  d5,d0
                lsl.w   #3,d0
                adda.w  d0,a2
                move.w  #$10-1,d7

SlotsLayout_Begin16CellRow:
                move.w  #$10-1,d6

SlotsLayout_FilterCellAndFindMapping:
                moveq   #0,d0
                move.b  (a0)+,d0
                beq.s   SlotsLayout_AdvanceSamplesAndStoreCount
                cmpi.b  #$13,d0
                bhi.s   SlotsLayout_AdvanceSamplesAndStoreCount
                move.w  (a4),d3
                addi.w  #$120,d3
                cmpi.w  #$70,d3
                blo.s   SlotsLayout_AdvanceSamplesAndStoreCount
                cmpi.w  #$1D0,d3
                bhs.s   SlotsLayout_AdvanceSamplesAndStoreCount
                move.w  2(a4),d2
                addi.w  #$F0,d2
                cmpi.w  #$70,d2
                blo.s   SlotsLayout_AdvanceSamplesAndStoreCount
                cmpi.w  #$170,d2
                bhs.s   SlotsLayout_AdvanceSamplesAndStoreCount
                lea     (Chunk_table+$7000).l,a5
                lsl.w   #3,d0
                lea     (a5,d0.w),a5
                movea.l (a5)+,a1
                move.w  (a5)+,d1
                add.w   d1,d1
                adda.w  (a1,d1.w),a1
                movea.w (a5)+,a3
                moveq   #0,d1
                move.b  (a1)+,d1
                subq.b  #1,d1
                bmi.s   SlotsLayout_AdvanceSamplesAndStoreCount
                bsr.s   Slots_AppendPiecesToSpriteTable

SlotsLayout_AdvanceSamplesAndStoreCount:
                addq.w  #4,a4
                dbf     d6,SlotsLayout_FilterCellAndFindMapping
                lea     $70(a0),a0
                dbf     d7,SlotsLayout_Begin16CellRow
                move.b  d5,(Sprites_drawn).w
                rts
; End of function Slots_RenderLayout

; =============== S U B R O U T I N E =======================================

; Translate five-byte mapping pieces into hardware entries and stop at 80 sprites
Slots_AppendPiecesToSpriteTable:
                cmpi.b  #$50,d5
                beq.s   SlotsLayout_EmitPieceLoopReturn
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,(a2)+
                move.b  (a1)+,(a2)+
                addq.b  #1,d5
                addq.w  #1,a2
                move.b  (a1)+,d0
                lsl.w   #8,d0
                move.b  (a1)+,d0
                add.w   a3,d0
                move.w  d0,(a2)+
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d3,d0
                andi.w  #$1FF,d0
                bne.s   SlotsLayout_StoreNonzeroWrappedX
                addq.w  #1,d0

SlotsLayout_StoreNonzeroWrappedX:
                move.w  d0,(a2)+
                dbf     d1,Slots_AppendPiecesToSpriteTable

SlotsLayout_EmitPieceLoopReturn:
                rts
; End of function Slots_AppendPiecesToSpriteTable

; =============== S U B R O U T I N E =======================================

; Update descriptor frames from field rotation, ring animation and the two local frame timers
Slots_UpdateCellFrames:
                lea     (Chunk_table+$700C).l,a1
                moveq   #0,d0
                move.b  (Stat_table).w,d0
                lsr.b   #2,d0
                andi.w  #$F,d0
                moveq   #3-1,d1

SlotsLayout_SetColoredCellFrames:
                move.w  d0,(a1)
                addq.w  #8,a1
                dbf     d1,SlotsLayout_SetColoredCellFrames
                lea     (Chunk_table+$706C).l,a1
                moveq   #3-1,d1

SlotsLayout_SetTemporaryWallFrames:
                move.w  d0,(a1)
                addq.w  #8,a1
                dbf     d1,SlotsLayout_SetTemporaryWallFrames
                lea     (Chunk_table+$7005).l,a1
                subq.b  #1,(Slot_machine_goal_frame_timer).w
                bpl.s   SlotsLayout_SetGoalAndRingFrames
                move.b  #1,(Slot_machine_goal_frame_timer).w
                addq.b  #1,$20(a1)
                cmpi.b  #3,$20(a1)
                blo.s   SlotsLayout_AdvanceGoalFrameModulo6
                move.b  #0,$20(a1)

SlotsLayout_AdvanceGoalFrameModulo6:
                addq.b  #1,(Slot_machine_goal_frame).w
                cmpi.b  #6,(Slot_machine_goal_frame).w
                blo.s   SlotsLayout_SetGoalAndRingFrames
                move.b  #0,(Slot_machine_goal_frame).w

SlotsLayout_SetGoalAndRingFrames:
                move.b  (Slot_machine_goal_frame).w,$48(a1)
                move.b  (Rings_frame).w,$40(a1)
                subq.b  #1,(Slot_machine_peppermint_frame_timer).w
                bpl.s   SlotsLayout_SetPeppermintFrame
                move.b  #3,(Slot_machine_peppermint_frame_timer).w
                addq.b  #1,(Slot_machine_peppermint_frame).w
                andi.b  #3,(Slot_machine_peppermint_frame).w

SlotsLayout_SetPeppermintFrame:
                move.b  (Slot_machine_peppermint_frame).w,$38(a1)
                rts
; End of function Slots_UpdateCellFrames

; ---------------------------------------------------------------------------
; unused
                subq.b  #1,(Ring_spill_anim_counter).w
                bpl.s   SlotsLayout_SetRetainedRingSpillFrames
                move.b  #4,(Ring_spill_anim_counter).w
                addq.b  #1,(Ring_spill_anim_frame).w
                andi.b  #3,(Ring_spill_anim_frame).w

SlotsLayout_SetRetainedRingSpillFrames:
                move.b  (Ring_spill_anim_frame).w,d0
                move.b  d0,$168(a1)
                move.b  d0,$170(a1)
                move.b  d0,$178(a1)
                move.b  d0,$180(a1)
                rts

; =============== S U B R O U T I N E =======================================

; Search the 32 eight-byte records for a zero type. Return its pointer in a2 and signal success through Z
Slots_FindFreeCellAnimRecord:
                lea     (Chunk_table+$7400).l,a2
                move.w  #$20-1,d0

SlotsLayout_ScanFreeTransientRecord:
                tst.b   (a2)
                beq.s   SlotsLayout_TransientSlotSearchReturn
                addq.w  #8,a2
                dbf     d0,SlotsLayout_ScanFreeTransientRecord

SlotsLayout_TransientSlotSearchReturn:
                rts
; End of function Slots_FindFreeCellAnimRecord

; =============== S U B R O U T I N E =======================================

SlotsAdvanceAllTransientCellAnimations:
                lea     (Chunk_table+$7400).l,a0
                move.w  #$20-1,d7

SlotsLayout_DispatchActiveTransient:
                moveq   #0,d0
                move.b  (a0),d0
                beq.s   SlotsLayout_AdvanceTransientScan
                lsl.w   #2,d0
                movea.l SlotsLayout_TransientHandlerPointers-4(pc,d0.w),a1
                jsr     (a1)

SlotsLayout_AdvanceTransientScan:
                addq.w  #8,a0
                dbf     d7,SlotsLayout_DispatchActiveTransient
                rts
; End of function SlotsAdvanceAllTransientCellAnimations

; ---------------------------------------------------------------------------
SlotsLayout_TransientHandlerPointers:
                dc.l    SlotsLayout_TickRingRemoval
                dc.l    SlotsLayout_TickBumperAndRestoreCell
                dc.l    SlotsLayout_TickWallAndRestoreCell
                dc.l    SlotsLayout_TickReverseAndRestoreCell
; ---------------------------------------------------------------------------

SlotsLayout_TickRingRemoval:
                subq.b  #1,2(a0)
                bpl.s   SlotsLayout_RingRemovalReturn
                move.b  #5,2(a0)
                moveq   #0,d0
                move.b  3(a0),d0
                addq.b  #1,3(a0)
                movea.l 4(a0),a1
                move.b  SlotsLayout_RingRemovalCellTypes(pc,d0.w),d0
                move.b  d0,(a1)
                bne.s   SlotsLayout_RingRemovalReturn
                clr.l   (a0)
                clr.l   4(a0)

SlotsLayout_RingRemovalReturn:
                rts
; ---------------------------------------------------------------------------
SlotsLayout_RingRemovalCellTypes:
                dc.b    $10, $11, $12, $13,   0
                even
; ---------------------------------------------------------------------------

SlotsLayout_TickBumperAndRestoreCell:
                subq.b  #1,2(a0)
                bpl.s   SlotsLayout_BumperCellUpdateReturn
                move.b  #1,2(a0)
                moveq   #0,d0
                move.b  3(a0),d0
                addq.b  #1,3(a0)
                movea.l 4(a0),a1
                move.b  SlotsLayout_BumperCellTypes(pc,d0.w),d0
                bne.s   SlotsLayout_WriteBumperCellType
                clr.l   (a0)
                clr.l   4(a0)
                move.b  #5,(a1)
                rts
; ---------------------------------------------------------------------------

SlotsLayout_WriteBumperCellType:
                move.b  d0,(a1)

SlotsLayout_BumperCellUpdateReturn:
                rts
; ---------------------------------------------------------------------------
SlotsLayout_BumperCellTypes:
                dc.b    $A,  $B,   0
                even
; ---------------------------------------------------------------------------

SlotsLayout_TickReverseAndRestoreCell:
                subq.b  #1,2(a0)
                bpl.s   SlotsLayout_ReverseCellUpdateReturn
                move.b  #7,2(a0)
                moveq   #0,d0
                move.b  3(a0),d0
                addq.b  #1,3(a0)
                movea.l 4(a0),a1
                move.b  SlotsLayout_ReverseCellTypes(pc,d0.w),d0
                bne.s   SlotsLayout_WriteReverseCellType
                clr.l   (a0)
                clr.l   4(a0)
                move.b  #6,(a1)
                rts
; ---------------------------------------------------------------------------

SlotsLayout_WriteReverseCellType:
                move.b  d0,(a1)

SlotsLayout_ReverseCellUpdateReturn:
                rts
; ---------------------------------------------------------------------------
SlotsLayout_ReverseCellTypes:
                dc.b    $C,   6,  $C,   0
                even
; ---------------------------------------------------------------------------

; The original cell type is packed into the high byte of the saved cell pointer
SlotsLayout_TickWallAndRestoreCell:
                subq.b  #1,2(a0)
                bpl.s   SlotsLayout_WallCellUpdateReturn
                move.b  #1,2(a0)
                moveq   #0,d0
                move.b  3(a0),d0
                addq.b  #1,3(a0)
                movea.l 4(a0),a1
                move.b  SlotsLayout_WallCycleCellTypes(pc,d0.w),d0
                move.b  d0,(a1)
                bne.s   SlotsLayout_WallCellUpdateReturn
                move.b  4(a0),(a1)
                clr.l   (a0)
                clr.l   4(a0)

SlotsLayout_WallCellUpdateReturn:
                rts
; ---------------------------------------------------------------------------
SlotsLayout_WallCycleCellTypes:
                dc.b    $D
                dc.b    $E
                dc.b    $F
                dc.b    $D
                dc.b    $E
                dc.b    $F
                dc.b    $D
                dc.b    $E
                dc.b    $F
                dc.b    $D
                dc.b    $E
                dc.b    $F
                dc.b    $D
                dc.b    $E
                dc.b    $F
                dc.b    $D
                dc.b    $E
                dc.b    $F
                dc.b    $D
                dc.b    $E
                dc.b    $F
                dc.b    $D
                dc.b    $E
                dc.b    $F
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    $1E
                dc.b    $40
                dc.b    $80
                dc.b    3
                dc.b    $28
                dc.b    2
                dc.b    $F8
                even

; =============== S U B R O U T I N E =======================================

; Prepare the padded 128-by-128 layout, nineteen render descriptors and 32 transient records
Slots_InitLayoutDescriptorsAndCage:
                lea     (RAM_start+$3000).l,a1
                move.w  #bytesToLcnt($4000),d0

SlotsLayout_ClearPadded16KLayout:
                clr.l   (a1)+
                dbf     d0,SlotsLayout_ClearPadded16KLayout
                lea     (RAM_start+$4020).l,a1
                lea     (SlotBonusLayout).l,a0
                move.w  (a0)+,(Player_1+x_pos).w
                move.w  (a0)+,(Player_1+y_pos).w
                moveq   #$20-1,d1

SlotsLayout_Begin32ByteLayoutRow:
                moveq   #$20-1,d2

SlotsLayout_CopyCellsWithPaddedStride:
                move.b  (a0)+,(a1)+
                dbf     d2,SlotsLayout_CopyCellsWithPaddedStride
                lea     $60(a1),a1
                dbf     d1,SlotsLayout_Begin32ByteLayoutRow
                lea     (Chunk_table+$7008).l,a1
                lea     (SlotBonusMaps).l,a0
                moveq   #$13-1,d1

SlotsLayout_Expand19RenderDescriptors:
                move.l  (a0)+,(a1)+
                move.w  #0,(a1)+
                move.b  -4(a0),-1(a1)
                move.w  (a0)+,(a1)+
                dbf     d1,SlotsLayout_Expand19RenderDescriptors
                lea     (Chunk_table+$7400).l,a1
                move.w  #bytesToLcnt($100),d1

SlotsLayout_ClearTransientsAndTryCage:
                clr.l   (a1)+
                dbf     d1,SlotsLayout_ClearTransientsAndTryCage
                jsr     (AllocateObject).l
                bne.w   SlotsLayout_LayoutInitReturn
                move.l  #SlotsPlayer_InitCageAtCenter,(a1)

SlotsLayout_LayoutInitReturn:
                rts
; End of function Slots_InitLayoutDescriptorsAndCage

; ---------------------------------------------------------------------------
SlotBonusMaps:
                dc.l    Map_SB_ColoredWall+(0<<24)
                dc.w    make_art_tile(ArtTile_SlotsBlocks,3,0)
                dc.l    Map_SB_ColoredWall+(0<<24)
                dc.w    make_art_tile(ArtTile_SlotsBlocks,1,0)
                dc.l    Map_SB_ColoredWall+(0<<24)
                dc.w    make_art_tile(ArtTile_SlotsBlocks,2,0)
                dc.l    Map_SB_Goal+(0<<24)
                dc.w    make_art_tile(ArtTile_SlotsBlocks+$14C,0,0)
                dc.l    Map_SB_Bumper+(0<<24)
                dc.w    make_art_tile(ArtTile_SlotsBlocks+$F9,1,0)
                dc.l    Map_SB_R_and_Peppermint+(0<<24)
                dc.w    make_art_tile(ArtTile_SlotsBlocks+$13D,1,0)
                dc.l    Map_SB_R_and_Peppermint+(0<<24)
                dc.w    make_art_tile(ArtTile_SlotsBlocks+$122,2,0)
                dc.l    Map_SB_Ring+(0<<24)
                dc.w    make_art_tile(ArtTile_Ring,1,0)
                dc.l    Map_SB_Slot+(0<<24)
                dc.w    make_art_tile(ArtTile_SlotsBlocks+$146,0,0)
                dc.l    Map_SB_Bumper+(1<<24)
                dc.w    make_art_tile(ArtTile_SlotsBlocks+$F9,1,0)
                dc.l    Map_SB_Bumper+(2<<24)
                dc.w    make_art_tile(ArtTile_SlotsBlocks+$F9,2,0)
                dc.l    Map_SB_R_and_Peppermint+(0<<24)
                dc.w    make_art_tile(ArtTile_SlotsBlocks+$13D,2,0)
                dc.l    Map_SB_ColoredWall+(0<<24)
                dc.w    make_art_tile(ArtTile_SlotsBlocks,3,0)
                dc.l    Map_SB_ColoredWall+(0<<24)
                dc.w    make_art_tile(ArtTile_SlotsBlocks,1,0)
                dc.l    Map_SB_ColoredWall+(0<<24)
                dc.w    make_art_tile(ArtTile_SlotsBlocks,2,0)
                dc.l    Map_SB_Ring+(4<<24)
                dc.w    make_art_tile(ArtTile_Ring,1,0)
                dc.l    Map_SB_Ring+(5<<24)
                dc.w    make_art_tile(ArtTile_Ring,1,0)
                dc.l    Map_SB_Ring+(6<<24)
                dc.w    make_art_tile(ArtTile_Ring,1,0)
                dc.l    Map_SB_Ring+(7<<24)
                dc.w    make_art_tile(ArtTile_Ring,1,0)
Map_SB_Slot:
                include "src/objects/shared/zones/slots/mappings/slot.s"
Map_SB_R_and_Peppermint:
                include "src/objects/shared/zones/slots/mappings/r_peppermint.s"
Map_SB_Goal:
                include "src/objects/shared/zones/slots/mappings/goal.s"
Map_SB_Bumper:
                include "src/objects/shared/zones/slots/mappings/bumper.s"
Map_SB_Ring:
                include "src/objects/shared/zones/slots/mappings/ring.s"
Map_SB_ColoredWall:
                include "src/objects/shared/zones/slots/mappings/colored_wall.s"
