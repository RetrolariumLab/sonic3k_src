; Owner: objects/zones/lbz/s3
; Responsibility: Unused Launch Base elevator initialization, movement and player riding
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
byte_2471C:
                dc.b    $10, $18, $20, $38, $40, $68
                even
; ---------------------------------------------------------------------------

Obj_LBZUnusedElevator:
                move.l  #Map_LBZUnusedElevator,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZMisc,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  #$30,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  y_pos(a0),$32(a0)
                move.w  #$8000,objoff_16(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #4,d0
                andi.w  #$F,d0
                move.b  byte_2471C(pc,d0.w),d0
                lsl.w   #3,d0
                move.w  d0,$38(a0)
                sub.w   d0,y_pos(a0)
                btst    #0,status(a0)
                beq.s   loc_24782
                add.w   d0,d0
                add.w   d0,y_pos(a0)
                move.b  #1,$34(a0)

loc_24782:
                move.l  #loc_24788,(a0)

loc_24788:
                move.w  $36(a0),d0
                move.w  off_247BE(pc,d0.w),d1
                jsr     off_247BE(pc,d1.w)
                tst.b   render_flags(a0)
                bpl.s   loc_247B8
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l

loc_247B8:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
off_247BE:
                dc.w    loc_247C6-off_247BE
                dc.w    loc_247E4-off_247BE
                dc.w    loc_24810-off_247BE
                dc.w    loc_2482E-off_247BE
; ---------------------------------------------------------------------------

loc_247C6:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                beq.s   locret_247E2
                move.w  #$8000,objoff_16(a0)
                addq.w  #2,$36(a0)

locret_247E2:
                rts
; ---------------------------------------------------------------------------

loc_247E4:
                bsr.w   sub_2485A
                tst.w   y_vel(a0)
                bne.s   locret_2480E
                addq.w  #2,$36(a0)
                move.w  d0,y_pos(a0)
                move.w  $38(a0),d0
                sub.w   d0,y_pos(a0)
                btst    #0,status(a0)
                bne.s   locret_2480E
                add.w   d0,d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

locret_2480E:
                rts
; ---------------------------------------------------------------------------

loc_24810:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                bne.s   locret_2482C
                move.w  #$8000,objoff_16(a0)
                addq.w  #2,$36(a0)

locret_2482C:
                rts
; ---------------------------------------------------------------------------

loc_2482E:
                bsr.w   sub_2485A
                tst.w   y_vel(a0)
                bne.s   locret_24858
                clr.w   $36(a0)
                move.w  d0,y_pos(a0)
                move.w  $38(a0),d0
                sub.w   d0,y_pos(a0)
                btst    #0,status(a0)
                beq.s   locret_24858
                add.w   d0,d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

locret_24858:
                rts

; =============== S U B R O U T I N E =======================================

sub_2485A:
                move.w  y_pos(a0),d2
                moveq   #8,d1
                tst.b   $34(a0)
                bne.s   loc_248A8
                add.w   d1,y_vel(a0)
                move.w  y_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a0)
                move.w  $32(a0),d0
                cmp.w   y_pos(a0),d0
                bhi.s   locret_248E8
                beq.s   loc_24898
                sub.w   d0,d2
                neg.w   d2
                add.w   d0,d2
                move.w  d2,y_pos(a0)
                neg.w   $16(a0)
                move.b  #1,$34(a0)
                bra.s   locret_248E8
; ---------------------------------------------------------------------------

loc_24898:
                neg.w   $16(a0)
                add.w   d1,y_vel(a0)
                move.b  #1,$34(a0)
                bra.s   locret_248E8
; ---------------------------------------------------------------------------

loc_248A8:
                sub.w   d1,y_vel(a0)
                move.w  y_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a0)
                move.w  $32(a0),d0
                cmp.w   y_pos(a0),d0
                blo.s   locret_248E8
                beq.s   loc_248DA
                sub.w   d0,d2
                neg.w   d2
                add.w   d0,d2
                move.w  d2,y_pos(a0)
                neg.w   $16(a0)
                move.b  #0,$34(a0)
                bra.s   locret_248E8
; ---------------------------------------------------------------------------

loc_248DA:
                neg.w   $16(a0)
                sub.w   d1,y_vel(a0)
                move.b  #0,$34(a0)

locret_248E8:
                rts
; End of function sub_2485A

; ---------------------------------------------------------------------------
Map_LBZUnusedElevator:
                include "src/objects/shared/zones/lbz/map_unused_elevator.s"
