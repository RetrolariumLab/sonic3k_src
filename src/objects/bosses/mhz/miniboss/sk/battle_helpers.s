; Owner: objects/bosses/mhz/miniboss/sk
; Responsibility: Mushroom Hill miniboss collision, projectile and movement helper callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; Correct the floor penetration on contact. Bounce once, then schedule the recovery wait on the next contact
MHZMiniThrown_BounceOrStartRecovery:
                bset    #7,$38(a0)
                bne.s   loc_758E2
                add.w   d1,y_pos(a0)
                move.w  x_vel(a0),d0
                asr.w   #1,d0
                move.w  d0,x_vel(a0)
                move.w  y_vel(a0),d0
                asr.w   #1,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_758E2:
                move.b  #4,routine(a0)
                add.w   d1,y_pos(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_758FC,$34(a0)
                rts
; End of function MHZMiniThrown_BounceOrStartRecovery

; ---------------------------------------------------------------------------

loc_758FC:
                move.b  #6,routine(a0)
                clr.w   x_vel(a0)
                move.w  #-$200,y_vel(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_75936,$34(a0)
                lea     ChildObjDat_75EA6(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_75924:
                jsr     (MoveSprite2).l

loc_7592A:
                jsr     (Animate_RawMultiDelay).l
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_75936:
                move.b  #8,routine(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_7594C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_7594C:
                move.b  #$A,routine(a0)
                move.w  #$180,priority(a0)
                move.w  #-$300,y_vel(a0)
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.w  x_pos(a1),d0
                subq.w  #6,d0
                sub.w   x_pos(a0),d0
                smi     d1
                bpl.s   loc_75974
                neg.w   d0

loc_75974:
                swap    d0
                divu.w  #$6100,d0
                tst.b   d1
                beq.s   loc_75980
                neg.w   d0

loc_75980:
                move.w  d0,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_75986:
                addi.w  #$10,y_vel(a0)
                jsr     (MoveSprite2).l
                tst.w   y_vel(a0)
                bmi.s   loc_759AA
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                addi.w  #-8,d0
                cmp.w   y_pos(a0),d0
                bls.s   loc_759B0

loc_759AA:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_759B0:
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_759C0:
                lea     word_75E5E(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_759D0,(a0)

loc_759D0:
                movea.w parent3(a0),a1
                move.b  (V_int_run_count+3).w,d0
                btst    #0,d0
                bne.w   loc_759EC
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------

loc_759EC:
                btst    #7,status(a1)
                bne.s   loc_759F6
                rts
; ---------------------------------------------------------------------------

loc_759F6:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_759FC:
                lea     (ObjDat3_6646E).l,a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_75A24,(a0)
                bsr.w   MHZMiniParticle_InitMotion
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$AC,d0
                move.w  d0,y_pos(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_75A24:
                move.w  x_vel(a0),d0
                add.w   $40(a0),d0
                cmpi.w  #-$100,d0
                ble.s   loc_75A44
                cmpi.w  #$100,d0
                bge.s   loc_75A48
                move.l  #loc_75A48,(a0)
                bset    #0,$38(a0)

loc_75A44:
                move.w  d0,x_vel(a0)

loc_75A48:
                move.w  y_vel(a0),d0
                move.w  $3E(a0),d1
                btst    #0,$38(a0)
                beq.s   loc_75A5A
                moveq   #-1,d1

loc_75A5A:
                sub.w   d1,d0
                cmpi.w  #$80,d0
                blt.s   loc_75A68
                move.l  #loc_75A6C,(a0)

loc_75A68:
                move.w  d0,y_vel(a0)

loc_75A6C:
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bpl.s   loc_75A7E
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_75A7E:
                jmp     (Delete_Current_Sprite).l
; End of function loc_75986
