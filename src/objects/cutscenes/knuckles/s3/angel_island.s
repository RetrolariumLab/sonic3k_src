; Owner: objects/cutscenes/knuckles/s3
; Responsibility: Knuckles cutscene dispatch and Angel Island act-one and act-two scene programs
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CutsceneKnuckles:
                move.w  a0,(_unkFAA4).w
                moveq   #0,d0
                move.b  subtype(a0),d0
                movea.l CutsceneKnuckles_Index(pc,d0.w),a1
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------
CutsceneKnuckles_Index:
                dc.l    CutsceneKnux_AIZ1
                dc.l    CutsceneKnux_AIZ2
                dc.l    CutsceneKnux_HCZ2
                dc.l    CutsceneKnux_CNZ2A
                dc.l    CutsceneKnux_CNZ2B
                dc.l    CutsceneKnux_LBZ1
                dc.l    CutsceneKnux_LBZ2
; ---------------------------------------------------------------------------

CutsceneKnux_AIZ1:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_AIZ1_Index(pc,d0.w),d1
                jsr     CutsceneKnux_AIZ1_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
CutsceneKnux_AIZ1_Index:
                dc.w    loc_4474C-CutsceneKnux_AIZ1_Index
                dc.w    loc_44782-CutsceneKnux_AIZ1_Index
                dc.w    loc_447B2-CutsceneKnux_AIZ1_Index
                dc.w    loc_447F2-CutsceneKnux_AIZ1_Index
                dc.w    loc_44824-CutsceneKnux_AIZ1_Index
                dc.w    loc_4486E-CutsceneKnux_AIZ1_Index
                dc.w    loc_4489E-CutsceneKnux_AIZ1_Index
; ---------------------------------------------------------------------------

loc_4474C:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                bclr    #7,art_tile(a0)
                move.b  #$13,y_radius(a0)
                move.b  #8,mapping_frame(a0)
                move.w  #$1400,x_pos(a0)
                move.w  #$440,y_pos(a0)
                bsr.w   sub_456C6
                lea     ChildObjDat_45756(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_44782:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_44790
                rts
; ---------------------------------------------------------------------------

loc_44790:
                move.b  #4,routine(a0)
                bset    #7,status(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$80,x_vel(a0)
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_447B2:
                lea     byte_4577B(pc),a1
                jsr     (Animate_RawNoSST).l
                jsr     (MoveSprite).l
                tst.l   d0
                bmi.s   locret_447D0
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_447D2

locret_447D0:
                rts
; ---------------------------------------------------------------------------

loc_447D2:
                move.b  #6,routine(a0)
                add.w   d1,y_pos(a0)
                move.b  #$16,mapping_frame(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_447F8,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_447F2:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_447F8:
                move.b  #8,routine(a0)
                bchg    #0,render_flags(a0)
                move.l  #byte_45775,$30(a0)
                move.w  #-$600,x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$29,$2E(a0)
                move.l  #loc_44836,$34(a0)

loc_44824:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_44836:
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  #$29,$2E(a0)
                move.l  #loc_44850,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_44850:
                move.b  #$A,routine(a0)
                move.b  #$16,mapping_frame(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_4487A,$34(a0)
                bra.w   loc_449E4
; ---------------------------------------------------------------------------

loc_4486E:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_4487A:
                move.b  #$C,routine(a0)
                move.l  #byte_45775,$30(a0)
                move.w  #$600,x_vel(a0)
                jsr     (AllocateObject).l
                bne.s   locret_4489C
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

locret_4489C:
                rts
; ---------------------------------------------------------------------------

loc_4489E:
                tst.b   render_flags(a0)
                bpl.s   loc_448B0
                jsr     (Animate_Raw).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_448B0:
                clr.b   (Palette_cycle_counters+$00).w
                clr.b   (Ctrl_1_locked).w
                jsr     (AfterBoss_Cleanup).l
                jsr     (Remove_From_TrackingSlot).l
                jsr     (AllocateObject).l
                bne.s   loc_448D2
                move.l  #Obj_TitleCard,(a1)

loc_448D2:
                move.b  #$91,(Level_started_flag).w
                move.b  #$80,(Update_HUD_timer).w
                clr.l   (Timer).w
                move.b  #1,(Update_HUD_life_count).w
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_448EE:
                lea     ObjDat3_4571E(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_448FE,(a0)

loc_448FE:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_44910
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_44910:
                lea     (word_29AF0).l,a4
                addq.b  #1,mapping_frame(a0)
                move.l  #loc_29838,(a0)
                jmp     (BreakObjectToPieces).l
; ---------------------------------------------------------------------------

CutsceneKnux_AIZ2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_AIZ2_Index(pc,d0.w),d1
                jsr     CutsceneKnux_AIZ2_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
CutsceneKnux_AIZ2_Index:
                dc.w    loc_44950-CutsceneKnux_AIZ2_Index
                dc.w    loc_449A2-CutsceneKnux_AIZ2_Index
                dc.w    loc_449B0-CutsceneKnux_AIZ2_Index
                dc.w    loc_449FC-CutsceneKnux_AIZ2_Index
                dc.w    loc_44A38-CutsceneKnux_AIZ2_Index
                dc.w    loc_44A72-CutsceneKnux_AIZ2_Index
; ---------------------------------------------------------------------------

loc_44950:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  #$4B8E,x_pos(a0)
                move.w  #$17D,y_pos(a0)
                bset    #0,render_flags(a0)
                bsr.w   sub_456C6
                move.w  #(2*60)-1,$2E(a0)
                move.l  #loc_449A8,$34(a0)
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     ChildObjDat_4572A(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   locret_449A0
                move.w  #$4B08,x_pos(a1)
                move.w  #$178,y_pos(a1)

locret_449A0:
                rts
; ---------------------------------------------------------------------------

loc_449A2:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_449A8:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_449B0:
                move.w  x_pos(a0),d0
                subq.w  #2,d0
                cmpi.w  #$4B3C,d0
                blo.s   loc_449CA
                move.w  d0,x_pos(a0)
                lea     byte_4576B(pc),a1
                jmp     (Animate_RawNoSST).l
; ---------------------------------------------------------------------------

loc_449CA:
                move.b  #6,routine(a0)
                bclr    #0,render_flags(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_44A08,$34(a0)

loc_449E4:
                move.l  #byte_45785,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                move.b  #$1C,mapping_frame(a0)

locret_449FA:
                rts
; ---------------------------------------------------------------------------

loc_449FC:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_44A08:
                move.b  #8,routine(a0)

loc_44A0E:
                move.w  #-$100,x_vel(a0)
                move.w  #-$400,y_vel(a0)

loc_44A1A:
                move.l  #byte_4577B,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                move.b  #8,mapping_frame(a0)
                move.b  #$13,y_radius(a0)
                rts
; ---------------------------------------------------------------------------

loc_44A38:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   locret_44A64
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   locret_44A64
                bset    #2,$38(a0)
                bne.s   loc_44A66
                neg.w   x_vel(a0)
                neg.w   y_vel(a0)

locret_44A64:
                rts
; ---------------------------------------------------------------------------

loc_44A66:
                addq.b  #2,routine(a0)
                add.w   d1,y_pos(a0)
                bra.w   loc_449E4
; ---------------------------------------------------------------------------

loc_44A72:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_44A78:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   CutsceneKnux_Delete
                move.b  #8,width_pixels(a0)
                moveq   #$13,d1
                move.w  #$20,d2
                move.w  #$40,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull2).l
; ---------------------------------------------------------------------------

CutsceneKnux_Delete:
                jmp     (Delete_Current_Sprite).l
; End of function CutsceneKnux_Delete
