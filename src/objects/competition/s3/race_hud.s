; Owner: objects/competition/s3
; Responsibility: Competition time display, live mapping construction, item icons and position widgets
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_37220:
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

loc_37262:
                move.w  (a1)+,(a2)+
                dbf     d0,loc_37262
                move.l  #loc_3726E,(a0)

loc_3726E:
                lea     (Score).w,a1
                lea     (Map_2PTime_P1_RAM+$A).l,a2
                lea     (Timer_minute).w,a3
                moveq   #0,d1
                move.b  (Competition_lap_count).w,d1
                lea     (Update_HUD_timer).w,a4
                lea     (Competition_time_record).w,a5
                lea     ((RAM_start+$7828)&$FFFFFF).l,a6
                bra.s   loc_3730E
; ---------------------------------------------------------------------------

loc_37292:
                tst.b   (Not_ghost_flag).w
                bne.s   loc_3729E
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3729E:
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

loc_372E0:
                move.w  (a1)+,(a2)+
                dbf     d0,loc_372E0
                move.l  #loc_372EC,(a0)

loc_372EC:
                lea     (Score_P2).w,a1
                lea     (Map_2PTime_P2_RAM+$A).l,a2
                lea     (Timer_minute_P2).w,a3
                moveq   #0,d1
                move.b  (Competition_lap_count_2P).w,d1
                lea     (Update_HUD_timer_P2).w,a4
                lea     (Competition_time_record_P2).w,a5
                lea     ((RAM_start+$7840)&$FFFFFF).l,a6

loc_3730E:
                tst.b   (a4)
                beq.s   loc_37342
                bmi.s   loc_37342
                cmpi.l  #(9<<16)|(59<<8)|99,(a5)
                blo.s   loc_37328
                move.b  #$80,(a4)
                move.l  #(9<<16)|(59<<8)|99,(a5)
                bra.s   loc_37362
; ---------------------------------------------------------------------------

loc_37328:
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   loc_37342
                move.b  #0,(a1)
                addq.b  #1,-(a1)
                cmpi.b  #60,(a1)
                blo.s   loc_37342
                move.b  #0,(a1)
                addq.b  #1,-(a1)

loc_37342:
                move.l  -1(a3),d6
                jsr     (sub_9F48).l
                cmpi.w  #5,d1
                bhs.s   loc_37362
                lsl.w   #2,d1
                move.l  d6,(a6,d1.w)
                move.l  $14(a6),d5
                jsr     sub_36508(pc)
                move.l  d6,(a5)

loc_37362:
                addq.w  #1,a5
                lea     word_373BC(pc),a1
                moveq   #0,d0
                move.b  (a5)+,d0
                lsl.w   #2,d0
                move.l  (a1,d0.w),(a2)+
                addq.w  #8,a2
                moveq   #0,d0
                move.b  (a5)+,d0
                moveq   #0,d2

loc_3737A:
                subi.w  #$A,d0
                bcs.s   loc_37384
                addq.w  #4,d2
                bra.s   loc_3737A
; ---------------------------------------------------------------------------

loc_37384:
                addi.w  #$A,d0
                move.l  (a1,d2.w),(a2)+
                addq.w  #2,a2
                lsl.w   #2,d0
                move.l  (a1,d0.w),(a2)+
                addq.w  #8,a2
                moveq   #0,d0
                move.b  (a5)+,d0
                moveq   #0,d2

loc_3739C:
                subi.w  #$A,d0
                bcs.s   loc_373A6
                addq.w  #4,d2
                bra.s   loc_3739C
; ---------------------------------------------------------------------------

loc_373A6:
                addi.w  #$A,d0
                move.l  (a1,d2.w),(a2)+
                addq.w  #2,a2
                lsl.w   #2,d0
                move.l  (a1,d0.w),(a2)+
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_373BC:
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
byte_373E4:
                dc.b    0,   1,   3,   5,   6,   8,  $A,  $B,  $D,  $F, $10, $12, $14, $15, $17, $19, $1A, $1C, $1E, $1F
                dc.b    $21, $23, $24, $26, $28, $29, $2B, $2D, $2E, $30, $32, $33, $35, $37, $38, $3A, $3C, $3D, $3F, $41
                dc.b    $42, $44, $46, $47, $49, $4B, $4C, $4E, $50, $51, $53, $55, $56, $58, $5A, $5B, $5D, $5F, $60, $62
Map_2PTime:
                dc.w    word_37422-Map_2PTime
