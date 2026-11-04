; Owner: objects/ending/sk
; Responsibility: Eggman and EggRobo ending eyecatch state machines, attached effects and palette or graphics preparation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_5F566:
                lea     ObjDat3_6018E(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_5F5B4,(a0)
                bclr    #2,render_flags(a0)
                move.w  #$110,x_pos(a0)
                move.w  #$F0,y_pos(a0)
                move.w  #$4AF,$2E(a0)
                lea     (Pal_EndingEyecatchEggman).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_5F59A:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_5F59A
                bsr.w   EndingSpawnLineTwoPaletteFadeAndStoreHandle
                lea     (ArtKosM_RobotnikSmug).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_EyecatchEggman),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_5F5B4:
                lea     AniRaw_602C6(pc),a1
                jsr     (Animate_RawNoSST).l
                bra.w   loc_5F2F8
; ---------------------------------------------------------------------------

loc_5F5C2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5F5D6(pc,d0.w),d1
                jsr     off_5F5D6(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_5F5D6:
                dc.w    loc_5F5DE-off_5F5D6
                dc.w    loc_5F654-off_5F5D6
                dc.w    loc_5F66A-off_5F5D6
                dc.w    loc_5F682-off_5F5D6
; ---------------------------------------------------------------------------

loc_5F5DE:
                lea     ObjDat3_6019A(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$108,y_pos(a0)
                move.w  #$EF,$2E(a0)
                lea     (Pal_EndingEyecatchEggRobo).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_5F60C:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_5F60C
                bsr.w   EndingSpawnLineTwoPaletteFadeAndStoreHandle
                lea     ChildObjDat_60220(pc),a2
                jsr     (CreateChild1_Normal).l
                jsr     (AllocateObject).l
                bne.s   loc_5F644
                move.w  a1,parent3(a1)
                move.l  #SpriteMask_InitializeMappingsAndSubtype,(a1)
                move.w  #$120,x_pos(a1)
                move.w  #$124,y_pos(a1)
                move.b  #$8A,subtype(a1)

loc_5F644:
                lea     (ArtKosM_EggRoboSKEnding).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_EyecatchEggRobo),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_5F654:
                btst    #2,$38(a0)
                beq.s   locret_5F668
                move.b  #4,routine(a0)
                move.w  #$1F,$2E(a0)

locret_5F668:
                rts
; ---------------------------------------------------------------------------

loc_5F66A:
                subq.w  #1,y_pos(a0)
                subq.w  #1,$2E(a0)
                bpl.s   locret_5F680
                move.b  #6,routine(a0)
                move.w  #$4AF,$2E(a0)

locret_5F680:
                rts
; ---------------------------------------------------------------------------

loc_5F682:
                lea     AniRaw_602C2(pc),a1
                jsr     (Animate_RawNoSST).l
                bra.w   loc_5F2F8
; ---------------------------------------------------------------------------

loc_5F690:
                lea     word_601A6(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #Draw_Sprite,(a0)
                bclr    #2,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_5F6A8:
                lea     word_601AC(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                bclr    #2,render_flags(a0)
                move.l  #loc_5F6C4,(a0)
                move.w  #(2*60)-1,$2E(a0)

loc_5F6C4:
                subq.w  #1,$2E(a0)
                bpl.s   locret_5F6D8
                move.l  #loc_5F6DA,(a0)
                move.l  #loc_5F6EA,$34(a0)

locret_5F6D8:
                rts
; ---------------------------------------------------------------------------

loc_5F6DA:
                lea     AniRaw_602A7(pc),a1
                jsr     (Animate_RawNoSSTMultiDelay).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5F6EA:
                move.l  #loc_5F6FC,(a0)
                movea.w parent3(a0),a1
                bset    #2,$38(a1)
                rts
; ---------------------------------------------------------------------------

loc_5F6FC:
                move.b  #-$14,child_dy(a0)
                movea.w parent3(a0),a1
                tst.b   mapping_frame(a1)
                beq.s   loc_5F712
                move.b  #-$13,child_dy(a0)

loc_5F712:
                jsr     (Refresh_ChildPosition).l
                jmp     (Draw_Sprite).l
