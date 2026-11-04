; Owner: objects/bosses/mgz/sk
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
                move.b  #mus_EndBoss,(Current_music+1).w

locret_6BF96:
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
                dc.w    loc_6BFCA-MGZ2DrillingRobotnik_Index
                dc.w    loc_6C014-MGZ2DrillingRobotnik_Index
                dc.w    loc_6C024-MGZ2DrillingRobotnik_Index
                dc.w    loc_6C07E-MGZ2DrillingRobotnik_Index
                dc.w    loc_6C0B2-MGZ2DrillingRobotnik_Index
                dc.w    loc_6C0E4-MGZ2DrillingRobotnik_Index
                dc.w    loc_6C122-MGZ2DrillingRobotnik_Index
                dc.w    loc_6C136-MGZ2DrillingRobotnik_Index
                dc.w    loc_6C0E4-MGZ2DrillingRobotnik_Index
                dc.w    loc_6C16A-MGZ2DrillingRobotnik_Index
                dc.w    loc_6C0E4-MGZ2DrillingRobotnik_Index
                dc.w    loc_6C1D4-MGZ2DrillingRobotnik_Index
                dc.w    loc_6C2B2-MGZ2DrillingRobotnik_Index
; ---------------------------------------------------------------------------

loc_6BFCA:
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
                bne.s   loc_6C00A
                move.b  #9,subtype(a1)

loc_6C00A:
                lea     ChildObjDat_6D7C0(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6C014:
                move.b  #4,routine(a0)
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_6C024:
                move.w  y_vel(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$C0,d0
                bge.s   loc_6C06E
                move.w  d0,y_vel(a0)
                btst    #7,$38(a0)
                bne.s   loc_6C068
                move.w  (Camera_Y_pos).w,d1
                addi.w  #$120,d1
                cmp.w   y_pos(a0),d1
                blo.s   loc_6C068
                bset    #7,$38(a0)
                lea     ChildObjDat_6D7EA(pc),a2
                btst    #0,render_flags(a0)
                beq.s   loc_6C062
                lea     ChildObjDat_6D7F2(pc),a2

loc_6C062:
                jsr     (CreateChild3_NormalRepeated).l

loc_6C068:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_6C06E:
                move.b  #6,routine(a0)
                move.b  #5,$39(a0)
                jmp     Swing_Setup1(pc)
; ---------------------------------------------------------------------------

loc_6C07E:
                btst    #6,status(a0)
                bne.s   loc_6C092
                jsr     (Swing_UpAndDown_Count).l
                tst.b   $39(a0)
                bpl.s   loc_6C0AC

loc_6C092:
                move.b  #$16,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_6C200,$34(a0)

loc_6C0AC:
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_6C0B2:
                subq.w  #1,$2E(a0)
                bpl.s   loc_6C0D8
                move.w  #3,$2E(a0)
                subq.w  #2,angle(a0)
                bne.s   loc_6C0D8
                move.b  #$A,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_6C0F6,$34(a0)

loc_6C0D8:
                jsr     (Swing_UpAndDown).l
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_6C0E4:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6C0F6:
                move.l  #loc_6C10C,$34(a0)

loc_6C0FE:
                bset    #3,$38(a0)
                move.w  #$5F,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C10C:
                move.b  #$C,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_6C128,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C122:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6C128:
                move.b  #$E,routine(a0)
                bset    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C136:
                btst    #1,$38(a0)
                beq.s   loc_6C140
                rts
; ---------------------------------------------------------------------------

loc_6C140:
                move.b  #$10,routine(a0)
                bclr    #3,$38(a0)
                move.w  #$5F,$2E(a0)
                move.l  #loc_6C15C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C15C:
                move.b  #$12,routine(a0)
                move.w  #3,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C16A:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                subq.w  #1,$2E(a0)
                bpl.s   locret_6C18E
                move.w  #3,$2E(a0)
                addq.w  #2,angle(a0)
                cmpi.w  #$C,angle(a0)
                bhs.s   loc_6C190

locret_6C18E:
                rts
; ---------------------------------------------------------------------------

loc_6C190:
                move.b  #$14,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_6C1A6,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C1A6:
                move.l  #loc_6C1B2,$34(a0)
                bra.w   loc_6C0FE
; ---------------------------------------------------------------------------

loc_6C1B2:
                move.b  #$16,routine(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_6C200,$34(a0)
                bclr    #7,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_6C1D4:
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bmi.s   loc_6C1E4
                jmp     (Move_WaitNoFall).l
; ---------------------------------------------------------------------------

loc_6C1E4:
                move.b  #$18,routine(a0)
                lea     ChildObjDat_6D7EA(pc),a2
                btst    #0,render_flags(a0)
                beq.s   loc_6C1FA
                lea     ChildObjDat_6D7F2(pc),a2

loc_6C1FA:
                jmp     (CreateChild3_NormalRepeated).l
; ---------------------------------------------------------------------------

loc_6C200:
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
                move.w  #$1DF,(Camera_min_Y_pos).w
                st      (Events_fg_2).w
                btst    #0,render_flags(a0)
                bne.s   loc_6C29E
                move.w  #$6000,(Camera_stored_max_X_pos).w
                jsr     (AllocateObject).l
                bne.s   locret_6C29C
                move.l  #Obj_IncLevEndXGradual,(a1)

locret_6C29C:
                rts
; ---------------------------------------------------------------------------

loc_6C29E:
                clr.w   (Camera_stored_min_X_pos).w
                jsr     (AllocateObject).l
                bne.s   locret_6C2B0
                move.l  #Obj_DecLevStartXGradual,(a1)

locret_6C2B0:
                rts
; ---------------------------------------------------------------------------

loc_6C2B2:
                jsr     (MoveSprite2).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6C2BE:
                move.l  #Obj_Wait,(a0)
                bset    #4,$38(a0)
                move.l  #loc_6C2E2,$34(a0)
                move.w  #$200,priority(a0)
                lea     ChildObjDat_6D822(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6C2E2:
                move.l  #loc_6C2EE,(a0)
                jmp     (AIZBossSK_SignalAndSpawnCapsule).l
; ---------------------------------------------------------------------------

loc_6C2EE:
                tst.b   (_unkFAA8).w
                bne.w   locret_6BF96
                move.l  #locret_6C318,(a0)
                bset    #4,$38(a0)
                jsr     (Restore_LevelMusic).l
                jsr     (AllocateObject).l
                bne.s   locret_6C316
                move.l  #loc_6D104,(a1)

locret_6C316:
                rts
; ---------------------------------------------------------------------------

locret_6C318:
                rts
