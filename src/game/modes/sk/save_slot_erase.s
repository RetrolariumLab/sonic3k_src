; Owner: game/modes/sk
; Responsibility: Save-slot emerald decoration, erase-state transitions and slot icon art loading
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_SaveScreen_Emeralds:
                move.b  #$40,render_flags(a0)
                move.w  #make_art_tile(ArtTile_Save_Misc,0,1),art_tile(a0)
                move.l  #Map_SaveScreen,mappings(a0)
                move.b  #$40,width_pixels(a0)
                move.w  #7,mainspr_childsprites(a0)
                movea.w parent2(a0),a1
                movea.l $30(a1),a2
                move.w  6(a2),d4
                move.w  x_pos(a1),d0
                move.w  y_pos(a1),d1
                move.w  d0,x_pos(a0)
                move.w  d1,y_pos(a0)
                lea     sub2_x_pos(a0),a1
                moveq   #$10,d2
                moveq   #7-1,d3

SKSaveErase_DecodeNextEmeraldState:
                clr.b   5(a1)
                moveq   #0,d6
                rol.w   #2,d4
                move.w  d4,d5
                andi.w  #3,d5
                beq.s   SKSaveErase_AdvanceEmeraldDecoration
                cmpi.w  #3,d5
                bne.s   SKSaveErase_StoreEmeraldDecorationFrame
                moveq   #$C,d6

SKSaveErase_StoreEmeraldDecorationFrame:
                add.b   d2,d6
                move.w  d0,(a1)
                move.w  d1,sub2_y_pos-sub2_x_pos(a1)
                move.b  d6,sub2_mapframe-sub2_x_pos(a1)

SKSaveErase_AdvanceEmeraldDecoration:
                addq.w  #1,d2
                addq.w  #6,a1
                dbf     d3,SKSaveErase_DecodeNextEmeraldState
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_SaveScreen_Delete_Save:
                moveq   #0,d0
                move.b  routine(a0),d0
                jmp     SaveScreen_Delete_Save_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SaveScreen_Delete_Save_Index:
                bra.w   SKSaveErase_InitEraseActor
; ---------------------------------------------------------------------------
                bra.w   SKSaveErase_EnterEraseSelection
; ---------------------------------------------------------------------------
                bra.w   SKSaveErase_AnimateAndLatchNonemptySlot
; ---------------------------------------------------------------------------
                bra.w   SKSaveErase_ClearSelectionAndTestEnd
; ---------------------------------------------------------------------------
                bra.w   SKSaveErase_WaitForConfirmationMarker
; ---------------------------------------------------------------------------
                bra.w   SKSaveErase_EraseOnLeftOrCancelOnRight
; ---------------------------------------------------------------------------

SKSaveErase_InitEraseActor:
                move.b  #$40,render_flags(a0)
                move.b  #$30,width_pixels(a0)
                move.w  #1,mainspr_childsprites(a0)
                move.b  #8,sub2_mapframe(a0)
                addq.b  #4,routine(a0)

SKSaveErase_EnterEraseSelection:
                cmpi.b  #9,(Dataselect_entry).w
                bne.w   SKSaveErase_ProjectActorAndChildren
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.w   SKSaveErase_ProjectActorAndChildren
                moveq   #signextendB(sfx_Starpost),d0
                jsr     (Play_SFX).l
                st      (Events_bg+$12).w
                addq.b  #4,routine(a0)
                bra.w   SKSaveErase_ProjectActorAndChildren
; ---------------------------------------------------------------------------

