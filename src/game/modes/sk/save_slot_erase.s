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

loc_D750:
                clr.b   5(a1)
                moveq   #0,d6
                rol.w   #2,d4
                move.w  d4,d5
                andi.w  #3,d5
                beq.s   loc_D774
                cmpi.w  #3,d5
                bne.s   loc_D768
                moveq   #$C,d6

loc_D768:
                add.b   d2,d6
                move.w  d0,(a1)
                move.w  d1,sub2_y_pos-sub2_x_pos(a1)
                move.b  d6,sub2_mapframe-sub2_x_pos(a1)

loc_D774:
                addq.w  #1,d2
                addq.w  #6,a1
                dbf     d3,loc_D750
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_SaveScreen_Delete_Save:
                moveq   #0,d0
                move.b  routine(a0),d0
                jmp     SaveScreen_Delete_Save_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SaveScreen_Delete_Save_Index:
                bra.w   loc_D7A4
; ---------------------------------------------------------------------------
                bra.w   loc_D7C0
; ---------------------------------------------------------------------------
                bra.w   loc_D7EA
; ---------------------------------------------------------------------------
                bra.w   loc_D884
; ---------------------------------------------------------------------------
                bra.w   loc_D8A4
; ---------------------------------------------------------------------------
                bra.w   loc_D8C4
; ---------------------------------------------------------------------------

loc_D7A4:
                move.b  #$40,render_flags(a0)
                move.b  #$30,width_pixels(a0)
                move.w  #1,mainspr_childsprites(a0)
                move.b  #8,sub2_mapframe(a0)
                addq.b  #4,routine(a0)

loc_D7C0:
                cmpi.b  #9,(Dataselect_entry).w
                bne.w   loc_D8A0
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.w   loc_D8A0
                moveq   #signextendB(sfx_Starpost),d0
                jsr     (Play_SFX).l
                st      (Events_bg+$12).w
                addq.b  #4,routine(a0)
                bra.w   loc_D8A0
; ---------------------------------------------------------------------------

loc_D7EA:
                jsr     SKSaveEraseAdvanceMainIconBlinkSequence(pc)
                jsr     SKSaveEraseCycleChildFramesEightThroughEleven(pc)
                tst.w   (Player_2+object_control).w
                bne.s   loc_D83C
                move.b  (Ctrl_1_pressed).w,d0
                btst    #button_B,d0
                bne.s   loc_D854
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.s   loc_D83C
                cmpi.b  #9,(Dataselect_entry).w
                beq.s   loc_D854
                moveq   #0,d0
                move.b  (Dataselect_entry).w,d0
                subq.w  #1,d0
                mulu.w  #$A,d0
                addi.l  #Saved_data,d0
                move.l  d0,$2E(a0)
                movea.l d0,a1
                tst.b   (a1)
                bmi.s   loc_D854
                moveq   #signextendB(sfx_Starpost),d0
                jsr     (Play_SFX).l
                st      (Events_bg+$10).w
                addq.b  #8,routine(a0)

loc_D83C:
                move.w  (Player_2+x_pos).w,d0
                move.w  d0,x_pos(a0)
                move.w  d0,sub2_x_pos(a0)
                move.w  y_pos(a0),sub2_y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_D854:
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

loc_D884:
                clr.w   (Events_bg+$12).w
                move.w  $12(a0),d0
                cmpi.w  #$448,d0
                blo.s   loc_D89A
                move.b  #4,routine(a0)
                bra.s   loc_D8A0
; ---------------------------------------------------------------------------

loc_D89A:
                addq.w  #8,d0
                move.w  d0,$12(a0)

loc_D8A0:
                bra.w   Set_ChildSprites
; ---------------------------------------------------------------------------

loc_D8A4:
                jsr     SKSaveEraseAdvanceMainIconBlinkSequence(pc)
                jsr     SKSaveEraseCycleChildFramesEightThroughEleven(pc)
                cmpi.b  #$B,sub2_mapframe(a0)
                bne.s   loc_D8BE
                move.b  #$C,sub2_mapframe(a0)
                addq.b  #4,routine(a0)

loc_D8BE:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_D8C4:
                jsr     SKSaveEraseAdvanceMainIconBlinkSequence(pc)
                btst    #button_right,(Ctrl_1_pressed).w
                bne.s   loc_D8FE
                btst    #button_left,(Ctrl_1_pressed).w
                beq.s   loc_D90C
                moveq   #signextendB(sfx_Perfect),d0
                jsr     (Play_SFX).l
                movea.l $2E(a0),a1
                move.w  #$8000,(a1)
                clr.l   2(a1)
                clr.w   6(a1)
                move.w  #$300,8(a1)
                st      (SRAM_mask_interrupts_flag).w
                jsr     Write_SaveGame(pc)

loc_D8FE:
                move.b  #8,routine(a0)
                clr.w   (Events_bg+$10).w
                bra.w   loc_D854
; ---------------------------------------------------------------------------

loc_D90C:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

SKSaveEraseAdvanceMainIconBlinkSequence:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_D938
                move.b  #5,anim_frame_timer(a0)

loc_D91E:
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #1,anim_frame(a0)
                move.b  byte_D93A(pc,d0.w),d0
                bpl.s   loc_D934
                clr.b   anim_frame(a0)
                bra.s   loc_D91E
; ---------------------------------------------------------------------------

loc_D934:
                move.b  d0,mapping_frame(a0)

locret_D938:
                rts
; End of function SKSaveEraseAdvanceMainIconBlinkSequence

