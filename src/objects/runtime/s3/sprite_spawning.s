; Owner: objects/runtime/s3
; Responsibility: Placed-object streaming, free-slot allocation and level object and ring memory reset
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Load_Sprites:
                moveq   #0,d0
                move.b  (Object_load_routine).w,d0
                jmp     Load_Sprites_Index(pc,d0.w)
; End of function Load_Sprites

; ---------------------------------------------------------------------------

Load_Sprites_Index:
                bra.w   S3Spawn_InitLoader
; ---------------------------------------------------------------------------
                bra.w   S3Spawn_UpdateCameraBackAndYWindow
; ---------------------------------------------------------------------------
                bra.w   S3Spawn_UpdateCameraBackAndYWindow
; ---------------------------------------------------------------------------
                rts
; ---------------------------------------------------------------------------

; Keep the existing respawn table when Respawn_table_keep is set
S3Spawn_InitLoader:
                addq.b  #4,(Object_load_routine).w
                tst.b   (Respawn_table_keep).w
                bne.s   S3Spawn_SelectLayoutAndLoadMode
                lea     (Object_respawn_table).w,a0
                moveq   #0,d0
                move.w  #bytesToLcnt($300),d1

S3Spawn_ClearRespawnTable:
                move.l  d0,(a0)+
                dbf     d1,S3Spawn_ClearRespawnTable

S3Spawn_SelectLayoutAndLoadMode:
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #5,d0
                lea     (SpriteLocPtrs).l,a0
                movea.l (a0,d0.w),a0
                cmpi.b  #$13,(Current_zone).w           ; Is this the Gumball Machine?
                bcc.s   S3Spawn_BeginOnePassPreload     ; if so, branch
                tst.w   (Competition_mode).w            ; Is Competition Mode active?
                beq.s   S3Spawn_InitLayoutCursors       ; if not, branch

S3Spawn_BeginOnePassPreload:
                addq.b  #8,(Object_load_routine).w
                jsr     AllocateObject(pc)
                bne.s   S3Spawn_FinishPreload
                lea     (CompactSceneObjectRespawnBytes).w,a3
                lea     (Sprite_Listing).l,a4
                move.w  #$800,d6

; Stop when the record X reaches the unsigned limit or no slot is available
S3Spawn_PreloadUntilXLimit:
                cmp.w   (a0),d6
                bls.s   S3Spawn_FinishPreload
                jsr     CreateObjectFromLayoutRecord(pc)
                beq.s   S3Spawn_PreloadUntilXLimit

S3Spawn_FinishPreload:
                clr.w   (Camera_X_pos_coarse_back).w
                rts
; ---------------------------------------------------------------------------

S3Spawn_InitLayoutCursors:
                move.l  a0,(Object_load_addr_front).w
                move.l  a0,(Object_load_addr_back).w
                lea     (Object_respawn_table).w,a3
                move.w  (Camera_X_pos).w,d6
                subi.w  #$80,d6
                bcc.s   S3Spawn_AlignFrontTo128px
                moveq   #0,d6

S3Spawn_AlignFrontTo128px:
                andi.w  #$FF80,d6
                movea.l (Object_load_addr_front).w,a0

S3Spawn_SeekInitialFront:
                cmp.w   (a0),d6
                bls.s   S3Spawn_StoreFrontAndBeginBackSeek
                addq.w  #6,a0
                addq.w  #1,a3
                bra.s   S3Spawn_SeekInitialFront
; ---------------------------------------------------------------------------

S3Spawn_StoreFrontAndBeginBackSeek:
                move.l  a0,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                lea     (Object_respawn_table).w,a3
                movea.l (Object_load_addr_back).w,a0
                subi.w  #$80,d6
                bcs.s   S3Spawn_StoreBackAndSeedCoarseXY

S3Spawn_SeekInitialBack:
                cmp.w   (a0),d6
                bls.s   S3Spawn_StoreBackAndSeedCoarseXY
                addq.w  #6,a0
                addq.w  #1,a3
                bra.s   S3Spawn_SeekInitialBack
; ---------------------------------------------------------------------------

