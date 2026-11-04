; Owner: objects/bosses/dez/final_boss/sk
; Responsibility: Death Egg final-boss stage initialization, player control, world motion, battle progression and completion events
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZ3_Boss:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  DEZ3_Boss_Index(pc,d0.w),d1
                jsr     DEZ3_Boss_Index(pc,d1.w)
                move.w  x_pos(a0),(Events_bg+$02).w
                move.w  y_pos(a0),(Events_bg+$04).w
                rts
; ---------------------------------------------------------------------------
DEZ3_Boss_Index:
                dc.w    loc_7FD9E-DEZ3_Boss_Index
                dc.w    loc_7FE2C-DEZ3_Boss_Index
                dc.w    loc_7FE74-DEZ3_Boss_Index
                dc.w    loc_7FE96-DEZ3_Boss_Index
                dc.w    loc_7FEE2-DEZ3_Boss_Index
                dc.w    loc_7FEF6-DEZ3_Boss_Index
                dc.w    DEZFinalWorld_StepHopOrImpact-DEZ3_Boss_Index
                dc.w    loc_7FFD2-DEZ3_Boss_Index
                dc.w    loc_8001C-DEZ3_Boss_Index
                dc.w    loc_80058-DEZ3_Boss_Index
                dc.w    loc_80082-DEZ3_Boss_Index
                dc.w    loc_800DE-DEZ3_Boss_Index
                dc.w    loc_800EE-DEZ3_Boss_Index
; ---------------------------------------------------------------------------

loc_7FD9E:
                move.b  #2,routine(a0)
                bset    #2,render_flags(a0)
                move.w  a0,(_unkFAA4).w
                clr.l   (_unkFA84).w
                lea     (ArtKosM_DEZFinalBossMisc).l,a1
                move.w  #tiles_to_bytes(ArtTile_DEZFinalBossMisc),d2
                jsr     (Queue_Kos_Module).l
                jsr     (AllocateObject).l
                bne.s   loc_7FDD0
                move.l  #loc_80DE0,(a1)

loc_7FDD0:
                jsr     (AllocateObject).l
                bne.s   loc_7FDE2
                move.l  #loc_80D72,(a1)
                move.w  a0,parent3(a1)

loc_7FDE2:
                lea     (Player_1).w,a1
                move.w  #$30,x_pos(a1)
                move.w  #$CD,y_pos(a1)
                bsr.w   SetDEZFinalIntroPlayerRunControl
                lea     (Player_2).w,a1
                move.w  #$10,x_pos(a1)
                move.w  #$CD,y_pos(a1)

; =============== S U B R O U T I N E =======================================

SetDEZFinalIntroPlayerRunControl:
                move.b  #$81,object_control(a1)
                move.b  #0,anim(a1)
                move.w  #$600,x_vel(a1)
                move.w  #$600,ground_vel(a1)
                cmpi.b  #1,character_id(a1)
                bne.s   locret_7FE2A
                addq.w  #4,y_pos(a1)

locret_7FE2A:
                rts
; End of function SetDEZFinalIntroPlayerRunControl

; ---------------------------------------------------------------------------

loc_7FE2C:
                bsr.w   AdvanceBothDEZIntroPlayersSixPixels
                move.w  (Camera_X_pos).w,d1
                addi.w  #$98,d1
                cmp.w   d1,d0
                blo.s   locret_7FE5A
                move.b  #4,routine(a0)
                clr.b   (Scroll_lock).w
                jsr     (AllocateObject).l
                bne.s   locret_7FE5A
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_FinalBoss,subtype(a1)

locret_7FE5A:
                rts

; =============== S U B R O U T I N E =======================================

AdvanceBothDEZIntroPlayersSixPixels:
                lea     (Player_2).w,a1
                bsr.w   AdvanceDEZIntroPlayerSixPixels
                lea     (Player_1).w,a1
; End of function AdvanceBothDEZIntroPlayersSixPixels

; =============== S U B R O U T I N E =======================================

AdvanceDEZIntroPlayerSixPixels:
                move.w  x_pos(a1),d0
                addq.w  #6,d0
                move.w  d0,x_pos(a1)
                rts
; End of function AdvanceDEZIntroPlayerSixPixels

; ---------------------------------------------------------------------------

