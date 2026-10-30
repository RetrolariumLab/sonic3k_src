; Owner: game/level/s3
; Responsibility: Zone and act camera-bound event dispatch, character-specific limits and shared maximum-height adjustment
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Do_ResizeEvents:
                moveq   #0,d0
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #6,d0
; Bug: this clamps the array index too hard, causing Competition and bonus
; stages to execute resize routines meant for the early game levels
                andi.w  #$3E,d0
                move.w  LevelResizeArray(pc,d0.w),d0
                jsr     LevelResizeArray(pc,d0.w)
                moveq   #2,d1
                move.w  (Camera_target_max_Y_pos).w,d0
                sub.w   (Camera_max_Y_pos).w,d0
                beq.s   locret_1A880
                bcc.s   loc_1A882
                neg.w   d1
                move.w  (Camera_Y_pos).w,d0
                cmp.w   (Camera_target_max_Y_pos).w,d0
                bls.s   loc_1A876
                move.w  d0,(Camera_max_Y_pos).w
                andi.w  #$FFFE,(Camera_max_Y_pos).w

loc_1A876:
                add.w   d1,(Camera_max_Y_pos).w
                move.b  #1,(Camera_max_Y_pos_changing).w

locret_1A880:
                rts
; ---------------------------------------------------------------------------

loc_1A882:
                move.w  (Camera_Y_pos).w,d0
                addi.w  #8,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                blo.s   loc_1A89C
                btst    #1,(Player_1+status).w
                beq.s   loc_1A89C
                add.w   d1,d1
                add.w   d1,d1

loc_1A89C:
                add.w   d1,(Camera_max_Y_pos).w
                move.b  #1,(Camera_max_Y_pos_changing).w
                rts
; ---------------------------------------------------------------------------
LevelResizeArray:
                dc.w    AIZ1_Resize-LevelResizeArray
                dc.w    AIZ2_Resize-LevelResizeArray
                dc.w    HCZ1_Resize-LevelResizeArray
                dc.w    HCZ2_Resize-LevelResizeArray
                dc.w    MGZ1_Resize-LevelResizeArray
                dc.w    MGZ2_Resize-LevelResizeArray
                dc.w    CNZ1_Resize-LevelResizeArray
                dc.w    CNZ2_Resize-LevelResizeArray
                dc.w    FBZ1_Resize-LevelResizeArray
                dc.w    FBZ2_Resize-LevelResizeArray
                dc.w    ICZ1_Resize-LevelResizeArray
                dc.w    ICZ2_Resize-LevelResizeArray
                dc.w    LBZ1_Resize-LevelResizeArray
                dc.w    LBZ2_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
                dc.w    No_Resize-LevelResizeArray
; ---------------------------------------------------------------------------

AIZ1_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  AIZ1_Resize_Index(pc,d0.w),d0
                jmp     AIZ1_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
AIZ1_Resize_Index:
                dc.w    loc_1A920-AIZ1_Resize_Index
                dc.w    loc_1A96C-AIZ1_Resize_Index
                dc.w    loc_1A9EC-AIZ1_Resize_Index
                dc.w    loc_1AA40-AIZ1_Resize_Index
                dc.w    loc_1AA7C-AIZ1_Resize_Index
; ---------------------------------------------------------------------------

loc_1A920:
                move.b  #1,(AIZ1_palette_cycle_flag).w
                cmpi.w  #$1000,(Camera_X_pos).w
                blo.s   locret_1A96A
                move.b  #0,(AIZ1_palette_cycle_flag).w
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                cmpi.w  #$1308,(Camera_X_pos).w
                blo.s   locret_1A96A
                tst.b   (Last_star_post_hit).w
                bne.s   loc_1A958
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_1A958
                moveq   #PLCID_0B,d0
                jsr     (Load_PLC).l

loc_1A958:
                moveq   #PalID_AIZ,d0
                jsr     (LoadPalette_Immediate).l
                move.w  #2,(Tails_CPU_routine).w
                addq.b  #2,(Dynamic_resize_routine).w

