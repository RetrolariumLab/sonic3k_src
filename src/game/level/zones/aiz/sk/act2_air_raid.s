; Owner: game/level/zones/aiz/sk
; Responsibility: Angel Island act-two battleship scene, bombs, background trees and small boss actors
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_AIZBattleship:
                move.l  #Obj_AIZBattleshipMain,(a0)
                move.l  #AIZBattleship_BombScript,$2E(a0)
                move.w  #$1A4,$32(a0)
                move.w  #$3FBC,d1
                moveq   #2-1,d2

SKAIZAirRaid_TryCreateShipPropellers:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKAIZAirRaid_SetUpShipPaletteCopy
                move.l  #Obj_BattleshipPropeller,(a1)   ; Create two propellers, one at the front and one in the back
                move.w  d1,$2E(a1)
                move.w  #$3DCC,d1
                dbf     d2,SKAIZAirRaid_TryCreateShipPropellers

SKAIZAirRaid_SetUpShipPaletteCopy:
                lea     (Normal_palette_line_2).w,a1
                lea     (Pal_AIZBattleship).l,a5
                moveq   #bytesToLcnt($20),d0

SKAIZAirRaid_CopyShipPalette:
                move.l  (a5)+,(a1)+
                dbf     d0,SKAIZAirRaid_CopyShipPalette

Obj_AIZBattleshipMain:
                subi.l  #$8800,(_unkEE98).w
                move.w  (_unkEE98).w,d0
                cmpi.w  #$3CDC,d0
                bpl.s   SKAIZAirRaid_PickShipYMotion
                move.l  #Obj_AIZ2BossSmall,(a0)
                st      (Events_fg_4).w                 ; Set for the next screen event
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKAIZAirRaid_ShipExitReturn
                move.l  #Obj_AIZ2MakeTree,(a1)

SKAIZAirRaid_ShipExitReturn:
                rts
; ---------------------------------------------------------------------------

SKAIZAirRaid_PickShipYMotion:
                move.w  d0,d1
                subi.w  #$3D5C,d0
                bpl.s   SKAIZAirRaid_ApplyShipBob
                neg.w   d0                              ; Move upwards as the battleship goes offscreen
                asr.w   #1,d0
                add.w   (_unkEEA2).w,d0
                move.w  d0,(_unkEE9C).w
                bra.s   SKAIZAirRaid_TryShipSound
; ---------------------------------------------------------------------------

SKAIZAirRaid_ApplyShipBob:
                asr.w   #2,d1                           ; Continue bobbing up and down
                andi.w  #$F,d1
                lea     (AIZBattleShip_BobbingMotion).l,a1
                move.b  (a1,d1.w),d1
                add.w   (_unkEEA2).w,d1
                move.w  d1,(_unkEE9C).w                 ; Get the bobbing motion delta, apply it to the second camera Y

SKAIZAirRaid_TryShipSound:
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   SKAIZAirRaid_TickBombScriptAndTrySpawn
                moveq   #signextendB(sfx_LargeShip),d0  ; Replay the battleship flying sound every 16th frame
                jsr     (Play_SFX).l

SKAIZAirRaid_TickBombScriptAndTrySpawn:
                subq.w  #1,$32(a0)                      ; Wait for delay to finish
                bcc.s   SKAIZAirRaid_BombScriptReturn
                movea.l $2E(a0),a2
                move.w  (a2)+,$32(a0)                   ; Get the first word of the bomb script as the new delay
                bmi.s   SKAIZAirRaid_BombScriptReturn
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKAIZAirRaid_BombScriptReturn
                move.l  #Obj_AIZShipBomb,(a1)           ; Create a new bomb
                move.w  (a2)+,$2E(a1)                   ; Put the X position into $2E so it can be translated
                move.l  a2,$2E(a0)                      ; Update the script position

SKAIZAirRaid_BombScriptReturn:
                rts
; ---------------------------------------------------------------------------

Obj_BattleshipPropeller:
                move.l  #Obj_BattleshipPropellerMain,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$20,height_pixels(a0)
                move.b  #8,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_AIZ2Bombership,0,0),art_tile(a0)
                move.l  #Map_AIZShipPropeller,mappings(a0)
                move.w  #$A71,$30(a0)

