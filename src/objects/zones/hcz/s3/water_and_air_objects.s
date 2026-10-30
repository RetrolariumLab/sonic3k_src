; Owner: objects/zones/hcz/s3
; Responsibility: Hydrocity air-bubble, water-rush and water-wall object families with player contact, debris and shared sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_Bubbler:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Bubbler_Index(pc,d0.w),d1
                jmp     Bubbler_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Bubbler_Index:
                dc.w    loc_2E068-Bubbler_Index
                dc.w    loc_2E0C6-Bubbler_Index
                dc.w    loc_2E0E0-Bubbler_Index
                dc.w    loc_2E142-Bubbler_Index
                dc.w    loc_2E160-Bubbler_Index
                dc.w    loc_2E166-Bubbler_Index
; ---------------------------------------------------------------------------

loc_2E068:
                addq.b  #2,routine(a0)
                move.l  #Map_Bubbler,mappings(a0)
                move.w  #make_art_tile(ArtTile_Bubbles,0,0),art_tile(a0)
                move.b  #$84,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  subtype(a0),d0
                bpl.s   loc_2E0AC
                addq.b  #8,routine(a0)
                andi.w  #$7F,d0
                move.b  d0,$32(a0)
                move.b  d0,$33(a0)
                move.b  #8,anim(a0)
                bra.w   loc_2E166
; ---------------------------------------------------------------------------

loc_2E0AC:
                move.b  d0,anim(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  #-$88,y_vel(a0)
                jsr     (Random_Number).l
                move.b  d0,angle(a0)

loc_2E0C6:
                lea     (Ani_Bubbler).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #6,mapping_frame(a0)
                bne.s   loc_2E0E0
                move.b  #1,$2E(a0)

loc_2E0E0:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_2E0F8
                move.b  #6,routine(a0)
                addq.b  #4,anim(a0)
                bra.w   loc_2E142
; ---------------------------------------------------------------------------

loc_2E0F8:
                move.b  angle(a0),d0
                addq.b  #1,angle(a0)
                andi.w  #$7F,d0
                lea     (AirCountdown_WobbleData).l,a1
                move.b  (a1,d0.w),d0
                ext.w   d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                tst.b   $2E(a0)
                beq.s   loc_2E12A
                bsr.w   sub_2E2BE
                cmpi.b  #6,routine(a0)
                beq.s   loc_2E142

loc_2E12A:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bpl.s   loc_2E13C
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2E13C:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2E142:
                lea     (Ani_Bubbler).l,a1
                jsr     (Animate_Sprite).l
                tst.b   render_flags(a0)
                bpl.s   loc_2E15A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2E15A:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2E160:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2E166:
                tst.w   $36(a0)
                bne.s   loc_2E1C8
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bhs.w   loc_2E272
                tst.b   render_flags(a0)
                bpl.w   loc_2E272
                subq.w  #1,$38(a0)
                bpl.w   loc_2E266
                move.w  #1,$36(a0)

loc_2E18E:
                jsr     (Random_Number).l
                move.w  d0,d1
                andi.w  #7,d0
                cmpi.w  #6,d0
                bhs.s   loc_2E18E
                move.b  d0,$34(a0)
                andi.w  #$C,d1
                lea     (byte_2E2AC).l,a1
                adda.w  d1,a1
                move.l  a1,$3C(a0)
                subq.b  #1,$32(a0)
                bpl.s   loc_2E1C6
                move.b  $33(a0),$32(a0)
                bset    #7,$36(a0)

loc_2E1C6:
                bra.s   loc_2E1D0
; ---------------------------------------------------------------------------

loc_2E1C8:
                subq.w  #1,$38(a0)
                bpl.w   loc_2E266

loc_2E1D0:
                jsr     (Random_Number).l
                andi.w  #$1F,d0
                move.w  d0,$38(a0)
                jsr     (AllocateObject).l
                bne.s   loc_2E24A
                move.l  (a0),(a1)
                move.w  x_pos(a0),x_pos(a1)
                jsr     (Random_Number).l
                andi.w  #$F,d0
                subq.w  #8,d0
                add.w   d0,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                moveq   #0,d0
                move.b  $34(a0),d0
                movea.l $3C(a0),a2
                move.b  (a2,d0.w),subtype(a1)
                btst    #7,$36(a0)
                beq.s   loc_2E24A
                jsr     (Random_Number).l
                andi.w  #3,d0
                bne.s   loc_2E236
                bset    #6,$36(a0)
                bne.s   loc_2E24A
                move.b  #2,subtype(a1)

loc_2E236:
                tst.b   $34(a0)
                bne.s   loc_2E24A
                bset    #6,$36(a0)
                bne.s   loc_2E24A
                move.b  #2,subtype(a1)

loc_2E24A:
                subq.b  #1,$34(a0)
                bpl.s   loc_2E266
                jsr     (Random_Number).l
                andi.w  #$7F,d0
                addi.w  #$80,d0
                add.w   d0,$38(a0)
                clr.w   $36(a0)

loc_2E266:
                lea     (Ani_Bubbler).l,a1
                jsr     (Animate_Sprite).l

loc_2E272:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_2E294
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                blo.w   loc_2E2A6
                rts
; ---------------------------------------------------------------------------

loc_2E294:
                move.w  respawn_addr(a0),d0
                beq.s   loc_2E2A0
                movea.w d0,a2
                bclr    #7,(a2)

loc_2E2A0:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2E2A6:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
byte_2E2AC:
                dc.b    0
                dc.b    1
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    0
                dc.b    1
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    0
                even

; =============== S U B R O U T I N E =======================================

sub_2E2BE:
                lea     (Player_1).w,a1
                bsr.s   sub_2E2C8
                lea     (Player_2).w,a1
; End of function sub_2E2BE

sub_2E2C8:
                tst.b   object_control(a1)
                bmi.w   locret_2E392
                move.w  x_pos(a1),d0
                move.w  x_pos(a0),d1
                subi.w  #$10,d1
                cmp.w   d0,d1
                bhs.w   locret_2E392
                addi.w  #2*$10,d1
                cmp.w   d0,d1
                blo.w   locret_2E392
                move.w  y_pos(a1),d0
                move.w  y_pos(a0),d1
                cmp.w   d0,d1
                bhs.w   locret_2E392
                addi.w  #$10,d1
                cmp.w   d0,d1
                blo.w   locret_2E392
                btst    #Status_BublShield,status_secondary(a1)
                bne.w   locret_2E392
                jsr     (Player_ResetAirTimer).l
                moveq   #signextendB(sfx_Bubble),d0
                jsr     (Play_SFX).l
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.b  #$15,anim(a1)
                move.w  #35,move_lock(a1)
                move.b  #0,jumping(a1)
                bclr    #Status_Push,status(a1)
                bclr    #Status_RollJump,status(a1)
                btst    #Status_Roll,status(a1)
                beq.w   loc_2E380
                cmpi.l  #Obj_Sonic,(a1)
                bne.s   loc_2E370
                bclr    #Status_Roll,status(a1)
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)
                subq.w  #5,y_pos(a1)
                bra.s   loc_2E380
