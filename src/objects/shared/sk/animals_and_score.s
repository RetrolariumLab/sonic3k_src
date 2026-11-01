; Owner: objects/shared/sk
; Responsibility: Freed animal state, species movement, enemy score display and product-specific animal spawn helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Animal:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Animal_Index(pc,d0.w),d1
                jmp     Animal_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Animal_Index:
                dc.w    loc_2C8B8-Animal_Index
                dc.w    loc_2C9E0-Animal_Index
                dc.w    loc_2CA3C-Animal_Index
                dc.w    loc_2CA7C-Animal_Index
                dc.w    loc_2CA3C-Animal_Index
                dc.w    loc_2CA3C-Animal_Index
                dc.w    loc_2CA3C-Animal_Index
                dc.w    loc_2CA7C-Animal_Index
                dc.w    loc_2CA3C-Animal_Index
                dc.w    loc_2CA7C-Animal_Index
                dc.w    loc_2CA3C-Animal_Index
                dc.w    loc_2CA3C-Animal_Index
                dc.w    loc_2CA3C-Animal_Index
                dc.w    loc_2CA3C-Animal_Index
                dc.w    loc_2CB02-Animal_Index
                dc.w    loc_2CB24-Animal_Index
                dc.w    loc_2CB24-Animal_Index
                dc.w    loc_2CB44-Animal_Index
                dc.w    loc_2CB80-Animal_Index
                dc.w    loc_2CBDC-Animal_Index
                dc.w    loc_2CBFC-Animal_Index
                dc.w    loc_2CBDC-Animal_Index
                dc.w    loc_2CBFC-Animal_Index
                dc.w    loc_2CBDC-Animal_Index
                dc.w    loc_2CC3C-Animal_Index
                dc.w    loc_2CB9C-Animal_Index
byte_2C7BA:
                dc.b    5, 1
                dc.b    0, 3
                dc.b    5, 1
                dc.b    0, 5
                dc.b    6, 5
                dc.b    2, 3
                dc.b    5, 1
                dc.b    6, 1
                dc.b    0, 1
                dc.b    5, 1
                dc.b    0, 5
                dc.b    6, 1
                dc.b    6, 5
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
                dc.b    5, 1
word_2C7EA:
                dc.w    -$200, -$400
                dc.l    Map_Animals5
                dc.w    -$200, -$300
                dc.l    Map_Animals1
                dc.w    -$180, -$300
                dc.l    Map_Animals5
                dc.w    -$140, -$180
                dc.l    Map_Animals4
                dc.w    -$1C0, -$300
                dc.l    Map_Animals3
                dc.w    -$300, -$400
                dc.l    Map_Animals1
                dc.w    -$280, -$380
                dc.l    Map_Animals2
                dc.w    -$280, -$300
                dc.l    Map_Animals1
                dc.w    -$200, -$380
                dc.l    Map_Animals2
                dc.w    -$2C0, -$300
                dc.l    Map_Animals2
                dc.w    -$140, -$200
                dc.l    Map_Animals2
                dc.w    -$200, -$300
                dc.l    Map_Animals2
word_2C84A:
                dc.w    -$440, -$400
                dc.w    -$440, -$400
                dc.w    -$440, -$400
                dc.w    -$300, -$400
                dc.w    -$300, -$400
                dc.w    -$180, -$300
                dc.w    -$180, -$300
                dc.w    -$140, -$180
                dc.w    -$1C0, -$300
                dc.w    -$200, -$300
                dc.w    -$280, -$380
off_2C876:
                dc.l    Map_Animals1
                dc.l    Map_Animals1
                dc.l    Map_Animals1
                dc.l    Map_Animals5
                dc.l    Map_Animals5
                dc.l    Map_Animals5
                dc.l    Map_Animals5
                dc.l    Map_Animals4
                dc.l    Map_Animals3
                dc.l    Map_Animals1
                dc.l    Map_Animals2
word_2C8A2:
                dc.w    make_art_tile($5A5,0,0)
                dc.w    make_art_tile($5A5,0,0)
                dc.w    make_art_tile($5A5,0,0)
                dc.w    make_art_tile($553,0,0)
                dc.w    make_art_tile($553,0,0)
                dc.w    make_art_tile($573,0,0)
                dc.w    make_art_tile($573,0,0)
                dc.w    make_art_tile($585,0,0)
                dc.w    make_art_tile($593,0,0)
                dc.w    make_art_tile($565,0,0)
                dc.w    make_art_tile($5B3,0,0)
