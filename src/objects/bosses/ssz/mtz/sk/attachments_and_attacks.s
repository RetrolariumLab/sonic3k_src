; Owner: objects/bosses/ssz/mtz/sk
; Responsibility: Sky Sanctuary Metropolis-style boss attached actors, orbiting or moving attack states and defeat effects
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

TickSSZMTZBossLaserPairBurst:
                subi.w  #1,(SSZ_MTZ_boss_laser_timer).w
                bne.s   locret_7AB7E
                tst.b   $31(a0)
                beq.s   locret_7AB7E
                subq.b  #1,$31(a0)
                move.b  #$10,$33(a0)
                move.w  #$1E,(SSZ_MTZ_boss_laser_timer).w
                lea     ChildObjDat_7AB80(pc),a2
                jsr     (CreateChild1_Normal).l

locret_7AB7E:
                rts
; End of function TickSSZMTZBossLaserPairBurst

; ---------------------------------------------------------------------------
ChildObjDat_7AB80:
                dc.w    2-1
                dc.l    loc_7AB8E
                dc.b    -$C,  -4
                dc.l    loc_7AB8E
                dc.b    -$18,  -4
; ---------------------------------------------------------------------------

loc_7AB8E:
                lea     ObjDat3_7ABFA(pc),a1
                jsr     (SetUp_ObjAttributes).l
                movea.w parent3(a0),a1
                jsr     (Refresh_ChildPositionAdjusted).l
                moveq   #0,d0
                tst.b   subtype(a0)
                beq.s   loc_7ABB8
                moveq   #8,d0
                move.b  #$C,mapping_frame(a0)
                move.w  #$100,priority(a0)

loc_7ABB8:
                move.w  d0,$2E(a0)
                move.l  #loc_7ABC2,(a0)

loc_7ABC2:
                subq.w  #1,$2E(a0)
                bmi.s   loc_7ABCE
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7ABCE:
                move.l  #loc_7ABEE,(a0)
                move.w  #-$400,d0
                btst    #0,render_flags(a0)
                beq.s   loc_7ABE2
                neg.w   d0

loc_7ABE2:
                move.w  d0,x_vel(a0)
                moveq   #signextendB(sfx_Laser),d0
                jsr     (Play_SFX).l

loc_7ABEE:
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
ObjDat3_7ABFA:
                dc.l    Map_SSZMTZOrbs
                dc.w    make_art_tile(ArtTile_SSZMTZOrbs,1,1)
                dc.w    $280
                dc.b    $28,   8,  $D, $9C

; =============== S U B R O U T I N E =======================================

; Request an orb at flash count $1F. The player response edits the low nibble of the packed animation command
SSZMTZBoss_CheckHitOrbRelease:
                bsr.w   SSZMTZBoss_HandleHitOrDefeat
                cmpi.b  #$1F,$1C(a0)
                bne.s   loc_7AC4A
                st      $39(a0)
                lea     (_unkFA82).w,a1
                andi.b  #$F0,2(a1)
                ori.b   #5,2(a1)
                tst.b   $3C(a0)
                beq.s   loc_7AC42
                move.b  #$A,$26(a0)
                move.w  #-$180,(SSZ_MTZ_boss_Y_vel).w
                subq.b  #1,$3C(a0)
                move.w  #0,(SSZ_MTZ_boss_X_vel).w

loc_7AC42:
                move.w  #0,(SSZ_MTZ_boss_X_vel).w
                rts
; ---------------------------------------------------------------------------

loc_7AC4A:
                cmpi.b  #4,(Player_1+routine).w
                beq.s   loc_7AC5A
                cmpi.b  #4,(Player_2+routine).w
                bne.s   locret_7AC78

loc_7AC5A:
                lea     (_unkFA82).w,a1
                move.b  2(a1),d0
                andi.b  #$F,d0
                cmpi.b  #4,d0
                beq.s   locret_7AC78
                andi.b  #$F0,2(a1)
                ori.b   #4,2(a1)

locret_7AC78:
                rts
; End of function SSZMTZBoss_CheckHitOrbRelease

; ---------------------------------------------------------------------------

