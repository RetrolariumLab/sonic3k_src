; Owner: objects/runtime/sk
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
                bra.w   SKSpawn_SelectZoneObjectIndex
; ---------------------------------------------------------------------------
                bra.w   SKSpawn_UpdateCameraBackAndYWindow
; ---------------------------------------------------------------------------
                bra.w   SKSpawn_UpdateCameraBackAndYWindow
; ---------------------------------------------------------------------------
                rts
; ---------------------------------------------------------------------------

SKSpawn_SelectZoneObjectIndex:
                move.l  #Sprite_ListingK,d0
                move.b  (Current_zone).w,d1
                cmpi.b  #$16,d1
                bhs.s   SKSpawn_InitLoader
                cmpi.b  #$E,d1
                bhs.s   SKSpawn_UseS3ObjectIndex
                cmpi.b  #7,d1
                bhs.s   SKSpawn_InitLoader

; Use the Sonic 3 index for zones below $07 and from $0E through $15
SKSpawn_UseS3ObjectIndex:
                move.l  #Sprite_Listing3,d0

; Keep the existing respawn table when Respawn_table_keep is set
SKSpawn_InitLoader:
                move.l  d0,(Object_index_addr).w
                addq.b  #4,(Object_load_routine).w
                tst.b   (Respawn_table_keep).w
                bne.s   SKSpawn_SelectLayoutAndLoadMode
                lea     (Object_respawn_table).w,a0
                moveq   #0,d0
                move.w  #bytesToLcnt($300),d1

SKSpawn_ClearRespawnTable:
                move.l  d0,(a0)+
                dbf     d1,SKSpawn_ClearRespawnTable

SKSpawn_SelectLayoutAndLoadMode:
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #5,d0
                lea     (SpriteLocPtrs).l,a0
                movea.l (a0,d0.w),a0
                cmpi.w  #$1701,(Current_zone_and_act).w
                beq.s   SKSpawn_BeginOnePassPreload
                cmpi.b  #$16,(Current_zone).w
                bhs.s   SKSpawn_InitLayoutCursors
                cmpi.b  #$14,(Current_zone).w
                beq.s   SKSpawn_InitLayoutCursors
                cmpi.b  #$13,(Current_zone).w
                bhs.s   SKSpawn_BeginOnePassPreload
                tst.w   (Competition_mode).w
                beq.s   SKSpawn_InitLayoutCursors

SKSpawn_BeginOnePassPreload:
                addq.b  #8,(Object_load_routine).w
                jsr     AllocateObject(pc)
                bne.s   SKSpawn_FinishPreload
                lea     (CompactSceneObjectRespawnBytes).w,a3
                movea.l (Object_index_addr).w,a4
                move.w  #$800,d6
                cmpi.w  #$1701,(Current_zone_and_act).w
                bne.s   SKSpawn_PreloadUntilXLimit
                move.w  #$1780,d6

; Stop when the record X reaches the unsigned limit or no slot is available
SKSpawn_PreloadUntilXLimit:
                cmp.w   (a0),d6
                bls.s   SKSpawn_FinishPreload
                jsr     CreateObjectFromLayoutRecord(pc)
                beq.s   SKSpawn_PreloadUntilXLimit

SKSpawn_FinishPreload:
                clr.w   (Camera_X_pos_coarse_back).w
                cmpi.w  #$1701,(Current_zone_and_act).w
                bne.s   SKSpawn_PreloadReturn
                move.w  (Camera_X_pos).w,d1
                subi.w  #$80,d1
                andi.w  #$FF80,d1
                move.w  d1,(Camera_X_pos_coarse_back).w

SKSpawn_PreloadReturn:
                rts
; ---------------------------------------------------------------------------

SKSpawn_InitLayoutCursors:
                move.l  a0,(Object_load_addr_front).w
                move.l  a0,(Object_load_addr_back).w
                lea     (Object_respawn_table).w,a3
                cmpi.b  #$14,(Current_zone).w
                bne.s   SKSpawn_CalcInitialFrontBoundary
                lea     (Object_respawn_table_2).w,a3
                moveq   #bytesToLcnt($200),d6

SKSpawn_ClearPachinkoRespawnTable:
                clr.l   (a3)+
                dbf     d6,SKSpawn_ClearPachinkoRespawnTable
                lea     (Object_respawn_table_2).w,a3

