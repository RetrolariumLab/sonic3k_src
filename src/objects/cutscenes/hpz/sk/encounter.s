; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace Knuckles encounter setup, combat movement, attack and defeat transition state program
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

CutsceneKnux_HPZ:
                movea.l a0,a1
                move.l  #loc_63D1A,(a1)
                lea     (Dynamic_object_RAM+(object_size*45)).w,a2
                move.w  a2,(_unkFAA4).w
                moveq   #bytesToWcnt(object_size),d0

loc_63D0E:
                move.w  (a1)+,(a2)+
                dbf     d0,loc_63D0E
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_63D1A:
                cmpi.b  #2,(Player_1+character_id).w
                beq.w   CutsceneKnux_Delete
                lea     word_63CEC(pc),a1
                jsr     (Check_CameraInRange).l
                jsr     (BeginBossCameraTransitionSaveBoundsAndFadeMusic).l
                jsr     (AllocateObject).l
                bne.s   loc_63D5C
                move.l  #loc_85CA4,(a1)
                move.l  #loc_63DD4,$34(a1)
                move.b  #mus_Knuckles,boss_saved_mus(a1)
                move.w  #2*60,$2E(a1)
                move.b  $27(a0),$27(a1)

loc_63D5C:
                move.l  #loc_63DE0,(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.w  #make_art_tile(ArtTile_CutsceneKnux,1,0),art_tile(a0)
                move.w  #$100,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #$13,y_radius(a0)
                move.b  #9,x_radius(a0)
                move.b  #4,render_flags(a0)
                bset    #0,render_flags(a0)
                move.b  #$D8,mapping_frame(a0)
                move.b  #8,collision_property(a0)
                move.l  #byte_66771,$30(a0)
                clr.w   $44(a0)
                lea     (Normal_palette_line_2).w,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_63DBC:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_63DBC
                lea     Pal_CutsceneKnux(pc),a1
                jsr     (PalLoad_Line1).l
                move.w  #$88,(Normal_palette_line_2+$C).w
                rts
; ---------------------------------------------------------------------------

