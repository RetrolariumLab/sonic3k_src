; Owner: objects/interface/s3
; Responsibility: Game-over text object creation, movement and lifetime
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_GameOver:
                tst.l   (Nem_decomp_queue).w
                beq.s   loc_2C9B4
                rts
; ---------------------------------------------------------------------------

loc_2C9B4:
                move.w  #$50,x_pos(a0)
                btst    #0,mapping_frame(a0)
                beq.s   loc_2C9C8
                move.w  #$1F0,x_pos(a0)

loc_2C9C8:
                move.w  #$F0,y_pos(a0)
                move.l  #Map_GameOver,mappings(a0)
                move.w  #make_art_tile(ArtTile_Shield,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.l  #loc_2C9E8,(a0)

loc_2C9E8:
                moveq   #$10,d1
                cmpi.w  #$120,x_pos(a0)
                beq.s   loc_2CA00
                bcs.s   loc_2C9F6
                neg.w   d1

loc_2C9F6:
                add.w   d1,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2CA00:
                move.w  #8*60,anim_frame_timer(a0)
                move.l  #loc_2CA0E,(a0)
                rts
; ---------------------------------------------------------------------------

loc_2CA0E:
                move.w  #0,(Collision_response_list).w
                btst    #0,mapping_frame(a0)
                bne.w   loc_2CA60
                move.b  (Ctrl_1_pressed).w,d0
                or.b    (Ctrl_2_pressed).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask|button_start_mask,d0
                bne.s   loc_2CA3C
                tst.w   anim_frame_timer(a0)
                beq.s   loc_2CA3C
                subq.w  #1,anim_frame_timer(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2CA3C:
                tst.b   (Time_over_flag).w
                bne.s   loc_2CA56
                move.b  #GameMode_Continue,(Game_mode).w
                tst.b   (Continue_count).w
                bne.s   loc_2CA60
                move.b  #GameMode_SegaScreen,(Game_mode).w
                bra.s   loc_2CA60
; ---------------------------------------------------------------------------

loc_2CA56:
                clr.l   (Saved_timer).w
                move.w  #1,(Restart_level_flag).w

loc_2CA60:
                jmp     (Draw_Sprite).l
