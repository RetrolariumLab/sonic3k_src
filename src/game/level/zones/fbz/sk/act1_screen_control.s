; Owner: game/level/zones/fbz/sk
; Responsibility: Flying Battery act-one screen initialization, event dispatch and progression control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

FBZ1_ScreenInit:
                cmpi.w  #$180,(Player_1+x_pos).w
                blo.s   SKFBZ1FG_InitOutdoorStart
                move.w  -8(a3),d0
                subq.w  #5,d0
                movea.w $34(a3),a1                      ; $680 Y
                movea.w $48(a3),a5                      ; $900 Y
                moveq   #3-1,d1

SKFBZ1FG_CopyIndoorStartRows:
                move.l  (a5)+,(a1)+                     ; Copy the "indoors" beginning part
                move.b  (a5)+,(a1)+
                adda.w  d0,a1
                adda.w  d0,a5
                dbf     d1,SKFBZ1FG_CopyIndoorStartRows
                bra.s   SKFBZ1FG_RefreshInitialForeground
; ---------------------------------------------------------------------------

SKFBZ1FG_InitOutdoorStart:
                move.w  #$18,(Events_bg+$00).w          ; If player is < $180 X
                st      (Events_bg+$02).w

SKFBZ1FG_RefreshInitialForeground:
                jsr     Reset_TileOffsetPositionActual(pc)
                jmp     Refresh_PlaneFull(pc)
; ---------------------------------------------------------------------------

FBZ1_ScreenEvent:
                cmpi.b  #6,(Player_1+routine).w
                blo.s   SKFBZ1FG_DispatchLayoutEvent
                rts                                     ; Don't do any special events while Sonic is dying
; ---------------------------------------------------------------------------

SKFBZ1FG_DispatchLayoutEvent:
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

SKFBZ1FG_FindPlayerRegion:
                lea     (a1),a5                         ; Check layout mod ranges
                cmp.w   (a5)+,d0
                blo.s   SKFBZ1FG_NextPlayerRegion
                cmp.w   (a5)+,d0
                bhi.s   SKFBZ1FG_NextPlayerRegion
                cmp.w   (a5)+,d1
                blo.s   SKFBZ1FG_NextPlayerRegion
                cmp.w   (a5)+,d1
                bhi.s   SKFBZ1FG_NextPlayerRegion
                move.w  d2,(Events_bg+$00).w
                bra.s   SKFBZ1FG_DrawForegroundAfterRangeScan
; ---------------------------------------------------------------------------

SKFBZ1FG_NextPlayerRegion:
                addq.w  #8,a1
                addq.w  #4,d2
                dbf     d3,SKFBZ1FG_FindPlayerRegion

SKFBZ1FG_DrawForegroundAfterRangeScan:
                jmp     DrawTilesAsYouMove(pc)
; ---------------------------------------------------------------------------

FBZ1SE_LayoutMod1:
                jsr     FBZ1Screen_CheckInRange(pc)     ; Make sure Sonic is still in range
                tst.w   (Events_bg+$02).w
                bne.s   SKFBZ1FG_Mod1_OutdoorXGate
                cmpi.w  #$B00,d0                        ; If indoors, check if Sonic is in right half of ranged area
                bhs.s   SKFBZ1FG_Mod1_IndoorYGate       ; If so, branch
                cmpi.w  #$70A,d0                        ; Otherwise, check if Sonic has gone far enough to the right
                bls.w   SKFBZ1FG_DrawForeground
                bra.s   SKFBZ1FG_Mod1_BindOutdoor
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod1_IndoorYGate:
                cmpi.w  #$A0E,d1                        ; If to the right of ranged area, instead check if Sonic has gone low enough
                bls.w   SKFBZ1FG_DrawForeground
                bra.s   SKFBZ1FG_Mod1_BindOutdoor
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod1_OutdoorXGate:
                cmpi.w  #$B00,d0                        ; If outdoors, check if Sonic is in right half of ranged area
                bhs.s   SKFBZ1FG_Mod1_OutdoorYGate      ; If so, branch
                cmpi.w  #$6F6,d0                        ; Otherwise, check if Sonic has gone far enough to the left
                bls.s   SKFBZ1FG_Mod1_BindIndoor
                bra.w   SKFBZ1FG_DrawForeground
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod1_OutdoorYGate:
                cmpi.w  #$9F2,d1                        ; If to the right of ranged area, instead check if Sonic has gone high enough
                bhi.w   SKFBZ1FG_DrawForeground

