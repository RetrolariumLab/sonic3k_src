; Owner: objects/cutscenes/knuckles/s3
; Responsibility: Knuckles Hydrocity act-two cutscene state and scene object records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_HCZ2:
                lea     word_44ADA(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_HCZ2_Index(pc,d0.w),d1
                jsr     CutsceneKnux_HCZ2_Index(pc,d1.w)
                lea     DPLCPtr_CutsceneKnux(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
CutsceneKnux_HCZ2_Index:
                dc.w    loc_44AE2-CutsceneKnux_HCZ2_Index
                dc.w    loc_44B00-CutsceneKnux_HCZ2_Index
                dc.w    loc_449A2-CutsceneKnux_HCZ2_Index
                dc.w    loc_44B6C-CutsceneKnux_HCZ2_Index
                dc.w    loc_449A2-CutsceneKnux_HCZ2_Index
                dc.w    loc_44A38-CutsceneKnux_HCZ2_Index
                dc.w    loc_44BAE-CutsceneKnux_HCZ2_Index
word_44ADA:
                dc.w    $540,  $600, $3900, $3940
; ---------------------------------------------------------------------------

loc_44AE2:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  (Camera_min_Y_pos).w,(Camera_stored_min_Y_pos).w
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  #$3940,(Camera_max_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_44B00:
                lea     (Player_1).w,a1
                cmpi.w  #$3990,x_pos(a1)
                blo.s   loc_44B1A
                tst.b   object_control(a1)
                bne.s   loc_44B1A
                btst    #Status_OnObj,status(a1)
                bne.s   loc_44B28

loc_44B1A:
                move.w  (Camera_Y_pos).w,(Camera_min_Y_pos).w
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_44B28:
                move.b  #4,routine(a0)
                bsr.w   sub_456C6
                move.w  #(3*60)-1,$2E(a0)
                move.l  #loc_44B42,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_44B42:
                move.b  #6,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_44B82,$34(a0)
                move.w  #$5C0,(Camera_min_Y_pos).w
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_44B6C:
                subq.w  #4,x_pos(a0)
                lea     (byte_4576B).l,a1
                jsr     (Animate_RawNoSST).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_44B82:
                move.b  #8,routine(a0)
                move.b  #$20,mapping_frame(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_44B9E,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_44B9E:
                move.b  #$A,routine(a0)
                bchg    #0,render_flags(a0)
                bra.w   loc_44A0E
; ---------------------------------------------------------------------------

loc_44BAE:
                jsr     (Animate_Raw).l
                tst.b   render_flags(a0)
                bmi.w   locret_449FA
                lea     (Pal_HCZ2).l,a1
                jsr     (PalLoad_Line1).l
                lea     ChildObjDat_44BEC(pc),a2
                jsr     (CreateChild1_Normal).l
                jsr     (AllocateObject).l
                bne.s   loc_44BE0
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

loc_44BE0:
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
ChildObjDat_44BEC:
                dc.w    2-1
                dc.l    Obj_DecLevStartYGradual
                dc.b    0,   0
                dc.l    Obj_IncLevEndXGradual
                dc.b    0,   0
