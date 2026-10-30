; Owner: objects/zones/lrz/sk
; Responsibility: Solid rock placement, motion, collision and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZSolidRock:
                move.l  #Map_LRZSolidRock,mappings(a0)
                move.w  #make_art_tile($090,3,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.w  y_pos(a0),$46(a0)
                move.l  #loc_44176,(a0)
                move.w  #-$60,d0
                tst.b   subtype(a0)
                bpl.s   loc_44132
                move.w  #-$C0,d0

loc_44132:
                move.w  respawn_addr(a0),d1
                beq.s   loc_4415E
                movea.w d1,a2
                btst    #0,(a2)
                beq.s   loc_4415E
                btst    #6,subtype(a0)
                bne.s   loc_44166

loc_44148:
                neg.w   d0
                move.w  #-$3F6E,$32(a0)
                move.b  #1,$30(a0)
                move.l  #loc_441A6,(a0)
                bra.s   loc_44166
; ---------------------------------------------------------------------------

loc_4415E:
                btst    #6,subtype(a0)
                bne.s   loc_44148

loc_44166:
                btst    #0,status(a0)
                beq.s   loc_44170
                neg.w   d0

loc_44170:
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_44176:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                btst    #0,(a3,d0.w)
                beq.s   loc_441D6
                move.l  #loc_441D2,(a0)
                moveq   #signextendB(sfx_DoorOpen),d0
                jsr     (Play_SFX).l
                move.w  respawn_addr(a0),d0
                beq.s   loc_441A4
                movea.w d0,a2
                bset    #0,(a2)

loc_441A4:
                bra.s   loc_441D2
; ---------------------------------------------------------------------------

loc_441A6:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                bpl.s   loc_441D6
                move.l  #loc_441D2,(a0)
                moveq   #signextendB(sfx_DoorOpen),d0
                jsr     (Play_SFX).l
                move.w  respawn_addr(a0),d0
                beq.s   loc_441D2
                movea.w d0,a2
                bclr    #0,(a2)

loc_441D2:
                bsr.w   sub_441F2

loc_441D6:
                move.w  #$23,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_441F2:
                move.w  #$60,d2
                tst.b   $30(a0)
                bne.s   loc_44220
                move.w  $34(a0),d1
                addq.w  #2,d1
                bne.s   loc_4420A
                move.l  #loc_44176,(a0)

loc_4420A:
                move.w  d1,$34(a0)
                add.w   d1,$32(a0)
                cmp.b   $32(a0),d2
                bhi.s   loc_44242
                move.b  #1,$30(a0)
                bra.s   loc_44242
; ---------------------------------------------------------------------------

loc_44220:
                move.w  $34(a0),d1
                subq.w  #2,d1
                bne.s   loc_4422E
                move.l  #loc_441A6,(a0)

loc_4422E:
                move.w  d1,$34(a0)
                add.w   d1,$32(a0)
                cmp.b   $32(a0),d2
                bls.s   loc_44242
                move.b  #0,$30(a0)

loc_44242:
                tst.b   $2C(a0)
                bmi.s   loc_44266
                moveq   #0,d0
                move.b  $32(a0),d0
                subi.w  #$60,d0
                btst    #0,status(a0)
                beq.s   loc_4425C
                neg.w   d0

loc_4425C:
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_44266:
                moveq   #0,d0
                move.w  $32(a0),d0
                lsr.w   #7,d0
                subi.w  #$C0,d0
                btst    #0,status(a0)
                beq.s   loc_4427C
                neg.w   d0

loc_4427C:
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                rts
; End of function sub_441F2

; ---------------------------------------------------------------------------
Map_LRZSolidRock:
                include "src/objects/shared/zones/lrz/map_solid_rock.s"
