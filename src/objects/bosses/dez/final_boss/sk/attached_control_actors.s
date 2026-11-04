; Owner: objects/bosses/dez/final_boss/sk
; Responsibility: Death Egg final-boss attached control actors, damage flags, movement and parent synchronization
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_804B0:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_804C4(pc,d0.w),d1
                jsr     off_804C4(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_804C4:
                dc.w    loc_804C8-off_804C4
                dc.w    loc_804D2-off_804C4
; ---------------------------------------------------------------------------

loc_804C8:
                lea     ObjDat3_812F8(pc),a1
                jmp     (SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

loc_804D2:
                btst    #3,(_unkFAB8).w
                bne.s   loc_804E0
                jmp     (Refresh_ChildPositionAdjusted).l
; ---------------------------------------------------------------------------

loc_804E0:
                move.l  #Wait_Draw,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_804F0:
                lea     ObjDat3_812C8(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_80512,(a0)
                move.w  #$6C,$42(a0)
                move.w  #8,$44(a0)
                move.b  #8,collision_property(a0)

loc_80512:
                tst.b   (_unkFAA9).w
                bne.s   loc_8051C
                bra.w   DEZFinalHead_TickFlashOrDefeat
; ---------------------------------------------------------------------------

loc_8051C:
                move.l  #loc_80522,(a0)

loc_80522:
                tst.b   (_unkFAA9).w
                bmi.s   loc_80536
                bsr.w   DEZFinalHead_TickFlashOrDefeat
                bsr.w   DEZFinalChild_SetPosFromParent
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_80536:
                move.l  #loc_80542,(a0)
                move.b  #$16,collision_flags(a0)

loc_80542:
                tst.b   (_unkFAA9).w
                bpl.s   loc_8055C
                bsr.w   DEZFinalChild_SetPosFromParent
                bsr.w   DEZFinalHead_ProcessHitOrDefeat
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8055C:
                move.l  #loc_80562,(a0)

loc_80562:
                tst.b   (_unkFAA9).w
                beq.s   loc_80576
                bsr.w   DEZFinalChild_SetPosFromParent
                bsr.w   DEZFinalHead_TickFlashOrDefeat
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_80576:
                move.l  #loc_80512,(a0)
                bclr    #7,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_80584:
                clr.w   (Events_bg+$10).w
                bsr.w   DEZFinalChild_SetPosFromParent
                jmp     Child_Draw_Sprite2(pc)
; ---------------------------------------------------------------------------

loc_80590:
                move.l  #loc_805AE,(a0)
                move.b  #8,collision_flags(a0)
                move.b  #-1,collision_property(a0)
                move.w  #$A0,$42(a0)
                move.w  #-$34,$44(a0)

loc_805AE:
                tst.b   collision_flags(a0)
                beq.s   loc_805C2
                bsr.w   DEZFinalChild_SetPosFromParent
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     Child_CheckParent(pc)
; ---------------------------------------------------------------------------

loc_805C2:
                move.l  #loc_805F0,(a0)
                move.b  #-1,collision_property(a0)
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                st      (Events_fg_5).w
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_805F0
                move.l  #loc_8060C,(a1)
                move.w  parent3(a0),parent3(a1)

loc_805F0:
                movea.w parent3(a0),a1
                btst    #2,$38(a1)
                bne.s   loc_80608
                move.l  #loc_805AE,(a0)
                move.b  $25(a0),collision_flags(a0)

loc_80608:
                jmp     Child_CheckParent(pc)
; ---------------------------------------------------------------------------

loc_8060C:
                lea     ObjDat3_812AA(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_80634,(a0)
                bset    #0,render_flags(a0)
                move.w  #$7C,$42(a0)
                move.w  #$28,$44(a0)
                move.b  #1,(_unkFAA9).w

loc_80634:
                move.w  $44(a0),d0
                addq.w  #4,d0
                move.w  d0,$44(a0)
                cmpi.w  #$68,d0
                blo.s   loc_80672
                move.l  #loc_8067A,(a0)
                bset    #2,$38(a0)
                move.b  #$80,(_unkFAA9).w
                st      (Events_fg_5).w
                jsr     (AllocateObject).l
                bne.s   loc_80672
                move.l  #loc_807BC,(a1)
                move.w  parent3(a0),parent3(a1)
                move.w  a0,$3A(a1)

loc_80672:
                bsr.w   DEZFinalChild_SetPosFromParent
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_8067A:
                btst    #2,$38(a0)
                beq.s   loc_8068A
                bsr.w   DEZFinalChild_SetPosFromParent
                jmp     Child_CheckParent(pc)
; ---------------------------------------------------------------------------

loc_8068A:
                move.l  #loc_806A6,(a0)
                move.w  #$80,$2E(a0)
                move.b  #1,(_unkFAA9).w
                st      (Events_fg_5).w
                move.b  #1,(_unkFAA9).w

loc_806A6:
                move.w  $44(a0),d0
                subq.w  #4,d0
                move.w  d0,$44(a0)
                cmpi.w  #$28,d0
                bhi.s   loc_806D2
                movea.w parent3(a0),a1
                bclr    #2,$38(a1)
                clr.w   $1C(a1)
                clr.b   (_unkFAA9).w
                st      (Events_fg_5).w
                jsr     (Go_Delete_Sprite).l

loc_806D2:
                bsr.w   DEZFinalChild_SetPosFromParent
                jmp     Child_Draw_Sprite(pc)
