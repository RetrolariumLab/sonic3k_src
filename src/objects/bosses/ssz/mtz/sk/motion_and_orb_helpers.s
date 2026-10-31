; Owner: objects/bosses/ssz/mtz/sk
; Responsibility: Sky Sanctuary Metropolis-style boss child motion, player contact and orb animation decoder
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_7AF5A:
                move.w  $3A(a0),d0
                bmi.s   loc_7AF82
                cmpi.w  #$C,d0
                blt.s   loc_7AF74
                move.b  #0,mapping_frame(a0)
                move.w  #$80,priority(a0)
                rts
; ---------------------------------------------------------------------------

loc_7AF74:
                move.b  #1,mapping_frame(a0)
                move.w  #$100,priority(a0)
                rts
; ---------------------------------------------------------------------------

loc_7AF82:
                cmpi.w  #-$C,d0
                blt.s   loc_7AF96
                move.b  #1,mapping_frame(a0)
                move.w  #$300,priority(a0)
                rts
; ---------------------------------------------------------------------------

loc_7AF96:
                move.b  #2,mapping_frame(a0)
                move.w  #$380,priority(a0)
                rts
; End of function sub_7AF5A

; ---------------------------------------------------------------------------

loc_7AFA4:
                tst.b   $3C(a0)
                bmi.s   loc_7AFB6
                subq.b  #1,$3C(a0)
                bpl.s   loc_7AFB6
                move.b  #$C6,collision_flags(a0)

loc_7AFB6:
                jsr     (MoveSprite).l
                subi.w  #$20,y_vel(a0)
                cmpi.w  #$180,y_vel(a0)
                blt.s   loc_7AFD0
                move.w  #$180,y_vel(a0)

loc_7AFD0:
                tst.w   y_vel(a0)
                bmi.s   loc_7AFF8
                cmpi.w  #$42C,y_pos(a0)
                blo.s   loc_7AFF8
                move.w  #$42C,y_pos(a0)
                move.w  #$42C,$38(a0)
                move.b  #1,$32(a0)
                addq.b  #2,routine(a0)
                bsr.w   sub_7B0A8

loc_7AFF8:
                bsr.w   sub_7B0C2

loc_7AFFC:
                lea     Ani_SSZMTZOrbs(pc),a1
                jsr     (Animate_Sprite).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
; unused
                tst.b   collision_property(a0)
                beq.s   locret_7B028
                move.b  #$E,mapping_frame(a0)
                move.b  #6,anim(a0)
                addq.b  #2,routine(a0)

locret_7B028:
                rts
; ---------------------------------------------------------------------------

loc_7B02A:
                tst.b   $3C(a0)
                bmi.s   loc_7B03C
                subq.b  #1,$3C(a0)
                bpl.s   loc_7B03C
                move.b  #$DA,collision_flags(a0)

loc_7B03C:
                bsr.w   sub_7B0C2
                cmpi.b  #8,mapping_frame(a0)
                bne.s   loc_7AFFC
                move.b  $32(a0),d0
                jsr     (GetSineCosine).l
                neg.w   d0
                asr.w   #2,d0
                add.w   $38(a0),d0
                cmpi.w  #$42C,d0
                bhs.s   loc_7B08C
                move.w  d0,y_pos(a0)
                addq.b  #1,$32(a0)
                btst    #0,$32(a0)
                beq.s   loc_7B080
                moveq   #-1,d0
                btst    #0,render_flags(a0)
                beq.s   loc_7B07C
                neg.w   d0

loc_7B07C:
                add.w   d0,x_pos(a0)

loc_7B080:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_7B08C:
                move.w  #$42C,y_pos(a0)
                bsr.w   sub_7B0A8
                move.b  #1,$32(a0)
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_7B0A8:
                move.w  (Player_1+x_pos).w,d0
                sub.w   x_pos(a0),d0
                bpl.s   loc_7B0BA
                bclr    #0,render_flags(a0)
                rts
; ---------------------------------------------------------------------------

loc_7B0BA:
                bset    #0,render_flags(a0)
                rts
; End of function sub_7B0A8

; =============== S U B R O U T I N E =======================================

sub_7B0C2:
                moveq   #0,d0
                move.b  collision_property(a0),d0
                bne.s   loc_7B0D2
                tst.b   (_unkFA88).w
                bne.s   loc_7B0F6
                rts
; ---------------------------------------------------------------------------

loc_7B0D2:
                clr.b   collision_property(a0)
                andi.b  #3,d0
                add.w   d0,d0
                movea.w word_7B10E(pc,d0.w),a1
                tst.b   $34(a1)
                bne.w   locret_7A718
                jsr     (Check_PlayerAttack).l
                bne.s   loc_7B0F6
                jsr     (HurtCharacter_Directly).l

