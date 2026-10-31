; Owner: objects/bosses/dez/end_boss/sk
; Responsibility: Death Egg end-boss movement, collision, palette, angle and parent-state helpers
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_7F8A0:
                move.w  x_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a0)
                move.w  y_vel(a0),d0
                moveq   #$38,d1
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_7F8BA
                neg.w   d1

loc_7F8BA:
                add.w   d1,d0
                move.w  d0,y_vel(a0)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a0)
                rts
; End of function sub_7F8A0

; =============== S U B R O U T I N E =======================================

sub_7F8CA:
                tst.b   $3A(a0)
                sne     d0
                tst.b   (Reverse_gravity_flag).w
                beq.s   loc_7F8D8
                not.b   d0

loc_7F8D8:
                tst.b   d0
                beq.s   locret_7F8FE
                move.b  #4,routine(a0)
                move.b  #$C6,collision_flags(a0)
                clr.b   $39(a0)
                move.w  x_vel(a0),d0
                beq.s   loc_7F8FA
                move.w  d0,$3C(a0)
                clr.w   x_vel(a0)

loc_7F8FA:
                clr.w   y_vel(a0)

locret_7F8FE:
                rts
; End of function sub_7F8CA

; =============== S U B R O U T I N E =======================================

sub_7F900:
                jsr     Check_PlayerCollision(pc)
                beq.w   locret_7F9A6
                cmpi.b  #2,anim(a1)
                beq.s   loc_7F926
                tst.b   invulnerability_timer(a1)
                bne.w   locret_7F9A6
                btst    #Status_InAir,status_secondary(a1)
                bne.w   locret_7F9A6
                jmp     HurtCharacter_Directly(pc)
; ---------------------------------------------------------------------------

loc_7F926:
                btst    #Status_InAir,status(a1)
                beq.s   loc_7F95C
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.w  #-$300,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bsr.w   sub_7F4AC
                adda.w  #8,sp
                rts
; ---------------------------------------------------------------------------

loc_7F95C:
                move.b  #6,routine(a0)
                move.b  #$C6,collision_flags(a0)
                move.w  #7,child_dx(a0)
                move.b  #8,$39(a0)
                move.w  #$200,d4
                tst.w   x_vel(a1)
                bpl.s   loc_7F980
                neg.w   d4

loc_7F980:
                move.w  d4,x_vel(a0)
                move.w  ground_vel(a1),d4
                bpl.s   loc_7F98C
                neg.w   d4

loc_7F98C:
                cmpi.w  #$500,d4
                bhs.s   loc_7F996
                move.w  #$500,d4

loc_7F996:
                btst    #1,render_flags(a0)
                beq.s   loc_7F9A0
                neg.w   d4

loc_7F9A0:
                move.w  d4,y_vel(a0)
                addq.w  #4,sp

locret_7F9A6:
                rts
; End of function sub_7F900

; =============== S U B R O U T I N E =======================================

sub_7F9A8:
                jsr     Check_PlayerCollision(pc)
                beq.w   locret_7F9F6
                cmpi.b  #2,anim(a1)
                bne.s   loc_7F9C0
                btst    #Status_InAir,status(a1)
                beq.s   loc_7F9D6

loc_7F9C0:
                tst.b   invulnerability_timer(a1)
                bne.w   locret_7F9F6
                btst    #Status_InAir,status_secondary(a1)
                bne.w   locret_7F9F6
                jmp     HurtCharacter_Directly(pc)
; ---------------------------------------------------------------------------

loc_7F9D6:
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                smi     d1
                move.w  x_vel(a1),d2
                bmi.s   loc_7F9E8
                not.b   d1

loc_7F9E8:
                tst.b   d1
                beq.s   locret_7F9F6
                neg.w   d2
                move.w  d2,x_vel(a1)
                neg.w   ground_vel(a1)

locret_7F9F6:
                rts
; End of function sub_7F9A8

; =============== S U B R O U T I N E =======================================

sub_7F9F8:
                jsr     Check_PlayerCollision(pc)
                beq.s   locret_7FA5E
                tst.b   $39(a0)
                beq.s   loc_7FA0A
                subq.b  #1,$39(a0)
                rts
; ---------------------------------------------------------------------------

loc_7FA0A:
                cmpi.b  #2,anim(a1)
                beq.s   loc_7FA2C
                cmpi.b  #9,anim(a1)
                beq.s   loc_7FA2C

loc_7FA1A:
                tst.b   $34(a1)
                bne.s   locret_7FA5E
                btst    #Status_Invincible,status_secondary(a1)
                bne.s   locret_7FA5E
                jmp     HurtCharacter_Directly(pc)
; ---------------------------------------------------------------------------

loc_7FA2C:
                jsr     (Find_OtherObject).l
                cmpi.w  #$10,d2
                bhs.s   loc_7FA1A
                btst    #1,render_flags(a0)
                sne     d2
                tst.w   d1
                bne.s   loc_7FA46
                not.b   d2

loc_7FA46:
                tst.b   d2
                bne.s   loc_7FA1A
                neg.w   x_vel(a1)
                neg.w   y_vel(a1)
                neg.w   ground_vel(a1)
                bsr.w   sub_7F4AC
                adda.w  #8,sp

locret_7FA5E:
                rts
; End of function sub_7F9F8

; =============== S U B R O U T I N E =======================================

sub_7FA60:
                move.w  x_pos(a0),d0
                tst.w   x_vel(a0)
                bmi.s   loc_7FA72
                cmpi.w  #$3598,d0
                bhs.s   loc_7FA78
                rts
; ---------------------------------------------------------------------------

