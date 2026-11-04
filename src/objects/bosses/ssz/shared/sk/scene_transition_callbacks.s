; Owner: objects/bosses/ssz/shared/sk
; Responsibility: Sky Sanctuary post-battle player control restoration, palette fade and camera boundary transition actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

SSZPostBossResultsGate_Initialize:
                move.l  #SSZMecha_ResultsWaitForLanding,(a0)
                move.w  #(2*60)-1,$2E(a0)

SSZMecha_ResultsWaitForLanding:
                moveq   #2,d0
                jsr     (SKCapsule_TryResultsOnLanding).l
                tst.b   routine(a0)
                beq.s   SSZMecha_ResultsLandingCheckReturn
                move.l  #SSZMecha_RestoreControlsAfterResults,(a0)

SSZMecha_ResultsLandingCheckReturn:
                rts
; ---------------------------------------------------------------------------

SSZMecha_RestoreControlsAfterResults:
                jsr     (Check_TailsEndPose).l
                tst.b   (ActCompletionHandshake).w
                bne.w   SSZMechaBattleAndChildren_SharedReturn
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SSZMecha_InitTransformFlash:
                move.b  #2,$39(a0)
                move.l  #SSZMecha_BeginPaletteRaisePass,(a0)

SSZMecha_BeginPaletteRaisePass:
                subq.w  #1,$2E(a0)
                bpl.s   SSZMecha_PalettePassReturn
                move.w  #5,$2E(a0)
                lea     (Normal_palette).w,a1
                moveq   #$40-1,d0

SSZMecha_RaisePaletteColors:
                jsr     (EffectColorSKRaiseOneColorTowardWhite).l
                dbf     d0,SSZMecha_RaisePaletteColors
                subq.b  #1,$39(a0)
                bmi.s   SSZMechaTransformFlash_BeginRestoreDelay

SSZMecha_PalettePassReturn:
                rts
; ---------------------------------------------------------------------------

SSZMechaTransformFlash_BeginRestoreDelay:
                move.l  #SSZMecha_BeginPaletteRestorePass,(a0)
                move.b  #2,$39(a0)
                move.w  #30-1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

SSZMecha_BeginPaletteRestorePass:
                subq.w  #1,$2E(a0)
                bpl.s   SSZMecha_PalettePassReturn
                move.w  #3,$2E(a0)
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #$40-1,d0

SSZMecha_LowerPaletteColors:
                jsr     (EffectColorSKLowerOneColorTowardTarget).l
                dbf     d0,SSZMecha_LowerPaletteColors
                subq.b  #1,$39(a0)
                bpl.s   SSZMecha_PalettePassReturn
                lea     (Target_palette).w,a1
                lea     (Normal_palette).w,a2
                moveq   #bytesToLcnt($80),d6

SSZMecha_RestoreTargetPaletteAndDelete:
                move.l  (a1)+,(a2)+
                dbf     d6,SSZMecha_RestoreTargetPaletteAndDelete
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

SSZCraneSceneCamera_AdvanceTowardFixedX:
                move.w  #$100,d0
                cmp.w   (Camera_X_pos).w,d0
                bls.s   SSZCraneSceneCamera_ClampUnlockAndSignal
                addq.w  #1,(Camera_X_pos).w
                addq.w  #1,(Camera_min_X_pos).w
                addq.w  #1,(Camera_max_X_pos).w
                rts
; ---------------------------------------------------------------------------

SSZCraneSceneCamera_ClampUnlockAndSignal:
                move.w  d0,(Camera_X_pos).w
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                clr.b   (Scroll_lock).w
                bset    #4,(SceneSyncFlagsOrMHZState).w
                jmp     (Delete_Current_Sprite).l
; End of function SSZMecha_RestoreControlsAfterResults
