; Owner: objects/rings/s3
; Responsibility: Ring manager initialization, camera-window streaming, player collection and attraction response
; Source provenance and ranges: config/reconstruction/source_layout.json
Load_Rings:
                moveq   #0,d0
                move.b  (Rings_manager_routine).w,d0
                move.w  Load_Rings_Index(pc,d0.w),d0
                jmp     Load_Rings_Index(pc,d0.w)
; End of function Load_Rings

; ---------------------------------------------------------------------------
Load_Rings_Index:
                dc.w    S3RingManager_InitAndSeekWindow-Load_Rings_Index
                dc.w    S3RingQueue_InitActiveLoop-Load_Rings_Index
; ---------------------------------------------------------------------------

S3RingManager_InitAndSeekWindow:
                addq.b  #2,(Rings_manager_routine).w
                bsr.w   S3LevelRings_InitLayoutAndTotal
                movea.l (Ring_start_addr_ROM).w,a1
                lea     (Ring_status_table).w,a2
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   S3RingWindow_StoreInitialStart
                moveq   #1,d4
                bra.s   S3RingWindow_StoreInitialStart
; ---------------------------------------------------------------------------

S3RingWindow_NextInitialStart:
                addq.w  #4,a1
                addq.w  #2,a2

S3RingWindow_StoreInitialStart:
                cmp.w   (a1),d4
                bhi.s   S3RingWindow_NextInitialStart
                move.l  a1,(Ring_start_addr_ROM).w
                move.w  a2,(Ring_start_addr_RAM).w
                addi.w  #$150,d4
                bra.s   S3RingWindow_StoreInitialEnd
; ---------------------------------------------------------------------------

S3RingWindow_NextInitialEnd:
                addq.w  #4,a1

S3RingWindow_StoreInitialEnd:
                cmp.w   (a1),d4
                bhi.s   S3RingWindow_NextInitialEnd
                move.l  a1,(Ring_end_addr_ROM).w
                rts
; ---------------------------------------------------------------------------

S3RingQueue_InitActiveLoop:
                lea     (Ring_consumption_table).w,a2
                move.w  (a2)+,d1
                subq.w  #1,d1
                bcs.s   S3RingWindow_GetCameraStartX

S3RingQueue_TickAndRetireSparkle:
                move.w  (a2)+,d0
                beq.s   S3RingQueue_TickAndRetireSparkle
                movea.w d0,a1
                subq.b  #1,(a1)
                bne.s   S3RingQueue_RepeatActiveLoop
                move.b  #6,(a1)
                addq.b  #1,1(a1)
                cmpi.b  #8,1(a1)
                bne.s   S3RingQueue_RepeatActiveLoop
                move.w  #-1,(a1)
                clr.w   -2(a2)
                subq.w  #1,(Ring_consumption_table).w

S3RingQueue_RepeatActiveLoop:
                dbf     d1,S3RingQueue_TickAndRetireSparkle

S3RingWindow_GetCameraStartX:
                movea.l (Ring_start_addr_ROM).w,a1
                movea.w (Ring_start_addr_RAM).w,a2
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   S3Rings_TestForwardLeftWindowSeek
                moveq   #1,d4
                bra.s   S3Rings_TestForwardLeftWindowSeek
; ---------------------------------------------------------------------------

S3RingWindow_AdvanceStart:
                addq.w  #4,a1
                addq.w  #2,a2

S3Rings_TestForwardLeftWindowSeek:
                cmp.w   (a1),d4
                bhi.s   S3RingWindow_AdvanceStart
                bra.s   S3RingWindow_StoreStartAndSeekEnd
; ---------------------------------------------------------------------------

S3RingWindow_RewindStart:
                subq.w  #4,a1
                subq.w  #2,a2

S3RingWindow_StoreStartAndSeekEnd:
                cmp.w   -4(a1),d4
                bls.s   S3RingWindow_RewindStart
                move.l  a1,(Ring_start_addr_ROM).w
                move.w  a2,(Ring_start_addr_RAM).w
                movea.l (Ring_end_addr_ROM).w,a2
                addi.w  #$150,d4
                bra.s   S3Rings_TestForwardRightWindowSeek
; ---------------------------------------------------------------------------

S3RingWindow_AdvanceEnd:
                addq.w  #4,a2

S3Rings_TestForwardRightWindowSeek:
                cmp.w   (a2),d4
                bhi.s   S3RingWindow_AdvanceEnd
                bra.s   S3RingWindow_StoreExclusiveEnd
; ---------------------------------------------------------------------------

S3RingWindow_RewindEnd:
                subq.w  #4,a2

S3RingWindow_StoreExclusiveEnd:
                cmp.w   -4(a2),d4
                bls.s   S3RingWindow_RewindEnd
                move.l  a2,(Ring_end_addr_ROM).w
                rts

; =============== S U B R O U T I N E =======================================

Test_Ring_Collisions:
                cmpi.b  #90,invulnerability_timer(a0)
                bhs.w   S3Rings_ReturnAfterRingScanOrEntryGuard
                movea.l (Ring_start_addr_ROM).w,a1
                movea.l (Ring_end_addr_ROM).w,a2
                cmpa.l  a1,a2
                beq.w   S3Rings_ReturnAfterRingScanOrEntryGuard
                movea.w (Ring_start_addr_RAM).w,a4
                btst    #Status_LtngShield,status_secondary(a0)  ; does Sonic have a Lightning Shield?
                beq.s   Test_Ring_Collisions_NoAttraction
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$40,d2
                subi.w  #$40,d3
                move.w  #6,d1
                move.w  #$C,d6
                move.w  #$80,d4
                move.w  #$80,d5
                bra.s   Test_Ring_Collisions_NextRing
