; Owner: objects/shared/s3
; Responsibility: Spike orientation, movement, player collision and damage responses with competition variants and mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
byte_22602:
                dc.b    $10, $10
                dc.b    $20, $10
                dc.b    $30, $10
                dc.b    $40, $10
                dc.b    $10, $10
                dc.b    $10, $20
                dc.b    $10, $30
                dc.b    $10, $40
                even
; ---------------------------------------------------------------------------

Obj_Spikes:
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.b  subtype(a0),d0
                andi.w  #$F0,d0
                lsr.w   #3,d0
                tst.w   (Competition_mode).w
                bne.s   loc_226A0
                lea     byte_22602(pc,d0.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.l  #loc_226FC,(a0)
                move.l  #Map_Spikes,mappings(a0)
                move.w  #make_art_tile(ArtTile_SpikesSprings+$8,0,0),art_tile(a0)
                lsr.w   #1,d0
                move.b  d0,mapping_frame(a0)
                cmpi.b  #4,d0
                blo.s   loc_22666
                move.l  #loc_2274E,(a0)
                move.w  #make_art_tile(ArtTile_SpikesSprings,0,0),art_tile(a0)

loc_22666:
                btst    #1,status(a0)
                beq.s   loc_22674
                move.l  #loc_227AA,(a0)

loc_22674:
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  subtype(a0),d0
                andi.b  #$F,d0
                add.b   d0,d0
                move.b  d0,subtype(a0)
                rts
; ---------------------------------------------------------------------------
byte_22690:
                dc.b    $C,  $C
                dc.b    $18,  $C
                dc.b    $24,  $C
                dc.b    $30,  $C
                dc.b    $C,  $C
                dc.b    $C, $18
                dc.b    $C, $24
                dc.b    $C, $30
; ---------------------------------------------------------------------------

loc_226A0:
                lea     byte_22690(pc,d0.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.l  #loc_227FA,(a0)
                move.l  #Map_2PSpikes,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PArt_2,0,0),art_tile(a0)
                lsr.w   #1,d0
                move.b  d0,mapping_frame(a0)
                cmpi.b  #4,d0
                blo.s   loc_226D2
                move.l  #loc_22848,(a0)

loc_226D2:
                btst    #1,status(a0)
                beq.s   loc_226E0
                move.l  #loc_228A0,(a0)

loc_226E0:
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  subtype(a0),d0
                andi.b  #$F,d0
                add.b   d0,d0
                move.b  d0,subtype(a0)
                rts
; ---------------------------------------------------------------------------

loc_226FC:
                bsr.w   sub_22922
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull
                move.b  status(a0),d6
                andi.b  #standing_mask,d6
                beq.s   loc_22744
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   loc_22736
                lea     (Player_1).w,a1
                bsr.w   sub_228EC

loc_22736:
                andi.b  #p2_standing,d6
                beq.s   loc_22744
                lea     (Player_2).w,a1
                bsr.w   sub_228EC

loc_22744:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

loc_2274E:
                bsr.w   sub_22922
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull
                swap    d6
                andi.w  #1|2,d6
                beq.s   loc_227A0
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   loc_2278C
                lea     (Player_1).w,a1
                bsr.w   sub_228EC
                bclr    #p1_pushing_bit,status(a0)

loc_2278C:
                andi.b  #2,d6
                beq.s   loc_227A0
                lea     (Player_2).w,a1
                bsr.w   sub_228EC
                bclr    #p2_pushing_bit,status(a0)

loc_227A0:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

loc_227AA:
                bsr.w   sub_22922
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull
                swap    d6
                andi.w  #4|8,d6
                beq.s   loc_227F0
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   loc_227E2
                lea     (Player_1).w,a1
                bsr.w   sub_228EC

loc_227E2:
                andi.b  #8,d6
                beq.s   loc_227F0
                lea     (Player_2).w,a1
                bsr.w   sub_228EC

loc_227F0:
                move.w  $30(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

loc_227FA:
                bsr.w   sub_229C0
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #7,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull
                move.b  status(a0),d6
                andi.b  #standing_mask,d6
                beq.s   loc_22842
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   loc_22834
                lea     (Player_1).w,a1
                bsr.w   sub_228EC

loc_22834:
                andi.b  #p2_standing,d6
                beq.s   loc_22842
                lea     (Player_2).w,a1
                bsr.w   sub_228EC

loc_22842:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_22848:
                bsr.w   sub_229C0
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #7,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull
                swap    d6
                andi.w  #1|2,d6
                beq.s   loc_2289A
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   loc_22886
                lea     (Player_1).w,a1
                bsr.w   sub_228EC
                bclr    #p1_pushing_bit,status(a0)

loc_22886:
                andi.b  #2,d6
                beq.s   loc_2289A
                lea     (Player_2).w,a1
                bsr.w   sub_228EC
                bclr    #p2_pushing_bit,status(a0)

loc_2289A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_228A0:
                bsr.w   sub_229C0
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #7,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull
                swap    d6
                andi.w  #4|8,d6
                beq.s   loc_228E6
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   loc_228D8
                lea     (Player_1).w,a1
                bsr.w   sub_228EC

loc_228D8:
                andi.b  #8,d6
                beq.s   loc_228E6
                lea     (Player_2).w,a1
                bsr.w   sub_228EC

loc_228E6:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_228EC:
                btst    #Status_Invincible,status_secondary(a1)
                bne.s   locret_22920
                tst.b   invulnerability_timer(a1)
                bne.s   locret_22920
                cmpi.b  #4,routine(a1)
                bhs.s   locret_22920
                move.l  y_pos(a1),d3
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                sub.l   d0,d3
                move.l  d3,y_pos(a1)
                movea.l a0,a2
                movea.l a1,a0
                jsr     (HurtCharacter).l
                movea.l a2,a0

locret_22920:
                rts
; End of function sub_228EC

; =============== S U B R O U T I N E =======================================

sub_22922:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  off_22930(pc,d0.w),d1
                jmp     off_22930(pc,d1.w)
; End of function sub_22922

; ---------------------------------------------------------------------------
off_22930:
                dc.w    locret_22936-off_22930
                dc.w    loc_22938-off_22930
                dc.w    loc_2294C-off_22930
; ---------------------------------------------------------------------------

locret_22936:
                rts
; ---------------------------------------------------------------------------

loc_22938:
                bsr.w   sub_22960
                moveq   #0,d0
                move.b  $34(a0),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_2294C:
                bsr.w   sub_22960
                moveq   #0,d0
                move.b  $34(a0),d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_22960:
                tst.w   $38(a0)
                beq.s   loc_2297C
                subq.w  #1,$38(a0)
                bne.s   locret_229BE
                tst.b   render_flags(a0)
                bpl.s   locret_229BE
                moveq   #signextendB(sfx_SpikeMove),d0
                jsr     (Play_SFX).l
                bra.s   locret_229BE
; ---------------------------------------------------------------------------

loc_2297C:
                tst.w   $36(a0)
                beq.s   loc_2299E
                subi.w  #$800,$34(a0)
                bcc.s   locret_229BE
                move.w  #0,$34(a0)
                move.w  #0,$36(a0)
                move.w  #60,$38(a0)
                bra.s   locret_229BE
; ---------------------------------------------------------------------------

loc_2299E:
                addi.w  #$800,$34(a0)
                cmpi.w  #$2000,$34(a0)
                blo.s   locret_229BE
                move.w  #$2000,$34(a0)
                move.w  #1,$36(a0)
                move.w  #60,$38(a0)

locret_229BE:
                rts
; End of function sub_22960

; =============== S U B R O U T I N E =======================================

sub_229C0:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  off_229CE(pc,d0.w),d1
                jmp     off_229CE(pc,d1.w)
; End of function sub_229C0

; ---------------------------------------------------------------------------
off_229CE:
                dc.w    locret_22936-off_229CE
                dc.w    loc_229D4-off_229CE
                dc.w    loc_229E8-off_229CE
; ---------------------------------------------------------------------------

loc_229D4:
                bsr.w   sub_229FC
                moveq   #0,d0
                move.b  $34(a0),d0
                add.w   $32(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_229E8:
                bsr.w   sub_229FC
                moveq   #0,d0
                move.b  $34(a0),d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_229FC:
                tst.w   $38(a0)
                beq.s   loc_22A18
                subq.w  #1,$38(a0)
                bne.s   locret_22A5A
                tst.b   render_flags(a0)
                bpl.s   locret_22A5A
                moveq   #signextendB(sfx_SpikeMove),d0
                jsr     (Play_SFX).l
                bra.s   locret_22A5A
; ---------------------------------------------------------------------------

loc_22A18:
                tst.w   $36(a0)
                beq.s   loc_22A3A
                subi.w  #$800,$34(a0)
                bcc.s   locret_22A5A
                move.w  #0,$34(a0)
                move.w  #0,$36(a0)
                move.w  #60,$38(a0)
                bra.s   locret_22A5A
; ---------------------------------------------------------------------------

loc_22A3A:
                addi.w  #$800,$34(a0)
                cmpi.w  #$1800,$34(a0)
                blo.s   locret_22A5A
                move.w  #$1800,$34(a0)
                move.w  #1,$36(a0)
                move.w  #60,$38(a0)

locret_22A5A:
                rts
; End of function sub_229FC

; ---------------------------------------------------------------------------
Map_Spikes:
                include "src/objects/shared/level_misc/map_spikes.s"
Map_2PSpikes:
                include "src/game/competition/shared/2p_zone/map_spikes.s"
