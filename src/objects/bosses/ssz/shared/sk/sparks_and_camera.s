; Owner: objects/bosses/ssz/shared/sk
; Responsibility: Mecha Sonic spark effects, parent interaction and associated camera transition callbacks
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MechaSonic_Sparks:
                lea     ObjDat_MechaSonic_Sparks(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_7C964,(a0)
                bclr    #7,subtype(a0)
                beq.s   loc_7C964
                bclr    #2,render_flags(a0)

loc_7C964:
                movea.w parent3(a0),a1
                btst    #6,$38(a1)
                bne.w   loc_7C8F8
                cmpi.w  #$E88,(Normal_palette_line_2+$12).w
                bne.w   locret_7B448
                moveq   #signextendB(sfx_MechaSpark),d0
                jsr     (Play_SFX).l
                moveq   #0,d0
                bchg    #0,$39(a0)
                bne.s   loc_7C990
                moveq   #4,d0

loc_7C990:
                add.b   subtype(a0),d0
                lea     byte_7C9AA(pc,d0.w),a2
                move.w  (a2)+,child_dx(a0)              ; and child_dy
                move.b  (a2)+,mapping_frame(a0)
                jsr     Refresh_ChildPositionAdjusted(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
byte_7C9AA:
                dc.b    -4,  $C,   4
                even
                dc.b    0,   8,   5
                even
                dc.b    8,   4,   6
                even
                dc.b    8,   4,   7
                even
; ---------------------------------------------------------------------------

loc_7C9BA:
                lea     word_7D3FC(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #loc_7C9C8,(a0)

loc_7C9C8:
                bsr.w   sub_7D260
                jsr     Refresh_ChildPositionAdjusted(pc)
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                bne.s   loc_7C9E2
                jmp     (Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

loc_7C9E2:
                jmp     (Go_Delete_Sprite).l
; ---------------------------------------------------------------------------

loc_7C9E8:
                move.b  #1,(Scroll_lock).w
                move.l  #loc_7C9F6,(a0)
                rts
; ---------------------------------------------------------------------------

loc_7C9F6:
                bsr.w   sub_7D150
                move.w  (Camera_X_pos).w,d0
                move.w  x_vel(a0),d1
                move.w  (Camera_max_X_pos).w,d2
                addq.w  #6,d0
                cmp.w   d2,d0
                bhs.s   loc_7CA12
                move.w  d0,(Camera_X_pos).w
                rts
; ---------------------------------------------------------------------------

loc_7CA12:
                move.w  d2,(Camera_X_pos).w
                jmp     (Delete_Current_Sprite).l
; End of function loc_7C9F6
