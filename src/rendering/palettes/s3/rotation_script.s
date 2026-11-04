; Owner: rendering/palettes/s3
; Responsibility: Object palette rotation script execution and delay or step helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Run_PalRotationScript:
                lea     (Palette_rotation_data).w,a1

PaletteRotationS3_VisitSlot:
                move.w  (a1),d0                         ; load palette displacement to d0
                beq.s   S3PalRotation_ScriptReturn      ; if 0, return
                subq.b  #1,2(a1)                        ; decrement delay
                bpl.s   PaletteRotationS3_AdvanceToNextSlot  ; if still positive, go to next entry
                movea.l 4(a1),a2                        ; load palette script address to a2
                movea.w (a2),a3                         ; load destination address to a3
                lea     (a2,d0.w),a4                    ; copy script address to a4 and skip to palette data
                move.w  (a4),d1                         ; load the first entry to d1
                bpl.s   PaletteRotationS3_BeginColorCopy  ; if positive, it is a normal entry
                bsr.w   PalRotation_DispatchControlCommand  ; this is a command

PaletteRotationS3_BeginColorCopy:
                moveq   #0,d2
                move.b  2(a2),d2                        ; load number of colors to d2

S3PalRotation_CopyStepColors:
                move.w  (a4)+,(a3)+                     ; copy the next color into destination
                dbf     d2,S3PalRotation_CopyStepColors  ; loop for every color
                move.w  (a4)+,d0                        ; load next delay
                move.b  d0,2(a1)                        ; save the delay
                move.l  a4,d0                           ; copy current script position into d0
                sub.l   a2,d0                           ; calculate the current displacement from palette script origin
                move.w  d0,(a1)                         ; store it back

PaletteRotationS3_AdvanceToNextSlot:
                addq.w  #8,a1                           ; go to next script
                bra.s   PaletteRotationS3_VisitSlot     ; run the code again
; End of function Run_PalRotationScript

; =============== S U B R O U T I N E =======================================

PalRotation_DispatchControlCommand:
                move.b  3(a2),d2                        ; load additional parameter to d2
                bne.s   PaletteRotationS3_DispatchCountedCommand
                moveq   #4,d0                           ; Start from the beginning of the rotation
                lea     (a2,d0.w),a4

S3PalRotation_ScriptReturn:
                rts
; ---------------------------------------------------------------------------

PaletteRotationS3_DispatchCountedCommand:
                neg.w   d1
                jmp     .table-8(pc,d1.w)
; End of function PalRotation_DispatchControlCommand

; ---------------------------------------------------------------------------

                .table:
                bra.w   S3PalRotation_TrySwitchScriptAtLimit
                bra.w   S3PalRotation_TickCustomCount
; ---------------------------------------------------------------------------

S3PalRotation_TrySwitchScriptAtLimit:
                addq.b  #1,3(a1)                        ; Add one to counter
                cmp.b   3(a1),d2                        ; Compare with max counter
                bhi.s   PaletteRotationS3_RestartHeaderData
                move.w  2(a4),d2
                adda.w  d2,a2
                move.l  a2,4(a1)                        ; Load new script after counter has finished
                movea.w (a2),a3
                clr.w   2(a1)

PaletteRotationS3_RestartHeaderData:
                moveq   #4,d0                           ; Start from the beginning of the rotation
                lea     (a2,d0.w),a4
                rts
; ---------------------------------------------------------------------------

S3PalRotation_TickCustomCount:
                addq.b  #1,3(a1)
                cmp.b   3(a1),d2
                bls.s   S3PalRotation_CallCustomAndStep
                moveq   #4,d0                           ; Start from the beginning of the rotation
                lea     (a2,d0.w),a4
                rts
; ---------------------------------------------------------------------------

S3PalRotation_CallCustomAndStep:
                movea.l (Palette_rotation_custom).w,a2
                move.l  a1,-(sp)
                jsr     (a2)                            ; Run custom routine
                movea.l (sp)+,a1
                addq.w  #4,sp
                bra.s   PaletteRotationS3_AdvanceToNextSlot
; End of function S3PalRotation_CallCustomAndStep
