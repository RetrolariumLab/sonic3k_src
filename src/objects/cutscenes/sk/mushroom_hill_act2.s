; Owner: objects/cutscenes/sk
; Responsibility: Mushroom Hill second-act Knuckles encounter, motion and scene transition helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_MHZ2:
                cmpi.b  #2,(Player_1+character_id).w
                beq.s   loc_6311A
                cmpi.b  #7,(Last_star_post_hit).w
                bhs.w   CutsceneKnux_Delete
                lea     word_630D0(pc),a1
                jsr     (Check_CameraInRange).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_MHZ2_Index(pc,d0.w),d1
                jsr     CutsceneKnux_MHZ2_Index(pc,d1.w)
                lea     DPLCPtr_MHZKnuxPress(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------

loc_6311A:
                lea     ChildObjDat_665BC(pc),a2
                jsr     (CreateChild1_Normal).l
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------
CutsceneKnux_MHZ2_Index:
                dc.w    loc_63134-CutsceneKnux_MHZ2_Index
                dc.w    loc_63170-CutsceneKnux_MHZ2_Index
                dc.w    loc_631A4-CutsceneKnux_MHZ2_Index
                dc.w    loc_63220-CutsceneKnux_MHZ2_Index
                dc.w    loc_632AE-CutsceneKnux_MHZ2_Index
; ---------------------------------------------------------------------------

loc_63134:
                lea     ObjSlot_CutsceneKnux_MHZ2(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.l  #loc_63182,$34(a0)
                move.w  (Camera_min_X_pos).w,(Camera_stored_min_X_pos).w
                move.w  (word_630DC).l,(_unkFAB4).w
                bsr.w   sub_65DD6
                st      (Events_bg+$16).w
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                lea     ChildObjDat_665BC(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_63170:
                move.w  (Camera_X_pos).w,d0
                move.w  (_unkFAB4).w,d1
                cmp.w   d1,d0
                bhs.s   loc_63182
                move.w  d0,(Camera_min_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_63182:
                move.w  d1,(Camera_min_X_pos).w
                move.b  #4,routine(a0)
                move.w  #60-1,$2E(a0)
                st      (Ctrl_1_locked).w
                st      (Ctrl_2_locked).w
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                rts
; ---------------------------------------------------------------------------

loc_631A4:
                subi.w  #1,$2E(a0)
                bmi.s   loc_631E0
                moveq   #0,d0
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.s   loc_631BE
                bset    #0,d0

loc_631BE:
                lea     (Player_2).w,a2
                tst.l   (a2)
                beq.s   loc_631D4
                tst.b   render_flags(a2)
                bpl.s   loc_631D4
                btst    #Status_InAir,status(a2)
                bne.s   loc_631D8

loc_631D4:
                bset    #1,d0

loc_631D8:
                cmpi.b  #3,d0
                beq.s   loc_631E0

locret_631DE:
                rts
; ---------------------------------------------------------------------------

loc_631E0:
                move.b  #6,routine(a0)
                move.l  #loc_63280,$34(a0)
                move.w  #$10,$3E(a0)
                clr.w   $2E(a0)
                move.b  #1,$39(a0)
                lea     (Player_1).w,a1
                bsr.w   sub_6320E
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   locret_631DE

; =============== S U B R O U T I N E =======================================

sub_6320E:
                move.b  #$81,object_control(a1)
                move.b  #5,anim(a1)
                jmp     (Stop_Object).l
; End of function sub_6320E

; ---------------------------------------------------------------------------

loc_63220:
                bsr.w   sub_65E62
                cmpi.b  #8,anim_frame(a0)
                blo.s   loc_63238
                moveq   #signextendB(sfx_LeafBlower),d0
                jsr     (Play_SFX_Continuous).l
                bsr.w   sub_65EB4

loc_63238:
                lea     byte_666F6(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                beq.s   locret_6327E
                cmpi.b  #$C,anim_frame(a0)
                bne.s   loc_63266
                lea     (Player_1).w,a1
                move.b  #$14,anim(a1)
                lea     (Player_2).w,a1
                tst.b   render_flags(a1)
                bpl.s   loc_63266
                move.b  #$14,anim(a1)

loc_63266:
                cmpi.b  #2,mapping_frame(a0)
                bne.s   locret_6327E
                addq.b  #1,$39(a0)
                subq.w  #4,$3E(a0)
                moveq   #signextendB(sfx_Switch),d0
                jsr     (Play_SFX).l

locret_6327E:
                rts
; ---------------------------------------------------------------------------

loc_63280:
                move.b  #8,routine(a0)
                jsr     (AllocateObject).l
                bne.s   loc_63294
                move.l  #loc_6338E,(a1)

loc_63294:
                tst.b   (Player_2+render_flags).w
                bpl.s   loc_632AE
                jsr     (AllocateObject).l
                bne.s   loc_632AE
                move.l  #loc_6338E,(a1)
                move.b  #2,subtype(a1)

loc_632AE:
                tst.b   render_flags(a0)
                bpl.w   loc_62422
                bra.w   sub_65EB4
; ---------------------------------------------------------------------------
; unused
                lea     (Pal_MHZ2).l,a1
                jsr     (PalLoad_Line1).l
                bra.w   loc_62422
; ---------------------------------------------------------------------------

loc_632CA:
                lea     ObjDat3_66456(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_63308,(a0)
                cmpi.b  #2,(Player_1+character_id).w
                bne.s   loc_632F8
                move.l  #Sprite_OnScreen_Test,(a0)
                move.w  #make_art_tile(ArtTile_MHZKnuxSwitch,0,1),art_tile(a0)
                movea.w parent3(a0),a1
                move.w  respawn_addr(a1),respawn_addr(a0)

loc_632F8:
                lea     (ArtKosM_MHZKnuxSwitch).l,a1
                move.w  #tiles_to_bytes(ArtTile_MHZKnuxSwitch),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_63308:
                movea.w parent3(a0),a1
                clr.b   mapping_frame(a0)
                cmpi.b  #2,mapping_frame(a1)
                bne.s   loc_6331E
                move.b  #1,mapping_frame(a0)

loc_6331E:
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_63324:
                lea     ObjDat3_6646E(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_63372,(a0)
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                cmpi.w  #$140,d0
                blo.s   loc_6334A
                andi.w  #$3F,d0
                lsl.w   #2,d0

loc_6334A:
                move.w  (Camera_X_pos_copy).w,d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                move.w  (Camera_Y_pos_copy).w,d1
                addi.w  #$E8,d1
                move.w  d1,y_pos(a0)
                moveq   #0,d1
                movea.w parent3(a0),a1
                move.b  $39(a1),d1
                add.w   d1,d1
                neg.w   d1
                move.w  d1,y_vel(a0)

loc_63372:
                move.w  y_vel(a0),d0
                add.w   d0,y_pos(a0)
                move.w  (Camera_Y_pos).w,d0
                subq.w  #8,d0
                cmp.w   y_pos(a0),d0
                bhs.w   CutsceneKnux_Delete
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_6338E:
                lea     (Player_1).w,a1
                tst.b   subtype(a0)
                beq.s   loc_6339C
                lea     (Player_2).w,a1

loc_6339C:
                move.l  #loc_633D6,(a0)
                move.w  a1,$44(a0)
                move.w  #-$1000,y_vel(a0)
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                move.b  #$81,object_control(a1)
                move.b  #$F,anim(a1)
                bclr    #1,render_flags(a1)
                bset    #7,art_tile(a1)
                st      (Fast_V_scroll_flag).w
                rts
; ---------------------------------------------------------------------------

loc_633D6:
                moveq   #signextendB(sfx_LeafBlower),d0
                jsr     (Play_SFX_Continuous).l
                jsr     (MoveSprite_LightGravity).l
                movea.w $44(a0),a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                tst.w   y_vel(a0)
                bmi.w   locret_6206C
                clr.b   (Ctrl_1_locked).w
                clr.b   (Ctrl_2_locked).w
                clr.w   (Ctrl_1_logical).w
                clr.w   (Ctrl_2_logical).w
                clr.b   object_control(a1)
                bclr    #7,art_tile(a1)
                clr.b   anim(a1)
                move.w  #$10,ground_vel(a1)
                clr.b   (Fast_V_scroll_flag).w
                clr.b   (Events_bg+$16).w
                move.b  #7,(Last_star_post_hit).w
                move.w  #$52A,(Saved_X_pos).w
                move.w  #$5AC,(Saved_Y_pos).w
                jsr     (Save_Level_Data).l
                jmp     (Delete_Current_Sprite).l
