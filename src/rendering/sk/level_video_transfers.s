; Owner: rendering/sk
; Responsibility: Level VInt drawing, VRAM operations and special window or scroll transfers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

VInt_DrawLevel:
                lea     (VDP_data_port).l,a6
                lea     (Plane_buffer).w,a0
                bsr.s   VInt_DrawLevel_2
                move.l  (Plane_buffer_2_addr).w,d0
                beq.s   VInt_DrawLevel_Return
                movea.l d0,a0
; End of function VInt_DrawLevel

; =============== S U B R O U T I N E =======================================

VInt_DrawLevel_2:
                move.w  (a0),d0
                beq.s   VInt_DrawLevel_Done
                clr.w   (a0)+
                move.w  (a0)+,d1
                bmi.s   VInt_DrawLevel_Col
                move.w  #$8F02,d2                       ; VRAM increment at 2 bytes (horizontal level write)
                move.w  #$80,d3
                bra.s   VInt_DrawLevel_Draw
; ---------------------------------------------------------------------------

VInt_DrawLevel_Col:
                move.w  #$8F80,d2                       ; VRAM increment at $80 bytes (vertical level write)
                moveq   #2,d3
                andi.w  #$7FFF,d1

VInt_DrawLevel_Draw:
                move.w  d2,VDP_control_port-VDP_data_port(a6)
                move.w  d0,d2
                move.w  d1,d4
                bsr.s   VInt_VRAMWrite
                move.w  d2,d0
                add.w   d3,d0
                move.w  d4,d1
                bsr.s   VInt_VRAMWrite
                bra.s   VInt_DrawLevel_2
; ---------------------------------------------------------------------------

VInt_DrawLevel_Done:
                move.w  #$8F02,VDP_control_port-VDP_data_port(a6)

VInt_DrawLevel_Return:
                rts
; End of function VInt_DrawLevel_2

; =============== S U B R O U T I N E =======================================

VInt_VRAMWrite:
                swap    d0
                clr.w   d0
                swap    d0
                lsl.l   #2,d0
                lsr.w   #2,d0
                ori.w   #$4000,d0
                swap    d0
                move.l  d0,VDP_control_port-VDP_data_port(a6)

                .loop:
                move.l  (a0)+,(a6)
                dbf     d1,.loop
                rts
; End of function VInt_VRAMWrite

; =============== S U B R O U T I N E =======================================

SpecialVInt_VRAMRead:
                swap    d0
                clr.w   d0
                swap    d0
                lsl.l   #2,d0
                lsr.w   #2,d0
                swap    d0
                move.l  d0,VDP_control_port-VDP_data_port(a6)

                .loop:
                move.l  (a6),(a0)+
                dbf     d1,.loop
                rts
; End of function SpecialVInt_VRAMRead

; =============== S U B R O U T I N E =======================================

VInt_DrawLevel_Competition:
                lea     (VDP_data_port).l,a6
                lea     (Plane_buffer).w,a0

SKCompVInt_TryWritePlanePair:
                move.w  (a0),d0
                beq.s   SKCompVInt_PlanePairReturn
                clr.w   (a0)+
                move.w  (a0)+,d1
                move.w  d0,d2
                move.w  d1,d4
                bsr.s   VInt_VRAMWrite
                move.w  d2,d0
                add.w   (CompetitionPairedPlaneCopyVramDelta).w,d0
                move.w  d4,d1
                bsr.s   VInt_VRAMWrite
                bra.s   SKCompVInt_TryWritePlanePair
; ---------------------------------------------------------------------------

SKCompVInt_PlanePairReturn:
                rts
; End of function VInt_DrawLevel_Competition

; =============== S U B R O U T I N E =======================================

SpecialVInt_Function:
                lea     (VDP_data_port).l,a6
                move.w  (Special_V_int_routine).w,d0
                jmp     SpecialVInt_Array(pc,d0.w)
; End of function SpecialVInt_Function

; ---------------------------------------------------------------------------

SpecialVInt_Array:
                rts                                     ; $00
                nop
; ---------------------------------------------------------------------------
                bra.w   SpecialVInt_VScrollOn           ; $04
; ---------------------------------------------------------------------------
                bra.w   SpecialVInt_VScrollCopy         ; $08
; ---------------------------------------------------------------------------
                bra.w   SpecialVInt_VScrollOff          ; $0C
; ---------------------------------------------------------------------------
                bra.w   SpecialVInt_LBZ2WindowCopy      ; $10
; ---------------------------------------------------------------------------
                bra.w   SpecialVInt_LBZ2ScrollAClear    ; $14
; ---------------------------------------------------------------------------
                bra.w   SpecialVInt_LBZ2ScrollAClear2   ; $18
; ---------------------------------------------------------------------------
                bra.w   SpecialVInt_LBZ2WindowClear     ; $1C
