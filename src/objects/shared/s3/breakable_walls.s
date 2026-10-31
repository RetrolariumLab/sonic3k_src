; Owner: objects/shared/s3
; Responsibility: Breakable wall contact, player response, fracture geometry and fragment creation with zone-specific mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_BreakableWall:
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.l  #loc_1F844,(a0)
                move.b  subtype(a0),d0
                bpl.s   loc_1F6E0
                tst.b   (Level_trigger_array).w
                beq.s   loc_1F6E0
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_1F6E0:
                andi.b  #$F,d0
                move.b  d0,mapping_frame(a0)
                move.l  #Map_AIZBreakableWall,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.l  #word_1FBE2,$34(a0)
                move.l  #word_1FC0A,$38(a0)
                cmpi.b  #1,(Current_zone).w
                bne.s   loc_1F776
                move.l  #Map_HCZBreakableWall,mappings(a0)
                move.w  #make_art_tile($001,3,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #word_1FC32,$34(a0)
                move.l  #word_1FC52,$38(a0)
                cmpi.b  #2,mapping_frame(a0)
                bne.s   loc_1F776
                move.w  #make_art_tile(ArtTile_HCZ2KnuxWall,2,0),art_tile(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #word_1FC32,$34(a0)
                move.l  #word_1FC52,$38(a0)
                move.l  #loc_1FAEC,(a0)
                rts
; ---------------------------------------------------------------------------

loc_1F776:
                cmpi.b  #2,(Current_zone).w
                bne.s   loc_1F7C8
                move.l  #Map_MGZBreakableWall,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.l  #word_1FCC2,$34(a0)
                move.l  #word_1FC72,$38(a0)
                btst    #4,subtype(a0)
                beq.s   loc_1F7B8
                move.l  #loc_1FAEC,(a0)
                rts
; ---------------------------------------------------------------------------

loc_1F7B8:
                cmpi.b  #2,mapping_frame(a0)
                bne.s   loc_1F7C8
                move.l  #loc_1FA02,(a0)
                rts
; ---------------------------------------------------------------------------

loc_1F7C8:
                cmpi.b  #3,(Current_zone).w
                bne.s   loc_1F80A
                move.l  #Map_CNZBreakableWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$CF,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #word_1FD12,$34(a0)
                move.l  #word_1FD32,$38(a0)
                cmpi.b  #2,mapping_frame(a0)
                bne.s   loc_1F80A
                move.l  #loc_1FAEC,(a0)
                rts
; ---------------------------------------------------------------------------

loc_1F80A:
                cmpi.b  #6,(Current_zone).w
                bne.s   loc_1F844
                move.l  #Map_LBZBreakableWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,1,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #word_1FC32,$34(a0)
                move.l  #word_1FC52,$38(a0)
                move.l  #loc_1FAEC,(a0)
                rts
; ---------------------------------------------------------------------------

