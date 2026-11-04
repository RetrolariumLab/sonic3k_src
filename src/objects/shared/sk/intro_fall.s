; Owner: objects/shared/sk
; Responsibility: Introductory player fall, ground transition and character control helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LevelIntro_PlayerFallIntoGround:
                move.l  #SKSozSandIntro_MoveFallingPlayers,(a0)
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
                beq.s   SKSozSandIntro_ControlSetupReturn

; =============== S U B R O U T I N E =======================================

SetSozIntroPlayerControl:
                move.b  #1,object_control(a1)

SKSozSandIntro_ControlSetupReturn:
                rts
; End of function SetSozIntroPlayerControl

; ---------------------------------------------------------------------------

SKSozSandIntro_MoveFallingPlayers:
                move.b  #1,(Ctrl_1_locked).w
                move.b  #1,(Ctrl_2_locked).w
                move.w  #0,(Ctrl_1_logical).w
                move.w  #0,(Ctrl_2_logical).w
                lea     (Player_1).w,a1
                bsr.s   MoveSozIntroFallingPlayer
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   SKSozSandIntro_SelectP1SplashHeight
                bsr.s   MoveSozIntroFallingPlayer

; Use $690 for most player modes and $694 for Tails alone
SKSozSandIntro_SelectP1SplashHeight:
                lea     (Player_1).w,a2
                move.w  #$690,d0
                cmpi.w  #2,(Player_mode).w
                bne.s   SKSozSandIntro_TryLandingSplash
                addq.w  #4,d0

; Player 1 must match the selected Y exactly to play the sound and spawn the effects
SKSozSandIntro_TryLandingSplash:
                cmp.w   y_pos(a2),d0
                bne.s   SKSozSandIntro_CheckP1SandDepth
                bsr.w   SKSozSandIntro_TrySpawnSplashAtPlayerX
                moveq   #signextendB(sfx_SandSplash),d0
                jsr     (Play_SFX).l
                lea     (Player_2).w,a2
                tst.l   (a2)
                beq.s   SKSozSandIntro_CheckP1SandDepth
                bsr.w   SKSozSandIntro_TrySpawnSplashAtPlayerX

SKSozSandIntro_CheckP1SandDepth:
                cmpi.w  #$6C0,(Player_1+y_pos).w
                bhs.s   SKSozSandIntro_InstallJumpWait
                rts
; ---------------------------------------------------------------------------

SKSozSandIntro_InstallJumpWait:
                move.l  #SKSozSandIntro_WaitForP1RawJump,(a0)
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

; Read fresh A, B or C directly from the physical controller while logical input is cleared
SKSozSandIntro_WaitForP1RawJump:
                move.b  #1,(Ctrl_1_locked).w
                move.b  #1,(Ctrl_2_locked).w
                move.w  #0,(Ctrl_1_logical).w
                move.w  #0,(Ctrl_2_logical).w
                move.b  (Ctrl_1_pressed).w,d0
                andi.b  #button_A_mask|button_B_mask|button_C_mask,d0
                bne.s   SKSozSandIntro_LaunchPresentPlayers
                rts
; ---------------------------------------------------------------------------

SKSozSandIntro_LaunchPresentPlayers:
                move.l  #SKSozSandIntro_CheckP1ReleaseHeight,(a0)
                lea     (Player_1).w,a1
                bsr.s   LaunchSozIntroPlayerFromSand
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   SKSozSandIntro_LaunchReturn

; =============== S U B R O U T I N E =======================================

LaunchSozIntroPlayerFromSand:
                move.w  #-$800,y_vel(a1)
                bset    #Status_InAir,status(a1)
                clr.b   jumping(a1)
                move.b  #$10,anim(a1)
                move.b  #1,object_control(a1)

SKSozSandIntro_LaunchReturn:
                rts
; End of function LaunchSozIntroPlayerFromSand

; ---------------------------------------------------------------------------

; Release once Player 1 reaches an unsigned Y below $6A8
SKSozSandIntro_CheckP1ReleaseHeight:
                move.b  #1,(Ctrl_1_locked).w
                move.b  #1,(Ctrl_2_locked).w
                move.w  #0,(Ctrl_1_logical).w
                move.w  #0,(Ctrl_2_logical).w
                lea     (Player_1).w,a2
                cmpi.w  #$6A8,y_pos(a2)
                bhs.s   SKSozSandIntro_MoveEscapingPlayers
                move.b  #0,object_control(a2)
                bsr.w   SKSozSandIntro_TrySpawnSplashAtPlayerX
                lea     (Player_2).w,a2
                tst.l   (a2)
                beq.s   SKSozSandIntro_SplashUnlockAndDelete
                move.b  #0,object_control(a2)
                bsr.w   SKSozSandIntro_TrySpawnSplashAtPlayerX

SKSozSandIntro_SplashUnlockAndDelete:
                moveq   #signextendB(sfx_SandSplash),d0
                jsr     (Play_SFX).l
                move.b  #0,(Ctrl_1_locked).w
                move.b  #0,(Ctrl_2_locked).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSozSandIntro_MoveEscapingPlayers:
                bsr.s   MoveSozIntroEscapePlayerWithGravity
                lea     (Player_2).w,a2
                tst.l   (a2)
                beq.s   SKSozSandIntro_MoveReturn

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

SKSozSandIntro_MoveReturn:
                rts
; End of function MoveSozIntroEscapePlayerWithGravity

; ---------------------------------------------------------------------------

SKSozSandIntro_TrySpawnSplashAtPlayerX:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKSozSandIntro_SplashSpawnReturn
                move.l  #SKSozSandIntro_InitTwoSpriteSplash,(a1)
                move.w  x_pos(a2),x_pos(a1)
                move.w  #$66C,y_pos(a1)

SKSozSandIntro_SplashSpawnReturn:
                rts
; ---------------------------------------------------------------------------

SKSozSandIntro_InitTwoSpriteSplash:
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
                move.l  #SKSozSandIntro_StepSplashEveryFour,(a0)

; Toggle X flip, increment the y_pos and y_vel words and cycle child frames 9 through 12
SKSozSandIntro_StepSplashEveryFour:
                lea     sub2_x_pos(a0),a2
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKSozSandIntro_HideSplashMainAt12
                move.b  #3,anim_frame_timer(a0)
                bchg    #0,render_flags(a0)
                addq.w  #1,y_pos(a0)
                addq.w  #1,y_vel(a0)
                addq.b  #1,sub2_mapframe(a0)
                cmpi.b  #$D,sub2_mapframe(a0)
                blo.s   SKSozSandIntro_HideSplashMainAt12
                move.b  #9,sub2_mapframe(a0)

SKSozSandIntro_HideSplashMainAt12:
                cmpi.w  #$C,$30(a0)
                bne.s   SKSozSandIntro_TickSplashLifeOrDelete
                move.b  #$D,mapping_frame(a0)

SKSozSandIntro_TickSplashLifeOrDelete:
                subq.w  #1,$30(a0)
                bpl.s   SKSozSandIntro_DrawSplash
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKSozSandIntro_DrawSplash:
                jmp     (Draw_Sprite).l
