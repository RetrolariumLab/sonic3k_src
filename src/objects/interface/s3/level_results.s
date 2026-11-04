; Owner: objects/interface/s3
; Responsibility: Level-results presentation, timed score counting, decimal conversion, element movement and object catalogs
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LevelResults:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  LevelResults_Index(pc,d0.w),d1
                jmp     LevelResults_Index(pc,d1.w)
; ---------------------------------------------------------------------------
LevelResults_Index:
                dc.w    Obj_LevelResultsInit-LevelResults_Index
                dc.w    Obj_LevelResultsCreate-LevelResults_Index
                dc.w    Obj_LevelResultsWait-LevelResults_Index
                dc.w    Obj_LevelResultsWait2-LevelResults_Index
; ---------------------------------------------------------------------------

Obj_LevelResultsInit:
                lea     (ArtKosM_ResultsGeneral).l,a1
                move.w  #tiles_to_bytes($520),d2
                jsr     (Queue_Kos_Module).l            ; General art for
                lea     (ArtKosM_TitleCardNum1).l,a1
                tst.b   (Apparent_act).w
                beq.s   S3LevelResults_QueueActAndPickCharArt
                lea     (ArtKosM_TitleCardNum2).l,a1

S3LevelResults_QueueActAndPickCharArt:
                move.w  #tiles_to_bytes($570),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_ResultsSONIC).l,a1     ; Select character name to use based on character of course
                cmpi.w  #1,(Player_mode).w
                bls.s   S3LevelResults_SelectCharArtDest
                lea     (ArtKosM_ResultsKNUCKLES).l,a1
                cmpi.w  #3,(Player_mode).w
                beq.s   S3LevelResults_SelectCharArtDest
                lea     (ArtKosM_ResultsMILES).l,a1
                tst.b   (Graphics_flags).w
                bpl.s   S3LevelResults_SelectCharArtDest
                lea     (ArtKosM_ResultsTAILS).l,a1

S3LevelResults_SelectCharArtDest:
                move.w  #tiles_to_bytes($580),d2
                tst.b   (Apparent_act).w
                beq.s   S3LevelResults_QueueCharArtAndGetSeconds
                move.w  #tiles_to_bytes($5A0),d2

S3LevelResults_QueueCharArtAndGetSeconds:
                jsr     (Queue_Kos_Module).l            ; Load character name graphics
                moveq   #0,d0
                move.b  (Timer_minute).w,d0
                mulu.w  #60,d0
                moveq   #0,d1
                move.b  (Timer_second).w,d1
                add.w   d1,d0
                cmpi.w  #9+59*10,d0
                bne.s   S3LevelResults_ClampTimeBonusBand
                move.w  #10000,(Time_bonus_countdown).w  ; If clock is at 9:59, give an automatic 100000 point time bonus
                bra.s   S3LevelResults_InitRingBonusAndWait
; ---------------------------------------------------------------------------

; Divide by 30 seconds and cap the table index at seven
S3LevelResults_ClampTimeBonusBand:
                divu.w  #30,d0                          ; Divide time by 30
                moveq   #7,d1
                cmp.w   d1,d0                           ; If result is above 7, make it 7
                blo.s   S3LevelResults_ReadTimeBonus
                move.w  d1,d0

S3LevelResults_ReadTimeBonus:
                add.w   d0,d0
                lea     TimeBonus(pc),a1
                move.w  (a1,d0.w),(Time_bonus_countdown).w  ; Get the time bonus

S3LevelResults_InitRingBonusAndWait:
                move.w  (Ring_count).w,d0
                mulu.w  #10,d0
                move.w  d0,(Ring_bonus_countdown).w     ; Get the ring bonus
                clr.w   (Total_bonus_countup).w
                move.w  #6*60,$2E(a0)                   ; Wait 6 seconds before starting score counting sequence
                move.w  #$C,$30(a0)
                addq.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

Obj_LevelResultsCreate:
                tst.b   (Kos_modules_left).w
                bne.s   S3LevelResults_CreateReturn     ; Don't load the objects until the art has been loaded
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   S3LevelResults_CreateReturn
                lea     ObjArray_LevResults(pc),a2
                moveq   #$C-1,d1                        ; Make 12 objects

