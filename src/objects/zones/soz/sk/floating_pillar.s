; Owner: objects/zones/soz/sk
; Responsibility: Floating pillar motion, player riding and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
SKSOZFloatPillar_ShapeAttributes:
                dc.b    $20, $40,   0,   0
                dc.b    $20, $50,   1, $30
                dc.b    $20, $50,   2,  $C
                even
; ---------------------------------------------------------------------------

Obj_SOZFloatingPillar:
                move.l  #Map_SOZFloatingPillar,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #2,d0
                andi.w  #$1C,d0
                lea     SKSOZFloatPillar_ShapeAttributes(pc,d0.w),a2
                move.b  (a2)+,width_pixels(a0)
                move.b  (a2)+,height_pixels(a0)
                move.b  (a2)+,mapping_frame(a0)
                move.b  (a2)+,$34(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                add.w   d0,d0
                move.w  SKSOZFloatPillar_MotionOffsets(pc,d0.w),d0
                lea     SKSOZFloatPillar_MotionOffsets(pc,d0.w),a1
                move.l  a1,$30(a0)
                move.l  #SKSOZFloatPillar_MoveAndCheckSolid,(a0)

SKSOZFloatPillar_MoveAndCheckSolid:
                move.w  x_pos(a0),-(sp)
                movea.l $30(a0),a1
                jsr     (a1)
                move.w  (sp)+,d4
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                jsr     (SolidObjectFull).l
                swap    d6
                and.b   $34(a0),d6
                bne.s   SKSOZFloatPillar_CheckTopSpikes

SKSOZFloatPillar_CullAtOriginAndDraw:
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
SKSOZFloatPillar_MotionOffsets:
                dc.w    SKSOZFloatPillar_Stationary-SKSOZFloatPillar_MotionOffsets
                dc.w    SKSOZFloatPillar_OscillateX32-SKSOZFloatPillar_MotionOffsets
                dc.w    SKSOZFloatPillar_OscillateX64-SKSOZFloatPillar_MotionOffsets
                dc.w    SKSOZFloatPillar_OscillateX128-SKSOZFloatPillar_MotionOffsets
                dc.w    SKSOZFloatPillar_OscillateY32-SKSOZFloatPillar_MotionOffsets
                dc.w    SKSOZFloatPillar_OscillateY64-SKSOZFloatPillar_MotionOffsets
                dc.w    SKSOZFloatPillar_OscillateY128-SKSOZFloatPillar_MotionOffsets
; ---------------------------------------------------------------------------

SKSOZFloatPillar_CheckTopSpikes:
                cmpi.b  #1,mapping_frame(a0)
                bne.s   SKSOZFloatPillar_CheckP1UnderContact
                move.b  d6,d0
                andi.b  #$10,d0
                beq.s   SKSOZFloatPillar_CheckP2TopContact
                lea     (Player_1).w,a1
                jsr     (HurtPlayerFromSolidHazard).l

SKSOZFloatPillar_CheckP2TopContact:
                andi.b  #$20,d6
                beq.s   SKSOZFloatPillar_DrawAfterTopContact
                lea     (Player_2).w,a1
                jsr     (HurtPlayerFromSolidHazard).l

SKSOZFloatPillar_DrawAfterTopContact:
                bra.s   SKSOZFloatPillar_CullAtOriginAndDraw
; ---------------------------------------------------------------------------

SKSOZFloatPillar_CheckP1UnderContact:
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   SKSOZFloatPillar_CheckP2UnderContact
                lea     (Player_1).w,a1
                jsr     (HurtPlayerFromSolidHazard).l

SKSOZFloatPillar_CheckP2UnderContact:
                andi.b  #8,d6
                beq.s   SKSOZFloatPillar_DrawAfterUnderContact
                lea     (Player_2).w,a1
                jsr     (HurtPlayerFromSolidHazard).l

SKSOZFloatPillar_DrawAfterUnderContact:
                bra.s   SKSOZFloatPillar_CullAtOriginAndDraw
; ---------------------------------------------------------------------------

SKSOZFloatPillar_Stationary:
                rts
; ---------------------------------------------------------------------------

SKSOZFloatPillar_OscillateX32:
                moveq   #0,d0
                move.b  (Oscillating_table+$0A).w,d0
                subi.w  #$20,d0
                bra.s   SKSOZFloatPillar_MirrorOffsetX
; ---------------------------------------------------------------------------

SKSOZFloatPillar_OscillateX64:
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                subi.w  #$40,d0
                bra.s   SKSOZFloatPillar_MirrorOffsetX
; ---------------------------------------------------------------------------

SKSOZFloatPillar_OscillateX128:
                moveq   #0,d0
                move.b  (Oscillating_table+$3A).w,d0
                add.w   d0,d0
                subi.w  #$80,d0

SKSOZFloatPillar_MirrorOffsetX:
                btst    #0,status(a0)
                beq.s   SKSOZFloatPillar_ApplyOffsetX
                neg.w   d0

SKSOZFloatPillar_ApplyOffsetX:
                add.w   $44(a0),d0
                move.w  d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKSOZFloatPillar_OscillateY32:
                moveq   #0,d0
                move.b  (Oscillating_table+$0A).w,d0
                subi.w  #$20,d0
                bra.s   SKSOZFloatPillar_MirrorOffsetY
; ---------------------------------------------------------------------------

SKSOZFloatPillar_OscillateY64:
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                subi.w  #$40,d0
                bra.s   SKSOZFloatPillar_MirrorOffsetY
; ---------------------------------------------------------------------------

SKSOZFloatPillar_OscillateY128:
                moveq   #0,d0
                move.b  (Oscillating_table+$3A).w,d0
                add.w   d0,d0
                subi.w  #$80,d0

SKSOZFloatPillar_MirrorOffsetY:
                btst    #0,status(a0)
                beq.s   SKSOZFloatPillar_ApplyOffsetY
                neg.w   d0

SKSOZFloatPillar_ApplyOffsetY:
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
Map_SOZFloatingPillar:
                include "src/objects/shared/zones/soz/mappings/floating_pillar.s"
