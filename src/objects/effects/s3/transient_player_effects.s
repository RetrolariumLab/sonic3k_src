; Owner: objects/effects/s3
; Responsibility: Short-lived dash, splash and drowning particles, transformation stars and instant-shield attack display
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DashDust:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DashDust_Index(pc,d0.w),d1
                jmp     DashDust_Index(pc,d1.w)
; ---------------------------------------------------------------------------
DashDust_Index:
                dc.w    loc_178D4-DashDust_Index
                dc.w    loc_1792A-DashDust_Index
                dc.w    loc_17A1C-DashDust_Index
                dc.w    loc_17A20-DashDust_Index
; ---------------------------------------------------------------------------

loc_178D4:
                addq.b  #2,routine(a0)
                move.l  #Map_DashDust,mappings(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #make_art_tile(ArtTile_DashDust,0,0),art_tile(a0)
                move.w  #Player_1,parent(a0)
                move.w  #tiles_to_bytes(ArtTile_DashDust),vram_art(a0)
                cmpa.w  #Dust,a0
                beq.s   loc_1792A
                move.b  #1,$38(a0)
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_1792A
                move.w  #make_art_tile(ArtTile_DashDust_P2,0,0),art_tile(a0)
                move.w  #Player_2,parent(a0)
                move.w  #tiles_to_bytes(ArtTile_DashDust_P2),vram_art(a0)

loc_1792A:
                movea.w parent(a0),a2
                moveq   #0,d0
                move.b  anim(a0),d0
                add.w   d0,d0
                move.w  off_1793E(pc,d0.w),d1
                jmp     off_1793E(pc,d1.w)
; ---------------------------------------------------------------------------
off_1793E:
                dc.w    loc_179FE-off_1793E
                dc.w    loc_17948-off_1793E
                dc.w    loc_179A0-off_1793E
                dc.w    loc_179F6-off_1793E
                dc.w    loc_1796C-off_1793E
; ---------------------------------------------------------------------------

loc_17948:
                move.w  (Water_level).w,y_pos(a0)
                tst.b   prev_anim(a0)
                bne.w   loc_179FE
                move.w  x_pos(a2),x_pos(a0)
                move.b  #0,status(a0)
                andi.w  #drawing_mask,art_tile(a0)
                bra.w   loc_179FE
; ---------------------------------------------------------------------------

loc_1796C:
                tst.b   prev_anim(a0)
                bne.s   loc_17984
                move.w  x_pos(a2),x_pos(a0)
                move.b  #0,status(a0)
                andi.w  #drawing_mask,art_tile(a0)

loc_17984:
                lea     (Ani_DashSplashDrown).l,a1
                jsr     (Animate_Sprite).l
                move.l  #ArtUnc_SplashDrown,d6
                bsr.w   SplashDrown_Load_DPLC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_179A0:
                cmpi.b  #12,air_left(a2)
                blo.w   loc_17A14
                cmpi.b  #4,routine(a2)
                bhs.s   loc_17A14
                tst.b   spin_dash_flag(a2)
                beq.s   loc_17A14
                move.w  x_pos(a2),x_pos(a0)
                move.w  y_pos(a2),y_pos(a0)
                move.b  status(a2),status(a0)
                andi.b  #1,status(a0)
                tst.b   $38(a0)
                beq.s   loc_179DC
                subi.w  #4,y_pos(a0)

loc_179DC:
                tst.b   prev_anim(a0)
                bne.s   loc_179FE
                andi.w  #drawing_mask,art_tile(a0)
                tst.w   art_tile(a2)
                bpl.s   loc_179FE
                ori.w   #high_priority,art_tile(a0)
                bra.s   loc_179FE
; ---------------------------------------------------------------------------

loc_179F6:
                cmpi.b  #12,air_left(a2)
                blo.s   loc_17A14

loc_179FE:
                lea     (Ani_DashSplashDrown).l,a1
                jsr     (Animate_Sprite).l
                bsr.w   DashDust_Load_DPLC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_17A14:
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_17A1C:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

loc_17A20:
                movea.w parent(a0),a2
                cmpi.b  #$D,anim(a2)
                beq.s   loc_17A3A
                move.b  #2,routine(a0)
                move.b  #0,$36(a0)
                rts