; Initialize from the fourteen-byte element record
S3LevelResults_InitElementAndFindSlot:
                move.l  (a2)+,(a1)
                move.w  (a2)+,$46(a1)
                move.w  (a2)+,x_pos(a1)
                spl     routine(a1)
                move.w  (a2)+,y_pos(a1)
                move.b  (a2)+,mapping_frame(a1)
                move.b  (a2)+,width_pixels(a1)
                move.w  (a2)+,d2
                move.b  d2,$28(a1)
                move.b  #$40,render_flags(a1)
                move.l  #Map_Results,mappings(a1)
                move.w  a0,parent2(a1)
                jsr     (CreateNewSprite4).l
                dbne    d1,S3LevelResults_InitElementAndFindSlot
                addq.b  #2,routine(a0)
                tst.b   (Apparent_act).w
                bne.s   S3LevelResults_CreateReturn     ; If this is act 2, branch
                move.b  (Apparent_zone).w,d0
                beq.s   S3LevelResults_CreateReturn     ; If this is Angel Island, branch
                cmpi.b  #5,d0
                beq.s   S3LevelResults_CreateReturn     ; If this is Ice Cap Zone, branch
                st      (Events_fg_5).w                 ; Set the background event flag for the given level (presumably for transitions)

S3LevelResults_CreateReturn:
                rts
; ---------------------------------------------------------------------------

Obj_LevelResultsWait:
                tst.w   $2E(a0)
                beq.s   S3LevelResults_BeginTallyAndTickTime
                subq.w  #1,$2E(a0)
                cmpi.w  #289,$2E(a0)
                bne.s   S3LevelResults_TallyReturn      ; Play after eh, a second or so
                move.b  #30,(Player_1+air_left).w       ; Reset air for Hydrocity
                move.b  #30,(Player_2+air_left).w
                moveq   #signextendB(mus_GotThroughAct),d0
                jmp     (Play_Music).l                  ; Play level complete theme
; ---------------------------------------------------------------------------

S3LevelResults_BeginTallyAndTickTime:
                moveq   #0,d0
                tst.w   (Time_bonus_countdown).w
                beq.s   S3LevelResults_TickRingBonus
                addi.w  #10,d0
                subi.w  #10,(Time_bonus_countdown).w    ; Get 100 points from the time bonus

S3LevelResults_TickRingBonus:
                tst.w   (Ring_bonus_countdown).w
                beq.s   S3LevelResults_AddTallyScoreAndTrySound
                addi.w  #10,d0
                subi.w  #10,(Ring_bonus_countdown).w    ; Get 100 points from the ring bonus

S3LevelResults_AddTallyScoreAndTrySound:
                add.w   d0,(Total_bonus_countup).w      ; Add to total score for level
                tst.w   d0
                beq.s   S3LevelResults_PlayRegisterAndBeginSave  ; Branch once score has finished counting down
                jsr     (HUD_AddToScore).l              ; Add to actual score
                move.w  (Level_frame_counter).w,d0
                andi.w  #3,d0
                bne.s   S3LevelResults_TallyReturn
                moveq   #signextendB(sfx_Switch),d0     ; Every four frames, play the score countdown sound
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

S3LevelResults_TallyReturn:
                rts
; ---------------------------------------------------------------------------

S3LevelResults_PlayRegisterAndBeginSave:
                moveq   #signextendB(sfx_Register),d0   ; Play the cash register sound
                jsr     (Play_SFX).l
                jsr     (SaveGame).l
                move.w  #90,$2E(a0)                     ; Set wait amount
                addq.b  #2,routine(a0)

Obj_LevelResultsWait2:
                tst.w   $2E(a0)
                beq.s   S3LevelResults_WaitElementsAndTickExit
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

S3LevelResults_WaitElementsAndTickExit:
                tst.w   $30(a0)                         ; Wait for title screen objects to disappear
                beq.s   S3LevelResults_FinishActOrStartNextTitle
                addq.w  #1,$32(a0)
                rts
; ---------------------------------------------------------------------------

S3LevelResults_FinishActOrStartNextTitle:
                tst.b   (Apparent_act).w
                beq.s   S3LevelResults_SetAct2AndSelectTitle
                clr.b   (ActCompletionHandshake).w      ; Act 2
                st      (End_of_level_flag).w           ; Stop level results flag and set title card finished flag
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

S3LevelResults_SetAct2AndSelectTitle:
                move.b  #1,(Apparent_act).w             ; Change to act 2 if in act 1
                clr.b   (Last_star_post_hit).w
                clr.b   (Special_bonus_entry_flag).w
                clr.b   (ActCompletionHandshake).w
                move.l  #Obj_TitleCard,(a0)             ; Change current object to title card
                clr.b   routine(a0)
                st      $3E(a0)
                rts
; ---------------------------------------------------------------------------

