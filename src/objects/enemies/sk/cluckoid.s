; Owner: objects/enemies/sk
; Responsibility: Cluckoid enemy movement, projectiles, helper callbacks and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Cluckoid:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Cluckoid_Index(pc,d0.w),d1
                jsr     Cluckoid_Index(pc,d1.w)
                lea     DPLCPtr_Cluckoid(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Sprite_CheckDeleteTouchSlotted).l
; ---------------------------------------------------------------------------
Cluckoid_Index:
                dc.w    loc_8E1AA-Cluckoid_Index
                dc.w    loc_8E1BE-Cluckoid_Index
                dc.w    loc_8E1E2-Cluckoid_Index
                dc.w    loc_8E21A-Cluckoid_Index
; ---------------------------------------------------------------------------

loc_8E1AA:
                lea     ObjSlot_Cluckoid(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                lea     ChildObjDat_8E402(pc),a2
                jmp     (CreateChild10_NormalAdjusted).l
; ---------------------------------------------------------------------------

loc_8E1BE:
                jsr     (Find_SonicTails).l
                cmpi.w  #$80,d2
                bhs.s   locret_8E1D0
                cmpi.w  #$40,d3
                blo.s   loc_8E1D2

locret_8E1D0:
                rts
; ---------------------------------------------------------------------------

loc_8E1D2:
                move.b  #4,routine(a0)
                move.l  #loc_8E20C,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8E1E2:
                cmpi.b  #7,mapping_frame(a0)
                blo.s   loc_8E202
                bset    #7,$38(a0)
                bne.s   loc_8E1FA
                moveq   #signextendB(sfx_EnemyBreath),d0
                jsr     (Play_SFX).l

loc_8E1FA:
                bsr.w   PushBothPlayersWithCluckoidBreath
                bsr.w   EmitCluckoidBreathParticleOnVblankPhase

loc_8E202:
                lea     byte_8E418(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

loc_8E20C:
                move.b  #6,routine(a0)
                move.w  #$60,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_8E21A:
                subq.w  #1,$2E(a0)
                bmi.s   loc_8E222
                rts
; ---------------------------------------------------------------------------

loc_8E222:
                move.b  #2,routine(a0)
                move.b  #0,mapping_frame(a0)
                bclr    #7,$38(a0)

locret_8E234:
                rts
; ---------------------------------------------------------------------------

loc_8E236:
                lea     ObjDat3_8E3F6(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_8E250,(a0)
                bsr.w   CluckoidBreath_InitParticle
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8E250:
                tst.b   render_flags(a0)
                bpl.s   loc_8E2B8
                moveq   #0,d1
                move.w  x_vel(a0),d0
                add.w   $40(a0),d0
                cmpi.w  #-$80,d0
                blt.s   loc_8E274
                cmpi.w  #$80,d0
                bgt.s   loc_8E274
                bset    #0,d1
                bra.w   loc_8E278
; ---------------------------------------------------------------------------

loc_8E274:
                move.w  d0,x_vel(a0)

loc_8E278:
                move.w  y_vel(a0),d0
                addi.w  #8,d0
                bmi.s   loc_8E290
                cmpi.w  #$80,d0
                blt.s   loc_8E290
                bset    #1,d1
                bra.w   loc_8E294
; ---------------------------------------------------------------------------

loc_8E290:
                move.w  d0,y_vel(a0)

loc_8E294:
                cmpi.b  #3,d1
                bne.s   loc_8E2A6
                move.l  #loc_3DBE0,(a0)
                move.w  #2,$34(a0)

loc_8E2A6:
                jsr     (AnimateMhzPollenByHorizontalDirection).l
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8E2B8:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_8E2BE:
                lea     ObjDat3_8E3EA(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_8E2CE,(a0)

loc_8E2CE:
                jmp     (Child_Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

EmitCluckoidBreathParticleOnVblankPhase:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #7,d0
                bne.w   locret_8E234
                lea     ChildObjDat_8E40A(pc),a2
                jmp     (CreateChild6_Simple).l
; End of function EmitCluckoidBreathParticleOnVblankPhase

; =============== S U B R O U T I N E =======================================

; Use parent subtype and both halves of the random result. A suppressed table entry deletes the particle
CluckoidBreath_InitParticle:
                jsr     (Random_Number).l
                movea.w parent3(a0),a1
                move.w  d0,d1
                moveq   #0,d2
                move.b  subtype(a1),d2
                lsl.w   #5,d2
                lea     word_8E438(pc),a2
                adda.w  d2,a2
                andi.w  #$1C,d1
                adda.w  d1,a2
                move.w  (a2)+,d2
                move.w  (a2)+,d3
                beq.s   loc_8E35C
                andi.w  #6,d0
                move.w  word_8E364(pc,d0.w),d0
                move.w  #-$20,d4
                btst    #0,render_flags(a1)
                bne.s   loc_8E330
                bset    #0,render_flags(a0)
                neg.w   d0
                neg.w   d2
                neg.w   d4

loc_8E330:
                move.w  d0,x_vel(a0)
                add.w   d2,x_pos(a0)
                add.w   d3,y_pos(a0)
                move.w  d4,$40(a0)
                swap    d0
                moveq   #0,d2
                tst.w   d0
                bpl.s   loc_8E34A
                moveq   #4,d2

loc_8E34A:
                andi.w  #6,d0
                move.w  word_8E36C(pc,d0.w),y_vel(a0)
                move.l  off_8E374(pc,d2.w),mappings(a0)
                rts
; ---------------------------------------------------------------------------

loc_8E35C:
                addq.w  #4,sp
                jmp     (Delete_Current_Sprite).l
; End of function CluckoidBreath_InitParticle

; ---------------------------------------------------------------------------
word_8E364:
                dc.w    $600,  $700,  $800,  $900
word_8E36C:
                dc.w    -$180, -$200, -$280, -$300
off_8E374:
                dc.l    Map_MHZPollen
                dc.l    Map_MHZBigLeaves

; =============== S U B R O U T I N E =======================================

PushBothPlayersWithCluckoidBreath:
                lea     (Player_1).w,a1
                bsr.w   PushPlayerAwayInCluckoidBreath
                lea     (Player_2).w,a1
; End of function PushBothPlayersWithCluckoidBreath

; =============== S U B R O U T I N E =======================================

PushPlayerAwayInCluckoidBreath:
                cmpi.b  #8,anim(a1)
                beq.s   locret_8E3D6
                tst.b   spin_dash_flag(a1)
                bne.s   locret_8E3D6
                tst.b   object_control(a1)
                bne.s   locret_8E3D6
                jsr     (Find_OtherObject).l
                cmpi.w  #$100,d2
                bhs.s   locret_8E3D6
                cmpi.w  #$40,d3
                bhs.s   locret_8E3D6
                move.w  d0,d4
                btst    #0,render_flags(a0)
                bne.s   loc_8E3BA
                subq.w  #2,d4

loc_8E3BA:
                tst.w   d4
                beq.s   locret_8E3D6
                lsr.w   #4,d2
                andi.w  #$F,d2
                subi.w  #$F,d2
                neg.w   d2
                addq.w  #1,d2
                tst.w   d0
                bne.s   loc_8E3D2
                neg.w   d2

loc_8E3D2:
                add.w   d2,x_pos(a1)

locret_8E3D6:
                rts
; End of function PushPlayerAwayInCluckoidBreath

; ---------------------------------------------------------------------------
ObjSlot_Cluckoid:
                dc.w    2-1
                dc.w    make_art_tile(ArtTile_Cluckoid,1,1)
                dc.w    $11,     2
                dc.l    Map_Cluckoid
                dc.w    $280
                dc.b    $14, $10,   0, $1A
ObjDat3_8E3EA:
                dc.l    Map_CluckoidArrow
                dc.w    make_art_tile(ArtTile_Cluckoid+$22,1,1)
                dc.w    $280
                dc.b    $10,  $C,   0,   0
ObjDat3_8E3F6:
                dc.l    Map_MHZPollen
                dc.w    make_art_tile(ArtTile_MHZMisc+$1C,3,1)
                dc.w    0
                dc.b    8,   8,   0,   0
ChildObjDat_8E402:
                dc.w    1-1
                dc.l    loc_8E2BE
                dc.b    0, $1C
ChildObjDat_8E40A:
                dc.w    1-1
                dc.l    loc_8E236
DPLCPtr_Cluckoid:
                dc.l    ArtUnc_Cluckoid
                dc.l    DPLC_Cluckoid
byte_8E418:
                dc.b    0,   7
                dc.b    1,   7
                dc.b    2,   7
                dc.b    3,   7
                dc.b    4, $2F
                dc.b    5,   2
                dc.b    6,   2
                dc.b    7,   2
                dc.b    8,   2
                dc.b    9,   7
                dc.b    $A,   7
                dc.b    $B,   7
                dc.b    $C,   7
                dc.b    $D, $1F
                dc.b    0,  $F
                dc.b    $F4
                even
word_8E438:
                dc.w    $10,   $28
                dc.w    $20,   $28
                dc.w    $30,   $28
                dc.w    $40,   $28
                dc.w    $50,   $28
                dc.w    $60,   $28
                dc.w    $70,   $28
                dc.w    $80,   $28
                dc.w    $10,   $28
                dc.w    $18,   $28
                dc.w    $30,   $48
                dc.w    $40,   $48
                dc.w    $50,   $48
                dc.w    $60,   $48
                dc.w    $70,   $48
                dc.w    $80,   $48
                dc.w    $10,   $28
                dc.w    $14,   $28
                dc.w    $18,   $28
                dc.w    $1C,   $28
                dc.w    $20,   $28
                dc.w    0,     0
                dc.w    0,     0
                dc.w    0,     0
                dc.w    $10,   $28
                dc.w    $18,   $28
                dc.w    $20,   $28
                dc.w    $30,   $48
                dc.w    $40,   $48
                dc.w    $50,   $48
                dc.w    $60,   $48
                dc.w    $80,   $68
DPLC_Cluckoid:
                include "src/objects/shared/cluckoid/dplc/cluckoid.s"
Map_CluckoidArrow:
                include "src/objects/shared/cluckoid/mappings/arrow.s"
Map_Cluckoid:
                include "src/objects/shared/cluckoid/mappings/cluckoid.s"
