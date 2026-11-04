; Owner: objects/zones/mhz/sk
; Responsibility: Mushroom platform state, player collision and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZMushroomPlatform:
                move.l  #Map_MHZMushroomPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_MHZMisc+$86,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #SKMHZMushPlat_TickFallDelay,(a0)

SKMHZMushPlat_TickFallDelay:
                tst.b   $2E(a0)
                beq.s   SKMHZMushPlat_ResolveSolidAndTryArmFall
                tst.b   $2F(a0)
                beq.s   SKMHZMushPlat_FallAndCheckRiderRelease
                subq.b  #1,$2F(a0)
                bra.s   SKMHZMushPlat_ResolveSolidAndTryArmFall
; ---------------------------------------------------------------------------

SKMHZMushPlat_FallAndCheckRiderRelease:
                jsr     (MoveSprite2).l
                addi.w  #$28,y_vel(a0)
                jsr     (CheckPlayerReleaseFromObj).l
                tst.b   render_flags(a0)
                bmi.s   SKMHZMushPlat_ResolveSolidAndTryArmFall
                move.w  #$7F00,x_pos(a0)

SKMHZMushPlat_ResolveSolidAndTryArmFall:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                lea     (SKMHZMushPlat_SurfaceHeights).l,a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   SKMHZMushPlat_AnimateAndDraw
                move.b  #1,anim(a0)
                tst.b   subtype(a0)
                beq.s   SKMHZMushPlat_AnimateAndDraw
                tst.b   $2E(a0)
                bne.s   SKMHZMushPlat_AnimateAndDraw
                move.b  #1,$2E(a0)
                move.b  #$10,$2F(a0)

SKMHZMushPlat_AnimateAndDraw:
                lea     (Ani_MHZMushroomPlatform).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Ani_MHZMushroomPlatform:
                include "src/objects/shared/zones/mhz/animations/mushroom_platform.s"
SKMHZMushPlat_SurfaceHeights:
                dc.b    $C,  $D,  $E,  $F, $10, $11, $12, $13, $13, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14
                dc.b    $14, $14, $14, $13, $13, $12, $11, $10,  $F,  $E,  $D,  $C
                even
Map_MHZMushroomPlatform:
                include "src/objects/shared/zones/mhz/mappings/mushroom_platform.s"
; End of function Obj_MHZMushroomPlatform
