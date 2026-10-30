; Owner: game/level/zones/fbz/sk
; Responsibility: Flying Battery act-one screen initialization, event dispatch and progression control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

FBZ1_ScreenInit:
                cmpi.w  #$180,(Player_1+x_pos).w
                blo.s   loc_52412
                move.w  -8(a3),d0
                subq.w  #5,d0
                movea.w $34(a3),a1                      ; $680 Y
                movea.w $48(a3),a5                      ; $900 Y
                moveq   #3-1,d1

loc_52404:
                move.l  (a5)+,(a1)+                     ; Copy the "indoors" beginning part
                move.b  (a5)+,(a1)+
                adda.w  d0,a1
                adda.w  d0,a5
                dbf     d1,loc_52404
                bra.s   loc_5241C
; ---------------------------------------------------------------------------

loc_52412:
                move.w  #$18,(Events_bg+$00).w          ; If player is < $180 X
                st      (Events_bg+$02).w

loc_5241C:
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

FBZ1_ScreenEvent:
                cmpi.b  #6,(Player_1+routine).w
                blo.s   loc_5242E
                rts                                     ; Don't do any special events while Sonic is dying
; ---------------------------------------------------------------------------

loc_5242E:
                lea     FBZ1_LayoutModRange(pc),a1
                move.w  (Player_1+x_pos).w,d0
                move.w  (Player_1+y_pos).w,d1
                move.w  (Events_bg+$00).w,d2
                jmp     FBZ1_ScreenEvent_Index(pc,d2.w)
; ---------------------------------------------------------------------------

FBZ1_ScreenEvent_Index:
                bra.w   FBZ1SE_Normal
; ---------------------------------------------------------------------------
                bra.w   FBZ1SE_LayoutMod1
; ---------------------------------------------------------------------------
                bra.w   FBZ1SE_LayoutMod2
; ---------------------------------------------------------------------------
                bra.w   FBZ1SE_LayoutMod3
; ---------------------------------------------------------------------------
                bra.w   FBZ1SE_LayoutMod4
; ---------------------------------------------------------------------------
                bra.w   FBZ1SE_LayoutMod5
; ---------------------------------------------------------------------------
                bra.w   FBZ1SE_LayoutMod6               ; Beginning of stage
; ---------------------------------------------------------------------------

FBZ1SE_Normal:
                moveq   #4,d2
                moveq   #6-1,d3

loc_52462:
                lea     (a1),a5                         ; Check layout mod ranges
                cmp.w   (a5)+,d0
                blo.s   loc_5247A
                cmp.w   (a5)+,d0
                bhi.s   loc_5247A
                cmp.w   (a5)+,d1
                blo.s   loc_5247A
                cmp.w   (a5)+,d1
                bhi.s   loc_5247A
                move.w  d2,(Events_bg+$00).w
                bra.s   loc_52482
; ---------------------------------------------------------------------------

loc_5247A:
                addq.w  #8,a1
                addq.w  #4,d2
                dbf     d3,loc_52462

loc_52482:
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

FBZ1SE_LayoutMod1:
                jsr     FBZ1Screen_CheckInRange(pc)     ; Make sure Sonic is still in range
                tst.w   (Events_bg+$02).w
                bne.s   loc_524AA
                cmpi.w  #$B00,d0                        ; If indoors, check if Sonic is in right half of ranged area
                bhs.s   loc_524A0                       ; If so, branch
                cmpi.w  #$70A,d0                        ; Otherwise, check if Sonic has gone far enough to the right
                bls.w   loc_52828
                bra.s   loc_524D4
; ---------------------------------------------------------------------------

loc_524A0:
                cmpi.w  #$A0E,d1                        ; If to the right of ranged area, instead check if Sonic has gone low enough
                bls.w   loc_52828
                bra.s   loc_524D4
; ---------------------------------------------------------------------------

loc_524AA:
                cmpi.w  #$B00,d0                        ; If outdoors, check if Sonic is in right half of ranged area
                bhs.s   loc_524BA                       ; If so, branch
                cmpi.w  #$6F6,d0                        ; Otherwise, check if Sonic has gone far enough to the left
                bls.s   loc_524C2
                bra.w   loc_52828
