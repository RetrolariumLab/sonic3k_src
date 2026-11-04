; Owner: objects/bonus/s3
; Responsibility: Gumball triangle bumpers, player collision, bounce response and shared bonus resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_GumballTriangleBumper:
                lea     ObjDat3_43F70(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_43B18,(a0)

loc_43B18:
                tst.w   ((RAM_start+$2020)&$FFFFFF).l
                bpl.s   loc_43B68
                moveq   #$D,d1
                moveq   #8,d2
                moveq   #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                btst    #$10,d6
                bne.s   loc_43B3E
                btst    #p1_standing_bit,status(a0)
                beq.s   loc_43B4C

loc_43B3E:
                lea     (Player_1).w,a1
                bsr.w   S3GumballTriangle_LaunchAndClear
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_43B4C:
                btst    #$11,d6
                bne.s   loc_43B5A
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_43B68

loc_43B5A:
                lea     (Player_2).w,a1
                bsr.w   S3GumballTriangle_LaunchAndClear
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_43B68:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Consume the bumper cell. Notify the machine to descend once both cells in the pair are empty
S3GumballTriangle_LaunchAndClear:
                move.w  #-$300,d0
                move.w  #-$600,y_vel(a1)
                bset    #Status_Facing,status(a1)
                btst    #0,render_flags(a0)
                bne.s   loc_43B8E
                bclr    #Status_Facing,status(a1)
                neg.w   d0

loc_43B8E:
                move.w  d0,x_vel(a1)
                move.w  d0,ground_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #$10,anim(a1)
                clr.b   jumping(a1)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     ((RAM_start+$2000)&$FFFFFF).l,a1
                clr.b   (a1,d0.w)
                move.w  #$F,((RAM_start+$2020)&$FFFFFF).l
                movea.w (_unkFAA4).w,a1
                bset    #0,$38(a1)
                moveq   #signextendB(sfx_Spring),d0
                jsr     (Play_SFX).l
                rts
; End of function S3GumballTriangle_LaunchAndClear

; ---------------------------------------------------------------------------

loc_43BD8:
                lea     ObjDat3_43F58(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_43BEC,(a0)
                bsr.w   S3GumballDecor_SelectFrameAndMask

loc_43BEC:
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_43BF8:
                lea     ObjDat3_43FA0(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_43C0C,(a0)
                bsr.w   GumballS3OffsetDebrisAndSeedSubtypeDelay

loc_43C0C:
                subq.b  #1,$2E(a0)
                bpl.s   loc_43C18
                move.l  #MoveChkDel,(a0)

loc_43C18:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_43C1E:
                addi.w  #$2A0,y_pos(a0)
                move.l  #loc_43C2A,(a0)

loc_43C2A:
                subq.w  #1,((RAM_start+$2020)&$FFFFFF).l
                lea     word_43C7C(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.w   d0
                bne.s   loc_43C50
                swap    d0
                tst.w   d0
                beq.w   locret_43A92
                lea     (Player_2).w,a1
                jmp     (Delete_Referenced_Sprite).l
; ---------------------------------------------------------------------------

loc_43C50:
                move.w  (Saved_zone_and_act).w,(Current_zone_and_act).w
                move.w  (Saved_apparent_zone_and_act).w,(Apparent_zone_and_act).w
                move.b  (Saved_last_star_post_hit).w,(Last_star_post_hit).w
                move.b  #0,(Special_bonus_entry_flag).w
                move.b  #1,(Restart_level_flag).w
                move.w  (Ring_count).w,(Saved_ring_count).w
                move.b  (Extra_life_flags).w,(Saved_extra_life_flags).w
                rts
; ---------------------------------------------------------------------------
word_43C7C:
                dc.w    -$100,  $200,  -$10,   $40
; ---------------------------------------------------------------------------

loc_43C84:
                lea     ObjDat3_43FB8(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_43C94,(a0)

loc_43C94:
                st      (Spritemask_flag).w
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

; Check both players, dispatch one subtype effect and return Z when the item should remain
S3Gumball_TryRewardNearbyPlayer:
                lea     word_43CE4(pc),a1
                jsr     (Check_PlayerInRange).l
                tst.l   d0
                beq.s   locret_43CD0
                moveq   #0,d1
                moveq   #1,d2
                move.b  subtype(a0),d1
                add.w   d1,d1
                move.w  off_43CD2(pc,d1.w),d1
                jsr     off_43CD2(pc,d1.w)
                tst.w   d2

locret_43CD0:
                rts
; End of function S3Gumball_TryRewardNearbyPlayer

; ---------------------------------------------------------------------------
off_43CD2:
                dc.w    loc_43CEC-off_43CD2
                dc.w    loc_43CFC-off_43CD2
                dc.w    loc_43D1A-off_43CD2
                dc.w    locret_43D18-off_43CD2
                dc.w    loc_43D28-off_43CD2
                dc.w    loc_43DA2-off_43CD2
                dc.w    loc_43DCC-off_43CD2
                dc.w    loc_43DF6-off_43CD2
                dc.w    loc_43E30-off_43CD2
word_43CE4:
                dc.w    -$18,   $30,  -$18,   $30
; ---------------------------------------------------------------------------

loc_43CEC:
                addq.b  #1,(Life_count).w
                addq.b  #1,(Update_HUD_life_count).w
                moveq   #signextendB(mus_ExtraLife),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

loc_43CFC:
                tst.b   ((RAM_start+$2022)&$FFFFFF).l
                bne.s   locret_43CD0
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_43CD0
                move.l  #loc_43932,(a1)
                st      ((RAM_start+$2022)&$FFFFFF).l

locret_43D18:
                rts
; ---------------------------------------------------------------------------

loc_43D1A:
                addi.w  #20,(Saved_ring_count).w
                moveq   #10,d0
                jmp     (AddRings).l
; ---------------------------------------------------------------------------

loc_43D28:
                move.l  d0,-(sp)
                tst.w   d0
                beq.s   loc_43D30
                bsr.s   S3GumballRound_RepelPlayer

loc_43D30:
                move.l  (sp)+,d0
                swap    d0
                tst.w   d0
                beq.s   loc_43D3A
                bsr.s   S3GumballRound_RepelPlayer

loc_43D3A:
                clr.b   collision_property(a0)
                moveq   #0,d2
                rts

; =============== S U B R O U T I N E =======================================

; Use magnitude $700 and perturb the angle with the high byte of the frame counter
S3GumballRound_RepelPlayer:
                movea.w d0,a1
                move.w  x_pos(a0),d1
                move.w  y_pos(a0),d2
                sub.w   x_pos(a1),d1
                sub.w   y_pos(a1),d2
                jsr     (GetArcTan).l
                move.b  (Level_frame_counter).w,d1
                andi.w  #3,d1
                add.w   d1,d0
                jsr     (GetSineCosine).l
                muls.w  #-$700,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a1)
                muls.w  #-$700,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                bclr    #Status_Push,status(a1)
                clr.b   jumping(a1)
                move.b  #1,anim(a0)
                moveq   #signextendB(sfx_SmallBumpers),d0
                jmp     (Play_SFX).l
; End of function S3GumballRound_RepelPlayer

; ---------------------------------------------------------------------------

loc_43DA2:
                lea     (Player_1).w,a1
                move.l  #Obj_FireShield,(Shield).w
                move.w  a1,(Shield+parent).w
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                moveq   #Status_FireShield,d0
                bsr.w   S3Gumball_SetLiveAndSavedShield
                moveq   #signextendB(sfx_FireShield),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

loc_43DCC:
                lea     (Player_1).w,a1
                move.l  #Obj_BubbleShield,(Shield).w
                move.w  a1,(Shield+parent).w
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                moveq   #Status_BublShield,d0
                bsr.w   S3Gumball_SetLiveAndSavedShield
                moveq   #signextendB(sfx_BubbleShield),d0
                jmp     (Play_Music).l
; ---------------------------------------------------------------------------

loc_43DF6:
                lea     (Player_1).w,a1
                move.l  #Obj_LightningShield,(Shield).w
                move.w  a1,(Shield+parent).w
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                moveq   #Status_LtngShield,d0
                bsr.w   S3Gumball_SetLiveAndSavedShield
                moveq   #signextendB(sfx_LightningShield),d0
                jmp     (Play_Music).l

; =============== S U B R O U T I N E =======================================

; Set the live shield bit and replace the saved elemental bits used when returning to the main level
S3Gumball_SetLiveAndSavedShield:
                bset    d0,status_secondary(a1)
                lea     (Saved_status_secondary).w,a2
                andi.b  #$8F,(a2)
                bset    d0,(a2)
                rts
; End of function S3Gumball_SetLiveAndSavedShield

; ---------------------------------------------------------------------------

loc_43E30:
                bset    #7,(Saved_status_secondary).w
                rts

; =============== S U B R O U T I N E =======================================

; When flagged, count leading empty occupancy words to choose the target. Move down four pixels per update
S3GumballMachine_UpdateDescent:
                bclr    #0,$38(a0)
                beq.s   loc_43E60
                lea     ((RAM_start+$2000)&$FFFFFF).l,a1
                moveq   #0,d0
                moveq   #$E-1,d1

loc_43E4A:
                tst.w   (a1)+
                bne.s   loc_43E56
                addi.w  #$20,d0
                dbf     d1,loc_43E4A

loc_43E56:
                move.w  $3A(a0),d1
                add.w   d0,d1
                move.w  d1,$3C(a0)

loc_43E60:
                move.w  $3C(a0),d1
                move.w  y_pos(a0),d2
                cmp.w   d1,d2
                bhs.s   locret_43E72
                addq.w  #4,d2
                move.w  d2,y_pos(a0)

locret_43E72:
                rts
; End of function S3GumballMachine_UpdateDescent

; =============== S U B R O U T I N E =======================================

; Use the weighted 16-entry table and honor only the first index-zero life roll for each machine
S3GumballMachine_ChooseDrop:
                jsr     (Random_Number).l
                andi.w  #$F,d0
                bne.s   loc_43E8E
                movea.w parent3(a0),a1
                bset    #7,$38(a1)
                beq.s   loc_43E8E
                moveq   #3,d0

loc_43E8E:
                move.b  byte_43EAC(pc,d0.w),d0
                move.b  d0,subtype(a0)
                cmpi.b  #4,d0
                bne.s   loc_43EA2
                move.b  #$D7,collision_flags(a0)

loc_43EA2:
                lsl.w   #2,d0
                move.l  off_43EBC(pc,d0.w),$30(a0)
                rts
; End of function S3GumballMachine_ChooseDrop

; ---------------------------------------------------------------------------
byte_43EAC:
                dc.b    0
                dc.b    3
                dc.b    1
                dc.b    4
                dc.b    2
                dc.b    4
                dc.b    5
                dc.b    4
                dc.b    6
                dc.b    3
                dc.b    7
                dc.b    4
                dc.b    5
                dc.b    6
                dc.b    7
                dc.b    2
                even
off_43EBC:
                dc.l    byte_44032
                dc.l    byte_44036
                dc.l    byte_4403A
                dc.l    byte_4403E
                dc.l    byte_44042
                dc.l    byte_44046
                dc.l    byte_4404A
                dc.l    byte_4404E
                dc.l    byte_44052

; =============== S U B R O U T I N E =======================================

; Pass the fixed refill-platform dimensions and current X, then tail-call the supplied worker in a1
S3GumballPlatform_CallSolidity:
                moveq   #$4B,d1
                moveq   #$10,d2
                moveq   #$11,d3
                move.w  x_pos(a0),d4
                jmp     (a1)
; End of function S3GumballPlatform_CallSolidity

; =============== S U B R O U T I N E =======================================

GumballS3OffsetDebrisAndSeedSubtypeDelay:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.b  d0,$2E(a0)
                lea     byte_43F0E(pc,d0.w),a1
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,x_pos(a0)
                moveq   #0,d0
                move.b  (a1)+,d0
                ext.w   d0
                add.w   d0,y_pos(a0)
                rts
; End of function GumballS3OffsetDebrisAndSeedSubtypeDelay

; ---------------------------------------------------------------------------
byte_43F0E:
                dc.b    -8,   8
                dc.b    8,   8
                dc.b    -8,  -8
                dc.b    8,  -8
                dc.b    -$18,   8
                dc.b    $18,   8
                dc.b    -$18,  -8
                dc.b    $18,  -8
                dc.b    -$28,   8
                dc.b    $28,   8
                dc.b    -$28,  -8
                dc.b    $28,  -8
                dc.b    -$38,   8
                dc.b    $38,   8
                dc.b    -$38,  -8
                dc.b    $38,  -8
                even

; =============== S U B R O U T I N E =======================================

; Subtype selects one of four decoration frames and can spawn the central mask sprite
S3GumballDecor_SelectFrameAndMask:
                moveq   #0,d0
                move.b  subtype(a0),d0
                subi.w  #6,d0
                lsr.w   #1,d0
                move.b  RawAni_43F54(pc,d0.w),d0
                move.b  d0,mapping_frame(a0)
                cmpi.b  #$16,d0
                bne.w   locret_43A92
                lea     ChildObjDat_44016(pc),a2
                jmp     (CreateChild6_Simple).l
; End of function S3GumballDecor_SelectFrameAndMask

; ---------------------------------------------------------------------------
RawAni_43F54:
                dc.b    0,   1,   0, $16
ObjDat3_43F58:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,0,0)
                dc.w    $200
                dc.b    $10, $20,   0,   0
ObjDat3_43F64:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    $40, $10, $13,   0
ObjDat3_43F70:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    4, $10, $12,   0
ObjDat_GumballMachine:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    $18, $18,   5,   0
ObjDat3_43F88:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    $14, $14,   2,   0
ObjDat3_43F94:
                dc.l    Map_Spring
                dc.w    make_art_tile(ArtTile_SpikesSprings+$10,0,0)
                dc.w    $100
                dc.b    $10, $10,   0,   0
ObjDat3_43FA0:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,1,1)
                dc.w    $100
                dc.b    8,   8, $15,   0
ObjDat3_43FAC:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile(ArtTile_BonusStage,0,1)
                dc.w    $100
                dc.b    8,   8,   8,   0
ObjDat3_43FB8:
                dc.l    Map_GumballBonus
                dc.w    make_art_tile($000,0,0)
                dc.w    $180
                dc.b    4, $10, $17,   0
ChildObjDat_43FC4:
                dc.w    7-1
                dc.l    loc_43932
                dc.b    0,   0
                dc.l    loc_43A26
                dc.b    0, $24
                dc.l    loc_43C1E
                dc.b    0,   0
                dc.l    loc_43BD8
                dc.b    -$38,-$2C
                dc.l    loc_43BD8
                dc.b    0,-$2C
                dc.l    loc_43BD8
                dc.b    $38,-$2C
                dc.l    loc_43BD8
                dc.b    0,-$28
word_43FF0:
                dc.w    4-1
                dc.l    loc_43986
                dc.b    -$30,-$18
                dc.l    loc_43986
                dc.b    -$10,-$18
                dc.l    loc_43986
                dc.b    $10,-$18
                dc.l    loc_43986
                dc.b    $30,-$18
ChildObjDat_4400A:
                dc.w    $10-1
                dc.l    loc_43BF8
ChildObjDat_44010:
                dc.w    1-1
                dc.l    loc_43A94
ChildObjDat_44016:
                dc.w    1-1
                dc.l    loc_43C84
byte_4401C:
                dc.b    3,   5,   6,   7, $14,   5, $F4
                dc.b    $7F,   5,   5, $FC
byte_44027:
                dc.b    2,   3,   3,   3,   4,  $F,   3,   3,   2,   3, $F4
byte_44032:
                dc.b    $7F,   8,   8, $FC
byte_44036:
                dc.b    $7F,   9,   9, $FC
byte_4403A:
                dc.b    $7F,  $A,  $A, $FC
byte_4403E:
                dc.b    $7F,  $B,  $B, $FC
byte_44042:
                dc.b    $7F,  $C,  $C, $FC
byte_44046:
                dc.b    $7F,  $D,  $D, $FC
byte_4404A:
                dc.b    $7F,  $E,  $E, $FC
byte_4404E:
                dc.b    $7F,  $F,  $F, $FC
byte_44052:
                dc.b    1, $10, $11, $FC
