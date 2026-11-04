; Owner: objects/zones/lbz/sk
; Responsibility: Launch Base flamethrower timing, flame creation and automatic spin control with animation resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_LBZFlameThrower:
                movea.l a0,a1
                bsr.s   InitializeLbzFlamethrowerVisuals
                move.l  #SKLBZFlame_TryEmitStaticFlame,(a0)

SKLBZFlame_TryEmitStaticFlame:
                move.b  (V_int_run_count+3).w,d0
                add.b   subtype(a0),d0
                andi.b  #$7F,d0
                bne.s   SKLBZFlame_ResolveEmitterAndDraw
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKLBZFlame_ResolveEmitterAndDraw
                move.l  #Obj_AutoSpin460,(a1)
                bsr.s   InitializeLbzFlamethrowerVisuals
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  status(a0),status(a1)
                move.b  #$9D,collision_flags(a1)
                bset    #4,shield_reaction(a1)
                addi.w  #$40,x_pos(a1)
                btst    #0,status(a0)
                beq.s   SKLBZFlame_TryPlayFireSound
                subi.w  #2*$40,x_pos(a1)

SKLBZFlame_TryPlayFireSound:
                tst.b   render_flags(a0)
                bpl.s   SKLBZFlame_ResolveEmitterAndDraw
                moveq   #signextendB(sfx_FireAttack),d0
                jsr     (Play_SFX).l

SKLBZFlame_ResolveEmitterAndDraw:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

Obj_AutoSpin460:
                lea     (Ani_LBZFlameThrower).l,a1
                jsr     (Animate_Sprite).l
                tst.b   routine(a0)
                beq.s   SKLBZFlame_DrawFlameAndCheckTouch
                move.w  #$7FFF,x_pos(a0)

SKLBZFlame_DrawFlameAndCheckTouch:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------
Ani_LBZFlameThrower:
                include "src/objects/shared/zones/lbz/animations/flame_thrower.s"
; End of function Obj_LBZFlameThrower
