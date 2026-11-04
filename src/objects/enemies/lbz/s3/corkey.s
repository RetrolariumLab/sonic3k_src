; Owner: objects/enemies/lbz/s3
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
                dc.w    S3Corkey_InitPatrol-Corkey_Index
                dc.w    S3Corkey_TickAndMovePatrol-Corkey_Index
                dc.w    CorkeyS3_Root_WaitUntilGunClearsRequest-Corkey_Index
; ---------------------------------------------------------------------------

S3Corkey_InitPatrol:
                lea     ObjDat_Corkey(pc),a1
                jsr     (SetUp_ObjAttributes).l
                moveq   #-1,d0
                btst    #0,render_flags(a0)
                beq.s   S3Corkey_SetPatrolAndSpawnGun
                neg.w   d0

S3Corkey_SetPatrolAndSpawnGun:
                move.w  d0,$40(a0)
                move.b  subtype(a0),d0
                move.b  d0,$2F(a0)
                move.l  #S3Corkey_ReversePatrolAndWait,$34(a0)
                add.b   d0,d0
                move.b  d0,subtype(a0)
                lea     CorkeyS3_Root_OneNormalGunChildRecord(pc),a2
                jsr     (CreateChild1_Normal).l

S3Corkey_ChoosePatrolDuration:
                jsr     (Random_Number).l
                andi.w  #$3F,d0
                move.w  d0,d1
                andi.w  #$30,d1
                bne.s   CorkeyS3_Root_StoreRandomTravelCountdown
                ori.w   #$30,d0

CorkeyS3_Root_StoreRandomTravelCountdown:
                move.w  d0,$3A(a0)
                rts
; ---------------------------------------------------------------------------

