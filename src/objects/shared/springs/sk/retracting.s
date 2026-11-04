; Owner: objects/shared/springs/sk
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
                dc.w    SKRetractSpring_InstallNormalUp-RetractingSpring_Index
                dc.w    SKRetractSpring_InstallNormalHorizontal-RetractingSpring_Index
                dc.w    SKRetractSpring_InstallNormalDown-RetractingSpring_Index
                dc.w    SKRetractSpring_InstallNormalUpDiag-RetractingSpring_Index
                dc.w    SKRetractSpring_InstallNormalDownDiag-RetractingSpring_Index
; ---------------------------------------------------------------------------

SKRetractSpring_InstallNormalUp:
                move.l  #SKRetractingSpring_MoveNormalUpAlongY,(a0)

SKRetractingSpring_MoveNormalUpAlongY:
                bsr.w   UpdateRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_Spring_Up
; ---------------------------------------------------------------------------

SKRetractSpring_InstallNormalHorizontal:
                move.l  #SKRetractSpring_MoveNormalHorizontal,(a0)

SKRetractSpring_MoveNormalHorizontal:
                bsr.w   UpdateRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_Spring_Horizontal
; ---------------------------------------------------------------------------

SKRetractSpring_InstallNormalDown:
                move.l  #SKRetractingSpring_MoveNormalDownAlongY,(a0)

SKRetractingSpring_MoveNormalDownAlongY:
                bsr.w   UpdateRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_Spring_Down
; ---------------------------------------------------------------------------

SKRetractSpring_InstallNormalUpDiag:
                move.l  #SKRetractSpring_CalcNormalUpDiagDelta,(a0)

SKRetractSpring_CalcNormalUpDiagDelta:
                bsr.w   UpdateRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                move.w  d0,d1
                btst    #0,status(a0)
                bne.s   SKRetractSpring_MoveNormalUpDiagonal
                neg.w   d0

SKRetractSpring_MoveNormalUpDiagonal:
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                add.w   $34(a0),d1
                move.w  d1,y_pos(a0)
                bra.w   Obj_Spring_UpDiag
; ---------------------------------------------------------------------------

SKRetractSpring_InstallNormalDownDiag:
                move.l  #SKRetractSpring_CalcNormalDownDiagDelta,(a0)

SKRetractSpring_CalcNormalDownDiagDelta:
                bsr.w   UpdateRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                move.w  d0,d1
                btst    #0,status(a0)
                beq.s   SKRetractSpring_MoveNormalDownDiagonal
                neg.w   d0

SKRetractSpring_MoveNormalDownDiagonal:
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                add.w   $34(a0),d1
                move.w  d1,y_pos(a0)
                bra.w   Obj_Spring_DownDiag

; =============== S U B R O U T I N E =======================================

UpdateRetractingSpringTravel:
                tst.w   $3A(a0)
                beq.s   SKRetractSpring_TickNormalTravel
                subq.w  #1,$3A(a0)
                bne.s   SKRetractSpring_NormalTravelReturn
                tst.b   render_flags(a0)
                bpl.s   SKRetractSpring_NormalTravelReturn
                moveq   #signextendB(sfx_SpikeMove),d0
                jsr     (Play_SFX).l
                bra.s   SKRetractSpring_NormalTravelReturn
; ---------------------------------------------------------------------------

SKRetractSpring_TickNormalTravel:
                tst.w   $38(a0)
                beq.s   SKRetractSpring_ExtendNormalAndPause
                subi.w  #$800,$36(a0)
                bcc.s   SKRetractSpring_NormalTravelReturn
                move.w  #0,$36(a0)
                move.w  #0,$38(a0)
                move.w  #60,$3A(a0)
                bra.s   SKRetractSpring_NormalTravelReturn
; ---------------------------------------------------------------------------

; Advance in eight-pixel steps and pause at 32 pixels of extension
SKRetractSpring_ExtendNormalAndPause:
                addi.w  #$800,$36(a0)
                cmpi.w  #$2000,$36(a0)
                blo.s   SKRetractSpring_NormalTravelReturn
                move.w  #$2000,$36(a0)
                move.w  #1,$38(a0)
                move.w  #60,$3A(a0)

SKRetractSpring_NormalTravelReturn:
                rts
; End of function UpdateRetractingSpringTravel

