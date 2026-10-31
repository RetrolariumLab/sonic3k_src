; Owner: objects/cutscenes/sk
; Responsibility: Angel Island plane opening actor, flight sequence, child construction and private palette resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZPlaneIntro:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZPlaneIntro_Index(pc,d0.w),d1
                jsr     AIZPlaneIntro_Index(pc,d1.w)
                jsr     (Sonic_Load_PLC).l
                bsr.w   sub_67A08
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
AIZPlaneIntro_Index:
                dc.w    loc_674AC-AIZPlaneIntro_Index
                dc.w    loc_67514-AIZPlaneIntro_Index
                dc.w    loc_67536-AIZPlaneIntro_Index
                dc.w    loc_67560-AIZPlaneIntro_Index
                dc.w    loc_67594-AIZPlaneIntro_Index
                dc.w    loc_675C0-AIZPlaneIntro_Index
                dc.w    loc_67614-AIZPlaneIntro_Index
                dc.w    loc_67624-AIZPlaneIntro_Index
                dc.w    loc_6764E-AIZPlaneIntro_Index
                dc.w    loc_67674-AIZPlaneIntro_Index
                dc.w    loc_676AC-AIZPlaneIntro_Index
                dc.w    loc_676C6-AIZPlaneIntro_Index
                dc.w    loc_676E8-AIZPlaneIntro_Index
                dc.w    loc_67704-AIZPlaneIntro_Index
; ---------------------------------------------------------------------------

loc_674AC:
                addq.b  #2,routine(a0)
                move.l  #Map_Sonic,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$BA,mapping_frame(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  #$60,x_pos(a0)
                move.w  #$30,y_pos(a0)
                move.w  #$40,$2E(a0)
                move.l  #loc_6751A,$34(a0)
                move.w  #8,$40(a0)
                move.w  #$E918,(Events_fg_1).w
                move.b  #-1,(Player_prev_frame).w
                lea     (Player_1).w,a1
                move.b  #0,mapping_frame(a1)
                move.b  #$53,object_control(a1)

locret_67512:
                rts
; ---------------------------------------------------------------------------

