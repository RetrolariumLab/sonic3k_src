; Owner: objects/zones/soz/sk
; Responsibility: Sandopolis ghost spawn velocity, darkness-dependent motion initialization and private speed records
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

; sub_8F538:
set_Hyudoro_body_init:
                jsr     (Random_Number).l
                andi.w  #$FF,d0
                subi.w  #$7F,d0
                add.w   d0,x_pos(a0)
                moveq   #0,d1
                move.b  (SOZ_darkness_level).w,d1
                add.w   d1,d1
                move.w  Hyudoro_init_spd_tbl(pc,d1.w),d2
                cmpi.w  #$120,d0
                bhs.s   ._100
                bset    #0,render_flags(a0)
                neg.w   d2

; loc_8F564:
                ._100:
                move.w  d2,x_vel(a0)
                andi.w  #$C,d1
                move.l  .pg_tbl(pc,d1.w),$30(a0)
                bra.w   set_puka_init
; ---------------------------------------------------------------------------

; off_8F576:
                .pg_tbl:
                dc.l    Hyudoro_apar_pg00
                dc.l    Hyudoro_apar_pg01
                dc.l    Hyudoro_apar_pg02
; ---------------------------------------------------------------------------

; word_8F582:
Hyudoro_init_spd_tbl:
                dc.w    -$100
                dc.w    -$100
                dc.w    -$100
                dc.w    -$180
                dc.w    -$180
                dc.w    -$200
; ---------------------------------------------------------------------------

; loc_8F58E:
set_puka_init:
                moveq   #0,d0
                move.b  (SOZ_darkness_level).w,d0
                add.w   d0,d0
                move.w  Hyudoro_init_spd_tbl(pc,d0.w),d1
                tst.w   x_vel(a0)
                bmi.s   ._100
                neg.w   d1

; loc_8F5A2:
                ._100:
                move.w  d1,x_vel(a0)
                add.w   d0,d0
                movea.l .puka_tbl(pc,d0.w),a1
                bclr    #0,$38(a0)
                jsr     (a1)
                tst.w   y_vel(a0)
                bpl.s   ._200
                bset    #0,$38(a0)
                neg.w   d0

; loc_8F5C2:
                ._200:
                move.w  d0,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

; off_8F5C8:
                .puka_tbl:
                dc.l    puka_init_00
                dc.l    puka_init_00
                dc.l    puka_init_00
                dc.l    puka_init_01
                dc.l    puka_init_01
                dc.l    puka_init_02
; ---------------------------------------------------------------------------

; loc_8F5E0:
puka_init_00:
                move.w  #$40,d0
                move.w  d0,$3E(a0)
                move.w  #4,$40(a0)
                rts
; ---------------------------------------------------------------------------

; loc_8F5F0:
puka_init_01:
                move.w  #$80,d0
                move.w  d0,$3E(a0)
                move.w  #8,$40(a0)
                bclr    #0,$38(a0)
                rts
; ---------------------------------------------------------------------------

; loc_8F606:
puka_init_02:
                move.w  #$C0,d0
                move.w  d0,$3E(a0)
                move.w  #$10,$40(a0)
                bclr    #0,$38(a0)
                rts
