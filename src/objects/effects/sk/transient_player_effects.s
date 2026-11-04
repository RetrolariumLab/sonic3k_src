; Owner: objects/effects/sk
; Responsibility: Short-lived dash, splash and drowning particles, transformation stars and instant-shield attack display
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DashDust:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DashDust_Index(pc,d0.w),d1
                jmp     DashDust_Index(pc,d1.w)
; ---------------------------------------------------------------------------
DashDust_Index:
                dc.w    SKDust_InitParentArtAndDma-DashDust_Index
                dc.w    SKDust_DispatchNormalAnim-DashDust_Index
                dc.w    SKDust_DeleteNormal-DashDust_Index
                dc.w    SKDust_CheckNormalSmokeEmitter-DashDust_Index
; ---------------------------------------------------------------------------

SKDust_InitParentArtAndDma:
                addq.b  #2,routine(a0)
                move.l  #Map_DashDust,mappings(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #make_art_tile(ArtTile_DashDust,0,0),art_tile(a0)
                move.w  #Player_1,parent(a0)
                move.w  #tiles_to_bytes(ArtTile_DashDust),vram_art(a0)
                cmpa.w  #Dust,a0
                beq.s   SKDust_DispatchNormalAnim
                move.b  #1,$38(a0)
                cmpi.w  #2,(Player_mode).w
                beq.s   SKDust_DispatchNormalAnim
                move.w  #make_art_tile(ArtTile_DashDust_P2,0,0),art_tile(a0)
                move.w  #Player_2,parent(a0)
                move.w  #tiles_to_bytes(ArtTile_DashDust_P2),vram_art(a0)

SKDust_DispatchNormalAnim:
                movea.w parent(a0),a2
                moveq   #0,d0
                move.b  anim(a0),d0
                add.w   d0,d0
                move.w  SKDust_NormalHandlerOffsets(pc,d0.w),d1
                jmp     SKDust_NormalHandlerOffsets(pc,d1.w)
; ---------------------------------------------------------------------------
SKDust_NormalHandlerOffsets:
                dc.w    SKDust_AnimateLoadAndDrawNormal-SKDust_NormalHandlerOffsets
                dc.w    SKDust_AlignWaterSplash-SKDust_NormalHandlerOffsets
                dc.w    SKDust_CheckChargingPlayer-SKDust_NormalHandlerOffsets
                dc.w    SKDust_CheckDetachedSmoke-SKDust_NormalHandlerOffsets
                dc.w    SKDust_InitGroundSplashX-SKDust_NormalHandlerOffsets
; ---------------------------------------------------------------------------

SKDust_AlignWaterSplash:
                move.w  (Water_level).w,y_pos(a0)
                tst.b   prev_anim(a0)
                bne.w   SKDust_AnimateLoadAndDrawNormal
                move.w  x_pos(a2),x_pos(a0)
                move.b  #0,status(a0)
                andi.w  #drawing_mask,art_tile(a0)
                bra.w   SKDust_AnimateLoadAndDrawNormal
; ---------------------------------------------------------------------------

SKDust_InitGroundSplashX:
                tst.b   prev_anim(a0)
                bne.s   SKDust_AnimateGroundSplash
                move.w  x_pos(a2),x_pos(a0)
                move.b  #0,status(a0)
                andi.w  #drawing_mask,art_tile(a0)

SKDust_AnimateGroundSplash:
                lea     (Ani_DashSplashDrown).l,a1
                jsr     (Animate_Sprite).l
                move.l  #ArtUnc_SplashDrown,d6
                bsr.w   SplashDrown_Load_DPLC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKDust_CheckChargingPlayer:
                cmpi.b  #12,air_left(a2)
                blo.w   SKDust_SetIdleAndReturn
                cmpi.b  #4,routine(a2)
                bhs.s   SKDust_SetIdleAndReturn
                tst.b   spin_dash_flag(a2)
                beq.s   SKDust_SetIdleAndReturn
                move.w  x_pos(a2),x_pos(a0)
                move.w  y_pos(a2),y_pos(a0)
                move.b  status(a2),status(a0)
                andi.b  #1,status(a0)
                moveq   #4,d1
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKDust_OffsetP2ChargeForGravity
                ori.b   #2,status(a0)
                neg.w   d1

