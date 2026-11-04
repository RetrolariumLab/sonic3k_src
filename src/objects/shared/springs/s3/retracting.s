; Owner: objects/shared/springs/s3
; Responsibility: Retracting spring timing, extension states, competition variants and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_RetractingSpring:
                bsr.w   Obj_Spring
                move.b  subtype(a0),d0
                lsr.w   #3,d0
                andi.w  #$E,d0
                move.w  RetractingSpring_Index(pc,d0.w),d1
                jmp     RetractingSpring_Index(pc,d1.w)
; ---------------------------------------------------------------------------
RetractingSpring_Index:
                dc.w    S3RetractSpring_InstallNormalUp-RetractingSpring_Index
                dc.w    S3RetractSpring_InstallNormalHorizontal-RetractingSpring_Index
                dc.w    S3RetractSpring_InstallNormalDown-RetractingSpring_Index
                dc.w    S3RetractSpring_InstallNormalUpDiag-RetractingSpring_Index
                dc.w    S3RetractSpring_InstallNormalDownDiag-RetractingSpring_Index
; ---------------------------------------------------------------------------

S3RetractSpring_InstallNormalUp:
                move.l  #S3RetractingSpring_MoveNormalUpAlongY,(a0)

S3RetractingSpring_MoveNormalUpAlongY:
                bsr.w   UpdateRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_Spring_Up
; ---------------------------------------------------------------------------

S3RetractSpring_InstallNormalHorizontal:
                move.l  #S3RetractSpring_MoveNormalHorizontal,(a0)

S3RetractSpring_MoveNormalHorizontal:
                bsr.w   UpdateRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_Spring_Horizontal
; ---------------------------------------------------------------------------

S3RetractSpring_InstallNormalDown:
                move.l  #S3RetractingSpring_MoveNormalDownAlongY,(a0)

S3RetractingSpring_MoveNormalDownAlongY:
                bsr.w   UpdateRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_Spring_Down
; ---------------------------------------------------------------------------

S3RetractSpring_InstallNormalUpDiag:
                move.l  #S3RetractSpring_CalcNormalUpDiagDelta,(a0)

S3RetractSpring_CalcNormalUpDiagDelta:
                bsr.w   UpdateRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                move.w  d0,d1
                btst    #0,status(a0)
                bne.s   S3RetractSpring_MoveNormalUpDiagonal
                neg.w   d0

S3RetractSpring_MoveNormalUpDiagonal:
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                add.w   $34(a0),d1
                move.w  d1,y_pos(a0)
                bra.w   Obj_Spring_UpDiag
; ---------------------------------------------------------------------------

S3RetractSpring_InstallNormalDownDiag:
                move.l  #S3RetractSpring_CalcNormalDownDiagDelta,(a0)

S3RetractSpring_CalcNormalDownDiagDelta:
                bsr.w   UpdateRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                move.w  d0,d1
                btst    #0,status(a0)
                beq.s   S3RetractSpring_MoveNormalDownDiagonal
                neg.w   d0

S3RetractSpring_MoveNormalDownDiagonal:
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                add.w   $34(a0),d1
                move.w  d1,y_pos(a0)
                bra.w   Obj_Spring_DownDiag

; =============== S U B R O U T I N E =======================================

UpdateRetractingSpringTravel:
                tst.w   $3A(a0)
                beq.s   S3RetractSpring_TickNormalTravel
                subq.w  #1,$3A(a0)
                bne.s   S3RetractSpring_NormalTravelReturn
                tst.b   render_flags(a0)
                bpl.s   S3RetractSpring_NormalTravelReturn
                moveq   #signextendB(sfx_SpikeMove),d0
                jsr     (Play_SFX).l
                bra.s   S3RetractSpring_NormalTravelReturn
; ---------------------------------------------------------------------------

S3RetractSpring_TickNormalTravel:
                tst.w   $38(a0)
                beq.s   S3RetractSpring_ExtendNormalAndPause
                subi.w  #$800,$36(a0)
                bcc.s   S3RetractSpring_NormalTravelReturn
                move.w  #0,$36(a0)
                move.w  #0,$38(a0)
                move.w  #60,$3A(a0)
                bra.s   S3RetractSpring_NormalTravelReturn
; ---------------------------------------------------------------------------

; Advance in eight-pixel steps and pause at 32 pixels of extension
S3RetractSpring_ExtendNormalAndPause:
                addi.w  #$800,$36(a0)
                cmpi.w  #$2000,$36(a0)
                blo.s   S3RetractSpring_NormalTravelReturn
                move.w  #$2000,$36(a0)
                move.w  #1,$38(a0)
                move.w  #60,$3A(a0)

