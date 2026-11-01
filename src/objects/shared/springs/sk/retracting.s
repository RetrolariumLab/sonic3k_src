; Owner: objects/shared/springs/sk
; Responsibility: Retracting spring timing, extension states, competition variants and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_RetractingSpring:
                bsr.w   Obj_Spring
                move.b  subtype(a0),d0
                lsr.w   #3,d0
                andi.w  #$E,d0
                move.w  RetractingSpring_Index(pc,d0.w),d1
                jmp     RetractingSpring_Index(pc,d1.w)
; ---------------------------------------------------------------------------
RetractingSpring_Index:
                dc.w    loc_23A04-RetractingSpring_Index
                dc.w    loc_23A20-RetractingSpring_Index
                dc.w    loc_23A3C-RetractingSpring_Index
                dc.w    loc_23A58-RetractingSpring_Index
                dc.w    loc_23A88-RetractingSpring_Index
; ---------------------------------------------------------------------------

loc_23A04:
                move.l  #loc_23A0A,(a0)

loc_23A0A:
                bsr.w   UpdateRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_Spring_Up
; ---------------------------------------------------------------------------

loc_23A20:
                move.l  #loc_23A26,(a0)

loc_23A26:
                bsr.w   UpdateRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_Spring_Horizontal
; ---------------------------------------------------------------------------

loc_23A3C:
                move.l  #loc_23A42,(a0)

loc_23A42:
                bsr.w   UpdateRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_Spring_Down
; ---------------------------------------------------------------------------

loc_23A58:
                move.l  #loc_23A5E,(a0)

loc_23A5E:
                bsr.w   UpdateRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                move.w  d0,d1
                btst    #0,status(a0)
                bne.s   loc_23A74
                neg.w   d0

loc_23A74:
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                add.w   $34(a0),d1
                move.w  d1,y_pos(a0)
                bra.w   Obj_Spring_UpDiag
; ---------------------------------------------------------------------------

loc_23A88:
                move.l  #loc_23A8E,(a0)

loc_23A8E:
                bsr.w   UpdateRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                move.w  d0,d1
                btst    #0,status(a0)
                beq.s   loc_23AA4
                neg.w   d0

loc_23AA4:
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                add.w   $34(a0),d1
                move.w  d1,y_pos(a0)
                bra.w   Obj_Spring_DownDiag

; =============== S U B R O U T I N E =======================================

UpdateRetractingSpringTravel:
                tst.w   $3A(a0)
                beq.s   loc_23AD4
                subq.w  #1,$3A(a0)
                bne.s   locret_23B16
                tst.b   render_flags(a0)
                bpl.s   locret_23B16
                moveq   #signextendB(sfx_SpikeMove),d0
                jsr     (Play_SFX).l
                bra.s   locret_23B16
; ---------------------------------------------------------------------------

loc_23AD4:
                tst.w   $38(a0)
                beq.s   loc_23AF6
                subi.w  #$800,$36(a0)
                bcc.s   locret_23B16
                move.w  #0,$36(a0)
                move.w  #0,$38(a0)
                move.w  #60,$3A(a0)
                bra.s   locret_23B16
; ---------------------------------------------------------------------------

loc_23AF6:
                addi.w  #$800,$36(a0)
                cmpi.w  #$2000,$36(a0)
                blo.s   locret_23B16
                move.w  #$2000,$36(a0)
                move.w  #1,$38(a0)
                move.w  #60,$3A(a0)

locret_23B16:
                rts
; End of function UpdateRetractingSpringTravel

; ---------------------------------------------------------------------------
byte_23B18:
                dc.b    $C,   8,   0,   1
                dc.b    $C,   8,   0,   0
                dc.b    $C,   8,   0,   1
                dc.b    8,  $C,   1,   0
                dc.b    $C,   8,   2,   1
                dc.b    $C,   8,   3,   1
                dc.b    $C,   8,   2,   1
                dc.b    $C,   8,   3,   1
                even
; ---------------------------------------------------------------------------

Obj_2PRetractingSpring:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_23C0E
                move.l  #loc_23ED0,(a1)
                move.l  #Map_2PRetractingSpring,mappings(a1)
                move.w  #make_art_tile(ArtTile_2PArt_2,0,0),art_tile(a1)
                cmpi.b  #$12,(Current_zone).w
                bne.s   loc_23B66
                move.l  #Map_2PRetractingSpring_2,mappings(a1)

