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
                dc.w    loc_E8BE-Load_Rings_Index
                dc.w    loc_E942-Load_Rings_Index
                dc.w    loc_E9CA-Load_Rings_Index
; ---------------------------------------------------------------------------

loc_E8BE:
                addq.b  #2,(Rings_manager_routine).w
                bsr.w   SKLevelRings_InitLayoutAndTotal
                cmpi.b  #$14,(Current_zone).w
                beq.s   loc_E904
                movea.l (Ring_start_addr_ROM).w,a1
                lea     (Ring_status_table).w,a2
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   loc_E8E6
                moveq   #1,d4
                bra.s   loc_E8E6
; ---------------------------------------------------------------------------

loc_E8E2:
                addq.w  #4,a1
                addq.w  #2,a2

loc_E8E6:
                cmp.w   (a1),d4
                bhi.s   loc_E8E2
                move.l  a1,(Ring_start_addr_ROM).w
                move.w  a2,(Ring_start_addr_RAM).w
                addi.w  #$150,d4
                bra.s   loc_E8FA
; ---------------------------------------------------------------------------

loc_E8F8:
                addq.w  #4,a1

loc_E8FA:
                cmp.w   (a1),d4
                bhi.s   loc_E8F8
                move.l  a1,(Ring_end_addr_ROM).w
                rts
; ---------------------------------------------------------------------------

loc_E904:
                addq.b  #2,(Rings_manager_routine).w
                movea.l (Ring_start_addr_ROM).w,a1
                lea     (Ring_status_table_2).w,a2
                move.w  (Camera_Y_pos).w,d4
                subq.w  #8,d4
                bhi.s   loc_E920
                moveq   #1,d4
                bra.s   loc_E920
; ---------------------------------------------------------------------------

loc_E91C:
                addq.w  #4,a1
                addq.w  #2,a2

loc_E920:
                cmp.w   2(a1),d4
                bhi.s   loc_E91C
                move.l  a1,(Ring_start_addr_ROM).w
                move.w  a2,(Ring_start_addr_RAM).w
                addi.w  #$F0,d4
                bra.s   loc_E936
; ---------------------------------------------------------------------------

loc_E934:
                addq.w  #4,a1

loc_E936:
                cmp.w   2(a1),d4
                bhi.s   loc_E934
                move.l  a1,(Ring_end_addr_ROM).w
                rts
; ---------------------------------------------------------------------------

loc_E942:
                bsr.s   AdvanceQueuedRingConsumptionSparkles
                movea.l (Ring_start_addr_ROM).w,a1
                movea.w (Ring_start_addr_RAM).w,a2
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   loc_E95C
                moveq   #1,d4
                bra.s   loc_E95C
; ---------------------------------------------------------------------------

loc_E958:
                addq.w  #4,a1
                addq.w  #2,a2

loc_E95C:
                cmp.w   (a1),d4
                bhi.s   loc_E958
                bra.s   loc_E966
; ---------------------------------------------------------------------------

loc_E962:
                subq.w  #4,a1
                subq.w  #2,a2

loc_E966:
                cmp.w   -4(a1),d4
                bls.s   loc_E962
                move.l  a1,(Ring_start_addr_ROM).w
                move.w  a2,(Ring_start_addr_RAM).w
                movea.l (Ring_end_addr_ROM).w,a2
                addi.w  #$150,d4
                bra.s   loc_E980
; ---------------------------------------------------------------------------

loc_E97E:
                addq.w  #4,a2

loc_E980:
                cmp.w   (a2),d4
                bhi.s   loc_E97E
                bra.s   loc_E988
; ---------------------------------------------------------------------------

loc_E986:
                subq.w  #4,a2

loc_E988:
                cmp.w   -4(a2),d4
                bls.s   loc_E986
                move.l  a2,(Ring_end_addr_ROM).w
                rts

; =============== S U B R O U T I N E =======================================

AdvanceQueuedRingConsumptionSparkles:
                lea     (Ring_consumption_table).w,a2
                move.w  (a2)+,d1
                subq.w  #1,d1
                bcs.s   locret_E9C8

loc_E99E:
                move.w  (a2)+,d0
                beq.s   loc_E99E
                movea.w d0,a1
                subq.b  #1,(a1)
                bne.s   loc_E9C4
                move.b  #6,(a1)
                addq.b  #1,1(a1)
                cmpi.b  #8,1(a1)
                bne.s   loc_E9C4
                move.w  #-1,(a1)
                clr.w   -2(a2)
                subq.w  #1,(Ring_consumption_table).w

loc_E9C4:
                dbf     d1,loc_E99E

locret_E9C8:
                rts
; End of function AdvanceQueuedRingConsumptionSparkles

; ---------------------------------------------------------------------------

loc_E9CA:
                bsr.s   AdvanceQueuedRingConsumptionSparkles
                movea.l (Ring_start_addr_ROM).w,a1
                movea.w (Ring_start_addr_RAM).w,a2
                move.w  (Camera_Y_pos).w,d4
                subq.w  #8,d4
                bhi.s   loc_E9E4
                moveq   #1,d4
                bra.s   loc_E9E4
; ---------------------------------------------------------------------------

