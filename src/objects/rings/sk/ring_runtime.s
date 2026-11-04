; Owner: objects/rings/sk
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
                dc.w    SKRingManager_InitAndChooseAxis-Load_Rings_Index
                dc.w    SKRingWindow_UpdateSparklesAndX-Load_Rings_Index
                dc.w    SKRingWindow_UpdateSparklesAndY-Load_Rings_Index
; ---------------------------------------------------------------------------

SKRingManager_InitAndChooseAxis:
                addq.b  #2,(Rings_manager_routine).w
                bsr.w   SKLevelRings_InitLayoutAndTotal
                cmpi.b  #$14,(Current_zone).w
                beq.s   SKRingWindow_InitPachinkoY
                movea.l (Ring_start_addr_ROM).w,a1
                lea     (Ring_status_table).w,a2
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   SKRingWindow_StoreInitialXStart
                moveq   #1,d4
                bra.s   SKRingWindow_StoreInitialXStart
; ---------------------------------------------------------------------------

SKRingWindow_NextInitialXStart:
                addq.w  #4,a1
                addq.w  #2,a2

SKRingWindow_StoreInitialXStart:
                cmp.w   (a1),d4
                bhi.s   SKRingWindow_NextInitialXStart
                move.l  a1,(Ring_start_addr_ROM).w
                move.w  a2,(Ring_start_addr_RAM).w
                addi.w  #$150,d4
                bra.s   SKRingWindow_StoreInitialXEnd
; ---------------------------------------------------------------------------

SKRingWindow_NextInitialXEnd:
                addq.w  #4,a1

SKRingWindow_StoreInitialXEnd:
                cmp.w   (a1),d4
                bhi.s   SKRingWindow_NextInitialXEnd
                move.l  a1,(Ring_end_addr_ROM).w
                rts
; ---------------------------------------------------------------------------

; The vertical window uses the alternate status table
SKRingWindow_InitPachinkoY:
                addq.b  #2,(Rings_manager_routine).w
                movea.l (Ring_start_addr_ROM).w,a1
                lea     (Ring_status_table_2).w,a2
                move.w  (Camera_Y_pos).w,d4
                subq.w  #8,d4
                bhi.s   SKRingWindow_StoreInitialYStart
                moveq   #1,d4
                bra.s   SKRingWindow_StoreInitialYStart
; ---------------------------------------------------------------------------

SKRingWindow_NextInitialYStart:
                addq.w  #4,a1
                addq.w  #2,a2

SKRingWindow_StoreInitialYStart:
                cmp.w   2(a1),d4
                bhi.s   SKRingWindow_NextInitialYStart
                move.l  a1,(Ring_start_addr_ROM).w
                move.w  a2,(Ring_start_addr_RAM).w
                addi.w  #$F0,d4
                bra.s   SKRingWindow_StoreInitialYEnd
; ---------------------------------------------------------------------------

SKRingWindow_NextInitialYEnd:
                addq.w  #4,a1

SKRingWindow_StoreInitialYEnd:
                cmp.w   2(a1),d4
                bhi.s   SKRingWindow_NextInitialYEnd
                move.l  a1,(Ring_end_addr_ROM).w
                rts
; ---------------------------------------------------------------------------

SKRingWindow_UpdateSparklesAndX:
                bsr.s   AdvanceQueuedRingConsumptionSparkles
                movea.l (Ring_start_addr_ROM).w,a1
                movea.w (Ring_start_addr_RAM).w,a2
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   SKRingWindow_TestXStartForward
                moveq   #1,d4
                bra.s   SKRingWindow_TestXStartForward
; ---------------------------------------------------------------------------

SKRingWindow_AdvanceXStart:
                addq.w  #4,a1
                addq.w  #2,a2

SKRingWindow_TestXStartForward:
                cmp.w   (a1),d4
                bhi.s   SKRingWindow_AdvanceXStart
                bra.s   SKRingWindow_StoreXStartAndSeekEnd
; ---------------------------------------------------------------------------

SKRingWindow_RewindXStart:
                subq.w  #4,a1
                subq.w  #2,a2

SKRingWindow_StoreXStartAndSeekEnd:
                cmp.w   -4(a1),d4
                bls.s   SKRingWindow_RewindXStart
                move.l  a1,(Ring_start_addr_ROM).w
                move.w  a2,(Ring_start_addr_RAM).w
                movea.l (Ring_end_addr_ROM).w,a2
                addi.w  #$150,d4
                bra.s   SKRingWindow_TestXEndForward
