; Owner: objects/zones/lrz/sk
; Responsibility: Spike-ball movement, collision, rock debris and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZSpikeBall:
                move.l  #Map_LRZSpikeBall,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZBigSpike,1,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #$20,x_radius(a0)
                move.b  #$20,y_radius(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                tst.b   subtype(a0)
                bne.s   SKLRZSpikeBall_InitApproachOrbit
                ori.w   #high_priority,art_tile(a0)
                move.b  #$8F,collision_flags(a0)
                move.l  #SKLRZSpikeBall_PlacePerpetualOrbit,(a0)
                bra.w   SKLRZSpikeBall_PlacePerpetualOrbit
; ---------------------------------------------------------------------------

SKLRZSpikeBall_InitApproachOrbit:
                move.l  #SKLRZSpikeBall_PlaceOrbitAndSetDamage,(a0)

SKLRZSpikeBall_PlaceOrbitAndSetDamage:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d1
                add.w   $44(a0),d1
                move.w  d1,x_pos(a0)
                move.b  #0,collision_flags(a0)
                andi.w  #drawing_mask,art_tile(a0)
                tst.b   angle(a0)
                bpl.s   SKLRZSpikeBall_TryLatchP1Approach
                ori.w   #high_priority,art_tile(a0)
                move.b  #$8F,collision_flags(a0)

SKLRZSpikeBall_TryLatchP1Approach:
                lea     (Player_1).w,a1
                move.w  y_pos(a1),d0
                sub.w   $46(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$80,d0
                bhs.s   SKLRZSpikeBall_TryLaunchFromOrbit
                move.w  x_pos(a1),d0
                sub.w   $44(a0),d0
                bcc.s   SKLRZSpikeBall_TryLaunchFromOrbit
                tst.w   (Debug_placement_mode).w
                bne.s   SKLRZSpikeBall_TryLaunchFromOrbit
                move.b  #1,$30(a0)

; Launch after the approach latch is set and the angle exactly equals the subtype
SKLRZSpikeBall_TryLaunchFromOrbit:
                tst.b   $30(a0)
                beq.s   SKLRZSpikeBall_StepOrbitAndChooseDraw
                move.b  subtype(a0),d0
                cmp.b   angle(a0),d0
                bne.s   SKLRZSpikeBall_StepOrbitAndChooseDraw
                move.l  #SKLRZSpikeBall_RollAndProbeWall,(a0)
                move.w  #-$400,x_vel(a0)
                move.w  #0,y_vel(a0)

SKLRZSpikeBall_StepOrbitAndChooseDraw:
                subq.b  #2,angle(a0)
                tst.b   $30(a0)
                bne.s   SKLRZSpikeBall_DrawLatchedOrbit
                move.w  $44(a0),d0
                jmp     (SKTouchCull_TestAnchorAndDraw).l
; ---------------------------------------------------------------------------

SKLRZSpikeBall_DrawLatchedOrbit:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLRZSpikeBall_RollAndProbeWall:
                btst    #1,status(a0)
                bne.s   SKLRZSpikeBall_ProbeWallInAir
                jsr     (MoveSprite2).l
                moveq   #-$20,d3
                add.w   x_pos(a0),d3
                jsr     (ObjCheckLeftWallDist_Part2).l
                tst.w   d1
                bpl.s   SKLRZSpikeBall_FollowFloorOrFall
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.b  #0,$30(a0)

SKLRZSpikeBall_FollowFloorOrFall:
                jsr     (ObjCheckFloorDist).l
                cmpi.w  #$E,d1
                bgt.s   SKLRZSpikeBall_BeginFall
                add.w   d1,y_pos(a0)
                move.w  #0,y_vel(a0)
                tst.w   x_vel(a0)
                beq.s   SKLRZSpikeBall_AccelRollAndTryDebris
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   SKLRZSpikeBall_AccelRollAndTryDebris
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l

SKLRZSpikeBall_AccelRollAndTryDebris:
                subi.w  #4,x_vel(a0)
                bsr.w   EmitLrzSpikeBallGroundDebris
                bra.s   SKLRZSpikeBall_TickRollingFrames
; ---------------------------------------------------------------------------

SKLRZSpikeBall_BeginFall:
                bset    #1,status(a0)
                bra.s   SKLRZSpikeBall_TickRollingFrames
; ---------------------------------------------------------------------------

SKLRZSpikeBall_ProbeWallInAir:
                moveq   #-$20,d3
                add.w   x_pos(a0),d3
                jsr     (ObjCheckLeftWallDist_Part2).l
                tst.w   d1
                bpl.s   SKLRZSpikeBall_FallAndCheckLanding
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

SKLRZSpikeBall_FallAndCheckLanding:
                jsr     (MoveSprite).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   SKLRZSpikeBall_TickRollingFrames
                add.w   d1,y_pos(a0)
                bclr    #1,status(a0)
                move.w  #0,y_vel(a0)

SKLRZSpikeBall_TickRollingFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKLRZSpikeBall_ChooseRollingDraw
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   SKLRZSpikeBall_ChooseRollingDraw
                move.b  #0,mapping_frame(a0)

SKLRZSpikeBall_ChooseRollingDraw:
                tst.b   $30(a0)
                beq.s   SKLRZSpikeBall_TouchCullRollingBall
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLRZSpikeBall_TouchCullRollingBall:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

SKLRZSpikeBall_PlacePerpetualOrbit:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d1
                add.w   $44(a0),d1
                move.w  d1,x_pos(a0)
                btst    #1,status(a0)
                bne.s   SKLRZSpikeBall_TryPlayTerrainSound
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)

