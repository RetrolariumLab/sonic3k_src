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
                bra.w   loc_19D0A
; ---------------------------------------------------------------------------
                bra.w   loc_19DD0
; ---------------------------------------------------------------------------
                bra.w   loc_19DD0
; ---------------------------------------------------------------------------
                rts
; ---------------------------------------------------------------------------

loc_19D0A:
                addq.b  #4,(Object_load_routine).w
                tst.b   (Respawn_table_keep).w
                bne.s   loc_19D24
                lea     (Object_respawn_table).w,a0
                moveq   #0,d0
                move.w  #bytesToLcnt($300),d1

loc_19D1E:
                move.l  d0,(a0)+
                dbf     d1,loc_19D1E

loc_19D24:
                move.w  (Current_zone_and_act).w,d0
                ror.b   #1,d0
                lsr.w   #5,d0
                lea     (SpriteLocPtrs).l,a0
                movea.l (a0,d0.w),a0
                cmpi.b  #$13,(Current_zone).w           ; Is this the Gumball Machine?
                bcc.s   loc_19D44                       ; if so, branch
                tst.w   (Competition_mode).w            ; Is Competition Mode active?
                beq.s   loc_19D6C                       ; if not, branch

loc_19D44:
                addq.b  #8,(Object_load_routine).w
                jsr     AllocateObject(pc)
                bne.s   loc_19D66
                lea     (_unkF712).w,a3
                lea     (Sprite_Listing).l,a4
                move.w  #$800,d6

loc_19D5C:
                cmp.w   (a0),d6
                bls.s   loc_19D66
                jsr     CreateObjectFromLayoutRecord(pc)
                beq.s   loc_19D5C

loc_19D66:
                clr.w   (Camera_X_pos_coarse_back).w
                rts
; ---------------------------------------------------------------------------

loc_19D6C:
                move.l  a0,(Object_load_addr_front).w
                move.l  a0,(Object_load_addr_back).w
                lea     (Object_respawn_table).w,a3
                move.w  (Camera_X_pos).w,d6
                subi.w  #$80,d6
                bcc.s   loc_19D84
                moveq   #0,d6

loc_19D84:
                andi.w  #$FF80,d6
                movea.l (Object_load_addr_front).w,a0

loc_19D8C:
                cmp.w   (a0),d6
                bls.s   loc_19D96
                addq.w  #6,a0
                addq.w  #1,a3
                bra.s   loc_19D8C
; ---------------------------------------------------------------------------

loc_19D96:
                move.l  a0,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                lea     (Object_respawn_table).w,a3
                movea.l (Object_load_addr_back).w,a0
                subi.w  #$80,d6
                bcs.s   loc_19DB6

loc_19DAC:
                cmp.w   (a0),d6
                bls.s   loc_19DB6
                addq.w  #6,a0
                addq.w  #1,a3
                bra.s   loc_19DAC
; ---------------------------------------------------------------------------

loc_19DB6:
                move.l  a0,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w
                move.w  #-1,(Camera_X_pos_coarse).w
                move.w  (Camera_Y_pos).w,d0
                andi.w  #$FF80,d0
                move.w  d0,(Camera_Y_pos_coarse).w

loc_19DD0:
                move.w  (Camera_X_pos).w,d1
                subi.w  #$80,d1
                andi.w  #$FF80,d1
                move.w  d1,(Camera_X_pos_coarse_back).w
                lea     (Sprite_Listing).l,a4
                tst.w   (Camera_min_Y_pos).w
                bpl.s   loc_19E1A
                lea     loc_1A010(pc),a6
                move.w  (Camera_Y_pos).w,d3
                andi.w  #$FF80,d3
                move.w  d3,d4
                addi.w  #$200,d4
                subi.w  #$80,d3
                bpl.s   loc_19E0A
                and.w   (Screen_Y_wrap_value).w,d3
                bra.s   loc_19E34
; ---------------------------------------------------------------------------

