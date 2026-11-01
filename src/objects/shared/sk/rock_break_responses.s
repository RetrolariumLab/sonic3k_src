; Owner: objects/shared/sk
; Responsibility: Additional standing and character break responses, push recovery, fragment creation and shared fragment or mapping tables
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

loc_1FF48:
                move.w  (Player_1+y_vel).w,$30(a0)
                move.w  (Player_2+y_vel).w,$36(a0)
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
                andi.w  #4|8,d6
                bne.s   loc_1FF84
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

loc_1FF84:
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   loc_1FFA8
                lea     (Player_1).w,a1
                move.w  $30(a0),y_vel(a1)
                andi.b  #8,d6
                beq.s   loc_1FFC4
                lea     (Player_2).w,a1
                move.w  $36(a0),y_vel(a1)
                bra.s   loc_1FFC4
; ---------------------------------------------------------------------------

loc_1FFA8:
                andi.b  #8,d6
                beq.s   loc_1FFBA
                lea     (Player_2).w,a1
                move.w  $36(a0),y_vel(a1)
                bra.s   loc_1FFC4
; ---------------------------------------------------------------------------

loc_1FFBA:
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

loc_1FFC4:
                btst    #p1_standing_bit,status(a0)
                beq.s   loc_1FFDC
                lea     (Player_1).w,a1
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)

loc_1FFDC:
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_1FFF4
                lea     (Player_2).w,a1
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)

loc_1FFF4:
                move.l  #loc_1FC16,(a0)
                bsr.w   ShatterRockWithDefaultVelocities
                bra.w   loc_1FC16
; ---------------------------------------------------------------------------

loc_20002:
                move.w  (Chain_bonus_counter).w,$38(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.b  status(a0),d0
                andi.b  #p1_standing,d0
                bne.s   loc_20036

loc_20030:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_20036:
                lea     (Player_1).w,a1
                cmpi.b  #2,character_id(a1)
                bne.s   loc_20030
                bsr.s   BouncePlayerAfterKnucklesRockTopBreak
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_20088
                lea     (Player_2).w,a1
                bsr.s   BouncePlayerAfterKnucklesRockTopBreak
                bra.w   loc_20088

; =============== S U B R O U T I N E =======================================

BouncePlayerAfterKnucklesRockTopBreak:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.w  #-$300,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                rts
; End of function BouncePlayerAfterKnucklesRockTopBreak

; ---------------------------------------------------------------------------

loc_20088:
                move.w  $38(a0),(Chain_bonus_counter).w
                andi.b  #$E7,status(a0)
                move.l  #loc_1FC16,(a0)
                bsr.w   ShatterRockWithDefaultVelocities
                bra.w   loc_1FC16

; =============== S U B R O U T I N E =======================================

UpdatePlayersPushingRockLeft:
                move.b  status(a0),d3
                andi.b  #pushing_mask,d3
                beq.w   locret_200CA
                move.w  x_pos(a0),d2
                lea     (Player_1).w,a1
                move.b  $3A(a0),d0
                moveq   #p1_pushing_bit,d6
                bsr.s   StepPushableRockLeftForPlayer
                lea     (Player_2).w,a1
                move.b  $3B(a0),d0
                moveq   #p2_pushing_bit,d6
                bsr.s   StepPushableRockLeftForPlayer

locret_200CA:
                rts
; End of function UpdatePlayersPushingRockLeft

; =============== S U B R O U T I N E =======================================

StepPushableRockLeftForPlayer:
                btst    d6,d3
                beq.s   locret_2011C
                cmp.w   x_pos(a1),d2
                bhs.s   locret_2011C
                btst    #5,d0
                beq.s   locret_2011C
                subq.w  #1,$40(a0)
                bpl.s   locret_2011C
                move.w  #$10,$40(a0)
                tst.w   $42(a0)
                beq.s   locret_2011C
                subq.w  #1,$42(a0)
                subq.w  #1,x_pos(a0)
                subq.w  #1,x_pos(a1)
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)
                move.w  respawn_addr(a0),d0
                beq.s   locret_2011C
                movea.w d0,a2
                move.b  $43(a0),d0
                subi.b  #$40,d0
                neg.b   d0
                move.b  d0,(a2)
                bset    #7,(a2)

