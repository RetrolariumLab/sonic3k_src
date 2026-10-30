; Owner: objects/zones/aiz/s3
; Responsibility: Angel Island collapsing log bridge timing, log and fire fragments and shared bridge mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_AIZCollapsingLogBridge:
                move.b  subtype(a0),d0
                bmi.w   loc_2A470
                move.b  d0,$36(a0)
                addi.b  #$30,d0
                move.b  d0,$35(a0)
                move.b  #8,$37(a0)
                move.l  #Map_AIZCollapsingLogBridge,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,0),art_tile(a0)
                move.b  #$5A,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #4,render_flags(a0)             ; oddly, this is not an ori like the child sprites, however it doesn't matter in normal gameplay as this object only faces one direction
                move.w  #$200,priority(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2A466
                move.l  #loc_2A57C,(a1)
                move.l  #Map_AIZCollapsingLogBridge,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.b  #$5A,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                bset    #6,render_flags(a1)
                move.w  #6,mainspr_childsprites(a1)
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                subi.w  #$4B,d3
                lea     sub2_x_pos(a1),a2
                move.w  mainspr_childsprites(a1),d6
                subq.w  #1,d6
                move.w  #1,4(a2)

loc_2A44E:
                move.w  d3,(a2)+
                move.w  d2,(a2)+
                addq.w  #2,a2
                addi.w  #$1E,d3
                dbf     d6,loc_2A44E
                move.w  #2,-2(a2)
                move.w  a1,$3C(a0)

loc_2A466:
                move.l  #loc_2A538,(a0)
                bra.w   loc_2A538
; ---------------------------------------------------------------------------

loc_2A470:
                andi.b  #$7F,d0
                move.b  d0,$36(a0)
                addi.b  #$30,d0
                move.b  d0,$35(a0)
                move.b  #8,$37(a0)
                move.l  #Map_AIZDrawBridgeFire,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,1),art_tile(a0)
                move.b  #$60,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #4,render_flags(a0)             ; oddly, this is not an ori like the child sprites, however it doesn't matter in normal gameplay as this object only faces one direction
                move.w  #$200,priority(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   loc_2A52E
                move.l  #loc_2A57C,(a1)
                move.l  #Map_AIZDrawBridgeFire,mappings(a1)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,1),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.b  #$60,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.w  #$200,priority(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                bset    #6,render_flags(a1)
                move.w  #6,mainspr_childsprites(a1)
                move.w  y_pos(a0),d2
                move.w  x_pos(a0),d3
                subi.w  #$50,d3
                lea     sub2_x_pos(a1),a2
                move.w  mainspr_childsprites(a1),d6
                subq.w  #1,d6
                move.w  #1,4(a2)

loc_2A516:
                move.w  d3,(a2)+
                move.w  d2,(a2)+
                addq.w  #2,a2
                addi.w  #$20,d3
                dbf     d6,loc_2A516
                move.w  #2,-2(a2)
                move.w  a1,$3C(a0)

loc_2A52E:
                move.l  #loc_2A5AA,(a0)
                bra.w   loc_2A5AA
; ---------------------------------------------------------------------------

loc_2A538:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_2A560
                move.b  $35(a0),$34(a0)
                move.b  $36(a0),d2
                move.b  $37(a0),d3
                move.l  #loc_2A638,(a0)
                move.l  #loc_2A582,d4
                bsr.w   sub_2A6C6

loc_2A560:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  height_pixels(a0),d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_2A57C:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_2A582:
                tst.b   $34(a0)
                beq.s   loc_2A592
                subq.b  #1,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2A592:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bpl.s   loc_2A5A4
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2A5A4:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2A5AA:
                tst.b   (_unkFAA2).w
                beq.s   loc_2A5CE
                move.b  $35(a0),$34(a0)
                move.b  $36(a0),d2
                move.b  $37(a0),d3
                move.l  #loc_2A638,(a0)
                move.l  #loc_2A5EA,d4
                bsr.w   sub_2A6C6

loc_2A5CE:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                moveq   #0,d3
                move.b  height_pixels(a0),d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_2A5EA:
                tst.b   $34(a0)
                beq.s   loc_2A602
                subq.b  #1,$34(a0)
                bne.s   loc_2A5FC
                move.b  #3,mapping_frame(a0)

loc_2A5FC:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2A602:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_2A620
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #8,mapping_frame(a0)
                blo.s   loc_2A620
                move.b  #3,mapping_frame(a0)

loc_2A620:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bpl.s   loc_2A632
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2A632:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2A638:
                subq.b  #1,$34(a0)
                bne.s   loc_2A644
                move.l  #loc_2AB1A,(a0)

loc_2A644:
                move.b  $34(a0),d3
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   sub_2A664
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.s   sub_2A664
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

sub_2A664:
                btst    d6,status(a0)
                beq.s   locret_2A6C4
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   loc_2A6A8
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_2A6A8
                cmp.w   d2,d0
                bhs.s   loc_2A6A8
                btst    #0,status(a0)
                beq.s   loc_2A692
                neg.w   d0
                add.w   d2,d0

loc_2A692:
                lsr.w   #5,d0
                add.w   d0,d0
                add.w   d0,d0
                add.w   d0,d0
                add.b   $36(a0),d0
                move.b  $35(a0),d2
                sub.b   d0,d2
                cmp.b   d2,d3
                bhi.s   locret_2A6C4

loc_2A6A8:
                bclr    d6,status(a0)
                bclr    #Status_OnObj,status(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,prev_anim(a1)

locret_2A6C4:
                rts
; End of function sub_2A664

; =============== S U B R O U T I N E =======================================

sub_2A6C6:
                movea.w $3C(a0),a3
                lea     sub2_x_pos(a3),a2
                move.w  mainspr_childsprites(a3),d6
                subq.w  #1,d6
                bclr    #6,render_flags(a3)
                movea.l a3,a1
                bra.s   loc_2A6E6
; ---------------------------------------------------------------------------

loc_2A6DE:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_2A724

loc_2A6E6:
                move.l  d4,(a1)
                move.l  mappings(a3),mappings(a1)
                move.b  render_flags(a3),render_flags(a1)
                move.w  art_tile(a3),art_tile(a1)
                move.w  priority(a3),priority(a1)
                move.b  width_pixels(a3),width_pixels(a1)
                move.b  height_pixels(a3),height_pixels(a1)
                move.w  (a2)+,x_pos(a1)
                move.w  (a2)+,y_pos(a1)
                move.w  (a2)+,d0
                move.b  d0,mapping_frame(a1)
                move.b  d2,$34(a1)
                add.b   d3,d2
                dbf     d6,loc_2A6DE

loc_2A724:
                move.w  #0,sub2_x_pos(a3)
                move.w  #0,sub2_y_pos(a3)
                moveq   #signextendB(sfx_Collapse),d0
                jmp     (Play_SFX).l
; End of function sub_2A6C6

; ---------------------------------------------------------------------------
Map_AIZCollapsingLogBridge:
                include "src/objects/shared/zones/aiz/map_collapsing_log_bridge.s"
Map_AIZDrawBridgeFire:
                include "src/objects/shared/zones/aiz/map_draw_bridge_fire.s"