SKFBZ1FG_Mod1_BindIndoor:
                clr.w   (Events_bg+$02).w               ; In either case, go outdoors->indoors
                movea.w (a3),a5
                lea     $60(a5),a5
                movea.w (a3),a6
                lea     $64(a6),a6
                bra.s   SKFBZ1FG_Mod1_BeginLayoutCopy
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod1_BindOutdoor:
                st      (Events_bg+$02).w               ; Go indoors->outdoors
                movea.w $18(a3),a5
                lea     $60(a5),a5                      ; First source is at $300 Y, $3000 X
                movea.w $14(a3),a6
                lea     $64(a6),a6                      ; Second source is at $280 Y, $3200 X (both of these are technically out of range)

SKFBZ1FG_Mod1_BeginLayoutCopy:
                movea.w $48(a3),a1
                lea     $C(a1),a1                       ; First destination is $900 Y, $600 X
                move.w  -8(a3),d0
                subq.w  #4,d0                           ; Width of four tiles
                moveq   #6-1,d1                         ; Height of 6 tiles

SKFBZ1FG_Mod1_CopyLeftRows:
                move.l  (a5)+,(a1)+                     ; Copy over layout
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,SKFBZ1FG_Mod1_CopyLeftRows
                movea.w $48(a3),a1
                lea     $1A(a1),a1                      ; Second destination is $900 Y, $D00 X
                move.w  -8(a3),d0
                subq.w  #6,d0                           ; Width of 6 tiles
                moveq   #4-1,d1                         ; Height of 4 tiles

SKFBZ1FG_Mod1_CopyRightRows:
                move.l  (a6)+,(a1)+
                move.w  (a6)+,(a1)+                     ; Copy over layout
                adda.w  d0,a6
                adda.w  d0,a1
                dbf     d1,SKFBZ1FG_Mod1_CopyRightRows
                jmp     Refresh_PlaneScreenDirect(pc)   ; Refresh screen
; ---------------------------------------------------------------------------

FBZ1SE_LayoutMod2:
                lea     8(a1),a1                        ; The following layout mods all basically work identically to the above with modifications in positioning, etc
                jsr     FBZ1Screen_CheckInRange(pc)     ; I'll leave it as an exercise to the reader to get the specifics of each routine :)
                tst.w   (Events_bg+$02).w
                bne.s   SKFBZ1FG_Mod2_CheckOutdoorHalf
                cmpi.w  #$C80,d0
                bhs.s   SKFBZ1FG_Mod2_IndoorXGate
                cmpi.w  #$1F2,d1
                bhs.w   SKFBZ1FG_DrawForeground
                bra.s   SKFBZ1FG_Mod2_BindOutdoor
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod2_IndoorXGate:
                cmpi.w  #$108A,d0
                bls.w   SKFBZ1FG_DrawForeground
                bra.s   SKFBZ1FG_Mod2_BindOutdoor
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod2_CheckOutdoorHalf:
                cmpi.w  #$C80,d0
                bhs.s   SKFBZ1FG_Mod2_OutdoorXGate
                cmpi.w  #$20E,d1
                bhs.s   SKFBZ1FG_Mod2_BindIndoor
                bra.w   SKFBZ1FG_DrawForeground
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod2_OutdoorXGate:
                cmpi.w  #$1076,d0
                bhi.w   SKFBZ1FG_DrawForeground