S3RetractSpring_NormalTravelReturn:
                rts
; End of function UpdateRetractingSpringTravel

; ---------------------------------------------------------------------------
S3RetractSpring_CompanionAttrs:
                dc.b    $C,   8,   0,   1
                dc.b    $C,   8,   0,   0
                dc.b    $C,   8,   0,   1
                dc.b    8,  $C,   1,   0
                dc.b    $C,   8,   2,   1
                dc.b    $C,   8,   3,   1
                dc.b    $C,   8,   2,   1
                dc.b    $C,   8,   3,   1
                even
; ---------------------------------------------------------------------------

Obj_2PRetractingSpring:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   S3RetractSpring_InitCompParent
                move.l  #S3RetractSpring_FollowParentAndTrigger,(a1)
                move.l  #Map_2PRetractingSpring,mappings(a1)
                move.w  #make_art_tile(ArtTile_2PArt_2,0,0),art_tile(a1)
                cmpi.b  #$12,(Current_zone).w
                bne.s   S3RetractSpring_InitCompanionAttrs
                move.l  #Map_2PRetractingSpring_2,mappings(a1)

S3RetractSpring_InitCompanionAttrs:
                move.b  subtype(a0),d0
                move.b  d0,subtype(a1)
                lsr.b   #2,d0
                andi.w  #$1C,d0
                lea     S3RetractSpring_CompanionAttrs(pc,d0.w),a2
                move.b  (a2)+,width_pixels(a1)
                move.b  (a2)+,height_pixels(a1)
                move.b  (a2)+,d0
                move.b  d0,mapping_frame(a1)
                bne.s   S3RetractSpring_SetSubtypeAndChildPos
                move.l  #S3RetractSpring_CheckTriggerOnlyChild,(a1)

S3RetractSpring_SetSubtypeAndChildPos:
                andi.b  #$F0,subtype(a0)
                move.b  (a2)+,d1
                or.b    d1,subtype(a0)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                moveq   #0,d2
                moveq   #0,d3
                cmpi.b  #1,d0
                bne.s   S3RetractSpring_TryOffsetCompanionDown
                moveq   #$C,d2
                btst    #0,status(a0)
                bne.s   S3RetractSpring_OffsetCompanionX
                neg.w   d2

S3RetractSpring_OffsetCompanionX:
                add.w   d2,x_pos(a1)

S3RetractSpring_TryOffsetCompanionDown:
                cmpi.b  #2,d0
                bne.s   S3RetractSpring_TryOffsetCompanionUp
                moveq   #$B,d3
                add.w   d3,y_pos(a1)

S3RetractSpring_TryOffsetCompanionUp:
                cmpi.b  #3,d0
                bne.s   S3RetractSpring_SaveOffsetsAndYFlip
                moveq   #-$B,d3
                add.w   d3,y_pos(a1)

; Save child XY offsets and latch the parent's initial Y flip before clearing its flag
S3RetractSpring_SaveOffsetsAndYFlip:
                move.w  d2,$30(a1)
                move.w  d3,$32(a1)
                bclr    #1,status(a0)
                beq.s   S3RetractSpring_CopyFlagsAndLinkChild
                move.b  #1,$3C(a0)

S3RetractSpring_CopyFlagsAndLinkChild:
                move.b  status(a0),status(a1)
                move.b  render_flags(a0),render_flags(a1)
                ori.b   #4,render_flags(a1)
                move.w  #$200,priority(a1)
                move.w  a0,$3E(a1)
                move.w  a1,$3E(a0)

S3RetractSpring_InitCompParent:
                bsr.w   InitCompetitionRetractingSpring

S3RetractSpring_DispatchCompOrientation:
                move.b  subtype(a0),d0
                lsr.w   #3,d0
                andi.w  #$E,d0
                move.w  S3RetractSpring_CompOrientationOffsets(pc,d0.w),d1
                jmp     S3RetractSpring_CompOrientationOffsets(pc,d1.w)
