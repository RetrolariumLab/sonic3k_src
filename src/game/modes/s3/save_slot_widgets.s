; Owner: game/modes/s3
; Responsibility: Save-slot selector, empty and populated slot displays, level icons and child sprite setup
; Source provenance and ranges: config/reconstruction/source_layout.json
Obj_SaveScreen_Selector:
                move.w  #$A8,d0
                moveq   #0,d1
                moveq   #0,d2
                move.b  (Dataselect_entry).w,d2
                subq.w  #1,d2
                bcs.s   loc_C098

loc_C078:
                moveq   #$D-1,d4

loc_C07A:
                addq.w  #8,d0
                cmpi.w  #$120,d0
                bls.s   loc_C090
                subq.w  #8,d0
                addq.w  #8,d1
                cmpi.w  #$1F0,d1
                bls.s   loc_C090
                subq.w  #8,d1
                addq.w  #8,d0

loc_C090:
                dbf     d4,loc_C07A
                dbf     d2,loc_C078

loc_C098:
                move.w  d0,$12(a0)
                move.w  d1,(Camera_X_pos_copy).w
                neg.w   d1
                move.w  d1,(H_scroll_buffer+2).w
                move.l  #loc_C0AC,(a0)

loc_C0AC:
                tst.w   (Events_bg+$12).w
                bne.s   loc_C0C4
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_C0C4
                move.b  #GameMode_TitleScreen,(Game_mode).w
                bra.w   loc_C180
; ---------------------------------------------------------------------------

loc_C0C4:
                tst.w   (Events_bg+$10).w
                bne.w   loc_C180
                tst.w   $30(a0)
                bne.s   loc_C13C
                moveq   #0,d0
                btst    #button_left,(Ctrl_1_pressed).w
                beq.s   loc_C106
                tst.w   (Events_bg+$12).w
                beq.s   loc_C0EA
                cmpi.b  #1,(Dataselect_entry).w
                beq.s   loc_C106

loc_C0EA:
                tst.b   (Dataselect_entry).w
                beq.s   loc_C106
                subq.b  #1,(Dataselect_entry).w
                moveq   #signextendB(sfx_SlotMachine),d0
                tst.w   (Events_bg+$12).w
                beq.s   loc_C0FE
                moveq   #signextendB(sfx_SmallBumpers),d0

loc_C0FE:
                jsr     (Play_SFX).l
                moveq   #-8,d0

loc_C106:
                btst    #button_right,(Ctrl_1_pressed).w
                beq.s   loc_C12C
                cmpi.b  #7,(Dataselect_entry).w
                beq.s   loc_C12C
                addq.b  #1,(Dataselect_entry).w
                moveq   #signextendB(sfx_SlotMachine),d0
                tst.w   (Events_bg+$12).w
                beq.s   loc_C124
                moveq   #signextendB(sfx_SmallBumpers),d0

loc_C124:
                jsr     (Play_SFX).l
                moveq   #8,d0

loc_C12C:
                move.w  d0,$2E(a0)
                beq.s   loc_C13A
                move.w  #$D,$30(a0)
                bra.s   loc_C13C
; ---------------------------------------------------------------------------

loc_C13A:
                bra.s   loc_C180
; ---------------------------------------------------------------------------

loc_C13C:
                move.w  $12(a0),d0
                move.w  (Camera_X_pos_copy).w,d1
                move.w  $2E(a0),d2
                bmi.s   loc_C162
                add.w   d2,d0
                cmpi.w  #$120,d0
                bls.s   loc_C174
                sub.w   d2,d0
                add.w   d2,d1
                cmpi.w  #$1F0,d1
                bls.s   loc_C174
                sub.w   d2,d1
                add.w   d2,d0
                bra.s   loc_C174
; ---------------------------------------------------------------------------

loc_C162:
                add.w   d2,d0
                cmpi.w  #$120,d0
                bcc.s   loc_C174
                sub.w   d2,d0
                add.w   d2,d1
                bpl.s   loc_C174
                sub.w   d2,d1
                add.w   d2,d0

loc_C174:
                move.w  d0,$12(a0)
                move.w  d1,(Camera_X_pos_copy).w
                subq.w  #1,$30(a0)

loc_C180:
                moveq   #8,d2
                move.b  (Dataselect_entry).w,d1
                beq.s   loc_C192
                neg.w   d2
                cmpi.b  #7,d1
                beq.s   loc_C192
                moveq   #0,d2

loc_C192:
                add.w   $12(a0),d2
                move.w  d2,x_pos(a0)
                moveq   #2,d0
                cmpi.w  #$F0,d2
                bcs.s   loc_C1AA
                cmpi.w  #$148,d2
                bhi.s   loc_C1AA
                moveq   #1,d0

loc_C1AA:
                move.b  d0,mapping_frame(a0)
                btst    #2,(Level_frame_counter+1).w
                beq.s   locret_C1BC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_C1BC:
                rts
