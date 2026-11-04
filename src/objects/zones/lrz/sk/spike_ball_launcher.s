; Owner: objects/zones/lrz/sk
; Responsibility: Spike-ball launcher timing, projectile creation and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZSpikeBallLauncher:
                move.l  #Map_LRZSpikeBallLauncher,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKLRZBallLauncher_InitLauncherState
                move.l  #SKLRZBallLauncher_TouchCullBall,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subi.w  #8,y_pos(a1)
                move.w  y_pos(a1),$46(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  #$280,priority(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.b  #$9A,collision_flags(a1)
                move.w  a1,$3C(a0)

; The launcher update is installed even when allocating its ball fails
SKLRZBallLauncher_InitLauncherState:
                move.l  #SKLRZBallLauncher_UpdateLaunchScript,(a0)

SKLRZBallLauncher_UpdateLaunchScript:
                lea     (Ani_LRZSpikeBallLauncher).l,a1
                jsr     (Animate_SpriteIrregularDelay).l
                tst.b   routine(a0)
                beq.s   SKLRZBallLauncher_CheckSolidAndDraw
                clr.b   routine(a0)
                tst.b   anim(a0)
                bne.s   SKLRZBallLauncher_TryPlayLaunchSound
                tst.b   render_flags(a0)
                bpl.s   SKLRZBallLauncher_CheckSolidAndDraw
                moveq   #signextendB(sfx_Charging),d0
                jsr     (Play_SFX).l
                bra.s   SKLRZBallLauncher_CheckSolidAndDraw
; ---------------------------------------------------------------------------

SKLRZBallLauncher_TryPlayLaunchSound:
                tst.b   render_flags(a0)
                bpl.s   SKLRZBallLauncher_LaunchBall
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

; Dereference the stored ball handle directly. Upward velocity is the subtype times -16
SKLRZBallLauncher_LaunchBall:
                movea.w $3C(a0),a1
                move.l  #SKLRZBallLauncher_TickAirborneFrames,(a1)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #4,d0
                neg.w   d0
                move.w  d0,y_vel(a1)

SKLRZBallLauncher_CheckSolidAndDraw:
                move.w  #$1B,d1
                move.w  #4,d2
                move.w  #5,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKLRZBallLauncher_TickAirborneFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKLRZBallLauncher_FallAndCheckBaseline
                move.b  #2,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   SKLRZBallLauncher_FallAndCheckBaseline
                move.b  #0,mapping_frame(a0)

SKLRZBallLauncher_FallAndCheckBaseline:
                jsr     (MoveSprite).l
                move.w  $46(a0),d0
                cmp.w   y_pos(a0),d0
                bhs.s   SKLRZBallLauncher_TouchCullBall
                move.w  d0,y_pos(a0)
                move.b  #0,mapping_frame(a0)
                move.l  #SKLRZBallLauncher_TouchCullBall,(a0)

SKLRZBallLauncher_TouchCullBall:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------
Ani_LRZSpikeBallLauncher:
                include "src/objects/shared/zones/lrz/animations/spike_ball_launcher.s"
Map_LRZSpikeBallLauncher:
                include "src/objects/shared/zones/lrz/mappings/spike_ball_launcher.s"
; End of function Obj_LRZSpikeBallLauncher