; Clamp camera X minus $80 to zero on unsigned borrow
SKSpawn_CalcInitialFrontBoundary:
                move.w  (Camera_X_pos).w,d6
                subi.w  #$80,d6
                bcc.s   SKSpawn_AlignFrontTo128px
                moveq   #0,d6

SKSpawn_AlignFrontTo128px:
                andi.w  #$FF80,d6
                movea.l (Object_load_addr_front).w,a0

SKSpawn_SeekInitialFront:
                cmp.w   (a0),d6
                bls.s   SKSpawn_StoreFrontAndBeginBackSeek
                addq.w  #6,a0
                addq.w  #1,a3
                bra.s   SKSpawn_SeekInitialFront
; ---------------------------------------------------------------------------

SKSpawn_StoreFrontAndBeginBackSeek:
                move.l  a0,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                lea     (Object_respawn_table).w,a3
                cmpi.b  #$14,(Current_zone).w
                bne.s   SKSpawn_BeginBackSeek
                lea     (Object_respawn_table_2).w,a3

SKSpawn_BeginBackSeek:
                movea.l (Object_load_addr_back).w,a0
                subi.w  #$80,d6
                bcs.s   SKSpawn_StoreBackAndSeedCoarseXY

SKSpawn_SeekInitialBack:
                cmp.w   (a0),d6
                bls.s   SKSpawn_StoreBackAndSeedCoarseXY
                addq.w  #6,a0
                addq.w  #1,a3
                bra.s   SKSpawn_SeekInitialBack
; ---------------------------------------------------------------------------

; Set coarse X to -1 to force the first horizontal refresh
SKSpawn_StoreBackAndSeedCoarseXY:
                move.l  a0,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w
                move.w  #-1,(Camera_X_pos_coarse).w
                move.w  (Camera_Y_pos).w,d0
                andi.w  #$FF80,d0
                move.w  d0,(Camera_Y_pos_coarse).w

SKSpawn_UpdateCameraBackAndYWindow:
                move.w  (Camera_Y_pos).w,d1
                subi.w  #$80,d1
                andi.w  #$FF80,d1
                move.w  d1,(Camera_Y_pos_coarse_back).w
                move.w  (Camera_X_pos).w,d1
                subi.w  #$80,d1
                andi.w  #$FF80,d1
                move.w  d1,(Camera_X_pos_coarse_back).w
                movea.l (Object_index_addr).w,a4
                tst.w   (Camera_min_Y_pos).w
                bpl.s   SKSpawn_BuildLinearYWindow
                lea     SKSpawn_DecodeWrappedRecord(pc),a6
                move.w  (Camera_Y_pos).w,d3
                andi.w  #$FF80,d3
                move.w  d3,d4
                addi.w  #$200,d4
                subi.w  #$80,d3
                bpl.s   SKSpawn_CheckYWindowBottomWrap
                and.w   (Screen_Y_wrap_value).w,d3
                bra.s   SKSpawn_SelectXStreamDirection
; ---------------------------------------------------------------------------

SKSpawn_CheckYWindowBottomWrap:
                move.w  (Screen_Y_wrap_value).w,d0
                addq.w  #1,d0
                cmp.w   d0,d4
                bls.s   SKSpawn_UseLinearYDecoder
                and.w   (Screen_Y_wrap_value).w,d4
                bra.s   SKSpawn_SelectXStreamDirection
; ---------------------------------------------------------------------------

; Clamp the top edge to zero when it would be negative
SKSpawn_BuildLinearYWindow:
                move.w  (Camera_Y_pos).w,d3
                andi.w  #$FF80,d3
                move.w  d3,d4
                addi.w  #$200,d4
                subi.w  #$80,d3
                bpl.s   SKSpawn_UseLinearYDecoder
                moveq   #0,d3

SKSpawn_UseLinearYDecoder:
                lea     SKSpawn_DecodeLinearRecord(pc),a6

; Compare coarse X as signed. If X is unchanged, scan the entering Y row
SKSpawn_SelectXStreamDirection:
                move.w  #$FFF,d5
                move.w  (Camera_X_pos).w,d6
                andi.w  #$FF80,d6
                cmp.w   (Camera_X_pos_coarse).w,d6
                beq.w   SKSpawn_SelectEnteringYRow
                bge.s   SKSpawn_BeginRightStream
                move.w  d6,(Camera_X_pos_coarse).w
                movea.l (Object_load_addr_back).w,a0
                movea.w (Object_respawn_index_back).w,a3
                subi.w  #$80,d6
                bcs.s   SKSpawn_StoreLeftBackCursor
                jsr     AllocateObject(pc)
                bne.s   SKSpawn_StoreLeftBackCursor

