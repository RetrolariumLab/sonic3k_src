; Owner: objects/bosses/dez/final_boss/sk
; Responsibility: Death Egg final-boss attached control actors, damage flags, movement and parent synchronization
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

DEZEscapeCrane_DispatchAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DEZEscapeCrane_StateOffsets(pc,d0.w),d1
                jsr     DEZEscapeCrane_StateOffsets(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
DEZEscapeCrane_StateOffsets:
                dc.w    DEZEscapeCrane_InitializeAttributes-DEZEscapeCrane_StateOffsets
                dc.w    DEZFinal_CraneFollowUntilDefeat-DEZEscapeCrane_StateOffsets
; ---------------------------------------------------------------------------

DEZEscapeCrane_InitializeAttributes:
                lea     DEZFinalEscapeCrane_Attributes(pc),a1
                jmp     (SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

DEZFinal_CraneFollowUntilDefeat:
                btst    #3,(_unkFAB8).w
                bne.s   DEZFinal_CraneWaitThenDelete
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

; Install the deletion callback without reloading the existing timer
DEZFinal_CraneWaitThenDelete:
                move.l  #Wait_Draw,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_InitHeadHealthAndOffsets:
                lea     DEZFinalHead_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #DEZFinalHead_WaitHiddenForExposureMode,(a0)
                move.w  #$6C,$42(a0)
                move.w  #8,$44(a0)
                move.b  #8,collision_property(a0)

DEZFinalHead_WaitHiddenForExposureMode:
                tst.b   (_unkFAA9).w
                bne.s   DEZFinalHead_InstallOpeningModeUpdater
                bra.w   DEZFinalHead_TickFlashOrDefeat
; ---------------------------------------------------------------------------

DEZFinalHead_InstallOpeningModeUpdater:
                move.l  #DEZFinal_HeadDrawUntilExposed,(a0)

DEZFinal_HeadDrawUntilExposed:
                tst.b   (_unkFAA9).w
                bmi.s   DEZFinalHead_EnableVulnerableExposure
                bsr.w   DEZFinalHead_TickFlashOrDefeat
                bsr.w   DEZFinalChild_SetPosFromParent
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZFinalHead_EnableVulnerableExposure:
                move.l  #DEZFinal_HeadCheckExposedHits,(a0)
                move.b  #$16,collision_flags(a0)

DEZFinal_HeadCheckExposedHits:
                tst.b   (_unkFAA9).w
                bpl.s   DEZFinalHead_InstallClosingModeUpdater
                bsr.w   DEZFinalChild_SetPosFromParent
                bsr.w   DEZFinalHead_ProcessHitOrDefeat
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZFinalHead_InstallClosingModeUpdater:
                move.l  #DEZFinalHead_ShowInactiveUntilModeClears,(a0)

DEZFinalHead_ShowInactiveUntilModeClears:
                tst.b   (_unkFAA9).w
                beq.s   DEZFinalHead_ReturnToHiddenWait
                bsr.w   DEZFinalChild_SetPosFromParent
                bsr.w   DEZFinalHead_TickFlashOrDefeat
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

DEZFinalHead_ReturnToHiddenWait:
                move.l  #DEZFinalHead_WaitHiddenForExposureMode,(a0)
                bclr    #7,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

DEZFinal_DefeatedHeadClearBeam:
                clr.w   (Events_bg+$10).w
                bsr.w   DEZFinalChild_SetPosFromParent
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

DEZFinal_InitHeadTrigger:
                move.l  #DEZFinal_TriggerTouchOrExpose,(a0)
                move.b  #8,collision_flags(a0)
                move.b  #-1,collision_property(a0)
                move.w  #$A0,$42(a0)
                move.w  #-$34,$44(a0)

DEZFinal_TriggerTouchOrExpose:
                tst.b   collision_flags(a0)
                beq.s   DEZFinal_RequestHeadExposure
                bsr.w   DEZFinalChild_SetPosFromParent
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     Child_CheckParent(pc)
; ---------------------------------------------------------------------------

DEZFinal_RequestHeadExposure:
                move.l  #DEZFinal_WaitExposureRequestClear,(a0)
                move.b  #-1,collision_property(a0)
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                st      (Events_fg_5).w
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   DEZFinal_WaitExposureRequestClear
                move.l  #DEZFinal_InitExposureGraphic,(a1)
                move.w  parent3(a0),parent3(a1)

DEZFinal_WaitExposureRequestClear:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   DEZFinal_ExposureTriggerCheckParent
                move.l  #DEZFinal_TriggerTouchOrExpose,(a0)
                move.b  $25(a0),collision_flags(a0)

DEZFinal_ExposureTriggerCheckParent:
                jmp     Child_CheckParent(pc)
; ---------------------------------------------------------------------------

DEZFinal_InitExposureGraphic:
                lea     DEZFinalBeamGate_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #DEZFinal_OpenHeadAndTryBeam,(a0)
                bset    #0,render_flags(a0)
                move.w  #$7C,$42(a0)
                move.w  #$28,$44(a0)
                move.b  #1,(_unkFAA9).w

DEZFinal_OpenHeadAndTryBeam:
                move.w  $44(a0),d0
                addq.w  #4,d0
                move.w  d0,$44(a0)
                cmpi.w  #$68,d0
                blo.s   DEZFinal_DrawOpeningHead
                move.l  #DEZFinal_WaitForBeamCompletion,(a0)
                bset    #2,$38(a0)
                move.b  #$80,(_unkFAA9).w
                st      (Events_fg_5).w
                jsr     (AllocateObject).l
                bne.s   DEZFinal_DrawOpeningHead
                move.l  #DEZFinalBeamCharge_Initialize,(a1)
                move.w  parent3(a0),parent3(a1)
                move.w  a0,$3A(a1)

DEZFinal_DrawOpeningHead:
                bsr.w   DEZFinalChild_SetPosFromParent
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

DEZFinal_WaitForBeamCompletion:
                btst    #2,$38(a0)
                beq.s   DEZFinalHeadExposure_BeginClosingMode
                bsr.w   DEZFinalChild_SetPosFromParent
                jmp     Child_CheckParent(pc)
; ---------------------------------------------------------------------------

DEZFinalHeadExposure_BeginClosingMode:
                move.l  #DEZFinal_CloseHeadAndClearRequest,(a0)
                move.w  #$80,$2E(a0)
                move.b  #1,(_unkFAA9).w
                st      (Events_fg_5).w
                move.b  #1,(_unkFAA9).w

DEZFinal_CloseHeadAndClearRequest:
                move.w  $44(a0),d0
                subq.w  #4,d0
                move.w  d0,$44(a0)
                cmpi.w  #$28,d0
                bhi.s   DEZFinal_DrawClosingHead
                movea.w parent3(a0),a1
                bclr    #2,$38(a1)
                clr.w   $1C(a1)
                clr.b   (_unkFAA9).w
                st      (Events_fg_5).w
                jsr     (Go_Delete_Sprite).l

DEZFinal_DrawClosingHead:
                bsr.w   DEZFinalChild_SetPosFromParent
                jmp     Child_Draw_Sprite(pc)
