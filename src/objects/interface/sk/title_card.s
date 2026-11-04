; Owner: objects/interface/sk
; Responsibility: Title-card initialization, coordinated banner and text sprites, act display and object catalogs
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_TitleCard:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  TitleCard_Index(pc,d0.w),d1
                jmp     TitleCard_Index(pc,d1.w)
; ---------------------------------------------------------------------------
TitleCard_Index:
                dc.w    Obj_TitleCardInit-TitleCard_Index
                dc.w    Obj_TitleCardCreate-TitleCard_Index
                dc.w    Obj_TitleCardWait-TitleCard_Index
                dc.w    Obj_TitleCardWait2-TitleCard_Index
; ---------------------------------------------------------------------------

Obj_TitleCardInit:
                cmpi.w  #$D01,(Current_zone_and_act).w
                beq.s   SKTitleCard_DeleteSuppressed    ; if we're in the ending, don't show title card
                cmpi.b  #$E,(Current_zone).w
                blo.s   SKTitleCard_QueueInitialPanelArt  ; If in any of the 2P stages, don't show title card
                cmpi.b  #$12,(Current_zone).w
                bhi.s   SKTitleCard_QueueInitialPanelArt
                st      $44(a0)

SKTitleCard_DeleteSuppressed:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKTitleCard_QueueInitialPanelArt:
                lea     (ArtKosM_TitleCardRedAct).l,a1
                move.w  #tiles_to_bytes($500),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_TitleCardSKZone).l,a1
                tst.w   (SK_alone_flag).w
                bne.s   SKTitleCard_QueueMarkAndPickActArt
                lea     (ArtKosM_TitleCardS3KZone).l,a1

SKTitleCard_QueueMarkAndPickActArt:
                move.w  #tiles_to_bytes($510),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_TitleCardNum2).l,a1
                cmpi.w  #$1600,(Current_zone_and_act).w
                beq.s   SKTitleCard_QueueActAndPickNameArt
                cmpi.w  #$1700,(Current_zone_and_act).w
                beq.s   SKTitleCard_QueueActAndPickNameArt  ; Death Egg Boss and LRZ Boss show act 2
                tst.b   (Apparent_act).w
                bne.s   SKTitleCard_QueueActAndPickNameArt
                lea     (ArtKosM_TitleCardNum1).l,a1

SKTitleCard_QueueActAndPickNameArt:
                move.w  #tiles_to_bytes($53D),d2
                jsr     (Queue_Kos_Module).l
                lea     TitleCard_LevelGfx(pc),a1
                moveq   #9,d0
                cmpi.w  #$1600,(Current_zone_and_act).w  ; If in LRZ's boss, set it to Lava Reef's card
                beq.s   SKTitleCard_QueueNameAndArmCreate
                moveq   #$D,d0
                cmpi.w  #$1601,(Current_zone_and_act).w  ; If in Hidden Palace, set it to its card
                beq.s   SKTitleCard_QueueNameAndArmCreate
                moveq   #$B,d0
                cmpi.w  #$1700,(Current_zone_and_act).w  ; If in Death Egg boss, set it to Death Egg's card
                beq.s   SKTitleCard_QueueNameAndArmCreate
                move.b  (Apparent_zone_and_act).w,d0    ; Otherwise, just use current zone

SKTitleCard_QueueNameAndArmCreate:
                lsl.w   #2,d0
                movea.l (a1,d0.w),a1
                move.w  #tiles_to_bytes($54D),d2
                jsr     (Queue_Kos_Module).l
                move.w  #90,$2E(a0)                     ; Set wait value
                clr.w   $32(a0)
                st      $48(a0)
                addq.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

Obj_TitleCardCreate:
                tst.b   (Kos_modules_left).w
                bne.w   SKTitleCard_CreateWaitReturn    ; Wait for KosM queue to clear
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKTitleCard_CreateWaitReturn
                cmpi.b  #$16,(Current_zone).w
                beq.s   SKTitleCard_SelectElementArray
                cmpi.w  #$1700,(Current_zone_and_act).w
                beq.s   SKTitleCard_SelectElementArray
                lea     ObjArray_TtlCardBonus(pc),a2
                moveq   #1,d1
                cmpi.b  #$13,(Current_zone).w
                bhs.s   SKTitleCard_InitAndCountElement

