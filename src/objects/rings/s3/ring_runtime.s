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
                dc.w    loc_F604-Load_Rings_Index
                dc.w    loc_F642-Load_Rings_Index
; ---------------------------------------------------------------------------

loc_F604:
                addq.b  #2,(Rings_manager_routine).w
                bsr.w   LevelRingsS3ResetStatusSelectLayoutAndCountPerfectRings
                movea.l (Ring_start_addr_ROM).w,a1
                lea     (Ring_status_table).w,a2
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   loc_F624
                moveq   #1,d4
                bra.s   loc_F624
; ---------------------------------------------------------------------------

loc_F620:
                addq.w  #4,a1
                addq.w  #2,a2

loc_F624:
                cmp.w   (a1),d4
                bhi.s   loc_F620
                move.l  a1,(Ring_start_addr_ROM).w
                move.w  a2,(Ring_start_addr_RAM).w
                addi.w  #$150,d4
                bra.s   loc_F638
; ---------------------------------------------------------------------------

loc_F636:
                addq.w  #4,a1

loc_F638:
                cmp.w   (a1),d4
                bhi.s   loc_F636
                move.l  a1,(Ring_end_addr_ROM).w
                rts
; ---------------------------------------------------------------------------

loc_F642:
                lea     (Ring_consumption_table).w,a2
                move.w  (a2)+,d1
                subq.w  #1,d1
                bcs.s   loc_F676

loc_F64C:
                move.w  (a2)+,d0
                beq.s   loc_F64C
                movea.w d0,a1
                subq.b  #1,(a1)
                bne.s   loc_F672
                move.b  #6,(a1)
                addq.b  #1,1(a1)
                cmpi.b  #8,1(a1)
                bne.s   loc_F672
                move.w  #-1,(a1)
                clr.w   -2(a2)
                subq.w  #1,(Ring_consumption_table).w

loc_F672:
                dbf     d1,loc_F64C

loc_F676:
                movea.l (Ring_start_addr_ROM).w,a1
                movea.w (Ring_start_addr_RAM).w,a2
                move.w  (Camera_X_pos).w,d4
                subq.w  #8,d4
                bhi.s   loc_F68E
                moveq   #1,d4
                bra.s   loc_F68E
; ---------------------------------------------------------------------------

loc_F68A:
                addq.w  #4,a1
                addq.w  #2,a2

loc_F68E:
                cmp.w   (a1),d4
                bhi.s   loc_F68A
                bra.s   loc_F698
; ---------------------------------------------------------------------------

loc_F694:
                subq.w  #4,a1
                subq.w  #2,a2

loc_F698:
                cmp.w   -4(a1),d4
                bls.s   loc_F694
                move.l  a1,(Ring_start_addr_ROM).w
                move.w  a2,(Ring_start_addr_RAM).w
                movea.l (Ring_end_addr_ROM).w,a2
                addi.w  #$150,d4
                bra.s   loc_F6B2
; ---------------------------------------------------------------------------

loc_F6B0:
                addq.w  #4,a2

loc_F6B2:
                cmp.w   (a2),d4
                bhi.s   loc_F6B0
                bra.s   loc_F6BA
; ---------------------------------------------------------------------------

loc_F6B8:
                subq.w  #4,a2

loc_F6BA:
                cmp.w   -4(a2),d4
                bls.s   loc_F6B8
                move.l  a2,(Ring_end_addr_ROM).w
                rts

; =============== S U B R O U T I N E =======================================

Test_Ring_Collisions:
                cmpi.b  #90,invulnerability_timer(a0)
                bhs.w   locret_F78A
                movea.l (Ring_start_addr_ROM).w,a1
                movea.l (Ring_end_addr_ROM).w,a2
                cmpa.l  a1,a2
                beq.w   locret_F78A
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
                bne.w   loc_F780
                move.w  (a1),d0
                sub.w   d1,d0
                sub.w   d2,d0
                bcc.s   loc_F746
                add.w   d6,d0
                bcs.s   loc_F74C
                bra.w   loc_F780
; ---------------------------------------------------------------------------

loc_F746:
                cmp.w   d4,d0
                bhi.w   loc_F780

loc_F74C:
                move.w  2(a1),d0
                sub.w   d1,d0
                sub.w   d3,d0
                bcc.s   loc_F75E
                add.w   d6,d0
                bcs.s   loc_F764
                bra.w   loc_F780
; ---------------------------------------------------------------------------

loc_F75E:
                cmp.w   d5,d0
                bhi.w   loc_F780

loc_F764:
                btst    #Status_LtngShield,status_secondary(a0)  ; does Sonic have a Lightning Shield?
                bne.s   Test_Ring_Collisions_AttractRing

loc_F76C:
                move.w  #$604,(a4)
                bsr.s   LevelRingsS3CountPerfectPickupAndGiveP1Ring
                lea     (Ring_consumption_table+2).w,a3

loc_F776:
                tst.w   (a3)+
                bne.s   loc_F776
                move.w  a4,-(a3)
                addq.w  #1,(Ring_consumption_table).w

loc_F780:
                addq.w  #4,a1
                addq.w  #2,a4
                cmpa.l  a1,a2
                bne.w   Test_Ring_Collisions_NextRing

locret_F78A:
                rts
; End of function Test_Ring_Collisions

; =============== S U B R O U T I N E =======================================

LevelRingsS3CountPerfectPickupAndGiveP1Ring:
                subq.w  #1,(Perfect_rings_left).w
                jmp     (GiveRing).l
; End of function LevelRingsS3CountPerfectPickupAndGiveP1Ring

; ---------------------------------------------------------------------------

Test_Ring_Collisions_AttractRing:
                movea.l a1,a3
                jsr     (AllocateObject).l
                bne.w   loc_F7BC
                move.l  #Obj_Attracted_Ring,(a1)
                move.w  (a3),x_pos(a1)
                move.w  2(a3),y_pos(a1)
                move.w  a4,$30(a1)
                move.w  #-1,(a4)
                rts
; ---------------------------------------------------------------------------

loc_F7BC:
                movea.l a3,a1
                bra.s   loc_F76C

; =============== S U B R O U T I N E =======================================

LevelRingsS3ResetStatusSelectLayoutAndCountPerfectRings:
                moveq   #0,d0
                tst.b   (Respawn_table_keep).w
                bne.s   loc_F7D6
                lea     (Ring_status_table).w,a1
                move.w  #bytesToLcnt(Ring_status_table_end-Ring_status_table),d1

loc_F7D0:
                move.l  d0,(a1)+
                dbf     d1,loc_F7D0

loc_F7D6:
                lea     (Ring_consumption_table).w,a1
                moveq   #bytesToLcnt(Ring_consumption_table_end-Ring_consumption_table),d1

loc_F7DC:
                move.l  d0,(a1)+
                dbf     d1,loc_F7DC
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #5,d0
                lea     (RingLocPtrs).l,a1
                movea.l (a1,d0.w),a1
                move.l  a1,(Ring_start_addr_ROM).w
                addq.w  #4,a1
                moveq   #0,d5
                move.w  #511-1,d0

loc_F800:
                tst.l   (a1)+
                bmi.s   loc_F80A
                addq.w  #1,d5
                dbf     d0,loc_F800

loc_F80A:
                move.w  d5,(Perfect_rings_left).w
                move.w  #0,(Perfect_rings_flag).w
                rts
; End of function LevelRingsS3ResetStatusSelectLayoutAndCountPerfectRings