; ---------------------------------------------------------------------------
S3RetractSpring_CompOrientationOffsets:
                dc.w    S3RetractSpring_InstallCompUpY-S3RetractSpring_CompOrientationOffsets
                dc.w    S3RetractSpring_InstallCompHorizontalX-S3RetractSpring_CompOrientationOffsets
                dc.w    S3RetractSpring_InstallCompDownY-S3RetractSpring_CompOrientationOffsets
                dc.w    S3RetractSpring_InstallCompHorizontalY-S3RetractSpring_CompOrientationOffsets
                dc.w    S3RetractSpring_InstallCompUpX-S3RetractSpring_CompOrientationOffsets
                dc.w    S3RetractSpring_InstallCompDownX-S3RetractSpring_CompOrientationOffsets
                dc.w    S3RetractSpring_InstallCompUpX-S3RetractSpring_CompOrientationOffsets
                dc.w    S3RetractSpring_InstallCompDownX-S3RetractSpring_CompOrientationOffsets
; ---------------------------------------------------------------------------

S3RetractSpring_InstallCompUpY:
                move.l  #S3RetractSpring_MoveCompUpY,(a0)

S3RetractSpring_MoveCompUpY:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_2PSpring_Up
; ---------------------------------------------------------------------------

S3RetractSpring_InstallCompHorizontalX:
                move.l  #S3RetractSpring_MoveCompHorizontalX,(a0)

S3RetractSpring_MoveCompHorizontalX:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_2PSpring_Horizontal
; ---------------------------------------------------------------------------

S3RetractSpring_InstallCompDownY:
                move.l  #S3RetractSpring_MoveCompDownY,(a0)

S3RetractSpring_MoveCompDownY:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_2PSpring_Down
; ---------------------------------------------------------------------------

S3RetractSpring_InstallCompHorizontalY:
                move.l  #S3RetractSpring_MoveCompHorizontalY,(a0)

S3RetractSpring_MoveCompHorizontalY:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_2PSpring_Horizontal
; ---------------------------------------------------------------------------

S3RetractSpring_InstallCompUpX:
                move.l  #S3RetractSpring_MoveCompUpX,(a0)

S3RetractSpring_MoveCompUpX:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_2PSpring_Up
; ---------------------------------------------------------------------------

S3RetractSpring_InstallCompDownX:
                move.l  #S3RetractSpring_MoveCompDownX,(a0)

S3RetractSpring_MoveCompDownX:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_2PSpring_Down

; =============== S U B R O U T I N E =======================================

UpdateCompetitionRetractingSpringTravel:
                tst.b   subtype(a0)
                bmi.s   S3RetractSpring_CheckRetractedRest
                tst.w   $3A(a0)
                beq.s   S3RetractSpring_TickAutoCompTravel
                subq.w  #1,$3A(a0)
                bne.s   S3RetractSpring_AutoCompTravelReturn
                tst.b   render_flags(a0)
                bpl.s   S3RetractSpring_AutoCompTravelReturn
                moveq   #signextendB(sfx_SpikeMove),d0
                jsr     (Play_SFX).l
                bra.s   S3RetractSpring_AutoCompTravelReturn
; ---------------------------------------------------------------------------

S3RetractSpring_TickAutoCompTravel:
                tst.w   $38(a0)
                beq.s   S3RetractSpring_ExtendAutoCompTo24
                subi.w  #$800,$36(a0)
                bcc.s   S3RetractSpring_AutoCompTravelReturn
                move.w  #0,$36(a0)
                move.w  #0,$38(a0)
                move.w  #60,$3A(a0)
                bra.s   S3RetractSpring_AutoCompTravelReturn
; ---------------------------------------------------------------------------

; Use eight-pixel steps and stop at 24 pixels of extension
S3RetractSpring_ExtendAutoCompTo24:
                addi.w  #$800,$36(a0)
                cmpi.w  #$1800,$36(a0)
                blo.s   S3RetractSpring_AutoCompTravelReturn
                move.w  #$1800,$36(a0)
                move.w  #1,$38(a0)
                move.w  #60,$3A(a0)

S3RetractSpring_AutoCompTravelReturn:
                rts
; ---------------------------------------------------------------------------

; Use the initial Y flip latch to select retracted rest. The other branch rests extended
S3RetractSpring_CheckRetractedRest:
                tst.b   $3C(a0)
                beq.w   S3RetractSpring_TickExtendedRestHold
                tst.w   $3A(a0)
                beq.s   S3RetractSpring_TickTriggeredRetract
                subq.w  #1,$3A(a0)
                bne.w   S3RetractSpring_RetractedRestReturn
                move.w  #0,$38(a0)
                bra.w   S3RetractSpring_RetractedRestReturn
; ---------------------------------------------------------------------------

