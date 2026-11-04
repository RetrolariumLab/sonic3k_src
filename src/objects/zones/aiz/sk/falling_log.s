; Owner: objects/zones/aiz/sk
; Responsibility: Angel Island falling log motion, water splash fragments and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
SKFallingLog_PeriodMasks:
                dc.w    1
                dc.w    3
                dc.w    7
                dc.w    $F
                dc.w    $1F
                dc.w    $3F
                dc.w    $7F
                dc.w    $FF
                dc.w    $1FF
                dc.w    $3FF
                dc.w    $7FF
                dc.w    $FFF
                dc.w    $1FFF
                dc.w    $3FFF
                dc.w    $7FFF
                dc.w    $FFFF
; ---------------------------------------------------------------------------

Obj_AIZFallingLog:
                cmpi.w  #$26B0,x_pos(a0)
                beq.s   SKFallingLog_TryDeleteTriggeredSpawner
                cmpi.w  #$2700,x_pos(a0)
                bne.s   SKFallingLog_PickSpawnPeriodAndShift

SKFallingLog_TryDeleteTriggeredSpawner:
                tst.b   (Level_trigger_array).w
                beq.s   SKFallingLog_PickSpawnPeriodAndShift
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKFallingLog_PickSpawnPeriodAndShift:
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F,d0
                move.w  d0,d2
                add.w   d0,d0
                move.w  SKFallingLog_PeriodMasks(pc,d0.w),$32(a0)
                subq.w  #3,d2
                bcc.s   SKFallingLog_StartTimedSpawner
                moveq   #0,d2

SKFallingLog_StartTimedSpawner:
                lsr.w   #4,d1
                andi.w  #$F,d1
                lsl.w   d2,d1
                move.w  d1,$34(a0)
                move.b  #4,render_flags(a0)
                move.l  #SKFallingLog_TrySpawnAtPhaseZero,(a0)

SKFallingLog_TrySpawnAtPhaseZero:
                move.w  (Level_frame_counter).w,d0
                add.w   $34(a0),d0
                and.w   $32(a0),d0
                bne.w   SKFallingLog_CullSpawner
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKFallingLog_CullSpawner
                move.l  #SKFallingLog_FallToWater,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_AIZFallingLog2,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,0),art_tile(a1)
                tst.b   (Current_act).w
                bne.s   SKFallingLog_FinishLogAndTrySplash
                move.l  #Map_AIZFallingLog,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZFallingLog,2,0),art_tile(a1)

SKFallingLog_FinishLogAndTrySplash:
                move.b  #$18,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.b  #4,render_flags(a1)
                move.w  #$280,priority(a1)
                movea.l a1,a2
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKFallingLog_CullSpawner
                move.l  #SKFallingLog_FollowAndAnimateSplash,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_AIZFallingLogSplash2,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZMisc2,3,0),art_tile(a1)
                tst.b   (Current_act).w
                bne.s   SKFallingLog_InitSplashAndLinkPair
                move.l  #Map_AIZFallingLogSplash,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZFallingLog,2,0),art_tile(a1)

SKFallingLog_InitSplashAndLinkPair:
                move.b  #$20,width_pixels(a1)
                move.b  #$10,height_pixels(a1)
                move.b  #4,render_flags(a1)
                move.w  #$200,priority(a1)
                move.w  a2,$3C(a1)
                move.w  a1,$3C(a2)

SKFallingLog_CullSpawner:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKFallingLog_FallToWater:
                addq.w  #1,y_pos(a0)
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.s   SKFallingLog_UpdateAfterFall
                move.l  #SKFallingLog_TickFloatLifetime,(a0)
                move.b  #60-1,anim_frame_timer(a0)

SKFallingLog_UpdateAfterFall:
                bra.s   SKFallingLog_CheckTopSolidAndDraw
; ---------------------------------------------------------------------------

SKFallingLog_TickFloatLifetime:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKFallingLog_TickFloatBlink
                move.w  #$7FF0,x_pos(a0)

SKFallingLog_TickFloatBlink:
                move.b  anim_frame_timer(a0),d0
                andi.b  #3,d0
                bne.s   SKFallingLog_CheckTopSolidAndDraw
                bchg    #0,$36(a0)

SKFallingLog_CheckTopSolidAndDraw:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #8,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   SKFallingLog_TryDeleteSplash
                tst.b   $36(a0)
                bne.s   SKFallingLog_HiddenBlinkReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKFallingLog_HiddenBlinkReturn:
                rts
; ---------------------------------------------------------------------------

SKFallingLog_TryDeleteSplash:
                move.w  $3C(a0),d0
                beq.s   SKFallingLog_ClearRespawnBit
                movea.w d0,a1
                jsr     (Delete_Referenced_Sprite).l

SKFallingLog_ClearRespawnBit:
                move.w  respawn_addr(a0),d0
                beq.s   SKFallingLog_DeleteLog
                movea.w d0,a2
                bclr    #7,(a2)

SKFallingLog_DeleteLog:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKFallingLog_FollowAndAnimateSplash:
                movea.w $3C(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKFallingLog_DrawSplash
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)

SKFallingLog_DrawSplash:
                jmp     (Draw_Sprite).l