SKTitleCard_SelectElementArray:
                lea     ObjArray_TtlCard(pc),a2
                moveq   #3,d1
                tst.b   $44(a0)
                beq.s   SKTitleCard_InitAndCountElement
                lea     ObjArray_TtlCard2(pc),a2
                moveq   #0,d1

; The live-child count records only successful allocations
SKTitleCard_InitAndCountElement:
                addq.w  #1,$30(a0)
                move.l  (a2)+,(a1)
                move.w  (a2)+,$46(a1)
                move.w  (a2)+,x_pos(a1)
                move.w  (a2)+,y_pos(a1)
                move.b  (a2)+,mapping_frame(a1)
                move.b  (a2)+,width_pixels(a1)
                move.w  (a2)+,d2
                move.b  d2,$28(a1)
                move.b  #$40,render_flags(a1)
                move.l  #Map_TitleCard,mappings(a1)
                move.w  a0,parent2(a1)
                jsr     (CreateNewSprite4).l
                dbne    d1,SKTitleCard_InitAndCountElement
                tst.b   $3E(a0)
                beq.s   SKTitleCard_BeginArrivalWait
                cmpi.b  #6,(Current_zone).w
                bne.s   SKTitleCard_BeginArrivalWait
                moveq   #PLCID_25,d0                    ; If title card is mid-level and it's in LBZ, load the LBZ 2 misc art
                jsr     (Load_PLC).l

SKTitleCard_BeginArrivalWait:
                addq.b  #2,routine(a0)

SKTitleCard_CreateWaitReturn:
                rts
; ---------------------------------------------------------------------------

Obj_TitleCardWait:
                tst.w   $34(a0)
                beq.s   SKTitleCard_ResetMidlevelCounters
                clr.w   $34(a0)
                rts
; ---------------------------------------------------------------------------

SKTitleCard_ResetMidlevelCounters:
                tst.w   $3E(a0)
                beq.s   SKTitleCard_ClearLoadingAndBeginHold
                clr.l   (Timer).w                       ; If using in-level title card
                clr.w   (Ring_count).w                  ; Reset HUD rings and timer
                clr.w   (Total_ring_count).w            ; Reset number of collected rings
                clr.b   (Extra_life_flags).w            ; Reset extra life ring flag
                clr.l   (Timer_P2).w
                clr.w   (Ring_count_P2).w               ; Reset actual rings and timer values
                clr.w   (Total_ring_count_P2).w
                st      (Update_HUD_timer).w
                st      (Update_HUD_ring_count).w       ; Start updating timer and rings again
                move.b  #30,(Player_1+air_left).w
                move.b  #30,(Player_2+air_left).w       ; Reset air
                jsr     (Restore_LevelMusic).l          ; Play music

SKTitleCard_ClearLoadingAndBeginHold:
                clr.w   $48(a0)
                addq.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

Obj_TitleCardWait2:
                tst.w   $2E(a0)
                beq.s   SKTitleCard_TickExitAndCheckChildren
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

SKTitleCard_TickExitAndCheckChildren:
                tst.w   $30(a0)
                beq.s   SKTitleCard_SelectPostTitleResources
                addq.w  #1,$32(a0)
                rts
; ---------------------------------------------------------------------------

SKTitleCard_SelectPostTitleResources:
                tst.b   $44(a0)
                bne.s   SKTitleCard_DeleteTitleParent
                cmpi.w  #$801,(Current_zone_and_act).w
                bne.s   SKTitleCard_CheckPostTitleReload
                jsr     (AllocateObject).l
                bne.s   SKTitleCard_CheckPostTitleReload
                move.l  #Hyudoro,(a1)                   ; If new level is Sandopolis 2, then load the ghosts

SKTitleCard_CheckPostTitleReload:
                cmpi.b  #$16,(Current_zone).w
                beq.s   SKTitleCard_FinishMidlevelOrReload
                cmpi.w  #$1700,(Current_zone_and_act).w
                beq.s   SKTitleCard_FinishMidlevelOrReload
                cmpi.b  #$13,(Current_zone).w
                bhs.s   SKTitleCard_DeleteTitleParent

