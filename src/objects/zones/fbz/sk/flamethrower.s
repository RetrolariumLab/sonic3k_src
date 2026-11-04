; Owner: objects/zones/fbz/sk
; Responsibility: Flamethrower timing, flame creation, flame motion and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZFlamethrower:
                move.l  #Map_FBZFlameThrower,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$A4,0,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$180,priority(a0)
                bset    #6,render_flags(a0)
                move.w  #3,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),d0
                addq.w  #8,d0
                move.w  d0,(a2)+
                move.w  y_pos(a0),d1
                move.w  d1,(a2)+
                move.w  #0,(a2)+
                move.w  x_pos(a0),(a2)+
                move.w  d1,(a2)+
                move.w  #$11,(a2)+
                subi.w  #$10,d0
                move.w  d0,(a2)+
                move.w  d1,(a2)+
                move.w  #$10,(a2)+
                move.b  #1,mapping_frame(a0)
                move.b  subtype(a0),d0
                bpl.s   SKFBZFlame_ChooseNozzleLayout
                move.b  #3,mapping_frame(a0)

SKFBZFlame_ChooseNozzleLayout:
                andi.b  #$40,d0
                beq.s   SKFBZFlame_StartRotatingEmitter
                move.w  #2,mainspr_childsprites(a0)
                btst    #0,status(a0)
                beq.s   SKFBZFlame_StartSideEmitter
                lea     sub2_x_pos(a0),a2
                subi.w  #$10,(a2)
                move.b  #$10,sub2_mapframe-sub2_x_pos(a2)

SKFBZFlame_StartSideEmitter:
                move.l  #SKFBZFlame_TickSideEmitter,(a0)
                bra.w   SKFBZFlame_TickSideEmitter
; ---------------------------------------------------------------------------

SKFBZFlame_StartRotatingEmitter:
                move.l  #SKFBZFlame_TickRotatingEmitter,(a0)

SKFBZFlame_TickRotatingEmitter:
                cmpi.b  #2,mapping_frame(a0)
                beq.w   SKFBZFlame_PlaceNozzlesAndCharge
                subq.b  #1,$34(a0)
                bpl.s   SKFBZFlame_CheckRotatingFireFrame
                move.b  #2,$34(a0)
                addq.b  #1,$35(a0)
                andi.b  #3,$35(a0)

SKFBZFlame_CheckRotatingFireFrame:
                move.b  (Level_frame_counter+1).w,d0
                move.b  d0,d1
                andi.b  #3,d0
                bne.w   SKFBZFlame_PlaceNozzlesAndCharge
                andi.b  #$F,d1
                bne.s   SKFBZFlame_TrySpawnOppositeFlames
                tst.b   render_flags(a0)
                bpl.s   SKFBZFlame_TrySpawnOppositeFlames
                moveq   #signextendB(sfx_FlamethrowerLoud),d0
                jsr     (Play_SFX).l

SKFBZFlame_TrySpawnOppositeFlames:
                tst.b   render_flags(a0)
                bpl.w   SKFBZFlame_PlaceNozzlesAndCharge
                subq.b  #4,$2E(a0)
                andi.b  #$7F,$2E(a0)
                bsr.w   SpawnFbzFlamethrowerParticle
                ori.b   #$80,$2E(a0)
                bsr.w   SpawnFbzFlamethrowerParticle

SKFBZFlame_PlaceNozzlesAndCharge:
                bsr.w   PositionFbzFlamethrowerRotatingNozzles
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                bsr.s   UpdateFbzFlamethrowerStandingCharge
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKFBZFlame_TickSideEmitter:
                cmpi.b  #2,mapping_frame(a0)
                beq.w   SKFBZFlame_ResolveSideSolidAndDraw
                subq.b  #1,$34(a0)
                bpl.s   SKFBZFlame_CheckSideFireFrame
                move.b  #2,$34(a0)
                addq.b  #1,$35(a0)
                andi.b  #3,$35(a0)

; The periodic sound can play offscreen. Only the particle spawn tests visibility
SKFBZFlame_CheckSideFireFrame:
                move.b  (Level_frame_counter+1).w,d0
                move.b  d0,d1
                andi.b  #3,d0
                bne.w   SKFBZFlame_ResolveSideSolidAndDraw
                andi.b  #$F,d1
                bne.s   SKFBZFlame_TrySpawnSideFlame
                moveq   #signextendB(sfx_FlamethrowerLoud),d0
                jsr     (Play_SFX).l

SKFBZFlame_TrySpawnSideFlame:
                tst.b   render_flags(a0)
                bpl.w   SKFBZFlame_ResolveSideSolidAndDraw
                addq.b  #2,$2E(a0)
                bsr.w   SpawnFbzFlamethrowerParticle

SKFBZFlame_ResolveSideSolidAndDraw:
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                bsr.s   UpdateFbzFlamethrowerStandingCharge
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdateFbzFlamethrowerStandingCharge:
                tst.b   subtype(a0)
                bmi.s   SKFBZFlame_ChargeReturn
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   SKFBZFlame_ResetCharge
                tst.w   $30(a0)
                bne.s   SKFBZFlame_TickChargeAndTryP1
                move.w  #$3C,$30(a0)
                move.b  #2,mapping_frame(a0)
                move.b  #0,$2E(a0)

