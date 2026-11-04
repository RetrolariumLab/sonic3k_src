; Owner: objects/zones/lrz/sk
; Responsibility: Lava Reef solid platform subtype geometry, movement, player riding and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
SKLRZMovingSolid_ShapeAttributes:
                dc.b    $20, $20, 0
                even
                dc.b    $20, $20, 1
                even
; ---------------------------------------------------------------------------

Obj_LRZSolidMovingPlatforms:
                move.l  #Map_LRZSolidMovingPlatforms,mappings(a0)
                move.w  #make_art_tile($090,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$180,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #2,d0
                andi.w  #$1C,d0
                lea     SKLRZMovingSolid_ShapeAttributes(pc,d0.w),a2
                move.b  (a2)+,width_pixels(a0)
                move.b  (a2)+,height_pixels(a0)
                move.b  (a2)+,mapping_frame(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$34(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                add.w   d0,d0
                move.w  SKLRZMovingSolid_MotionOffsets(pc,d0.w),d0
                lea     SKLRZMovingSolid_MotionOffsets(pc,d0.w),a1
                move.l  a1,$42(a0)
                move.l  #SKLRZMovingSolid_MoveAndCheckSolid,(a0)

SKLRZMovingSolid_MoveAndCheckSolid:
                move.w  x_pos(a0),-(sp)
                movea.l $42(a0),a1
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
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
SKLRZMovingSolid_MotionOffsets:
                dc.w    SKLRZMovingSolid_Stationary-SKLRZMovingSolid_MotionOffsets
                dc.w    SKLRZMovingSolid_OscillateX64-SKLRZMovingSolid_MotionOffsets
                dc.w    SKLRZMovingSolid_OscillateX128-SKLRZMovingSolid_MotionOffsets
                dc.w    SKLRZMovingSolid_AccelOscillateX96-SKLRZMovingSolid_MotionOffsets
                dc.w    SKLRZMovingSolid_OscillateY64-SKLRZMovingSolid_MotionOffsets
                dc.w    SKLRZMovingSolid_OscillateY128-SKLRZMovingSolid_MotionOffsets
                dc.w    SKLRZMovingSolid_AccelOscillateY96-SKLRZMovingSolid_MotionOffsets
                dc.w    SKLRZMovingSolid_AccelOscillateX128-SKLRZMovingSolid_MotionOffsets
                dc.w    SKLRZMovingSolid_AccelOscillateY128-SKLRZMovingSolid_MotionOffsets
; ---------------------------------------------------------------------------

SKLRZMovingSolid_Stationary:
                rts
; ---------------------------------------------------------------------------

SKLRZMovingSolid_OscillateX64:
                moveq   #0,d0
                move.b  (Oscillating_table+$0A).w,d0
                subi.w  #$20,d0
                bra.s   SKLRZMovingSolid_TryMirrorOffsetX
; ---------------------------------------------------------------------------

SKLRZMovingSolid_OscillateX128:
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                subi.w  #$40,d0

SKLRZMovingSolid_TryMirrorOffsetX:
                btst    #0,status(a0)
                beq.s   SKLRZMovingSolid_ApplyOffsetX
                neg.w   d0

SKLRZMovingSolid_ApplyOffsetX:
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKLRZMovingSolid_OscillateY64:
                moveq   #0,d0
                move.b  (Oscillating_table+$0A).w,d0
                subi.w  #$20,d0
                bra.s   SKLRZMovingSolid_TryMirrorOffsetY
; ---------------------------------------------------------------------------

SKLRZMovingSolid_OscillateY128:
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                subi.w  #$40,d0

SKLRZMovingSolid_TryMirrorOffsetY:
                btst    #0,status(a0)
                beq.s   SKLRZMovingSolid_ApplyOffsetY
                neg.w   d0

SKLRZMovingSolid_ApplyOffsetY:
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKLRZMovingSolid_AccelOscillateX96:
                move.w  #$5F,d2
                bsr.s   AdvanceLrzPlatformAcceleratedOffset
                subi.w  #$60,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKLRZMovingSolid_AccelOscillateY96:
                move.w  #$5F,d2
                bsr.s   AdvanceLrzPlatformAcceleratedOffset
                subi.w  #$60,d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKLRZMovingSolid_AccelOscillateX128:
                move.w  #$7F,d2
                bsr.s   AdvanceLrzPlatformAcceleratedOffset
                subi.w  #$80,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKLRZMovingSolid_AccelOscillateY128:
                move.w  #$7F,d2
                bsr.s   AdvanceLrzPlatformAcceleratedOffset
                subi.w  #$80,d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                rts

; =============== S U B R O U T I N E =======================================

AdvanceLrzPlatformAcceleratedOffset:
                tst.b   $3C(a0)
                bne.s   SKLRZMovingSolid_DecelAndCheckTurn
                move.w  $40(a0),d1
                addq.w  #4,d1
                move.w  d1,$40(a0)
                add.w   d1,$36(a0)
                cmp.b   $36(a0),d2
                bhi.s   SKLRZMovingSolid_GetMirroredOffset
                move.b  #1,$3C(a0)
                bra.s   SKLRZMovingSolid_GetMirroredOffset
; ---------------------------------------------------------------------------

SKLRZMovingSolid_DecelAndCheckTurn:
                move.w  $40(a0),d1
                subq.w  #4,d1
                move.w  d1,$40(a0)
                add.w   d1,$36(a0)
                cmp.b   $36(a0),d2
                bls.s   SKLRZMovingSolid_GetMirroredOffset
                move.b  #0,$3C(a0)

SKLRZMovingSolid_GetMirroredOffset:
                moveq   #0,d0
                move.b  $36(a0),d0
                btst    #0,status(a0)
                beq.s   SKLRZMovingSolid_OffsetReturn
                neg.w   d0
                add.w   d2,d0

SKLRZMovingSolid_OffsetReturn:
                rts
; End of function AdvanceLrzPlatformAcceleratedOffset

; ---------------------------------------------------------------------------
Map_LRZSolidMovingPlatforms:
                include "src/objects/shared/zones/lrz/mappings/solid_moving_platforms.s"
; ---------------------------------------------------------------------------
; unused
                dc.b    $20, $10,   0
                even
