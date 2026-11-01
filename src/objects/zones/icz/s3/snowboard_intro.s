; Owner: objects/zones/icz/s3
; Responsibility: IceCap opening scene control, snowboard dust objects and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_LevelIntroICZ1:
                lea     (Player_1).w,a1
                move.w  #$800,x_vel(a1)
                move.w  #$280,y_vel(a1)
                move.w  #$800,ground_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #0,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.b  #1,(Ctrl_1_locked).w
                move.w  #0,(Ctrl_1_logical).w
                move.w  #0,(Ctrl_1).w
                move.b  #0,mapping_frame(a1)
                move.b  #3,object_control(a1)
                move.b  #30,anim_frame_timer(a0)
                move.l  #Map_Snowboard,mappings(a0)
                move.w  #make_art_tile(ArtTile_S3Snowboard,0,0),art_tile(a0)
                move.w  #$80,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.b  #8,mapping_frame(a0)
                move.w  #$C0,x_pos(a0)
                move.w  #$170,y_pos(a0)
                move.l  #loc_38D7E,(a0)

loc_38D7E:
                subq.b  #1,anim_frame_timer(a0)
                bne.s   loc_38D94
                lea     (Player_1).w,a2
                move.b  #0,object_control(a2)
                move.l  #loc_38D94,(a0)

loc_38D94:
                move.b  #1,(Ctrl_1_locked).w
                move.w  #0,(Ctrl_1_logical).w
                lea     (Player_1).w,a2
                cmpi.w  #$C0,x_pos(a2)
                blo.s   loc_38DC4
                move.w  #-$600,y_vel(a0)
                move.w  #$400,x_vel(a2)
                move.w  #-$800,y_vel(a2)
                move.l  #loc_38DD0,(a0)

loc_38DC4:
                jsr     (QueueIczSnowboardFrameArt).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_38DD0:
                lea     (Player_1).w,a2
                move.w  x_pos(a2),x_pos(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_38DF8
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #9,mapping_frame(a0)
                blo.s   loc_38DF8
                move.b  #1,mapping_frame(a0)

loc_38DF8:
                cmpi.w  #$184,x_pos(a2)
                blo.s   loc_38E3C
                move.b  #0,mapping_frame(a2)
                move.b  #2,object_control(a2)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_38E34
                move.l  #loc_389EC,(a1)
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                move.w  x_vel(a2),x_vel(a1)
                move.w  y_vel(a2),y_vel(a1)

loc_38E34:
                move.l  #loc_38E4C,(a0)
                rts
; ---------------------------------------------------------------------------

loc_38E3C:
                jsr     (MoveSprite2).l
                addi.w  #$28,y_vel(a0)
                bra.w   loc_38DC4
; ---------------------------------------------------------------------------

loc_38E4C:
                lea     (Player_1).w,a2
                move.w  x_pos(a2),x_pos(a0)
                move.w  y_pos(a2),y_pos(a0)
                move.w  (Ctrl_1).w,d0
                andi.w  #((button_A_mask|button_B_mask|button_C_mask|button_start_mask)<<8)|button_A_mask|button_B_mask|button_C_mask|button_start_mask,d0
                move.w  d0,(Ctrl_1_logical).w
                tst.b   object_control(a2)
                bne.s   locret_38EA2
                move.b  #0,(Ctrl_1_locked).w
                move.l  #loc_38EA4,(a0)
                addi.w  #$14,y_pos(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                move.b  #$84,render_flags(a0)
                move.b  #1,mapping_frame(a0)
                move.b  #1,anim_frame_timer(a0)
                bra.w   loc_38DC4
; ---------------------------------------------------------------------------

locret_38EA2:
                rts
; ---------------------------------------------------------------------------

loc_38EA4:
                tst.b   render_flags(a0)
                bmi.s   loc_38EB0
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_38EB0:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_38ECE
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #9,mapping_frame(a0)
                blo.s   loc_38ECE
                move.b  #1,mapping_frame(a0)

loc_38ECE:
                jsr     (MoveSprite2).l
                addi.w  #$28,y_vel(a0)
                bra.w   loc_38DC4
; ---------------------------------------------------------------------------

loc_38EDE:
                move.l  #loc_38EE4,(a0)

loc_38EE4:
                movea.w $30(a0),a3
                lea     (Player_1).w,a2
                tst.b   object_control(a2)
                bne.s   loc_38EF8
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_38EF8:
                btst    #Status_InAir,status(a2)
                bne.s   locret_38F20
                bsr.s   SpawnSnowboardSnowParticle
                bsr.s   SpawnSnowboardSnowParticle
                cmpi.b  #7,mapping_frame(a3)
                beq.s   loc_38F14
                cmpi.b  #8,mapping_frame(a3)
                bne.s   locret_38F20

loc_38F14:
                bsr.s   SpawnSnowboardSnowParticle
                bsr.s   SpawnSnowboardSnowParticle
                bsr.s   SpawnSnowboardSnowParticle
                bsr.s   SpawnSnowboardSnowParticle
                bsr.s   SpawnSnowboardSnowParticle
                bsr.s   SpawnSnowboardSnowParticle

locret_38F20:
                rts

; =============== S U B R O U T I N E =======================================

SpawnSnowboardSnowParticle:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   locret_38FA2
                move.l  #loc_38FA4,(a1)
                move.w  #make_art_tile(ArtTile_SnowboardDust,0,0),art_tile(a1)
                move.l  #Map_SnowboardDust,mappings(a1)
                move.w  #$100,priority(a1)
                move.b  #4,width_pixels(a1)
                move.b  #4,height_pixels(a1)
                move.b  #$84,render_flags(a1)
                move.w  #1,anim(a1)
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                addi.w  #$14,y_pos(a1)
                jsr     (Random_Number).l
                move.l  d0,d1
                andi.w  #$1FF,d0
                neg.w   d0
                subi.w  #$200,y_vel(a1)
                move.w  d0,y_vel(a1)
                move.w  #-$100,x_vel(a1)
                move.l  d1,d0
                andi.w  #$F,d0
                sub.w   d0,x_pos(a1)
                swap    d0
                andi.w  #$F,d0
                sub.w   d0,y_pos(a1)

locret_38FA2:
                rts
; End of function SpawnSnowboardSnowParticle

; ---------------------------------------------------------------------------

loc_38FA4:
                tst.b   render_flags(a0)
                bpl.s   loc_38FC8
                jsr     (MoveSprite2).l
                lea     (Ani_SnowboardDust).l,a1
                jsr     (Animate_Sprite).l
                tst.b   routine(a0)
                bne.s   loc_38FC8
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_38FC8:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Ani_SnowboardDust:
                include "src/objects/shared/snowboard/animations/dust.s"
Map_SnowboardDust:
                include "src/objects/shared/snowboard/mappings/dust.s"
ArtNem_SnowboardDust:
                binclude "data/General/Sprites/Snowboard/Snowboard Dust.nem"
                even