SKSaveErase_AnimateAndLatchNonemptySlot:
                jsr     SKSaveEraseAdvanceMainIconBlinkSequence(pc)
                jsr     SKSaveErase_AnimateChild(pc)
                tst.w   (Player_2+object_control).w
                bne.s   SKSaveErase_FollowSelectorX
                move.b  (Ctrl_1_pressed).w,d0
                btst    #button_B,d0
                bne.s   SKSaveErase_ResetAnimAndBeginReturn
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.s   SKSaveErase_FollowSelectorX
                cmpi.b  #9,(Dataselect_entry).w
                beq.s   SKSaveErase_ResetAnimAndBeginReturn
                moveq   #0,d0
                move.b  (Dataselect_entry).w,d0
                subq.w  #1,d0
                mulu.w  #$A,d0
                addi.l  #Saved_data,d0
                move.l  d0,$2E(a0)
                movea.l d0,a1
                tst.b   (a1)
                bmi.s   SKSaveErase_ResetAnimAndBeginReturn
                moveq   #signextendB(sfx_Starpost),d0
                jsr     (Play_SFX).l
                st      (Events_bg+$10).w
                addq.b  #8,routine(a0)

SKSaveErase_FollowSelectorX:
                move.w  (Player_2+x_pos).w,d0
                move.w  d0,x_pos(a0)
                move.w  d0,sub2_x_pos(a0)
                move.w  y_pos(a0),sub2_y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKSaveErase_ResetAnimAndBeginReturn:
                clr.b   $24(a0)
                clr.b   $23(a0)
                clr.b   $25(a0)
                clr.b   $28(a0)
                move.b  #$D,mapping_frame(a0)
                move.b  #8,sub2_mapframe(a0)
                move.w  (Player_2+x_pos).w,d0
                add.w   (Camera_X_pos_copy).w,d0
                move.w  d0,$12(a0)
                addq.b  #4,routine(a0)
                bra.w   Set_ChildSprites
; ---------------------------------------------------------------------------

SKSaveErase_ClearSelectionAndTestEnd:
                clr.w   (Events_bg+$12).w
                move.w  $12(a0),d0
                cmpi.w  #$448,d0
                blo.s   SKSaveErase_Step8PixelsTowardEndpoint
                move.b  #4,routine(a0)
                bra.s   SKSaveErase_ProjectActorAndChildren
; ---------------------------------------------------------------------------

SKSaveErase_Step8PixelsTowardEndpoint:
                addq.w  #8,d0
                move.w  d0,$12(a0)

SKSaveErase_ProjectActorAndChildren:
                bra.w   Set_ChildSprites
; ---------------------------------------------------------------------------

SKSaveErase_WaitForConfirmationMarker:
                jsr     SKSaveEraseAdvanceMainIconBlinkSequence(pc)
                jsr     SKSaveErase_AnimateChild(pc)
                cmpi.b  #$B,sub2_mapframe(a0)
                bne.s   SKSaveErase_DrawConfirmationPrep
                move.b  #$C,sub2_mapframe(a0)
                addq.b  #4,routine(a0)

SKSaveErase_DrawConfirmationPrep:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; Clearing a ten-byte record restores the default lives in its last word
SKSaveErase_EraseOnLeftOrCancelOnRight:
                jsr     SKSaveEraseAdvanceMainIconBlinkSequence(pc)
                btst    #button_right,(Ctrl_1_pressed).w
                bne.s   SKSaveErase_UnlockAndBeginReturn
                btst    #button_left,(Ctrl_1_pressed).w
                beq.s   SKSaveErase_DrawWhileAwaitingDirection
                moveq   #signextendB(sfx_Perfect),d0
                jsr     (Play_SFX).l
                movea.l $2E(a0),a1
                move.w  #$8000,(a1)
                clr.l   2(a1)
                clr.w   6(a1)
                move.w  #$300,8(a1)
                st      (SRAM_mask_interrupts_flag).w
                jsr     Write_SaveGame(pc)

SKSaveErase_UnlockAndBeginReturn:
                move.b  #8,routine(a0)
                clr.w   (Events_bg+$10).w
                bra.w   SKSaveErase_ResetAnimAndBeginReturn
; ---------------------------------------------------------------------------

SKSaveErase_DrawWhileAwaitingDirection:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

SKSaveEraseAdvanceMainIconBlinkSequence:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKSaveErase_MainBlinkUpdateReturn
                move.b  #5,anim_frame_timer(a0)

