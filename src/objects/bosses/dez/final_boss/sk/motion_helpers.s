; Owner: objects/bosses/dez/final_boss/sk
; Responsibility: Death Egg final-boss movement, collision, palette, parent-state and damage helpers with private lookup constants
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_80E2C:
                tst.b   collision_flags(a0)
                bne.s   locret_80EA2
                move.b  collision_property(a0),d0
                beq.s   loc_80EA4
                tst.b   $20(a0)
                bne.s   loc_80E70
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)
                btst    #7,$38(a0)
                beq.s   loc_80E70
                lea     (Player_1).w,a1
                tst.b   $1C(a0)
                beq.s   loc_80E68
                lea     (Player_2).w,a1

loc_80E68:
                clr.w   x_vel(a1)
                clr.w   ground_vel(a1)

loc_80E70:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_80E7E
; Bug: this should be 2*3
                addi.w  #2*2,d0

loc_80E7E:
                bsr.w   sub_80ED6
                subq.b  #1,$20(a0)
                bne.s   locret_80EA2
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)
                cmpi.b  #8,routine(a0)
                blo.s   locret_80EA2
                move.w  #$800,x_vel(a0)

locret_80EA2:
                rts
; ---------------------------------------------------------------------------

loc_80EA4:
                move.l  #Wait_Draw,(a0)
                move.w  #$2F,$2E(a0)
                move.l  #loc_8029C,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_80ECC
                move.b  #4,subtype(a1)

loc_80ECC:
                moveq   #100,d0
                jsr     (HUD_AddToScore).l
                rts
; End of function sub_80E2C

; =============== S U B R O U T I N E =======================================

sub_80ED6:
                lea     word_80EE2(pc),a1
                lea     word_80EE8(pc,d0.w),a2
                jmp     CopyWordData_3(pc)
; End of function sub_80ED6

; ---------------------------------------------------------------------------
word_80EE2:
                dc.w    Normal_palette+$0E, Normal_palette+$1C, Normal_palette+$1E
word_80EE8:
                dc.w    8,  $866,  $222
                dc.w    $888,  $CCC,  $EEE

; =============== S U B R O U T I N E =======================================

sub_80EF4:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                bne.s   locret_80F0C
                jsr     (AllocateObject).l
                bne.s   locret_80F0C
                move.l  #loc_80426,(a1)

locret_80F0C:
                rts
; End of function sub_80EF4

; =============== S U B R O U T I N E =======================================

sub_80F0E:
                move.l  (_unkFA84).w,d0
                addi.l  #$1000,d0
                cmpi.l  #$40000,d0
                bhi.s   loc_80F24
                move.l  d0,(_unkFA84).w

loc_80F24:
                move.l  (Camera_X_pos).w,d1
                add.l   d0,d1
                move.l  d1,(Camera_X_pos).w
                swap    d1
                move.w  d1,(Camera_min_X_pos).w
                move.w  d1,(Camera_max_X_pos).w
                rts
; End of function sub_80F0E

; =============== S U B R O U T I N E =======================================

sub_80F3A:
                btst    #7,status(a0)
                beq.s   locret_80F9C
                move.l  #loc_80102,(a0)
                move.w  #$80,x_vel(a0)
                move.w  #$80,y_vel(a0)
                jsr     (AllocateObject).l
                bne.s   loc_80F62
                move.l  #loc_8642E,(a1)

loc_80F62:
                bclr    #5,$38(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_80F7C
                move.b  #$16,subtype(a1)

loc_80F7C:
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_80F90
                move.b  #$16,subtype(a1)

loc_80F90:
                lea     PLC_DEZ3_Boss(pc),a1
                jsr     (Load_PLC_Raw).l
                addq.w  #4,sp

locret_80F9C:
                rts
; End of function sub_80F3A

; ---------------------------------------------------------------------------
PLC_DEZ3_Boss:  plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
PLC_DEZ3_Boss_End:

; =============== S U B R O U T I N E =======================================

