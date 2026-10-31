; Owner: objects/bosses/dez/final_boss/sk
; Responsibility: Death Egg final-boss body and arm actors, collision states, animation and parent-relative motion
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_806DA:
                lea     ObjDat3_812D4(pc),a1
                jsr     (SetUp_ObjAttributes).l
                lea     (Collected_emeralds_array).w,a1
                moveq   #3,d0
                moveq   #7-1,d1

loc_806EC:
                cmp.b   (a1)+,d0
                bne.s   loc_8070A
                dbf     d1,loc_806EC
                st      $3A(a0)
                lea     word_813AA(pc),a1
                lea     (Palette_rotation_data).w,a2
                moveq   #bytesToLcnt($10),d0

loc_80702:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_80702
                clr.w   (a2)

loc_8070A:
                tst.b   $2C(a0)
                bne.s   loc_80724
                move.l  #loc_80730,(a0)
                move.w  #$58,$42(a0)
                move.w  #8,$44(a0)
                rts
; ---------------------------------------------------------------------------

loc_80724:
                move.l  #loc_80760,(a0)
                clr.b   mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_80730:
                tst.b   $3A(a0)
                beq.s   loc_8073A
                jsr     Run_PalRotationScript(pc)

loc_8073A:
                bsr.w   sub_81024
                movea.w parent3(a0),a1
                btst    #4,$38(a1)
                bne.w   loc_810D0
                tst.b   (_unkFAA9).w
                beq.s   loc_80758
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_80758:
                bclr    #7,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_80760:
                tst.b   $3A(a0)
                beq.s   loc_8076A
                jsr     Run_PalRotationScript(pc)

loc_8076A:
                jsr     Refresh_ChildPosition(pc)
                btst    #4,(_unkFAB8).w
                beq.s   loc_8077C
                move.l  #loc_80782,(a0)

loc_8077C:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_80782:
                tst.b   $3A(a0)
                beq.s   loc_8078C
                jsr     Run_PalRotationScript(pc)

loc_8078C:
                jsr     (MoveSprite).l
                cmpi.w  #$CF,y_pos(a0)
                blo.s   loc_807A6
                move.l  #loc_807AC,(a0)
                move.w  #$CF,y_pos(a0)

loc_807A6:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_807AC:
                tst.b   $3A(a0)
                beq.s   loc_807B6
                jsr     Run_PalRotationScript(pc)

loc_807B6:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_807BC:
                lea     ObjDat3_812B6(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_807EE,(a0)
                move.w  #$58,$42(a0)
                move.w  #4,$44(a0)
                move.l  #loc_80802,$34(a0)
                move.b  #$13,$39(a0)
                moveq   #signextendB(sfx_Charging),d0
                jsr     (Play_SFX).l

loc_807EE:
                bsr.w   sub_80FFA
                lea     byte_8135A(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                bsr.w   sub_81024
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_80802:
                move.l  #loc_80810,(a0)
                move.w  #2*60,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_80810:
                subq.w  #1,$2E(a0)
                bmi.s   loc_8083C
                cmpi.w  #$28,$2E(a0)
                blo.s   loc_80822
                bsr.w   sub_80FFA

loc_80822:
                move.b  #$1A,mapping_frame(a0)
                btst    #0,d0
                bne.s   loc_80834
                move.b  #$1F,mapping_frame(a0)

loc_80834:
                bsr.w   sub_81024
                jmp     Child_Draw_Sprite(pc)
; ---------------------------------------------------------------------------

loc_8083C:
                move.l  #loc_8086C,(a0)
                addi.w  #$34,$42(a0)
                addi.w  #4,$44(a0)
                lea     byte_81397(pc),a1
                jsr     Set_Raw_Animation(pc)
                move.l  #loc_80888,$34(a0)
                bclr    #7,render_flags(a0)
                moveq   #signextendB(sfx_MissileExplode),d0
                jsr     (Play_SFX).l

loc_8086C:
                jsr     Animate_RawMultiDelay(pc)
                beq.s   loc_8087C
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                move.w  d0,(Events_bg+$10).w

loc_8087C:
                bsr.w   sub_80FA6
                bsr.w   sub_81024
                jmp     Child_CheckParent(pc)
; ---------------------------------------------------------------------------

loc_80888:
                move.l  #loc_80894,(a0)
                move.w  #$5F,$2E(a0)

loc_80894:
                subq.w  #1,$2E(a0)
                bmi.s   loc_8089E
                jmp     Child_CheckParent(pc)
; ---------------------------------------------------------------------------

loc_8089E:
                movea.w $3A(a0),a1
                bclr    #2,$38(a1)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_808AE:
                lea     word_812C2(pc),a1
                jsr     (SetUp_ObjAttributes3).l
                move.l  #loc_808FA,(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                addi.w  #$64,d2
                move.w  y_pos(a1),d3
                addq.w  #4,d3
                jsr     (Random_Number).l
                andi.w  #$1F,d0
                add.w   d0,d2
                swap    d0
                andi.w  #$7F,d0
                subi.w  #$40,d0
                add.w   d0,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_808FA:
                lea     byte_8138E(pc),a1
                jsr     Animate_RawNoSSTMultiDelay(pc)
                subi.w  #$40,x_vel(a0)
                movea.w parent3(a0),a1
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                jsr     (GetSineCosine).l
                add.w   d0,d0
                move.w  d0,y_vel(a0)
                jsr     (MoveSprite2).l
                move.w  x_pos(a1),d0
                addi.w  #$3C,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_8093A
                jsr     (Go_Delete_Sprite).l

loc_8093A:
                jmp     (Draw_Sprite).l