word_37422:     dc.w    8
                dc.b    $F8,  $D,   0,   0, $FF, $C0
                dc.b    $F8,   5,   0,   8, $FF, $E8
                dc.b    $F0,   0,   0, $2E, $FF, $F4
                dc.b    $F8,   5,   0,   8, $FF, $FC
                dc.b    $F8,   5,   0,   8,   0,   8
                dc.b    $F0,   0,   0, $2F,   0, $14
                dc.b    $F8,   5,   0,   8,   0, $1C
                dc.b    $F8,   5,   0,   8,   0, $28
Map_2PTime_end:
; End of function loc_37220
; ---------------------------------------------------------------------------

loc_37454:
                move.l  #Map_2PItemIcon,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PLapNum+$50,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$E0,y_pos(a0)
                tst.b   subtype(a0)
                beq.s   loc_374A0
                tst.b   (Not_ghost_flag).w
                bne.s   loc_37492
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_37492:
                bset    #4,render_flags(a0)
                move.l  #loc_374D4,(a0)
                bra.s   loc_374D4
; ---------------------------------------------------------------------------

loc_374A0:
                bset    #3,render_flags(a0)
                move.l  #loc_374AC,(a0)

loc_374AC:
                moveq   #0,d0
                tst.w   (Ring_count).w
                beq.s   loc_374B6
                moveq   #3,d0

loc_374B6:
                btst    #Status_SpeedShoes,(Player_1+status_secondary).w
                beq.s   loc_374CA
                moveq   #1,d0
                cmpi.w  #$C00,(Max_speed).w
                beq.s   loc_374CA
                moveq   #2,d0

loc_374CA:
                move.b  d0,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_374D4:
                moveq   #0,d0
                tst.w   (Ring_count_P2).w
                beq.s   loc_374DE
                moveq   #3,d0

loc_374DE:
                btst    #2,(Player_2+status_secondary).w
                beq.s   loc_374F2
                moveq   #1,d0
                cmpi.w  #$C00,(Max_speed_P2).w
                beq.s   loc_374F2
                moveq   #2,d0

loc_374F2:
                move.b  d0,mapping_frame(a0)
                jmp     (Draw_Sprite).l
; End of function loc_37454
; ---------------------------------------------------------------------------
Map_2PItemIcon:
                include "src/game/competition/shared/2p_zone/map_item_icon.s"
; ---------------------------------------------------------------------------
; unused
                move.l  #Map_2PPosition,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PPosIcon,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.b  #4,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                tst.b   subtype(a0)
                beq.s   loc_375D6
                tst.b   (Not_ghost_flag).w
                bne.s   loc_375B0
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_375B0:
                move.w  #$90,x_pos(a0)
                move.w  #$84,y_pos(a0)
                move.w  (Player_2+x_pos).w,$30(a0)
                bset    #4,render_flags(a0)
                move.b  #2,mapping_frame(a0)
                move.l  #loc_3764E,(a0)
                bra.s   loc_3764E
; ---------------------------------------------------------------------------

loc_375D6:
                move.w  #$90,x_pos(a0)
                move.w  #$E8,y_pos(a0)
                move.w  (Player_1+x_pos).w,$30(a0)
                bset    #3,render_flags(a0)
                move.b  #1,mapping_frame(a0)
                move.l  #loc_375FA,(a0)

loc_375FA:
                move.w  (Player_1+x_pos).w,d0
                move.w  (Saved_X_pos).w,d1

loc_37602:
                tst.w   (Events_bg+$14).w
                beq.s   loc_37612
                move.w  #0,$34(a0)
                move.w  d1,$30(a0)

loc_37612:
                move.w  d0,d1
                sub.w   $30(a0),d0
                beq.s   loc_3763A
                bcc.s   loc_37628
                cmpi.w  #-$200,d0
                bge.s   loc_37632
                addi.w  #$400,d0
                bra.s   loc_37632
; ---------------------------------------------------------------------------

loc_37628:
                cmpi.w  #$200,d0
                blt.s   loc_37632
                subi.w  #$400,d0

loc_37632:
                add.w   d0,$34(a0)
                move.w  d1,$30(a0)

loc_3763A:
                move.w  $34(a0),d0
                asr.w   #6,d0
                addi.w  #$90,d0
                move.w  d0,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_3764E:
                move.w  (Player_2+x_pos).w,d0
                move.w  (Saved2_X_pos).w,d1
                bra.s   loc_37602
; ---------------------------------------------------------------------------
Map_2PPosition:
                include "src/game/competition/shared/2p_zone/map_position_icons_unused.s"
; End of function loc_375B0
