; Owner: objects/enemies/icz/s3
; Responsibility: Star Pointer enemy and child motion with private construction data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_StarPointer:
                jsr     (Obj_WaitOffscreen).l
                lea     ObjDat_StarPointer(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #S3StarPointer_MoveAndCheckTarget,(a0)
                bclr    #1,render_flags(a0)
                beq.s   S3StarPointer_InitSpeedAndSpawnSpikes
                bset    #7,art_tile(a0)

S3StarPointer_InitSpeedAndSpawnSpikes:
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #6,d0
                move.w  S3StarPointer_SubtypeSpeeds(pc,d0.w),d4
                jsr     (Set_VelocityXTrackSonic).l
                lea     S3StarPointer_OrbitSpikeChildren(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------
S3StarPointer_SubtypeSpeeds:
                dc.w    -$40,  -$60,  -$80, -$100
; ---------------------------------------------------------------------------

S3StarPointer_MoveAndCheckTarget:
                jsr     (MoveSprite2).l
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                bhs.s   S3StarPointer_DrawAndCheckTouch
                btst    #0,render_flags(a0)
                beq.s   S3StarPointer_CheckFacingTarget
                subq.w  #2,d0

S3StarPointer_CheckFacingTarget:
                tst.w   d0
                beq.s   S3StarPointer_SignalSpikeRelease

S3StarPointer_DrawAndCheckTouch:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

S3StarPointer_SignalSpikeRelease:
                move.l  #S3StarPointer_MoveAfterRelease,(a0)
                bset    #1,$38(a0)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

S3StarPointer_MoveAfterRelease:
                jsr     (MoveSprite2).l
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

S3StarPointer_InitSpike:
                lea     S3StarPointer_SpikeAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bset    #3,shield_reaction(a0)
                move.b  #8,x_radius(a0)
                move.l  #S3StarPointer_StepSpikeOrbit,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  S3StarPointer_SpikeStartPhases(pc,d0.w),$3C(a0)
                move.l  #S3StarPointer_BeginSpikeBreak,$34(a0)
                rts
; ---------------------------------------------------------------------------
S3StarPointer_SpikeStartPhases:
                dc.b    0, $40, $80, $C0
                even
; ---------------------------------------------------------------------------

S3StarPointer_StepSpikeOrbit:
                btst    #0,(V_int_run_count+3).w
                bne.s   S3StarPointer_UpdateOrbitingSpike
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   S3StarPointer_StepReverseSpikePhase
                addq.b  #1,$3C(a0)
                bra.w   S3StarPointer_TryLaunchSpike
; ---------------------------------------------------------------------------

S3StarPointer_StepReverseSpikePhase:
                subq.b  #1,$3C(a0)

; Launch at phase zero after the parent signals release, using twice its X speed
S3StarPointer_TryLaunchSpike:
                bne.s   S3StarPointer_UpdateOrbitingSpike
                btst    #1,$38(a1)
                beq.s   S3StarPointer_UpdateOrbitingSpike
                move.l  #S3StarPointer_UpdateFlyingSpike,(a0)
                move.w  x_vel(a1),d0
                asl.w   #1,d0
                move.l  #ObjHitWall_DoRoutine,$30(a0)
                move.w  #8,$44(a0)
                move.w  d0,x_vel(a0)
                bpl.s   S3StarPointer_UpdateOrbitingSpike
                move.l  #ObjHitWall2_DoRoutine,$30(a0)
                move.w  #-8,$44(a0)

S3StarPointer_UpdateOrbitingSpike:
                bsr.w   StarPointerSpike_CheckHitCallback
                moveq   #4,d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

S3StarPointer_UpdateFlyingSpike:
                jsr     (MoveSprite2).l
                movea.l $30(a0),a1
                move.w  $44(a0),d3
                jsr     (a1)
                bsr.w   StarPointerSpike_CheckHitCallback
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

S3StarPointer_BeginSpikeBreak:
                move.l  #S3StarPointer_AnimateSpikeBreak,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3StarPointer_AnimateSpikeBreak:
                lea     S3StarPointer_SpikeBreakAnim(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     Sprite_CheckDeleteTouchXY(pc)

; =============== S U B R O U T I N E =======================================

; Run the stored callback when the collision byte is clear. The callback selects the vanish or deletion path
StarPointerSpike_CheckHitCallback:
                tst.b   collision_flags(a0)
                bne.s   S3StarPointer_SpikeCollisionReturn
                movea.l $34(a0),a1
                jsr     (a1)

S3StarPointer_SpikeCollisionReturn:
                rts
; End of function StarPointerSpike_CheckHitCallback

; ---------------------------------------------------------------------------
ObjDat_StarPointer:
                dc.l    Map_StarPointer
                dc.w    make_art_tile(ArtTile_StarPointer,1,0)
                dc.w    $280
                dc.b    8,   8,   0,  $B
S3StarPointer_SpikeAttrs:
                dc.w    $280
                dc.b    8,   8,   1, $8B
S3StarPointer_OrbitSpikeChildren:
                dc.w    4-1
                dc.l    S3StarPointer_InitSpike
                dc.b    0,   0
S3StarPointer_SpikeBreakAnim:
                dc.b    3,   1,   2,   3, $F4
                even