SKDust_OffsetP2ChargeForGravity:
                tst.b   $38(a0)
                beq.s   SKDust_InitChargeArtPriority
                sub.w   d1,y_pos(a0)

; Copy the parent's priority only on entry from animation bank zero
SKDust_InitChargeArtPriority:
                tst.b   prev_anim(a0)
                bne.s   SKDust_AnimateLoadAndDrawNormal
                andi.w  #drawing_mask,art_tile(a0)
                tst.w   art_tile(a2)
                bpl.s   SKDust_AnimateLoadAndDrawNormal
                ori.w   #high_priority,art_tile(a0)
                bra.s   SKDust_AnimateLoadAndDrawNormal
; ---------------------------------------------------------------------------

SKDust_CheckDetachedSmoke:
                cmpi.b  #12,air_left(a2)
                blo.s   SKDust_SetIdleAndReturn
                btst    #6,status(a0)
                bne.s   SKDust_SetIdleAndReturn

SKDust_AnimateLoadAndDrawNormal:
                lea     (Ani_DashSplashDrown).l,a1
                jsr     (Animate_Sprite).l
                bsr.w   DashDust_Load_DPLC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKDust_SetIdleAndReturn:
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKDust_DeleteNormal:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

SKDust_CheckNormalSmokeEmitter:
                movea.w parent(a0),a2
                moveq   #$10,d1
                cmpi.b  #$D,anim(a2)
                beq.s   SKDust_WaitForNormalSmoke
                cmpi.b  #2,character_id(a2)
                bne.s   SKDust_RestoreNormalDispatcher
                moveq   #6,d1
                cmpi.b  #3,double_jump_flag(a2)
                beq.s   SKDust_WaitForNormalSmoke

SKDust_RestoreNormalDispatcher:
                move.b  #2,routine(a0)
                move.b  #0,$36(a0)
                rts
; ---------------------------------------------------------------------------

SKDust_WaitForNormalSmoke:
                subq.b  #1,$36(a0)
                bpl.s   SKDust_RefreshEmitterPatterns
                move.b  #3,$36(a0)
                btst    #Status_Underwater,status(a2)
                bne.s   SKDust_RefreshEmitterPatterns
                bsr.w   AllocateObject
                bne.s   SKDust_RefreshEmitterPatterns
                move.l  (a0),(a1)
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                tst.b   $38(a0)
                beq.s   SKDust_MirrorSmokeYOffset
                subq.w  #4,d1

SKDust_MirrorSmokeYOffset:
                tst.b   (Reverse_gravity_flag).w
                beq.s   SKDust_InitStationarySmoke
                neg.w   d1

SKDust_InitStationarySmoke:
                add.w   d1,y_pos(a1)
                move.b  #0,status(a1)
                move.b  #3,anim(a1)
                addq.b  #2,routine(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.w  #$80,priority(a1)
                move.b  #4,width_pixels(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  parent(a0),parent(a1)
                andi.w  #drawing_mask,art_tile(a1)
                tst.w   art_tile(a2)
                bpl.s   SKDust_RefreshEmitterPatterns
                ori.w   #high_priority,art_tile(a1)

SKDust_RefreshEmitterPatterns:
                bsr.s   DashDust_Load_DPLC
                rts

; =============== S U B R O U T I N E =======================================

DashDust_Load_DPLC:
                move.l  #ArtUnc_DashDust,d6

SplashDrown_Load_DPLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $34(a0),d0
                beq.s   SKDust_PatternLoadReturn
                move.b  d0,$34(a0)
                lea     (DPLC_DashSplashDrown).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   SKDust_PatternLoadReturn
                move.w  vram_art(a0),d4

SKDust_QueueDplcAndAdvanceVram:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,SKDust_QueueDplcAndAdvanceVram

SKDust_PatternLoadReturn:
                rts
; End of function DashDust_Load_DPLC

; ---------------------------------------------------------------------------
Ani_DashSplashDrown:
                include "src/objects/shared/dash_dust/animations/dash_dust.s"