SKSpawn_LoadLeftRecords:
                cmp.w   -6(a0),d6
                bge.s   SKSpawn_StoreLeftBackCursor
                subq.w  #6,a0
                subq.w  #1,a3
                jsr     (a6)
                bne.s   SKSpawn_AdvanceLeftOnFailure
                subq.w  #6,a0
                bra.s   SKSpawn_LoadLeftRecords
; ---------------------------------------------------------------------------

; The decoder already consumed the record before the next slot search failed
SKSpawn_AdvanceLeftOnFailure:
                addq.w  #6,a0
                addq.w  #1,a3

SKSpawn_StoreLeftBackCursor:
                move.l  a0,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w
                movea.l (Object_load_addr_front).w,a0
                movea.w (Object_respawn_index_front).w,a3
                addi.w  #$300,d6

SKSpawn_RetractFrontCursor:
                cmp.w   -6(a0),d6
                bgt.s   SKSpawn_StoreRetractedFrontCursor
                subq.w  #6,a0
                subq.w  #1,a3
                bra.s   SKSpawn_RetractFrontCursor
; ---------------------------------------------------------------------------

SKSpawn_StoreRetractedFrontCursor:
                move.l  a0,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                bra.s   SKSpawn_SelectEnteringYRow
; ---------------------------------------------------------------------------

SKSpawn_BeginRightStream:
                move.w  d6,(Camera_X_pos_coarse).w
                movea.l (Object_load_addr_front).w,a0
                movea.w (Object_respawn_index_front).w,a3
                addi.w  #$280,d6
                jsr     AllocateObject(pc)
                bne.s   SKSpawn_StoreRightFrontCursor

; Stop at the exclusive right edge using an unsigned X comparison
SKSpawn_LoadRightRecords:
                cmp.w   (a0),d6
                bls.s   SKSpawn_StoreRightFrontCursor
                jsr     (a6)
                addq.w  #1,a3
                beq.s   SKSpawn_LoadRightRecords

SKSpawn_StoreRightFrontCursor:
                move.l  a0,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                movea.l (Object_load_addr_back).w,a0
                movea.w (Object_respawn_index_back).w,a3
                subi.w  #$300,d6
                bcs.s   SKSpawn_StoreAdvancedBackCursor

SKSpawn_AdvanceBackCursor:
                cmp.w   (a0),d6
                bls.s   SKSpawn_StoreAdvancedBackCursor
                addq.w  #6,a0
                addq.w  #1,a3
                bra.s   SKSpawn_AdvanceBackCursor
; ---------------------------------------------------------------------------

SKSpawn_StoreAdvancedBackCursor:
                move.l  a0,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w

SKSpawn_SelectEnteringYRow:
                move.w  (Camera_Y_pos).w,d6
                andi.w  #$FF80,d6
                move.w  d6,d3
                cmp.w   (Camera_Y_pos_coarse).w,d6
                beq.w   SKSpawn_StoreCoarseY
                bge.s   SKSpawn_SelectDownstreamYRow
                tst.w   (Camera_min_Y_pos).w
                bpl.s   SKSpawn_CheckLinearUpperRow
                tst.w   d6
                bne.s   SKSpawn_WrapUpperRow
                cmpi.w  #$80,(Camera_Y_pos_coarse).w
                bne.s   SKSpawn_WrapLowerRow

SKSpawn_WrapUpperRow:
                subi.w  #$80,d3
                bpl.s   SKSpawn_BeginYRowScan
                and.w   (Screen_Y_wrap_value).w,d3
                bra.s   SKSpawn_BeginYRowScan
; ---------------------------------------------------------------------------

SKSpawn_CheckLinearUpperRow:
                subi.w  #$80,d3
                bmi.w   SKSpawn_StoreCoarseY
                bra.s   SKSpawn_BeginYRowScan
; ---------------------------------------------------------------------------

