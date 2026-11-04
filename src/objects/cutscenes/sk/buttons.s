; Owner: objects/cutscenes/sk
; Responsibility: Generic cutscene button and Carnival Night water-level cork or switch actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CutsceneButton:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                lea     ObjDat_CutsceneButton(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_65C04,(a0)
                addq.w  #4,y_pos(a0)
                lea     PLC_CutsceneButton(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------
PLC_CutsceneButton: plrlistheader
                plreq   ArtTile_GrayButton, ArtNem_GrayButton
PLC_CutsceneButton_End:
; ---------------------------------------------------------------------------

loc_65C04:
                move.w  (_unkFAA4).w,d0
                beq.s   loc_65C3A
                movea.w d0,a1
                lea     word_65C48(pc),a2
                jsr     (Check_InMyRange).l
                beq.s   loc_65C3A
                move.l  #loc_65C50,(a0)
                move.b  #1,mapping_frame(a0)
                st      (_unkFAA9).w
                clr.w   respawn_addr(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  off_65C40(pc,d0.w),d0
                jsr     off_65C40(pc,d0.w)

loc_65C3A:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
off_65C40:
                dc.w    loc_65C56-off_65C40
                dc.w    loc_65C72-off_65C40
                dc.w    loc_65C78-off_65C40
                dc.w    loc_65CAC-off_65C40
word_65C48:
                dc.w    -$18,   $30,  -$18,   $30
; ---------------------------------------------------------------------------

loc_65C50:
                jmp     (Sprite_CheckDelete).l
; ---------------------------------------------------------------------------

loc_65C56:
                clr.b   (Ctrl_1_locked).w
                move.w  #$1000,d0
                move.w  d0,(Camera_stored_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                lea     (Child6_IncLevY).l,a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_65C72:
                st      (Level_trigger_array+8).w
                rts
; ---------------------------------------------------------------------------

loc_65C78:
                move.w  #$14,(Screen_shake_flag).w
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$100,d0
                move.w  d0,(Mean_water_level).w
                move.w  #$350,(Target_water_level).w
                st      (_unkFAA3).w
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   locret_65CAA
                move.l  #loc_62480,(a1)

locret_65CAA:
                rts
; ---------------------------------------------------------------------------

loc_65CAC:
                move.w  #$14,(Screen_shake_flag).w
                movea.w (Level_layout_main+$40).w,a1
                lea     $8E(a1),a1
                move.w  (Level_layout_header).w,d0
                move.b  #$14,(a1)
                adda.w  d0,a1
                move.b  #$F,(a1)
                adda.w  d0,a1
                move.b  #$F,(a1)
                adda.w  d0,a1
                move.b  #$88,(a1)
                jsr     (AllocateObject).l
                bne.s   loc_65CF4
                move.l  #Obj_CNZVacuumTube,(a1)
                move.w  #$4740,x_pos(a1)
                move.w  #$828,y_pos(a1)
                move.b  #$4C,subtype(a1)

loc_65CF4:
                jsr     (AllocateObject).l
                bne.s   locret_65D14
                move.l  #Obj_CNZVacuumTube,(a1)
                move.w  #$4740,x_pos(a1)
                move.w  #$A28,y_pos(a1)
                move.b  #$20,subtype(a1)

locret_65D14:
                rts
; ---------------------------------------------------------------------------

Obj_CNZWaterLevelCorkFloor:
                jsr     (Obj_WaitOffscreen).l
                move.l  #loc_65D46,(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_65D46
                move.l  #Obj_CorkFloor,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  #1,subtype(a1)
                move.w  a1,$44(a0)

loc_65D46:
                movea.w $44(a0),a1
                cmpi.l  #SKCork_MoveFragmentAndApplyGravity,(a1)
                beq.s   loc_65D58
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_65D58:
                tst.b   (_unkFAA2).w
                bne.s   loc_65D68
                st      (_unkFAA2).w
                move.w  #$958,(Target_water_level).w

loc_65D68:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_CNZWaterLevelButton:
                lea     ObjDat_CutsceneButton(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_65D8C,(a0)
                addq.w  #4,y_pos(a0)
                lea     PLC_CutsceneButton(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

loc_65D8C:
                bsr.w   CutsceneKnucklesSolidThinWrapper
                move.b  #0,mapping_frame(a0)
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_65DD0
                move.b  #1,mapping_frame(a0)
                tst.b   (_unkFAA3).w
                beq.s   loc_65DD0
                clr.b   (_unkFAA3).w
                move.w  #$A58,(Target_water_level).w
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   loc_65DD0
                move.l  #loc_62480,(a1)
                st      subtype(a1)

loc_65DD0:
                jmp     (Sprite_OnScreen_Test).l