loc_1F844:
                move.w  (Player_1+x_vel).w,$30(a0)
                move.w  (Player_2+x_vel).w,$32(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                tst.b   subtype(a0)
                bpl.s   loc_1F880
                tst.b   (Level_trigger_array).w
                beq.s   loc_1F888
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_1F880:
                swap    d6
                andi.w  #3,d6
                bne.s   loc_1F88E

loc_1F888:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_1F88E:
                lea     (Player_1).w,a1
                move.w  $30(a0),d1
                move.w  d6,d0
                andi.w  #1,d0
                beq.s   loc_1F906
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   loc_1F8D0
                btst    #Status_FireShield,status_secondary(a1)
                bne.s   loc_1F8BC
                cmpi.b  #2,character_id(a1)
                beq.s   loc_1F8D0
                btst    #p1_pushing_bit,status(a0)
                beq.s   loc_1F906

loc_1F8BC:
                cmpi.b  #2,anim(a1)
                bne.s   loc_1F906
                move.w  d1,d0
                bpl.s   loc_1F8CA
                neg.w   d0

loc_1F8CA:
                cmpi.w  #$480,d0
                blo.s   loc_1F906

loc_1F8D0:
                bclr    #p1_pushing_bit,status(a0)
                bsr.s   sub_1F936
                btst    #p2_pushing_bit,status(a0)
                beq.s   loc_1F888
                lea     (Player_2).w,a1
                cmpi.b  #2,anim(a1)
                bne.s   loc_1F888
                move.w  $32(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #p2_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)
                bra.s   loc_1F888
; ---------------------------------------------------------------------------

loc_1F906:
                lea     (Player_2).w,a1
                move.w  $32(a0),d1
                btst    #p2_pushing_bit,status(a0)
                beq.w   loc_1F888
                cmpi.b  #2,anim(a1)
                bne.w   loc_1F888
                move.w  d1,d0
                bpl.s   loc_1F928
                neg.w   d0

loc_1F928:
                cmpi.w  #$480,d0
                blo.w   loc_1F888
                bclr    #p2_pushing_bit,status(a0)

; =============== S U B R O U T I N E =======================================

sub_1F936:
                move.w  d1,x_vel(a1)
                addq.w  #4,x_pos(a1)
                movea.l $34(a0),a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   loc_1F956
                subi.w  #8,x_pos(a1)
                movea.l $38(a0),a4

loc_1F956:
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)         ; set Sonic as not pushing an object
                move.l  #loc_1F96E,(a0)
                addq.b  #1,mapping_frame(a0)
                bsr.s   BreakObjectToPieces

loc_1F96E:
                jsr     (MoveSprite2).l
                addi.w  #$70,y_vel(a0)                  ; make obj fall
                tst.b   render_flags(a0)
                bpl.s   loc_1F986
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_1F986:
                jmp     (Delete_Current_Sprite).l
; End of function sub_1F936

; =============== S U B R O U T I N E =======================================

BreakObjectToPieces:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                movea.l mappings(a0),a3                 ; get mapping pointer
                adda.w  (a3,d0.w),a3
                move.w  (a3)+,d1
                subq.w  #1,d1
                bset    #5,render_flags(a0)             ; set static mappings flag
                move.l  (a0),d4
                move.b  render_flags(a0),d5             ; get render flags
                movea.l a0,a1
                bra.s   BreakObjectToPieces_InitObject
; ---------------------------------------------------------------------------

BreakObjectToPieces_Loop:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_1F9FA
                addq.w  #6,a3                           ; add to mappings

BreakObjectToPieces_InitObject:
                move.l  d4,code(a1)                     ; get object pointer (in Sonic 1 and 2, this copies the object ID)
                move.l  a3,mappings(a1)                 ; get mappings pointer
                move.b  d5,render_flags(a1)             ; get render flags
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  art_tile(a0),art_tile(a1)
                ori.w   #high_priority,art_tile(a1)     ; change fragment's priority
                move.b  priority(a0),priority(a1)       ; copy priority
                move.b  width_pixels(a0),width_pixels(a1)
                move.b  height_pixels(a0),height_pixels(a1)
                move.w  (a4)+,x_vel(a1)
                move.w  (a4)+,y_vel(a1)
                dbf     d1,BreakObjectToPieces_Loop

loc_1F9FA:
                moveq   #signextendB(sfx_Collapse),d0
                jmp     (Play_SFX).l
; End of function BreakObjectToPieces

; ---------------------------------------------------------------------------

loc_1FA02:
                move.w  (Player_1+x_vel).w,$30(a0)
                move.w  (Player_2+x_vel).w,$32(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.b  #3,d6
                beq.w   loc_1FABC
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   loc_1FA90
                lea     (Player_1).w,a1
                bclr    #6,$37(a1)
                beq.s   loc_1FA90
                move.w  $30(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                bclr    #p1_pushing_bit,status(a0)
                bsr.s   sub_1FAC2
                andi.b  #2,d6
                beq.s   loc_1FABC
                lea     (Player_2).w,a1
                bclr    #6,$37(a1)
                beq.s   loc_1FABC
                move.w  $32(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                bclr    #p2_pushing_bit,status(a0)
                bra.s   loc_1FABC
; ---------------------------------------------------------------------------

loc_1FA90:
                andi.b  #2,d6
                beq.s   loc_1FABC
                lea     (Player_2).w,a1
                bclr    #6,$37(a1)
                beq.s   loc_1FABC
                move.w  $32(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                bclr    #p2_pushing_bit,status(a0)
                bsr.s   sub_1FAC2

loc_1FABC:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_1FAC2:
                movea.l $34(a0),a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   loc_1FADA
                subi.w  #8,x_pos(a1)
                movea.l $38(a0),a4

loc_1FADA:
                move.l  #loc_1F96E,(a0)
                addq.b  #1,mapping_frame(a0)
                bsr.w   BreakObjectToPieces
                bra.w   loc_1F96E
; End of function sub_1FAC2

; ---------------------------------------------------------------------------

loc_1FAEC:
                move.w  (Player_1+x_vel).w,$30(a0)
                move.w  (Player_2+x_vel).w,$32(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                tst.b   subtype(a0)
                bpl.s   loc_1FB28
                tst.b   (Level_trigger_array).w
                beq.s   loc_1FB32
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_1FB28:
                move.b  status(a0),d0
                andi.b  #$60,d0
                bne.s   loc_1FB38

loc_1FB32:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_1FB38:
                lea     (Player_1).w,a1
                move.w  $30(a0),d1
                btst    #p1_pushing_bit,status(a0)
                beq.s   loc_1FB86
                cmpi.b  #2,character_id(a1)
                bne.s   loc_1FB86
                bclr    #p1_pushing_bit,status(a0)
                bsr.s   sub_1FBA4
                btst    #p2_pushing_bit,status(a0)
                beq.s   loc_1FB32
                lea     (Player_2).w,a1
                cmpi.b  #2,character_id(a1)
                bne.s   loc_1FB32
                move.w  $32(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #p2_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)
                bra.s   loc_1FB32
; ---------------------------------------------------------------------------

loc_1FB86:
                lea     (Player_2).w,a1
                move.w  $32(a0),d1
                btst    #p2_pushing_bit,status(a0)
                beq.s   loc_1FB32
                cmpi.b  #2,character_id(a1)
                bne.s   loc_1FB32
                bclr    #p2_pushing_bit,status(a0)

; =============== S U B R O U T I N E =======================================

sub_1FBA4:
                move.w  d1,x_vel(a1)
                addq.w  #4,x_pos(a1)
                movea.l $34(a0),a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   loc_1FBC4
                subi.w  #8,x_pos(a1)
                movea.l $38(a0),a4

loc_1FBC4:
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                move.l  #loc_1F96E,(a0)
                addq.b  #1,mapping_frame(a0)
                bsr.w   BreakObjectToPieces
                bra.w   loc_1F96E
; End of function sub_1FBA4

; ---------------------------------------------------------------------------
word_1FBE2:
                dc.w    $400, -$500
                dc.w    $600, -$600
                dc.w    $600, -$100
                dc.w    $800, -$200
                dc.w    $680,     0
                dc.w    $880,     0
                dc.w    $600,  $100
                dc.w    $800,  $200
                dc.w    $400,  $500
                dc.w    $600,  $600
word_1FC0A:
                dc.w    -$600, -$600
                dc.w    -$400, -$500
                dc.w    -$800, -$200
                dc.w    -$600, -$100
                dc.w    -$880,     0
                dc.w    -$680,     0
                dc.w    -$800,  $200
                dc.w    -$600,  $100
                dc.w    -$600,  $600
                dc.w    -$400,  $500
word_1FC32:
                dc.w    $400, -$500
                dc.w    $600, -$600
                dc.w    $600, -$100
                dc.w    $800, -$200
                dc.w    $600,  $100
                dc.w    $800,  $200
                dc.w    $400,  $500
                dc.w    $600,  $600
word_1FC52:
                dc.w    -$600, -$600
                dc.w    -$400, -$500
                dc.w    -$800, -$200
                dc.w    -$600, -$100
                dc.w    -$800,  $200
                dc.w    -$600,  $100
                dc.w    -$600,  $600
                dc.w    -$400,  $500
word_1FC72:
                dc.w    $400, -$500
                dc.w    $500, -$580
                dc.w    $600, -$600
                dc.w    $700, -$680
                dc.w    $600, -$100
                dc.w    $700, -$180
                dc.w    $800, -$200
                dc.w    $900, -$280
                dc.w    $680,     0
                dc.w    $780,     0
                dc.w    $880,     0
                dc.w    $980,     0
                dc.w    $600,  $100
                dc.w    $700,  $180
                dc.w    $800,  $200
                dc.w    $900,  $280
                dc.w    $400,  $500
                dc.w    $500,  $580
                dc.w    $600,  $600
                dc.w    $700,  $680
word_1FCC2:
                dc.w    -$700, -$680
                dc.w    -$600, -$600
                dc.w    -$500, -$580
                dc.w    -$400, -$500
                dc.w    -$900, -$280
                dc.w    -$800, -$200
                dc.w    -$700, -$180
                dc.w    -$600, -$100
                dc.w    -$980,     0
                dc.w    -$880,     0
                dc.w    -$780,     0
                dc.w    -$680,     0
                dc.w    -$900,  $280
                dc.w    -$800,  $200
                dc.w    -$700,  $180
                dc.w    -$600,  $100
                dc.w    -$700,  $680
                dc.w    -$600,  $600
                dc.w    -$500,  $580
                dc.w    -$400,  $500
word_1FD12:
                dc.w    $400, -$500
                dc.w    $600, -$600
                dc.w    $600, -$100
                dc.w    $800, -$200
                dc.w    $600,  $100
                dc.w    $800,  $200
                dc.w    $400,  $500
                dc.w    $600,  $600
word_1FD32:
                dc.w    -$600, -$600
                dc.w    -$400, -$500
                dc.w    -$800, -$200
                dc.w    -$600, -$100
                dc.w    -$800,  $200
                dc.w    -$600,  $100
                dc.w    -$600,  $600
                dc.w    -$400,  $500
Map_AIZBreakableWall:
                include "src/objects/shared/zones/aiz/mappings/breakable_wall.s"
Map_CNZBreakableWall:
                include "src/objects/shared/zones/cnz/mappings/breakable_wall_s3.s"
Map_MGZBreakableWall:
                include "src/objects/shared/zones/mgz/mappings/breakable_wall.s"
Map_HCZBreakableWall:
                include "src/objects/shared/zones/hcz/mappings/breakable_wall.s"
Map_LBZBreakableWall:
                include "src/objects/shared/zones/lbz/mappings/breakable_wall.s"