locret_1A96A:
                rts
; ---------------------------------------------------------------------------

loc_1A96C:
                move.w  #$1308,(Camera_min_X_pos).w
                cmpi.w  #$1400,(Camera_X_pos).w
                blo.s   locret_1A9EA
                tst.b   (Last_star_post_hit).w
                bne.s   loc_1A9BE
                cmpi.w  #2,(Player_mode).w
                beq.s   loc_1A9BE
                lea     (AIZ1_16x16_MainLevel_Kos).l,a1
                lea     (Block_table+$268).w,a2
                jsr     (Queue_Kos).l
                lea     (AIZ1_8x8_MainLevel_KosM).l,a1
                move.w  #tiles_to_bytes($0BE),d2
                jsr     (Queue_Kos_Module).l
                st      (Events_fg_5).w
                move.w  #$500,(Anim_Counters).w
                move.w  #$500,(Anim_Counters+2).w
                move.w  #$500,(Anim_Counters+4).w

loc_1A9BE:
                move.b  #1,(Last_star_post_hit).w
                move.w  #$13A0,(Saved_X_pos).w
                move.w  #$41A,(Saved_Y_pos).w
                jsr     (Save_Level_Data).l
                move.l  #0,(Saved_timer).w
                moveq   #PLCID_08,d0
                jsr     (Load_PLC).l
                addq.b  #2,(Dynamic_resize_routine).w

locret_1A9EA:
                rts
; ---------------------------------------------------------------------------

loc_1A9EC:
                lea     (word_1AA84).l,a1
                bsr.w   Resize_MaxYFromX
                move.w  #0,(Camera_min_Y_pos).w
                move.w  #$20E,(Normal_palette_line_3+$1E).w
                cmpi.w  #$2B00,(Camera_X_pos).w
                blo.s   loc_1AA10
                move.w  #4,(Normal_palette_line_3+$1E).w

loc_1AA10:
                cmpi.w  #$2C00,(Camera_X_pos).w
                blo.s   loc_1AA1E
                move.w  #$2E0,(Camera_min_Y_pos).w

loc_1AA1E:
                cmpi.w  #$2D80,(Camera_X_pos).w
                blo.s   locret_1AA3E
                move.w  #$C02,(Normal_palette_line_3+$1E).w
                move.w  #$2D80,(Camera_min_X_pos).w
                moveq   #PLCID_5A,d0
                jsr     (Load_PLC).l
                addq.b  #2,(Dynamic_resize_routine).w

locret_1AA3E:
                rts
; ---------------------------------------------------------------------------

loc_1AA40:
                lea     (word_1AA84).l,a1
                bsr.w   Resize_MaxYFromX
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                cmpi.w  #$2E00,(Camera_X_pos).w
                blo.s   locret_1AA7A
                tst.b   (Kos_modules_left).w
                bne.s   locret_1AA7A
                lea     (AIZ1_8x8_Flames_KosM).l,a1
                move.w  #tiles_to_bytes($500),d2
                jsr     (Queue_Kos_Module).l
                moveq   #PLCID_0C,d0
                jsr     (Load_PLC).l
                addq.b  #2,(Dynamic_resize_routine).w

locret_1AA7A:
                rts
; ---------------------------------------------------------------------------

loc_1AA7C:
                move.w  (Camera_X_pos).w,(Camera_min_X_pos).w
                rts
; ---------------------------------------------------------------------------
word_1AA84:
                dc.w    $8390, $1650
                dc.w    $83B0, $1B00
                dc.w    $8430, $2000
                dc.w    $84C0, $2B00
                dc.w    $83B0, $2D80
                dc.w    $82E0, $FFFF
; ---------------------------------------------------------------------------

AIZ2_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  AIZ2_Resize_Index(pc,d0.w),d0
                jmp     AIZ2_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