Map_DashDust:
                include "src/objects/shared/dash_dust/mappings/dash_dust.s"
DPLC_DashSplashDrown:
                include "src/objects/shared/dash_dust/dplc/dash_dust.s"
; ---------------------------------------------------------------------------

Obj_DashDust2P:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DashDust2P_Index(pc,d0.w),d1
                jmp     DashDust2P_Index(pc,d1.w)
; ---------------------------------------------------------------------------
DashDust2P_Index:
                dc.w    SKDust_InitCompAndSelectParent-DashDust2P_Index
                dc.w    SKDust_DispatchCompAnim-DashDust2P_Index
                dc.w    SKDust_DeleteComp-DashDust2P_Index
                dc.w    SKDust_CheckCompSmokeEmitter-DashDust2P_Index
; ---------------------------------------------------------------------------

SKDust_InitCompAndSelectParent:
                addq.b  #2,routine(a0)
                move.l  #Map_DashDust2P,mappings(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #make_art_tile(ArtTile_DashDust,0,0),art_tile(a0)
                move.w  #Player_1,parent(a0)
                cmpa.w  #Dust,a0
                beq.s   SKDust_DispatchCompAnim
                move.w  #Player_2,parent(a0)

SKDust_DispatchCompAnim:
                movea.w parent(a0),a2
                moveq   #0,d0
                move.b  anim(a0),d0
                add.w   d0,d0
                move.w  SKDust_CompHandlerOffsets(pc,d0.w),d1
                jmp     SKDust_CompHandlerOffsets(pc,d1.w)
; ---------------------------------------------------------------------------
SKDust_CompHandlerOffsets:
                dc.w    SKDust_BlankCompIdleOrSplash-SKDust_CompHandlerOffsets
                dc.w    SKDust_BlankCompIdleOrSplash-SKDust_CompHandlerOffsets
                dc.w    SKDust_CheckCompCharge-SKDust_CompHandlerOffsets
                dc.w    SKDust_CheckCompSmokeAir-SKDust_CompHandlerOffsets
; ---------------------------------------------------------------------------

SKDust_BlankCompIdleOrSplash:
                move.b  #0,mapping_frame(a0)
                bra.s   SKDust_AnimateAndDrawComp
; ---------------------------------------------------------------------------

SKDust_CheckCompCharge:
                cmpi.b  #12,air_left(a2)
                blo.s   SKDust_SetCompIdleAndReturn
                cmpi.b  #4,routine(a2)
                bhs.s   SKDust_SetCompIdleAndReturn
                tst.b   spin_dash_flag(a2)
                beq.s   SKDust_SetCompIdleAndReturn
                move.w  x_pos(a2),x_pos(a0)
                move.w  y_pos(a2),y_pos(a0)
                move.b  status(a2),status(a0)
                andi.b  #1,status(a0)
                tst.b   prev_anim(a0)
                bne.s   SKDust_AnimateAndDrawComp
                andi.w  #drawing_mask,art_tile(a0)
                tst.w   art_tile(a2)
                bpl.s   SKDust_AnimateAndDrawComp
                ori.w   #high_priority,art_tile(a0)
                bra.s   SKDust_AnimateAndDrawComp
; ---------------------------------------------------------------------------

SKDust_CheckCompSmokeAir:
                cmpi.b  #12,air_left(a2)
                blo.s   SKDust_SetCompIdleAndReturn

SKDust_AnimateAndDrawComp:
                lea     (Ani_DashDust2P).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKDust_SetCompIdleAndReturn:
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

SKDust_DeleteComp:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

SKDust_CheckCompSmokeEmitter:
                movea.w parent(a0),a2
                cmpi.b  #$D,anim(a2)
                beq.s   SKDust_TickCompSmokeEmitter
                move.b  #2,routine(a0)
                move.b  #0,$36(a0)
                rts
; ---------------------------------------------------------------------------