; ---------------------------------------------------------------------------

loc_17A3A:
                subq.b  #1,$36(a0)
                bpl.s   loc_17AB2
                move.b  #3,$36(a0)
                bsr.w   AllocateObject
                bne.s   loc_17AB2
                move.l  (a0),(a1)
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                addi.w  #$10,y_pos(a1)
                tst.b   $38(a0)
                beq.s   loc_17A6C
                subi.w  #4,y_pos(a1)

loc_17A6C:
                move.b  #0,status(a1)
                move.b  #3,anim(a1)
                addq.b  #2,routine(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.w  #$80,priority(a1)
                move.b  #4,width_pixels(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  parent(a0),parent(a1)
                andi.w  #drawing_mask,art_tile(a1)
                tst.w   art_tile(a2)
                bpl.s   loc_17AB2
                ori.w   #high_priority,art_tile(a1)

loc_17AB2:
                bsr.s   DashDust_Load_DPLC
                rts

; =============== S U B R O U T I N E =======================================

DashDust_Load_DPLC:
                move.l  #ArtUnc_DashDust,d6

SplashDrown_Load_DPLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmp.b   $34(a0),d0
                beq.s   locret_17B0A
                move.b  d0,$34(a0)
                lea     (DPLC_DashSplashDrown).l,a2
                add.w   d0,d0
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,d5
                subq.w  #1,d5
                bmi.s   locret_17B0A
                move.w  vram_art(a0),d4

loc_17AE2:
                moveq   #0,d1
                move.w  (a2)+,d1
                move.w  d1,d3
                lsr.w   #8,d3
                andi.w  #$F0,d3
                addi.w  #$10,d3
                andi.w  #$FFF,d1
                lsl.l   #5,d1
                add.l   d6,d1
                move.w  d4,d2
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l
                dbf     d5,loc_17AE2

locret_17B0A:
                rts
; End of function DashDust_Load_DPLC

; ---------------------------------------------------------------------------
Ani_DashSplashDrown:
                include "src/objects/shared/dash_dust/animations/dash_dust.s"
Map_DashDust:
                include "src/objects/shared/dash_dust/mappings/dash_dust.s"
DPLC_DashSplashDrown:
                include "src/objects/shared/dash_dust/dplc/dash_dust.s"
; ---------------------------------------------------------------------------

Obj_DashDust2P:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DashDust2P_Index(pc,d0.w),d1
                jmp     DashDust2P_Index(pc,d1.w)
; ---------------------------------------------------------------------------
DashDust2P_Index:
                dc.w    loc_17CE8-DashDust2P_Index
                dc.w    loc_17D1E-DashDust2P_Index
                dc.w    loc_17DAC-DashDust2P_Index
                dc.w    loc_17DB0-DashDust2P_Index
; ---------------------------------------------------------------------------

loc_17CE8:
                addq.b  #2,routine(a0)
                move.l  #Map_DashDust2P,mappings(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #make_art_tile(ArtTile_DashDust,0,0),art_tile(a0)
                move.w  #Player_1,parent(a0)
                cmpa.w  #Dust,a0
                beq.s   loc_17D1E
                move.w  #Player_2,parent(a0)

loc_17D1E:
                movea.w parent(a0),a2
                moveq   #0,d0
                move.b  anim(a0),d0
                add.w   d0,d0
                move.w  off_17D32(pc,d0.w),d1
                jmp     off_17D32(pc,d1.w)
; ---------------------------------------------------------------------------
off_17D32:
                dc.w    loc_17D3A-off_17D32
                dc.w    loc_17D3A-off_17D32
                dc.w    loc_17D42-off_17D32
                dc.w    loc_17D8A-off_17D32
; ---------------------------------------------------------------------------

loc_17D3A:
                move.b  #0,mapping_frame(a0)
                bra.s   loc_17D92
; ---------------------------------------------------------------------------

