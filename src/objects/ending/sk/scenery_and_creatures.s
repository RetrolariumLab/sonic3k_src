; Owner: objects/ending/sk
; Responsibility: Ending scenery, island-lift and animal child actors with scene-relative drawing or cleanup
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_5EBC6:
                move.l  #loc_5EBE4,(a0)
                lea     (SSZMechaMasterEmerald_Attributes).l,a1
                jsr     (SetUp_ObjAttributes).l
                addi.w  #make_art_tile($000,2,0),art_tile(a0)
                move.b  #2,mapping_frame(a0)

loc_5EBE4:
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5EBF0:
                lea     word_600F2(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_5EC14,(a0)

loc_5EC00:
                movea.w parent3(a0),a1
                btst    #2,render_flags(a1)
                bne.s   locret_5EC12
                bclr    #2,render_flags(a0)

locret_5EC12:
                rts
; ---------------------------------------------------------------------------

loc_5EC14:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_5EC36
                btst    #1,(V_int_run_count+3).w
                bne.w   locret_5FF1A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5EC36:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_5EC3C:
                lea     word_600F8(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_5EC4E,(a0)
                bra.s   loc_5EC00
; ---------------------------------------------------------------------------

loc_5EC4E:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  mapping_frame(a1),d0
                subq.w  #1,d0
                add.w   d0,d0
                move.w  byte_5EC8E(pc,d0.w),child_dx(a0)  ; and child_dy
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.s   loc_5EC36
                move.b  #$16,mapping_frame(a0)
                btst    #1,(V_int_run_count+3).w
                beq.s   loc_5EC88
                move.b  #$17,mapping_frame(a0)

loc_5EC88:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
byte_5EC8E:
                dc.b    -$A,  $C
                dc.b    -9,  $B
                dc.b    -8,   9
                even
; ---------------------------------------------------------------------------

loc_5EC94:
                lea     word_600FE(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_5ECA8,(a0)
                bra.w   loc_5EC00
; ---------------------------------------------------------------------------

loc_5ECA8:
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Child_Draw_Sprite2).l
; ---------------------------------------------------------------------------

loc_5ECB4:
                lea     ObjDat3_600E6(pc),a1
                jsr     (SetUp_ObjAttributes).l
                movea.w parent3(a0),a1
                bclr    #7,art_tile(a0)
                btst    #7,art_tile(a1)
                beq.s   loc_5ECD6
                bset    #7,art_tile(a0)

loc_5ECD6:
                btst    #2,render_flags(a1)
                bne.s   loc_5ECE4
                bclr    #2,render_flags(a0)

loc_5ECE4:
                move.l  #loc_5ED18,(a0)
                move.w  (Player_mode).w,d0
                cmpi.w  #3,d0
                bne.s   loc_5ECFC
                tst.b   (_unkFA88).w
                bmi.s   loc_5ECFC
                addq.w  #1,d0

loc_5ECFC:
                add.w   d0,d0
                tst.b   subtype(a0)
                beq.s   loc_5ED06
                addq.b  #1,d0

loc_5ED06:
                move.b  byte_5ED0E(pc,d0.w),mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------
byte_5ED0E:
                dc.b    $C,  $E
                dc.b    $C,  $E
                dc.b    $D,  $F
                dc.b    $13, $14
                dc.b    $13, $15
; ---------------------------------------------------------------------------

loc_5ED18:
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.w   loc_5EC36
                bsr.w   EndingAttachment_SetOffsetsFromPose
                jsr     (Refresh_ChildPositionAdjusted).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5ED36:
                lea     word_60110(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_5ED4A,(a0)
                bra.w   loc_5EC00
; ---------------------------------------------------------------------------

loc_5ED4A:
                jsr     (Child_GetPriority).l
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #5,$38(a1)
                bne.w   loc_5EC36
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5ED6A:
                lea     word_600F8(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_5ED7E,(a0)
                bra.w   loc_5EC00
; ---------------------------------------------------------------------------

loc_5ED7E:
                jsr     (Refresh_ChildPositionAdjusted).l
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                bne.w   loc_5EC36
                move.b  #$18,mapping_frame(a0)
                btst    #1,(V_int_run_count+3).w
                beq.s   loc_5EDA6
                move.b  #$19,mapping_frame(a0)

loc_5EDA6:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5EDAC:
                move.l  #Map_IslandLiftGfx,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_IslandLiftGfx,3,1),art_tile(a0)
                move.w  #$300,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  x_pos(a0),$3A(a0)
                move.w  y_pos(a0),$3C(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                subi.b  #$41,d0
                bcc.s   loc_5EDE6
                moveq   #0,d0

loc_5EDE6:
                add.w   d0,d0
                move.w  off_5EDF0(pc,d0.w),d0
                jmp     off_5EDF0(pc,d0.w)
; ---------------------------------------------------------------------------
off_5EDF0:
                dc.w    loc_5EDFE-off_5EDF0
                dc.w    loc_5EE18-off_5EDF0
                dc.w    loc_5EE3C-off_5EDF0
                dc.w    loc_5EE5E-off_5EDF0
                dc.w    loc_5EE86-off_5EDF0
                dc.w    loc_5EE86-off_5EDF0
                dc.w    loc_5EE86-off_5EDF0
; ---------------------------------------------------------------------------

loc_5EDFE:
                move.l  #loc_5EEC4,(a0)
                bset    #2,render_flags(a0)
                move.w  (Camera_Y_pos_copy).w,$3A(a0)
                bclr    #7,art_tile(a0)
                rts
; ---------------------------------------------------------------------------

loc_5EE18:
                move.l  #loc_5EF28,(a0)
                move.b  #4,mapping_frame(a0)
                move.b  $2D(a0),d0
                move.b  d0,$24(a0)
                cmpi.w  #3,(Player_mode).w
                bne.s   locret_5EE3A
                bset    #2,render_flags(a0)

locret_5EE3A:
                rts
; ---------------------------------------------------------------------------

loc_5EE3C:
                move.l  #loc_5EF5C,(a0)
                move.b  #$1A,mapping_frame(a0)
                move.l  #AniRaw_60281,$30(a0)
                tst.b   $2D(a0)
                beq.s   locret_5EE5C
                move.b  #$18,$24(a0)

locret_5EE5C:
                rts
; ---------------------------------------------------------------------------

loc_5EE5E:
                move.l  #loc_5EF5C,(a0)
                move.b  #$1A,mapping_frame(a0)
                move.l  #AniRaw_60289,$30(a0)
                tst.b   subtype(a0)
                cmpi.b  #8,$2D(a0)
                blo.s   locret_5EE84
                move.b  #$10,$24(a0)

locret_5EE84:
                rts
; ---------------------------------------------------------------------------

loc_5EE86:
                bclr    #7,art_tile(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                subi.b  #$45,d0
                lsl.w   #2,d0
                move.l  off_5EEB8(pc,d0.w),$30(a0)
                move.l  #loc_5EF5C,(a0)
                bset    #2,render_flags(a0)
                tst.b   $2D(a0)
                beq.s   locret_5EEB6
                move.b  #$C,$24(a0)

locret_5EEB6:
                rts
; ---------------------------------------------------------------------------
off_5EEB8:
                dc.l    AniRaw_6028F
                dc.l    AniRaw_60295
                dc.l    AniRaw_6029B
; ---------------------------------------------------------------------------

loc_5EEC4:
                move.w  (Camera_Y_pos_copy).w,d0
                sub.w   $3A(a0),d0
                cmpi.w  #$10,d0
                blt.s   loc_5EF04
                move.l  #loc_5EF08,(a0)
                bclr    #2,render_flags(a0)
                move.w  #$10,y_vel(a0)
                move.w  x_pos(a0),d0
                sub.w   (Camera_X_pos_copy).w,d0
                addi.w  #$80,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos_copy).w,d0
                addi.w  #$80,d0
                move.w  d0,y_pos(a0)

loc_5EF04:
                bra.w   loc_5EF0E
; ---------------------------------------------------------------------------

loc_5EF08:
                jsr     (MoveSprite2).l

loc_5EF0E:
                lea     AniRaw_60276(pc),a1
                jsr     (Animate_RawNoSST).l
                btst    #0,(V_int_run_count+3).w
                bne.w   locret_5FF1A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5EF28:
                lea     AniRaw_6027C(pc),a1
                jsr     (Animate_RawNoSST).l
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_5EF3E
                bsr.w   Ending_ProjectActorAndFlagOutside

loc_5EF3E:
                btst    #3,(_unkFAB8).w
                bne.s   loc_5EF56
                btst    #6,$38(a0)
                bne.w   locret_5FF1A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5EF56:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_5EF5C:
                jsr     (Animate_Raw).l
                jmp     (Draw_Sprite).l
; End of function loc_5EF5C
