; Owner: objects/enemies/icz/sk
; Responsibility: Star Pointer enemy and child motion with private construction data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_StarPointer:
                jsr     (Obj_WaitOffscreen).l
                lea     ObjDat_StarPointer(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKStarPointer_MoveAndCheckTarget,(a0)
                bclr    #1,render_flags(a0)
                beq.s   SKStarPointer_InitSpeedAndSpawnSpikes
                bset    #7,art_tile(a0)

SKStarPointer_InitSpeedAndSpawnSpikes:
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #6,d0
                move.w  SKStarPointer_SubtypeSpeeds(pc,d0.w),d4
                jsr     (Set_VelocityXTrackSonic).l
                lea     SKStarPointer_OrbitSpikeChildren(pc),a2
                jmp     CreateChild3_NormalRepeated(pc)
; ---------------------------------------------------------------------------
SKStarPointer_SubtypeSpeeds:
                dc.w    -$40,  -$60,  -$80, -$100
; ---------------------------------------------------------------------------

SKStarPointer_MoveAndCheckTarget:
                jsr     (MoveSprite2).l
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                bhs.s   SKStarPointer_DrawAndCheckTouch
                btst    #0,render_flags(a0)
                beq.s   SKStarPointer_CheckFacingTarget
                subq.w  #2,d0

SKStarPointer_CheckFacingTarget:
                tst.w   d0
                beq.s   SKStarPointer_SignalSpikeRelease

SKStarPointer_DrawAndCheckTouch:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKStarPointer_SignalSpikeRelease:
                move.l  #SKStarPointer_MoveAfterRelease,(a0)
                bset    #1,$38(a0)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKStarPointer_MoveAfterRelease:
                jsr     (MoveSprite2).l
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKStarPointer_InitSpike:
                lea     SKStarPointer_SpikeAttrs(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                bset    #3,shield_reaction(a0)
                move.b  #8,x_radius(a0)
                move.l  #SKStarPointer_StepSpikeOrbit,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  SKStarPointer_SpikeStartPhases(pc,d0.w),$3C(a0)
                move.l  #SKStarPointer_BeginSpikeBreak,$34(a0)
                rts
; ---------------------------------------------------------------------------
SKStarPointer_SpikeStartPhases:
                dc.b    0, $40, $80, $C0
                even
; ---------------------------------------------------------------------------

SKStarPointer_StepSpikeOrbit:
                btst    #0,(V_int_run_count+3).w
                bne.s   SKStarPointer_UpdateOrbitingSpike
                movea.w parent3(a0),a1
                btst    #0,render_flags(a1)
                beq.s   SKStarPointer_StepReverseSpikePhase
                addq.b  #1,$3C(a0)
                bra.w   SKStarPointer_TryLaunchSpike
; ---------------------------------------------------------------------------

SKStarPointer_StepReverseSpikePhase:
                subq.b  #1,$3C(a0)

; Launch at phase zero after the parent signals release, using twice its X speed
SKStarPointer_TryLaunchSpike:
                bne.s   SKStarPointer_UpdateOrbitingSpike
                btst    #1,$38(a1)
                beq.s   SKStarPointer_UpdateOrbitingSpike
                move.l  #SKStarPointer_UpdateFlyingSpike,(a0)
                move.w  x_vel(a1),d0
                asl.w   #1,d0
                move.l  #ObjHitWall_DoRoutine,$30(a0)
                move.w  #8,$44(a0)
                move.w  d0,x_vel(a0)
                bpl.s   SKStarPointer_UpdateOrbitingSpike
                move.l  #ObjHitWall2_DoRoutine,$30(a0)
                move.w  #-8,$44(a0)

SKStarPointer_UpdateOrbitingSpike:
                bsr.w   StarPointerSpike_CheckHitCallback
                moveq   #4,d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

SKStarPointer_UpdateFlyingSpike:
                jsr     (MoveSprite2).l
                movea.l $30(a0),a1
                move.w  $44(a0),d3
                jsr     (a1)
                bsr.w   StarPointerSpike_CheckHitCallback
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------

SKStarPointer_BeginSpikeBreak:
                move.l  #SKStarPointer_AnimateSpikeBreak,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKStarPointer_AnimateSpikeBreak:
                lea     SKStarPointer_SpikeBreakAnim(pc),a1
                jsr     Animate_RawNoSST(pc)
                jmp     Sprite_CheckDeleteTouchXY(pc)

; =============== S U B R O U T I N E =======================================

; Run the stored callback when the collision byte is clear. The callback selects the vanish or deletion path
StarPointerSpike_CheckHitCallback:
                tst.b   collision_flags(a0)
                bne.s   SKStarPointer_SpikeCollisionReturn
                movea.l $34(a0),a1
                jsr     (a1)

SKStarPointer_SpikeCollisionReturn:
                rts
; End of function StarPointerSpike_CheckHitCallback

; ---------------------------------------------------------------------------
ObjDat_StarPointer:
                dc.l    Map_StarPointer
                dc.w    make_art_tile(ArtTile_StarPointer,1,0)
                dc.w    $280
                dc.b    8,   8,   0,  $B
SKStarPointer_SpikeAttrs:
                dc.w    $280
                dc.b    8,   8,   1, $8B
SKStarPointer_OrbitSpikeChildren:
                dc.w    4-1
                dc.l    SKStarPointer_InitSpike
                dc.b    0,   0
SKStarPointer_SpikeBreakAnim:
                dc.b    3,   1,   2,   3, $F4
                even
