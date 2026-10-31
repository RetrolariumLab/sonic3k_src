; Owner: rendering/palettes/sk
; Responsibility: Object palette rotation interpreters, command dispatch and alternate script update
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Run_PalRotationScript:
                tst.b   (Palette_rotation_disable).w
                bne.s   locret_85A00
                lea     (Palette_rotation_data).w,a1

loc_85994:
                move.w  (a1),d0                         ; load palette displacement to d0
                beq.s   locret_85A00                    ; if 0, return
                subq.b  #1,2(a1)                        ; decrement delay
                bpl.s   loc_859CA                       ; if still positive, go to next entry
                movea.l 4(a1),a2                        ; load palette script address to a2
                movea.w (a2),a3                         ; load destination address to a3
                movea.l a2,a4                           ; copy script address to a4
                adda.w  d0,a4                           ; skip to palette data
                move.w  (a4),d1                         ; load the first entry to d1
                bpl.s   loc_859B0                       ; if positive, it is a normal entry
                bsr.w   sub_859CE                       ; this is a command

loc_859B0:
                moveq   #0,d2
                move.b  2(a2),d2                        ; load number of colors to d2

loc_859B6:
                move.w  (a4)+,(a3)+                     ; copy the next color into destination
                dbf     d2,loc_859B6                    ; loop for every color
                move.w  (a4)+,d0                        ; load next delay
                move.b  d0,2(a1)                        ; save the delay
                move.l  a4,d0                           ; copy current script position into d0
                move.l  a2,d1                           ; copy palette script origin to d1
                sub.l   d1,d0                           ; calculate the current displacement
                move.w  d0,(a1)                         ; store it back

loc_859CA:
                addq.w  #8,a1                           ; go to next script
                bra.s   loc_85994                       ; run the code again
; End of function Run_PalRotationScript

; =============== S U B R O U T I N E =======================================

sub_859CE:
                move.b  3(a2),d2                        ; load additional parameter to d2
                beq.s   loc_859FC
                neg.w   d1
                jmp     .table-8(pc,d1.w)
; ---------------------------------------------------------------------------

                .table:
                bra.w   loc_859E2
                bra.w   loc_85A02
; ---------------------------------------------------------------------------

loc_859E2:
                addq.b  #1,3(a1)                        ; Add one to counter
                cmp.b   3(a1),d2                        ; Compare with max counter
                bhi.s   loc_859FC
                move.w  2(a4),d2
                adda.w  d2,a2
                move.l  a2,4(a1)                        ; Load new script after counter has finished
                movea.w (a2),a3
                clr.w   2(a1)

loc_859FC:
                movea.l a2,a4                           ; Start from the beginning of the rotation
                addq.l  #4,a4

locret_85A00:
                rts
; End of function sub_859CE

; ---------------------------------------------------------------------------

loc_85A02:
                addq.b  #1,3(a1)
                cmp.b   3(a1),d2
                bhi.s   loc_859FC                       ; Wait for counter to finish
                movea.l (Palette_rotation_custom).w,a2
                move.l  a1,-(sp)
                jsr     (a2)                            ; Run custom routine
                movea.l (sp)+,a1
                addq.w  #4,sp
                bra.s   loc_859CA

; =============== S U B R O U T I N E =======================================

Run_PalRotationScript2:
                tst.b   (Palette_rotation_disable).w
                bne.s   locret_85A58
                subq.b  #1,$3A(a0)
                bpl.s   locret_85A58
                movea.l (a1)+,a3                        ; Address of Palette animation data
                move.w  (a1)+,d0                        ; Number of colors to replace
                moveq   #0,d1
                move.b  $3B(a0),d1
                addq.b  #2,d1
                moveq   #0,d2
                move.b  (a1,d1.w),d2
                bpl.s   loc_85A3E
                moveq   #0,d1
                move.b  (a1),d2

loc_85A3E:
                move.b  d1,$3B(a0)
                move.b  1(a1,d1.w),$3A(a0)
                add.w   d2,d2
                move.w  (a3,d2.w),d2
                lea     (a3,d2.w),a3

loc_85A52:
                move.w  (a3)+,(a2)+
                dbf     d0,loc_85A52

locret_85A58:
                rts
; End of function Run_PalRotationScript2