; ---------------------------------------------------------------------------
SKRetractSpring_CompanionAttrs:
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
                bne.w   SKRetractSpring_InitCompParent
                move.l  #SKRetractSpring_FollowParentAndTrigger,(a1)
                move.l  #Map_2PRetractingSpring,mappings(a1)
                move.w  #make_art_tile(ArtTile_2PArt_2,0,0),art_tile(a1)
                cmpi.b  #$12,(Current_zone).w
                bne.s   SKRetractSpring_InitCompanionAttrs
                move.l  #Map_2PRetractingSpring_2,mappings(a1)

SKRetractSpring_InitCompanionAttrs:
                move.b  subtype(a0),d0
                move.b  d0,subtype(a1)
                lsr.b   #2,d0
                andi.w  #$1C,d0
                lea     SKRetractSpring_CompanionAttrs(pc,d0.w),a2
                move.b  (a2)+,width_pixels(a1)
                move.b  (a2)+,height_pixels(a1)
                move.b  (a2)+,d0
                move.b  d0,mapping_frame(a1)
                bne.s   SKRetractSpring_SetSubtypeAndChildPos
                move.l  #SKRetractSpring_CheckTriggerOnlyChild,(a1)

SKRetractSpring_SetSubtypeAndChildPos:
                andi.b  #$F0,subtype(a0)
                move.b  (a2)+,d1
                or.b    d1,subtype(a0)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                moveq   #0,d2
                moveq   #0,d3
                cmpi.b  #1,d0
                bne.s   SKRetractSpring_TryOffsetCompanionDown
                moveq   #$C,d2
                btst    #0,status(a0)
                bne.s   SKRetractSpring_OffsetCompanionX
                neg.w   d2

SKRetractSpring_OffsetCompanionX:
                add.w   d2,x_pos(a1)

SKRetractSpring_TryOffsetCompanionDown:
                cmpi.b  #2,d0
                bne.s   SKRetractSpring_TryOffsetCompanionUp
                moveq   #$B,d3
                add.w   d3,y_pos(a1)

SKRetractSpring_TryOffsetCompanionUp:
                cmpi.b  #3,d0
                bne.s   SKRetractSpring_SaveOffsetsAndYFlip
                moveq   #-$B,d3
                add.w   d3,y_pos(a1)

; Save child XY offsets and latch the parent's initial Y flip before clearing its flag
SKRetractSpring_SaveOffsetsAndYFlip:
                move.w  d2,$30(a1)
                move.w  d3,$32(a1)
                bclr    #1,status(a0)
                beq.s   SKRetractSpring_CopyFlagsAndLinkChild
                move.b  #1,$3C(a0)

SKRetractSpring_CopyFlagsAndLinkChild:
                move.b  status(a0),status(a1)
                move.b  render_flags(a0),render_flags(a1)
                ori.b   #4,render_flags(a1)
                move.w  #$200,priority(a1)
                move.w  a0,$3E(a1)
                move.w  a1,$3E(a0)

SKRetractSpring_InitCompParent:
                bsr.w   InitCompetitionRetractingSpring

SKRetractSpring_DispatchCompOrientation:
                move.b  subtype(a0),d0
                lsr.w   #3,d0
                andi.w  #$E,d0
                move.w  SKRetractSpring_CompOrientationOffsets(pc,d0.w),d1
                jmp     SKRetractSpring_CompOrientationOffsets(pc,d1.w)
; ---------------------------------------------------------------------------
SKRetractSpring_CompOrientationOffsets:
                dc.w    SKRetractSpring_InstallCompUpY-SKRetractSpring_CompOrientationOffsets
                dc.w    SKRetractSpring_InstallCompHorizontalX-SKRetractSpring_CompOrientationOffsets
                dc.w    SKRetractSpring_InstallCompDownY-SKRetractSpring_CompOrientationOffsets
                dc.w    SKRetractSpring_InstallCompHorizontalY-SKRetractSpring_CompOrientationOffsets
                dc.w    SKRetractSpring_InstallCompUpX-SKRetractSpring_CompOrientationOffsets
                dc.w    SKRetractSpring_InstallCompDownX-SKRetractSpring_CompOrientationOffsets
                dc.w    SKRetractSpring_InstallCompUpX-SKRetractSpring_CompOrientationOffsets
                dc.w    SKRetractSpring_InstallCompDownX-SKRetractSpring_CompOrientationOffsets
