; Owner: objects/bosses/aiz/end_boss/s3
; Responsibility: Angel Island end-boss initialization, battle state, defeat sequence and player transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZEndBoss:
                move.w  #$4880,d0
                cmp.w   (Camera_X_pos).w,d0
                bls.s   loc_470BE                       ; Only branch if Sonic has reached the boss area
                rts
; ---------------------------------------------------------------------------

loc_470BE:
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                move.l  #Obj_Wait,(a0)                  ; Set up object to wait $78 frames
                move.w  #2*60,$2E(a0)
                move.l  #Obj_AIZEndBossMusic,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.b  #1,(Boss_flag).w                ; Lock the screen
                clr.b   (_unkFAA3).w
                moveq   #PLCID_6B,d0
                jsr     (Load_PLC).l                    ; Load Robotnik's ship and explosions
                lea     (ArtKosM_AIZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_AIZEndBoss),d2
                jsr     (Queue_Kos_Module).l            ; Load the AIZ boss ship
                lea     Pal_AIZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l               ; Load the AIZ boss palette
; ---------------------------------------------------------------------------

Obj_AIZEndBossMusic:
                move.l  #Obj_AIZEndBossMain,(a0)
                moveq   #signextendB(mus_EndBoss),d0    ; Play the boss music
                jsr     (Play_Music).l
                rts
; ---------------------------------------------------------------------------

Obj_AIZEndBossMain:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZ_EndBossIndex(pc,d0.w),d1
                jsr     AIZ_EndBossIndex(pc,d1.w)
                btst    #6,$38(a0)
                bne.w   locret_47246                    ; Only draw and touch when boss has revealed itself
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
AIZ_EndBossIndex:
                dc.w    Obj_AIZEndBossInit-AIZ_EndBossIndex
                dc.w    loc_471C2-AIZ_EndBossIndex
                dc.w    loc_4720C-AIZ_EndBossIndex
                dc.w    loc_47248-AIZ_EndBossIndex
                dc.w    loc_472C2-AIZ_EndBossIndex
                dc.w    loc_471C2-AIZ_EndBossIndex
                dc.w    loc_47328-AIZ_EndBossIndex
                dc.w    loc_47348-AIZ_EndBossIndex
; ---------------------------------------------------------------------------

Obj_AIZEndBossInit:
                lea     ObjDat_AIZEndBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #8,collision_property(a0)       ; 8 hits defeats it
                bset    #0,render_flags(a0)
                lea     (Child1_MakeRoboShip).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_47176
                move.b  #8,subtype(a1)

loc_47176:
                lea     ChildObjDat_47B6E(pc),a2
                jsr     (CreateChild1_Normal).l

loc_47180:
                move.b  #2,routine(a0)
                moveq   #signextendB(sfx_WaterfallSplash),d0
                jsr     (Play_SFX).l
                ori.b   #$48,$38(a0)
                move.l  #loc_471E2,$34(a0)
                clr.b   collision_flags(a0)
                bsr.w   sub_47AEA
                bclr    #0,render_flags(a0)
                cmpi.w  #8,angle(a0)
                bhs.s   loc_471B8
                bset    #0,render_flags(a0)

