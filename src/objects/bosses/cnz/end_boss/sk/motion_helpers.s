; Owner: objects/bosses/cnz/end_boss/sk
; Responsibility: Carnival Night end-boss movement, collision, attack and child positioning helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SetCNZBossMagnetDepthFromPhase:
                move.b  $3C(a0),d0
                move.w  #$200,priority(a0)
                addi.b  #$40,d0
                bpl.s   locret_6EBEE
                move.w  #$280,priority(a0)

locret_6EBEE:
                rts
; End of function SetCNZBossMagnetDepthFromPhase

; =============== S U B R O U T I N E =======================================

SelectCNZBossMagnetPhaseFrame:
                cmpi.b  #3,mapping_frame(a0)
                beq.s   locret_6EC12
                move.b  $3C(a0),d0
                lea     byte_6EC14(pc),a1
                moveq   #5-1,d6

loc_6EC02:
                cmp.b   (a1)+,d0
                blo.s   loc_6EC0E
                addq.w  #1,a1
                dbf     d6,loc_6EC02
                rts
; ---------------------------------------------------------------------------

loc_6EC0E:
                move.b  (a1)+,mapping_frame(a0)

locret_6EC12:
                rts
; End of function SelectCNZBossMagnetPhaseFrame

; ---------------------------------------------------------------------------
byte_6EC14:
                dc.b    $30,   1
                dc.b    $58,   8
                dc.b    $A8,   2
                dc.b    $D0,   8
                dc.b    $FF,   1
                even

; =============== S U B R O U T I N E =======================================

; Delete when the parent's pulse ends or the parent is defeated
CNZBossSpark_TryDelete:
                movea.w parent3(a0),a1
                btst    #7,$38(a1)
                bne.s   loc_6EC34
                btst    #7,status(a1)
                bne.s   loc_6EC34
                rts
; ---------------------------------------------------------------------------

loc_6EC34:
                jmp     (Go_Delete_Sprite).l
; End of function CNZBossSpark_TryDelete

; =============== S U B R O U T I N E =======================================

PullBothPlayersWithCNZBossMagnet:
                btst    #2,$38(a0)
                bne.s   loc_6EC44
                rts
; ---------------------------------------------------------------------------

loc_6EC44:
                lea     (Player_1).w,a1
                bsr.w   DisplacePlayerTowardCNZBossMagnet
                lea     (Player_2).w,a1
; End of function PullBothPlayersWithCNZBossMagnet

; =============== S U B R O U T I N E =======================================

DisplacePlayerTowardCNZBossMagnet:
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                spl     d1
                bpl.s   loc_6EC5E
                neg.w   d0

loc_6EC5E:
                andi.w  #$FFC0,d0
                cmpi.w  #$1C0,d0
                blo.s   loc_6EC6C
                move.w  #$1C0,d0

loc_6EC6C:
                lsr.w   #4,d0
                move.l  dword_6EC7E(pc,d0.w),d2
                tst.b   d1
                bne.s   loc_6EC78
                neg.l   d2

loc_6EC78:
                add.l   d2,x_pos(a1)
                rts
; End of function DisplacePlayerTowardCNZBossMagnet

; ---------------------------------------------------------------------------
dword_6EC7E:
                dc.l    $28000
                dc.l    $20000
                dc.l    $1C000
                dc.l    $18000
                dc.l    $14000
                dc.l    $10000
                dc.l    $C000
                dc.l    $8000

; =============== S U B R O U T I N E =======================================

HandleCNZEndBossFourColorHitOrDefeat:
                tst.l   (a0)
                beq.s   locret_6ECF4
                tst.b   collision_flags(a0)
                bne.s   locret_6ECF4
                tst.b   collision_property(a0)
                beq.s   loc_6ECF6
                tst.b   $20(a0)
                bne.s   loc_6ECC2
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_6ECC2:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_6ECD4
                addq.w  #2*4,d0

loc_6ECD4:
                lea     word_6ED0A(pc),a1
                lea     word_6ED12(pc,d0.w),a2
                jsr     (CopyWordData_4).l
                subq.b  #1,$20(a0)
                bne.s   locret_6ECF4
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_6ECF4:
                rts
; ---------------------------------------------------------------------------

loc_6ECF6:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #loc_6E6C6,$34(a0)
                jmp     (BossDefeated_StopTimer).l
; End of function HandleCNZEndBossFourColorHitOrDefeat

; ---------------------------------------------------------------------------
word_6ED0A:
                dc.w    Normal_palette_line_2+$12, Normal_palette_line_2+$14, Normal_palette_line_2+$16, Normal_palette_line_2+$1C
word_6ED12:
                dc.w    $60,   $20,   $20,  $640
                dc.w    $888,  $EEE,  $EEE,  $AAA

; =============== S U B R O U T I N E =======================================

BreakCNZBossDroppedCoreWhenParentDefeats:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   loc_6ED32
                clr.b   collision_flags(a0)

loc_6ED32:
                btst    #4,$38(a1)
                bne.s   loc_6ED3C
                rts
; ---------------------------------------------------------------------------

loc_6ED3C:
                move.l  #Delete_Current_Sprite,(a0)
                lea     ChildObjDat_6EDF2(pc),a2
                jmp     (CreateChild1_Normal).l
; End of function BreakCNZBossDroppedCoreWhenParentDefeats

; =============== S U B R O U T I N E =======================================

DetachCNZBossMagnetAfterParentDefeat:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   loc_6ED5C
                clr.b   collision_flags(a0)

loc_6ED5C:
                btst    #4,$38(a1)
                bne.s   loc_6ED66
                rts
; ---------------------------------------------------------------------------

loc_6ED66:
                bset    #7,status(a0)
                move.b  #1,mapping_frame(a0)
                clr.b   collision_flags(a0)
                move.l  #Obj_FlickerMove,(a0)
                moveq   #0,d0
                jmp     (Set_IndexedVelocity).l
; End of function DetachCNZBossMagnetAfterParentDefeat
