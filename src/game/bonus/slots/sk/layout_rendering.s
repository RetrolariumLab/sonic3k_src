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

loc_4B3A6:
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

loc_4B3C8:
                move.l  d2,d0
                asr.l   #8,d0
                move.w  d0,(a1)+
                move.l  d1,d0
                asr.l   #8,d0
                move.w  d0,(a1)+
                add.l   d5,d2
                add.l   d4,d1
                dbf     d6,loc_4B3C8
                movem.w (sp)+,d0-d2
                addi.w  #$18,d3
                dbf     d7,loc_4B3A6
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

loc_4B424:
                move.w  #$10-1,d6

loc_4B428:
                moveq   #0,d0
                move.b  (a0)+,d0
                beq.s   loc_4B47C
                cmpi.b  #$13,d0
                bhi.s   loc_4B47C
                move.w  (a4),d3
                addi.w  #$120,d3
                cmpi.w  #$70,d3
                blo.s   loc_4B47C
                cmpi.w  #$1D0,d3
                bhs.s   loc_4B47C
                move.w  2(a4),d2
                addi.w  #$F0,d2
                cmpi.w  #$70,d2
                blo.s   loc_4B47C
                cmpi.w  #$170,d2
                bhs.s   loc_4B47C
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
                bmi.s   loc_4B47C
                bsr.s   Slots_AppendPiecesToSpriteTable

loc_4B47C:
                addq.w  #4,a4
                dbf     d6,loc_4B428
                lea     $70(a0),a0
                dbf     d7,loc_4B424
                move.b  d5,(Sprites_drawn).w
                rts
; End of function Slots_RenderLayout

; =============== S U B R O U T I N E =======================================

; Translate five-byte mapping pieces into hardware entries and stop at 80 sprites
Slots_AppendPiecesToSpriteTable:
                cmpi.b  #$50,d5
                beq.s   locret_4B4C2
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
                bne.s   loc_4B4BC
                addq.w  #1,d0

loc_4B4BC:
                move.w  d0,(a2)+
                dbf     d1,Slots_AppendPiecesToSpriteTable

locret_4B4C2:
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

loc_4B4D8:
                move.w  d0,(a1)
                addq.w  #8,a1
                dbf     d1,loc_4B4D8
                lea     (Chunk_table+$706C).l,a1
                moveq   #3-1,d1

loc_4B4E8:
                move.w  d0,(a1)
                addq.w  #8,a1
                dbf     d1,loc_4B4E8
                lea     (Chunk_table+$7005).l,a1
                subq.b  #1,(Slot_machine_goal_frame_timer).w
                bpl.s   loc_4B526
                move.b  #1,(Slot_machine_goal_frame_timer).w
                addq.b  #1,$20(a1)
                cmpi.b  #3,$20(a1)
                blo.s   loc_4B514
                move.b  #0,$20(a1)

loc_4B514:
                addq.b  #1,(Slot_machine_goal_frame).w
                cmpi.b  #6,(Slot_machine_goal_frame).w
                blo.s   loc_4B526
                move.b  #0,(Slot_machine_goal_frame).w

loc_4B526:
                move.b  (Slot_machine_goal_frame).w,$48(a1)
                move.b  (Rings_frame).w,$40(a1)
                subq.b  #1,(Slot_machine_peppermint_frame_timer).w
                bpl.s   loc_4B548
                move.b  #3,(Slot_machine_peppermint_frame_timer).w
                addq.b  #1,(Slot_machine_peppermint_frame).w
                andi.b  #3,(Slot_machine_peppermint_frame).w

loc_4B548:
                move.b  (Slot_machine_peppermint_frame).w,$38(a1)
                rts
; End of function Slots_UpdateCellFrames

; ---------------------------------------------------------------------------
; unused
                subq.b  #1,(Ring_spill_anim_counter).w
                bpl.s   loc_4B566
                move.b  #4,(Ring_spill_anim_counter).w
                addq.b  #1,(Ring_spill_anim_frame).w
                andi.b  #3,(Ring_spill_anim_frame).w

loc_4B566:
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

loc_4B586:
                tst.b   (a2)
                beq.s   locret_4B590
                addq.w  #8,a2
                dbf     d0,loc_4B586

locret_4B590:
                rts
; End of function Slots_FindFreeCellAnimRecord

; =============== S U B R O U T I N E =======================================

SlotsAdvanceAllTransientCellAnimations:
                lea     (Chunk_table+$7400).l,a0
                move.w  #$20-1,d7