SKFBZ1FG_Mod2_BindIndoor:
                clr.w   (Events_bg+$02).w
                movea.w (a3),a5
                lea     $6C(a5),a5
                movea.w (a3),a6
                lea     $76(a6),a6
                bra.s   SKFBZ1FG_Mod2_BeginLayoutCopy
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod2_BindOutdoor:
                st      (Events_bg+$02).w
                movea.w $14(a3),a5
                lea     $6C(a5),a5
                movea.w $10(a3),a6
                lea     $76(a6),a6

SKFBZ1FG_Mod2_BeginLayoutCopy:
                movea.w 8(a3),a1
                lea     $E(a1),a1
                move.w  -8(a3),d0
                subi.w  #$A,d0
                moveq   #4-1,d1

SKFBZ1FG_Mod2_CopyLeftRows:
                move.l  (a5)+,(a1)+
                move.l  (a5)+,(a1)+
                move.w  (a5)+,(a1)+
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,SKFBZ1FG_Mod2_CopyLeftRows
                movea.w $C(a3),a1
                lea     $1C(a1),a1
                move.w  -8(a3),d0
                subi.w  #$C,d0
                moveq   #3-1,d1

SKFBZ1FG_Mod2_CopyRightRows:
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                adda.w  d0,a6
                adda.w  d0,a1
                dbf     d1,SKFBZ1FG_Mod2_CopyRightRows
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

FBZ1SE_LayoutMod3:
                lea     $10(a1),a1
                jsr     FBZ1Screen_CheckInRange(pc)
                tst.w   (Events_bg+$02).w
                bne.s   SKFBZ1FG_Mod3_OutdoorXGate
                cmpi.w  #$1880,d0
                bhs.s   SKFBZ1FG_Mod3_IndoorYGate
                cmpi.w  #$158A,d0
                bls.w   SKFBZ1FG_DrawForeground
                bra.s   SKFBZ1FG_Mod3_BindOutdoor
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod3_IndoorYGate:
                cmpi.w  #$A0E,d1
                bls.w   SKFBZ1FG_DrawForeground
                bra.s   SKFBZ1FG_Mod3_BindOutdoor
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod3_OutdoorXGate:
                cmpi.w  #$1880,d0
                bhs.s   SKFBZ1FG_Mod3_OutdoorYGate
                cmpi.w  #$1576,d0
                bls.s   SKFBZ1FG_Mod3_BindIndoor
                bra.w   SKFBZ1FG_DrawForeground
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod3_OutdoorYGate:
                cmpi.w  #$9F2,d1
                bhi.w   SKFBZ1FG_DrawForeground

SKFBZ1FG_Mod3_BindIndoor:
                clr.w   (Events_bg+$02).w
                movea.w $34(a3),a5
                lea     $60(a5),a5
                movea.w $28(a3),a6
                lea     $66(a6),a6
                bra.s   SKFBZ1FG_Mod3_BeginLayoutCopy
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod3_BindOutdoor:
                st      (Events_bg+$02).w
                movea.w $44(a3),a5
                lea     $60(a5),a5
                movea.w $3C(a3),a6
                lea     $66(a6),a6

SKFBZ1FG_Mod3_BeginLayoutCopy:
                movea.w $48(a3),a1
                lea     $28(a1),a1
                move.w  -8(a3),d0
                subq.w  #6,d0
                moveq   #4-1,d1

SKFBZ1FG_Mod3_CopyFirstRows:
                move.l  (a5)+,(a1)+
                move.w  (a5)+,(a1)+
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,SKFBZ1FG_Mod3_CopyFirstRows
                movea.w $48(a3),a1
                lea     $34(a1),a1
                move.w  -8(a3),d0
                subq.w  #6,d0
                moveq   #4-1,d1

SKFBZ1FG_Mod3_CopySecondRows:
                move.l  (a6)+,(a1)+
                move.w  (a6)+,(a1)+
                adda.w  d0,a6
                adda.w  d0,a1
                dbf     d1,SKFBZ1FG_Mod3_CopySecondRows
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