locret_2011C:
                rts
; End of function StepPushableRockLeftForPlayer

; =============== S U B R O U T I N E =======================================

ShatterRockWithDefaultVelocities:
                cmpi.b  #9,(Current_zone).w
                beq.w   loc_201C4
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                lea     (off_202E4).l,a4
                adda.w  (a4,d0.w),a4
; End of function ShatterRockWithDefaultVelocities

; =============== S U B R O U T I N E =======================================

SpawnRockFragments:
                lea     (off_2026E).l,a3
                adda.w  (a3,d0.w),a3
                move.w  (a3)+,d1
                move.l  (a0),d4
                move.b  render_flags(a0),d5
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  #3,d6
                movea.l a0,a1
                bra.s   loc_20162
; ---------------------------------------------------------------------------

loc_2015C:
                bsr.w   AllocateObjectAfterCurrent
                bne.s   loc_201BC

loc_20162:
                move.l  d4,(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  d5,render_flags(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  art_tile(a0),art_tile(a1)
                ori.w   #high_priority,art_tile(a1)
                move.w  #$80,priority(a1)
                move.b  #$18,width_pixels(a1)
; Bug: This only covers the width, when it
; should be covering the height as the width
; has already been defined
                move.b  #$18,width_pixels(a1)
                move.w  (a4)+,x_vel(a1)
                move.w  (a4)+,y_vel(a1)
                move.b  d6,mapping_frame(a1)
                addq.b  #1,d6
                cmpi.b  #7,d6
                blo.s   loc_201B8
                move.w  #3,d6

loc_201B8:
                dbf     d1,loc_2015C

loc_201BC:
                moveq   #signextendB(sfx_Collapse),d0
                jmp     (Play_SFX).l
; End of function SpawnRockFragments

; ---------------------------------------------------------------------------

loc_201C4:
                move.l  #loc_1FC66,(a0)
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                subq.b  #4,d0
                add.w   d0,d0
                lea     (off_202E4).l,a4
                adda.w  (a4,d0.w),a4

; =============== S U B R O U T I N E =======================================

SpawnLavaReefRockFragments:
                lea     (off_2026E).l,a3
                adda.w  (a3,d0.w),a3
                move.w  (a3)+,d1
                move.l  (a0),d4
                move.b  render_flags(a0),d5
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  #3,d6
                movea.l a0,a1
                bra.s   loc_20206
; ---------------------------------------------------------------------------

loc_20200:
                bsr.w   AllocateObjectAfterCurrent
                bne.s   loc_20266

loc_20206:
                move.l  d4,(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  d5,render_flags(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  art_tile(a0),art_tile(a1)
                ori.w   #high_priority,art_tile(a1)
                move.w  #$80,priority(a1)
                move.b  #$20,width_pixels(a1)
; Bug: This only covers the width, when it
; should be covering the height as the width
; has already been defined
                move.b  #$20,width_pixels(a1)
                move.w  (a4)+,x_vel(a1)
                move.w  (a4)+,y_vel(a1)
                move.b  (a3)+,mapping_frame(a1)
                move.b  mapping_frame(a1),d0
                andi.b  #$FC,d0
                move.b  d0,$3C(a1)
                move.b  #7,anim_frame_timer(a1)
                dbf     d1,loc_20200

loc_20266:
                moveq   #signextendB(sfx_Collapse),d0
                jmp     (Play_SFX).l
; End of function SpawnLavaReefRockFragments

; ---------------------------------------------------------------------------
off_2026E:
                dc.w    word_2027E-off_2026E
                dc.w    word_20290-off_2026E
                dc.w    word_2029C-off_2026E
                dc.w    word_202A6-off_2026E
                dc.w    word_202B4-off_2026E
                dc.w    word_202C8-off_2026E
                dc.w    word_202C8-off_2026E
                dc.w    word_202DC-off_2026E
word_2027E:
                dc.w    8-1
                dc.b    -8, -$18
                dc.b    $B, -$1C
                dc.b    -4,  -$C
                dc.b    $C,   -4
                dc.b    -$C,    4
                dc.b    4,   $C
                dc.b    -$C,  $1C
                dc.b    $C,  $1C
word_20290:
                dc.w    5-1
                dc.b    -4,  -$C
                dc.b    $B,  -$C
                dc.b    -4,   -4
                dc.b    -$C,   $C
                dc.b    $C,   $C
word_2029C:
                dc.w    4-1
                dc.b    -4,   -4
                dc.b    $C,   -4
                dc.b    -$C,    4
                dc.b    $C,    4
word_202A6:
                dc.w    6-1
                dc.b    -8,   -8
                dc.b    8,   -8
                dc.b    -8,    0
                dc.b    8,    0
                dc.b    -8,    8
                dc.b    8,    8
word_202B4:
                dc.w    6-1
                dc.b    0,  $10,   6
                dc.b    0,    0,   7
                dc.b    -8, -$10,   1
                dc.b    8,  $20,   0
                dc.b    0, -$18,   6
                dc.b    0,  $1B,   7
word_202C8:
                dc.w    6-1
                dc.b    8,    3,   7
                dc.b    -8,   -5,   1
                dc.b    -$10,    8,   1
                dc.b    -$18,    0,   7
                dc.b    0,    0,   6
                dc.b    $18,    0,   6
word_202DC:
                dc.w    2-1
                dc.b    0,  $10,   1
                dc.b    0, -$10,   0
off_202E4:
                dc.w    word_202F4-off_202E4
                dc.w    word_20334-off_202E4
                dc.w    word_20348-off_202E4
                dc.w    word_20358-off_202E4
                dc.w    word_203A0-off_202E4
                dc.w    word_203C0-off_202E4
                dc.w    word_203C0-off_202E4
                dc.w    word_203A0-off_202E4
word_202F4:
                dc.w    -$300, -$300
                dc.w    -$2C0, -$280
                dc.w    -$2C0, -$280
                dc.w    -$280, -$200
                dc.w    -$280, -$180
                dc.w    -$240, -$180
                dc.w    -$240, -$100
                dc.w    -$200, -$100
word_20314:
                dc.w    $2C0, -$280
                dc.w    $300, -$300
                dc.w    $280, -$200
                dc.w    $2C0, -$280
                dc.w    $240, -$180
                dc.w    $280, -$180
                dc.w    $200, -$100
                dc.w    $240, -$100
word_20334:
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    -$100, -$1E0
                dc.w    -$1B0, -$1C0
                dc.w    $1C0, -$1C0
word_20348:
                dc.w    -$100, -$200
                dc.w    $100, -$1E0
                dc.w    -$1B0, -$1C0
                dc.w    $1C0, -$1C0
word_20358:
                dc.w    -$B0, -$1E0
                dc.w    $B0, -$1D0
                dc.w    -$80, -$200
                dc.w    $80, -$1E0
                dc.w    -$D8, -$1C0
                dc.w    $E0, -$1C0
word_20370:
                dc.w    -$2C0, -$280
                dc.w    -$280, -$200
                dc.w    -$280, -$180
                dc.w    -$240, -$180
                dc.w    -$240, -$100
                dc.w    -$200, -$100
word_20388:
                dc.w    $2C0, -$280
                dc.w    $280, -$200
                dc.w    $280, -$180
                dc.w    $240, -$180
                dc.w    $240, -$100
                dc.w    $200, -$100
word_203A0:
                dc.w    -$300, -$300
                dc.w    -$2C0, -$280
                dc.w    -$2C0, -$280
                dc.w    -$280, -$200
                dc.w    -$280, -$180
                dc.w    -$240, -$180
                dc.w    -$240, -$100
                dc.w    -$200, -$100
word_203C0:
                dc.w    $C0, -$1E0
                dc.w    -$80, -$1A0
                dc.w    -$A0, -$160
                dc.w    -$100, -$1E0
                dc.w    $40, -$1C0
                dc.w    $100, -$1E0
Map_LRZBreakableRock:
                include "src/objects/shared/zones/lrz/mappings/breakable_rock.s"
Map_LRZBreakableRock2:
                include "src/objects/shared/zones/lrz/mappings/breakable_rock_2.s"
