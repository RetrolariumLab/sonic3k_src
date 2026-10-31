; Owner: objects/zones/dez/sk
; Responsibility: Conveyor pad movement, player riding and transport state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZConveyorPad:
                move.l  #Map_DEZConveyorPad,mappings(a0)
                move.w  #make_art_tile(ArtTile_DEZMisc+$BB,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$3F,x_radius(a0)
                move.b  #$F,y_radius(a0)
                move.w  #$280,priority(a0)
                move.b  #2,anim(a0)
                move.b  status(a0),d0
                andi.b  #1,d0
                move.b  d0,$31(a0)
                andi.b  #$FE,status(a0)
                move.w  #1,$34(a0)
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                beq.s   loc_479EA
                lsl.w   #3,d0
                move.w  d0,$32(a0)
                tst.b   subtype(a0)
                bpl.s   loc_479D0
                neg.w   $34(a0)

loc_479D0:
                move.l  #Map_DEZConveyorPad2,mappings(a0)
                move.b  #$80,width_pixels(a0)
                bset    #6,render_flags(a0)
                move.w  #0,mainspr_childsprites(a0)

loc_479EA:
                move.l  #loc_479F0,(a0)

loc_479F0:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_47A12
                move.b  $31(a0),anim(a0)
                move.l  #loc_47A14,(a0)
                tst.b   subtype(a0)
                bne.s   loc_47A12
                move.l  #loc_47AB4,(a0)

loc_47A12:
                bra.s   loc_47A58
; ---------------------------------------------------------------------------

loc_47A14:
                tst.w   $32(a0)
                beq.s   loc_47A38
                subq.w  #1,$32(a0)
                move.w  $34(a0),d0
                add.w   d0,y_pos(a0)
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   loc_47A38
                moveq   #signextendB(sfx_ConveyorPlatform),d0
                jsr     (Play_SFX).l

loc_47A38:
                bsr.w   sub_47A88
                move.b  status(a0),d0
                move.b  $30(a0),d1
                move.b  d0,$30(a0)
                eor.b   d0,d1
                and.b   d0,d1
                andi.b  #standing_mask,d1
                beq.s   loc_47A58
                bchg    #0,anim(a0)

loc_47A58:
                lea     (Ani_DEZConveyorPad).l,a1
                jsr     (Animate_Sprite).l
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_47A88:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   sub_47A96
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
; End of function sub_47A88

; =============== S U B R O U T I N E =======================================

sub_47A96:
                btst    d6,status(a0)
                beq.s   locret_47AB2
                moveq   #2,d0
                tst.b   anim(a0)
                beq.s   loc_47AA6
                neg.w   d0

loc_47AA6:
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_47AAE
                neg.w   d0

loc_47AAE:
                add.w   d0,x_pos(a1)

locret_47AB2:
                rts
; End of function sub_47A96

; ---------------------------------------------------------------------------

loc_47AB4:
                move.w  x_pos(a0),-(sp)
                bsr.w   sub_47B58
                moveq   #1,d0
                tst.b   anim(a0)
                beq.s   loc_47AC6
                neg.w   d0

loc_47AC6:
                add.w   d0,x_pos(a0)
                moveq   #-$40,d3
                jsr     (ObjCheckLeftWallDist).l
                tst.w   d1
                bpl.s   loc_47AE0
                sub.w   d1,x_pos(a0)
                bchg    #0,anim(a0)

loc_47AE0:
                moveq   #$40,d3
                jsr     (ObjCheckRightWallDist).l
                tst.w   d1
                bpl.s   loc_47AF6
                add.w   d1,x_pos(a0)
                bchg    #0,anim(a0)

loc_47AF6:
                move.b  status(a0),d0
                move.b  $30(a0),d1
                move.b  d0,$30(a0)
                eor.b   d0,d1
                and.b   d0,d1
                andi.b  #standing_mask,d1
                beq.s   loc_47B12
                bchg    #0,anim(a0)

loc_47B12:
                move.w  (sp)+,d4
                lea     (Ani_DEZConveyorPad).l,a1
                jsr     (Animate_Sprite).l
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                jsr     (SolidObjectFull).l
                tst.b   render_flags(a0)
                bpl.s   loc_47B52
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   loc_47B52
                moveq   #signextendB(sfx_ConveyorPlatform),d0
                jsr     (Play_SFX).l

loc_47B52:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_47B58:
                move.w  $36(a0),d0
                bne.s   loc_47B7C
                move.w  $34(a0),d0
                add.w   d0,y_pos(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   locret_47B7A
                add.w   d1,y_pos(a0)
                move.w  #1,$36(a0)

locret_47B7A:
                rts
; ---------------------------------------------------------------------------

loc_47B7C:
                subq.w  #1,d0
                bne.s   loc_47BBA
                move.w  x_pos(a0),d3
                subi.w  #$30,d3
                jsr     (ObjCheckFloorDist2).l
                move.w  d1,-(sp)
                move.w  x_pos(a0),d3
                addi.w  #$30,d3
                jsr     (ObjCheckFloorDist2).l
                move.w  (sp)+,d0
                cmp.w   d0,d1
                ble.s   loc_47BA6
                move.w  d0,d1

loc_47BA6:
                cmpi.w  #$E,d1
                bgt.s   loc_47BB2
                add.w   d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_47BB2:
                move.w  #2,$36(a0)
                rts
; ---------------------------------------------------------------------------

loc_47BBA:
                jsr     (MoveSprite).l
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$120,d0
                cmp.w   y_pos(a0),d0
                bgt.s   loc_47BD8
                move.w  #$7F00,d4
                move.w  d4,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_47BD8:
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   locret_47BF2
                add.w   d1,y_pos(a0)
                move.w  #0,y_vel(a0)
                move.w  #1,$36(a0)

locret_47BF2:
                rts
; End of function sub_47B58

; ---------------------------------------------------------------------------
Ani_DEZConveyorPad:
                include "src/objects/shared/zones/dez/animations/conveyor_pad.s"
Map_DEZConveyorPad:
                include "src/objects/shared/zones/dez/mappings/conveyor_pad.s"
; ---------------------------------------------------------------------------
word_47DD6:
                dc.w    $7F
                dc.w    $FF
                dc.w    $1FF
                dc.w    $3FF

; =============== S U B R O U T I N E =======================================

sub_47DDE:
                move.w  #make_art_tile(ArtTile_DEZMisc+$B2,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$300,priority(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$C,d0
                lsr.w   #1,d0
                move.w  word_47DD6(pc,d0.w),d0
                move.w  d0,$32(a0)
                addq.w  #1,d0
                lsr.w   #4,d0
                andi.w  #$F0,d1
                lsr.w   #4,d1
                mulu.w  d1,d0
                move.w  d0,$30(a0)
                move.b  subtype(a0),d1
                andi.b  #3,d1
                addq.b  #2,d1
                lsl.w   #5,d1
                move.w  (Level_frame_counter).w,d0
                add.w   $30(a0),d0
                and.w   $32(a0),d0
                rts
; End of function sub_47DDE
