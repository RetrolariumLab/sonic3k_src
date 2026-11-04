; Owner: objects/ending/sk
; Responsibility: Mecha Sonic ending eyecatch, palette rotation, animation, launch and exit input
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

EndMecha_DispatchLoadArtAndDraw:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  EndingMechaSonicEyecatch_StateOffsets(pc,d0.w),d1
                jsr     EndingMechaSonicEyecatch_StateOffsets(pc,d1.w)
                lea     (DPLCPtr_MechaSonic).l,a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
EndingMechaSonicEyecatch_StateOffsets:
                dc.w    EndMecha_InitSlottedAppearance-EndingMechaSonicEyecatch_StateOffsets
                dc.w    EndMecha_WaitAndCyclePalette-EndingMechaSonicEyecatch_StateOffsets
                dc.w    EndMecha_WaitThenStartFirstAnim-EndingMechaSonicEyecatch_StateOffsets
                dc.w    EndMecha_AnimateWithCallback-EndingMechaSonicEyecatch_StateOffsets
                dc.w    EndMecha_AnimateWithCallback-EndingMechaSonicEyecatch_StateOffsets
                dc.w    EndMecha_JumpAndAnimateLanding-EndingMechaSonicEyecatch_StateOffsets
                dc.w    EndMecha_AnimateWithCallback-EndingMechaSonicEyecatch_StateOffsets
                dc.w    EndMecha_WaitForStartOrTimeout-EndingMechaSonicEyecatch_StateOffsets
; ---------------------------------------------------------------------------

EndMecha_InitSlottedAppearance:
                clr.w   (Slotted_object_bits).w
                lea     (ObjSlot_MechaSonic).l,a1
                jsr     (SetUp_ObjAttributesSlotted).l
                bclr    #2,render_flags(a0)
                bset    #7,art_tile(a0)
                move.b  #$F,mapping_frame(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$F8,y_pos(a0)
                move.w  #$EF,$2E(a0)
                lea     (Pal_SSZGHZMisc).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

EndMecha_CopyPaletteAndTrySparks:
                move.l  (a1)+,(a2)+
                dbf     d6,EndMecha_CopyPaletteAndTrySparks
                bsr.w   Ending_TrySpawnLine2Fade
                lea     (SSZMechaSparks_SimpleChildRecord).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   EndMecha_InstallPaletteScriptAndArt
                move.b  #$80,subtype(a1)

EndMecha_InstallPaletteScriptAndArt:
                lea     (MechaSonic_IdleFlashPaletteScript).l,a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                lea     (ArtKosM_MechaSonicExtra).l,a1
                move.w  #tiles_to_bytes(ArtTile_MechaSonicExtra),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

EndMecha_WaitAndCyclePalette:
                subq.w  #1,$2E(a0)
                bmi.s   EndMecha_BeginChildEffectHandshake
                jmp     (Run_PalRotationScript).l
; ---------------------------------------------------------------------------

EndMecha_BeginChildEffectHandshake:
                move.b  #4,routine(a0)
                lea     (Pal_SSZGHZMisc).l,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

EndMecha_RestorePaletteAndSetWaitFlag:
                move.l  (a1)+,(a2)+
                dbf     d6,EndMecha_RestorePaletteAndSetWaitFlag
                bset    #6,$38(a0)
                lea     (SSZMechaSignalEffect_NormalChildRecord).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

EndMecha_WaitThenStartFirstAnim:
                btst    #6,$38(a0)
                bne.w   EndingScene_SharedReturn
                move.b  #6,routine(a0)
                move.b  #$E,mapping_frame(a0)
                move.l  #EndMecha_BeginSecondAnim,$34(a0)
                lea     (SSZMecha_RecoverThenActAnim).l,a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

EndMecha_AnimateWithCallback:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

EndMecha_BeginSecondAnim:
                move.b  #8,routine(a0)
                move.l  #EndingMechaSonicEyecatch_LaunchJump,$34(a0)
                lea     (SSZMecha_PreJumpCallbackRawAnimation).l,a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

EndingMechaSonicEyecatch_LaunchJump:
                move.b  #$A,routine(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

EndMecha_JumpAndAnimateLanding:
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.w   EndingScene_SharedReturn
                cmpi.w  #$C8,y_pos(a0)
                blo.w   EndingScene_SharedReturn
                move.b  #$C,routine(a0)
                move.w  #$CC,y_pos(a0)
                move.l  #EndMecha_BeginFinalExitDelay,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                lea     (SSZMecha_TransformLandingAnim).l,a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

EndMecha_BeginFinalExitDelay:
                move.b  #$E,routine(a0)
                move.w  #$4AF,$2E(a0)
                rts
; ---------------------------------------------------------------------------

EndMecha_WaitForStartOrTimeout:
                btst    #button_start,(Ctrl_1_held).w
                bne.s   EndMecha_SelectSegaScreen
                btst    #button_start,(Ctrl_2_held).w
                bne.s   EndMecha_SelectSegaScreen
                subq.w  #1,$2E(a0)
                bpl.s   EndMecha_ExitWaitReturn

EndMecha_SelectSegaScreen:
                move.b  #GameMode_SegaScreen,(Game_mode).w

EndMecha_ExitWaitReturn:
                rts