AIZ2_Resize_Index:
                dc.w    AIZ2_Resize1-AIZ2_Resize_Index
                dc.w    AIZ2_Resize2-AIZ2_Resize_Index
                dc.w    AIZ2_Resize3-AIZ2_Resize_Index
                dc.w    AIZ2_Resize4-AIZ2_Resize_Index
                dc.w    AIZ2_Resize5-AIZ2_Resize_Index
                dc.w    AIZ2_Resize6-AIZ2_Resize_Index
                dc.w    AIZ2_Resize7-AIZ2_Resize_Index
                dc.w    AIZ2_Resize8-AIZ2_Resize_Index
                dc.w    AIZ2_ResizeEnd-AIZ2_Resize_Index
; ---------------------------------------------------------------------------

AIZ2_Resize1:
                cmpi.w  #$380,(Camera_X_pos).w
                blo.s   locret_1AAF2
                move.w  #$4F0,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                addq.b  #2,(Dynamic_resize_routine).w   ; Set level height to normal when past the open field
                cmpi.w  #1,(Apparent_zone_and_act).w    ; If non-internal level is not AIZ2, then the miniboss hasn't been defeated yet
                bne.s   locret_1AAF2
                move.w  #$590,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  #$F50,(Camera_min_X_pos).w      ; Put $F50 as the start X
                addq.b  #2,(Dynamic_resize_routine).w

locret_1AAF2:
                rts
; ---------------------------------------------------------------------------

AIZ2_Resize2:
                cmpi.w  #$300,(Camera_Y_pos).w
                bcc.s   loc_1AB48
                move.w  #$590,d0
                cmpi.w  #$ED0,(Camera_X_pos).w
                blo.s   loc_1AB0C
                move.w  #$2B8,d0                        ; Set level height to 2B8 when boss is approached

loc_1AB0C:
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                cmpi.w  #$F50,(Camera_X_pos).w
                blo.s   locret_1AB46
                move.w  #$F50,(Camera_min_X_pos).w      ; When boss has been reached, lock the screen
                tst.w   (Debug_placement_mode).w        ; If in debug mode, don't load boss
                bne.s   loc_1AB42
                jsr     (AllocateObject).l
                bne.s   loc_1AB42
                move.l  #Obj_AIZMiniboss,(a1)           ; Make the miniboss
                move.w  #$11F0,x_pos(a1)
                move.w  #$289,y_pos(a1)                 ; Set the position for Sonic's area area

loc_1AB42:
                addq.b  #2,(Dynamic_resize_routine).w

locret_1AB46:
                rts
; ---------------------------------------------------------------------------

loc_1AB48:
                move.w  #$590,d0
                cmpi.w  #$ED0,(Camera_X_pos).w
                bcs.s   loc_1AB58
                move.w  #$450,d0

loc_1AB58:
                cmpi.w  #$11A0,(Camera_X_pos).w
                bcs.s   loc_1AB70
                move.w  #$820,d0
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  #$F80,(Target_water_level).w
                rts
; ---------------------------------------------------------------------------

loc_1AB70:
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                rts
; ---------------------------------------------------------------------------

AIZ2_Resize3:
                cmpi.w  #$1500,(Camera_X_pos).w
                blo.s   locret_1AB92
                move.w  #$630,(Camera_max_Y_pos).w      ; Set the level height to $630 when playing as Sonic past $1500
                move.w  #$630,(Camera_target_max_Y_pos).w
                addq.b  #2,(Dynamic_resize_routine).w

locret_1AB92:
                rts
; ---------------------------------------------------------------------------