Obj_BattleshipPropellerMain:
                cmpi.w  #$C,(Events_routine_fg).w
                bne.s   SKAIZAirRaid_AnimateAndDrawPropeller
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKAIZAirRaid_AnimateAndDrawPropeller:
                lea     (Ani_AIZShipPropeller).l,a1
                jsr     (Animate_Sprite).l
                jsr     Translate_Camera2ObjPosition(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_AIZShipBomb:
                move.l  #Obj_AIZShipBombMain,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$18,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_AIZ2Bombership,0,0),art_tile(a0)
                move.l  #Map_AIZ2BombExplode,mappings(a0)
                move.b  #$10,y_radius(a0)
                move.w  #$A60,$30(a0)
                move.w  #6,$32(a0)

Obj_AIZShipBombMain:
                moveq   #0,d0
                move.b  routine(a0),d0
                jmp     AIZShipBomb_Index(pc,d0.w)
; ---------------------------------------------------------------------------

AIZShipBomb_Index:
                bra.w   AIZShipBomb_ReadyDrop
; ---------------------------------------------------------------------------
                bra.w   AIZShipBomb_Delay
; ---------------------------------------------------------------------------
                bra.w   AIZShipBomb_Drop
; ---------------------------------------------------------------------------

AIZShipBomb_ReadyDrop:
                addq.w  #2,$30(a0)
                cmpi.w  #$A80,$30(a0)                   ; Put bomb into position before delay
                blo.s   SKAIZAirRaid_DrawAttachedBomb
                addq.b  #4,routine(a0)
                bra.s   SKAIZAirRaid_DrawAttachedBomb
; ---------------------------------------------------------------------------

AIZShipBomb_Delay:
                subq.w  #1,$32(a0)
                bne.s   SKAIZAirRaid_DrawAttachedBomb
                addq.b  #4,routine(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l                    ; Play the drop sound after the delay

SKAIZAirRaid_DrawAttachedBomb:
                jsr     Translate_Camera2ObjPosition(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AIZShipBomb_Drop:
                move.l  y_pos(a0),d0
                add.l   y_vel(a0),d0
                move.l  d0,y_pos(a0)                    ; Drop bomb downwards
                addi.l  #$2000,y_vel(a0)                ; Increase acceleration
                swap    d0
                jsr     Translate_Camera2ObjX(pc)
                jsr     (Draw_Sprite).l
                jsr     (ObjCheckFloorDist).l
                cmpi.w  #-8,d1
                bgt.s   SKAIZAirRaid_BombDropReturn
                move.w  #$10,(Screen_shake_flag).w      ; If touching the floor, set up a timed screen shake
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l                    ; Play the bomb explosion sound
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKAIZAirRaid_ScheduleBombDelete
                lea     (AIZBombExplodeDat).l,a2
                moveq   #8-1,d1

SKAIZAirRaid_InitBombExplosionPiece:
                move.l  #Obj_AIZBombExplosion,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  (a2)+,d2
                add.w   d2,x_pos(a1)
                move.w  (a2)+,d2
                add.w   d2,y_pos(a1)
                move.w  (a2)+,anim(a1)
                move.w  (a2)+,$2E(a1)
                jsr     (CreateNewSprite4).l
                dbne    d1,SKAIZAirRaid_InitBombExplosionPiece

SKAIZAirRaid_ScheduleBombDelete:
                move.l  #Delete_Current_Sprite,(a0)     ; Delete the bomb sprite

SKAIZAirRaid_BombDropReturn:
                rts

; =============== S U B R O U T I N E =======================================

Translate_Camera2ObjPosition:
                move.w  $30(a0),d0
                sub.w   (_unkEE9C).w,d0
                add.w   (Camera_Y_pos_copy).w,d0

Translate_Camera2ObjX:
                sub.w   (Screen_shake_last_offset).w,d0
                add.w   (Screen_shake_offset).w,d0
                move.w  d0,y_pos(a0)
                move.w  $2E(a0),d0
                sub.w   (_unkEE98).w,d0
                add.w   (Camera_X_pos_copy).w,d0
                move.w  d0,x_pos(a0)
                rts
; End of function Translate_Camera2ObjPosition

; ---------------------------------------------------------------------------

Obj_AIZBombExplosion:
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)
                subq.w  #1,$2E(a0)
                bmi.s   SKAIZAirRaid_StartBombExplosion
                rts
; ---------------------------------------------------------------------------

SKAIZAirRaid_StartBombExplosion:
                move.l  #Obj_AIZBombExplosionAnim,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.w  #make_art_tile(ArtTile_AIZ2Bombership,0,0),art_tile(a0)
                move.l  #Map_AIZ2BombExplode,mappings(a0)
                move.b  #$8B,collision_flags(a0)
                bra.s   SKAIZAirRaid_AnimateBombExplosion
; ---------------------------------------------------------------------------

Obj_AIZBombExplosionAnim:
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)