; Emit every four updates with a fixed vertical offset
SKDust_TickCompSmokeEmitter:
                move.b  #0,mapping_frame(a0)
                subq.b  #1,$36(a0)
                bpl.s   SKDust_CompSmokeReturn
                move.b  #3,$36(a0)
                bsr.w   AllocateObject
                bne.s   SKDust_CompSmokeReturn
                move.l  (a0),(a1)
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                addi.w  #$C,y_pos(a1)
                move.b  #0,status(a1)
                move.b  #3,anim(a1)
                addq.b  #2,routine(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.w  #$80,priority(a1)
                move.b  #4,width_pixels(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  parent(a0),parent(a1)
                andi.w  #drawing_mask,art_tile(a1)
                tst.w   art_tile(a2)
                bpl.s   SKDust_CompSmokeReturn
                ori.w   #high_priority,art_tile(a1)

SKDust_CompSmokeReturn:
                rts
; ---------------------------------------------------------------------------
Ani_DashDust2P:
                include "src/objects/shared/dash_dust/animations/competition.s"
Map_DashDust2P:
                include "src/objects/shared/dash_dust/mappings/competition.s"
; ---------------------------------------------------------------------------

Obj_SuperSonicKnux_Stars:
                move.l  #ArtUnc_SuperSonic_Stars,d1
                move.w  #tiles_to_bytes(ArtTile_Shield),d2
                move.w  #$1A0,d3
                jsr     (Add_To_DMA_Queue).l
                move.l  #Map_SuperSonic_Stars,mappings(a0)
                move.b  #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #make_art_tile(ArtTile_Shield,0,0),art_tile(a0)
                btst    #7,(Player_1+art_tile).w
                beq.s   SKSuperTrail_InstallHandler
                bset    #7,art_tile(a0)

SKSuperTrail_InstallHandler:
                move.l  #SKSuperTrail_UpdateOrBurst,(a0)

SKSuperTrail_UpdateOrBurst:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.w   SKSuperTrail_DeleteWhenNormal
                tst.b   anim(a0)
                beq.s   SKSuperTrail_TickAndLatchPosition
                bsr.w   SKSuperStarBurst_SpawnParticles

; Run the six-frame cycle and latch the frozen position at the transition
SKSuperTrail_TickAndLatchPosition:
                tst.b   $34(a0)
                beq.s   SKSuperTrail_CheckP1Control
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKSuperTrail_CheckFrozenPosition
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #6,mapping_frame(a0)
                blo.s   SKSuperTrail_CheckFrozenPosition
                move.b  #0,mapping_frame(a0)
                move.b  #0,$34(a0)
                move.b  #1,$35(a0)
                rts
; ---------------------------------------------------------------------------

SKSuperTrail_CheckFrozenPosition:
                tst.b   $35(a0)
                bne.s   SKSuperTrail_Draw

SKSuperTrail_CopyP1Position:
                move.w  (Player_1+x_pos).w,x_pos(a0)
                move.w  (Player_1+y_pos).w,y_pos(a0)

SKSuperTrail_Draw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSuperTrail_CheckP1Control:
                tst.b   (Player_1+object_control).w
                bne.s   SKSuperTrail_ClearAndReturn
                move.w  (Player_1+ground_vel).w,d0
                bpl.s   SKSuperTrail_TryArmAtSpeed8
                neg.w   d0

SKSuperTrail_TryArmAtSpeed8:
                cmpi.w  #$800,d0
                blo.s   SKSuperTrail_ClearAndReturn
                move.b  #0,mapping_frame(a0)
                move.b  #1,$34(a0)
                bra.s   SKSuperTrail_CopyP1Position
; ---------------------------------------------------------------------------

SKSuperTrail_ClearAndReturn:
                move.b  #0,$34(a0)
                move.b  #0,$35(a0)
                rts
; ---------------------------------------------------------------------------

SKSuperTrail_DeleteWhenNormal:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

; Consume the burst request and try sixteen stars in eight mirrored velocity pairs at Player 1
SKSuperStarBurst_SpawnParticles:
                move.b  #0,anim(a0)
                lea     (Player_1).w,a2
                moveq   #$10-1,d5
                move.w  #$488,d4

