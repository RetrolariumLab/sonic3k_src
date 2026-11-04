; Owner: objects/bosses/ssz/shared/sk
; Responsibility: Sky Sanctuary post-battle player control restoration, palette fade and camera boundary transition actors
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_7D056:
                move.l  #loc_7D062,(a0)
                move.w  #(2*60)-1,$2E(a0)

loc_7D062:
                moveq   #2,d0
                jsr     (SKCapsule_TryResultsOnLanding).l
                tst.b   routine(a0)
                beq.s   locret_7D076
                move.l  #loc_7D078,(a0)

locret_7D076:
                rts
; ---------------------------------------------------------------------------

loc_7D078:
                jsr     (Check_TailsEndPose).l
                tst.b   (_unkFAA8).w
                bne.w   locret_7B448
                jsr     (Restore_PlayerControl).l
                lea     (Player_2).w,a1
                jsr     (Restore_PlayerControl2).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_7D09C:
                move.b  #2,$39(a0)
                move.l  #loc_7D0A8,(a0)

loc_7D0A8:
                subq.w  #1,$2E(a0)
                bpl.s   locret_7D0CA
                move.w  #5,$2E(a0)
                lea     (Normal_palette).w,a1
                moveq   #$40-1,d0

loc_7D0BA:
                jsr     (EffectColorSKRaiseOneColorTowardWhite).l
                dbf     d0,loc_7D0BA
                subq.b  #1,$39(a0)
                bmi.s   loc_7D0CC

locret_7D0CA:
                rts
; ---------------------------------------------------------------------------

loc_7D0CC:
                move.l  #loc_7D0E0,(a0)
                move.b  #2,$39(a0)
                move.w  #30-1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_7D0E0:
                subq.w  #1,$2E(a0)
                bpl.s   locret_7D0CA
                move.w  #3,$2E(a0)
                lea     (Normal_palette).w,a1
                lea     (Target_palette).w,a2
                moveq   #$40-1,d0

loc_7D0F6:
                jsr     (EffectColorSKLowerOneColorTowardTarget).l
                dbf     d0,loc_7D0F6
                subq.b  #1,$39(a0)
                bpl.s   locret_7D0CA
                lea     (Target_palette).w,a1
                lea     (Normal_palette).w,a2
                moveq   #bytesToLcnt($80),d6

loc_7D110:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_7D110
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_7D11C:
                move.w  #$100,d0
                cmp.w   (Camera_X_pos).w,d0
                bls.s   loc_7D134
                addq.w  #1,(Camera_X_pos).w
                addq.w  #1,(Camera_min_X_pos).w
                addq.w  #1,(Camera_max_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_7D134:
                move.w  d0,(Camera_X_pos).w
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                clr.b   (Scroll_lock).w
                bset    #4,(_unkFAB8).w
                jmp     (Delete_Current_Sprite).l
; End of function loc_7D078