; ---------------------------------------------------------------------------

SKRetractSpring_InstallCompUpY:
                move.l  #SKRetractSpring_MoveCompUpY,(a0)

SKRetractSpring_MoveCompUpY:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_2PSpring_Up
; ---------------------------------------------------------------------------

SKRetractSpring_InstallCompHorizontalX:
                move.l  #SKRetractSpring_MoveCompHorizontalX,(a0)

SKRetractSpring_MoveCompHorizontalX:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_2PSpring_Horizontal
; ---------------------------------------------------------------------------

SKRetractSpring_InstallCompDownY:
                move.l  #SKRetractSpring_MoveCompDownY,(a0)

SKRetractSpring_MoveCompDownY:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_2PSpring_Down
; ---------------------------------------------------------------------------

SKRetractSpring_InstallCompHorizontalY:
                move.l  #SKRetractSpring_MoveCompHorizontalY,(a0)

SKRetractSpring_MoveCompHorizontalY:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_2PSpring_Horizontal
; ---------------------------------------------------------------------------

SKRetractSpring_InstallCompUpX:
                move.l  #SKRetractSpring_MoveCompUpX,(a0)

SKRetractSpring_MoveCompUpX:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_2PSpring_Up
; ---------------------------------------------------------------------------

SKRetractSpring_InstallCompDownX:
                move.l  #SKRetractSpring_MoveCompDownX,(a0)

SKRetractSpring_MoveCompDownX:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_2PSpring_Down

; =============== S U B R O U T I N E =======================================

UpdateCompetitionRetractingSpringTravel:
                tst.b   subtype(a0)
                bmi.s   SKRetractSpring_CheckRetractedRest
                tst.w   $3A(a0)
                beq.s   SKRetractSpring_TickAutoCompTravel
                subq.w  #1,$3A(a0)
                bne.s   SKRetractSpring_AutoCompTravelReturn
                tst.b   render_flags(a0)
                bpl.s   SKRetractSpring_AutoCompTravelReturn
                moveq   #signextendB(sfx_SpikeMove),d0
                jsr     (Play_SFX).l
                bra.s   SKRetractSpring_AutoCompTravelReturn
; ---------------------------------------------------------------------------

SKRetractSpring_TickAutoCompTravel:
                tst.w   $38(a0)
                beq.s   SKRetractSpring_ExtendAutoCompTo24
                subi.w  #$800,$36(a0)
                bcc.s   SKRetractSpring_AutoCompTravelReturn
                move.w  #0,$36(a0)
                move.w  #0,$38(a0)
                move.w  #60,$3A(a0)
                bra.s   SKRetractSpring_AutoCompTravelReturn
; ---------------------------------------------------------------------------

; Use eight-pixel steps and stop at 24 pixels of extension
SKRetractSpring_ExtendAutoCompTo24:
                addi.w  #$800,$36(a0)
                cmpi.w  #$1800,$36(a0)
                blo.s   SKRetractSpring_AutoCompTravelReturn
                move.w  #$1800,$36(a0)
                move.w  #1,$38(a0)
                move.w  #60,$3A(a0)

SKRetractSpring_AutoCompTravelReturn:
                rts
; ---------------------------------------------------------------------------

; Use the initial Y flip latch to select retracted rest. The other branch rests extended
SKRetractSpring_CheckRetractedRest:
                tst.b   $3C(a0)
                beq.w   SKRetractSpring_TickExtendedRestHold
                tst.w   $3A(a0)
                beq.s   SKRetractSpring_TickTriggeredRetract
                subq.w  #1,$3A(a0)
                bne.w   SKRetractSpring_RetractedRestReturn
                move.w  #0,$38(a0)
                bra.w   SKRetractSpring_RetractedRestReturn
; ---------------------------------------------------------------------------

SKRetractSpring_TickTriggeredRetract:
                tst.w   $38(a0)
                bne.w   SKRetractSpring_ExtendTriggeredAndHold
                tst.w   $36(a0)
                beq.w   SKRetractSpring_RetractedRestReturn
                subi.w  #$800,$36(a0)
                bhi.w   SKRetractSpring_RetractedRestReturn
                move.w  #0,$36(a0)
                move.b  subtype(a0),d0
                andi.b  #$F0,d0
                cmpi.b  #$E0,d0
                bne.s   SKRetractSpring_SwapRetractedF0ToE0
                addi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$F0,subtype(a0)
                move.l  #SKRetractSpring_DispatchCompOrientation,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