loc_63DD4:
                bset    #0,(_unkFAB8).w
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_63DE0:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_63E1E(pc,d0.w),d1
                jsr     off_63E1E(pc,d1.w)
                move.w  $44(a0),d0
                move.w  off_63E00(pc,d0.w),d0
                jsr     off_63E00(pc,d0.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_63E00:
                dc.w    loc_63E06-off_63E00
                dc.w    loc_63E0A-off_63E00
                dc.w    loc_63E14-off_63E00
; ---------------------------------------------------------------------------

loc_63E06:
                bra.w   Knuckles_Load_PLC_661E0
; ---------------------------------------------------------------------------

loc_63E0A:
                lea     DPLCPtr_HPZKnucklesGrab(pc),a2
                jmp     (Perform_DPLC).l
; ---------------------------------------------------------------------------

loc_63E14:
                lea     DPLCPtr_SSZKnucklesTired(pc),a2
                jmp     (Perform_DPLC).l
; ---------------------------------------------------------------------------
off_63E1E:
                dc.w    loc_63E7C-off_63E1E
                dc.w    loc_63EDA-off_63E1E
                dc.w    loc_63F3C-off_63E1E
                dc.w    loc_63FD8-off_63E1E
                dc.w    loc_64016-off_63E1E
                dc.w    loc_6403A-off_63E1E
                dc.w    loc_64090-off_63E1E
                dc.w    loc_64102-off_63E1E
                dc.w    loc_6414C-off_63E1E
                dc.w    loc_64184-off_63E1E
                dc.w    loc_641EC-off_63E1E
                dc.w    loc_64258-off_63E1E
                dc.w    loc_642F0-off_63E1E
                dc.w    loc_64350-off_63E1E
                dc.w    loc_6438A-off_63E1E
                dc.w    loc_643BE-off_63E1E
                dc.w    loc_643EA-off_63E1E
                dc.w    loc_64422-off_63E1E
                dc.w    loc_64460-off_63E1E
                dc.w    loc_6451E-off_63E1E
                dc.w    loc_64574-off_63E1E
                dc.w    loc_64594-off_63E1E
                dc.w    loc_645D4-off_63E1E
                dc.w    loc_64610-off_63E1E
                dc.w    loc_64668-off_63E1E
                dc.w    loc_64692-off_63E1E
                dc.w    loc_646F6-off_63E1E
                dc.w    loc_64758-off_63E1E
                dc.w    loc_647C6-off_63E1E
                dc.w    loc_6480A-off_63E1E
                dc.w    loc_64846-off_63E1E
                dc.w    loc_6487C-off_63E1E
                dc.w    loc_648B2-off_63E1E
                dc.w    loc_648E2-off_63E1E
                dc.w    loc_648F2-off_63E1E
                dc.w    loc_64952-off_63E1E
                dc.w    loc_64984-off_63E1E
                dc.w    loc_649AE-off_63E1E
                dc.w    loc_649D6-off_63E1E
                dc.w    loc_64A00-off_63E1E
                dc.w    loc_64A36-off_63E1E
                dc.w    loc_64A6E-off_63E1E
                dc.w    loc_64AC0-off_63E1E
                dc.w    loc_64B10-off_63E1E
                dc.w    loc_64B6A-off_63E1E
                dc.w    loc_64BB8-off_63E1E
                dc.w    loc_64BFA-off_63E1E
; ---------------------------------------------------------------------------

loc_63E7C:
                jsr     (Animate_Raw2MultiDelay).l
                tst.w   d2
                bpl.s   loc_63EA0
                btst    #0,(_unkFAB8).w
                beq.s   loc_63EA0
                move.b  $39(a0),d0
                addq.b  #1,d0
                cmpi.b  #2,d0
                bhs.w   loc_641C4
                move.b  d0,$39(a0)

loc_63EA0:
                jsr     (Find_SonicTails).l
                bsr.w   HPZKnucklesFaceTargetFromSideWord
                cmpi.w  #$40,d3
                bhs.w   locret_6206C
                cmpi.w  #$30,d2
                bhs.w   locret_6206C
                bra.w   loc_63F20
; ---------------------------------------------------------------------------

loc_63EBE:
                move.b  #0,routine(a0)
                clr.b   $39(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                lea     byte_66771(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_63EDA:
                jsr     (Animate_RawCheckResult).l
                jsr     (Find_SonicTails).l
                bsr.w   HPZKnucklesFaceTargetFromSideWord
                cmpi.w  #$10,d3
                bhs.s   loc_63F00
                cmpi.w  #$20,d2
                bhs.s   loc_63F00
                cmpi.b  #2,anim(a1)
                bne.w   loc_63FF8

loc_63F00:
                subq.w  #1,$2E(a0)
                bmi.w   loc_64066
                lea     off_63F10(pc),a3
                bra.w   loc_660BE
; ---------------------------------------------------------------------------
off_63F10:
                dc.l    loc_63F7A
                dc.l    loc_63FF8
                dc.l    loc_6429E
                dc.l    loc_660A6
; ---------------------------------------------------------------------------

loc_63F20:
                move.b  #2,routine(a0)
                move.b  #$DA,mapping_frame(a0)
                move.w  #(2*60)-1,$2E(a0)
                lea     byte_667AD(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_63F3C:
                jsr     (HPZKnucklesStopHorizontalSpeedAtCameraMargins).l
                move.w  x_vel(a0),d0
                beq.s   loc_63F58
                move.w  $40(a0),d1
                add.w   d1,d0
                move.w  d0,x_vel(a0)
                jsr     (MoveSprite2).l

loc_63F58:
                jsr     (Animate_Raw2MultiDelay).l
                bmi.w   locret_6206C
                lea     off_63F6A(pc),a3
                bra.w   loc_660BE
; ---------------------------------------------------------------------------
off_63F6A:
                dc.l    loc_63F7A
                dc.l    loc_660A6
                dc.l    loc_6429E
                dc.l    loc_660A6
; ---------------------------------------------------------------------------

loc_63F7A:
                move.b  #4,routine(a0)
                move.l  #loc_63EBE,$34(a0)
                move.w  #$2C0,d3
                move.w  #-$20,d4
                btst    #0,render_flags(a0)
                bne.s   loc_63F9C
                neg.w   d3
                neg.w   d4

loc_63F9C:
                move.w  d3,x_vel(a0)
                move.w  d4,$40(a0)
                move.w  x_vel(a1),d0
                move.w  #$100,d1
                move.w  #-$100,d2
                cmp.w   d2,d0
                blt.s   loc_63FC0
                cmp.w   d1,d0
                bge.s   loc_63FC0
                tst.w   d0
                bpl.s   loc_63FBE
                move.w  d2,d1

loc_63FBE:
                move.w  d1,d0

loc_63FC0:
                neg.w   d0
                move.w  d0,x_vel(a1)
                neg.w   y_vel(a1)
                neg.w   ground_vel(a1)
                lea     byte_667B4(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_63FD8:
                subq.w  #1,$2E(a0)
                bmi.w   loc_63EBE
                lea     off_63FE8(pc),a3
                bra.w   loc_660BE
; ---------------------------------------------------------------------------
off_63FE8:
                dc.l    loc_660A6
                dc.l    loc_660A6
                dc.l    loc_6429E
                dc.l    loc_660A6
; ---------------------------------------------------------------------------

loc_63FF8:
                tst.b   $34(a1)
                bne.w   locret_6206C
                move.b  #6,routine(a0)
                move.b  #$DE,mapping_frame(a0)
                move.w  #7,$2E(a0)
                bra.w   loc_660AE
; ---------------------------------------------------------------------------

loc_64016:
                jmp     (Animate_RawCheckResult).l
; ---------------------------------------------------------------------------

loc_6401C:
                move.b  #$A,routine(a0)
                move.w  #-$600,y_vel(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                lea     byte_667C1(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_6403A:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bpl.w   loc_640DC
                lea     off_64056(pc),a3
                bra.w   loc_660BE
; ---------------------------------------------------------------------------
off_64056:
                dc.l    loc_660A6
                dc.l    loc_660A6
                dc.l    loc_660A6
                dc.l    loc_660A6
; ---------------------------------------------------------------------------

loc_64066:
                move.b  #8,routine(a0)
                jsr     (Find_SonicTails).l
                bsr.w   HPZKnucklesFaceTargetFromSideWord
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.l  #loc_6401C,$34(a0)
                lea     byte_667CC(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64090:
                jsr     (HPZKnucklesStopHorizontalSpeedAtCameraMargins).l
                jsr     (MoveSprite2).l
                tst.w   x_vel(a0)
                beq.w   loc_64132
                jsr     (Find_SonicTails).l
                cmpi.w  #$30,d2
                blo.s   loc_640C4
                btst    #0,render_flags(a0)
                sne     d4
                tst.w   d0
                beq.s   loc_640BE
                not.b   d4

loc_640BE:
                tst.b   d4
                beq.w   loc_64132

loc_640C4:
                lea     off_640CC(pc),a3
                bra.w   loc_660BE
; ---------------------------------------------------------------------------
off_640CC:
                dc.l    loc_660A6
                dc.l    loc_660A6
                dc.l    loc_6429E
                dc.l    loc_660A6
; ---------------------------------------------------------------------------

loc_640DC:
                move.b  #$C,routine(a0)
                move.b  #$C0,mapping_frame(a0)
                move.w  #$400,d0
                btst    #0,render_flags(a0)
                beq.s   loc_640F6
                neg.w   d0

loc_640F6:
                move.w  d0,x_vel(a0)
                move.w  #$80,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_64102:
                jsr     (Animate_Raw2MultiDelay).l
                jsr     (MoveSprite).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.w   loc_64164
                lea     off_64122(pc),a3
                bra.w   loc_660BE
; ---------------------------------------------------------------------------
off_64122:
                dc.l    loc_6429E
                dc.l    loc_660A6
                dc.l    loc_6429E
                dc.l    loc_660A6
; ---------------------------------------------------------------------------

loc_64132:
                move.b  #$E,routine(a0)
                bchg    #0,render_flags(a0)
                clr.w   x_vel(a0)
                lea     byte_667D4(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_6414C:
                jsr     (Animate_RawCheckResult).l
                jsr     (Find_SonicTails).l
                bsr.w   HPZKnucklesFaceTargetFromSideWord
                lea     off_63F10(pc),a3
                bra.w   loc_660BE
; ---------------------------------------------------------------------------

loc_64164:
                add.w   d1,y_pos(a0)
                move.b  #$10,routine(a0)
                clr.w   y_vel(a0)
                move.l  #loc_63EBE,$34(a0)
                lea     byte_667E0(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64184:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                bne.s   loc_64196
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l

loc_64196:
                jsr     (Animate_RawCheckResult).l
                subq.w  #1,$2E(a0)
                bmi.w   loc_64222
                cmpi.w  #43,$2E(a0)
                bne.s   loc_641BC
                bclr    #0,$38(a0)
                lea     ChildObjDat_665FC(pc),a2
                jsr     (CreateChild6_Simple).l

loc_641BC:
                lea     off_64056(pc),a3
                bra.w   loc_660BE
; ---------------------------------------------------------------------------

loc_641C4:
                move.b  #$12,routine(a0)
                jsr     (Find_SonicTails).l
                bsr.w   HPZKnucklesFaceTargetFromSideWord
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.w  #60-1,$2E(a0)
                lea     byte_667F5(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_641EC:
                jsr     (Animate_RawCheckResult).l
                jsr     (HPZKnucklesStopHorizontalSpeedAtCameraMargins).l
                tst.w   x_vel(a0)
                bne.s   loc_6420C
                bchg    #0,render_flags(a0)
                subq.w  #4,y_pos(a0)
                bra.w   loc_63EBE
; ---------------------------------------------------------------------------

loc_6420C:
                move.w  $40(a0),d0
                add.w   d0,x_vel(a0)
                jsr     (MoveSprite2).l
                lea     off_64056(pc),a3
                bra.w   loc_660BE
; ---------------------------------------------------------------------------

loc_64222:
                move.b  #$14,routine(a0)
                bset    #0,$38(a0)
                move.w  #$800,d0
                move.w  #-$10,d1
                btst    #0,render_flags(a0)
                beq.s   loc_64242
                neg.w   d0
                neg.w   d1

loc_64242:
                move.w  d0,x_vel(a0)
                move.w  d1,$40(a0)
                addq.w  #4,y_pos(a0)
                lea     byte_667C1(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64258:
                jsr     (Animate_RawCheckResult).l
                jsr     (HPZKnucklesStopHorizontalSpeedAtCameraMargins).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   locret_6206C
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.w   locret_6206C
                add.w   d1,y_pos(a0)
                move.w  (Camera_X_pos).w,d0
                addi.w  #$A0,d0
                sub.w   x_pos(a0),d0
                bpl.s   loc_64292
                neg.w   d0

loc_64292:
                cmpi.w  #$60,d0
                blo.w   loc_641C4
                bra.w   loc_64066
; ---------------------------------------------------------------------------

loc_6429E:
                bset    #0,$38(a0)
                moveq   #signextendB(sfx_FloorThump),d0
                jsr     (Play_SFX).l
                move.w  #$300,d3
                move.w  x_pos(a1),d1
                sub.w   x_pos(a0),d1
                bcs.s   loc_642BC
                neg.w   d3

loc_642BC:
                move.w  d3,x_vel(a0)
                move.w  #-$300,y_vel(a0)
                subq.b  #1,collision_property(a0)
                beq.s   loc_64310
                move.b  #$16,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$8D,mapping_frame(a0)
                lea     byte_667BC(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_642F0:
                jsr     (HPZKnucklesStopHorizontalSpeedAtCameraMargins).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.w   locret_6206C
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_64356
                rts
; ---------------------------------------------------------------------------

loc_64310:
                move.b  #$18,routine(a0)
                clr.b   (Update_HUD_timer).w
                move.w  #2,$44(a0)
                move.l  #Map_HPZKnucklesGrab,mappings(a0)
                move.b  #2,mapping_frame(a0)
                bset    #4,$38(a0)
                move.b  #mus_LRZ2,(Current_music+1).w
                jsr     (AllocateObject).l
                bne.s   locret_6434E
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_LRZ2,subtype(a1)

locret_6434E:
                rts
; ---------------------------------------------------------------------------

loc_64350:
                jmp     (Animate_Raw2MultiDelay).l
; ---------------------------------------------------------------------------

loc_64356:
                add.w   d1,y_pos(a0)
                move.b  #$1A,routine(a0)
                move.l  #loc_643A4,$34(a0)
                moveq   #signextendB(sfx_DoorMove),d0
                jsr     (Play_SFX).l
                lea     byte_6680A(pc),a1
                jsr     (Set_Raw_Animation).l
                lea     (ArtKosM_HPZKnuxDizzy).l,a1
                move.w  #tiles_to_bytes(ArtTile_HPZKnuxDizzy),d2
                jmp     (Queue_Kos_Module).l
; End of function loc_6429E