; ---------------------------------------------------------------------------

loc_2C8B8:
                tst.b   subtype(a0)
                beq.w   loc_2C924
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.b  d0,routine(a0)
                subi.w  #$14,d0
                move.w  word_2C8A2(pc,d0.w),art_tile(a0)
                add.w   d0,d0
                move.l  off_2C876(pc,d0.w),mappings(a0)
                lea     word_2C84A(pc),a1
                move.w  (a1,d0.w),$32(a0)
                move.w  (a1,d0.w),x_vel(a0)
                move.w  2(a1,d0.w),$34(a0)
                move.w  2(a1,d0.w),y_vel(a0)
                move.b  #$C,y_radius(a0)
                move.b  #4,render_flags(a0)
                bset    #0,render_flags(a0)
                move.w  #$300,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #7,anim_frame_timer(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2C924:
                addq.b  #2,routine(a0)
                jsr     (Random_Number).l
                move.w  #make_art_tile(ArtTile_Animals1,0,0),art_tile(a0)
                andi.w  #1,d0
                beq.s   loc_2C940
                move.w  #make_art_tile(ArtTile_Animals2,0,0),art_tile(a0)

loc_2C940:
                moveq   #0,d1
                move.b  (Current_zone).w,d1
                add.w   d1,d1
                add.w   d0,d1
                lea     byte_2C7BA(pc),a1
                move.b  (a1,d1.w),d0
                move.b  d0,$30(a0)
                lsl.w   #3,d0
                lea     word_2C7EA(pc),a1
                adda.w  d0,a1
                move.w  (a1)+,$32(a0)
                move.w  (a1)+,$34(a0)
                move.l  (a1)+,mappings(a0)
                move.b  #$C,y_radius(a0)
                move.b  #4,render_flags(a0)
                bset    #0,render_flags(a0)
                move.w  #$300,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #7,anim_frame_timer(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #-$400,y_vel(a0)
                tst.b   $38(a0)
                bne.s   loc_2C9CA
                jsr     (AllocateObject).l
                bne.s   loc_2C9C4
                move.l  #Obj_EnemyScore,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  $3E(a0),d0
                lsr.w   #1,d0
                move.b  d0,mapping_frame(a1)

loc_2C9C4:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2C9CA:
                move.b  #$1C,routine(a0)
                clr.w   x_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2C9DA:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_2C9E0:
                tst.b   render_flags(a0)
                bpl.s   loc_2C9DA
                jsr     (MoveSprite).l
                tst.w   y_vel(a0)
                bmi.s   loc_2CA36
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_2CA36
                add.w   d1,y_pos(a0)
                move.w  $32(a0),x_vel(a0)
                move.w  $34(a0),y_vel(a0)
                move.b  #1,mapping_frame(a0)
                move.b  $30(a0),d0
                add.b   d0,d0
                addq.b  #4,d0
                move.b  d0,routine(a0)
                tst.b   $38(a0)
                beq.s   loc_2CA36
                btst    #4,(V_int_run_count+3).w
                beq.s   loc_2CA36
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

loc_2CA36:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2CA3C:
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   loc_2CA68
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_2CA68
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

loc_2CA68:
                tst.b   subtype(a0)
                bne.s   loc_2CAE4
                tst.b   render_flags(a0)
                bpl.w   loc_2C9DA
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2CA7C:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.w   y_vel(a0)
                bmi.s   loc_2CABA
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_2CABA
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)
                tst.b   subtype(a0)
                beq.s   loc_2CABA
                cmpi.b  #$A,subtype(a0)
                beq.s   loc_2CABA
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

loc_2CABA:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_2CAD0
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

loc_2CAD0:
                tst.b   subtype(a0)
                bne.s   loc_2CAE4
                tst.b   render_flags(a0)
                bpl.w   loc_2C9DA
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2CAE4:
                move.w  x_pos(a0),d0
                sub.w   (Player_1+x_pos).w,d0
                bcs.s   loc_2CAFC
                subi.w  #$180,d0
                bpl.s   loc_2CAFC
                tst.b   render_flags(a0)
                bpl.w   loc_2C9DA

loc_2CAFC:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2CB02:
                tst.b   render_flags(a0)
                bpl.w   loc_2C9DA
                subq.w  #1,$36(a0)
                bne.w   loc_2CB1E
                move.b  #2,routine(a0)
                move.w  #$80,priority(a0)

