; Owner: objects/terrain/icz/sk
; Responsibility: IceCap freezer trap, player freeze and release states, fragments and private resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZFreezer:
                jsr     Obj_WaitOffscreen(pc)
                move.l  #loc_8A656,(a0)
                lea     ObjDat_ICZFreezer(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_8A656:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   loc_8A67A
                move.l  #loc_8A67E,(a0)
                clr.w   $2E(a0)
                clr.w   $30(a0)
                clr.b   $39(a0)
                moveq   #signextendB(sfx_FrostPuff),d0
                jsr     (Play_SFX).l

loc_8A67A:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_8A67E:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$40,d2
                bhs.s   loc_8A6C6
                subq.w  #1,$30(a0)
                bpl.s   loc_8A6AA
                moveq   #0,d0
                move.b  $39(a0),d0
                bchg    #1,d0
                move.b  d0,$39(a0)
                move.w  word_8A6DE(pc,d0.w),$30(a0)
                move.w  off_8A6E2(pc,d0.w),d0
                jsr     off_8A6E2(pc,d0.w)

loc_8A6AA:
                btst    #1,$38(a0)
                beq.s   loc_8A6C2
                subq.w  #1,$2E(a0)
                bpl.s   loc_8A6C2
                move.w  #1,$2E(a0)
                bsr.w   SpawnIczFreezerFrostPuff

loc_8A6C2:
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_8A6C6:
                move.l  #loc_8A656,(a0)
                bclr    #1,$38(a0)
                moveq   #signextendB(cmd_StopSFX),d0
                jsr     (Play_SFX).l
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
word_8A6DE:
                dc.w    $40,   $40
off_8A6E2:
                dc.w    loc_8A6E6-off_8A6E2
                dc.w    loc_8A6EE-off_8A6E2
; ---------------------------------------------------------------------------

loc_8A6E6:
                bclr    #1,$38(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A6EE:
                bset    #1,$38(a0)
                lea     ChildObjDat_8AAD2(pc),a2
                btst    #1,render_flags(a0)
                beq.s   loc_8A704
                lea     ChildObjDat_8AADA(pc),a2

loc_8A704:
                jmp     CreateChild1_Normal(pc)

; =============== S U B R O U T I N E =======================================

SpawnIczFreezerFrostPuff:
                lea     ChildObjDat_8AAC2(pc),a2
                btst    #1,render_flags(a0)
                beq.s   loc_8A718
                lea     ChildObjDat_8AACA(pc),a2

loc_8A718:
                jmp     CreateChild1_Normal(pc)
; End of function SpawnIczFreezerFrostPuff

; ---------------------------------------------------------------------------

loc_8A71C:
                lea     word_8AAA2(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #loc_8A72C,(a0)

locret_8A72A:
                rts
; ---------------------------------------------------------------------------

loc_8A72C:
                bsr.w   AdvanceIczFreezerPuffEnvelopeAndJitter
                jsr     Refresh_ChildPosition(pc)
                subq.b  #1,$3A(a0)
                bpl.w   locret_8A72A
                move.b  #2,$3A(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8A748:
                move.l  #loc_8A75C,(a0)
                move.w  #$1F,$2E(a0)
                lea     ObjDat_ICZFreezer(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_8A75C:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_8A78C
                subq.w  #1,$2E(a0)
                bmi.s   loc_8A770
                rts
; ---------------------------------------------------------------------------

loc_8A770:
                move.l  #loc_8A778,(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A778:
                movea.w parent3(a0),a1
                btst    #1,$38(a1)
                beq.s   loc_8A78C
                lea     word_8AA30(pc),a1
                bra.w   CapturePlayersInsideIczFreezerZone
; ---------------------------------------------------------------------------

loc_8A78C:
                move.l  #loc_8A7A2,(a0)
                move.w  #$1F,$2E(a0)
                move.l  #Go_Delete_Sprite,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A7A2:
                jsr     Obj_Wait(pc)
                lea     word_8AA30(pc),a1
                bra.w   CapturePlayersInsideIczFreezerZone
; ---------------------------------------------------------------------------

loc_8A7AE:
                lea     ObjDat3_8AAAA(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_8A80C,(a0)
                move.b  #$10,y_radius(a0)
                movea.w $44(a0),a1
                move.w  x_pos(a1),d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),y_pos(a0)
                btst    #0,render_flags(a1)
                beq.s   loc_8A7E2
                bset    #0,render_flags(a0)

loc_8A7E2:
                movea.w parent3(a0),a2
                move.w  #$200,d1
                cmp.w   x_pos(a2),d0
                bhs.s   loc_8A7F2
                neg.w   d1

loc_8A7F2:
                move.w  d1,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                move.w  #$7F,$2E(a0)
                move.l  #loc_8A88A,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_8A80C:
                move.w  (Camera_X_pos).w,d0
                tst.w   x_vel(a0)
                bmi.s   loc_8A824
                addi.w  #$128,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_8A82E
                bra.w   loc_8A832
; ---------------------------------------------------------------------------

loc_8A824:
                addi.w  #$20,d0
                cmp.w   x_pos(a0),d0
                blo.s   loc_8A832

loc_8A82E:
                clr.w   x_vel(a0)

loc_8A832:
                jsr     (MoveSprite).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_8A84C
                add.w   d1,y_pos(a0)
                move.l  #loc_8A84C,(a0)

loc_8A84C:
                movea.w $44(a0),a1
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                cmpi.b  #2,character_id(a1)
                bne.s   loc_8A870
                moveq   #-4,d2
                btst    #0,render_flags(a1)
                beq.s   loc_8A86C
                neg.w   d2

loc_8A86C:
                add.w   d2,d0
                addq.w  #2,d1

loc_8A870:
                move.w  d0,x_pos(a1)
                move.w  d1,y_pos(a1)
                subq.w  #1,$2E(a0)
                bmi.s   loc_8A88A
                bsr.w   TryRescueIczFrozenPlayerWithPartner
                bne.s   loc_8A8BA
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8A88A:
                movea.w $44(a0),a1
                btst    #Status_Invincible,status_secondary(a1)
                movea.l a0,a2
                movea.l a1,a0
                jsr     (HurtCharacter).l
                cmpi.b  #$18,anim(a0)
                beq.s   loc_8A8B8
                move.w  #$200,d0
                btst    #0,render_flags(a0)
                bne.s   loc_8A8B4
                neg.w   d0

loc_8A8B4:
                move.w  d0,x_vel(a0)

loc_8A8B8:
                movea.l a2,a0

loc_8A8BA:
                movea.w $44(a0),a1
                bset    #1,status(a1)
                clr.b   object_control(a1)
                move.b  #2*60,invulnerability_timer(a1)
                lea     ChildObjDat_8AAEA(pc),a2
                jsr     CreateChild1_Normal(pc)
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_8A8DC:
                lea     ObjDat3_8AAB6(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #byte_8AB3E,$30(a0)
                cmpi.b  #8,subtype(a0)
                bhs.s   loc_8A902
                move.l  #byte_8AB34,$30(a0)

loc_8A902:
                jsr     (Random_Number).l
                andi.b  #3,d0
                move.b  d0,anim_frame(a0)
                moveq   #$C,d0
                jmp     Set_IndexedVelocity(pc)

; =============== S U B R O U T I N E =======================================

AdvanceIczFreezerPuffEnvelopeAndJitter:
                subq.w  #1,$2E(a0)
                bpl.s   locret_8A96E
                move.w  #2,$2E(a0)
                moveq   #0,d0
                move.b  $39(a0),d0
                addq.b  #4,d0
                cmpi.b  #$48,d0
                bhs.s   loc_8A970
                move.b  d0,$39(a0)
                lea     byte_8A97A(pc,d0.w),a1
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
                beq.s   loc_8A96A
                neg.b   child_dy(a0)

loc_8A96A:
                add.b   d0,child_dy(a0)

locret_8A96E:
                rts
; ---------------------------------------------------------------------------

loc_8A970:
                jsr     (Delete_Current_Sprite).l
                addq.w  #4,sp
                rts
; End of function AdvanceIczFreezerPuffEnvelopeAndJitter

; ---------------------------------------------------------------------------
byte_8A97A:
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

CapturePlayersInsideIczFreezerZone:
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   locret_8AA2E
                tst.w   d0
                beq.s   loc_8A9D8
                movea.w d0,a4
                bsr.w   FreezeEligiblePlayerInIczShell

loc_8A9D8:
                swap    d0
                tst.w   d0
                beq.s   locret_8AA2E
                movea.w d0,a4
; End of function CapturePlayersInsideIczFreezerZone

; =============== S U B R O U T I N E =======================================

FreezeEligiblePlayerInIczShell:
                tst.b   object_control(a4)
                bne.s   locret_8AA2E
                btst    #Status_Invincible,status_secondary(a4)
                bne.s   locret_8AA2E
                tst.b   invulnerability_timer(a4)
                bne.s   locret_8AA2E
                cmpi.b  #4,routine(a4)
                bhs.s   locret_8AA2E
                move.b  #$81,object_control(a4)
                move.b  #$1A,anim(a4)
                bset    #Status_InAir,status(a4)
                clr.b   spin_dash_flag(a4)
                clr.w   x_vel(a4)
                clr.w   y_vel(a4)
                clr.w   ground_vel(a4)
                move.l  d0,d4
                lea     ChildObjDat_8AAE2(pc),a2
                jsr     CreateChild1_Normal(pc)
                move.l  d4,d0
                move.w  a4,$44(a1)

locret_8AA2E:
                rts
; End of function FreezeEligiblePlayerInIczShell

; ---------------------------------------------------------------------------
word_8AA30:
                dc.w    -$10,   $20,  -$28,   $50

; =============== S U B R O U T I N E =======================================

TryRescueIczFrozenPlayerWithPartner:
                lea     (Player_1).w,a3
                cmpa.w  $44(a0),a3
                bne.s   loc_8AA46
                lea     (Player_2).w,a3

loc_8AA46:
                tst.w   y_vel(a3)
                bmi.s   loc_8AA8A
                cmpi.b  #2,anim(a3)
                beq.s   loc_8AA5C
                cmpi.b  #9,anim(a3)
                bne.s   loc_8AA8A

loc_8AA5C:
                lea     word_8AA8E(pc),a1
                jsr     Check_PlayerInRange(pc)
                tst.l   d0
                beq.s   locret_8AA88
                tst.w   d0
                beq.s   loc_8AA74
                movea.w d0,a4
                tst.b   object_control(a4)
                beq.s   loc_8AA82

loc_8AA74:
                swap    d0
                tst.w   d0
                beq.s   locret_8AA88
                movea.w d0,a4
                tst.b   object_control(a4)
                bne.s   loc_8AA8A

loc_8AA82:
                neg.w   y_vel(a3)
                moveq   #1,d0

locret_8AA88:
                rts
; ---------------------------------------------------------------------------

loc_8AA8A:
                moveq   #0,d0
                rts
; End of function TryRescueIczFrozenPlayerWithPartner

; ---------------------------------------------------------------------------
word_8AA8E:
                dc.w    -$1C,   $38,  -$18,   $30
ObjDat_ICZFreezer:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,1,0)
                dc.w    $280
                dc.b    $10,  $C,   6, $9A
word_8AAA2:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    $C,  $C, $16,   0
ObjDat3_8AAAA:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    $14, $10,   2,   0
ObjDat3_8AAB6:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    4,   4,  $C,   0
ChildObjDat_8AAC2:
                dc.w    1-1
                dc.l    loc_8A71C
                dc.b    0,  $C
ChildObjDat_8AACA:
                dc.w    1-1
                dc.l    loc_8A71C
                dc.b    0, -$C
ChildObjDat_8AAD2:
                dc.w    1-1
                dc.l    loc_8A748
                dc.b    0, $30
ChildObjDat_8AADA:
                dc.w    1-1
                dc.l    loc_8A748
                dc.b    0,-$30
ChildObjDat_8AAE2:
                dc.w    1-1
                dc.l    loc_8A7AE
                dc.b    0,   0
ChildObjDat_8AAEA:
                dc.w    $C-1
                dc.l    loc_8A8DC
                dc.b    -$C,  -8
                dc.l    loc_8A8DC
                dc.b    -4,  -8
                dc.l    loc_8A8DC
                dc.b    4,  -8
                dc.l    loc_8A8DC
                dc.b    $C,  -8
                dc.l    loc_8A8DC
                dc.b    -$C,   0
                dc.l    loc_8A8DC
                dc.b    -4,   0
                dc.l    loc_8A8DC
                dc.b    4,   0
                dc.l    loc_8A8DC
                dc.b    $C,   0
                dc.l    loc_8A8DC
                dc.b    -$C,   8
                dc.l    loc_8A8DC
                dc.b    -4,   8
                dc.l    loc_8A8DC
                dc.b    4,   8
                dc.l    loc_8A8DC
                dc.b    $C,   8
byte_8AB34:
                dc.b    0, $27, $23, $27, $13, $27, $24, $27, $14, $FC
byte_8AB3E:
                dc.b    0, $27,  $C, $27,  $D, $27,  $E, $FC
byte_8AB46:
                dc.b    0, $27,  $F, $27, $10, $27, $11, $FC
                even