loc_7FE74:
                bsr.s   AdvanceBothDEZIntroPlayersSixPixels
                cmpi.w  #$360,d0
                blo.s   locret_7FE94
                move.b  #6,routine(a0)
                bsr.w   StopDEZIntroPlayerAndSetWaitingAnimation
                lea     (Player_2).w,a1

; =============== S U B R O U T I N E =======================================

StopDEZIntroPlayerAndSetWaitingAnimation:
                jsr     Stop_Object(pc)
                move.b  #5,anim(a1)

locret_7FE94:
                rts
; End of function StopDEZIntroPlayerAndSetWaitingAnimation

; ---------------------------------------------------------------------------

loc_7FE96:
                btst    #1,(_unkFAB8).w
                beq.s   locret_7FEE0
                move.b  #8,routine(a0)
                move.w  #$BF,$2E(a0)
                move.w  #-$80,y_vel(a0)
                clr.b   (Player_1+object_control).w
                clr.b   (Player_2+object_control).w
                jsr     (AllocateObject).l
                bne.s   loc_7FEC6
                move.l  #SKLevel_InitializeScreenShakeRumbleActor,(a1)

loc_7FEC6:
                lea     (PLC_BossExplosion).l,a1
                jsr     (Load_PLC_Raw).l
                jsr     (AllocateObject).l
                bne.s   locret_7FEE0
                move.l  #loc_810A0,(a1)

locret_7FEE0:
                rts
; ---------------------------------------------------------------------------

loc_7FEE2:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   locret_7FEF4
                move.b  #$A,routine(a0)

locret_7FEF4:
                rts
; ---------------------------------------------------------------------------

loc_7FEF6:
                btst    #2,(_unkFAB8).w
                beq.s   locret_7FF3C
                move.b  #$C,routine(a0)
                move.w  y_pos(a0),$3A(a0)
                move.w  #1,$40(a0)
                jsr     (AllocateObject).l
                bne.s   loc_7FF22
                move.l  #loc_804F0,(a1)
                move.w  a0,parent3(a1)

loc_7FF22:
                jsr     (AllocateObject).l
                bne.s   loc_7FF34
                move.l  #loc_806DA,(a1)
                move.w  a0,parent3(a1)

loc_7FF34:
                lea     ChildObjDat_81310(pc),a2
                jsr     CreateChild6_Simple(pc)

locret_7FF3C:
                rts

; =============== S U B R O U T I N E =======================================

; Use a half-sine lift while moving horizontally, then dispatch the impact phase
DEZFinalWorld_StepHopOrImpact:
                move.w  $40(a0),d0
                add.w   d0,x_pos(a0)
                move.b  angle(a0),d0
                addq.b  #2,d0
                andi.b  #$7F,d0
                move.b  d0,angle(a0)
                beq.s   loc_7FF6A
                jsr     (GetSineCosine).l
                asr.w   #4,d0
                move.w  $3A(a0),d1
                sub.w   d0,d1
                move.w  d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_7FF6A:
                move.b  #$E,routine(a0)
                move.w  #$1F,$2E(a0)
                move.w  #$14,(Screen_shake_flag).w
                moveq   #signextendB(sfx_ThumpBoss),d0
                jsr     (Play_SFX).l
                moveq   #0,d0
                move.b  $30(a0),d0
                jmp     loc_7FF8E(pc,d0.w)
; End of function DEZFinalWorld_StepHopOrImpact

; ---------------------------------------------------------------------------

loc_7FF8E:
                bra.w   loc_7FF9A
; ---------------------------------------------------------------------------
                bra.w   loc_7FFB2
; ---------------------------------------------------------------------------
                bra.w   loc_7FFBC
; ---------------------------------------------------------------------------

loc_7FF9A:
                move.l  #loc_7FFD8,$34(a0)
                cmpi.w  #$540,x_pos(a0)
                blo.s   locret_7FFD0
                move.b  #4,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_7FFB2:
                move.l  #loc_8000E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7FFBC:
                move.b  #$18,routine(a0)
                move.w  #$F,$2E(a0)
                move.l  #loc_800D0,$34(a0)

locret_7FFD0:
                rts
; ---------------------------------------------------------------------------