; When wrapping is enabled, a seam crossing can select the upper row even after a signed increase in coarse Y
SKSpawn_SelectDownstreamYRow:
                tst.w   (Camera_min_Y_pos).w
                bpl.s   SKSpawn_CheckLinearLowerRow
                tst.w   (Camera_Y_pos_coarse).w
                bne.s   SKSpawn_WrapLowerRow
                cmpi.w  #$80,d6
                bne.s   SKSpawn_WrapUpperRow

SKSpawn_WrapLowerRow:
                addi.w  #$180,d3
                cmp.w   (Screen_Y_wrap_value).w,d3
                blo.s   SKSpawn_BeginYRowScan
                and.w   (Screen_Y_wrap_value).w,d3
                bra.s   SKSpawn_BeginYRowScan
; ---------------------------------------------------------------------------

; Scan the row at the limit itself. Skip only when the row starts beyond the limit
SKSpawn_CheckLinearLowerRow:
                addi.w  #$180,d3
                cmp.w   (Screen_Y_wrap_value).w,d3
                bhi.s   SKSpawn_StoreCoarseY

SKSpawn_BeginYRowScan:
                jsr     AllocateObject(pc)
                bne.s   SKSpawn_StoreCoarseY
                move.w  d3,d4
                addi.w  #$80,d4
                move.w  #$FFF,d5
                movea.l (Object_load_addr_back).w,a0
                movea.w (Object_respawn_index_back).w,a3
                move.l  (Object_load_addr_front).w,d7
                sub.l   a0,d7
                beq.s   SKSpawn_StoreCoarseY
                addq.w  #2,a0

; Accept both edges of the Y row and skip records whose respawn bit is set
SKSpawn_LoadUnspawnedYRowRecords:
                tst.b   (a3)
                bmi.s   SKSpawn_AdvanceYRowRecord
                move.w  (a0),d1
                and.w   d5,d1
                cmp.w   d3,d1
                blo.s   SKSpawn_AdvanceYRowRecord
                cmp.w   d4,d1
                bhi.s   SKSpawn_AdvanceYRowRecord
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
                bne.s   SKSpawn_StoreCoarseY

SKSpawn_AdvanceYRowRecord:
                addq.w  #6,a0
                addq.w  #1,a3
                subq.w  #6,d7
                bne.s   SKSpawn_LoadUnspawnedYRowRecords

; Advance coarse Y even when the row is skipped or a slot cannot be allocated
SKSpawn_StoreCoarseY:
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

SKSpawn_DecodeWrappedRecord:
                tst.b   (a3)
                bpl.s   SKSpawn_FilterWrappedRecordY
                addq.w  #6,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

; The wrapped window accepts Y on either side of the seam. A negative packed Y bypasses the filter
SKSpawn_FilterWrappedRecordY:
                move.w  (a0)+,d7
                move.w  (a0)+,d1
                move.w  d1,d2
                bmi.s   SKSpawn_MaskForcedWrappedY
                and.w   d5,d1
                cmp.w   d3,d1
                bhs.s   SKSpawn_CreateWrappedRecord
                cmp.w   d4,d1
                bls.s   SKSpawn_CreateWrappedRecord
                addq.w  #2,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

SKSpawn_MaskForcedWrappedY:
                and.w   d5,d1

SKSpawn_CreateWrappedRecord:
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

SKSpawn_DecodeLinearRecord:
                tst.b   (a3)
                bpl.s   SKSpawn_FilterLinearRecordY
                addq.w  #6,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

; The linear window includes both bounds. A negative packed Y bypasses the filter
SKSpawn_FilterLinearRecordY:
                move.w  (a0)+,d7
                move.w  (a0)+,d1
                move.w  d1,d2
                bmi.s   SKSpawn_MaskForcedLinearY
                and.w   d5,d1
                cmp.w   d3,d1
                blo.s   SKSpawn_SkipRecordTail
                cmp.w   d4,d1
                bls.s   SKSpawn_CreateLinearRecord

; Skip ID and subtype, then set Z so the caller can continue scanning
SKSpawn_SkipRecordTail:
                addq.w  #2,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

SKSpawn_MaskForcedLinearY:
                and.w   d5,d1

SKSpawn_CreateLinearRecord:
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
                bmi.s   SKSpawn_NextSlotReturn

SKSpawn_FindNextFreeSlot:
                lea     next_object(a1),a1
                tst.l   (a1)
                dbeq    d0,SKSpawn_FindNextFreeSlot

; Return the remaining count in D0.w and keep the slot search flags for the caller
SKSpawn_NextSlotReturn:
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

