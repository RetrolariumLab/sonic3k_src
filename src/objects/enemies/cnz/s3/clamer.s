; Owner: objects/enemies/cnz/s3
; Responsibility: Clamer attack and projectile state, tracking slots and private graphics resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Clamer:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Clamer_Index(pc,d0.w),d1
                jsr     Clamer_Index(pc,d1.w)
                lea     PLCPtr_Clamer(pc),a2
                jsr     Perform_DPLC(pc)
                jmp     Sprite_CheckDeleteTouchSlotted(pc)
; ---------------------------------------------------------------------------
Clamer_Index:
                dc.w    S3Clamer_InitAndSpawnContact-Clamer_Index
                dc.w    S3Clamer_CheckContactOrTarget-Clamer_Index
                dc.w    S3Clamer_AnimateContactResponse-Clamer_Index
                dc.w    S3Clamer_AnimateAndTryFire-Clamer_Index
; ---------------------------------------------------------------------------

S3Clamer_InitAndSpawnContact:
                lea     ObjSlot_Clamer(pc),a1
                jsr     SetUp_ObjAttributesSlotted(pc)
                lea     S3Clamer_ContactChildRecord(pc),a2
                jmp     CreateChild1_Normal(pc)
; ---------------------------------------------------------------------------

S3Clamer_CheckContactOrTarget:
                btst    #0,$38(a0)
                bne.s   S3Clamer_BeginContactResponse
                jsr     Find_SonicTails(pc)
                cmpi.w  #$60,d2
                bhs.s   ClamerS3_Root_DecodeIdleFrameDelayPairs
                btst    #0,render_flags(a0)
                beq.s   S3Clamer_CheckFacingTarget
                subq.w  #2,d0

S3Clamer_CheckFacingTarget:
                tst.w   d0
                beq.s   S3Clamer_BeginFiring

ClamerS3_Root_DecodeIdleFrameDelayPairs:
                lea     ClamerS3_Root_IdleFrameDelayPairs(pc),a1
                jmp     Animate_RawNoSSTMultiDelay(pc)
; ---------------------------------------------------------------------------

S3Clamer_BeginContactResponse:
                move.b  #4,routine(a0)
                clr.b   collision_flags(a0)
                bclr    #0,$38(a0)
                move.l  #S3Clamer_RestoreIdleContact,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

S3Clamer_BeginFiring:
                move.b  #6,routine(a0)
                move.l  #S3Clamer_RestoreIdleContact,$34(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)

S3Clamer_StateReturn:
                rts
; ---------------------------------------------------------------------------

S3Clamer_AnimateContactResponse:
                lea     S3Clamer_ContactAnim(pc),a1
                jmp     Animate_RawNoSST(pc)
; ---------------------------------------------------------------------------

S3Clamer_RestoreIdleContact:
                move.b  #2,routine(a0)
                move.b  #$A,collision_flags(a0)
                rts
; ---------------------------------------------------------------------------

; Fire only on entry to frame 8 while the object is visible
S3Clamer_AnimateAndTryFire:
                lea     S3Clamer_FiringAnim(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                tst.w   d2
                beq.w   S3Clamer_StateReturn
                cmpi.b  #8,mapping_frame(a0)
                bne.w   S3Clamer_StateReturn
                tst.b   render_flags(a0)
                bpl.w   S3Clamer_StateReturn
                lea     S3Clamer_ProjectileChildRecord(pc),a2
                jmp     CreateChild5_ComplexAdjusted(pc)
; ---------------------------------------------------------------------------

S3Clamer_InitContactChild:
                lea     S3Clamer_ContactAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                movea.w parent3(a0),a1
                move.b  render_flags(a1),render_flags(a0)
                clr.w   art_tile(a0)
                move.l  #S3Clamer_TryLaunchOnContact,(a0)
                rts
; ---------------------------------------------------------------------------

S3Clamer_TryLaunchOnContact:
                bsr.w   Check_PlayerCollision
                beq.s   S3Clamer_DrawContactChild
                move.l  #S3Clamer_WaitContactCooldown,(a0)
                bsr.w   LaunchPlayerFromClamerContactTrigger

S3Clamer_DrawContactChild:
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

S3Clamer_WaitContactCooldown:
                subq.w  #1,$2E(a0)
                bmi.s   S3Clamer_RearmContact
                rts
; ---------------------------------------------------------------------------

S3Clamer_RearmContact:
                move.l  #S3Clamer_TryLaunchOnContact,(a0)
                rts

; =============== S U B R O U T I N E =======================================

LaunchPlayerFromClamerContactTrigger:
                move.w  #$800,d0
                bclr    #Status_Facing,status(a1)
                btst    #0,render_flags(a0)
                beq.s   S3Clamer_LaunchInFacingDirection
                neg.w   d0
                bset    #Status_Facing,status(a1)

S3Clamer_LaunchInFacingDirection:
                move.w  d0,x_vel(a1)
                move.w  d0,ground_vel(a1)
                move.w  #-$800,y_vel(a1)
                bset    #Status_InAir,status(a1)
                addq.w  #6,y_pos(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)
                clr.b   jumping(a1)
                moveq   #signextendB(sfx_Spring),d0
                jsr     (Play_SFX).l
                rts
; End of function LaunchPlayerFromClamerContactTrigger

; ---------------------------------------------------------------------------
ObjSlot_Clamer:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_Clamer,1,1)
                dc.w    $12,     0
                dc.l    Map_Clamer
                dc.w    $280
                dc.b    $14, $10,   0,  $A
S3Clamer_ContactAttrs:
                dc.w    $280
                dc.b    8,   4,  $B, $D7
S3Clamer_ProjectileAttrs:
                dc.l    Map_Clamer
                dc.w    make_art_tile(ArtTile_Clamer+$70,1,1)
                dc.w    $200
                dc.b    8,   8,   9, $98
S3Clamer_ContactChildRecord:
                dc.w    1-1
                dc.l    S3Clamer_InitContactChild
                dc.b    0,  -8
S3Clamer_ProjectileChildRecord:
                dc.w    1-1
                dc.l    S3CallbackShot_InitDeflectable
                dc.l    S3Clamer_ProjectileAttrs
                dc.l    0
                dc.l    MoveSprite2
                dc.b    -$10,   2
                dc.w    -$200,     0
PLCPtr_Clamer:
                dc.l    ArtUnc_Clamer
                dc.l    DPLC_Clamer
ClamerS3_Root_IdleFrameDelayPairs:
                dc.b    1,   1
                dc.b    0, $5F
                dc.b    1,   1
                dc.b    2,   1
                dc.b    $FC
S3Clamer_ContactAnim:
                dc.b    0,   0,   1,   2,   3,   4,   3,   2,   1,  $A,   0, $F4
S3Clamer_FiringAnim:
                dc.b    0,   2
                dc.b    5,   2
                dc.b    6,   2
                dc.b    7, $2F
                dc.b    8,   5
                dc.b    7, $1F
                dc.b    6,   2
                dc.b    5,   2
                dc.b    0, $1F
                dc.b    $F4
                even