; ---------------------------------------------------------------------------

loc_2E370:
                move.b  #$F,y_radius(a1)
                move.b  #9,x_radius(a1)
                subq.w  #1,y_pos(a1)

loc_2E380:
                cmpi.b  #6,routine(a0)
                beq.s   locret_2E392
                move.b  #6,routine(a0)
                addq.b  #4,anim(a0)

locret_2E392:
                rts
; ---------------------------------------------------------------------------
Ani_Bubbler:
                include "src/objects/shared/bubbles/anim_bubbler.s"
Map_Bubbler:
                include "src/objects/shared/bubbles/map_bubbler.s"
; ---------------------------------------------------------------------------

Obj_HCZWaterRush:
                move.l  #Map_HCZWaterRush,mappings(a0)
                ori.b   #4,render_flags(a0)
                move.w  #make_art_tile(ArtTile_HCZWaterRush,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #2,mapping_frame(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2E53E
                move.l  #loc_2E5C8,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subi.w  #$30,x_pos(a1)
                move.l  #Map_HCZWaterRushBlock,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZMisc+$A,2,0),art_tile(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$20,height_pixels(a1)
                move.b  #4,render_flags(a1)
                move.w  #$280,priority(a1)
                move.b  #1,mapping_frame(a1)
                move.w  a1,$3C(a0)

loc_2E53E:
                move.b  #3,(_unkF7C7).w
                move.l  #loc_2E54A,(a0)

loc_2E54A:
                tst.b   (Level_trigger_array).w
                beq.s   loc_2E56E
                move.b  #3,mapping_frame(a0)
                move.b  #1,anim_frame_timer(a0)
                move.l  #loc_2E574,(a0)
                move.b  #0,(_unkF7C7).w
                move.b  #1,(Palette_cycle_counters+$00).w

loc_2E56E:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2E574:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_2E5B4
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #2,mapping_frame(a0)
                bne.s   loc_2E5AE
                addi.w  #$20,x_pos(a0)
                cmpi.w  #$580,x_pos(a0)
                bne.s   loc_2E5AE
                cmpi.w  #$5A0,y_pos(a0)
                bne.s   loc_2E5AE
                subi.w  #$20,x_pos(a0)
                subi.w  #$20,y_pos(a0)

