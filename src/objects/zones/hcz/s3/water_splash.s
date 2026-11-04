; Owner: objects/zones/hcz/s3
; Responsibility: Hydrocity splash emission, particle motion, player contact and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZWaterSplash:
                tst.b   subtype(a0)
                beq.s   S3WaterSplash_InitOrdinarySplash
                move.l  #Map_HCZWaterSplash2,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZ2WaterSplash2,0,0),art_tile(a0)
                tst.b   (Current_act).w
                beq.s   S3WaterSplash_InitSkimmingSplash
                move.w  #make_art_tile(ArtTile_HCZ1WaterSplash2,0,0),art_tile(a0)

S3WaterSplash_InitSkimmingSplash:
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
                move.l  #S3WaterSplash_TrackP1AndUpdateSkimmers,(a0)
                bra.w   S3WaterSplash_TrackP1AndUpdateSkimmers
; ---------------------------------------------------------------------------

S3WaterSplash_InitOrdinarySplash:
                move.l  #Map_HCZWaterSplash,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZWaterSplash,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$300,priority(a0)
                move.b  #$28,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #-1,$30(a0)
                move.l  #S3WaterSplash_StepOrdinaryFrames,(a0)

S3WaterSplash_StepOrdinaryFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3WaterSplash_TryUploadOrdinaryArt
                move.b  #7,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

S3WaterSplash_TryUploadOrdinaryArt:
                tst.b   render_flags(a0)
                bpl.s   S3WaterSplash_CullOrDrawOrdinary
                moveq   #0,d1
                move.b  mapping_frame(a0),d1
                cmp.b   $30(a0),d1
                beq.s   S3WaterSplash_CullOrDrawOrdinary
                move.b  d1,$30(a0)
                lsl.w   #8,d1
                move.w  d1,d0
                add.w   d0,d0
                add.w   d0,d1
                addi.l  #ArtUnc_HCZWaterSplash,d1
                move.w  #tiles_to_bytes(ArtTile_HCZWaterSplash),d2
                move.w  #$180,d3
                jsr     (Add_To_DMA_Queue).l

S3WaterSplash_CullOrDrawOrdinary:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

S3WaterSplash_TrackP1AndUpdateSkimmers:
                move.w  (Player_1+x_pos).w,x_pos(a0)
                move.w  (Water_level).w,y_pos(a0)
                bsr.s   UpdateHczWaterSkimmingPlayers
                tst.b   status(a0)
                beq.s   S3WaterSplash_PickSkimArtDestination
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #2,d0
                andi.b  #$F,d0
                bne.s   S3WaterSplash_StepSkimmingArtBank
                moveq   #signextendB(sfx_WaterSkid),d0
                jsr     (Play_SFX).l

S3WaterSplash_StepSkimmingArtBank:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   S3WaterSplash_PickSkimArtDestination
                move.b  #2,anim_frame_timer(a0)
                addq.b  #1,$30(a0)
                cmpi.b  #5,$30(a0)
                blo.s   S3WaterSplash_PickSkimArtDestination
                move.b  #0,$30(a0)

S3WaterSplash_PickSkimArtDestination:
                moveq   #0,d1
                move.b  $30(a0),d1
                cmp.b   $31(a0),d1
                beq.s   S3WaterSplash_CullOrDrawSkim
                move.b  d1,$31(a0)
                lsl.w   #7,d1
                move.w  d1,d0
                add.w   d0,d0
                add.w   d0,d1
                addi.l  #ArtUnc_HCZWaterSplash2,d1
                move.w  #tiles_to_bytes(ArtTile_HCZ2WaterSplash2),d2
                tst.b   (Current_act).w
                beq.s   S3WaterSplash_QueueSkimArtDma
                move.w  #tiles_to_bytes(ArtTile_HCZ1WaterSplash2),d2

S3WaterSplash_QueueSkimArtDma:
                move.w  #$C0,d3
                jsr     (Add_To_DMA_Queue).l

S3WaterSplash_CullOrDrawSkim:
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
                beq.s   S3WaterSplash_UpdateP2Skimming
                bset    #0,render_flags(a0)