FBZ1SE_LayoutMod4:
                lea     $18(a1),a1
                jsr     FBZ1Screen_CheckInRange(pc)
                tst.w   (Events_bg+$02).w
                bne.s   SKFBZ1FG_Mod4_CheckOutdoorHalf
                cmpi.w  #$208A,d0
                bhs.s   SKFBZ1FG_Mod4_BindOutdoor
                cmpi.w  #$1D80,d0
                bhs.s   SKFBZ1FG_Mod4_IndoorYGate
                cmpi.w  #$1C0A,d0
                bls.w   SKFBZ1FG_DrawForeground
                bra.s   SKFBZ1FG_Mod4_BindOutdoor
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod4_IndoorYGate:
                cmpi.w  #$F2,d1
                bhs.w   SKFBZ1FG_DrawForeground
                bra.s   SKFBZ1FG_Mod4_BindOutdoor
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod4_CheckOutdoorHalf:
                cmpi.w  #$1D80,d0
                bhs.s   SKFBZ1FG_Mod4_OutdoorXYGate
                cmpi.w  #$1BF6,d0
                bls.s   SKFBZ1FG_Mod4_BindIndoor
                bra.w   SKFBZ1FG_DrawForeground
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod4_OutdoorXYGate:
                cmpi.w  #$10E,d1
                bls.w   SKFBZ1FG_DrawForeground
                cmpi.w  #$2076,d0
                bhs.w   SKFBZ1FG_DrawForeground

SKFBZ1FG_Mod4_BindIndoor:
                clr.w   (Events_bg+$02).w
                movea.w $28(a3),a5
                lea     $6E(a5),a5
                movea.w $28(a3),a6
                lea     $76(a6),a6
                bra.s   SKFBZ1FG_Mod4_BeginLayoutCopy
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod4_BindOutdoor:
                st      (Events_bg+$02).w
                movea.w $3C(a3),a5
                lea     $6E(a5),a5
                movea.w $3C(a3),a6
                lea     $76(a6),a6

SKFBZ1FG_Mod4_BeginLayoutCopy:
                movea.w (a3),a1
                lea     $36(a1),a1
                move.w  -8(a3),d0
                subq.w  #8,d0
                moveq   #4-1,d1

SKFBZ1FG_Mod4_CopyLeftRows:
                move.l  (a5)+,(a1)+
                move.l  (a5)+,(a1)+
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,SKFBZ1FG_Mod4_CopyLeftRows
                movea.w (a3),a1
                lea     $3E(a1),a1
                move.w  -8(a3),d0
                subi.w  #$12,d0
                moveq   #5-1,d1

SKFBZ1FG_Mod4_CopyRightRows:
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                move.w  (a6)+,(a1)+
                adda.w  d0,a6
                adda.w  d0,a1
                dbf     d1,SKFBZ1FG_Mod4_CopyRightRows
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

FBZ1SE_LayoutMod5:
                lea     $20(a1),a1
                jsr     FBZ1Screen_CheckInRange(pc)
                cmpi.w  #$2100,d0
                blo.s   SKFBZ1FG_Mod5_CheckSwitchHeight
                cmpi.w  #$2600,d0
                bls.w   SKFBZ1FG_DrawForeground

SKFBZ1FG_Mod5_CheckSwitchHeight:
                tst.w   (Events_bg+$02).w
                bne.s   SKFBZ1FG_ReturnFifthLayoutIndoorsAtY018E
                cmpi.w  #$172,d1
                bhs.w   SKFBZ1FG_DrawForeground
                bra.s   SKFBZ1FG_Mod5_BindOutdoor
; ---------------------------------------------------------------------------

SKFBZ1FG_ReturnFifthLayoutIndoorsAtY018E:
                cmpi.w  #$18E,d1
                blo.w   SKFBZ1FG_DrawForeground
                clr.w   (Events_bg+$02).w
                movea.w $28(a3),a5
                lea     $6E(a5),a5
                movea.w $28(a3),a6
                lea     $76(a6),a6
                bra.s   SKFBZ1FG_Mod5_BeginLayoutCopy
; ---------------------------------------------------------------------------

