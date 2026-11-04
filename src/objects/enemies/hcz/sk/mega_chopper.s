; Owner: objects/enemies/hcz/sk
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
                bne.s   SKMegaChopper_ScoreDefeatAndDraw
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKMegaChopper_ScoreDefeatAndDraw:
                jsr     EnemyDefeated(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
MegaChopper_Index:
                dc.w    SKMegaChopper_InitSwimmer-MegaChopper_Index
                dc.w    SKMegaChopper_AnimateAndPickSwimMotion-MegaChopper_Index
                dc.w    SKMegaChopper_UpdateLeap-MegaChopper_Index
                dc.w    SKMegaChopper_PickAttachedFrame-MegaChopper_Index
; ---------------------------------------------------------------------------

; Consume the initial vertical flip and use it to select art priority
SKMegaChopper_InitSwimmer:
                lea     ObjDat_MegaChopper(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AniRaw_MegaChopper,$30(a0)
                clr.w   child_dx(a0)                    ; and child_dy
                bclr    #1,render_flags(a0)
                beq.s   SKMegaChopper_UpdateReturn
                bset    #7,art_tile(a0)

SKMegaChopper_UpdateReturn:
                rts
; ---------------------------------------------------------------------------

SKMegaChopper_AnimateAndPickSwimMotion:
                bsr.w   SKMegaChopper_ResolveContact
                jsr     Animate_Raw(pc)
                jsr     Find_SonicTails(pc)
                move.b  (V_int_run_count+3).w,d4
                andi.b  #7,d4
                bne.s   SKMegaChopper_PickSwimOrLeap
                moveq   #1,d4
                tst.w   d1
                bne.s   SKMegaChopper_StepYTowardTarget
                neg.w   d4

SKMegaChopper_StepYTowardTarget:
                add.w   d4,y_pos(a0)

SKMegaChopper_PickSwimOrLeap:
                move.w  y_pos(a0),d4
                move.w  (Water_level).w,d5
                addq.w  #8,d5
                cmp.w   d5,d4
                bhi.s   SKMegaChopper_SwimTowardTargetX
                btst    #Status_Underwater,status(a1)
                beq.s   SKMegaChopper_PickLeapDirection

SKMegaChopper_SwimTowardTargetX:
                move.w  #$200,d0
                move.w  #8,d1
                jsr     (Chase_ObjectXOnly).l
                jsr     Change_FlipXWithVelocity(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

SKMegaChopper_PickLeapDirection:
                move.b  #4,routine(a0)
                move.w  #$200,d4
                bset    #0,render_flags(a0)
                tst.w   d0
                bne.s   SKMegaChopper_StoreLeapVelocity
                neg.w   d4
                bclr    #0,render_flags(a0)

SKMegaChopper_StoreLeapVelocity:
                move.w  d4,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKMegaChopper_UpdateLeap:
                bsr.w   SKMegaChopper_ResolveContact
                jsr     Animate_Raw(pc)
                tst.w   y_vel(a0)
                bmi.s   SKMegaChopper_ApplyLeapGravity
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.s   SKMegaChopper_ApplyLeapGravity
                move.w  y_vel(a0),d0
                addi.w  #-$20,d0
                move.w  d0,y_vel(a0)
                beq.s   SKMegaChopper_ResumeSwimming
                bmi.s   SKMegaChopper_ResumeSwimming
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

SKMegaChopper_ApplyLeapGravity:
                jmp     MoveSprite_LightGravity(pc)
; ---------------------------------------------------------------------------

SKMegaChopper_ResumeSwimming:
                move.b  #2,routine(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKMegaChopper_PickAttachedFrame:
                move.b  #0,mapping_frame(a0)
                btst    #2,(V_int_run_count+3).w
                beq.s   SKMegaChopper_CheckEscapeAndFilterInput
                move.b  #2,mapping_frame(a0)

SKMegaChopper_CheckEscapeAndFilterInput:
                movea.w $44(a0),a1
                cmpi.b  #4,routine(a1)
                beq.w   SKMegaChopper_ReleaseInputAndDetach
                cmpi.b  #2,anim(a1)
                beq.s   SKMegaChopper_ReleaseInputAndDetach
                cmpi.b  #9,anim(a1)
                beq.s   SKMegaChopper_ReleaseInputAndDetach
                jsr     Check_LRControllerShake(pc)
                bne.s   SKMegaChopper_ReleaseInputAndDetach
                btst    #2,$38(a0)
                beq.s   SKMegaChopper_FollowXAndCheckFacing
                move.w  (Ctrl_1).w,d0
                andi.w  #($8C<<8)|$8C,d0
                move.w  d0,(Ctrl_1_logical).w

SKMegaChopper_FollowXAndCheckFacing:
                move.w  x_pos(a1),d0
                move.b  child_dx(a0),d1
                ext.w   d1
                move.b  $38(a0),d2
                andi.b  #1,d2
                move.b  render_flags(a1),d3
                andi.b  #1,d3
                eor.b   d2,d3
                beq.s   SKMegaChopper_StoreXAndReadYOffset
                bchg    #0,render_flags(a0)
                bchg    #0,$38(a0)
                neg.b   child_dx(a0)

SKMegaChopper_StoreXAndReadYOffset:
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),d0
                move.b  child_dy(a0),d1
                ext.w   d1
                bpl.s   SKMegaChopper_StoreYAndDrainRings
                cmpi.b  #8,anim(a1)
                bne.s   SKMegaChopper_StoreYAndDrainRings
                addi.w  #$10,d1

SKMegaChopper_StoreYAndDrainRings:
                add.w   d1,d0
                move.w  d0,y_pos(a0)
                bsr.w   DrainGlobalRingFromAttachedMegaChopper
                beq.w   SKMegaChopper_UpdateReturn

; Clear the primary input lock only when this object owns it
SKMegaChopper_ReleaseInputAndDetach:
                bclr    #2,$38(a0)
                beq.s   SKMegaChopper_BeginDetachedFall
                clr.b   (Ctrl_1_locked).w

SKMegaChopper_BeginDetachedFall:
                move.l  #MoveChkDel,(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #$200,d0
                btst    #0,render_flags(a0)
                beq.s   SKMegaChopper_StoreDetachVelocity
                neg.w   d0

SKMegaChopper_StoreDetachVelocity:
                move.w  d0,x_vel(a0)
                move.w  #-$200,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKMegaChopper_ResolveContact:
                move.b  collision_property(a0),d0
                beq.w   SKMegaChopper_UpdateReturn
                clr.b   collision_property(a0)
                andi.w  #3,d0
                move.w  d0,d2
                lsl.w   #2,d0
                lea     SKMegaChopper_PlayerControlPairs-4(pc),a2
                lea     (a2,d0.w),a2
                movea.w (a2)+,a1
                move.w  a1,$44(a0)
                move.w  y_pos(a0),d1
                sub.w   y_pos(a1),d1
                cmpi.w  #-$10,d1
                blt.w   SKMegaChopper_UpdateReturn
                cmpi.w  #$10,d1
                bge.w   SKMegaChopper_UpdateReturn
                jsr     Check_PlayerAttack(pc)
                bne.w   SKMegaChopper_MarkDefeated
                cmpi.w  #1,d2
                bne.s   SKMegaChopper_AttachAndStartRingTimer
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                bset    #2,$38(a0)

SKMegaChopper_AttachAndStartRingTimer:
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
                bpl.s   SKMegaChopper_SaveYOffsetAndFacing
                bset    #0,render_flags(a0)

SKMegaChopper_SaveYOffsetAndFacing:
                move.w  y_pos(a0),d0
                sub.w   y_pos(a1),d0
                move.b  d0,child_dy(a0)
                bclr    #0,$38(a0)
                btst    #0,render_flags(a1)
                beq.s   SKMegaChopper_AttachmentReturn
                bset    #0,$38(a0)

SKMegaChopper_AttachmentReturn:
                rts
; ---------------------------------------------------------------------------
SKMegaChopper_PlayerControlPairs:
                dc.w    Player_1, Ctrl_1
                dc.w    Player_2, Ctrl_2
                dc.w    Player_1, Ctrl_1
; ---------------------------------------------------------------------------

SKMegaChopper_MarkDefeated:
                bset    #7,status(a0)
                rts

; =============== S U B R O U T I N E =======================================

DrainGlobalRingFromAttachedMegaChopper:
                subq.w  #1,$2E(a0)
                bpl.s   SKMegaChopper_TryClearRingHudPulse
                move.w  #60-1,$2E(a0)
                ori.b   #1,(Update_HUD_ring_count).w
                bset    #7,$38(a0)
                move.w  (Ring_count).w,d0
                subq.w  #1,d0
                bmi.s   SKMegaChopper_KillPlayerAtRingUnderflow
                beq.s   SKMegaChopper_RequestFullRingHudUpdate
                cmpi.w  #10,(Ring_count).w
                beq.s   SKMegaChopper_RequestFullRingHudUpdate
                cmpi.w  #100,(Ring_count).w
                bne.s   SKMegaChopper_StoreRingsAndPlaySound

SKMegaChopper_RequestFullRingHudUpdate:
                ori.b   #$80,(Update_HUD_ring_count).w

SKMegaChopper_StoreRingsAndPlaySound:
                move.w  d0,(Ring_count).w
                moveq   #signextendB(sfx_RingRight),d0
                jsr     (Play_SFX).l

SKMegaChopper_RingDrainReturnZero:
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

SKMegaChopper_TryClearRingHudPulse:
                bclr    #7,$38(a0)
                beq.s   SKMegaChopper_RingDrainReturnZero
                andi.b  #$FE,(Update_HUD_ring_count).w
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

SKMegaChopper_KillPlayerAtRingUnderflow:
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
