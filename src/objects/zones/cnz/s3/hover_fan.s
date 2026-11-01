; Owner: objects/zones/cnz/s3
; Responsibility: Carnival Night hovering fan motion, player lift and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZHoverFan:
                move.l  #Map_CNZHoverFan,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$97,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  x_pos(a0),$30(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F,d0
                addq.w  #4,d0
                lsl.w   #4,d0
                move.w  d0,$36(a0)
                addi.w  #$30,d0
                move.w  d0,$38(a0)
                andi.w  #$70,d1
                addi.w  #$18,d1
                move.w  d1,$32(a0)
                add.w   d1,d1
                move.w  d1,$34(a0)
                move.b  subtype(a0),d0
                bmi.s   loc_30EE6
                move.l  #loc_30F56,(a0)
                bra.w   loc_30F56
; ---------------------------------------------------------------------------

loc_30EE6:
                andi.w  #$70,d0
                move.w  d0,d1
                lsr.w   #4,d0
                move.b  d0,mapping_frame(a0)
                addi.b  #$10,d1
                move.b  d1,width_pixels(a0)
                btst    #0,status(a0)
                bne.s   loc_30F0C
                move.l  #loc_30F24,(a0)
                bra.w   loc_30F24
; ---------------------------------------------------------------------------

loc_30F0C:
                move.l  #loc_30F12,(a0)

loc_30F12:
                moveq   #0,d0
                move.b  (Oscillating_table+$0E).w,d0
                subi.w  #$30,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)

loc_30F24:
                moveq   #0,d6
                lea     (Player_1).w,a1
                bsr.w   ApplyCnzHoverFanFieldToPlayer
                lea     (Player_2).w,a1
                bsr.w   ApplyCnzHoverFanFieldToPlayer
                tst.w   d6
                beq.s   loc_30F4C
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   loc_30F4C
                moveq   #signextendB(sfx_Hoverpad),d0
                jsr     (Play_SFX).l

loc_30F4C:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

loc_30F56:
                moveq   #0,d6
                lea     (Player_1).w,a1
                bsr.w   ApplyCnzHoverFanFieldToPlayer
                lea     (Player_2).w,a1
                bsr.w   ApplyCnzHoverFanFieldToPlayer
                tst.w   d6
                beq.s   loc_30F7E
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$1F,d0
                bne.s   loc_30F7E
                moveq   #signextendB(sfx_Hoverpad),d0
                jsr     (Play_SFX).l

loc_30F7E:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

ApplyCnzHoverFanFieldToPlayer:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   $32(a0),d0
                cmp.w   $34(a0),d0
                bhs.s   locret_3100E
                moveq   #0,d1
                move.b  (Oscillating_table+$16).w,d1
                add.w   y_pos(a1),d1
                add.w   $36(a0),d1
                sub.w   y_pos(a0),d1
                bcs.s   locret_3100E
                cmp.w   $38(a0),d1
                bhs.s   locret_3100E
                cmpi.b  #4,routine(a1)
                bhs.w   locret_3100E
                tst.b   object_control(a1)
                bne.s   locret_3100E
                sub.w   $36(a0),d1
                bcs.s   loc_30FCA
                not.w   d1
                add.w   d1,d1

loc_30FCA:
                add.w   $36(a0),d1
                neg.w   d1
                asr.w   #4,d1
                add.w   d1,y_pos(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.w  #0,y_vel(a1)
                moveq   #1,d6
                move.w  #1,ground_vel(a1)
                tst.b   flip_angle(a1)
                bne.s   locret_3100E
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #$7F,flips_remaining(a1)
                move.b  #8,flip_speed(a1)

locret_3100E:
                rts
; End of function ApplyCnzHoverFanFieldToPlayer

; ---------------------------------------------------------------------------
Map_CNZHoverFan:
                include "src/objects/shared/zones/cnz/mappings/hover_fan.s"