SKSaveErase_AdvanceBlinkFrameOrRestart:
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,anim_frame(a0)
                move.b  SKSaveErase_MainBlinkFrames(pc,d0.w),d0
                bpl.s   SKSaveErase_StoreEraseBlinkMappingFrame
                clr.b   anim_frame(a0)
                bra.s   SKSaveErase_AdvanceBlinkFrameOrRestart
; ---------------------------------------------------------------------------

SKSaveErase_StoreEraseBlinkMappingFrame:
                move.b  d0,mapping_frame(a0)

SKSaveErase_MainBlinkUpdateReturn:
                rts
; End of function SKSaveEraseAdvanceMainIconBlinkSequence

; ---------------------------------------------------------------------------
SKSaveErase_MainBlinkFrames:
                dc.b    $D,  $E,  $D,  $E,  $D,  $E,  $D,  $E,  $D,  $E,  $D,  $D,  $D,  $D, $FF
                even

; =============== S U B R O U T I N E =======================================

; Cycle frames 8 through 11 once every four calls
SKSaveErase_AnimateChild:
                subq.b  #1,$25(a0)
                bpl.s   SKSaveErase_ChildFrameUpdateReturn
                move.b  #3,$25(a0)
                addq.b  #1,$28(a0)
                move.b  $28(a0),d0
                andi.b  #3,d0
                addq.b  #8,d0
                move.b  d0,sub2_mapframe(a0)

SKSaveErase_ChildFrameUpdateReturn:
                rts
; End of function SKSaveErase_AnimateChild

; =============== S U B R O U T I N E =======================================

Load_Icon_Art:
                cmp.b   $3A(a0),d1
                bne.s   SKSaveErase_SelectZoneCardUploadDest
                tst.b   $3B(a0)
                beq.s   SKSaveErase_SelectZoneCardUploadDest
                cmpi.w  #1,$34(a0)
                bls.s   SKSaveErase_SelectCompletedCardPalette
                cmpi.b  #3,$3B(a0)
                beq.s   SKSaveErase_SelectCompletedCardPalette
                moveq   #$E,d1
                cmpi.w  #3,$34(a0)
                beq.s   SKSaveErase_SelectCompletedPortrait
                addq.w  #2,d1

SKSaveErase_SelectCompletedPortrait:
                cmpi.b  #1,$3B(a0)
                beq.s   SKSaveErase_SelectPortraitUploadDest
                addq.w  #1,d1

SKSaveErase_SelectPortraitUploadDest:
                move.w  #tiles_to_bytes(ArtTile_Save_Misc+$27D),d2
                bra.s   SKSaveErase_QueueCardOrPortraitArt
; ---------------------------------------------------------------------------

SKSaveErase_SelectZoneCardUploadDest:
                move.w  #tiles_to_bytes(ArtTile_Save_Misc+$31B),d2

SKSaveErase_QueueCardOrPortraitArt:
                move.l  a1,-(sp)
                move.w  d1,-(sp)
                mulu.w  #$8C0,d1
                addi.l  #RAM_start,d1
                move.w  #$460,d3
                jsr     (Add_To_DMA_Queue).l
                move.w  (sp)+,d0
                movea.l (sp)+,a1
                lea     Pal_Save_ZoneCard1(pc),a2
                bra.s   SKSaveErase_SelectIndexedCardPalette
; ---------------------------------------------------------------------------

SKSaveErase_SelectCompletedCardPalette:
                lea     Pal_Save_FinishCard1(pc),a2
                moveq   #0,d0
                cmpi.b  #1,$3B(a0)
                beq.s   SKSaveErase_SelectIndexedCardPalette
                addq.w  #1,d0
                cmpi.b  #2,$3B(a0)
                beq.s   SKSaveErase_SelectIndexedCardPalette
                addq.w  #1,d0