; ---------------------------------------------------------------------------

loc_524BA:
                cmpi.w  #$9F2,d1                        ; If to the right of ranged area, instead check if Sonic has gone high enough
                bhi.w   loc_52828

loc_524C2:
                clr.w   (Events_bg+$02).w               ; In either case, go outdoors->indoors
                movea.w (a3),a5
                lea     $60(a5),a5
                movea.w (a3),a6
                lea     $64(a6),a6
                bra.s   loc_524E8
; ---------------------------------------------------------------------------

loc_524D4:
                st      (Events_bg+$02).w               ; Go indoors->outdoors
                movea.w $18(a3),a5
                lea     $60(a5),a5                      ; First source is at $300 Y, $3000 X
                movea.w $14(a3),a6
                lea     $64(a6),a6                      ; Second source is at $280 Y, $3200 X (both of these are technically out of range)

loc_524E8:
                movea.w $48(a3),a1
                lea     $C(a1),a1                       ; First destination is $900 Y, $600 X
                move.w  -8(a3),d0
                subq.w  #4,d0                           ; Width of four tiles
                moveq   #6-1,d1                         ; Height of 6 tiles

loc_524F8:
                move.l  (a5)+,(a1)+                     ; Copy over layout
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,loc_524F8
                movea.w $48(a3),a1
                lea     $1A(a1),a1                      ; Second destination is $900 Y, $D00 X
                move.w  -8(a3),d0
                subq.w  #6,d0                           ; Width of 6 tiles
                moveq   #4-1,d1                         ; Height of 4 tiles

loc_52512:
                move.l  (a6)+,(a1)+
                move.w  (a6)+,(a1)+                     ; Copy over layout
                adda.w  d0,a6
                adda.w  d0,a1
                dbf     d1,loc_52512
                jmp     Refresh_PlaneScreenDirect(pc)   ; Refresh screen
; ---------------------------------------------------------------------------

FBZ1SE_LayoutMod2:
                lea     8(a1),a1                        ; The following layout mods all basically work identically to the above with modifications in positioning, etc
                jsr     FBZ1Screen_CheckInRange(pc)     ; I'll leave it as an exercise to the reader to get the specifics of each routine :)
                tst.w   (Events_bg+$02).w
                bne.s   loc_5254A
                cmpi.w  #$C80,d0
                bhs.s   loc_52540
                cmpi.w  #$1F2,d1
                bhs.w   loc_52828
                bra.s   loc_52574
; ---------------------------------------------------------------------------

loc_52540:
                cmpi.w  #$108A,d0
                bls.w   loc_52828
                bra.s   loc_52574
; ---------------------------------------------------------------------------

loc_5254A:
                cmpi.w  #$C80,d0
                bhs.s   loc_5255A
                cmpi.w  #$20E,d1
                bhs.s   loc_52562
                bra.w   loc_52828
; ---------------------------------------------------------------------------

loc_5255A:
                cmpi.w  #$1076,d0
                bhi.w   loc_52828

loc_52562:
                clr.w   (Events_bg+$02).w
                movea.w (a3),a5
                lea     $6C(a5),a5
                movea.w (a3),a6
                lea     $76(a6),a6
                bra.s   loc_52588
; ---------------------------------------------------------------------------

loc_52574:
                st      (Events_bg+$02).w
                movea.w $14(a3),a5
                lea     $6C(a5),a5
                movea.w $10(a3),a6
                lea     $76(a6),a6

loc_52588:
                movea.w 8(a3),a1
                lea     $E(a1),a1
                move.w  -8(a3),d0
                subi.w  #$A,d0
                moveq   #4-1,d1

loc_5259A:
                move.l  (a5)+,(a1)+
                move.l  (a5)+,(a1)+
                move.w  (a5)+,(a1)+
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,loc_5259A
                movea.w $C(a3),a1
                lea     $1C(a1),a1
                move.w  -8(a3),d0
                subi.w  #$C,d0
                moveq   #3-1,d1

loc_525BA:
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                adda.w  d0,a6
                adda.w  d0,a1
                dbf     d1,loc_525BA
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

