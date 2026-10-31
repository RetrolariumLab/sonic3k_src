; Owner: game/bonus/slots/sk
; Responsibility: Rotating slot bonus Sonic lifecycle, movement, collision, gravity and cage sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Sonic_RotatingSlotBonus:
                move.w  (Ctrl_1).w,(Ctrl_1_logical).w
                tst.w   (Debug_placement_mode).w
                beq.s   loc_4B96E
                jsr     (DebugMode).l
                bra.w   sub_4BBF4
; ---------------------------------------------------------------------------

loc_4B96E:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Obj_Sonic_RotatingSlotBonus_Index(pc,d0.w),d1
                jsr     Obj_Sonic_RotatingSlotBonus_Index(pc,d1.w)

loc_4B97C:
                move.b  #2,anim(a0)
                bsr.s   sub_4B99E
                lea     (Player_1).w,a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                jsr     (Perform_Player_DPLC).l
                bsr.w   sub_4BBF4
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_4B99E:
                move.b  character_id(a0),d0
                bne.s   loc_4B9AA
                jmp     (Animate_Sonic).l
; ---------------------------------------------------------------------------

loc_4B9AA:
                cmpi.b  #1,d0
                bne.s   loc_4B9B6
                jmp     (Animate_Tails).l
; ---------------------------------------------------------------------------

loc_4B9B6:
                jmp     (Animate_Knuckles).l
; End of function sub_4B99E

; ---------------------------------------------------------------------------
Obj_Sonic_RotatingSlotBonus_Index:
                dc.w    loc_4B9CE-Obj_Sonic_RotatingSlotBonus_Index
                dc.w    loc_4BA4E-Obj_Sonic_RotatingSlotBonus_Index
                dc.w    loc_4BC1E-Obj_Sonic_RotatingSlotBonus_Index
off_4B9C2:
                dc.l    Map_Sonic
                dc.l    Map_Tails
                dc.l    Map_Knuckles
; ---------------------------------------------------------------------------

loc_4B9CE:
                addq.b  #2,routine(a0)
                move.b  #$E,y_radius(a0)
                move.b  #7,x_radius(a0)
                move.w  (Player_mode).w,d0
                subq.w  #1,d0
                bcc.s   loc_4B9E8
                moveq   #0,d0

loc_4B9E8:
                move.b  d0,character_id(a0)
                lsl.w   #2,d0
                move.l  off_4B9C2(pc,d0.w),mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$100,priority(a0)
                move.b  #2,anim(a0)
                bset    #Status_Roll,status(a0)
                bset    #Status_InAir,status(a0)
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_4BA32
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                move.l  #Obj_Tails_Tail,(Tails_tails).w
                move.w  a0,(Tails_tails+$30).w

loc_4BA32:
                clr.w   (Stat_table).w
                move.w  #$40,(SStage_scalar_index_1).w
                move.w  (Saved_ring_count).w,(Ring_count).w
                move.b  (Saved_extra_life_flags).w,(Extra_life_flags).w
                move.b  #1,(Update_HUD_ring_count).w

loc_4BA4E:
                tst.w   (Debug_mode_flag).w
                beq.s   loc_4BA62
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_4BA62
                move.w  #1,(Debug_placement_mode).w

loc_4BA62:
                move.b  #0,$30(a0)
                tst.b   object_control(a0)
                bne.s   loc_4BA80
                moveq   #0,d0
                move.b  status(a0),d0
                andi.w  #2,d0
                move.w  off_4BA90(pc,d0.w),d1
                jmp     off_4BA90(pc,d1.w)
; ---------------------------------------------------------------------------

loc_4BA80:
                move.w  (SStage_scalar_index_1).w,d0
                asl.w   #4,d0
                add.w   (Stat_table).w,d0
                move.w  d0,(Stat_table).w
                rts
; ---------------------------------------------------------------------------
off_4BA90:
                dc.w    loc_4BA94-off_4BA90
                dc.w    loc_4BA98-off_4BA90
; ---------------------------------------------------------------------------

loc_4BA94:
                bsr.w   sub_4BBB2

loc_4BA98:
                bsr.w   sub_4BABC
                bsr.w   sub_4BCB0
                bsr.w   sub_4BDCA
                bsr.w   sub_4BE3A
                jsr     (MoveSprite2).l
                move.w  (Stat_table).w,d0
                add.w   (SStage_scalar_index_1).w,d0
                move.w  d0,(Stat_table).w
                rts

; =============== S U B R O U T I N E =======================================

