; Owner: objects/shared/springs/s3
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
                dc.w    loc_22092-RetractingSpring_Index
                dc.w    loc_220AE-RetractingSpring_Index
                dc.w    loc_220CA-RetractingSpring_Index
                dc.w    loc_220E6-RetractingSpring_Index
                dc.w    loc_22116-RetractingSpring_Index
; ---------------------------------------------------------------------------

loc_22092:
                move.l  #loc_22098,(a0)

loc_22098:
                bsr.w   sub_22146
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_Spring_Up
; ---------------------------------------------------------------------------

loc_220AE:
                move.l  #loc_220B4,(a0)

loc_220B4:
                bsr.w   sub_22146
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_Spring_Horizontal
; ---------------------------------------------------------------------------

loc_220CA:
                move.l  #loc_220D0,(a0)

loc_220D0:
                bsr.w   sub_22146
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_Spring_Down
; ---------------------------------------------------------------------------

loc_220E6:
                move.l  #loc_220EC,(a0)

loc_220EC:
                bsr.w   sub_22146
                moveq   #0,d0
                move.b  $36(a0),d0
                move.w  d0,d1
                btst    #0,status(a0)
                bne.s   loc_22102
                neg.w   d0

loc_22102:
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                add.w   $34(a0),d1
                move.w  d1,y_pos(a0)
                bra.w   Obj_Spring_UpDiag
; ---------------------------------------------------------------------------

loc_22116:
                move.l  #loc_2211C,(a0)

loc_2211C:
                bsr.w   sub_22146
                moveq   #0,d0
                move.b  $36(a0),d0
                move.w  d0,d1
                btst    #0,status(a0)
                beq.s   loc_22132
                neg.w   d0

loc_22132:
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                add.w   $34(a0),d1
                move.w  d1,y_pos(a0)
                bra.w   Obj_Spring_DownDiag

; =============== S U B R O U T I N E =======================================

sub_22146:
                tst.w   $3A(a0)
                beq.s   loc_22162
                subq.w  #1,$3A(a0)
                bne.s   locret_221A4
                tst.b   render_flags(a0)
                bpl.s   locret_221A4
                moveq   #signextendB(sfx_SpikeMove),d0
                jsr     (Play_SFX).l
                bra.s   locret_221A4
; ---------------------------------------------------------------------------

loc_22162:
                tst.w   $38(a0)
                beq.s   loc_22184
                subi.w  #$800,$36(a0)
                bcc.s   locret_221A4
                move.w  #0,$36(a0)
                move.w  #0,$38(a0)
                move.w  #60,$3A(a0)
                bra.s   locret_221A4
; ---------------------------------------------------------------------------

loc_22184:
                addi.w  #$800,$36(a0)
                cmpi.w  #$2000,$36(a0)
                blo.s   locret_221A4
                move.w  #$2000,$36(a0)
                move.w  #1,$38(a0)
                move.w  #60,$3A(a0)

locret_221A4:
                rts
; End of function sub_22146

; ---------------------------------------------------------------------------
byte_221A6:
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
                bne.w   loc_2229C
                move.l  #loc_2255E,(a1)
                move.l  #Map_2PRetractingSpring,mappings(a1)
                move.w  #make_art_tile(ArtTile_2PArt_2,0,0),art_tile(a1)
                cmpi.b  #$12,(Current_zone).w
                bne.s   loc_221F4
                move.l  #Map_2PRetractingSpring_2,mappings(a1)

loc_221F4:
                move.b  subtype(a0),d0
                move.b  d0,subtype(a1)
                lsr.b   #2,d0
                andi.w  #$1C,d0
                lea     byte_221A6(pc,d0.w),a2
                move.b  (a2)+,width_pixels(a1)
                move.b  (a2)+,height_pixels(a1)
                move.b  (a2)+,d0
                move.b  d0,mapping_frame(a1)
                bne.s   loc_2221C
                move.l  #loc_225B8,(a1)

