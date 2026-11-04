; Owner: game/modes/s3
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
                move.b  6(a2),d4
                move.w  x_pos(a1),d0
                move.w  y_pos(a1),d1
                move.w  d0,x_pos(a0)
                move.w  d1,y_pos(a0)
                lea     sub2_x_pos(a0),a1
                moveq   #$10,d2
                moveq   #7-1,d3

S3SaveErase_DecorateFromEmeraldBit:
                clr.b   5(a1)
                lsl.b   #1,d4
                bcc.s   S3SaveErase_AdvanceEmeraldDecoration
                move.w  d0,(a1)
                move.w  d1,sub2_y_pos-sub2_x_pos(a1)
                move.b  d2,sub2_mapframe-sub2_x_pos(a1)

S3SaveErase_AdvanceEmeraldDecoration:
                addq.w  #1,d2
                addq.w  #6,a1
                dbf     d3,S3SaveErase_DecorateFromEmeraldBit
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_SaveScreen_Delete_Save:
                moveq   #0,d0
                move.b  routine(a0),d0
                jmp     SaveScreen_Delete_Save_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SaveScreen_Delete_Save_Index:
                bra.w   S3SaveErase_InitEraseActor
; ---------------------------------------------------------------------------
                bra.w   S3SaveErase_EnterEraseSelection
; ---------------------------------------------------------------------------
                bra.w   S3SaveErase_AnimateAndLatchNonemptySlot
; ---------------------------------------------------------------------------
                bra.w   S3SaveErase_ClearSelectionAndTestEnd
; ---------------------------------------------------------------------------
                bra.w   S3SaveErase_WaitForConfirmationMarker
; ---------------------------------------------------------------------------
                bra.w   S3SaveErase_EraseOnLeftOrCancelOnRight
; ---------------------------------------------------------------------------

S3SaveErase_InitEraseActor:
                move.b  #$40,render_flags(a0)
                move.b  #$30,width_pixels(a0)
                move.w  #1,mainspr_childsprites(a0)
                move.b  #8,sub2_mapframe(a0)
                addq.b  #4,routine(a0)

S3SaveErase_EnterEraseSelection:
                cmpi.b  #7,(Dataselect_entry).w
                bne.w   S3SaveErase_ProjectActorAndChildren
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.w   S3SaveErase_ProjectActorAndChildren
                moveq   #signextendB(sfx_Starpost),d0
                jsr     (Play_SFX).l
                st      (Events_bg+$12).w
                addq.b  #4,routine(a0)
                bra.w   S3SaveErase_ProjectActorAndChildren
; ---------------------------------------------------------------------------

S3SaveErase_AnimateAndLatchNonemptySlot:
                jsr     S3SaveEraseAdvanceMainIconBlinkSequence(pc)
                jsr     S3SaveErase_AnimateChild(pc)
                tst.w   (Player_2+object_control).w
                bne.s   S3SaveErase_FollowSelectorX
                move.b  (Ctrl_1_pressed).w,d0
                btst    #button_B,d0
                bne.s   S3SaveErase_ResetAnimAndBeginReturn
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.s   S3SaveErase_FollowSelectorX
                cmpi.b  #7,(Dataselect_entry).w
                beq.s   S3SaveErase_ResetAnimAndBeginReturn
                moveq   #0,d0
                move.b  (Dataselect_entry).w,d0
                subq.w  #1,d0
                lsl.w   #3,d0
                addi.l  #Saved_data,d0
                move.l  d0,$2E(a0)
                movea.l d0,a1
                tst.b   (a1)
                bmi.s   S3SaveErase_ResetAnimAndBeginReturn
                moveq   #signextendB(sfx_Starpost),d0
                jsr     (Play_SFX).l
                st      (Events_bg+$10).w
                addq.b  #8,routine(a0)

S3SaveErase_FollowSelectorX:
                move.w  (Player_2+x_pos).w,d0
                move.w  d0,x_pos(a0)
                move.w  d0,sub2_x_pos(a0)
                move.w  y_pos(a0),sub2_y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SaveErase_ResetAnimAndBeginReturn:
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

S3SaveErase_ClearSelectionAndTestEnd:
                clr.w   (Events_bg+$12).w
                move.w  $12(a0),d0
                cmpi.w  #$378,d0
                blo.s   S3SaveErase_Step8PixelsTowardEndpoint
                move.b  #4,routine(a0)
                bra.s   S3SaveErase_ProjectActorAndChildren
; ---------------------------------------------------------------------------

S3SaveErase_Step8PixelsTowardEndpoint:
                addq.w  #8,d0
                move.w  d0,$12(a0)

S3SaveErase_ProjectActorAndChildren:
                bra.w   Set_ChildSprites
; ---------------------------------------------------------------------------

S3SaveErase_WaitForConfirmationMarker:
                jsr     S3SaveEraseAdvanceMainIconBlinkSequence(pc)
                jsr     S3SaveErase_AnimateChild(pc)
                cmpi.b  #$B,sub2_mapframe(a0)
                bne.s   S3SaveErase_DrawConfirmationPrep
                move.b  #$C,sub2_mapframe(a0)
                addq.b  #4,routine(a0)