loc_7B0F6:
                clr.b   collision_flags(a0)
                move.b  #$E,mapping_frame(a0)
                move.b  #6,anim(a0)
                move.b  #8,routine(a0)
                rts
; End of function sub_7B0C2

; ---------------------------------------------------------------------------
word_7B10E:
                dc.w    Player_1
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_2
; ---------------------------------------------------------------------------

loc_7B116:
                moveq   #signextendB(sfx_Balloon),d0
                jsr     (Play_SFX).l
                movea.l $34(a0),a1
                subi.b  #1,$30(a1)
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

; This routine comes from Sonic 2, and is used in Sky Sanctuary by Mecha
; Sonic cosplaying as the Metropolis Zone boss
; sub_7B12E:
Boss_MoveObject:
                move.l  (SSZ_MTZ_boss_X_pos).w,d2
                move.l  (SSZ_MTZ_boss_Y_pos).w,d3
                move.w  (SSZ_MTZ_boss_X_vel).w,d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d2
                move.w  (SSZ_MTZ_boss_Y_vel).w,d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3
                move.l  d2,(SSZ_MTZ_boss_X_pos).w
                move.l  d3,(SSZ_MTZ_boss_Y_pos).w
                rts
; End of function Boss_MoveObject

; ---------------------------------------------------------------------------
; unused
                moveq   #0,d6
                movea.l a1,a4
                lea     (_unkFA82).w,a2
                lea     mapping_frame(a0),a3
                tst.b   (a3)
                bne.s   loc_7B168
                addq.w  #2,a2
                bra.s   loc_7B16C
; ---------------------------------------------------------------------------

loc_7B168:
                bsr.w   sub_7B17A

loc_7B16C:
                moveq   #0,d6
                move.b  mainspr_childsprites(a0),d6
                subq.w  #1,d6
                bmi.s   locret_7B1E0
                lea     sub2_mapframe(a0),a3

; =============== S U B R O U T I N E =======================================

sub_7B17A:
                movea.l a4,a1
                moveq   #0,d0
                moveq   #0,d1
                moveq   #0,d2
                moveq   #0,d4
                move.b  (a2)+,d0
                move.b  d0,d1
                lsr.b   #4,d1
                andi.b  #$F,d0
                move.b  d0,d2
                cmp.b   d0,d1
                beq.s   loc_7B196
                st      d4

loc_7B196:
                move.b  d0,d5
                lsl.b   #4,d5
                or.b    d0,d5
                move.b  (a2)+,d0
                move.b  d0,d1
                lsr.b   #4,d1
                tst.b   d4
                beq.s   loc_7B1AA
                moveq   #0,d0
                moveq   #0,d1

loc_7B1AA:
                andi.b  #$F,d0
                subi.b  #1,d0
                bpl.s   loc_7B1CC
                add.w   d2,d2
                adda.w  (a1,d2.w),a1
                move.b  (a1),d0
                move.b  1(a1,d1.w),d2
                bmi.s   loc_7B1E2

loc_7B1C2:
                andi.b  #$7F,d2
                move.b  d2,(a3)
                addi.b  #1,d1

loc_7B1CC:
                lsl.b   #4,d1
                or.b    d1,d0
                move.b  d0,-1(a2)
                move.b  d5,-2(a2)
                adda.w  #next_subspr,a3
                dbf     d6,sub_7B17A

locret_7B1E0:
                rts
; ---------------------------------------------------------------------------

loc_7B1E2:
                addq.b  #1,d2
                bne.s   loc_7B1F0
                move.b  #0,d1
                move.b  1(a1),d2
                bra.s   loc_7B1C2
; ---------------------------------------------------------------------------

loc_7B1F0:
                addq.b  #1,d2
                bne.s   loc_7B1FC
                addi.b  #2,$26(a0)
                rts
; ---------------------------------------------------------------------------

loc_7B1FC:
                addq.b  #1,d2
                bne.s   loc_7B20A
                andi.b  #$F0,d5
                or.b    2(a1,d1.w),d5
                bra.s   loc_7B1CC
; ---------------------------------------------------------------------------

loc_7B20A:
                addq.b  #1,d2
                bne.s   locret_7B21A
                moveq   #0,d3
                move.b  2(a1,d1.w),d1
                move.b  1(a1,d1.w),d2
                bra.s   loc_7B1C2
; ---------------------------------------------------------------------------

locret_7B21A:
                rts
; End of function sub_7B17A
