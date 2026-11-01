; Owner: objects/zones/mgz/s3
; Responsibility: Marble Garden moving spike-platform motion, player collision and damage
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MGZMovingSpikePlatform:
                move.l  #Map_MGZMovingSpikePlatform,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                btst    #0,status(a0)
                beq.s   loc_33ABA
                move.b  #1,$34(a0)

loc_33ABA:
                move.l  #loc_33AC0,(a0)

loc_33AC0:
                move.w  x_pos(a0),-(sp)
                tst.b   $34(a0)
                bne.s   loc_33AE4
                addq.w  #1,x_pos(a0)
                move.w  $30(a0),d0
                addi.w  #$50,d0
                cmp.w   x_pos(a0),d0
                bne.s   loc_33AFC
                move.b  #1,$34(a0)
                bra.s   loc_33AFC
; ---------------------------------------------------------------------------

loc_33AE4:
                subq.w  #1,x_pos(a0)
                move.w  $30(a0),d0
                subi.w  #$50,d0
                cmp.w   x_pos(a0),d0
                bne.s   loc_33AFC
                move.b  #0,$34(a0)

loc_33AFC:
                moveq   #0,d0
                move.b  (Oscillating_table+$12).w,d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.w  #1|2,d6
                beq.s   loc_33B78
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   loc_33B54
                bclr    #5,status(a0)
                lea     (Player_1).w,a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$28,d0
                bmi.s   loc_33B54
                jsr     (HurtPlayerFromSolidHazard).l

loc_33B54:
                andi.b  #2,d6
                beq.s   loc_33B78
                bclr    #6,status(a0)
                lea     (Player_2).w,a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$28,d0
                bmi.s   loc_33B78
                jsr     (HurtPlayerFromSolidHazard).l

loc_33B78:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_33B8E
                move.b  #7,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

loc_33B8E:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
Map_MGZMovingSpikePlatform:
                include "src/objects/shared/zones/mgz/mappings/moving_spike_platform.s"
; End of function Obj_MGZMovingSpikePlatform