SKSpawn_ClearActiveRespawnBit:
                lea     next_object(a1),a1
                tst.l   (a1)
                beq.s   SKSpawn_NextActorOrReadRingCount
                move.w  respawn_addr(a1),d0
                beq.s   SKSpawn_NextActorOrReadRingCount
                movea.w d0,a2
                bclr    #7,(a2)

SKSpawn_NextActorOrReadRingCount:
                dbf     d1,SKSpawn_ClearActiveRespawnBit
                lea     (Ring_consumption_table).w,a2
                move.w  (a2)+,d1
                subq.w  #1,d1
                bcs.s   SKSpawn_ClearRespawnAndRingReturn

; Ignore empty queue entries and mark each referenced ring status word as -1
SKSpawn_FinalizeConsumedRings:
                move.w  (a2)+,d0
                beq.s   SKSpawn_FinalizeConsumedRings
                movea.w d0,a1
                move.w  #-1,(a1)
                clr.w   -2(a2)
                subq.w  #1,(Ring_consumption_table).w
                dbf     d1,SKSpawn_FinalizeConsumedRings

SKSpawn_ClearRespawnAndRingReturn:
                rts
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================
; Changes the coarse back- and forward-camera edges to match new Camera_X value
; Also seeks to appropriate object locations in the level's object layout, so
; that Load_Sprites will correctly load the objects again

Seek_Object_Manager:
                move.w  (Camera_X_pos).w,d6
                addi.w  #$400,d6
                andi.w  #$FF80,d6
                cmp.w   (Camera_X_pos_coarse).w,d6
                beq.w   SKSpawn_RebaseReturn
                bge.s   SKSpawn_BeginRightRebase
                move.w  d6,(Camera_X_pos_coarse).w
                movea.l (Object_load_addr_back).w,a1
                movea.w (Object_respawn_index_back).w,a3
                subi.w  #$80,d6
                bcs.s   SKSpawn_RebaseStoreBackLeft

; Move the layout and respawn cursors without creating objects
SKSpawn_RebaseSeekBackLeft:
                cmp.w   -6(a1),d6
                bge.s   SKSpawn_RebaseStoreBackLeft
                subq.w  #6,a1
                subq.w  #1,a3
                bra.s   SKSpawn_RebaseSeekBackLeft
; ---------------------------------------------------------------------------

SKSpawn_RebaseStoreBackLeft:
                move.l  a1,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w
                movea.l (Object_load_addr_front).w,a1
                movea.w (Object_respawn_index_front).w,a3
                addi.w  #$300,d6

SKSpawn_RebaseRetractFront:
                cmp.w   -6(a1),d6
                bgt.s   SKSpawn_RebaseStoreFrontLeft
                subq.w  #6,a1
                subq.w  #1,a3
                bra.s   SKSpawn_RebaseRetractFront
; ---------------------------------------------------------------------------

SKSpawn_RebaseStoreFrontLeft:
                move.l  a1,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                bra.s   SKSpawn_RebaseReturn
; ---------------------------------------------------------------------------

SKSpawn_BeginRightRebase:
                move.w  d6,(Camera_X_pos_coarse).w
                movea.l (Object_load_addr_front).w,a1
                movea.w (Object_respawn_index_front).w,a3
                addi.w  #$280,d6

SKSpawn_RebaseAdvanceFront:
                cmp.w   (a1),d6
                bls.s   SKSpawn_RebaseStoreFrontRight
                addq.w  #6,a1
                addq.w  #1,a3
                bra.s   SKSpawn_RebaseAdvanceFront
; ---------------------------------------------------------------------------

SKSpawn_RebaseStoreFrontRight:
                move.l  a1,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                movea.l (Object_load_addr_back).w,a1
                movea.w (Object_respawn_index_back).w,a3
                subi.w  #$300,d6
                bcs.s   SKSpawn_RebaseStoreBackRight

SKSpawn_RebaseAdvanceBack:
                cmp.w   (a1),d6
                bls.s   SKSpawn_RebaseStoreBackRight
                addq.w  #6,a1
                addq.w  #1,a3
                bra.s   SKSpawn_RebaseAdvanceBack
; ---------------------------------------------------------------------------

SKSpawn_RebaseStoreBackRight:
                move.l  a1,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w

SKSpawn_RebaseReturn:
                rts
