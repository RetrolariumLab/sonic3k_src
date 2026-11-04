; Owner: rendering/palettes/sk
; Responsibility: Ending Super Knuckles pose palette cycle and timed palette fade callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

EndSuperKnuxPal_AdvanceCycle:
                tst.b   (Palette_cycle_counters+$00).w
                bne.w   EndingChild_DeleteCurrentActor
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   EndSuperKnuxPal_CycleReturn
                move.b  #2,anim_frame_timer(a0)
                lea     Pal_KnuxEndPoseSuper(pc),a1
                move.w  $3A(a0),d0
                addq.w  #6,d0
                cmpi.w  #$3C,d0
                blo.s   EndSuperKnuxPal_CopyColors
                moveq   #0,d0
                move.b  #$E,anim_frame_timer(a0)

EndSuperKnuxPal_CopyColors:
                move.w  d0,$3A(a0)
                lea     (Normal_palette+$4).w,a2
                move.l  (a1,d0.w),(a2)+
                move.w  4(a1,d0.w),2(a2)

EndSuperKnuxPal_CycleReturn:
                rts
; ---------------------------------------------------------------------------
Pal_KnuxEndPoseSuper:
                binclude "data/General/Ending/Palettes/Super Knuckles End Pose.bin"
                even
; ---------------------------------------------------------------------------

EndLine3Flash_InitRaise:
                move.b  #2,$39(a0)
                move.l  #EndLine3Flash_TryRaisePass,(a0)

EndLine3Flash_TryRaisePass:
                subq.w  #1,$2E(a0)
                bpl.s   EndingLineThreeFlash_ReturnBetweenPasses
                move.w  #5,$2E(a0)
                lea     (Normal_palette_line_3+$2).w,a1
                moveq   #$F-1,d0

EndingLineThreeFlash_RaiseColorLoop:
                jsr     (EffectColorSKRaiseOneColorTowardWhite).l
                dbf     d0,EndingLineThreeFlash_RaiseColorLoop
                subq.b  #1,$39(a0)
                bmi.s   EndingLineThreeFlash_BeginRestoreDelay

EndingLineThreeFlash_ReturnBetweenPasses:
                rts
; ---------------------------------------------------------------------------

EndingLineThreeFlash_BeginRestoreDelay:
                move.l  #EndLine3Flash_TryRestorePass,(a0)
                move.b  #2,$39(a0)
                move.w  #$13,$2E(a0)
                rts
; ---------------------------------------------------------------------------

EndLine3Flash_TryRestorePass:
                subq.w  #1,$2E(a0)
                bpl.s   EndingLineThreeFlash_ReturnBetweenPasses
                move.w  #3,$2E(a0)
                lea     (Normal_palette_line_3+$2).w,a1
                lea     (Target_palette_line_3+$2).w,a2
                moveq   #$F-1,d0

EndLine3Flash_RestoreColors:
                jsr     (EffectColorSKLowerOneColorTowardTarget).l
                dbf     d0,EndLine3Flash_RestoreColors
                subq.b  #1,$39(a0)
                bpl.s   EndingLineThreeFlash_ReturnBetweenPasses
                jmp     (Go_Delete_Sprite).l
; End of function EndLine3Flash_TryRestorePass