loc_2CB1E:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2CB24:
                bsr.w   GetAnimalActivationXDifference
                bcc.s   loc_2CB40
                move.w  $32(a0),x_vel(a0)
                move.w  $34(a0),y_vel(a0)
                move.b  #$E,routine(a0)
                bra.w   loc_2CA7C
; ---------------------------------------------------------------------------

loc_2CB40:
                bra.w   loc_2CAE4
; ---------------------------------------------------------------------------

loc_2CB44:
                bsr.w   GetAnimalActivationXDifference
                bpl.s   loc_2CB7C
                clr.w   x_vel(a0)
                clr.w   $32(a0)
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                bsr.w   BounceAnimalOnFloorAndSelectFrame
                bsr.w   SetAnimalFlipFromPlayerSide
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_2CB7C
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

loc_2CB7C:
                bra.w   loc_2CAE4
; ---------------------------------------------------------------------------

loc_2CB80:
                bsr.w   GetAnimalActivationXDifference
                bpl.s   loc_2CBD8
                move.w  $32(a0),x_vel(a0)
                move.w  $34(a0),y_vel(a0)
                move.b  #4,routine(a0)
                bra.w   loc_2CA3C
; ---------------------------------------------------------------------------

loc_2CB9C:
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   loc_2CBD8
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_2CBD8
                not.b   subtype+1(a0)
                bne.s   loc_2CBCE
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

loc_2CBCE:
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

loc_2CBD8:
                bra.w   loc_2CAE4
; ---------------------------------------------------------------------------

loc_2CBDC:
                bsr.w   GetAnimalActivationXDifference
                bpl.s   loc_2CBF8
                clr.w   x_vel(a0)
                clr.w   $32(a0)
                jsr     (MoveSprite).l
                bsr.w   BounceAnimalOnFloorAndSelectFrame
                bsr.w   SetAnimalFlipFromPlayerSide

loc_2CBF8:
                bra.w   loc_2CAE4
; ---------------------------------------------------------------------------

loc_2CBFC:
                bsr.w   GetAnimalActivationXDifference
                bpl.s   loc_2CC38
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   loc_2CC38
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_2CC38
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

loc_2CC38:
                bra.w   loc_2CAE4
; ---------------------------------------------------------------------------

loc_2CC3C:
                bsr.w   GetAnimalActivationXDifference
                bpl.s   loc_2CC8E
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.w   y_vel(a0)
                bmi.s   loc_2CC78
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_2CC78
                not.b   subtype+1(a0)
                bne.s   loc_2CC6E
                neg.w   x_vel(a0)
                bchg    #0,render_flags(a0)

loc_2CC6E:
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

loc_2CC78:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_2CC8E
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

loc_2CC8E:
                bra.w   loc_2CAE4

; =============== S U B R O U T I N E =======================================

BounceAnimalOnFloorAndSelectFrame:
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   locret_2CCB8
                move.b  #0,mapping_frame(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   locret_2CCB8
                add.w   d1,y_pos(a0)
                move.w  $34(a0),y_vel(a0)

locret_2CCB8:
                rts
; End of function BounceAnimalOnFloorAndSelectFrame

; =============== S U B R O U T I N E =======================================

SetAnimalFlipFromPlayerSide:
                bset    #0,render_flags(a0)
                move.w  x_pos(a0),d0
                sub.w   (Player_1+x_pos).w,d0
                bcc.s   locret_2CCD0
                bclr    #0,render_flags(a0)

locret_2CCD0:
                rts
; End of function SetAnimalFlipFromPlayerSide

; =============== S U B R O U T I N E =======================================

GetAnimalActivationXDifference:
                move.w  (Player_1+x_pos).w,d0
                sub.w   x_pos(a0),d0
                subi.w  #$B8,d0
                rts
; End of function GetAnimalActivationXDifference

; ---------------------------------------------------------------------------

Obj_EnemyScore:
                move.l  #Map_EnemyScore,mappings(a0)
                move.w  #make_art_tile(ArtTile_StarPost,0,1),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #8,width_pixels(a0)
                move.w  #-$300,y_vel(a0)
                move.l  #loc_2CD0C,(a0)