loc_7AC7A:
                move.l  #loc_7AC92,(a0)
                bset    #0,render_flags(a0)
                move.w  #$400,x_vel(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_7AC92:
                subq.w  #1,$2E(a0)
                bmi.s   loc_7ACA4
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7ACA4:
                clr.b   (Boss_flag).w
                bset    #4,$38(a0)
                st      (_unkFA89).w
                st      (Events_bg+$02).w
                lea     (Target_palette_line_2).w,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_7ACC0:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_7ACC0
                moveq   #PLCID_32,d0
                jsr     (Load_PLC).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
; unused
                move.b  $1D(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #6,d0
                add.w   (SSZ_MTZ_boss_Y_pos).w,d0
                move.w  d0,y_pos(a0)
                move.w  (SSZ_MTZ_boss_X_pos).w,x_pos(a0)
                addq.b  #2,$1D(a0)

; =============== S U B R O U T I N E =======================================

; The recovery timer shares storage with the hitter field. Scored defeat leaves the HUD timer running
SSZMTZBoss_HandleHitOrDefeat:
                cmpi.b  #$10,$26(a0)
                bhs.s   locret_7AD38
                tst.b   collision_property(a0)
                beq.s   loc_7AD3A
                tst.b   collision_flags(a0)
                bne.s   locret_7AD38
                tst.b   $1C(a0)
                bne.s   loc_7AD1A
                move.b  #$20,$1C(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_7AD1A:
                moveq   #0,d0
                btst    #0,$1C(a0)
                bne.s   loc_7AD28
; Bug: this should be 2*3
                addi.w  #2*2,d0

loc_7AD28:
                bsr.w   CopySSZMTZThreeColorPaletteAtByteOffset
                subq.b  #1,$1C(a0)
                bne.s   locret_7AD38
                move.b  #$F,collision_flags(a0)

locret_7AD38:
                rts
; ---------------------------------------------------------------------------

loc_7AD3A:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #loc_7AC7A,$34(a0)
                st      (_unkFA88).w
                clr.b   $38(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_7AD64
                move.b  #4,subtype(a1)

loc_7AD64:
                jmp     (BossDefeated).l
; End of function SSZMTZBoss_HandleHitOrDefeat

; =============== S U B R O U T I N E =======================================

CopySSZMTZThreeColorPaletteAtByteOffset:
                lea     word_7AD78(pc),a1
                lea     word_7AD7E(pc,d0.w),a2
                jmp     (CopyWordData_3).l
; End of function CopySSZMTZThreeColorPaletteAtByteOffset

; ---------------------------------------------------------------------------
word_7AD78:
                dc.w    Normal_palette+$0E, Normal_palette+$1C, Normal_palette+$1E
word_7AD7E:
                dc.w    8,  $866,  $222
                dc.w    $888,  $CCC,  $EEE
; ---------------------------------------------------------------------------

loc_7AD8A:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_7AD98(pc,d0.w),d1
                jmp     off_7AD98(pc,d1.w)
; ---------------------------------------------------------------------------
off_7AD98:
                dc.w    loc_7ADA2-off_7AD98
                dc.w    loc_7AE22-off_7AD98
                dc.w    loc_7AFA4-off_7AD98
                dc.w    loc_7B02A-off_7AD98
                dc.w    loc_7B116-off_7AD98
; ---------------------------------------------------------------------------

loc_7ADA2:
                movea.l a0,a1
                moveq   #7-1,d3
                moveq   #0,d2
                bra.s   loc_7ADB2
; ---------------------------------------------------------------------------

loc_7ADAA:
                jsr     (AllocateObject).l
                bne.s   locret_7AE12

loc_7ADB2:
                move.b  #$20,width_pixels(a1)
                move.l  $34(a0),$34(a1)
                move.l  #loc_7AD8A,(a1)
                move.l  #Map_SSZMTZOrbs,mappings(a1)
                move.w  #make_art_tile(ArtTile_SSZMTZOrbs,0,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.w  #$180,priority(a1)
                addq.b  #2,routine(a1)
                move.b  #0,mapping_frame(a1)
                move.b  byte_7AE14(pc,d2.w),$2E(a1)
                move.b  byte_7AE14(pc,d2.w),$41(a1)
                move.b  byte_7AE1B(pc,d2.w),$40(a1)
                move.b  #$40,$2F(a1)
                move.b  #$87,collision_flags(a1)
                move.b  #0,$42(a1)
                addq.w  #1,d2
                dbf     d3,loc_7ADAA

locret_7AE12:
                rts
; ---------------------------------------------------------------------------
byte_7AE14:
                dc.b    $24, $6C, $B4, $FC, $48, $90, $D8
byte_7AE1B:
                dc.b    0,   1,   1,   0,   1,   1,   0
                even
; ---------------------------------------------------------------------------

loc_7AE22:
                movea.l $34(a0),a1
                move.w  y_pos(a1),$30(a0)
                subi.w  #4,$30(a0)
                move.w  x_pos(a1),$3E(a0)
                tst.b   $39(a1)
                beq.s   loc_7AE9C
                move.b  #0,$39(a1)
                addi.b  #1,$30(a1)
                addq.b  #2,routine(a0)
                move.b  #$3C,$3C(a0)
                move.b  #2,anim(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #-$80,d1
                move.w  (Player_1+x_pos).w,d0
                sub.w   x_pos(a0),d0
                bpl.s   loc_7AE70
                neg.w   d1

loc_7AE70:
                cmpi.w  #$16A0,x_pos(a0)
                bhs.s   loc_7AE7C
                move.w  #$80,d1

loc_7AE7C:
                cmpi.w  #$1760,x_pos(a0)
                blo.s   loc_7AE88
                move.w  #-$80,d1

loc_7AE88:
                bclr    #0,render_flags(a0)
                tst.w   d1
                bmi.s   loc_7AE98
                bset    #0,render_flags(a0)

loc_7AE98:
                move.w  d1,x_vel(a0)

loc_7AE9C:
                bsr.w   SSZMTZOrb_ProjectOrbitAndFold
                bsr.w   SSZMTZOrb_SelectFrameAndPriority
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Use separate phases for position and depth while updating the shared fold state
SSZMTZOrb_ProjectOrbitAndFold:
                move.b  $2F(a0),d0
                jsr     (GetSineCosine).l
                move.w  d0,d3
                moveq   #0,d1
                move.b  $38(a1),d1
                muls.w  d1,d0
                move.w  d0,d5
                move.w  d0,d4
                move.b  $3A(a1),d2
                tst.b   $3B(a1)
                beq.s   loc_7AED6
                move.w  #$10,d2

loc_7AED6:
                muls.w  d3,d2
                move.w  $3E(a0),d6
                move.b  $2E(a0),d0
                jsr     (GetSineCosine).l
                muls.w  d0,d5
                swap    d5
                add.w   d6,d5
                move.w  d5,x_pos(a0)
                muls.w  d1,d4
                swap    d4
                move.w  d4,$3A(a0)
                move.w  $30(a0),d6
                move.b  $41(a0),d0
                tst.b   $3B(a1)
                beq.s   loc_7AF0A
                move.b  $42(a0),d0

loc_7AF0A:
                jsr     (GetSineCosine).l
                muls.w  d0,d2
                swap    d2
                add.w   d6,d2
                move.w  d2,y_pos(a0)
                addq.b  #4,$2E(a0)
                tst.b   $3B(a1)
                bne.s   loc_7AF2A
                addq.b  #8,$41(a0)
                rts
; ---------------------------------------------------------------------------

loc_7AF2A:
                cmpi.b  #-1,$3B(a1)
                beq.s   loc_7AF4C
                cmpi.b  #$80,$3B(a1)
                bne.s   loc_7AF44
                subq.b  #2,$42(a0)
                bpl.s   locret_7AF58
                clr.b   $42(a0)

loc_7AF44:
                move.b  #0,$3B(a1)
                rts
; ---------------------------------------------------------------------------

loc_7AF4C:
                cmpi.b  #$40,$42(a0)
                bhs.s   locret_7AF58
                addq.b  #2,$42(a0)

locret_7AF58:
                rts
; End of function SSZMTZOrb_ProjectOrbitAndFold
