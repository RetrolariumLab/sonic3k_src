; Owner: objects/zones/mgz/top_platform/s3
; Responsibility: Marble Garden spinning top scripted loop entry, constrained path traversal and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

TryEnterTopPlatformScriptedSinePath:
                tst.w   (Debug_placement_mode).w
                bne.s   S3MGZTopPath_EntryScanReturn
                tst.b   $34(a0)
                beq.s   S3MGZTopPath_EntryScanReturn
                lea     (S3MGZTopPath_Act1EntryRecords).l,a1
                tst.b   (Current_act).w
                beq.s   S3MGZTopPath_BeginActEntryScan
                lea     (S3MGZTopPath_Act2EntryRecords).l,a1

S3MGZTopPath_BeginActEntryScan:
                move.w  (a1)+,d6
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3

S3MGZTopPath_CheckEntryWindowAndSpeed:
                move.w  (a1),d0
                sub.w   d2,d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   S3MGZTopPath_NextEntryRecord
                move.w  2(a1),d1
                sub.w   d3,d1
                addi.w  #$10,d1
                cmpi.w  #$20,d1
                bhs.s   S3MGZTopPath_NextEntryRecord
                move.w  ground_vel(a0),d0
                move.b  4(a1),d2
                andi.b  #$7F,d2
                beq.s   S3MGZTopPath_TryAcceptEntryDirection
                neg.w   d0

S3MGZTopPath_TryAcceptEntryDirection:
                tst.w   d0
                bpl.s   S3MGZTopPath_BeginEntryApproach

S3MGZTopPath_NextEntryRecord:
                adda.w  #$10,a1
                dbf     d6,S3MGZTopPath_CheckEntryWindowAndSpeed

S3MGZTopPath_EntryScanReturn:
                rts
; ---------------------------------------------------------------------------

S3MGZTopPath_BeginEntryApproach:
                move.b  #1,$35(a0)
                move.w  4(a1),$3E(a0)
                addq.w  #6,a1
                move.w  (a1)+,d4
                move.w  d4,$30(a0)
                move.w  (a1)+,d5
                move.w  d5,d0
                move.b  $3F(a0),d1
                andi.b  #$7F,d1
                beq.s   S3MGZTopPath_SaveBaselineAndExitCursor
                sub.w   (a1),d0

S3MGZTopPath_SaveBaselineAndExitCursor:
                move.w  d0,$32(a0)
                move.l  a1,$36(a0)
                move.w  ground_vel(a0),d2
                bpl.s   S3MGZTopPath_UseDefaultEntrySpeed
                neg.w   d2

S3MGZTopPath_UseDefaultEntrySpeed:
                tst.w   d2
                bne.s   S3MGZTopPath_CalcApproachDeltaX
                move.w  #$800,d2

S3MGZTopPath_CalcApproachDeltaX:
                moveq   #0,d0
                move.w  d2,d3
                move.w  d4,d0
                sub.w   x_pos(a0),d0
                bge.s   S3MGZTopPath_CalcApproachDeltaY
                neg.w   d0
                neg.w   d2

S3MGZTopPath_CalcApproachDeltaY:
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a0),d1
                bge.s   S3MGZTopPath_SolveYDominantApproach
                neg.w   d1
                neg.w   d3

S3MGZTopPath_SolveYDominantApproach:
                cmp.w   d0,d1
                blo.s   S3MGZTopPath_SolveXDominantApproach
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a0),d1
                swap    d1
                divs.w  d3,d1
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a0),d0
                beq.s   S3MGZTopPath_StoreYDominantVelocity
                swap    d0
                divs.w  d1,d0

S3MGZTopPath_StoreYDominantVelocity:
                move.w  d0,x_vel(a0)
                move.w  d3,y_vel(a0)
                tst.w   d1
                bpl.s   S3MGZTopPath_StoreYDominantDuration
                neg.w   d1

S3MGZTopPath_StoreYDominantDuration:
                move.w  d1,$3A(a0)
                rts
; ---------------------------------------------------------------------------

S3MGZTopPath_SolveXDominantApproach:
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a0),d0
                swap    d0
                divs.w  d2,d0
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a0),d1
                beq.s   S3MGZTopPath_StoreXDominantVelocity
                swap    d1
                divs.w  d0,d1

S3MGZTopPath_StoreXDominantVelocity:
                move.w  d1,y_vel(a0)
                move.w  d2,x_vel(a0)
                tst.w   d0
                bpl.s   S3MGZTopPath_StoreXDominantDuration
                neg.w   d0

S3MGZTopPath_StoreXDominantDuration:
                move.w  d0,$3A(a0)
                rts
; End of function TryEnterTopPlatformScriptedSinePath

; ---------------------------------------------------------------------------
S3MGZTopPath_Act1EntryRecords:  dc.w    7-1
                dc.w    $1BA0,   $C6,     0, $1C40,   $E6,  $280, $1CE0,  $385
                dc.w    $1BA0,  $3C4, $8001, $1C40,  $3A6,  $2C0, $1BA0,   $C6
                dc.w    $1CE0,  $385,  $101, $1C40,  $366,  $280, $1BA0,   $C6
                dc.w    $2720,  $846,     0, $27C0,  $866,  $200, $2860,  $A86
                dc.w    $2860,  $846,  $180, $27C0,  $866,  $200, $2720,  $A86
                dc.w    $2720,  $A86,   $81, $27C0,  $A66,  $200, $2860,  $846
                dc.w    $2860,  $A86,  $101, $27C0,  $A66,  $200, $2720,  $846