loc_23B66:
                move.b  subtype(a0),d0
                move.b  d0,subtype(a1)
                lsr.b   #2,d0
                andi.w  #$1C,d0
                lea     byte_23B18(pc,d0.w),a2
                move.b  (a2)+,width_pixels(a1)
                move.b  (a2)+,height_pixels(a1)
                move.b  (a2)+,d0
                move.b  d0,mapping_frame(a1)
                bne.s   loc_23B8E
                move.l  #loc_23F2A,(a1)

loc_23B8E:
                andi.b  #$F0,subtype(a0)
                move.b  (a2)+,d1
                or.b    d1,subtype(a0)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                moveq   #0,d2
                moveq   #0,d3
                cmpi.b  #1,d0
                bne.s   loc_23BC0
                moveq   #$C,d2
                btst    #0,status(a0)
                bne.s   loc_23BBC
                neg.w   d2

loc_23BBC:
                add.w   d2,x_pos(a1)

loc_23BC0:
                cmpi.b  #2,d0
                bne.s   loc_23BCC
                moveq   #$B,d3
                add.w   d3,y_pos(a1)

loc_23BCC:
                cmpi.b  #3,d0
                bne.s   loc_23BD8
                moveq   #-$B,d3
                add.w   d3,y_pos(a1)

loc_23BD8:
                move.w  d2,$30(a1)
                move.w  d3,$32(a1)
                bclr    #1,status(a0)
                beq.s   loc_23BEE
                move.b  #1,$3C(a0)

loc_23BEE:
                move.b  status(a0),status(a1)
                move.b  render_flags(a0),render_flags(a1)
                ori.b   #4,render_flags(a1)
                move.w  #$200,priority(a1)
                move.w  a0,$3E(a1)
                move.w  a1,$3E(a0)

loc_23C0E:
                bsr.w   InitCompetitionRetractingSpring

loc_23C12:
                move.b  subtype(a0),d0
                lsr.w   #3,d0
                andi.w  #$E,d0
                move.w  off_23C24(pc,d0.w),d1
                jmp     off_23C24(pc,d1.w)
; ---------------------------------------------------------------------------
off_23C24:
                dc.w    loc_23C34-off_23C24
                dc.w    loc_23C50-off_23C24
                dc.w    loc_23C6C-off_23C24
                dc.w    loc_23C88-off_23C24
                dc.w    loc_23CA4-off_23C24
                dc.w    loc_23CC0-off_23C24
                dc.w    loc_23CA4-off_23C24
                dc.w    loc_23CC0-off_23C24
; ---------------------------------------------------------------------------

loc_23C34:
                move.l  #loc_23C3A,(a0)

loc_23C3A:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_2PSpring_Up
; ---------------------------------------------------------------------------

loc_23C50:
                move.l  #loc_23C56,(a0)

loc_23C56:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_2PSpring_Horizontal
; ---------------------------------------------------------------------------

loc_23C6C:
                move.l  #loc_23C72,(a0)

loc_23C72:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_2PSpring_Down
; ---------------------------------------------------------------------------

loc_23C88:
                move.l  #loc_23C8E,(a0)

loc_23C8E:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_2PSpring_Horizontal
; ---------------------------------------------------------------------------

loc_23CA4:
                move.l  #loc_23CAA,(a0)

loc_23CAA:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_2PSpring_Up
; ---------------------------------------------------------------------------

loc_23CC0:
                move.l  #loc_23CC6,(a0)

loc_23CC6:
                bsr.w   UpdateCompetitionRetractingSpringTravel
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_2PSpring_Down

; =============== S U B R O U T I N E =======================================

UpdateCompetitionRetractingSpringTravel:
                tst.b   subtype(a0)
                bmi.s   loc_23D42
                tst.w   $3A(a0)
                beq.s   loc_23CFE
                subq.w  #1,$3A(a0)
                bne.s   locret_23D40
                tst.b   render_flags(a0)
                bpl.s   locret_23D40
                moveq   #signextendB(sfx_SpikeMove),d0
                jsr     (Play_SFX).l
                bra.s   locret_23D40
; ---------------------------------------------------------------------------

