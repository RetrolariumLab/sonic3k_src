; Owner: objects/zones/hpz/sk
; Responsibility: Hidden Palace special-stage selection, transition, hub state and common emerald control helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HPZSSEntryControl:
                lea     (ArtKosM_HPZSmallEmeralds).l,a1
                move.w  #tiles_to_bytes(ArtTile_HPZSmallEmeralds),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_Teleporter).l,a1
                move.w  #tiles_to_bytes(ArtTile_HPZEntryTeleporter),d2
                jsr     (Queue_Kos_Module).l
                lea     (Pal_CutsceneKnux).l,a1
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_90998
                lea     (Pal_SonicTails).l,a1

loc_90998:
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d0

loc_9099E:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_9099E
                lea     (Pal_HPZ+$20).l,a1
                lea     (Target_palette_line_3).w,a2
                moveq   #bytesToLcnt($40),d6

loc_909B0:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_909B0
                move.l  #$6A00660,(Target_palette_line_4+$2).w
                jsr     (AllocateObject).l
                bne.s   loc_909CC
                move.l  #Obj_HPZMasterEmerald,(a1)

loc_909CC:
                jsr     (AllocateObject).l
                bne.s   loc_909EA
                move.l  #Obj_SSZHPZTeleporter,(a1)
                move.w  #$1640,x_pos(a1)
                move.w  #$3C7,y_pos(a1)
                move.w  a1,$44(a0)

loc_909EA:
                tst.w   (HPZ_special_stage_completed).w
                beq.s   loc_90A10
                moveq   #0,d2
                moveq   #7-1,d3

loc_909F4:
                jsr     (AllocateObject).l
                move.l  #Obj_HPZSuperEmerald,(a1)
                move.b  d2,subtype(a1)
                addq.w  #1,d2
                dbf     d3,loc_909F4
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_90A10:
                move.l  #loc_90A72,(a0)
                move.w  #$1F,$2E(a0)
                lea     (Collected_emeralds_array).w,a2
                moveq   #2,d1
                moveq   #0,d2
                moveq   #7-1,d3

loc_90A26:
                cmp.b   (a2)+,d1
                bhi.s   loc_90A3A
                jsr     (AllocateObject).l
                move.l  #Obj_HPZSuperEmerald,(a1)
                move.b  d2,subtype(a1)

loc_90A3A:
                addq.w  #1,d2
                dbf     d3,loc_90A26
                lea     (Player_1).w,a1
                bsr.w   PreparePlayerForHpzEmeraldConversion
                lea     (Player_2).w,a1

; =============== S U B R O U T I N E =======================================

PreparePlayerForHpzEmeraldConversion:
                move.b  #$83,object_control(a1)
                bset    #7,art_tile(a1)
                move.b  #0,mapping_frame(a1)
                move.b  #$1C,anim(a1)
                move.w  #$1640,x_pos(a1)
                move.w  #$3A3,y_pos(a1)
                rts
; End of function PreparePlayerForHpzEmeraldConversion

; ---------------------------------------------------------------------------

loc_90A72:
                subq.w  #1,$2E(a0)
                bpl.s   locret_90A92
                move.l  #loc_90A94,(a0)
                jsr     (AllocateObject).l
                bne.s   locret_90A92
                move.l  #loc_90CA2,(a1)
                move.b  #7,subtype(a1)

locret_90A92:
                rts
; ---------------------------------------------------------------------------

loc_90A94:
                bclr    #0,(_unkFAB8).w
                beq.w   locret_90C32
                lea     (Collected_emeralds_array).w,a1
                lea     byte_90B1A(pc),a2
                lea     (_unkFA82).w,a3
                lea     word_90B0C(pc),a4
                lea     (_unkFAB0).w,a5
                moveq   #0,d0
                moveq   #0,d1
                moveq   #0,d2
                moveq   #7-1,d3

loc_90ABA:
                move.b  (a2)+,d0
                move.b  (a1,d0.w),d4
                beq.s   loc_90AD2
                cmpi.b  #1,d4
                bne.s   loc_90AD2
                move.b  d0,(a5)+
                add.w   d0,d0
                move.w  (a4,d0.w),(a3)+
                moveq   #1,d1

loc_90AD2:
                cmpi.b  #2,d4
                bne.s   loc_90ADA
                moveq   #1,d2

loc_90ADA:
                dbf     d3,loc_90ABA
                clr.w   (a3)
                tst.w   d1
                bne.s   loc_90AF2
                tst.w   d2
                bne.s   loc_90AEE
                bset    #5,$38(a0)

