; Owner: objects/zones/mhz/sk
; Responsibility: Pollen and leaf emitters, particle creation, particle movement and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MHZ_Pollen_Spawner:
                cmpi.b  #$10,(MHZ_pollen_counter).w
                bhs.s   SKMHZPollen_EmitterReturn
                lea     $2E(a0),a3
                lea     (Player_1).w,a2
                bsr.s   EmitMhzPollenFromPlayerMotion
                lea     (Player_2).w,a2
                tst.b   render_flags(a2)
                bpl.s   SKMHZPollen_EmitterReturn
                lea     $30(a0),a3
                bsr.s   EmitMhzPollenFromPlayerMotion

SKMHZPollen_EmitterReturn:
                rts

; =============== S U B R O U T I N E =======================================

EmitMhzPollenFromPlayerMotion:
                cmpi.b  #$C,top_solid_bit(a2)
                bne.s   SKMHZPollen_EmitterReturn
                btst    #Status_InAir,status(a2)
                bne.w   SKMHZPollen_SaveAirborneYSpeed
                jsr     (Random_Number).l
                andi.w  #3,d0
                bne.s   SKMHZPollen_EmitterReturn
                move.w  (a3),d2
                beq.s   SKMHZPollen_CalcAbsPlayerXSpeed
                move.w  #0,(a3)
                btst    #Status_OnObj,status(a2)
                bne.s   SKMHZPollen_CalcAbsPlayerXSpeed
                cmpi.w  #$400,d2
                bhs.s   SKMHZPollen_BeginLandingBurst

SKMHZPollen_CalcAbsPlayerXSpeed:
                move.w  x_vel(a2),d2
                bpl.s   SKMHZPollen_TryEmitFromRunSpeed
                neg.w   d2

SKMHZPollen_TryEmitFromRunSpeed:
                cmpi.w  #$500,d2
                blo.s   SKMHZPollen_RunEmissionReturn
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKMHZPollen_RunEmissionReturn
                bsr.w   SelectMhzPollenOrLeafGraphics
                ori.b   #4,render_flags(a1)
                move.w  #0,priority(a1)
                move.b  #4,width_pixels(a1)
                move.b  #4,height_pixels(a1)
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                addi.w  #$10,y_pos(a1)
                subi.w  #$500,d2
                lsr.w   #4,d2
                addi.w  #$200,d2
                neg.w   d2
                move.w  d2,y_vel(a1)
                swap    d0
                andi.w  #3,d0
                addq.w  #2,d0
                move.w  d0,$34(a1)
                move.l  #Obj_MHZ_Pollen,(a1)
                addq.b  #1,(MHZ_pollen_counter).w

SKMHZPollen_RunEmissionReturn:
                rts
; ---------------------------------------------------------------------------

SKMHZPollen_SaveAirborneYSpeed:
                move.w  y_vel(a2),(a3)
                rts
; ---------------------------------------------------------------------------

SKMHZPollen_BeginLandingBurst:
                move.w  #$100,d2
                lea     (SKMHZPollen_BurstVelocityBias).l,a4
                moveq   #6-1,d6

; Advance the velocity bias only on successful allocation
SKMHZPollen_TrySpawnBurstParticle:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKMHZPollen_NextBurstAttempt
                bsr.w   SelectMhzPollenOrLeafGraphics
                ori.b   #4,render_flags(a1)
                move.w  #0,priority(a1)
                move.b  #4,width_pixels(a1)
                move.b  #4,height_pixels(a1)
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                addi.w  #$18,y_pos(a1)
                jsr     (Random_Number).l
                move.w  d0,angle(a1)
                andi.w  #$1FF,d0
                subi.w  #$100,d0
                add.w   (a4)+,d0
                move.w  d0,x_vel(a1)
                swap    d0
                andi.w  #$FF,d0
                add.w   d2,d0
                sub.w   (a4)+,d0
                neg.w   d0
                move.w  d0,y_vel(a1)
                swap    d0
                andi.w  #3,d0
                addq.w  #2,d0
                move.w  d0,$34(a1)
                move.l  #SKMHZPollen_MoveBurstAndCheckApex,(a1)
                addq.b  #1,(MHZ_pollen_counter).w

SKMHZPollen_NextBurstAttempt:
                dbf     d6,SKMHZPollen_TrySpawnBurstParticle
                rts
