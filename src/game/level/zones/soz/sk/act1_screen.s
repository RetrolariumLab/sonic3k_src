; Owner: game/level/zones/soz/sk
; Responsibility: Sandopolis act-one screen and background initialization, event control, deformation and private sequence data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SOZ1_ScreenInit:
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

SOZ1_ScreenEvent:
                move.w  (Screen_shake_offset).w,d0
                add.w   d0,(Camera_Y_pos_copy).w
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

SOZ1_BackgroundInit:
                move.w  (a3),$1C(a3)
                movea.w $18(a3),a1
                move.b  #$FD,$D(a1)
                jsr     sub_55D56(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                moveq   #0,d1
                jsr     (Refresh_PlaneFull).l
                jmp     loc_55DF2(pc)
; ---------------------------------------------------------------------------

SOZ1_BackgroundEvent:
                move.w  (Events_routine_bg).w,d0
                jmp     SOZ1_BackgroundEvent_Index(pc,d0.w)
; ---------------------------------------------------------------------------

SOZ1_BackgroundEvent_Index:
                bra.w   loc_55A9A
; ---------------------------------------------------------------------------
                bra.w   loc_55B04
; ---------------------------------------------------------------------------
                bra.w   loc_55B70
; ---------------------------------------------------------------------------
                bra.w   loc_55BCE
; ---------------------------------------------------------------------------
                bra.w   loc_55C26
; ---------------------------------------------------------------------------
                bra.w   loc_55C84
; ---------------------------------------------------------------------------

loc_55A9A:
                tst.w   (Events_fg_5).w
                beq.s   loc_55ACE
                clr.w   (Events_fg_5).w
                move.w  #-8,(_unkEE9C).w
                st      (Screen_shake_flag).w
                jsr     sub_55DB6(pc)
                jsr     Reset_TileOffsetPositionEff(pc)
                addi.w  #$E0,d0
                and.w   (Camera_Y_pos_mask).w,d0
                move.w  d0,(Draw_delayed_position).w
                move.w  #$F,(Draw_delayed_rowcount).w
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_55B08
; ---------------------------------------------------------------------------

loc_55ACE:
                move.w  #$B20,d0
                cmpi.w  #$4000,(Player_1+x_pos).w
                blo.s   loc_55ADE
                move.w  #$960,d0

loc_55ADE:
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                jsr     sub_55E96(pc)
                jsr     sub_55D56(pc)
                lea     (Camera_Y_pos_BG_copy).w,a6
                lea     (Camera_Y_pos_BG_rounded).w,a5
                moveq   #0,d1
                moveq   #$20,d6
                jsr     (Draw_TileRow).l
                jmp     loc_55DF2(pc)
; ---------------------------------------------------------------------------

loc_55B04:
                jsr     sub_55DB6(pc)

loc_55B08:
                move.w  (Camera_X_pos_BG_copy).w,d1
                move.w  (Camera_Y_pos_BG_copy).w,d2
                jsr     Draw_PlaneVertBottomUp(pc)
                bpl.w   loc_55BA2
                movem.l d7-a0/a2-a3,-(sp)
                lea     (SOZ1_16x16_Custom_Kos).l,a1
                lea     (Block_table+$EA0).w,a2
                jsr     (Queue_Kos).l
                lea     (ArtKosM_SOZ1_Custom).l,a1
                move.w  #tiles_to_bytes($315),d2
                jsr     (Queue_Kos_Module).l
                movem.l (sp)+,d7-a0/a2-a3
                jsr     (AllocateObject).l
                bne.s   loc_55B6A
                move.l  #loc_55F48,(a1)
                jsr     (CreateNewSprite4).l
                bne.s   loc_55B6A
                move.l  #loc_55F98,(a1)
                jsr     (CreateNewSprite4).l
                bne.s   loc_55B6A
                move.l  #loc_55FDA,(a1)

loc_55B6A:
                addq.w  #4,(Events_routine_bg).w
                bra.s   loc_55BA2
; ---------------------------------------------------------------------------

loc_55B70:
                cmpi.w  #$55,(Events_fg_5).w
                bne.s   loc_55B9E
                move.w  #$4378,d0
                cmp.w   (Player_1+x_pos).w,d0
                bhi.s   loc_55B9E
                cmpi.w  #$9A8,(Player_1+y_pos).w
                blo.s   loc_55B9E
                tst.w   (Player_mode).w
                bne.s   loc_55BB4
                cmp.w   (Player_2+x_pos).w,d0
                blo.s   loc_55BB4
                cmpi.w  #$9A8,(Player_2+y_pos).w
                bhs.s   loc_55BB4

loc_55B9E:
                jsr     sub_55D94(pc)

loc_55BA2:
                jsr     (DrawBGAsYouMove).l
                jsr     sub_55EBE(pc)
                jsr     sub_55E4C(pc)
                jmp     ShakeScreen_Setup(pc)
; ---------------------------------------------------------------------------

loc_55BB4:
                move.w  #$10-1,(Palette_fade_info).w
                move.w  #$15,(Events_bg+$04).w
                move.w  #$10,(Events_bg+$06).w
                st      (Palette_fade_timer).w
                addq.w  #4,(Events_routine_bg).w

loc_55BCE:
                tst.w   (Events_bg+$06).w
                beq.s   loc_55BE0
                subq.w  #1,(Events_bg+$06).w
                bne.s   loc_55BFE
                st      (Events_bg+$02).w
                bra.s   loc_55BFE
; ---------------------------------------------------------------------------

loc_55BE0:
                tst.w   (Events_bg+$02).w
                bne.s   loc_55BFE
                btst    #0,(Level_frame_counter+1).w
                beq.s   loc_55BFE
                move.l  a0,-(sp)
                jsr     (Pal_ToBlack).l
                movea.l (sp)+,a0
                subq.w  #1,(Events_bg+$04).w
                bmi.s   loc_55C10

loc_55BFE:
                jsr     sub_55D94(pc)
                jsr     (DrawBGAsYouMove).l
                jsr     sub_55EBE(pc)
                jmp     sub_55E4C(pc)
; ---------------------------------------------------------------------------

loc_55C10:
                move.w  #$4020-1,(Palette_fade_info).w
                move.w  #$15,(Events_bg+$04).w
                move.w  #8,(Events_bg+$06).w
                addq.w  #4,(Events_routine_bg).w

loc_55C26:
                tst.w   (Events_bg+$06).w
                beq.s   loc_55C32
                subq.w  #1,(Events_bg+$06).w
                bra.s   loc_55C4A
; ---------------------------------------------------------------------------

loc_55C32:
                btst    #0,(Level_frame_counter+1).w
                beq.s   loc_55C4A
                move.l  a0,-(sp)
                jsr     (Pal_ToBlack).l
                movea.l (sp)+,a0
                subq.w  #1,(Events_bg+$04).w
                bmi.s   loc_55C4E

loc_55C4A:
                jmp     sub_55E4C(pc)
; ---------------------------------------------------------------------------

loc_55C4E:
                movem.l d7-a0/a2-a3,-(sp)
                lea     (SOZ2_16x16_Secondary_Kos).l,a1
                lea     (Block_table+$EA0).w,a2
                jsr     (Queue_Kos).l
                lea     (ArtKosM_SOZ2_Secondary).l,a1
                move.w  #tiles_to_bytes($315),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_2C,d0
                jsr     (Load_PLC).l
                movem.l (sp)+,d7-a0/a2-a3
                addq.w  #4,(Events_routine_bg).w
                rts
; ---------------------------------------------------------------------------

loc_55C84:
                tst.b   (Kos_modules_left).w
                bne.w   locret_55D54
                move.w  #$801,(Current_zone_and_act).w
                clr.b   (Dynamic_resize_routine).w
                clr.b   (Object_load_routine).w
                clr.b   (Rings_manager_routine).w
                clr.b   (Boss_flag).w
                clr.b   (Respawn_table_keep).w
                jsr     Clear_Switches(pc)
                movem.l d7-a0/a2-a3,-(sp)
                jsr     (Load_Level).l
                jsr     (LoadSolids).l
                moveq   #PalID_SonicTails,d0
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_55CC6
                moveq   #PalID_Knuckles,d0

loc_55CC6:
                jsr     (LoadPalette).l
                moveq   #PalID_SOZ2,d0
                jsr     (LoadPalette).l
                moveq   #PalID_SOZ2,d0
                jsr     (LoadPalette_Immediate).l
                movem.l (sp)+,d7-a0/a2-a3
                jsr     sub_55EFC(pc)
                lea     (Normal_palette_line_3).w,a1
                moveq   #bytesToLcnt($40),d0

loc_55CEA:
                clr.l   (a1)+
                dbf     d0,loc_55CEA
                move.w  (Player_1+x_pos).w,d2
                sub.w   (Player_2+x_pos).w,d2
                move.w  (Player_1+y_pos).w,d3
                sub.w   (Player_2+y_pos).w,d3
                move.w  #$140,d0
                move.w  #$3AC,d1
                move.w  d0,(Player_1+x_pos).w
                move.w  d1,(Player_1+y_pos).w
                sub.w   d2,d0
                sub.w   d3,d1
                move.w  d0,(Player_2+x_pos).w
                move.w  d1,(Player_2+y_pos).w
                move.w  #$A0,d0
                move.w  #$34C,d1
                move.w  d0,(Camera_X_pos).w
                move.w  d1,(Camera_Y_pos).w
                move.w  d0,(Camera_X_pos_copy).w
                move.w  d1,(Camera_Y_pos_copy).w
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                move.w  d1,(Camera_min_Y_pos).w
                move.w  d1,(Camera_max_Y_pos).w
                move.w  d1,(Camera_target_max_Y_pos).w
                clr.l   (Events_bg+$02).w
                clr.w   (Events_fg_5).w
                clr.w   (Events_routine_bg).w

locret_55D54:
                rts

; =============== S U B R O U T I N E =======================================

sub_55D56:
                move.w  (Camera_Y_pos_copy).w,d0
                asr.w   #4,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                asr.l   #4,d0
                move.l  d0,d1
                asr.l   #1,d1
                swap    d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                swap    d0
                swap    d1
                move.w  d1,(Events_bg+$10).w
                swap    d1
                asr.l   #1,d1
                lea     (HScroll_table).w,a1
                moveq   #7-1,d2

loc_55D86:
                swap    d0
                move.w  d0,(a1)+
                swap    d0
                add.l   d1,d0
                dbf     d2,loc_55D86
                rts
; End of function sub_55D56

; =============== S U B R O U T I N E =======================================

sub_55D94:
                tst.w   (Screen_shake_flag).w
                bpl.s   sub_55DB6
                move.w  (Level_frame_counter).w,d0
                andi.w  #3,d0
                beq.s   sub_55DB6
                addq.w  #1,(_unkEE9C).w
                cmpi.w  #$280,(_unkEE9C).w
                blt.s   sub_55DB6
                move.w  #8,(Screen_shake_flag).w
; End of function sub_55D94

; =============== S U B R O U T I N E =======================================

sub_55DB6:
                tst.w   (Screen_shake_flag).w
                bpl.s   loc_55DD0
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   loc_55DD0
                moveq   #signextendB(sfx_Rumble2),d0
                jsr     (Play_SFX).l

loc_55DD0:
                move.w  (Camera_Y_pos_copy).w,d0
                subi.w  #$900,d0
                add.w   (_unkEE9C).w,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                move.w  (Camera_X_pos_copy).w,d0
                subi.w  #$3CD0,d0
                move.w  d0,(Camera_X_pos_BG_copy).w
                move.w  d0,(Events_bg+$10).w
                rts
; End of function sub_55DB6

; ---------------------------------------------------------------------------

loc_55DF2:
                lea     (HScroll_table+$010).w,a1
                lea     AIZ2_SOZ1_LRZ3_FGDeformDelta(pc),a6
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  #$DF,d1
                move.w  (Level_frame_counter).w,d2
                asr.w   #1,d2
                add.w   d0,d2
                add.w   d0,d2
                andi.w  #$3E,d2
                adda.w  d2,a6
                move.w  (Camera_X_pos_copy).w,d6
                neg.w   d6
                jsr     MakeFGDeformArray(pc)
                lea     (H_scroll_buffer).w,a1
                lea     (HScroll_table+$010).w,a2
                lea     word_560DC(pc),a4
                lea     (HScroll_table).w,a5
                lea     AIZ2_SOZ1_LRZ3_FGDeformDelta(pc),a6
                move.w  (Camera_Y_pos_BG_copy).w,d0
                move.w  #$DF,d1
                move.w  (Level_frame_counter).w,d2
                asr.w   #1,d2
                add.w   d0,d2
                add.w   d0,d2
                andi.w  #$3E,d2
                adda.w  d2,a6
                jmp     ApplyFGandBGDeformation(pc)

; =============== S U B R O U T I N E =======================================

sub_55E4C:
                lea     (H_scroll_buffer).w,a1
                lea     AIZ2_SOZ1_LRZ3_FGDeformDelta(pc),a6
                move.w  (Camera_Y_pos_copy).w,d0
                move.w  (Level_frame_counter).w,d1
                asr.w   #1,d1
                add.w   d0,d1
                add.w   d0,d1
                andi.w  #$3E,d1
                adda.w  d1,a6
                move.w  (Camera_X_pos_copy).w,d0
                neg.w   d0
                move.w  (Camera_X_pos_BG_copy).w,d1
                neg.w   d1
                move.w  #$70-1,d2

loc_55E78:
                move.w  (a6)+,d3
                move.w  d3,d4
                add.w   d0,d3
                add.w   d1,d4
                move.w  d3,(a1)+
                move.w  d4,(a1)+
                move.w  (a6)+,d3
                move.w  d3,d4
                add.w   d0,d3
                add.w   d1,d4
                move.w  d3,(a1)+
                move.w  d4,(a1)+
                dbf     d2,loc_55E78
                rts
; End of function sub_55E4C

; =============== S U B R O U T I N E =======================================

sub_55E96:
                move.w  (Camera_max_Y_pos).w,d0
                cmpi.w  #$960,d0
                bne.s   locret_55EBC
                cmp.w   (Camera_Y_pos).w,d0
                bhi.s   locret_55EBC
                move.w  d0,(Camera_min_Y_pos).w
                cmpi.w  #$4310,(Camera_X_pos).w
                blo.s   locret_55EBC
                move.w  #$4180,(Camera_min_X_pos).w
                st      (Events_fg_5).w

locret_55EBC:
                rts
; End of function sub_55E96

; =============== S U B R O U T I N E =======================================

sub_55EBE:
                move.w  (Events_bg+$00).w,d0
                beq.s   locret_55EFA
                clr.w   (Events_bg+$00).w
                movea.w $18(a3),a1
                move.b  d0,$D(a1)
                cmpi.w  #$540,(Camera_X_pos_BG_copy).w
                blo.s   locret_55EFA
                move.w  #$6A0,d1
                move.w  #$320,d0
                moveq   #5,d6
                moveq   #6-1,d2

loc_55EE4:
                movem.w d0-d2/d6,-(sp)
                jsr     (Setup_TileRowDraw).l
                movem.w (sp)+,d0-d2/d6
                addi.w  #$10,d0
                dbf     d2,loc_55EE4

locret_55EFA:
                rts
; End of function sub_55EBE

; =============== S U B R O U T I N E =======================================

sub_55EFC:
                lea     (Normal_palette_line_3+$2).w,a1
                lea     (Target_palette_line_3+$2).w,a5
                lea     word_560EA(pc),a6
                moveq   #$B-1,d0

loc_55F0A:
                move.w  (a6),(a1)+
                move.w  (a6)+,(a5)+
                dbf     d0,loc_55F0A
                lea     (Normal_palette_line_4+$2).w,a1
                lea     (Target_palette_line_4+$2).w,a5
                lea     word_56100(pc),a6
                moveq   #$F-1,d0

loc_55F20:
                move.w  (a6),(a1)+
                move.w  (a6)+,(a5)+
                dbf     d0,loc_55F20
                move.b  #5,(SOZ_darkness_level).w
                move.w  #(30*60)-1,(Palette_cycle_counter1).w
                move.b  #0,(Palette_cycle_counters+$00).w
                move.w  #4,(Palette_cycle_counters+$06).w
                move.w  #$D0,(Palette_cycle_counters+$02).w
                rts
; End of function sub_55EFC

; ---------------------------------------------------------------------------

loc_55F48:
                moveq   #0,d0
                move.b  routine(a0),d0
                jmp     loc_55F52(pc,d0.w)
; ---------------------------------------------------------------------------

loc_55F52:
                bra.w   loc_55F5E
; ---------------------------------------------------------------------------
                bra.w   loc_55F6E
; ---------------------------------------------------------------------------
                bra.w   loc_55F7C
; ---------------------------------------------------------------------------

loc_55F5E:
                tst.w   (Screen_shake_flag).w
                bne.s   locret_55F96
                move.w  #60,$2E(a0)
                addq.b  #4,routine(a0)

loc_55F6E:
                subq.w  #1,$2E(a0)
                bne.s   locret_55F96
                st      (Events_bg+$02).w
                addq.b  #4,routine(a0)

loc_55F7C:
                tst.w   (Events_bg+$02).w
                bne.s   locret_55F96
                jsr     (AllocateObject).l
                bne.s   loc_55F90
                move.l  #Obj_SOZMiniboss,(a1)

loc_55F90:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

locret_55F96:
                rts
; ---------------------------------------------------------------------------

loc_55F98:
                move.l  #loc_55FBE,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$24,width_pixels(a0)
                move.w  #$200,priority(a0)
                move.l  #Map_SOZ1EndDoor,mappings(a0)
                move.w  #$A00,y_pos(a0)

loc_55FBE:
                tst.b   (Current_act).w
                beq.s   loc_55FCA
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_55FCA:
                move.w  (Camera_X_pos).w,x_pos(a0)
                st      (Spritemask_flag).w
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_55FDA:
                move.l  #loc_56012,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$24,width_pixels(a0)
                move.w  #$380,priority(a0)
                move.w  #make_art_tile($029,2,1),art_tile(a0)
                move.l  #Map_SOZ1EndDoor,mappings(a0)
                move.w  #$439C,x_vel(a0)
                move.w  #$9D4,y_vel(a0)
                move.b  #1,mapping_frame(a0)

loc_56012:
                bclr    #7,render_flags(a0)
                tst.w   (Events_bg+$02).w
                bne.s   loc_56020
                rts
; ---------------------------------------------------------------------------

loc_56020:
                moveq   #signextendB(sfx_DoorOpen),d0
                jsr     (Play_SFX).l
                move.w  #$F6,(Events_bg+$00).w
                move.l  #loc_56034,(a0)

loc_56034:
                moveq   #1,d0
                bsr.s   sub_560A2
                cmpi.w  #$58,$2E(a0)
                blo.s   loc_56050
                move.w  #$58,$2E(a0)
                clr.w   (Events_bg+$02).w
                move.l  #loc_56056,(a0)

loc_56050:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_56056:
                tst.b   (Current_act).w
                beq.s   loc_56062
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_56062:
                bclr    #7,render_flags(a0)
                tst.w   (Events_bg+$02).w
                bne.s   loc_56070
                rts
; ---------------------------------------------------------------------------

loc_56070:
                moveq   #signextendB(sfx_DoorOpen),d0
                jsr     (Play_SFX).l
                move.l  #loc_5607E,(a0)

loc_5607E:
                moveq   #-1,d0
                bsr.s   sub_560A2
                tst.w   $2E(a0)
                bpl.s   loc_5609C
                clr.w   $2E(a0)
                move.w  #$FD,(Events_bg+$00).w
                clr.w   (Events_bg+$02).w
                move.l  #loc_56012,(a0)

loc_5609C:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_560A2:
                move.w  (Level_frame_counter).w,d1
                andi.w  #3,d1
                bne.s   loc_560AE
                add.w   d0,d0

loc_560AE:
                add.w   d0,$2E(a0)
                move.w  $1A(a0),d0
                add.w   $2E(a0),d0
                move.w  d0,y_pos(a0)
                lea     ScreenShakeArray2(pc),a1
                move.w  $2E(a0),d0
                andi.w  #$3F,d0
                move.b  (a1,d0.w),d0
                andi.w  #1,d0
                add.w   $18(a0),d0
                move.w  d0,x_pos(a0)
                rts
; End of function sub_560A2

; ---------------------------------------------------------------------------
word_560DC:
                dc.w    $110,     8,     8,     8,     8,     8, $7FFF
word_560EA:
                dc.w    $C46,  $824,  $804,  $402,  $202,  $200,     0,  $422,  $402,  $200,   $40
word_56100:
                dc.w    $6AE,  $664,  $422,  $402,  $200,     0,     0,  $EEE,  $466,  $224,     0,   $46,  $6EE,  $48C,  $26A
Map_SOZ1EndDoor:
                include "src/objects/shared/zones/soz/act1/mappings/end_door.s"
