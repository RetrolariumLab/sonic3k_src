; Owner: objects/competition/sk
; Responsibility: Competition time display, live mapping construction, item icons and position widgets
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_37C8E:
                move.l  #Map_2PTime_P1_RAM,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PTime,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$C8,x_pos(a0)
                move.w  #$90,y_pos(a0)
                bset    #3,render_flags(a0)
                lea     (Map_2PTime).l,a1
                lea     (Map_2PTime_P1_RAM).l,a2
                move.w  #bytesToWcnt(Map_2PTime_end-Map_2PTime),d0

loc_37CD0:
                move.w  (a1)+,(a2)+
                dbf     d0,loc_37CD0
                move.l  #loc_37CDC,(a0)

loc_37CDC:
                lea     (Score).w,a1
                lea     (Map_2PTime_P1_RAM+$A).l,a2
                lea     (Timer_minute).w,a3
                moveq   #0,d1
                move.b  (Competition_lap_count).w,d1
                lea     (Update_HUD_timer).w,a4
                lea     (Competition_time_record).w,a5
                lea     ((RAM_start+$7828)&$FFFFFF).l,a6
                bra.s   loc_37D7C
; ---------------------------------------------------------------------------

loc_37D00:
                tst.b   (Not_ghost_flag).w
                bne.s   loc_37D0C
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_37D0C:
                move.l  #Map_2PTime_P2_RAM,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PTime,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$C8,x_pos(a0)
                move.w  #$90,y_pos(a0)
                bset    #4,render_flags(a0)
                lea     (Map_2PTime).l,a1
                lea     (Map_2PTime_P2_RAM).l,a2
                move.w  #bytesToWcnt(Map_2PTime_end-Map_2PTime),d0

loc_37D4E:
                move.w  (a1)+,(a2)+
                dbf     d0,loc_37D4E
                move.l  #loc_37D5A,(a0)

loc_37D5A:
                lea     (Score_P2).w,a1
                lea     (Map_2PTime_P2_RAM+$A).l,a2
                lea     (Timer_minute_P2).w,a3
                moveq   #0,d1
                move.b  (Competition_lap_count_2P).w,d1
                lea     (Update_HUD_timer_P2).w,a4
                lea     (Competition_time_record_P2).w,a5
                lea     ((RAM_start+$7840)&$FFFFFF).l,a6

loc_37D7C:
                tst.b   (a4)
                beq.s   loc_37DB0
                bmi.s   loc_37DB0
                cmpi.l  #(9<<16)|(59<<8)|99,(a5)
                blo.s   loc_37D96
                move.b  #$80,(a4)
                move.l  #(9<<16)|(59<<8)|99,(a5)
                bra.s   loc_37DD0
; ---------------------------------------------------------------------------

loc_37D96:
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   loc_37DB0
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   loc_37DB0
                move.b  #0,(a1)
                addq.b  #1,-(a1)

loc_37DB0:
                move.l  -1(a3),d6
                jsr     (SKCompConvertTimerFrameByteToHundredths).l
                cmpi.w  #5,d1
                bhs.s   loc_37DD0
                lsl.w   #2,d1
                move.l  d6,(a6,d1.w)
                move.l  $14(a6),d5
                jsr     CompetitionGoalSKAddPackedMinuteSecondCentisecondTimes(pc)
                move.l  d6,(a5)

loc_37DD0:
                addq.w  #1,a5
                lea     word_37E2A(pc),a1
                moveq   #0,d0
                move.b  (a5)+,d0
                lsl.w   #2,d0
                move.l  (a1,d0.w),(a2)+
                addq.w  #8,a2
                moveq   #0,d0
                move.b  (a5)+,d0
                moveq   #0,d2

loc_37DE8:
                subi.w  #$A,d0
                bcs.s   loc_37DF2
                addq.w  #4,d2
                bra.s   loc_37DE8
; ---------------------------------------------------------------------------

loc_37DF2:
                addi.w  #$A,d0
                move.l  (a1,d2.w),(a2)+
                addq.w  #2,a2
                lsl.w   #2,d0
                move.l  (a1,d0.w),(a2)+
                addq.w  #8,a2
                moveq   #0,d0
                move.b  (a5)+,d0
                moveq   #0,d2

loc_37E0A:
                subi.w  #$A,d0
                bcs.s   loc_37E14
                addq.w  #4,d2
                bra.s   loc_37E0A
; ---------------------------------------------------------------------------

loc_37E14:
                addi.w  #$A,d0
                move.l  (a1,d2.w),(a2)+
                addq.w  #2,a2
                lsl.w   #2,d0
                move.l  (a1,d0.w),(a2)+
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_37E2A:
                dc.w    $F805,     8
                dc.w    $F801,    $C
                dc.w    $F805,    $E
                dc.w    $F805,   $12
                dc.w    $F805,   $16
                dc.w    $F805,   $1A
                dc.w    $F805,   $1E
                dc.w    $F805,   $22
                dc.w    $F805,   $26
                dc.w    $F805,   $2A
