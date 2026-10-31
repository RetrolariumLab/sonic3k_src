; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace post-encounter Knuckles movement, ship-scene setup and recovery progression
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_6438A:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$1F,d0
                bne.s   loc_6439C
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l

loc_6439C:
                subq.w  #1,$2E(a0)
                bmi.s   loc_643C6
                rts
; ---------------------------------------------------------------------------

loc_643A4:
                move.b  #$1C,routine(a0)
                move.w  #$7F,$2E(a0)
                st      (Screen_shake_flag).w
                lea     ChildObjDat_66602(pc),a2
                jmp     (CreateChild6_Simple).l
; ---------------------------------------------------------------------------

loc_643BE:
                subq.w  #1,$2E(a0)
                bmi.s   loc_643F2
                rts
; ---------------------------------------------------------------------------

loc_643C6:
                move.b  #$1E,routine(a0)
                move.b  #6,mapping_frame(a0)
                move.w  #$F,$2E(a0)
                lea     ChildObjDat_66644(pc),a2
                jsr     (CreateChild6_Simple).l
                bne.s   locret_643E8
                st      subtype(a1)

locret_643E8:
                rts
; ---------------------------------------------------------------------------

loc_643EA:
                subq.w  #1,$2E(a0)
                bmi.s   loc_64450
                rts
; ---------------------------------------------------------------------------