SKSaveErase_SelectIndexedCardPalette:
                lsl.w   #5,d0
                adda.w  d0,a2
                lea     (Normal_palette_line_4).w,a3
                moveq   #bytesToLcnt(Normal_palette_end-Normal_palette_line_4),d0

SKSaveErase_CopyCardPaletteToNormal:
                move.l  (a2)+,(a3)+
                dbf     d0,SKSaveErase_CopyCardPaletteToNormal
                rts
; End of function Load_Icon_Art

; =============== S U B R O U T I N E =======================================

; A zero byte writes a blank tile. Any negative byte ends the label
SKSave_WriteEncodedLabel:
                lea     (VDP_data_port).l,a6
                jsr     SKSave_MakeVRAMWriteCommand(pc)
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                move.w  #make_art_tile(ArtTile_Save_Text-$10,1,1),d5
                moveq   #0,d6

SKSaveErase_WriteEncodedLabelOrBlank:
                move.b  (a1)+,d6
                bne.s   SKSaveErase_EndEncodedLabelOrWriteGlyph
                move.w  #$8000,(a6)
                bra.s   SKSaveErase_WriteEncodedLabelOrBlank
; ---------------------------------------------------------------------------

SKSaveErase_EndEncodedLabelOrWriteGlyph:
                bmi.s   SKSaveErase_EncodedLabelWriteReturn
                move.w  d5,d4
                add.w   d6,d4
                move.w  d4,(a6)
                bra.s   SKSaveErase_WriteEncodedLabelOrBlank
; ---------------------------------------------------------------------------

SKSaveErase_EncodedLabelWriteReturn:
                rts
; End of function SKSave_WriteEncodedLabel

; =============== S U B R O U T I N E =======================================

; Expand seven two-bit entries and derive the Chaos and Super Emerald counts and conversion flag
SKSave_DecodeEmeraldStates:
                clr.b   (Emeralds_converted_flag).w
                moveq   #0,d1
                moveq   #0,d2
                moveq   #7-1,d3

SKSaveErase_DecodeAndCountEmeraldStates:
                rol.w   #2,d0
                move.w  d0,d4
                andi.w  #3,d4
                move.b  d4,(a2)+
                beq.s   SKSaveErase_LatchEmeraldConversion
                addq.w  #1,d1
                cmpi.w  #3,d4
                bne.s   SKSaveErase_LatchEmeraldConversion
                addq.w  #1,d2

SKSaveErase_LatchEmeraldConversion:
                cmpi.w  #2,d4
                blo.s   SKSaveErase_RepeatEmeraldStateDecode
                st      (Emeralds_converted_flag).w

SKSaveErase_RepeatEmeraldStateDecode:
                dbf     d3,SKSaveErase_DecodeAndCountEmeraldStates
                rts
; End of function SKSave_DecodeEmeraldStates

; =============== S U B R O U T I N E =======================================

; Knuckles has a separate Sky Sanctuary Act 2 result for progress index $B
SKSave_MapProgressToZoneAct:
                cmpi.w  #3,$34(a0)
                bne.s   SKSaveErase_MapProgressToZoneAct
                cmpi.b  #$B,d0
                bne.s   SKSaveErase_MapProgressToZoneAct
                move.w  #$A01,d0
                bra.s   SKSaveErase_ProgressZoneActReturn
; ---------------------------------------------------------------------------

SKSaveErase_MapProgressToZoneAct:
                andi.w  #$F,d0
                add.w   d0,d0
                move.w  SKSaveErase_ProgressToZoneActTable(pc,d0.w),d0

SKSaveErase_ProgressZoneActReturn:
                rts
; End of function SKSave_MapProgressToZoneAct

; ---------------------------------------------------------------------------
SKSaveErase_ProgressToZoneActTable:
                dc.w    0
                dc.w    $100
                dc.w    $200
                dc.w    $300
                dc.w    $500
                dc.w    $600
                dc.w    $700
                dc.w    $400
                dc.w    $800
                dc.w    $900
                dc.w    $1601
                dc.w    $A00
                dc.w    $B00
                dc.w    $C00
