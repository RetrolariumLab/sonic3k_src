; Owner: objects/zones/hcz/sk
; Responsibility: Hydrocity and competition fans, airflow, large-fan states and shared mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HCZCGZFan:
                tst.w   (Competition_mode).w
                bne.w   SKFans_InitCompFan
                movea.l a0,a1
                tst.b   subtype(a0)
                bpl.s   SKFans_InitFanAndField
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKFans_FanSetupReturn
                move.l  #SKFans_PickBlockMotion,(a0)
                move.w  x_pos(a0),x_pos(a1)
                move.w  x_pos(a0),$40(a0)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$1C,y_pos(a0)
                move.l  #Map_HCZWaterRushBlock,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZMisc+$A,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.w  a1,$3C(a0)
                move.b  subtype(a0),d0
                andi.w  #$30,d0
                add.w   d0,d0
                move.w  d0,$3A(a0)
                move.b  subtype(a0),subtype(a1)
                bclr    #5,subtype(a1)
                bset    #4,subtype(a1)

SKFans_InitFanAndField:
                move.l  #Map_HCZFan,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZMisc+$41,1,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.w  #$200,priority(a1)
                move.b  #$10,width_pixels(a1)
                move.b  #$C,height_pixels(a1)
                move.w  x_pos(a1),$40(a1)
                move.b  subtype(a1),d0
                andi.w  #$F,d0
                addq.w  #8,d0
                lsl.w   #4,d0
                move.w  d0,$36(a1)
                addi.w  #$30,d0
                move.w  d0,$38(a1)
                move.l  #SKFans_CheckFanTrigger,(a1)

SKFans_FanSetupReturn:
                rts
; ---------------------------------------------------------------------------

SKFans_CheckFanTrigger:
                move.b  subtype(a0),d0
                btst    #5,d0
                beq.s   SKFans_PickFanCycle
                tst.b   (Level_trigger_array).w
                beq.w   HCZFansSK_CullFanByOriginalSavedXAndDraw
                bclr    #5,subtype(a0)
                bset    #4,subtype(a0)

SKFans_PickFanCycle:
                tst.b   $42(a0)
                bne.s   SKFans_StepSpinDown
                btst    #4,subtype(a0)
                bne.s   SKFans_RunActiveFan
                subq.w  #1,$30(a0)
                bpl.s   SKFans_CheckActiveCyclePhase
                move.w  #0,$34(a0)
                move.w  #2*60,$30(a0)
                bchg    #0,$32(a0)
                beq.s   SKFans_CheckActiveCyclePhase
                move.w  #3*60,$30(a0)

SKFans_CheckActiveCyclePhase:
                tst.b   $32(a0)
                beq.w   SKFans_RunActiveFan

SKFans_StepSpinDown:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   HCZFansSK_CullFanByOriginalSavedXAndDraw
                cmpi.w  #$400,$34(a0)
                bhs.w   HCZFansSK_CullFanByOriginalSavedXAndDraw
                addi.w  #$2A,$34(a0)
                move.b  $34(a0),anim_frame_timer(a0)
                bra.s   HCZFansSK_AdvanceSmallFanFrameModuloFive
; ---------------------------------------------------------------------------

SKFans_RunActiveFan:
                lea     (Player_1).w,a1
                bsr.w   SKFans_TryApplyPlayerField
                lea     (Player_2).w,a1
                bsr.w   SKFans_TryApplyPlayerField
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKFans_TrySmallFanSound
                move.b  #0,anim_frame_timer(a0)

HCZFansSK_AdvanceSmallFanFrameModuloFive:
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #5,mapping_frame(a0)
                blo.s   SKFans_TrySmallFanSound
                move.b  #0,mapping_frame(a0)

SKFans_TrySmallFanSound:
                tst.b   render_flags(a0)
                bpl.s   SKFans_TryFanBubble
                move.b  (Level_frame_counter+1).w,d0
                addq.b  #1,d0
                andi.b  #$F,d0
                bne.s   SKFans_TryFanBubble
                moveq   #signextendB(sfx_FanSmall),d0
                jsr     (Play_SFX).l

SKFans_TryFanBubble:
                btst    #6,subtype(a0)
                beq.s   HCZFansSK_CullFanByOriginalSavedXAndDraw
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #3,d0
                bne.s   HCZFansSK_CullFanByOriginalSavedXAndDraw
                jsr     (AllocateObject).l
                bne.s   HCZFansSK_CullFanByOriginalSavedXAndDraw
                move.l  #SKFans_TryMoveBubble,(a1)
                move.l  #Map_Bubbler,mappings(a1)
                move.w  #make_art_tile(ArtTile_Bubbles,0,0),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.b  #4,width_pixels(a1)
