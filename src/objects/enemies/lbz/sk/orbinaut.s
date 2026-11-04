; Owner: objects/enemies/lbz/sk
; Responsibility: Orbinaut orbiting enemy, orb children and private construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Orbinaut:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Orbinaut_Index(pc,d0.w),d1
                jsr     Orbinaut_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Orbinaut_Index:
                dc.w    SKOrbinaut_InitAndSpawnOrbs-Orbinaut_Index
                dc.w    SKOrbinaut_FaceP1AndPickSpeed-Orbinaut_Index
; ---------------------------------------------------------------------------

SKOrbinaut_InitAndSpawnOrbs:
                lea     ObjDat_Orbinaut(pc),a1
                jsr     (SetUp_ObjAttributes).l
                lea     SKOrbinaut_OrbChildren(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKOrbinaut_FaceP1AndPickSpeed:
                lea     (Player_1).w,a1
                jsr     Find_OtherObject(pc)
                bclr    #0,render_flags(a0)
                move.w  #-$80,d1
                tst.w   d0
                beq.s   SKOrbinaut_MoveWithGroundedP1
                bset    #0,render_flags(a0)
                neg.w   d1

SKOrbinaut_MoveWithGroundedP1:
                move.w  d1,x_vel(a0)
                bsr.w   TestPrimaryPlayerGroundMotionForOrbinaut
                beq.w   SKOrbinaut_GroundMotionReturn
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

SKOrbinaut_InitOrbAndPhase:
                lea     OrbinautSK_Orb_PartialAttributePrefix(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #SKOrbinaut_TryAdvanceOrbPhase,(a0)
                move.b  subtype(a0),d0
                lsl.b   #5,d0
                move.b  d0,$3C(a0)
                jmp     Child_DrawTouch_Sprite(pc)
; ---------------------------------------------------------------------------

SKOrbinaut_TryAdvanceOrbPhase:
                movea.w parent3(a0),a1
                bsr.w   TestPrimaryPlayerGroundMotionForOrbinaut
                beq.s   SKOrbinaut_PlaceAndDrawOrb
                moveq   #8,d0
                btst    #0,render_flags(a1)
                beq.s   OrbinautSK_Orb_AddSignedEightPhaseStep
                moveq   #-8,d0

OrbinautSK_Orb_AddSignedEightPhaseStep:
                add.b   d0,$3C(a0)

SKOrbinaut_PlaceAndDrawOrb:
                moveq   #4,d2
                jsr     MoveSprite_CircularSimple(pc)
                jmp     Child_DrawTouch_Sprite(pc)

; =============== S U B R O U T I N E =======================================

TestPrimaryPlayerGroundMotionForOrbinaut:
                lea     (Player_1).w,a2
                btst    #Status_InAir,status(a2)
                bne.s   SKOrbinaut_NoGroundMotion
                tst.w   x_vel(a2)
                bne.s   SKOrbinaut_GroundMotionReturn
                tst.w   y_vel(a2)
                bne.s   SKOrbinaut_GroundMotionReturn

SKOrbinaut_NoGroundMotion:
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

SKOrbinaut_GroundMotionReturn:
                rts
; End of function TestPrimaryPlayerGroundMotionForOrbinaut

; ---------------------------------------------------------------------------
ObjDat_Orbinaut:
                dc.l    Map_Orbinaut
                dc.w    make_art_tile(ArtTile_Orbinaut,1,0)
                dc.w    $280
                dc.b    8,   8,   0,  $B
OrbinautSK_Orb_PartialAttributePrefix:
                dc.w    $280
                dc.b    8,   8,   1, $8B
SKOrbinaut_OrbChildren:
                dc.w    4-1
                dc.l    SKOrbinaut_InitOrbAndPhase
                dc.b    0, $10
                dc.l    SKOrbinaut_InitOrbAndPhase
                dc.b    $10,   0
                dc.l    SKOrbinaut_InitOrbAndPhase
                dc.b    0,-$10
                dc.l    SKOrbinaut_InitOrbAndPhase
                dc.b    -$10,   0
                dc.b    0,   5
                dc.b    1,   5
                dc.b    2,   5
                dc.b    3,   5
                dc.b    $FC
                even