; ---------------------------------------------------------------------------

Test_Ring_Collisions_NoAttraction:
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #8,d2
                moveq   #0,d5
                move.b  y_radius(a0),d5
                subq.b  #3,d5
                sub.w   d5,d3
                move.w  #6,d1
                move.w  #$C,d6
                move.w  #$10,d4
                add.w   d5,d5

Test_Ring_Collisions_NextRing:
                tst.w   (a4)
                bne.w   S3RingContact_NextLayoutEntry
                move.w  (a1),d0
                sub.w   d1,d0
                sub.w   d2,d0
                bcc.s   S3RingContact_CheckWidth
                add.w   d6,d0
                bcs.s   S3RingContact_CheckYOverlap
                bra.w   S3RingContact_NextLayoutEntry
; ---------------------------------------------------------------------------

S3RingContact_CheckWidth:
                cmp.w   d4,d0
                bhi.w   S3RingContact_NextLayoutEntry

S3RingContact_CheckYOverlap:
                move.w  2(a1),d0
                sub.w   d1,d0
                sub.w   d3,d0
                bcc.s   S3RingContact_CheckHeight
                add.w   d6,d0
                bcs.s   S3RingContact_SelectPickupPath
                bra.w   S3RingContact_NextLayoutEntry
; ---------------------------------------------------------------------------

S3RingContact_CheckHeight:
                cmp.w   d5,d0
                bhi.w   S3RingContact_NextLayoutEntry

S3RingContact_SelectPickupPath:
                btst    #Status_LtngShield,status_secondary(a0)  ; does Sonic have a Lightning Shield?
                bne.s   Test_Ring_Collisions_AttractRing

S3RingContact_MarkSparkleAndCredit:
                move.w  #$604,(a4)
                bsr.s   S3LevelRings_PickupForP1
                lea     (Ring_consumption_table+2).w,a3

S3RingQueue_InsertFirstFree:
                tst.w   (a3)+
                bne.s   S3RingQueue_InsertFirstFree
                move.w  a4,-(a3)
                addq.w  #1,(Ring_consumption_table).w

S3RingContact_NextLayoutEntry:
                addq.w  #4,a1
                addq.w  #2,a4
                cmpa.l  a1,a2
                bne.w   Test_Ring_Collisions_NextRing

S3Rings_ReturnAfterRingScanOrEntryGuard:
                rts
; End of function Test_Ring_Collisions

; =============== S U B R O U T I N E =======================================

; Decrement the perfect-ring remainder before tail-calling the ordinary ring award
S3LevelRings_PickupForP1:
                subq.w  #1,(Perfect_rings_left).w
                jmp     (GiveRing).l
; End of function S3LevelRings_PickupForP1

; ---------------------------------------------------------------------------

Test_Ring_Collisions_AttractRing:
                movea.l a1,a3
                jsr     (AllocateObject).l
                bne.w   S3RingContact_CollectOnAllocFailure
                move.l  #Obj_Attracted_Ring,(a1)
                move.w  (a3),x_pos(a1)
                move.w  2(a3),y_pos(a1)
                move.w  a4,$30(a1)
                move.w  #-1,(a4)
                rts
; ---------------------------------------------------------------------------

S3RingContact_CollectOnAllocFailure:
                movea.l a3,a1
                bra.s   S3RingContact_MarkSparkleAndCredit

; =============== S U B R O U T I N E =======================================

; Select the current act's placement stream. Preserve consumed statuses when Respawn_table_keep is set
S3LevelRings_InitLayoutAndTotal:
                moveq   #0,d0
                tst.b   (Respawn_table_keep).w
                bne.s   S3RingManager_InitQueueClear
                lea     (Ring_status_table).w,a1
                move.w  #bytesToLcnt(Ring_status_table_end-Ring_status_table),d1

S3RingManager_ClearStatusWords:
                move.l  d0,(a1)+
                dbf     d1,S3RingManager_ClearStatusWords

S3RingManager_InitQueueClear:
                lea     (Ring_consumption_table).w,a1
                moveq   #bytesToLcnt(Ring_consumption_table_end-Ring_consumption_table),d1

S3RingManager_ClearQueueAndGetLayout:
                move.l  d0,(a1)+
                dbf     d1,S3RingManager_ClearQueueAndGetLayout
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #5,d0
                lea     (RingLocPtrs).l,a1
                movea.l (a1,d0.w),a1
                move.l  a1,(Ring_start_addr_ROM).w
                addq.w  #4,a1
                moveq   #0,d5
                move.w  #511-1,d0

; Count at most 511 records and stop at the negative long sentinel
S3RingManager_CountLayoutRings:
                tst.l   (a1)+
                bmi.s   S3RingManager_StorePerfectCount
                addq.w  #1,d5
                dbf     d0,S3RingManager_CountLayoutRings

S3RingManager_StorePerfectCount:
                move.w  d5,(Perfect_rings_left).w
                move.w  #0,(Perfect_rings_flag).w
                rts
; End of function S3LevelRings_InitLayoutAndTotal
