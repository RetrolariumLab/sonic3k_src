; Owner: game/level/s3
; Responsibility: Attract recording selection and recorded player-input playback
; Source provenance and ranges: config/reconstruction/source_layout.json
GetDemoPtr:
                move.w  (Next_demo_number).w,d0
                lsl.w   #2,d0
                move.l  DemoPtrs(pc,d0.w),(Demo_data_addr).w
                move.w  #button_start_mask<<8,(Ctrl_1).w
                move.w  #button_start_mask<<8,(Ctrl_2).w
                st      (Demo_start_button).w
                rts
; End of function GetDemoPtr

; ---------------------------------------------------------------------------
DemoPtrs:
                dc.l    DemoDat_MGZ+1
                dc.l    DemoDat_AIZ+1
                dc.l    DemoDat_HCZ+1

; =============== S U B R O U T I N E =======================================

Demo_PlayRecord:
                tst.w   (Demo_mode_flag).w
                bne.s   S3Level_CancelDemoFromEitherPlayerStart
                rts
; ---------------------------------------------------------------------------

S3Level_CancelDemoFromEitherPlayerStart:
                move.b  (Ctrl_1_pressed).w,d0
                or.b    (Ctrl_2_pressed).w,d0
                andi.b  #button_start_mask,d0
                beq.s   S3Level_DecodeRawDemoSampleAndStartEdges
                move.b  #GameMode_TitleScreen,(Game_mode).w

S3Level_DecodeRawDemoSampleAndStartEdges:
                movea.l (Demo_data_addr).w,a0
                move.b  (Demo_start_button).w,d1
                andi.b  #button_start_mask,d1
                or.b    -1(a0),d1
                move.b  (Ctrl_1_held).w,d0
                andi.b  #button_start_mask,d0
                sne     (Demo_start_button).w
                or.b    (a0)+,d0
                move.l  a0,(Demo_data_addr).w
                move.b  d0,(Ctrl_1_held).w
                eor.b   d0,d1
                and.b   d0,d1
                move.b  d1,(Ctrl_1_pressed).w
                move.w  #(button_start_mask<<8)|button_start_mask,d0
                and.w   d0,(Ctrl_2).w
                rts
; End of function Demo_PlayRecord
