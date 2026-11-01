; Owner: objects/players/tails/sk
; Responsibility: Tails hurt, death, restart and recovery animation dispatch
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

loc_1569C:
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_156BE
                tst.w   (Debug_mode_flag).w
                beq.s   loc_156BE
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_156BE
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_156BE:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_156D6
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

loc_156D6:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$30,y_vel(a0)
                btst    #Status_Underwater,status(a0)
                beq.s   loc_156F0
                subi.w  #$20,y_vel(a0)

loc_156F0:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_15700
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_15700:
                bsr.w   TailsSKResolveHurtLandingOrDeathPlane
                bsr.w   Tails_Check_Screen_Boundaries
                bsr.w   Sonic_RecordPos
                bsr.w   TailsSKAnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

TailsSKResolveHurtLandingOrDeathPlane:
                tst.b   (Disable_death_plane).w
                bne.s   loc_15742
                tst.b   (Reverse_gravity_flag).w
                bne.s   loc_15734
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$E0,d0
                cmp.w   y_pos(a0),d0
                blt.w   loc_15788
                bra.s   loc_15742
; ---------------------------------------------------------------------------

loc_15734:
                move.w  (Camera_min_Y_pos).w,d0
                cmp.w   y_pos(a0),d0
                blt.s   loc_15742
                bra.w   loc_15788
; ---------------------------------------------------------------------------

loc_15742:
                movem.l a4-a6,-(sp)
                bsr.w   Tails_DoLevelCollision
                movem.l (sp)+,a4-a6
                btst    #Status_InAir,status(a0)
                bne.s   locret_15786
                moveq   #0,d0
                move.w  d0,y_vel(a0)
                move.w  d0,x_vel(a0)
                move.w  d0,ground_vel(a0)
                move.b  d0,object_control(a0)
                move.b  #0,anim(a0)
                move.w  #$100,priority(a0)
                move.b  #2,routine(a0)
                move.b  #2*60,invulnerability_timer(a0)
                move.b  #0,spin_dash_flag(a0)

locret_15786:
                rts
; ---------------------------------------------------------------------------

loc_15788:
                jmp     (Kill_Character).l
; End of function TailsSKResolveHurtLandingOrDeathPlane

; ---------------------------------------------------------------------------

loc_1578E:
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_157B0
                tst.w   (Debug_mode_flag).w
                beq.s   loc_157B0
                btst    #button_B,(Ctrl_1_pressed).w
                beq.s   loc_157B0
                move.w  #1,(Debug_placement_mode).w
                clr.b   (Ctrl_1_locked).w
                rts
; ---------------------------------------------------------------------------

loc_157B0:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_157C8
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

loc_157C8:
                bsr.w   PlayerSKFinishDeathWithFollowerResetRestartOrCompetitionRespawn
                jsr     (MoveSprite_TestGravity).l
                bsr.w   Sonic_RecordPos
                bsr.w   TailsSKAnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_157E0:
                tst.w   $3E(a0)
                beq.s   locret_157F2
                subq.w  #1,$3E(a0)
                bne.s   locret_157F2
                move.w  #1,(Restart_level_flag).w

locret_157F2:
                rts
; ---------------------------------------------------------------------------

loc_157F4:
                tst.w   (H_scroll_amount_P2).w
                bne.s   loc_15806
                tst.w   (V_scroll_amount_P2).w
                bne.s   loc_15806
                move.b  #2,routine(a0)

loc_15806:
                bsr.w   TailsSKAnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_15810:
                tst.b   (Flying_carrying_Sonic_flag).w
                beq.s   loc_15828
                lea     (Player_1).w,a1
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                clr.w   (Flying_carrying_Sonic_flag).w

loc_15828:
                jsr     (MoveSprite_TestGravity2).l
                addi.w  #$10,y_vel(a0)
                bsr.w   Sonic_RecordPos
                bsr.w   TailsSKAnimateRecoveryStateAndDispatchPatternLoader
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

TailsSKAnimateRecoveryStateAndDispatchPatternLoader:
                tst.w   (Competition_mode).w
                bne.s   loc_1585A
                bsr.s   Animate_Tails
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_15856
                eori.b  #2,render_flags(a0)

loc_15856:
                bra.w   Tails_Load_PLC
; ---------------------------------------------------------------------------

loc_1585A:
                bsr.w   Animate_Tails2P
                bra.w   Tails2P_Load_PLC
; End of function TailsSKAnimateRecoveryStateAndDispatchPatternLoader
