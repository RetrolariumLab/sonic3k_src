; Owner: objects/enemies/sk
; Responsibility: EggRobo enemy controller, projectiles, motion or attack helpers and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_EggRobo:
                jsr     (Obj_WaitOffscreen).l
                bsr.w   InitializeEggRoboVariantFromSubtype
                movea.l (a0),a1
                jmp     (a1)
; ---------------------------------------------------------------------------

SKEggRobo_ScaledFlightTryShrink:
                move.b  $40(a0),d0
                subi.b  #3,d0
                cmpi.b  #4,d0
                blo.s   SKEggRobo_ScaledFlightUpdateYSpeed
                cmp.b   $41(a0),d0
                beq.s   SKEggRobo_ScaledFlightUpdateYSpeed
                move.b  d0,$40(a0)
                move.b  d0,$41(a0)
                jsr     (Perform_Art_Scaling).l

SKEggRobo_ScaledFlightUpdateYSpeed:
                move.w  $3C(a0),d0
                subq.w  #1,d0
                move.w  d0,$3C(a0)
                add.w   d0,y_vel(a0)
                bpl.s   SKEggRobo_ScaledFlightProjectAndDraw
                tst.b   render_flags(a0)
                bpl.s   SKEggRobo_ScaledFlightUnlockHover

SKEggRobo_ScaledFlightProjectAndDraw:
                jsr     (IntegrateScaledObjectCenter).l
                jsr     (SetScaledObjectOriginFromCenter).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Set the subtype's appearance bit and queue normal Badnik art before deleting the scaled object
SKEggRobo_ScaledFlightUnlockHover:
                move.b  subtype(a0),d0
                andi.w  #$F0,d0
                lsr.w   #4,d0
                move.w  (_unkFA82).w,d1
                bset    d0,d1
                move.w  d1,(_unkFA82).w
                lea     (ArtKosM_EggRoboBadnik).l,a1
                move.w  #tiles_to_bytes(ArtTile_EggRoboBadnik),d2
                jsr     (Queue_Kos_Module).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

; Keep two previous Y samples so the gun can follow the older one
SKEggRobo_HoverAndCheckPlayerHeight:
                bsr.w   SetEggRoboFrameFromVblankParity
                move.w  $30(a0),$32(a0)
                move.w  y_pos(a0),$30(a0)
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                jsr     (Change_FlipX).l
                cmpi.w  #8,d3
                bhi.s   SKEggRobo_HoverDraw
                move.l  #SKEggRobo_WaitForGunToFinish,(a0)
                bset    #1,$38(a0)

SKEggRobo_HoverDraw:
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

SKEggRobo_WaitForGunToFinish:
                bsr.w   SetEggRoboFrameFromVblankParity
                btst    #1,$38(a0)
                bne.s   SKEggRobo_FiringHoldDraw
                move.l  #SKEggRobo_HoverAndCheckPlayerHeight,(a0)

SKEggRobo_FiringHoldDraw:
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

; On screen, try one spawn every 16 V-int ticks. Begin departure after five attempts
SKEggRobo_ReleaseAnimals:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                bne.s   SKEggRobo_AnimalReleaseDraw
                tst.b   render_flags(a0)
                bpl.s   SKEggRobo_AnimalReleaseDraw
                lea     SKEggRobo_ReleasedAnimalChild(pc),a2
                jsr     (CreateChild6_Simple).l
                subq.b  #1,$39(a0)
                bpl.s   SKEggRobo_AnimalReleaseDraw
                move.l  #SKEggRobo_DepartUpward,(a0)
                lea     EggRoboSK_Hover_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #7,art_tile(a0)
                move.w  #-$300,d0
                btst    #0,render_flags(a0)
                beq.s   SKEggRobo_DepartAndSpawnAttachments
                neg.w   d0

SKEggRobo_DepartAndSpawnAttachments:
                move.w  d0,x_vel(a0)
                lea     SKEggRobo_HoverAttachmentChildren(pc),a2
                jsr     (CreateChild1_Normal).l

SKEggRobo_AnimalReleaseDraw:
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