loc_17D42:
                cmpi.b  #12,air_left(a2)
                blo.s   loc_17DA4
                cmpi.b  #4,routine(a2)
                bhs.s   loc_17DA4
                tst.b   spin_dash_flag(a2)
                beq.s   loc_17DA4
                move.w  x_pos(a2),x_pos(a0)
                move.w  y_pos(a2),y_pos(a0)
                move.b  status(a2),status(a0)
                andi.b  #1,status(a0)
                tst.b   prev_anim(a0)
                bne.s   loc_17D92
                andi.w  #drawing_mask,art_tile(a0)
                tst.w   art_tile(a2)
                bpl.s   loc_17D92
                ori.w   #high_priority,art_tile(a0)
                bra.s   loc_17D92
; ---------------------------------------------------------------------------

loc_17D8A:
                cmpi.b  #12,air_left(a2)
                blo.s   loc_17DA4

loc_17D92:
                lea     (Ani_DashDust2P).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_17DA4:
                move.b  #0,anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_17DAC:
                bra.w   Delete_Current_Sprite
; ---------------------------------------------------------------------------

loc_17DB0:
                movea.w parent(a0),a2
                cmpi.b  #$D,anim(a2)
                beq.s   loc_17DCA
                move.b  #2,routine(a0)
                move.b  #0,$36(a0)
                rts
; ---------------------------------------------------------------------------

loc_17DCA:
                move.b  #0,mapping_frame(a0)
                subq.b  #1,$36(a0)
                bpl.s   locret_17E3C
                move.b  #3,$36(a0)
                bsr.w   AllocateObject
                bne.s   locret_17E3C
                move.l  (a0),(a1)
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                addi.w  #$C,y_pos(a1)
                move.b  #0,status(a1)
                move.b  #3,anim(a1)
                addq.b  #2,routine(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.w  #$80,priority(a1)
                move.b  #4,width_pixels(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  parent(a0),parent(a1)
                andi.w  #drawing_mask,art_tile(a1)
                tst.w   art_tile(a2)
                bpl.s   locret_17E3C
                ori.w   #high_priority,art_tile(a1)

locret_17E3C:
                rts
; ---------------------------------------------------------------------------
Ani_DashDust2P:
                include "src/objects/shared/dash_dust/animations/competition.s"
Map_DashDust2P:
                include "src/objects/shared/dash_dust/mappings/competition.s"
; ---------------------------------------------------------------------------

Obj_SuperSonic_Stars:
                move.l  #ArtUnc_SuperSonic_Stars,d1
                move.w  #tiles_to_bytes(ArtTile_Shield),d2
                move.w  #$1A0,d3
                jsr     (Add_To_DMA_Queue).l
                move.l  #Map_SuperSonic_Stars,mappings(a0)
                move.b  #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #make_art_tile(ArtTile_Shield,0,0),art_tile(a0)
                btst    #7,(Player_1+art_tile).w
                beq.s   loc_17EEA
                bset    #7,art_tile(a0)

loc_17EEA:
                move.l  #loc_17EF0,(a0)

loc_17EF0:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.w   loc_17F7C
                tst.b   anim(a0)
                beq.s   loc_17F02
                bsr.w   SuperStarBurstS3SpawnSixteenMirroredRadialParticles

loc_17F02:
                tst.b   $34(a0)
                beq.s   loc_17F4C
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_17F34
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #6,mapping_frame(a0)
                blo.s   loc_17F34
                move.b  #0,mapping_frame(a0)
                move.b  #0,$34(a0)
                move.b  #1,$35(a0)
                rts
; ---------------------------------------------------------------------------

loc_17F34:
                tst.b   $35(a0)
                bne.s   loc_17F46

loc_17F3A:
                move.w  (Player_1+x_pos).w,x_pos(a0)
                move.w  (Player_1+y_pos).w,y_pos(a0)

loc_17F46:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_17F4C:
                tst.b   (Player_1+object_control).w
                bne.s   loc_17F6E
                move.w  (Player_1+ground_vel).w,d0
                bpl.s   loc_17F5A
                neg.w   d0

loc_17F5A:
                cmpi.w  #$800,d0
                blo.s   loc_17F6E
                move.b  #0,mapping_frame(a0)
                move.b  #1,$34(a0)
                bra.s   loc_17F3A
; ---------------------------------------------------------------------------

loc_17F6E:
                move.b  #0,$34(a0)
                move.b  #0,$35(a0)
                rts
; ---------------------------------------------------------------------------

loc_17F7C:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