FBZ1SE_LayoutMod3:
                lea     $10(a1),a1
                jsr     FBZ1Screen_CheckInRange(pc)
                tst.w   (Events_bg+$02).w
                bne.s   loc_525F4
                cmpi.w  #$1880,d0
                bhs.s   loc_525EA
                cmpi.w  #$158A,d0
                bls.w   loc_52828
                bra.s   loc_52622
; ---------------------------------------------------------------------------

loc_525EA:
                cmpi.w  #$A0E,d1
                bls.w   loc_52828
                bra.s   loc_52622
; ---------------------------------------------------------------------------

loc_525F4:
                cmpi.w  #$1880,d0
                bhs.s   loc_52604
                cmpi.w  #$1576,d0
                bls.s   loc_5260C
                bra.w   loc_52828
; ---------------------------------------------------------------------------

loc_52604:
                cmpi.w  #$9F2,d1
                bhi.w   loc_52828

loc_5260C:
                clr.w   (Events_bg+$02).w
                movea.w $34(a3),a5
                lea     $60(a5),a5
                movea.w $28(a3),a6
                lea     $66(a6),a6
                bra.s   loc_52636
; ---------------------------------------------------------------------------

loc_52622:
                st      (Events_bg+$02).w
                movea.w $44(a3),a5
                lea     $60(a5),a5
                movea.w $3C(a3),a6
                lea     $66(a6),a6

loc_52636:
                movea.w $48(a3),a1
                lea     $28(a1),a1
                move.w  -8(a3),d0
                subq.w  #6,d0
                moveq   #4-1,d1

loc_52646:
                move.l  (a5)+,(a1)+
                move.w  (a5)+,(a1)+
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,loc_52646
                movea.w $48(a3),a1
                lea     $34(a1),a1
                move.w  -8(a3),d0
                subq.w  #6,d0
                moveq   #4-1,d1

loc_52662:
                move.l  (a6)+,(a1)+
                move.w  (a6)+,(a1)+
                adda.w  d0,a6
                adda.w  d0,a1
                dbf     d1,loc_52662
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

FBZ1SE_LayoutMod4:
                lea     $18(a1),a1
                jsr     FBZ1Screen_CheckInRange(pc)
                tst.w   (Events_bg+$02).w
                bne.s   loc_526A0
                cmpi.w  #$208A,d0
                bhs.s   loc_526D6
                cmpi.w  #$1D80,d0
                bhs.s   loc_52696
                cmpi.w  #$1C0A,d0
                bls.w   loc_52828
                bra.s   loc_526D6
; ---------------------------------------------------------------------------

loc_52696:
                cmpi.w  #$F2,d1
                bhs.w   loc_52828
                bra.s   loc_526D6
; ---------------------------------------------------------------------------

loc_526A0:
                cmpi.w  #$1D80,d0
                bhs.s   loc_526B0
                cmpi.w  #$1BF6,d0
                bls.s   loc_526C0
                bra.w   loc_52828
; ---------------------------------------------------------------------------

loc_526B0:
                cmpi.w  #$10E,d1
                bls.w   loc_52828
                cmpi.w  #$2076,d0
                bhs.w   loc_52828

loc_526C0:
                clr.w   (Events_bg+$02).w
                movea.w $28(a3),a5
                lea     $6E(a5),a5
                movea.w $28(a3),a6
                lea     $76(a6),a6
                bra.s   loc_526EA
; ---------------------------------------------------------------------------

loc_526D6:
                st      (Events_bg+$02).w
                movea.w $3C(a3),a5
                lea     $6E(a5),a5
                movea.w $3C(a3),a6
                lea     $76(a6),a6

loc_526EA:
                movea.w (a3),a1
                lea     $36(a1),a1
                move.w  -8(a3),d0
                subq.w  #8,d0
                moveq   #4-1,d1

loc_526F8:
                move.l  (a5)+,(a1)+
                move.l  (a5)+,(a1)+
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,loc_526F8
                movea.w (a3),a1
                lea     $3E(a1),a1
                move.w  -8(a3),d0
                subi.w  #$12,d0
                moveq   #5-1,d1

loc_52714:
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                move.w  (a6)+,(a1)+
                adda.w  d0,a6
                adda.w  d0,a1
                dbf     d1,loc_52714
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