SKEggRobo_DepartUpward:
                bsr.w   SetEggRoboFrameFromVblankParity
                addi.w  #-$10,y_vel(a0)
                jsr     (MoveSprite2).l
                move.w  y_vel(a0),d0
                cmpi.w  #-$200,d0
                bgt.s   SKEggRobo_DepartureDraw
                move.l  #SKEggRobo_ReturnDownToHover,(a0)
                clr.w   x_vel(a0)
                bset    #7,art_tile(a0)

SKEggRobo_DepartureDraw:
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

SKEggRobo_ReturnDownToHover:
                bsr.w   SetEggRoboFrameFromVblankParity
                addi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                move.w  y_vel(a0),d0
                cmpi.w  #$100,d0
                blt.s   SKEggRobo_ReturnArcDraw
                move.l  #SKEggRobo_HoverAndCheckPlayerHeight,(a0)
                bsr.w   ResetEggRoboHoverSwing

SKEggRobo_ReturnArcDraw:
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

SKEggRobo_InitLowerAttachment:
                lea     SKEggRobo_LowerAttachmentAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                movea.w parent3(a0),a1
                btst    #2,render_flags(a1)
                bne.s   SKEggRobo_SetLowerFollowHandler
                bclr    #2,render_flags(a0)

SKEggRobo_SetLowerFollowHandler:
                move.l  #SKEggRobo_LowerFollowAndChooseFrame,(a0)
                rts
; ---------------------------------------------------------------------------

SKEggRobo_LowerFollowAndChooseFrame:
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #6,d0
                move.w  y_vel(a1),d1
                bmi.s   SKEggRobo_LowerStoreFrameAndDraw
                moveq   #5,d0
                cmpi.w  #$20,d1
                blo.s   SKEggRobo_LowerStoreFrameAndDraw
                moveq   #4,d0

SKEggRobo_LowerStoreFrameAndDraw:
                move.b  d0,mapping_frame(a0)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SKEggRobo_InitGun:
                lea     EggRoboSK_Gun_PartialAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                movea.w parent3(a0),a1
                btst    #2,render_flags(a1)
                bne.s   SKEggRobo_SetGunFollowHandler
                bclr    #2,render_flags(a0)

SKEggRobo_SetGunFollowHandler:
                move.l  #SKEggRobo_GunFollowAndCheckFire,(a0)
                rts
; ---------------------------------------------------------------------------

SKEggRobo_GunFollowAndCheckFire:
                bsr.w   FollowEggRoboGunUsingCachedParentY
                btst    #1,$38(a1)
                beq.s   EggRoboSK_Gun_CurrentParentLifetimeDraw
                move.l  #SKEggRobo_GunWaitAtShotOrigin,(a0)
                move.w  #$5F,$2E(a0)
                lea     SKEggRobo_GunLaserChild(pc),a2
                jsr     (CreateChild10_NormalAdjusted).l

EggRoboSK_Gun_CurrentParentLifetimeDraw:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

; Hold position for 96 calls, then clear the body's firing flag and resume following
SKEggRobo_GunWaitAtShotOrigin:
                subq.w  #1,$2E(a0)
                bpl.s   SKEggRobo_GunDrawAtShotOrigin
                move.l  #SKEggRobo_GunFollowAndCheckFire,(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)

