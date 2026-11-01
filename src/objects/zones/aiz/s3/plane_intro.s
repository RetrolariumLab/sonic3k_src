; Owner: objects/zones/aiz/s3
; Responsibility: Angel Island opening plane scene, coordinated character motion and transition control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZPlaneIntro:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AIZPlaneIntro_Index(pc,d0.w),d1
                jsr     AIZPlaneIntro_Index(pc,d1.w)
                jsr     (Sonic_Load_PLC).l
                bsr.w   AdvanceAizPlaneIntroScrollOrPlayer
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
AIZPlaneIntro_Index:
                dc.w    loc_45888-AIZPlaneIntro_Index
                dc.w    loc_458F0-AIZPlaneIntro_Index
                dc.w    loc_45912-AIZPlaneIntro_Index
                dc.w    loc_4593C-AIZPlaneIntro_Index
                dc.w    loc_45970-AIZPlaneIntro_Index
                dc.w    loc_4599C-AIZPlaneIntro_Index
                dc.w    loc_459F0-AIZPlaneIntro_Index
                dc.w    loc_45A00-AIZPlaneIntro_Index
                dc.w    loc_45A2A-AIZPlaneIntro_Index
                dc.w    loc_45A50-AIZPlaneIntro_Index
                dc.w    loc_45A88-AIZPlaneIntro_Index
                dc.w    loc_45AA2-AIZPlaneIntro_Index
                dc.w    loc_45AC4-AIZPlaneIntro_Index
                dc.w    loc_45AE0-AIZPlaneIntro_Index
; ---------------------------------------------------------------------------

loc_45888:
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
                move.l  #loc_458F6,$34(a0)
                move.w  #8,$40(a0)
                move.w  #$E918,(Events_fg_1).w
                move.b  #-1,(Player_prev_frame).w
                lea     (Player_1).w,a1
                move.b  #0,mapping_frame(a1)
                move.b  #$53,object_control(a1)

locret_458EE:
                rts
; ---------------------------------------------------------------------------

