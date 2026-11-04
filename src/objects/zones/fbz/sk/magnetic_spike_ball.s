; Owner: objects/zones/fbz/sk
; Responsibility: Magnetic spike-ball activation, motion and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZMagneticSpikeBall:
                move.l  #Map_FBZMagneticSpikeBall,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$CA,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                tst.b   subtype(a0)
                beq.s   SKFBZMagSpike_InitFallingBall
                bmi.s   SKFBZMagSpike_ChooseMagnetVisual
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$9A,collision_flags(a0)
                move.l  #Sprite_CheckDeleteTouch3,(a0)
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

SKFBZMagSpike_ChooseMagnetVisual:
                btst    #0,subtype(a0)
                bne.s   SKFBZMagSpike_InitCompactMagnet
                ori.w   #high_priority,art_tile(a0)
                move.b  #$30,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.l  #SKFBZMagSpike_AnimateLargeMagnet,(a0)
                bra.w   SKFBZMagSpike_AnimateLargeMagnet
; ---------------------------------------------------------------------------

SKFBZMagSpike_InitCompactMagnet:
                move.w  #make_art_tile(ArtTile_FBZMisc+$C9,1,1),art_tile(a0)
                move.b  #$24,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.b  #4,mapping_frame(a0)
                move.w  #$200,priority(a0)
                move.l  #SKFBZMagSpike_AnimateCompactMagnet,(a0)
                bra.w   SKFBZMagSpike_AnimateCompactMagnet
; ---------------------------------------------------------------------------

SKFBZMagSpike_InitFallingBall:
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$A,y_radius(a0)
                move.b  #$9A,collision_flags(a0)
                move.l  #SKFBZMagSpike_FallAndCheckFloor,(a0)

SKFBZMagSpike_FallAndCheckFloor:
                jsr     (MoveSprite2).l
                addi.w  #$58,y_vel(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKFBZMagSpike_TrySwitchToRising
                add.w   d1,y_pos(a0)
                move.w  #0,y_vel(a0)
                move.l  #SKFBZMagSpike_TrySwitchToRising,(a0)

SKFBZMagSpike_TrySwitchToRising:
                tst.b   (_unkF7C1).w
                beq.s   SKFBZMagSpike_DrawFallingBall
                move.l  #SKFBZMagSpike_RiseAndCheckCeiling,(a0)

SKFBZMagSpike_DrawFallingBall:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

SKFBZMagSpike_RiseAndCheckCeiling:
                jsr     (MoveSprite2).l
                subi.w  #$18,y_vel(a0)
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   SKFBZMagSpike_TrySwitchToFalling
                sub.w   d1,y_pos(a0)
                move.w  #0,y_vel(a0)
                move.l  #SKFBZMagSpike_TrySwitchToFalling,(a0)

SKFBZMagSpike_TrySwitchToFalling:
                tst.b   (_unkF7C1).w
                bne.s   SKFBZMagSpike_DrawRisingBall
                move.l  #SKFBZMagSpike_FallAndCheckFloor,(a0)

SKFBZMagSpike_DrawRisingBall:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

SKFBZMagSpike_AnimateLargeMagnet:
                tst.b   (_unkF7C1).w
                beq.s   SKFBZMagSpike_CullHiddenLargeMagnet
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #5,mapping_frame(a0)
                blo.s   SKFBZMagSpike_TryPlayMagnetSound
                move.b  #1,mapping_frame(a0)

SKFBZMagSpike_TryPlayMagnetSound:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   SKFBZMagSpike_DrawLargeMagnet
                tst.b   render_flags(a0)
                bpl.s   SKFBZMagSpike_DrawLargeMagnet
                moveq   #signextendB(sfx_MagneticSpike),d0
                jsr     (Play_SFX).l

SKFBZMagSpike_DrawLargeMagnet:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKFBZMagSpike_CullHiddenLargeMagnet:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKFBZMagSpike_AnimateCompactMagnet:
                tst.b   (_unkF7C1).w
                beq.s   SKFBZMagSpike_CullHiddenCompactMagnet
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #7,mapping_frame(a0)
                blo.s   SKFBZMagSpike_DrawCompactMagnet
                move.b  #5,mapping_frame(a0)

SKFBZMagSpike_DrawCompactMagnet:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKFBZMagSpike_CullHiddenCompactMagnet:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------
Map_FBZMagneticSpikeBall:
                include "src/objects/shared/zones/fbz/mappings/magnetic_spike_ball.s"
; End of function Obj_FBZMagneticSpikeBall
