; Owner: objects/interface/s3
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
                cmpi.b  #$E,(Current_zone).w
                blo.s   loc_2CA96                       ; If in any of the 2P stages, don't show title card
                cmpi.b  #$12,(Current_zone).w
                bhi.s   loc_2CA96
                st      $44(a0)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2CA96:
                lea     (ArtKosM_TitleCardRedAct).l,a1
                move.w  #tiles_to_bytes($500),d2
                jsr     (Queue_Kos_Module).l
                lea     (ArtKosM_TitleCardNum1).l,a1
                tst.b   (Apparent_act).w
                beq.s   loc_2CAB8
                lea     (ArtKosM_TitleCardNum2).l,a1

loc_2CAB8:
                move.w  #tiles_to_bytes($53D),d2
                jsr     (Queue_Kos_Module).l
                lea     TitleCard_LevelGfx(pc),a1
                moveq   #0,d0
                move.b  (Apparent_zone).w,d0
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
                bne.w   locret_2CB76                    ; Wait for KosM queue to clear
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_2CB76
                lea     ObjArray_TtlCardBonus(pc),a2
                moveq   #1,d1
                cmpi.b  #$13,(Current_zone).w
                bhs.s   loc_2CB20
                lea     ObjArray_TtlCard(pc),a2
                moveq   #3,d1
                tst.b   $44(a0)
                beq.s   loc_2CB20
                lea     ObjArray_TtlCard2(pc),a2
                moveq   #0,d1

loc_2CB20:
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
                dbne    d1,loc_2CB20
                tst.b   $3E(a0)
                beq.s   loc_2CB72
                cmpi.b  #6,(Apparent_zone).w
                bne.s   loc_2CB72
                moveq   #PLCID_25,d0                    ; If title card is mid-level and it's in LBZ, load the LBZ 2 misc art
                jsr     (Load_PLC).l

loc_2CB72:
                addq.b  #2,routine(a0)

locret_2CB76:
                rts
; ---------------------------------------------------------------------------

Obj_TitleCardWait:
                tst.w   $34(a0)
                beq.s   loc_2CB84
                clr.w   $34(a0)
                rts
; ---------------------------------------------------------------------------

loc_2CB84:
                tst.w   $3E(a0)
                beq.s   loc_2CBC0
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

loc_2CBC0:
                clr.w   $48(a0)
                addq.b  #2,routine(a0)
                rts
; ---------------------------------------------------------------------------

Obj_TitleCardWait2:
                tst.w   $2E(a0)
                beq.s   loc_2CBD6
                subq.w  #1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_2CBD6:
                tst.w   $30(a0)
                beq.s   loc_2CBE2
                addq.w  #1,$32(a0)
                rts
; ---------------------------------------------------------------------------

loc_2CBE2:
                tst.b   $44(a0)
                bne.s   loc_2CC12
                cmpi.b  #$13,(Current_zone).w
                bhs.s   loc_2CC12
                tst.w   $3E(a0)
                beq.s   loc_2CBFC
                st      (End_of_level_flag).w           ; If in-level, set end of title card flag. No need to reload PLCs
                bra.s   loc_2CC08
; ---------------------------------------------------------------------------

loc_2CBFC:
                lea     (PLC_SpikesSprings).l,a1        ; Reload spikes
                jsr     (Load_PLC_Raw).l

loc_2CC08:
                jsr     LoadEnemyArt(pc)                ; Load animals and enemies
                jsr     (PLCLoad_AnimalsAndExplosion).l

loc_2CC12:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_TitleCardRedBanner:
                movea.w parent2(a0),a1
                move.w  $32(a1),d0
                beq.s   loc_2CC40
                tst.b   render_flags(a0)
                bmi.s   loc_2CC32
                subq.w  #1,$30(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2CC32:
                cmp.b   $28(a0),d0
                blo.s   loc_2CC56
                subi.w  #$20,y_pos(a0)
                bra.s   loc_2CC56
; ---------------------------------------------------------------------------

loc_2CC40:
                move.w  y_pos(a0),d0
                cmp.w   $46(a0),d0
                beq.s   loc_2CC56
                addi.w  #$10,d0
                move.w  d0,y_pos(a0)
                st      $34(a1)

loc_2CC56:
                move.b  #$70,height_pixels(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_TitleCardName:
                move.b  (Apparent_zone).w,d0
                add.b   d0,mapping_frame(a0)
                move.l  #Obj_TitleCardElement,(a0)

Obj_TitleCardElement:
                movea.w parent2(a0),a1
                move.w  $32(a1),d0
                beq.s   loc_2CC98
                tst.b   render_flags(a0)
                bmi.s   loc_2CC8A
                subq.w  #1,$30(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2CC8A:
                cmp.b   $28(a0),d0
                blo.s   loc_2CCAE
                addi.w  #$20,x_pos(a0)
                bra.s   loc_2CCAE
; ---------------------------------------------------------------------------

loc_2CC98:
                move.w  x_pos(a0),d0
                cmp.w   $46(a0),d0
                beq.s   loc_2CCAE
                subi.w  #$10,d0
                move.w  d0,x_pos(a0)
                st      $34(a1)

loc_2CCAE:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_TitleCardAct:
                move.l  #Obj_TitleCardElement,(a0)
                move.b  (Apparent_zone).w,d0
                cmpi.b  #$A,d0
                beq.s   loc_2CCCA
                cmpi.b  #$C,d0
                bne.s   Obj_TitleCardElement

loc_2CCCA:
                movea.w parent2(a0),a1                  ; Sky Sanctuary and Doomsday do not have act numbers
                subq.w  #1,$30(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_TitleCardElement2:
                clr.b   render_flags(a0)                ; I'm not entirely sure what this is used for
                movea.w parent2(a0),a1
                move.w  $32(a1),d0
                beq.s   loc_2CD06
                cmpi.w  #$20C,x_pos(a0)
                blo.s   loc_2CCF8
                subq.w  #1,$30(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2CCF8:
                cmp.b   $28(a0),d0
                blo.s   loc_2CD1C
                addi.w  #$20,x_pos(a0)
                bra.s   loc_2CD1C
; ---------------------------------------------------------------------------

loc_2CD06:
                move.w  x_pos(a0),d0
                cmp.w   $46(a0),d0
                beq.s   loc_2CD1C
                subi.w  #$10,d0
                move.w  d0,x_pos(a0)
                st      $34(a1)

loc_2CD1C:
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
                dc.l    ArtKosM_AIZTitleCard
                dc.l    ArtKosM_AIZTitleCard
                dc.l    ArtKosM_AIZTitleCard
                dc.l    ArtKosM_AIZTitleCard
                dc.l    ArtKosM_AIZTitleCard
                dc.l    ArtKosM_AIZTitleCard
                dc.l    ArtKosM_AIZTitleCard
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
