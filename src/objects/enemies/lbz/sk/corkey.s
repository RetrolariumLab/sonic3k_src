; Owner: objects/enemies/lbz/sk
; Responsibility: Corkey flying enemy, spawned projectiles and private construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Corkey:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Corkey_Index(pc,d0.w),d1
                jsr     Corkey_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Corkey_Index:
                dc.w    SKCorkey_InitPatrol-Corkey_Index
                dc.w    SKCorkey_TickAndMovePatrol-Corkey_Index
                dc.w    CorkeySK_Root_WaitUntilGunClearsRequest-Corkey_Index
; ---------------------------------------------------------------------------

SKCorkey_InitPatrol:
                lea     ObjDat_Corkey(pc),a1
                jsr     (SetUp_ObjAttributes).l
                moveq   #-1,d0
                btst    #0,render_flags(a0)
                beq.s   SKCorkey_SetPatrolAndSpawnGun
                neg.w   d0

SKCorkey_SetPatrolAndSpawnGun:
                move.w  d0,$40(a0)
                move.b  subtype(a0),d0
                move.b  d0,$2F(a0)
                move.l  #SKCorkey_ReversePatrolAndWait,$34(a0)
                add.b   d0,d0
                move.b  d0,subtype(a0)
                lea     CorkeySK_Root_OneNormalGunChildRecord(pc),a2
                jsr     (CreateChild1_Normal).l

SKCorkey_ChoosePatrolDuration:
                jsr     (Random_Number).l
                andi.w  #$3F,d0
                move.w  d0,d1
                andi.w  #$30,d1
                bne.s   CorkeySK_Root_StoreRandomTravelCountdown
                ori.w   #$30,d0

CorkeySK_Root_StoreRandomTravelCountdown:
                move.w  d0,$3A(a0)
                rts
; ---------------------------------------------------------------------------

SKCorkey_TickAndMovePatrol:
                subq.w  #1,$3A(a0)
                bmi.s   CorkeySK_Root_StopAndRequestGunSpin
                move.w  $40(a0),d0
                add.w   d0,x_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

CorkeySK_Root_StopAndRequestGunSpin:
                move.b  #4,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

SKCorkey_ReversePatrolAndWait:
                neg.w   $40(a0)
                clr.b   $2E(a0)
                move.b  subtype(a0),$2F(a0)
                rts
; ---------------------------------------------------------------------------

CorkeySK_Root_WaitUntilGunClearsRequest:
                btst    #1,$38(a0)
                beq.s   SKCorkey_ResumePatrol
                rts
; ---------------------------------------------------------------------------

SKCorkey_ResumePatrol:
                move.b  #2,routine(a0)
                bra.s   SKCorkey_ChoosePatrolDuration
; ---------------------------------------------------------------------------

SKCorkey_UpdateGun:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CorkeySK_Gun_FourRelativeStateOffsets(pc,d0.w),d1
                jsr     CorkeySK_Gun_FourRelativeStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
CorkeySK_Gun_FourRelativeStateOffsets:
                dc.w    SKCorkey_InitGun-CorkeySK_Gun_FourRelativeStateOffsets
                dc.w    SKCorkey_FollowAndTrySpinGun-CorkeySK_Gun_FourRelativeStateOffsets
                dc.w    SKCorkey_AnimateSpinAndTryFire-CorkeySK_Gun_FourRelativeStateOffsets
                dc.w    CorkeySK_Gun_CountPostSpinWait-CorkeySK_Gun_FourRelativeStateOffsets
; ---------------------------------------------------------------------------

