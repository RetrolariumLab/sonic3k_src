; Owner: objects/ending/sk
; Responsibility: Ending companion actor states, parent-relative motion, pose progression and child cleanup
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_5EA52:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5EA6A(pc,d0.w),d1
                jsr     off_5EA6A(pc,d1.w)
                bsr.w   EndingTornado_UpdateSubSprites
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
off_5EA6A:
                dc.w    loc_5EA74-off_5EA6A
                dc.w    loc_5EADC-off_5EA6A
                dc.w    loc_5EB02-off_5EA6A
                dc.w    loc_5EB16-off_5EA6A
                dc.w    loc_5EB2E-off_5EA6A
; ---------------------------------------------------------------------------

loc_5EA74:
                lea     ObjDat3_600CE(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,$38(a0)
                beq.s   loc_5EA8C
                bclr    #2,render_flags(a0)

loc_5EA8C:
                tst.b   subtype(a0)
                beq.s   loc_5EABA
                move.b  #4,routine(a0)
                move.w  #$40,x_pos(a0)
                move.w  #$10B,d0
                move.w  d0,y_pos(a0)
                move.w  d0,$3A(a0)
                tst.b   (_unkFA88).w
                bmi.s   loc_5EABA
                lea     ChildObjDat_601E8(pc),a2
                jsr     (CreateChild1_Normal).l

loc_5EABA:
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_5EAC6
                subq.b  #4,$43(a0)

loc_5EAC6:
                bset    #6,render_flags(a0)
                move.w  #2,mainspr_childsprites(a0)
                lea     ChildObjDat_601C2(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_5EADC:
                jsr     (Child_GetPriority).l
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_5EAF4
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

loc_5EAF4:
                move.b  #8,routine(a0)
                move.w  y_pos(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------

loc_5EB02:
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.s   locret_5EB14
                move.b  #6,routine(a0)

locret_5EB14:
                rts
; ---------------------------------------------------------------------------

loc_5EB16:
                btst    #0,(_unkFAB8).w
                bne.s   loc_5EB26
                addq.w  #2,x_pos(a0)
                bra.w   EndingBobYFromSavedBaseAndByteSinePhase
; ---------------------------------------------------------------------------

loc_5EB26:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_5EB2E:
                bra.w   EndingBobYFromSavedBaseAndByteSinePhase