SKTitleCard_FinishMidlevelOrReload:
                tst.w   $3E(a0)
                beq.s   SKTitleCard_TryReloadSpikesAndSprings
                st      (End_of_level_flag).w           ; If in-level, set end of title card flag. No need to reload PLCs
                bra.s   SKTitleCard_LoadEnemyAndAnimalArt
; ---------------------------------------------------------------------------

SKTitleCard_TryReloadSpikesAndSprings:
                cmpi.b  #$C,(Current_zone).w
                beq.s   SKTitleCard_DeleteTitleParent
                cmpi.w  #$1700,(Current_zone_and_act).w
                beq.s   SKTitleCard_DeleteTitleParent
                lea     (PLC_SpikesSprings).l,a1        ; Reload spikes in all but DEZ boss and Doomsday
                jsr     (Load_PLC_Raw).l

SKTitleCard_LoadEnemyAndAnimalArt:
                cmpi.w  #$1700,(Current_zone_and_act).w
                beq.s   SKTitleCard_DeleteTitleParent
                jsr     LoadEnemyArt(pc)                ; Load animals and enemies in all but DEZ boss
                jsr     (PLCLoad_AnimalsAndExplosion).l

SKTitleCard_DeleteTitleParent:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_TitleCardRedBanner:
                movea.w parent2(a0),a1
                move.w  $32(a1),d0
                beq.s   SKTitleCard_MoveBannerDownToTarget
                tst.b   render_flags(a0)
                bmi.s   SKTitleCard_MoveBannerUpAfterDelay
                subq.w  #1,$30(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

; Use the low byte of the departure clock for the delay
SKTitleCard_MoveBannerUpAfterDelay:
                cmp.b   $28(a0),d0
                blo.s   SKTitleCard_SetBannerHeightAndDraw
                subi.w  #$20,y_pos(a0)
                bra.s   SKTitleCard_SetBannerHeightAndDraw
; ---------------------------------------------------------------------------

SKTitleCard_MoveBannerDownToTarget:
                move.w  y_pos(a0),d0
                cmp.w   $46(a0),d0
                beq.s   SKTitleCard_SetBannerHeightAndDraw
                addi.w  #$10,d0
                move.w  d0,y_pos(a0)
                st      $34(a1)

SKTitleCard_SetBannerHeightAndDraw:
                move.b  #$70,height_pixels(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_TitleCardName:
                move.b  (Apparent_zone).w,d0
                add.b   d0,mapping_frame(a0)
                moveq   #$D,d0
                cmpi.w  #$1600,(Current_zone_and_act).w
                beq.s   SKTitleCard_OverrideBossOrHPZName
                moveq   #$11,d0
                cmpi.w  #$1601,(Current_zone_and_act).w
                beq.s   SKTitleCard_OverrideBossOrHPZName
                moveq   #$F,d0
                cmpi.w  #$1700,(Current_zone_and_act).w
                bne.s   SKTitleCard_EnterGenericElement

SKTitleCard_OverrideBossOrHPZName:
                move.b  d0,mapping_frame(a0)

SKTitleCard_EnterGenericElement:
                move.l  #Obj_TitleCardElement,(a0)

Obj_TitleCardElement:
                movea.w parent2(a0),a1
                move.w  $32(a1),d0
                beq.s   SKTitleCard_MoveTextLeftToTarget
                tst.b   render_flags(a0)
                bmi.s   SKTitleCard_MoveTextRightAfterDelay
                subq.w  #1,$30(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKTitleCard_MoveTextRightAfterDelay:
                cmp.b   $28(a0),d0
                blo.s   SKTitleCard_QueueGenericTitleElementDraw
                addi.w  #$20,x_pos(a0)
                bra.s   SKTitleCard_QueueGenericTitleElementDraw
; ---------------------------------------------------------------------------

SKTitleCard_MoveTextLeftToTarget:
                move.w  x_pos(a0),d0
                cmp.w   $46(a0),d0
                beq.s   SKTitleCard_QueueGenericTitleElementDraw
                subi.w  #$10,d0
                move.w  d0,x_pos(a0)
                st      $34(a1)