loc_643F2:
                move.b  #$20,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$56,mapping_frame(a0)
                bclr    #0,render_flags(a0)
                move.w  #7,$2E(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_64422:
                jsr     (Animate_RawCheckResult).l
                move.w  x_vel(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$400,d0
                bhs.s   loc_6443A
                move.w  d0,x_vel(a0)

loc_6443A:
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$180,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_64472
                rts
; ---------------------------------------------------------------------------

loc_64450:
                move.b  #$22,routine(a0)
                lea     byte_66824(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64460:
                jsr     (Animate_RawCheckResult).l
                btst    #0,(_unkFAB8).w
                bne.w   loc_6453C
                rts
; ---------------------------------------------------------------------------

loc_64472:
                move.b  #$24,routine(a0)
                move.w  #2,$44(a0)
                move.l  #Map_HPZKnucklesGrab,mappings(a0)
                move.b  #$A,mapping_frame(a0)
                lea     byte_6687B(pc),a1
                jsr     (Set_Raw_Animation).l
                bset    #7,art_tile(a0)
                move.w  #$1620,x_pos(a0)
                move.w  #$3AC,y_pos(a0)
                clr.b   (_unkFAB8).w
                clr.w   (Screen_shake_flag).w
                jsr     (AllocateObject).l
                bne.s   loc_644BE
                move.l  #loc_64C70,(a1)

loc_644BE:
                jsr     (AllocateObject).l
                bne.s   loc_644CC
                move.l  #loc_64E88,(a1)

loc_644CC:
                jsr     (AllocateObject).l
                bne.s   loc_644DA
                move.l  #Obj_IncLevEndXGradual,(a1)

loc_644DA:
                jsr     (AllocateObject).l
                bne.s   loc_644E8
                move.l  #Obj_DecLevStartYGradual,(a1)

loc_644E8:
                move.w  (Camera_stored_max_Y_pos).w,(Camera_target_max_Y_pos).w
                jsr     (AllocateObject).l
                bne.s   loc_644FC
                move.l  #Obj_IncLevEndYGradual,(a1)

loc_644FC:
                lea     (ArtKosM_KnuxFinalBossCrane).l,a1
                move.w  #tiles_to_bytes(ArtTile_HPZSSZBossCrane),d2
                jsr     (Queue_Kos_Module).l
                lea     PLC_KnuxHPZCutsceneShip(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------
PLC_KnuxHPZCutsceneShip:    plrlistheader
                plreq   ArtTile_RobotnikShip, ArtNem_RobotnikShip
PLC_KnuxHPZCutsceneShip_End:
; ---------------------------------------------------------------------------

loc_6451E:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   locret_6453A
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_6457C

locret_6453A:
                rts
; ---------------------------------------------------------------------------

loc_6453C:
                move.b  #$26,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$9A,mapping_frame(a0)
                move.w  #$C0,x_vel(a0)
                move.w  #-$600,y_vel(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                lea     byte_667C1(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64574:
                subq.w  #1,$2E(a0)
                bmi.s   loc_645B0
                rts
; ---------------------------------------------------------------------------

loc_6457C:
                add.w   d1,y_pos(a0)
                move.b  #$28,routine(a0)
                move.b  #$D6,mapping_frame(a0)
                move.w  #8,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_64594:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   locret_645AE
                cmpi.w  #$339,y_pos(a0)
                bhs.s   loc_645E0

locret_645AE:
                rts
; ---------------------------------------------------------------------------

loc_645B0:
                move.b  #$2A,routine(a0)
                move.w  #-$C0,x_vel(a0)
                move.w  #-$500,y_vel(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                lea     byte_667C1(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_645D4:
                subq.w  #1,$2E(a0)
                bmi.s   loc_6463C
                jmp     (Animate_RawCheckResult).l
; ---------------------------------------------------------------------------

loc_645E0:
                move.b  #$2C,routine(a0)
                move.w  #$339,y_pos(a0)
                move.w  #2,$44(a0)
                move.l  #Map_HPZKnucklesGrab,mappings(a0)
                move.b  #$A,mapping_frame(a0)
                move.w  #$7F,$2E(a0)
                lea     byte_66880(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64610:
                jsr     (Animate_RawCheckResult).l
                move.w  x_vel(a0),d0
                addi.w  #$C,d0
                cmpi.w  #$300,d0
                bls.s   loc_64628
                move.w  #$300,d0

loc_64628:
                move.w  d0,x_vel(a0)
                jsr     (MoveSprite2).l
                cmpi.w  #$1660,x_pos(a0)
                bhs.s   loc_64670
                rts
; ---------------------------------------------------------------------------

loc_6463C:
                move.b  #$2E,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #7,mapping_frame(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                lea     byte_6682F(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64668:
                subq.w  #1,$2E(a0)
                bmi.s   loc_646B8
                rts
; ---------------------------------------------------------------------------

loc_64670:
                move.b  #$30,routine(a0)
                move.w  #2,$44(a0)
                move.l  #Map_HPZKnucklesGrab,mappings(a0)
                move.b  #$D,mapping_frame(a0)
                move.w  #30-1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_64692:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                movea.w (_unkFAAE).w,a1
                lea     word_646B0(pc),a2
                jsr     (Check_InTheirRange).l
                bne.s   loc_6471A
                rts
; ---------------------------------------------------------------------------
word_646B0:
                dc.w    -$20,   $40,  -$20,   $40
; ---------------------------------------------------------------------------

loc_646B8:
                move.b  #$32,routine(a0)
                bset    #1,(_unkFAB8).w
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$9A,mapping_frame(a0)
                move.w  #$300,x_vel(a0)
                move.w  #-$500,y_vel(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                lea     byte_667C1(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_646F6:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   locret_64710
                cmpi.w  #$3AB,y_pos(a0)
                bhs.s   loc_6478E

locret_64710:
                rts
; ---------------------------------------------------------------------------
; unused
                dc.w    -$20,   $40,  -$20,   $40
; ---------------------------------------------------------------------------

loc_6471A:
                bset    #6,status(a1)
                move.b  #$34,routine(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$9A,mapping_frame(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #-$200,y_vel(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                lea     byte_667C1(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_64758:
                jsr     (Animate_RawCheckResult).l
                move.w  x_vel(a0),d0
                addi.w  #$C,d0
                cmpi.w  #$300,d0
                bls.s   loc_64770
                move.w  #$300,d0

loc_64770:
                move.w  d0,x_vel(a0)
                jsr     (MoveSprite2).l
                movea.w (_unkFABA).w,a1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$30,d0
                blo.s   loc_647EC
                rts
; ---------------------------------------------------------------------------

loc_6478E:
                move.w  #$3AB,y_pos(a0)
                move.b  #$36,routine(a0)
                bclr    #7,art_tile(a0)
                move.w  #0,$44(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #7,mapping_frame(a0)
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                lea     byte_6682F(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_647C6:
                jsr     (Animate_RawCheckResult).l
                jsr     (MoveSprite).l
                movea.w (_unkFABA).w,a1
                lea     word_647E4(pc),a2
                jsr     (Check_InTheirRange).l
                bne.s   loc_6482A
                rts
; ---------------------------------------------------------------------------
word_647E4:
                dc.w    -$10,   $60,     0,   $10
; ---------------------------------------------------------------------------

loc_647EC:
                move.b  #$38,routine(a0)
                move.w  #-$600,y_vel(a0)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l
                lea     byte_667C1(pc),a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_6480A:
                btst    #4,(_unkFAB8).w
                bne.s   loc_6486E

loc_64812:
                movea.w (_unkFABA).w,a1
                move.w  x_pos(a1),d0
                subi.w  #$C,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_6482A:
                move.b  #$3A,routine(a0)
                move.w  #2,$44(a0)
                move.l  #Map_HPZKnucklesGrab,mappings(a0)
                move.b  #0,mapping_frame(a0)
                bra.s   loc_64812
; ---------------------------------------------------------------------------

loc_64846:
                subq.w  #1,$2E(a0)
                bmi.s   loc_6489E
                moveq   #0,d0
                move.b  (V_int_run_count+3).w,d1
                btst    #0,d1
                beq.s   loc_6485A
                moveq   #1,d0

loc_6485A:
                move.b  d0,mapping_frame(a0)
                andi.b  #3,d1
                beq.s   loc_6486C
                moveq   #signextendB(sfx_GravityMachine),d0
                jsr     (Play_SFX).l

loc_6486C:
                bra.s   loc_64812
; ---------------------------------------------------------------------------

loc_6486E:
                move.b  #$3C,routine(a0)
                move.w  #60-1,$2E(a0)
                bra.s   loc_64812
; ---------------------------------------------------------------------------

loc_6487C:
                moveq   #0,d0
                btst    #0,(V_int_run_count+3).w
                beq.s   loc_64888
                moveq   #1,d0

loc_64888:
                move.b  d0,mapping_frame(a0)
                jsr     (MoveSprite_LightGravity).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bmi.s   loc_648B8
                rts
; ---------------------------------------------------------------------------

loc_6489E:
                move.b  #$3E,routine(a0)
                move.w  #-$100,x_vel(a0)
                move.w  #-$100,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_648B2:
                jmp     (Animate_Raw2MultiDelay).l
; ---------------------------------------------------------------------------

loc_648B8:
                add.w   d1,y_pos(a0)
                move.b  #$40,routine(a0)
                bset    #5,(_unkFAB8).w
                clr.w   x_vel(a0)
                clr.w   y_vel(a0)
                move.l  #loc_648EA,$34(a0)
                lea     byte_667E7(pc),a1
                jmp     (Set_Raw_Animation).l
; End of function loc_6438A