SKAIZAirRaid_AnimateBombExplosion:
                lea     (Ani_AIZ2BombExplode).l,a1
                jsr     (Animate_SpriteIrregularDelay).l
                tst.b   routine(a0)
                beq.s   SKAIZAirRaid_TryQueueExplosionTouch
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKAIZAirRaid_TryQueueExplosionTouch:
                moveq   #4,d0
                add.b   anim(a0),d0
                cmp.b   mapping_frame(a0),d0
                bls.s   SKAIZAirRaid_DrawExplosion
                jsr     (Add_SpriteToCollisionResponseList).l

SKAIZAirRaid_DrawExplosion:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_AIZ2MakeTree:
                cmpi.w  #$44D0,(Camera_X_pos).w
                bhs.s   SKAIZAirRaid_StartTreeSpawnScript
                rts
; ---------------------------------------------------------------------------

SKAIZAirRaid_StartTreeSpawnScript:
                move.l  #SKAIZAirRaid_ReadTreeSpawnThreshold,(a0)
                move.w  (Events_fg_1).w,$2E(a0)
                move.l  #AIZMakeTreeScript,$30(a0)

SKAIZAirRaid_ReadTreeSpawnThreshold:
                movea.l $30(a0),a2
                tst.w   (a2)
                bpl.s   SKAIZAirRaid_TrySpawnTreeAtDistance
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKAIZAirRaid_TrySpawnTreeAtDistance:
                move.w  (Events_fg_1).w,d0
                sub.w   $2E(a0),d0
                cmp.w   (a2)+,d0
                blo.s   SKAIZAirRaid_TreeSpawnReturn
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKAIZAirRaid_TreeSpawnReturn
                move.l  #Obj_AIZ2BGTree,(a1)
                move.w  (a2)+,8(a1)
                move.l  a2,$30(a0)

SKAIZAirRaid_TreeSpawnReturn:
                rts
; ---------------------------------------------------------------------------

Obj_AIZ2BGTree:
                move.l  #Obj_AIZ2BGTreeMove,(a0)
                move.w  #make_art_tile(ArtTile_AIZBackgroundTree,0,0),art_tile(a0)
                move.l  #Map_AIZ2BGTree,mappings(a0)
                move.w  #$E9,y_pos(a0)
                move.w  #$1C0,$2E(a0)
                move.w  (Events_fg_1).w,$30(a0)

Obj_AIZ2BGTreeMove:
                cmpi.w  #$4880,(Camera_X_pos).w
                blo.s   SKAIZAirRaid_PositionBackgroundTree
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

; Subtract one quarter of the signed event displacement to get the tree step
SKAIZAirRaid_PositionBackgroundTree:
                move.w  (Events_fg_1).w,d0
                sub.w   $30(a0),d0
                move.w  d0,d1
                asr.w   #2,d0
                sub.w   d0,d1
                move.w  $2E(a0),d0
                sub.w   d1,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$1C0,d0
                bhs.s   SKAIZAirRaid_BackgroundTreeReturn
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKAIZAirRaid_BackgroundTreeReturn:
                rts
; ---------------------------------------------------------------------------

Obj_AIZ2BossSmall:
                move.l  #Obj_AIZ2BossSmallMain,(a0)
                move.w  #$300,priority(a0)
                move.w  #make_art_tile(ArtTile_AIZ2Bombership,0,0),art_tile(a0)
                move.l  #Map_AIZ2BossSmall,mappings(a0)
                move.w  #$30,x_pos(a0)
                move.w  #$D8,y_pos(a0)
                move.w  #5,x_vel(a0)
                clr.w   $2E(a0)
                lea     (Normal_palette_line_2+$2).w,a1
                lea     (Pal_AIZBossSmall).l,a5
                moveq   #bytesToLcnt($1C),d0

SKAIZAirRaid_CopySmallBossPalette:
                move.l  (a5)+,(a1)+
                dbf     d0,SKAIZAirRaid_CopySmallBossPalette

Obj_AIZ2BossSmallMain:
                tst.b   $2E(a0)
                bne.s   SKAIZAirRaid_CheckSmallBossExit
                cmpi.w  #$4670,(Camera_X_pos).w
                blo.s   SKAIZAirRaid_SmallBossReturn
                st      $2E(a0)

SKAIZAirRaid_CheckSmallBossExit:
                cmpi.w  #$240,x_pos(a0)
                blo.s   SKAIZAirRaid_StepSmallBossX
                clr.b   (Scroll_lock).w
                clr.w   (Special_events_routine).w
                clr.w   (Level_repeat_offset).w         ; Stop repeating scrolling section
                move.w  #$6000,(Camera_max_X_pos).w     ; Change level size
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKAIZAirRaid_StepSmallBossX:
                move.l  x_pos(a0),d0
                move.l  x_vel(a0),d1                    ; Move Robotnik
                add.l   d1,d0
                move.l  d0,x_pos(a0)
                tst.b   $2F(a0)
                bne.s   SKAIZAirRaid_AccelerateSmallBoss
                subi.l  #$E80,d1                        ; Phase 1: Slow down until moving slightly to the left
                cmpi.l  #-$10000,d1
                sle     $2F(a0)
                bra.s   SKAIZAirRaid_DrawSmallBossAndTrySiren