S3RetractSpring_TickTriggeredRetract:
                tst.w   $38(a0)
                bne.w   S3RetractSpring_ExtendTriggeredAndHold
                tst.w   $36(a0)
                beq.w   S3RetractSpring_RetractedRestReturn
                subi.w  #$800,$36(a0)
                bhi.w   S3RetractSpring_RetractedRestReturn
                move.w  #0,$36(a0)
                move.b  subtype(a0),d0
                andi.b  #$F0,d0
                cmpi.b  #$E0,d0
                bne.s   S3RetractSpring_SwapRetractedF0ToE0
                addi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$F0,subtype(a0)
                move.l  #S3RetractSpring_DispatchCompOrientation,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

; Shift Y by -$16, flip the parent and companion offset, and redispatch orientation
S3RetractSpring_SwapRetractedF0ToE0:
                cmpi.b  #$F0,d0
                bne.s   S3RetractSpring_RetractedEndpointDone
                subi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$E0,subtype(a0)
                move.l  #S3RetractSpring_DispatchCompOrientation,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

S3RetractSpring_RetractedEndpointDone:
                bra.s   S3RetractSpring_RetractedRestReturn
; ---------------------------------------------------------------------------

; At 24 pixels of extension, load the three-second hold
S3RetractSpring_ExtendTriggeredAndHold:
                addi.w  #$800,$36(a0)
                cmpi.w  #$1800,$36(a0)
                blo.s   S3RetractSpring_RetractedRestReturn
                move.w  #$1800,$36(a0)
                move.w  #3*60,$3A(a0)

S3RetractSpring_RetractedRestReturn:
                rts
; ---------------------------------------------------------------------------

S3RetractSpring_TickExtendedRestHold:
                tst.w   $3A(a0)
                beq.s   S3RetractSpring_RetractFromExtendedRest
                subq.w  #1,$3A(a0)
                bne.w   S3RetractSpring_ExtendedRestReturn
                move.w  #0,$38(a0)
                bra.w   S3RetractSpring_ExtendedRestReturn
; ---------------------------------------------------------------------------

S3RetractSpring_RetractFromExtendedRest:
                tst.w   $38(a0)
                beq.s   S3RetractSpring_RestoreExtendedRest
                subi.w  #$800,$36(a0)
                bcc.w   S3RetractSpring_ExtendedRestReturn
                move.w  #0,$36(a0)
                move.w  #3*60,$3A(a0)
                bra.w   S3RetractSpring_ExtendedRestReturn
; ---------------------------------------------------------------------------

S3RetractSpring_RestoreExtendedRest:
                cmpi.w  #$1800,$36(a0)
                beq.w   S3RetractSpring_ExtendedRestReturn
                addi.w  #$800,$36(a0)
                cmpi.w  #$1800,$36(a0)
                blo.s   S3RetractSpring_ExtendedRestReturn
                move.w  #$1800,$36(a0)
                move.b  subtype(a0),d0
                andi.b  #$F0,d0
                cmpi.b  #$E0,d0
                bne.s   S3RetractSpring_SwapExtendedF0ToE0
                addi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$F0,subtype(a0)
                move.l  #S3RetractSpring_DispatchCompOrientation,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

; Shift Y by -$16, flip the parent and companion offset, and redispatch orientation
S3RetractSpring_SwapExtendedF0ToE0:
                cmpi.b  #$F0,d0
                bne.s   S3RetractSpring_ExtendedRestReturn
                subi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$E0,subtype(a0)
                move.l  #S3RetractSpring_DispatchCompOrientation,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

S3RetractSpring_ExtendedRestReturn:
                rts
; End of function UpdateCompetitionRetractingSpringTravel

; ---------------------------------------------------------------------------

S3RetractSpring_FollowParentAndTrigger:
                movea.w $3E(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                add.w   $30(a0),d2
                add.w   $32(a0),d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                move.b  subtype(a0),d1
                bpl.s   S3RetractSpring_CollideAndDrawCompanion
                andi.w  #$F,d1
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d1.w)
                beq.s   S3RetractSpring_CollideAndDrawCompanion
                move.w  #1,$38(a1)

S3RetractSpring_CollideAndDrawCompanion:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #7,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3RetractSpring_CheckTriggerOnlyChild:
                move.b  subtype(a0),d1
                bpl.s   S3RetractSpring_TriggerOnlyReturn
                andi.w  #$F,d1
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d1.w)
                beq.s   S3RetractSpring_TriggerOnlyReturn
                movea.w $3E(a0),a1
                move.w  #1,$38(a1)

S3RetractSpring_TriggerOnlyReturn:
                rts
; ---------------------------------------------------------------------------
Map_2PRetractingSpring:
                include "src/objects/shared/level_misc/mappings/competition_retracting_spring.s"
