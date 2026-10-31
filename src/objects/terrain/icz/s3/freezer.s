; Owner: objects/terrain/icz/s3
; Responsibility: IceCap freezer trap, player freeze and release states, fragments and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZFreezer:
                jsr     Obj_WaitOffscreen(pc)
                move.l  #loc_57E4E,(a0)
                lea     ObjDat_ICZFreezer(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_57E4E:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   loc_57E72
                move.l  #loc_57E76,(a0)
                clr.w   $2E(a0)
                clr.w   $30(a0)
                clr.b   $39(a0)
                moveq   #signextendB(sfx_FrostPuff),d0
                jsr     (Play_SFX).l

loc_57E72:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_57E76:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   loc_57EBE
                subq.w  #1,$30(a0)
                bpl.s   loc_57EA2
                moveq   #0,d0
                move.b  $39(a0),d0
                bchg    #1,d0
                move.b  d0,$39(a0)
                move.w  word_57ED6(pc,d0.w),$30(a0)
                move.w  off_57EDA(pc,d0.w),d0
                jsr     off_57EDA(pc,d0.w)

loc_57EA2:
                btst    #1,$38(a0)
                beq.s   loc_57EBA
                subq.w  #1,$2E(a0)
                bpl.s   loc_57EBA
                move.w  #1,$2E(a0)
                bsr.w   sub_57F00

loc_57EBA:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_57EBE:
                move.l  #loc_57E4E,(a0)
                bclr    #1,$38(a0)
                moveq   #signextendB(cmd_StopSFX),d0
                jsr     (Play_SFX).l
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
word_57ED6:
                dc.w    $40,   $40
off_57EDA:
                dc.w    loc_57EDE-off_57EDA
                dc.w    loc_57EE6-off_57EDA
; ---------------------------------------------------------------------------

loc_57EDE:
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_57EE6:
                bset    #1,$38(a0)
                lea     ChildObjDat_582A8(pc),a2
                btst    #1,render_flags(a0)
                beq.s   loc_57EFC
                lea     ChildObjDat_582B0(pc),a2

loc_57EFC:
                jmp     CreateChild1_Normal(pc)

; =============== S U B R O U T I N E =======================================

sub_57F00:
                lea     ChildObjDat_58298(pc),a2
                btst    #1,render_flags(a0)
                beq.s   loc_57F10
                lea     ChildObjDat_582A0(pc),a2

loc_57F10:
                jmp     CreateChild1_Normal(pc)
; End of function sub_57F00

; ---------------------------------------------------------------------------

loc_57F14:
                lea     word_58278(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_57F24,(a0)

locret_57F22:
                rts
; ---------------------------------------------------------------------------

loc_57F24:
                bsr.w   sub_580EC
                jsr     Refresh_ChildPosition(pc)
                subq.b  #1,$3A(a0)
                bpl.w   locret_57F22
                move.b  #2,$3A(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_57F40:
                move.l  #loc_57F54,(a0)
                move.w  #$1F,$2E(a0)
                lea     ObjDat_ICZFreezer(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_57F54:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_57F84
                subq.w  #1,$2E(a0)
                bmi.s   loc_57F68
                rts
; ---------------------------------------------------------------------------

loc_57F68:
                move.l  #loc_57F70,(a0)
                rts
; ---------------------------------------------------------------------------

loc_57F70:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_57F84
                lea     word_58206(pc),a1
                bra.w   sub_5819C
; ---------------------------------------------------------------------------

loc_57F84:
                move.l  #loc_57F9A,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_57F9A:
                jsr     Obj_Wait(pc)
                lea     word_58206(pc),a1
                bra.w   sub_5819C
; ---------------------------------------------------------------------------

loc_57FA6:
                lea     ObjDat3_58280(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_58004,(a0)
                move.b  #$10,y_radius(a0)
                movea.w $44(a0),a1
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                btst    #0,render_flags(a1)
                beq.s   loc_57FDA
                bset    #0,render_flags(a0)

loc_57FDA:
                movea.w parent3(a0),a2
                move.w  #$200,d1
                cmp.w   x_pos(a2),d0
                bhs.s   loc_57FEA
                neg.w   d1

loc_57FEA:
                move.w  d1,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_58066,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_58004:
                move.w  (Camera_X_pos).w,d0
                tst.w   x_vel(a0)
                bmi.s   loc_5801C
                addi.w  #$128,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_58026
                bra.w   loc_5802A
; ---------------------------------------------------------------------------

loc_5801C:
                addi.w  #$20,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_5802A

loc_58026:
                clr.w   x_vel(a0)

loc_5802A:
                jsr     (MoveSprite).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_58044
                add.w   d1,y_pos(a0)
                move.l  #loc_58044,(a0)

loc_58044:
                movea.w $44(a0),a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subq.w  #1,$2E(a0)
                bmi.s   loc_58066
                bsr.w   sub_5820E
                bne.s   loc_58090
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_58066:
                movea.w $44(a0),a1
                movea.l a0,a2
                movea.l a1,a0
                jsr     (HurtCharacter).l
                cmpi.b  #$18,anim(a0)
                beq.s   loc_5808E
                move.w  #$200,d0
                btst    #0,render_flags(a0)
                bne.s   loc_5808A
                neg.w   d0

loc_5808A:
                move.w  d0,x_vel(a0)

loc_5808E:
                movea.l a2,a0

loc_58090:
                movea.w $44(a0),a1
                bset    #1,status(a1)
                clr.b   object_control(a1)
                move.b  #2*60,invulnerability_timer(a1)
                lea     ChildObjDat_582C0(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_580B2:
                lea     ObjDat3_5828C(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #byte_58314,$30(a0)
                cmpi.b  #8,subtype(a0)
                bhs.s   loc_580D8
                move.l  #byte_5830A,$30(a0)

loc_580D8:
                jsr     (Random_Number).l
                andi.b  #3,d0
                move.b  d0,anim_frame(a0)
                moveq   #$C,d0
                jmp     Set_IndexedVelocity(pc)

; =============== S U B R O U T I N E =======================================

sub_580EC:
                subq.w  #1,$2E(a0)
                bpl.s   locret_58144
                move.w  #2,$2E(a0)
                moveq   #0,d0
                move.b  $39(a0),d0
                addq.b  #4,d0
                cmpi.b  #$48,d0
                bhs.s   loc_58146
                move.b  d0,$39(a0)
                lea     byte_58150(pc,d0.w),a1
                move.b  (a1)+,child_dy(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,d2
                jsr     (Random_Number).l
                and.b   d2,d0
                move.w  d2,d3
                lsr.b   #1,d3
                sub.b   d3,d0
                move.b  d0,child_dx(a0)
                swap    d0
                and.b   d2,d0
                sub.b   d3,d0
                movea.w parent3(a0),a1
                btst    #1,render_flags(a1)
                beq.s   loc_58140
                neg.b   child_dy(a0)

loc_58140:
                add.b   d0,child_dy(a0)

locret_58144:
                rts
; ---------------------------------------------------------------------------

loc_58146:
                jsr     (Delete_Current_Sprite).l
                addq.w  #4,sp
                rts
; End of function sub_580EC

; ---------------------------------------------------------------------------
byte_58150:
                dc.b    $10, $16,   3
                even
                dc.b    $10, $16,   3
                even
                dc.b    $14, $16,   3
                even
                dc.b    $18, $16,   3
                even
                dc.b    $1C, $16,   7
                even
                dc.b    $22, $17,   7
                even
                dc.b    $26, $17,   7
                even
                dc.b    $2E, $17,   7
                even
                dc.b    $32, $17,   7
                even
                dc.b    $3C, $18,   7
                even
                dc.b    $40, $18,  $F
                even
                dc.b    $4D, $19,  $F
                even
                dc.b    $52, $19,  $F
                even
                dc.b    $4B, $19,  $F
                even
                dc.b    $44, $19,  $F
                even
                dc.b    $42, $19,  $F
                even
                dc.b    $3E, $18,  $F
                even
                dc.b    $3B, $17,  $F
                even
                dc.b    $38, $16,  $F
                even

; =============== S U B R O U T I N E =======================================

sub_5819C:
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   locret_58204
                tst.w   d0
                beq.s   loc_581AE
                movea.w d0,a4
                bsr.w   sub_581B6

loc_581AE:
                swap    d0
                tst.w   d0
                beq.s   locret_58204
                movea.w d0,a4
; End of function sub_5819C

; =============== S U B R O U T I N E =======================================

sub_581B6:
                tst.b   object_control(a4)
                bne.s   locret_58204
                btst    #Status_Invincible,status_secondary(a4)
                bne.s   locret_58204
                tst.b   invulnerability_timer(a4)
                bne.s   locret_58204
                cmpi.b  #4,routine(a4)
                bhs.s   locret_58204
                move.b  #$81,object_control(a4)
                move.b  #$1A,anim(a4)
                bset    #Status_InAir,status(a4)
                clr.b   spin_dash_flag(a4)
                clr.w   x_vel(a4)
                clr.w   y_vel(a4)
                clr.w   ground_vel(a4)
                move.l  d0,d4
                lea     ChildObjDat_582B8(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.l  d4,d0
                move.w  a4,$44(a1)

locret_58204:
                rts
; End of function sub_581B6

; ---------------------------------------------------------------------------
word_58206:
                dc.w    -$10,   $20,  -$28,   $50

; =============== S U B R O U T I N E =======================================

sub_5820E:
                lea     (Player_1).w,a3
                cmpa.w  $44(a0),a3
                bne.s   loc_5821C
                lea     (Player_2).w,a3

loc_5821C:
                tst.w   y_vel(a3)
                bmi.s   loc_58260
                cmpi.b  #2,anim(a3)
                beq.s   loc_58232
                cmpi.b  #9,anim(a3)
                bne.s   loc_58260

loc_58232:
                lea     word_58264(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   locret_5825E
                tst.w   d0
                beq.s   loc_5824A
                movea.w d0,a4
                tst.b   object_control(a4)
                beq.s   loc_58258

loc_5824A:
                swap    d0
                tst.w   d0
                beq.s   locret_5825E
                movea.w d0,a4
                tst.b   object_control(a4)
                bne.s   loc_58260

loc_58258:
                neg.w   y_vel(a3)
                moveq   #1,d0

locret_5825E:
                rts
; ---------------------------------------------------------------------------

loc_58260:
                moveq   #0,d0
                rts
; End of function sub_5820E

; ---------------------------------------------------------------------------
word_58264:
                dc.w    -$1C,   $38,  -$18,   $30
ObjDat_ICZFreezer:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,1,0)
                dc.w    $280
                dc.b    $10,  $C,   6, $9A
word_58278:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    $C,  $C, $16,   0
ObjDat3_58280:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    $14, $10,   2,   0
ObjDat3_5828C:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    4,   4,  $C,   0
ChildObjDat_58298:
                dc.w    1-1
                dc.l    loc_57F14
                dc.b    0,  $C
ChildObjDat_582A0:
                dc.w    1-1
                dc.l    loc_57F14
                dc.b    0, -$C
ChildObjDat_582A8:
                dc.w    1-1
                dc.l    loc_57F40
                dc.b    0, $30
ChildObjDat_582B0:
                dc.w    1-1
                dc.l    loc_57F40
                dc.b    0,-$30
ChildObjDat_582B8:
                dc.w    1-1
                dc.l    loc_57FA6
                dc.b    0,   0
ChildObjDat_582C0:
                dc.w    $C-1
                dc.l    loc_580B2
                dc.b    -$C,  -8
                dc.l    loc_580B2
                dc.b    -4,  -8
                dc.l    loc_580B2
                dc.b    4,  -8
                dc.l    loc_580B2
                dc.b    $C,  -8
                dc.l    loc_580B2
                dc.b    -$C,   0
                dc.l    loc_580B2
                dc.b    -4,   0
                dc.l    loc_580B2
                dc.b    4,   0
                dc.l    loc_580B2
                dc.b    $C,   0
                dc.l    loc_580B2
                dc.b    -$C,   8
                dc.l    loc_580B2
                dc.b    -4,   8
                dc.l    loc_580B2
                dc.b    4,   8
                dc.l    loc_580B2
                dc.b    $C,   8
byte_5830A:
                dc.b    0, $27, $23, $27, $13, $27, $24, $27, $14, $FC
byte_58314:
                dc.b    0, $27,  $C, $27,  $D, $27,  $E, $FC
byte_5831C:
                dc.b    0, $27,  $F, $27, $10, $27, $11, $FC
                even
