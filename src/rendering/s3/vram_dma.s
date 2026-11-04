; Owner: rendering/s3; responsibility: vram dma
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Copies a plane map to a plane PNT
; Inputs:
; a1 = map address
; d0 = VDP command to write to the PNT
; d1 = number of cells in a row - 1
; d2 = number of cell rows - 1
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Plane_Map_To_VRAM:
                lea     (VDP_data_port).l,a6
                move.l  #$80<<16,d4                     ; row increment value

S3PlaneMap_BeginRowForSixtyFourCellPlane:
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                move.w  d1,d3

S3PlaneMap_CopyRow64:
                move.w  (a1)+,(a6)
                dbf     d3,S3PlaneMap_CopyRow64         ; copy one row
                add.l   d4,d0                           ; move onto next row
                dbf     d2,S3PlaneMap_BeginRowForSixtyFourCellPlane  ; and copy it
                rts
; End of function Plane_Map_To_VRAM

; ---------------------------------------------------------------------------
; Copies a plane map to a plane PNT, used for a 128-cell wide plane
; Inputs:
; a1 = map address
; d0 = VDP command to write to the PNT
; d1 = number of cells in a row - 1
; d2 = number of cell rows - 1
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Plane_Map_To_VRAM_2:
                lea     (VDP_data_port).l,a6
                move.l  #$100<<16,d4                    ; row increment value

S3PlaneMap_BeginRow128:
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                move.w  d1,d3

S3PlaneMap_CopyTileWordsForWidePlaneRow:
                move.w  (a1)+,(a6)
                dbf     d3,S3PlaneMap_CopyTileWordsForWidePlaneRow  ; copy one row
                add.l   d4,d0                           ; move onto next row
                dbf     d2,S3PlaneMap_BeginRow128       ; and copy it
                rts
; End of function Plane_Map_To_VRAM_2

; ---------------------------------------------------------------------------
; Adds art to the DMA queue
; Inputs:
; d1 = source address
; d2 = destination VRAM address
; d3 = number of words to transfer
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Add_To_DMA_Queue:
                movea.l (DMA_queue_slot).w,a1
                cmpa.w  #DMA_queue_slot,a1              ; is the queue full?
                beq.s   Add_To_DMA_Queue_Done           ; if it is, return

                move.w  #$9300,d0
                move.b  d3,d0
                move.w  d0,(a1)+                        ; command to specify transfer length in words & $00FF

                move.w  #$9400,d0
                lsr.w   #8,d3
                move.b  d3,d0
                move.w  d0,(a1)+                        ; command to specify transfer length in words & $FF00

                move.w  #$9500,d0
                lsr.l   #1,d1
                move.b  d1,d0
                move.w  d0,(a1)+                        ; command to specify transfer source & $0001FE

                move.w  #$9600,d0
                lsr.l   #8,d1
                move.b  d1,d0
                move.w  d0,(a1)+                        ; command to specify transfer source & $01FE00

                move.w  #$9700,d0
                lsr.l   #8,d1
                andi.b  #$7F,d1                         ; this instruction safely allows source to be in RAM; S2's lacks this
                move.b  d1,d0
                move.w  d0,(a1)+                        ; command to specify transfer source & $FE0000

                andi.l  #$FFFF,d2
                lsl.l   #2,d2
                lsr.w   #2,d2
                swap    d2
                ori.l   #vdpComm($0000,VRAM,DMA),d2
                move.l  d2,(a1)+                        ; command to specify transfer destination and begin DMA

                move.l  a1,(DMA_queue_slot).w           ; set new free slot address
                cmpa.w  #DMA_queue_slot,a1              ; has the end of the queue been reached?
                beq.s   Add_To_DMA_Queue_Done           ; if it has, branch
                move.w  #0,(a1)                         ; place stop token at the end of the queue

Add_To_DMA_Queue_Done:
                rts
; End of function Add_To_DMA_Queue

; =============== S U B R O U T I N E =======================================

Process_DMA_Queue:
                lea     (VDP_control_port).l,a5
                lea     (DMA_queue).w,a1

                .loop:
                move.w  (a1)+,d0                        ; has a stop token been encountered?
                beq.s   .stop                           ; if it has, branch
                move.w  d0,(a5)
                move.w  (a1)+,(a5)
                move.w  (a1)+,(a5)
                move.w  (a1)+,(a5)
                move.w  (a1)+,(a5)
                move.w  (a1)+,(a5)
                move.w  (a1)+,(a5)
                cmpa.w  #DMA_queue_slot,a1              ; has the end of the queue been reached?
                bne.s   .loop                           ; if not, loop

                .stop:
                move.w  #0,(DMA_queue).w
                move.l  #DMA_queue,(DMA_queue_slot).w
                rts
; End of function Process_DMA_Queue
