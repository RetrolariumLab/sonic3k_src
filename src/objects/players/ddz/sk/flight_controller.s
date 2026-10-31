; Owner: objects/players/ddz/sk
; Responsibility: Doomsday player flight controller, scripted entry, camera limits, debugging transition and failure state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_81492:
                bsr.w   sub_82742
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_81514(pc,d0.w),d1
                jsr     off_81514(pc,d1.w)
                move.w  (_unkFABC).w,d0
                move.w  (Debug_placement_mode).w,d1
                move.w  d1,(_unkFABC).w
                eor.w   d1,d0
                beq.s   loc_814B8
                bsr.w   sub_8151C

loc_814B8:
                tst.w   d1
                bne.s   locret_81512
                bsr.w   sub_82920
                bsr.w   sub_829D2
                btst    #1,(_unkFAB8).w
                beq.s   locret_81512
                move.l  #loc_816FC,(a0)
                bset    #3,$38(a0)
                move.l  (Camera_X_pos).w,d0
                move.l  d0,(_unkFA86).w
                swap    d0
                move.w  d0,(Camera_stored_min_X_pos).w
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                addi.w  #$140,d0
                move.w  d0,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   loc_81504
                move.l  #Obj_DecLevStartXGradual,(a1)

loc_81504:
                jsr     (AllocateObject).l
                bne.s   locret_81512
                move.l  #Obj_IncLevEndXGradual,(a1)

locret_81512:
                rts
; ---------------------------------------------------------------------------
off_81514:
                dc.w    loc_81554-off_81514
                dc.w    loc_8160A-off_81514
                dc.w    loc_8167C-off_81514
                dc.w    loc_816F4-off_81514

; =============== S U B R O U T I N E =======================================

sub_8151C:
                tst.w   d1
                bne.s   loc_81548
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.b  #1,object_control(a1)
                clr.b   anim(a1)
                move.w  #$800,x_vel(a1)
                move.w  #$800,ground_vel(a1)
                rts
; ---------------------------------------------------------------------------

loc_81548:
                clr.w   (Camera_min_X_pos).w
                move.w  #$7FFF,(Camera_max_X_pos).w
                rts
; End of function sub_8151C

; ---------------------------------------------------------------------------

loc_81554:
                move.b  #2,routine(a0)
                move.w  a0,(_unkFA8E).w
                move.w  #$17,$2E(a0)
                move.w  #$400,x_vel(a0)
                st      (Scroll_lock).w
                move.b  #1,(Boss_flag).w
                move.l  #$10000,(_unkFA82).w
                move.l  #$800,(_unkFA8A).w
                lea     (Player_1).w,a1
                bset    #7,art_tile(a1)
                move.b  #$81,object_control(a1)
                move.b  #2,anim(a1)
                clr.b   status(a1)
                move.w  (Camera_X_pos).w,d0
                subi.w  #$20,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$20,d0
                move.w  d0,y_pos(a0)
                lea     word_81602(pc),a1
                lea     (_unkFAB0).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                move.w  #0,(Camera_min_Y_pos).w
                move.w  #$120,(Camera_max_Y_pos).w
                move.w  #$120,(Camera_target_max_Y_pos).w
                lea     (Player_2).w,a1
                moveq   #0,d0
                moveq   #$12-1,d1

loc_815DC:
                move.l  d0,(a1)+
                dbf     d1,loc_815DC
                clr.w   (a1)
                jsr     (AllocateObject).l
                bne.s   loc_815F2
                move.l  #loc_82722,(a1)

loc_815F2:
                lea     (ArtKosM_DDZMisc).l,a1
                move.w  #tiles_to_bytes(ArtTile_DDZMisc),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------
word_81602:
                dc.w    $20,   $C0
                dc.w    $20,   $C0
; ---------------------------------------------------------------------------