; End of function EmitMhzPollenFromPlayerMotion

; ---------------------------------------------------------------------------
SKMHZPollen_BurstVelocityBias:
                dc.w    $80,  $100
                dc.w    $100,   $C0
                dc.w    $180,   $80
                dc.w    -$80,  $100
                dc.w    -$100,   $C0
                dc.w    -$180,   $80

; =============== S U B R O U T I N E =======================================

SelectMhzPollenOrLeafGraphics:
                tst.b   (ZoneMagnetOrLeafSelectionFlag).w
                bne.s   SKMHZPollen_ChooseLeafVariant
                move.l  #Map_MHZPollen,mappings(a1)
                move.w  #make_art_tile(ArtTile_MHZMisc+$21,3,1),art_tile(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZPollen_ChooseLeafVariant:
                move.b  $32(a0),d0
                addq.b  #1,$32(a0)
                andi.w  #7,d0
                move.b  SKMHZPollen_LeafVariantCycle(pc,d0.w),d0
                bne.s   SKMHZPollen_UseSmallLeafArt
                move.l  #Map_MHZBigLeaves,mappings(a1)
                move.w  #make_art_tile(ArtTile_MHZMisc+$1C,3,1),art_tile(a1)
                rts
; ---------------------------------------------------------------------------

SKMHZPollen_UseSmallLeafArt:
                move.l  #Map_MHZPollen,mappings(a1)
                move.w  #make_art_tile(ArtTile_MHZMisc+$1C,3,1),art_tile(a1)
                rts
; End of function SelectMhzPollenOrLeafGraphics

; ---------------------------------------------------------------------------
SKMHZPollen_LeafVariantCycle:
                dc.b    0,   0,   1,   0,   0,   0,   1,   1
                even
; ---------------------------------------------------------------------------

Obj_MHZ_Pollen:
                jsr     (MoveSprite2).l
                move.w  $34(a0),d0
                add.w   d0,d0
                add.w   d0,d0
                add.w   d0,y_vel(a0)
                bmi.s   SKMHZPollen_DrawInitialRise
                move.l  #SKMHZPollen_MoveWithSineDrift,(a0)
                move.b  (Level_frame_counter+1).w,angle(a0)

SKMHZPollen_DrawInitialRise:
                bsr.s   AnimateMhzPollenByHorizontalDirection
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKMHZPollen_MoveWithSineDrift:
                move.b  angle(a0),d0
                addq.b  #4,angle(a0)
                jsr     (GetSineCosine).l
                move.w  d0,x_vel(a0)
                jsr     (MoveSprite2).l
                move.w  $34(a0),d0
                add.w   d0,y_vel(a0)
                tst.b   render_flags(a0)
                bmi.s   SKMHZPollen_DrawDescendingParticle
                move.w  #$7F00,x_pos(a0)
                subq.b  #1,(MHZ_pollen_counter).w

SKMHZPollen_DrawDescendingParticle:
                bsr.s   AnimateMhzPollenByHorizontalDirection
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

; Switch to descending motion with the angle already stored in the particle
SKMHZPollen_MoveBurstAndCheckApex:
                jsr     (MoveSprite2).l
                move.w  $34(a0),d0
                add.w   d0,d0
                add.w   d0,d0
                add.w   d0,y_vel(a0)
                bmi.s   SKMHZPollen_DrawBurstRise
                move.l  #SKMHZPollen_MoveWithSineDrift,(a0)

SKMHZPollen_DrawBurstRise:
                bsr.s   AnimateMhzPollenByHorizontalDirection
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

AnimateMhzPollenByHorizontalDirection:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKMHZPollen_DirectionAnimReturn
                move.b  #7,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)
                tst.w   x_vel(a0)
                bpl.s   SKMHZPollen_DirectionAnimReturn
                addq.b  #2,mapping_frame(a0)

SKMHZPollen_DirectionAnimReturn:
                rts
; End of function AnimateMhzPollenByHorizontalDirection

; ---------------------------------------------------------------------------
Map_MHZPollen:
                include "src/objects/shared/zones/mhz/mappings/pollen_leaves.s"
Map_MHZBigLeaves:
                include "src/objects/shared/zones/mhz/mappings/big_leaves.s"