byte_37E52:
                dc.b    0,   1,   3,   5,   6,   8,  $A,  $B,  $D,  $F, $10, $12, $14, $15, $17, $19, $1A, $1C, $1E, $1F
                dc.b    $21, $23, $24, $26, $28, $29, $2B, $2D, $2E, $30, $32, $33, $35, $37, $38, $3A, $3C, $3D, $3F, $41
                dc.b    $42, $44, $46, $47, $49, $4B, $4C, $4E, $50, $51, $53, $55, $56, $58, $5A, $5B, $5D, $5F, $60, $62
Map_2PTime:
                dc.w    word_37E90-Map_2PTime
word_37E90:     dc.w    8
                dc.b    $F8,  $D,   0,   0, $FF, $C0
                dc.b    $F8,   5,   0,   8, $FF, $E8
                dc.b    $F0,   0,   0, $2E, $FF, $F4
                dc.b    $F8,   5,   0,   8, $FF, $FC
                dc.b    $F8,   5,   0,   8,   0,   8
                dc.b    $F0,   0,   0, $2F,   0, $14
                dc.b    $F8,   5,   0,   8,   0, $1C
                dc.b    $F8,   5,   0,   8,   0, $28
Map_2PTime_end:
; End of function loc_37C8E
; ---------------------------------------------------------------------------

loc_37EC2:
                move.l  #Map_2PItemIcon,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PLapNum+$50,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$E0,y_pos(a0)
                tst.b   subtype(a0)
                beq.s   loc_37F0E
                tst.b   (Not_ghost_flag).w
                bne.s   loc_37F00
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_37F00:
                bset    #4,render_flags(a0)
                move.l  #loc_37F42,(a0)
                bra.s   loc_37F42
; ---------------------------------------------------------------------------

loc_37F0E:
                bset    #3,render_flags(a0)
                move.l  #loc_37F1A,(a0)

loc_37F1A:
                moveq   #0,d0
                tst.w   (Ring_count).w
                beq.s   loc_37F24
                moveq   #3,d0

loc_37F24:
                btst    #Status_SpeedShoes,(Player_1+status_secondary).w
                beq.s   loc_37F38
                moveq   #1,d0
                cmpi.w  #$C00,(Max_speed).w
                beq.s   loc_37F38
                moveq   #2,d0

loc_37F38:
                move.b  d0,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_37F42:
                moveq   #0,d0
                tst.w   (Ring_count_P2).w
                beq.s   loc_37F4C
                moveq   #3,d0

loc_37F4C:
                btst    #2,(Player_2+status_secondary).w
                beq.s   loc_37F60
                moveq   #1,d0
                cmpi.w  #$C00,(Max_speed_P2).w
                beq.s   loc_37F60
                moveq   #2,d0

loc_37F60:
                move.b  d0,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; End of function loc_37EC2
; ---------------------------------------------------------------------------
Map_2PItemIcon:
                include "src/game/competition/shared/mappings/item_icon.s"
; ---------------------------------------------------------------------------
; unused
                move.l  #Map_2PPosition,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PPosIcon,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #4,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                tst.b   subtype(a0)
                beq.s   loc_38044
                tst.b   (Not_ghost_flag).w
                bne.s   loc_3801E
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3801E:
                move.w  #$90,x_pos(a0)
                move.w  #$84,y_pos(a0)
                move.w  (Player_2+x_pos).w,$30(a0)
                bset    #4,render_flags(a0)
                move.b  #2,mapping_frame(a0)
                move.l  #loc_380BC,(a0)
                bra.s   loc_380BC
; ---------------------------------------------------------------------------

loc_38044:
                move.w  #$90,x_pos(a0)
                move.w  #$E8,y_pos(a0)
                move.w  (Player_1+x_pos).w,$30(a0)
                bset    #3,render_flags(a0)
                move.b  #1,mapping_frame(a0)
                move.l  #loc_38068,(a0)

loc_38068:
                move.w  (Player_1+x_pos).w,d0
                move.w  (Saved_X_pos).w,d1

loc_38070:
                tst.w   (Events_bg+$14).w
                beq.s   loc_38080
                move.w  #0,$34(a0)
                move.w  d1,$30(a0)

loc_38080:
                move.w  d0,d1
                sub.w   $30(a0),d0
                beq.s   loc_380A8
                bcc.s   loc_38096
                cmpi.w  #-$200,d0
                bge.s   loc_380A0
                addi.w  #$400,d0
                bra.s   loc_380A0
; ---------------------------------------------------------------------------

loc_38096:
                cmpi.w  #$200,d0
                blt.s   loc_380A0
                subi.w  #$400,d0

loc_380A0:
                add.w   d0,$34(a0)
                move.w  d1,$30(a0)

loc_380A8:
                move.w  $34(a0),d0
                asr.w   #6,d0
                addi.w  #$90,d0
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_380BC:
                move.w  (Player_2+x_pos).w,d0
                move.w  (Saved2_X_pos).w,d1
                bra.s   loc_38070
; ---------------------------------------------------------------------------
Map_2PPosition:
                include "src/game/competition/shared/mappings/position_icons_unused.s"
; End of function loc_3801E
