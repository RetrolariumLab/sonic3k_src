; Owner: objects/zones/lbz/s3
; Responsibility: Launch Base alarm initialization, animation and player-triggered state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZAlarm:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #$D7,collision_flags(a0)
                move.l  #loc_283DC,(a0)

loc_283DC:
                tst.w   $30(a0)
                beq.s   loc_283F0
                subq.w  #1,$30(a0)
                bne.s   loc_28448
                move.w  #0,(Anim_Counters+4).w
                bra.s   loc_2846E
; ---------------------------------------------------------------------------

loc_283F0:
                tst.b   collision_property(a0)
                beq.s   loc_2846E
                clr.b   collision_property(a0)
                move.w  #$81,$30(a0)
                move.w  #1,(Anim_Counters+4).w
                btst    #0,subtype(a0)
                bne.s   locret_28446

; =============== S U B R O U T I N E =======================================

sub_2840E:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_28446
                move.l  #Obj_Flybot767,(a1)
                lea     (Player_1).w,a2
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                move.b  subtype(a0),d0
                add.w   d0,d0
                add.w   d0,d0
                andi.w  #$C,d0
                move.l  word_2847A(pc,d0.w),d0
                add.w   d0,y_pos(a1)
                swap    d0
                add.w   d0,x_pos(a1)

locret_28446:
                rts
; End of function sub_2840E

; ---------------------------------------------------------------------------

loc_28448:
                btst    #0,subtype(a0)
                beq.s   loc_2845A
                cmpi.w  #$41,$30(a0)
                bne.s   loc_2845A
                bsr.s   sub_2840E

loc_2845A:
                move.w  $30(a0),d0
                andi.b  #$1F,d0
                bne.s   locret_2846C
                moveq   #signextendB(sfx_Alarm),d0
                jsr     (Play_SFX).l

locret_2846C:
                rts
; ---------------------------------------------------------------------------

loc_2846E:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------
word_2847A:
                dc.w    $C0,  -$60
                dc.w    $C0,  -$60
                dc.w    -$C0,  -$60
                dc.w    -$C0,  -$60
