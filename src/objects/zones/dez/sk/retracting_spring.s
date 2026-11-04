; Owner: objects/zones/dez/sk
; Responsibility: Retracting spring timing, extension and player launch response
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
SKDEZRetractSpring_LaunchSpeeds:
                dc.w    -$1000
                dc.w    -$A00
; ---------------------------------------------------------------------------

Obj_DEZRetractingSpring:
                move.l  #Map_DEZRetractingSpring,mappings(a0)
                move.w  #make_art_tile(ArtTile_DEZ2Extra,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  #$20,$32(a0)
                move.b  subtype(a0),d0
                andi.w  #2,d0
                move.w  SKDEZRetractSpring_LaunchSpeeds(pc,d0.w),$30(a0)
                move.l  #SKDEZRetractSpring_CheckP1Height,(a0)

SKDEZRetractSpring_CheckP1Height:
                move.w  (Player_1+y_pos).w,d0
                sub.w   y_pos(a0),d0
                bcs.s   SKDEZRetractSpring_TryRetractAboveBand
                cmpi.w  #$20,d0
                blt.s   SKDEZRetractSpring_SelectFacingOffset
                move.w  $32(a0),d1
                cmp.w   $34(a0),d1
                beq.s   SKDEZRetractSpring_SelectFacingOffset
                tst.w   $34(a0)
                bne.s   SKDEZRetractSpring_ExtendSpring
                moveq   #signextendB(sfx_SpringLatch),d0
                jsr     (Play_SFX).l

SKDEZRetractSpring_ExtendSpring:
                addq.w  #8,$34(a0)
                bra.s   SKDEZRetractSpring_SelectFacingOffset
; ---------------------------------------------------------------------------

SKDEZRetractSpring_TryRetractAboveBand:
                cmpi.w  #-$20,d0
                bge.s   SKDEZRetractSpring_SelectFacingOffset
                tst.w   $34(a0)
                beq.s   SKDEZRetractSpring_SelectFacingOffset
                move.w  $32(a0),d1
                cmp.w   $34(a0),d1
                bne.s   SKDEZRetractSpring_RetractSpring
                moveq   #signextendB(sfx_SpringLatch),d0
                jsr     (Play_SFX).l

SKDEZRetractSpring_RetractSpring:
                subq.w  #8,$34(a0)

SKDEZRetractSpring_SelectFacingOffset:
                move.w  $34(a0),d0
                btst    #0,status(a0)
                bne.s   SKDEZRetractSpring_TryReflectXOffset
                neg.w   d0

SKDEZRetractSpring_TryReflectXOffset:
                btst    #1,status(a0)
                beq.s   SKDEZRetractSpring_PlaceAndCheckP1
                neg.w   d0

SKDEZRetractSpring_PlaceAndCheckP1:
                add.w   $44(a0),d0
                move.w  d0,x_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #9,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                jsr     (SolidObjectTop_1P).l
                btst    #p1_standing_bit,status(a0)
                beq.s   SKDEZRetractSpring_RestoreShapeCheckP2
                jsr     (LaunchPlayerFromUpSpring).l

SKDEZRetractSpring_RestoreShapeCheckP2:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                jsr     (SolidObjectTop_1P).l
                btst    #p2_standing_bit,status(a0)
                beq.s   SKDEZRetractSpring_AnimateAndCull
                jsr     (LaunchPlayerFromUpSpring).l

SKDEZRetractSpring_AnimateAndCull:
                lea     (Ani_DEZRetractingSpring).l,a1
                jsr     (Animate_Sprite).l
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
Ani_DEZRetractingSpring:
                include "src/objects/shared/zones/dez/animations/retracting_spring.s"
Map_DEZRetractingSpring:
                include "src/objects/shared/zones/dez/mappings/retracting_spring.s"
; End of function Obj_DEZRetractingSpring
