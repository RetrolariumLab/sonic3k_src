; Owner: objects/bosses/ssz/shared/sk
; Responsibility: Shared Mecha Sonic movement, collision, pattern, parent-state and palette helper callbacks with private lookup constants
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_7D150:
                lea     (Player_1).w,a1
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                clr.w   ground_vel(a1)
                rts
; End of function sub_7D150

; =============== S U B R O U T I N E =======================================

sub_7D162:
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                move.l  word_7D172(pc,d0.w),x_vel(a0)   ; and y_vel
                rts
; End of function sub_7D162

; ---------------------------------------------------------------------------
word_7D172:
                dc.w    0,  $400
                dc.w    $2D4,  $2D4
                dc.w    $400,     0
                dc.w    $2D4, -$2D4
                dc.w    0, -$400
                dc.w    -$2D4, -$2D4
                dc.w    -$400,     0
                dc.w    -$2D4,  $2D4

; =============== S U B R O U T I N E =======================================

sub_7D192:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lea     off_7D1A6(pc,d0.w),a1
                move.l  (a1)+,$30(a0)
                move.l  (a1)+,$34(a0)
                rts
; End of function sub_7D192

; ---------------------------------------------------------------------------
off_7D1A6:
                dc.l    byte_7D68C
                dc.l    loc_7C764
                dc.l    byte_7D6B3
                dc.l    Go_Delete_Sprite

; =============== S U B R O U T I N E =======================================

sub_7D1B6:
                bsr.w   sub_7D1EA
                moveq   #0,d0
                move.b  child_dx(a0),d0
                lsl.w   #2,d0
                lea     byte_7D1D2-4(pc,d0.w),a1

loc_7D1C6:
                move.b  (a1)+,d1
                beq.s   locret_7D1D0
                cmp.b   d1,d2
                bne.s   loc_7D1C6
                moveq   #1,d0

locret_7D1D0:
                rts
; End of function sub_7D1B6

; ---------------------------------------------------------------------------
byte_7D1D2:
                dc.b    1
                dc.b    0
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    2
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    2
                dc.b    3
                dc.b    0
                dc.b    4
                dc.b    5
                dc.b    6
                dc.b    0
                dc.b    5
                dc.b    6
                dc.b    0
                dc.b    0
                dc.b    6
                dc.b    0
                dc.b    0
                dc.b    0
                even

; =============== S U B R O U T I N E =======================================

sub_7D1EA:
                move.w  (Player_1+x_pos).w,d0
                sub.w   (Camera_min_X_pos).w,d0
                move.w  d0,d1
                subi.w  #$F0,d1
                scc     d3
                bcc.s   loc_7D202
                moveq   #1,d2
                bra.w   loc_7D204
; ---------------------------------------------------------------------------

loc_7D202:
                moveq   #4,d2

loc_7D204:
                cmpi.w  #$50,d0
                blo.s   locret_7D214
                addq.w  #1,d2
                cmpi.w  #$A0,d0
                blo.s   locret_7D214
                addq.w  #1,d2

locret_7D214:
                rts
; End of function sub_7D1EA

; ---------------------------------------------------------------------------

loc_7D216:
                tst.w   x_vel(a0)
                bmi.s   loc_7D228
                move.w  (_unkFAB6).w,d0
                cmp.w   x_pos(a0),d0
                bls.s   loc_7D234
                rts
; ---------------------------------------------------------------------------

loc_7D228:
                move.w  (_unkFAB4).w,d0
                cmp.w   x_pos(a0),d0
                bhs.s   loc_7D234
                rts
; ---------------------------------------------------------------------------

loc_7D234:
                jmp     (a1)

; =============== S U B R O U T I N E =======================================

sub_7D236:
                moveq   #0,d0
                move.b  subtype(a0),d0
                add.w   d0,d0
                lea     byte_7D24C(pc,d0.w),a1
                move.w  (a1)+,child_dx(a0)              ; and child_dy
                move.w  (a1)+,priority(a0)
                rts
; End of function sub_7D236

; ---------------------------------------------------------------------------
byte_7D24C:
                dc.b    -4, $1C
                dc.w    $300
                dc.b    8, $1C
                dc.w    $200
                dc.b    -8, $1C
                dc.w    $200
                dc.b    4, $1C
                dc.w    $300
                dc.b    $C,  $C
                dc.w    $200

; =============== S U B R O U T I N E =======================================

sub_7D260:
                lea     byte_7D280(pc),a1
                movea.w parent3(a0),a2
                moveq   #0,d0
                move.b  mapping_frame(a2),d0
                lsl.w   #2,d0
                adda.w  d0,a1
                move.w  (a1)+,child_dx(a0)              ; and child_dy
                move.b  (a1)+,collision_flags(a0)
                move.b  (a1)+,mapping_frame(a0)
                rts