SKFBZFlame_ChargeReturn:
                rts
; ---------------------------------------------------------------------------

SKFBZFlame_ResetCharge:
                move.w  #0,$30(a0)
                move.b  #1,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

SKFBZFlame_TickChargeAndTryP1:
                subq.w  #1,$30(a0)
                bne.s   SKFBZFlame_ChargeReturn
                lea     (Player_1).w,a1
                bclr    #p1_standing_bit,status(a0)
                beq.s   SKFBZFlame_TryLaunchP2
                bsr.w   LaunchPlayerFromFbzSpringSurface

SKFBZFlame_TryLaunchP2:
                lea     (Player_2).w,a1
                bclr    #p2_standing_bit,status(a0)
                beq.s   SKFBZFlame_LaunchReturn
                bsr.w   LaunchPlayerFromFbzSpringSurface

SKFBZFlame_LaunchReturn:
                rts
; End of function UpdateFbzFlamethrowerStandingCharge

; =============== S U B R O U T I N E =======================================

PositionFbzFlamethrowerRotatingNozzles:
                move.b  $2E(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #5,d1
                move.w  d1,d0
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),d2
                add.w   d2,d1
                move.w  d1,(a2)
                neg.w   d0
                add.w   d2,d0
                move.w  d0,sub4_x_pos-sub2_x_pos(a2)
                cmpi.b  #-$40,$2E(a0)
                blo.s   SKFBZFlame_SwapOuterNozzleFrames
                move.b  #0,sub2_mapframe-sub2_x_pos(a2)
                move.b  #$10,sub4_mapframe-sub2_x_pos(a2)
                rts
; ---------------------------------------------------------------------------

SKFBZFlame_SwapOuterNozzleFrames:
                move.b  #$10,sub2_mapframe-sub2_x_pos(a2)
                move.b  #0,sub4_mapframe-sub2_x_pos(a2)
                rts
; End of function PositionFbzFlamethrowerRotatingNozzles

; =============== S U B R O U T I N E =======================================

SpawnFbzFlamethrowerParticle:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKFBZFlame_FlameSpawnReturn
                move.l  #SKFBZFlame_TickFlameStage,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subq.w  #4,y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  #make_art_tile(ArtTile_FBZMisc+$A4,0,0),art_tile(a1)
                move.w  #$200,priority(a1)
                move.b  #$C,width_pixels(a1)
                move.b  #$C,height_pixels(a1)
                move.b  #$98,collision_flags(a1)
                bset    #4,shield_reaction(a1)
                btst    #6,subtype(a0)
                bne.s   SKFBZFlame_CalcSideFlameSpeed
                move.b  $2E(a0),d0
                bpl.s   SKFBZFlame_InitRotatingFlame
                move.w  #$80,priority(a1)

SKFBZFlame_InitRotatingFlame:
                jsr     (GetSineCosine).l
                move.w  d1,d0
                asl.w   #2,d1
                move.w  d1,x_vel(a1)
                asr.w   #4,d0
                add.w   d0,x_pos(a1)
                move.b  $35(a0),anim_frame(a1)
                move.b  #4,anim_frame_timer(a1)
                move.b  #$C,anim(a1)

SKFBZFlame_FlameSpawnReturn:
                rts
; ---------------------------------------------------------------------------

SKFBZFlame_CalcSideFlameSpeed:
                move.b  $2E(a0),d0
                jsr     (GetSineCosine).l
                move.w  d1,d2
                asr.w   #1,d2
                add.w   d2,d1
                addi.w  #$280,d1
                move.w  d1,x_vel(a1)
                addi.w  #$10,x_pos(a1)
                btst    #0,status(a0)
                beq.s   SKFBZFlame_InitSideFlameAnim
                neg.w   x_vel(a1)
                subi.w  #$20,x_pos(a1)

SKFBZFlame_InitSideFlameAnim:
                move.b  $35(a0),anim_frame(a1)
                move.b  #4,anim_frame_timer(a1)
                move.b  #$C,anim(a1)
                rts
; End of function SpawnFbzFlamethrowerParticle

; ---------------------------------------------------------------------------

SKFBZFlame_TickFlameStage:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKFBZFlame_AnimateAndMoveFlame
                move.b  #5,anim_frame_timer(a0)
                subq.b  #4,anim(a0)
                beq.s   SKFBZFlame_DeleteSpentFlame

SKFBZFlame_AnimateAndMoveFlame:
                addq.b  #1,anim_frame(a0)
                andi.b  #3,anim_frame(a0)
                move.b  anim(a0),d0
                add.b   anim_frame(a0),d0
                move.b  d0,mapping_frame(a0)
                jsr     (MoveSprite2).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKFBZFlame_DeleteSpentFlame:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_FBZFlameThrower:
                include "src/objects/shared/zones/fbz/mappings/flamethrower.s"