sub_4BABC:
                btst    #button_left,(Ctrl_1_logical).w
                beq.s   loc_4BAC8
                bsr.w   sub_4BB54

loc_4BAC8:
                btst    #button_right,(Ctrl_1_logical).w
                beq.s   loc_4BAD4
                bsr.w   sub_4BB84

loc_4BAD4:
                move.b  (Ctrl_1_logical).w,d0
                andi.b  #button_left_mask|button_right_mask,d0
                bne.s   loc_4BB04
                move.w  ground_vel(a0),d0
                beq.s   loc_4BB04
                bmi.s   loc_4BAF6
                subi.w  #$C,d0
                bcc.s   loc_4BAF0
                move.w  #0,d0

loc_4BAF0:
                move.w  d0,ground_vel(a0)
                bra.s   loc_4BB04
; ---------------------------------------------------------------------------

loc_4BAF6:
                addi.w  #$C,d0
                bcc.s   loc_4BB00
                move.w  #0,d0

loc_4BB00:
                move.w  d0,ground_vel(a0)

loc_4BB04:
                move.b  (Stat_table).w,d0
                addi.b  #$20,d0
                andi.b  #$C0,d0
                neg.b   d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                add.l   d1,x_pos(a0)
                muls.w  ground_vel(a0),d0
                add.l   d0,y_pos(a0)
                movem.l d0-d1,-(sp)
                move.l  y_pos(a0),d2
                move.l  x_pos(a0),d3
                bsr.w   sub_4BD5A
                beq.s   loc_4BB4E
                movem.l (sp)+,d0-d1
                sub.l   d1,x_pos(a0)
                sub.l   d0,y_pos(a0)
                move.w  #0,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_4BB4E:
                movem.l (sp)+,d0-d1
                rts
; End of function sub_4BABC

; =============== S U B R O U T I N E =======================================

sub_4BB54:
                bset    #Status_Facing,status(a0)
                move.w  ground_vel(a0),d0
                beq.s   loc_4BB62
                bpl.s   loc_4BB76

loc_4BB62:
                subi.w  #$C,d0
                cmpi.w  #-$800,d0
                bgt.s   loc_4BB70
                move.w  #-$800,d0

loc_4BB70:
                move.w  d0,ground_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_4BB76:
                subi.w  #$40,d0
                bcc.s   loc_4BB7E
                nop

loc_4BB7E:
                move.w  d0,ground_vel(a0)
                rts
; End of function sub_4BB54

; =============== S U B R O U T I N E =======================================

sub_4BB84:
                bclr    #Status_Facing,status(a0)
                move.w  ground_vel(a0),d0
                bmi.s   loc_4BBA4
                addi.w  #$C,d0
                cmpi.w  #$800,d0
                blt.s   loc_4BB9E
                move.w  #$800,d0

loc_4BB9E:
                move.w  d0,ground_vel(a0)
                bra.s   locret_4BBB0
; ---------------------------------------------------------------------------

loc_4BBA4:
                addi.w  #$40,d0
                bcc.s   loc_4BBAC
                nop

loc_4BBAC:
                move.w  d0,ground_vel(a0)

locret_4BBB0:
                rts
; End of function sub_4BB84

; =============== S U B R O U T I N E =======================================

sub_4BBB2:
                move.b  (Ctrl_1_pressed_logical).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   locret_4BBF2
                move.b  (Stat_table).w,d0
                andi.b  #$FC,d0
                neg.b   d0
                subi.b  #$40,d0
                jsr     (GetSineCosine).l
                muls.w  #$680,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  #$680,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                bset    #Status_InAir,status(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l

locret_4BBF2:
                rts
; End of function sub_4BBB2

; =============== S U B R O U T I N E =======================================

sub_4BBF4:
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                move.w  (Camera_X_pos).w,d0
                subi.w  #$A0,d3
                bcs.s   loc_4BC0C
                sub.w   d3,d0
                sub.w   d0,(Camera_X_pos).w

loc_4BC0C:
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$70,d2
                bcs.s   locret_4BC1C
                sub.w   d2,d0
                sub.w   d0,(Camera_Y_pos).w

locret_4BC1C:
                rts
; End of function sub_4BBF4

; ---------------------------------------------------------------------------

loc_4BC1E:
                addi.w  #$40,(SStage_scalar_index_1).w
                cmpi.w  #$1800,(SStage_scalar_index_1).w
                bne.s   loc_4BC46
                move.w  #$40-1,(Palette_fade_info).w
                clr.w   (Pal_fade_delay).w
                move.l  #loc_4BC54,(a0)
                move.w  #60,$38(a0)
                st      (Palette_cycle_counters+$00).w