loc_19E0A:
                move.w  (Screen_Y_wrap_value).w,d0
                addq.w  #1,d0
                cmp.w   d0,d4
                bls.s   loc_19E30
                and.w   (Screen_Y_wrap_value).w,d4
                bra.s   loc_19E34
; ---------------------------------------------------------------------------

loc_19E1A:
                move.w  (Camera_Y_pos).w,d3
                andi.w  #$FF80,d3
                move.w  d3,d4
                addi.w  #$200,d4
                subi.w  #$80,d3
                bpl.s   loc_19E30
                moveq   #0,d3

loc_19E30:
                lea     loc_1A062(pc),a6

loc_19E34:
                move.w  #$FFF,d5
                move.w  (Camera_X_pos).w,d6
                andi.w  #$FF80,d6
                cmp.w   (Camera_X_pos_coarse).w,d6
                beq.w   loc_19EEA
                bge.s   loc_19EA2
                move.w  d6,(Camera_X_pos_coarse).w
                movea.l (Object_load_addr_back).w,a0
                movea.w (Object_respawn_index_back).w,a3
                subi.w  #$80,d6
                bcs.s   loc_19E78
                jsr     AllocateObject(pc)
                bne.s   loc_19E78

loc_19E62:
                cmp.w   -6(a0),d6
                bge.s   loc_19E78
                subq.w  #6,a0
                subq.w  #1,a3
                jsr     (a6)
                bne.s   loc_19E74
                subq.w  #6,a0
                bra.s   loc_19E62
; ---------------------------------------------------------------------------

loc_19E74:
                addq.w  #6,a0
                addq.w  #1,a3

loc_19E78:
                move.l  a0,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w
                movea.l (Object_load_addr_front).w,a0
                movea.w (Object_respawn_index_front).w,a3
                addi.w  #$300,d6

loc_19E8C:
                cmp.w   -6(a0),d6
                bgt.s   loc_19E98
                subq.w  #6,a0
                subq.w  #1,a3
                bra.s   loc_19E8C
; ---------------------------------------------------------------------------

loc_19E98:
                move.l  a0,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                bra.s   loc_19EEA
; ---------------------------------------------------------------------------

loc_19EA2:
                move.w  d6,(Camera_X_pos_coarse).w
                movea.l (Object_load_addr_front).w,a0
                movea.w (Object_respawn_index_front).w,a3
                addi.w  #$280,d6
                jsr     AllocateObject(pc)
                bne.s   loc_19EC2

loc_19EB8:
                cmp.w   (a0),d6
                bls.s   loc_19EC2
                jsr     (a6)
                addq.w  #1,a3
                beq.s   loc_19EB8

loc_19EC2:
                move.l  a0,(Object_load_addr_front).w
                move.w  a3,(Object_respawn_index_front).w
                movea.l (Object_load_addr_back).w,a0
                movea.w (Object_respawn_index_back).w,a3
                subi.w  #$300,d6
                bcs.s   loc_19EE2

loc_19ED8:
                cmp.w   (a0),d6
                bls.s   loc_19EE2
                addq.w  #6,a0
                addq.w  #1,a3
                bra.s   loc_19ED8
; ---------------------------------------------------------------------------

loc_19EE2:
                move.l  a0,(Object_load_addr_back).w
                move.w  a3,(Object_respawn_index_back).w

loc_19EEA:
                move.w  (Camera_Y_pos).w,d6
                andi.w  #$FF80,d6
                move.w  d6,d3
                cmp.w   (Camera_Y_pos_coarse).w,d6
                beq.w   loc_19FCA
                bge.s   loc_19F26
                tst.w   (Camera_min_Y_pos).w
                bpl.s   loc_19F1C
                tst.w   d6
                bne.s   loc_19F10
                cmpi.w  #$80,(Camera_Y_pos_coarse).w
                bne.s   loc_19F38

loc_19F10:
                subi.w  #$80,d3
                bpl.s   loc_19F52
                and.w   (Screen_Y_wrap_value).w,d3
                bra.s   loc_19F52
