; Owner: game/modes/sk
; Responsibility: Save-slot selector, empty and populated slot displays, level icons and child sprite setup
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_SaveScreen_Selector:
                move.w  #$A8,d0
                moveq   #0,d1
                moveq   #0,d2
                move.b  (Dataselect_entry).w,d2
                subq.w  #1,d2
                bcs.s   loc_D1E6

loc_D1C6:
                moveq   #$D-1,d4

loc_D1C8:
                addq.w  #8,d0
                cmpi.w  #$120,d0
                bls.s   loc_D1DE
                subq.w  #8,d0
                addq.w  #8,d1
                cmpi.w  #$2C0,d1
                bls.s   loc_D1DE
                subq.w  #8,d1
                addq.w  #8,d0

loc_D1DE:
                dbf     d4,loc_D1C8
                dbf     d2,loc_D1C6

loc_D1E6:
                move.w  d0,$12(a0)
                move.w  d1,(Camera_X_pos_copy).w
                neg.w   d1
                move.w  d1,(H_scroll_buffer+2).w
                move.l  #loc_D1FA,(a0)

loc_D1FA:
                tst.w   (Events_bg+$12).w
                bne.s   loc_D212
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_D212
                move.b  #GameMode_TitleScreen,(Game_mode).w
                bra.w   loc_D2CE
; ---------------------------------------------------------------------------

loc_D212:
                tst.w   (Events_bg+$10).w
                bne.w   loc_D2CE
                tst.w   $30(a0)
                bne.s   loc_D28A
                moveq   #0,d0
                btst    #button_left,(Ctrl_1_pressed).w
                beq.s   loc_D254
                tst.w   (Events_bg+$12).w
                beq.s   loc_D238
                cmpi.b  #1,(Dataselect_entry).w
                beq.s   loc_D254

loc_D238:
                tst.b   (Dataselect_entry).w
                beq.s   loc_D254
                subq.b  #1,(Dataselect_entry).w
                moveq   #signextendB(sfx_SlotMachine),d0
                tst.w   (Events_bg+$12).w
                beq.s   loc_D24C
                moveq   #signextendB(sfx_SmallBumpers),d0

loc_D24C:
                jsr     (Play_SFX).l
                moveq   #-8,d0

loc_D254:
                btst    #button_right,(Ctrl_1_pressed).w
                beq.s   loc_D27A
                cmpi.b  #9,(Dataselect_entry).w
                beq.s   loc_D27A
                addq.b  #1,(Dataselect_entry).w
                moveq   #signextendB(sfx_SlotMachine),d0
                tst.w   (Events_bg+$12).w
                beq.s   loc_D272
                moveq   #signextendB(sfx_SmallBumpers),d0

loc_D272:
                jsr     (Play_SFX).l
                moveq   #8,d0

loc_D27A:
                move.w  d0,$2E(a0)
                beq.s   loc_D288
                move.w  #$D,$30(a0)
                bra.s   loc_D28A
; ---------------------------------------------------------------------------

loc_D288:
                bra.s   loc_D2CE
; ---------------------------------------------------------------------------

loc_D28A:
                move.w  $12(a0),d0
                move.w  (Camera_X_pos_copy).w,d1
                move.w  $2E(a0),d2
                bmi.s   loc_D2B0
                add.w   d2,d0
                cmpi.w  #$120,d0
                bls.s   loc_D2C2
                sub.w   d2,d0
                add.w   d2,d1
                cmpi.w  #$2C0,d1
                bls.s   loc_D2C2
                sub.w   d2,d1
                add.w   d2,d0
                bra.s   loc_D2C2
; ---------------------------------------------------------------------------

loc_D2B0:
                add.w   d2,d0
                cmpi.w  #$120,d0
                bhs.s   loc_D2C2
                sub.w   d2,d0
                add.w   d2,d1
                bpl.s   loc_D2C2
                sub.w   d2,d1
                add.w   d2,d0

loc_D2C2:
                move.w  d0,$12(a0)
                move.w  d1,(Camera_X_pos_copy).w
                subq.w  #1,$30(a0)

loc_D2CE:
                moveq   #8,d2
                move.b  (Dataselect_entry).w,d1
                beq.s   loc_D2E0
                neg.w   d2
                cmpi.b  #9,d1
                beq.s   loc_D2E0
                moveq   #0,d2

