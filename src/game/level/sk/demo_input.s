; Owner: game/level/sk
; Responsibility: Attract recording selection and recorded player-input playback
; Source provenance and ranges: config/reconstruction/source_layout.json
GetDemoPtr:
                move.w  (Demo_number).w,d0
                lsl.w   #2,d0
                movea.l DemoPtrs(pc,d0.w),a0
                move.b  (a0)+,(Demo_hold_counter).w
                move.l  a0,(Demo_data_addr).w
                clr.b   (Demo_hold_buttons).w
                move.w  #button_start_mask<<8,(Ctrl_1).w
                move.w  #button_start_mask<<8,(Ctrl_2).w
                st      (Demo_start_button).w
                rts
; End of function GetDemoPtr

; ---------------------------------------------------------------------------
DemoPtrs:
                dc.l    DemoDat_AIZ
                dc.l    DemoDat_HCZ
                dc.l    DemoDat_MGZ
                dc.l    DemoDat_MHZ
                dc.l    DemoDat_FBZ
                dc.l    DemoDat_SOZ
                dc.l    DemoDat_SpecialStage

; =============== S U B R O U T I N E =======================================

Demo_PlayRecord:
                tst.w   (Demo_mode_flag).w
                bne.s   SKLevel_CancelDemoFromPlayerOneStart
                rts
; ---------------------------------------------------------------------------

SKLevel_CancelDemoFromPlayerOneStart:
                move.b  (Ctrl_1_pressed).w,d0
                andi.b  #button_start_mask,d0
                beq.s   SKLevel_ChooseRawOrRunLengthDemoDecoder
                move.b  #GameMode_TitleScreen,(Game_mode).w

SKLevel_ChooseRawOrRunLengthDemoDecoder:
                movea.l (Demo_data_addr).w,a0
                cmpi.b  #4,(Current_zone).w
                beq.s   SKDemo_ReadRunButtons
                cmpi.b  #7,(Current_zone).w
                bhs.s   SKDemo_ReadRunButtons
                move.b  (Demo_start_button).w,d1
                andi.b  #button_start_mask,d1
                or.b    -1(a0),d1
                move.b  (Ctrl_1_held).w,d0
                andi.b  #button_start_mask,d0
                sne     (Demo_start_button).w
                or.b    (a0)+,d0
                bra.s   SKDemo_StoreInputAndCursor
; ---------------------------------------------------------------------------

; Read the current buttons before ticking the counter or advancing to the next run
SKDemo_ReadRunButtons:
                move.b  (a0),d2
                subq.b  #1,(Demo_hold_counter).w
                bcc.s   SKDemo_MergePhysicalStart
                addq.w  #2,a0
                move.b  -1(a0),(Demo_hold_counter).w

SKDemo_MergePhysicalStart:
                move.b  (Demo_start_button).w,d1
                andi.b  #button_start_mask,d1
                or.b    (Demo_hold_buttons).w,d1
                move.b  d2,(Demo_hold_buttons).w
                move.b  (Ctrl_1).w,d0
                andi.b  #button_start_mask,d0
                sne     (Demo_start_button).w
                or.b    d2,d0

SKDemo_StoreInputAndCursor:
                move.b  d0,(Ctrl_1).w
                eor.b   d0,d1
                and.b   d0,d1
                move.b  d1,(Ctrl_1_pressed).w
                move.w  #(button_start_mask<<8)|button_start_mask,d0
                and.w   d0,(Ctrl_2).w
                move.l  a0,(Demo_data_addr).w
                rts
; End of function Demo_PlayRecord