loc_7FA72:
                cmpi.w  #$3488,d0
                bhi.s   locret_7FA7C

loc_7FA78:
                neg.w   x_vel(a0)

locret_7FA7C:
                rts
; End of function sub_7FA60

; =============== S U B R O U T I N E =======================================

sub_7FA7E:
                jsr     Check_PlayerCollision(pc)
                beq.s   locret_7FACA
                move.b  $3C(a0),d0
                move.b  (V_int_run_count+3).w,d1
                andi.b  #3,d1
                subq.b  #2,d1
                add.w   d1,d0
                jsr     (GetSineCosine).l
                lsl.w   #3,d0
                lsl.w   #3,d1
                move.w  d0,x_vel(a1)
                move.w  d1,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                bclr    #Status_Push,status(a1)
                clr.b   jumping(a1)
                move.b  #1,anim(a0)
                moveq   #signextendB(sfx_Bumper),d0
                jsr     (Play_SFX).l

locret_7FACA:
                rts
; End of function sub_7FA7E

; =============== S U B R O U T I N E =======================================

sub_7FACC:
                moveq   #0,d0
                move.b  $3C(a0),d0
                bclr    #7,d0
                sne     d2
                moveq   #4,d3
                lea     byte_7FB0A(pc),a1
                btst    #6,d0
                beq.s   loc_7FAE8
                moveq   #$A,d3
                addq.w  #8,a1

loc_7FAE8:
                cmp.b   (a1)+,d0
                blo.s   loc_7FAF0
                addq.w  #1,d3
                bra.s   loc_7FAE8
; ---------------------------------------------------------------------------

loc_7FAF0:
                move.b  d3,mapping_frame(a0)
                move.b  render_flags(a0),d0
                andi.b  #$FC,d0
                tst.b   d2
                beq.s   loc_7FB04
                ori.b   #3,d0

loc_7FB04:
                move.b  d0,render_flags(a0)
                rts
; End of function sub_7FACC

; ---------------------------------------------------------------------------
byte_7FB0A:
                dc.b    5, $10, $1B, $26, $31, $3C, $40
                even
                dc.b    $45, $50, $5B, $66, $71, $7C, $80
                even

; =============== S U B R O U T I N E =======================================

sub_7FB1A:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                lsr.w   #1,d0
                addi.b  #$1F,d0
                move.b  d0,mapping_frame(a0)
                add.w   d1,d1
                move.l  word_7FB42(pc,d1.w),x_vel(a0)   ; and y_vel
                btst    #1,render_flags(a0)
                beq.s   locret_7FB40
                neg.w   y_vel(a0)

locret_7FB40:
                rts
; End of function sub_7FB1A

; ---------------------------------------------------------------------------
word_7FB42:
                dc.w    -$16A, -$16A
                dc.w    0, -$200
                dc.w    $16A, -$16A

; =============== S U B R O U T I N E =======================================

sub_7FB4E:
                movea.w parent3(a0),a1
                btst    #6,status(a1)
                bne.s   locret_7FB88
                lea     word_7FB8A(pc),a2
                jsr     Check_InMyRange(pc)
                beq.s   locret_7FB88
                btst    #1,render_flags(a0)
                sne     d0
                tst.w   y_vel(a0)
                bpl.s   loc_7FB74
                not.b   d0

loc_7FB74:
                tst.b   d0
                beq.s   loc_7FB82
                st      $42(a1)
                bset    #6,status(a1)

loc_7FB82:
                bsr.w   sub_7F4B8
                addq.w  #4,sp

locret_7FB88:
                rts
; End of function sub_7FB4E

; ---------------------------------------------------------------------------
word_7FB8A:
                dc.w    -$28,   $50,  -$28,   $50

; =============== S U B R O U T I N E =======================================

sub_7FB92:
                tst.b   $42(a0)
                beq.s   locret_7FBD4
                tst.b   $20(a0)
                bne.s   loc_7FBB2
                subq.b  #1,collision_property(a0)
                beq.s   loc_7FBD6
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_7FBB2:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_7FBC0
                addi.w  #2*6,d0

loc_7FBC0:
                bsr.w   sub_7FC0E
                subq.b  #1,$20(a0)
                bne.s   locret_7FBD4
                bclr    #6,status(a0)
                clr.b   $42(a0)

locret_7FBD4:
                rts
; ---------------------------------------------------------------------------

loc_7FBD6:
                move.l  #Wait_NewDelay,(a0)
                bset    #7,status(a0)
                bset    #0,(_unkFAB8).w
                move.l  #loc_7F210,$34(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild6_Simple).l
                jsr     (AllocateObject).l
                bne.s   loc_7FC0A
                move.l  #loc_7FC3E,(a1)

loc_7FC0A:
                jmp     BossDefeated_StopTimer(pc)
; End of function sub_7FB92

; =============== S U B R O U T I N E =======================================

sub_7FC0E:
                lea     word_7FC1A(pc),a1
                lea     word_7FC26(pc,d0.w),a2
                jmp     CopyWordData_6(pc)
; End of function sub_7FC0E

; ---------------------------------------------------------------------------
word_7FC1A:
                dc.w    Normal_palette_line_2+$06, Normal_palette_line_2+$08, Normal_palette_line_2+$16
                dc.w    Normal_palette_line_2+$18, Normal_palette_line_2+$1A, Normal_palette_line_2+$1C
word_7FC26:
                dc.w    $2A,     6,  $A48,  $644,  $422,     0
                dc.w    $888,  $AAA,  $888,  $AAA,  $CCC,  $EEE
; ---------------------------------------------------------------------------

loc_7FC3E:
                clr.b   (Reverse_gravity_flag).w
                rts