; ---------------------------------------------------------------------------

Obj_SaveScreen_NoSave_Slot:
                move.b  #$F,sub2_mapframe(a0)
                move.w  (Dataselect_nosave_player).w,d0
                addq.w  #4,d0
                move.b  d0,mapping_frame(a0)
                tst.b   (Dataselect_entry).w
                bne.s   loc_C244
                move.w  (Player_2+object_control).w,d0
                or.w    (Events_bg+$12).w,d0
                bne.s   loc_C244
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.s   loc_C224
                move.b  #GameMode_Level,(Game_mode).w
                move.w  (Dataselect_nosave_player).w,(Player_option).w
                clr.w   (Current_zone_and_act).w
                clr.w   (Apparent_zone_and_act).w
                clr.w   (Current_special_stage).w
                clr.w   (Chaos_emerald_count).w
                clr.l   (Collected_emeralds_array).w
                clr.w   (Collected_emeralds_array+4).w
                clr.b   (Collected_emeralds_array+6).w
                clr.l   (Collected_special_ring_array).w
                clr.l   (Save_pointer).w
                jsr     (Set_Lives_and_Continues).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_C224:
                move.w  (Dataselect_nosave_player).w,d0
                jsr     S3Save_TryCycleNewGameCharacter(pc)
                move.w  d0,(Dataselect_nosave_player).w
                addq.w  #4,d0
                move.b  d0,mapping_frame(a0)
                move.w  #1,mainspr_childsprites(a0)
                btst    #4,(Level_frame_counter+1).w
                bne.s   loc_C248

loc_C244:
                clr.w   mainspr_childsprites(a0)

loc_C248:
                bra.w   Set_ChildSprites
; ---------------------------------------------------------------------------

Obj_SaveScreen_Save_Slot:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_C25E
                move.l  #Obj_SaveScreen_Emeralds,(a1)
                move.w  a0,parent2(a1)

loc_C25E:
                moveq   #0,d0
                move.b  $2E(a0),d0
                lsl.w   #3,d0
                addi.l  #Saved_data,d0
                move.l  d0,$30(a0)
                movea.l d0,a1
                move.b  2(a1),$35(a0)
                move.b  3(a1),$37(a0)
                move.l  #loc_C284,(a0)

loc_C284:
                clr.w   mainspr_childsprites(a0)
                movea.l $30(a0),a1
                move.b  (Dataselect_entry).w,d0
                subq.b  #1,d0
                cmp.b   $2E(a0),d0
                beq.s   Load_Level_Icons
                move.b  3(a1),$37(a0)
                clr.w   $38(a0)

loc_C2A2:
                move.w  $34(a0),d0
                addq.w  #4,d0
                move.b  d0,mapping_frame(a0)
                bra.w   Set_ChildSprites
; ---------------------------------------------------------------------------

Load_Level_Icons:
                tst.b   (a1)
                bmi.w   loc_C40A
                move.w  $36(a0),d1
                jsr     Load_Icon_Art(pc)
                move.b  #$17,sub3_mapframe(a0)
                cmpi.w  #6,$36(a0)
                bls.s   loc_C2DC
                addq.b  #1,sub3_mapframe(a0)
                cmpi.b  #7,5(a1)
                bcs.s   loc_C2DC
                addq.b  #1,sub3_mapframe(a0)

loc_C2DC:
                tst.w   $38(a0)
                bne.s   loc_C2EE
                cmpi.w  #6,$36(a0)
                bls.s   loc_C360
                st      $38(a0)

loc_C2EE:
                tst.w   (Player_2+object_control).w
                bne.s   loc_C2A2
                tst.w   (Events_bg+$12).w
                beq.s   loc_C306
                clr.b   sub2_mapframe(a0)
                move.w  #2,mainspr_childsprites(a0)
                bra.s   loc_C2A2
; ---------------------------------------------------------------------------

loc_C306:
                moveq   #0,d2
                move.w  $36(a0),d1
                move.b  (Ctrl_1_pressed).w,d0
                btst    #button_down,d0
                beq.s   loc_C32A
                moveq   #signextendB(sfx_Switch),d2
                subq.w  #1,d1
                bpl.s   loc_C320
                moveq   #6,d1
                bra.s   loc_C344
; ---------------------------------------------------------------------------

loc_C320:
                cmpi.w  #4,d1
                bne.s   loc_C344
                subq.w  #1,d1
                bra.s   loc_C344
; ---------------------------------------------------------------------------

loc_C32A:
                btst    #button_up,d0
                beq.s   loc_C344
                moveq   #signextendB(sfx_Switch),d2
                addq.w  #1,d1
                cmpi.w  #4,d1
                bne.s   loc_C33C
                addq.w  #1,d1

loc_C33C:
                cmpi.w  #6,d1
                bls.s   loc_C344
                moveq   #0,d1