S3SaveErase_DrawConfirmationPrep:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3SaveErase_EraseOnLeftOrCancelOnRight:
                jsr     S3SaveEraseAdvanceMainIconBlinkSequence(pc)
                btst    #button_right,(Ctrl_1_pressed).w
                bne.s   S3SaveErase_UnlockAndBeginReturn
                btst    #button_left,(Ctrl_1_pressed).w
                beq.s   S3SaveErase_DrawWhileAwaitingDirection
                moveq   #signextendB(sfx_Perfect),d0
                jsr     (Play_SFX).l
                movea.l $2E(a0),a1
                clr.l   (a1)
                clr.l   4(a1)
                bset    #7,(a1)
                jsr     Write_SaveGame(pc)

S3SaveErase_UnlockAndBeginReturn:
                move.b  #8,routine(a0)
                clr.w   (Events_bg+$10).w
                bra.w   S3SaveErase_ResetAnimAndBeginReturn
; ---------------------------------------------------------------------------

S3SaveErase_DrawWhileAwaitingDirection:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

S3SaveEraseAdvanceMainIconBlinkSequence:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3SaveErase_MainBlinkUpdateReturn
                move.b  #5,anim_frame_timer(a0)

S3SaveErase_AdvanceBlinkFrameOrRestart:
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,anim_frame(a0)
                move.b  S3SaveErase_MainBlinkFrames(pc,d0.w),d0
                bpl.s   S3SaveErase_StoreEraseBlinkMappingFrame
                clr.b   anim_frame(a0)
                bra.s   S3SaveErase_AdvanceBlinkFrameOrRestart
; ---------------------------------------------------------------------------

S3SaveErase_StoreEraseBlinkMappingFrame:
                move.b  d0,mapping_frame(a0)

S3SaveErase_MainBlinkUpdateReturn:
                rts
; End of function S3SaveEraseAdvanceMainIconBlinkSequence

; ---------------------------------------------------------------------------
S3SaveErase_MainBlinkFrames:
                dc.b    $D,  $E,  $D,  $E,  $D,  $E,  $D,  $E,  $D,  $E,  $D,  $D,  $D,  $D, $FF
                even

; =============== S U B R O U T I N E =======================================

; Cycle frames 8 through 11 once every four calls
S3SaveErase_AnimateChild:
                subq.b  #1,$25(a0)
                bpl.s   S3SaveErase_ChildFrameUpdateReturn
                move.b  #3,$25(a0)
                addq.b  #1,$28(a0)
                move.b  $28(a0),d0
                andi.b  #3,d0
                addq.b  #8,d0
                move.b  d0,sub2_mapframe(a0)

S3SaveErase_ChildFrameUpdateReturn:
                rts
; End of function S3SaveErase_AnimateChild

; =============== S U B R O U T I N E =======================================

Load_Icon_Art:
                cmpi.b  #6,d1
                bhi.s   S3SaveErase_SelectFinishPaletteByChaos
                move.l  a1,-(sp)
                move.w  d1,-(sp)
                mulu.w  #$8C0,d1
                addi.l  #RAM_start,d1
                move.w  #tiles_to_bytes(ArtTile_Save_Misc+$31B),d2
                move.w  #$460,d3
                jsr     (Add_To_DMA_Queue).l
                move.w  (sp)+,d0
                movea.l (sp)+,a1
                lea     Pal_Save_ZoneCard1(pc),a2
                bra.s   S3SaveErase_SelectIndexedCardPalette
; ---------------------------------------------------------------------------

S3SaveErase_SelectFinishPaletteByChaos:
                lea     Pal_Save_FinishCard1(pc),a2
                moveq   #0,d0
                cmpi.b  #7,5(a1)
                bcs.s   S3SaveErase_SelectIndexedCardPalette
                moveq   #1,d0

S3SaveErase_SelectIndexedCardPalette:
                lsl.w   #5,d0
                adda.w  d0,a2
                lea     (Normal_palette_line_4).w,a3
                moveq   #bytesToLcnt(Normal_palette_end-Normal_palette_line_4),d0

S3SaveErase_CopyCardPaletteToNormal:
                move.l  (a2)+,(a3)+
                dbf     d0,S3SaveErase_CopyCardPaletteToNormal
                rts
; End of function Load_Icon_Art

; =============== S U B R O U T I N E =======================================

; A zero byte writes a blank tile. Any negative byte ends the label
S3Save_WriteEncodedLabel:
                lea     (VDP_data_port).l,a6
                jsr     S3Save_MakeVRAMWriteCommand(pc)
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                move.w  #make_art_tile(ArtTile_Save_Text-$10,1,1),d5
                moveq   #0,d6

S3SaveErase_WriteEncodedLabelOrBlank:
                move.b  (a1)+,d6
                bne.s   S3SaveErase_EndEncodedLabelOrWriteGlyph
                move.w  #$8000,(a6)
                bra.s   S3SaveErase_WriteEncodedLabelOrBlank
; ---------------------------------------------------------------------------

S3SaveErase_EndEncodedLabelOrWriteGlyph:
                bmi.s   S3SaveErase_EncodedLabelWriteReturn
                move.w  d5,d4
                add.w   d6,d4
                move.w  d4,(a6)
                bra.s   S3SaveErase_WriteEncodedLabelOrBlank
; ---------------------------------------------------------------------------

S3SaveErase_EncodedLabelWriteReturn:
                rts
; End of function S3Save_WriteEncodedLabel

; ---------------------------------------------------------------------------