loc_2E5AE:
                andi.b  #1,mapping_frame(a0)

loc_2E5B4:
                cmpi.w  #$980,x_pos(a0)
                blo.s   loc_2E5C2
                move.w  #$7F00,x_pos(a0)

loc_2E5C2:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2E5C8:
                tst.b   (Level_trigger_array).w
                beq.s   loc_2E5E8
                move.l  #loc_2E5D4,(a0)

loc_2E5D4:
                subi.w  #$10,y_pos(a0)
                cmpi.w  #$560,y_pos(a0)
                bne.s   loc_2E5E8
                move.w  #$7F00,x_pos(a0)

loc_2E5E8:
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
Map_HCZWaterRush:
                include "src/objects/shared/zones/hcz/map_water_rush.s"
Map_HCZWaterRushBlock:
                include "src/objects/shared/zones/hcz/map_water_rush_block.s"
; ---------------------------------------------------------------------------

Obj_HCZWaterWall:
                tst.b   subtype(a0)
                beq.s   loc_2E794
                move.l  #loc_2EB24,(a0)
                rts
; ---------------------------------------------------------------------------

loc_2E794:
                move.w  (Player_1+y_pos).w,d0
                cmpi.w  #$500,d0
                bhs.s   loc_2E7A4
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2E7A4:
                lea     (ArtKosM_HCZGeyserHorz).l,a1
                move.w  #tiles_to_bytes(ArtTile_HCZGeyser),d2
                jsr     (Queue_Kos_Module).l
                move.l  #loc_2E7BA,(a0)

loc_2E7BA:
                tst.b   (Kos_modules_left).w
                beq.s   loc_2E7C2
                rts
; ---------------------------------------------------------------------------

loc_2E7C2:
                ori.b   #4,render_flags(a0)
                move.w  #$300,priority(a0)
                move.l  #Map_HCZWaterWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZGeyser,2,0),art_tile(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #$20,$30(a0)
                move.l  #loc_2E80C,(a0)

loc_2E80C:
                move.w  (Player_1+x_pos).w,d0
                subi.w  #$60,d0
                cmp.w   x_pos(a0),d0
                blo.w   loc_2E896
                move.l  #loc_2E8CC,(a0)
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                lea     (byte_2E89C).l,a3
                move.w  x_pos(a0),d2
                addi.w  #$60,d2
                move.w  y_pos(a0),d3
                moveq   #8-1,d1

loc_2E83E:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_2E896
                move.l  #loc_2E9AA,(a1)
                move.l  #Map_HCZWaterWallDebris,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZGeyser+$58,2,0),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  #$380,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.w  (a3)+,x_vel(a1)
                move.w  (a3)+,y_vel(a1)
                move.b  d1,mapping_frame(a1)
                dbf     d1,loc_2E83E

loc_2E896:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
byte_2E89C:
                dc.b    0,-$18
                dc.w    $400,  -$80
                dc.b    0,  -8
                dc.w    $600,  -$40
                dc.b    0,   8
                dc.w    $600,   $40
                dc.b    0, $18
                dc.w    $400,   $80
                dc.b    0,-$18
                dc.w    $300, -$380
                dc.b    0,  -8
                dc.w    $400, -$340
                dc.b    0,   8
                dc.w    $300,  $100
                dc.b    0, $18
                dc.w    $500, -$100
; ---------------------------------------------------------------------------

loc_2E8CC:
                tst.w   $30(a0)
                beq.s   loc_2E8DA
                subq.w  #1,$30(a0)
                addq.w  #8,x_pos(a0)

loc_2E8DA:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2E958
                move.l  #loc_2EA6E,(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  #$84,render_flags(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  (Level_frame_counter).w,d0
                jsr     (Random_Number).l
                move.w  d0,d1
                andi.w  #$F,d0
                lsl.w   #3,d0
                subi.w  #$50,d0
                add.w   d0,x_pos(a1)
                addi.w  #$18,y_pos(a1)
                move.w  #make_art_tile(ArtTile_HCZGeyser+$30,2,0),art_tile(a1)
                lsr.w   #4,d1
                andi.w  #3,d1
                bne.s   loc_2E936
                move.w  #make_art_tile(ArtTile_Bubbles,0,0),art_tile(a1)

loc_2E936:
                move.b  d1,anim(a1)
                move.w  #$380,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.w  #$400,x_vel(a1)
                move.w  #0,y_vel(a1)

