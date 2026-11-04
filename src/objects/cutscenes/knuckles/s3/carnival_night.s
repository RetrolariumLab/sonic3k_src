; Owner: objects/cutscenes/knuckles/s3
; Responsibility: Knuckles Carnival Night act-two cutscene variants, trigger logic and scene object records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_CNZ2A:
                lea     word_44C2E(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_CNZ2A_Index(pc,d0.w),d1
                jsr     CutsceneKnux_CNZ2A_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
CutsceneKnux_CNZ2A_Index:
                dc.w    loc_44C36-CutsceneKnux_CNZ2A_Index
                dc.w    loc_44CA2-CutsceneKnux_CNZ2A_Index
                dc.w    loc_44CC4-CutsceneKnux_CNZ2A_Index
                dc.w    loc_44CEC-CutsceneKnux_CNZ2A_Index
                dc.w    loc_44CC4-CutsceneKnux_CNZ2A_Index
                dc.w    loc_44D6E-CutsceneKnux_CNZ2A_Index
word_44C2E:
                dc.w    $176,  $300, $1B00, $1D00
; ---------------------------------------------------------------------------

loc_44C36:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.l  #S3KnuxScene_ChuckleLoopAnim,$30(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                move.w  #2*60,$2E(a0)
                move.b  #mus_Knuckles,$26(a0)
                move.w  (Camera_min_Y_pos).w,(Camera_stored_min_Y_pos).w
                move.w  (Camera_target_max_Y_pos).w,(Camera_stored_max_Y_pos).w
                move.w  (Camera_min_X_pos).w,(Camera_stored_min_X_pos).w
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  #$280,(Camera_target_max_Y_pos).w
                move.w  #$1D00,$1C(a0)
                move.w  #$1D00,(Camera_max_X_pos).w
                move.l  #loc_44CAE,$34(a0)
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     S3KnuxScene_CNZTallBarrierChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_44CA2:
                jsr     (Animate_Raw).l
                jmp     (S3EndCamera_TickMusicDelay).l
; ---------------------------------------------------------------------------

loc_44CAE:
                move.b  #4,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_44CD0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_44CC4:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_44CD0:
                move.b  #6,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$140,x_vel(a0)
                bra.w   loc_44A1A
; ---------------------------------------------------------------------------

loc_44CEC:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   locret_44D26
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   locret_44D26
                moveq   #0,d0
                move.b  $39(a0),d0
                cmpi.b  #8,d0
                bhs.s   loc_44D28
                move.l  word_44D4A(pc,d0.w),x_vel(a0)   ; and y_vel
                addq.b  #4,d0
                move.b  d0,$39(a0)
                bchg    #0,render_flags(a0)

locret_44D26:
                rts
; ---------------------------------------------------------------------------

loc_44D28:
                move.b  #8,routine(a0)
                bclr    #0,render_flags(a0)
                add.w   d1,y_pos(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_44D52,$34(a0)
                bra.w   loc_449E4
; ---------------------------------------------------------------------------
word_44D4A:
                dc.w    -$100, -$400
                dc.w    $100, -$400
; ---------------------------------------------------------------------------

loc_44D52:
                move.b  #$A,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$400,x_vel(a0)
                bra.w   loc_44A1A
; ---------------------------------------------------------------------------

loc_44D6E:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bmi.w   locret_449FA
                lea     (Pal_CNZ).l,a1
                jsr     (PalLoad_Line1).l
                lea     (PLC_Monitors).l,a1
                jsr     (Load_PLC_Raw).l
                lea     ChildObjDat_44DC4(pc),a2
                jsr     (CreateChild1_Normal).l
                move.w  (Camera_stored_max_Y_pos).w,(Camera_target_max_Y_pos).w
                jsr     (AllocateObject).l
                bne.s   loc_44DB8
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

loc_44DB8:
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
ChildObjDat_44DC4:
                dc.w    3-1
                dc.l    Obj_DecLevStartYGradual
                dc.b    0,   0
                dc.l    Obj_DecLevStartXGradual
                dc.b    0,   0
                dc.l    Obj_IncLevEndXGradual
                dc.b    0,   0
; ---------------------------------------------------------------------------

loc_44DD8:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_44DFE
                move.b  #8,width_pixels(a0)
                moveq   #$13,d1
                move.w  #$100,d2
                move.w  #$200,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull2).l
; ---------------------------------------------------------------------------

loc_44DFE:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_44E04:
                subq.w  #1,$2E(a0)
                bpl.s   locret_44E3E
                moveq   #0,d0
                move.b  $39(a0),d0
                cmpi.b  #6,d0
                bhs.s   loc_44E40
                addq.b  #1,$39(a0)
                add.w   d0,d0
                move.w  word_44E54(pc,d0.w),$2E(a0)
                moveq   #0,d1
                btst    #1,d0
                beq.s   loc_44E2C
                moveq   #$40,d1

loc_44E2C:
                lea     Pal_CNZFlash(pc),a1
                adda.w  d1,a1

; =============== S U B R O U T I N E =======================================

CNZCutsceneS3CopyTwoPaletteLines:
                lea     (Normal_palette_line_3).w,a2
                moveq   #bytesToLcnt($40),d0

loc_44E38:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_44E38

locret_44E3E:
                rts
; End of function CNZCutsceneS3CopyTwoPaletteLines

; ---------------------------------------------------------------------------

loc_44E40:
                tst.b   subtype(a0)
                beq.s   loc_44E4E
                lea     (Pal_CNZ+$20).l,a1
                bsr.s   CNZCutsceneS3CopyTwoPaletteLines

loc_44E4E:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
word_44E54:
                dc.w    8
                dc.w    4
                dc.w    3
                dc.w    2
                dc.w    4
                dc.w    8
                dc.w    8
; ---------------------------------------------------------------------------

CutsceneKnux_CNZ2B:
                lea     word_44E9A(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_CNZ2B_Index(pc,d0.w),d1
                jsr     CutsceneKnux_CNZ2B_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
CutsceneKnux_CNZ2B_Index:
                dc.w    loc_44EA2-CutsceneKnux_CNZ2B_Index
                dc.w    loc_44EC8-CutsceneKnux_CNZ2B_Index
                dc.w    loc_44EE6-CutsceneKnux_CNZ2B_Index
                dc.w    loc_449A2-CutsceneKnux_CNZ2B_Index
                dc.w    loc_44A38-CutsceneKnux_CNZ2B_Index
                dc.w    loc_44F38-CutsceneKnux_CNZ2B_Index
                dc.w    loc_44F5C-CutsceneKnux_CNZ2B_Index
                dc.w    loc_44F94-CutsceneKnux_CNZ2B_Index
word_44E9A:
                dc.w    $720,  $A00, $45C0, $46E0
; ---------------------------------------------------------------------------

loc_44EA2:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                move.b  #$80,(Player_1+object_control).w
                bsr.w   SpawnKnucklesCutsceneMusicTransition
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_44EC8:
                lea     (Player_1).w,a1
                cmpi.w  #$4728,x_pos(a1)
                blo.s   locret_44EDC
                btst    #Status_InAir,status(a1)
                bne.s   loc_44EDE

locret_44EDC:
                rts
; ---------------------------------------------------------------------------

loc_44EDE:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_44EE6:
                move.w  #(button_right_mask<<8)+button_right_mask,(Ctrl_1_logical).w
                cmpi.w  #$4760,(Player_1+x_pos).w
                bhs.s   loc_44EF6
                rts
; ---------------------------------------------------------------------------

loc_44EF6:
                move.b  #6,routine(a0)
                clr.w   (Ctrl_1_logical).w
                lea     (Player_1).w,a1
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  #$1F,$2E(a0)
                move.l  #loc_44F20,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_44F20:
                move.b  #8,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_44F44,$34(a0)
                bra.w   loc_44A0E
; ---------------------------------------------------------------------------

loc_44F38:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_44F44:
                move.b  #$C,routine(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #S3KnuxScene_RunAnim,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_44F5C:
                addq.w  #4,x_pos(a0)
                jsr     (Animate_Raw).l
                tst.b   render_flags(a0)
                bmi.w   locret_449FA
                move.b  #$E,routine(a0)
                clr.b   (Player_1+object_control).w
                lea     (Pal_CNZ).l,a1
                jsr     (PalLoad_Line1).l
                jsr     (AllocateObject).l
                bne.s   locret_44F92
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

locret_44F92:
                rts
; ---------------------------------------------------------------------------

loc_44F94:
                move.w  #(button_left_mask<<8)+button_left_mask,(Ctrl_1_logical).w
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$160,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_44FAA
                rts
; ---------------------------------------------------------------------------

loc_44FAA:
                clr.b   (Ctrl_1_locked).w
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; End of function loc_44F94