; Set coarse X to -1 to force the first horizontal refresh
S3Spawn_StoreBackAndSeedCoarseXY:
                move.l  a0,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w
                move.w  #-1,(Camera_X_pos_coarse).w
                move.w  (Camera_Y_pos).w,d0
                andi.w  #$FF80,d0
                move.w  d0,(Camera_Y_pos_coarse).w

S3Spawn_UpdateCameraBackAndYWindow:
                move.w  (Camera_X_pos).w,d1
                subi.w  #$80,d1
                andi.w  #$FF80,d1
                move.w  d1,(Camera_X_pos_coarse_back).w
                lea     (Sprite_Listing).l,a4
                tst.w   (Camera_min_Y_pos).w
                bpl.s   S3Spawn_BuildLinearYWindow
                lea     S3Spawn_DecodeWrappedRecord(pc),a6
                move.w  (Camera_Y_pos).w,d3
                andi.w  #$FF80,d3
                move.w  d3,d4
                addi.w  #$200,d4
                subi.w  #$80,d3
                bpl.s   S3Spawn_CheckYWindowBottomWrap
                and.w   (Screen_Y_wrap_value).w,d3
                bra.s   S3Spawn_SelectXStreamDirection
; ---------------------------------------------------------------------------

S3Spawn_CheckYWindowBottomWrap:
                move.w  (Screen_Y_wrap_value).w,d0
                addq.w  #1,d0
                cmp.w   d0,d4
                bls.s   S3Spawn_UseLinearYDecoder
                and.w   (Screen_Y_wrap_value).w,d4
                bra.s   S3Spawn_SelectXStreamDirection
; ---------------------------------------------------------------------------

; Clamp the top edge to zero when it would be negative
S3Spawn_BuildLinearYWindow:
                move.w  (Camera_Y_pos).w,d3
                andi.w  #$FF80,d3
                move.w  d3,d4
                addi.w  #$200,d4
                subi.w  #$80,d3
                bpl.s   S3Spawn_UseLinearYDecoder
                moveq   #0,d3

S3Spawn_UseLinearYDecoder:
                lea     S3Spawn_DecodeLinearRecord(pc),a6

; Compare coarse X as signed. If X is unchanged, scan the entering Y row
S3Spawn_SelectXStreamDirection:
                move.w  #$FFF,d5
                move.w  (Camera_X_pos).w,d6
                andi.w  #$FF80,d6
                cmp.w   (Camera_X_pos_coarse).w,d6
                beq.w   S3Spawn_SelectEnteringYRow
                bge.s   S3Spawn_BeginRightStream
                move.w  d6,(Camera_X_pos_coarse).w
                movea.l (Object_load_addr_back).w,a0
                movea.w (Object_respawn_index_back).w,a3
                subi.w  #$80,d6
                bcs.s   S3Spawn_StoreLeftBackCursor
                jsr     AllocateObject(pc)
                bne.s   S3Spawn_StoreLeftBackCursor

S3Spawn_LoadLeftRecords:
                cmp.w   -6(a0),d6
                bge.s   S3Spawn_StoreLeftBackCursor
                subq.w  #6,a0
                subq.w  #1,a3
                jsr     (a6)
                bne.s   S3Spawn_AdvanceLeftOnFailure
                subq.w  #6,a0
                bra.s   S3Spawn_LoadLeftRecords
; ---------------------------------------------------------------------------

; The decoder already consumed the record before the next slot search failed
S3Spawn_AdvanceLeftOnFailure:
                addq.w  #6,a0
                addq.w  #1,a3

S3Spawn_StoreLeftBackCursor:
                move.l  a0,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w
                movea.l (Object_load_addr_front).w,a0
                movea.w (Object_respawn_index_front).w,a3
                addi.w  #$300,d6

S3Spawn_RetractFrontCursor:
                cmp.w   -6(a0),d6
                bgt.s   S3Spawn_StoreRetractedFrontCursor
                subq.w  #6,a0
                subq.w  #1,a3
                bra.s   S3Spawn_RetractFrontCursor
; ---------------------------------------------------------------------------

S3Spawn_StoreRetractedFrontCursor:
                move.l  a0,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                bra.s   S3Spawn_SelectEnteringYRow
; ---------------------------------------------------------------------------