; ---------------------------------------------------------------------------

loc_19F1C:
                subi.w  #$80,d3
                bmi.w   loc_19FCA
                bra.s   loc_19F52
; ---------------------------------------------------------------------------

loc_19F26:
                tst.w   (Camera_min_Y_pos).w
                bpl.s   loc_19F48
                tst.w   (Camera_Y_pos_coarse).w
                bne.s   loc_19F38
                cmpi.w  #$80,d6
                bne.s   loc_19F10

loc_19F38:
                addi.w  #$180,d3
                cmp.w   (Screen_Y_wrap_value).w,d3
                blo.s   loc_19F52
                and.w   (Screen_Y_wrap_value).w,d3
                bra.s   loc_19F52
; ---------------------------------------------------------------------------

loc_19F48:
                addi.w  #$180,d3
                cmp.w   (Screen_Y_wrap_value).w,d3
                bhi.s   loc_19FCA

loc_19F52:
                jsr     AllocateObject(pc)
                bne.s   loc_19FCA
                move.w  d3,d4
                addi.w  #$80,d4
                move.w  #$FFF,d5
                movea.l (Object_load_addr_back).w,a0
                movea.w (Object_respawn_index_back).w,a3
                move.l  (Object_load_addr_front).w,d7
                sub.l   a0,d7
                beq.s   loc_19FCA
                addq.w  #2,a0

loc_19F74:
                tst.b   (a3)
                bmi.s   loc_19FC2
                move.w  (a0),d1
                and.w   d5,d1
                cmp.w   d3,d1
                blo.s   loc_19FC2
                cmp.w   d4,d1
                bhi.s   loc_19FC2
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
                bne.s   loc_19FCA

loc_19FC2:
                addq.w  #6,a0
                addq.w  #1,a3
                subq.w  #6,d7
                bne.s   loc_19F74

loc_19FCA:
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

loc_1A010:
                tst.b   (a3)
                bpl.s   loc_1A01A
                addq.w  #6,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

loc_1A01A:
                move.w  (a0)+,d7
                move.w  (a0)+,d1
                move.w  d1,d2
                bmi.s   loc_1A032
                and.w   d5,d1
                cmp.w   d3,d1
                bhs.s   loc_1A034
                cmp.w   d4,d1
                bls.s   loc_1A034
                addq.w  #2,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

loc_1A032:
                and.w   d5,d1

loc_1A034:
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

loc_1A062:
                tst.b   (a3)
                bpl.s   loc_1A06C
                addq.w  #6,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

loc_1A06C:
                move.w  (a0)+,d7
                move.w  (a0)+,d1
                move.w  d1,d2
                bmi.s   loc_1A084
                and.w   d5,d1
                cmp.w   d3,d1
                blo.s   loc_1A07E
                cmp.w   d4,d1
                bls.s   loc_1A086

loc_1A07E:
                addq.w  #2,a0
                moveq   #0,d1
                rts
; ---------------------------------------------------------------------------

loc_1A084:
                and.w   d5,d1

loc_1A086:
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
                bmi.s   locret_1A0C0

loc_1A0B6:
                lea     next_object(a1),a1
                tst.l   (a1)
                dbeq    d0,loc_1A0B6

locret_1A0C0:
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

loc_1A154:
                lea     next_object(a1),a1
                tst.l   (a1)
                beq.s   loc_1A168
                move.w  respawn_addr(a1),d0
                beq.s   loc_1A168
                movea.w d0,a2
                bclr    #7,(a2)

loc_1A168:
                dbf     d1,loc_1A154
                lea     (Ring_consumption_table).w,a2
                move.w  (a2)+,d1
                subq.w  #1,d1
                bcs.s   locret_1A18C

loc_1A176:
                move.w  (a2)+,d0
                beq.s   loc_1A176
                movea.w d0,a1
                move.w  #-1,(a1)
                clr.w   -2(a2)
                subq.w  #1,(Ring_consumption_table).w
                dbf     d1,loc_1A176

locret_1A18C:
                rts
