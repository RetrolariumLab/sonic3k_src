; Owner: objects/ending/sk
; Responsibility: Ending scene coordination, player character state, completion progression and retained legacy credits return entry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

S3Credits:
                rts
; ---------------------------------------------------------------------------

Obj_5D86A:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5D89C(pc,d0.w),d1
                jsr     off_5D89C(pc,d1.w)
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_5D886
                move.b  #$7F,(Palette_timer).w

loc_5D886:
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_5D89C:
                dc.w    loc_5D8BC-off_5D89C
                dc.w    loc_5D9EE-off_5D89C
                dc.w    loc_5DA50-off_5D89C
                dc.w    loc_5DA74-off_5D89C
                dc.w    loc_5DB2C-off_5D89C
                dc.w    loc_5DB60-off_5D89C
                dc.w    loc_5DB76-off_5D89C
                dc.w    loc_5DBBE-off_5D89C
                dc.w    loc_5DBDC-off_5D89C
                dc.w    loc_5DBF6-off_5D89C
                dc.w    loc_5DC2C-off_5D89C
                dc.w    loc_5DC98-off_5D89C
                dc.w    loc_5DCA6-off_5D89C
                dc.w    loc_5DD34-off_5D89C
                dc.w    loc_5DD6A-off_5D89C
                dc.w    loc_5DE1A-off_5D89C
; ---------------------------------------------------------------------------

loc_5D8BC:
                lea     ObjDat3_600DA(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                move.b  #2,routine(a0)
                bsr.w   sub_5FE82
                st      (Scroll_lock).w
                clr.b   (_unkFAB8).w
                lea     (Player_1).w,a1
                bclr    #2,render_flags(a1)
                bset    #7,art_tile(a1)
                move.b  #$81,object_control(a1)
                move.b  #$F,anim(a1)
                clr.b   status(a1)
                move.w  #$800,ground_vel(a1)
                clr.l   (Player_2).w
                cmpi.w  #2,(Player_mode).w
                move.w  #$7FFF,(Super_frame_count).w
                move.b  #1,(Update_HUD_timer).w
                tst.b   (_unkFA88).w
                bmi.w   loc_5D96A
                bne.s   loc_5D944
                cmpi.w  #2,(Player_mode).w
                bhs.w   loc_5D96A
                bsr.w   sub_5FC8E
                jsr     (AllocateObject).l
                bne.s   loc_5D940
                move.l  #Obj_Ending_RevertSuperSonic,(a1)

loc_5D940:
                bra.w   loc_5D95C
; ---------------------------------------------------------------------------

loc_5D944:
                clr.b   (Player_1+anim).w
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_5D958
                bsr.w   sub_5FCB4
                bra.w   loc_5D96A
; ---------------------------------------------------------------------------

loc_5D958:
                bsr.w   sub_5FCCE

loc_5D95C:
                move.l  #$EEE0EEE,d0
                move.l  d0,(Normal_palette+$4).w
                move.w  d0,(Normal_palette+$8).w

loc_5D96A:
                move.w  #$100,x_pos(a0)
                move.w  #$E0,y_pos(a0)
                lea     (Dynamic_object_RAM+(object_size*5)).w,a1
                move.w  a1,$44(a0)
                move.l  #Obj_5EA52,(a1)
                st      $2C(a1)
                bset    #2,$38(a1)
                move.w  a0,$46(a1)
                lea     (Dynamic_object_RAM+(object_size*45)).w,a1
                move.l  #Obj_5DE60,(a1)
                move.w  a0,$46(a1)
                move.w  #$11E,x_pos(a1)
                move.w  #$CF,y_pos(a1)
                lea     (Pal_SSZ2+$20).l,a1
                lea     (Target_palette_line_3).w,a2
                moveq   #bytesToLcnt($20),d6

loc_5D9B8:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_5D9B8
                lea     (ArtKosM_EndingMasterEmerald).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_MasterEmerald),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SonicPlane).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Plane),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_SonicPlaneEnding).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_PlaneExtra),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_5D9EE:
                cmpi.w  #$EEE,(Normal_palette+$2).w
                bne.s   loc_5DA12
                bset    #7,$38(a0)
                bne.s   loc_5DA12
                move.b  #1,(_unkFAC1).w
                jsr     (AllocateObject).l
                bne.s   loc_5DA12
                move.l  #loc_5DF58,(a1)

