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
                dc.w    SKCluckoid_InitBodyAndArrow-Cluckoid_Index
                dc.w    SKCluckoid_CheckPlayerBreathRange-Cluckoid_Index
                dc.w    SKCluckoid_CheckBreathFrame-Cluckoid_Index
                dc.w    SKCluckoid_TickCooldown-Cluckoid_Index
; ---------------------------------------------------------------------------

SKCluckoid_InitBodyAndArrow:
                lea     ObjSlot_Cluckoid(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                lea     SKCluckoid_ArrowChild(pc),a2
                jmp     (CreateChild10_NormalAdjusted).l
; ---------------------------------------------------------------------------

SKCluckoid_CheckPlayerBreathRange:
                jsr     (Find_SonicTails).l
                cmpi.w  #$80,d2
                bhs.s   SKCluckoid_BreathCheckReturn
                cmpi.w  #$40,d3
                blo.s   SKCluckoid_BeginBreath

SKCluckoid_BreathCheckReturn:
                rts
; ---------------------------------------------------------------------------

SKCluckoid_BeginBreath:
                move.b  #4,routine(a0)
                move.l  #SKCluckoid_BeginCooldown,$34(a0)
                rts
; ---------------------------------------------------------------------------

SKCluckoid_CheckBreathFrame:
                cmpi.b  #7,mapping_frame(a0)
                blo.s   SKCluckoid_AnimateBreath
                bset    #7,$38(a0)
                bne.s   SKCluckoid_PushPlayersAndEmit
                moveq   #signextendB(sfx_EnemyBreath),d0
                jsr     (Play_SFX).l

SKCluckoid_PushPlayersAndEmit:
                bsr.w   PushBothPlayersWithCluckoidBreath
                bsr.w   EmitCluckoidBreathParticleOnVblankPhase

SKCluckoid_AnimateBreath:
                lea     SKCluckoid_BreathAnimation(pc),a1
                jmp     (Animate_RawNoSSTMultiDelay).l
; ---------------------------------------------------------------------------

SKCluckoid_BeginCooldown:
                move.b  #6,routine(a0)
                move.w  #$60,$2E(a0)
                rts
; ---------------------------------------------------------------------------

SKCluckoid_TickCooldown:
                subq.w  #1,$2E(a0)
                bmi.s   SKCluckoid_ResetBreathState
                rts
; ---------------------------------------------------------------------------

SKCluckoid_ResetBreathState:
                move.b  #2,routine(a0)
                move.b  #0,mapping_frame(a0)
                bclr    #7,$38(a0)

SKCluckoid_BreathUpdateReturn:
                rts
; ---------------------------------------------------------------------------

SKCluckoidFx_InitParticle:
                lea     SKCluckoidFx_ParticleAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKCluckoidFx_CheckVisibleAndCalcXSpeed,(a0)
                bsr.w   CluckoidBreath_InitParticle
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKCluckoidFx_CheckVisibleAndCalcXSpeed:
                tst.b   render_flags(a0)
                bpl.s   SKCluckoidFx_DeleteInvisibleParticle
                moveq   #0,d1
                move.w  x_vel(a0),d0
                add.w   $40(a0),d0
                cmpi.w  #-$80,d0
                blt.s   SKCluckoidFx_StoreNewXSpeed
                cmpi.w  #$80,d0
                bgt.s   SKCluckoidFx_StoreNewXSpeed
                bset    #0,d1
                bra.w   SKCluckoidFx_CheckYSpeed
; ---------------------------------------------------------------------------

SKCluckoidFx_StoreNewXSpeed:
                move.w  d0,x_vel(a0)

SKCluckoidFx_CheckYSpeed:
                move.w  y_vel(a0),d0
                addi.w  #8,d0
                bmi.s   SKCluckoidFx_StoreNewYSpeed
                cmpi.w  #$80,d0
                blt.s   SKCluckoidFx_StoreNewYSpeed
                bset    #1,d1
                bra.w   SKCluckoidFx_TryBeginPollenOscillation
; ---------------------------------------------------------------------------

SKCluckoidFx_StoreNewYSpeed:
                move.w  d0,y_vel(a0)

; Switch to the shared pollen update once both velocity gates are set
SKCluckoidFx_TryBeginPollenOscillation:
                cmpi.b  #3,d1
                bne.s   SKCluckoidFx_AnimateMoveAndDraw
                move.l  #SKMHZPollen_MoveWithSineDrift,(a0)
                move.w  #2,$34(a0)

SKCluckoidFx_AnimateMoveAndDraw:
                jsr     (AnimateMhzPollenByHorizontalDirection).l
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKCluckoidFx_DeleteInvisibleParticle:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKCluckoidArrow_InitFixedArrow:
                lea     SKCluckoidArrow_ArrowAttributes(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #SKCluckoidArrow_DrawFixedArrow,(a0)

SKCluckoidArrow_DrawFixedArrow:
                jmp     (Child_Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

EmitCluckoidBreathParticleOnVblankPhase:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #7,d0
                bne.w   SKCluckoid_BreathUpdateReturn
                lea     SKCluckoid_BreathParticleChild(pc),a2
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
                lea     SKCluckoidFx_SpawnOffsetsBySubtype(pc),a2
                adda.w  d2,a2
                andi.w  #$1C,d1
                adda.w  d1,a2
                move.w  (a2)+,d2
                move.w  (a2)+,d3
                beq.s   SKCluckoidFx_AbortParticleInit
                andi.w  #6,d0
                move.w  SKCluckoidFx_LaunchXSpeeds(pc,d0.w),d0
                move.w  #-$20,d4
                btst    #0,render_flags(a1)
                bne.s   SKCluckoidFx_SetLaunchMotion
                bset    #0,render_flags(a0)
                neg.w   d0
                neg.w   d2
                neg.w   d4

SKCluckoidFx_SetLaunchMotion:
                move.w  d0,x_vel(a0)
                add.w   d2,x_pos(a0)
                add.w   d3,y_pos(a0)
                move.w  d4,$40(a0)
                swap    d0
                moveq   #0,d2
                tst.w   d0
                bpl.s   SKCluckoidFx_SelectYSpeedAndMapping
                moveq   #4,d2

SKCluckoidFx_SelectYSpeedAndMapping:
                andi.w  #6,d0
                move.w  SKCluckoidFx_LaunchYSpeeds(pc,d0.w),y_vel(a0)
                move.l  SKCluckoidFx_PollenAndLeafMappings(pc,d2.w),mappings(a0)
                rts
; ---------------------------------------------------------------------------

; Discard the initializer's return address to skip its draw call
SKCluckoidFx_AbortParticleInit:
                addq.w  #4,sp
                jmp     (Delete_Current_Sprite).l
; End of function CluckoidBreath_InitParticle

; ---------------------------------------------------------------------------
SKCluckoidFx_LaunchXSpeeds:
                dc.w    $600,  $700,  $800,  $900
SKCluckoidFx_LaunchYSpeeds:
                dc.w    -$180, -$200, -$280, -$300
SKCluckoidFx_PollenAndLeafMappings:
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
                beq.s   SKCluckoidBreath_PushReturn
                tst.b   spin_dash_flag(a1)
                bne.s   SKCluckoidBreath_PushReturn
                tst.b   object_control(a1)
                bne.s   SKCluckoidBreath_PushReturn
                jsr     (Find_OtherObject).l
                cmpi.w  #$100,d2
                bhs.s   SKCluckoidBreath_PushReturn
                cmpi.w  #$40,d3
                bhs.s   SKCluckoidBreath_PushReturn
                move.w  d0,d4
                btst    #0,render_flags(a0)
                bne.s   SKCluckoidBreath_CheckFacingAndCalcPush
                subq.w  #2,d4

SKCluckoidBreath_CheckFacingAndCalcPush:
                tst.w   d4
                beq.s   SKCluckoidBreath_PushReturn
                lsr.w   #4,d2
                andi.w  #$F,d2
                subi.w  #$F,d2
                neg.w   d2
                addq.w  #1,d2
                tst.w   d0
                bne.s   SKCluckoidBreath_ApplyPushX
                neg.w   d2

SKCluckoidBreath_ApplyPushX:
                add.w   d2,x_pos(a1)

SKCluckoidBreath_PushReturn:
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
SKCluckoidArrow_ArrowAttributes:
                dc.l    Map_CluckoidArrow
                dc.w    make_art_tile(ArtTile_Cluckoid+$22,1,1)
                dc.w    $280
                dc.b    $10,  $C,   0,   0
SKCluckoidFx_ParticleAttributes:
                dc.l    Map_MHZPollen
                dc.w    make_art_tile(ArtTile_MHZMisc+$1C,3,1)
                dc.w    0
                dc.b    8,   8,   0,   0
SKCluckoid_ArrowChild:
                dc.w    1-1
                dc.l    SKCluckoidArrow_InitFixedArrow
                dc.b    0, $1C
SKCluckoid_BreathParticleChild:
                dc.w    1-1
                dc.l    SKCluckoidFx_InitParticle
DPLCPtr_Cluckoid:
                dc.l    ArtUnc_Cluckoid
                dc.l    DPLC_Cluckoid
SKCluckoid_BreathAnimation:
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
SKCluckoidFx_SpawnOffsetsBySubtype:
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
