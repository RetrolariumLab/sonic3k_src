; Owner: objects/level_end/s3
; Responsibility: Restore player control, create and sequence the end sign, and wait for camera transition conditions
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
                bclr    #7,render_flags(a0)
                bset    #4,$38(a0)
                move.w  #$7F,$2E(a0)
                move.l  #Obj_EndSignControlDoSign,$34(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                rts
; End of function Obj_EndSignControl

; ---------------------------------------------------------------------------
PLC_EndSignStuff:   plrlistheader
                plreq   ArtTile_SignpostStub, ArtNem_SignpostStub
                plreq   ArtTile_Monitors, ArtNem_Monitors
PLC_EndSignStuff_End:
; ---------------------------------------------------------------------------

Obj_EndSignControlWait:
                bclr    #7,render_flags(a0)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Obj_EndSignControlDoSign:
                move.l  #Obj_EndSignControlAwaitStart,(a0)
                clr.b   (Boss_flag).w
                jsr     Restore_LevelMusic(pc)
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
                bne.w   S3RuntimeChildren_ReturnAfterAttributeSetupOrSharedEarlyExit
                move.l  #Obj_EndSignControlDoStart,(a0)
                jsr     Restore_PlayerControl(pc)
                lea     (Player_2).w,a1
                jmp     Restore_PlayerControl2(pc)
; ---------------------------------------------------------------------------

Obj_EndSignControlDoStart:
                tst.b   (End_of_level_flag).w           ; Wait for title card to finish
                beq.w   S3RuntimeChildren_ReturnAfterAttributeSetupOrSharedEarlyExit
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
                blo.s   loc_54198
                cmp.w   (a1)+,d0
                bhi.s   loc_54198
                move.w  (Camera_X_pos).w,d1
                cmp.w   (a1)+,d1
                blo.s   loc_54198
                cmp.w   (a1)+,d1
                bhi.s   loc_54198
                move.l  (sp),(a0)
                rts
; ---------------------------------------------------------------------------

loc_54198:
                jsr     (Delete_Sprite_If_Not_In_Range).l
                addq.w  #4,sp
                rts
; End of function Check_CameraInRange

; ---------------------------------------------------------------------------

loc_541A2:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                move.w  (Camera_target_max_Y_pos).w,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                blo.s   locret_541C6
                move.w  d0,(Camera_min_Y_pos).w
                move.w  $3A(a0),d0
                cmp.w   (Camera_X_pos).w,d0
                bhi.s   locret_541C6
                movea.l $34(a0),a1
                jsr     (a1)

locret_541C6:
                rts
; ---------------------------------------------------------------------------

loc_541C8:
                btst    #0,$38(a0)
                bne.s   loc_541E6
                subq.w  #1,$2E(a0)
                bpl.s   loc_541E6
                move.b  $26(a0),d0
                jsr     (Play_Music).l
                bset    #0,$38(a0)

loc_541E6:
                btst    #1,$38(a0)
                bne.s   loc_54202
                move.w  (Camera_target_max_Y_pos).w,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                bne.s   loc_54202
                move.w  d0,(Camera_min_Y_pos).w
                bset    #1,$38(a0)

loc_54202:
                btst    #2,$38(a0)
                bne.s   loc_54220
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                move.w  $1C(a0),d0
                cmp.w   (Camera_X_pos).w,d0
                bhi.s   loc_54220
                bset    #2,$38(a0)

loc_54220:
                move.b  $38(a0),d0
                andi.b  #7,d0
                cmpi.b  #7,d0
                bne.w   S3RuntimeChildren_ReturnAfterAttributeSetupOrSharedEarlyExit
                clr.b   $38(a0)
                clr.w   $1C(a0)
                clr.b   $26(a0)
                movea.l $34(a0),a1
                jmp     (a1)