loc_5DA12:
                move.l  (_unkEE9C).w,d0
                addi.l  #$8000,d0
                move.l  d0,(_unkEE9C).w
                cmpi.l  #$800000,d0
                blo.s   locret_5DA4E
                move.b  #4,routine(a0)
                jsr     (AllocateObject).l
                bne.s   loc_5DA3C
                move.l  #loc_5F94C,(a1)

loc_5DA3C:
                move.b  #$1F,(_unkFAB9).w
                move.w  #-$100,(_unkFAC2).w
                move.w  #-$100,(_unkFAC4).w

locret_5DA4E:
                rts
; ---------------------------------------------------------------------------

loc_5DA50:
                move.l  (_unkEE9C).w,d0
                addi.l  #$8000,d0
                move.l  d0,(_unkEE9C).w
                cmpi.l  #$1000000,d0
                blo.s   locret_5DA72
                move.b  #6,routine(a0)
                bset    #3,$38(a0)

locret_5DA72:
                rts
; ---------------------------------------------------------------------------

loc_5DA74:
                movea.w $44(a0),a1
                move.w  x_pos(a1),d0
                addi.w  #$20,d0
                cmp.w   x_pos(a0),d0
                bgt.s   loc_5DA96
                move.l  (_unkEE9C).w,d0
                addi.l  #$8000,d0
                move.l  d0,(_unkEE9C).w
                rts
; ---------------------------------------------------------------------------

loc_5DA96:
                move.b  #8,routine(a0)
                bset    #0,(_unkFAB8).w
                move.w  #$20,$2E(a0)
                moveq   #-$20,d0
                move.b  d0,$42(a1)
                move.w  x_pos(a1),d1
                neg.w   d0
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                moveq   #$2B,d0
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_5DACC
                subq.b  #4,d0
                bclr    #2,(Tails_tails+render_flags).w

loc_5DACC:
                move.b  d0,$43(a1)
                move.w  y_pos(a1),d1
                neg.w   d0
                add.w   d0,d1
                move.w  d1,y_pos(a0)
                move.w  d1,$3A(a0)
                lea     (Player_1).w,a1
                tst.b   (_unkFA88).w
                bmi.s   loc_5DB1C
                beq.s   loc_5DB1C
                move.b  #2,(Super_palette_status).w
                move.w  #$1E,(Palette_frame).w
                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #0,(Super_Tails_flag).w
                move.l  #Map_Sonic,mappings(a1)
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_5DB1C
                move.l  #Map_Tails,mappings(a1)

loc_5DB1C:
                move.b  #5,anim(a1)
                move.b  #$83,$2E(a1)
                bsr.w   sub_5FD88

loc_5DB2C:
                subq.w  #1,$2E(a0)
                bne.s   loc_5DB38
                bset    #1,(_unkFAB8).w

loc_5DB38:
                addq.w  #2,x_pos(a0)
                cmpi.w  #$160,x_pos(a0)
                blo.s   loc_5DB5C
                move.b  #$A,routine(a0)
                tst.b   (_unkFA88).w
                bpl.s   loc_5DB5C
                move.b  #$C,routine(a0)
                move.w  #(5*60)-1,$2E(a0)

loc_5DB5C:
                bra.w   sub_60000
; ---------------------------------------------------------------------------

loc_5DB60:
                tst.w   (_unkFAA4).w
                bne.s   loc_5DB6A
                bra.w   sub_60000
; ---------------------------------------------------------------------------

loc_5DB6A:
                move.b  #$C,routine(a0)
                move.w  #(5*60)-1,$2E(a0)