loc_8160A:
                jsr     (MoveSprite_LightGravity).l
                subq.w  #1,$2E(a0)
                bpl.w   locret_82ABA
                move.b  #4,routine(a0)
                bset    #7,$38(a0)
                addi.w  #50,(Ring_count).w
                move.b  #1,(Super_palette_status).w
                move.b  #$F,(Palette_timer).w
                move.b  #1,(Super_Sonic_Knux_flag).w
                move.w  #60,(Super_frame_count).w
                move.l  #Map_SuperSonic,(Player_1+mappings).w
                move.b  #$81,(Player_1+object_control).w
                move.b  #$1F,(Player_1+anim).w
                move.w  #$A00,(Max_speed).w
                move.w  #$30,(Acceleration).w
                move.w  #$100,(Deceleration).w
                move.b  #0,(Player_1+invincibility_timer).w
                bset    #Status_Invincible,(Player_1+status_secondary).w
                moveq   #signextendB(sfx_Whistle),d0    ; This is not the normal Super transformation SFX
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

loc_8167C:
                subi.w  #$20,y_vel(a0)
                jsr     (MoveSprite2).l
                lea     (Player_1).w,a1
                tst.b   object_control(a1)
                bne.w   locret_82ABA
                move.b  #6,routine(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                bset    #2,$38(a0)
                move.b  #1,object_control(a1)
                clr.b   anim(a1)
                move.w  #$1000,x_vel(a1)
                move.w  #$1000,ground_vel(a1)
                cmpi.b  #7,(Super_emerald_count).w
                beq.s   loc_816D2
                move.l  #loc_8242A,(Super_stars).w
                bra.w   loc_816E8
; ---------------------------------------------------------------------------

loc_816D2:
                jsr     (sub_5FCCE).l
                move.l  #Obj_HyperSonic_Stars,(Invincibility_stars).w
                move.l  #Obj_HyperSonicKnux_Trail,(Super_stars).w

loc_816E8:
                lea     (PLC_BossExplosion).l,a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

loc_816F4:
                bsr.w   sub_82772
                bra.w   sub_828B2
; ---------------------------------------------------------------------------

loc_816FC:
                bsr.w   sub_82742
                bsr.w   sub_82772
                bsr.w   sub_828B2
                bsr.w   sub_829A0
                bsr.w   sub_829D2
                btst    #0,(_unkFAB8).w
                beq.s   locret_81724
                move.l  #loc_81726,(a0)
                move.w  #$140,$3C(a0)

locret_81724:
                rts
; ---------------------------------------------------------------------------

loc_81726:
                clr.w   (_unkFAAE).w
                move.w  (Camera_X_pos).w,d0
                cmpi.w  #$7400,d0
                blo.s   loc_81770
                move.w  #$2000,d1
                sub.w   d1,d0
                move.w  d0,(Camera_X_pos).w
                jsr     (Seek_Object_Manager).l
                moveq   #0,d0
                lea     (Ring_status_table).w,a1
                move.w  #bytesToLcnt($400),d1

loc_8174E:
                move.l  d0,(a1)+
                dbf     d1,loc_8174E
                move.w  (Camera_X_pos).w,d0
                subi.w  #$80,d0
                andi.w  #$FF80,d0
                move.w  d0,(Camera_X_pos_coarse_back).w
                move.w  #$2000,d1
                move.w  d1,(_unkFAAE).w
                sub.w   d1,x_pos(a0)

loc_81770:
                bsr.w   sub_82742
                bsr.w   sub_82772
                bsr.w   sub_828B2
                move.w  (_unkFABC).w,d0
                move.w  (Debug_placement_mode).w,d1
                move.w  d1,(_unkFABC).w
                eor.w   d1,d0
                beq.s   loc_81790
                bsr.w   sub_8151C

loc_81790:
                tst.w   d1
                bne.w   locret_82ABA
                bsr.w   sub_82920
                bra.w   sub_829D2
; ---------------------------------------------------------------------------

loc_8179E:
                lea     (Player_1).w,a1
                jsr     (MoveSprite).l
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$F0,d0
                cmp.w   y_pos(a0),d0
                bhs.w   locret_82ABA
                movea.l a0,a2
                lea     (Player_1).w,a1
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l a2,a0
                jmp     (Delete_Current_Sprite).l