FBZ1SE_LayoutMod5:
                lea     $20(a1),a1
                jsr     FBZ1Screen_CheckInRange(pc)
                cmpi.w  #$2100,d0
                blo.s   loc_52740
                cmpi.w  #$2600,d0
                bls.w   loc_52828

loc_52740:
                tst.w   (Events_bg+$02).w
                bne.s   loc_52750
                cmpi.w  #$172,d1
                bhs.w   loc_52828
                bra.s   loc_5276E
; ---------------------------------------------------------------------------

loc_52750:
                cmpi.w  #$18E,d1
                blo.w   loc_52828
                clr.w   (Events_bg+$02).w
                movea.w $28(a3),a5
                lea     $6E(a5),a5
                movea.w $28(a3),a6
                lea     $76(a6),a6
                bra.s   loc_52782
; ---------------------------------------------------------------------------

loc_5276E:
                st      (Events_bg+$02).w
                movea.w $3C(a3),a5
                lea     $6E(a5),a5
                movea.w $3C(a3),a6
                lea     $76(a6),a6

loc_52782:
                movea.w (a3),a1
                lea     $36(a1),a1
                move.w  -8(a3),d0
                subq.w  #8,d0
                moveq   #4-1,d1

loc_52790:
                move.l  (a5)+,(a1)+
                move.l  (a5)+,(a1)+
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,loc_52790
                movea.w (a3),a1
                lea     $3E(a1),a1
                move.w  -8(a3),d0
                subi.w  #$12,d0
                moveq   #5-1,d1

loc_527AC:
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                move.w  (a6)+,(a1)+
                adda.w  d0,a6
                adda.w  d0,a1
                dbf     d1,loc_527AC
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

FBZ1SE_LayoutMod6:
                lea     $28(a1),a1                      ; Get the last layout change range
                jsr     FBZ1Screen_CheckInRange(pc)     ; Ensure player is still in specified range
                tst.w   (Events_bg+$02).w
                bne.s   loc_527DA
                cmpi.w  #$70E,d1                        ; If "indoors", check if Sonic is below given point
                bls.w   loc_52828                       ; If not, don't do anything
                bra.s   loc_527EC
; ---------------------------------------------------------------------------

loc_527DA:
                cmpi.w  #$6F2,d1                        ; If "outdoors" flag is set, check if Sonic is above point given
                bhi.w   loc_52828                       ; If not, don't do anything
                clr.w   (Events_bg+$02).w               ; Make Sonic "indoors"
                movea.w $48(a3),a5                      ; Perform layout copy of indoor tiles
                bra.s   loc_527F4
; ---------------------------------------------------------------------------

loc_527EC:
                st      (Events_bg+$02).w               ; Make Sonic "outdoors"
                movea.w $54(a3),a5                      ; Perform layout copy of outdoor tiles

loc_527F4:
                movea.w $34(a3),a1
                move.w  -8(a3),d0
                subq.w  #5,d0
                moveq   #3-1,d1

loc_52800:
                move.l  (a5)+,(a1)+
                move.b  (a5)+,(a1)+                     ; Perform layout copy
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,loc_52800
                jmp     Refresh_PlaneScreenDirect(pc)   ; Redraw screen directly

; =============== S U B R O U T I N E =======================================

FBZ1Screen_CheckInRange:
                cmp.w   (a1)+,d0
                blo.s   loc_52822
                cmp.w   (a1)+,d0
                bhi.s   loc_52822
                cmp.w   (a1)+,d1
                blo.s   loc_52822
                cmp.w   (a1)+,d1
                bhi.s   loc_52822
                rts
; ---------------------------------------------------------------------------

loc_52822:
                addq.w  #4,sp
                clr.w   (Events_bg+$00).w

loc_52828:
                jmp     DrawTilesAsYouMove(pc)
; End of function FBZ1Screen_CheckInRange

; ---------------------------------------------------------------------------
FBZ1_LayoutModRange:
                dc.w    $400,  $F00,  $880,  $A80
                dc.w    $880, $1100,  $180,  $300
                dc.w    $1400, $1B80,  $900,  $B00
                dc.w    $1A80, $2100,   $80,  $200
                dc.w    $2080, $2680,  $100,  $280
                dc.w    0,  $180,  $580,  $780