S3Spawn_BeginRightStream:
                move.w  d6,(Camera_X_pos_coarse).w
                movea.l (Object_load_addr_front).w,a0
                movea.w (Object_respawn_index_front).w,a3
                addi.w  #$280,d6
                jsr     AllocateObject(pc)
                bne.s   S3Spawn_StoreRightFrontCursor

; Stop at the exclusive right edge using an unsigned X comparison
S3Spawn_LoadRightRecords:
                cmp.w   (a0),d6
                bls.s   S3Spawn_StoreRightFrontCursor
                jsr     (a6)
                addq.w  #1,a3
                beq.s   S3Spawn_LoadRightRecords

S3Spawn_StoreRightFrontCursor:
                move.l  a0,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                movea.l (Object_load_addr_back).w,a0
                movea.w (Object_respawn_index_back).w,a3
                subi.w  #$300,d6
                bcs.s   S3Spawn_StoreAdvancedBackCursor

S3Spawn_AdvanceBackCursor:
                cmp.w   (a0),d6
                bls.s   S3Spawn_StoreAdvancedBackCursor
                addq.w  #6,a0
                addq.w  #1,a3
                bra.s   S3Spawn_AdvanceBackCursor
; ---------------------------------------------------------------------------

S3Spawn_StoreAdvancedBackCursor:
                move.l  a0,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w

S3Spawn_SelectEnteringYRow:
                move.w  (Camera_Y_pos).w,d6
                andi.w  #$FF80,d6
                move.w  d6,d3
                cmp.w   (Camera_Y_pos_coarse).w,d6
                beq.w   S3Spawn_StoreCoarseY
                bge.s   S3Spawn_SelectDownstreamYRow
                tst.w   (Camera_min_Y_pos).w
                bpl.s   S3Spawn_CheckLinearUpperRow
                tst.w   d6
                bne.s   S3Spawn_WrapUpperRow
                cmpi.w  #$80,(Camera_Y_pos_coarse).w
                bne.s   S3Spawn_WrapLowerRow

S3Spawn_WrapUpperRow:
                subi.w  #$80,d3
                bpl.s   S3Spawn_BeginYRowScan
                and.w   (Screen_Y_wrap_value).w,d3
                bra.s   S3Spawn_BeginYRowScan
; ---------------------------------------------------------------------------

S3Spawn_CheckLinearUpperRow:
                subi.w  #$80,d3
                bmi.w   S3Spawn_StoreCoarseY
                bra.s   S3Spawn_BeginYRowScan
; ---------------------------------------------------------------------------

; When wrapping is enabled, a seam crossing can select the upper row even after a signed increase in coarse Y
S3Spawn_SelectDownstreamYRow:
                tst.w   (Camera_min_Y_pos).w
                bpl.s   S3Spawn_CheckLinearLowerRow
                tst.w   (Camera_Y_pos_coarse).w
                bne.s   S3Spawn_WrapLowerRow
                cmpi.w  #$80,d6
                bne.s   S3Spawn_WrapUpperRow

S3Spawn_WrapLowerRow:
                addi.w  #$180,d3
                cmp.w   (Screen_Y_wrap_value).w,d3
                blo.s   S3Spawn_BeginYRowScan
                and.w   (Screen_Y_wrap_value).w,d3
                bra.s   S3Spawn_BeginYRowScan
; ---------------------------------------------------------------------------

; Scan the row at the limit itself. Skip only when the row starts beyond the limit
S3Spawn_CheckLinearLowerRow:
                addi.w  #$180,d3
                cmp.w   (Screen_Y_wrap_value).w,d3
                bhi.s   S3Spawn_StoreCoarseY

S3Spawn_BeginYRowScan:
                jsr     AllocateObject(pc)
                bne.s   S3Spawn_StoreCoarseY
                move.w  d3,d4
                addi.w  #$80,d4
                move.w  #$FFF,d5
                movea.l (Object_load_addr_back).w,a0
                movea.w (Object_respawn_index_back).w,a3
                move.l  (Object_load_addr_front).w,d7
                sub.l   a0,d7
                beq.s   S3Spawn_StoreCoarseY
                addq.w  #2,a0

