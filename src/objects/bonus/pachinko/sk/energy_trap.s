; Owner: objects/bonus/pachinko/sk
; Responsibility: Pachinko energy trap capture, player response and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_PachinkoEnergyTrap:
                movea.l a0,a1
                moveq   #2-1,d1
                bra.s   loc_49F20
; ---------------------------------------------------------------------------

loc_49EF4:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_49F46
                move.l  #loc_4A07A,(a1)
                move.w  x_pos(a0),x_pos(a1)
                addi.w  #$190,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                bset    #0,render_flags(a1)
                move.w  a0,$3E(a1)

loc_49F20:
                move.l  #Map_PachinkoEnergyTrap,mappings(a1)
                move.w  #make_art_tile(ArtTile_PachinkoMain+$85,1,1),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.b  #8,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.w  #0,priority(a1)

loc_49F46:
                dbf     d1,loc_49EF4
                move.b  #60,$24(a0)
                move.b  #4*60,$25(a0)
                move.l  #loc_49F5C,(a0)

loc_49F5C:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   loc_49F92
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_49F92
                move.l  #Obj_PachinkoInvisibleUnknown,(a1)
                move.w  x_pos(a0),x_pos(a1)
                addi.w  #$80,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  angle(a0),angle(a1)
                move.w  a0,$3E(a1)

loc_49F92:
                addi.b  #8,angle(a0)
                tst.b   subtype(a0)
                bne.s   loc_49FAE
                tst.b   $25(a0)
                beq.s   loc_49FAA
                subq.b  #1,$25(a0)
                bra.s   loc_49FAE
; ---------------------------------------------------------------------------

loc_49FAA:
                subq.w  #1,y_pos(a0)

loc_49FAE:
                lea     (Player_1).w,a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$180,d0
                cmpi.w  #$180,d0
                bhs.s   loc_49FD6
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$3F,d0
                bne.s   loc_49FD6
                moveq   #signextendB(sfx_Transporter),d0
                jsr     (Play_SFX).l

loc_49FD6:
                bsr.s   sub_49FE4
                lea     (Player_2).w,a1
                bsr.s   sub_49FE4
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_49FE4:
                move.w  y_pos(a1),d0
                cmpi.w  #-$20,d0
                bge.s   loc_49FFC
                cmpa.w  #Player_1,a1
                bne.s   loc_4A024
                move.b  #0,$24(a0)
                bra.s   loc_4A024
; ---------------------------------------------------------------------------

loc_49FFC:
                sub.w   y_pos(a0),d0
                addi.w  #$C,d0
                cmpi.w  #$18,d0
                bhs.s   locret_4A078
                tst.w   (Debug_placement_mode).w
                bne.s   locret_4A078
                move.w  y_pos(a0),y_pos(a1)
                tst.b   $2E(a1)
                bne.s   loc_4A024
                moveq   #signextendB(sfx_Bouncy),d0
                jsr     (Play_SFX).l

loc_4A024:
                move.b  #$81,object_control(a1)
                bset    #Status_InAir,status(a1)
                cmpa.w  #Player_1,a1
                bne.s   locret_4A078
                move.b  #1,subtype(a0)
                subq.b  #1,$24(a0)
                bcc.s   locret_4A078
                move.w  (Saved_zone_and_act).w,(Current_zone_and_act).w
                move.w  (Saved_apparent_zone_and_act).w,(Apparent_zone_and_act).w
                move.b  (Saved_last_star_post_hit).w,(Last_star_post_hit).w
                move.b  #0,(Special_bonus_entry_flag).w
                move.b  #1,(Restart_level_flag).w
                move.w  (Ring_count).w,(Saved_ring_count).w
                move.b  (Extra_life_flags).w,(Saved_extra_life_flags).w
                move.b  (Player_1+status_secondary).w,d0
                andi.b  #$71,d0
                move.b  d0,(Saved_status_secondary).w

locret_4A078:
                rts
; End of function sub_49FE4

; ---------------------------------------------------------------------------

loc_4A07A:
                movea.w $3E(a0),a1
                move.w  y_pos(a1),y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_PachinkoEnergyTrap:
                include "src/objects/shared/zones/pachinko/mappings/energy_trap.s"