; ---------------------------------------------------------------------------

SKAIZAirRaid_AccelerateSmallBoss:
                addi.l  #$E80,d1                        ; Phase 2: Speed up till moving off screen

SKAIZAirRaid_DrawSmallBossAndTrySiren:
                move.l  d1,x_vel(a0)
                jsr     (Draw_Sprite).l
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   SKAIZAirRaid_SmallBossReturn
                moveq   #signextendB(sfx_RobotnikSiren),d0  ; Every sixteenth frame, play alarm sound
                jsr     (Play_SFX).l

SKAIZAirRaid_SmallBossReturn:
                rts
; ---------------------------------------------------------------------------
AIZ2_SOZ1_LRZ3_FGDeformDelta:
                dc.w    0,  0,  1,  1,  0,  0,  0,  0,  1,  0,  0,  0,  0,  1,  0,  0
                dc.w    0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  1,  1,  0,  0
                dc.w    0,  0,  1,  1,  0,  0,  0,  0,  1,  0,  0,  0,  0,  1,  0,  0
                dc.w    0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  1,  1,  0,  0
                dc.w    0,  0,  1,  1,  0,  0,  0,  0,  1,  0,  0,  0,  0,  1,  0,  0
                dc.w    0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  1,  1,  0,  0
                dc.w    0,  0,  1,  1,  0,  0,  0,  0,  1,  0,  0,  0,  0,  1,  0,  0
                dc.w    0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  1,  1,  0,  0
                dc.w    0,  0,  1,  1,  0,  0,  0,  0,  1,  0,  0,  0,  0,  1,  0,  0
                dc.w    0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  1,  1,  0,  0
                dc.w    0,  0,  1,  1,  0,  0,  0,  0,  1,  0,  0,  0,  0,  1,  0,  0
                dc.w    0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  1,  1,  0,  0
                dc.w    0,  0,  1,  1,  0,  0,  0,  0,  1,  0,  0,  0,  0,  1,  0,  0
                dc.w    0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  1,  1,  0,  0
                dc.w    0,  0,  1,  1,  0,  0,  0,  0,  1,  0,  0,  0,  0,  1,  0,  0
                dc.w    0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  1,  1,  0,  0
AIZ2_ALZ_BGDeformDelta:
                dc.w    -2,  1,  2,  2, -1,  2,  2,  1,  2, -1, -2, -2, -2,  1, -1, -1
                dc.w    -1,  0, -2,  0,  0,  0, -2,  0, -2,  2,  0, -2,  2,  2, -1, -2
                dc.w    -2,  1,  2,  2, -1,  2,  2,  1,  2, -1, -2, -2, -2,  1, -1, -1
                dc.w    -1,  0, -2,  0,  0,  0, -2,  0, -2,  2,  0, -2,  2,  2, -1, -2
                dc.w    -2,  1,  2,  2, -1,  2,  2,  1,  2, -1, -2, -2, -2,  1, -1, -1
                dc.w    -1,  0, -2,  0,  0,  0, -2,  0, -2,  2,  0, -2,  2,  2, -1, -2
                dc.w    -2,  1,  2,  2, -1,  2,  2,  1,  2, -1, -2, -2, -2,  1, -1, -1
                dc.w    -1,  0, -2,  0,  0,  0, -2,  0, -2,  2,  0, -2,  2,  2, -1, -2
                dc.w    -2,  1,  2,  2, -1,  2,  2,  1,  2, -1, -2, -2, -2,  1, -1, -1
                dc.w    -1,  0, -2,  0,  0,  0, -2,  0, -2,  2,  0, -2,  2,  2, -1, -2
                dc.w    -2,  1,  2,  2, -1,  2,  2,  1,  2, -1, -2, -2, -2,  1, -1, -1
                dc.w    -1,  0, -2,  0,  0,  0, -2,  0, -2,  2,  0, -2,  2,  2, -1, -2
                dc.w    -2,  1,  2,  2, -1,  2,  2,  1,  2, -1, -2, -2, -2,  1, -1, -1
                dc.w    -1,  0, -2,  0,  0,  0, -2,  0, -2,  2,  0, -2,  2,  2, -1, -2
                dc.w    -2,  1,  2,  2, -1,  2,  2,  1,  2, -1, -2, -2, -2,  1, -1, -1
                dc.w    -1,  0, -2,  0,  0,  0, -2,  0, -2,  2,  0, -2,  2,  2, -1, -2
