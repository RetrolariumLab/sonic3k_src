; Owner: rendering/palettes/s3; responsibility: transformation cycles
; Source provenance and ranges: config/reconstruction/source_layout.json
SuperSonic_PalCycle:
                move.b  (Super_palette_status).w,d0     ; 0 = off | 1 = fading | -1 = fading done
                beq.s   S3Pal_TransformCycleReturn      ; return, if player isn't super
                bmi.w   SuperSonic_PalCycle_Normal      ; branch, if fade-in is done
                subq.b  #1,d0
                bne.s   SuperSonic_PalCycle_Revert      ; branch for values greater than 1

; fade from Sonic's to Super Sonic's palette
; run frame timer
                subq.b  #1,(Palette_timer).w
                bpl.s   S3Pal_TransformCycleReturn
                move.b  #1,(Palette_timer).w

; increment palette frame and update Sonic's palette
                lea     (PalCycle_SuperSonic).l,a0
                move.w  (Palette_frame).w,d0
                addq.w  #6,(Palette_frame).w            ; 1 palette entry = 1 word, Sonic uses 3 shades of blue
                cmpi.w  #$24,(Palette_frame).w          ; has palette cycle reached the 6th frame?
                blo.s   SuperSonic_PalCycle_SonicApply  ; if not, branch
                move.b  #-1,(Super_palette_status).w    ; mark fade-in as done
                move.b  #0,(Player_1+object_control).w  ; restore Sonic's movement

SuperSonic_PalCycle_SonicApply:
                lea     (Normal_palette+$04).w,a1
                move.l  (a0,d0.w),(a1)+                 ; Write first two palette entries
                move.w  4(a0,d0.w),(a1)                 ; Write last palette entry

                tst.b   (Water_flag).w
                beq.s   S3Pal_TransformCycleReturn
                lea     (PalCycle_SuperSonicUnderwaterAIZICZ).l,a0  ; Load underwater fade-in palette
                tst.b   (Current_zone).w                ; Is Sonic in Angel Island Zone?
                beq.s   SuperSonic_PalCycle_ApplyUnderwater  ; If so, branch
                cmpi.b  #5,(Current_zone).w             ; Is Sonic in IceCap Zone?
                beq.s   SuperSonic_PalCycle_ApplyUnderwater  ; If so, branch
                lea     (PalCycle_SuperSonicUnderwaterHCZCNZLBZ).l,a0  ; Load alternate underwater fade-in palette

SuperSonic_PalCycle_ApplyUnderwater:
                lea     (Water_palette+$04).w,a1
                move.l  (a0,d0.w),(a1)+                 ; Write first two palette entries
                move.w  4(a0,d0.w),(a1)                 ; Write last palette entry

S3Pal_TransformCycleReturn:
                rts
; ---------------------------------------------------------------------------

SuperSonic_PalCycle_Revert:                             ; runs the fade in transition backwards
; run frame timer
                subq.b  #1,(Palette_timer).w
                bpl.s   S3Pal_TransformCycleReturn
                move.b  #3,(Palette_timer).w

; decrement palette frame and update Sonic's palette
                lea     (PalCycle_SuperSonic).l,a0
                move.w  (Palette_frame).w,d0
                subq.w  #6,(Palette_frame).w            ; previous frame
                bcc.s   S3Pal_ApplySonicRevertFrame     ; branch, if it isn't the first frame
; Bug: this only clears the high byte of Palette_frame, causing subsequent
; fade-ins to pull color values from Pal_FromBlack
                move.b  #0,(Palette_frame).w
                move.b  #0,(Super_palette_status).w     ; 0 = off

S3Pal_ApplySonicRevertFrame:
                bra.s   SuperSonic_PalCycle_SonicApply
; ---------------------------------------------------------------------------

SuperSonic_PalCycle_Normal:
; run frame timer
                subq.b  #1,(Palette_timer).w
                bpl.s   S3Pal_TransformCycleReturn
                move.b  #6,(Palette_timer).w

; increment palette frame and update Sonic's palette
                lea     (PalCycle_SuperSonic).l,a0
                move.w  (Palette_frame).w,d0
                addq.w  #6,(Palette_frame).w            ; next frame
                cmpi.w  #$36,(Palette_frame).w          ; is it the last frame?
; This condition causes the last frame to be skipped
                blo.s   S3Pal_ApplySuperSonicCycleFrame  ; if not, branch
                move.w  #$24,(Palette_frame).w          ; reset frame counter (Super Sonic's normal palette cycle starts at $24. Everything before that is for the palette fade)

S3Pal_ApplySuperSonicCycleFrame:
                bra.w   SuperSonic_PalCycle_SonicApply
; End of function SuperSonic_PalCycle

; ---------------------------------------------------------------------------
PalCycle_SuperSonic:
                dc.w    $E66,$C42,$822
                dc.w    $E88,$C66,$844
                dc.w    $EAA,$C88,$A66
                dc.w    $ECC,$EAA,$C88
                dc.w    $EEE,$ECC,$EAA
                dc.w    $EEE,$EEE,$EEE
                dc.w    $CEE,$CEE,$AEE
                dc.w    $AEE,$8EE,$6CC
                dc.w    $8EE,$0EE,$0AA
                dc.w    $AEE,$8EE,$6CC
PalCycle_SuperSonicUnderwaterAIZICZ:
                dc.w    $A82,$860,$640
                dc.w    $E88,$C66,$844
                dc.w    $EAA,$C88,$A66
                dc.w    $ECC,$EAA,$C88
                dc.w    $EEE,$ECC,$EAA
                dc.w    $EEE,$EEE,$EEE
                dc.w    $CEE,$CEC,$AEC
                dc.w    $AEC,$8EC,$6CA
                dc.w    $8EC,$4EA,$4A8
                dc.w    $CEE,$CEC,$AEC
PalCycle_SuperSonicUnderwaterHCZCNZLBZ:
                dc.w    $C66,$A44,$624
                dc.w    $E88,$C66,$844
                dc.w    $EAA,$C88,$A66
                dc.w    $ECC,$EAA,$C88
                dc.w    $EEE,$ECC,$EAA
                dc.w    $EEE,$EEE,$EEE
                dc.w    $CEE,$CEC,$AEC
                dc.w    $AEC,$8EC,$6CA
                dc.w    $8EC,$4EA,$4A8
                dc.w    $CEE,$CEC,$AEC

; =============== S U B R O U T I N E =======================================
