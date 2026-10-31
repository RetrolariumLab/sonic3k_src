; Owner: objects/cutscenes/sk
; Responsibility: Sky Sanctuary Knuckles encounter, tired actor and scene button program
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_SSZ:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_SSZ_Index(pc,d0.w),d1
                jsr     CutsceneKnux_SSZ_Index(pc,d1.w)
                btst    #6,$38(a0)
                bne.s   loc_65702
                move.l  #Map_Knuckles,mappings(a0)
                bsr.w   Knuckles_Load_PLC_661E0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_65702:
                move.l  #Map_SSZKnucklesTired,mappings(a0)
                lea     DPLCPtr_SSZKnucklesTired(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
CutsceneKnux_SSZ_Index:
                dc.w    loc_65730-CutsceneKnux_SSZ_Index
                dc.w    loc_6575E-CutsceneKnux_SSZ_Index
                dc.w    loc_65794-CutsceneKnux_SSZ_Index
                dc.w    loc_657CE-CutsceneKnux_SSZ_Index
                dc.w    loc_657FE-CutsceneKnux_SSZ_Index
                dc.w    loc_65826-CutsceneKnux_SSZ_Index
                dc.w    loc_6584C-CutsceneKnux_SSZ_Index
                dc.w    loc_65876-CutsceneKnux_SSZ_Index
                dc.w    loc_658BA-CutsceneKnux_SSZ_Index
                dc.w    loc_658F2-CutsceneKnux_SSZ_Index
                dc.w    loc_6594A-CutsceneKnux_SSZ_Index
; ---------------------------------------------------------------------------

loc_65730:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                clr.b   (_unkFAB8).w
                move.w  #$80,priority(a0)
                lea     (Normal_palette_line_2).w,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_6574E:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_6574E
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_6575E:
                lea     byte_667C1(pc),a1
                jsr     (Animate_RawNoSSTCheckResult).l
                btst    #0,(_unkFAB8).w
                beq.w   locret_6206C
                move.b  #4,routine(a0)
                move.b  #$56,mapping_frame(a0)
                move.b  #$33,y_radius(a0)
                lea     (ArtKosM_SSZDeathEggSmall).l,a1
                move.w  #tiles_to_bytes(ArtTile_SSZDeathEggSmall),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_65794:
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.w   locret_6206C
                add.w   d1,y_pos(a0)
                move.b  #6,routine(a0)
                move.w  #5,$2E(a0)
                jsr     (AllocateObject).l
                bne.s   loc_657C4
                move.l  #loc_66072,(a1)

loc_657C4:
                lea     ChildObjDat_665F6(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_657CE:
                moveq   #signextendB(sfx_DeathEggRiseQuiet),d0
                jsr     (Play_SFX_Continuous).l
                subq.w  #1,$2E(a0)
                bpl.w   locret_6206C
                move.b  #8,routine(a0)
                bset    #0,render_flags(a0)
                bset    #6,$38(a0)
                clr.b   mapping_frame(a0)
                lea     byte_66719(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_657FE:
                moveq   #signextendB(sfx_DeathEggRiseQuiet),d0
                jsr     (Play_SFX_Continuous).l
                btst    #1,(_unkFAB8).w
                bne.s   loc_65814
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_65814:
                move.b  #$A,routine(a0)
                clr.b   mapping_frame(a0)
                move.w  #5,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_65826:
                subq.w  #1,$2E(a0)
                bpl.s   locret_6584A
                move.b  #$C,routine(a0)
                bclr    #0,render_flags(a0)
                bclr    #6,$38(a0)
                move.b  #$56,mapping_frame(a0)
                move.w  #5,$2E(a0)

locret_6584A:
                rts
; ---------------------------------------------------------------------------

loc_6584C:
                subq.w  #1,$2E(a0)
                bpl.w   locret_6206C
                move.b  #$E,routine(a0)
                move.b  #$13,y_radius(a0)
                move.w  #$200,x_vel(a0)
                move.w  #-$300,y_vel(a0)
                lea     byte_667C1(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_65876:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   locret_6206C
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.w   locret_6206C
                add.w   d1,y_pos(a0)
                move.b  #$10,routine(a0)
                move.w  #$300,x_vel(a0)
                clr.w   y_vel(a0)
                bclr    #0,render_flags(a0)
                lea     byte_66824(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_658BA:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite2).l
                cmpi.w  #$2A8,x_pos(a0)
                blo.w   locret_6206C
                move.b  #$12,routine(a0)
                move.b  #$1B,y_radius(a0)
                move.w  #$480,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                lea     byte_667C1(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_658F2:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   locret_6206C
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.w   locret_6206C
                add.w   d1,y_pos(a0)
                move.b  #$14,routine(a0)
                move.w  #$200,priority(a0)
                bclr    #0,render_flags(a0)
                bset    #6,$38(a0)
                move.b  #1,mapping_frame(a0)
                st      (Events_bg+$08).w
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l
                lea     byte_6671F(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_6594A:
                bsr.w   sub_65FDE
                jsr     (Animate_RawMultiDelay).l
                move.w  (Camera_X_pos).w,d0
                subi.w  #$80,d0
                cmp.w   x_pos(a0),d0
                bgt.s   loc_65976
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                cmpi.w  #$200,d0
                bls.w   locret_6206C

loc_65976:
                move.b  #1,(Last_star_post_hit).w
                move.w  #$140,(Saved_X_pos).w
                move.w  #$C6C,(Saved_Y_pos).w
                jsr     (Save_Level_Data).l
                lea     (Target_palette_line_2).w,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_65998:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_65998
                lea     (PLC_Monitors).l,a1
                jsr     (Load_PLC_Raw).l
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

Obj_SSZCutsceneButton:
                lea     ObjDat_SSZCutsceneButton(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_659C6,(a0)

loc_659C6:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_659CC:
                lea     ObjDat3_664AA(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_65A30,(a0)
                move.w  #$200,x_pos(a0)
                move.w  #$C68,d0
                move.w  d0,y_pos(a0)
                move.w  d0,y_vel(a0)
                move.w  #-$40,$40(a0)
                move.w  #$100,$2E(a0)
                move.l  (V_int_run_count).w,(RNG_seed).w
                lea     ChildObjDat_665C4(pc),a2
                jsr     (CreateChild1_Normal).l
                lea     (Normal_palette_line_4).w,a1
                lea     (Target_palette_line_4).w,a2
                moveq   #bytesToLcnt($20),d6

loc_65A14:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_65A14
                lea     Pal_KnuxSSZEnd(pc),a1
                lea     (Normal_palette_line_4).w,a2
                moveq   #bytesToWcnt($20),d0

loc_65A24:
                move.w  (a1)+,d1
                beq.s   loc_65A2A
                move.w  d1,(a2)

loc_65A2A:
                addq.w  #2,a2
                dbf     d0,loc_65A24

loc_65A30:
                jsr     (MoveSprite_SSZBGAdjust).l
                jsr     (Draw_Sprite).l
                subq.w  #1,$2E(a0)
                bpl.s   locret_65A48
                move.l  #loc_65A4A,(a0)

locret_65A48:
                rts
; ---------------------------------------------------------------------------

loc_65A4A:
                bsr.w   sub_66054
                jsr     (MoveSprite_SSZBGAdjust).l
                jsr     (Draw_Sprite).l
                move.w  (Camera_Y_pos).w,d0
                subi.w  #$38,d0
                cmp.w   y_pos(a0),d0
                bls.w   locret_6206C
                bset    #5,$38(a0)
                bset    #1,(_unkFAB8).w
                lea     (Target_palette_line_4).w,a1
                lea     (Normal_palette_line_4).w,a2
                moveq   #bytesToLcnt($20),d6

loc_65A80:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_65A80
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_65A8C:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_65AB0(pc,d0.w),d1
                jsr     off_65AB0(pc,d1.w)
                jsr     (MoveSprite_SSZBGAdjust).l
                lea     DPLCPtr_SSZDeathEggCloud(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_65AB0:
                dc.w    loc_65AB6-off_65AB0
                dc.w    loc_65AD4-off_65AB0
                dc.w    loc_65AF6-off_65AB0
; ---------------------------------------------------------------------------

loc_65AB6:
                lea     ObjSlot_664B6(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.l  #byte_66739,$30(a0)
                move.w  y_pos(a0),y_vel(a0)
                move.w  #$190,$2E(a0)

loc_65AD4:
                jsr     (Animate_RawMultiDelay).l
                subq.w  #1,$2E(a0)
                bpl.w   locret_6206C
                move.b  #4,routine(a0)
                move.w  #$10,$40(a0)
                move.w  #$180,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_65AF6:
                subq.w  #1,$2E(a0)
                bmi.s   loc_65B02
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_65B02:
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_65B0E:
                lea     ObjDat3_664C8(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_65B24,(a0)
                move.w  y_pos(a0),y_vel(a0)

loc_65B24:
                st      (Spritemask_flag).w
                btst    #2,(_unkFAB8).w
                bne.s   loc_65B3C
                jsr     (MoveSprite_SSZBGAdjust).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_65B3C:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_65B42:
                lea     word_664D4(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_65B5A,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)

loc_65B5A:
                jsr     (Refresh_ChildPosition).l
                lea     byte_66760(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_65B70:
                lea     word_664DA(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_65BAE,(a0)
                jsr     (Random_Number).l
                move.w  #$100,d1
                andi.w  #$3F,d0
                subi.w  #$20,d0
                bpl.s   loc_65B96
                neg.w   d1

loc_65B96:
                move.w  d1,x_vel(a0)
                add.w   d0,x_pos(a0)
                swap    d0
                andi.w  #$1F,d0
                add.w   d0,y_pos(a0)
                move.w  #$100,y_vel(a0)

loc_65BAE:
                move.b  #4,mapping_frame(a0)
                btst    #0,(V_int_run_count+3).w
                beq.s   loc_65BC2
                move.b  #5,mapping_frame(a0)

loc_65BC2:
                addi.w  #-$10,y_vel(a0)
                jsr     (MoveSprite2).l
                jmp     (Sprite_CheckDeleteXY).l
