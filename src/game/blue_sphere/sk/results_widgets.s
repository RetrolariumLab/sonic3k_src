; Owner: game/blue_sphere/sk
; Responsibility: Blue Sphere results timing, perfect message, score elements and interface object states
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SphereResults_4DEF8:
                move.w  #5*60,$30(a0)
                move.l  #loc_4DF04,(a0)

loc_4DF04:
                subq.w  #1,$30(a0)
                bpl.s   loc_4DF3E
                tst.w   (Special_stage_rings_left).w
                bne.s   loc_4DF38
                move    #$2700,sr
                lea     aPerfect(pc),a1
                move.w  #$49A,d2
                move.w  #make_art_tile(ArtTile_BlueSphere_TitleText,0,1),d6
                jsr     (sub_5B318).l
                move    #$2300,sr
                moveq   #signextendB(sfx_Continue),d0
                jsr     (Play_SFX).l
                move.w  #5*60,$30(a0)

loc_4DF38:
                move.l  #loc_4DF52,(a0)

loc_4DF3E:
                tst.w   (Special_stage_rings_left).w
                beq.s   locret_4DF50
                move.b  (Ctrl_1_pressed).w,d0
                beq.s   locret_4DF50
                move.b  #GameMode_BlueSpheresTitle,(Game_mode).w

locret_4DF50:
                rts
; ---------------------------------------------------------------------------

loc_4DF52:
                tst.w   (Special_stage_rings_left).w
                bne.s   loc_4DF5E
                subq.w  #1,$30(a0)
                bmi.s   loc_4DF64

loc_4DF5E:
                move.b  (Ctrl_1_pressed).w,d0
                beq.s   loc_4DF6A

loc_4DF64:
                move.b  #GameMode_BlueSpheresTitle,(Game_mode).w

loc_4DF6A:
                move.b  (V_int_run_count+3).w,d0
                andi.b  #$F,d0
                bne.s   locret_4DF84
                lea     (H_scroll_buffer+$120).w,a1
                moveq   #$10-1,d1

loc_4DF7A:
                eori.w  #$100,(a1)
                addq.w  #4,a1
                dbf     d1,loc_4DF7A

locret_4DF84:
                rts
; ---------------------------------------------------------------------------

Obj_SphereResults_4DF86:
                move.l  #Map_Sonic,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_1,0,1),art_tile(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$100,y_pos(a0)
                move.w  #$80,priority(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #$13,anim(a0)
                cmpi.w  #1,(Player_mode).w
                beq.s   loc_4DFE8
                move.l  #Map_Knuckles,mappings(a0)
                move.b  #$24,anim(a0)
                lea     (Pal_Knuckles).l,a1
                lea     (Target_palette).w,a2
                moveq   #bytesToLcnt($20),d6

loc_4DFDA:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_4DFDA
                move.l  #loc_4E000,(a0)
                bra.s   loc_4E000
; ---------------------------------------------------------------------------

loc_4DFE8:
                move.l  #loc_4DFEE,(a0)

loc_4DFEE:
                jsr     (Animate_Sonic).l
                jsr     (Sonic_Load_PLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4E000:
                jsr     (Animate_Knuckles).l
                jsr     (Knuckles_Load_PLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_Sphere_Results_4E012:
                movea.l a0,a1
                moveq   #0,d0
                moveq   #0,d2
                moveq   #7-1,d1

loc_4E01A:
                move.l  #loc_4E074,(a1)
                move.l  #Map_BSResultsEmerald,mappings(a1)
                move.w  #make_art_tile(ArtTile_BlueSphere_Emeralds,0,0),art_tile(a1)
                move.w  #$80,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.b  d0,angle(a1)
                addi.b  #$24,d0
                move.b  d2,mapping_frame(a1)
                addq.b  #1,d2
                lea     next_object(a1),a1
                dbf     d1,loc_4E01A
                move.l  #loc_4E05C,(a0)

loc_4E05C:
                move.b  $27(a0),d0
                jsr     (GetSineCosine).l
                asl.w   #4,d0
                addi.w  #$4000,d0
                move.w  d0,(Stat_table).w
                addq.b  #1,$27(a0)

loc_4E074:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                move.w  (Stat_table).w,d2
                muls.w  d2,d1
                muls.w  d2,d0
                swap    d1
                swap    d0
                addi.w  #$120,d1
                addi.w  #$100,d0
                move.w  d1,x_pos(a0)
                move.w  d0,y_pos(a0)
                addq.b  #1,angle(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_SphereResults_4E0A4:
                move.l  #Map_BlueSpheresText,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Misc,0,1),art_tile(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$140,y_pos(a0)
                move.w  #$80,priority(a0)
                move.b  #$28,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #4,mapping_frame(a0)
                move.w  y_pos(a0),d3
                addi.w  #$10,d3
                movea.l a0,a1
                move.b  #$A,next_object+mapping_frame(a1)
                move.w  #$114,d2
                moveq   #4-1,d1

loc_4E0EC:
                lea     next_object(a1),a1
                move.l  #loc_4E1AA,(a1)
                move.w  d2,x_pos(a1)
                move.w  d3,y_pos(a1)
                addq.w  #8,d2
                dbf     d1,loc_4E0EC
                move.b  #$B,mapping_frame(a1)
                move.w  #$1D,$30(a0)
                move.l  #loc_4E116,(a0)

loc_4E116:
                moveq   #0,d1
                move.b  (Blue_spheres_difficulty).w,d1
                addq.b  #1,d1
                bsr.w   sub_4D1AA
                subq.w  #1,$30(a0)
                bpl.s   loc_4E146
                move.w  #$1D,$30(a0)
                move.b  (Blue_spheres_difficulty).w,d1
                cmp.b   (Blue_spheres_target_difficulty).w,d1
                beq.s   loc_4E146
                addq.b  #1,(Blue_spheres_difficulty).w
                bsr.s   Difficulty_Level_Sprites_Display
                moveq   #signextendB(sfx_LaunchReady),d0
                jsr     (Play_SFX).l

loc_4E146:
                move.b  #4,mapping_frame(a0)
                cmpi.b  #12,(Blue_spheres_difficulty).w
                bne.s   loc_4E15A
                move.b  #5,mapping_frame(a0)

loc_4E15A:
                jmp     (Draw_Sprite).l