loc_90AEE:
                bra.w   loc_90C16
; ---------------------------------------------------------------------------

loc_90AF2:
                move.l  #loc_90B22,(a0)
                move.w  #$21F,$2E(a0)
                st      (Emeralds_converted_flag).w
                lea     ChildObjDat_90FEA(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------
word_90B0C:
                dc.w    $15A0, $1540, $1600, $1520, $1620, $1520, $1620
byte_90B1A:
                dc.b    5,   3,   1,   0,   2,   4,   6
                even
; ---------------------------------------------------------------------------

loc_90B22:
                subq.w  #1,$2E(a0)
                bpl.w   locret_90C32
                move.l  #loc_90BF4,$34(a0)

loc_90B32:
                move.l  #loc_90BD2,(a0)
                st      (Scroll_lock).w
                moveq   #0,d0
                move.b  $39(a0),d0
                addq.b  #1,$39(a0)
                lea     (_unkFAB0).w,a1
                moveq   #0,d1
                move.b  (a1,d0.w),d1
                move.b  d1,$3C(a0)
                add.w   d0,d0
                lea     (_unkFA82).w,a1
                move.w  (a1,d0.w),$3A(a0)
                bne.s   loc_90B72
                move.l  #loc_90C16,$34(a0)
                move.w  #$15A0,$3A(a0)
                moveq   #2,d1

loc_90B72:
                add.w   d1,d1
                lea     byte_90BBC(pc,d1.w),a2
                lea     (Player_1).w,a1
                bsr.w   SetPlayerHpzEmeraldViewingPose
                lea     (Player_2).w,a1

; =============== S U B R O U T I N E =======================================

SetPlayerHpzEmeraldViewingPose:
                bclr    #0,render_flags(a1)
                bclr    #Status_Facing,status(a1)
                tst.b   (a2)
                beq.s   loc_90BA0
                bset    #0,render_flags(a1)
                bset    #Status_Facing,status(a1)

loc_90BA0:
                moveq   #0,d0
                move.b  1(a2),d0
                add.b   character_id(a1),d0
                move.b  RawAni_90BCA(pc,d0.w),mapping_frame(a1)
                move.l  a2,-(sp)
                jsr     (Player_Load_PLC2).l
                movea.l (sp)+,a2
                rts
; End of function SetPlayerHpzEmeraldViewingPose

; ---------------------------------------------------------------------------
byte_90BBC:
                dc.b    1,   4
                dc.b    1,   0
                dc.b    0,   0
                dc.b    1,   4
                dc.b    0,   4
                dc.b    1,   0
                dc.b    0,   0
RawAni_90BCA:
                dc.b    $BA, $AD, $56
                even
                dc.b    $C4, $B0, $D6
                even
; ---------------------------------------------------------------------------

loc_90BD2:
                move.w  (Camera_X_pos).w,d0
                moveq   #-$10,d1
                sub.w   $3A(a0),d0
                bpl.s   loc_90BE2
                neg.w   d0
                neg.w   d1

loc_90BE2:
                cmpi.w  #$10,d0
                blo.s   loc_90BEE
                add.w   d1,(Camera_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_90BEE:
                movea.l $34(a0),a1
                jmp     (a1)
; ---------------------------------------------------------------------------

loc_90BF4:
                move.l  #loc_90C2A,(a0)
                move.w  #$1F,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   locret_90C14
                move.l  #loc_90CA2,(a1)
                move.b  $3C(a0),subtype(a1)

locret_90C14:
                rts
; ---------------------------------------------------------------------------

loc_90C16:
                move.l  #loc_90C34,(a0)
                clr.b   (Scroll_lock).w
                clr.b   (Player_1+object_control).w
                clr.b   (Player_2+object_control).w
                rts
; ---------------------------------------------------------------------------

loc_90C2A:
                subq.w  #1,$2E(a0)
                bmi.w   loc_90B32

locret_90C32:
                rts
; ---------------------------------------------------------------------------

loc_90C34:
                lea     (Player_1).w,a1
                move.w  x_pos(a1),d0
                subi.w  #$1640,d0
                bpl.s   loc_90C44
                neg.w   d0

loc_90C44:
                cmpi.w  #8,d0
                blo.s   loc_90C58
                cmpi.w  #$18,d0
                blo.s   locret_90CA0
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_90C58:
                bclr    #3,$38(a0)
                beq.s   locret_90CA0
                movea.w $44(a0),a1
                btst    #3,status(a1)
                beq.s   locret_90CA0
                btst    #5,$38(a0)
                beq.s   locret_90CA0
                moveq   #signextendB(sfx_EnterSS),d0
                jsr     (Play_SFX).l
                move.w  #1,(Restart_level_flag).w
                move.b  (Saved2_last_star_post_hit).w,(Last_star_post_hit).w
                move.w  (Saved2_zone_and_act).w,(Current_zone_and_act).w
                move.w  (Saved2_apparent_zone_and_act).w,(Apparent_zone_and_act).w
                move.b  (Player_1+status_secondary).w,(Saved2_status_secondary).w
                ori.b   #$80,(Last_star_post_hit).w

locret_90CA0:
                rts
; ---------------------------------------------------------------------------

loc_90CA2:
                lea     ObjDat3_90FCC(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_90CF4,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                lea     word_90CD4(pc,d0.w),a1
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,$3A(a0)
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$80,d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
word_90CD4:
                dc.w    $1640,  $300
                dc.w    $15E0,  $328
                dc.w    $16A0,  $328
                dc.w    $15A0,  $2D8
                dc.w    $16E0,  $2D8
                dc.w    $1550,  $318
                dc.w    $1730,  $318
                dc.w    $1640,  $340
; ---------------------------------------------------------------------------

loc_90CF4:
                move.w  y_pos(a0),d0
                addi.w  #$10,d0
                move.w  d0,y_pos(a0)
                cmp.w   $3A(a0),d0
                blo.s   loc_90D20
                move.l  #loc_90D30,(a0)
                move.w  #$3F,$2E(a0)
                move.w  #8,(Screen_shake_flag).w
                moveq   #signextendB(sfx_BossLaser),d0
                jsr     (Play_SFX).l

loc_90D20:
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_90C32
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_90D30:
                subq.w  #1,$2E(a0)
                bmi.s   loc_90D42
                cmpi.w  #$20,$2E(a0)
                bne.s   loc_90D20
                bsr.w   ApplyHpzConversionBeamMidpoint

loc_90D42:
                move.l  #loc_90D52,(a0)
                move.l  #loc_90D5E,$34(a0)
                bra.s   loc_90D20
; ---------------------------------------------------------------------------

loc_90D52:
                lea     byte_90FF6(pc),a1
                jsr     (Animate_RawNoSST).l
                bra.s   loc_90D20
; ---------------------------------------------------------------------------

loc_90D5E:
                bset    #0,(_unkFAB8).w
                move.w  $44(a0),d0
                beq.s   loc_90D72
                movea.w d0,a1
                bset    #5,$38(a1)

loc_90D72:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_90D78:
                move.l  #loc_90DA2,(a0)
                bset    #2,render_flags(a0)
                move.w  #-$80,y_vel(a0)
                move.w  #$7F,$2E(a0)
                moveq   #signextendB(sfx_Signpost),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_90FF0(pc),a2
                jsr     (CreateChild6_Simple).l

loc_90DA2:
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   locret_90DD6
                move.l  #loc_90DDC,(a0)
                lea     (Player_1).w,a1
                bsr.w   SetPlayerHpzEmeraldRevealPose
                lea     (Player_2).w,a1

; =============== S U B R O U T I N E =======================================

SetPlayerHpzEmeraldRevealPose:
                moveq   #0,d0
                move.b  character_id(a1),d0
                move.b  byte_90DD8(pc,d0.w),mapping_frame(a1)
                move.l  a2,-(sp)
                jsr     (Player_Load_PLC2).l
                movea.l (sp)+,a2

locret_90DD6:
                rts
; End of function SetPlayerHpzEmeraldRevealPose

; ---------------------------------------------------------------------------
byte_90DD8:
                dc.b    $C4, $B0, $D6
                even
; ---------------------------------------------------------------------------

loc_90DDC:
                cmpi.b  #$7F,$27(a0)
                bne.s   locret_90DFA
                bset    #2,$38(a0)
                bset    #7,$38(a0)
                bne.s   locret_90DFA
                moveq   #signextendB(sfx_SuperEmerald),d0
                jsr     (Play_SFX).l

locret_90DFA:
                rts
; ---------------------------------------------------------------------------

loc_90DFC:
                lea     ObjDat3_90FD8(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_90E1C,(a0)
                bset    #7,render_flags(a0)
                move.w  #$7F,$2E(a0)
                bsr.w   InitializeHpzChaosEmeraldConversionParticle

loc_90E1C:
                move.w  $3A(a0),d0
                addi.w  #$10,d0
                move.w  d0,$3A(a0)
                cmpi.w  #$1800,d0
                blo.s   loc_90E34
                move.l  #loc_90E4E,(a0)

loc_90E34:
                addq.b  #4,$3C(a0)
                jsr     (MoveSprite_Circular).l

loc_90E3E:
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_90C32
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_90E4E:
                move.b  $3D(a0),d0
                sub.b   $3C(a0),d0
                cmpi.b  #4,d0
                blo.s   loc_90E5E
                bra.s   loc_90E34
; ---------------------------------------------------------------------------

loc_90E5E:
                move.l  #loc_90E72,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                movea.w parent3(a0),a1
                bset    d0,$27(a1)

loc_90E72:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   loc_90E3E
                move.l  #loc_90E86,(a0)
                bra.s   loc_90E3E
; ---------------------------------------------------------------------------

loc_90E86:
                tst.b   render_flags(a0)
                bpl.s   loc_90E94
                jsr     (MoveSprite2).l
                bra.s   loc_90E3E
; ---------------------------------------------------------------------------

loc_90E94:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

ApplyHpzConversionBeamMidpoint:
                cmpi.b  #7,subtype(a0)
                bne.s   loc_90ED0
                lea     (Player_1).w,a1
                bsr.w   SetPlayerHpzBeamReactionPose
                lea     (Player_2).w,a1
; End of function ApplyHpzConversionBeamMidpoint

; =============== S U B R O U T I N E =======================================

SetPlayerHpzBeamReactionPose:
                moveq   #0,d0
                move.b  character_id(a1),d0
                cmpi.b  #1,d0
                bne.s   loc_90EBE
                addq.w  #4,y_pos(a1)

loc_90EBE:
                move.b  RawAni_90F06(pc,d0.w),mapping_frame(a1)
                move.b  #5,anim(a1)
                jmp     (Player_Load_PLC2).l
; End of function SetPlayerHpzBeamReactionPose

; ---------------------------------------------------------------------------

loc_90ED0:
                lea     (Collected_emeralds_array).w,a1
                moveq   #0,d0
                move.b  subtype(a0),d0
                addq.b  #1,(a1,d0.w)
                jsr     (AllocateObject).l
                bne.s   loc_90EFC
                move.l  #Obj_HPZSuperEmerald,(a1)
                move.b  subtype(a0),subtype(a1)
                bset    #7,$38(a1)
                move.w  a1,$44(a0)

loc_90EFC:
                st      (SRAM_mask_interrupts_flag).w
                jmp     (SaveGame_SpecialStage).l
; ---------------------------------------------------------------------------
RawAni_90F06:
                dc.b    $BA, $AD, $56
                even

; =============== S U B R O U T I N E =======================================

InitializeHpzChaosEmeraldConversionParticle:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d0
                move.b  d0,subtype(a0)
                move.b  byte_90F64(pc,d0.w),$3C(a0)
                move.b  byte_90F6C(pc,d0.w),$3D(a0)
                lea     (Collected_emeralds_array).w,a1
                move.b  (a1,d0.w),d2
                beq.s   loc_90F54
                cmpi.b  #2,d2
                bhs.s   loc_90F54
                move.b  d0,mapping_frame(a0)
                add.w   d1,d1
                move.l  word_90F74(pc,d1.w),x_vel(a0)   ; and y_vel
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_90F4A
                addq.w  #2,d1

loc_90F4A:
                move.w  word_90F90(pc,d1.w),d2
                move.w  d2,art_tile(a0)
                rts
; ---------------------------------------------------------------------------

loc_90F54:
                movea.w parent3(a0),a1
                bset    d0,$27(a1)
                addq.w  #4,sp
                jmp     (Delete_Current_Sprite).l
; End of function InitializeHpzChaosEmeraldConversionParticle

; ---------------------------------------------------------------------------
byte_90F64:
                dc.b    0, $24, $48, $6C, $90, $B4, $D8
                even
byte_90F6C:
                dc.b    $80, $86, $7A, $8C, $74, $92, $6E
                even
word_90F74:
                dc.w    0, -$400
                dc.w    -$F8, -$3E0
                dc.w    $F8, -$3E0
                dc.w    -$1E0, -$384
                dc.w    $1E0, -$384
                dc.w    -$2AC, -$2F4
                dc.w    $2AC, -$2F4
word_90F90:
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,2,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,2,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,0,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,1,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,2,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,2,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,0,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,1,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,0,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,1,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,0,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,1,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,3,1)
                dc.w    make_art_tile(ArtTile_HPZSmallEmeralds,3,1)
