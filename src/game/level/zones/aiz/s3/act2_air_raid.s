; Owner: game/level/zones/aiz/s3
; Responsibility: Angel Island act-two battleship scene, bombs, background trees, small boss objects and shared scene resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZBattleship:
                move.l  #Obj_AIZBattleshipMain,(a0)
                move.l  #AIZBattleship_BombScript,$2E(a0)
                move.w  #$1A4,$32(a0)
                move.w  #$3FBC,d1
                moveq   #2-1,d2

loc_3B7F8:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_3B812
                move.l  #Obj_BattleshipPropeller,(a1)   ; Create two propellers, one at the front and one in the back
                move.w  d1,$2E(a1)
                move.w  #$3DCC,d1
                dbf     d2,loc_3B7F8

loc_3B812:
                lea     (Normal_palette_line_2).w,a1
                lea     Pal_AIZBattleship(pc),a5
                moveq   #bytesToLcnt($20),d0

loc_3B81C:
                move.l  (a5)+,(a1)+
                dbf     d0,loc_3B81C

Obj_AIZBattleshipMain:
                subi.l  #$8800,(_unkEE98).w
                move.w  (_unkEE98).w,d0
                cmpi.w  #$3CDC,d0
                bpl.s   loc_3B84E
                move.l  #Obj_AIZ2BossSmall,(a0)
                st      (Events_fg_4).w                 ; Set for the next screen event
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_3B84C
                move.l  #Obj_AIZ2MakeTree,(a1)

locret_3B84C:
                rts
; ---------------------------------------------------------------------------

loc_3B84E:
                move.w  d0,d1
                subi.w  #$3D5C,d0
                bpl.s   loc_3B864
                neg.w   d0                              ; Move upwards as the battleship goes offscreen
                asr.w   #1,d0
                add.w   (_unkEEA2).w,d0
                move.w  d0,(_unkEE9C).w
                bra.s   loc_3B87A
; ---------------------------------------------------------------------------

loc_3B864:
                asr.w   #2,d1                           ; Continue bobbing up and down
                andi.w  #$F,d1
                lea     AIZBattleShip_BobbingMotion(pc),a1
                move.b  (a1,d1.w),d1
                add.w   (_unkEEA2).w,d1
                move.w  d1,(_unkEE9C).w                 ; Get the bobbing motion delta, apply it to the second camera Y

loc_3B87A:
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   loc_3B88E
                moveq   #signextendB(sfx_LargeShip),d0  ; Replay the battleship flying sound every 16th frame
                jsr     (Play_SFX).l

loc_3B88E:
                subq.w  #1,$32(a0)                      ; Wait for delay to finish
                bcc.s   locret_3B8B4
                movea.l $2E(a0),a2
                move.w  (a2)+,$32(a0)                   ; Get the first word of the bomb script as the new delay
                bmi.s   locret_3B8B4
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_3B8B4
                move.l  #Obj_AIZShipBomb,(a1)           ; Create a new bomb
                move.w  (a2)+,$2E(a1)                   ; Put the X position into $2E so it can be translated
                move.l  a2,$2E(a0)                      ; Update the script position

locret_3B8B4:
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
                bne.s   loc_3B8F6
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3B8F6:
                lea     Ani_AIZShipPropeller(pc),a1
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
                blo.s   loc_3B97C
                addq.b  #4,routine(a0)
                bra.s   loc_3B97C
; ---------------------------------------------------------------------------

AIZShipBomb_Delay:
                subq.w  #1,$32(a0)
                bne.s   loc_3B97C
                addq.b  #4,routine(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l                    ; Play the drop sound after the delay

loc_3B97C:
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
                bgt.s   locret_3BA04
                move.w  #$10,(Screen_shake_flag).w      ; If touching the floor, set up a timed screen shake
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l                    ; Play the bomb explosion sound
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_3B9FE
                lea     AIZBombExplodeDat(pc),a2
                moveq   #8-1,d1

loc_3B9CE:
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
                dbne    d1,loc_3B9CE

loc_3B9FE:
                move.l  #Delete_Current_Sprite,(a0)     ; Delete the bomb sprite