Obj_LevResultsCharName:
                cmpi.w  #2,(Player_mode).w
                beq.s   S3LevelResults_AdjustTailsNameForRegion
                cmpi.w  #3,(Player_mode).w
                bne.s   S3LevelResults_SelectCharArtOffset
                addq.b  #3,mapping_frame(a0)            ; Knuckles frame
                moveq   #$30,d0
                sub.w   d0,x_pos(a0)
                sub.w   d0,$46(a0)                      ; Sprite is offset slightly to the left
                add.b   d0,width_pixels(a0)             ; Increase width by said amount
                bra.s   S3LevelResults_SelectCharArtOffset
; ---------------------------------------------------------------------------

S3LevelResults_AdjustTailsNameForRegion:
                addq.b  #1,mapping_frame(a0)            ; Miles frame
                tst.b   (Graphics_flags).w
                bpl.s   S3LevelResults_SelectCharArtOffset
                addq.b  #1,mapping_frame(a0)            ; Tails frame
                moveq   #8,d0
                add.w   d0,x_pos(a0)
                add.w   d0,$46(a0)
                sub.b   d0,width_pixels(a0)             ; Offset like above

S3LevelResults_SelectCharArtOffset:
                moveq   #0,d0
                tst.b   (Apparent_act).w
                beq.s   S3LevelResults_SetArtAndEnterGeneral
                move.w  #$20,d0

S3LevelResults_SetArtAndEnterGeneral:
                move.w  d0,art_tile(a0)                 ; Offset VRAM depending on act number
                move.l  #Obj_LevResultsGeneral,(a0)