; ---------------------------------------------------------------------------

SpecialVInt_VScrollOn:
                move.w  #$8B07,VDP_control_port-VDP_data_port(a6)  ; Command $8B07 - VScroll cell-based, HScroll line-based
                addq.w  #4,(Special_V_int_routine).w

SpecialVInt_VScrollCopy:
                lea     (Vscroll_buffer).w,a0
                move.l  #vdpComm($0000,VSRAM,WRITE),VDP_control_port-VDP_data_port(a6)
                moveq   #$14-1,d0

                .loop:
                move.l  (a0)+,(a6)
                dbf     d0,.loop
                rts
; ---------------------------------------------------------------------------

SpecialVInt_VScrollOff:
                move.w  #$8B03,VDP_control_port-VDP_data_port(a6)  ; Command $8B03 - VScroll full, HScroll line-based
                clr.w   (Special_V_int_routine).w
                rts
; ---------------------------------------------------------------------------

SpecialVInt_LBZ2WindowCopy:
                lea     (VRAM_buffer).w,a0              ; Used specifically by the Death Egg platform at the end of LBZ2
                move.w  (Draw_delayed_rowcount).w,d0
                addi.w  #$D,d0
                andi.w  #$1F,d0
                lsl.w   #7,d0
                addi.w  #VRAM_Plane_A_Name_Table,d0
                move.w  d0,d2
                addi.w  #$64,d0
                moveq   #7-1,d1
                jsr     SpecialVInt_VRAMRead(pc)        ; Grabs the nametable area of the Death Egg platform
                move.w  d2,d0
                moveq   #$19-1,d1
                jsr     SpecialVInt_VRAMRead(pc)
                lea     (VRAM_buffer).w,a0
                move.w  (Draw_delayed_rowcount).w,d0
                lsl.w   #7,d0
                addi.w  #$8000,d0
                moveq   #$20-1,d1
                jsr     VInt_VRAMWrite(pc)              ; Copies the pertinent data from scroll A to the window nametable
                subq.w  #1,(Draw_delayed_rowcount).w    ; Do this (EECA) number of times
                bpl.s   .return
                addq.w  #4,(Special_V_int_routine).w

                .return:
                rts
; ---------------------------------------------------------------------------

SpecialVInt_LBZ2ScrollAClear:
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$900,VRAM,WRITE),(VDP_control_port).l  ; VRAM base $C900
                moveq   #0,d0
                moveq   #$60-1,d1

                .loop:
                move.l  d0,(a6)                         ; Clear 6 cell lines from VRAM A for when it scrolls upward
                move.l  d0,(a6)
                dbf     d1,.loop
                move.w  #$8320,VDP_control_port-VDP_data_port(a6)  ; VRAM command $8320 - Window at base address $8000
                move.w  #$9285,VDP_control_port-VDP_data_port(a6)  ; VRAM command $9285 - Window starts 5 cells down from top
                clr.w   (Special_V_int_routine).w
                rts
; ---------------------------------------------------------------------------

SpecialVInt_LBZ2ScrollAClear2:
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$600,VRAM,WRITE),(VDP_control_port).l  ; VRAM base $C600
                moveq   #0,d0
                moveq   #$60-1,d1

                .loop:
                move.l  d0,(a6)                         ; Erase remainder of upper area of VRAM A
                move.l  d0,(a6)
                dbf     d1,.loop
                addq.w  #4,(Special_V_int_routine).w
                rts
; ---------------------------------------------------------------------------

SpecialVInt_LBZ2WindowClear:
                lea     (VRAM_buffer).w,a0
                move.w  #$829C,d0
                moveq   #$19-1,d1
                jsr     SpecialVInt_VRAMRead(pc)
                move.w  #$8280,d0
                moveq   #7-1,d1
                jsr     SpecialVInt_VRAMRead(pc)        ; Copy from window data. Luckily, all 6 cell lines are identical so it only needs to be done once
                move.l  #vdpComm(VRAM_Plane_A_Name_Table+$900,VRAM,WRITE),(VDP_control_port).l  ; VRAM position $C900
                moveq   #6-1,d0

; Replay the same buffered row at each of the six window rows
SKCompVInt_RestoreWindowRow:
                lea     (VRAM_buffer).w,a0
                moveq   #$10-1,d1

SKCompVInt_CopyWindowCellPair:
                move.l  (a0)+,(a6)
                move.l  (a0)+,(a6)                      ; Write cell lines back to Scroll A
                dbf     d1,SKCompVInt_CopyWindowCellPair
                dbf     d0,SKCompVInt_RestoreWindowRow
                move.w  #$9200,VDP_control_port-VDP_data_port(a6)  ; VRAM command $9200 - Zero out window position
                clr.w   (Special_V_int_routine).w
                rts
