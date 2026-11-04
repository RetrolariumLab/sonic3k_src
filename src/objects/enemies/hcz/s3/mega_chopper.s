; Owner: objects/enemies/hcz/s3
; Responsibility: Mega Chopper swimming, player attachment, damage and private animation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MegaChopper:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MegaChopper_Index(pc,d0.w),d1
                jsr     MegaChopper_Index(pc,d1.w)
                btst    #7,status(a0)
                bne.w   EnemyDefeat_Score
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
MegaChopper_Index:
                dc.w    S3MegaChopper_InitSwimmer-MegaChopper_Index
                dc.w    S3MegaChopper_AnimateAndPickSwimMotion-MegaChopper_Index
                dc.w    S3MegaChopper_UpdateLeap-MegaChopper_Index
                dc.w    S3MegaChopper_PickAttachedFrame-MegaChopper_Index
; ---------------------------------------------------------------------------

; Consume the initial vertical flip and use it to select art priority
S3MegaChopper_InitSwimmer:
                lea     ObjDat_MegaChopper(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AniRaw_MegaChopper,$30(a0)
                clr.w   child_dx(a0)                    ; and child_dy
                bclr    #1,render_flags(a0)
                beq.s   S3MegaChopper_UpdateReturn
                bset    #7,art_tile(a0)

S3MegaChopper_UpdateReturn:
                rts
; ---------------------------------------------------------------------------

S3MegaChopper_AnimateAndPickSwimMotion:
                bsr.w   MegaChopper_ResolveLatchedContact
                jsr     Animate_Raw(pc)
                jsr     Find_SonicTails(pc)
                move.b  (V_int_run_count+3).w,d4
                andi.b  #7,d4
                bne.s   S3MegaChopper_PickSwimOrLeap
                moveq   #1,d4
                tst.w   d1
                bne.s   S3MegaChopper_StepYTowardTarget
                neg.w   d4

S3MegaChopper_StepYTowardTarget:
                add.w   d4,y_pos(a0)

S3MegaChopper_PickSwimOrLeap:
                move.w  y_pos(a0),d4
                move.w  (Water_level).w,d5
                addq.w  #8,d5
                cmp.w   d5,d4
                bhi.s   S3MegaChopper_SwimTowardTargetX
                btst    #Status_Underwater,status(a1)
                beq.s   S3MegaChopper_PickLeapDirection

S3MegaChopper_SwimTowardTargetX:
                move.w  #$200,d0
                move.w  #8,d1
                jsr     (Chase_ObjectXOnly).l
                jsr     Change_FlipXWithVelocity(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

S3MegaChopper_PickLeapDirection:
                move.b  #4,routine(a0)
                move.w  #$200,d4
                bset    #0,render_flags(a0)
                tst.w   d0
                bne.s   S3MegaChopper_StoreLeapVelocity
                neg.w   d4
                bclr    #0,render_flags(a0)

S3MegaChopper_StoreLeapVelocity:
                move.w  d4,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3MegaChopper_UpdateLeap:
                bsr.w   MegaChopper_ResolveLatchedContact
                jsr     Animate_Raw(pc)
                tst.w   y_vel(a0)
                bmi.s   S3MegaChopper_ApplyLeapGravity
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.s   S3MegaChopper_ApplyLeapGravity
                move.w  y_vel(a0),d0
                addi.w  #-$20,d0
                move.w  d0,y_vel(a0)
                beq.s   S3MegaChopper_ResumeSwimming
                bmi.s   S3MegaChopper_ResumeSwimming
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

S3MegaChopper_ApplyLeapGravity:
                jmp     MoveSprite_LightGravity(pc)
; ---------------------------------------------------------------------------

S3MegaChopper_ResumeSwimming:
                move.b  #2,routine(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3MegaChopper_PickAttachedFrame:
                move.b  #0,mapping_frame(a0)
                btst    #2,(V_int_run_count+3).w
                beq.s   S3MegaChopper_CheckEscapeAndFilterInput
                move.b  #2,mapping_frame(a0)

S3MegaChopper_CheckEscapeAndFilterInput:
                movea.w $44(a0),a1
                cmpi.b  #4,routine(a1)
                beq.w   S3MegaChopper_ReleaseInputAndDetach
                cmpi.b  #2,anim(a1)
                beq.s   S3MegaChopper_ReleaseInputAndDetach
                cmpi.b  #9,anim(a1)
                beq.s   S3MegaChopper_ReleaseInputAndDetach
                jsr     Check_LRControllerShake(pc)
                bne.s   S3MegaChopper_ReleaseInputAndDetach
                btst    #2,$38(a0)
                beq.s   S3MegaChopper_FollowXAndCheckFacing
                move.w  (Ctrl_1).w,d0
                andi.w  #($8C<<8)|$8C,d0
                move.w  d0,(Ctrl_1_logical).w

S3MegaChopper_FollowXAndCheckFacing:
                move.w  x_pos(a1),d0
                move.b  child_dx(a0),d1
                ext.w   d1
                move.b  $38(a0),d2
                andi.b  #1,d2
                move.b  render_flags(a1),d3
                andi.b  #1,d3
                eor.b   d2,d3
                beq.s   S3MegaChopper_StoreXAndReadYOffset
                bchg    #0,render_flags(a0)
                bchg    #0,$38(a0)
                neg.b   child_dx(a0)

S3MegaChopper_StoreXAndReadYOffset:
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),d0
                move.b  child_dy(a0),d1
                ext.w   d1
                bpl.s   S3MegaChopper_StoreYAndDrainRings
                cmpi.b  #8,anim(a1)
                bne.s   S3MegaChopper_StoreYAndDrainRings
                addi.w  #$10,d1

S3MegaChopper_StoreYAndDrainRings:
                add.w   d1,d0
                move.w  d0,y_pos(a0)
                bsr.w   DrainGlobalRingFromAttachedMegaChopper
                beq.w   S3MegaChopper_UpdateReturn

; Clear the primary input lock only when this object owns it
S3MegaChopper_ReleaseInputAndDetach:
                bclr    #2,$38(a0)
                beq.s   S3MegaChopper_BeginDetachedFall
                clr.b   (Ctrl_1_locked).w

S3MegaChopper_BeginDetachedFall:
                move.l  #MoveChkDel,(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #$200,d0
                btst    #0,render_flags(a0)
                beq.s   S3MegaChopper_StoreDetachVelocity
                neg.w   d0

S3MegaChopper_StoreDetachVelocity:
                move.w  d0,x_vel(a0)
                move.w  #-$200,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

; Consume the latch, then check whether to mark defeat or initialize attachment offsets and controller state
MegaChopper_ResolveLatchedContact:
                move.b  collision_property(a0),d0
                beq.w   S3MegaChopper_UpdateReturn
                clr.b   collision_property(a0)
                andi.w  #3,d0
                move.w  d0,d2
                lsl.w   #2,d0
                lea     S3MegaChopper_PlayerControlPairs-4(pc),a2
                lea     (a2,d0.w),a2
                movea.w (a2)+,a1
                move.w  a1,$44(a0)
                btst    #Status_Invincible,status_secondary(a1)
                bne.w   S3MegaChopper_MarkDefeated
                move.w  y_pos(a0),d1
                sub.w   y_pos(a1),d1
                cmpi.w  #-$10,d1
                blt.w   S3MegaChopper_UpdateReturn
                cmpi.w  #$10,d1
                bge.w   S3MegaChopper_UpdateReturn
                move.w  a1,$44(a0)
                cmpi.b  #2,anim(a1)
                beq.s   S3MegaChopper_MarkDefeated
                cmpi.w  #1,d2
                bne.s   S3MegaChopper_AttachAndStartRingTimer
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                bset    #2,$38(a0)

S3MegaChopper_AttachAndStartRingTimer:
                movea.w (a2)+,a3
                move.w  a3,$3E(a0)
                move.w  (a3),parent3(a0)
                move.b  #6,routine(a0)
                move.w  #0,priority(a0)
                move.w  #60,$2E(a0)
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                move.b  d0,child_dx(a0)
                bclr    #0,render_flags(a0)
                tst.w   d0
                bpl.s   S3MegaChopper_SaveYOffsetAndFacing
                bset    #0,render_flags(a0)

S3MegaChopper_SaveYOffsetAndFacing:
                move.w  y_pos(a0),d0
                sub.w   y_pos(a1),d0
                move.b  d0,child_dy(a0)
                bclr    #0,$38(a0)
                btst    #0,render_flags(a1)
                beq.s   S3MegaChopper_AttachmentReturn
                bset    #0,$38(a0)

S3MegaChopper_AttachmentReturn:
                rts
; ---------------------------------------------------------------------------
S3MegaChopper_PlayerControlPairs:
                dc.w    Player_1, Ctrl_1
                dc.w    Player_2, Ctrl_2
                dc.w    Player_1, Ctrl_1
; ---------------------------------------------------------------------------

S3MegaChopper_MarkDefeated:
                bset    #7,status(a0)
                rts

; =============== S U B R O U T I N E =======================================

DrainGlobalRingFromAttachedMegaChopper:
                subq.w  #1,$2E(a0)
                bpl.s   S3MegaChopper_TryClearRingHudPulse
                move.w  #60-1,$2E(a0)
                ori.b   #1,(Update_HUD_ring_count).w
                bset    #7,$38(a0)
                move.w  (Ring_count).w,d0
                subq.w  #1,d0
                bmi.s   S3MegaChopper_KillPlayerAtRingUnderflow
                beq.s   S3MegaChopper_RequestFullRingHudUpdate
                cmpi.w  #10,(Ring_count).w
                beq.s   S3MegaChopper_RequestFullRingHudUpdate
                cmpi.w  #100,(Ring_count).w
                bne.s   S3MegaChopper_StoreRingsAndPlaySound

S3MegaChopper_RequestFullRingHudUpdate:
                ori.b   #$80,(Update_HUD_ring_count).w

S3MegaChopper_StoreRingsAndPlaySound:
                move.w  d0,(Ring_count).w
                moveq   #signextendB(sfx_RingRight),d0
                jsr     (Play_SFX).l

S3MegaChopper_RingDrainReturnZero:
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

S3MegaChopper_TryClearRingHudPulse:
                bclr    #7,$38(a0)
                beq.s   S3MegaChopper_RingDrainReturnZero
                andi.b  #$FE,(Update_HUD_ring_count).w
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

S3MegaChopper_KillPlayerAtRingUnderflow:
                movea.l a0,a2
                movea.w $44(a0),a1
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l a2,a0
                moveq   #1,d0
                rts
; End of function DrainGlobalRingFromAttachedMegaChopper

; ---------------------------------------------------------------------------
ObjDat_MegaChopper:
                dc.l    Map_MegaChopper
                dc.w    make_art_tile(ArtTile_MegaChopper,1,0)
                dc.w    $280
                dc.b    $20, $20,   0, $D7
AniRaw_MegaChopper:
                dc.b    2,   0,   1, $FC
                even
