; Owner: objects/zones/fbz/sk
; Responsibility: Flamethrower timing, flame creation, flame motion and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZFlamethrower:
                move.l  #Map_FBZFlameThrower,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$A4,0,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$180,priority(a0)
                bset    #6,render_flags(a0)
                move.w  #3,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),d0
                addq.w  #8,d0
                move.w  d0,(a2)+
                move.w  y_pos(a0),d1
                move.w  d1,(a2)+
                move.w  #0,(a2)+
                move.w  x_pos(a0),(a2)+
                move.w  d1,(a2)+
                move.w  #$11,(a2)+
                subi.w  #$10,d0
                move.w  d0,(a2)+
                move.w  d1,(a2)+
                move.w  #$10,(a2)+
                move.b  #1,mapping_frame(a0)
                move.b  subtype(a0),d0
                bpl.s   loc_3CCFA
                move.b  #3,mapping_frame(a0)

loc_3CCFA:
                andi.b  #$40,d0
                beq.s   loc_3CD26
                move.w  #2,mainspr_childsprites(a0)
                btst    #0,status(a0)
                beq.s   loc_3CD1C
                lea     sub2_x_pos(a0),a2
                subi.w  #$10,(a2)
                move.b  #$10,sub2_mapframe-sub2_x_pos(a2)

loc_3CD1C:
                move.l  #loc_3CDB0,(a0)
                bra.w   loc_3CDB0
; ---------------------------------------------------------------------------

loc_3CD26:
                move.l  #loc_3CD2C,(a0)

loc_3CD2C:
                cmpi.b  #2,mapping_frame(a0)
                beq.w   loc_3CD8E
                subq.b  #1,$34(a0)
                bpl.s   loc_3CD4C
                move.b  #2,$34(a0)
                addq.b  #1,$35(a0)
                andi.b  #3,$35(a0)

loc_3CD4C:
                move.b  (Level_frame_counter+1).w,d0
                move.b  d0,d1
                andi.b  #3,d0
                bne.w   loc_3CD8E
                andi.b  #$F,d1
                bne.s   loc_3CD6E
                tst.b   render_flags(a0)
                bpl.s   loc_3CD6E
                moveq   #signextendB(sfx_FlamethrowerLoud),d0
                jsr     (Play_SFX).l

loc_3CD6E:
                tst.b   render_flags(a0)
                bpl.w   loc_3CD8E
                subq.b  #4,$2E(a0)
                andi.b  #$7F,$2E(a0)
                bsr.w   sub_3CEC0
                ori.b   #$80,$2E(a0)
                bsr.w   sub_3CEC0

loc_3CD8E:
                bsr.w   sub_3CE7A
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                bsr.s   sub_3CE1A
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_3CDB0:
                cmpi.b  #2,mapping_frame(a0)
                beq.w   loc_3CDFC
                subq.b  #1,$34(a0)
                bpl.s   loc_3CDD0
                move.b  #2,$34(a0)
                addq.b  #1,$35(a0)
                andi.b  #3,$35(a0)

loc_3CDD0:
                move.b  (Level_frame_counter+1).w,d0
                move.b  d0,d1
                andi.b  #3,d0
                bne.w   loc_3CDFC
                andi.b  #$F,d1
                bne.s   loc_3CDEC
                moveq   #signextendB(sfx_FlamethrowerLoud),d0
                jsr     (Play_SFX).l

loc_3CDEC:
                tst.b   render_flags(a0)
                bpl.w   loc_3CDFC
                addq.b  #2,$2E(a0)
                bsr.w   sub_3CEC0

loc_3CDFC:
                move.w  #$1B,d1
                move.w  #8,d2
                move.w  #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                bsr.s   sub_3CE1A
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_3CE1A:
                tst.b   subtype(a0)
                bmi.s   locret_3CE42
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_3CE44
                tst.w   $30(a0)
                bne.s   loc_3CE52
                move.w  #$3C,$30(a0)
                move.b  #2,mapping_frame(a0)
                move.b  #0,$2E(a0)