; Bug: This is missing the height, and only really repeats what the previous line did
                move.b  #4,width_pixels(a1)
                move.w  #$300,priority(a1)
                move.w  x_pos(a0),x_pos(a1)
                jsr     (Random_Number).l
                andi.w  #$F,d0
                subq.w  #8,d0
                add.w   d0,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  #-$800,y_vel(a1)

HCZFansSK_CullFanByOriginalSavedXAndDraw:
                move.w  $40(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

SKFans_TryApplyPlayerField:
                cmpi.b  #4,routine(a1)
                bhs.w   SKFans_PlayerFieldReturn
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$18,d0
                cmpi.w  #$30,d0
                bhs.w   SKFans_PlayerFieldReturn
                moveq   #0,d1
                move.b  (Oscillating_table+$16).w,d1
                add.w   y_pos(a1),d1
                add.w   $36(a0),d1
                sub.w   y_pos(a0),d1
                bcs.s   SKFans_PlayerFieldReturn
                cmp.w   $38(a0),d1
                bhs.s   SKFans_PlayerFieldReturn
                tst.b   object_control(a1)
                bne.s   SKFans_SetControlledGroundSpeed
                sub.w   $36(a0),d1
                bcs.s   SKFans_LiftPlayerAndClearJump
                not.w   d1
                add.w   d1,d1

SKFans_LiftPlayerAndClearJump:
                add.w   $36(a0),d1
                neg.w   d1
                asr.w   #6,d1
                add.w   d1,y_pos(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.w  #0,y_vel(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                btst    #6,subtype(a0)
                bne.s   SKFans_SetWaterLiftPose
                move.w  #1,ground_vel(a1)
                tst.b   flip_angle(a1)
                bne.s   SKFans_PlayerFieldReturn
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #$7F,flips_remaining(a1)
                move.b  #8,flip_speed(a1)

SKFans_PlayerFieldReturn:
                rts
; ---------------------------------------------------------------------------

SKFans_SetControlledGroundSpeed:
                move.w  #1,ground_vel(a1)
                rts
; ---------------------------------------------------------------------------

SKFans_SetWaterLiftPose:
                move.w  #1,ground_vel(a1)
                move.b  #$F,anim(a1)
                rts
; ---------------------------------------------------------------------------

SKFans_TryMoveBubble:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0
                bhs.s   SKFans_DeleteSurfacedBubble
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKFans_DeleteSurfacedBubble:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKFans_PickBlockMotion:
                movea.w $3C(a0),a1
                move.w  (Player_1+y_pos).w,d0
                sub.w   y_pos(a0),d0
                bcs.s   SKFans_TryClearSpinDown
                cmpi.w  #$20,d0
                blt.s   SKFans_ReflectBlockOffset
                tst.b   $42(a1)
                bne.s   SKFans_ExtendBlockOffset
                move.b  #1,$42(a1)
                move.w  #0,$34(a1)
                moveq   #signextendB(sfx_FanLatch),d0
                jsr     (Play_SFX).l

SKFans_ExtendBlockOffset:
                move.w  $3A(a0),d1
                cmp.w   $30(a0),d1
                beq.s   SKFans_ReflectBlockOffset
                addq.w  #8,$30(a0)
                bra.s   SKFans_ReflectBlockOffset
; ---------------------------------------------------------------------------

SKFans_TryClearSpinDown:
                cmpi.w  #-$30,d0
                bge.s   SKFans_ReflectBlockOffset
                tst.b   $42(a1)
                beq.s   SKFans_RetractBlockOffset
                move.b  #0,$42(a1)
                move.b  #0,anim_frame_timer(a1)
                moveq   #signextendB(sfx_FanLatch),d0
                jsr     (Play_SFX).l

SKFans_RetractBlockOffset:
                tst.w   $30(a0)
                beq.s   SKFans_ReflectBlockOffset
                subq.w  #8,$30(a0)

SKFans_ReflectBlockOffset:
                move.w  $30(a0),d0
                btst    #0,status(a0)
                beq.s   SKFans_MoveBlockAndFan
                neg.w   d0

SKFans_MoveBlockAndFan:
                add.w   $40(a0),d0
                move.w  d0,x_pos(a0)
                move.w  d0,x_pos(a1)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.w  $40(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

Obj_HCZLargeFan:
                move.w  (Player_1+x_pos).w,d0
                subi.w  #$20,d0
                cmp.w   x_pos(a0),d0
                blo.s   SKFans_LockAndCullInactiveLargeFan
                move.w  (Player_1+y_pos).w,d0
                subi.w  #$20,d0
                sub.w   y_pos(a0),d0
                cmpi.w  #$40,d0
                blo.s   SKFans_QueueLargeFanArt

SKFans_LockAndCullInactiveLargeFan:
                move.b  #3,(_unkF7C7).w
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKFans_QueueLargeFanArt:
                lea     (ArtKosM_HCZLargeFan).l,a1
                move.w  #tiles_to_bytes(ArtTile_HCZLargeFan),d2
                jsr     (Queue_Kos_Module).l
                move.l  #SKFans_WaitForLargeFanArt,(a0)

SKFans_WaitForLargeFanArt:
                tst.b   (Kos_modules_left).w
                beq.s   SKFans_InitAndLowerLargeFan
                rts
; ---------------------------------------------------------------------------

SKFans_InitAndLowerLargeFan:
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.l  #Map_HCZLargeFan,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZLargeFan,1,0),art_tile(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  #8,$30(a0)
                moveq   #signextendB(sfx_FanLatch),d0
                jsr     (Play_SFX).l
                move.l  #SKFans_StepLargeFanDescent,(a0)

SKFans_StepLargeFanDescent:
                tst.w   $30(a0)
                beq.s   SKFans_TryLargeFanSound
                addq.w  #8,y_pos(a0)
                subq.w  #1,$30(a0)
                bne.s   SKFans_TryLargeFanSound
                move.b  #0,(_unkF7C7).w

SKFans_TryLargeFanSound:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   SKFans_AnimateLargeFan
                moveq   #signextendB(sfx_FanBig),d0
                jsr     (Play_SFX).l

SKFans_AnimateLargeFan:
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKFans_CullOrDrawLargeFan
                move.b  #0,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #5,mapping_frame(a0)
                blo.s   SKFans_CullOrDrawLargeFan
                move.b  #0,mapping_frame(a0)

SKFans_CullOrDrawLargeFan:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKFans_InitCompFan:
                move.l  #Map_CGZFan,mappings(a0)
                move.w  #make_art_tile(ArtTile_CGZMisc,3,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                addq.w  #8,d0
                lsl.w   #4,d0
                move.w  d0,$36(a0)
                addi.w  #$30,d0
                move.w  d0,$38(a0)
                move.l  #SKFans_UpdateCompFan,(a0)

SKFans_UpdateCompFan:
                lea     (Player_1).w,a1
                bsr.w   ApplyCgzFanFieldToPlayer
                lea     (Player_2).w,a1
                bsr.w   ApplyCgzFanFieldToPlayer
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   HCZFansSK_DrawCompetitionFanDirectly
                move.b  #0,mapping_frame(a0)

HCZFansSK_DrawCompetitionFanDirectly:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

ApplyCgzFanFieldToPlayer:
                cmpi.b  #4,routine(a1)
                bhs.w   SKFans_CompFieldReturn
                tst.b   object_control(a1)
                bne.w   SKFans_CompFieldReturn
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$14,d0
                cmpi.w  #$28,d0
                bhs.s   SKFans_CompFieldReturn
                moveq   #0,d1
                move.b  (Oscillating_table+$16).w,d1
                add.w   y_pos(a1),d1
                add.w   $36(a0),d1
                sub.w   y_pos(a0),d1
                bcs.s   SKFans_CompFieldReturn
                cmp.w   $38(a0),d1
                bhs.s   SKFans_CompFieldReturn
                sub.w   $36(a0),d1
                bcs.s   SKFans_ApplyCompLiftAndFlip
                not.w   d1
                add.w   d1,d1

SKFans_ApplyCompLiftAndFlip:
                add.w   $36(a0),d1
                neg.w   d1
                asr.w   #6,d1
                add.w   d1,y_pos(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                move.w  #0,y_vel(a1)
                move.b  #0,double_jump_flag(a1)
                move.b  #0,jumping(a1)
                move.w  #1,ground_vel(a1)
                tst.b   flip_angle(a1)
                bne.s   SKFans_CompFieldReturn
                move.b  #1,flip_angle(a1)
                move.b  #0,anim(a1)
                move.b  #$7F,flips_remaining(a1)
                move.b  #8,flip_speed(a1)

SKFans_CompFieldReturn:
                rts
; End of function ApplyCgzFanFieldToPlayer
