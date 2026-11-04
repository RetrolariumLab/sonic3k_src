; Owner: objects/zones/ssz/sk
; Responsibility: Bouncy cloud contact, deformation, player response and movement
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSZBouncyCloud:
                move.l  #SKSSZCloud_MoveAndSelectRiderOffset,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$20,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$102,3,1),art_tile(a0)
                move.l  #Map_SSZBouncyCloud,mappings(a0)
                clr.b   $2D(a0)
                move.w  y_pos(a0),y_vel(a0)
                jsr     (Random_Number).l
                andi.w  #$FFF,d0
                addi.w  #$C00,d0
                move.w  d0,$30(a0)

SKSSZCloud_MoveAndSelectRiderOffset:
                move.l  #$1C00,d0
                move.l  #$80,d1
                jsr     Gradual_SwingOffset(pc)
                add.w   $1A(a0),d0
                move.b  $3E(a0),d1
                move.b  $46(a0),d2
                move.b  d1,d3
                or.b    d2,d3
                beq.s   SKSSZCloud_SelectRecoveryByTimer
                cmp.b   d2,d1
                bhs.s   SKSSZCloud_ApplyCompression
                exg     d1,d2

; Choose the larger compression as an unsigned byte, then sign-extend it for Y
SKSSZCloud_ApplyCompression:
                ext.w   d1
                add.w   d1,d0
                bra.s   SKSSZCloud_StoreYAndTickCooldown
; ---------------------------------------------------------------------------

SKSSZCloud_SelectRecoveryByTimer:
                move.b  $39(a0),d1
                move.b  $3F(a0),d2
                move.b  $41(a0),d3
                move.b  $47(a0),d4
                cmp.b   d3,d1
                bhs.s   SKSSZCloud_ApplyRecoveryOffset
                exg     d2,d4

SKSSZCloud_ApplyRecoveryOffset:
                ext.w   d2
                add.w   d2,d0

SKSSZCloud_StoreYAndTickCooldown:
                move.w  d0,y_pos(a0)
                tst.b   routine(a0)
                beq.s   SKSSZCloud_UpdateRidersAndDraw
                subq.b  #1,routine(a0)

SKSSZCloud_UpdateRidersAndDraw:
                move.b  $2D(a0),anim(a0)
                lea     (Player_1).w,a1
                lea     $38(a0),a2
                moveq   #p1_standing_bit,d6
                bsr.s   SSZCloud_UpdateBounceAndSpin
                lea     (Player_2).w,a1
                lea     $40(a0),a2
                moveq   #p2_standing_bit,d6
                bsr.s   SSZCloud_UpdateBounceAndSpin
                lea     Ani_SSZBouncyCloud(pc),a1
                jsr     (Animate_Sprite).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

; Top contact starts the synchronized compression delay. After launch, track angle and recoil
SSZCloud_UpdateBounceAndSpin:
                moveq   #$20,d1
                moveq   #$10,d2
                moveq   #0,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop_1P).l
                tst.b   (a2)
                bne.s   SKSSZCloud_TickCompressionOrSpin
                btst    d6,status(a0)
                beq.s   SKSSZCloud_RiderCaptureReturn
                move.w  x_vel(a1),2(a2)
                move.w  ground_vel(a1),4(a2)
                clr.w   x_vel(a1)
                clr.w   ground_vel(a1)
                move.b  #1,anim(a0)
                move.b  #1,flip_type(a0)
                move.b  routine(a0),d0
                bne.s   SKSSZCloud_BeginRiderCompression
                moveq   #7,d0
                move.b  d0,routine(a0)

SKSSZCloud_BeginRiderCompression:
                move.b  d0,(a2)
                move.b  (SKSSZCloud_InitialCompressionSample).l,6(a2)

SKSSZCloud_RiderCaptureReturn:
                rts
; ---------------------------------------------------------------------------

SKSSZCloud_TickCompressionOrSpin:
                bmi.w   SKSSZCloud_CheckSpinAndSampleRecovery
                subq.b  #1,(a2)
                beq.s   SKSSZCloud_LaunchRiderAndSelectSpin
                move.b  (a2),d0
                ext.w   d0
                lea     SKSSZCloud_CompressionSamples(pc),a3
                move.b  (a3,d0.w),6(a2)
                bra.w   SKSSZCloud_BounceReturn
; ---------------------------------------------------------------------------

SKSSZCloud_LaunchRiderAndSelectSpin:
                moveq   #signextendB(sfx_Bouncy),d0
                jsr     (Play_SFX).l
                move.w  2(a2),x_vel(a1)
                move.w  4(a2),ground_vel(a1)
                move.w  #-$700,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #2,routine(a1)
                clr.b   anim(a1)
                st      (a2)
                moveq   #-$1C,d0
                btst    #0,status(a1)
                bne.s   SKSSZCloud_BeginRecoveryAndSpawnFx
                neg.w   d0
                bclr    #0,(a2)

