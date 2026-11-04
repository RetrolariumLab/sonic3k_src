; Owner: objects/ending/sk
; Responsibility: Ending companion actor states, parent-relative motion, pose progression and child cleanup
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

EndingTornado_DispatchStateAndSubSprites:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  EndingTornado_StateOffsets(pc,d0.w),d1
                jsr     EndingTornado_StateOffsets(pc,d1.w)
                bsr.w   EndingTornado_UpdateSubSprites
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
EndingTornado_StateOffsets:
                dc.w    EndTornado_InitAndConsumeScreenFlag-EndingTornado_StateOffsets
                dc.w    EndingTornado_FollowParentUntilDetached-EndingTornado_StateOffsets
                dc.w    EndTornado_WaitForApproachSignal-EndingTornado_StateOffsets
                dc.w    EndTornado_ApproachAndBobUntilBoarded-EndingTornado_StateOffsets
                dc.w    EndingTornado_BobAtSavedBaseY-EndingTornado_StateOffsets
; ---------------------------------------------------------------------------

EndTornado_InitAndConsumeScreenFlag:
                lea     EndingTornado_Attributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,$38(a0)
                beq.s   EndTornado_InitAlternateEntrance
                bclr    #2,render_flags(a0)

EndTornado_InitAlternateEntrance:
                tst.b   subtype(a0)
                beq.s   EndTornado_AdjustTailsAttachment
                move.b  #4,routine(a0)
                move.w  #$40,x_pos(a0)
                move.w  #$10B,d0
                move.w  d0,y_pos(a0)
                move.w  d0,$3A(a0)
                tst.b   (_unkFA88).w
                bmi.s   EndTornado_AdjustTailsAttachment
                lea     EndingEmeraldCarrier_ChildRecord(pc),a2
                jsr     (CreateChild1_Normal).l

EndTornado_AdjustTailsAttachment:
                cmpi.w  #2,(Player_mode).w
                bne.s   EndTornado_InitSubspritesAndAttachment
                subq.b  #4,$43(a0)

EndTornado_InitSubspritesAndAttachment:
                bset    #6,render_flags(a0)
                move.w  #2,mainspr_childsprites(a0)
                lea     EndingPlaneAttachment_ChildRecord(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

EndingTornado_FollowParentUntilDetached:
                jsr     (Child_GetPriority).l
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   EndTornado_SaveBaseYAndBeginBob
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

EndTornado_SaveBaseYAndBeginBob:
                move.b  #8,routine(a0)
                move.w  y_pos(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------

EndTornado_WaitForApproachSignal:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   EndingTornado_ReturnFromApproachWait
                move.b  #6,routine(a0)

EndingTornado_ReturnFromApproachWait:
                rts
; ---------------------------------------------------------------------------

EndTornado_ApproachAndBobUntilBoarded:
                btst    #0,(_unkFAB8).w
                bne.s   EndingTornado_ResumeParentFollowing
                addq.w  #2,x_pos(a0)
                bra.w   EndingBobYFromSavedBaseAndByteSinePhase
; ---------------------------------------------------------------------------

EndingTornado_ResumeParentFollowing:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

EndingTornado_BobAtSavedBaseY:
                bra.w   EndingBobYFromSavedBaseAndByteSinePhase
