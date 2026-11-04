; Owner: objects/shared/sk
; Responsibility: Introductory player running state and character control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LevelIntro_PlayerRun:
                move.w  (Player_1+x_pos).w,d0
                addi.w  #$B0,d0
                move.w  d0,$30(a0)
                move.w  (Player_1+y_pos).w,d0
                move.w  d0,$32(a0)
                move.l  #SKLevelRunIntro_ForceRightToAnchor,(a0)

; Lock scrolling and hold Right for the lead player until the anchor is reached
SKLevelRunIntro_ForceRightToAnchor:
                move.b  #1,(Ctrl_1_locked).w
                move.w  #button_right_mask<<8,d0
                move.w  d0,(Ctrl_1_logical).w
                move.b  #1,(Scroll_force_positions).w
                move.w  $30(a0),(Scroll_forced_X_pos).w
                move.w  $32(a0),(Scroll_forced_Y_pos).w
                move.w  (Player_1+x_pos).w,d0
                addi.w  #$10,d0
                cmp.w   $30(a0),d0
                bhs.s   SKLevelRunIntro_UnlockAndDelete
                rts
; ---------------------------------------------------------------------------

SKLevelRunIntro_UnlockAndDelete:
                move.b  #0,(Ctrl_1_locked).w
                move.b  #0,(Ctrl_2_locked).w
                jmp     (Delete_Current_Sprite).l
; End of function Obj_LevelIntro_PlayerRun
