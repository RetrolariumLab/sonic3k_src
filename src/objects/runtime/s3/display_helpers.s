; Owner: objects/runtime/s3
; Responsibility: Timed sprite drawing, screen lock, boss flashing, slotted attributes and dynamic pattern loading
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
                subq.w  #1,$2E(a0)                      ; Timed object, not actually used
                bmi.w   Go_Delete_Sprite
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
                subq.w  #1,$2E(a0)                      ; Timed object with gravity-influenced movement
                bmi.w   Go_Delete_Sprite
                jsr     (MoveSprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MoveDraw_SpriteTimed:
                subq.w  #1,$2E(a0)
                bmi.w   Go_Delete_Sprite
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

MoveDraw_SpriteTimed2:
                subq.w  #1,$2E(a0)
                bmi.w   Go_Delete_Sprite
                jsr     (MoveSprite_LightGravity).l
                bra.w   Draw_And_Touch_Sprite

; =============== S U B R O U T I N E =======================================

TimedSprite_ScreenLock:
                subq.w  #1,$2E(a0)
                bmi.s   S3RuntimeLifetime_ScreenLockTimer_SetBossFlagAndSchedulePrivateFlagDeletion
                rts
; ---------------------------------------------------------------------------

S3RuntimeLifetime_ScreenLockTimer_SetBossFlagAndSchedulePrivateFlagDeletion:
                move.b  #1,(Boss_flag).w
                bra.w   Go_Delete_Sprite_2
; End of function TimedSprite_ScreenLock

; =============== S U B R O U T I N E =======================================

BossFlash:
                lea     (Normal_palette_line_2+$2).w,a1
                moveq   #0,d0
                tst.w   (a1)
                bne.s   .noflash
                move.w  #$EEE,d0

                .noflash:
                move.w  d0,(a1)
                rts
; End of function BossFlash

; =============== S U B R O U T I N E =======================================

SetUp_ObjAttributesSlotted:
                moveq   #0,d0
                move.w  (a1)+,d1                        ; Maximum number of objects that can be made in this array
                move.w  d1,d2
                move.w  (a1)+,d3                        ; Base VRAM offset of object
                move.w  (a1)+,d4                        ; Amount to add to base VRAM offset for each slot
                moveq   #0,d5
                move.w  (a1)+,d5                        ; Index of slot array to use
                lea     (Slotted_object_bits).w,a2
                adda.w  d5,a2                           ; Get the address of the array to use
                move.b  (a2),d5
                beq.s   S3RuntimeLifetime_SlottedAttributes_ReserveBitAndCopyFullSlottedDescriptorTail  ; If array is clear, just make the object

S3RuntimeLifetime_SlottedAttributes_ShiftOccupiedBitsOrAbortTwoReturnLevels:
                lsr.b   #1,d5                           ; Check slot (each bit)
                bcc.s   S3RuntimeLifetime_SlottedAttributes_ReserveBitAndCopyFullSlottedDescriptorTail  ; If clear, make object
                addq.w  #1,d0                           ; Increment bit number
                add.w   d4,d3                           ; Add VRAM offset
                dbf     d1,S3RuntimeLifetime_SlottedAttributes_ShiftOccupiedBitsOrAbortTwoReturnLevels  ; Repeat max times
                moveq   #0,d0
                move.l  d0,(a0)
                move.l  d0,x_pos(a0)
                move.l  d0,y_pos(a0)
                move.b  d0,subtype(a0)
                move.b  d0,render_flags(a0)
                move.w  d0,status(a0)                   ; If no open slots, then destroy this object period
                addq.w  #8,sp
                rts
; ---------------------------------------------------------------------------

S3RuntimeLifetime_SlottedAttributes_ReserveBitAndCopyFullSlottedDescriptorTail:
                bset    d0,(a2)                         ; Turn this slot on
                move.b  d0,ros_bit(a0)
                move.w  a2,ros_addr(a0)                 ; Keep track of slot address and bit number
                move.w  d3,art_tile(a0)                 ; Use correct VRAM offset
                move.l  (a1)+,mappings(a0)              ; Mapping address
                move.w  (a1)+,priority(a0)              ; Priority
                move.b  (a1)+,width_pixels(a0)          ; Width
                move.b  (a1)+,height_pixels(a0)         ; Height
                move.b  (a1)+,mapping_frame(a0)         ; Frame number
                move.b  (a1)+,collision_flags(a0)       ; Collision number
                bset    #2,status(a0)                   ; Turn object slotting on
                move.b  #-1,objoff_3A(a0)               ; Reset objoff_3A (used by Perform_DPLC)
                bset    #2,render_flags(a0)             ; Use screen coordinates
                addq.b  #2,routine(a0)                  ; Next routine
                rts
; End of function SetUp_ObjAttributesSlotted

; =============== S U B R O U T I N E =======================================

Perform_DPLC:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0            ; Get the frame number
                cmp.b   $3A(a0),d0                      ; If frame number remains the same as before, don't do anything
                beq.s   .end
                move.b  d0,$3A(a0)
                movea.l (a2)+,a3                        ; Source address of art
                move.w  art_tile(a0),d4
                andi.w  #$7FF,d4                        ; Isolate tile location offset
                lsl.w   #5,d4                           ; Convert to VRAM address
                movea.l (a2)+,a2                        ; Address of DPLC script
                add.w   d0,d0
                adda.w  (a2,d0.w),a2                    ; Apply offset to script
                move.w  (a2)+,d5                        ; Get number of DMA transactions
                moveq   #0,d3

                .loop:
                move.w  (a2)+,d3                        ; Art source offset
                move.l  d3,d1
                andi.w  #$FFF0,d1                       ; Isolate all but lower 4 bits
                add.w   d1,d1
                add.l   a3,d1                           ; Get final source address of art
                move.w  d4,d2                           ; Destination VRAM address
                andi.w  #$F,d3
                addq.w  #1,d3
                lsl.w   #4,d3                           ; d3 is the total number of words to transfer (maximum 16 tiles per transaction)
                add.w   d3,d4
                add.w   d3,d4
                jsr     (Add_To_DMA_Queue).l            ; Add to queue
                dbf     d5,.loop                        ; Keep going

                .end:
                rts
; End of function Perform_DPLC