locret_3BA04:
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
                bmi.s   loc_3BA40
                rts
; ---------------------------------------------------------------------------

loc_3BA40:
                move.l  #Obj_AIZBombExplosionAnim,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.w  #make_art_tile(ArtTile_AIZ2Bombership,0,0),art_tile(a0)
                move.l  #Map_AIZ2BombExplode,mappings(a0)
                move.b  #$8B,collision_flags(a0)
                bra.s   loc_3BA70
; ---------------------------------------------------------------------------

Obj_AIZBombExplosionAnim:
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)

loc_3BA70:
                lea     Ani_AIZ2BombExplode(pc),a1
                jsr     (Animate_SpriteIrregularDelay).l
                tst.b   routine(a0)
                beq.s   loc_3BA86
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3BA86:
                moveq   #4,d0
                add.b   anim(a0),d0
                cmp.b   mapping_frame(a0),d0
                bls.s   loc_3BA98
                jsr     (Add_SpriteToCollisionResponseList).l

loc_3BA98:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_AIZ2MakeTree:
                cmpi.w  #$44D0,(Camera_X_pos_copy).w
                bhs.s   loc_3BAA8
                rts
; ---------------------------------------------------------------------------

loc_3BAA8:
                move.l  #loc_3BABC,(a0)
                move.w  (Events_fg_1).w,$2E(a0)
                move.l  #AIZMakeTreeScript,$30(a0)

loc_3BABC:
                movea.l $30(a0),a2
                tst.w   (a2)
                bpl.s   loc_3BACA
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3BACA:
                move.w  (Events_fg_1).w,d0
                sub.w   $2E(a0),d0
                cmp.w   (a2)+,d0
                blo.s   locret_3BAEC
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_3BAEC
                move.l  #Obj_AIZ2BGTree,(a1)
                move.w  (a2)+,8(a1)
                move.l  a2,$30(a0)

locret_3BAEC:
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
                cmpi.w  #$4880,(Camera_X_pos_copy).w
                blo.s   loc_3BB22
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3BB22:
                move.w  (Events_fg_1).w,d0
                sub.w   $30(a0),d0
                move.w  d0,d1
                asr.w   #2,d0
                sub.w   d0,d1
                move.w  $2E(a0),d0
                sub.w   d1,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$1C0,d0
                bhs.s   locret_3BB46
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_3BB46:
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
                lea     Pal_AIZBossSmall(pc),a5
                moveq   #bytesToLcnt($1C),d0

loc_3BB82:
                move.l  (a5)+,(a1)+
                dbf     d0,loc_3BB82

Obj_AIZ2BossSmallMain:
                tst.b   $2E(a0)
                bne.s   loc_3BB9A
                cmpi.w  #$4670,(Camera_X_pos_copy).w
                blo.s   locret_3BC04
                st      $2E(a0)

loc_3BB9A:
                cmpi.w  #$240,x_pos(a0)
                blo.s   loc_3BBBA
                clr.b   (Scroll_lock).w
                clr.w   (Special_events_routine).w
                clr.w   (Level_repeat_offset).w         ; Stop repeating scrolling section
                move.w  #$6000,(Camera_max_X_pos).w     ; Change level size
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3BBBA:
                move.l  x_pos(a0),d0
                move.l  x_vel(a0),d1                    ; Move Robotnik
                add.l   d1,d0
                move.l  d0,x_pos(a0)
                tst.b   $2F(a0)
                bne.s   loc_3BBE0
                subi.l  #$E80,d1                        ; Phase 1: Slow down until moving slightly to the left
                cmpi.l  #-$10000,d1
                sle     $2F(a0)
                bra.s   loc_3BBE6
; ---------------------------------------------------------------------------

loc_3BBE0:
                addi.l  #$E80,d1                        ; Phase 2: Speed up till moving off screen

loc_3BBE6:
                move.l  d1,x_vel(a0)
                jsr     (Draw_Sprite).l
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   locret_3BC04
                moveq   #signextendB(sfx_RobotnikSiren),d0  ; Every sixteenth frame, play alarm sound
                jsr     (Play_SFX).l

locret_3BC04:
                rts
