; Owner: objects/cutscenes/hpz/sk
; Responsibility: Hidden Palace ship actor state, synchronized motion and interaction callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_64E88:
                lea     ObjDat3_664EE(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.w  a0,(_unkFAAE).w
                move.l  #loc_64EC4,(a0)
                bset    #0,render_flags(a0)
                move.w  #$1640,x_pos(a0)
                move.w  #$2D0,y_pos(a0)
                lea     (Child1_MakeRoboHead4).l,a2
                jsr     (CreateChild1_Normal).l
                lea     ChildObjDat_66608(pc),a2
                jsr     (CreateChild1_Normal).l

loc_64EC4:
                btst    #2,$38(a0)
                beq.s   loc_64EEC
                move.l  #loc_64EF2,(a0)
                move.w  #$100,x_vel(a0)
                move.w  #$180,y_vel(a0)
                move.w  #$40,$2E(a0)
                move.l  #loc_64F04,$34(a0)

loc_64EEC:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_64EF2:
                jsr     (MoveSprite2).l
                jsr     (Obj_Wait).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_64F04:
                move.l  #loc_64F20,(a0)
                clr.w   x_vel(a0)
                jsr     (Swing_Setup1).l
                lea     (Child1_MakeRoboShipFlame).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_64F20:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                btst    #6,status(a0)
                bne.s   loc_64F38
                addq.w  #2,x_pos(a0)

loc_64F38:
                cmpi.w  #$1890,x_pos(a0)
                blo.s   loc_64F66
                move.l  #loc_64F70,(a0)
                bset    #4,$38(a0)
                clr.w   x_vel(a0)
                move.b  #$F,collision_flags(a0)
                move.b  #-1,collision_property(a0)
                lea     ChildSpriteDat_66624(pc),a2
                jsr     (CreateChild3_NormalRepeated).l

loc_64F66:
                bsr.w   HPZShipCountMovingHitPauseAndClearStatusBit
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_64F70:
                move.b  (_unkFAB8).w,d0
                andi.b  #$C,d0
                cmpi.b  #$C,d0
                bne.s   loc_64F8A
                move.l  #loc_64FA0,(a0)
                bset    #4,(_unkFAB8).w

loc_64F8A:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                bsr.w   HPZShipFlashThreePaletteSlotsAndRestoreContactAfterHit
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_64FA0:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                btst    #5,(_unkFAB8).w
                beq.s   loc_64FD2
                move.l  #loc_64FDC,(a0)
                move.w  #$190,x_vel(a0)
                bclr    #4,$38(a0)
                lea     (Child1_MakeRoboShipFlame).l,a2
                jsr     (CreateChild1_Normal).l

loc_64FD2:
                bsr.w   HPZShipFlashThreePaletteSlotsAndRestoreContactAfterHit
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_64FDC:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                move.w  (Camera_X_pos).w,d0
                addi.w  #$200,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_65000
                bsr.w   HPZShipFlashThreePaletteSlotsAndRestoreContactAfterHit
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_65000:
                ori.b   #$30,$38(a0)
                movea.w (_unkFABA).w,a1
                jsr     (Delete_Referenced_Sprite).l
                clr.w   (_unkFABA).w
                clr.w   (Palette_cycle_counter1).w
                lea     (ArtKosM_Teleporter).l,a1
                move.w  #tiles_to_bytes(ArtTile_HPZTeleporter),d2
                jsr     (Queue_Kos_Module).l
                jmp     (Go_Delete_Sprite).l
; End of function loc_64E88
