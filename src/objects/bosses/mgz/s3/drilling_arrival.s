; Owner: objects/bosses/mgz/s3
; Responsibility: Marble Garden drilling Robotnik arrival scene, movement and battle transition
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MGZ2DrillingRobotnik:
                move.l  #Obj_Wait,(a0)
                move.b  #1,(Boss_flag).w
                move.w  #2*60,$2E(a0)
                move.l  #Obj_MGZ2DrillingRobotnikGo,$34(a0)
                clr.b   subtype(a0)
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                lea     (ArtKosM_MGZEndBoss).l,a1
                move.w  #tiles_to_bytes(ArtTile_MGZEndBoss),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_MGZEndBossDebris).l,a1
                move.w  #tiles_to_bytes(ArtTile_MGZEndBossDebris),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_6D,d0
                jsr     (Load_PLC).l
                lea     Pal_MGZEndBoss(pc),a1
                jmp     (PalLoad_Line1).l
; ---------------------------------------------------------------------------

Obj_MGZ2DrillingRobotnikGo:
                move.l  #Obj_MGZ2DrillingRobotnikStart,(a0)
                moveq   #signextendB(mus_EndBoss),d0    ; Play boss music
                jsr     (Play_Music).l

locret_49DD8:
                rts
; ---------------------------------------------------------------------------

Obj_MGZ2DrillingRobotnikStart:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MGZ2DrillingRobotnik_Index(pc,d0.w),d1
                jsr     MGZ2DrillingRobotnik_Index(pc,d1.w)
                bsr.w   MGZ2_SpecialCheckHit
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------
MGZ2DrillingRobotnik_Index:
                dc.w    loc_49E0C-MGZ2DrillingRobotnik_Index
                dc.w    loc_49E56-MGZ2DrillingRobotnik_Index
                dc.w    loc_49E6E-MGZ2DrillingRobotnik_Index
                dc.w    loc_49EC8-MGZ2DrillingRobotnik_Index
                dc.w    loc_49EFC-MGZ2DrillingRobotnik_Index
                dc.w    loc_49F2E-MGZ2DrillingRobotnik_Index
                dc.w    loc_49F6C-MGZ2DrillingRobotnik_Index
                dc.w    loc_49F80-MGZ2DrillingRobotnik_Index
                dc.w    loc_49F2E-MGZ2DrillingRobotnik_Index
                dc.w    loc_49FB4-MGZ2DrillingRobotnik_Index
                dc.w    loc_49F2E-MGZ2DrillingRobotnik_Index
                dc.w    loc_4A01E-MGZ2DrillingRobotnik_Index
                dc.w    loc_4A0EC-MGZ2DrillingRobotnik_Index
; ---------------------------------------------------------------------------