loc_5DB76:
                subq.w  #1,$2E(a0)
                bpl.s   loc_5DBB2
                move.b  #$E,routine(a0)
                move.w  #-$100,(_unkFAC4).w
                clr.b   (_unkFAB9).w
                move.w  #$BF,$2E(a0)
                st      (Events_fg_5).w
                lea     word_5DBB6(pc),a2
                moveq   #$42,d1
                moveq   #2-1,d2
                bsr.w   Create_Continue_Sprite
                lea     (ArtKosM_IslandLiftGfx).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_IslandLiftGfx),d2
                jsr     (Queue_Kos_Module).l

loc_5DBB2:
                bra.w   sub_60000
; ---------------------------------------------------------------------------
word_5DBB6:
                dc.w    $69C,  $384
                dc.w    $6DC,  $384
; ---------------------------------------------------------------------------

loc_5DBBE:
                addq.w  #2,(_unkEE98).w
                addq.w  #1,(_unkEE9C).w
                subq.w  #1,$2E(a0)
                bpl.s   loc_5DBD8
                move.b  #$10,routine(a0)
                move.w  #(5*60)-1,$2E(a0)

loc_5DBD8:
                bra.w   sub_60000
; ---------------------------------------------------------------------------

loc_5DBDC:
                addq.w  #2,(_unkEE98).w
                subq.w  #1,$2E(a0)
                bpl.s   loc_5DBF2
                move.b  #$12,routine(a0)
                move.w  #$8F,$2E(a0)

loc_5DBF2:
                bra.w   sub_60000
; ---------------------------------------------------------------------------

loc_5DBF6:
                cmpi.w  #$60,x_pos(a0)
                bls.s   loc_5DC02
                subq.w  #2,x_pos(a0)

loc_5DC02:
                addq.w  #2,(_unkEE98).w
                bsr.w   sub_60000
                subq.w  #1,$2E(a0)
                bpl.s   locret_5DC2A
                move.b  #$14,routine(a0)
                bset    #7,status(a0)
                st      (Events_fg_4).w
                move.w  #$8F,$2E(a0)
                clr.b   (Player_1+anim).w

locret_5DC2A:
                rts
; ---------------------------------------------------------------------------

