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

loc_50364:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_5037E
                move.l  #Obj_BattleshipPropeller,(a1)   ; Create two propellers, one at the front and one in the back
                move.w  d1,$2E(a1)
                move.w  #$3DCC,d1
                dbf     d2,loc_50364

loc_5037E:
                lea     (Normal_palette_line_2).w,a1
                lea     (Pal_AIZBattleship).l,a5
                moveq   #bytesToLcnt($20),d0

loc_5038A:
                move.l  (a5)+,(a1)+
                dbf     d0,loc_5038A

Obj_AIZBattleshipMain:
                subi.l  #$8800,(_unkEE98).w
                move.w  (_unkEE98).w,d0
                cmpi.w  #$3CDC,d0
                bpl.s   loc_503BC
                move.l  #Obj_AIZ2BossSmall,(a0)
                st      (Events_fg_4).w                 ; Set for the next screen event
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_503BA
                move.l  #Obj_AIZ2MakeTree,(a1)

locret_503BA:
                rts
; ---------------------------------------------------------------------------

loc_503BC:
                move.w  d0,d1
                subi.w  #$3D5C,d0
                bpl.s   loc_503D2
                neg.w   d0                              ; Move upwards as the battleship goes offscreen
                asr.w   #1,d0
                add.w   (_unkEEA2).w,d0
                move.w  d0,(_unkEE9C).w
                bra.s   loc_503EA
; ---------------------------------------------------------------------------

loc_503D2:
                asr.w   #2,d1                           ; Continue bobbing up and down
                andi.w  #$F,d1
                lea     (AIZBattleShip_BobbingMotion).l,a1
                move.b  (a1,d1.w),d1
                add.w   (_unkEEA2).w,d1
                move.w  d1,(_unkEE9C).w                 ; Get the bobbing motion delta, apply it to the second camera Y

loc_503EA:
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   loc_503FE
                moveq   #signextendB(sfx_LargeShip),d0  ; Replay the battleship flying sound every 16th frame
                jsr     (Play_SFX).l

loc_503FE:
                subq.w  #1,$32(a0)                      ; Wait for delay to finish
                bcc.s   locret_50424
                movea.l $2E(a0),a2
                move.w  (a2)+,$32(a0)                   ; Get the first word of the bomb script as the new delay
                bmi.s   locret_50424
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_50424
                move.l  #Obj_AIZShipBomb,(a1)           ; Create a new bomb
                move.w  (a2)+,$2E(a1)                   ; Put the X position into $2E so it can be translated
                move.l  a2,$2E(a0)                      ; Update the script position

locret_50424:
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
                bne.s   loc_50466
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_50466:
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
                blo.s   loc_504EE
                addq.b  #4,routine(a0)
                bra.s   loc_504EE
; ---------------------------------------------------------------------------

AIZShipBomb_Delay:
                subq.w  #1,$32(a0)
                bne.s   loc_504EE
                addq.b  #4,routine(a0)
                moveq   #signextendB(sfx_MissileThrow),d0
                jsr     (Play_SFX).l                    ; Play the drop sound after the delay

loc_504EE:
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
                bgt.s   locret_50578
                move.w  #$10,(Screen_shake_flag).w      ; If touching the floor, set up a timed screen shake
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l                    ; Play the bomb explosion sound
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_50572
                lea     (AIZBombExplodeDat).l,a2
                moveq   #8-1,d1

loc_50542:
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
                dbne    d1,loc_50542

loc_50572:
                move.l  #Delete_Current_Sprite,(a0)     ; Delete the bomb sprite

locret_50578:
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
                bmi.s   loc_505B4
                rts
; ---------------------------------------------------------------------------

loc_505B4:
                move.l  #Obj_AIZBombExplosionAnim,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.w  #make_art_tile(ArtTile_AIZ2Bombership,0,0),art_tile(a0)
                move.l  #Map_AIZ2BombExplode,mappings(a0)
                move.b  #$8B,collision_flags(a0)
                bra.s   loc_505E4
; ---------------------------------------------------------------------------

Obj_AIZBombExplosionAnim:
                move.w  (Level_repeat_offset).w,d0
                sub.w   d0,x_pos(a0)

loc_505E4:
                lea     (Ani_AIZ2BombExplode).l,a1
                jsr     (Animate_SpriteIrregularDelay).l
                tst.b   routine(a0)
                beq.s   loc_505FC
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_505FC:
                moveq   #4,d0
                add.b   anim(a0),d0
                cmp.b   mapping_frame(a0),d0
                bls.s   loc_5060E
                jsr     (Add_SpriteToCollisionResponseList).l

loc_5060E:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_AIZ2MakeTree:
                cmpi.w  #$44D0,(Camera_X_pos).w
                bhs.s   loc_5061E
                rts
; ---------------------------------------------------------------------------

loc_5061E:
                move.l  #loc_50632,(a0)
                move.w  (Events_fg_1).w,$2E(a0)
                move.l  #AIZMakeTreeScript,$30(a0)

loc_50632:
                movea.l $30(a0),a2
                tst.w   (a2)
                bpl.s   loc_50640
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_50640:
                move.w  (Events_fg_1).w,d0
                sub.w   $2E(a0),d0
                cmp.w   (a2)+,d0
                blo.s   locret_50662
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_50662
                move.l  #Obj_AIZ2BGTree,(a1)
                move.w  (a2)+,8(a1)
                move.l  a2,$30(a0)

locret_50662:
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
                blo.s   loc_50698
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_50698:
                move.w  (Events_fg_1).w,d0
                sub.w   $30(a0),d0
                move.w  d0,d1
                asr.w   #2,d0
                sub.w   d0,d1
                move.w  $2E(a0),d0
                sub.w   d1,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$1C0,d0
                bhs.s   locret_506BC
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_506BC:
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

loc_506FA:
                move.l  (a5)+,(a1)+
                dbf     d0,loc_506FA

Obj_AIZ2BossSmallMain:
                tst.b   $2E(a0)
                bne.s   loc_50712
                cmpi.w  #$4670,(Camera_X_pos).w
                blo.s   locret_5077C
                st      $2E(a0)

loc_50712:
                cmpi.w  #$240,x_pos(a0)
                blo.s   loc_50732
                clr.b   (Scroll_lock).w
                clr.w   (Special_events_routine).w
                clr.w   (Level_repeat_offset).w         ; Stop repeating scrolling section
                move.w  #$6000,(Camera_max_X_pos).w     ; Change level size
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_50732:
                move.l  x_pos(a0),d0
                move.l  x_vel(a0),d1                    ; Move Robotnik
                add.l   d1,d0
                move.l  d0,x_pos(a0)
                tst.b   $2F(a0)
                bne.s   loc_50758
                subi.l  #$E80,d1                        ; Phase 1: Slow down until moving slightly to the left
                cmpi.l  #-$10000,d1
                sle     $2F(a0)
                bra.s   loc_5075E
; ---------------------------------------------------------------------------

loc_50758:
                addi.l  #$E80,d1                        ; Phase 2: Speed up till moving off screen

loc_5075E:
                move.l  d1,x_vel(a0)
                jsr     (Draw_Sprite).l
                move.w  (Level_frame_counter).w,d0
                subq.w  #1,d0
                andi.w  #$F,d0
                bne.s   locret_5077C
                moveq   #signextendB(sfx_RobotnikSiren),d0  ; Every sixteenth frame, play alarm sound
                jsr     (Play_SFX).l

locret_5077C:
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