loc_471B8:
                lea     ChildObjDat_47B84(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_471C2:
                lea     byte_47BEE(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                bclr    #6,$38(a0)
                cmpi.b  #$2B,mapping_frame(a0)
                bne.s   locret_471E0
                bset    #6,$38(a0)

locret_471E0:
                rts
; ---------------------------------------------------------------------------

loc_471E2:
                move.b  #4,routine(a0)
                bclr    #6,$38(a0)
                bset    #7,art_tile(a0)
                move.b  #$16,collision_flags(a0)
                move.l  #loc_4721A,$34(a0)
                lea     ChildObjDat_47B8C(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_4720C:
                lea     byte_47C09(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                bra.w   sub_47A20
; ---------------------------------------------------------------------------

loc_4721A:
                move.b  #6,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_4725E,$34(a0)
                move.w  #$C0,d0
                move.w  d0,$3E(a0)
                move.w  d0,y_vel(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)

locret_47246:
                rts
; ---------------------------------------------------------------------------

loc_47248:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                bra.w   sub_47A20
; ---------------------------------------------------------------------------

loc_4725E:
                bset    #1,$38(a0)
                btst    #7,$38(a0)
                bne.s   loc_47282
                move.w  #4,angle(a0)
                move.w  #$2F,$2E(a0)
                move.l  #loc_472AE,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_47282:
                move.w  #$BF,$2E(a0)
                move.l  #loc_47292,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_47292:
                move.b  #8,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_472CC,$34(a0)
                andi.b  #$F5,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_472AE:
                st      (_unkFAA2).w
                move.w  #$8F,$2E(a0)
                move.l  #loc_47292,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_472C2:
                bsr.w   sub_47A20
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_472CC:
                move.b  #$A,routine(a0)
                moveq   #signextendB(sfx_WaterfallSplash),d0
                jsr     (Play_SFX).l
                move.l  #loc_472FC,$34(a0)
                clr.b   collision_flags(a0)
                bsr.w   sub_47AEA
                lea     ChildObjDat_47B84(pc),a2
                jsr     (CreateChild1_Normal).l
                move.b  #2,subtype(a1)
                rts
; ---------------------------------------------------------------------------

loc_472FC:
                move.b  #$C,routine(a0)
                bset    #7,$38(a0)
                beq.s   loc_47310
                move.b  #$E,routine(a0)

loc_47310:
                move.l  #loc_47354,$34(a0)
                bclr    #7,art_tile(a0)
                move.b  #0,mapping_frame(a0)
                bra.w   loc_478AC
; ---------------------------------------------------------------------------

loc_47328:
                move.w  (Camera_max_X_pos).w,d0
                addq.w  #2,d0
                cmpi.w  #$49A0,d0
                bcc.s   loc_47338
                move.w  d0,(Camera_max_X_pos).w

loc_47338:
                move.w  (Camera_min_X_pos).w,d0
                addq.w  #2,d0
                cmpi.w  #$48E0,d0
                bcc.s   loc_47348
                move.w  d0,(Camera_min_X_pos).w

loc_47348:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_47354:
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                bra.w   loc_47180
; ---------------------------------------------------------------------------

loc_47360:
                move.l  #loc_47390,$34(a0)
                st      (_unkFAA3).w
                move.l  #Obj_Wait,(a0)
                bset    #4,$38(a0)
                move.w  #$7F,$2E(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                lea     ChildObjDat_47BBC(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_47390:
                move.l  #loc_473C6,(a0)

loc_47396:
                st      (_unkFAA8).w
                clr.b   (Boss_flag).w
                jsr     (Restore_LevelMusic).l
                lea     (PLC_EggCapsule).l,a1
                jsr     (Load_PLC_Raw).l
                lea     ChildObjDat_47BE2(pc),a2
                jsr     (CreateChild6_Simple).l
                bset    #1,render_flags(a1)
                jmp     (PLCLoad_AnimalsAndExplosion).l
; ---------------------------------------------------------------------------

loc_473C6:
                tst.b   (_unkFAA8).w
                bne.w   locret_47246
                move.l  #loc_47402,(a0)
                clr.b   (_unkFAA8).w
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                move.w  #$48E0+$158,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_47402:
                move.b  #5,(Flying_picking_Sonic_timer).w
                lea     (Player_1).w,a1
                cmpi.w  #$48E0+$1F8,x_pos(a1)
                bcc.s   loc_4741C
                move.w  #(button_right_mask<<8)|button_right_mask,(Ctrl_1_logical).w
                rts
; ---------------------------------------------------------------------------

loc_4741C:
                move.l  #loc_4744A,(a0)
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                lea     ChildObjDat_47BE8(pc),a2
                jsr     (CreateChild6_Simple).l
                move.b  #4,subtype(a1)
                lea     (PLC_Explosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

loc_4744A:
                move.b  #5,(Flying_picking_Sonic_timer).w
                tst.b   (Ctrl_1_locked).w
                beq.s   loc_4745E
                move.w  #(button_up_mask<<8)|button_up_mask,(Ctrl_1_logical).w
                rts
; ---------------------------------------------------------------------------

loc_4745E:
                move.l  #loc_47466,(a0)
                rts
; ---------------------------------------------------------------------------

loc_47466:
                move.b  #5,(Flying_picking_Sonic_timer).w
                cmpi.w  #$15A+$1E6,(Player_1+y_pos).w
                bcc.s   loc_47476
                rts
; ---------------------------------------------------------------------------

loc_47476:
                move.w  #$100,d0
                jsr     (StartNewLevel).l
                jmp     (Delete_Current_Sprite).l
; End of function loc_47466
