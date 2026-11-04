; Owner: objects/bosses/ssz/mtz/sk
; Responsibility: Sky Sanctuary Metropolis-style boss child motion, player contact and orb animation decoder
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SSZMTZOrb_SelectFrameAndPriority:
                move.w  $3A(a0),d0
                bmi.s   SSZMTZ_OrbSelectNegativeDepth
                cmpi.w  #$C,d0
                blt.s   SSZMTZ_OrbSelectNearDepthFrame
                move.b  #0,mapping_frame(a0)
                move.w  #$80,priority(a0)
                rts
; ---------------------------------------------------------------------------

SSZMTZ_OrbSelectNearDepthFrame:
                move.b  #1,mapping_frame(a0)
                move.w  #$100,priority(a0)
                rts
; ---------------------------------------------------------------------------

SSZMTZ_OrbSelectNegativeDepth:
                cmpi.w  #-$C,d0
                blt.s   SSZMTZOrbDepth_SelectFarNegativeFrame
                move.b  #1,mapping_frame(a0)
                move.w  #$300,priority(a0)
                rts
; ---------------------------------------------------------------------------

SSZMTZOrbDepth_SelectFarNegativeFrame:
                move.b  #2,mapping_frame(a0)
                move.w  #$380,priority(a0)
                rts
; End of function SSZMTZOrb_SelectFrameAndPriority

; ---------------------------------------------------------------------------

SSZMTZ_OrbTickFlightTouchDelay:
                tst.b   $3C(a0)
                bmi.s   SSZMTZ_OrbMoveWithReducedGravity
                subq.b  #1,$3C(a0)
                bpl.s   SSZMTZ_OrbMoveWithReducedGravity
                move.b  #$C6,collision_flags(a0)

SSZMTZ_OrbMoveWithReducedGravity:
                jsr     (MoveSprite).l
                subi.w  #$20,y_vel(a0)
                cmpi.w  #$180,y_vel(a0)
                blt.s   SSZMTZDetachedOrb_TestFixedLandingHeight
                move.w  #$180,y_vel(a0)

SSZMTZDetachedOrb_TestFixedLandingHeight:
                tst.w   y_vel(a0)
                bmi.s   SSZMTZ_OrbCheckFlightContact
                cmpi.w  #$42C,y_pos(a0)
                blo.s   SSZMTZ_OrbCheckFlightContact
                move.w  #$42C,y_pos(a0)
                move.w  #$42C,$38(a0)
                move.b  #1,$32(a0)
                addq.b  #2,routine(a0)
                bsr.w   SSZMTZOrb_FaceP1OnLanding

SSZMTZ_OrbCheckFlightContact:
                bsr.w   SSZMTZOrb_HandleContactOrDefeat

SSZMTZ_OrbAnimateAndTouchDraw:
                lea     Ani_SSZMTZOrbs(pc),a1
                jsr     (Animate_Sprite).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
; unused
                tst.b   collision_property(a0)
                beq.s   SSZMTZDetachedOrb_LegacyContactReturn
                move.b  #$E,mapping_frame(a0)
                move.b  #6,anim(a0)
                addq.b  #2,routine(a0)

SSZMTZDetachedOrb_LegacyContactReturn:
                rts
; ---------------------------------------------------------------------------

SSZMTZ_OrbTickHopTouchDelay:
                tst.b   $3C(a0)
                bmi.s   SSZMTZ_OrbCheckHopContactAndFrame
                subq.b  #1,$3C(a0)
                bpl.s   SSZMTZ_OrbCheckHopContactAndFrame
                move.b  #$DA,collision_flags(a0)

SSZMTZ_OrbCheckHopContactAndFrame:
                bsr.w   SSZMTZOrb_HandleContactOrDefeat
                cmpi.b  #8,mapping_frame(a0)
                bne.s   SSZMTZ_OrbAnimateAndTouchDraw
                move.b  $32(a0),d0
                jsr     (GetSineCosine).l
                neg.w   d0
                asr.w   #2,d0
                add.w   $38(a0),d0
                cmpi.w  #$42C,d0
                bhs.s   SSZMTZ_OrbRestartHopAtFloor
                move.w  d0,y_pos(a0)
                addq.b  #1,$32(a0)
                btst    #0,$32(a0)
                beq.s   SSZMTZ_OrbHopTouchDraw
                moveq   #-1,d0
                btst    #0,render_flags(a0)
                beq.s   SSZMTZDetachedOrb_ApplyOnePixelHopStep
                neg.w   d0

