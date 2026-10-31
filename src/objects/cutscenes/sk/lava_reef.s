; Owner: objects/cutscenes/sk
; Responsibility: Lava Reef Knuckles encounter, boulder interaction and scene progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_LRZ2:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  CutsceneKnux_LRZ2_Index(pc,d0.w),d1
                jsr     CutsceneKnux_LRZ2_Index(pc,d1.w)
                bsr.w   Knuckles_Load_PLC_661E0
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
CutsceneKnux_LRZ2_Index:
                dc.w    loc_63A96-CutsceneKnux_LRZ2_Index
                dc.w    loc_63ACA-CutsceneKnux_LRZ2_Index
                dc.w    loc_63AE8-CutsceneKnux_LRZ2_Index
                dc.w    loc_63B10-CutsceneKnux_LRZ2_Index
                dc.w    locret_63B20-CutsceneKnux_LRZ2_Index
; ---------------------------------------------------------------------------

loc_63A96:
                lea     ObjSlot_CutsceneKnux(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                bset    #0,render_flags(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$56,mapping_frame(a0)
                move.w  #$3A38,x_pos(a0)
                move.w  #$EC,y_pos(a0)
                lea     Pal_CutsceneKnux(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

loc_63ACA:
                btst    #1,(_unkFAB8).w
                beq.w   locret_6206C
                move.b  #4,routine(a0)
                move.b  #$DE,mapping_frame(a0)
                move.l  #loc_63AF2,$34(a0)

loc_63AE8:
                lea     byte_66891(pc),a1
                jmp     (Animate_Raw2NoSSTMultiDelay).l
; ---------------------------------------------------------------------------

loc_63AF2:
                move.b  #6,routine(a0)
                bset    #2,(_unkFAB8).w
                move.l  #loc_63B1A,$34(a0)
                lea     byte_668A7(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_63B10:
                lea     byte_668A7(pc),a1
                jmp     (Animate_Raw2NoSSTMultiDelay).l
; ---------------------------------------------------------------------------

loc_63B1A:
                move.b  #8,routine(a0)

locret_63B20:
                rts
; ---------------------------------------------------------------------------

Obj_LRZ2CutsceneKnuckles:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                move.l  #loc_63B40,(a0)
                jsr     (AllocateObject).l
                bne.s   loc_63B40
                move.l  #loc_863C0,(a1)

loc_63B40:
                lea     (Player_1).w,a1
                lea     word_63B94(pc),a2
                jsr     (Check_InMyRange).l
                beq.w   locret_6206C
                move.l  #loc_63B9C,(a0)
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                jsr     (AllocateObject).l
                bne.s   loc_63B72
                move.l  #Obj_CutsceneKnuckles,(a1)
                move.b  #$24,subtype(a1)

loc_63B72:
                bsr.w   sub_65DD6
                jsr     (AllocateObject).l
                bne.s   loc_63B84
                move.l  #loc_63C3E,(a1)

loc_63B84:
                lea     (ArtKosM_LRZKnuxBoulder).l,a1
                move.w  #tiles_to_bytes(ArtTile_LRZKnuxBoulder),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------
word_63B94:
                dc.w    -$10,   $10, -$240,  $240
; ---------------------------------------------------------------------------

loc_63B9C:
                lea     (Player_1).w,a1
                cmpi.w  #$39B0,x_pos(a1)
                blo.s   locret_63BBC
                move.l  #loc_63BBE,(a0)
                st      (Ctrl_1_locked).w
                jsr     (Stop_Object).l
                clr.w   (Ctrl_1_logical).w

locret_63BBC:
                rts
; ---------------------------------------------------------------------------

loc_63BBE:
                lea     (Player_1).w,a1
                btst    #Status_InAir,status(a1)
                bne.w   locret_6206C
                move.l  #loc_63BF4,(a0)
                bset    #0,(_unkFAB8).w
                move.w  #0,(Camera_min_X_pos).w
                st      (Scroll_lock).w
                clr.b   (Ctrl_1_locked).w
                move.b  #$81,object_control(a1)
                move.b  #7,anim(a1)
                rts
; ---------------------------------------------------------------------------

loc_63BF4:
                move.w  (Camera_Y_pos).w,d0
                subq.w  #2,d0
                move.w  d0,(Camera_Y_pos).w
                cmpi.w  #$90,d0
                bhi.w   locret_6206C
                move.l  #loc_63C14,(a0)
                bset    #1,(_unkFAB8).w
                rts
; ---------------------------------------------------------------------------

loc_63C14:
                cmpi.w  #$4C0,(Player_1+y_pos).w
                blo.w   locret_6206C
                st      (Act3_flag).w
                move.w  (Ring_count).w,(Act3_ring_count).w
                move.l  (Timer).w,(Act3_timer).w
                move.b  (Player_1+status_secondary).w,(Saved2_status_secondary).w
                move.w  #$1600,d0
                jmp     (StartNewLevel).l
; ---------------------------------------------------------------------------

loc_63C3E:
                lea     ObjDat3_6647A(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_63C66,(a0)
                move.w  #$3A08,x_pos(a0)
                move.w  #$E2,y_pos(a0)
                move.b  #$1F,y_radius(a0)
                move.w  a0,$46(a0)
                rts
; ---------------------------------------------------------------------------

loc_63C66:
                btst    #2,(_unkFAB8).w
                beq.s   loc_63C7A
                move.l  #loc_63C80,(a0)
                move.w  #-$200,x_vel(a0)

loc_63C7A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_63C80:
                moveq   #signextendB(sfx_PushBlock),d0
                jsr     (Play_SFX_Continuous).l
                bsr.w   sub_65ED4
                bsr.w   sub_65EFE
                jsr     (MoveSprite2).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_63CA6
                move.l  #loc_63CAC,(a0)

loc_63CA6:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_63CAC:
                moveq   #signextendB(sfx_PushBlock),d0
                jsr     (Play_SFX_Continuous).l
                bsr.w   sub_65ED4
                bsr.w   sub_65EFE
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.s   loc_63CE6
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_63CE6
                move.w  #-$100,y_vel(a0)
                move.w  #$14,(Screen_shake_flag).w
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l

loc_63CE6:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
word_63CEC:
                dc.w    $180,  $480,  $FE0, $11E0
                dc.w    $380,  $380, $10E0, $10E0