; ---------------------------------------------------------------------------

SKRingWindow_AdvanceXEnd:
                addq.w  #4,a2

SKRingWindow_TestXEndForward:
                cmp.w   (a2),d4
                bhi.s   SKRingWindow_AdvanceXEnd
                bra.s   SKRingWindow_StoreExclusiveXEnd
; ---------------------------------------------------------------------------

SKRingWindow_RewindXEnd:
                subq.w  #4,a2

SKRingWindow_StoreExclusiveXEnd:
                cmp.w   -4(a2),d4
                bls.s   SKRingWindow_RewindXEnd
                move.l  a2,(Ring_end_addr_ROM).w
                rts

; =============== S U B R O U T I N E =======================================

AdvanceQueuedRingConsumptionSparkles:
                lea     (Ring_consumption_table).w,a2
                move.w  (a2)+,d1
                subq.w  #1,d1
                bcs.s   SKRingQueue_UpdateReturn

SKRingQueue_TickSparkleHighByte:
                move.w  (a2)+,d0
                beq.s   SKRingQueue_TickSparkleHighByte
                movea.w d0,a1
                subq.b  #1,(a1)
                bne.s   SKRingQueue_NextActiveEntry
                move.b  #6,(a1)
                addq.b  #1,1(a1)
                cmpi.b  #8,1(a1)
                bne.s   SKRingQueue_NextActiveEntry
                move.w  #-1,(a1)
                clr.w   -2(a2)
                subq.w  #1,(Ring_consumption_table).w

SKRingQueue_NextActiveEntry:
                dbf     d1,SKRingQueue_TickSparkleHighByte

SKRingQueue_UpdateReturn:
                rts
; End of function AdvanceQueuedRingConsumptionSparkles

; ---------------------------------------------------------------------------

SKRingWindow_UpdateSparklesAndY:
                bsr.s   AdvanceQueuedRingConsumptionSparkles
                movea.l (Ring_start_addr_ROM).w,a1
                movea.w (Ring_start_addr_RAM).w,a2
                move.w  (Camera_Y_pos).w,d4
                subq.w  #8,d4
                bhi.s   SKRingWindow_TestYStartForward
                moveq   #1,d4
                bra.s   SKRingWindow_TestYStartForward
; ---------------------------------------------------------------------------

SKRingWindow_AdvanceYStart:
                addq.w  #4,a1
                addq.w  #2,a2

SKRingWindow_TestYStartForward:
                cmp.w   2(a1),d4
                bhi.s   SKRingWindow_AdvanceYStart
                bra.s   SKRingWindow_StoreYStartAndSeekEnd
; ---------------------------------------------------------------------------

SKRingWindow_RewindYStart:
                subq.w  #4,a1
                subq.w  #2,a2

SKRingWindow_StoreYStartAndSeekEnd:
                cmp.w   -2(a1),d4
                bls.s   SKRingWindow_RewindYStart
                move.l  a1,(Ring_start_addr_ROM).w
                move.w  a2,(Ring_start_addr_RAM).w
                movea.l (Ring_end_addr_ROM).w,a2
                addi.w  #$F0,d4
                bra.s   SKRingWindow_TestYEndForward
; ---------------------------------------------------------------------------

SKRingWindow_AdvanceYEnd:
                addq.w  #4,a2

SKRingWindow_TestYEndForward:
                cmp.w   2(a2),d4
                bhi.s   SKRingWindow_AdvanceYEnd
                bra.s   SKRingWindow_StoreExclusiveYEnd
; ---------------------------------------------------------------------------

SKRingWindow_RewindYEnd:
                subq.w  #4,a2

SKRingWindow_StoreExclusiveYEnd:
                cmp.w   -2(a2),d4
                bls.s   SKRingWindow_RewindYEnd
                move.l  a2,(Ring_end_addr_ROM).w
                rts

; =============== S U B R O U T I N E =======================================

Test_Ring_Collisions:
                cmpi.b  #90,invulnerability_timer(a0)
                bhs.w   SKRingContact_ScanReturn
                movea.l (Ring_start_addr_ROM).w,a1
                movea.l (Ring_end_addr_ROM).w,a2
                cmpa.l  a1,a2
                beq.w   SKRingContact_ScanReturn
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
                bne.w   SKRingContact_NextLayoutEntry
                move.w  (a1),d0
                sub.w   d1,d0
                sub.w   d2,d0
                bcc.s   SKRingContact_CheckWidth
                add.w   d6,d0
                bcs.s   SKRingContact_CheckYOverlap
                bra.w   SKRingContact_NextLayoutEntry
