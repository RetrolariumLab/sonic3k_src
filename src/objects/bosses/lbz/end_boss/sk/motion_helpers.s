; Owner: objects/bosses/lbz/end_boss/sk
; Responsibility: Launch Base end-boss motion, parent synchronization and private lookup helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

MoveAndSolidifyLBZEndBossTopPlatform:
                move.w  x_pos(a0),-(sp)
                jsr     (a2)
                moveq   #$12,d1
                moveq   #7,d2
                moveq   #7,d3
                move.w  (sp)+,d4
                jmp     (SolidObjectTop).l
; End of function MoveAndSolidifyLBZEndBossTopPlatform

; =============== S U B R O U T I N E =======================================

HandleLBZEndBossSingleColorHitOrEscape:
                tst.l   (a0)
                beq.s   locret_74038
                tst.b   collision_flags(a0)
                bne.s   locret_74038
                tst.b   collision_property(a0)
                beq.s   loc_7403A
                tst.b   $20(a0)
                bne.s   loc_74006
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_74006:
                bset    #6,status(a0)
                lea     (Normal_palette_line_2+$16).w,a1
                move.w  #$222,d0
                btst    #0,$20(a0)
                bne.s   loc_74020
                move.w  #$EEE,d0

loc_74020:
                move.w  d0,(a1)
                subq.b  #1,$20(a0)
                bne.s   locret_74038
                bclr    #6,status(a0)
                move.w  #$222,(a1)
                move.b  $25(a0),collision_flags(a0)

locret_74038:
                rts
; ---------------------------------------------------------------------------

loc_7403A:
                move.l  #loc_73A52,(a0)
                clr.b   (Update_HUD_timer).w
                moveq   #100,d0
                jsr     (HUD_AddToScore).l
                bclr    #7,render_flags(a0)
                move.w  #$7F,$2E(a0)
                bset    #4,$38(a0)
                move.w  #make_art_tile(ArtTile_LBZEndBoss,1,1),art_tile(a0)
                move.w  #-$200,y_vel(a0)
                move.l  #loc_73A6A,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_74086
                move.b  #4,subtype(a1)

loc_74086:
                move.w  #$3AB8,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; End of function HandleLBZEndBossSingleColorHitOrEscape

; ---------------------------------------------------------------------------

loc_74098:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_740AA
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_740AA:
                move.l  #MoveChkDel,(a0)
                bset    #7,status(a0)
                move.w  #make_art_tile(ArtTile_LBZEndBoss,1,1),art_tile(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_740E4(pc,d0.w),x_vel(a0)
                move.w  #-$200,y_vel(a0)
                jsr     (Displace_PlayerOffObject).l
                lea     (Player_2).w,a1
                bclr    #Status_RollJump,status(a1)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_740E4:
                dc.w    $300,  $200, -$200, -$300