loc_2E958:
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                tst.b   render_flags(a0)
                bmi.s   loc_2E990
                clr.b   (Palette_cycle_counters+$00).w
                move.w  #signextendB(cmd_MutePSG),d0
                jsr     (Play_SFX).l
                move.w  #signextendB(cmd_StopSFX),d0
                jsr     (Play_SFX).l
                move.w  #150,$30(a0)
                move.l  #loc_2E996,(a0)
                rts
; ---------------------------------------------------------------------------

loc_2E990:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2E996:
                subq.w  #1,$30(a0)
                bmi.s   loc_2E99E
                rts
; ---------------------------------------------------------------------------

loc_2E99E:
                jsr     (LoadEnemyArt).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2E9AA:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_2E9C0
                move.b  #2,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #7,mapping_frame(a0)

loc_2E9C0:
                jsr     (MoveSprite2).l
                addi.w  #$38,y_vel(a0)
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_2EA32
                move.w  #0,y_vel(a0)
                asr     x_vel(a0)
                asr     x_vel(a0)
                move.l  #loc_2EA38,(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2EA32
                move.l  #loc_2EACE,(a1)
                move.l  #Map_HCZWaterWall,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZGeyser+$30,1,0),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  (Water_level).w,y_pos(a1)
                move.w  #$200,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.b  #8,anim(a1)

loc_2EA32:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2EA38:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_2EA4E
                move.b  #9,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #7,mapping_frame(a0)

loc_2EA4E:
                jsr     (MoveSprite2).l
                addi.w  #8,y_vel(a0)
                tst.b   render_flags(a0)
                bpl.w   loc_2EA68
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2EA68:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2EA6E:
                jsr     (MoveSprite2).l
                addi.w  #$28,y_vel(a0)
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_2EA92
                move.w  d0,y_pos(a0)
                move.l  #loc_2EAAC,(a0)
                addq.b  #4,anim(a0)

loc_2EA92:
                tst.b   render_flags(a0)
                bpl.w   loc_2EA68
                lea     (Ani_HCZWaterWall).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2EAAC:
                tst.b   render_flags(a0)
                bpl.w   loc_2EA68
                lea     (Ani_HCZWaterWall).l,a1
                jsr     (Animate_Sprite).l
                tst.b   routine(a0)
                bne.w   loc_2EA68
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2EACE:
                tst.b   render_flags(a0)
                bpl.w   loc_2EA68
                lea     (Ani_HCZWaterWall).l,a1
                jsr     (Animate_SpriteIrregularDelay).l
                tst.b   routine(a0)
                bne.w   loc_2EA68
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_HCZWaterWall:
                include "src/objects/shared/zones/hcz/anim_water_wall.s"
; ---------------------------------------------------------------------------

loc_2EB24:
                move.w  (Player_1+x_pos).w,d0
                addi.w  #$30,d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$60,d0
                bhs.s   loc_2EB48
                move.w  (Player_1+y_pos).w,d0
                addi.w  #$40,d0
                sub.w   y_pos(a0),d0
                cmpi.w  #$10,d0
                blo.s   loc_2EB4E

loc_2EB48:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_2EB4E:
                lea     (ArtKosM_HCZGeyserVert).l,a1
                move.w  #tiles_to_bytes(ArtTile_HCZGeyser),d2
                jsr     (Queue_Kos_Module).l
                move.b  #1,mapping_frame(a0)
                move.b  #$81,(Player_1+object_control).w
                move.b  #$81,(Player_2+object_control).w
                move.l  #loc_2EB76,(a0)

loc_2EB76:
                tst.b   (Kos_modules_left).w
                beq.s   loc_2EB8A
                subi.w  #8,(Player_1+y_pos).w
                subi.w  #8,(Player_2+y_pos).w
                rts
; ---------------------------------------------------------------------------

loc_2EB8A:
                ori.b   #4,render_flags(a0)
                move.w  #$300,priority(a0)
                move.l  #Map_HCZWaterWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZGeyser,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$60,height_pixels(a0)
                move.w  #$60,$30(a0)
                move.b  #$1C,(Player_1+anim).w
                move.b  #$1C,(Player_2+anim).w
                move.l  #loc_2EBC8,(a0)

loc_2EBC8:
                tst.w   $30(a0)
                beq.s   loc_2EBD6
                subq.w  #1,$30(a0)
                subq.w  #8,y_pos(a0)

loc_2EBD6:
                subi.w  #8,(Player_1+y_pos).w
                subi.w  #8,(Player_2+y_pos).w
                cmpi.w  #$28,$30(a0)
                bhi.w   locret_2EC78
                move.b  #$1A,(Player_1+anim).w
                move.b  #$1A,(Player_2+anim).w
                move.l  #loc_2ECAA,(a0)
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                move.b  #1,(Palette_cycle_counters+$00).w
                lea     (byte_2EC7A).l,a3
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$80,d3
                moveq   #8-1,d1