loc_2CD0C:
                tst.w   y_vel(a0)
                bpl.w   loc_2C9DA
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_Difficulty_SpawnChickens:
                lea     Child6_DifficultyChicken(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Child6_DifficultyChicken:
                dc.w    4-1
                dc.l    loc_2CD3C
; ---------------------------------------------------------------------------

loc_2CD3C:
                move.l  #loc_2CD6E,(a0)
                move.l  #Map_Animals1,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Difficulty+$141,1,0),art_tile(a0)
                lea     word_2CD5E(pc),a1
                bsr.w   InitDifficultyAnimalPositionAndDelay
                jmp     (EndingInitializeGentleVerticalSwing).l
; ---------------------------------------------------------------------------
word_2CD5E:
                dc.w    $C0,   $A0
                dc.w    $A8,   $C8
                dc.w    $D0,   $B8
                dc.w    $D8,   $D0
; ---------------------------------------------------------------------------

loc_2CD6E:
                subq.w  #1,$2E(a0)
                bpl.s   loc_2CD7A
                move.l  #loc_2CD84,(a0)

loc_2CD7A:
                bsr.w   AnimateDifficultyChickenFrames
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_2CD84:
                bsr.w   AnimateDifficultyChickenFrames
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_Difficulty_SpawnSquirrels:
                lea     Child6_DifficultySquirrel(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Child6_DifficultySquirrel:
                dc.w    4-1
                dc.l    loc_2CDB0
; ---------------------------------------------------------------------------

loc_2CDB0:
                move.l  #loc_2CDEA,(a0)
                move.l  #Map_Animals2,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Difficulty+$14F,1,0),art_tile(a0)
                bset    #0,render_flags(a0)
                lea     word_2CDDA(pc),a1
                bsr.w   InitDifficultyAnimalPositionAndDelay
                move.w  y_pos(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------
word_2CDDA:
                dc.w    $160,  $130
                dc.w    $180,  $120
                dc.w    $1A0,  $128
                dc.w    $178,  $138
; ---------------------------------------------------------------------------

loc_2CDEA:
                jsr     (MoveSprite).l
                move.b  #1,mapping_frame(a0)
                tst.w   y_vel(a0)
                bmi.s   loc_2CE26
                move.b  #0,mapping_frame(a0)
                move.w  y_pos(a0),d0
                cmp.w   $3A(a0),d0
                blo.s   loc_2CE26
                move.w  $3A(a0),y_pos(a0)
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                addi.w  #$100,d0
                neg.w   d0
                move.w  d0,y_vel(a0)

loc_2CE26:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_Difficulty_SpawnRabbits:
                lea     Child6_DifficultyRabbit(pc),a2
                jsr     (CreateChild6_Simple).l
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Child6_DifficultyRabbit:
                dc.w    4-1
                dc.l    loc_2CE42
; ---------------------------------------------------------------------------

loc_2CE42:
                move.l  #loc_2CDEA,(a0)
                move.l  #Map_Animals5,mappings(a0)
                move.w  #make_art_tile(ArtTile_BlueSphere_Difficulty+$161,1,0),art_tile(a0)
                lea     word_2CE66(pc),a1
                bsr.w   InitDifficultyAnimalPositionAndDelay
                move.w  y_pos(a0),$3A(a0)
                rts
; ---------------------------------------------------------------------------
word_2CE66:
                dc.w    $C0,  $110
                dc.w    $A8,  $128
                dc.w    $C0,  $130
                dc.w    $D8,  $138

; =============== S U B R O U T I N E =======================================

InitDifficultyAnimalPositionAndDelay:
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                adda.w  d0,a1
                move.w  (a1)+,x_pos(a0)
                move.w  (a1)+,y_pos(a0)
                add.w   d0,d0
                move.w  d0,$2E(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$200,priority(a0)
                rts
; End of function InitDifficultyAnimalPositionAndDelay

; =============== S U B R O U T I N E =======================================

AnimateDifficultyChickenFrames:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_2CEB8
                move.b  #2,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                andi.b  #1,mapping_frame(a0)

locret_2CEB8:
                rts
; End of function AnimateDifficultyChickenFrames

; ---------------------------------------------------------------------------
Map_Animals1:
                include "src/objects/shared/animals/mappings/set_1.s"
Map_Animals2:
                include "src/objects/shared/animals/mappings/set_2.s"
Map_Animals3:
                include "src/objects/shared/animals/mappings/set_3.s"
Map_Animals4:
                include "src/objects/shared/animals/mappings/set_4.s"
Map_Animals5:
                include "src/objects/shared/animals/mappings/set_5.s"
Map_EnemyScore:
                include "src/objects/shared/enemy_misc/mappings/enemy_points.s"