loc_4B59C:
                moveq   #0,d0
                move.b  (a0),d0
                beq.s   loc_4B5AA
                lsl.w   #2,d0
                movea.l off_4B5B2-4(pc,d0.w),a1
                jsr     (a1)

loc_4B5AA:
                addq.w  #8,a0
                dbf     d7,loc_4B59C
                rts
; End of function SlotsAdvanceAllTransientCellAnimations

; ---------------------------------------------------------------------------
off_4B5B2:
                dc.l    loc_4B5C2
                dc.l    loc_4B5F2
                dc.l    loc_4B65A
                dc.l    loc_4B626
; ---------------------------------------------------------------------------

loc_4B5C2:
                subq.b  #1,2(a0)
                bpl.s   locret_4B5EA
                move.b  #5,2(a0)
                moveq   #0,d0
                move.b  3(a0),d0
                addq.b  #1,3(a0)
                movea.l 4(a0),a1
                move.b  byte_4B5EC(pc,d0.w),d0
                move.b  d0,(a1)
                bne.s   locret_4B5EA
                clr.l   (a0)
                clr.l   4(a0)

locret_4B5EA:
                rts
; ---------------------------------------------------------------------------
byte_4B5EC:
                dc.b    $10, $11, $12, $13,   0
                even
; ---------------------------------------------------------------------------

loc_4B5F2:
                subq.b  #1,2(a0)
                bpl.s   locret_4B620
                move.b  #1,2(a0)
                moveq   #0,d0
                move.b  3(a0),d0
                addq.b  #1,3(a0)
                movea.l 4(a0),a1
                move.b  byte_4B622(pc,d0.w),d0
                bne.s   loc_4B61E
                clr.l   (a0)
                clr.l   4(a0)
                move.b  #5,(a1)
                rts
; ---------------------------------------------------------------------------

loc_4B61E:
                move.b  d0,(a1)

locret_4B620:
                rts
; ---------------------------------------------------------------------------
byte_4B622:
                dc.b    $A,  $B,   0
                even
; ---------------------------------------------------------------------------

loc_4B626:
                subq.b  #1,2(a0)
                bpl.s   locret_4B654
                move.b  #7,2(a0)
                moveq   #0,d0
                move.b  3(a0),d0
                addq.b  #1,3(a0)
                movea.l 4(a0),a1
                move.b  byte_4B656(pc,d0.w),d0
                bne.s   loc_4B652
                clr.l   (a0)
                clr.l   4(a0)
                move.b  #6,(a1)
                rts
; ---------------------------------------------------------------------------

loc_4B652:
                move.b  d0,(a1)

locret_4B654:
                rts
; ---------------------------------------------------------------------------
byte_4B656:
                dc.b    $C,   6,  $C,   0
                even
; ---------------------------------------------------------------------------

loc_4B65A:
                subq.b  #1,2(a0)
                bpl.s   locret_4B686
                move.b  #1,2(a0)
                moveq   #0,d0
                move.b  3(a0),d0
                addq.b  #1,3(a0)
                movea.l 4(a0),a1
                move.b  byte_4B688(pc,d0.w),d0
                move.b  d0,(a1)
                bne.s   locret_4B686
                move.b  4(a0),(a1)
                clr.l   (a0)
                clr.l   4(a0)

locret_4B686:
                rts
; ---------------------------------------------------------------------------
byte_4B688:
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

loc_4B6B4:
                clr.l   (a1)+
                dbf     d0,loc_4B6B4
                lea     (RAM_start+$4020).l,a1
                lea     (SlotBonusLayout).l,a0
                move.w  (a0)+,(Player_1+x_pos).w
                move.w  (a0)+,(Player_1+y_pos).w
                moveq   #$20-1,d1

loc_4B6D0:
                moveq   #$20-1,d2

loc_4B6D2:
                move.b  (a0)+,(a1)+
                dbf     d2,loc_4B6D2
                lea     $60(a1),a1
                dbf     d1,loc_4B6D0
                lea     (Chunk_table+$7008).l,a1
                lea     (SlotBonusMaps).l,a0
                moveq   #$13-1,d1

loc_4B6EE:
                move.l  (a0)+,(a1)+
                move.w  #0,(a1)+
                move.b  -4(a0),-1(a1)
                move.w  (a0)+,(a1)+
                dbf     d1,loc_4B6EE
                lea     (Chunk_table+$7400).l,a1
                move.w  #bytesToLcnt($100),d1

loc_4B70A:
                clr.l   (a1)+
                dbf     d1,loc_4B70A
                jsr     (AllocateObject).l
                bne.w   locret_4B720
                move.l  #loc_4BF62,(a1)

locret_4B720:
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
