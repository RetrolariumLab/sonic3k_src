; Owner: objects/zones/lbz/sk
; Responsibility: Launch Base alarm initialization, animation and player-triggered state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZAlarm:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #$D7,collision_flags(a0)
                move.l  #loc_2946A,(a0)

loc_2946A:
                tst.w   $30(a0)
                beq.s   loc_2947E
                subq.w  #1,$30(a0)
                bne.s   loc_294D6
                move.w  #0,(Anim_Counters+4).w
                bra.s   loc_294FC
; ---------------------------------------------------------------------------

loc_2947E:
                tst.b   collision_property(a0)
                beq.s   loc_294FC
                clr.b   collision_property(a0)
                move.w  #$81,$30(a0)
                move.w  #1,(Anim_Counters+4).w
                btst    #0,subtype(a0)
                bne.s   locret_294D4

; =============== S U B R O U T I N E =======================================

sub_2949C:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_294D4
                move.l  #Obj_Flybot767,(a1)
                lea     (Player_1).w,a2
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                move.b  subtype(a0),d0
                add.w   d0,d0
                add.w   d0,d0
                andi.w  #$C,d0
                move.l  word_29508(pc,d0.w),d0
                add.w   d0,y_pos(a1)
                swap    d0
                add.w   d0,x_pos(a1)

locret_294D4:
                rts
; End of function sub_2949C

; ---------------------------------------------------------------------------

loc_294D6:
                btst    #0,subtype(a0)
                beq.s   loc_294E8
                cmpi.w  #$41,$30(a0)
                bne.s   loc_294E8
                bsr.s   sub_2949C

loc_294E8:
                move.w  $30(a0),d0
                andi.b  #$1F,d0
                bne.s   locret_294FA
                moveq   #signextendB(sfx_Alarm),d0
                jsr     (Play_SFX).l

locret_294FA:
                rts
; ---------------------------------------------------------------------------

loc_294FC:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------
word_29508:
                dc.w    $C0,  -$60
                dc.w    $C0,  -$60
                dc.w    -$C0,  -$60
                dc.w    -$C0,  -$60