; ---------------------------------------------------------------------------
byte_D93A:
                dc.b    $D,  $E,  $D,  $E,  $D,  $E,  $D,  $E,  $D,  $E,  $D,  $D,  $D,  $D, $FF
                even

; =============== S U B R O U T I N E =======================================

SKSaveEraseCycleChildFramesEightThroughEleven:
                subq.b  #1,$25(a0)
                bpl.s   locret_D968
                move.b  #3,$25(a0)
                addq.b  #1,$28(a0)
                move.b  $28(a0),d0
                andi.b  #3,d0
                addq.b  #8,d0
                move.b  d0,sub2_mapframe(a0)

locret_D968:
                rts
; End of function SKSaveEraseCycleChildFramesEightThroughEleven

; =============== S U B R O U T I N E =======================================

Load_Icon_Art:
                cmp.b   $3A(a0),d1
                bne.s   loc_D9A2
                tst.b   $3B(a0)
                beq.s   loc_D9A2
                cmpi.w  #1,$34(a0)
                bls.s   loc_D9C8
                cmpi.b  #3,$3B(a0)
                beq.s   loc_D9C8
                moveq   #$E,d1
                cmpi.w  #3,$34(a0)
                beq.s   loc_D992
                addq.w  #2,d1

loc_D992:
                cmpi.b  #1,$3B(a0)
                beq.s   loc_D99C
                addq.w  #1,d1

loc_D99C:
                move.w  #tiles_to_bytes(ArtTile_Save_Misc+$27D),d2
                bra.s   loc_D9A6
; ---------------------------------------------------------------------------

loc_D9A2:
                move.w  #tiles_to_bytes(ArtTile_Save_Misc+$31B),d2

loc_D9A6:
                move.l  a1,-(sp)
                move.w  d1,-(sp)
                mulu.w  #$8C0,d1
                addi.l  #RAM_start,d1
                move.w  #$460,d3
                jsr     (Add_To_DMA_Queue).l
                move.w  (sp)+,d0
                movea.l (sp)+,a1
                lea     Pal_Save_ZoneCard1(pc),a2
                bra.s   loc_D9E2
; ---------------------------------------------------------------------------

loc_D9C8:
                lea     Pal_Save_FinishCard1(pc),a2
                moveq   #0,d0
                cmpi.b  #1,$3B(a0)
                beq.s   loc_D9E2
                addq.w  #1,d0
                cmpi.b  #2,$3B(a0)
                beq.s   loc_D9E2
                addq.w  #1,d0

loc_D9E2:
                lsl.w   #5,d0
                adda.w  d0,a2
                lea     (Normal_palette_line_4).w,a3
                moveq   #bytesToLcnt(Normal_palette_end-Normal_palette_line_4),d0

loc_D9EC:
                move.l  (a2)+,(a3)+
                dbf     d0,loc_D9EC
                rts
; End of function Load_Icon_Art

; =============== S U B R O U T I N E =======================================

SKSaveWriteEncodedLabelTilesUntilNegativeTerminator:
                lea     (VDP_data_port).l,a6
                jsr     SKSaveConvertVRAMWordAddressToWriteCommand(pc)
                move.l  d0,VDP_control_port-VDP_data_port(a6)
                move.w  #make_art_tile(ArtTile_Save_Text-$10,1,1),d5
                moveq   #0,d6

loc_DA08:
                move.b  (a1)+,d6
                bne.s   loc_DA12
                move.w  #$8000,(a6)
                bra.s   loc_DA08
; ---------------------------------------------------------------------------

loc_DA12:
                bmi.s   locret_DA1C
                move.w  d5,d4
                add.w   d6,d4
                move.w  d4,(a6)
                bra.s   loc_DA08
; ---------------------------------------------------------------------------

locret_DA1C:
                rts
; End of function SKSaveWriteEncodedLabelTilesUntilNegativeTerminator

; =============== S U B R O U T I N E =======================================

SKSaveDecodeSevenTwoBitEmeraldStatesAndCounts:
                clr.b   (Emeralds_converted_flag).w
                moveq   #0,d1
                moveq   #0,d2
                moveq   #7-1,d3

loc_DA28:
                rol.w   #2,d0
                move.w  d0,d4
                andi.w  #3,d4
                move.b  d4,(a2)+
                beq.s   loc_DA3E
                addq.w  #1,d1
                cmpi.w  #3,d4
                bne.s   loc_DA3E
                addq.w  #1,d2

loc_DA3E:
                cmpi.w  #2,d4
                blo.s   loc_DA48
                st      (Emeralds_converted_flag).w

loc_DA48:
                dbf     d3,loc_DA28
                rts
; End of function SKSaveDecodeSevenTwoBitEmeraldStatesAndCounts

; =============== S U B R O U T I N E =======================================

SKSaveMapProgressIndexToZoneActWithKnucklesSSZ2Exception:
                cmpi.w  #3,$34(a0)
                bne.s   loc_DA62
                cmpi.b  #$B,d0
                bne.s   loc_DA62
                move.w  #$A01,d0
                bra.s   locret_DA6C
; ---------------------------------------------------------------------------

loc_DA62:
                andi.w  #$F,d0
                add.w   d0,d0
                move.w  LevelList_DA6E(pc,d0.w),d0

locret_DA6C:
                rts
; End of function SKSaveMapProgressIndexToZoneActWithKnucklesSSZ2Exception

; ---------------------------------------------------------------------------
LevelList_DA6E:
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
word_DB08:
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1)
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1)
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1)
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1)
                dc.w    make_art_tile($000,0,1), make_art_tile($000,0,1)
