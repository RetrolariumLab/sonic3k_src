; Owner: objects/ending/sk
; Responsibility: Prepare or revert the super character ending state and coordinate the related palette transition
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

EndingPrepareSuperSonicVisualState:
                clr.b   (Player_1+anim).w
                move.w  #$24,(Palette_frame).w
                move.b  #1,(Super_Sonic_Knux_flag).w

EndPose_InstallSuperSonicVisuals:
                move.b  #-1,(Super_palette_status).w
                move.b  #0,(Palette_timer).w
                move.l  #Map_SuperSonic,(Player_1+mappings).w
                rts
; End of function EndingPrepareSuperSonicVisualState

; =============== S U B R O U T I N E =======================================

EndingPrepareSuperTailsPaletteState:
                move.b  #-1,(Super_palette_status).w
                move.w  #0,(Palette_frame).w
                move.b  #0,(Palette_frame_Tails).w
                move.b  #1,(Super_Tails_flag).w
                rts
; End of function EndingPrepareSuperTailsPaletteState

; =============== S U B R O U T I N E =======================================

EndingAndDDZPrepareHyperSonicVisualState:
                move.b  #-1,(Super_Sonic_Knux_flag).w
                move.w  #0,(Palette_frame).w
                bra.s   EndPose_InstallSuperSonicVisuals
; End of function EndingAndDDZPrepareHyperSonicVisualState

; ---------------------------------------------------------------------------

EndingSuperTailsPaletteActor_Initialize:
                move.l  #EndPose_CycleSuperTailsUntilCleanup,(a0)
                lea     PalSPtr_EndingSuperTails(pc),a1
                jsr     (InstallSingleGlobalPaletteRotationScript).l

EndPose_CycleSuperTailsUntilCleanup:
                btst    #3,(_unkFAB8).w
                bne.w   EndingChild_DeleteCurrentActor
                jmp     (Run_PalRotationScript).l
; ---------------------------------------------------------------------------

EndPose_InitPaletteActorBySubtype:
                move.l  #EndingSonicPosePaletteActor_AdvanceCycle,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  EndPose_PaletteSpanDelayPairs(pc,d0.w),$3A(a0)
                add.w   d0,d0
                move.l  EndPose_PaletteSourcePointers(pc,d0.w),$30(a0)

EndingSonicPosePaletteActor_AdvanceCycle:
                tst.b   (Palette_cycle_counters+$00).w
                bne.w   EndingChild_DeleteCurrentActor
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   EndPose_PosePaletteUpdateReturn
                move.b  $3B(a0),anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #6,d0
                cmp.b   $3A(a0),d0
                blo.s   EndPose_CopySelectedPoseColors
                moveq   #0,d0

EndPose_CopySelectedPoseColors:
                move.b  d0,anim_frame(a0)
                movea.l $30(a0),a1
                adda.w  d0,a1
                lea     (Normal_palette_line_3+$4).w,a2
                move.l  (a1)+,(a2)+
                move.w  (a1)+,(a2)+

EndPose_PosePaletteUpdateReturn:
                rts
; ---------------------------------------------------------------------------
EndPose_PaletteSpanDelayPairs:
                dc.b    $18,   6
                dc.b    $48,   4
                even
EndPose_PaletteSourcePointers:
                dc.l    PalCycle_SuperSonic+$24
                dc.l    PalCycle_HyperSonic
; ---------------------------------------------------------------------------

EndingDelayedS3ResultBanner_Initialize:
                move.l  #EndPose_WaitAndTryS3Banner,(a0)
                move.w  #32-1,$2E(a0)

EndPose_WaitAndTryS3Banner:
                subq.w  #1,$2E(a0)
                bpl.w   EndingScene_SharedReturn
                jsr     (AllocateObject).l
                bne.s   EndPose_DeleteAfterBannerAttempt
                move.l  #EndBanner_InitS3GraphicsProgram,(a1)
                move.b  #4,subtype(a1)

EndPose_DeleteAfterBannerAttempt:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

Ending_SetP1PoseAndLoadArt:
                lea     (Player_1).w,a1
                move.w  (Player_mode).w,d0
                andi.w  #3,d0
                move.b  EndPose_FramesByPlayerMode(pc,d0.w),mapping_frame(a1)
                jmp     (Player_Load_PLC).l
; End of function Ending_SetP1PoseAndLoadArt

; ---------------------------------------------------------------------------
EndPose_FramesByPlayerMode:
                dc.b    $BA
                dc.b    $BA
                dc.b    $AD
                dc.b    $56
                even

; =============== S U B R O U T I N E =======================================

; Store the allocated fade actor's short handle in the eyecatch owner
Ending_TrySpawnLine2Fade:
                jsr     (AllocateObject).l
                bne.s   EndPose_Line2FadeSpawnReturn
                move.w  a1,$44(a0)
                move.l  #Obj_FadeSelectedFromBlack,(a1)
                moveq   #5,d0
                move.w  d0,$3A(a1)
                move.w  d0,$2E(a1)
                move.w  #$F,$3C(a1)
                move.w  #Normal_palette_line_2,$30(a1)
                move.w  #Target_palette_line_2,$32(a1)

EndPose_Line2FadeSpawnReturn:
                rts
; End of function Ending_TrySpawnLine2Fade

; ---------------------------------------------------------------------------

Obj_Ending_RevertSuperSonic:
                move.w  #(2*60)-1,$2E(a0)
                move.l  #EndPose_WaitAndRestoreNormalFlags,(a0)

EndPose_WaitAndRestoreNormalFlags:
                subq.w  #1,$2E(a0)
                bpl.s   EndPose_SuperRevertFlagReturn
                move.l  #EndPose_RestoreNormalMapAndDelete,(a0)
                lea     (Player_1).w,a1
                move.b  #$F,anim(a1)
                move.b  #2,(Super_palette_status).w
                move.w  #$1E,(Palette_frame).w
                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #0,(Super_Tails_flag).w

EndPose_SuperRevertFlagReturn:
                rts
; ---------------------------------------------------------------------------

EndPose_RestoreNormalMapAndDelete:
                move.l  #Map_Sonic,(Player_1+mappings).w
                jmp     (Delete_Current_Sprite).l