Obj_LevResultsGeneral:
                jsr     LevelResults_MoveElement(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_LevelResultsTimeBonus:
                jsr     LevelResults_MoveElement(pc)
                move.w  (Time_bonus_countdown).w,d0
                bra.s   S3LevelResults_BuildAndDrawDigits
; ---------------------------------------------------------------------------

Obj_LevelResultsRingBonus:
                jsr     LevelResults_MoveElement(pc)
                move.w  (Ring_bonus_countdown).w,d0
                bra.s   S3LevelResults_BuildAndDrawDigits
; ---------------------------------------------------------------------------

Obj_LevelResultsTotal:
                jsr     LevelResults_MoveElement(pc)
                move.w  (Total_bonus_countup).w,d0

S3LevelResults_BuildAndDrawDigits:
                bsr.s   LevResults_DisplayScore
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

LevResults_DisplayScore:
                move.w  #7,mainspr_childsprites(a0)
                jsr     LevResults_GetDecimalScore(pc)
                rol.l   #4,d1
                lea     sub2_x_pos(a0),a1
                move.w  x_pos(a0),d2
                subi.w  #$38,d2
                move.w  y_pos(a0),d3
                moveq   #0,d4
                moveq   #7-1,d5

S3LevelResults_SetDigitPosAndReadNibble:
                move.w  d2,(a1)+
                move.w  d3,(a1)+
                addq.w  #1,a1
                rol.l   #4,d1
                move.w  d1,d0
                andi.w  #$F,d0
                beq.s   S3LevelResults_StoreDigitFrameAndStep
                moveq   #1,d4

S3LevelResults_StoreDigitFrameAndStep:
                add.w   d4,d0
                move.b  d0,(a1)+
                addq.w  #8,d2
                dbf     d5,S3LevelResults_SetDigitPosAndReadNibble
                rts
; End of function LevResults_DisplayScore

; =============== S U B R O U T I N E =======================================

LevelResults_MoveElement:
                movea.w parent2(a0),a1
                move.w  $32(a1),d0
                beq.s   S3LevelResults_ApproachTargetInStepsOf16
                tst.b   render_flags(a0)
                bmi.s   S3LevelResults_TryExitAtQueueRank
                subq.w  #1,$30(a1)                      ; If offscreen, subtract from number of elements and delete
                addq.w  #4,sp
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

; Use the low byte of the parent exit queue for the rank comparison
S3LevelResults_TryExitAtQueueRank:
                cmp.b   $28(a0),d0                      ; Level element moving out. Test if value of parent queue matches given queue value
                blo.s   S3LevelResults_ElementMoveReturn
                move.w  #-$20,d0                        ; If so, move out
                tst.b   routine(a0)
                beq.s   S3LevelResults_AddExitXDelta
                neg.w   d0                              ; Change direction depending on where it came from

S3LevelResults_AddExitXDelta:
                add.w   x_pos(a0),d0
                bra.s   S3LevelResults_StoreElementX
; ---------------------------------------------------------------------------

S3LevelResults_ApproachTargetInStepsOf16:
                moveq   #$10,d1                         ; Level element moving in
                move.w  x_pos(a0),d0
                cmp.w   $46(a0),d0
                beq.s   S3LevelResults_StoreElementX    ; If X position has reached destination, don't do anything else
                blt.s   S3LevelResults_AddEntranceXDelta  ; See which direction it needs to go
                neg.w   d1

S3LevelResults_AddEntranceXDelta:
                add.w   d1,d0                           ; Add speed to X amount

S3LevelResults_StoreElementX:
                move.w  d0,x_pos(a0)

S3LevelResults_ElementMoveReturn:
                rts
; End of function LevelResults_MoveElement

; =============== S U B R O U T I N E =======================================

LevResults_GetDecimalScore:
                clr.l   (ResultsNumericAccumulator).w
                lea     TimeBonus(pc),a1
                moveq   #$10-1,d2

S3LevelResults_ReadBitOrSkipBcdWeight:
                ror.w   #1,d0
                bcs.s   S3LevelResults_AddPackedBcdWeight
                subq.w  #3,a1
                bra.s   S3LevelResults_FinishBcdConversion
; ---------------------------------------------------------------------------

S3LevelResults_AddPackedBcdWeight:
                lea     (ResultsNumericAccumulatorEnd).w,a2
                addi.w  #0,d0
                abcd    -(a1),-(a2)
                abcd    -(a1),-(a2)
                abcd    -(a1),-(a2)

S3LevelResults_FinishBcdConversion:
                dbf     d2,S3LevelResults_ReadBitOrSkipBcdWeight
                move.l  (ResultsNumericAccumulator).w,d1
                rts
; End of function LevResults_GetDecimalScore

; ---------------------------------------------------------------------------
                tribyte $32768
                tribyte $16384
                tribyte $8192
                tribyte $4096
                tribyte $2048
                tribyte $1024
                tribyte $512
                tribyte $256
                tribyte $128
                tribyte $64
                tribyte $32
                tribyte $16
                tribyte 8
                tribyte 4
                tribyte 2
                tribyte 1
TimeBonus:
                dc.w    5000
                dc.w    5000
                dc.w    1000
                dc.w    500
                dc.w    400
                dc.w    300
                dc.w    100
                dc.w    10
ObjArray_LevResults:
                dc.l    Obj_LevResultsCharName          ; Object address
                dc.w    $E0                             ; X destination
                dc.w    -$220                           ; X position
                dc.w    $B8                             ; Y position
                dc.b    $13                             ; Mapping frame
                dc.b    $48                             ; Width
                dc.w    1                               ; Place in exit queue
                dc.l    Obj_LevResultsGeneral
                dc.w    $130
                dc.w    -$1D0
                dc.w    $B8
                dc.b    $11
                dc.b    $30
                dc.w    1
                dc.l    Obj_LevResultsGeneral
                dc.w    $E8
                dc.w    $468
                dc.w    $CC
                dc.b    $10
                dc.b    $70
                dc.w    3
                dc.l    Obj_LevResultsGeneral
                dc.w    $160
                dc.w    $4E0
                dc.w    $BC
                dc.b    $F
                dc.b    $38
                dc.w    3
                dc.l    Obj_LevResultsGeneral
                dc.w    $C0
                dc.w    $4C0
                dc.w    $F0
                dc.b    $E
                dc.b    $20
                dc.w    5
                dc.l    Obj_LevResultsGeneral
                dc.w    $E8
                dc.w    $4E8
                dc.w    $F0
                dc.b    $C
                dc.b    $30
                dc.w    5
                dc.l    Obj_LevelResultsTimeBonus
                dc.w    $178
                dc.w    $578
                dc.w    $F0
                dc.b    1
                dc.b    $40
                dc.w    5
                dc.l    Obj_LevResultsGeneral
                dc.w    $C0
                dc.w    $500
                dc.w    $100
                dc.b    $D
                dc.b    $20
                dc.w    7
                dc.l    Obj_LevResultsGeneral
                dc.w    $E8
                dc.w    $528
                dc.w    $100
                dc.b    $C
                dc.b    $30
                dc.w    7
                dc.l    Obj_LevelResultsRingBonus
                dc.w    $178
                dc.w    $5B8
                dc.w    $100
                dc.b    1
                dc.b    $40
                dc.w    7
                dc.l    Obj_LevResultsGeneral
                dc.w    $D4
                dc.w    $554
                dc.w    $11C
                dc.b    $B
                dc.b    $30
                dc.w    9
                dc.l    Obj_LevelResultsTotal
                dc.w    $178
                dc.w    $5F8
                dc.w    $11C
                dc.b    1
                dc.b    $40
                dc.w    9
; ---------------------------------------------------------------------------

S3LevelResults_SpecialVIntReturn:
                rts
