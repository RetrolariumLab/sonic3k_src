; Owner: objects/zones/fbz/sk
; Responsibility: Snake platform initialization, wait and movement states, restart and player riding
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZSnakePlatform:
                moveq   #$19,d2
                moveq   #3-1,d1

SKFBZSnakePlat_TrySpawnDelayedMember:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKFBZSnakePlat_NextAttemptOrInitRoot
                move.l  #Obj_FBZSnakePlatformMain,(a1)
                move.b  d2,anim_frame_timer(a1)
                addi.b  #$18,d2
                move.b  subtype(a0),subtype(a1)

SKFBZSnakePlat_NextAttemptOrInitRoot:
                dbf     d1,SKFBZSnakePlat_TrySpawnDelayedMember
                move.b  #1,anim_frame_timer(a0)
                move.l  #Obj_FBZSnakePlatformMain,(a0)

Obj_FBZSnakePlatformMain:
                move.l  #Map_FBZSnakePlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$F2,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.w  #$280,priority(a0)
                bset    #7,status(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                add.w   d0,d0
                add.w   d0,d0
                lea     (FBZSnakePlatform_Data).l,a2
                movea.l (a2,d0.w),a2
                move.w  (a2)+,d1
                move.w  (a2)+,d0
                move.w  d0,$34(a0)
                sub.w   d1,d0
                andi.w  #$FF80,d0
                addi.w  #$300,d0
                move.w  d0,$36(a0)
                move.l  a2,$30(a0)
                bsr.w   FBZSnake_ChangeDir
                move.l  #Obj_FBZSnakePlatformWait,(a0)

Obj_FBZSnakePlatformWait:
                subq.b  #1,anim_frame_timer(a0)
                bne.s   SKFBZSnakePlat_DrawFromRouteAnchor
                move.l  #Obj_FBZSnakePlatformMove,(a0)

Obj_FBZSnakePlatformMove:
                move.w  x_pos(a0),-(sp)
                jsr     (MoveSprite2).l
                movea.l $30(a0),a2
                move.w  (a2)+,d0
                cmp.w   x_pos(a0),d0
                bne.s   SKFBZSnakePlat_RestoreOldX
                move.w  (a2)+,d0
                cmp.w   y_pos(a0),d0
                bne.s   SKFBZSnakePlat_RestoreOldX
                bsr.w   FBZSnake_ChangeDir

SKFBZSnakePlat_RestoreOldX:
                move.w  (sp)+,d4

SKFBZSnakePlat_ResolveRouteSolid:
                move.w  #$17,d1
                move.w  #$C,d2
                move.w  #$D,d3
                jsr     (SolidObjectFull).l

SKFBZSnakePlat_DrawFromRouteAnchor:
                move.w  $34(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmp.w   $36(a0),d0
                bhi.w   SKFBZSnakePlat_ClearRespawnBit
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKFBZSnakePlat_ClearRespawnBit:
                move.w  respawn_addr(a0),d0
                beq.s   SKFBZSnakePlat_DeleteOutOfRange
                movea.w d0,a2
                bclr    #7,(a2)

SKFBZSnakePlat_DeleteOutOfRange:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_FBZSnakePlatformStopRestart:
                move.w  x_pos(a0),d4
                subq.w  #1,$38(a0)
                bne.s   SKFBZSnakePlat_ResolveRouteSolid
                move.l  #Obj_FBZSnakePlatformMove,(a0)
                bra.s   Obj_FBZSnakePlatformMove

; =============== S U B R O U T I N E =======================================

FBZSnake_ChangeDir:
                movea.l $30(a0),a2
                move.w  (a2)+,d4
                move.w  d4,x_pos(a0)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a0)
                move.l  a2,$30(a0)
                move.w  (a2)+,d4
                bmi.s   SKFBZSnakePlat_ReadRouteRestartDelay
                move.w  (a2)+,d5
                move.w  #$140,d0
                cmp.w   x_pos(a0),d4
                beq.s   SKFBZSnakePlat_PickVerticalOrDiagonal
                bcc.s   SKFBZSnakePlat_SetHorizontalSpeed
                neg.w   d0

SKFBZSnakePlat_SetHorizontalSpeed:
                move.w  d0,x_vel(a0)
                move.w  #0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKFBZSnakePlat_PickVerticalOrDiagonal:
                cmp.w   y_pos(a0),d5
                beq.s   SKFBZSnakePlat_SetDiagonalSpeed
                bcc.s   SKFBZSnakePlat_SetVerticalSpeed
                neg.w   d0

SKFBZSnakePlat_SetVerticalSpeed:
                move.w  #0,x_vel(a0)
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

; Identical waypoint coordinates set both speed components
SKFBZSnakePlat_SetDiagonalSpeed:
                move.w  d0,x_vel(a0)
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

SKFBZSnakePlat_ReadRouteRestartDelay:
                move.w  (a2),d0
                beq.s   SKFBZSnakePlat_RestartSubtypeRoute
                move.w  d0,$38(a0)
                move.l  #Obj_FBZSnakePlatformStopRestart,(a0)

SKFBZSnakePlat_RestartSubtypeRoute:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                add.w   d0,d0
                add.w   d0,d0
                lea     (FBZSnakePlatform_Data).l,a2
                movea.l (a2,d0.w),a2
                addq.w  #4,a2
                move.l  a2,$30(a0)
                bra.w   FBZSnake_ChangeDir
; End of function FBZSnake_ChangeDir

; ---------------------------------------------------------------------------
Map_FBZSnakePlatform:
                include "src/objects/shared/zones/fbz/mappings/snake_platform.s"