loc_D2E0:
                add.w   $12(a0),d2
                move.w  d2,x_pos(a0)
                moveq   #2,d0
                cmpi.w  #$F0,d2
                blo.s   loc_D2F8
                cmpi.w  #$148,d2
                bhi.s   loc_D2F8
                moveq   #1,d0

loc_D2F8:
                move.b  d0,mapping_frame(a0)
                btst    #2,(Level_frame_counter+1).w
                beq.s   locret_D30A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_D30A:
                rts
; ---------------------------------------------------------------------------

Obj_SaveScreen_NoSave_Slot:
                move.b  #$F,sub2_mapframe(a0)
                move.w  (Dataselect_nosave_player).w,d0
                addq.w  #4,d0
                move.b  d0,mapping_frame(a0)
                tst.b   (Dataselect_entry).w
                bne.s   loc_D396
                move.w  (Player_2+object_control).w,d0
                or.w    (Events_bg+$12).w,d0
                bne.s   loc_D396
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.s   loc_D376
                move.b  #GameMode_Level,(Game_mode).w
                move.w  (Dataselect_nosave_player).w,(Player_option).w
                clr.w   (Current_zone_and_act).w
                clr.w   (Apparent_zone_and_act).w
                clr.w   (Current_special_stage).w
                clr.w   (Emerald_counts).w
                clr.l   (Collected_emeralds_array).w
                clr.w   (Collected_emeralds_array+4).w
                clr.b   (Collected_emeralds_array+6).w
                clr.l   (Collected_special_ring_array).w
                clr.b   (Emeralds_converted_flag).w
                clr.l   (Save_pointer).w
                jsr     (Set_Lives_and_Continues).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_D376:
                move.w  (Dataselect_nosave_player).w,d0
                jsr     SKSave_TryCycleNewGameCharacter(pc)
                move.w  d0,(Dataselect_nosave_player).w
                addq.w  #4,d0
                move.b  d0,mapping_frame(a0)
                move.w  #1,mainspr_childsprites(a0)
                btst    #4,(Level_frame_counter+1).w
                bne.s   loc_D39A

loc_D396:
                clr.w   mainspr_childsprites(a0)

loc_D39A:
                bra.w   Set_ChildSprites
; ---------------------------------------------------------------------------

Obj_SaveScreen_Save_Slot:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_D3B0
                move.l  #Obj_SaveScreen_Emeralds,(a1)
                move.w  a0,parent2(a1)

loc_D3B0:
                moveq   #0,d0
                move.b  $2E(a0),d0
                mulu.w  #$A,d0
                addi.l  #Saved_data,d0
                move.l  d0,$30(a0)
                movea.l d0,a1
                move.b  2(a1),d0
                lsr.b   #4,d0
                move.b  d0,$35(a0)
                move.b  3(a1),d0
                move.b  d0,$37(a0)
                move.b  d0,$3A(a0)
                move.b  (a1),d0
                andi.b  #3,d0
                move.b  d0,$3B(a0)
                move.w  6(a1),d0
                lea     (Collected_emeralds_array).w,a2
                jsr     SKSave_DecodeEmeraldStates(pc)
                move.b  d1,$3C(a0)
                move.b  d2,$3D(a0)
                tst.b   9(a1)
                bne.s   loc_D41A
                cmpi.b  #3,8(a1)
                bhs.s   loc_D41A
                move.b  #3,8(a1)
                move.l  a1,-(sp)
                st      (SRAM_mask_interrupts_flag).w
                jsr     Write_SaveGame(pc)
                movea.l (sp)+,a1

loc_D41A:
                move.b  8(a1),$3E(a0)
                move.b  9(a1),$3F(a0)
                move.l  #loc_D42C,(a0)

loc_D42C:
                clr.w   mainspr_childsprites(a0)
                movea.l $30(a0),a1
                move.b  (Dataselect_entry).w,d0
                subq.b  #1,d0
                cmp.b   $2E(a0),d0
                beq.s   Load_Level_Icons
                move.b  3(a1),$37(a0)
                clr.w   $38(a0)

