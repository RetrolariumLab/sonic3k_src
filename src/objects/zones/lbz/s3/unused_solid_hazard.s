; Owner: objects/zones/lbz/s3
; Responsibility: Unused Launch Base moving solid hazard collision, damage, animation and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZUnusedSolidHurt:
                move.l  #Map_LBZUnusedSolidHurt,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.w  y_pos(a0),$30(a0)
                move.l  #S3LBZUnusedHazard_UpdateKickedHazard,(a0)

S3LBZUnusedHazard_UpdateKickedHazard:
                tst.b   $2E(a0)
                beq.s   S3LBZUnusedHazard_TryKickFromP1Solid
                move.w  y_vel(a0),d0
                addi.w  #8,y_vel(a0)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a0)
                move.w  $30(a0),d0
                addq.w  #2,d0
                cmp.w   y_pos(a0),d0
                bcc.s   S3LBZUnusedHazard_TryKickFromP1Solid
                move.w  $30(a0),y_pos(a0)
                clr.w   $16(a0)
                clr.w   y_vel(a0)
                clr.b   $2E(a0)

S3LBZUnusedHazard_TryKickFromP1Solid:
                move.w  #$1B,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                jsr     (SolidObjectFull2_1P).l
                cmpi.w  #-2,d4
                bne.s   S3LBZUnusedHazard_TryKickFromP2Solid
                bsr.s   KickLbzUnusedSolidHazardUpward

S3LBZUnusedHazard_TryKickFromP2Solid:
                movem.l (sp)+,d1-d4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                jsr     (SolidObjectFull2_1P).l
                cmpi.w  #-2,d4
                bne.s   S3LBZUnusedHazard_TryHurtStandingP1
                bsr.s   KickLbzUnusedSolidHazardUpward

S3LBZUnusedHazard_TryHurtStandingP1:
                move.b  status(a0),d6
                andi.b  #standing_mask,d6
                beq.s   S3LBZUnusedHazard_AnimateAndDraw
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   S3LBZUnusedHazard_TryHurtStandingP2
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard

; Read P2's bit from the live d6 after any P1 damage call
S3LBZUnusedHazard_TryHurtStandingP2:
                andi.b  #p2_standing,d6
                beq.s   S3LBZUnusedHazard_AnimateAndDraw
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3LBZUnusedHazard_AnimateAndDraw:
                lea     (Ani_LBZUnusedSolidHurt).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

KickLbzUnusedSolidHazardUpward:
                move.w  #-$40,y_vel(a0)
                move.b  #1,$2E(a0)
                rts
; End of function KickLbzUnusedSolidHazardUpward

; ---------------------------------------------------------------------------
Ani_LBZUnusedSolidHurt:
                include "src/objects/shared/zones/lbz/animations/unused_solid_hurt.s"
Map_LBZUnusedSolidHurt:
                include "src/objects/shared/zones/lbz/mappings/unused_solid_hurt.s"