S3MGZTopPath_Act2EntryRecords:  dc.w    7-1
                dc.w    $1760,  $546, $8180, $16C0,  $566,  $140, $1760,  $6C5
                dc.w    $1760,  $6C5, $8181, $16C0,  $6A6,  $140, $1760,  $546
                dc.w    $1620,  $6C4,   $81, $16C0,  $6C6,  $180, $1760,  $546
                dc.w    $2AA0,  $444, $8000, $2B40,  $466,  $2C0, $2AA0,  $744
                dc.w    $2BE0,  $446, $8180, $2B40,  $466,  $2C0, $2BE0,  $746
                dc.w    $2AA0,  $744, $8001, $2B40,  $726,  $2C0, $2AA0,  $444
                dc.w    $2BE0,  $746, $8181, $2B40,  $726,  $2C0, $2BE0,  $446

; =============== S U B R O U T I N E =======================================

UpdateTopPlatformScriptedSinePath:
                cmpi.b  #2,$35(a0)
                beq.s   S3MGZTopPath_CalcAngleFromProgress
                subq.b  #1,$3A(a0)
                bpl.s   S3MGZTopPath_StepLinearApproach
                cmpi.b  #3,$35(a0)
                beq.s   S3MGZTopPath_TryReverseExitSpeed
                move.w  #0,$3C(a0)
                move.b  #2,$35(a0)
                movea.l $36(a0),a1
                move.w  (a1)+,d0
                move.w  d0,$2E(a0)
                move.b  $3F(a0),d1
                andi.b  #$7F,d1
                beq.s   S3MGZTopPath_BeginSineTraversal
                move.w  d0,$3C(a0)

S3MGZTopPath_BeginSineTraversal:
                move.l  a1,$36(a0)
                bra.s   S3MGZTopPath_CalcAngleFromProgress
; ---------------------------------------------------------------------------

S3MGZTopPath_StepLinearApproach:
                move.l  x_pos(a0),d2
                move.l  y_pos(a0),d3
                move.w  x_vel(a0),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d2
                move.w  y_vel(a0),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3
                move.l  d2,x_pos(a0)
                move.l  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

S3MGZTopPath_TryReverseExitSpeed:
                tst.b   $3E(a0)
                bpl.s   S3MGZTopPath_ClearScriptedPhase
                neg.w   ground_vel(a0)

S3MGZTopPath_ClearScriptedPhase:
                move.b  #0,$35(a0)
                rts
; ---------------------------------------------------------------------------

S3MGZTopPath_CalcAngleFromProgress:
                move.w  $3C(a0),d0
                add.w   d0,d0
                tst.b   $3F(a0)
                bpl.s   S3MGZTopPath_PlaceOnSinePath
                neg.w   d0

S3MGZTopPath_PlaceOnSinePath:
                jsr     (GetSineCosine).l
                muls.w  #$5800,d0
                swap    d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                move.w  $32(a0),d0
                add.w   $3C(a0),d0
                move.w  d0,y_pos(a0)
                moveq   #2,d1
                move.w  ground_vel(a0),d0
                bpl.s   S3MGZTopPath_TryFastTraversalStep
                neg.w   d0

; Use step 3 only when absolute ground speed is exactly $C00
S3MGZTopPath_TryFastTraversalStep:
                cmpi.w  #$C00,d0
                bne.s   S3MGZTopPath_StepReverseProgress
                moveq   #3,d1

S3MGZTopPath_StepReverseProgress:
                move.b  $3F(a0),d0
                andi.b  #$7F,d0
                beq.s   S3MGZTopPath_StepForwardProgress
                sub.w   d1,$3C(a0)
                bgt.s   S3MGZTopPath_TraversalReturn
                bra.s   S3MGZTopPath_BeginLinearExit
; ---------------------------------------------------------------------------

S3MGZTopPath_StepForwardProgress:
                add.w   d1,$3C(a0)
                move.w  $2E(a0),d0
                cmp.w   $3C(a0),d0
                bhi.s   S3MGZTopPath_TraversalReturn

S3MGZTopPath_BeginLinearExit:
                move.b  #3,$35(a0)
                movea.l $36(a0),a2
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  ground_vel(a0),d2
                bpl.s   S3MGZTopPath_UseDefaultExitSpeed
                neg.w   d2

S3MGZTopPath_UseDefaultExitSpeed:
                tst.w   d2
                bne.s   S3MGZTopPath_CalcExitVector
                move.w  #$800,d2

S3MGZTopPath_CalcExitVector:
                bra.w   S3MGZTopPath_CalcApproachDeltaX
; ---------------------------------------------------------------------------

S3MGZTopPath_TraversalReturn:
                rts
; End of function UpdateTopPlatformScriptedSinePath

; ---------------------------------------------------------------------------
Map_MGZTopPlatform:
                include "src/objects/shared/zones/mgz/mappings/top_platform.s"