SKSuperBurst_TryParticleAndStep:
                bsr.w   AllocateObject
                bne.w   SKSuperBurst_SpawnReturn
                move.l  #Obj_SuperSonicKnux_Stars_Timer,(a1)
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                move.l  #Map_SuperSonic_Stars2,mappings(a1)
                move.w  #make_art_tile(ArtTile_Shield,0,1),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.w  #$380,priority(a1)
                move.b  #8,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                tst.w   d4
                bmi.s   SKSuperBurst_StoreVelAndMirrorX
                move.w  d4,d0
                jsr     (GetSineCosine).l
                move.w  d4,d2
                lsr.w   #8,d2
                asl.w   d2,d0
                asl.w   d2,d1
                move.w  d0,d2
                move.w  d1,d3
                addi.b  #$10,d4
                bcc.s   SKSuperBurst_StoreVelAndMirrorX
                subi.w  #$80,d4
                bcc.s   SKSuperBurst_StoreVelAndMirrorX
                move.w  #$488,d4

SKSuperBurst_StoreVelAndMirrorX:
                move.w  d2,x_vel(a1)
                move.w  d3,y_vel(a1)
                neg.w   d2
                neg.w   d4
                dbf     d5,SKSuperBurst_TryParticleAndStep

SKSuperBurst_SpawnReturn:
                rts
; End of function SKSuperStarBurst_SpawnParticles

; ---------------------------------------------------------------------------

Obj_SuperSonicKnux_Stars_Timer:
                tst.b   render_flags(a0)
                bmi.s   SKSuperBurst_MoveAndCycleParticle
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSuperBurst_MoveAndCycleParticle:
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)
                bsr.w   MoveSprite2
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------
Map_SuperSonic_Stars:
                include "src/objects/shared/shields/mappings/super_sonic_stars.s"
; ---------------------------------------------------------------------------

Obj_HyperSonic_Stars:
                lea     (ArtKosM_HyperSonicStars).l,a1
                move.w  #tiles_to_bytes(ArtTile_Shield),d2
                jsr     (Queue_Kos_Module).l
                lea     (a0),a1
                moveq   #0,d0
                moveq   #0,d2
                moveq   #4-1,d1

                .createObject:
                move.l  #Obj_HyperSonic_Stars_Init,(a1)
                move.b  d0,angle(a1)
                addi.b  #$40,d0
                addq.b  #1,d2
                move.b  d2,anim_frame_timer(a1)
                lea     next_object(a1),a1
                dbf     d1,.createObject

Obj_HyperSonic_Stars_Init:
; Wait for art to finish loading before we display
                tst.b   (Kos_modules_left).w
                beq.s   .artDoneLoading

                .return:
                rts
; ---------------------------------------------------------------------------

                .artDoneLoading:
                subq.b  #1,anim_frame_timer(a0)
                bne.s   .return
                move.l  #Map_HyperSonicStars,mappings(a0)
                move.b  #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #make_art_tile(ArtTile_Shield,0,0),art_tile(a0)
                move.b  #6,mapping_frame(a0)
                cmpa.w  #Invincibility_stars,a0
                beq.s   .isParent
                move.l  #Obj_HyperSonic_Stars_Main.child,(a0)
                bra.s   Obj_HyperSonic_Stars_Main.child
; ---------------------------------------------------------------------------

                .isParent:
                move.l  #Obj_HyperSonic_Stars_Main,(a0)

Obj_HyperSonic_Stars_Main:
                tst.b   anim(a0)
                beq.s   .child
                clr.b   anim(a0)
                move.w  (Player_1+x_pos).w,x_pos(a0)
                move.w  (Player_1+y_pos).w,y_pos(a0)
                moveq   #2,d2
                bsr.w   Obj_LightningShield_CreateSpark_Part2
                move.b  #4,(Hyper_Sonic_flash_timer).w

                .child:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.w   SKHyperStar_DeleteWhenNormal
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKHyperStar_AccumulateOrbit
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   SKHyperStar_AccumulateOrbit
                move.b  #0,mapping_frame(a0)
                moveq   #0,d0
                move.w  d0,$30(a0)
                move.w  d0,$34(a0)