sub_80FA6:
                cmpi.b  #$1E,mapping_frame(a0)
                bne.s   locret_80FF0
                lea     word_80FF2(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   locret_80FF0
                tst.w   d0
                beq.s   loc_80FD6
                movea.w d0,a1
                tst.b   invulnerability_timer(a1)
                bne.s   loc_80FD6
                btst    #Status_Invincible,status_secondary(a1)
                bne.s   loc_80FD6
                move.l  d0,-(sp)
                jsr     HurtCharacter_Directly(pc)
                move.l  (sp)+,d0

loc_80FD6:
                swap    d0
                tst.w   d0
                beq.s   locret_80FF0
                movea.w d0,a1
                tst.b   invulnerability_timer(a1)
                bne.s   locret_80FF0
                btst    #Status_Invincible,status_secondary(a1)
                bne.s   locret_80FF0
                jsr     HurtCharacter_Directly(pc)

locret_80FF0:
                rts
; End of function sub_80FA6

; ---------------------------------------------------------------------------
word_80FF2:
                dc.w    0,  $120,  -$20,   $40

; =============== S U B R O U T I N E =======================================

sub_80FFA:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #3,d0
                bne.s   locret_8100C
                lea     ChildObjDat_8132A(pc),a2
                jsr     CreateChild6_Simple(pc)

locret_8100C:
                rts
; End of function sub_80FFA

; =============== S U B R O U T I N E =======================================

sub_8100E:
                move.w  x_pos(a0),d0
                addi.w  #$40,d0
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                addq.w  #1,(Camera_X_pos).w
                rts
; End of function sub_8100E

; =============== S U B R O U T I N E =======================================

sub_81024:
                movea.w parent3(a0),a1
                move.w  $42(a0),d0
                move.w  x_pos(a1),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.w  $44(a0),d0
                move.w  y_pos(a1),d1
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                rts
; End of function sub_81024

; =============== S U B R O U T I N E =======================================

sub_81046:
                btst    #2,$38(a0)
                bne.s   locret_8106C
                subq.w  #1,$1C(a0)
                bpl.s   locret_8106C
                move.w  #$140,$1C(a0)
                jsr     (AllocateObject).l
                bne.s   locret_8106C
                move.l  #Obj_DEZ3_Boss_Fireball,(a1)
                move.w  a0,parent3(a1)

locret_8106C:
                rts
; End of function sub_81046

; =============== S U B R O U T I N E =======================================

sub_8106E:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_8109E
                move.l  #loc_80A3A,(a1)
                move.w  parent3(a0),parent3(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  $42(a0),$42(a1)
                move.w  $44(a0),$44(a1)
                move.b  d2,subtype(a1)

locret_8109E:
                rts
; End of function sub_8106E

; ---------------------------------------------------------------------------

loc_810A0:
                move.w  (Camera_X_pos).w,d0
                move.w  d0,(Camera_min_X_pos).w
                move.w  #$520,d1
                cmp.w   d1,d0
                blo.w   locret_80C88
                bset    #2,(_unkFAB8).w
                move.w  d1,(Camera_min_X_pos).w
                addi.w  #$A0,d1
                move.w  d1,(Camera_max_X_pos).w
                move.w  #$2C0,(Events_bg+$00).w
                addi.w  #$100,x_pos(a0)

loc_810D0:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_810D6:
                move.b  collision_property(a0),d0
                beq.s   loc_81140
                tst.b   $20(a0)
                beq.s   locret_810F8
                bsr.w   sub_8117A
                subq.b  #1,$20(a0)
                bne.s   locret_810F8
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_810F8:
                rts
; End of function sub_810D6

; =============== S U B R O U T I N E =======================================

sub_810FA:
                cmpi.b  #4,mapping_frame(a0)
                bne.s   sub_810D6
                tst.b   collision_flags(a0)
                bne.s   locret_8113E
                move.b  collision_property(a0),d0
                beq.s   loc_81140
                tst.b   $20(a0)
                bne.s   loc_81128
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

loc_81128:
                bsr.w   sub_8117A
                subq.b  #1,$20(a0)
                bne.s   locret_8113E
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_8113E:
                rts
; ---------------------------------------------------------------------------

loc_81140:
                move.l  #loc_80D64,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_81168
                move.b  #6,subtype(a1)

loc_81168:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #1,d0
                movea.w parent3(a0),a1
                bset    d0,$3A(a1)
                rts
; End of function sub_810FA

; =============== S U B R O U T I N E =======================================

sub_8117A:
                movea.w parent3(a0),a1
                move.b  mapping_frame(a1),d0
                btst    #0,$20(a0)
                beq.s   loc_81190
                move.b  d0,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_81190:
                addi.b  #$13,d0
                move.b  d0,mapping_frame(a0)
                rts
; End of function sub_8117A

; =============== S U B R O U T I N E =======================================

sub_8119A:
                tst.b   collision_flags(a0)
                bne.s   locret_81204
                tst.b   collision_property(a0)
                beq.s   loc_81206
                tst.b   $20(a0)
                bne.s   loc_811DA
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                lea     (Player_1).w,a1
                tst.b   $1C(a0)
                beq.s   loc_811C8
                lea     (Player_2).w,a1

loc_811C8:
                move.w  #$600,d0
                move.w  d0,ground_vel(a1)
                move.w  d0,x_vel(a1)
                move.w  #-$300,y_vel(a1)

loc_811DA:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_811EE
                addi.w  #2*5,d0

loc_811EE:
                bsr.w   sub_81230
                subq.b  #1,$20(a0)
                bne.s   locret_81204
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_81204:
                rts
; ---------------------------------------------------------------------------

loc_81206:
                move.l  #loc_80584,(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_81220
                move.b  #4,subtype(a1)

loc_81220:
                movea.w parent3(a0),a1
                bset    #7,status(a1)
                jmp     (BossDefeated_StopTimer).l
; End of function sub_8119A

; =============== S U B R O U T I N E =======================================

sub_81230:
                lea     word_8123E(pc),a1
                lea     word_81248(pc,d0.w),a2
                jmp     (CopyWordData_5).l
; End of function sub_81230

; ---------------------------------------------------------------------------
word_8123E:
                dc.w    Normal_palette_line_2+$14, Normal_palette_line_2+$16, Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_81248:
                dc.w    $888,  $666,  $444,  $222,     0
                dc.w    $EEE,  $EEE,  $CCC,  $AAA,  $888

; =============== S U B R O U T I N E =======================================

sub_8125C:
                tst.b   collision_property(a0)
                beq.s   loc_81206
                tst.b   $20(a0)
                beq.s   locret_81284
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_81276
                addi.w  #2*5,d0

loc_81276:
                bsr.s   sub_81230
                subq.b  #1,$20(a0)
                bne.s   locret_81284
                bclr    #6,status(a0)

locret_81284:
                rts
; End of function sub_8125C
