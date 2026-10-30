; Owner: objects/zones/icz/s3
; Responsibility: IceCap Tails introductory player control, timed release and crash transition
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_LevelIntroICZ1Tails:
                lea     (Player_1).w,a1
                move.w  #$800,x_vel(a1)
                move.w  #$480,y_vel(a1)
                move.w  #$800,ground_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #0,jumping(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.b  #3,object_control(a1)
                move.b  #1,(Ctrl_1_locked).w
                move.w  #0,(Ctrl_1_logical).w
                move.w  #0,(Ctrl_1).w
                move.b  #30,anim_frame_timer(a0)
                move.l  #loc_391C2,(a0)

loc_391C2:
                move.b  #1,(Ctrl_1_locked).w
                move.w  #0,(Ctrl_1_logical).w
                move.w  #0,(Ctrl_2_logical).w
                subq.b  #1,anim_frame_timer(a0)
                beq.s   loc_391DC
                rts
; ---------------------------------------------------------------------------

loc_391DC:
                lea     (Player_1).w,a2
                move.b  #0,object_control(a2)
                move.l  #loc_391EC,(a0)

loc_391EC:
                move.b  #1,(Ctrl_1_locked).w
                move.w  #0,(Ctrl_1_logical).w
                lea     (Player_1).w,a2
                cmpi.w  #$38F0,x_pos(a2)
                blo.s   locret_3923C
                bset    #Status_InAir,status(a2)
                move.w  #-$200,x_vel(a2)
                move.w  #-$400,y_vel(a2)
                move.b  #$19,anim(a2)
                move.b  #0,object_control(a2)
                move.b  #0,(Ctrl_1_locked).w
                move.w  #$14,(Screen_shake_flag).w
                moveq   #signextendB(sfx_Crash),d0
                jsr     (Play_SFX).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

locret_3923C:
                rts
