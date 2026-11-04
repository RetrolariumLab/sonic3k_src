; Owner: objects/zones/lrz/sk
; Responsibility: Flamethrower timing, flame objects, player collision and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZFlameThrower:
                move.l  #Map_LRZFlameThrower,mappings(a0)
                move.w  #make_art_tile($090,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                bpl.s   SKLRZFlame_InitHorizontalEmitter
                andi.w  #$7F,d0
                lsl.w   #2,d0
                move.w  d0,$32(a0)
                move.w  #2*60,$30(a0)
                move.b  #7,mapping_frame(a0)
                btst    #0,status(a0)
                beq.s   SKLRZFlame_InitVerticalEmitter
                bset    #1,render_flags(a0)

SKLRZFlame_InitVerticalEmitter:
                move.l  #SKLRZFlame_TickVerticalActive,(a0)
                bra.w   SKLRZFlame_TickVerticalActive
; ---------------------------------------------------------------------------

SKLRZFlame_InitHorizontalEmitter:
                lsl.w   #2,d0
                move.w  d0,$32(a0)
                move.w  #2*60,$30(a0)
                move.b  #6,mapping_frame(a0)
                move.l  #SKLRZFlame_TickHorizontalActive,(a0)

SKLRZFlame_TickHorizontalActive:
                tst.b   $2F(a0)
                bne.s   SKLRZFlame_TickHorizontalPause
                subq.w  #1,$30(a0)
                bpl.s   SKLRZFlame_TickHorizontalFramePhase
                move.w  $32(a0),$30(a0)
                move.b  #1,$2F(a0)
                bra.w   SKLRZFlame_CheckHorizontalSolid
; ---------------------------------------------------------------------------

SKLRZFlame_TickHorizontalPause:
                subq.w  #1,$30(a0)
                bpl.w   SKLRZFlame_CheckHorizontalSolid
                move.w  #2*60,$30(a0)
                move.b  #0,$2F(a0)
                moveq   #signextendB(sfx_FlamethrowerLoud),d0
                jsr     (Play_SFX).l

SKLRZFlame_TickHorizontalFramePhase:
                subq.b  #1,$24(a0)
                bpl.s   SKLRZFlame_CheckHorizontalEmission
                move.b  #2,$24(a0)
                addq.b  #1,$25(a0)
                andi.b  #1,$25(a0)

SKLRZFlame_CheckHorizontalEmission:
                move.b  (Level_frame_counter+1).w,d0
                move.b  d0,d1
                andi.b  #3,d0
                bne.w   SKLRZFlame_CheckHorizontalSolid
                andi.b  #$F,d1
                bne.s   SKLRZFlame_AimAndTrySpawnHorizontal
                cmpi.w  #30,$30(a0)
                blo.s   SKLRZFlame_AimAndTrySpawnHorizontal
                moveq   #signextendB(sfx_FlamethrowerLoud),d0
                jsr     (Play_SFX).l

SKLRZFlame_AimAndTrySpawnHorizontal:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #4,d0
                move.b  d0,$2E(a0)
                addq.b  #8,angle(a0)
                tst.b   render_flags(a0)
                bpl.w   SKLRZFlame_CheckHorizontalSolid
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKLRZFlame_CheckHorizontalSolid
                move.l  #SKLRZFlame_TickParticleGrowth,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$10,x_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,1,0),art_tile(a1)
                move.w  #$300,priority(a1)
                move.b  #$C,width_pixels(a1)
                move.b  #$C,height_pixels(a1)
                move.b  #$98,collision_flags(a1)
                bset    #4,shield_reaction(a1)
                move.b  $2E(a0),d0
                jsr     (GetSineCosine).l
                asl.w   #2,d1
                asl.w   #2,d0
                move.w  d1,x_vel(a1)
                move.w  d0,y_vel(a1)
                btst    #0,status(a0)
                beq.s   SKLRZFlame_InitHorizontalParticle
                neg.w   x_vel(a1)
                subi.w  #2*$10,x_pos(a1)

SKLRZFlame_InitHorizontalParticle:
                move.b  $25(a0),mapping_frame(a1)
                move.b  $24(a0),$25(a1)
                move.b  #8,$24(a1)