S3Corkey_TickAndMovePatrol:
                subq.w  #1,$3A(a0)
                bmi.s   CorkeyS3_Root_StopAndRequestGunSpin
                move.w  $40(a0),d0
                add.w   d0,x_pos(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

CorkeyS3_Root_StopAndRequestGunSpin:
                move.b  #4,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

S3Corkey_ReversePatrolAndWait:
                neg.w   $40(a0)
                clr.b   $2E(a0)
                move.b  subtype(a0),$2F(a0)
                rts
; ---------------------------------------------------------------------------

CorkeyS3_Root_WaitUntilGunClearsRequest:
                btst    #1,$38(a0)
                beq.s   S3Corkey_ResumePatrol
                rts
; ---------------------------------------------------------------------------

S3Corkey_ResumePatrol:
                move.b  #2,routine(a0)
                bra.s   S3Corkey_ChoosePatrolDuration
; ---------------------------------------------------------------------------

S3Corkey_UpdateGun:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CorkeyS3_Gun_FourRelativeStateOffsets(pc,d0.w),d1
                jsr     CorkeyS3_Gun_FourRelativeStateOffsets(pc,d1.w)
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------
CorkeyS3_Gun_FourRelativeStateOffsets:
                dc.w    S3Corkey_InitGun-CorkeyS3_Gun_FourRelativeStateOffsets
                dc.w    S3Corkey_FollowAndTrySpinGun-CorkeyS3_Gun_FourRelativeStateOffsets
                dc.w    S3Corkey_AnimateSpinAndTryFire-CorkeyS3_Gun_FourRelativeStateOffsets
                dc.w    CorkeyS3_Gun_CountPostSpinWait-CorkeyS3_Gun_FourRelativeStateOffsets
; ---------------------------------------------------------------------------

S3Corkey_InitGun:
                lea     CorkeyS3_Gun_PartialAttributePrefix(pc),a1
                jmp     (SetUp_ObjAttributes3).l
; ---------------------------------------------------------------------------

S3Corkey_FollowAndTrySpinGun:
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   CorkeyS3_Gun_ReturnAfterRequestPoll
                move.b  #4,routine(a0)
                move.l  #CorkeyS3_Gun_StartEightCallPostSpinWait,$34(a0)
                move.l  #S3Corkey_GunSpinAnim,$30(a0)

CorkeyS3_Gun_ReturnAfterRequestPoll:
                rts
; ---------------------------------------------------------------------------

S3Corkey_AnimateSpinAndTryFire:
                jsr     Animate_RawGetFaster(pc)
                tst.w   d2
                bpl.s   CorkeyS3_Gun_ReturnWithoutSelectedShot
                cmpi.b  #4,$2F(a0)
                beq.s   S3Corkey_FireLeftLaser
                cmpi.b  #5,$2F(a0)
                beq.s   S3Corkey_FireRightLaser
                cmpi.b  #6,$2F(a0)
                beq.s   S3Corkey_FireCenterLaser

CorkeyS3_Gun_ReturnWithoutSelectedShot:
                rts
; ---------------------------------------------------------------------------

; All three shots write the animation pointer through a1 without checking allocation
S3Corkey_FireLeftLaser:
                lea     S3Corkey_LeftLaserChild(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #S3Corkey_LeftLaserAnim,$30(a1)
                rts
; ---------------------------------------------------------------------------

S3Corkey_FireRightLaser:
                lea     S3Corkey_RightLaserChild(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #S3Corkey_RightLaserAnim,$30(a1)
                rts
; ---------------------------------------------------------------------------

S3Corkey_FireCenterLaser:
                lea     S3Corkey_CenterLaserChild(pc),a2
                jsr     (CreateChild1_Normal).l
                move.l  #S3Corkey_CenterLaserAnim,$30(a1)
                rts
; ---------------------------------------------------------------------------

CorkeyS3_Gun_StartEightCallPostSpinWait:
                move.b  #6,routine(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #7,$2E(a0)
                move.l  #S3Corkey_RearmGun,$34(a0)
                rts
; ---------------------------------------------------------------------------

CorkeyS3_Gun_CountPostSpinWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3Corkey_RearmGun:
                move.b  #2,routine(a0)
                move.b  #1,mapping_frame(a0)
                movea.w parent3(a0),a1
                bclr    #1,$38(a1)
                rts
; ---------------------------------------------------------------------------

S3Corkey_InitLaser:
                lea     CorkeyS3_Laser_ArtFirstAttributeRecord(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #S3Corkey_AnimateAndDrawLaser,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                moveq   #signextendB(sfx_Laser),d0
                jsr     (Play_SFX).l

S3Corkey_AnimateAndDrawLaser:
                addq.w  #1,$3A(a0)
                jsr     Animate_RawMultiDelay(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------
ObjDat_Corkey:
                dc.l    Map_Corkey
                dc.w    make_art_tile(ArtTile_Corkey,1,0)
                dc.w    $280
                dc.b    $10,  $C,   0,  $B
CorkeyS3_Gun_PartialAttributePrefix:
                dc.w    $280
                dc.b    8,   4,   1,   0
CorkeyS3_Laser_ArtFirstAttributeRecord:
                dc.w    make_art_tile(ArtTile_Corkey,0,0)
                dc.w    $280
                dc.b    4, $50,   0, $A0
CorkeyS3_Root_OneNormalGunChildRecord:
                dc.w    1-1
                dc.l    S3Corkey_UpdateGun
                dc.b    0,  $C
S3Corkey_LeftLaserChild:
                dc.w    1-1
                dc.l    S3Corkey_InitLaser
                dc.b    -4, $54
S3Corkey_RightLaserChild:
                dc.w    1-1
                dc.l    S3Corkey_InitLaser
                dc.b    4, $54
S3Corkey_CenterLaserChild:
                dc.w    1-1
                dc.l    S3Corkey_InitLaser
                dc.b    0, $54
S3Corkey_GunSpinAnim:
                dc.b    7, $10
                dc.b    1,   3
                dc.b    $FC
S3Corkey_LeftLaserAnim:
                dc.b    6,   0
                dc.b    6,   0
                dc.b    7,   4
                dc.b    5,   0
                dc.b    $F4
S3Corkey_RightLaserAnim:
                dc.b    5,   0
                dc.b    5,   0
                dc.b    7,   4
                dc.b    6,   0
                dc.b    $F4
S3Corkey_CenterLaserAnim:
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
