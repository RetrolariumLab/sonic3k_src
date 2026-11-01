; Owner: objects/zones/hcz/s3
; Responsibility: Hydrocity splash emission, particle motion, player contact and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZWaterSplash:
                tst.b   subtype(a0)
                beq.s   loc_37A0A
                move.l  #Map_HCZWaterSplash2,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZ2WaterSplash2,0,0),art_tile(a0)
                tst.b   (Current_act).w
                beq.s   loc_379B4
                move.w  #make_art_tile(ArtTile_HCZ1WaterSplash2,0,0),art_tile(a0)

loc_379B4:
                ori.b   #4,render_flags(a0)
                move.w  #$300,priority(a0)
                move.b  #$A0,width_pixels(a0)
                move.b  #$80,height_pixels(a0)
                move.b  #-1,$31(a0)
                move.b  #0,status(a0)
                bset    #6,render_flags(a0)
                move.w  #2,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #5,(a2)+
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #(5<<8)|5,(a2)+
                move.l  #loc_37A8A,(a0)
                bra.w   loc_37A8A
; ---------------------------------------------------------------------------

loc_37A0A:
                move.l  #Map_HCZWaterSplash,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZWaterSplash,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$300,priority(a0)
                move.b  #$28,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #-1,$30(a0)
                move.l  #loc_37A3C,(a0)

loc_37A3C:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_37A52
                move.b  #7,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

loc_37A52:
                tst.b   render_flags(a0)
                bpl.s   loc_37A84
                moveq   #0,d1
                move.b  mapping_frame(a0),d1
                cmp.b   $30(a0),d1
                beq.s   loc_37A84
                move.b  d1,$30(a0)
                lsl.w   #8,d1
                move.w  d1,d0
                add.w   d0,d0
                add.w   d0,d1
                addi.l  #ArtUnc_HCZWaterSplash,d1
                move.w  #tiles_to_bytes(ArtTile_HCZWaterSplash),d2
                move.w  #$180,d3
                jsr     (Add_To_DMA_Queue).l

loc_37A84:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_37A8A:
                move.w  (Player_1+x_pos).w,x_pos(a0)
                move.w  (Water_level).w,y_pos(a0)
                bsr.s   UpdateHczWaterSkimmingPlayers
                tst.b   status(a0)
                beq.s   loc_37AD0
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #2,d0
                andi.b  #$F,d0
                bne.s   loc_37AB2
                moveq   #signextendB(sfx_WaterSkid),d0
                jsr     (Play_SFX).l

loc_37AB2:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_37AD0
                move.b  #2,anim_frame_timer(a0)
                addq.b  #1,$30(a0)
                cmpi.b  #5,$30(a0)
                blo.s   loc_37AD0
                move.b  #0,$30(a0)

loc_37AD0:
                moveq   #0,d1
                move.b  $30(a0),d1
                cmp.b   $31(a0),d1
                beq.s   loc_37B06
                move.b  d1,$31(a0)
                lsl.w   #7,d1
                move.w  d1,d0
                add.w   d0,d0
                add.w   d0,d1
                addi.l  #ArtUnc_HCZWaterSplash2,d1
                move.w  #tiles_to_bytes(ArtTile_HCZ2WaterSplash2),d2
                tst.b   (Current_act).w
                beq.s   loc_37AFC
                move.w  #tiles_to_bytes(ArtTile_HCZ1WaterSplash2),d2

loc_37AFC:
                move.w  #$C0,d3
                jsr     (Add_To_DMA_Queue).l

loc_37B06:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdateHczWaterSkimmingPlayers:
                lea     (Player_1).w,a1
                lea     sub2_x_pos(a0),a2
                moveq   #p1_standing_bit,d6
                move.w  (Ctrl_1_logical).w,d5
                bsr.s   UpdatePlayerSkimmingHczWater
                bclr    #0,render_flags(a0)
                btst    #Status_Facing,status(a1)
                beq.s   loc_37B30
                bset    #0,render_flags(a0)

loc_37B30:
                lea     (Player_2).w,a1
                lea     sub3_x_pos(a0),a2
                moveq   #p2_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.s   UpdatePlayerSkimmingHczWater
                move.b  render_flags(a0),d0
                add.b   status(a1),d0
                andi.b  #1,d0
                beq.s   locret_37B54
                move.b  #5,sub3_mapframe-sub3_x_pos(a2)

locret_37B54:
                rts
; End of function UpdateHczWaterSkimmingPlayers

; =============== S U B R O U T I N E =======================================

UpdatePlayerSkimmingHczWater:
                btst    d6,status(a0)
                bne.s   loc_37BAA
                tst.w   y_vel(a1)
                bne.s   locret_37BA8
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   y_pos(a1),d1
                addq.w  #1,d1
                cmp.w   (Water_level).w,d1
                bne.s   locret_37BA8
                move.w  x_vel(a1),d0
                bpl.s   loc_37B7C
                neg.w   d0

loc_37B7C:
                cmpi.w  #$700,d0
                blo.s   locret_37BA8
                bset    d6,status(a0)
                move.w  x_pos(a1),(a2)
                move.w  (Water_level).w,sub2_y_pos-sub2_x_pos(a2)
                move.b  #0,sub2_mapframe-sub2_x_pos(a2)
                bclr    #Status_Facing,status(a1)
                tst.w   x_vel(a1)
                bpl.s   locret_37BA8
                bset    #Status_Facing,status(a1)

locret_37BA8:
                rts
; ---------------------------------------------------------------------------

loc_37BAA:
                move.w  d5,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   loc_37C2A
                move.w  (Water_level).w,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                subq.w  #1,d0
                cmp.w   y_pos(a1),d0
                bhi.s   loc_37C1E
                move.w  x_vel(a1),d1
                bpl.s   loc_37BCE
                neg.w   d1

loc_37BCE:
                cmpi.w  #$700,d1
                blo.s   loc_37C1E
                move.w  d0,y_pos(a1)
                move.w  #0,y_vel(a1)
                move.w  x_pos(a1),(a2)
                move.w  (Water_level).w,sub2_y_pos-sub2_x_pos(a2)
                btst    #Status_InAir,status(a1)
                beq.s   locret_37C28
                andi.w  #(button_left_mask|button_right_mask)<<8,d5
                bne.s   locret_37C28
                move.w  #$C,d1
                move.w  x_vel(a1),d0
                beq.s   loc_37C1E
                bmi.s   loc_37C10
                sub.w   d1,d0
                bcc.s   loc_37C0A
                move.w  #0,d0

loc_37C0A:
                move.w  d0,x_vel(a1)
                bra.s   locret_37C28
; ---------------------------------------------------------------------------

loc_37C10:
                add.w   d1,d0
                bcc.s   loc_37C18
                move.w  #0,d0

loc_37C18:
                move.w  d0,x_vel(a1)
                bra.s   locret_37C28
; ---------------------------------------------------------------------------

loc_37C1E:
                bclr    d6,status(a0)
                move.b  #5,sub2_mapframe-sub2_x_pos(a2)

locret_37C28:
                rts
; ---------------------------------------------------------------------------

loc_37C2A:
                bclr    d6,status(a0)
                move.b  #5,sub2_mapframe-sub2_x_pos(a2)
                move.w  #-$680,y_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                rts
; End of function UpdatePlayerSkimmingHczWater

; ---------------------------------------------------------------------------
Map_HCZWaterSplash:
                include "src/objects/shared/zones/hcz/mappings/water_splash.s"
Map_HCZWaterSplash2:
                include "src/objects/shared/zones/hcz/mappings/water_splash_2.s"