SKCorkey_InitGun:
                lea     CorkeySK_Gun_PartialAttributePrefix(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

SKCorkey_FollowAndTrySpinGun:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   CorkeySK_Gun_ReturnAfterRequestPoll
                move.b  #4,routine(a0)
                move.l  #CorkeySK_Gun_StartEightCallPostSpinWait,$34(a0)
                move.l  #SKCorkey_GunSpinAnim,$30(a0)

CorkeySK_Gun_ReturnAfterRequestPoll:
                rts
; ---------------------------------------------------------------------------

SKCorkey_AnimateSpinAndTryFire:
                jsr     (Animate_RawGetFaster).l
                tst.w   d2
                bpl.s   CorkeySK_Gun_ReturnWithoutSelectedShot
                cmpi.b  #4,$2F(a0)
                beq.s   SKCorkey_FireLeftLaser
                cmpi.b  #5,$2F(a0)
                beq.s   SKCorkey_FireRightLaser
                cmpi.b  #6,$2F(a0)
                beq.s   SKCorkey_FireCenterLaser

CorkeySK_Gun_ReturnWithoutSelectedShot:
                rts
; ---------------------------------------------------------------------------

; All three shots write the animation pointer through a1 without checking allocation
SKCorkey_FireLeftLaser:
                lea     SKCorkey_LeftLaserChild(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #SKCorkey_LeftLaserAnim,$30(a1)
                rts
; ---------------------------------------------------------------------------

SKCorkey_FireRightLaser:
                lea     SKCorkey_RightLaserChild(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #SKCorkey_RightLaserAnim,$30(a1)
                rts
; ---------------------------------------------------------------------------

SKCorkey_FireCenterLaser:
                lea     SKCorkey_CenterLaserChild(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #SKCorkey_CenterLaserAnim,$30(a1)
                rts
; ---------------------------------------------------------------------------

CorkeySK_Gun_StartEightCallPostSpinWait:
                move.b  #6,routine(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #7,$2E(a0)
                move.l  #SKCorkey_RearmGun,$34(a0)
                rts
; ---------------------------------------------------------------------------

CorkeySK_Gun_CountPostSpinWait:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

SKCorkey_RearmGun:
                move.b  #2,routine(a0)
                move.b  #1,mapping_frame(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

SKCorkey_InitLaser:
                lea     CorkeySK_Laser_ArtFirstAttributeRecord(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #SKCorkey_AnimateAndDrawLaser,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #signextendB(sfx_Laser),d0
                jsr     (Play_SFX).l

SKCorkey_AnimateAndDrawLaser:
                addq.w  #1,$3A(a0)
                jsr     (Animate_RawMultiDelay).l
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
ObjDat_Corkey:
                dc.l    Map_Corkey
                dc.w    make_art_tile(ArtTile_Corkey,1,0)
                dc.w    $280
                dc.b    $10,  $C,   0,  $B
CorkeySK_Gun_PartialAttributePrefix:
                dc.w    $280
                dc.b    8,   4,   1,   0
CorkeySK_Laser_ArtFirstAttributeRecord:
                dc.w    make_art_tile(ArtTile_Corkey,0,0)
                dc.w    $280
                dc.b    4, $50,   0, $A0
CorkeySK_Root_OneNormalGunChildRecord:
                dc.w    1-1
                dc.l    SKCorkey_UpdateGun
                dc.b    0,  $C
SKCorkey_LeftLaserChild:
                dc.w    1-1
                dc.l    SKCorkey_InitLaser
                dc.b    -4, $54
SKCorkey_RightLaserChild:
                dc.w    1-1
                dc.l    SKCorkey_InitLaser
                dc.b    4, $54
SKCorkey_CenterLaserChild:
                dc.w    1-1
                dc.l    SKCorkey_InitLaser
                dc.b    0, $54
SKCorkey_GunSpinAnim:
                dc.b    7, $10
                dc.b    1,   3
                dc.b    $FC
SKCorkey_LeftLaserAnim:
                dc.b    6,   0
                dc.b    6,   0
                dc.b    7,   4
                dc.b    5,   0
                dc.b    $F4
SKCorkey_RightLaserAnim:
                dc.b    5,   0
                dc.b    5,   0
                dc.b    7,   4
                dc.b    6,   0
                dc.b    $F4
SKCorkey_CenterLaserAnim:
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    4,   0
                dc.b    5,   0
                dc.b    7,   0
                dc.b    6,   3
                dc.b    $F4
                even