loc_4BC46:
                move.w  (Stat_table).w,d0
                add.w   (SStage_scalar_index_1).w,d0
                move.w  d0,(Stat_table).w
                rts
; ---------------------------------------------------------------------------

loc_4BC54:
                subq.w  #1,(Pal_fade_delay).w
                bpl.s   loc_4BC6A
                move.w  #2,(Pal_fade_delay).w
                move.l  a0,-(sp)
                jsr     (Pal_ToBlack).l
                movea.l (sp)+,a0

loc_4BC6A:
                addi.w  #$40,(SStage_scalar_index_1).w
                move.w  (Stat_table).w,d0
                add.w   (SStage_scalar_index_1).w,d0
                move.w  d0,(Stat_table).w
                subq.w  #1,$38(a0)
                bne.s   loc_4BCAC
                move.w  (Saved_zone_and_act).w,(Current_zone_and_act).w
                move.w  (Saved_apparent_zone_and_act).w,(Apparent_zone_and_act).w
                move.b  (Saved_last_star_post_hit).w,(Last_star_post_hit).w
                move.b  #0,(Special_bonus_entry_flag).w
                move.b  #1,(Restart_level_flag).w
                move.w  (Ring_count).w,(Saved_ring_count).w
                move.b  (Extra_life_flags).w,(Saved_extra_life_flags).w

loc_4BCAC:
                bra.w   loc_4B97C

; =============== S U B R O U T I N E =======================================

sub_4BCB0:
                move.l  y_pos(a0),d2
                move.l  x_pos(a0),d3
                move.b  (Stat_table).w,d0
                andi.b  #$FC,d0
                jsr     (GetSineCosine).l
                move.w  x_vel(a0),d4
                ext.l   d4
                asl.l   #8,d4
                muls.w  #$2A,d0
                add.l   d4,d0
                move.w  y_vel(a0),d4
                ext.l   d4
                asl.l   #8,d4
                muls.w  #$2A,d1
                add.l   d4,d1
                add.l   d0,d3
                bsr.w   sub_4BD5A
                beq.s   loc_4BD10
                sub.l   d0,d3
                moveq   #0,d0
                move.w  d0,x_vel(a0)
                bclr    #Status_InAir,status(a0)
                move.b  #4,$3A(a0)
                add.l   d1,d2
                bsr.w   sub_4BD5A
                beq.s   loc_4BD2C
                sub.l   d1,d2
                moveq   #0,d1
                move.w  d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_4BD10:
                add.l   d1,d2
                bsr.w   sub_4BD5A
                beq.s   loc_4BD3A
                sub.l   d1,d2
                moveq   #0,d1
                move.w  d1,y_vel(a0)
                bclr    #Status_InAir,status(a0)
                move.b  #4,$3A(a0)

loc_4BD2C:
                asr.l   #8,d0
                asr.l   #8,d1
                move.w  d0,x_vel(a0)
                move.w  d1,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_4BD3A:
                asr.l   #8,d0
                asr.l   #8,d1
                move.w  d0,x_vel(a0)
                move.w  d1,y_vel(a0)
                tst.b   $3A(a0)
                bne.s   loc_4BD54
                bset    #Status_InAir,status(a0)
                rts
; ---------------------------------------------------------------------------

loc_4BD54:
                subq.b  #1,$3A(a0)
                rts
; End of function sub_4BCB0

; =============== S U B R O U T I N E =======================================

sub_4BD5A:
                lea     (RAM_start+$3000).l,a1
                moveq   #0,d4
                swap    d2
                move.w  d2,d4
                swap    d2
                addi.w  #$44,d4
                divu.w  #$18,d4
                mulu.w  #$80,d4
                adda.l  d4,a1
                moveq   #0,d4
                swap    d3
                move.w  d3,d4
                swap    d3
                addi.w  #$14,d4
                divu.w  #$18,d4
                adda.w  d4,a1
                moveq   #0,d5
                move.b  (a1)+,d4
                bsr.s   sub_4BDA2
                move.b  (a1)+,d4
                bsr.s   sub_4BDA2
                adda.w  #$7E,a1
                move.b  (a1)+,d4
                bsr.s   sub_4BDA2
                move.b  (a1)+,d4
                bsr.s   sub_4BDA2
                tst.b   d5
                rts