S3WaterSplash_UpdateP2Skimming:
                lea     (Player_2).w,a1
                lea     sub3_x_pos(a0),a2
                moveq   #p2_standing_bit,d6
                move.w  (Ctrl_2_logical).w,d5
                bsr.s   UpdatePlayerSkimmingHczWater
                move.b  render_flags(a0),d0
                add.b   status(a1),d0
                andi.b  #1,d0
                beq.s   S3WaterSplash_SkimmersReturn
                move.b  #5,sub3_mapframe-sub3_x_pos(a2)

S3WaterSplash_SkimmersReturn:
                rts
; End of function UpdateHczWaterSkimmingPlayers

; =============== S U B R O U T I N E =======================================

UpdatePlayerSkimmingHczWater:
                btst    d6,status(a0)
                bne.s   S3WaterSplash_CheckJumpOrSkimHeight
                tst.w   y_vel(a1)
                bne.s   S3WaterSplash_StartSkimReturn
                moveq   #0,d1
                move.b  y_radius(a1),d1
                add.w   y_pos(a1),d1
                addq.w  #1,d1
                cmp.w   (Water_level).w,d1
                bne.s   S3WaterSplash_StartSkimReturn
                move.w  x_vel(a1),d0
                bpl.s   S3WaterSplash_TryStartSkimming
                neg.w   d0

; Require an exact waterline contact and an absolute X speed of at least seven pixels per step
S3WaterSplash_TryStartSkimming:
                cmpi.w  #$700,d0
                blo.s   S3WaterSplash_StartSkimReturn
                bset    d6,status(a0)
                move.w  x_pos(a1),(a2)
                move.w  (Water_level).w,sub2_y_pos-sub2_x_pos(a2)
                move.b  #0,sub2_mapframe-sub2_x_pos(a2)
                bclr    #Status_Facing,status(a1)
                tst.w   x_vel(a1)
                bpl.s   S3WaterSplash_StartSkimReturn
                bset    #Status_Facing,status(a1)

S3WaterSplash_StartSkimReturn:
                rts
; ---------------------------------------------------------------------------

S3WaterSplash_CheckJumpOrSkimHeight:
                move.w  d5,d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   S3WaterSplash_JumpFromWaterAndHide
                move.w  (Water_level).w,d0
                moveq   #0,d1
                move.b  y_radius(a1),d1
                sub.w   d1,d0
                subq.w  #1,d0
                cmp.w   y_pos(a1),d0
                bhi.s   S3WaterSplash_EndSkimAndHideSplash
                move.w  x_vel(a1),d1
                bpl.s   S3WaterSplash_ClampSkimmerToWaterline
                neg.w   d1

S3WaterSplash_ClampSkimmerToWaterline:
                cmpi.w  #$700,d1
                blo.s   S3WaterSplash_EndSkimAndHideSplash
                move.w  d0,y_pos(a1)
                move.w  #0,y_vel(a1)
                move.w  x_pos(a1),(a2)
                move.w  (Water_level).w,sub2_y_pos-sub2_x_pos(a2)
                btst    #Status_InAir,status(a1)
                beq.s   S3WaterSplash_ActiveSkimReturn
                andi.w  #(button_left_mask|button_right_mask)<<8,d5
                bne.s   S3WaterSplash_ActiveSkimReturn
                move.w  #$C,d1
                move.w  x_vel(a1),d0
                beq.s   S3WaterSplash_EndSkimAndHideSplash
                bmi.s   S3WaterSplash_SlowNegativeSkimmer
                sub.w   d1,d0
                bcc.s   S3WaterSplash_StorePositiveSkimSpeed
                move.w  #0,d0

S3WaterSplash_StorePositiveSkimSpeed:
                move.w  d0,x_vel(a1)
                bra.s   S3WaterSplash_ActiveSkimReturn
; ---------------------------------------------------------------------------

S3WaterSplash_SlowNegativeSkimmer:
                add.w   d1,d0
                bcc.s   S3WaterSplash_StoreNegativeSkimSpeed
                move.w  #0,d0

S3WaterSplash_StoreNegativeSkimSpeed:
                move.w  d0,x_vel(a1)
                bra.s   S3WaterSplash_ActiveSkimReturn
; ---------------------------------------------------------------------------

S3WaterSplash_EndSkimAndHideSplash:
                bclr    d6,status(a0)
                move.b  #5,sub2_mapframe-sub2_x_pos(a2)

S3WaterSplash_ActiveSkimReturn:
                rts
; ---------------------------------------------------------------------------

S3WaterSplash_JumpFromWaterAndHide:
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