loc_2221C:
                andi.b  #$F0,subtype(a0)
                move.b  (a2)+,d1
                or.b    d1,subtype(a0)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                moveq   #0,d2
                moveq   #0,d3
                cmpi.b  #1,d0
                bne.s   loc_2224E
                moveq   #$C,d2
                btst    #0,status(a0)
                bne.s   loc_2224A
                neg.w   d2

loc_2224A:
                add.w   d2,x_pos(a1)

loc_2224E:
                cmpi.b  #2,d0
                bne.s   loc_2225A
                moveq   #$B,d3
                add.w   d3,y_pos(a1)

loc_2225A:
                cmpi.b  #3,d0
                bne.s   loc_22266
                moveq   #-$B,d3
                add.w   d3,y_pos(a1)

loc_22266:
                move.w  d2,$30(a1)
                move.w  d3,$32(a1)
                bclr    #1,status(a0)
                beq.s   loc_2227C
                move.b  #1,$3C(a0)

loc_2227C:
                move.b  status(a0),status(a1)
                move.b  render_flags(a0),render_flags(a1)
                ori.b   #4,render_flags(a1)
                move.w  #$200,priority(a1)
                move.w  a0,$3E(a1)
                move.w  a1,$3E(a0)

loc_2229C:
                bsr.w   sub_21426

loc_222A0:
                move.b  subtype(a0),d0
                lsr.w   #3,d0
                andi.w  #$E,d0
                move.w  off_222B2(pc,d0.w),d1
                jmp     off_222B2(pc,d1.w)
; ---------------------------------------------------------------------------
off_222B2:
                dc.w    loc_222C2-off_222B2
                dc.w    loc_222DE-off_222B2
                dc.w    loc_222FA-off_222B2
                dc.w    loc_22316-off_222B2
                dc.w    loc_22332-off_222B2
                dc.w    loc_2234E-off_222B2
                dc.w    loc_22332-off_222B2
                dc.w    loc_2234E-off_222B2
; ---------------------------------------------------------------------------

loc_222C2:
                move.l  #loc_222C8,(a0)

loc_222C8:
                bsr.w   sub_2236A
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_2PSpring_Up
; ---------------------------------------------------------------------------

loc_222DE:
                move.l  #loc_222E4,(a0)

loc_222E4:
                bsr.w   sub_2236A
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_2PSpring_Horizontal
; ---------------------------------------------------------------------------

loc_222FA:
                move.l  #loc_22300,(a0)

loc_22300:
                bsr.w   sub_2236A
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_2PSpring_Down
; ---------------------------------------------------------------------------

loc_22316:
                move.l  #loc_2231C,(a0)

loc_2231C:
                bsr.w   sub_2236A
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                bra.w   Obj_2PSpring_Horizontal
; ---------------------------------------------------------------------------

loc_22332:
                move.l  #loc_22338,(a0)

loc_22338:
                bsr.w   sub_2236A
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_2PSpring_Up
; ---------------------------------------------------------------------------

loc_2234E:
                move.l  #loc_22354,(a0)

loc_22354:
                bsr.w   sub_2236A
                moveq   #0,d0
                move.b  $36(a0),d0
                add.w   $32(a0),d0
                move.w  d0,x_pos(a0)
                bra.w   Obj_2PSpring_Down

; =============== S U B R O U T I N E =======================================

sub_2236A:
                tst.b   subtype(a0)
                bmi.s   loc_223D0
                tst.w   $3A(a0)
                beq.s   loc_2238C
                subq.w  #1,$3A(a0)
                bne.s   locret_223CE
                tst.b   render_flags(a0)
                bpl.s   locret_223CE
                moveq   #signextendB(sfx_SpikeMove),d0
                jsr     (Play_SFX).l
                bra.s   locret_223CE
; ---------------------------------------------------------------------------

loc_2238C:
                tst.w   $38(a0)
                beq.s   loc_223AE
                subi.w  #$800,$36(a0)
                bcc.s   locret_223CE
                move.w  #0,$36(a0)
                move.w  #0,$38(a0)
                move.w  #60,$3A(a0)
                bra.s   locret_223CE
; ---------------------------------------------------------------------------