; Shift Y by -$16, flip the parent and companion offset, and redispatch orientation
SKRetractSpring_SwapRetractedF0ToE0:
                cmpi.b  #$F0,d0
                bne.s   SKRetractSpring_RetractedEndpointDone
                subi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$E0,subtype(a0)
                move.l  #SKRetractSpring_DispatchCompOrientation,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

SKRetractSpring_RetractedEndpointDone:
                bra.s   SKRetractSpring_RetractedRestReturn
; ---------------------------------------------------------------------------

; At 24 pixels of extension, load the three-second hold
SKRetractSpring_ExtendTriggeredAndHold:
                addi.w  #$800,$36(a0)
                cmpi.w  #$1800,$36(a0)
                blo.s   SKRetractSpring_RetractedRestReturn
                move.w  #$1800,$36(a0)
                move.w  #3*60,$3A(a0)

SKRetractSpring_RetractedRestReturn:
                rts
; ---------------------------------------------------------------------------

SKRetractSpring_TickExtendedRestHold:
                tst.w   $3A(a0)
                beq.s   SKRetractSpring_RetractFromExtendedRest
                subq.w  #1,$3A(a0)
                bne.w   SKRetractSpring_ExtendedRestReturn
                move.w  #0,$38(a0)
                bra.w   SKRetractSpring_ExtendedRestReturn
; ---------------------------------------------------------------------------

SKRetractSpring_RetractFromExtendedRest:
                tst.w   $38(a0)
                beq.s   SKRetractSpring_RestoreExtendedRest
                subi.w  #$800,$36(a0)
                bcc.w   SKRetractSpring_ExtendedRestReturn
                move.w  #0,$36(a0)
                move.w  #3*60,$3A(a0)
                bra.w   SKRetractSpring_ExtendedRestReturn
; ---------------------------------------------------------------------------

SKRetractSpring_RestoreExtendedRest:
                cmpi.w  #$1800,$36(a0)
                beq.w   SKRetractSpring_ExtendedRestReturn
                addi.w  #$800,$36(a0)
                cmpi.w  #$1800,$36(a0)
                blo.s   SKRetractSpring_ExtendedRestReturn
                move.w  #$1800,$36(a0)
                move.b  subtype(a0),d0
                andi.b  #$F0,d0
                cmpi.b  #$E0,d0
                bne.s   SKRetractSpring_SwapExtendedF0ToE0
                addi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$F0,subtype(a0)
                move.l  #SKRetractSpring_DispatchCompOrientation,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

; Shift Y by -$16, flip the parent and companion offset, and redispatch orientation
SKRetractSpring_SwapExtendedF0ToE0:
                cmpi.b  #$F0,d0
                bne.s   SKRetractSpring_ExtendedRestReturn
                subi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$E0,subtype(a0)
                move.l  #SKRetractSpring_DispatchCompOrientation,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

SKRetractSpring_ExtendedRestReturn:
                rts
; End of function UpdateCompetitionRetractingSpringTravel

; ---------------------------------------------------------------------------

SKRetractSpring_FollowParentAndTrigger:
                movea.w $3E(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                add.w   $30(a0),d2
                add.w   $32(a0),d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                move.b  subtype(a0),d1
                bpl.s   SKRetractSpring_CollideAndDrawCompanion
                andi.w  #$F,d1
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d1.w)
                beq.s   SKRetractSpring_CollideAndDrawCompanion
                move.w  #1,$38(a1)

SKRetractSpring_CollideAndDrawCompanion:
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

SKRetractSpring_CheckTriggerOnlyChild:
                move.b  subtype(a0),d1
                bpl.s   SKRetractSpring_TriggerOnlyReturn
                andi.w  #$F,d1
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d1.w)
                beq.s   SKRetractSpring_TriggerOnlyReturn
                movea.w $3E(a0),a1
                move.w  #1,$38(a1)

SKRetractSpring_TriggerOnlyReturn:
                rts
; ---------------------------------------------------------------------------
Map_2PRetractingSpring:
                include "src/objects/shared/level_misc/mappings/competition_retracting_spring.s"
