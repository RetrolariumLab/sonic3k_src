; Owner: objects/interface/s3
; Responsibility: Game-over text object creation, movement and lifetime
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_GameOver:
                tst.l   (Nem_decomp_queue).w
                beq.s   S3GameOver_InitMessageHalfX
                rts
; ---------------------------------------------------------------------------

S3GameOver_InitMessageHalfX:
                move.w  #$50,x_pos(a0)
                btst    #0,mapping_frame(a0)
                beq.s   S3GameOver_InitMessageAndStartSlide
                move.w  #$1F0,x_pos(a0)

S3GameOver_InitMessageAndStartSlide:
                move.w  #$F0,y_pos(a0)
                move.l  #Map_GameOver,mappings(a0)
                move.w  #make_art_tile(ArtTile_Shield,0,1),art_tile(a0)
                move.w  #0,priority(a0)
                move.l  #S3GameOver_SlideMessageToCenter,(a0)

S3GameOver_SlideMessageToCenter:
                moveq   #$10,d1
                cmpi.w  #$120,x_pos(a0)
                beq.s   S3GameOver_StartEightSecondWait
                bcs.s   S3GameOver_StepAndDrawMessage
                neg.w   d1

S3GameOver_StepAndDrawMessage:
                add.w   d1,x_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3GameOver_StartEightSecondWait:
                move.w  #8*60,anim_frame_timer(a0)
                move.l  #S3GameOver_ClearTouchQueueAndWait,(a0)
                rts
; ---------------------------------------------------------------------------

; Only the even mapping frame owns the transition timer
S3GameOver_ClearTouchQueueAndWait:
                move.w  #0,(Collision_response_list).w
                btst    #0,mapping_frame(a0)
                bne.w   S3GameOver_DrawOverMessage
                move.b  (Ctrl_1_pressed).w,d0
                or.b    (Ctrl_2_pressed).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask|button_start_mask,d0
                bne.s   S3GameOver_ChooseContinueOrSega
                tst.w   anim_frame_timer(a0)
                beq.s   S3GameOver_ChooseContinueOrSega
                subq.w  #1,anim_frame_timer(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3GameOver_ChooseContinueOrSega:
                tst.b   (Time_over_flag).w
                bne.s   S3GameOver_RestartAfterTimeOver
                move.b  #GameMode_Continue,(Game_mode).w
                tst.b   (Continue_count).w
                bne.s   S3GameOver_DrawOverMessage
                move.b  #GameMode_SegaScreen,(Game_mode).w
                bra.s   S3GameOver_DrawOverMessage
; ---------------------------------------------------------------------------

S3GameOver_RestartAfterTimeOver:
                clr.l   (Saved_timer).w
                move.w  #1,(Restart_level_flag).w

S3GameOver_DrawOverMessage:
                jmp     (Draw_Sprite).l