SSZMTZDetachedOrb_ApplyOnePixelHopStep:
                add.w   d0,x_pos(a0)

SSZMTZ_OrbHopTouchDraw:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SSZMTZ_OrbRestartHopAtFloor:
                move.w  #$42C,y_pos(a0)
                bsr.w   SSZMTZOrb_FaceP1OnLanding
                move.b  #1,$32(a0)
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

SSZMTZOrb_FaceP1OnLanding:
                move.w  (Player_1+x_pos).w,d0
                sub.w   x_pos(a0),d0
                bpl.s   SSZMTZ_OrbFacePlayerDelta
                bclr    #0,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

SSZMTZ_OrbFacePlayerDelta:
                bset    #0,render_flags(a0)
                rts
; End of function SSZMTZOrb_FaceP1OnLanding

; =============== S U B R O U T I N E =======================================

; Consume the contact accumulator to select the player response. The boss defeat signal also starts orb removal
SSZMTZOrb_HandleContactOrDefeat:
                moveq   #0,d0
                move.b  collision_property(a0),d0
                bne.s   SSZMTZ_OrbCheckPlayerAttack
                tst.b   (EndingOutcomeOrBossSceneSignals).w
                bne.s   SSZMTZDetachedOrb_SelectPopState
                rts
; ---------------------------------------------------------------------------

SSZMTZ_OrbCheckPlayerAttack:
                clr.b   collision_property(a0)
                andi.b  #3,d0
                add.w   d0,d0
                movea.w SSZMTZDetachedOrb_ContactPlayerAddresses(pc,d0.w),a1
                tst.b   $34(a1)
                bne.w   SSZMTZBoss_ReturnFromSetupOrSharedPolicy
                jsr     (Check_PlayerAttack).l
                bne.s   SSZMTZDetachedOrb_SelectPopState
                jsr     (HurtCharacter_Directly).l

SSZMTZDetachedOrb_SelectPopState:
                clr.b   collision_flags(a0)
                move.b  #$E,mapping_frame(a0)
                move.b  #6,anim(a0)
                move.b  #8,routine(a0)
                rts
; End of function SSZMTZOrb_HandleContactOrDefeat

; ---------------------------------------------------------------------------
SSZMTZDetachedOrb_ContactPlayerAddresses:
                dc.w    Player_1
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_2
; ---------------------------------------------------------------------------

SSZMTZ_OrbPopAndDecReleaseCount:
                moveq   #signextendB(sfx_Balloon),d0
                jsr     (Play_SFX).l
                movea.l $34(a0),a1
                subi.b  #1,$30(a1)
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

; This routine comes from Sonic 2, and is used in Sky Sanctuary by Mecha
; Sonic cosplaying as the Metropolis Zone boss
; sub_7B12E:
Boss_MoveObject:
                move.l  (SSZ_MTZ_boss_X_pos).w,d2
                move.l  (SSZ_MTZ_boss_Y_pos).w,d3
                move.w  (SSZ_MTZ_boss_X_vel).w,d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d2
                move.w  (SSZ_MTZ_boss_Y_vel).w,d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3
                move.l  d2,(SSZ_MTZ_boss_X_pos).w
                move.l  d3,(SSZ_MTZ_boss_Y_pos).w
                rts
; End of function Boss_MoveObject

; ---------------------------------------------------------------------------
; unused
                moveq   #0,d6
                movea.l a1,a4
                lea     (SceneTimerOrSharedMotionRecordBase).w,a2
                lea     mapping_frame(a0),a3
                tst.b   (a3)
                bne.s   SSZMTZ_PackedAnimReadMainSlot
                addq.w  #2,a2
                bra.s   SSZMTZ_PackedAnimLoadChildSlots
