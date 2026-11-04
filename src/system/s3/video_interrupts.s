; Owner: system/s3; responsibility: video interrupts
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Vertical interrupt handler
; ---------------------------------------------------------------------------

VInt:
                nop
                movem.l d0-a6,-(sp)
                tst.b   (V_int_routine).w
                beq.w   VInt_0_Main

S3VInt_WaitForVBlankBeforeRequestedFrameTransfer:
                move.w  (VDP_control_port).l,d0
                andi.w  #8,d0
                beq.s   S3VInt_WaitForVBlankBeforeRequestedFrameTransfer  ; wait until vertical blanking is taking place

                move.l  #vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
                move.l  (V_scroll_value).w,(VDP_data_port).l
                btst    #6,(Graphics_flags).w
                beq.s   S3VInt_ConsumeFrameRequestAndDispatchMaskedVIntIndex  ; branch if it's not a PAL system
                move.w  #$700,d0
                dbf     d0,*                            ; otherwise, waste a bit of time here

S3VInt_ConsumeFrameRequestAndDispatchMaskedVIntIndex:
                move.b  (V_int_routine).w,d0
                move.b  #VInt_ID_0,(V_int_routine).w
                move.w  #1,(H_int_flag).w               ; Allow H Interrupt code to run
                andi.w  #$3E,d0
                move.w  VInt_Table(pc,d0.w),d0
                jsr     VInt_Table(pc,d0.w)

VInt_Done:
                addq.l  #1,(V_int_run_count).w
                movem.l (sp)+,d0-a6
                rte
; ---------------------------------------------------------------------------
VInt_Table:

vintptr:        macro   vintroutine,{INTLABEL}
__LABEL__:      label   *-VInt_Table
                    dc.w    vintroutine-VInt_Table
                endm

VInt_ID_0:      vintptr VInt_0
VInt_ID_2:      vintptr VInt_2
VInt_ID_4:      vintptr VInt_4
VInt_ID_6:      vintptr VInt_6
VInt_ID_8:      vintptr VInt_8
VInt_ID_A:      vintptr VInt_A_C
VInt_ID_C:      vintptr VInt_A_C
VInt_ID_E:      vintptr VInt_E
VInt_ID_10:     vintptr VInt_10
VInt_ID_12:     vintptr VInt_12
VInt_ID_14:     vintptr VInt_14
VInt_ID_16:     vintptr VInt_16
VInt_ID_18:     vintptr VInt_18
VInt_ID_1A:     vintptr VInt_1A
VInt_ID_1C:     vintptr VInt_1C
VInt_ID_1E:     vintptr VInt_1E
; ---------------------------------------------------------------------------

VInt_0:
                addq.w  #4,sp

VInt_0_Main:
                addq.w  #1,(Lag_frame_count).w

; branch if a level or demo is running
                cmpi.b  #GameMode_Demo+$80,(Game_mode).w
                beq.s   VInt_0_Level
                cmpi.b  #GameMode_Level+$80,(Game_mode).w
                beq.s   VInt_0_Level
                cmpi.b  #GameMode_Demo,(Game_mode).w
                beq.s   VInt_0_Level
                cmpi.b  #GameMode_Level,(Game_mode).w
                beq.s   VInt_0_Level
                stopZ80
                bsr.w   sndDriverInput
                startZ80
                bra.s   VInt_Done                       ; otherwise, return from V-int
; ---------------------------------------------------------------------------

VInt_0_Level:
                tst.b   (Water_flag).w
                beq.w   VInt_0_NoWater
                move.w  (VDP_control_port).l,d0
                btst    #6,(Graphics_flags).w
                beq.s   +                               ; branch if it isn't a PAL system
                move.w  #$700,d0
                dbf     d0,*                            ; otherwise waste a bit of time here

                +:
                move.w  #1,(H_int_flag).w
                stopZ80
                tst.b   (Water_full_screen_flag).w
                bne.s   VInt_0_FullyUnderwater
                dma68kToVDP Normal_palette,0,Normal_palette_end-Normal_palette,CRAM
                bra.s   VInt_0_Water_Cont
; ---------------------------------------------------------------------------