AIZ2_Resize4:
                cmpi.w  #$3C00,(Camera_X_pos).w
                blo.s   locret_1ABE2
                tst.b   (Kos_modules_left).w            ; When $3C00 X is passed
                bne.s   locret_1ABE2
                lea     (AIZ2_16x16_BomberShip_Kos).l,a1  ; If KosM queue is clear
                lea     (Block_table+$AB8).w,a2
                jsr     (Queue_Kos).l
                lea     (AIZ2_8x8_BomberShip_KosM).l,a1
                move.w  #tiles_to_bytes($1FC),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_AIZ2Bombership2_8x8).l,a1
                move.w  #tiles_to_bytes(ArtTile_AIZ2Bombership),d2
                jsr     (Queue_Kos_Module).l            ; Load all battleship art
                moveq   #PalID_AIZBoss,d0
                jsr     (LoadPalette_Immediate).l       ; Load palette
                st      (Events_fg_5).w                 ; Send signal to background event
                addq.b  #2,(Dynamic_resize_routine).w

locret_1ABE2:
                rts
; ---------------------------------------------------------------------------

AIZ2_Resize5:
                cmpi.w  #$3F00,(Camera_X_pos).w
                blo.s   locret_1ABFC
                move.w  #$15A,d0                        ; When past $3F00 X, set top of level to $15A
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_target_min_Y_pos).w
                addq.b  #2,(Dynamic_resize_routine).w

locret_1ABFC:
                rts
; ---------------------------------------------------------------------------

AIZ2_Resize6:
                cmpi.w  #$4000,(Camera_X_pos).w
                blo.s   locret_1AC16
                move.w  #$15A,d0
                move.w  d0,(Camera_max_Y_pos).w         ; When past $4000 X, set bottom of level to $15A
                move.w  d0,(Camera_target_max_Y_pos).w
                addq.b  #2,(Dynamic_resize_routine).w

locret_1AC16:
                rts
; ---------------------------------------------------------------------------

AIZ2_Resize7:
                cmpi.w  #$4160,(Camera_X_pos).w
                blo.s   locret_1AC28
                st      (Events_fg_4).w                 ; When past $4160, send signal to screen event to start the battleship sequence
                addq.b  #2,(Dynamic_resize_routine).w

locret_1AC28:
                rts
; ---------------------------------------------------------------------------

AIZ2_Resize8:
                cmpi.w  #$4780,(Camera_X_pos).w
                blo.s   locret_1AC36
                addq.b  #2,(Dynamic_resize_routine).w

locret_1AC36:
                rts
; ---------------------------------------------------------------------------

AIZ2_ResizeEnd:
                rts
; ---------------------------------------------------------------------------

HCZ1_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  HCZ1_Resize_Index(pc,d0.w),d0
                jmp     HCZ1_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
HCZ1_Resize_Index:
                dc.w    loc_1AC4E-HCZ1_Resize_Index
                dc.w    loc_1AC74-HCZ1_Resize_Index
                dc.w    locret_1ACB0-HCZ1_Resize_Index
; ---------------------------------------------------------------------------

loc_1AC4E:
                cmpi.w  #$360,(Camera_X_pos).w
                bhs.s   locret_1AC72
                cmpi.w  #$3E0,(Camera_Y_pos).w
                blo.s   locret_1AC72
                lea     (Normal_palette_line_4+$10).w,a1
; Bug: this should be $680
                move.w  #$B80,(a1)+
                move.w  #$240,(a1)+
                move.w  #$220,(a1)+
                addq.b  #2,(Dynamic_resize_routine).w

locret_1AC72:
                rts
; ---------------------------------------------------------------------------

loc_1AC74:
                cmpi.w  #$360,(Camera_X_pos).w
                bhs.s   loc_1AC8A
                cmpi.w  #$3E0,(Camera_Y_pos).w
                bhs.s   locret_1ACAE
                subq.b  #2,(Dynamic_resize_routine).w
                bra.s   loc_1AC9E
; ---------------------------------------------------------------------------

loc_1AC8A:
                cmpi.w  #$500,(Camera_Y_pos).w
                blo.s   locret_1ACAE
                cmpi.w  #$900,(Camera_X_pos).w
                blo.s   locret_1ACAE
                addq.b  #2,(Dynamic_resize_routine).w