SKTitleCard_QueueGenericTitleElementDraw:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_TitleCardAct:
                move.l  #Obj_TitleCardElement,(a0)
                cmpi.b  #$A,(Current_zone).w
                beq.s   SKTitleCard_AckAndDeleteSuppressedAct
                cmpi.b  #$C,(Current_zone).w
                beq.s   SKTitleCard_AckAndDeleteSuppressedAct
                cmpi.w  #$1601,(Current_zone_and_act).w
                bne.s   Obj_TitleCardElement

SKTitleCard_AckAndDeleteSuppressedAct:
                movea.w parent2(a0),a1                  ; Sky Sanctuary, Doomsday, and Hidden Palace do not have act numbers
                subq.w  #1,$30(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_TitleCardElement2:
                clr.b   render_flags(a0)                ; I'm not entirely sure what this is used for
                movea.w parent2(a0),a1
                move.w  $32(a1),d0
                beq.s   SKTitleCard_MoveAltTitleLeftToTarget
                cmpi.w  #$20C,x_pos(a0)
                blo.s   SKTitleCard_MoveAltTitleRightAfterDelay
                subq.w  #1,$30(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKTitleCard_MoveAltTitleRightAfterDelay:
                cmp.b   $28(a0),d0
                blo.s   SKTitleCard_DrawAltTitle
                addi.w  #$20,x_pos(a0)
                bra.s   SKTitleCard_DrawAltTitle
; ---------------------------------------------------------------------------

SKTitleCard_MoveAltTitleLeftToTarget:
                move.w  x_pos(a0),d0
                cmp.w   $46(a0),d0
                beq.s   SKTitleCard_DrawAltTitle
                subi.w  #$10,d0
                move.w  d0,x_pos(a0)
                st      $34(a1)

SKTitleCard_DrawAltTitle:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
TitleCard_LevelGfx:
                dc.l    ArtKosM_AIZTitleCard
                dc.l    ArtKosM_HCZTitleCard
                dc.l    ArtKosM_MGZTitleCard
                dc.l    ArtKosM_CNZTitleCard
                dc.l    ArtKosM_FBZTitleCard
                dc.l    ArtKosM_ICZTitleCard
                dc.l    ArtKosM_LBZTitleCard
                dc.l    ArtKosM_MHZTitleCard
                dc.l    ArtKosM_SOZTitleCard
                dc.l    ArtKosM_LRZTitleCard
                dc.l    ArtKosM_SSZTitleCard
                dc.l    ArtKosM_DEZTitleCard
                dc.l    ArtKosM_DDZTitleCard
                dc.l    ArtKosM_HPZTitleCard
                dc.l    ArtKosM_ALZTitleCard
                dc.l    ArtKosM_BPZTitleCard
                dc.l    ArtKosM_CGZTitleCard
                dc.l    ArtKosM_DPZTitleCard
                dc.l    ArtKosM_EMZTitleCard
                dc.l    ArtKosM_BonusTitleCard
                dc.l    ArtKosM_BonusTitleCard
                dc.l    ArtKosM_BonusTitleCard
ObjArray_TtlCard:
                dc.l    Obj_TitleCardName
                dc.w    $120
                dc.w    $260
                dc.w    $E0
                dc.b    4
                dc.b    $80
                dc.w    3
                dc.l    Obj_TitleCardElement
                dc.w    $17C
                dc.w    $2FC
                dc.w    $100
                dc.b    3
                dc.b    $24
                dc.w    5
                dc.l    Obj_TitleCardAct
                dc.w    $184
                dc.w    $344
                dc.w    $120
                dc.b    2
                dc.b    $1C
                dc.w    7
                dc.l    Obj_TitleCardRedBanner
                dc.w    $C0
                dc.w    $E0
                dc.w    $10
                dc.b    1
                dc.b    0
                dc.w    1
ObjArray_TtlCard2:
                dc.l    Obj_TitleCardElement2
                dc.w    $15C
                dc.w    $21C
                dc.w    $BC
                dc.b    $12
                dc.b    $80
                dc.w    1
ObjArray_TtlCardBonus:
                dc.l    Obj_TitleCardElement
                dc.w    $C8
                dc.w    $188
                dc.w    $E8
                dc.b    $13
                dc.b    $80
                dc.w    1
                dc.l    Obj_TitleCardElement
                dc.w    $128
                dc.w    $1E8
                dc.w    $E8
                dc.b    $14
                dc.b    $80
                dc.w    1