loc_458F0:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_458F6:
                move.b  #4,routine(a0)
                move.w  #$300,x_vel(a0)
                move.w  #$600,y_vel(a0)
                lea     ChildObjDat_45E36(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_45912:
                subi.w  #$18,y_vel(a0)
                beq.s   loc_45920
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_45920:
                move.b  #6,routine(a0)
                clr.w   x_vel(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_4594E,$34(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

loc_4593C:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_4594E:
                move.b  #8,routine(a0)
                move.w  #$400,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                move.l  #byte_45E60,$30(a0)
                bset    #3,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_45970:
                subi.w  #$40,x_vel(a0)
                jsr     (MoveSprite).l
                cmpi.w  #$130,y_pos(a0)
                bhs.s   loc_4598A
                jmp     (loc_45DFC).l
; ---------------------------------------------------------------------------

loc_4598A:
                move.b  #$A,routine(a0)
                move.w  #$130,y_pos(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_4599C:
                subi.w  #$40,x_vel(a0)
                jsr     (MoveSprite2).l
                cmpi.w  #$40,x_pos(a0)
                blo.s   loc_459B2
                rts
; ---------------------------------------------------------------------------

loc_459B2:
                move.b  #$C,routine(a0)
                move.w  #$40,x_pos(a0)
                move.w  #5,$2E(a0)
                move.l  #loc_459D6,$34(a0)
                move.w  #$3F,$3A(a0)
                bra.w   loc_45D72
; ---------------------------------------------------------------------------

loc_459D6:
                move.w  #5,$2E(a0)
                cmpi.w  #$80,x_pos(a0)
                blo.w   locret_458EE
                lea     ChildObjDat_45E4C(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_459F0:
                subq.w  #1,$3A(a0)
                bpl.w   locret_458EE
                move.b  #$E,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_45A00:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                jsr     (Obj_Wait).l
                move.w  x_pos(a0),d0
                addq.w  #4,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$200,d0
                bhs.s   loc_45A1C
                rts
; ---------------------------------------------------------------------------

loc_45A1C:
                move.b  #$10,routine(a0)
                move.w  #$1F,$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_45A2A:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                jsr     (Obj_Wait).l
                subq.w  #1,$3A(a0)
                bpl.w   locret_458EE
                move.b  #$12,routine(a0)
                bset    #2,$38(a0)
                move.w  #$C,$40(a0)
                rts
; ---------------------------------------------------------------------------

loc_45A50:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                jsr     (Obj_Wait).l
                move.w  x_pos(a0),d0
                subi.w  #4,d0
                move.w  d0,x_pos(a0)
                cmpi.w  #$120,d0
                bls.s   loc_45A6E
                rts
; ---------------------------------------------------------------------------

loc_45A6E:
                move.b  #$14,routine(a0)
                bset    #2,$38(a0)
                move.w  #$1F,$3A(a0)
                move.w  #$10,$40(a0)
                rts
; ---------------------------------------------------------------------------

loc_45A88:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                jsr     (Obj_Wait).l
                subq.w  #1,$3A(a0)
                bpl.w   locret_458EE
                move.b  #$16,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_45AA2:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                cmpi.w  #$918,(Player_1+x_pos).w
                bhs.s   loc_45AB4
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_45AB4:
                move.b  #$18,routine(a0)
                lea     ChildObjDat_45E54(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_45AC4:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                cmpi.w  #$1240,(Player_1+x_pos).w
                bhs.s   loc_45AD2
                rts
; ---------------------------------------------------------------------------

loc_45AD2:
                move.b  #$1A,routine(a0)
                subi.w  #$20,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_45AE0:
                bsr.w   AnimateAizPlaneIntroSuperAppearance
                cmpi.w  #$13D0,(Player_1+x_pos).w
                bhs.s   loc_45AEE
                rts
; ---------------------------------------------------------------------------

loc_45AEE:
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

loc_45B40:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_45B40
                lea     ChildObjDat_45E5A(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_45B56:
                move.l  #loc_45BAA,(a0)
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
                lea     ChildObjDat_45E3E(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_45BAA:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                beq.s   loc_45BC8
                move.l  #loc_45BDC,(a0)

loc_45BC8:
                btst    #3,$38(a1)
                bne.s   loc_45BD6
                jsr     (Refresh_ChildPosition).l

loc_45BD6:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_45BDC:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #4,x_pos(a0)
                cmpi.w  #$20,x_pos(a0)
                blo.s   loc_45BFA
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_45BFA:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_45C00:
                move.l  #Map_AIZIntroPlane,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZIntroPlane,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #4,width_pixels(a0)
; Bug: This is missing the height, and it overwrites what the previous line did
                move.b  #$C,width_pixels(a0)
                move.l  #loc_45C26,(a0)

loc_45C26:
                lea     (byte_45E6B).l,a1
                jsr     (Animate_RawNoSST).l
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_45C3E:
                move.l  #Map_AIZIntroPlane,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZIntroPlane,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #4,width_pixels(a0)
; Bug: This is missing the height, and it overwrites what the previous line did
                move.b  #$C,width_pixels(a0)
                move.l  #loc_45C64,(a0)

loc_45C64:
                lea     (byte_45E73).l,a1
                jsr     (Animate_RawNoSST).l
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_45C7C:
                move.l  #loc_45CB6,(a0)
                move.l  #Map_AIZIntroWaves,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZIntroSprites,0,0),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$10,width_pixels(a0)
                bset    #0,render_flags(a0)
                movea.w parent3(a0),a1
                move.l  #byte_45E77,$30(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

loc_45CB6:
                cmpi.w  #$60,x_pos(a0)
                blo.s   loc_45CD6
                movea.w parent3(a0),a1
                move.w  $40(a1),d0
                sub.w   d0,x_pos(a0)
                jsr     (Animate_RawMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_45CD6:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_45CDC:
                lea     ObjDat3_45E2A(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  d0,mapping_frame(a0)
                move.l  #loc_45D14,(a0)
                move.b  #4,y_radius(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                moveq   #$40,d0
                jsr     (Set_IndexedVelocity).l

loc_45D14:
                jsr     (MoveSprite).l
                tst.l   d0
                bmi.s   loc_45D32
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_45D32
                add.w   d1,y_pos(a0)
                move.l  #loc_45D38,(a0)

loc_45D32:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_45D38:
                movea.w (_unkFAA4).w,a1
                move.w  x_pos(a0),d0
                move.w  x_pos(a1),d1
                subq.w  #8,d0
                cmp.w   d0,d1
                blo.s   loc_45D52
                addi.w  #2*8,d0
                cmp.w   d0,d1
                blo.s   loc_45D58

loc_45D52:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_45D58:
                move.w  x_vel(a1),d0
                btst    #1,subtype(a0)
                beq.s   loc_45D66
                neg.w   d0

loc_45D66:
                tst.w   d0
                bmi.w   locret_458EE
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_45D72:
                move.l  #Map_SuperSonic,mappings(a0)
                move.b  #$21,mapping_frame(a0)
                move.b  #0,(Palette_timer).w
                move.w  #$24,(Palette_frame).w
                move.w  #$7FFF,(Super_frame_count).w
                rts

; =============== S U B R O U T I N E =======================================

AnimateAizPlaneIntroSuperAppearance:
                move.b  #1,(Super_Sonic_Knux_flag).w
                move.b  #$21,mapping_frame(a0)
                btst    #1,(V_int_run_count+3).w
                beq.s   loc_45DAE
                move.b  #$22,mapping_frame(a0)

loc_45DAE:
                subq.b  #1,(Palette_timer).w
                bpl.s   locret_45DE2
                move.b  #6,(Palette_timer).w
                lea     (PalCycle_SuperSonic).l,a1
                move.w  (Palette_frame).w,d0
                addq.w  #6,(Palette_frame).w
                cmpi.w  #$36,(Palette_frame).w
; This condition causes the last frame to be skipped
                blo.s   loc_45DD6
                move.w  #$24,(Palette_frame).w

loc_45DD6:
                lea     (Normal_palette+$4).w,a2
                move.l  (a1,d0.w),(a2)+
                move.w  4(a1,d0.w),(a2)

locret_45DE2:
                rts
; End of function AnimateAizPlaneIntroSuperAppearance

; =============== S U B R O U T I N E =======================================

AdvanceAizPlaneIntroScrollOrPlayer:
                move.w  $40(a0),d1
                move.w  (Events_fg_1).w,d0
                bpl.s   loc_45DF6
                add.w   d1,d0
                move.w  d0,(Events_fg_1).w
                rts
; ---------------------------------------------------------------------------

loc_45DF6:
                add.w   d1,(Player_1+x_pos).w
                rts
; End of function AdvanceAizPlaneIntroScrollOrPlayer

; ---------------------------------------------------------------------------

loc_45DFC:
                movea.l $30(a0),a1
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_45E28
                move.b  (a1),anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #1,d0
                cmp.b   1(a1),d0
                blo.s   loc_45E1A
                moveq   #0,d0

loc_45E1A:
                move.b  d0,anim_frame(a0)
                moveq   #0,d1
                move.b  2(a1,d0.w),d1
                move.b  d1,mapping_frame(a0)

locret_45E28:
                rts
; ---------------------------------------------------------------------------
ObjDat3_45E2A:
                dc.l    Map_AIZIntroEmeralds
                dc.w    make_art_tile(ArtTile_AIZIntroEmeralds,3,0)
                dc.w    $280
                dc.b    4,   4,   1,   0
ChildObjDat_45E36:
                dc.w    1-1
                dc.l    loc_45B56
                dc.b    -$22, $2C
ChildObjDat_45E3E:
                dc.w    2-1
                dc.l    loc_45C00
                dc.b    $38,   4
                dc.l    loc_45C3E
                dc.b    $18, $18
ChildObjDat_45E4C:
                dc.w    1-1
                dc.l    loc_45C7C
                dc.b    0, $18
ChildObjDat_45E54:
                dc.w    1-1
                dc.l    Obj_CutsceneKnuckles
ChildObjDat_45E5A:
                dc.w    7-1
                dc.l    loc_45CDC
byte_45E60:
                dc.b    3,   8
                dc.b    $97, $96
                dc.b    $98, $96
                dc.b    $99, $96
                dc.b    $9A, $96
                dc.b    $FC
byte_45E6B:
                dc.b    0,   1,   2,   3,   4,   3,   2, $FC
byte_45E73:
                dc.b    0,   5,   6, $FC
byte_45E77:
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