SKLRZFlame_CheckHorizontalSolid:
                move.w  #$23,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKLRZFlame_TickVerticalActive:
                tst.b   $2F(a0)
                bne.s   SKLRZFlame_TickVerticalPause
                subq.w  #1,$30(a0)
                bpl.s   SKLRZFlame_TickVerticalFramePhase
                move.w  $32(a0),$30(a0)
                move.b  #1,$2F(a0)
                bra.w   SKLRZFlame_CheckVerticalSolid
; ---------------------------------------------------------------------------

SKLRZFlame_TickVerticalPause:
                subq.w  #1,$30(a0)
                bpl.w   SKLRZFlame_CheckVerticalSolid
                move.w  #2*60,$30(a0)
                move.b  #0,$2F(a0)
                moveq   #signextendB(sfx_FlamethrowerLoud),d0
                jsr     (Play_SFX).l

SKLRZFlame_TickVerticalFramePhase:
                subq.b  #1,$24(a0)
                bpl.s   SKLRZFlame_CheckVerticalEmission
                move.b  #2,$24(a0)
                addq.b  #1,$25(a0)
                andi.b  #1,$25(a0)

SKLRZFlame_CheckVerticalEmission:
                move.b  (Level_frame_counter+1).w,d0
                move.b  d0,d1
                andi.b  #3,d0
                bne.w   SKLRZFlame_CheckVerticalSolid
                andi.b  #$F,d1
                bne.s   SKLRZFlame_AimAndTrySpawnVertical
                cmpi.w  #30,$30(a0)
                blo.s   SKLRZFlame_AimAndTrySpawnVertical
                moveq   #signextendB(sfx_FlamethrowerLoud),d0
                jsr     (Play_SFX).l

SKLRZFlame_AimAndTrySpawnVertical:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #4,d0
                move.b  d0,$2E(a0)
                addq.b  #8,angle(a0)
                tst.b   render_flags(a0)
                bpl.w   SKLRZFlame_CheckVerticalSolid
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKLRZFlame_CheckVerticalSolid
                move.l  #SKLRZFlame_TickParticleGrowth,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$10,y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,1,0),art_tile(a1)
                move.w  #$300,priority(a1)
                move.b  #$C,width_pixels(a1)
                move.b  #$C,height_pixels(a1)
                move.b  #$98,collision_flags(a1)
                bset    #4,shield_reaction(a1)
                move.b  $2E(a0),d0
                jsr     (GetSineCosine).l
                asl.w   #2,d1
                asl.w   #2,d0
                move.w  d1,y_vel(a1)
                move.w  d0,x_vel(a1)
                btst    #0,status(a0)
                beq.s   SKLRZFlame_InitVerticalParticle
                neg.w   y_vel(a1)
                subi.w  #$20,y_pos(a1)

SKLRZFlame_InitVerticalParticle:
                move.b  $25(a0),mapping_frame(a1)
                move.b  $24(a0),$25(a1)
                move.b  #8,$24(a1)

SKLRZFlame_CheckVerticalSolid:
                move.w  #$1B,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKLRZFlame_TickParticleGrowth:
                subq.b  #1,$24(a0)
                bpl.s   SKLRZFlame_TickParticleFlicker
                move.b  #7,$24(a0)
                addq.b  #2,mapping_frame(a0)
                cmpi.b  #6,mapping_frame(a0)
                bhs.s   SKLRZFlame_DeleteParticle

; The low frame bit has a separate timer from the growth frame pair
SKLRZFlame_TickParticleFlicker:
                subq.b  #1,$25(a0)
                bpl.s   SKLRZFlame_MoveParticleAndQueueContact
                move.b  #2,$25(a0)
                bchg    #0,mapping_frame(a0)

SKLRZFlame_MoveParticleAndQueueContact:
                jsr     (MoveSprite2).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLRZFlame_DeleteParticle:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_LRZFlameThrower:
                include "src/objects/shared/zones/lrz/mappings/flamethrower.s"
; End of function Obj_LRZFlameThrower