loc_E9E0:
                addq.w  #4,a1
                addq.w  #2,a2

loc_E9E4:
                cmp.w   2(a1),d4
                bhi.s   loc_E9E0
                bra.s   loc_E9F0
; ---------------------------------------------------------------------------

loc_E9EC:
                subq.w  #4,a1
                subq.w  #2,a2

loc_E9F0:
                cmp.w   -2(a1),d4
                bls.s   loc_E9EC
                move.l  a1,(Ring_start_addr_ROM).w
                move.w  a2,(Ring_start_addr_RAM).w
                movea.l (Ring_end_addr_ROM).w,a2
                addi.w  #$F0,d4
                bra.s   loc_EA0A
; ---------------------------------------------------------------------------

loc_EA08:
                addq.w  #4,a2

loc_EA0A:
                cmp.w   2(a2),d4
                bhi.s   loc_EA08
                bra.s   loc_EA14
; ---------------------------------------------------------------------------

loc_EA12:
                subq.w  #4,a2

loc_EA14:
                cmp.w   -2(a2),d4
                bls.s   loc_EA12
                move.l  a2,(Ring_end_addr_ROM).w
                rts

; =============== S U B R O U T I N E =======================================

Test_Ring_Collisions:
                cmpi.b  #90,invulnerability_timer(a0)
                bhs.w   locret_EAE4
                movea.l (Ring_start_addr_ROM).w,a1
                movea.l (Ring_end_addr_ROM).w,a2
                cmpa.l  a1,a2
                beq.w   locret_EAE4
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
                bne.w   loc_EADA
                move.w  (a1),d0
                sub.w   d1,d0
                sub.w   d2,d0
                bcc.s   loc_EAA0
                add.w   d6,d0
                bcs.s   loc_EAA6
                bra.w   loc_EADA
; ---------------------------------------------------------------------------

loc_EAA0:
                cmp.w   d4,d0
                bhi.w   loc_EADA

loc_EAA6:
                move.w  2(a1),d0
                sub.w   d1,d0
                sub.w   d3,d0
                bcc.s   loc_EAB8
                add.w   d6,d0
                bcs.s   loc_EABE
                bra.w   loc_EADA
; ---------------------------------------------------------------------------

loc_EAB8:
                cmp.w   d5,d0
                bhi.w   loc_EADA

loc_EABE:
                btst    #Status_LtngShield,status_secondary(a0)  ; does Sonic have a Lightning Shield?
                bne.s   Test_Ring_Collisions_AttractRing

loc_EAC6:
                move.w  #$604,(a4)
                bsr.s   SKLevelRings_PickupForP1
                lea     (Ring_consumption_list).w,a3

loc_EAD0:
                tst.w   (a3)+
                bne.s   loc_EAD0
                move.w  a4,-(a3)
                addq.w  #1,(Ring_consumption_table).w

loc_EADA:
                addq.w  #4,a1
                addq.w  #2,a4
                cmpa.l  a1,a2
                bne.w   Test_Ring_Collisions_NextRing

locret_EAE4:
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
                bne.w   loc_EB16
                move.l  #Obj_Attracted_Ring,(a1)
                move.w  (a3),x_pos(a1)
                move.w  2(a3),y_pos(a1)
                move.w  a4,$30(a1)
                move.w  #-1,(a4)
                rts
; ---------------------------------------------------------------------------

loc_EB16:
                movea.l a3,a1
                bra.s   loc_EAC6

; =============== S U B R O U T I N E =======================================

; Select the current act's placement stream. Preserve consumed statuses when Respawn_table_keep is set
SKLevelRings_InitLayoutAndTotal:
                moveq   #0,d0
                tst.b   (Respawn_table_keep).w
                bne.s   loc_EB30
                lea     (Ring_status_table).w,a1
                move.w  #bytesToLcnt(Ring_status_table_end-Ring_status_table),d1

loc_EB2A:
                move.l  d0,(a1)+
                dbf     d1,loc_EB2A

loc_EB30:
                lea     (Ring_consumption_table).w,a1
                moveq   #bytesToLcnt(Ring_consumption_table_end-Ring_consumption_table),d1

loc_EB36:
                move.l  d0,(a1)+
                dbf     d1,loc_EB36
                cmpi.b  #$14,(Current_zone).w
                bne.s   loc_EB52
                lea     (Ring_status_table_2).w,a1
                move.w  #bytesToLcnt(Ring_status_table_2_end-Ring_status_table_2),d1

loc_EB4C:
                move.l  d0,(a1)+
                dbf     d1,loc_EB4C

loc_EB52:
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #5,d0
                lea     (RingLocPtrs).l,a1
                movea.l (a1,d0.w),a1
                move.l  a1,(Ring_start_addr_ROM).w
                addq.w  #4,a1
                moveq   #0,d5
                move.w  #511-1,d0

loc_EB70:
                tst.l   (a1)+
                bmi.s   loc_EB7A
                addq.w  #1,d5
                dbf     d0,loc_EB70

loc_EB7A:
                move.w  d5,(Perfect_rings_left).w
                move.w  #0,(Perfect_rings_flag).w
                rts
; End of function SKLevelRings_InitLayoutAndTotal
