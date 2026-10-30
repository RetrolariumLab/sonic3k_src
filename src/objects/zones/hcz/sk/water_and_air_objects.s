; Owner: objects/zones/hcz/sk
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
                dc.w    loc_2F952-Bubbler_Index
                dc.w    loc_2F9B0-Bubbler_Index
                dc.w    loc_2F9CA-Bubbler_Index
                dc.w    loc_2FA2C-Bubbler_Index
                dc.w    loc_2FA4A-Bubbler_Index
                dc.w    loc_2FA50-Bubbler_Index
; ---------------------------------------------------------------------------

loc_2F952:
                addq.b  #2,routine(a0)
                move.l  #Map_Bubbler,mappings(a0)
                move.w  #make_art_tile(ArtTile_Bubbles,0,0),art_tile(a0)
                move.b  #$84,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  subtype(a0),d0
                bpl.s   loc_2F996
                addq.b  #8,routine(a0)
                andi.w  #$7F,d0
                move.b  d0,$32(a0)
                move.b  d0,$33(a0)
                move.b  #8,anim(a0)
                bra.w   loc_2FA50
; ---------------------------------------------------------------------------

loc_2F996:
                move.b  d0,anim(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  #-$88,y_vel(a0)
                jsr     (Random_Number).l
                move.b  d0,angle(a0)

loc_2F9B0:
                lea     (Ani_Bubbler).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #6,mapping_frame(a0)
                bne.s   loc_2F9CA
                move.b  #1,$2E(a0)

loc_2F9CA:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_2F9E2
                move.b  #6,routine(a0)
                addq.b  #4,anim(a0)
                bra.w   loc_2FA2C
; ---------------------------------------------------------------------------

loc_2F9E2:
                move.b  angle(a0),d0
                addq.b  #1,angle(a0)
                andi.w  #$7F,d0
                lea     (AirCountdown_WobbleData).l,a1
                move.b  (a1,d0.w),d0
                ext.w   d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                tst.b   $2E(a0)
                beq.s   loc_2FA14
                bsr.w   sub_2FBA8
                cmpi.b  #6,routine(a0)
                beq.s   loc_2FA2C

loc_2FA14:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bpl.s   loc_2FA26
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2FA26:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2FA2C:
                lea     (Ani_Bubbler).l,a1
                jsr     (Animate_Sprite).l
                tst.b   render_flags(a0)
                bpl.s   loc_2FA44
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2FA44:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2FA4A:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2FA50:
                tst.w   $36(a0)
                bne.s   loc_2FAB2
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bhs.w   loc_2FB5C
                tst.b   render_flags(a0)
                bpl.w   loc_2FB5C
                subq.w  #1,$38(a0)
                bpl.w   loc_2FB50
                move.w  #1,$36(a0)

loc_2FA78:
                jsr     (Random_Number).l
                move.w  d0,d1
                andi.w  #7,d0
                cmpi.w  #6,d0
                bhs.s   loc_2FA78
                move.b  d0,$34(a0)
                andi.w  #$C,d1
                lea     (byte_2FB96).l,a1
                adda.w  d1,a1
                move.l  a1,$3C(a0)
                subq.b  #1,$32(a0)
                bpl.s   loc_2FAB0
                move.b  $33(a0),$32(a0)
                bset    #7,$36(a0)

loc_2FAB0:
                bra.s   loc_2FABA
; ---------------------------------------------------------------------------

loc_2FAB2:
                subq.w  #1,$38(a0)
                bpl.w   loc_2FB50

loc_2FABA:
                jsr     (Random_Number).l
                andi.w  #$1F,d0
                move.w  d0,$38(a0)
                jsr     (AllocateObject).l
                bne.s   loc_2FB34
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
                beq.s   loc_2FB34
                jsr     (Random_Number).l
                andi.w  #3,d0
                bne.s   loc_2FB20
                bset    #6,$36(a0)
                bne.s   loc_2FB34
                move.b  #2,subtype(a1)

loc_2FB20:
                tst.b   $34(a0)
                bne.s   loc_2FB34
                bset    #6,$36(a0)
                bne.s   loc_2FB34
                move.b  #2,subtype(a1)

loc_2FB34:
                subq.b  #1,$34(a0)
                bpl.s   loc_2FB50
                jsr     (Random_Number).l
                andi.w  #$7F,d0
                addi.w  #$80,d0
                add.w   d0,$38(a0)
                clr.w   $36(a0)

loc_2FB50:
                lea     (Ani_Bubbler).l,a1
                jsr     (Animate_Sprite).l

loc_2FB5C:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_2FB7E
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                blo.w   loc_2FB90
                rts
; ---------------------------------------------------------------------------

loc_2FB7E:
                move.w  respawn_addr(a0),d0
                beq.s   loc_2FB8A
                movea.w d0,a2
                bclr    #7,(a2)

loc_2FB8A:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2FB90:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
byte_2FB96:
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

sub_2FBA8:
                lea     (Player_1).w,a1
                bsr.s   loc_2FBB2
                lea     (Player_2).w,a1
; End of function sub_2FBA8

loc_2FBB2:
                tst.b   object_control(a1)
                bmi.w   locret_2FC7C
                move.w  x_pos(a1),d0
                move.w  x_pos(a0),d1
                subi.w  #$10,d1
                cmp.w   d0,d1
                bhs.w   locret_2FC7C
                addi.w  #2*$10,d1
                cmp.w   d0,d1
                blo.w   locret_2FC7C
                move.w  y_pos(a1),d0
                move.w  y_pos(a0),d1
                cmp.w   d0,d1
                bhs.w   locret_2FC7C
                addi.w  #$10,d1
                cmp.w   d0,d1
                blo.w   locret_2FC7C
                btst    #Status_BublShield,status_secondary(a1)
                bne.w   locret_2FC7C
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
                beq.w   loc_2FC6A
                cmpi.l  #Obj_Sonic,(a1)
                bne.s   loc_2FC5A
                bclr    #Status_Roll,status(a1)
                move.b  #$13,y_radius(a1)
                move.b  #9,x_radius(a1)
                subq.w  #5,y_pos(a1)
                bra.s   loc_2FC6A
; ---------------------------------------------------------------------------

loc_2FC5A:
                move.b  #$F,y_radius(a1)
                move.b  #9,x_radius(a1)
                subq.w  #1,y_pos(a1)

loc_2FC6A:
                cmpi.b  #6,routine(a0)
                beq.s   locret_2FC7C
                move.b  #6,routine(a0)
                addq.b  #4,anim(a0)

locret_2FC7C:
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
                bne.w   loc_2FE28
                move.l  #loc_2FEB2,(a1)
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

loc_2FE28:
                move.b  #3,(_unkF7C7).w
                move.l  #loc_2FE34,(a0)

loc_2FE34:
                tst.b   (Level_trigger_array).w
                beq.s   loc_2FE58
                move.b  #3,mapping_frame(a0)
                move.b  #1,anim_frame_timer(a0)
                move.l  #loc_2FE5E,(a0)
                move.b  #0,(_unkF7C7).w
                move.b  #1,(Palette_cycle_counters+$00).w

loc_2FE58:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2FE5E:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_2FE9E
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #2,mapping_frame(a0)
                bne.s   loc_2FE98
                addi.w  #$20,x_pos(a0)
                cmpi.w  #$580,x_pos(a0)
                bne.s   loc_2FE98
                cmpi.w  #$5A0,y_pos(a0)
                bne.s   loc_2FE98
                subi.w  #$20,x_pos(a0)
                subi.w  #$20,y_pos(a0)

loc_2FE98:
                andi.b  #1,mapping_frame(a0)

loc_2FE9E:
                cmpi.w  #$980,x_pos(a0)
                blo.s   loc_2FEAC
                move.w  #$7F00,x_pos(a0)

loc_2FEAC:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2FEB2:
                tst.b   (Level_trigger_array).w
                beq.s   loc_2FED2
                move.l  #loc_2FEBE,(a0)

loc_2FEBE:
                subi.w  #$10,y_pos(a0)
                cmpi.w  #$560,y_pos(a0)
                bne.s   loc_2FED2
                move.w  #$7F00,x_pos(a0)

loc_2FED2:
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

Obj_HCZWaterWall:
                tst.b   subtype(a0)
                beq.s   loc_2FF04
                move.l  #loc_30294,(a0)
                rts
; ---------------------------------------------------------------------------

loc_2FF04:
                move.w  (Player_1+y_pos).w,d0
                cmpi.w  #$500,d0
                bhs.s   loc_2FF14
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2FF14:
                lea     (ArtKosM_HCZGeyserHorz).l,a1
                move.w  #tiles_to_bytes(ArtTile_HCZGeyser),d2
                jsr     (Queue_Kos_Module).l
                move.l  #loc_2FF2A,(a0)

loc_2FF2A:
                tst.b   (Kos_modules_left).w
                beq.s   loc_2FF32
                rts
; ---------------------------------------------------------------------------

loc_2FF32:
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
                move.l  #loc_2FF7C,(a0)

loc_2FF7C:
                move.w  (Player_1+x_pos).w,d0
                subi.w  #$60,d0
                cmp.w   x_pos(a0),d0
                blo.w   loc_30006
                move.l  #loc_3003C,(a0)
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                lea     (byte_3000C).l,a3
                move.w  x_pos(a0),d2
                addi.w  #$60,d2
                move.w  y_pos(a0),d3
                moveq   #8-1,d1

loc_2FFAE:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_30006
                move.l  #loc_3011A,(a1)
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
                dbf     d1,loc_2FFAE

loc_30006:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
byte_3000C:
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

loc_3003C:
                tst.w   $30(a0)
                beq.s   loc_3004A
                subq.w  #1,$30(a0)
                addq.w  #8,x_pos(a0)

loc_3004A:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_300C8
                move.l  #loc_301DE,(a1)
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
                bne.s   loc_300A6
                move.w  #make_art_tile(ArtTile_Bubbles,0,0),art_tile(a1)

loc_300A6:
                move.b  d1,anim(a1)
                move.w  #$380,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.w  #$400,x_vel(a1)
                move.w  #0,y_vel(a1)

loc_300C8:
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                tst.b   render_flags(a0)
                bmi.s   loc_30100
                clr.b   (Palette_cycle_counters+$00).w
                move.w  #signextendB(cmd_MutePSG),d0
                jsr     (Play_SFX).l
                move.w  #signextendB(cmd_StopSFX),d0
                jsr     (Play_SFX).l
                move.w  #150,$30(a0)
                move.l  #loc_30106,(a0)
                rts
; ---------------------------------------------------------------------------

loc_30100:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_30106:
                subq.w  #1,$30(a0)
                bmi.s   loc_3010E
                rts
; ---------------------------------------------------------------------------

loc_3010E:
                jsr     (LoadEnemyArt).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3011A:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_30130
                move.b  #2,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #7,mapping_frame(a0)

loc_30130:
                jsr     (MoveSprite2).l
                addi.w  #$38,y_vel(a0)
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_301A2
                move.w  #0,y_vel(a0)
                asr     x_vel(a0)
                asr     x_vel(a0)
                move.l  #loc_301A8,(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_301A2
                move.l  #loc_3023E,(a1)
                move.l  #Map_HCZWaterWall,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZGeyser+$30,1,0),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  (Water_level).w,y_pos(a1)
                move.w  #$200,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.b  #8,anim(a1)

loc_301A2:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_301A8:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_301BE
                move.b  #9,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #7,mapping_frame(a0)

loc_301BE:
                jsr     (MoveSprite2).l
                addi.w  #8,y_vel(a0)
                tst.b   render_flags(a0)
                bpl.w   loc_301D8
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_301D8:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_301DE:
                jsr     (MoveSprite2).l
                addi.w  #$28,y_vel(a0)
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_30202
                move.w  d0,y_pos(a0)
                move.l  #loc_3021C,(a0)
                addq.b  #4,anim(a0)

loc_30202:
                tst.b   render_flags(a0)
                bpl.w   loc_301D8
                lea     (Ani_HCZWaterWall).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_3021C:
                tst.b   render_flags(a0)
                bpl.w   loc_301D8
                lea     (Ani_HCZWaterWall).l,a1
                jsr     (Animate_Sprite).l
                tst.b   routine(a0)
                bne.w   loc_301D8
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_3023E:
                tst.b   render_flags(a0)
                bpl.w   loc_301D8
                lea     (Ani_HCZWaterWall).l,a1
                jsr     (Animate_SpriteIrregularDelay).l
                tst.b   routine(a0)
                bne.w   loc_301D8
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_HCZWaterWall:
                include "src/objects/shared/zones/hcz/anim_water_wall.s"
; ---------------------------------------------------------------------------

loc_30294:
                move.w  (Player_1+x_pos).w,d0
                addi.w  #$30,d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$60,d0
                bhs.s   loc_302B8
                move.w  (Player_1+y_pos).w,d0
                addi.w  #$40,d0
                sub.w   y_pos(a0),d0
                cmpi.w  #$10,d0
                blo.s   loc_302BE

loc_302B8:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_302BE:
                lea     (ArtKosM_HCZGeyserVert).l,a1
                move.w  #tiles_to_bytes(ArtTile_HCZGeyser),d2
                jsr     (Queue_Kos_Module).l
                move.b  #1,mapping_frame(a0)
                move.b  #$81,(Player_1+object_control).w
                move.b  #$81,(Player_2+object_control).w
                move.l  #loc_302E6,(a0)

loc_302E6:
                tst.b   (Kos_modules_left).w
                beq.s   loc_302FA
                subi.w  #8,(Player_1+y_pos).w
                subi.w  #8,(Player_2+y_pos).w
                rts
; ---------------------------------------------------------------------------

loc_302FA:
                ori.b   #4,render_flags(a0)
                move.w  #$300,priority(a0)
                move.l  #Map_HCZWaterWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZGeyser,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$60,height_pixels(a0)
                move.w  #$60,$30(a0)
                move.b  #$1C,(Player_1+anim).w
                move.b  #$1C,(Player_2+anim).w
                move.l  #loc_30338,(a0)

loc_30338:
                tst.w   $30(a0)
                beq.s   loc_30346
                subq.w  #1,$30(a0)
                subq.w  #8,y_pos(a0)

loc_30346:
                subi.w  #8,(Player_1+y_pos).w
                subi.w  #8,(Player_2+y_pos).w
                cmpi.w  #$28,$30(a0)
                bhi.w   locret_303E8
                move.b  #$1A,(Player_1+anim).w
                move.b  #$1A,(Player_2+anim).w
                move.l  #loc_3041A,(a0)
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                move.b  #1,(Palette_cycle_counters+$00).w
                lea     (byte_303EA).l,a3
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$80,d3
                moveq   #8-1,d1

loc_30390:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_303E8
                move.l  #loc_3011A,(a1)
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
                dbf     d1,loc_30390

locret_303E8:
                rts
; ---------------------------------------------------------------------------
byte_303EA:
                dc.b    -$18,   0
                dc.w    -$200, -$B00
                dc.b    -8,   0
                dc.w    -$100, -$C00
                dc.b    -$18,  0
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

loc_3041A:
                tst.w   $30(a0)
                beq.s   loc_30470
                move.w  #-$A00,y_vel(a0)
                subq.w  #1,$30(a0)
                bne.s   loc_30470
                move.l  #loc_3052A,(a0)
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

loc_30470:
                subi.w  #$A,(Player_1+y_pos).w
                subi.w  #$A,(Player_2+y_pos).w
                jsr     (MoveSprite2).l
                addi.w  #$48,y_vel(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_304D4
                jsr     (Random_Number).l
                move.w  d0,d1
                move.w  d0,d2
                bsr.s   sub_304DA
                addi.w  #$10,x_pos(a1)
                andi.w  #$F,d1
                lsl.w   #6,d1
                move.w  d1,x_vel(a1)
                move.w  #-$700,y_vel(a1)
                move.w  d0,d2
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_304D4
                bsr.s   sub_304DA
                subi.w  #$10,x_pos(a1)
                neg.w   d1
                move.w  d1,x_vel(a1)
                move.w  #-$700,y_vel(a1)

loc_304D4:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_304DA:
                move.l  #loc_301DE,(a1)
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
                bne.s   loc_30524
                move.w  #make_art_tile(ArtTile_Bubbles,0,0),art_tile(a1)

loc_30524:
                move.b  d2,anim(a1)
                rts
; End of function sub_304DA

; ---------------------------------------------------------------------------

loc_3052A:
                tst.b   render_flags(a0)
                bmi.s   loc_3056E
                move.w  #signextendB(cmd_StopSFX),d0
                jsr     (Play_SFX).l
                move.w  #signextendB(cmd_MutePSG),d0
                jsr     (Play_SFX).l                    ; this will actually never play... Why is any of this here?
                move.w  #signextendB(cmd_StopSFX),d0
                jsr     (Play_SFX).l
                move.b  #0,(Palette_cycle_counters+$00).w
                move.w  respawn_addr(a0),d0
                beq.s   loc_30560
                movea.w d0,a2
                bclr    #7,(a2)

loc_30560:
                move.w  #$1E,$30(a0)
                move.l  #loc_30106,(a0)
                rts
; ---------------------------------------------------------------------------

loc_3056E:
                jsr     (MoveSprite2).l
                addi.w  #$48,y_vel(a0)
                jmp     (Sprite_OnScreen_Test).l
; End of function loc_3052A
