; Owner: objects/level_end/sk
; Responsibility: Player control restoration, end-sign sequencing and camera transition checks
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Restore_PlayerControl:
                lea     (Player_1).w,a1

Restore_PlayerControl2:
                clr.b   object_control(a1)
                bclr    #Status_InAir,status(a1)
                move.w  #(5<<8)|5,anim(a1)              ; and prev_anim
                clr.b   anim_frame(a1)
                clr.b   anim_frame_timer(a1)
                rts
; End of function Restore_PlayerControl

; =============== S U B R O U T I N E =======================================

Obj_EndSignControl:
                move.l  #Obj_EndSignControlWait,(a0)
                st      (_unkFAA8).w                    ; End of level is in effect
                bset    #4,$38(a0)
                move.w  #(2*60)-1,$2E(a0)
                move.l  #Obj_EndSignControlDoSign,$34(a0)
                rts
; End of function Obj_EndSignControl

; ---------------------------------------------------------------------------
PLC_EndSignStuff:   plrlistheader
                plreq   ArtTile_SignpostStub, ArtNem_SignpostStub
                plreq   ArtTile_Monitors, ArtNem_Monitors
PLC_EndSignStuff_End:
; ---------------------------------------------------------------------------

Obj_EndSignControlWait:
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Obj_EndSignControlDoSign:
                move.l  #Obj_EndSignControlAwaitStart,(a0)
                clr.b   (Boss_flag).w
                lea     Child6_EndSign(pc),a2
                jsr     CreateChild6_Simple(pc)
                lea     PLC_EndSignStuff(pc),a1
                jsr     (Load_PLC_Raw).l
                jmp     AfterBoss_Cleanup(pc)
; ---------------------------------------------------------------------------
Child6_EndSign:
                dc.w    1-1
                dc.l    Obj_EndSign
; ---------------------------------------------------------------------------

Obj_EndSignControlAwaitStart:
                tst.b   (_unkFAA8).w
                bne.w   SKReturn_AttrSetup
                move.l  #Obj_EndSignControlDoStart,(a0)
                jsr     Restore_PlayerControl(pc)
                lea     (Player_2).w,a1
                jmp     Restore_PlayerControl2(pc)
; ---------------------------------------------------------------------------

Obj_EndSignControlDoStart:
                tst.b   (End_of_level_flag).w           ; Wait for title card to finish
                beq.w   SKReturn_AttrSetup
                jsr     Change_Act2Sizes(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
; unused
                jsr     Displace_PlayerOffObject(pc)
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

Check_CameraInRange:
                move.w  (Camera_Y_pos).w,d0
                cmp.w   (a1)+,d0
                blo.s   loc_85C74
                cmp.w   (a1)+,d0
                bhi.s   loc_85C74
                move.w  (Camera_X_pos).w,d1
                cmp.w   (a1)+,d1
                blo.s   loc_85C74
                cmp.w   (a1)+,d1
                bhi.s   loc_85C74
                bclr    #7,$27(a0)
                cmp.w   (a1),d0
                bls.s   loc_85C5E
                bset    #7,$27(a0)

loc_85C5E:
                bclr    #6,$27(a0)
                cmp.w   4(a1),d1
                bls.s   loc_85C70
                bset    #6,$27(a0)

loc_85C70:
                move.l  (sp),(a0)
                rts
; ---------------------------------------------------------------------------

loc_85C74:
                jsr     (Delete_Sprite_If_Not_In_Range).l
                addq.w  #4,sp
                rts
; End of function Check_CameraInRange

; ---------------------------------------------------------------------------

loc_85C7E:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                move.w  (Camera_target_max_Y_pos).w,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                blo.s   locret_85CA2
                move.w  d0,(Camera_min_Y_pos).w
                move.w  $3A(a0),d0
                cmp.w   (Camera_X_pos).w,d0
                bhi.s   locret_85CA2
                movea.l $34(a0),a1
                jsr     (a1)

locret_85CA2:
                rts
; ---------------------------------------------------------------------------

loc_85CA4:
                btst    #0,$27(a0)
                bne.s   loc_85CC6
                subq.w  #1,$2E(a0)
                bpl.s   loc_85CC6
                move.b  boss_saved_mus(a0),d0
                move.b  d0,(Current_music+1).w
                jsr     (Play_Music).l
                bset    #0,$27(a0)

loc_85CC6:
                btst    #1,$27(a0)
                bne.s   loc_85D06
                move.w  (Camera_Y_pos).w,d0
                tst.b   $27(a0)
                bmi.s   loc_85CE6
                cmp.w   (_unkFAB0).w,d0
                bhs.s   loc_85CF2
                move.w  d0,(Camera_min_Y_pos).w
                bra.w   loc_85D06
; ---------------------------------------------------------------------------

loc_85CE6:
                move.w  (_unkFAB2).w,d1
                addi.w  #$60,d1
                cmp.w   d1,d0
                bhi.s   loc_85D06

loc_85CF2:
                bset    #1,$27(a0)
                move.w  (_unkFAB0).w,(Camera_min_Y_pos).w
                move.w  (_unkFAB2).w,d0
                move.w  d0,(Camera_target_max_Y_pos).w

loc_85D06:
                btst    #2,$27(a0)
                bne.s   loc_85D48
                move.w  (Camera_X_pos).w,d0
                btst    #6,$27(a0)
                bne.s   loc_85D28
                cmp.w   (_unkFAB4).w,d0
                bhs.s   loc_85D36
                move.w  d0,(Camera_min_X_pos).w
                bra.w   loc_85D48
; ---------------------------------------------------------------------------

loc_85D28:
                cmp.w   (_unkFAB6).w,d0
                bls.s   loc_85D36
                move.w  d0,(Camera_max_X_pos).w
                bra.w   loc_85D48
; ---------------------------------------------------------------------------

loc_85D36:
                bset    #2,$27(a0)
                move.w  (_unkFAB4).w,(Camera_min_X_pos).w
                move.w  (_unkFAB6).w,(Camera_max_X_pos).w

loc_85D48:
                move.b  $27(a0),d0
                andi.b  #7,d0
                cmpi.b  #7,d0
                bne.w   SKReturn_AttrSetup
                clr.b   $27(a0)
                clr.w   $1C(a0)
                clr.b   $26(a0)
                movea.l $34(a0),a1
                jmp     (a1)

; =============== S U B R O U T I N E =======================================

; Set the boss flag, fade music and start the wait. Save and load four camera-bound words for convergence
Boss_BeginCameraTransition:
                move.b  #1,(Boss_flag).w

loc_85D70:
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #2*60,$2E(a0)

loc_85D7E:
                move.w  (Camera_min_Y_pos).w,(Camera_stored_min_Y_pos).w
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  (Camera_min_X_pos).w,(Camera_stored_min_X_pos).w
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  (a1)+,(_unkFAB0).w
                move.w  (a1)+,(_unkFAB2).w
                move.w  (a1)+,(_unkFAB4).w
                move.w  (a1)+,(_unkFAB6).w
                rts
; End of function Boss_BeginCameraTransition