loc_1AC9E:
                lea     (Normal_palette_line_4+$10).w,a1
                move.w  #$CEE,(a1)+
                move.w  #$ACE,(a1)+
                move.w  #$8A,(a1)+

locret_1ACAE:
                rts
; ---------------------------------------------------------------------------

locret_1ACB0:
                rts
; ---------------------------------------------------------------------------

HCZ2_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  HCZ2_Resize_Index(pc,d0.w),d0
                jmp     HCZ2_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
HCZ2_Resize_Index:
                dc.w    loc_1ACC4-HCZ2_Resize_Index
                dc.w    locret_1ACD6-HCZ2_Resize_Index
; ---------------------------------------------------------------------------

loc_1ACC4:
                cmpi.w  #$C00,(Camera_X_pos).w
                blo.s   locret_1ACD4
                st      (Events_fg_5).w
                addq.b  #2,(Dynamic_resize_routine).w

locret_1ACD4:
                rts
; ---------------------------------------------------------------------------

locret_1ACD6:
                rts
; ---------------------------------------------------------------------------

MGZ1_Resize:
; Bug: MGZ1 uses a dynamic resize routine meant for MGZ2
; This causes the act 2 boss to spawn in out-of-bounds act 1

MGZ2_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  MGZ2_Resize_Index(pc,d0.w),d0
                jmp     MGZ2_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
MGZ2_Resize_Index:
                dc.w    loc_1ACEC-MGZ2_Resize_Index
                dc.w    loc_1AD2A-MGZ2_Resize_Index
                dc.w    locret_1AD84-MGZ2_Resize_Index
; ---------------------------------------------------------------------------

loc_1ACEC:
                move.w  (Camera_Y_pos).w,d0
                cmpi.w  #$600,d0
                blo.s   locret_1AD28
                cmpi.w  #$700,d0
                bhs.s   locret_1AD28
                cmpi.w  #$3A00,(Camera_X_pos).w
                blo.s   locret_1AD28
                move.w  #$6A0,d0
                move.w  d0,(Camera_min_Y_pos).w
                move.w  d0,(Camera_target_min_Y_pos).w
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  #$3C80,d0
                move.w  d0,(Camera_max_X_pos).w
                move.w  d0,(Camera_target_max_X_pos).w
                addq.b  #2,(Dynamic_resize_routine).w

locret_1AD28:
                rts
; ---------------------------------------------------------------------------

loc_1AD2A:
                cmpi.w  #$3A00,(Camera_X_pos).w
                blo.s   loc_1AD64
                move.w  #$3C80,d0
                cmp.w   (Camera_X_pos).w,d0
                bhi.s   locret_1AD82
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_target_min_X_pos).w
                jsr     (AllocateObject).l
                bne.s   loc_1AD5E
                move.l  #Obj_MGZEndBoss,(a1)
                move.w  #$3D20,x_pos(a1)
                move.w  #$668,y_pos(a1)

loc_1AD5E:
                addq.b  #2,(Dynamic_resize_routine).w
                rts
; ---------------------------------------------------------------------------

loc_1AD64:
                move.l  #$1000,d0
                move.l  d0,(Camera_min_Y_pos).w
                move.l  d0,(Camera_target_min_Y_pos).w
                move.w  #$6000,d0
                move.w  d0,(Camera_max_X_pos).w
                move.w  d0,(Camera_target_max_X_pos).w
                subq.b  #2,(Dynamic_resize_routine).w

locret_1AD82:
                rts
; ---------------------------------------------------------------------------

locret_1AD84:
                rts
; ---------------------------------------------------------------------------

CNZ1_Resize:
CNZ2_Resize:
FBZ1_Resize:
FBZ2_Resize:
                rts
; ---------------------------------------------------------------------------

ICZ1_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  ICZ1_Resize_Index(pc,d0.w),d0
                jmp     ICZ1_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
ICZ1_Resize_Index:
                dc.w    loc_1AD9C-ICZ1_Resize_Index
                dc.w    loc_1ADB6-ICZ1_Resize_Index
                dc.w    locret_1ADC8-ICZ1_Resize_Index