; End of function sub_4BD5A

; =============== S U B R O U T I N E =======================================

sub_4BDA2:
                beq.s   locret_4BDB0
                cmpi.b  #8,d4
                beq.s   locret_4BDB0
                cmpi.b  #$10,d4
                blo.s   loc_4BDB2

locret_4BDB0:
                rts
; ---------------------------------------------------------------------------

loc_4BDB2:
                cmpi.b  #7,d4
                beq.s   loc_4BDC6
                cmpi.b  #9,d4
                bhs.s   loc_4BDC6
                move.b  d4,$30(a0)
                move.l  a1,$32(a0)

loc_4BDC6:
                moveq   #-1,d5
                rts
; End of function sub_4BDA2

; =============== S U B R O U T I N E =======================================

sub_4BDCA:
                lea     (RAM_start+$3000).l,a1
                moveq   #0,d4
                move.w  y_pos(a0),d4
                addi.w  #$50,d4
                divu.w  #$18,d4
                mulu.w  #$80,d4
                adda.l  d4,a1
                moveq   #0,d4
                move.w  x_pos(a0),d4
                addi.w  #$20,d4
                divu.w  #$18,d4
                adda.w  d4,a1
                move.b  (a1),d4
                bne.s   loc_4BDFC
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_4BDFC:
                cmpi.b  #8,d4
                bne.s   loc_4BE36
                bsr.w   sub_4B57C
                bne.s   loc_4BE10
                move.b  #1,(a2)
                move.l  a1,4(a2)

loc_4BE10:
                jsr     (GiveRing).l
                cmpi.w  #50,(Ring_count).w
                blo.s   loc_4BE32
                bset    #0,(Extra_life_flags).w
                bne.s   loc_4BE32
                addq.b  #1,(Continue_count).w
                moveq   #signextendB(sfx_Continue),d0
                jsr     (Play_Music).l

loc_4BE32:
                moveq   #0,d4
                rts
; ---------------------------------------------------------------------------

loc_4BE36:
                moveq   #-1,d4
                rts
; End of function sub_4BDCA

; =============== S U B R O U T I N E =======================================

sub_4BE3A:
                move.b  $30(a0),d0
                bne.s   loc_4BE5A
                subq.b  #1,$36(a0)
                bpl.s   loc_4BE4C
                move.b  #0,$36(a0)

loc_4BE4C:
                subq.b  #1,$37(a0)
                bpl.s   locret_4BE58
                move.b  #0,$37(a0)

locret_4BE58:
                rts
; ---------------------------------------------------------------------------

loc_4BE5A:
                cmpi.b  #5,d0
                bne.s   loc_4BED0
                move.l  $32(a0),d1
                subi.l  #-$CFFF,d1
                move.w  d1,d2
                andi.w  #$7F,d1
                mulu.w  #$18,d1
                subi.w  #$14,d1
                lsr.w   #7,d2
                andi.w  #$7F,d2
                mulu.w  #$18,d2
                subi.w  #$44,d2
                sub.w   x_pos(a0),d1
                sub.w   y_pos(a0),d2
                jsr     (GetArcTan).l
                jsr     (GetSineCosine).l
                muls.w  #-$700,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  #-$700,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                bset    #Status_InAir,status(a0)
                bsr.w   sub_4B57C
                bne.s   loc_4BEC8
                move.b  #2,(a2)
                move.l  $32(a0),d0
                subq.l  #1,d0
                move.l  d0,4(a2)

loc_4BEC8:
                moveq   #signextendB(sfx_Bumper),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

loc_4BED0:
                cmpi.b  #4,d0
                bne.s   loc_4BEE4
                addq.b  #2,routine(a0)
                moveq   #signextendB(sfx_Goal),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_4BEE4:
                cmpi.b  #6,d0
                bne.s   loc_4BF18
                tst.b   $37(a0)
                bne.w   locret_4BF60
                move.b  #$1E,$37(a0)
                bsr.w   sub_4B57C
                bne.s   loc_4BF0C
                move.b  #4,(a2)
                move.l  $32(a0),d0
                subq.l  #1,d0
                move.l  d0,4(a2)

loc_4BF0C:
                neg.w   (SStage_scalar_index_1).w
                moveq   #signextendB(sfx_LaunchGo),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

loc_4BF18:
                cmpi.b  #1,d0
                beq.s   loc_4BF30
                cmpi.b  #2,d0
                beq.s   loc_4BF30
                cmpi.b  #3,d0
                beq.s   loc_4BF30
                cmpi.b  #4,d0
                bne.s   locret_4BF60

