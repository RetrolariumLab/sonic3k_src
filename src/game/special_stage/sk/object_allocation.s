; Owner: game/special_stage/sk
; Responsibility: Complete fixed-slot special-stage object allocator and its preserved return behavior
; Source provenance and ranges: config/reconstruction/source_layout.json
AllocateObjectAfterCurrent_SpecialStage:
                movea.l a0,a1
                move.w  #Object_RAM_end-object_size,d0
                sub.w   a0,d0
                lsr.w   #6,d0
                move.b  .lookup(pc,d0.w),d0
                bmi.s   .return

                .loop:
                lea     next_object(a1),a1
                tst.l   (a1)
                dbeq    d0,.loop

                .return:
                rts

                .lookup:
                .a:     set Object_RAM-object_size*2    ; Oddly, this does too many object slots
                .b:     set Object_RAM_end-object_size
                .c:     set .b                          ; begin from bottom of array and decrease backwards
; There's a mistake here: this division should be rounded up,
; otherwise the first object slot might not get an entry
; In this case, the aforementioned surplus entries counteract this problem
                rept    (.b-.a)/$40                     ; repeat for all slots, minus exception
                .c:     set .c-$40                      ; address for previous $40 (also skip last part)
                dc.b    (.b-.c-1)/object_size-1         ; write possible slots according to object_size division + hack + dbf hack
                endm
                even
; End of function AllocateObjectAfterCurrent_SpecialStage