; ---------------------------------------------------------------------------

loc_1AD9C:
                cmpi.w  #$3700,(Camera_X_pos).w
                blo.s   locret_1ADB4
                cmpi.w  #$68C,(Camera_Y_pos).w
                blo.s   locret_1ADB4
                st      (Events_fg_5).w
                addq.b  #2,(Dynamic_resize_routine).w

locret_1ADB4:
                rts
; ---------------------------------------------------------------------------

loc_1ADB6:
                cmpi.w  #$3940,(Camera_X_pos).w
                blo.s   locret_1ADC6
                st      (Events_fg_5).w
                addq.b  #2,(Dynamic_resize_routine).w

locret_1ADC6:
                rts
; ---------------------------------------------------------------------------

locret_1ADC8:
                rts
; ---------------------------------------------------------------------------

ICZ2_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  ICZ2_Resize_Index(pc,d0.w),d0
                jmp     ICZ2_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
ICZ2_Resize_Index:
                dc.w    loc_1ADDC-ICZ2_Resize_Index
                dc.w    locret_1ADF8-ICZ2_Resize_Index
; ---------------------------------------------------------------------------

loc_1ADDC:
                cmpi.w  #$740,(Camera_X_pos).w
                blo.s   locret_1ADF6
                cmpi.w  #$400,(Camera_Y_pos).w
                bhs.s   locret_1ADF6
                move.w  #$740,(Camera_min_X_pos).w
                addq.b  #2,(Dynamic_resize_routine).w

locret_1ADF6:
                rts
; ---------------------------------------------------------------------------

locret_1ADF8:
                rts
; ---------------------------------------------------------------------------

LBZ1_Resize:
                rts
; ---------------------------------------------------------------------------

LBZ2_Resize:
                moveq   #0,d0
                move.b  (Dynamic_resize_routine).w,d0
                move.w  LBZ2_Resize_Index(pc,d0.w),d0
                jmp     LBZ2_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------
LBZ2_Resize_Index:
                dc.w    loc_1AE0E-LBZ2_Resize_Index
                dc.w    locret_1AE66-LBZ2_Resize_Index
; ---------------------------------------------------------------------------

loc_1AE0E:
                cmpi.w  #$3BC0,(Camera_X_pos).w
                bcs.s   locret_1AE64
                cmpi.w  #$500,(Camera_Y_pos).w
                bcs.s   locret_1AE64
                addq.b  #2,(Dynamic_resize_routine).w
                lea     (LBZ2_16x16_DeathEgg_Kos).l,a1
                lea     (Block_table).w,a2
                jsr     (Queue_Kos).l
                lea     (LBZ2_128x128_DeathEgg_Kos).l,a1
                lea     (RAM_start).l,a2
                jsr     (Queue_Kos).l
                lea     (LBZ2_8x8_DeathEgg_KosM).l,a1
                move.w  #tiles_to_bytes($000),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_LBZ2DeathEgg2_8x8).l,a1
                move.w  #tiles_to_bytes(ArtTile_Explosion),d2
                jsr     (Queue_Kos_Module).l

locret_1AE64:
                rts
; ---------------------------------------------------------------------------

locret_1AE66:
                rts
; ---------------------------------------------------------------------------

No_Resize:
                rts

; =============== S U B R O U T I N E =======================================

Resize_MaxYFromX:
                move.w  (Camera_X_pos).w,d0

loc_1AE6E:
                move.l  (a1)+,d1
                cmp.w   d1,d0
                bhi.s   loc_1AE6E
                swap    d1
                tst.w   d1
                bpl.s   loc_1AE82
                andi.w  #$7FFF,d1
                move.w  d1,(Camera_max_Y_pos).w

loc_1AE82:
                move.w  d1,(Camera_target_max_Y_pos).w
                rts
; End of function Resize_MaxYFromX
