; Owner: objects/cutscenes/sk
; Responsibility: Carnival Night Knuckles encounters and their local transition helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_CNZ2A:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                lea     word_6228E(pc),a1
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
                dc.w    loc_622E4-CutsceneKnux_CNZ2A_Index
                dc.w    loc_62332-CutsceneKnux_CNZ2A_Index
                dc.w    loc_62354-CutsceneKnux_CNZ2A_Index
                dc.w    loc_6237C-CutsceneKnux_CNZ2A_Index
                dc.w    loc_62354-CutsceneKnux_CNZ2A_Index
                dc.w    loc_623FE-CutsceneKnux_CNZ2A_Index
word_622DC:                                             ; used in S3, unused in S&K
                dc.w    $176,  $300, $1B00, $1D00
; ---------------------------------------------------------------------------

loc_622E4:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.l  #byte_666BF,$30(a0)
                move.l  #loc_6233E,$34(a0)
                lea     word_62296(pc),a1
                move.b  #mus_Knuckles,boss_saved_mus(a0)
                jsr     (loc_85D70).l
                lea     (Normal_palette_line_2).w,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_62318:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_62318
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     ChildObjDat_66560(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_62332:
                jsr     (Animate_Raw).l
                jmp     (loc_85CA4).l
; ---------------------------------------------------------------------------

loc_6233E:
                move.b  #4,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_62360,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_62354:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_62360:
                move.b  #6,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$140,x_vel(a0)
                bra.w   loc_6208C
; ---------------------------------------------------------------------------

loc_6237C:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   locret_623B6
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   locret_623B6
                moveq   #0,d0
                move.b  $39(a0),d0
                cmpi.b  #8,d0
                bhs.s   loc_623B8
                move.l  word_623DA(pc,d0.w),x_vel(a0)   ; and y_vel
                addq.b  #4,d0
                move.b  d0,$39(a0)
                bchg    #0,render_flags(a0)

locret_623B6:
                rts
; ---------------------------------------------------------------------------

loc_623B8:
                move.b  #8,routine(a0)
                bclr    #0,render_flags(a0)
                add.w   d1,y_pos(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_623E2,$34(a0)
                bra.w   loc_62056
; ---------------------------------------------------------------------------
word_623DA:
                dc.w    -$100, -$400
                dc.w    $100, -$400
; ---------------------------------------------------------------------------

loc_623E2:
                move.b  #$A,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #-$600,y_vel(a0)
                move.w  #$400,x_vel(a0)
                bra.w   loc_6208C
; ---------------------------------------------------------------------------

loc_623FE:
                jsr     (Animate_Raw).l
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bmi.w   locret_6206C
                lea     ChildObjDat_66568(pc),a2
                jsr     (CreateChild1_Normal).l
                move.w  (Camera_stored_max_Y_pos).w,(Camera_target_max_Y_pos).w

loc_62422:
                lea     (Target_palette_line_2).w,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_6242C:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_6242C
                lea     (PLC_Monitors).l,a1
                jsr     (Load_PLC_Raw).l
                jsr     (AllocateObject).l
                bne.s   loc_6244C
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

loc_6244C:
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_62458:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.w   CutsceneKnux_Delete
                move.b  #8,width_pixels(a0)
                moveq   #$13,d1
                move.w  #$100,d2
                move.w  #$200,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull2).l
; ---------------------------------------------------------------------------

loc_62480:
                subq.w  #1,$2E(a0)
                bpl.s   locret_624BA
                moveq   #0,d0
                move.b  $39(a0),d0
                cmpi.b  #6,d0
                bhs.s   loc_624BC
                addq.b  #1,$39(a0)
                add.w   d0,d0
                move.w  word_624D0(pc,d0.w),$2E(a0)
                moveq   #0,d1
                btst    #1,d0
                beq.s   loc_624A8
                moveq   #$40,d1

loc_624A8:
                lea     Pal_CNZFlash(pc),a1
                adda.w  d1,a1

; =============== S U B R O U T I N E =======================================

sub_624AE:
                lea     (Normal_palette_line_3).w,a2
                moveq   #bytesToLcnt($40),d0

loc_624B4:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_624B4

locret_624BA:
                rts
; End of function sub_624AE

; ---------------------------------------------------------------------------

loc_624BC:
                tst.b   subtype(a0)
                beq.s   loc_624CA
                lea     (Pal_CNZ+$20).l,a1
                bsr.s   sub_624AE

loc_624CA:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
word_624D0:
                dc.w    8
                dc.w    4
                dc.w    3
                dc.w    2
                dc.w    4
                dc.w    8
                dc.w    8
; ---------------------------------------------------------------------------

CutsceneKnux_CNZ2B:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                lea     word_62520(pc),a1
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
                dc.w    loc_62528-CutsceneKnux_CNZ2B_Index
                dc.w    loc_6254E-CutsceneKnux_CNZ2B_Index
                dc.w    loc_6256C-CutsceneKnux_CNZ2B_Index
                dc.w    loc_62014-CutsceneKnux_CNZ2B_Index
                dc.w    loc_620AA-CutsceneKnux_CNZ2B_Index
                dc.w    loc_625BE-CutsceneKnux_CNZ2B_Index
                dc.w    loc_625E2-CutsceneKnux_CNZ2B_Index
                dc.w    loc_6261A-CutsceneKnux_CNZ2B_Index
word_62520:
                dc.w    $720,  $A00, $45C0, $46E0
; ---------------------------------------------------------------------------

loc_62528:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                move.b  #$80,(Player_1+object_control).w
                bsr.w   sub_65DD6
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_6254E:
                lea     (Player_1).w,a1
                cmpi.w  #$4728,x_pos(a1)
                blo.s   locret_62562
                btst    #Status_InAir,status(a1)
                bne.s   loc_62564

locret_62562:
                rts
; ---------------------------------------------------------------------------

loc_62564:
                move.b  #4,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_6256C:
                move.w  #(button_right_mask<<8)+button_right_mask,(Ctrl_1_logical).w
                cmpi.w  #$4760,(Player_1+x_pos).w
                bhs.s   loc_6257C
                rts
; ---------------------------------------------------------------------------

loc_6257C:
                move.b  #6,routine(a0)
                clr.w   (Ctrl_1_logical).w
                lea     (Player_1).w,a1
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                move.w  #$1F,$2E(a0)
                move.l  #loc_625A6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_625A6:
                move.b  #8,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_625CA,$34(a0)
                bra.w   loc_62080
; ---------------------------------------------------------------------------

loc_625BE:
                jsr     (Animate_Raw).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_625CA:
                move.b  #$C,routine(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)
                move.l  #byte_6669F,$30(a0)
                rts
; ---------------------------------------------------------------------------

loc_625E2:
                addq.w  #4,x_pos(a0)
                jsr     (Animate_Raw).l
                tst.b   render_flags(a0)
                bmi.w   locret_6206C
                move.b  #$E,routine(a0)
                clr.b   (Player_1+object_control).w
                lea     (Pal_CNZ).l,a1
                jsr     (PalLoad_Line1).l
                jsr     (AllocateObject).l
                bne.s   locret_62618
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

locret_62618:
                rts
; ---------------------------------------------------------------------------

loc_6261A:
                move.w  #(button_left_mask<<8)+button_left_mask,(Ctrl_1_logical).w
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$160,d0
                cmp.w   y_pos(a0),d0
                blo.s   loc_62630
                rts
; ---------------------------------------------------------------------------

loc_62630:
                clr.b   (Ctrl_1_locked).w
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; End of function loc_6261A