loc_4BF30:
                bsr.w   sub_4B57C
                bne.s   loc_4BF58
                move.b  #3,(a2)
                movea.l $32(a0),a1
                subq.l  #1,a1
                move.l  a1,4(a2)
                move.b  (a1),d0
                addq.b  #1,d0
                cmpi.b  #4,d0
                bls.s   loc_4BF54
                clr.b   d0
                move.b  #4,d0

loc_4BF54:
                move.b  d0,4(a2)

loc_4BF58:
                moveq   #signextendB(sfx_Flipper),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

locret_4BF60:
                rts
; End of function sub_4BE3A

; ---------------------------------------------------------------------------

loc_4BF62:
                move.w  #$460,x_pos(a0)
                move.w  #$430,y_pos(a0)
                move.l  #Map_SlotBonusCage,mappings(a0)
                move.w  #make_art_tile(ArtTile_SlotsBlocks+$146,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.l  #loc_4BF9A,(a0)

loc_4BF9A:
                move.b  (Stat_table).w,d0
                andi.b  #$FC,d0
                jsr     (GetSineCosine).l
                lea     (Player_1).w,a1
                move.w  #$460,d2
                sub.w   x_pos(a1),d2
                move.w  d2,d4
                move.w  #$430,d3
                sub.w   y_pos(a1),d3
                move.w  d3,d5
                muls.w  d0,d4
                muls.w  d0,d5
                muls.w  d1,d2
                muls.w  d1,d3
                add.l   d4,d3
                asr.l   #8,d3
                sub.l   d5,d2
                asr.l   #8,d2
                add.w   x_pos(a1),d2
                add.w   y_pos(a1),d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                move.w  d2,(Events_bg+$00).w
                move.w  d3,(Events_bg+$02).w
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.w   sub_4C014
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_4C012
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #6,mapping_frame(a0)
                blo.s   locret_4C012
                move.b  #0,mapping_frame(a0)

locret_4C012:
                rts

; =============== S U B R O U T I N E =======================================

sub_4C014:
                move.w  (a2),d0
                move.w  off_4C01E(pc,d0.w),d0
                jmp     off_4C01E(pc,d0.w)
; End of function sub_4C014

; ---------------------------------------------------------------------------
off_4C01E:
                dc.w    loc_4C026-off_4C01E
                dc.w    loc_4C21C-off_4C01E
                dc.w    loc_4C250-off_4C01E
                dc.w    loc_4C292-off_4C01E
; ---------------------------------------------------------------------------

loc_4C026:
                tst.b   object_control(a1)
                bne.s   locret_4C0A8
                tst.w   (SStage_scalar_result_0).w
                bne.s   locret_4C0A8
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$18,d0
                cmpi.w  #$30,d0
                bhs.s   locret_4C0A8
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$18,d0
                cmpi.w  #$30,d0
                bhs.s   locret_4C0A8
                move.w  #$460,x_pos(a1)
                move.w  #$430,y_pos(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #$81,object_control(a1)
                addq.w  #2,(a2)+
                move.w  #$78,(a2)
                move.w  a1,$42(a0)
                move.b  #1,(Palette_cycle_counters+$00).w
                cmpi.b  #$18,(SStage_scalar_result_0+2).w
                bne.s   locret_4C0A8
                move.b  #8,(SStage_scalar_result_0+2).w
                clr.w   $32(a0)
                move.w  #-1,(SStage_scalar_result_0).w
                move.w  #-1,$2E(a0)

locret_4C0A8:
                rts
; ---------------------------------------------------------------------------

loc_4C0AA:
                move.w  (SStage_scalar_result_1+2).w,d0
                bpl.w   loc_4C172
                tst.w   $2E(a0)
                bpl.s   loc_4C0BE
                move.w  #$64,$2E(a0)