SKHyperStar_AccumulateOrbit:
                move.b  angle(a0),d0
                addi.b  #-$10,angle(a0)
                jsr     (GetSineCosine).l
                asl.w   #3,d0
                asl.w   #3,d1
                move.w  d0,x_vel(a0)
                move.w  d1,y_vel(a0)
                move.w  x_vel(a0),d0
                add.w   d0,$30(a0)
                move.w  y_vel(a0),d1
                add.w   d1,$34(a0)
                move.b  $30(a0),d2
                ext.w   d2
                btst    #Status_Facing,(Player_1+status).w
                beq.s   SKHyperStar_SetOrbitPosition
                neg.w   d2

; Add the signed high bytes of the orbit accumulators to Player 1's coordinates
SKHyperStar_SetOrbitPosition:
                move.b  $34(a0),d3
                ext.w   d3
                add.w   (Player_1+x_pos).w,d2
                add.w   (Player_1+y_pos).w,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                andi.w  #drawing_mask,art_tile(a0)
                tst.b   (Player_1+art_tile).w
                bpl.s   SKHyperStar_Draw
                ori.w   #high_priority,art_tile(a0)

SKHyperStar_Draw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKHyperStar_DeleteWhenNormal:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_HyperSonicStars:
                include "src/objects/shared/sonic/mappings/hyper_sonic_stars.s"
; ---------------------------------------------------------------------------

Obj_InstaShield:
; Init
                move.l  #Map_InstaShield,mappings(a0)
                move.l  #DPLC_InstaShield,shield_plc(a0)  ; Used by PLCLoad_Shields
                move.l  #ArtUnc_InstaShield,shield_art(a0)  ; Used by PLCLoad_Shields
                move.b  #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #make_art_tile(ArtTile_Shield,0,0),art_tile(a0)
                move.w  #tiles_to_bytes(ArtTile_Shield),vram_art(a0)  ; Used by PLCLoad_Shields
                btst    #7,(Player_1+art_tile).w
                beq.s   .nothighpriority
                bset    #7,art_tile(a0)

                .nothighpriority:
                move.w  #1,anim(a0)                     ; Clear anim and set prev_anim to 1
                move.b  #-1,shield_prev_frame(a0)       ; Reset shield_prev_frame (used by PLCLoad_Shields)
                move.l  #Obj_InstaShield_Main,(a0)

Obj_InstaShield_Main:
                movea.w parent(a0),a2
                btst    #Status_Invincible,status_secondary(a2)  ; Is the player invincible?
                bne.s   SKInstaShield_ParentInvincibleReturn  ; If so, return
                move.w  x_pos(a2),x_pos(a0)             ; Inherit player's x_pos
                move.w  y_pos(a2),y_pos(a0)             ; Inherit player's y_pos
                move.b  status(a2),status(a0)           ; Inherit status
                andi.b  #1,status(a0)                   ; Limit inheritance to 'orientation' bit
                tst.b   (Reverse_gravity_flag).w
                beq.s   .normalgravity
                ori.b   #2,status(a0)                   ; Reverse the vertical mirror render flag bit (on if off beforehand and vice versa)

                .normalgravity:
                andi.w  #drawing_mask,art_tile(a0)
                tst.w   art_tile(a2)
                bpl.s   .nothighpriority
                ori.w   #high_priority,art_tile(a0)

                .nothighpriority:
                lea     (Ani_InstaShield).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #7,mapping_frame(a0)            ; Has it reached then end of its animation?
                bne.s   .notover                        ; If not, branch
                tst.b   double_jump_flag(a2)            ; Is it in its attacking state?
                beq.s   .notover                        ; If not, branch
                move.b  #2,double_jump_flag(a2)         ; Mark attack as over

                .notover:
                tst.b   mapping_frame(a0)               ; Is this the first frame?
                beq.s   .loadnewDPLC                    ; If so, branch and load the DPLC for this and the next few frames
                cmpi.b  #3,mapping_frame(a0)            ; Is this the third frame?
                bne.s   .skipDPLC                       ; If not, branch as we don't need to load another DPLC yet

                .loadnewDPLC:
                bsr.w   PLCLoad_Shields

                .skipDPLC:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKInstaShield_ParentInvincibleReturn:
                rts
