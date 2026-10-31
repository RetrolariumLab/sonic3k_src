; Owner: objects/zones/soz/sk
; Responsibility: Sandopolis darkness-dependent ghost controller, ghost body attack states and disappearance animation
; Source provenance and ranges: config/reconstruction/source_layout.json

; ' <-- lol TextWrangler; it assumes ' is the string delimiter for all assembly files; I don't want
; my screen to be filled with pink
; ---------------------------------------------------------------------------

; original label: gost08
; Obj_SOZGhosts:
Hyudoro:
                move.l  #Hyudoro_ctr,(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$A0,y_pos(a0)

; loc_8F0CA:
Hyudoro_ctr:
                cmpi.b  #2,(Player_1+character_id).w    ; Is the player character Knuckles?
                beq.s   ._100
                tst.b   (Last_star_post_hit).w
                beq.w   return

; loc_8F0DA:
                ._100:
                moveq   #0,d0
                move.b  (SOZ_darkness_level).w,d0
                beq.s   .clr_ret
                move.b  .cnt_tbl(pc,d0.w),d0
                move.b  (Hyudoro_count).w,d1
                cmp.b   d0,d1
                bhs.w   return
                subq.w  #1,$3A(a0)
                bpl.w   return
                addq.b  #1,d1
                move.b  d1,(Hyudoro_count).w
                cmp.b   d0,d1
                bhs.s   ._200
                move.w  #$3F,$3A(a0)

