; Owner: objects/zones/hpz/sk
; Responsibility: Hidden Palace Master Emerald actor, hub state and player interaction
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_HPZMasterEmerald:
                lea     ObjDat_HPZMasterEmerald(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_90700,(a0)
                move.w  a0,(_unkFABA).w
                move.b  #-$10,(_unkFABC).w
                move.b  #-$18,(_unkFABD).w
                lea     (off_914CE).l,a1
                lea     (Palette_rotation_data).w,a2
                move.l  (a1)+,(a2)+
                move.l  (a1)+,(a2)+
                clr.w   (a2)
                move.w  #$1640,x_pos(a0)
                move.w  #$340,y_pos(a0)
                move.w  #8000-1,(Palette_cycle_counter1).w
                lea     (Collected_emeralds_array).w,a1
                moveq   #3,d0
                moveq   #7-1,d1

loc_906EA:
                cmp.b   (a1)+,d0
                bne.s   loc_90700
                dbf     d1,loc_906EA
                st      $26(a0)
                lea     ChildObjDat_90FE4(pc),a2
                jsr     (CreateChild6_Simple).l

loc_90700:
                tst.b   render_flags(a0)
                bpl.s   loc_9072E
                tst.b   $26(a0)
                bne.s   loc_9071A
                move.l  #$6A00660,(Normal_palette_line_4+$2).w
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

loc_9071A:
                tst.b   (_unkFAC1).w
                bne.s   loc_9072E
                lea     off_914CE(pc),a1
                lea     (Normal_palette_line_4+$2).w,a2
                jsr     (Run_PalRotationScript2).l

loc_9072E:
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------

loc_90734:
                lea     word_90FB8(pc),a1
                jsr     (SetUp_ObjAttributes2).l
                move.l  #loc_90744,(a0)

loc_90744:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                moveq   #0,d0
                move.b  $3B(a1),d0
                lsr.w   #1,d0
                move.b  RawAni_90768(pc,d0.w),mapping_frame(a0)
                jmp     (Child_Draw_Sprite).l
; ---------------------------------------------------------------------------
RawAni_90768:
                dc.b    $1D, $1D, $1D,  $C,  $D,  $E, $1D,  $F, $10, $11, $1D, $1D
                even
; End of function Obj_HPZMasterEmerald