VInt_0_FullyUnderwater:
                dma68kToVDP Water_palette,0,Water_palette_end-Water_palette,CRAM

VInt_0_Water_Cont:
                move.w  (H_int_counter_command).w,(a5)
                bsr.w   sndDriverInput
                startZ80
                bra.w   VInt_Done
; ---------------------------------------------------------------------------

VInt_0_NoWater:
                move.w  (VDP_control_port).l,d0
                btst    #6,(Graphics_flags).w
                beq.s   +                               ; branch if it isn't a PAL system
                move.w  #$700,d0
                dbf     d0,*                            ; otherwise, waste a bit of time here

                +:
                move.w  #1,(H_int_flag).w
                move.w  (H_int_counter_command).w,(VDP_control_port).l
                stopZ80

; In Competition Mode, we have to update the sprite table
; even during a lag frame so that the top half of the screen
; shows the correct sprites
                tst.w   (Competition_mode).w
                beq.s   VInt_0_Done

; Update V-Scroll
                move.l  #vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
                move.l  (V_scroll_value).w,(VDP_data_port).l

; Unlike in Sonic 2, the sprite tables are page-flipped in two-player mode
; This fixes a race-condition where incomplete sprite tables can be uploaded
; to the VDP on lag frames, causing corrupted sprites to appear

; Upload the front buffer
                tst.w   (Current_sprite_table_page).w
                beq.s   +
                dma68kToVDP Sprite_table,$F800,Sprite_table_end-Sprite_table,VRAM
                bra.s   VInt_0_Done

                +:
                dma68kToVDP Sprite_table_alternate,$F800,Sprite_table_alternate_end-Sprite_table_alternate,VRAM

VInt_0_Done:
                bsr.w   sndDriverInput
                startZ80
                bra.w   VInt_Done
; ---------------------------------------------------------------------------

VInt_2:
                bsr.w   Do_ControllerPal
                dma68kToVDP H_scroll_buffer,$F000,H_scroll_buffer_end-H_scroll_buffer,VRAM
                jsr     (SegaScr_VInt).l
                tst.w   (Demo_timer).w
                beq.w   S3VInt_ReturnAfterSegaVIntAndOptionalDemoTick
                subq.w  #1,(Demo_timer).w

S3VInt_ReturnAfterSegaVIntAndOptionalDemoTick:
                rts
; ---------------------------------------------------------------------------

VInt_14:
                move.b  (V_int_run_count+3).w,d0
                andi.w  #$F,d0
                bne.s   S3VInt_TickDemoTimerAfterSparseControllerPoll  ; run the following code once every 16 frames

                stopZ80
                bsr.w   Poll_Controllers
                startZ80

S3VInt_TickDemoTimerAfterSparseControllerPoll:
                tst.w   (Demo_timer).w
                beq.w   S3VInt_ReturnFromSparsePollVInt
                subq.w  #1,(Demo_timer).w

S3VInt_ReturnFromSparsePollVInt:
                rts
; ---------------------------------------------------------------------------

VInt_4:
                bsr.w   TitleAnim_FlipBuffer
                bsr.w   Do_ControllerPal
                move.w  (Ctrl_1).w,(Ctrl_1_title).w
                bsr.w   Process_Nem_Queue
                tst.w   (Demo_timer).w
                beq.w   S3VInt_ReturnAfterTitleTransfersAndDemoTick
                subq.w  #1,(Demo_timer).w

S3VInt_ReturnAfterTitleTransfersAndDemoTick:
                rts
; ---------------------------------------------------------------------------

VInt_6:
                bsr.w   Do_ControllerPal
                rts
; ---------------------------------------------------------------------------

VInt_10:
                cmpi.b  #GameMode_SpecialStage3,(Game_mode).w
                beq.w   VInt_1C                         ; If in a special stage, branch

VInt_8:
                stopZ80
                bsr.w   Poll_Controllers

                tst.b   (Water_full_screen_flag).w
                bne.s   +
                dma68kToVDP Normal_palette,0,Normal_palette_end-Normal_palette,CRAM
                bra.s   ++

                +:
                dma68kToVDP Water_palette,0,Water_palette_end-Water_palette,CRAM

                +:
                move.w  (H_int_counter_command).w,(a5)

                dma68kToVDP H_scroll_buffer,$F000,H_scroll_buffer_end-H_scroll_buffer,VRAM

                tst.w   (Competition_mode).w
                beq.s   ++