; ---------------------------------------------------------------------------
AIZ2_BGDeformArray:
                dc.w    $10,   $20,   $38,   $58,   $28,   $40,   $38,   $18,   $18,   $90,   $48,   $10,   $18
                dc.w    $20,   $38,   $58,   $28,   $40,   $38,   $18,   $18,   $90,   $48,   $10, $7FFF
AIZ2_BGDeformMake:
                dc.b    2-1, $12, $2A
                dc.b    4-1, $10, $14, $28, $2C
                dc.b    4-1,  $E, $16, $26, $2E
                dc.b    5-1,   0,  $C, $18, $24, $30
                dc.b    4-1,   2,  $A, $1A, $22
                dc.b    4-1,   4,   8, $1C, $20
                dc.b    2-1,   6, $1E
                dc.b    $FF
                even
AIZ2_FGDeformDelta:
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
Pal_AIZBattleship:
                binclude "data/Levels/AIZ/Palettes/Battleship.bin"
                even
Pal_AIZBossSmall:
                binclude "data/Levels/AIZ/Palettes/Boss Small.bin"
                even
AIZBattleShip_BobbingMotion:
                dc.b    4,   4,   3,   3,   2,   1,   1,   0,   0,   0,   1,   1,   2,   3,   3,   4
                even
AIZBattleship_BombScript:
                dc.w    $20, $3F5C
                dc.w    $20, $3F2C
                dc.w    $20, $3F5C
                dc.w    $20, $3F2C
                dc.w    $20, $3F5C
                dc.w    $38, $3F2C
                dc.w    $20, $3EDC
                dc.w    $20, $3EAC
                dc.w    $20, $3EDC
                dc.w    $20, $3EAC
                dc.w    $20, $3EDC
                dc.w    $38, $3EAC
                dc.w    $20, $3E5C
                dc.w    $20, $3E2C
                dc.w    $20, $3E5C
                dc.w    $20, $3E2C
                dc.w    $20, $3E5C
                dc.w    $38, $3E2C
                dc.w    $40, $3DEC
                dc.w    $40, $3DEC
                dc.w    $40, $3DEC
                dc.w    $FFFF
AIZBombExplodeDat:
                dc.w    0,  -$3C, (0<<8)|0,    $A       ; X offset, Y offset, animation number, animation delay
                dc.w    0,   -$C, (1<<8)|1,     9
                dc.w    -4,  -$34, (0<<8)|0,     8
                dc.w    $C,    -4, (1<<8)|1,     7
                dc.w    -$C,    -4, (1<<8)|1,     5
                dc.w    8,  -$24, (0<<8)|0,     4
                dc.w    -8,  -$1C, (0<<8)|0,     2
                dc.w    0,   -$C, (0<<8)|0,     0
AIZMakeTreeScript:
                dc.w    0,  $280
                dc.w    $32,  $380
                dc.w    $8E,  $280
                dc.w    $103,  $380
                dc.w    $179,  $280
                dc.w    $1C6,  $380
                dc.w    $233,  $280
                dc.w    $2A0,  $380
                dc.w    $30A,  $280
                dc.w    $37C,  $380
                dc.w    $3C7,  $280
                dc.w    $401,  $380
                dc.w    $439,  $280
                dc.w    $46E,  $380
                dc.w    $4CA,  $280
                dc.w    $50C,  $380
                dc.w    $557,  $280
                dc.w    $FFFF
Map_AIZShipPropeller:
                include "src/objects/shared/zones/aiz/map_act_2_ship_propeller.s"
Ani_AIZShipPropeller:
                include "src/objects/shared/zones/aiz/anim_act_2_ship_propeller.s"
Map_AIZ2BombExplode:
                include "src/objects/shared/zones/aiz/map_act_2_bomb_explosion.s"
Ani_AIZ2BombExplode:
                include "src/objects/shared/zones/aiz/anim_act_2_bomb_explosion.s"
Map_AIZ2BGTree:
                include "src/objects/shared/zones/aiz/map_act_2_background_tree.s"
Map_AIZ2BossSmall:
                include "src/objects/shared/zones/aiz/map_act_2_boss_small.s"