loc_5DC2C:
                addq.w  #2,(_unkEE98).w
                subq.w  #1,$2E(a0)
                bpl.w   locret_5FF1A
                move.b  #$16,routine(a0)
                move.b  #1,mapping_frame(a0)
                move.w  #$40,x_pos(a0)
                move.w  #$110,y_pos(a0)
                move.w  #(2*60)-1,$2E(a0)
                lea     (Player_1).w,a1
                clr.b   mapping_frame(a1)
                move.w  #$100,x_vel(a0)
                bsr.w   sub_6001E
                lea     ChildObjDat_601CA(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     ChildObjDat_601D0(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_601D8(pc),a2
                jsr     (CreateChild1_Normal).l
                tst.b   (_unkFA88).w
                bmi.w   locret_5FF1A
                lea     ChildObjDat_601E0(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_5DC98:
                subq.w  #1,$2E(a0)
                bpl.s   locret_5DCA4
                move.b  #$18,routine(a0)

locret_5DCA4:
                rts
; ---------------------------------------------------------------------------

loc_5DCA6:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                cmpi.w  #$140,x_pos(a0)
                blo.s   loc_5DCC4
                lea     AniRaw_60253(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l

loc_5DCC4:
                cmpi.w  #$220,x_pos(a0)
                bls.w   locret_5FF1A
                move.b  #$1A,routine(a0)
                move.w  #make_art_tile(ArtTile_Ending_PlaneExtra,1,0),art_tile(a0)
                bset    #0,render_flags(a0)
                bclr    #7,art_tile(a0)
                bset    #4,$38(a0)
                subq.w  #8,y_pos(a0)
                move.w  #-$80,x_vel(a0)
                clr.w   y_vel(a0)
                move.b  #5,mapping_frame(a0)
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_5DD0E
                move.b  #6,mapping_frame(a0)

loc_5DD0E:
                lea     Pal_EndingSmallPlane(pc),a1
                jsr     (PalLoad_Line1).l
                lea     ChildObjDat_6022E(pc),a2
                jsr     (CreateChild1_Normal).l
                tst.b   (_unkFA88).w
                bmi.w   locret_5FF1A
                lea     ChildObjDat_6020C(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_5DD34:
                jsr     (MoveSprite2).l
                cmpi.w  #$120,x_pos(a0)
                bhs.s   locret_5DD68
                move.b  #$1C,routine(a0)
                move.w  #60-1,$2E(a0)
                bset    #5,$38(a0)
                tst.b   (_unkFA88).w
                bmi.s   locret_5DD68
                jsr     (AllocateObject).l
                bne.s   locret_5DD68
                move.l  #loc_5FC1E,(a1)

locret_5DD68:
                rts
; ---------------------------------------------------------------------------

loc_5DD6A:
                subq.w  #1,$2E(a0)
                bpl.s   locret_5DDD0
                move.b  #$1E,routine(a0)
                st      (Events_fg_4).w
                cmpi.w  #3,(Player_mode).w
                beq.s   locret_5DDD0
                tst.b   (_unkFA88).w
                bmi.s   locret_5DDD0
                lea     word_5DDD2(pc),a2
                moveq   #$41,d1
                moveq   #6-1,d2
                bsr.w   Create_Continue_Sprite
                lea     word_5DDEA(pc),a2
                moveq   #$43,d1
                moveq   #2-1,d2
                bsr.w   Create_Continue_Sprite
                lea     word_5DDF2(pc),a2
                moveq   #$44,d1
                moveq   #4-1,d2
                bsr.w   Create_Continue_Sprite
                lea     word_5DE02(pc),a2
                moveq   #$45,d1
                moveq   #2-1,d2
                bsr.w   Create_Continue_Sprite
                lea     word_5DE0A(pc),a2
                moveq   #$46,d1
                moveq   #2-1,d2
                bsr.w   Create_Continue_Sprite
                lea     word_5DE12(pc),a2
                moveq   #$47,d1
                moveq   #2-1,d2
                bsr.w   Create_Continue_Sprite

locret_5DDD0:
                rts
; ---------------------------------------------------------------------------
word_5DDD2:
                dc.w    $2B0,   $D4
                dc.w    $2D0,   $D4
                dc.w    $2F0,   $D4
                dc.w    $310,   $D4
                dc.w    $330,   $D4
                dc.w    $350,   $D4
word_5DDEA:
                dc.w    $12C,  $11C
                dc.w    $F4,  $11C
word_5DDF2:
                dc.w    $E8,  $12C
                dc.w    $158,  $12C
                dc.w    $B8,  $12C
                dc.w    $188,  $12C
word_5DE02:
                dc.w    $2FC,   $DC
                dc.w    $32C,   $DC
word_5DE0A:
                dc.w    $2C4,   $D8
                dc.w    $2EC,   $D8
word_5DE12:
                dc.w    $304,   $D0
                dc.w    $344,   $D0
; ---------------------------------------------------------------------------

loc_5DE1A:
                jsr     (MoveSprite2).l
                cmpi.w  #$60,x_pos(a0)
                bhs.s   locret_5DE34
                move.l  #loc_5DE36,(a0)
                bset    #1,$38(a0)

locret_5DE34:
                rts
; ---------------------------------------------------------------------------

loc_5DE36:
                tst.b   (_unkFA88).w
                bmi.s   loc_5DE46
                cmpi.w  #$78,(Camera_Y_pos_copy).w
                blo.w   locret_5FF1A

loc_5DE46:
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                clr.b   (_unkFAC1).w
                clr.b   (_unkFAB8).w
                st      (Events_fg_4).w
                jmp     (Delete_Current_Sprite).l