; ---------------------------------------------------------------------------

SSZMTZ_PackedAnimReadMainSlot:
                bsr.w   DecodeLegacySSZMTZPackedAnimationSlots

SSZMTZ_PackedAnimLoadChildSlots:
                moveq   #0,d6
                move.b  mainspr_childsprites(a0),d6
                subq.w  #1,d6
                bmi.s   SSZMTZ_PackedAnimSlotLoopReturn
                lea     sub2_mapframe(a0),a3

; =============== S U B R O U T I N E =======================================

DecodeLegacySSZMTZPackedAnimationSlots:
                movea.l a4,a1
                moveq   #0,d0
                moveq   #0,d1
                moveq   #0,d2
                moveq   #0,d4
                move.b  (a2)+,d0
                move.b  d0,d1
                lsr.b   #4,d1
                andi.b  #$F,d0
                move.b  d0,d2
                cmp.b   d0,d1
                beq.s   SSZMTZ_PackedAnimReadCursorAndDelay
                st      d4

SSZMTZ_PackedAnimReadCursorAndDelay:
                move.b  d0,d5
                lsl.b   #4,d5
                or.b    d0,d5
                move.b  (a2)+,d0
                move.b  d0,d1
                lsr.b   #4,d1
                tst.b   d4
                beq.s   SSZMTZ_PackedAnimTickOrFetchToken
                moveq   #0,d0
                moveq   #0,d1

SSZMTZ_PackedAnimTickOrFetchToken:
                andi.b  #$F,d0
                subi.b  #1,d0
                bpl.s   SSZMTZ_PackedAnimStoreSlot
                add.w   d2,d2
                adda.w  (a1,d2.w),a1
                move.b  (a1),d0
                move.b  1(a1,d1.w),d2
                bmi.s   SSZMTZLegacyAnimation_TestRestartCommand

SSZMTZ_PackedAnimWriteFrameAndStep:
                andi.b  #$7F,d2
                move.b  d2,(a3)
                addi.b  #1,d1

SSZMTZ_PackedAnimStoreSlot:
                lsl.b   #4,d1
                or.b    d1,d0
                move.b  d0,-1(a2)
                move.b  d5,-2(a2)
                adda.w  #next_subspr,a3
                dbf     d6,DecodeLegacySSZMTZPackedAnimationSlots

SSZMTZ_PackedAnimSlotLoopReturn:
                rts
; ---------------------------------------------------------------------------

SSZMTZLegacyAnimation_TestRestartCommand:
                addq.b  #1,d2
                bne.s   SSZMTZ_PackedAnimCheckAdvanceOwner
                move.b  #0,d1
                move.b  1(a1),d2
                bra.s   SSZMTZ_PackedAnimWriteFrameAndStep
; ---------------------------------------------------------------------------

SSZMTZ_PackedAnimCheckAdvanceOwner:
                addq.b  #1,d2
                bne.s   SSZMTZ_PackedAnimCheckChangeAnim
                addi.b  #2,$26(a0)
                rts
; ---------------------------------------------------------------------------

SSZMTZ_PackedAnimCheckChangeAnim:
                addq.b  #1,d2
                bne.s   SSZMTZ_PackedAnimCheckSetCursor
                andi.b  #$F0,d5
                or.b    2(a1,d1.w),d5
                bra.s   SSZMTZ_PackedAnimStoreSlot
; ---------------------------------------------------------------------------

SSZMTZ_PackedAnimCheckSetCursor:
                addq.b  #1,d2
                bne.s   SSZMTZ_PackedAnimUnknownCmdReturn
                moveq   #0,d3
                move.b  2(a1,d1.w),d1
                move.b  1(a1,d1.w),d2
                bra.s   SSZMTZ_PackedAnimWriteFrameAndStep
; ---------------------------------------------------------------------------

SSZMTZ_PackedAnimUnknownCmdReturn:
                rts
; End of function DecodeLegacySSZMTZPackedAnimationSlots
