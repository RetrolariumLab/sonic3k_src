; Owner: objects/zones/fbz/sk
; Responsibility: Missile launcher activation, aiming, missile creation and launcher state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZMissileLauncher:
                move.l  #Map_FBZMissileLauncher,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZOutdoors+$46,1,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$C,d0
                addi.w  #4,d0
                lsl.w   #2,d0
                move.w  d0,$30(a0)
                move.b  d1,d0
                andi.b  #3,d0
                move.b  d0,$34(a0)
                move.b  d0,$35(a0)
                andi.b  #$70,d1
                move.b  d1,$32(a0)
                tst.b   subtype(a0)
                bpl.s   SKFBZMissile_StartVisibilityWait
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKFBZMissile_InitInterceptCounter
                move.l  #SKFBZMissile_CheckBarrierIntercepts,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$30,x_pos(a1)
                subi.w  #$30,y_pos(a1)
                move.w  x_pos(a0),$44(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  #make_art_tile(ArtTile_FBZOutdoors+$46,2,1),art_tile(a1)
                move.w  #$100,priority(a1)
                move.b  #$20,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.b  #6,mapping_frame(a1)
                bset    #7,status(a1)
                move.w  a0,$3C(a1)

SKFBZMissile_InitInterceptCounter:
                move.b  #5,$40(a0)

SKFBZMissile_StartVisibilityWait:
                move.l  #SKFBZMissile_WaitForPriorVisibility,(a0)

SKFBZMissile_WaitForPriorVisibility:
                tst.b   4(a0)
                bpl.w   SKFBZMissile_DrawLauncher
                move.l  #SKFBZMissile_TryBeginVolley,(a0)

SKFBZMissile_TryBeginVolley:
                move.b  (Level_frame_counter+1).w,d0
                add.b   $32(a0),d0
                bne.w   SKFBZMissile_DrawLauncher
                move.w  #0,$2E(a0)
                move.b  #1,mapping_frame(a0)
                move.l  #SKFBZMissile_TickGapAndTryFire,(a0)

SKFBZMissile_TickGapAndTryFire:
                subq.w  #1,$2E(a0)
                bpl.w   SKFBZMissile_DrawLauncher
                move.w  $30(a0),$2E(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKFBZMissile_CountVolleyAttempt
                move.l  #SKFBZMissile_MoveMissileAndCheckApex,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subi.w  #4,y_pos(a1)
                move.w  y_pos(a0),$46(a1)
                subi.w  #$44,$46(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  #make_art_tile(ArtTile_FBZOutdoors+$46,1,1),art_tile(a1)
                move.w  #$80,priority(a1)
                move.b  #8,width_pixels(a1)
                move.b  #$24,height_pixels(a1)
                move.b  #$C,y_radius(a1)
                move.b  #2,mapping_frame(a1)
                move.w  #-$600,y_vel(a1)
                addi.w  #6,y_pos(a1)
                move.b  subtype(a0),subtype(a1)
                move.w  a0,$3C(a1)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                andi.w  #$E,d0
                move.w  SKFBZMissile_MissileDriftSteps(pc,d0.w),d0
                lsl.l   #8,d0
                move.l  d0,$36(a1)
                addq.b  #2,anim_frame(a0)
                moveq   #signextendB(sfx_LevelProjectile),d0
                jsr     (Play_SFX).l

; A failed object allocation still consumes an attempt in the volley
SKFBZMissile_CountVolleyAttempt:
                subq.b  #1,$34(a0)
                bpl.s   SKFBZMissile_DrawLauncher
                move.b  $35(a0),$34(a0)
                move.l  #SKFBZMissile_CloseAndWaitForPhase,(a0)
                move.b  #7,anim_frame_timer(a0)

SKFBZMissile_DrawLauncher:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
SKFBZMissile_MissileDriftSteps:
                dc.w    $100
                dc.w    $E0
                dc.w    $120
                dc.w    $140
                dc.w    $100
                dc.w    $E0
                dc.w    $C0
                dc.w    $E0
; ---------------------------------------------------------------------------

SKFBZMissile_CloseAndWaitForPhase:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKFBZMissile_DrawLauncher
                move.b  #0,mapping_frame(a0)
                move.l  #SKFBZMissile_TryBeginVolley,(a0)
                bra.s   SKFBZMissile_DrawLauncher
; ---------------------------------------------------------------------------

SKFBZMissile_CheckBarrierIntercepts:
                movea.w $3C(a0),a1
                tst.b   $40(a1)
                bne.s   SKFBZMissile_ResolveBarrierAndDraw
                lea     (SKFBZMissile_BarrierExplosionOffsets).l,a2
                moveq   #4-1,d1

; Advance the offset pair only after allocating an explosion
SKFBZMissile_TrySpawnBarrierExplosion:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKFBZMissile_NextBlastOrHideBarrier
                move.l  #Obj_Explosion,(a1)
                move.b  #6,routine(a1)
                move.w  #make_art_tile($000,0,1),art_tile(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  (a2)+,d0
                add.w   d0,x_pos(a1)
                move.w  (a2)+,d0
                add.w   d0,y_pos(a1)

SKFBZMissile_NextBlastOrHideBarrier:
                dbf     d1,SKFBZMissile_TrySpawnBarrierExplosion
                move.w  #$7F00,x_pos(a0)
                move.w  x_pos(a0),$44(a0)
                moveq   #signextendB(sfx_TubeLauncher),d0
                jsr     (Play_SFX).l

SKFBZMissile_ResolveBarrierAndDraw:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
SKFBZMissile_BarrierExplosionOffsets:
                dc.w    -$18
                dc.w    2
                dc.w    -8
                dc.w    -4
                dc.w    8
                dc.w    4
                dc.w    $18
                dc.w    -2
; ---------------------------------------------------------------------------

SKFBZMissile_MoveMissileAndCheckApex:
                jsr     (MoveSprite2).l
                tst.w   y_vel(a0)
                bpl.s   SKFBZMissile_FallTowardBarrierOrFloor
                addi.w  #$18,y_vel(a0)
                bmi.s   SKFBZMissile_CalcAbsYSpeedForDrift
                move.b  #3,mapping_frame(a0)
                move.b  #$9E,collision_flags(a0)
                andi.w  #drawing_mask,art_tile(a0)
                bra.s   SKFBZMissile_CalcAbsYSpeedForDrift
; ---------------------------------------------------------------------------

SKFBZMissile_FallTowardBarrierOrFloor:
                addi.w  #$10,y_vel(a0)
                tst.b   subtype(a0)
                bmi.s   SKFBZMissile_TryInterceptAtBarrier

SKFBZMissile_TryExplodeAtFloor:
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKFBZMissile_CalcAbsYSpeedForDrift
                add.w   d1,y_pos(a0)
                move.l  #SKFBZMissile_ExplodeMissile,(a0)
                bra.s   SKFBZMissile_CalcAbsYSpeedForDrift
; ---------------------------------------------------------------------------

SKFBZMissile_TryInterceptAtBarrier:
                movea.w $3C(a0),a1
                tst.b   $40(a1)
                beq.s   SKFBZMissile_TryExplodeAtFloor
                move.w  $46(a0),d0
                sub.w   y_pos(a0),d0
                bcc.s   SKFBZMissile_CalcAbsYSpeedForDrift
                add.w   d0,y_pos(a0)
                move.l  #SKFBZMissile_ExplodeMissile,(a0)
                subq.b  #1,$40(a1)
                bne.s   SKFBZMissile_CalcAbsYSpeedForDrift
                andi.b  #$7F,subtype(a1)

SKFBZMissile_CalcAbsYSpeedForDrift:
                move.w  y_vel(a0),d0
                bpl.s   SKFBZMissile_TryApplyApexDrift
                neg.w   d0

SKFBZMissile_TryApplyApexDrift:
                cmpi.w  #$1D0,d0
                bhs.s   SKFBZMissile_AddMissileTouchAndDraw
                move.l  $36(a0),d0
                add.l   d0,x_pos(a0)

SKFBZMissile_AddMissileTouchAndDraw:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
; unused
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKFBZMissile_ExplodeMissile:
                addq.w  #4,y_pos(a0)
                move.l  #Obj_Explosion,(a0)
                move.b  #6,routine(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)
                moveq   #signextendB(sfx_Explode),d0
                jsr     (Play_SFX).l
                jmp     (Obj_Explosion).l
; ---------------------------------------------------------------------------
Map_FBZMissileLauncher:
                include "src/objects/shared/zones/fbz/mappings/missile_launcher.s"
; End of function Obj_FBZMissileLauncher