loc_7FFD2:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_7FFD8:
                move.b  #$C,routine(a0)
                moveq   #1,d2
                move.w  (Player_1+x_pos).w,d0
                cmpi.w  #$610,d0
                bhs.s   loc_7FFFA
                move.w  x_pos(a0),d1
                subi.w  #$80,d1
                cmp.w   d1,d0
                bhs.s   loc_80008
                bra.w   loc_80006
; ---------------------------------------------------------------------------

loc_7FFFA:
                move.w  x_pos(a0),d1
                addi.w  #$80,d1
                cmp.w   d1,d0
                bhs.s   loc_80008

loc_80006:
                neg.w   d2

loc_80008:
                move.w  d2,$40(a0)
                rts
; ---------------------------------------------------------------------------

loc_8000E:
                move.b  #$10,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_8001C:
                cmpi.w  #-1,(_unkFA82).w
                beq.s   loc_80030
                btst    #1,$38(a0)
                beq.w   loc_7FFD8
                rts
; ---------------------------------------------------------------------------

loc_80030:
                move.b  #$12,routine(a0)
                bset    #5,$38(a0)
                jsr     (AllocateObject).l
                bne.s   loc_8004A
                move.l  #SKLevel_InitializeScreenShakeRumbleActor,(a1)

loc_8004A:
                move.w  (Camera_X_pos).w,d0
                move.w  d0,(Camera_max_X_pos).w
                move.w  d0,(Camera_min_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_80058:
                move.w  y_pos(a0),d0
                addq.w  #1,d0
                move.w  d0,y_pos(a0)
                cmpi.w  #$18F,d0
                blo.s   locret_80080
                move.b  #$14,routine(a0)
                move.w  #$6C0,(Events_bg+$00).w
                move.w  (Camera_X_pos).w,d0
                subi.w  #$40,d0
                move.w  d0,x_pos(a0)

locret_80080:
                rts
; ---------------------------------------------------------------------------

loc_80082:
                move.w  y_pos(a0),d0
                subq.w  #1,d0
                move.w  d0,y_pos(a0)
                cmpi.w  #$AF,d0
                bhi.w   locret_80C88
                move.b  #8,$30(a0)
                move.w  #$80,$1C(a0)
                move.w  y_pos(a0),$3A(a0)
                clr.w   angle(a0)
                st      (Scroll_lock).w
                jsr     (AllocateObject).l
                bne.s   loc_800C0
                move.l  #loc_80590,(a1)
                move.w  a0,parent3(a1)

loc_800C0:
                lea     (ArtKosM_BossMasterEmerald).l,a1
                move.w  #tiles_to_bytes(ArtTile_BossMasterEmerald),d2
                jsr     (Queue_Kos_Module).l

loc_800D0:
                move.b  #$16,routine(a0)
                move.w  #1,$40(a0)
                rts
; ---------------------------------------------------------------------------

loc_800DE:
                bsr.w   DEZFinalWorld_TryBeginDefeat
                bsr.w   DEZFinal_TryTimedFireball
                bsr.w   DEZFinalWorld_StepHopOrImpact
                bra.w   DEZFinal_LockBoundsAndNudgeCamera
; ---------------------------------------------------------------------------

loc_800EE:
                bsr.w   DEZFinalWorld_TryBeginDefeat
                bsr.w   DEZFinal_TryTimedFireball
                addq.w  #1,x_pos(a0)
                bsr.w   DEZFinal_LockBoundsAndNudgeCamera
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_80102:
                jsr     (MoveSprite2).l
                cmpi.w  #$18F,y_pos(a0)
                bhs.s   loc_8011E
                move.w  x_pos(a0),(Events_bg+$02).w
                move.w  y_pos(a0),(Events_bg+$04).w
                rts
; ---------------------------------------------------------------------------

loc_8011E:
                clr.w   (Screen_shake_flag).w
                clr.w   (Events_bg+$00).w
                bset    #5,$38(a0)
                jsr     (AllocateObject).l
                bne.s   loc_8013A
                move.l  #loc_80160,(a1)

loc_8013A:
                lea     (ArtKosM_KnuxFinalBossCrane).l,a1
                move.w  #tiles_to_bytes(ArtTile_DEZBossCrane),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_DEZFinalBossDebris).l,a1
                move.w  #tiles_to_bytes(ArtTile_DEZFinalBossDebris),d2
                jsr     (Queue_Kos_Module).l
                jmp     (Go_Delete_Sprite_2).l
; End of function loc_800DE
