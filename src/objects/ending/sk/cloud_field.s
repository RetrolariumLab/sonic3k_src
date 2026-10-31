; Owner: objects/ending/sk
; Responsibility: Ending cloud generator, seeded velocity or position selection and individual cloud movement
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_5F94C:
                move.l  #loc_5F986,(a0)
                move.l  (V_int_run_count).w,(RNG_seed).w
                lea     (Pal_FBZCloud).l,a1
                lea     (Normal_palette).w,a2
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_5F96E
                lea     (Normal_palette_line_2).w,a2

loc_5F96E:
                moveq   #bytesToLcnt($10),d0

loc_5F970:
                move.l  (a1)+,(a2)+
                dbf     d0,loc_5F970
                lea     (ArtKosM_FBZCloud).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_Cloud),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_5F986:
                tst.b   (_unkFAB9).w
                beq.w   loc_5EC36
                move.b  (V_int_run_count+3).w,d0
                and.b   (_unkFAB9).w,d0
                bne.w   locret_5FA56
                addq.b  #1,$39(a0)
                jsr     (AllocateObject).l
                bne.w   locret_5FA56
                jsr     (Random_Number).l
                move.l  #loc_5FA58,(a1)
                move.b  d0,subtype(a1)
                move.w  (_unkFAC2).w,d2
                beq.s   loc_5F9D0
                move.w  d0,d1
                andi.w  #$3F,d1
                tst.w   d2
                bpl.s   loc_5F9CA
                neg.w   d1

loc_5F9CA:
                add.w   d2,d1
                move.w  d1,x_vel(a1)

loc_5F9D0:
                move.w  (_unkFAC4).w,d3
                beq.s   loc_5F9EA
                move.l  d0,d1
                swap    d1
                andi.w  #$3F,d1
                tst.w   d3
                bpl.s   loc_5F9E4
                neg.w   d1

loc_5F9E4:
                add.w   d3,d1
                move.w  d1,y_vel(a1)

loc_5F9EA:
                tst.w   d2
                beq.s   loc_5FA1C
                tst.w   d3
                beq.s   loc_5F9FA
                btst    #0,$39(a0)
                bne.s   loc_5FA1C

loc_5F9FA:
                move.w  #$50,d1
                tst.w   d2
                bpl.s   loc_5FA06
                move.w  #$1F0,d1

loc_5FA06:
                move.w  d1,x_pos(a1)
                move.w  d0,d1
                andi.w  #$FF,d1
                addi.w  #$80,d1
                move.w  d1,y_pos(a1)
                bra.w   loc_5FA4A
; ---------------------------------------------------------------------------

loc_5FA1C:
                move.w  #$60,d1
                tst.w   d3
                bpl.s   loc_5FA28
                move.w  #$180,d1

loc_5FA28:
                move.w  d1,y_pos(a1)
                move.w  d0,d1
                andi.w  #$1FF,d1
                move.w  d1,d2
                subi.w  #$160,d2
                bcs.s   loc_5FA42
                add.w   d2,d2
                addi.w  #$10,d2
                move.w  d2,d1

loc_5FA42:
                addi.w  #$70,d1
                move.w  d1,x_pos(a1)

loc_5FA4A:
                moveq   #1,d1
                tst.w   d0
                bpl.s   loc_5FA52
                moveq   #3,d1

loc_5FA52:
                move.b  d1,mapping_frame(a1)

locret_5FA56:
                rts
; ---------------------------------------------------------------------------

loc_5FA58:
                move.l  #loc_5FA8C,(a0)
                move.l  #Map_FBZ2Preboss,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_Cloud,0,0),art_tile(a0)
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_5FA7A
                move.w  #make_art_tile(ArtTile_Ending_Cloud,1,0),art_tile(a0)

loc_5FA7A:
                move.w  #$300,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$10,height_pixels(a0)

loc_5FA8C:
                move.w  (_unkFAC2).w,d0
                beq.s   loc_5FAA0
                move.w  x_vel(a0),d1
                add.w   d0,d1
                ext.l   d1
                lsl.l   #8,d1
                add.l   d1,x_pos(a0)

loc_5FAA0:
                move.w  (_unkFAC4).w,d2
                beq.s   loc_5FAB4
                move.w  y_vel(a0),d3
                add.w   d2,d3
                ext.l   d3
                lsl.l   #8,d3
                add.l   d3,y_pos(a0)

loc_5FAB4:
                cmpi.w  #$200,x_pos(a0)
                bhs.w   loc_5EC36
                cmpi.w  #$200,y_pos(a0)
                bhs.w   loc_5EC36
                jmp     (Draw_Sprite).l