SuperStarBurstS3SpawnSixteenMirroredRadialParticles:
                move.b  #0,anim(a0)
                lea     (Player_1).w,a2
                moveq   #$10-1,d5
                move.w  #$488,d4

loc_17F92:
                bsr.w   AllocateObject
                bne.w   locret_1800A
                move.l  #Obj_SuperSonic_Stars_Timer,(a1)
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                move.l  #Map_SuperSonic_Stars2,mappings(a1)
                move.w  #make_art_tile(ArtTile_Shield,0,1),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.w  #$380,priority(a1)
                move.b  #8,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                tst.w   d4
                bmi.s   loc_17FFA
                move.w  d4,d0
                jsr     (GetSineCosine).l
                move.w  d4,d2
                lsr.w   #8,d2
                asl.w   d2,d0
                asl.w   d2,d1
                move.w  d0,d2
                move.w  d1,d3
                addi.b  #$10,d4
                bcc.s   loc_17FFA
                subi.w  #$80,d4
                bcc.s   loc_17FFA
                move.w  #$488,d4

loc_17FFA:
                move.w  d2,x_vel(a1)
                move.w  d3,y_vel(a1)
                neg.w   d2
                neg.w   d4
                dbf     d5,loc_17F92

locret_1800A:
                rts
; End of function SuperStarBurstS3SpawnSixteenMirroredRadialParticles

; ---------------------------------------------------------------------------

Obj_SuperSonic_Stars_Timer:
                tst.b   render_flags(a0)
                bmi.s   loc_18018
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_18018:
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)
                bsr.w   MoveSprite2
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------
Map_SuperSonic_Stars:
                include "src/objects/shared/shields/mappings/super_sonic_stars.s"
; ---------------------------------------------------------------------------

Obj_InstaShield:
; Init
                move.l  #Map_InstaShield,mappings(a0)
                move.l  #DPLC_InstaShield,shield_plc(a0)  ; Used by PLCLoad_Shields
                move.l  #ArtUnc_InstaShield,shield_art(a0)  ; Used by PLCLoad_Shields
                move.b  #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #make_art_tile(ArtTile_Shield,0,0),art_tile(a0)
                move.w  #tiles_to_bytes(ArtTile_Shield),vram_art(a0)  ; Used by PLCLoad_Shields
                btst    #7,(Player_1+art_tile).w
                beq.s   .nothighpriority
                bset    #7,art_tile(a0)

                .nothighpriority:
                move.w  #1,anim(a0)                     ; Clear anim and set prev_anim to 1
                move.b  #-1,shield_prev_frame(a0)       ; Reset shield_prev_frame (used by PLCLoad_Shields)
                move.l  #Obj_InstaShield_Main,(a0)

Obj_InstaShield_Main:
                movea.w parent(a0),a2
                btst    #Status_Invincible,status_secondary(a2)  ; Is the player invincible?
                bne.s   locret_18158                    ; If so, return
                move.w  x_pos(a2),x_pos(a0)             ; Inherit player's x_pos
                move.w  y_pos(a2),y_pos(a0)             ; Inherit player's y_pos
                move.b  status(a2),status(a0)           ; Inherit status
                andi.b  #1,status(a0)                   ; Limit inheritance to 'orientation' bit
                andi.w  #drawing_mask,art_tile(a0)
                tst.w   art_tile(a2)
                bpl.s   .nothighpriority
                ori.w   #high_priority,art_tile(a0)

                .nothighpriority:
                lea     (Ani_InstaShield).l,a1
                jsr     (Animate_Sprite).l
                cmpi.b  #7,mapping_frame(a0)            ; Has it reached then end of its animation?
                bne.s   .notover                        ; If not, branch
                move.b  #2,double_jump_flag(a2)         ; Mark attack as over

                .notover:
                tst.b   mapping_frame(a0)               ; Is this the first frame?
                beq.s   .loadnewDPLC                    ; If so, branch and load the DPLC for this and the next few frames
                cmpi.b  #3,mapping_frame(a0)            ; Is this the third frame?
                bne.s   .skipDPLC                       ; If not, branch as we don't need to load another DPLC yet

                .loadnewDPLC:
                bsr.w   PLCLoad_Shields

                .skipDPLC:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_18158:
                rts
