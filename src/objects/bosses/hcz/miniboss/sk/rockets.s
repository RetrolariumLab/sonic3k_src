; Owner: objects/bosses/hcz/miniboss/sk
; Responsibility: Hydrocity miniboss rocket actors, flight states and attack behavior
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZMiniboss_Rockets:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  HCZMiniboss_Rockets_Index(pc,d0.w),d1
                jsr     HCZMiniboss_Rockets_Index(pc,d1.w)
                moveq   #$20,d0
                jmp     (Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
HCZMiniboss_Rockets_Index:
                dc.w    loc_6A2DE-HCZMiniboss_Rockets_Index
                dc.w    loc_6A2F8-HCZMiniboss_Rockets_Index
                dc.w    loc_6A34C-HCZMiniboss_Rockets_Index
                dc.w    loc_6A36C-HCZMiniboss_Rockets_Index
                dc.w    loc_6A37A-HCZMiniboss_Rockets_Index
                dc.w    loc_6A404-HCZMiniboss_Rockets_Index
                dc.w    loc_6A41E-HCZMiniboss_Rockets_Index
; ---------------------------------------------------------------------------

loc_6A2DE:
                lea     ObjDat_HCZMiniboss_Rockets(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #6,$38(a0)
                lea     ChildObjDat_6AD76(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_6A2F8:
                clr.b   collision_flags(a0)
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.w   locret_69F78
                move.b  #4,routine(a0)
                move.b  #1,$40(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_6A356,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_6A344(pc,d0.w),$3C(a0)
                cmpi.b  #4,d0
                blo.s   locret_6A342
                bset    #0,render_flags(a0)
                move.b  #6,routine(a0)

locret_6A342:
                rts
; ---------------------------------------------------------------------------
word_6A344:
                dc.w    0, $8080, $8000,   $80
; ---------------------------------------------------------------------------

loc_6A34C:
                bsr.w   sub_6AB1A
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6A356:
                move.b  #8,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_6A384,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A36C:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6A372:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A37A:
                bsr.w   sub_6AB1A
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_6A384:
                move.b  #2,$40(a0)
                move.b  #$8B,collision_flags(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_6A3A0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A3A0:
                move.b  #$A,routine(a0)
                move.b  #4,$40(a0)
                move.l  #loc_6A416,$34(a0)
                bclr    #6,$38(a0)
                moveq   #signextendB(sfx_LevelProjectile),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_6A3C4:
                move.b  #2,$40(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_6A3DA,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A3DA:
                move.b  #6,routine(a0)
                cmpi.b  #4,subtype(a0)
                blo.s   loc_6A3EE
                move.b  #4,routine(a0)

loc_6A3EE:
                move.b  #1,$40(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_6A372,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A404:
                bsr.w   sub_6AB1A
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.w   locret_69F78

loc_6A416:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A41E:
                bsr.w   sub_6AB1A
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  byte_6A45C(pc,d0.w),d1
                cmp.b   $3C(a0),d1
                beq.s   loc_6A436
                rts
; ---------------------------------------------------------------------------

loc_6A436:
                move.b  #8,routine(a0)
                clr.b   collision_flags(a0)
                move.b  #2,$40(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_6A3C4,$34(a0)
                bset    #6,$38(a0)
                rts
; ---------------------------------------------------------------------------
byte_6A45C:
                dc.b    $80,   0, $C0, $40
; ---------------------------------------------------------------------------

loc_6A460:
                lea     word_6AD08(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_6A478,(a0)
                bset    #4,shield_reaction(a0)
                rts
; ---------------------------------------------------------------------------

loc_6A478:
                bsr.w   sub_6ABA8

loc_6A47C:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_6A4A2
                btst    #6,$38(a1)
                bne.w   locret_69F78
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_69F78
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_6A4A2:
                jmp     (Go_Delete_Sprite).l
