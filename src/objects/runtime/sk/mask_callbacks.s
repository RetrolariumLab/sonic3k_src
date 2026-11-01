; Owner: objects/runtime/sk
; Responsibility: Sprite mask actors, facing or parent-state helpers and second-player input locking callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SpriteMask:
                bset    #2,render_flags(a0)

loc_862B4:
                clr.w   art_tile(a0)
                move.l  #Map_SpriteMask,mappings(a0)
                move.b  #$20,width_pixels(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.l  #loc_862FE,(a0)
                btst    #3,d0
                beq.s   loc_862DE
                move.l  #loc_86308,(a0)

loc_862DE:
                move.w  d0,d1
                andi.w  #$F0,d0
                lsr.w   #2,d0
                move.b  d0,height_pixels(a0)
                lsr.w   #2,d0
                move.b  d0,mapping_frame(a0)
                andi.w  #7,d1
                add.w   d1,d1
                move.w  word_86324(pc,d1.w),priority(a0)
                rts
; ---------------------------------------------------------------------------

loc_862FE:
                st      (Spritemask_flag).w
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_86308:
                st      (Spritemask_flag).w
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.s   loc_8631E
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8631E:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
word_86324:
                dc.w    0,   $80,  $100,  $180,  $200,  $280,  $300,  $380
; ---------------------------------------------------------------------------

loc_86334:
                move.w  #(button_right_mask<<8)|button_right_mask,d0
                tst.w   $2E(a0)
                beq.s   loc_86346
                subq.w  #1,$2E(a0)
                move.w  #((button_A_mask|button_right_mask)<<8)|button_right_mask,d0

loc_86346:
                btst    #5,(Player_1+status).w
                beq.s   loc_86358
                move.w  #$1F,$2E(a0)
                move.w  #((button_A_mask|button_right_mask)<<8)|(button_A_mask|button_right_mask),d0

loc_86358:
                move.w  d0,(Ctrl_1_logical).w
                rts

; =============== S U B R O U T I N E =======================================

LaunchPlayerWithSpringVelocity:
                move.w  d0,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #$10,anim(a1)
                move.b  #2,routine(a1)
                moveq   #signextendB(sfx_Spring),d0
                jmp     (Play_SFX).l
; End of function LaunchPlayerWithSpringVelocity

; =============== S U B R O U T I N E =======================================

FacePlayersTowardObject:
                lea     (Player_1).w,a1
                bsr.w   FacePlayerTowardObject
                lea     (Player_2).w,a1
                tst.b   render_flags(a1)
                bpl.s   locret_863BE
; End of function FacePlayersTowardObject

; =============== S U B R O U T I N E =======================================

FacePlayerTowardObject:
                move.w  x_pos(a0),d0
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                cmp.w   x_pos(a1),d0
                bhs.s   locret_863BE
                bset    #0,render_flags(a1)
                bset    #Status_Facing,status(a1)

locret_863BE:
                rts
; End of function FacePlayerTowardObject

; ---------------------------------------------------------------------------

loc_863C0:
                tst.l   (Player_2).w
                beq.s   loc_863E6
                move.b  #1,(Ctrl_2_locked).w
                clr.w   (Tails_CPU_idle_timer).w
                move.l  #loc_863D6,(a0)

loc_863D6:
                tst.b   (Ctrl_2_locked).w
                beq.s   loc_863E2
                clr.w   (Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

loc_863E2:
                clr.w   (Ctrl_2).w

loc_863E6:
                jmp     (Delete_Current_Sprite).l
; End of function loc_863C0