SKSSZCloud_BeginRecoveryAndSpawnFx:
                move.b  d0,angle(a1)
                clr.b   $2D(a0)
                clr.b   6(a2)
                move.b  #$26,1(a2)
                lea     SKSSZCloud_BounceParticleRecords(pc),a3
                move.w  x_pos(a1),d1
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKSSZCloud_BounceReturn
                moveq   #4-1,d2

SKSSZCloud_InitBounceParticle:
                move.l  #SKSSZCloudFx_CheckSpawnBounds,(a1)
                move.w  a0,$2E(a1)
                move.w  (a3)+,d3
                add.w   d1,d3
                move.w  d3,x_pos(a1)
                move.w  (a3)+,d3
                add.w   y_pos(a0),d3
                move.w  d3,y_pos(a1)
                move.w  (a3)+,x_vel(a1)
                move.w  (a3)+,y_vel(a1)
                jsr     (CreateNewSprite4).l
                dbne    d2,SKSSZCloud_InitBounceParticle

SKSSZCloud_BounceReturn:
                rts
; ---------------------------------------------------------------------------

SKSSZCloud_CheckSpinAndSampleRecovery:
                tst.b   $2E(a1)
                bne.s   SKSSZCloud_ClearSpinMarker
                move.b  status(a1),d0
                btst    #1,d0
                beq.s   SKSSZCloud_ClearSpinMarker
                andi.w  #$28,d0
                bne.s   SKSSZCloud_ClearSpinMarker
                move.b  1(a2),d0
                ext.w   d0
                lea     SKSSZCloud_RecoverySamples(pc),a3
                move.b  (a3,d0.w),7(a2)
                subq.b  #1,d0
                bmi.s   SKSSZCloud_SelectSpinStep
                move.b  d0,1(a2)

SKSSZCloud_SelectSpinStep:
                move.b  angle(a1),d0
                move.l  #$60002,d1
                btst    #0,(a2)
                bne.s   SKSSZCloud_SelectReverseSpinRate
                tst.b   d0
                bmi.s   SKSSZCloud_StepSpinForward
                swap    d1

SKSSZCloud_StepSpinForward:
                add.b   d1,d0
                bcc.s   SKSSZCloud_StoreSpinAngle
                bra.s   SKSSZCloud_ZeroWrappedAngle
; ---------------------------------------------------------------------------

SKSSZCloud_SelectReverseSpinRate:
                tst.b   d0
                bpl.s   SKSSZCloud_StepSpinBackward
                swap    d1

SKSSZCloud_StepSpinBackward:
                sub.b   d1,d0
                bcc.s   SKSSZCloud_StoreSpinAngle

SKSSZCloud_ZeroWrappedAngle:
                moveq   #0,d0

SKSSZCloud_StoreSpinAngle:
                move.b  d0,angle(a1)
                bne.s   SKSSZCloud_SpinReturn

SKSSZCloud_ClearSpinMarker:
                clr.b   (a2)

SKSSZCloud_SpinReturn:
                rts
; End of function SSZCloud_UpdateBounceAndSpin

; ---------------------------------------------------------------------------

SKSSZCloudFx_CheckSpawnBounds:
                movea.w $2E(a0),a1
                move.w  x_pos(a1),d0
                tst.w   x_vel(a0)
                bpl.s   SKSSZCloudFx_CheckRightSpawnBound
                subi.w  #$18,d0
                cmp.w   x_pos(a0),d0
                bls.s   SKSSZCloudFx_InitParticle
                bra.s   SKSSZCloudFx_DeleteParticle
; ---------------------------------------------------------------------------

SKSSZCloudFx_CheckRightSpawnBound:
                addi.w  #$18,d0
                cmp.w   x_pos(a0),d0
                bhs.s   SKSSZCloudFx_InitParticle

SKSSZCloudFx_DeleteParticle:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSSZCloudFx_InitParticle:
                move.l  #SKSSZCloudFx_TickParticleAnimation,(a0)
                move.b  #4,render_flags(a0)
                move.b  #4,height_pixels(a0)
                move.b  #4,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$102,3,1),art_tile(a0)
                move.l  #Map_SSZBouncyCloud,mappings(a0)
                move.b  #2,anim(a0)

SKSSZCloudFx_TickParticleAnimation:
                lea     Ani_SSZBouncyCloud(pc),a1
                jsr     (Animate_SpriteIrregularDelay).l
                tst.b   routine(a0)
                beq.s   SKSSZCloudFx_MoveAndDampParticle
                move.l  #Delete_Current_Sprite,(a0)

SKSSZCloudFx_MoveAndDampParticle:
                jsr     (MoveSprite2).l
                lea     x_vel(a0),a1
                bsr.s   DampSszCloudParticleVelocity
                lea     y_vel(a0),a1
                bsr.s   DampSszCloudParticleVelocity
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

DampSszCloudParticleVelocity:
                move.w  (a1),d0
                asr.w   #2,d0
                sub.w   d0,(a1)
                rts
; End of function DampSszCloudParticleVelocity