loc_23CFE:
                tst.w   $38(a0)
                beq.s   loc_23D20
                subi.w  #$800,$36(a0)
                bcc.s   locret_23D40
                move.w  #0,$36(a0)
                move.w  #0,$38(a0)
                move.w  #60,$3A(a0)
                bra.s   locret_23D40
; ---------------------------------------------------------------------------

loc_23D20:
                addi.w  #$800,$36(a0)
                cmpi.w  #$1800,$36(a0)
                blo.s   locret_23D40
                move.w  #$1800,$36(a0)
                move.w  #1,$38(a0)
                move.w  #60,$3A(a0)

locret_23D40:
                rts
; ---------------------------------------------------------------------------

loc_23D42:
                tst.b   $3C(a0)
                beq.w   loc_23E0C
                tst.w   $3A(a0)
                beq.s   loc_23D62
                subq.w  #1,$3A(a0)
                bne.w   locret_23E0A
                move.w  #0,$38(a0)
                bra.w   locret_23E0A
; ---------------------------------------------------------------------------

loc_23D62:
                tst.w   $38(a0)
                bne.w   loc_23DF0
                tst.w   $36(a0)
                beq.w   locret_23E0A
                subi.w  #$800,$36(a0)
                bhi.w   locret_23E0A
                move.w  #0,$36(a0)
                move.b  subtype(a0),d0
                andi.b  #$F0,d0
                cmpi.b  #$E0,d0
                bne.s   loc_23DBC
                addi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$F0,subtype(a0)
                move.l  #loc_23C12,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

loc_23DBC:
                cmpi.b  #$F0,d0
                bne.s   loc_23DEE
                subi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$E0,subtype(a0)
                move.l  #loc_23C12,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

loc_23DEE:
                bra.s   locret_23E0A
; ---------------------------------------------------------------------------

loc_23DF0:
                addi.w  #$800,$36(a0)
                cmpi.w  #$1800,$36(a0)
                blo.s   locret_23E0A
                move.w  #$1800,$36(a0)
                move.w  #3*60,$3A(a0)

locret_23E0A:
                rts
; ---------------------------------------------------------------------------

loc_23E0C:
                tst.w   $3A(a0)
                beq.s   loc_23E24
                subq.w  #1,$3A(a0)
                bne.w   locret_23ECE
                move.w  #0,$38(a0)
                bra.w   locret_23ECE
; ---------------------------------------------------------------------------

loc_23E24:
                tst.w   $38(a0)
                beq.s   loc_23E44
                subi.w  #$800,$36(a0)
                bcc.w   locret_23ECE
                move.w  #0,$36(a0)
                move.w  #3*60,$3A(a0)
                bra.w   locret_23ECE
; ---------------------------------------------------------------------------

loc_23E44:
                cmpi.w  #$1800,$36(a0)
                beq.w   locret_23ECE
                addi.w  #$800,$36(a0)
                cmpi.w  #$1800,$36(a0)
                blo.s   locret_23ECE
                move.w  #$1800,$36(a0)
                move.b  subtype(a0),d0
                andi.b  #$F0,d0
                cmpi.b  #$E0,d0
                bne.s   loc_23E9C
                addi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$F0,subtype(a0)
                move.l  #loc_23C12,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

loc_23E9C:
                cmpi.b  #$F0,d0
                bne.s   locret_23ECE
                subi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$E0,subtype(a0)
                move.l  #loc_23C12,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

locret_23ECE:
                rts
; End of function UpdateCompetitionRetractingSpringTravel

; ---------------------------------------------------------------------------

loc_23ED0:
                movea.w $3E(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                add.w   $30(a0),d2
                add.w   $32(a0),d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                move.b  subtype(a0),d1
                bpl.s   loc_23F06
                andi.w  #$F,d1
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d1.w)
                beq.s   loc_23F06
                move.w  #1,$38(a1)

loc_23F06:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #7,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_23F2A:
                move.b  subtype(a0),d1
                bpl.s   locret_23F48
                andi.w  #$F,d1
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d1.w)
                beq.s   locret_23F48
                movea.w $3E(a0),a1
                move.w  #1,$38(a1)

locret_23F48:
                rts
; ---------------------------------------------------------------------------
Map_2PRetractingSpring:
                include "src/objects/shared/level_misc/mappings/competition_retracting_spring.s"