loc_C344:
                move.w  d1,$36(a0)
                move.l  d2,d0
                jsr     (Play_SFX).l
                move.b  #$1A,sub2_mapframe(a0)
                btst    #4,(Level_frame_counter+1).w
                beq.s   loc_C368
                bra.s   loc_C36C
; ---------------------------------------------------------------------------

loc_C360:
                tst.w   (Player_2+object_control).w
                bne.w   loc_C2A2

loc_C368:
                clr.b   sub2_mapframe(a0)

loc_C36C:
                move.w  #2,mainspr_childsprites(a0)
                tst.w   (Events_bg+$12).w
                bne.w   loc_C2A2
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.w   loc_C2A2
                move.b  #GameMode_Level,(Game_mode).w
                clr.l   (Collected_special_ring_array).w
                cmpi.b  #6,3(a1)
                bls.s   loc_C3AE
                move.w  $36(a0),d0
                cmpi.b  #6,d0
                bls.s   loc_C3BE
                move.w  #$601,d0
                move.b  #GameMode_S3Credits,(Game_mode).w
                bra.s   loc_C3C0
; ---------------------------------------------------------------------------

loc_C3AE:
                move.b  1(a1),(Collected_special_ring_array+2).w
                move.b  7(a1),(Collected_special_ring_array+3).w
                move.b  3(a1),d0

loc_C3BE:
                lsl.w   #8,d0

loc_C3C0:
                move.w  d0,(Current_zone_and_act).w
                move.w  d0,(Apparent_zone_and_act).w
                moveq   #0,d0
                move.b  2(a1),d0
                move.w  d0,(Player_option).w
                move.b  4(a1),(Current_special_stage).w
                moveq   #0,d0
                move.b  5(a1),d0
                move.w  d0,(Chaos_emerald_count).w
                move.b  6(a1),d0
                lea     (Collected_emeralds_array).w,a3
                moveq   #6,d1

loc_C3EC:
                moveq   #0,d2
                lsl.b   #1,d0
                bcc.s   loc_C3F4
                moveq   #1,d2

loc_C3F4:
                move.b  d2,(a3)+
                dbf     d1,loc_C3EC
                move.l  a1,(Save_pointer).w
                jsr     (Set_Lives_and_Continues).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_C40A:
                move.b  #$F,sub2_mapframe(a0)
                clr.b   sub3_mapframe(a0)
                move.w  (Player_2+object_control).w,d0
                or.w    (Events_bg+$12).w,d0
                bne.w   loc_C2A2
                move.b  (Ctrl_1_pressed).w,d0
                andi.w  #button_A_mask|button_C_mask|button_start_mask,d0
                beq.s   loc_C476
                move.b  #GameMode_Level,(Game_mode).w
                clr.l   (a1)
                clr.l   4(a1)
                move.w  $34(a0),d0
                move.b  d0,2(a1)
                move.w  d0,(Player_option).w
                clr.w   (Current_zone_and_act).w
                clr.w   (Apparent_zone_and_act).w
                clr.w   (Current_special_stage).w
                clr.w   (Chaos_emerald_count).w
                clr.l   (Collected_emeralds_array).w
                clr.w   (Collected_emeralds_array+4).w
                clr.b   (Collected_emeralds_array+6).w
                clr.l   (Collected_special_ring_array).w
                move.l  a1,(Save_pointer).w
                jsr     (Set_Lives_and_Continues).l
                jsr     Write_SaveGame(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_C476:
                move.w  $34(a0),d0
                jsr     S3Save_TryCycleNewGameCharacter(pc)
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
                bne.s   loc_C4C6
                subq.w  #8,sub2_y_pos(a0)

loc_C4C6:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Use fresh Up or Down while cursor motion is idle
S3Save_TryCycleNewGameCharacter:
                moveq   #0,d2
                tst.w   (Player_2+objoff_30).w
                bne.s   loc_C4F6
                move.b  (Ctrl_1_pressed).w,d1
                lsr.w   #1,d1
                bcc.s   loc_C4EA
                moveq   #signextendB(sfx_Switch),d2
                addq.w  #1,d0
                cmpi.w  #2,d0
                bls.s   loc_C4F6
                moveq   #0,d0
                bra.s   loc_C4F6
; ---------------------------------------------------------------------------

loc_C4EA:
                lsr.w   #1,d1
                bcc.s   loc_C4F6
                moveq   #signextendB(sfx_Switch),d2
                subq.w  #1,d0
                bpl.s   loc_C4F6
                moveq   #2,d0

loc_C4F6:
                tst.w   d2
                beq.s   locret_C506
                move.l  d0,-(sp)
                move.l  d2,d0
                jsr     (Play_SFX).l
                move.l  (sp)+,d0

locret_C506:
                rts
; End of function S3Save_TryCycleNewGameCharacter

; ---------------------------------------------------------------------------