loc_D44A:
                move.w  $34(a0),d0
                addq.w  #4,d0
                move.b  d0,mapping_frame(a0)
                bra.w   Set_ChildSprites
; ---------------------------------------------------------------------------

Load_Level_Icons:
                tst.b   (a1)
                bmi.w   loc_D5FE
                move.w  $36(a0),d1
                jsr     Load_Icon_Art(pc)
                move.b  #$17,sub3_mapframe(a0)
                move.w  $36(a0),d1
                cmp.b   $3A(a0),d1
                bne.s   loc_D4A4
                move.b  $3B(a0),d0
                beq.s   loc_D4A4
                addq.b  #1,sub3_mapframe(a0)
                cmpi.b  #1,d0
                beq.s   loc_D496
                addq.b  #1,sub3_mapframe(a0)
                cmpi.b  #2,d0
                beq.s   loc_D496
                addq.b  #2,sub3_mapframe(a0)
                bra.s   loc_D4A4
; ---------------------------------------------------------------------------

loc_D496:
                cmpi.w  #1,$34(a0)
                bls.s   loc_D4A4
                move.b  #$23,sub3_mapframe(a0)

loc_D4A4:
                tst.w   $38(a0)
                bne.s   loc_D4B6
                tst.b   $3B(a0)
                beq.w   loc_D534
                st      $38(a0)

loc_D4B6:
                tst.w   (Player_2+object_control).w
                bne.s   loc_D44A
                tst.w   (Events_bg+$12).w
                beq.s   loc_D4D0
                clr.b   sub2_mapframe(a0)
                move.w  #2,mainspr_childsprites(a0)
                bra.w   loc_D44A
; ---------------------------------------------------------------------------

loc_D4D0:
                moveq   #$B,d6
                cmpi.w  #3,$34(a0)
                beq.s   loc_D4EE
                moveq   #$C,d6
                cmpi.w  #2,$34(a0)
                beq.s   loc_D4EE
                cmpi.b  #2,$3B(a0)
                blo.s   loc_D4EE
                moveq   #$D,d6

loc_D4EE:
                moveq   #0,d2
                move.w  $36(a0),d1
                move.b  (Ctrl_1_pressed).w,d0
                btst    #button_down,d0
                beq.s   loc_D508
                moveq   #signextendB(sfx_Switch),d2
                subq.w  #1,d1
                bpl.s   loc_D518
                move.w  d6,d1
                bra.s   loc_D518
; ---------------------------------------------------------------------------

loc_D508:
                btst    #button_up,d0
                beq.s   loc_D518
                moveq   #signextendB(sfx_Switch),d2
                addq.w  #1,d1
                cmp.w   d6,d1
                bls.s   loc_D518
                moveq   #0,d1

loc_D518:
                move.w  d1,$36(a0)
                move.l  d2,d0
                jsr     (Play_SFX).l
                move.b  #$1A,sub2_mapframe(a0)
                btst    #4,(Level_frame_counter+1).w
                beq.s   loc_D53C
                bra.s   loc_D540
; ---------------------------------------------------------------------------

loc_D534:
                tst.w   (Player_2+object_control).w
                bne.w   loc_D44A

loc_D53C:
                clr.b   sub2_mapframe(a0)

loc_D540:
                move.w  #2,mainspr_childsprites(a0)
                tst.w   (Events_bg+$12).w
                bne.w   loc_D44A
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.w   loc_D44A
                move.w  4(a1),(Collected_special_ring_array+2).w
                move.b  3(a1),d0
                tst.b   $3B(a0)
                beq.s   loc_D57A
                move.w  $36(a0),d0
                cmp.b   $3A(a0),d0
                bhs.w   loc_D44A
                clr.l   (Collected_special_ring_array).w

loc_D57A:
                jsr     SKSave_MapProgressToZoneAct(pc)
                move.w  d0,(Current_zone_and_act).w
                move.w  d0,(Apparent_zone_and_act).w
                moveq   #0,d0
                move.b  2(a1),d0
                lsr.b   #4,d0
                move.w  d0,(Player_option).w
                move.b  2(a1),d0
                andi.b  #$F,d0
                move.b  d0,(Current_special_stage).w
                move.w  6(a1),d0
                lea     (Collected_emeralds_array).w,a2
                jsr     SKSave_DecodeEmeraldStates(pc)
                move.b  d1,(Chaos_emerald_count).w
                move.b  d2,(Super_emerald_count).w
                move.l  a1,(Save_pointer).w
                jsr     (Set_Lives_and_Continues).l
                move.b  8(a1),d0
                beq.s   loc_D5CE
                cmpi.b  #3,d0
                bhs.s   loc_D5DE
                tst.b   9(a1)
                bne.s   loc_D5DE

