; Owner: objects/zones/mgz/s3
; Responsibility: Marble Garden triggered platform initialization, movement and player riding
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
byte_33868:
                dc.b    $40, $1E,   0, $40
                dc.b    $20, $40,   1, $40
                dc.b    $20, $40,   1, $40
                even
; ---------------------------------------------------------------------------

Obj_MGZTriggerPlatform:
                move.b  subtype(a0),d1
                andi.w  #$F0,d1
                lsr.w   #2,d1
                lea     byte_33868(pc,d1.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                moveq   #0,d0
                move.b  (a1)+,d0
                move.w  d0,$30(a0)
                lsr.w   #2,d1
                move.w  d1,$34(a0)
                move.l  #Map_MGZTriggerPlatform,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.w  x_pos(a0),$36(a0)
                tst.w   d1
                beq.s   loc_338CA
                move.l  #loc_3393E,(a0)
                bra.w   loc_3393E
; ---------------------------------------------------------------------------

loc_338CA:
                move.l  #loc_338D0,(a0)

loc_338D0:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                beq.s   loc_33916
                moveq   #2,d0
                btst    #0,status(a0)
                beq.s   loc_338EE
                neg.w   d0

loc_338EE:
                add.w   d0,x_pos(a0)
                move.w  #-1,(Screen_shake_flag).w
                subq.w  #1,$30(a0)
                bne.s   loc_33916
                move.w  #$7F00,x_pos(a0)
                move.w  #$7F00,$36(a0)
                move.w  #0,respawn_addr(a0)
                move.w  #0,(Screen_shake_flag).w

loc_33916:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.w  $36(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

loc_3393E:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                tst.b   (a3,d0.w)
                beq.s   loc_3395C
                tst.b   $32(a0)
                bmi.s   loc_3398E
                move.b  #1,$32(a0)

loc_3395C:
                tst.b   $32(a0)
                beq.s   loc_3398E
                bmi.s   loc_3398E
                move.w  $34(a0),d0
                btst    #0,status(a0)
                beq.s   loc_33972
                neg.w   d0

loc_33972:
                add.w   d0,y_pos(a0)
                move.w  #-1,(Screen_shake_flag).w
                subq.w  #1,$30(a0)
                bne.s   loc_3398E
                move.b  #-1,$32(a0)
                move.w  #0,(Screen_shake_flag).w

loc_3398E:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_MGZTriggerPlatform:
                include "src/objects/shared/zones/mgz/map_trigger_platform.s"
; End of function Obj_MGZTriggerPlatform
