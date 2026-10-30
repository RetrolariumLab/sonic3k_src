; Owner: objects/zones/soz/sk
; Responsibility: Rising sand wall timing, coordinated movement and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZRisingSandWall:
                move.l  #Map_SOZRisingSandWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZMisc+$69,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$34,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.w  #$19,$30(a0)
                move.l  #loc_40B48,(a0)

loc_40B48:
                moveq   #0,d1
                move.b  subtype(a0),d1
                move.w  d1,d2
                add.w   d2,d2
                lea     (Player_1).w,a1
                bsr.s   sub_40B62
                lea     (Player_2).w,a1
                bsr.s   sub_40B62
                bra.w   loc_40C0E

; =============== S U B R O U T I N E =======================================

sub_40B62:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                cmp.w   d2,d0
                bhs.w   locret_40BC8
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$A4,d0
                cmpi.w  #$C0,d0
                bhs.s   locret_40BC8
                tst.w   (Debug_placement_mode).w
                bne.s   locret_40BC8
                bset    #6,render_flags(a0)
                move.w  #2,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),d0
                move.w  d0,(a2)+
                move.w  #9,(a2)+
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #0,(a2)+
                move.b  #3,anim_frame_timer(a0)
                moveq   #signextendB(sfx_SandwallRise),d0
                jsr     (Play_SFX).l
                move.l  #loc_40BCA,(a0)

locret_40BC8:
                rts
; End of function sub_40B62

; ---------------------------------------------------------------------------

loc_40BCA:
                lea     sub2_x_pos(a0),a2
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_40BEC
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,sub2_mapframe(a0)
                cmpi.b  #$D,sub2_mapframe(a0)
                blo.s   loc_40BEC
                move.b  #9,sub2_mapframe(a0)

loc_40BEC:
                subq.w  #4,y_pos(a0)
                move.w  y_pos(a0),$20(a0)
                subq.w  #1,$30(a0)
                bpl.s   loc_40C0E
                bclr    #6,render_flags(a0)
                move.w  #0,mainspr_childsprites(a0)
                move.l  #loc_40C2A,(a0)

loc_40C0E:
                move.w  #$17,d1
                move.w  #$34,d2
                move.w  #$35,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_40C2A:
                move.w  #$17,d1
                move.w  #$34,d2
                move.w  #$35,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.w  #3,d6
                beq.w   loc_40CE6
                btst    #0,d6
                beq.s   loc_40C66
                lea     (Player_1).w,a1
                cmpi.b  #2,anim(a1)
                bne.s   loc_40C66
                asr     x_vel(a1)
                asr     ground_vel(a1)
                bra.s   loc_40C80
; ---------------------------------------------------------------------------

loc_40C66:
                btst    #1,d6
                beq.s   loc_40CE6
                lea     (Player_2).w,a1
                cmpi.b  #2,anim(a1)
                bne.s   loc_40CE6
                asr     x_vel(a1)
                asr     ground_vel(a1)

loc_40C80:
                moveq   #signextendB(sfx_SandSplash),d0
                jsr     (Play_SFX).l
                move.l  #loc_40CEC,(a0)
                move.b  #5,anim_frame_timer(a0)
                move.b  #1,mapping_frame(a0)
                lea     (Player_1).w,a1
                bclr    #p1_standing_bit,status(a0)
                beq.s   loc_40CB2
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)

loc_40CB2:
                bclr    #p1_pushing_bit,status(a0)
                beq.s   loc_40CC0
                bclr    #Status_Push,status(a1)

loc_40CC0:
                lea     (Player_2).w,a1
                bclr    #p2_standing_bit,status(a0)
                beq.s   loc_40CD8
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)

loc_40CD8:
                bclr    #p2_pushing_bit,status(a0)
                beq.s   loc_40CE6
                bclr    #Status_Push,status(a1)

loc_40CE6:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_40CEC:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_40D0A
                move.b  #5,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #9,mapping_frame(a0)
                blo.s   loc_40D0A
                move.w  #$7F00,x_pos(a0)

loc_40D0A:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_SOZRisingSandWall:
                include "src/objects/shared/zones/soz/map_rising_sand_wall.s"