locret_3CE42:
                rts
; ---------------------------------------------------------------------------

loc_3CE44:
                move.w  #0,$30(a0)
                move.b  #1,mapping_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_3CE52:
                subq.w  #1,$30(a0)
                bne.s   locret_3CE42
                lea     (Player_1).w,a1
                bclr    #p1_standing_bit,status(a0)
                beq.s   loc_3CE68
                bsr.w   sub_3CBCE

loc_3CE68:
                lea     (Player_2).w,a1
                bclr    #p2_standing_bit,status(a0)
                beq.s   locret_3CE78
                bsr.w   sub_3CBCE

locret_3CE78:
                rts
; End of function sub_3CE1A

; =============== S U B R O U T I N E =======================================

sub_3CE7A:
                move.b  $2E(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #5,d1
                move.w  d1,d0
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),d2
                add.w   d2,d1
                move.w  d1,(a2)
                neg.w   d0
                add.w   d2,d0
                move.w  d0,sub4_x_pos-sub2_x_pos(a2)
                cmpi.b  #-$40,$2E(a0)
                blo.s   loc_3CEB2
                move.b  #0,sub2_mapframe-sub2_x_pos(a2)
                move.b  #$10,sub4_mapframe-sub2_x_pos(a2)
                rts
; ---------------------------------------------------------------------------

loc_3CEB2:
                move.b  #$10,sub2_mapframe-sub2_x_pos(a2)
                move.b  #0,sub4_mapframe-sub2_x_pos(a2)
                rts
; End of function sub_3CE7A

; =============== S U B R O U T I N E =======================================

sub_3CEC0:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   locret_3CF4A
                move.l  #loc_3CF90,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subq.w  #4,y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  #make_art_tile(ArtTile_FBZMisc+$A4,0,0),art_tile(a1)
                move.w  #$200,priority(a1)
                move.b  #$C,width_pixels(a1)
                move.b  #$C,height_pixels(a1)
                move.b  #$98,collision_flags(a1)
                bset    #4,shield_reaction(a1)
                btst    #6,subtype(a0)
                bne.s   loc_3CF4C
                move.b  $2E(a0),d0
                bpl.s   loc_3CF24
                move.w  #$80,priority(a1)

loc_3CF24:
                jsr     (GetSineCosine).l
                move.w  d1,d0
                asl.w   #2,d1
                move.w  d1,x_vel(a1)
                asr.w   #4,d0
                add.w   d0,x_pos(a1)
                move.b  $35(a0),anim_frame(a1)
                move.b  #4,anim_frame_timer(a1)
                move.b  #$C,anim(a1)

locret_3CF4A:
                rts
; ---------------------------------------------------------------------------

loc_3CF4C:
                move.b  $2E(a0),d0
                jsr     (GetSineCosine).l
                move.w  d1,d2
                asr.w   #1,d2
                add.w   d2,d1
                addi.w  #$280,d1
                move.w  d1,x_vel(a1)
                addi.w  #$10,x_pos(a1)
                btst    #0,status(a0)
                beq.s   loc_3CF7C
                neg.w   x_vel(a1)
                subi.w  #$20,x_pos(a1)

loc_3CF7C:
                move.b  $35(a0),anim_frame(a1)
                move.b  #4,anim_frame_timer(a1)
                move.b  #$C,anim(a1)
                rts
; End of function sub_3CEC0

; ---------------------------------------------------------------------------

loc_3CF90:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_3CFA2
                move.b  #5,anim_frame_timer(a0)
                subq.b  #4,anim(a0)
                beq.s   loc_3CFCA

loc_3CFA2:
                addq.b  #1,anim_frame(a0)
                andi.b  #3,anim_frame(a0)
                move.b  anim(a0),d0
                add.b   anim_frame(a0),d0
                move.b  d0,mapping_frame(a0)
                jsr     (MoveSprite2).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_3CFCA:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_FBZFlameThrower:
                include "src/objects/shared/zones/fbz/mappings/flamethrower.s"
