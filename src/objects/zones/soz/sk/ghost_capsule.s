; Owner: objects/zones/soz/sk
; Responsibility: Sandopolis ghost capsule, switch, ghost release, stage setup and related graphics selection
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

; Obj_SOZGhostCapsuleLoadArt:
set_SOZ_capsule_Hyudoro_cg:
                moveq   #0,d0
                move.b  subtype(a0),d0
                movea.l .col_tbl(pc,d0.w),a1
                jsr     (Check_PlayerInRange).l
                tst.l   d0
                beq.w   return
                tst.w   d0
                beq.w   return
                moveq   #0,d0
                move.b  subtype(a0),d0
                movea.l .jmp_tbl(pc,d0.w),a1
                jsr     (a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

; off_8F3BE:
                .col_tbl:
                dc.l    col_tbl_00
                dc.l    col_tbl_04

; off_8F3C6:
                .jmp_tbl:
                dc.l    set_soz_capsule_cg
                dc.l    set_soz_enemy_cg

; word_8F3CE:
col_tbl_00:
                dc.w    -$10,   $20,  -$40,   $80

; word_8F3D6:
col_tbl_04:
                dc.w    -$10,   $20,  -$80,  $100
; ---------------------------------------------------------------------------

; original label: set_openbox_cg
; loc_8F3DE:
set_soz_capsule_cg:
                lea     PLC_SOZGhostCapsule(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

PLC_SOZGhostCapsule:    plrlistheader
                plreq   ArtTile_SOZGhostCapsule, ArtNem_EggCapsule
PLC_SOZGhostCapsule_End:
; ---------------------------------------------------------------------------

; original label: set_emy08_cg
; loc_8F3F0:
set_soz_enemy_cg:
                jmp     (LoadEnemyArt).l
; ---------------------------------------------------------------------------

; original label: obox08
; Obj_SOZGhostCapsule:
SOZ_capsule:
                lea     SOZ_capsule_init_tbl(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKFBZEggPrison_CheckButtonAndSaveOpened,(a0)
                move.b  #3,subtype(a0)
                lea     SOZ_capsule_switch_set_tbl(pc),a2
                jsr     (CreateChild1_Normal).l
                tst.b   (Last_star_post_hit).w
                bne.s   .UseOpenedCapsule
                cmpi.b  #2,(Player_1+character_id).w    ; Is the player character Knuckles?
                bne.s   return

; loc_8F424:
                .UseOpenedCapsule:
                move.l  #FBZEggPrisonSK_ResolveSolidThenTouchCull,(a0)
                move.b  #1,mapping_frame(a0)
                bset    #5,$38(a0)

; locret_8F436:
return:
                rts
; ---------------------------------------------------------------------------

; loc_8F438:
SOZ_capsule_switch:
                lea     (SKCapsule_SharedButtonPartialAttributes).l,a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKEggCapsule_CheckGroundButtonPress,(a0)
                tst.b   (Last_star_post_hit).w
                beq.s   .ret
                move.l  #SKEggCapsule_DrawPressedGroundButton,(a0)
                move.b  #$C,mapping_frame(a0)

; locret_8F45C:
                .ret:
                rts
; ---------------------------------------------------------------------------

; loc_8F45E:
SOZ_capsule_Hyudoro:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  .act_tbl(pc,d0.w),d1
                jsr     .act_tbl(pc,d1.w)
                tst.b   subtype(a0)
                bne.s   .CullReleasedGhost
                lea     Hyudoro_DPLC_tbl(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteSlotted).l
; ---------------------------------------------------------------------------

; loc_8F482:
                .CullReleasedGhost:
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

; off_8F488:
                .act_tbl:
                dc.w    SOZ_capsule_Hyudoro_init-.act_tbl
                dc.w    SOZ_capsule_Hyudoro_move0-.act_tbl
                dc.w    SOZ_capsule_Hyudoro_move1-.act_tbl
; ---------------------------------------------------------------------------

; loc_8F48E:
SOZ_capsule_Hyudoro_init:
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     .spd_tbl(pc,d0.w),a1
                move.w  (a1)+,x_vel(a0)
                move.w  (a1)+,$40(a0)
                jsr     (Change_FlipXWithVelocity).l
                tst.w   d0
                bne.s   .InitOtherGhostChild
                lea     Hyudoro_init_tbl(pc),a1
                jmp     (SetUp_ObjAttributesSlotted).l
; ---------------------------------------------------------------------------

; loc_8F4B6:
                .InitOtherGhostChild:
                lea     SOZ_capsule_Hyudoro_init_tbl(pc),a1
                jmp     (SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

; word_8F4C0:
                .spd_tbl:
                dc.w    -$200,  -$20
                dc.w    $200,  -$20
                dc.w    -$280,  -$18
                dc.w    $280,  -$18
                dc.w    -$300,  -$10
                dc.w    $300,  -$10
; ---------------------------------------------------------------------------

; loc_8F4D8:
SOZ_capsule_Hyudoro_move0:
                lea     Hyudoro_pg00(pc),a1
                jsr     (Animate_RawNoSST).l

; loc_8F4E2:
SOZ_capsule_Hyudoro_move1:
                move.w  $40(a0),d0
                add.w   d0,y_vel(a0)
                jmp     (MoveSprite2).l

; =============== S U B R O U T I N E =======================================

; sub_8F4F0:
chk_Hyudoro_limit:
                move.w  x_pos(a0),d0
                tst.w   x_vel(a0)
                bmi.s   .chk_l

                .chk_r:
                cmpi.w  #$1A0,d0
                bhi.s   .neg
                rts
; ---------------------------------------------------------------------------

; loc_8F502:
                .chk_l:
                cmpi.w  #$A0,d0
                bhs.s   .ret

; loc_8F508:
                .neg:
                bchg    #0,render_flags(a0)
                neg.w   x_vel(a0)

; locret_8F512:
                .ret:
                rts
; ---------------------------------------------------------------------------

; loc_8F514:
set_Hyudoro:
                move.b  #1,(Last_star_post_hit).w
                lea     (SOZ2_Start).l,a1
                move.w  (a1)+,(Saved_X_pos).w
                move.w  (a1)+,(Saved_Y_pos).w
                jsr     (Save_Level_Data).l
                lea     SOZ_capsule_Hyudoro_set_tbl(pc),a2
                jmp     (CreateChild1_Normal).l
