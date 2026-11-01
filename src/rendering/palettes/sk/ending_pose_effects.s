; Owner: rendering/palettes/sk
; Responsibility: Ending Super Knuckles pose palette cycle and timed palette fade callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_5FBA0:
                tst.b   (Palette_cycle_counters+$00).w
                bne.w   loc_5EC36
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   locret_5FBE0
                move.b  #2,anim_frame_timer(a0)
                lea     Pal_KnuxEndPoseSuper(pc),a1
                move.w  $3A(a0),d0
                addq.w  #6,d0
                cmpi.w  #$3C,d0
                blo.s   loc_5FBCE
                moveq   #0,d0
                move.b  #$E,anim_frame_timer(a0)

loc_5FBCE:
                move.w  d0,$3A(a0)
                lea     (Normal_palette+$4).w,a2
                move.l  (a1,d0.w),(a2)+
                move.w  4(a1,d0.w),2(a2)

locret_5FBE0:
                rts
; ---------------------------------------------------------------------------
Pal_KnuxEndPoseSuper:
                binclude "data/General/Ending/Palettes/Super Knuckles End Pose.bin"
                even
; ---------------------------------------------------------------------------

loc_5FC1E:
                move.b  #2,$39(a0)
                move.l  #loc_5FC2A,(a0)

loc_5FC2A:
                subq.w  #1,$2E(a0)
                bpl.s   locret_5FC4C
                move.w  #5,$2E(a0)
                lea     (Normal_palette_line_3+$2).w,a1
                moveq   #$F-1,d0

loc_5FC3C:
                jsr     (EffectColorSKRaiseOneColorTowardWhite).l
                dbf     d0,loc_5FC3C
                subq.b  #1,$39(a0)
                bmi.s   loc_5FC4E

locret_5FC4C:
                rts
; ---------------------------------------------------------------------------

loc_5FC4E:
                move.l  #loc_5FC62,(a0)
                move.b  #2,$39(a0)
                move.w  #$13,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_5FC62:
                subq.w  #1,$2E(a0)
                bpl.s   locret_5FC4C
                move.w  #3,$2E(a0)
                lea     (Normal_palette_line_3+$2).w,a1
                lea     (Target_palette_line_3+$2).w,a2
                moveq   #$F-1,d0

loc_5FC78:
                jsr     (EffectColorSKLowerOneColorTowardTarget).l
                dbf     d0,loc_5FC78
                subq.b  #1,$39(a0)
                bpl.s   locret_5FC4C
                jmp     (Go_Delete_Sprite).l
; End of function loc_5FC62