loc_67514:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6751A:
                move.b  #4,routine(a0)
                move.w  #$300,x_vel(a0)
                move.w  #$600,y_vel(a0)
                lea     ChildObjDat_67A5A(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_67536:
                subi.w  #$18,y_vel(a0)
                beq.s   loc_67544
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_67544:
                move.b  #6,routine(a0)
                clr.w   x_vel(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_67572,$34(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

loc_67560:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_67572:
                move.b  #8,routine(a0)
                move.w  #$400,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                move.l  #byte_67A84,$30(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_67594:
                subi.w  #$40,x_vel(a0)
                jsr     (MoveSprite).l
                cmpi.w  #$130,y_pos(a0)
                bhs.s   loc_675AE
                jmp     (loc_67A20).l
; ---------------------------------------------------------------------------

loc_675AE:
                move.b  #$A,routine(a0)
                move.w  #$130,y_pos(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_675C0:
                subi.w  #$40,x_vel(a0)
                jsr     (MoveSprite2).l
                cmpi.w  #$40,x_pos(a0)
                blo.s   loc_675D6
                rts
; ---------------------------------------------------------------------------

loc_675D6:
                move.b  #$C,routine(a0)
                move.w  #$40,x_pos(a0)
                move.w  #5,$2E(a0)
                move.l  #loc_675FA,$34(a0)
                move.w  #$3F,$3A(a0)
                bra.w   loc_67996
; ---------------------------------------------------------------------------

loc_675FA:
                move.w  #5,$2E(a0)
                cmpi.w  #$80,x_pos(a0)
                blo.w   locret_67512
                lea     ChildObjDat_67A70(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_67614:
                subq.w  #1,$3A(a0)
                bpl.w   locret_67512
                move.b  #$E,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_67624:
                bsr.w   sub_679B8
                jsr     (Obj_Wait).l
                move.w  x_pos(a0),d0
                addq.w  #4,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$200,d0
                bhs.s   loc_67640
                rts
; ---------------------------------------------------------------------------

loc_67640:
                move.b  #$10,routine(a0)
                move.w  #$1F,$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_6764E:
                bsr.w   sub_679B8
                jsr     (Obj_Wait).l
                subq.w  #1,$3A(a0)
                bpl.w   locret_67512
                move.b  #$12,routine(a0)
                bset    #2,$38(a0)
                move.w  #$C,$40(a0)
                rts
; ---------------------------------------------------------------------------

loc_67674:
                bsr.w   sub_679B8
                jsr     (Obj_Wait).l
                move.w  x_pos(a0),d0
                subi.w  #4,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$120,d0
                bls.s   loc_67692
                rts
; ---------------------------------------------------------------------------

loc_67692:
                move.b  #$14,routine(a0)
                bset    #2,$38(a0)
                move.w  #$1F,$3A(a0)
                move.w  #$10,$40(a0)
                rts
; ---------------------------------------------------------------------------

loc_676AC:
                bsr.w   sub_679B8
                jsr     (Obj_Wait).l
                subq.w  #1,$3A(a0)
                bpl.w   locret_67512
                move.b  #$16,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_676C6:
                bsr.w   sub_679B8
                cmpi.w  #$918,(Player_1+x_pos).w
                bhs.s   loc_676D8
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_676D8:
                move.b  #$18,routine(a0)
                lea     ChildObjDat_67A78(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_676E8:
                bsr.w   sub_679B8
                cmpi.w  #$1240,(Player_1+x_pos).w
                bhs.s   loc_676F6
                rts
; ---------------------------------------------------------------------------

loc_676F6:
                move.b  #$1A,routine(a0)
                subi.w  #$20,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_67704:
                bsr.w   sub_679B8
                cmpi.w  #$13D0,(Player_1+x_pos).w
                bhs.s   loc_67712
                rts
; ---------------------------------------------------------------------------

loc_67712:
                st      (Palette_cycle_counters+$00).w
                lea     (Player_1).w,a1
                move.b  #4,routine(a1)
                bset    #Status_InAir,status(a1)
                move.w  #-$400,y_vel(a1)
                move.w  #-$200,x_vel(a1)
                move.w  #0,ground_vel(a1)
                move.b  #$1A,anim(a1)
                clr.b   object_control(a1)
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                clr.b   (Super_Sonic_Knux_flag).w
                move.b  #2,(Super_palette_status).w
                move.w  #$1E,(Palette_frame).w
                lea     Pal_AIZIntroEmeralds(pc),a1
                lea     (Normal_palette_line_4).w,a2
                moveq   #bytesToLcnt($20),d0

loc_67764:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_67764
                lea     ChildObjDat_67A7E(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_6777A:
                move.l  #loc_677CE,(a0)
                move.l  #Map_AIZIntroPlane,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZIntroPlane,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$40,width_pixels(a0)
; Bug: This is missing the height, and it overwrites what the previous line did
                move.b  #$20,width_pixels(a0)
                jsr     Swing_Setup1(pc)
                lea     (ArtKosM_AIZIntroPlane).l,a1
                move.w  #tiles_to_bytes(ArtTile_AIZIntroPlane),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_AIZIntroEmeralds).l,a1
                move.w  #tiles_to_bytes(ArtTile_AIZIntroEmeralds),d2
                jsr     (Queue_Kos_Module).l
                lea     ChildObjDat_67A62(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_677CE:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   loc_677EC
                move.l  #loc_67800,(a0)

loc_677EC:
                btst    #3,$38(a1)
                bne.s   loc_677FA
                jsr     (Refresh_ChildPosition).l

loc_677FA:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_67800:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #4,x_pos(a0)
                cmpi.w  #$20,x_pos(a0)
                blo.s   loc_6781E
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6781E:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_67824:
                move.l  #Map_AIZIntroPlane,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZIntroPlane,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #4,width_pixels(a0)
; Bug: This is missing the height, and it overwrites what the previous line did
                move.b  #$C,width_pixels(a0)
                move.l  #loc_6784A,(a0)

loc_6784A:
                lea     (byte_67A8F).l,a1
                jsr     (Animate_RawNoSST).l
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_67862:
                move.l  #Map_AIZIntroPlane,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZIntroPlane,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #4,width_pixels(a0)
; Bug: This is missing the height, and it overwrites what the previous line did
                move.b  #$C,width_pixels(a0)
                move.l  #loc_67888,(a0)

loc_67888:
                lea     (byte_67A97).l,a1
                jsr     (Animate_RawNoSST).l
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_678A0:
                move.l  #loc_678DA,(a0)
                move.l  #Map_AIZIntroWaves,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZIntroSprites,0,0),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$10,width_pixels(a0)
                bset    #0,render_flags(a0)
                movea.w parent3(a0),a1
                move.l  #byte_67A9B,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

loc_678DA:
                cmpi.w  #$60,x_pos(a0)
                blo.s   loc_678FA
                movea.w parent3(a0),a1
                move.w  $40(a1),d0
                sub.w   d0,x_pos(a0)
                jsr     (Animate_RawMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_678FA:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_67900:
                lea     ObjDat3_67A4E(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  d0,mapping_frame(a0)
                move.l  #loc_67938,(a0)
                move.b  #4,y_radius(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                moveq   #$40,d0
                jsr     (Set_IndexedVelocity).l

loc_67938:
                jsr     (MoveSprite).l
                tst.l   d0
                bmi.s   loc_67956
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_67956
                add.w   d1,y_pos(a0)
                move.l  #loc_6795C,(a0)

loc_67956:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6795C:
                movea.w (_unkFAA4).w,a1
                move.w  x_pos(a0),d0
                move.w  x_pos(a1),d1
                subq.w  #8,d0
                cmp.w   d0,d1
                blo.s   loc_67976
                addi.w  #2*8,d0
                cmp.w   d0,d1
                blo.s   loc_6797C

loc_67976:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6797C:
                move.w  x_vel(a1),d0
                btst    #1,subtype(a0)
                beq.s   loc_6798A
                neg.w   d0

loc_6798A:
                tst.w   d0
                bmi.w   locret_67512
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_67996:
                move.l  #Map_SuperSonic,mappings(a0)
                move.b  #$21,mapping_frame(a0)
                move.b  #0,(Palette_timer).w
                move.w  #$24,(Palette_frame).w
                move.w  #$7FFF,(Super_frame_count).w
                rts

; =============== S U B R O U T I N E =======================================

sub_679B8:
                move.b  #1,(Super_Sonic_Knux_flag).w
                move.b  #$21,mapping_frame(a0)
                btst    #1,(V_int_run_count+3).w
                beq.s   loc_679D2
                move.b  #$22,mapping_frame(a0)

loc_679D2:
                subq.b  #1,(Palette_timer).w
                bpl.s   locret_67A06
                move.b  #6,(Palette_timer).w
                lea     (PalCycle_SuperSonic).l,a1
                move.w  (Palette_frame).w,d0
                addq.w  #6,(Palette_frame).w
                cmpi.w  #$36,(Palette_frame).w
; This condition causes the last frame to be skipped
                blo.s   loc_679FA
                move.w  #$24,(Palette_frame).w

loc_679FA:
                lea     (Normal_palette+$4).w,a2
                move.l  (a1,d0.w),(a2)+
                move.w  4(a1,d0.w),(a2)

locret_67A06:
                rts
; End of function sub_679B8

; =============== S U B R O U T I N E =======================================

sub_67A08:
                move.w  $40(a0),d1
                move.w  (Events_fg_1).w,d0
                bpl.s   loc_67A1A
                add.w   d1,d0
                move.w  d0,(Events_fg_1).w
                rts
; ---------------------------------------------------------------------------

loc_67A1A:
                add.w   d1,(Player_1+x_pos).w
                rts
; End of function sub_67A08

; ---------------------------------------------------------------------------

loc_67A20:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_67A4C
                move.b  (a1),anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                cmp.b   1(a1),d0
                blo.s   loc_67A3E
                moveq   #0,d0

loc_67A3E:
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  2(a1,d0.w),d1
                move.b  d1,mapping_frame(a0)

locret_67A4C:
                rts
; ---------------------------------------------------------------------------
ObjDat3_67A4E:
                dc.l    Map_AIZIntroEmeralds
                dc.w    make_art_tile(ArtTile_AIZIntroEmeralds,3,0)
                dc.w    $280
                dc.b    4,   4,   1,   0
ChildObjDat_67A5A:
                dc.w    1-1
                dc.l    loc_6777A
                dc.b    -$22, $2C
ChildObjDat_67A62:
                dc.w    2-1
                dc.l    loc_67824
                dc.b    $38,   4
                dc.l    loc_67862
                dc.b    $18, $18
ChildObjDat_67A70:
                dc.w    1-1
                dc.l    loc_678A0
                dc.b    0, $18
ChildObjDat_67A78:
                dc.w    1-1
                dc.l    Obj_CutsceneKnuckles
ChildObjDat_67A7E:
                dc.w    7-1
                dc.l    loc_67900
byte_67A84:
                dc.b    3,   8
                dc.b    $97, $96
                dc.b    $98, $96
                dc.b    $99, $96
                dc.b    $9A, $96
                dc.b    $FC
byte_67A8F:
                dc.b    0,   1,   2,   3,   4,   3,   2, $FC
byte_67A97:
                dc.b    0,   5,   6, $FC
byte_67A9B:
                dc.b    0,   1
                dc.b    0,   0
                dc.b    1,   1
                dc.b    2,   2
                dc.b    3,   2
                dc.b    4,   1
                dc.b    5,   1
                dc.b    $F4
                even
Pal_AIZIntroEmeralds:
                binclude "data/Levels/AIZ/Palettes/Intro Emeralds.bin"
                even
