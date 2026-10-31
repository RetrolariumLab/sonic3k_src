; Owner: objects/ending/sk
; Responsibility: Ending Master Emerald actor state, movement and scene transitions
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_5DE60:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5DE74(pc,d0.w),d1
                jsr     off_5DE74(pc,d1.w)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_5DE74:
                dc.w    loc_5DE80-off_5DE74
                dc.w    loc_5DED4-off_5DE74
                dc.w    loc_5DEF0-off_5DE74
                dc.w    loc_5DF12-off_5DE74
                dc.w    loc_5DF34-off_5DE74
                dc.w    loc_5DF48-off_5DE74
; ---------------------------------------------------------------------------

loc_5DE80:
                move.b  #2,routine(a0)
                move.l  #Map_SSZMasterEmerald,mappings(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.b  #2,mapping_frame(a0)
                tst.b   subtype(a0)
                bne.s   loc_5DEC6
                move.w  #make_art_tile(ArtTile_Ending_MasterEmerald,2,1),art_tile(a0)
                move.w  #$280,priority(a0)
                tst.b   (_unkFA88).w
                bpl.s   locret_5DEC4
                move.b  #8,routine(a0)
                move.w  #(2*60)-1,$2E(a0)

locret_5DEC4:
                rts
; ---------------------------------------------------------------------------

loc_5DEC6:
                move.w  #make_art_tile(ArtTile_Ending_MasterEmerald,1,0),art_tile(a0)
                move.w  #$300,priority(a0)
                rts
; ---------------------------------------------------------------------------

loc_5DED4:
                btst    #0,(_unkFAB8).w
                bne.s   loc_5DEDE
                rts
; ---------------------------------------------------------------------------

loc_5DEDE:
                move.b  #4,routine(a0)
                move.w  #-$200,x_vel(a0)
                move.w  #$100,y_vel(a0)

loc_5DEF0:
                move.w  (_unkFAA4).w,d0
                bne.s   loc_5DEFC
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_5DEFC:
                move.b  #6,routine(a0)
                move.w  d0,parent3(a0)
                move.b  #-$20,child_dx(a0)
                move.b  #1,child_dy(a0)

loc_5DF12:
                jsr     (Refresh_ChildPosition).l
                cmpi.w  #$50,x_pos(a0)
                bls.s   loc_5DF2E
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_5DF2E
                rts
; ---------------------------------------------------------------------------

loc_5DF2E:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_5DF34:
                subq.w  #1,$2E(a0)
                bpl.s   locret_5DF46
                move.b  #$A,routine(a0)
                move.w  #-$80,y_vel(a0)

locret_5DF46:
                rts
; ---------------------------------------------------------------------------

loc_5DF48:
                jsr     (MoveSprite2).l
                cmpi.w  #$40,y_pos(a0)
                blo.s   loc_5DF2E
                rts
; ---------------------------------------------------------------------------

loc_5DF58:
                tst.b   (_unkFA88).w
                beq.s   locret_5DF7E
                bmi.s   locret_5DF7E
                move.b  (_unkFAC1).w,d0
                beq.s   locret_5DF7E
                lea     (off_7DD5A).l,a1
                lea     (Normal_palette_line_3+$1C).w,a2
                tst.b   d0
                bpl.s   loc_5DF78
                lea     (Normal_palette_line_2+$1C).w,a2

loc_5DF78:
                jsr     (Run_PalRotationScript2).l

locret_5DF7E:
                rts
; ---------------------------------------------------------------------------

loc_5DF80:
                lea     ObjDat3_60104(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                move.l  #loc_5DF98,(a0)
                rts
; ---------------------------------------------------------------------------

loc_5DF98:
                btst    #1,(_unkFAB8).w
                beq.s   loc_5DFA6
                move.l  #loc_5DFB2,(a0)

loc_5DFA6:
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5DFB2:
                move.b  child_dx(a0),d0
                subq.b  #2,d0
                move.b  d0,child_dx(a0)
                cmpi.b  #-$74,d0
                bgt.s   loc_5DFCC
                move.l  #loc_5DFD8,(a0)
                move.w  a0,(_unkFAA4).w

loc_5DFCC:
                jsr     (Refresh_ChildPosition).l
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5DFD8:
                jsr     (Refresh_ChildPosition).l
                cmpi.w  #$50,x_pos(a0)
                bls.w   loc_5EC36
                jmp     (Child_Draw_Sprite).l