loc_49E0C:
                lea     ObjDat_MGZDrillBoss(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #-1,collision_property(a0)
                move.b  #$30,x_radius(a0)
                move.b  #$24,y_radius(a0)
                move.w  #$C,angle(a0)
                bset    #3,$38(a0)
                move.w  #-$800,y_vel(a0)
                lea     Child1_MakeRoboShip3(pc),a2
                jsr     (CreateChild1_Normal).l
                bne.s   loc_49E4C
                move.b  #9,subtype(a1)

loc_49E4C:
                lea     ChildObjDat_4B3D4(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_49E56:
                tst.l   (Nem_decomp_queue).w
                bne.w   locret_49DD8
                move.b  #4,routine(a0)
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_49E6E:
                move.w  y_vel(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$C0,d0
                bge.s   loc_49EB8
                move.w  d0,y_vel(a0)
                btst    #7,$38(a0)
                bne.s   loc_49EB2
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$120,d1
                cmp.w   y_pos(a0),d1
                blo.s   loc_49EB2
                bset    #7,$38(a0)
                lea     ChildObjDat_4B3FE(pc),a2
                btst    #0,render_flags(a0)
                beq.s   loc_49EAC
                lea     ChildObjDat_4B406(pc),a2

loc_49EAC:
                jsr     (CreateChild3_NormalRepeated).l

loc_49EB2:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_49EB8:
                move.b  #6,routine(a0)
                move.b  #5,$39(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

loc_49EC8:
                btst    #6,status(a0)
                bne.s   loc_49EDC
                jsr     (Swing_UpAndDown_Count).l
                tst.b   $39(a0)
                bpl.s   loc_49EF6

loc_49EDC:
                move.b  #$16,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_4A04A,$34(a0)

loc_49EF6:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_49EFC:
                subq.w  #1,$2E(a0)
                bpl.s   loc_49F22
                move.w  #3,$2E(a0)
                subq.w  #2,angle(a0)
                bne.s   loc_49F22
                move.b  #$A,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_49F40,$34(a0)

loc_49F22:
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_49F2E:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_49F40:
                move.l  #loc_49F56,$34(a0)

loc_49F48:
                bset    #3,$38(a0)
                move.w  #$5F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_49F56:
                move.b  #$C,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_49F72,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_49F6C:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_49F72:
                move.b  #$E,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_49F80:
                btst    #1,$38(a0)
                beq.s   loc_49F8A
                rts
; ---------------------------------------------------------------------------

loc_49F8A:
                move.b  #$10,routine(a0)
                bclr    #3,$38(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_49FA6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_49FA6:
                move.b  #$12,routine(a0)
                move.w  #3,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_49FB4:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   locret_49FD8
                move.w  #3,$2E(a0)
                addq.w  #2,angle(a0)
                cmpi.w  #$C,angle(a0)
                bhs.s   loc_49FDA

locret_49FD8:
                rts
; ---------------------------------------------------------------------------

loc_49FDA:
                move.b  #$14,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_49FF0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_49FF0:
                move.l  #loc_49FFC,$34(a0)
                bra.w   loc_49F48
; ---------------------------------------------------------------------------

loc_49FFC:
                move.b  #$16,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_4A04A,$34(a0)
                bclr    #7,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_4A01E:
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bmi.s   loc_4A02E
                jmp     (Move_WaitNoFall).l
; ---------------------------------------------------------------------------

loc_4A02E:
                move.b  #$18,routine(a0)
                lea     ChildObjDat_4B3FE(pc),a2
                btst    #0,render_flags(a0)
                beq.s   loc_4A044
                lea     ChildObjDat_4B406(pc),a2

loc_4A044:
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_4A04A:
                bset    #5,$38(a0)
                clr.b   (Boss_flag).w
                move.l  #Delete_Current_Sprite,(a0)
                jsr     (Restore_LevelMusic).l
                lea     (MGZ_8x8_Primary_KosM).l,a1
                move.w  #tiles_to_bytes($000),d2
                jsr     (Queue_Kos_Module).l
                lea     (MGZ2_8x8_Secondary_KosM).l,a1
                move.w  #tiles_to_bytes($252),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_14,d0
                jsr     (Load_PLC).l
                lea     (ArtKosM_Spiker).l,a1
                move.w  #tiles_to_bytes(ArtTile_Spiker),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_Mantis).l,a1
                move.w  #tiles_to_bytes(ArtTile_Mantis),d2
                jsr     (Queue_Kos_Module).l
                lea     (PLC_MonitorsSpikesSprings).l,a1
                jsr     (Load_PLC_Raw).l
                lea     (Pal_MGZ).l,a1
                jsr     (PalLoad_Line1).l
                btst    #0,render_flags(a0)
                bne.s   loc_4A0DA
                lea     (Child6_IncLevX).l,a2
                move.w  #$6000,(Camera_stored_max_X_pos).w
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_4A0DA:
                lea     (Child6_DecLevX).l,a2
                move.w  #0,(Camera_stored_min_X_pos).w
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_4A0EC:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
