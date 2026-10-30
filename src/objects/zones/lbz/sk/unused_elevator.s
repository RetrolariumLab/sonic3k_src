; Owner: objects/zones/lbz/sk
; Responsibility: Unused Launch Base elevator initialization, movement and player riding
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
byte_25AF0:
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
                move.b  byte_25AF0(pc,d0.w),d0
                lsl.w   #3,d0
                move.w  d0,$38(a0)
                sub.w   d0,y_pos(a0)
                btst    #0,status(a0)
                beq.s   loc_25B56
                add.w   d0,d0
                add.w   d0,y_pos(a0)
                move.b  #1,$34(a0)

loc_25B56:
                move.l  #loc_25B5C,(a0)

loc_25B5C:
                move.w  $36(a0),d0
                move.w  off_25B92(pc,d0.w),d1
                jsr     off_25B92(pc,d1.w)
                tst.b   render_flags(a0)
                bpl.s   loc_25B8C
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l

loc_25B8C:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
off_25B92:
                dc.w    loc_25B9A-off_25B92
                dc.w    loc_25BB8-off_25B92
                dc.w    loc_25BE4-off_25B92
                dc.w    loc_25C02-off_25B92
; ---------------------------------------------------------------------------

loc_25B9A:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                beq.s   locret_25BB6
                move.w  #$8000,objoff_16(a0)
                addq.w  #2,$36(a0)

locret_25BB6:
                rts
; ---------------------------------------------------------------------------

loc_25BB8:
                bsr.w   sub_25C2E
                tst.w   y_vel(a0)
                bne.s   locret_25BE2
                addq.w  #2,$36(a0)
                move.w  d0,y_pos(a0)
                move.w  $38(a0),d0
                sub.w   d0,y_pos(a0)
                btst    #0,status(a0)
                bne.s   locret_25BE2
                add.w   d0,d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

locret_25BE2:
                rts
; ---------------------------------------------------------------------------

loc_25BE4:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                bne.s   locret_25C00
                move.w  #$8000,objoff_16(a0)
                addq.w  #2,$36(a0)

locret_25C00:
                rts
; ---------------------------------------------------------------------------

loc_25C02:
                bsr.w   sub_25C2E
                tst.w   y_vel(a0)
                bne.s   locret_25C2C
                clr.w   $36(a0)
                move.w  d0,y_pos(a0)
                move.w  $38(a0),d0
                sub.w   d0,y_pos(a0)
                btst    #0,status(a0)
                beq.s   locret_25C2C
                add.w   d0,d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

locret_25C2C:
                rts

; =============== S U B R O U T I N E =======================================

sub_25C2E:
                move.w  y_pos(a0),d2
                moveq   #8,d1
                tst.b   $34(a0)
                bne.s   loc_25C7C
                add.w   d1,y_vel(a0)
                move.w  y_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a0)
                move.w  $32(a0),d0
                cmp.w   y_pos(a0),d0
                bhi.s   locret_25CBC
                beq.s   loc_25C6C
                sub.w   d0,d2
                neg.w   d2
                add.w   d0,d2
                move.w  d2,y_pos(a0)
                neg.w   $16(a0)
                move.b  #1,$34(a0)
                bra.s   locret_25CBC
; ---------------------------------------------------------------------------

loc_25C6C:
                neg.w   $16(a0)
                add.w   d1,y_vel(a0)
                move.b  #1,$34(a0)
                bra.s   locret_25CBC
; ---------------------------------------------------------------------------

loc_25C7C:
                sub.w   d1,y_vel(a0)
                move.w  y_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a0)
                move.w  $32(a0),d0
                cmp.w   y_pos(a0),d0
                blo.s   locret_25CBC
                beq.s   loc_25CAE
                sub.w   d0,d2
                neg.w   d2
                add.w   d0,d2
                move.w  d2,y_pos(a0)
                neg.w   $16(a0)
                move.b  #0,$34(a0)
                bra.s   locret_25CBC
; ---------------------------------------------------------------------------

loc_25CAE:
                neg.w   $16(a0)
                sub.w   d1,y_vel(a0)
                move.b  #0,$34(a0)

locret_25CBC:
                rts
; End of function sub_25C2E
