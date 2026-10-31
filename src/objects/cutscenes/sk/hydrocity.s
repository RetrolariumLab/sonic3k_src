; Owner: objects/cutscenes/sk
; Responsibility: Hydrocity Knuckles cutscene, deletion callback and private children
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_HCZ2:
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   CutsceneKnux_Delete
                lea     word_62150(pc),a1
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
                dc.w    loc_6215E-CutsceneKnux_HCZ2_Index
                dc.w    loc_62194-CutsceneKnux_HCZ2_Index
                dc.w    loc_62014-CutsceneKnux_HCZ2_Index
                dc.w    loc_62200-CutsceneKnux_HCZ2_Index
                dc.w    loc_62014-CutsceneKnux_HCZ2_Index
                dc.w    loc_620AA-CutsceneKnux_HCZ2_Index
                dc.w    loc_62242-CutsceneKnux_HCZ2_Index
word_62150:
                dc.w    $540,  $600, $3900, $3940
; ---------------------------------------------------------------------------

CutsceneKnux_Delete:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_6215E:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  (Camera_min_Y_pos).w,(Camera_stored_min_Y_pos).w
                move.w  (Camera_max_X_pos).w,(Camera_stored_max_X_pos).w
                move.w  #$3940,(Camera_max_X_pos).w
                lea     ChildObjDat_665A2(pc),a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_6218C
                move.b  #2,subtype(a1)

loc_6218C:
                addi.w  #$9E,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_62194:
                lea     (Player_1).w,a1
                cmpi.w  #$3990,x_pos(a1)
                blo.s   loc_621AE
                tst.b   object_control(a1)
                bne.s   loc_621AE
                btst    #Status_OnObj,status(a1)
                bne.s   loc_621BC

loc_621AE:
                move.w  (Camera_Y_pos).w,(Camera_min_Y_pos).w
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_621BC:
                move.b  #4,routine(a0)
                bsr.w   sub_65DD6
                move.w  #(3*60)-1,$2E(a0)
                move.l  #loc_621D6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_621D6:
                move.b  #6,routine(a0)
                bset    #0,render_flags(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_62216,$34(a0)
                move.w  #$5C0,(Camera_min_Y_pos).w
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_62200:
                subq.w  #4,x_pos(a0)
                lea     (byte_6669F).l,a1
                jsr     (Animate_RawNoSST).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_62216:
                move.b  #8,routine(a0)
                move.b  #$20,mapping_frame(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_62232,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_62232:
                move.b  #$A,routine(a0)
                bchg    #0,render_flags(a0)
                bra.w   loc_62080
; ---------------------------------------------------------------------------

loc_62242:
                jsr     (Animate_Raw).l
                tst.b   render_flags(a0)
                bmi.w   locret_6206C
                lea     (Pal_HCZ2).l,a1
                jsr     (PalLoad_Line1).l
                lea     ChildObjDat_62280(pc),a2
                jsr     (CreateChild1_Normal).l
                jsr     (AllocateObject).l
                bne.s   loc_62274
                move.l  #Obj_Song_Fade_ToLevelMusic,(a1)

loc_62274:
                jsr     (Remove_From_TrackingSlot).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
ChildObjDat_62280:
                dc.w    2-1
                dc.l    Obj_DecLevStartYGradual
                dc.b    0,   0
                dc.l    Obj_IncLevEndXGradual
                dc.b    0,   0
word_6228E:
                dc.w    $176,  $300, $1C00, $1E00
word_62296:
                dc.w    $280,  $280, $1D00, $1D00