; Unlike in Sonic 2, the sprite tables are page-flipped in two-player mode
; This fixes a race-condition where incomplete sprite tables can be uploaded
; to the VDP on lag frames, causing corrupted sprites to appear

; Perform page-flipping
                tst.w   (Sprite_table_page_flip_pending).w
                beq.s   +
                clr.w   (Sprite_table_page_flip_pending).w
                eori.w  #$FFFF,(Current_sprite_table_page).w  ; a not.w would've accomplished the same thing

                +:
; Upload the front buffer
                tst.w   (Current_sprite_table_page).w
                bne.s   +
                dma68kToVDP Sprite_table_alternate,$F800,Sprite_table_alternate_end-Sprite_table_alternate,VRAM
                bra.s   ++

                +:
                dma68kToVDP Sprite_table,$F800,Sprite_table_end-Sprite_table,VRAM

                +:
                bsr.w   Process_DMA_Queue
                move.l  (V_scroll_value_P2).w,(V_scroll_value_P2_copy).w
                jsr     (SpecialVInt_Function).l
                jsr     (VInt_DrawLevel).l
                bsr.w   sndDriverInput
                startZ80
                move    #$2300,sr
                tst.b   (Water_flag).w
                beq.s   +
                cmpi.b  #92,(H_int_counter).w           ; is H-int occurring on or below line 92?
                bhs.s   +                               ; if it is, branch
                move.b  #1,(Do_Updates_in_H_int).w
                jmp     (Set_Kos_Bookmark).l

                +:
                bsr.s   Do_Updates
                jmp     (Set_Kos_Bookmark).l

; =============== S U B R O U T I N E =======================================

Do_Updates:
                jsr     (UpdateHUD).l
                move.w  #0,(Lag_frame_count).w
                bsr.w   Process_Nem_Queue_2
                tst.w   (Demo_timer).w
                beq.w   S3VInt_ReturnFromHudAndThreeTileUpdateGroup
                subq.w  #1,(Demo_timer).w

S3VInt_ReturnFromHudAndThreeTileUpdateGroup:
                rts
; End of function Do_Updates

; ---------------------------------------------------------------------------

VInt_A_C:
                stopZ80
                bsr.w   Poll_Controllers
                tst.b   (Water_full_screen_flag).w
                bne.s   +
                dma68kToVDP Normal_palette,0,Normal_palette_end-Normal_palette,CRAM
                bra.s   ++

                +:
                dma68kToVDP Water_palette,0,Water_palette_end-Water_palette,CRAM

                +:
                move.w  (H_int_counter_command).w,(a5)
                dma68kToVDP H_scroll_buffer,$F000,H_scroll_buffer_end-H_scroll_buffer,VRAM

                tst.w   (Competition_mode).w
                beq.s   ++
; Unlike in Sonic 2, the sprite tables are page-flipped in two-player mode
; This fixes a race-condition where incomplete sprite tables can be uploaded
; to the VDP on lag frames, causing corrupted sprites to appear

; Perform page-flipping
                tst.w   (Sprite_table_page_flip_pending).w
                beq.s   +
                clr.w   (Sprite_table_page_flip_pending).w
                eori.w  #$FFFF,(Current_sprite_table_page).w  ; a not.w would've accomplished the same thing

                +:
; Upload the front buffer
                tst.w   (Current_sprite_table_page).w
                bne.s   +
                dma68kToVDP Sprite_table_alternate,$F800,Sprite_table_alternate_end-Sprite_table_alternate,VRAM
                bra.s   ++

                +:
                dma68kToVDP Sprite_table,$F800,Sprite_table_end-Sprite_table,VRAM

                +:
                bsr.w   Process_DMA_Queue
                move.l  (V_scroll_value_P2).w,(V_scroll_value_P2_copy).w
                jsr     (sndDriverInput).l
                startZ80
                bsr.w   Process_Nem_Queue
                jmp     (Set_Kos_Bookmark).l