; Accept both edges of the Y row and skip records whose respawn bit is set
S3Spawn_LoadUnspawnedYRowRecords:
                tst.b   (a3)
                bmi.s   S3Spawn_AdvanceYRowRecord
                move.w  (a0),d1
                and.w   d5,d1
                cmp.w   d3,d1
                blo.s   S3Spawn_AdvanceYRowRecord
                cmp.w   d4,d1
                bhi.s   S3Spawn_AdvanceYRowRecord
                bset    #7,(a3)
                move.w  -2(a0),x_pos(a1)
                move.w  (a0),d1
                move.w  d1,d2
                and.w   d5,d1
                move.w  d1,y_pos(a1)
                rol.w   #3,d2
                andi.w  #3,d2
                move.b  d2,render_flags(a1)
                move.b  d2,status(a1)
                move.b  2(a0),d2
                add.w   d2,d2
                add.w   d2,d2
                move.l  (a4,d2.w),(a1)
                move.b  3(a0),subtype(a1)
                move.w  a3,respawn_addr(a1)
                jsr     CreateNewSprite4(pc)
                bne.s   S3Spawn_StoreCoarseY

S3Spawn_AdvanceYRowRecord:
                addq.w  #6,a0
                addq.w  #1,a3
                subq.w  #6,d7
                bne.s   S3Spawn_LoadUnspawnedYRowRecords

; Advance coarse Y even when the row is skipped or a slot cannot be allocated
S3Spawn_StoreCoarseY:
                move.w  d6,(Camera_Y_pos_coarse).w
                rts
; ---------------------------------------------------------------------------
; unused
                bset    #7,(a3)
                beq.s   CreateObjectFromLayoutRecord
                addq.w  #6,a0
                moveq   #0,d1
                rts

; =============== S U B R O U T I N E =======================================

CreateObjectFromLayoutRecord:
                move.w  (a0)+,x_pos(a1)
                move.w  (a0)+,d1
                move.w  d1,d2
                andi.w  #$FFF,d1
                move.w  d1,y_pos(a1)
                rol.w   #3,d2
                andi.w  #3,d2
                move.b  d2,render_flags(a1)
                move.b  d2,status(a1)
                move.b  (a0)+,d2
                add.w   d2,d2
                add.w   d2,d2
                move.l  (a4,d2.w),(a1)
                move.b  (a0)+,subtype(a1)
                move.w  a3,respawn_addr(a1)
                bra.w   CreateNewSprite4
; ---------------------------------------------------------------------------

S3Spawn_DecodeWrappedRecord:
                tst.b   (a3)
                bpl.s   S3Spawn_FilterWrappedRecordY
                addq.w  #6,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

; The wrapped window accepts Y on either side of the seam. A negative packed Y bypasses the filter
S3Spawn_FilterWrappedRecordY:
                move.w  (a0)+,d7
                move.w  (a0)+,d1
                move.w  d1,d2
                bmi.s   S3Spawn_MaskForcedWrappedY
                and.w   d5,d1
                cmp.w   d3,d1
                bhs.s   S3Spawn_CreateWrappedRecord
                cmp.w   d4,d1
                bls.s   S3Spawn_CreateWrappedRecord
                addq.w  #2,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

S3Spawn_MaskForcedWrappedY:
                and.w   d5,d1

S3Spawn_CreateWrappedRecord:
                bset    #7,(a3)
                move.w  d7,x_pos(a1)
                move.w  d1,y_pos(a1)
                rol.w   #3,d2
                andi.w  #3,d2
                move.b  d2,render_flags(a1)
                move.b  d2,status(a1)
                move.b  (a0)+,d2
                add.w   d2,d2
                add.w   d2,d2
                move.l  (a4,d2.w),(a1)
                move.b  (a0)+,subtype(a1)
                move.w  a3,respawn_addr(a1)
                bra.s   CreateNewSprite4
; ---------------------------------------------------------------------------

S3Spawn_DecodeLinearRecord:
                tst.b   (a3)
                bpl.s   S3Spawn_FilterLinearRecordY
                addq.w  #6,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

; The linear window includes both bounds. A negative packed Y bypasses the filter
S3Spawn_FilterLinearRecordY:
                move.w  (a0)+,d7
                move.w  (a0)+,d1
                move.w  d1,d2
                bmi.s   S3Spawn_MaskForcedLinearY
                and.w   d5,d1
                cmp.w   d3,d1
                blo.s   S3Spawn_SkipRecordTail
                cmp.w   d4,d1
                bls.s   S3Spawn_CreateLinearRecord