loc_223AE:
                addi.w  #$800,$36(a0)
                cmpi.w  #$1800,$36(a0)
                blo.s   locret_223CE
                move.w  #$1800,$36(a0)
                move.w  #1,$38(a0)
                move.w  #60,$3A(a0)

locret_223CE:
                rts
; ---------------------------------------------------------------------------

loc_223D0:
                tst.b   $3C(a0)
                beq.w   loc_2249A
                tst.w   $3A(a0)
                beq.s   loc_223F0
                subq.w  #1,$3A(a0)
                bne.w   locret_22498
                move.w  #0,$38(a0)
                bra.w   locret_22498
; ---------------------------------------------------------------------------

loc_223F0:
                tst.w   $38(a0)
                bne.w   loc_2247E
                tst.w   $36(a0)
                beq.w   locret_22498
                subi.w  #$800,$36(a0)
                bhi.w   locret_22498
                move.w  #0,$36(a0)
                move.b  subtype(a0),d0
                andi.b  #$F0,d0
                cmpi.b  #$E0,d0
                bne.s   loc_2244A
                addi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$F0,subtype(a0)
                move.l  #loc_222A0,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

loc_2244A:
                cmpi.b  #$F0,d0
                bne.s   loc_2247C
                subi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$E0,subtype(a0)
                move.l  #loc_222A0,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

loc_2247C:
                bra.s   locret_22498
; ---------------------------------------------------------------------------

loc_2247E:
                addi.w  #$800,$36(a0)
                cmpi.w  #$1800,$36(a0)
                blo.s   locret_22498
                move.w  #$1800,$36(a0)
                move.w  #3*60,$3A(a0)

locret_22498:
                rts
; ---------------------------------------------------------------------------

loc_2249A:
                tst.w   $3A(a0)
                beq.s   loc_224B2
                subq.w  #1,$3A(a0)
                bne.w   locret_2255C
                move.w  #0,$38(a0)
                bra.w   locret_2255C
; ---------------------------------------------------------------------------

loc_224B2:
                tst.w   $38(a0)
                beq.s   loc_224D2
                subi.w  #$800,$36(a0)
                bcc.w   locret_2255C
                move.w  #0,$36(a0)
                move.w  #3*60,$3A(a0)
                bra.w   locret_2255C
; ---------------------------------------------------------------------------

loc_224D2:
                cmpi.w  #$1800,$36(a0)
                beq.w   locret_2255C
                addi.w  #$800,$36(a0)
                cmpi.w  #$1800,$36(a0)
                blo.s   locret_2255C
                move.w  #$1800,$36(a0)
                move.b  subtype(a0),d0
                andi.b  #$F0,d0
                cmpi.b  #$E0,d0
                bne.s   loc_2252A
                addi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$F0,subtype(a0)
                move.l  #loc_222A0,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

loc_2252A:
                cmpi.b  #$F0,d0
                bne.s   locret_2255C
                subi.w  #$16,y_pos(a0)
                bchg    #1,status(a0)
                bchg    #1,render_flags(a0)
                andi.b  #$F,subtype(a0)
                ori.b   #$E0,subtype(a0)
                move.l  #loc_222A0,(a0)
                movea.w $3E(a0),a1
                neg.w   $32(a1)

locret_2255C:
                rts
; End of function sub_2236A

; ---------------------------------------------------------------------------

loc_2255E:
                movea.w $3E(a0),a1
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                add.w   $30(a0),d2
                add.w   $32(a0),d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                move.b  subtype(a0),d1
                bpl.s   loc_22594
                andi.w  #$F,d1
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d1.w)
                beq.s   loc_22594
                move.w  #1,$38(a1)

loc_22594:
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

loc_225B8:
                move.b  subtype(a0),d1
                bpl.s   locret_225D6
                andi.w  #$F,d1
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d1.w)
                beq.s   locret_225D6
                movea.w $3E(a0),a1
                move.w  #1,$38(a1)

locret_225D6:
                rts
; ---------------------------------------------------------------------------
Map_2PRetractingSpring:
                include "src/objects/shared/level_misc/map_2p_retracting_spring.s"