; ---------------------------------------------------------------------------

VInt_E:
                bsr.w   Do_ControllerPal
                move.b  #VInt_ID_E,(V_int_routine).w
                rts
; ---------------------------------------------------------------------------

VInt_12:
                bsr.w   Do_ControllerPal
                move.w  (H_int_counter_command).w,(a5)
                bra.w   Process_Nem_Queue
; ---------------------------------------------------------------------------

VInt_18:
                stopZ80
                bsr.w   Poll_Controllers

                dma68kToVDP Normal_palette,0,Normal_palette_end-Normal_palette,CRAM
                dma68kToVDP Sprite_table,$F800,Sprite_table_end-Sprite_table,VRAM
                dma68kToVDP H_scroll_buffer,$F000,H_scroll_buffer_end-H_scroll_buffer,VRAM

                bclr    #0,(_unkFA88).w
                beq.s   S3VInt_FinishSaveVIntAfterOptionalPlaneBufferUpload
                dma68kToVDP RAM_start+$2000,$C000,$2000,VRAM

S3VInt_FinishSaveVIntAfterOptionalPlaneBufferUpload:
                bsr.w   Process_DMA_Queue
                bsr.w   sndDriverInput
                startZ80
                rts
; ---------------------------------------------------------------------------

VInt_16:
                stopZ80
                bsr.w   Poll_Controllers

                dma68kToVDP Normal_palette,0,Normal_palette_end-Normal_palette,CRAM
                dma68kToVDP Sprite_table,$F800,Sprite_table_end-Sprite_table,VRAM
                dma68kToVDP H_scroll_buffer,$F000,H_scroll_buffer_end-H_scroll_buffer,VRAM

                bsr.w   Process_DMA_Queue
                bsr.w   sndDriverInput
                startZ80
                bsr.w   Process_Nem_Queue
                tst.w   (Demo_timer).w
                beq.w   S3VInt_ReturnFromMenuVIntAndDemoTick
                subq.w  #1,(Demo_timer).w

S3VInt_ReturnFromMenuVIntAndDemoTick:
                rts
; ---------------------------------------------------------------------------

VInt_1A:
                bsr.w   Do_ControllerPal
                bsr.w   Process_Nem_Queue
                jmp     (Set_Kos_Bookmark).l
; ---------------------------------------------------------------------------

VInt_1C:
                bsr.w   Rotate_SSPal
                bsr.w   Do_ControllerPal
                bsr.w   Update_SSMap
                tst.w   (Demo_timer).w
                beq.w   S3VInt_TailBookmarkAfterSpecialStageMapAndDemoTick
                subq.w  #1,(Demo_timer).w

S3VInt_TailBookmarkAfterSpecialStageMapAndDemoTick:
                jmp     (Set_Kos_Bookmark).l
; ---------------------------------------------------------------------------

VInt_1E:
                bsr.s   Do_ControllerPal
                movea.l (_unkEF44_1).w,a0
                jsr     (a0)
                bsr.w   Process_Nem_Queue_2
                jmp     (Set_Kos_Bookmark).l

; =============== S U B R O U T I N E =======================================

Do_ControllerPal:
                stopZ80
                bsr.w   Poll_Controllers
                tst.b   (Water_full_screen_flag).w
                bne.s   S3VInt_UploadFullWaterPaletteForControllerTransferGroup
                dma68kToVDP Normal_palette,0,Normal_palette_end-Normal_palette,CRAM
                bra.s   S3VInt_UploadSpriteScrollAndQueuedDmaThenReleaseZ80

S3VInt_UploadFullWaterPaletteForControllerTransferGroup:
                dma68kToVDP Water_palette,0,Water_palette_end-Water_palette,CRAM

S3VInt_UploadSpriteScrollAndQueuedDmaThenReleaseZ80:
                dma68kToVDP Sprite_table,$F800,Sprite_table_end-Sprite_table,VRAM
                dma68kToVDP H_scroll_buffer,$F000,H_scroll_buffer_end-H_scroll_buffer,VRAM
                bsr.w   Process_DMA_Queue
                bsr.w   sndDriverInput
                startZ80
                rts
