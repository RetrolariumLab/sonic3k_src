; Owner: objects/zones/dez/sk
; Responsibility: Gravity switch contact, activation and player gravity state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZGravitySwitch:
                move.l  #Map_DEZGravitySwitch,mappings(a0)
                move.w  #make_art_tile(ArtTile_DEZMisc+$143,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.l  #SKDEZGravSwitch_CheckSolidAndTryPress,(a0)

SKDEZGravSwitch_CheckSolidAndTryPress:
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                swap    d6
                move.w  d6,d0
                andi.w  #$14,d0
                beq.w   SKDEZGravSwitch_DrawIdleSwitch
                move.b  #1,mapping_frame(a0)
                move.l  #SKDEZGravSwitch_TickPressAndToggle,(a0)
                move.w  #3,$30(a0)
                moveq   #8,d0
                btst    #1,render_flags(a0)
                beq.s   SKDEZGravSwitch_MoveAndResetPlayers
                neg.w   d0

SKDEZGravSwitch_MoveAndResetPlayers:
                add.w   d0,y_pos(a0)
                lea     (Player_1).w,a1
                move.w  d6,d2
                move.w  #$14,d3
                bsr.s   ResetFreePlayerForDezGravitySwitch
                lea     (Player_2).w,a1
                move.w  d6,d2
                move.w  #$28,d3
                bsr.s   ResetFreePlayerForDezGravitySwitch
                moveq   #signextendB(sfx_Transporter),d0
                jsr     (Play_SFX).l

SKDEZGravSwitch_DrawIdleSwitch:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

ResetFreePlayerForDezGravitySwitch:
                tst.b   object_control(a1)
                bne.s   SKDEZGravSwitch_PlayerResetReturn
                moveq   #0,d1
                move.b  d1,anim(a1)
                move.b  d1,flip_type(a1)
                move.b  d1,double_jump_flag(a1)
                move.b  d1,jumping(a1)
                move.b  d1,spin_dash_flag(a1)
                move.w  d1,ground_vel(a1)
                move.w  d1,x_vel(a1)
                move.w  d1,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                and.w   d3,d2
                beq.s   SKDEZGravSwitch_PlayerResetReturn
                add.w   d0,y_pos(a1)

SKDEZGravSwitch_PlayerResetReturn:
                rts
; End of function ResetFreePlayerForDezGravitySwitch

; ---------------------------------------------------------------------------

SKDEZGravSwitch_TickPressAndToggle:
                subq.w  #1,$30(a0)
                bpl.s   SKDEZGravSwitch_DrawPressDelay
                move.w  #20-1,$30(a0)
                eori.b  #1,(Reverse_gravity_flag).w
                move.l  #SKDEZGravSwitch_HoldPressedUnderP1,(a0)

SKDEZGravSwitch_DrawPressDelay:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKDEZGravSwitch_HoldPressedUnderP1:
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                btst    #Status_OnObj,status(a0)
                beq.s   SKDEZGravSwitch_TickReturnDelay
                move.w  #0,$30(a0)
                bra.s   SKDEZGravSwitch_DrawHeldSwitch
; ---------------------------------------------------------------------------

SKDEZGravSwitch_TickReturnDelay:
                subq.w  #1,$30(a0)
                bpl.s   SKDEZGravSwitch_DrawHeldSwitch
                move.b  #0,mapping_frame(a0)
                moveq   #8,d0
                btst    #1,render_flags(a0)
                beq.s   SKDEZGravSwitch_ReturnAndRearmSwitch
                neg.w   d0

SKDEZGravSwitch_ReturnAndRearmSwitch:
                sub.w   d0,y_pos(a0)
                move.l  #SKDEZGravSwitch_CheckSolidAndTryPress,(a0)

SKDEZGravSwitch_DrawHeldSwitch:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_DEZGravitySwitch:
                include "src/objects/shared/zones/dez/mappings/gravity_switch.s"