loc_2EC20:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_2EC78
                move.l  #loc_2E9AA,(a1)
                move.l  #Map_HCZWaterWallDebris,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZGeyser+$58,2,0),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  #$280,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.w  (a3)+,x_vel(a1)
                move.w  (a3)+,y_vel(a1)
                move.b  d1,mapping_frame(a1)
                dbf     d1,loc_2EC20

locret_2EC78:
                rts
; ---------------------------------------------------------------------------
byte_2EC7A:
                dc.b    -$18,   0
                dc.w    -$200, -$B00
                dc.b    -8,   0
                dc.w    -$100, -$C00
                dc.b    -$18,   0
                dc.w    -$400, -$800
                dc.b    -8,   0
                dc.w    -$300, -$A00
                dc.b    8,   0
                dc.w    $300, -$C00
                dc.b    $18,   0
                dc.w    $400, -$B00
                dc.b    8,   0
                dc.w    $100, -$A00
                dc.b    $18,   0
                dc.w    $200, -$800
; ---------------------------------------------------------------------------

loc_2ECAA:
                tst.w   $30(a0)
                beq.s   loc_2ED00
                move.w  #-$A00,y_vel(a0)
                subq.w  #1,$30(a0)
                bne.s   loc_2ED00
                move.l  #loc_2EDBA,(a0)
                lea     (Player_1).w,a1
                move.b  #0,object_control(a1)
                move.w  #0,x_vel(a1)
                move.w  #-$C00,y_vel(a1)
                move.b  #0,jumping(a1)
                lea     (Player_2).w,a1
                move.b  #0,object_control(a1)
                move.w  #0,x_vel(a1)
                move.w  #-$C00,y_vel(a1)
                move.b  #0,jumping(a1)
                move.w  #-$800,y_vel(a0)

loc_2ED00:
                subi.w  #$A,(Player_1+y_pos).w
                subi.w  #$A,(Player_2+y_pos).w
                jsr     (MoveSprite2).l
                addi.w  #$48,y_vel(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2ED64
                jsr     (Random_Number).l
                move.w  d0,d1
                move.w  d0,d2
                bsr.s   sub_2ED6A
                addi.w  #$10,x_pos(a1)
                andi.w  #$F,d1
                lsl.w   #6,d1
                move.w  d1,x_vel(a1)
                move.w  #-$700,y_vel(a1)
                move.w  d0,d2
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2ED64
                bsr.s   sub_2ED6A
                subi.w  #$10,x_pos(a1)
                neg.w   d1
                move.w  d1,x_vel(a1)
                move.w  #-$700,y_vel(a1)

loc_2ED64:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_2ED6A:
                move.l  #loc_2EA6E,(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  #$84,render_flags(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subi.w  #$50,y_pos(a1)
                move.w  #$380,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.w  #make_art_tile(ArtTile_HCZGeyser+$30,2,0),art_tile(a1)
                lsr.w   #4,d2
                andi.w  #3,d2
                bne.s   loc_2EDB4
                move.w  #make_art_tile(ArtTile_Bubbles,0,0),art_tile(a1)

loc_2EDB4:
                move.b  d2,anim(a1)
                rts
; End of function sub_2ED6A

; ---------------------------------------------------------------------------

loc_2EDBA:
                tst.b   render_flags(a0)
                bmi.s   loc_2EDFE
                move.w  #signextendB(cmd_StopSFX),d0
                jsr     (Play_SFX).l
                move.w  #signextendB(cmd_MutePSG),d0
                jsr     (Play_SFX).l                    ; this will actually never play... Why is any of this here?
                move.w  #signextendB(cmd_StopSFX),d0
                jsr     (Play_SFX).l
                move.b  #0,(Palette_cycle_counters+$00).w
                move.w  respawn_addr(a0),d0
                beq.s   loc_2EDF0
                movea.w d0,a2
                bclr    #7,(a2)

loc_2EDF0:
                move.w  #$1E,$30(a0)
                move.l  #loc_2E996,(a0)
                rts
; ---------------------------------------------------------------------------

loc_2EDFE:
                jsr     (MoveSprite2).l
                addi.w  #$48,y_vel(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_HCZWaterWall:
                include "src/objects/shared/zones/hcz/map_waterfall.s"
Map_HCZWaterWallDebris:
                include "src/objects/shared/zones/hcz/map_water_wall_debris.s"
; End of function loc_2EDBA