loc_D5CE:
                move.b  #3,8(a1)
                subq.b  #1,9(a1)
                bcc.s   loc_D5DE
                clr.b   9(a1)

loc_D5DE:
                move.b  8(a1),(Life_count).w
                move.b  9(a1),(Continue_count).w
                st      (SRAM_mask_interrupts_flag).w
                jsr     Write_SaveGame(pc)
                move.b  #GameMode_Level,(Game_mode).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_D5FE:
                move.b  #$F,sub2_mapframe(a0)
                clr.b   sub3_mapframe(a0)
                move.w  (Player_2+object_control).w,d0
                or.w    (Events_bg+$12).w,d0
                bne.w   loc_D44A
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.s   loc_D67A
                move.b  #GameMode_Level,(Game_mode).w
                clr.l   (a1)
                clr.l   4(a1)
                move.w  #$300,8(a1)
                move.w  $34(a0),d0
                move.w  d0,(Player_option).w
                lsl.b   #4,d0
                move.b  d0,2(a1)
                clr.w   (Current_zone_and_act).w
                clr.w   (Apparent_zone_and_act).w
                clr.w   (Current_special_stage).w
                clr.w   (Emerald_counts).w
                clr.l   (Collected_emeralds_array).w
                clr.w   (Collected_emeralds_array+4).w
                clr.b   (Collected_emeralds_array+6).w
                clr.l   (Collected_special_ring_array).w
                clr.b   (Emeralds_converted_flag).w
                move.l  a1,(Save_pointer).w
                jsr     (Set_Lives_and_Continues).l
                st      (SRAM_mask_interrupts_flag).w
                jsr     Write_SaveGame(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_D67A:
                move.w  $34(a0),d0
                jsr     SKSave_TryCycleNewGameCharacter(pc)
                move.w  d0,$34(a0)
                addq.w  #4,d0
                move.b  d0,mapping_frame(a0)
                move.w  #1,mainspr_childsprites(a0)
                btst    #4,(Level_frame_counter+1).w
                bne.s   Set_ChildSprites
                clr.w   mainspr_childsprites(a0)

Set_ChildSprites:
                move.w  $12(a0),d0
                sub.w   (Camera_X_pos_copy).w,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a0),d1
                move.w  d0,sub2_x_pos(a0)
                move.w  d1,sub2_y_pos(a0)
                move.w  d0,sub3_x_pos(a0)
                move.w  d1,sub3_y_pos(a0)
                cmpi.b  #$1A,sub2_mapframe(a0)
                bne.s   loc_D6CA
                subq.w  #8,sub2_y_pos(a0)

loc_D6CA:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Use fresh Up or Down while cursor motion is idle
SKSave_TryCycleNewGameCharacter:
                moveq   #0,d2
                tst.w   (Player_2+objoff_30).w
                bne.s   loc_D6FA
                move.b  (Ctrl_1_pressed).w,d1
                lsr.w   #1,d1
                bcc.s   loc_D6EE
                moveq   #signextendB(sfx_Switch),d2
                addq.w  #1,d0
                cmpi.w  #3,d0
                bls.s   loc_D6FA
                moveq   #0,d0
                bra.s   loc_D6FA
; ---------------------------------------------------------------------------

loc_D6EE:
                lsr.w   #1,d1
                bcc.s   loc_D6FA
                moveq   #signextendB(sfx_Switch),d2
                subq.w  #1,d0
                bpl.s   loc_D6FA
                moveq   #3,d0

loc_D6FA:
                tst.w   d2
                beq.s   locret_D70A
                move.l  d0,-(sp)
                move.l  d2,d0
                jsr     (Play_SFX).l
                move.l  (sp)+,d0

locret_D70A:
                rts
; End of function SKSave_TryCycleNewGameCharacter

; ---------------------------------------------------------------------------
