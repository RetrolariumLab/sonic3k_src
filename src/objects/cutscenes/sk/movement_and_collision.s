; Owner: objects/cutscenes/sk
; Responsibility: Shared Knuckles cutscene motion, collision, animation and scene-relative adjustment helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

CutsceneSpawnKnucklesMusicFadeTransition:
                jsr     (AllocateObject).l
                bne.s   SKScene_KnucklesMusicFadeReturn
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Knuckles,subtype(a1)

SKScene_KnucklesMusicFadeReturn:
                rts
; End of function CutsceneSpawnKnucklesMusicFadeTransition

; =============== S U B R O U T I N E =======================================

CutsceneKnucklesSolidThinWrapper:
                move.w  #$1B,d1
                move.w  #4,d2
                move.w  #5,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function CutsceneKnucklesSolidThinWrapper

; =============== S U B R O U T I N E =======================================

; Randomize the upward hop and choose X direction from the movement bounds and escape flag
OpeningAnimal_ChooseBounceVel:
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                addi.w  #$100,d0
                neg.w   d0
                move.w  d0,y_vel(a0)
                swap    d0
                move.w  #$100,d1
                btst    #2,(_unkFAB8).w
                bne.s   SKScene_AnimalBounceLeft
                bclr    #0,render_flags(a0)
                move.w  x_pos(a0),d2
                cmp.w   $3A(a0),d2
                blo.s   SKScene_StoreAnimalBounceVelocity
                cmp.w   $3C(a0),d2
                bhi.s   SKScene_AnimalBounceLeft
                tst.w   d0
                bpl.s   SKScene_StoreAnimalBounceVelocity

SKScene_AnimalBounceLeft:
                neg.w   d1
                bset    #0,render_flags(a0)

SKScene_StoreAnimalBounceVelocity:
                move.w  d1,x_vel(a0)
                rts
; End of function OpeningAnimal_ChooseBounceVel

; =============== S U B R O U T I N E =======================================

CutsceneKnucklesSolidTallWrapper:
                move.w  #$1B,d1
                move.w  #$20,d2
                move.w  #$20,d3
                move.w  x_pos(a0),d4
                jmp     (SolidObjectFull).l
; End of function CutsceneKnucklesSolidTallWrapper

; =============== S U B R O U T I N E =======================================

MHZBlower_ApplyPoseToBothPlayers:
                lea     (Player_1).w,a1
                bsr.w   MHZBlower_SetPlayerFlipPose
                lea     (Player_2).w,a1
                tst.l   (a1)
                beq.s   SKScene_BlowerPoseReturn
; End of function MHZBlower_ApplyPoseToBothPlayers

; =============== S U B R O U T I N E =======================================

; Hold the waiting pose until blower frame $C, then use the forced inverted flicker and load its art
MHZBlower_SetPlayerFlipPose:
                move.b  #5,anim(a1)
                cmpi.b  #$C,anim_frame(a0)
                blo.s   SKScene_BlowerPoseReturn
                move.b  #$83,object_control(a1)
                move.b  #0,anim(a1)
                bset    #1,render_flags(a1)
                moveq   #0,d0
                btst    #1,(V_int_run_count+3).w
                beq.s   SKScene_BlowerSelectPlayerPose
                moveq   #2,d0

SKScene_BlowerSelectPlayerPose:
                add.b   character_id(a1),d0
                move.b  SKMhzBlower_ForcedPlayerFramePairs(pc,d0.w),mapping_frame(a1)
                jsr     (Player_Load_PLC2).l

SKScene_BlowerPoseReturn:
                rts
; End of function MHZBlower_SetPlayerFlipPose

; ---------------------------------------------------------------------------
SKMhzBlower_ForcedPlayerFramePairs:
                dc.b    $B4, $A7, $B5, $A8
                even

; =============== S U B R O U T I N E =======================================

MHZBlowerEmitLeafOnReloadedTimer:
                subq.w  #1,$2E(a0)
                bpl.s   SKScene_BlowerLeafSpawnReturn
                move.w  $3E(a0),$2E(a0)
                jsr     (AllocateObject).l
                bne.s   SKScene_BlowerLeafSpawnReturn
                move.l  #MHZ2Scene_InitLeafWithBiasedX,(a1)
                move.w  a0,parent3(a1)

SKScene_BlowerLeafSpawnReturn:
                rts
; End of function MHZBlowerEmitLeafOnReloadedTimer

; =============== S U B R O U T I N E =======================================

LRZRollingSceneCycleOwnerRenderFlips:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKScene_LRZFlipTimerReturn
                move.b  #4,anim_frame_timer(a0)
                move.b  anim_frame(a0),d0
                addq.b  #1,d0
                move.b  d0,anim_frame(a0)
                andi.b  #3,d0
                move.b  render_flags(a0),d1
                andi.b  #$FC,d1
                or.b    d0,d1
                move.b  d1,render_flags(a0)

SKScene_LRZFlipTimerReturn:
                rts