SKEggRobo_GunDrawAtShotOrigin:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SKEggRobo_InitLaserCharge:
                lea     EggRoboSK_Laser_PartialChargeAttributes(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKEggRobo_LaserChooseChargeFrame,(a0)
                move.w  #$1F,$2E(a0)

SKEggRobo_LaserChooseChargeFrame:
                moveq   #0,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   SKEggRobo_LaserTickCharge
                moveq   #7,d0

SKEggRobo_LaserTickCharge:
                move.b  d0,mapping_frame(a0)
                subq.w  #1,$2E(a0)
                bpl.s   SKEggRobo_LaserChargeDraw
                move.l  #SKEggRobo_LaserFlyAndDraw,(a0)
                move.b  #7,mapping_frame(a0)
                move.b  #$9C,collision_flags(a0)
                move.w  #-$800,d0
                btst    #0,render_flags(a0)
                beq.s   SKEggRobo_LaserSetSpeedAndPlaySound
                neg.w   d0

SKEggRobo_LaserSetSpeedAndPlaySound:
                move.w  d0,x_vel(a0)
                moveq   #signextendB(sfx_Laser),d0
                jsr     (Play_SFX).l

SKEggRobo_LaserChargeDraw:
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------

; After launch the laser moves and culls independently of the gun
SKEggRobo_LaserFlyAndDraw:
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

SKEggRobo_AnimalInitRandomSpecies:
                move.l  #Obj_Animal,(a0)
                addq.b  #2,routine(a0)
                jsr     (Random_Number).l
                move.w  #make_art_tile(ArtTile_Animals1,0,0),art_tile(a0)
                andi.w  #1,d0
                beq.s   SKEggRobo_AnimalLoadFacingMotion
                move.w  #make_art_tile(ArtTile_Animals2,0,0),art_tile(a0)

SKEggRobo_AnimalLoadFacingMotion:
                move.b  d0,$30(a0)
                lsl.w   #3,d0
                lea     (SKAnimal_DefaultSpeciesRecords).l,a1
                adda.w  d0,a1
                move.w  (a1)+,d1
                movea.w parent3(a0),a2
                btst    #0,render_flags(a2)
                beq.s   SKEggRobo_AnimalStoreSpeciesAndCalcY
                neg.w   d1

SKEggRobo_AnimalStoreSpeciesAndCalcY:
                move.w  d1,x_vel(a0)
                move.w  (a1)+,$34(a0)
                move.l  (a1)+,mappings(a0)
                swap    d0
                andi.w  #$1FF,d0
                cmpi.w  #$100,d0
                bhs.s   SKEggRobo_AnimalLaunchUpward
                move.w  #$100,d0

SKEggRobo_AnimalLaunchUpward:
                neg.w   d0
                move.w  d0,y_vel(a0)
                move.b  #$C,y_radius(a0)
                move.b  #4,render_flags(a0)
                bset    #0,render_flags(a0)
                move.w  #$300,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #7,anim_frame_timer(a0)
                move.b  #1,mapping_frame(a0)
                move.b  $30(a0),d0
                add.b   d0,d0
                addq.b  #4,d0
                move.b  d0,routine(a0)
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

InitializeEggRoboVariantFromSubtype:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                move.w  SKEggRobo_VariantOffsets(pc,d0.w),d0
                jmp     SKEggRobo_VariantOffsets(pc,d0.w)
; End of function InitializeEggRoboVariantFromSubtype

; ---------------------------------------------------------------------------
SKEggRobo_VariantOffsets:
                dc.w    SKEggRobo_InitScaledFlight-SKEggRobo_VariantOffsets
                dc.w    SKEggRobo_InitHoverAfterUnlock-SKEggRobo_VariantOffsets
                dc.w    SKEggRobo_InitAnimalRelease-SKEggRobo_VariantOffsets
; ---------------------------------------------------------------------------

SKEggRobo_InitScaledFlight:
                lea     EggRoboSK_ScaledFlight_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKEggRobo_ScaledFlightTryShrink,(a0)
                move.w  #-$6000,$3A(a0)
                move.w  #-$80,d0
                btst    #0,render_flags(a0)
                bne.s   SKEggRobo_ScaledFlightSetOriginAndArt
                neg.w   d0

SKEggRobo_ScaledFlightSetOriginAndArt:
                move.w  d0,x_vel(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$34(a0)
                move.b  #$7F,$40(a0)
                move.l  #ArtScaled_EggRoboFly,$42(a0)
                btst    #0,render_flags(a0)
                move.w  #$180,y_vel(a0)

SKEggRobo_VariantSetupReturn:
                rts
; ---------------------------------------------------------------------------

SKEggRobo_InitHoverAfterUnlock:
                bsr.w   RequireEggRoboAppearanceGroupBit
                lea     EggRoboSK_Hover_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKEggRobo_HoverAndCheckPlayerHeight,(a0)
                lea     SKEggRobo_HoverAttachmentChildren(pc),a2
                jsr     (CreateChild1_Normal).l

; =============== S U B R O U T I N E =======================================

ResetEggRoboHoverSwing:
                move.w  #$100,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; End of function ResetEggRoboHoverSwing

; ---------------------------------------------------------------------------

SKEggRobo_InitAnimalRelease:
                lea     EggRoboSK_AnimalRelease_FullAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKEggRobo_ReleaseAnimals,(a0)
                move.b  #4,$39(a0)
                rts

; =============== S U B R O U T I N E =======================================

RequireEggRoboAppearanceGroupBit:
                move.b  subtype(a0),d0
                andi.w  #$F0,d0
                lsr.w   #4,d0
                move.w  (_unkFA82).w,d1
                btst    d0,d1
                bne.w   SKEggRobo_VariantSetupReturn
                addq.w  #8,sp
                jmp     (SKCull_ReleaseRespawnForStatusDelete).l
; End of function RequireEggRoboAppearanceGroupBit

; =============== S U B R O U T I N E =======================================

FollowEggRoboGunUsingCachedParentY:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                move.b  child_dx(a0),d1
                ext.w   d1
                bclr    #0,render_flags(a0)
                btst    #0,render_flags(a1)
                beq.s   SKEggRobo_GunSetXAndLoadCachedY
                neg.w   d1
                bset    #0,render_flags(a0)

SKEggRobo_GunSetXAndLoadCachedY:
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                move.w  $32(a1),d0
                bne.s   SKEggRobo_GunReflectYOffset
                move.w  y_pos(a1),d0

SKEggRobo_GunReflectYOffset:
                move.b  child_dy(a0),d1
                ext.w   d1
                bclr    #1,render_flags(a0)
                btst    #1,render_flags(a1)
                beq.s   SKEggRobo_GunStoreAdjustedY
                neg.w   d1
                bset    #1,render_flags(a0)

SKEggRobo_GunStoreAdjustedY:
                add.w   d1,d0
                move.w  d0,y_pos(a0)
                rts
; End of function FollowEggRoboGunUsingCachedParentY

; =============== S U B R O U T I N E =======================================

SetEggRoboFrameFromVblankParity:
                moveq   #1,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   EggRoboSK_Body_CommitVIntSelectedFrame
                moveq   #3,d0

EggRoboSK_Body_CommitVIntSelectedFrame:
                move.b  d0,mapping_frame(a0)
                rts
; End of function SetEggRoboFrameFromVblankParity

; ---------------------------------------------------------------------------
EggRoboSK_ScaledFlight_FullAttributes:
                dc.l    Map_ScaledArt
                dc.w    make_art_tile(ArtTile_EggRoboFlyScaled,1,1)
                dc.w    $280
                dc.b    $20, $20,   0,   0
EggRoboSK_Hover_FullAttributes:
                dc.l    Map_EggRobo
                dc.w    make_art_tile(ArtTile_EggRoboBadnik,0,1)
                dc.w    $280
                dc.b    $14, $18,   1,   6
EggRoboSK_AnimalRelease_FullAttributes:
                dc.l    Map_EggRobo
                dc.w    make_art_tile(ArtTile_EggRoboBadnik,0,1)
                dc.w    $280
                dc.b    4,   4,   0,   0
SKEggRobo_LowerAttachmentAttributes:
                dc.w    $280
                dc.b    $C, $10,   6,   0
EggRoboSK_Gun_PartialAttributes:
                dc.w    $280
                dc.b    $10,  $C,   2,   0
EggRoboSK_Laser_PartialChargeAttributes:
                dc.w    $280
                dc.b    $20,   4,   7,   0
SKEggRobo_HoverAttachmentChildren:
                dc.w    2-1
                dc.l    SKEggRobo_InitLowerAttachment
                dc.b    -$C, $1C
                dc.l    SKEggRobo_InitGun
                dc.b    -$1C,  -4
SKEggRobo_GunLaserChild:
                dc.w    1-1
                dc.l    SKEggRobo_InitLaserCharge
                dc.b    $B,  -4
SKEggRobo_ReleasedAnimalChild:
                dc.w    1-1
                dc.l    SKEggRobo_AnimalInitRandomSpecies