; loc_8F108:
                ._200:
                lea     Hyudoro_body_set_tbl(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

; loc_8F112:
                .clr_ret:
                clr.b   (Hyudoro_count).w
                rts
; ---------------------------------------------------------------------------

; byte_8F118:
                .cnt_tbl:
                dc.b    0,   1,   2,   2,   3,   3
                even
; ---------------------------------------------------------------------------

; loc_8F11E:
Hyudoro_body:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  .act_tbl(pc,d0.w),d1
                jsr     .act_tbl(pc,d1.w)
                lea     Hyudoro_DPLC_tbl(pc),a2
                jsr     (Perform_DPLC).l
                tst.b   render_flags(a0)
                bpl.s   .fout0
                tst.b   (SOZ_darkness_level).w
                beq.s   .fout1
                jsr     (Check_PlayerCollision).l
                beq.s   ._100
                jsr     (Check_PlayerAttack).l
                bne.s   .fout1
                tst.b   invulnerability_timer(a1)
                bne.s   ._100
                jsr     (HurtCharacter_Directly).l

; loc_8F15E:
                ._100:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; loc_8F16A:
                .fout0:
                subq.b  #1,(Hyudoro_count).w
                jmp     (Go_Delete_SpriteSlotted2).l
; ---------------------------------------------------------------------------

; loc_8F174:
                .fout1:
                move.l  #Hyudoro_body_fout0,(a0)
                move.l  #.fout0,$34(a0)
                lea     Hyudoro_away_pg00(pc),a1
                jsr     (Set_Raw_Animation).l
                moveq   #signextendB(sfx_Bouncy),d0
                jsr     (Play_SFX).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

; off_8F19A:
                .act_tbl:
                dc.w    Hyudoro_init-.act_tbl
                dc.w    Hyudoro_wait0-.act_tbl
                dc.w    Hyudoro_move0-.act_tbl
                dc.w    Hyudoro_chg0-.act_tbl
                dc.w    Hyudoro_chg1-.act_tbl
                dc.w    Hyudoro_chg2-.act_tbl
                dc.w    Hyudoro_atak0-.act_tbl
                dc.w    Hyudoro_atak1-.act_tbl
                dc.w    Hyudoro_atak2-.act_tbl
; ---------------------------------------------------------------------------

; loc_8F1AC:
Hyudoro_init:
                lea     Hyudoro_init_tbl(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                bclr    #2,render_flags(a0)
                bset    #7,render_flags(a0)
                move.b  (SOZ_darkness_level).w,child_dx(a0)
                move.b  (Hyudoro_count).w,child_dy(a0)
                bsr.w   set_Hyudoro_body_init
                moveq   #signextendB(sfx_GhostAppear),d0
                jsr     (Play_SFX).l

; loc_8F1DA:
Hyudoro_wait0:
                jsr     (Animate_RawMultiDelay).l
                tst.w   d2
                beq.s   .ret
                cmpi.b  #5,(SOZ_darkness_level).w
                beq.s   Hyudoro_atak_init
                move.b  #4,routine(a0)

; locret_8F1F2:
                .ret:
                rts
; ---------------------------------------------------------------------------

; loc_8F1F4:
Hyudoro_atak_init:
                move.b  #$C,routine(a0)
                bra.w   set_puka_init
; ---------------------------------------------------------------------------

; loc_8F1FE:
Hyudoro_move0:
                jsr     (Animate_RawMultiDelay).l
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                bsr.w   chk_Hyudoro_limit
                move.b  (SOZ_darkness_level).w,d0
                cmp.b   child_dx(a0),d0
                beq.s   .ret

                .next:
                move.b  #6,routine(a0)

; locret_8F224:
                .ret:
                rts
; ---------------------------------------------------------------------------

; loc_8F226:
Hyudoro_chg0:
                jsr     (Animate_RawMultiDelay).l
                jsr     (Swing_UpAndDown).l
                tst.w   d3
                bne.s   .next
                jsr     (MoveSprite2).l
                bra.w   chk_Hyudoro_limit
; ---------------------------------------------------------------------------

; loc_8F240:
                .next:
                move.b  #8,routine(a0)
                moveq   #0,d0
                move.b  (SOZ_darkness_level).w,d0
                move.b  .chk_puka_tbl(pc,d0.w),d1
                beq.w   return
                move.b  d0,child_dx(a0)
                cmpi.b  #5,d0
                beq.s   Hyudoro_atak_init
                move.b  #4,routine(a0)
                bra.w   set_puka_init
; ---------------------------------------------------------------------------

; byte_8F268:
                .chk_puka_tbl:
                dc.b    0,   0,   0,   1,   0,   1
                even
; ---------------------------------------------------------------------------

; loc_8F26E:
Hyudoro_chg1:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                bsr.w   chk_Hyudoro_limit
                jsr     (Animate_RawMultiDelay).l
                beq.s   .ret
                cmpi.b  #2,anim_frame(a0)
                bne.s   .ret

                .next:
                move.b  #$A,routine(a0)
                move.b  (SOZ_darkness_level).w,d0
                move.b  d0,child_dx(a0)
                add.w   d0,d0
                andi.w  #$C,d0
                movea.l .pg_tbl(pc,d0.w),a1
                move.b  (a1),mapping_frame(a0)
                jsr     (Set_Raw_Animation).l

; locret_8F2B0:
                .ret:
                rts
; ---------------------------------------------------------------------------

; off_8F2B2:
                .pg_tbl:
                dc.l    Hyudoro_chg_pg00
                dc.l    Hyudoro_chg_pg00
                dc.l    Hyudoro_chg_pg01
; ---------------------------------------------------------------------------

; loc_8F2BE:
Hyudoro_chg2:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                bsr.w   chk_Hyudoro_limit
                jsr     (Animate_RawMultiDelay).l
                tst.w   d2
                beq.s   .ret

                .next:
                move.b  #4,routine(a0)

; locret_8F2DE:
                .ret:
                rts
; ---------------------------------------------------------------------------

; loc_8F2E0:
Hyudoro_atak0:
                jsr     (Animate_RawMultiDelay).l
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  x_pos(a0),d0
                tst.w   x_vel(a0)
                bmi.s   .chk_l

                .chk_r:
                cmpi.w  #$1A0,d0
                bhi.s   .neg
                rts
; ---------------------------------------------------------------------------

; loc_8F304:
                .chk_l:
                cmpi.w  #$A0,d0
                bhs.s   .ret

; loc_8F30A:
                .neg:
                move.b  #$E,routine(a0)
                bchg    #0,render_flags(a0)
                neg.w   x_vel(a0)
                move.w  #60-1,$2E(a0)

; locret_8F320:
                .ret:
                rts
; ---------------------------------------------------------------------------

; loc_8F322:
Hyudoro_atak1:
                jsr     (Animate_RawMultiDelay).l
                subq.w  #1,$2E(a0)
                bpl.w   return

                .next:
                move.b  #$10,routine(a0)
                move.b  #$D7,collision_flags(a0)
                bset    #2,render_flags(a0)
                move.w  (Camera_X_pos).w,d0
                move.w  x_pos(a0),d1
                subi.w  #$80,d1
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                move.w  y_pos(a0),d1
                subi.w  #$80,d1
                add.w   d1,d0
                move.w  d0,y_pos(a0)
                move.w  #$100,y_vel(a0)

                .ret:
                rts
; ---------------------------------------------------------------------------

; loc_8F36E:
Hyudoro_atak2:
                jsr     (Animate_RawMultiDelay).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

; loc_8F37A:
Hyudoro_body_fout0:
                jsr     (Animate_RawMultiDelay).l
                lea     Hyudoro_DPLC_tbl(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
