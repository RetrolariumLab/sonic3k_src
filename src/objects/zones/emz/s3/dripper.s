; Owner: objects/zones/emz/s3
; Responsibility: Endless Mine dripper timing, water-drop creation and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_EMZDripper:
                move.l  #Map_EMZDripper,mappings(a0)
                move.w  #make_art_tile(ArtTile_EMZMisc,3,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #4,x_radius(a0)
                move.b  #4,y_radius(a0)
                btst    #0,status(a0)
                beq.s   loc_376DC
                move.w  #make_art_tile(ArtTile_EMZMisc,2,1),art_tile(a0)
                move.b  #3,mapping_frame(a0)
                move.l  #Draw_Sprite,(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_376DC:
                move.l  #loc_376E2,(a0)

loc_376E2:
                move.b  (Level_frame_counter+1).w,d0
                add.b   subtype(a0),d0
                andi.b  #$7F,d0
                bne.s   loc_3771A
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_3771A
                moveq   #subtype,d0

loc_376FC:
                move.w  (a0,d0.w),(a1,d0.w)
                subq.w  #2,d0
                bcc.s   loc_376FC
                move.l  #loc_37720,(a1)
                move.w  #make_art_tile(ArtTile_EMZMisc,2,0),art_tile(a1)
                move.b  #1,mapping_frame(a1)
                moveq   #0,d0

loc_3771A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_37720:
                jsr     (MoveSprite2).l
                addi.w  #8,y_vel(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_3775A
                move.l  #loc_377C6,(a0)
                move.w  #$100,x_vel(a0)
                neg.w   y_vel(a0)
                asr     y_vel(a0)
                asr     y_vel(a0)
                move.b  #2,mapping_frame(a0)
                bsr.s   sub_37784
                bsr.s   sub_37784
                bsr.s   sub_37784

loc_3775A:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_3776A
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_3776A:
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$60,d0
                cmp.w   y_pos(a0),d0
                bge.s   loc_3777E
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3777E:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_37784:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   locret_377C4
                moveq   #subtype,d0

loc_37790:
                move.w  (a0,d0.w),(a1,d0.w)
                subq.w  #2,d0
                bcc.s   loc_37790
                jsr     (Random_Number).l
                move.w  d0,d1
                andi.w  #$1FF,d0
                subi.w  #$100,d0
                move.w  d0,x_vel(a1)
                rol.w   #4,d1
                andi.w  #$F,d1
                addi.w  #$1A,d1
                move.b  d1,$3C(a1)
                subi.w  #$10,y_vel(a0)
                moveq   #0,d0

locret_377C4:
                rts
; End of function sub_37784

; ---------------------------------------------------------------------------

loc_377C6:
                jsr     (MoveSprite2).l
                addi.w  #8,y_vel(a0)
                subq.b  #1,$3C(a0)
                bne.s   loc_377DE
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_377DE:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_EMZDripper:
                include "src/objects/shared/zones/emz/map_dripper.s"
; ---------------------------------------------------------------------------

locret_3780C:
                rts