; word_DA8A
Map_DataSelect_Player_LivesContinues:
; Blank File
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1), make_art_tile($000,0,1)
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1), make_art_tile($000,0,1)
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1), make_art_tile($000,0,1)
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1), make_art_tile($000,0,1)
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1), make_art_tile($000,0,1)
; Sonic Lives and Continues
                dc.w    0
                dc.w    make_art_tile(ArtTile_Save_Extra+$6E,1,1), make_art_tile(ArtTile_Save_Extra+$70,1,1), make_art_tile(ArtTile_Save_Extra+$5A,1,1)
                dc.w    make_art_tile(ArtTile_Save_Extra+$6F,1,1), make_art_tile(ArtTile_Save_Extra+$71,1,1), make_art_tile(ArtTile_Save_Extra+$5B,1,1)
                dc.w    make_art_tile(ArtTile_Save_Extra+$5C,1,1), make_art_tile(ArtTile_Save_Extra+$5F,1,1), make_art_tile($000,1,1)
                dc.w    make_art_tile(ArtTile_Save_Extra+$5D,1,1), make_art_tile(ArtTile_Save_Extra+$60,1,1), make_art_tile(ArtTile_Save_Extra+$5A,1,1)
                dc.w    make_art_tile(ArtTile_Save_Extra+$5E,1,1), make_art_tile(ArtTile_Save_Extra+$61,1,1), make_art_tile(ArtTile_Save_Extra+$5B,1,1)
; Tails Lives and Continues
                dc.w    0
                dc.w    make_art_tile(ArtTile_Save_Extra+$72,1,1), make_art_tile(ArtTile_Save_Extra+$74,1,1), make_art_tile(ArtTile_Save_Extra+$5A,1,1)
                dc.w    make_art_tile(ArtTile_Save_Extra+$73,1,1), make_art_tile(ArtTile_Save_Extra+$75,1,1), make_art_tile(ArtTile_Save_Extra+$5B,1,1)
                dc.w    make_art_tile(ArtTile_Save_Extra+$62,1,1), make_art_tile(ArtTile_Save_Extra+$65,1,1), make_art_tile($000,1,1)
                dc.w    make_art_tile(ArtTile_Save_Extra+$63,1,1), make_art_tile(ArtTile_Save_Extra+$66,1,1), make_art_tile(ArtTile_Save_Extra+$5A,1,1)
                dc.w    make_art_tile(ArtTile_Save_Extra+$64,1,1), make_art_tile(ArtTile_Save_Extra+$67,1,1), make_art_tile(ArtTile_Save_Extra+$5B,1,1)
; Knuckles Lives and Continues
                dc.w    0
                dc.w    make_art_tile(ArtTile_Save_Extra+$76,1,1), make_art_tile(ArtTile_Save_Extra+$78,1,1), make_art_tile(ArtTile_Save_Extra+$5A,1,1)
                dc.w    make_art_tile(ArtTile_Save_Extra+$77,1,1), make_art_tile(ArtTile_Save_Extra+$79,1,1), make_art_tile(ArtTile_Save_Extra+$5B,1,1)
                dc.w    make_art_tile(ArtTile_Save_Extra+$68,1,1), make_art_tile(ArtTile_Save_Extra+$6B,1,1), make_art_tile($000,1,1)
                dc.w    make_art_tile(ArtTile_Save_Extra+$69,1,1), make_art_tile(ArtTile_Save_Extra+$6C,1,1), make_art_tile(ArtTile_Save_Extra+$5A,1,1)
                dc.w    make_art_tile(ArtTile_Save_Extra+$6A,1,1), make_art_tile(ArtTile_Save_Extra+$6D,1,1), make_art_tile(ArtTile_Save_Extra+$5B,1,1)
SKSaveErase_BlankLivesAndContinuesDigits:
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1)
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1)
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1)
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1)
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1)
