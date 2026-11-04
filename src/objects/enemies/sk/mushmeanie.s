; Owner: objects/enemies/sk
; Responsibility: Mushmeanie enemy movement, interaction and private object resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Mushmeanie:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Mushmeanie_Index(pc,d0.w),d1
                jsr     Mushmeanie_Index(pc,d1.w)
                bsr.w   HandleMushmeanieCapHitAndDefeat
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
Mushmeanie_Index:
                dc.w    SKMushmeanie_InitBodyAndCap-Mushmeanie_Index
                dc.w    SKMushmeanie_CheckNearestPlayer-Mushmeanie_Index
                dc.w    SKMushmeanie_AnimateHopPrep-Mushmeanie_Index
                dc.w    SKMushmeanie_HopAndCheckWall-Mushmeanie_Index
                dc.w    SKMushmeanie_AnimateLanding-Mushmeanie_Index
; ---------------------------------------------------------------------------

SKMushmeanie_InitBodyAndCap:
                lea     ObjDat_Mushmeanie(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.b  #2,$39(a0)
                move.b  #$12,y_radius(a0)
                lea     SKMushmeanie_CapChild(pc),a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

SKMushmeanie_CheckNearestPlayer:
                jsr     (Find_SonicTails).l
                cmpi.w  #$80,d2
                blo.s   SKMushmeanie_BeginHopPrep
                rts
; ---------------------------------------------------------------------------

SKMushmeanie_BeginHopPrep:
                move.b  #4,routine(a0)
                move.l  #SKMushmeanie_HopPrepAnimation,$30(a0)
                move.l  #SKMushmeanie_HopTowardP1,$34(a0)

SKMushmeanie_HopUpdateReturn:
                rts
; ---------------------------------------------------------------------------

SKMushmeanie_AnimateHopPrep:
                jsr     (Animate_RawMultiDelay).l
                tst.w   d2
                bne.s   SKMushmeanie_RaiseOnPrepEvent
                rts
; ---------------------------------------------------------------------------

SKMushmeanie_RaiseOnPrepEvent:
                subq.w  #3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

SKMushmeanie_HopTowardP1:
                move.b  #6,routine(a0)
                move.w  #-$300,y_vel(a0)
                move.l  #SKMushmeanie_BeginLanding,$34(a0)
                move.w  #-$100,d4
                jmp     (Set_VelocityXTrackSonic).l
; ---------------------------------------------------------------------------

SKMushmeanie_HopAndCheckWall:
                jsr     (MoveSprite_LightGravity).l
                tst.w   x_vel(a0)
                bmi.s   SKMushmeanie_ProbeLeftWall
                moveq   #8,d3
                jsr     (ObjCheckRightWallDist).l
                bra.w   SKMushmeanie_ResolveWallAndTurn
; ---------------------------------------------------------------------------

SKMushmeanie_ProbeLeftWall:
                moveq   #-8,d3
                jsr     (ObjCheckLeftWallDist).l

SKMushmeanie_ResolveWallAndTurn:
                tst.w   d1
                bpl.s   SKMushmeanie_TryLandWhileDescending
                add.w   d1,x_pos(a0)
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

SKMushmeanie_TryLandWhileDescending:
                tst.w   y_vel(a0)
                bmi.w   SKMushmeanie_HopUpdateReturn
                jmp     (ObjHitFloor_DoRoutine).l
; ---------------------------------------------------------------------------

SKMushmeanie_BeginLanding:
                move.b  #8,routine(a0)
                move.l  #SKMushmeanie_LandingAnimation,$30(a0)
                move.l  #SKMushmeanie_HopTowardP1,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKMushmeanie_AnimateLanding:
                jsr     (Animate_RawMultiDelay).l
                tst.w   d2
                bne.s   SKMushmeanie_ApplyLandingYStep
                rts
; ---------------------------------------------------------------------------

; Index by the current animation cursor, including cursor zero after a callback
SKMushmeanie_ApplyLandingYStep:
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                move.w  SKMushmeanie_LandingYSteps(pc,d0.w),d0
                add.w   d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
SKMushmeanie_LandingYSteps:
                dc.w    -3,     3,     3,    -3,    -3,    -3
; ---------------------------------------------------------------------------

SKMushmeanieCap_InitCap:
                lea     SKMushmeanieCap_CapAttributes(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #SKMushmeanieCap_FollowBodyOrDetach,(a0)

SKMushmeanieCap_FollowBodyOrDetach:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                btst    #6,status(a1)
                bne.s   SKMushmeanieCap_ChooseKickoffVelocity
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

SKMushmeanieCap_ChooseKickoffVelocity:
                move.l  #SKMushmeanieCap_FallAndCull,(a0)
                movea.w $44(a1),a2
                move.w  #$200,d0
                tst.w   x_vel(a2)
                bmi.s   SKMushmeanieCap_LaunchCap
                neg.w   d0

SKMushmeanieCap_LaunchCap:
                move.w  d0,x_vel(a0)
                move.w  #-$200,y_vel(a0)

SKMushmeanieCap_FallAndCull:
                jsr     (MoveSprite_LightGravity).l
                jmp     (Sprite_CheckDeleteXY).l

; =============== S U B R O U T I N E =======================================

HandleMushmeanieCapHitAndDefeat:
                tst.b   $20(a0)
                beq.s   SKMushmeanie_CheckAttackOrHurtPlayer
                subq.b  #1,$20(a0)
                bne.s   SKMushmeanie_HitReturn
                move.b  #$D7,collision_flags(a0)

SKMushmeanie_CheckAttackOrHurtPlayer:
                jsr     (Check_PlayerCollision).l
                beq.s   SKMushmeanie_HitReturn
                jsr     (Check_PlayerAttack).l
                bne.s   SKMushmeanie_TakeHitAndTryDetachCap
                tst.b   invulnerability_timer(a1)
                bne.s   SKMushmeanie_HitReturn
                jmp     (HurtCharacter_Directly).l
; ---------------------------------------------------------------------------

SKMushmeanie_TakeHitAndTryDetachCap:
                subq.b  #1,$39(a0)
                beq.s   SKMushmeanie_DefeatAndScore
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)
                move.b  #$20,$20(a0)
                bset    #6,status(a0)
                neg.w   x_vel(a1)
                neg.w   y_vel(a1)
                neg.w   ground_vel(a1)

SKMushmeanie_HitReturn:
                rts
; ---------------------------------------------------------------------------

SKMushmeanie_DefeatAndScore:
                jmp     (EnemyDefeated).l
; End of function HandleMushmeanieCapHitAndDefeat

; ---------------------------------------------------------------------------
ObjDat_Mushmeanie:
                dc.l    Map_Mushmeanie
                dc.w    make_art_tile(ArtTile_Mushmeanie,1,0)
                dc.w    $280
                dc.b    8,   8,   1, $D7
SKMushmeanieCap_CapAttributes:
                dc.w    make_art_tile(ArtTile_Mushmeanie,2,0)
                dc.w    $200
                dc.b    $C,   8,   0,   0
SKMushmeanie_CapChild:
                dc.w    1-1
                dc.l    SKMushmeanieCap_InitCap
                dc.b    0,   0
SKMushmeanie_HopPrepAnimation:
                dc.b    1,   2
                dc.b    2,   2
                dc.b    3,   0
                dc.b    $F4
SKMushmeanie_LandingAnimation:
                dc.b    3,   2
                dc.b    2,   2
                dc.b    1,   2
                dc.b    2,   2
                dc.b    3,   0
                dc.b    $F4
                even
Map_Mushmeanie:
                include "src/objects/shared/mushmeanie/mappings/mushmeanie.s"
