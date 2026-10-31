; Owner: objects/ending/sk
; Responsibility: Mecha Sonic ending eyecatch, palette rotation, animation, launch and exit input
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_5F71E:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5F73E(pc,d0.w),d1
                jsr     off_5F73E(pc,d1.w)
                lea     (DPLCPtr_MechaSonic).l,a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_5F73E:
                dc.w    loc_5F74E-off_5F73E
                dc.w    loc_5F7CC-off_5F73E
                dc.w    loc_5F802-off_5F73E
                dc.w    loc_5F82C-off_5F73E
                dc.w    loc_5F82C-off_5F73E
                dc.w    loc_5F85A-off_5F73E
                dc.w    loc_5F82C-off_5F73E
                dc.w    loc_5F8A8-off_5F73E
; ---------------------------------------------------------------------------

loc_5F74E:
                clr.w   (Slotted_object_bits).w
                lea     (ObjSlot_MechaSonic).l,a1
                jsr     (SetUp_ObjAttributesSlotted).l
                bclr    #2,render_flags(a0)
                bset    #7,art_tile(a0)
                move.b  #$F,mapping_frame(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$F8,y_pos(a0)
                move.w  #$EF,$2E(a0)
                lea     (Pal_SSZGHZMisc).l,a1
                lea     (Target_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_5F78E:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_5F78E
                bsr.w   sub_5FDA4
                lea     (ChildObjDat_7D48C).l,a2
                jsr     (CreateChild6_Simple).l
                bne.s   loc_5F7AC
                move.b  #$80,subtype(a1)

loc_5F7AC:
                lea     (word_7D842).l,a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                lea     (ArtKosM_MechaSonicExtra).l,a1
                move.w  #tiles_to_bytes(ArtTile_MechaSonicExtra),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_5F7CC:
                subq.w  #1,$2E(a0)
                bmi.s   loc_5F7D8
                jmp     (Run_PalRotationScript).l
; ---------------------------------------------------------------------------

loc_5F7D8:
                move.b  #4,routine(a0)
                lea     (Pal_SSZGHZMisc).l,a1
                lea     (Normal_palette_line_2).w,a2
                moveq   #bytesToLcnt($20),d6

loc_5F7EA:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_5F7EA
                bset    #6,$38(a0)
                lea     (ChildObjDat_7D492).l,a2
                jmp     (CreateChild1_Normal).l
; ---------------------------------------------------------------------------

loc_5F802:
                btst    #6,$38(a0)
                bne.w   locret_5FF1A
                move.b  #6,routine(a0)
                move.b  #$E,mapping_frame(a0)
                move.l  #loc_5F832,$34(a0)
                lea     (byte_7D5EF).l,a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_5F82C:
                jmp     (Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_5F832:
                move.b  #8,routine(a0)
                move.l  #loc_5F84C,$34(a0)
                lea     (byte_7D5F6).l,a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_5F84C:
                move.b  #$A,routine(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_5F85A:
                jsr     (MoveSprite_LightGravity).l
                tst.w   y_vel(a0)
                bmi.w   locret_5FF1A
                cmpi.w  #$C8,y_pos(a0)
                blo.w   locret_5FF1A
                move.b  #$C,routine(a0)
                move.w  #$CC,y_pos(a0)
                move.l  #loc_5F89A,$34(a0)
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l
                lea     (byte_7D5AB).l,a1
                jmp     (Set_Raw_Animation).l
; ---------------------------------------------------------------------------

loc_5F89A:
                move.b  #$E,routine(a0)
                move.w  #$4AF,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_5F8A8:
                btst    #button_start,(Ctrl_1_held).w
                bne.s   loc_5F8BE
                btst    #button_start,(Ctrl_2_held).w
                bne.s   loc_5F8BE
                subq.w  #1,$2E(a0)
                bpl.s   locret_5F8C4

loc_5F8BE:
                move.b  #GameMode_SegaScreen,(Game_mode).w

locret_5F8C4:
                rts
