; Owner: objects/bosses/hcz/miniboss/s3
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
                dc.w    loc_4812E-HCZMiniboss_Rockets_Index
                dc.w    loc_48148-HCZMiniboss_Rockets_Index
                dc.w    loc_4819C-HCZMiniboss_Rockets_Index
                dc.w    loc_481BC-HCZMiniboss_Rockets_Index
                dc.w    loc_481CA-HCZMiniboss_Rockets_Index
                dc.w    loc_48254-HCZMiniboss_Rockets_Index
                dc.w    loc_4826E-HCZMiniboss_Rockets_Index
; ---------------------------------------------------------------------------

loc_4812E:
                lea     ObjDat_HCZMiniboss_Rockets(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bset    #6,$38(a0)
                lea     ChildObjDat_48BBA(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_48148:
                clr.b   collision_flags(a0)
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                beq.w   locret_47DC8
                move.b  #4,routine(a0)
                move.b  #1,$40(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_481A6,$34(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_48194(pc,d0.w),$3C(a0)
                cmpi.b  #4,d0
                blo.s   locret_48192
                bset    #0,render_flags(a0)
                move.b  #6,routine(a0)

locret_48192:
                rts
; ---------------------------------------------------------------------------
word_48194:
                dc.w    0, $8080, $8000,   $80
; ---------------------------------------------------------------------------

loc_4819C:
                bsr.w   UpdateHCZMinibossRocketTwistPose
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_481A6:
                move.b  #8,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_481D4,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_481BC:
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_481C2:
                move.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_481CA:
                bsr.w   UpdateHCZMinibossRocketTwistPose
                jmp     (Obj_Wait).l
; ---------------------------------------------------------------------------

loc_481D4:
                move.b  #2,$40(a0)
                move.b  #$8B,collision_flags(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_481F0,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_481F0:
                move.b  #$A,routine(a0)
                move.b  #4,$40(a0)
                move.l  #loc_48266,$34(a0)
                bclr    #6,$38(a0)
                moveq   #signextendB(sfx_LevelProjectile),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

loc_48214:
                move.b  #2,$40(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_4822A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_4822A:
                move.b  #6,routine(a0)
                cmpi.b  #4,subtype(a0)
                blo.s   loc_4823E
                move.b  #4,routine(a0)

loc_4823E:
                move.b  #1,$40(a0)
                move.w  #$3F,$2E(a0)
                move.l  #loc_481C2,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_48254:
                bsr.w   UpdateHCZMinibossRocketTwistPose
                movea.w parent3(a0),a1
                btst    #3,$38(a1)
                bne.w   locret_47DC8

loc_48266:
                move.b  #$C,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_4826E:
                bsr.w   UpdateHCZMinibossRocketTwistPose
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.b   #1,d0
                move.b  byte_482AC(pc,d0.w),d1
                cmp.b   $3C(a0),d1
                beq.s   loc_48286
                rts
; ---------------------------------------------------------------------------

loc_48286:
                move.b  #8,routine(a0)
                clr.b   collision_flags(a0)
                move.b  #2,$40(a0)
                move.w  #$1F,$2E(a0)
                move.l  #loc_48214,$34(a0)
                bset    #6,$38(a0)
                rts
; ---------------------------------------------------------------------------
byte_482AC:
                dc.b    $80,   0, $C0, $40
; ---------------------------------------------------------------------------

loc_482B0:
                lea     word_48B4C(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_482C2,(a0)
                rts
; ---------------------------------------------------------------------------

loc_482C2:
                bsr.w   FollowHCZMinibossRocketTipPose

loc_482C6:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_482EC
                btst    #6,$38(a1)
                bne.w   locret_47DC8
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_47DC8
                jmp     (Draw_And_Touch_Sprite).l
; ---------------------------------------------------------------------------

loc_482EC:
                jmp     (Go_Delete_Sprite).l