loc_4C0BE:
                tst.w   $2E(a0)
                beq.w   loc_4C164
                btst    #0,(Level_frame_counter+1).w
                beq.w   loc_4C16C
                cmpi.w  #$10,$30(a0)
                bhs.w   loc_4C16C
                jsr     (AllocateObject).l
                bne.w   loc_4C16C
                move.l  #Obj_SlotSpike,(a1)
                move.l  #Map_SlotSpike,mappings(a1)
                move.w  #make_art_tile(ArtTile_SlotsBlocks+$155,1,0),art_tile(a1)
                move.b  #4,render_flags(a1)
                move.b  #$10,width_pixels(a1)
                move.w  #$200,priority(a1)
                move.w  #$1E,$40(a1)
                move.w  $32(a0),$32(a1)
                addi.w  #$90,$32(a0)
                move.w  x_pos(a0),$3C(a1)
                move.w  y_pos(a0),$3E(a1)
                move.w  $32(a1),d0
                jsr     (GetSineCosine).l
                asr.w   #1,d1
                add.w   $3C(a1),d1
                move.w  d1,$34(a1)
                move.w  d1,x_pos(a1)
                asr.w   #1,d0
                add.w   $3E(a1),d0
                move.w  d0,$38(a1)
                move.w  d0,y_pos(a1)
                lea     $30(a0),a2
                move.l  a2,$2E(a1)
                move.w  $42(a0),$42(a1)
                addq.w  #1,$30(a0)
                subq.w  #1,$2E(a0)

loc_4C164:
                tst.w   $30(a0)
                beq.w   loc_4C23E

loc_4C16C:
                addq.w  #1,(SStage_scalar_index_2).w
                rts
; ---------------------------------------------------------------------------

loc_4C172:
                beq.w   loc_4C214
                btst    #0,(Level_frame_counter+1).w
                beq.w   locret_4C21A
                cmpi.w  #$10,$30(a0)
                bhs.w   locret_4C21A
                jsr     (AllocateObject).l
                bne.w   locret_4C21A
                move.l  #Obj_SlotRing,(a1)
                move.l  #Map_Ring,mappings(a1)
                move.w  #make_art_tile(ArtTile_Ring,1,0),art_tile(a1)
                move.b  #4,render_flags(a1)
                move.w  #$180,priority(a1)
                move.b  #8,width_pixels(a1)
                move.w  #$1A,$40(a1)
                move.w  $32(a0),$32(a1)
                addi.w  #$89,$32(a0)
                move.w  x_pos(a0),$3C(a1)
                move.w  y_pos(a0),$3E(a1)
                move.w  $32(a1),d0
                jsr     (GetSineCosine).l
                asr.w   #1,d1
                add.w   $3C(a1),d1
                move.w  d1,$34(a1)
                move.w  d1,x_pos(a1)
                asr.w   #1,d0
                add.w   $3E(a1),d0
                move.w  d0,$38(a1)
                move.w  d0,y_pos(a1)
                lea     $30(a0),a2
                move.l  a2,$2E(a1)
                move.w  $42(a0),$42(a1)
                addq.w  #1,$30(a0)
                subq.w  #1,(SStage_scalar_result_1+2).w

loc_4C214:
                tst.w   $30(a0)
                beq.s   loc_4C23E

locret_4C21A:
                rts
; ---------------------------------------------------------------------------

loc_4C21C:
                move.w  a1,$42(a0)
                cmpi.b  #$18,(SStage_scalar_result_0+2).w
                beq.w   loc_4C0AA
                move.b  (V_int_run_count+3).w,d0
                andi.w  #$F,d0
                bne.s   locret_4C23C
                moveq   #signextendB(sfx_SlotMachine),d0
                jsr     (Play_SFX).l

locret_4C23C:
                rts
; ---------------------------------------------------------------------------

loc_4C23E:
                move.w  #0,$30(a0)
                addq.w  #2,(a2)+
                move.w  #8,(a2)
                clr.b   (Palette_cycle_counters+$00).w
                rts
; ---------------------------------------------------------------------------

loc_4C250:
                move.b  (Stat_table).w,d0
                andi.w  #$3C,d0
                bne.s   locret_4C290
                move.b  (Stat_table).w,d0
                andi.b  #$FC,d0
                jsr     (GetSineCosine).l
                asl.w   #2,d0
                asl.w   #2,d1
                move.w  d0,x_vel(a1)
                move.w  d1,y_vel(a1)
                move.b  #0,object_control(a1)
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)
                neg.w   (SStage_scalar_index_1).w
                addq.w  #2,(a2)+
                move.w  #8,(a2)

locret_4C290:
                rts
; ---------------------------------------------------------------------------

loc_4C292:
                subq.w  #1,2(a2)
                bpl.s   locret_4C29E
                clr.w   (a2)
                clr.w   (SStage_scalar_result_0).w

locret_4C29E:
                rts
; ---------------------------------------------------------------------------
Map_SlotBonusCage:
                include "src/objects/shared/zones/slots/mappings/bonus_cage_unused.s"
