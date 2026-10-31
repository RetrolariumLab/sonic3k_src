; Owner: objects/interface/blue_sphere/sk
; Responsibility: Shared difficulty-screen Mecha Sonic portrait and Master Emerald display widgets, pattern selection and palette animation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Difficulty_MechaSonic:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Difficulty_MechaSonic_Index(pc,d0.w),d1
                jsr     Difficulty_MechaSonic_Index(pc,d1.w)
                lea     DPLCPtr_MechaSonic(pc),a2
                jsr     (Perform_DPLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Difficulty_MechaSonic_Index:
                dc.w    Difficulty_MechaSonic_Init-Difficulty_MechaSonic_Index
                dc.w    Difficulty_MechaSonic_Return-Difficulty_MechaSonic_Index
; ---------------------------------------------------------------------------

Difficulty_MechaSonic_Init:
                lea     ObjSlot_MechaSonic(pc),a1
                jsr     (SetUp_ObjAttributesSlotted).l
                move.w  #make_art_tile(ArtTile_MechaSonic,2,0),art_tile(a0)
                bclr    #2,render_flags(a0)
                bset    #0,render_flags(a0)
                move.w  #$D8,x_pos(a0)
                move.w  #$104,y_pos(a0)

Difficulty_MechaSonic_Return:
                rts
; ---------------------------------------------------------------------------

Obj_Difficulty_MasterEmerald:
                move.l  #Map_SSZMasterEmerald,mappings(a0)
                move.w  #make_art_tile(ArtTile_SSZMasterEmerald,3,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #$120,x_pos(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_7D03E(pc,d0.w),y_pos(a0)
                move.l  #loc_7D042,(a0)
                cmpi.b  #7,(Super_emerald_count).w
                beq.s   locret_7D03C
                move.l  #loc_7D050,(a0)

locret_7D03C:
                rts
; ---------------------------------------------------------------------------
word_7D03E:
                dc.w    $F0,  $120
; ---------------------------------------------------------------------------

loc_7D042:
                lea     off_7DD5A(pc),a1
                lea     (Normal_palette_line_4+$1C).w,a2
                jsr     (Run_PalRotationScript2).l

loc_7D050:
                jmp     (Draw_Sprite).l
; End of function Obj_Difficulty_MasterEmerald
