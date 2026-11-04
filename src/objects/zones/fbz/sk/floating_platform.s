; Owner: objects/zones/fbz/sk
; Responsibility: Floating platform movement, player riding and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
off_3A56C:
                dc.l    loc_3A620
                dc.l    loc_3A63A
                dc.l    loc_3A646
                dc.l    loc_3A664
                dc.l    loc_3A692
; ---------------------------------------------------------------------------

Obj_FBZFloatingPlatform:
                move.l  #Map_FBZFloatingPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$A,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #$8C,collision_flags(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$70,d0
                lsr.w   #2,d0
                move.l  off_3A56C(pc,d0.w),$40(a0)
                andi.w  #$F,d1
                lsl.w   #4,d1
                move.b  d1,angle(a0)
                move.l  #loc_3A5DA,(a0)

loc_3A5DA:
                move.w  x_pos(a0),-(sp)
                movea.l $40(a0),a1
                jsr     (a1)
                move.w  #$2B,d1
                move.w  #$C,d2
                move.w  #-$D,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull_Offset).l
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_3A616
                move.b  #1,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   loc_3A616
                move.b  #0,mapping_frame(a0)

loc_3A616:
                move.w  $44(a0),d0
                jmp     (SKRuntimeLifetime_TouchDrawCull_TestSuppliedCoarseXAndRegisterContact).l
; ---------------------------------------------------------------------------

loc_3A620:
                move.b  $27(a0),d0
                addq.b  #1,$27(a0)
                jsr     (GetSineCosine).l
                asr.w   #5,d0
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_3A63A:
                moveq   #0,d0
                move.b  (Oscillating_table+$0A).w,d0
                subi.w  #$20,d0
                bra.s   loc_3A650
; ---------------------------------------------------------------------------

loc_3A646:
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                subi.w  #$40,d0

loc_3A650:
                btst    #0,status(a0)
                beq.s   loc_3A65A
                neg.w   d0

loc_3A65A:
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_3A664:
                move.b  (Level_frame_counter+1).w,d0
                btst    #0,status(a0)
                beq.s   loc_3A672
                neg.b   d0

loc_3A672:
                add.b   angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d0
                asr.w   #2,d1
                add.w   $44(a0),d0
                move.w  d0,x_pos(a0)
                add.w   $46(a0),d1
                move.w  d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_3A692:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_3A620
                move.l  #loc_3A6A4,$40(a0)

loc_3A6A4:
                move.b  $27(a0),d0
                andi.b  #$7F,d0
                bne.w   loc_3A620
                move.l  #loc_3A6D0,$40(a0)
                move.b  #0,$27(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lsl.w   #1,d0
                addi.w  #$28,d0
                move.w  d0,$36(a0)

loc_3A6D0:
                move.w  $36(a0),d2
                subq.w  #1,d2
                tst.b   $30(a0)
                bne.s   loc_3A6F8
                move.w  $34(a0),d1
                addq.w  #4,d1
                move.w  d1,$34(a0)
                add.w   d1,$32(a0)
                cmp.b   $32(a0),d2
                bhi.s   loc_3A712
                move.b  #1,$30(a0)
                bra.s   loc_3A712
; ---------------------------------------------------------------------------

loc_3A6F8:
                move.w  $34(a0),d1
                subq.w  #4,d1
                move.w  d1,$34(a0)
                add.w   d1,$32(a0)
                cmp.b   $32(a0),d2
                bls.s   loc_3A712
                move.b  #0,$30(a0)

loc_3A712:
                moveq   #0,d0
                move.w  $32(a0),d0
                lsr.w   #6,d0
                btst    #0,status(a0)
                beq.s   loc_3A724
                neg.w   d0

loc_3A724:
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                tst.w   $34(a0)
                bne.s   locret_3A740
                move.w  y_pos(a0),$46(a0)
                move.l  #loc_3A620,$40(a0)

locret_3A740:
                rts
; ---------------------------------------------------------------------------
Map_FBZFloatingPlatform:
                include "src/objects/shared/zones/fbz/mappings/floating_platform.s"
