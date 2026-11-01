; Owner: objects/shared/sk
; Responsibility: Introductory player fall, ground transition and character control helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LevelIntro_PlayerFallIntoGround:
                move.l  #loc_42028,(a0)
                move.b  #1,(Ctrl_1_locked).w
                move.b  #1,(Ctrl_2_locked).w
                moveq   #0,d0
                move.w  d0,(Ctrl_1_logical).w
                move.w  d0,(Ctrl_1).w
                move.w  d0,(Ctrl_2_logical).w
                move.w  d0,(Ctrl_2).w
                lea     (Player_1).w,a1
                bsr.s   SetSozIntroPlayerControl
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   locret_42026

; =============== S U B R O U T I N E =======================================

SetSozIntroPlayerControl:
                move.b  #1,object_control(a1)

locret_42026:
                rts
; End of function SetSozIntroPlayerControl

; ---------------------------------------------------------------------------

loc_42028:
                move.b  #1,(Ctrl_1_locked).w
                move.b  #1,(Ctrl_2_locked).w
                move.w  #0,(Ctrl_1_logical).w
                move.w  #0,(Ctrl_2_logical).w
                lea     (Player_1).w,a1
                bsr.s   MoveSozIntroFallingPlayer
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   loc_42050
                bsr.s   MoveSozIntroFallingPlayer

loc_42050:
                lea     (Player_1).w,a2
                move.w  #$690,d0
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_42062
                addq.w  #4,d0

loc_42062:
                cmp.w   y_pos(a2),d0
                bne.s   loc_42080
                bsr.w   loc_42180
                moveq   #signextendB(sfx_SandSplash),d0
                jsr     (Play_SFX).l
                lea     (Player_2).w,a2
                tst.l   (a2)
                beq.s   loc_42080
                bsr.w   loc_42180

loc_42080:
                cmpi.w  #$6C0,(Player_1+y_pos).w
                bhs.s   loc_4208A
                rts
; ---------------------------------------------------------------------------

loc_4208A:
                move.l  #loc_420A6,(a0)
                rts

; =============== S U B R O U T I N E =======================================

MoveSozIntroFallingPlayer:
                move.w  y_vel(a1),d0
                addi.w  #$38,y_vel(a1)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a1)
                rts
; End of function MoveSozIntroFallingPlayer

; ---------------------------------------------------------------------------

loc_420A6:
                move.b  #1,(Ctrl_1_locked).w
                move.b  #1,(Ctrl_2_locked).w
                move.w  #0,(Ctrl_1_logical).w
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Ctrl_1_pressed).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   loc_420CA
                rts
; ---------------------------------------------------------------------------

loc_420CA:
                move.l  #loc_420FC,(a0)
                lea     (Player_1).w,a1
                bsr.s   LaunchSozIntroPlayerFromSand
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   locret_420FA

; =============== S U B R O U T I N E =======================================

LaunchSozIntroPlayerFromSand:
                move.w  #-$800,y_vel(a1)
                bset    #Status_InAir,status(a1)
                clr.b   jumping(a1)
                move.b  #$10,anim(a1)
                move.b  #1,object_control(a1)

locret_420FA:
                rts
; End of function LaunchSozIntroPlayerFromSand

; ---------------------------------------------------------------------------

loc_420FC:
                move.b  #1,(Ctrl_1_locked).w
                move.b  #1,(Ctrl_2_locked).w
                move.w  #0,(Ctrl_1_logical).w
                move.w  #0,(Ctrl_2_logical).w
                lea     (Player_1).w,a2
                cmpi.w  #$6A8,y_pos(a2)
                bhs.s   loc_42156
                move.b  #0,object_control(a2)
                bsr.w   loc_42180
                lea     (Player_2).w,a2
                tst.l   (a2)
                beq.s   loc_4213C
                move.b  #0,object_control(a2)
                bsr.w   loc_42180

loc_4213C:
                moveq   #signextendB(sfx_SandSplash),d0
                jsr     (Play_SFX).l
                move.b  #0,(Ctrl_1_locked).w
                move.b  #0,(Ctrl_2_locked).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_42156:
                bsr.s   MoveSozIntroEscapePlayerWithGravity
                lea     (Player_2).w,a2
                tst.l   (a2)
                beq.s   locret_4217E

; =============== S U B R O U T I N E =======================================

MoveSozIntroEscapePlayerWithGravity:
                move.w  x_vel(a2),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a2)
                move.w  y_vel(a2),d0
                addi.w  #$38,y_vel(a2)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a2)

locret_4217E:
                rts
; End of function MoveSozIntroEscapePlayerWithGravity

; ---------------------------------------------------------------------------

loc_42180:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   locret_4219C
                move.l  #loc_4219E,(a1)
                move.w  x_pos(a2),x_pos(a1)
                move.w  #$66C,y_pos(a1)

locret_4219C:
                rts
; ---------------------------------------------------------------------------

loc_4219E:
                move.l  #Map_SOZRisingSandWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZMisc+$69,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$34,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  #8,mapping_frame(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),d0
                addi.w  #$68,d0
                move.w  d0,(a2)+
                move.w  #$D,(a2)+
                move.b  #3,anim_frame_timer(a0)
                move.w  #$13,$30(a0)
                move.l  #loc_421FE,(a0)

loc_421FE:
                lea     sub2_x_pos(a0),a2
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_4222E
                move.b  #3,anim_frame_timer(a0)
                bchg    #0,render_flags(a0)
                addq.w  #1,y_pos(a0)
                addq.w  #1,y_vel(a0)
                addq.b  #1,sub2_mapframe(a0)
                cmpi.b  #$D,sub2_mapframe(a0)
                blo.s   loc_4222E
                move.b  #9,sub2_mapframe(a0)

loc_4222E:
                cmpi.w  #$C,$30(a0)
                bne.s   loc_4223C
                move.b  #$D,mapping_frame(a0)

loc_4223C:
                subq.w  #1,$30(a0)
                bpl.s   loc_42248
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_42248:
                jmp     (Draw_Sprite).l
