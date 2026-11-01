; Owner: objects/zones/hcz/sk
; Responsibility: Hydrocity splash emission, particle motion, player contact and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZWaterSplash:
                tst.b   subtype(a0)
                beq.s   loc_38432
                move.l  #Map_HCZWaterSplash2,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZ2WaterSplash2,0,0),art_tile(a0)
                tst.b   (Current_act).w
                beq.s   loc_383DC
                move.w  #make_art_tile(ArtTile_HCZ1WaterSplash2,0,0),art_tile(a0)

loc_383DC:
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
                move.l  #loc_384B2,(a0)
                bra.w   loc_384B2
; ---------------------------------------------------------------------------

loc_38432:
                move.l  #Map_HCZWaterSplash,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZWaterSplash,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$300,priority(a0)
                move.b  #$28,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #-1,$30(a0)
                move.l  #loc_38464,(a0)

loc_38464:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_3847A
                move.b  #7,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

loc_3847A:
                tst.b   render_flags(a0)
                bpl.s   loc_384AC
                moveq   #0,d1
                move.b  mapping_frame(a0),d1
                cmp.b   $30(a0),d1
                beq.s   loc_384AC
                move.b  d1,$30(a0)
                lsl.w   #8,d1
                move.w  d1,d0
                add.w   d0,d0
                add.w   d0,d1
                addi.l  #ArtUnc_HCZWaterSplash,d1
                move.w  #tiles_to_bytes(ArtTile_HCZWaterSplash),d2
                move.w  #$180,d3
                jsr     (Add_To_DMA_Queue).l

loc_384AC:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_384B2:
                move.w  (Player_1+x_pos).w,x_pos(a0)
                move.w  (Water_level).w,y_pos(a0)
                bsr.s   UpdateHczWaterSkimmingPlayers
                tst.b   status(a0)
                beq.s   loc_384F8
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #2,d0
                andi.b  #$F,d0
                bne.s   loc_384DA
                moveq   #signextendB(sfx_WaterSkid),d0
                jsr     (Play_SFX).l

loc_384DA:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_384F8
                move.b  #2,anim_frame_timer(a0)
                addq.b  #1,$30(a0)
                cmpi.b  #5,$30(a0)
                blo.s   loc_384F8
                move.b  #0,$30(a0)

loc_384F8:
                moveq   #0,d1
                move.b  $30(a0),d1
                cmp.b   $31(a0),d1
                beq.s   loc_3852E
                move.b  d1,$31(a0)
                lsl.w   #7,d1
                move.w  d1,d0
                add.w   d0,d0
                add.w   d0,d1
                addi.l  #ArtUnc_HCZWaterSplash2,d1
                move.w  #tiles_to_bytes(ArtTile_HCZ2WaterSplash2),d2
                tst.b   (Current_act).w
                beq.s   loc_38524
                move.w  #tiles_to_bytes(ArtTile_HCZ1WaterSplash2),d2

loc_38524:
                move.w  #$C0,d3
                jsr     (Add_To_DMA_Queue).l

loc_3852E:
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
                beq.s   loc_38558
                bset    #0,render_flags(a0)

loc_38558:
                lea     (Player_2).w,a1
                lea     sub3_x_pos(a0),a2
                moveq   #p2_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.s   UpdatePlayerSkimmingHczWater
                move.b  render_flags(a0),d0
                add.b   status(a1),d0
                andi.b  #1,d0
                beq.s   locret_3857C
                move.b  #5,sub3_mapframe-sub3_x_pos(a2)

locret_3857C:
                rts
; End of function UpdateHczWaterSkimmingPlayers

; =============== S U B R O U T I N E =======================================

UpdatePlayerSkimmingHczWater:
                btst    d6,status(a0)
                bne.s   loc_385D2
                tst.w   y_vel(a1)
                bne.s   locret_385D0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   y_pos(a1),d1
                addq.w  #1,d1
                cmp.w   (Water_level).w,d1
                bne.s   locret_385D0
                move.w  x_vel(a1),d0
                bpl.s   loc_385A4
                neg.w   d0

loc_385A4:
                cmpi.w  #$700,d0
                blo.s   locret_385D0
                bset    d6,status(a0)
                move.w  x_pos(a1),(a2)
                move.w  (Water_level).w,sub2_y_pos-sub2_x_pos(a2)
                move.b  #0,sub2_mapframe-sub2_x_pos(a2)
                bclr    #Status_Facing,status(a1)
                tst.w   x_vel(a1)
                bpl.s   locret_385D0
                bset    #Status_Facing,status(a1)

locret_385D0:
                rts
; ---------------------------------------------------------------------------

loc_385D2:
                move.w  d5,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   loc_38652
                move.w  (Water_level).w,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                subq.w  #1,d0
                cmp.w   y_pos(a1),d0
                bhi.s   loc_38646
                move.w  x_vel(a1),d1
                bpl.s   loc_385F6
                neg.w   d1

loc_385F6:
                cmpi.w  #$700,d1
                blo.s   loc_38646
                move.w  d0,y_pos(a1)
                move.w  #0,y_vel(a1)
                move.w  x_pos(a1),(a2)
                move.w  (Water_level).w,sub2_y_pos-sub2_x_pos(a2)
                btst    #Status_InAir,status(a1)
                beq.s   locret_38650
                andi.w  #(button_left_mask|button_right_mask)<<8,d5
                bne.s   locret_38650
                move.w  #$C,d1
                move.w  x_vel(a1),d0
                beq.s   loc_38646
                bmi.s   loc_38638
                sub.w   d1,d0
                bcc.s   loc_38632
                move.w  #0,d0

loc_38632:
                move.w  d0,x_vel(a1)
                bra.s   locret_38650
; ---------------------------------------------------------------------------

loc_38638:
                add.w   d1,d0
                bcc.s   loc_38640
                move.w  #0,d0

loc_38640:
                move.w  d0,x_vel(a1)
                bra.s   locret_38650
; ---------------------------------------------------------------------------

loc_38646:
                bclr    d6,status(a0)
                move.b  #5,sub2_mapframe-sub2_x_pos(a2)

locret_38650:
                rts
; ---------------------------------------------------------------------------

loc_38652:
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