; End of function Do_ControllerPal

; ---------------------------------------------------------------------------

JmpTo_HInt:
                jmp     (H_int_jump).w

; ---------------------------------------------------------------------------
; Horizontal interrupt handler for Competition Mode
; ---------------------------------------------------------------------------

HInt:
                tst.w   (H_int_flag).w
                beq.w   HInt_Done
                move.w  #0,(H_int_flag).w
                move.l  a5,-(sp)
                move.l  d0,-(sp)

                -:
                move.w  (VDP_control_port).l,d0
                andi.w  #4,d0                           ; is horizontal blanking occurring?
                beq.s   -                               ; if not, wait until it is

                move.w  (VDP_reg_1_command).w,d0
                andi.b  #$BF,d0
                move.w  d0,(VDP_control_port).l         ; blank the display

; Update V-Scroll
                move.l  #vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
                move.l  (V_scroll_value_P2_copy).w,(VDP_data_port).l

                stopZ80
; Unlike in Sonic 2, the sprite tables are page-flipped in two-player mode
; This fixes a race-condition where incomplete sprite tables can be uploaded
; to the VDP on lag frames, causing corrupted sprites to appear

; Upload the front buffer
                tst.w   (Current_sprite_table_page).w
                beq.s   +
                dma68kToVDP Sprite_table_P2,$F800,Sprite_table_P2_end-Sprite_table_P2,VRAM
                bra.s   ++

                +:
                dma68kToVDP Sprite_table_P2_alternate,$F800,Sprite_table_P2_alternate_end-Sprite_table_P2_alternate,VRAM

                +:
                startZ80

                -:
                move.w  (VDP_control_port).l,d0
                andi.w  #4,d0                           ; is a horizontal blank occurring?
                beq.s   -                               ; if not, wait
                move.w  (VDP_reg_1_command).w,d0
                ori.b   #$40,d0
                move.w  d0,(VDP_control_port).l         ; enable display
                move.l  (sp)+,d0
                movea.l (sp)+,a5

HInt_Done:
                rte

; ---------------------------------------------------------------------------
; Used for water levels apart from Hydrocity, for uneven water surfaces
; ---------------------------------------------------------------------------

HInt3:
                tst.w   (H_int_flag).w
                beq.s   HInt3_Done
                move.w  #0,(H_int_flag).w
                movem.l d0-d1/a0-a2,-(sp)

                lea     (VDP_data_port).l,a1
                move.w  #$8AFF,VDP_control_port-VDP_data_port(a1)  ; Reset HInt timing
                stopZ80
                movea.l (Water_palette_data_addr).w,a2
                moveq   #$C,d0
                dbf     d0,*                            ; waste a few cycles here
                move.w  (a2)+,d1
                move.b  (H_int_counter).w,d0
                subi.b  #200,d0                         ; is H-int occurring below line 200?
                bcs.s   .transferColors                 ; if it is, branch
                sub.b   d0,d1
                bcs.s   .skipTransfer

                .transferColors:
                move.w  (a2)+,d0
                lea     (Water_palette).w,a0
                adda.w  d0,a0
                addi.w  #$C000,d0
                swap    d0
                move.l  d0,VDP_control_port-VDP_data_port(a1)  ; write to CRAM at appropriate address
                move.l  (a0)+,(a1)                      ; transfer two colors
                move.w  (a0)+,(a1)                      ; transfer the third color
                nop
                nop
                moveq   #$24,d0
                dbf     d0,*                            ; waste some cycles
                dbf     d1,.transferColors              ; repeat for number of colors

                .skipTransfer:
                startZ80
                movem.l (sp)+,d0-d1/a0-a2
                tst.b   (Do_Updates_in_H_int).w
                bne.s   HInt3_Do_Updates

HInt3_Done:
                rte
; ---------------------------------------------------------------------------

HInt3_Do_Updates:
                clr.b   (Do_Updates_in_H_int).w
                movem.l d0-a6,-(sp)
                jsr     (Do_Updates).l
                movem.l (sp)+,d0-a6
                rte