; End of function LRZRollingSceneCycleOwnerRenderFlips

; =============== S U B R O U T I N E =======================================

LRZRollingScene_OrbitBothPlayers:
                lea     (Player_1).w,a1
                moveq   #0,d2
                moveq   #$3C,d3
                moveq   #signextendB($8D),d4
                bsr.w   LRZRollingScene_TryCapturePlayer
                lea     (Player_2).w,a1
                moveq   #1,d2
                moveq   #$3D,d3
                moveq   #signextendB($8A),d4
                bsr.w   LRZRollingScene_TryCapturePlayer
                lea     (Player_1).w,a1
                moveq   #0,d2
                moveq   #$3C,d3
                bsr.w   LRZRollingSceneOrbitOneCapturedPlayer
                lea     (Player_2).w,a1
                moveq   #1,d2
                moveq   #$3D,d3
; End of function LRZRollingScene_OrbitBothPlayers

; =============== S U B R O U T I N E =======================================

LRZRollingSceneOrbitOneCapturedPlayer:
                btst    d2,$38(a0)
                beq.w   SKScene_LRZCaptureGateReturn
                subq.b  #1,anim_frame_timer(a1)
                bpl.s   SKScene_LRZOrbitCapturedPlayer
                move.b  #8,anim_frame_timer(a1)
                move.b  anim_frame(a1),d0
                addq.b  #1,anim_frame(a1)
                andi.b  #3,d0
                move.b  render_flags(a1),d1
                andi.b  #$FC,d1
                or.b    d0,d1
                move.b  d1,render_flags(a1)

SKScene_LRZOrbitCapturedPlayer:
                move.b  (a0,d3.w),d0
                addq.b  #2,(a0,d3.w)
                jsr     (GetSineCosine).l
                asr.w   #3,d0
                asr.w   #3,d1
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                add.w   d0,d2
                add.w   d1,d3
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                rts
; End of function LRZRollingSceneOrbitOneCapturedPlayer

; =============== S U B R O U T I N E =======================================

; Capture once within the signed 64-by-64 box, stop the timer and scroll lock, and seed the orbit angle
LRZRollingScene_TryCapturePlayer:
                btst    d2,$38(a0)
                bne.s   SKScene_LRZCaptureGateReturn
                lea     SKLrzRollingScene_PlayerCaptureRectangle(pc),a2
                jsr     (Check_InMyRange).l
                beq.s   SKScene_LRZCaptureGateReturn
                bset    d2,$38(a0)
                move.w  d3,-(sp)
                clr.b   (Scroll_lock).w
                clr.b   (Update_HUD_timer).w
                move.b  #$83,object_control(a1)
                move.b  d4,mapping_frame(a1)
                clr.b   anim(a1)
                clr.b   anim_frame_timer(a1)
                clr.b   anim_frame(a1)
                move.l  a1,-(sp)
                jsr     (Player_Load_PLC2).l
                movea.l (sp)+,a1
                movea.l a1,a2
                movea.l a0,a1
                jsr     (GetApproximateObjectBearing).l
                move.w  (sp)+,d3
                move.b  d0,(a0,d3.w)

SKScene_LRZCaptureGateReturn:
                rts
; End of function LRZRollingScene_TryCapturePlayer

; ---------------------------------------------------------------------------
SKLrzRollingScene_PlayerCaptureRectangle:
                dc.w    -$20,   $40,  -$20,   $40

; =============== S U B R O U T I N E =======================================

SSZKnucklesReactToCrouchingP1OnRight:
                btst    #3,$38(a0)
                bne.w   SKAIZScene_SharedSceneReturn
                lea     (Player_1).w,a1
                jsr     (Find_OtherObject).l
                cmpi.w  #$20,d3
                bhs.w   SKAIZScene_SharedSceneReturn
                subi.w  #$30,d2
                cmpi.w  #$20,d2
                bhs.w   SKAIZScene_SharedSceneReturn
                tst.w   d0
                beq.w   SKAIZScene_SharedSceneReturn
                btst    #0,render_flags(a1)
                beq.w   SKAIZScene_SharedSceneReturn
                cmpi.b  #8,anim(a1)
                bne.w   SKAIZScene_SharedSceneReturn
                lea     SKSceneAnim_SSZCrouchingPlayerReaction(pc),a1
                jmp     (Set_Raw_Animation).l
; End of function SSZKnucklesReactToCrouchingP1OnRight

; =============== S U B R O U T I N E =======================================

MoveSprite_SSZBGAdjust:
                move.w  (_unkFA84).w,d0
                add.w   d0,x_pos(a0)
                move.w  $40(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                move.l  y_vel(a0),d1
                add.l   d0,d1
                move.l  d1,y_vel(a0)
                swap    d1
                move.w  (_unkEE9C).w,d0
                asr.w   #2,d0
                sub.w   d0,d1
                move.w  d1,y_pos(a0)
                rts
; End of function MoveSprite_SSZBGAdjust