SKLRZSpikeBall_TryPlayTerrainSound:
                tst.b   render_flags(a0)
                bpl.s   SKLRZSpikeBall_TryDebrisAndTickFrames
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   SKLRZSpikeBall_TryDebrisAndTickFrames
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l

SKLRZSpikeBall_TryDebrisAndTickFrames:
                bsr.w   EmitLrzSpikeBallGroundDebris
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKLRZSpikeBall_StepPerpetualOrbit
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   SKLRZSpikeBall_StepPerpetualOrbit
                move.b  #0,mapping_frame(a0)

SKLRZSpikeBall_StepPerpetualOrbit:
                subq.b  #2,angle(a0)
                move.w  $44(a0),d0
                jmp     (SKTouchCull_TestAnchorAndDraw).l

; =============== S U B R O U T I N E =======================================

EmitLrzSpikeBallGroundDebris:
                move.w  (Level_frame_counter).w,d0
                andi.w  #3,d0
                bne.s   SKLRZSpikeBall_DebrisSpawnReturn
                tst.b   render_flags(a0)
                bpl.s   SKLRZSpikeBall_DebrisSpawnReturn
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKLRZSpikeBall_DebrisSpawnReturn
                move.l  #SKLRZSpikeBall_UpdateVisibleDebris,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$20,y_pos(a1)
                move.l  #Map_LRZRockDebris,mappings(a1)
                move.w  #make_art_tile($0D3,2,1),art_tile(a1)
                ori.b   #$84,render_flags(a1)
                move.w  #0,priority(a1)
                move.b  #4,width_pixels(a1)
                move.b  #4,height_pixels(a1)
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                subi.w  #$100,d0
                move.w  d0,x_vel(a1)
                asr.w   #4,d0
                add.w   d0,x_pos(a1)
                swap    d0
                andi.w  #$1FF,d0
                addi.w  #-$400,d0
                move.w  d0,y_vel(a1)

SKLRZSpikeBall_DebrisSpawnReturn:
                rts
; End of function EmitLrzSpikeBallGroundDebris

; ---------------------------------------------------------------------------

SKLRZSpikeBall_UpdateVisibleDebris:
                tst.b   render_flags(a0)
                bpl.s   SKLRZSpikeBall_DeleteDebris
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)
                jsr     (MoveSprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLRZSpikeBall_DeleteDebris:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_LRZSpikeBall:
                include "src/objects/shared/zones/lrz/mappings/spike_ball.s"
Map_LRZRockDebris:
                include "src/objects/shared/zones/lrz/mappings/rock_debris.s"