; Skip ID and subtype, then set Z so the caller can continue scanning
S3Spawn_SkipRecordTail:
                addq.w  #2,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

S3Spawn_MaskForcedLinearY:
                and.w   d5,d1

S3Spawn_CreateLinearRecord:
                bset    #7,(a3)
                move.w  d7,x_pos(a1)
                move.w  d1,y_pos(a1)
                rol.w   #3,d2
                andi.w  #3,d2
                move.b  d2,render_flags(a1)
                move.b  d2,status(a1)
                move.b  (a0)+,d2
                add.w   d2,d2
                add.w   d2,d2
                move.l  (a4,d2.w),(a1)
                move.b  (a0)+,subtype(a1)
                move.w  a3,respawn_addr(a1)

CreateNewSprite4:
                subq.w  #1,d0
                bmi.s   S3Spawn_NextSlotReturn

S3Spawn_FindNextFreeSlot:
                lea     next_object(a1),a1
                tst.l   (a1)
                dbeq    d0,S3Spawn_FindNextFreeSlot

; Return the remaining count in D0.w and keep the slot search flags for the caller
S3Spawn_NextSlotReturn:
                rts
; End of function CreateObjectFromLayoutRecord

; =============== S U B R O U T I N E =======================================

; Create_New_Sprite:
AllocateObject:
                lea     (Dynamic_object_RAM).w,a1
                moveq   #((Dynamic_object_RAM_end-Dynamic_object_RAM)/object_size)-1,d0
                bra.s   AllocateObjectAfterCurrent.loop
; ---------------------------------------------------------------------------
; Create_New_Sprite3:
AllocateObjectAfterCurrent:
                movea.l a0,a1
                move.w  #Dynamic_object_RAM_end,d0
                sub.w   a0,d0
                lsr.w   #6,d0                           ; Divide by $40... even though SSTs are $4A bytes long in this game
                move.b  .lookup(pc,d0.w),d0             ; Use a look-up table to get the right loop counter
                bmi.s   .return

                .loop:
                lea     next_object(a1),a1
                tst.l   (a1)
                dbeq    d0,.loop

                .return:
                rts

                .lookup:
                .a:     set Dynamic_object_RAM
                .b:     set Dynamic_object_RAM_end
                .c:     set .b                          ; begin from bottom of array and decrease backwards
; There's a mistake here: this division should be rounded up,
; otherwise the first object slot might not get an entry
                rept    (.b-.a)/$40                     ; repeat for all slots, minus exception
                .c:     set .c-$40                      ; address for previous $40 (also skip last part)
                dc.b    (.b-.c-1)/object_size-1         ; write possible slots according to object_size division + hack + dbf hack
                endm
                even
; End of function AllocateObject

; ---------------------------------------------------------------------------

Clear_SpriteRingMem:
                lea     (Dynamic_object_RAM).w,a1
                moveq   #((Dynamic_object_RAM_end-Dynamic_object_RAM)/object_size)-1,d1

S3Spawn_ClearActiveRespawnBit:
                lea     next_object(a1),a1
                tst.l   (a1)
                beq.s   S3Spawn_NextActorOrReadRingCount
                move.w  respawn_addr(a1),d0
                beq.s   S3Spawn_NextActorOrReadRingCount
                movea.w d0,a2
                bclr    #7,(a2)

S3Spawn_NextActorOrReadRingCount:
                dbf     d1,S3Spawn_ClearActiveRespawnBit
                lea     (Ring_consumption_table).w,a2
                move.w  (a2)+,d1
                subq.w  #1,d1
                bcs.s   S3Spawn_ClearRespawnAndRingReturn

; Ignore empty queue entries and mark each referenced ring status word as -1
S3Spawn_FinalizeConsumedRings:
                move.w  (a2)+,d0
                beq.s   S3Spawn_FinalizeConsumedRings
                movea.w d0,a1
                move.w  #-1,(a1)
                clr.w   -2(a2)
                subq.w  #1,(Ring_consumption_table).w
                dbf     d1,S3Spawn_FinalizeConsumedRings

S3Spawn_ClearRespawnAndRingReturn:
                rts
