; Owner: game/modes/s3; responsibility: pause
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Pause_Game:
                nop
                tst.b   (Life_count).w
                beq.w   Pause_Unpause
                tst.w   (Game_paused).w
                bne.s   S3Pause_EnterPauseAndSignalZ80MusicHold
                move.b  (Ctrl_1_pressed).w,d0
                or.b    (Ctrl_2_pressed).w,d0
                andi.b  #button_start_mask,d0           ; is Start pressed?
                beq.w   Pause_NoPause                   ; if not, branch

S3Pause_EnterPauseAndSignalZ80MusicHold:
                move.w  #1,(Game_paused).w
                stopZ80
                move.b  #1,(Z80_RAM+zPauseFlag).l       ; Pause the music
                startZ80

Pause_Loop:
                move.b  #VInt_ID_10,(V_int_routine).w
                bsr.w   Wait_VSync
                tst.b   (Slow_motion_flag).w
                beq.s   Pause_NoSlowMo
                btst    #button_A,(Ctrl_1_pressed).w
                beq.s   Pause_ChkFrameAdvance           ; branch if A isn't pressed
                move.b  #GameMode_LevelSelect,(Game_mode).w  ; go to level select (oddly enough this is only for Sonic 3 Alone. Sonic 2, the Nov 3rd Prototype and Sonic & Knuckles don't have it set for the level select. This line was eventually changed to return to the title screen once more by the 0610 build of Sonic & Knuckles.)
                nop
                bra.s   Pause_ResumeMusic
; ---------------------------------------------------------------------------

Pause_ChkFrameAdvance:
                btst    #button_B,(Ctrl_1_held).w
                bne.s   Pause_FrameAdvance              ; branch if B is held
                btst    #button_C,(Ctrl_1_pressed).w
                bne.s   Pause_FrameAdvance              ; branch if C is pressed

Pause_NoSlowMo:
                cmpi.b  #$E,(Current_zone).w
                blo.s   Pause_ChkStart                  ; if the zone is below ALZ
                cmpi.b  #$12,(Current_zone).w
                bhi.s   Pause_ChkStart                  ; if the zone is above EMZ
                tst.b   (Competition_type).w
                bpl.s   Pause_ChkStart
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   Pause_ChkStart
                move.b  #GameMode_CompetitionLevelSelect+$80,(Game_mode).w  ; If in time attack mode, go back to 2P menu if B is pressed
                bra.s   Pause_ResumeMusic
; ---------------------------------------------------------------------------

Pause_ChkStart:
                move.b  (Ctrl_1_pressed).w,d0
                or.b    (Ctrl_2_pressed).w,d0
                andi.b  #button_start_mask,d0
                beq.s   Pause_Loop

Pause_ResumeMusic:
                stopZ80
                move.b  #$80,(Z80_RAM+zPauseFlag).l     ; Unpause music
                startZ80

Pause_Unpause:
                move.w  #0,(Game_paused).w

Pause_NoPause:
                rts
; ---------------------------------------------------------------------------

Pause_FrameAdvance:
                move.w  #1,(Game_paused).w
                stopZ80
                move.b  #$80,(Z80_RAM+zPauseFlag).l     ; Unpause music
                startZ80
                rts                                     ; advance by a single frame
; End of function Pause_Game
