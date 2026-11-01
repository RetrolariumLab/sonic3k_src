; Owner: objects/cutscenes/sk
; Responsibility: Knuckles cutscene dispatch and Angel Island act-one and act-two encounters
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
                dc.l    CutsceneKnux_MHZ1
                dc.l    CutsceneKnux_MHZ2
                dc.l    CutsceneKnux_LRZ2
                dc.l    CutsceneKnux_HPZ
                dc.l    CutsceneKnux_SSZ
                dc.l    CutsceneKnux_SKIntro
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
                dc.w    loc_61DBE-CutsceneKnux_AIZ1_Index
                dc.w    loc_61DF4-CutsceneKnux_AIZ1_Index
                dc.w    loc_61E24-CutsceneKnux_AIZ1_Index
                dc.w    loc_61E64-CutsceneKnux_AIZ1_Index
                dc.w    loc_61E96-CutsceneKnux_AIZ1_Index
                dc.w    loc_61EE0-CutsceneKnux_AIZ1_Index
                dc.w    loc_61F10-CutsceneKnux_AIZ1_Index
; ---------------------------------------------------------------------------

loc_61DBE:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                bclr    #7,art_tile(a0)
                move.b  #$13,y_radius(a0)
                move.b  #8,mapping_frame(a0)
                move.w  #$1400,x_pos(a0)
                move.w  #$440,y_pos(a0)
                bsr.w   CutsceneSpawnKnucklesMusicFadeTransition
                lea     ChildObjDat_6659A(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_61DF4:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_61E02
                rts
; ---------------------------------------------------------------------------

loc_61E02:
                move.b  #4,routine(a0)
                bset    #7,status(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$80,x_vel(a0)
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_61E24:
                lea     byte_666AF(pc),a1
                jsr     (Animate_RawNoSST).l
                jsr     (MoveSprite).l
                tst.l   d0
                bmi.s   locret_61E42
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_61E44

locret_61E42:
                rts
; ---------------------------------------------------------------------------

loc_61E44:
                move.b  #6,routine(a0)
                add.w   d1,y_pos(a0)
                move.b  #$16,mapping_frame(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_61E6A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_61E64:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_61E6A:
                move.b  #8,routine(a0)
                bchg    #0,render_flags(a0)
                move.l  #byte_666A9,$30(a0)
                move.w  #-$600,x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #$29,$2E(a0)
                move.l  #loc_61EA8,$34(a0)

loc_61E96:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_61EA8:
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                move.w  #$29,$2E(a0)
                move.l  #loc_61EC2,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_61EC2:
                move.b  #$A,routine(a0)
                move.b  #$16,mapping_frame(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_61EEC,$34(a0)
                bra.w   loc_62056
; ---------------------------------------------------------------------------

loc_61EE0:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_61EEC:
                move.b  #$C,routine(a0)
                move.l  #byte_666A9,$30(a0)
                move.w  #$600,x_vel(a0)
                jsr     (AllocateObject).l
                bne.s   locret_61F0E
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

locret_61F0E:
                rts
; ---------------------------------------------------------------------------

loc_61F10:
                tst.b   render_flags(a0)
                bpl.s   loc_61F22
                jsr     (Animate_Raw).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_61F22:
                clr.b   (Palette_cycle_counters+$00).w
                clr.b   (Ctrl_1_locked).w
                jsr     (AfterBoss_Cleanup).l
                jsr     (Remove_From_TrackingSlot).l
                jsr     (AllocateObject).l
                bne.s   loc_61F44
                move.l  #Obj_TitleCard,(a1)

loc_61F44:
                move.b  #$91,(Level_started_flag).w
                move.b  #$80,(Update_HUD_timer).w
                clr.l   (Timer).w
                move.b  #1,(Update_HUD_life_count).w
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_61F60:
                lea     ObjDat3_66432(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_61F70,(a0)

loc_61F70:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_61F82
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_61F82:
                lea     (word_2A8B0).l,a4
                addq.b  #1,mapping_frame(a0)
                move.l  #loc_2A5F8,(a0)
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
                dc.w    loc_61FC2-CutsceneKnux_AIZ2_Index
                dc.w    loc_62014-CutsceneKnux_AIZ2_Index
                dc.w    loc_62022-CutsceneKnux_AIZ2_Index
                dc.w    loc_6206E-CutsceneKnux_AIZ2_Index
                dc.w    loc_620AA-CutsceneKnux_AIZ2_Index
                dc.w    loc_620E4-CutsceneKnux_AIZ2_Index
; ---------------------------------------------------------------------------

loc_61FC2:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  #$4B8E,x_pos(a0)
                move.w  #$17D,y_pos(a0)
                bset    #0,render_flags(a0)
                bsr.w   CutsceneSpawnKnucklesMusicFadeTransition
                move.w  #(2*60)-1,$2E(a0)
                move.l  #loc_6201A,$34(a0)
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     ChildObjDat_6655A(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   locret_62012
                move.w  #$4B08,x_pos(a1)
                move.w  #$178,y_pos(a1)

locret_62012:
                rts
; ---------------------------------------------------------------------------

loc_62014:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6201A:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_62022:
                move.w  x_pos(a0),d0
                subq.w  #2,d0
                cmpi.w  #$4B3C,d0
                blo.s   loc_6203C
                move.w  d0,x_pos(a0)
                lea     byte_6669F(pc),a1
                jmp     (Animate_RawNoSST).l
; ---------------------------------------------------------------------------

loc_6203C:
                move.b  #6,routine(a0)
                bclr    #0,render_flags(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_6207A,$34(a0)

loc_62056:
                move.l  #byte_666B9,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                move.b  #$1C,mapping_frame(a0)

locret_6206C:
                rts
; ---------------------------------------------------------------------------

loc_6206E:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6207A:
                move.b  #8,routine(a0)

loc_62080:
                move.w  #-$100,x_vel(a0)
                move.w  #-$400,y_vel(a0)

loc_6208C:
                move.l  #byte_666AF,$30(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                move.b  #8,mapping_frame(a0)
                move.b  #$13,y_radius(a0)
                rts
; ---------------------------------------------------------------------------

loc_620AA:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   locret_620D6
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   locret_620D6
                bset    #2,$38(a0)
                bne.s   loc_620D8
                neg.w   x_vel(a0)
                neg.w   y_vel(a0)

locret_620D6:
                rts
; ---------------------------------------------------------------------------

loc_620D8:
                addq.b  #2,routine(a0)
                add.w   d1,y_pos(a0)
                bra.w   loc_62056
; ---------------------------------------------------------------------------

loc_620E4:
                jmp     (Animate_Raw).l
; ---------------------------------------------------------------------------

loc_620EA:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   CutsceneKnux_Delete
                move.b  #8,width_pixels(a0)
                moveq   #$13,d1
                move.w  #$20,d2
                move.w  #$40,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull2).l
; End of function loc_620AA