SKFBZ1FG_Mod5_BindOutdoor:
                st      (Events_bg+$02).w
                movea.w $3C(a3),a5
                lea     $6E(a5),a5
                movea.w $3C(a3),a6
                lea     $76(a6),a6

SKFBZ1FG_Mod5_BeginLayoutCopy:
                movea.w (a3),a1
                lea     $36(a1),a1
                move.w  -8(a3),d0
                subq.w  #8,d0
                moveq   #4-1,d1

SKFBZ1FG_Mod5_CopyLeftRows:
                move.l  (a5)+,(a1)+
                move.l  (a5)+,(a1)+
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,SKFBZ1FG_Mod5_CopyLeftRows
                movea.w (a3),a1
                lea     $3E(a1),a1
                move.w  -8(a3),d0
                subi.w  #$12,d0
                moveq   #5-1,d1

SKFBZ1FG_Mod5_CopyRightRows:
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                move.l  (a6)+,(a1)+
                move.w  (a6)+,(a1)+
                adda.w  d0,a6
                adda.w  d0,a1
                dbf     d1,SKFBZ1FG_Mod5_CopyRightRows
                jmp     Refresh_PlaneScreenDirect(pc)
; ---------------------------------------------------------------------------

FBZ1SE_LayoutMod6:
                lea     $28(a1),a1                      ; Get the last layout change range
                jsr     FBZ1Screen_CheckInRange(pc)     ; Ensure player is still in specified range
                tst.w   (Events_bg+$02).w
                bne.s   SKFBZ1FG_TryRestoreIndoorStart
                cmpi.w  #$70E,d1                        ; If "indoors", check if Sonic is below given point
                bls.w   SKFBZ1FG_DrawForeground         ; If not, don't do anything
                bra.s   SKFBZ1FG_BindOutdoorStart
; ---------------------------------------------------------------------------

SKFBZ1FG_TryRestoreIndoorStart:
                cmpi.w  #$6F2,d1                        ; If "outdoors" flag is set, check if Sonic is above point given
                bhi.w   SKFBZ1FG_DrawForeground         ; If not, don't do anything
                clr.w   (Events_bg+$02).w               ; Make Sonic "indoors"
                movea.w $48(a3),a5                      ; Perform layout copy of indoor tiles
                bra.s   SKFBZ1FG_BeginStartLayoutCopy
; ---------------------------------------------------------------------------

SKFBZ1FG_BindOutdoorStart:
                st      (Events_bg+$02).w               ; Make Sonic "outdoors"
                movea.w $54(a3),a5                      ; Perform layout copy of outdoor tiles

SKFBZ1FG_BeginStartLayoutCopy:
                movea.w $34(a3),a1
                move.w  -8(a3),d0
                subq.w  #5,d0
                moveq   #3-1,d1

SKFBZ1FG_CopyAndRefreshStart:
                move.l  (a5)+,(a1)+
                move.b  (a5)+,(a1)+                     ; Perform layout copy
                adda.w  d0,a5
                adda.w  d0,a1
                dbf     d1,SKFBZ1FG_CopyAndRefreshStart
                jmp     Refresh_PlaneScreenDirect(pc)   ; Redraw screen directly

; =============== S U B R O U T I N E =======================================

FBZ1Screen_CheckInRange:
                cmp.w   (a1)+,d0
                blo.s   SKFBZ1FG_CancelLayoutEvent
                cmp.w   (a1)+,d0
                bhi.s   SKFBZ1FG_CancelLayoutEvent
                cmp.w   (a1)+,d1
                blo.s   SKFBZ1FG_CancelLayoutEvent
                cmp.w   (a1)+,d1
                bhi.s   SKFBZ1FG_CancelLayoutEvent
                rts
; ---------------------------------------------------------------------------

; Discard the range check's return address and resume ordinary foreground drawing
SKFBZ1FG_CancelLayoutEvent:
                addq.w  #4,sp
                clr.w   (Events_bg+$00).w

SKFBZ1FG_DrawForeground:
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
