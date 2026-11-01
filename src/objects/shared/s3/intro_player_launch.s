; Owner: objects/shared/s3
; Responsibility: Shared introductory player launch, ground motion and character control helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LevelIntro_PlayerLaunchFromGround:
                move.l  #loc_3907E,(a0)
                move.b  #1,(Ctrl_1_locked).w
                move.b  #1,(Ctrl_2_locked).w
                moveq   #0,d0
                move.w  d0,(Ctrl_1_logical).w
                move.w  d0,(Ctrl_1).w
                move.w  d0,(Ctrl_2_logical).w
                move.w  d0,(Ctrl_2).w
                move.b  #30,anim_frame_timer(a0)
                lea     (Player_1).w,a1
                bsr.s   HoldPlayerForLbzGroundLaunchIntro
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   locret_3907C

; =============== S U B R O U T I N E =======================================

HoldPlayerForLbzGroundLaunchIntro:
                move.b  #3,object_control(a1)

locret_3907C:
                rts
; End of function HoldPlayerForLbzGroundLaunchIntro

; ---------------------------------------------------------------------------

loc_3907E:
                move.b  #1,(Ctrl_1_locked).w
                move.b  #1,(Ctrl_2_locked).w
                move.w  #0,(Ctrl_1_logical).w
                move.w  #0,(Ctrl_2_logical).w
                subq.b  #1,anim_frame_timer(a0)
                beq.s   loc_3909E
                rts
; ---------------------------------------------------------------------------

loc_3909E:
                move.l  #loc_390D0,(a0)
                lea     (Player_1).w,a1
                bsr.s   LaunchLbzIntroPlayerUpward
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   locret_390CE

; =============== S U B R O U T I N E =======================================

LaunchLbzIntroPlayerUpward:
                move.w  #-$B00,y_vel(a1)
                bset    #Status_InAir,status(a1)
                clr.b   jumping(a1)
                move.b  #$10,anim(a1)
                move.b  #1,object_control(a1)

locret_390CE:
                rts
; End of function LaunchLbzIntroPlayerUpward

; ---------------------------------------------------------------------------

loc_390D0:
                move.b  #1,(Ctrl_1_locked).w
                move.b  #1,(Ctrl_2_locked).w
                move.w  #0,(Ctrl_1_logical).w
                move.w  #0,(Ctrl_2_logical).w
                lea     (Player_1).w,a2
                cmpi.w  #$5C0,y_pos(a2)
                bhs.s   loc_3913A
                move.b  #0,object_control(a2)
                move.w  #4<<8,(Dust+anim).w             ; and prev_anim
                move.w  #$5C0,(Dust+y_pos).w
                lea     (Player_2).w,a2
                tst.l   (a2)
                beq.s   loc_39120
                move.b  #0,object_control(a2)
                move.w  #4<<8,(Dust_P2+anim).w          ; and prev_anim
                move.w  #$5C0,(Dust_P2+y_pos).w

loc_39120:
                moveq   #signextendB(sfx_SandSplash),d0
                jsr     (Play_SFX).l
                move.b  #0,(Ctrl_1_locked).w
                move.b  #0,(Ctrl_2_locked).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3913A:
                bsr.s   MoveLbzIntroPlayerWithGravity
                lea     (Player_2).w,a2
                tst.l   (a2)
                beq.s   locret_39162

; =============== S U B R O U T I N E =======================================

MoveLbzIntroPlayerWithGravity:
                move.w  x_vel(a2),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a2)
                move.w  y_vel(a2),d0
                addi.w  #$38,y_vel(a2)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a2)

locret_39162:
                rts
; End of function MoveLbzIntroPlayerWithGravity