; ---------------------------------------------------------------------------

SKRingContact_CheckWidth:
                cmp.w   d4,d0
                bhi.w   SKRingContact_NextLayoutEntry

SKRingContact_CheckYOverlap:
                move.w  2(a1),d0
                sub.w   d1,d0
                sub.w   d3,d0
                bcc.s   SKRingContact_CheckHeight
                add.w   d6,d0
                bcs.s   SKRingContact_SelectPickupPath
                bra.w   SKRingContact_NextLayoutEntry
; ---------------------------------------------------------------------------

SKRingContact_CheckHeight:
                cmp.w   d5,d0
                bhi.w   SKRingContact_NextLayoutEntry

SKRingContact_SelectPickupPath:
                btst    #Status_LtngShield,status_secondary(a0)  ; does Sonic have a Lightning Shield?
                bne.s   Test_Ring_Collisions_AttractRing

SKRingContact_MarkSparkleAndCredit:
                move.w  #$604,(a4)
                bsr.s   SKLevelRings_PickupForP1
                lea     (Ring_consumption_list).w,a3

SKRingQueue_InsertFirstFree:
                tst.w   (a3)+
                bne.s   SKRingQueue_InsertFirstFree
                move.w  a4,-(a3)
                addq.w  #1,(Ring_consumption_table).w

SKRingContact_NextLayoutEntry:
                addq.w  #4,a1
                addq.w  #2,a4
                cmpa.l  a1,a2
                bne.w   Test_Ring_Collisions_NextRing

SKRingContact_ScanReturn:
                rts
; End of function Test_Ring_Collisions

; =============== S U B R O U T I N E =======================================

; Decrement the perfect-ring remainder before tail-calling the ordinary ring award
SKLevelRings_PickupForP1:
                subq.w  #1,(Perfect_rings_left).w
                jmp     (GiveRing).l
; End of function SKLevelRings_PickupForP1

; ---------------------------------------------------------------------------

Test_Ring_Collisions_AttractRing:
                movea.l a1,a3
                jsr     (AllocateObject).l
                bne.w   SKRingContact_CollectOnAllocFailure
                move.l  #Obj_Attracted_Ring,(a1)
                move.w  (a3),x_pos(a1)
                move.w  2(a3),y_pos(a1)
                move.w  a4,$30(a1)
                move.w  #-1,(a4)
                rts
; ---------------------------------------------------------------------------

SKRingContact_CollectOnAllocFailure:
                movea.l a3,a1
                bra.s   SKRingContact_MarkSparkleAndCredit

; =============== S U B R O U T I N E =======================================

; Select the current act's placement stream. Preserve consumed statuses when Respawn_table_keep is set
SKLevelRings_InitLayoutAndTotal:
                moveq   #0,d0
                tst.b   (Respawn_table_keep).w
                bne.s   SKRingManager_InitQueueClear
                lea     (Ring_status_table).w,a1
                move.w  #bytesToLcnt(Ring_status_table_end-Ring_status_table),d1

SKRingManager_ClearStatusWords:
                move.l  d0,(a1)+
                dbf     d1,SKRingManager_ClearStatusWords

SKRingManager_InitQueueClear:
                lea     (Ring_consumption_table).w,a1
                moveq   #bytesToLcnt(Ring_consumption_table_end-Ring_consumption_table),d1

SKRingManager_ClearQueueAndCheckY:
                move.l  d0,(a1)+
                dbf     d1,SKRingManager_ClearQueueAndCheckY
                cmpi.b  #$14,(Current_zone).w
                bne.s   SKRingManager_GetLayoutAndCount
                lea     (Ring_status_table_2).w,a1
                move.w  #bytesToLcnt(Ring_status_table_2_end-Ring_status_table_2),d1

SKRingManager_ClearPachinkoStatus:
                move.l  d0,(a1)+
                dbf     d1,SKRingManager_ClearPachinkoStatus

SKRingManager_GetLayoutAndCount:
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
SKRingManager_CountLayoutRings:
                tst.l   (a1)+
                bmi.s   SKRingManager_StorePerfectCount
                addq.w  #1,d5
                dbf     d0,SKRingManager_CountLayoutRings

SKRingManager_StorePerfectCount:
                move.w  d5,(Perfect_rings_left).w
                move.w  #0,(Perfect_rings_flag).w
                rts
; End of function SKLevelRings_InitLayoutAndTotal
