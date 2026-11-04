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
                beq.s   LBZBossSK_HitUpdateReturn
                tst.b   collision_flags(a0)
                bne.s   LBZBossSK_HitUpdateReturn
                tst.b   collision_property(a0)
                beq.s   LBZBossSK_BeginDefeatEscape
                tst.b   $20(a0)
                bne.s   LBZBossSK_HitChooseFlashColor
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

LBZBossSK_HitChooseFlashColor:
                bset    #6,status(a0)
                lea     (Normal_palette_line_2+$16).w,a1
                move.w  #$222,d0
                btst    #0,$20(a0)
                bne.s   LBZBossSK_HitWriteColorAndTick
                move.w  #$EEE,d0

LBZBossSK_HitWriteColorAndTick:
                move.w  d0,(a1)
                subq.b  #1,$20(a0)
                bne.s   LBZBossSK_HitUpdateReturn
                bclr    #6,status(a0)
                move.w  #$222,(a1)
                move.b  $25(a0),collision_flags(a0)

LBZBossSK_HitUpdateReturn:
                rts
; ---------------------------------------------------------------------------

LBZBossSK_BeginDefeatEscape:
                move.l  #LBZBossSK_EscapeMoveAndDraw,(a0)
                clr.b   (Update_HUD_timer).w
                moveq   #100,d0
                jsr     (HUD_AddToScore).l
                bclr    #7,render_flags(a0)
                move.w  #$7F,$2E(a0)
                bset    #4,$38(a0)
                move.w  #make_art_tile(ArtTile_LBZEndBoss,1,1),art_tile(a0)
                move.w  #-$200,y_vel(a0)
                move.l  #LBZBossSK_FinishEscapeAndRestoreMusic,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   LBZBossSK_ExpandRightCameraBound
                move.b  #4,subtype(a1)

LBZBossSK_ExpandRightCameraBound:
                move.w  #$3AB8,(Camera_stored_max_X_pos).w
                lea     (Child6_IncLevX).l,a2
                jmp     (CreateChild6_Simple).l
; End of function HandleLBZEndBossSingleColorHitOrEscape

; ---------------------------------------------------------------------------

LBZBossSK_PlatformDrawOrBreakAway:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   LBZBossSK_PlatformDetachAndRelease
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

LBZBossSK_PlatformDetachAndRelease:
                move.l  #MoveChkDel,(a0)
                bset    #7,status(a0)
                move.w  #make_art_tile(ArtTile_LBZEndBoss,1,1),art_tile(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  LBZBossSK_PlatformDefeatXSpeeds(pc,d0.w),x_vel(a0)
                move.w  #-$200,y_vel(a0)
                jsr     (Displace_PlayerOffObject).l
                lea     (Player_2).w,a1
                bclr    #Status_RollJump,status(a1)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
LBZBossSK_PlatformDefeatXSpeeds:
                dc.w    $300,  $200, -$200, -$300
