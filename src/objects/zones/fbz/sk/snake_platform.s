; Owner: objects/zones/fbz/sk
; Responsibility: Snake platform initialization, wait and movement states, restart and player riding
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZSnakePlatform:
                moveq   #$19,d2
                moveq   #3-1,d1

loc_3B538:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_3B556
                move.l  #Obj_FBZSnakePlatformMain,(a1)
                move.b  d2,anim_frame_timer(a1)
                addi.b  #$18,d2
                move.b  subtype(a0),subtype(a1)

loc_3B556:
                dbf     d1,loc_3B538
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
                bne.s   loc_3B60E
                move.l  #Obj_FBZSnakePlatformMove,(a0)

Obj_FBZSnakePlatformMove:
                move.w  x_pos(a0),-(sp)
                jsr     (MoveSprite2).l
                movea.l $30(a0),a2
                move.w  (a2)+,d0
                cmp.w   x_pos(a0),d0
                bne.s   loc_3B5FA
                move.w  (a2)+,d0
                cmp.w   y_pos(a0),d0
                bne.s   loc_3B5FA
                bsr.w   FBZSnake_ChangeDir

loc_3B5FA:
                move.w  (sp)+,d4

loc_3B5FC:
                move.w  #$17,d1
                move.w  #$C,d2
                move.w  #$D,d3
                jsr     (SolidObjectFull).l

loc_3B60E:
                move.w  $34(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmp.w   $36(a0),d0
                bhi.w   loc_3B628
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_3B628:
                move.w  respawn_addr(a0),d0
                beq.s   loc_3B634
                movea.w d0,a2
                bclr    #7,(a2)

loc_3B634:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_FBZSnakePlatformStopRestart:
                move.w  x_pos(a0),d4
                subq.w  #1,$38(a0)
                bne.s   loc_3B5FC
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
                bmi.s   loc_3B6A0
                move.w  (a2)+,d5
                move.w  #$140,d0
                cmp.w   x_pos(a0),d4
                beq.s   loc_3B680
                bcc.s   loc_3B674
                neg.w   d0

loc_3B674:
                move.w  d0,x_vel(a0)
                move.w  #0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_3B680:
                cmp.w   y_pos(a0),d5
                beq.s   loc_3B696
                bcc.s   loc_3B68A
                neg.w   d0

loc_3B68A:
                move.w  #0,x_vel(a0)
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_3B696:
                move.w  d0,x_vel(a0)
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_3B6A0:
                move.w  (a2),d0
                beq.s   loc_3B6AE
                move.w  d0,$38(a0)
                move.l  #Obj_FBZSnakePlatformStopRestart,(a0)

loc_3B6AE:
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
                include "src/objects/shared/zones/fbz/map_snake_platform.s"