; End of function sub_7D260

; ---------------------------------------------------------------------------
byte_7D280:
                dc.b    $10, -$C, $B4,   2
                dc.b    $10,  -4, $B4,   2
                dc.b    $10,   0, $B4,   2
                dc.b    0,   0,   0,   0
                dc.b    0,   0,   0,   0
                dc.b    0,   0,   0,   0
                dc.b    0,   0,   0,   0
                dc.b    $14,  -8, $9E,   1
                dc.b    $10, -$C, $9E,   1
                dc.b    $C,-$14, $98,   0
                dc.b    0,-$14, $B3,   8
                dc.b    -$C,-$14, $98,   0
                dc.b    -$10, -$C, $B4,   2
                dc.b    $10, -$C, $B4,   2
                dc.b    $10,   4, $B4,   2
                dc.b    $14,  $C, $B4,   2
                dc.b    $17,   5, $B4,   2
                dc.b    $10, -$C, $B4,   2
                dc.b    $C, -$C, $9E,   1
                dc.b    $10, -$C, $B4,   2
                dc.b    $10, -$C, $B4,   2
                dc.b    $10, -$C, $B4,   2
                even

; =============== S U B R O U T I N E =======================================

sub_7D2D8:
                btst    #6,status(a0)
                bne.s   locret_7D2FA
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                move.b  byte_7D2FC(pc,d0.w),d0
                btst    #7,$38(a0)
                beq.s   loc_7D2F6
                ori.b   #$80,d0

loc_7D2F6:
                move.b  d0,collision_flags(a0)

locret_7D2FA:
                rts
; End of function sub_7D2D8

; ---------------------------------------------------------------------------
byte_7D2FC:
                dc.b    $23
                dc.b    $23
                dc.b    9
                dc.b    $86
                dc.b    $86
                dc.b    $86
                dc.b    $86
                dc.b    $1A
                dc.b    $23
                dc.b    $23
                dc.b    $23
                dc.b    $23
                dc.b    $23
                dc.b    $23
                dc.b    9
                dc.b    0
                dc.b    9
                dc.b    $23
                dc.b    6
                dc.b    $23
                dc.b    $23
                dc.b    $23
                even

; =============== S U B R O U T I N E =======================================

sub_7D312:
                tst.b   collision_flags(a0)
                bne.s   locret_7D356
                move.b  collision_property(a0),d0
                beq.s   loc_7D358
                tst.b   $20(a0)
                bne.s   loc_7D338
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                bset    #6,status(a0)

loc_7D338:
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_7D346
; Bug: this should be 2*5
                addi.w  #2*4,d0

loc_7D346:
                bsr.w   sub_7D3BE
                subq.b  #1,$20(a0)
                bne.s   locret_7D356
                bclr    #6,status(a0)

locret_7D356:
                rts
; ---------------------------------------------------------------------------

loc_7D358:
                jmp     (a4)
; End of function sub_7D312

; =============== S U B R O U T I N E =======================================

sub_7D35A:
                move.l  #loc_7B81A,(a0)
                clr.b   routine(a0)
                move.l  #loc_7B858,$34(a0)
                bset    #6,status(a0)
                clr.b   (Update_HUD_timer).w
                move.w  #$7F,$2E(a0)
                moveq   #100,d0
                jsr     (HUD_AddToScore).l
                bclr    #7,render_flags(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     CreateChild1_Normal(pc)
                bne.s   locret_7D39C
                move.b  #4,subtype(a1)

locret_7D39C:
                rts
; End of function sub_7D35A

; ---------------------------------------------------------------------------

loc_7D39E:
                bset    #7,$38(a0)
                bsr.s   sub_7D35A
                move.w  (Camera_X_pos).w,d0
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_max_X_pos).w
                lea     (Pal_SSZGHZMisc).l,a1
                jmp     (PalLoad_Line1).l

; =============== S U B R O U T I N E =======================================

sub_7D3BE:
                lea     word_7D3CC(pc),a1
                lea     word_7D3D6(pc,d0.w),a2
                jmp     (CopyWordData_5).l
; End of function sub_7D3BE

; ---------------------------------------------------------------------------
word_7D3CC:
                dc.w    Normal_palette_line_2+$08, Normal_palette_line_2+$14, Normal_palette_line_2+$16, Normal_palette_line_2+$18, Normal_palette_line_2+$1C
word_7D3D6:
                dc.w    8,  $A24,  $624,  $422,   $20
                dc.w    $888,  $666,  $888,  $AAA,  $EEE
