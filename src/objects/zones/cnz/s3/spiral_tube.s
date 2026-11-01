; Owner: objects/zones/cnz/s3
; Responsibility: Carnival Night spiral tube player transport, directional motion and release
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZSpiralTube:
                lea     (Player_1).w,a1
                lea     $30(a0),a4
                bsr.s   UpdatePlayerInCnzSpiralTube
                lea     (Player_2).w,a1
                lea     $3A(a0),a4
                bsr.s   UpdatePlayerInCnzSpiralTube
                move.b  $30(a0),d0
                add.b   $3A(a0),d0
                beq.s   loc_32322
                rts
; ---------------------------------------------------------------------------

loc_32322:
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

UpdatePlayerInCnzSpiralTube:
                moveq   #0,d0
                move.b  (a4),d0
                move.w  off_32334(pc,d0.w),d0
                jmp     off_32334(pc,d0.w)
; End of function UpdatePlayerInCnzSpiralTube

; ---------------------------------------------------------------------------
off_32334:
                dc.w    loc_3233C-off_32334
                dc.w    loc_323C8-off_32334
                dc.w    loc_32404-off_32334
                dc.w    loc_32448-off_32334
; ---------------------------------------------------------------------------

loc_3233C:
                tst.w   (Debug_placement_mode).w
                bne.w   locret_323C6
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$80,d0
                bhs.s   locret_323C6
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$10,d1
                cmpi.w  #$20,d1
                bhs.s   locret_323C6
                tst.b   object_control(a1)
                bne.s   locret_323C6
                addq.b  #2,(a4)
                move.b  #$81,object_control(a1)
                move.b  #2,anim(a1)
                move.w  #$800,ground_vel(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                clr.b   1(a4)
                moveq   #$30,d1
                cmpi.w  #$40,d0
                bhs.s   loc_323AE
                neg.w   d1
                move.b  #$80,1(a4)

loc_323AE:
                add.w   x_pos(a0),d1
                move.w  d1,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  #sfx_Roll,d0
                jsr     (Play_SFX).l

locret_323C6:
                rts
; ---------------------------------------------------------------------------

loc_323C8:
                move.b  1(a4),d0
                addq.b  #8,1(a4)
                jsr     (GetSineCosine).l
                asr.w   #3,d1
                move.w  d1,d0
                asr.w   #1,d1
                add.w   d1,d0
                add.w   x_pos(a0),d0
                move.w  d0,x_pos(a1)
                moveq   #0,d0
                btst    #0,(Ring_count+1).w
                beq.s   loc_323F4
                move.w  #$80,d0

loc_323F4:
                cmp.b   1(a4),d0
                bne.s   locret_32402
                addq.b  #2,(a4)
                move.w  #$C0,2(a4)

locret_32402:
                rts
; ---------------------------------------------------------------------------

loc_32404:
                move.b  1(a4),d0
                addi.b  #$C,1(a4)
                jsr     (GetSineCosine).l
                asr.w   #3,d1
                move.w  d1,d0
                asr.w   #1,d1
                add.w   d1,d0
                add.w   x_pos(a0),d0
                move.w  d0,x_pos(a1)
                addq.w  #2,y_pos(a1)
                subq.w  #1,2(a4)
                bne.s   locret_32446
                moveq   #0,d0
                move.w  x_pos(a0),d1
                sub.w   x_pos(a1),d1
                bcc.s   loc_3243C
                moveq   #1,d0

loc_3243C:
                add.b   subtype(a0),d0
                bsr.w   InitializeCnzSpiralExitRoute
                addq.b  #2,(a4)

locret_32446:
                rts
; ---------------------------------------------------------------------------

loc_32448:
                subq.b  #1,2(a4)
                bpl.s   loc_32474
                movea.l 6(a4),a2
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)
                move.l  a2,6(a4)
                subq.w  #4,4(a4)
                beq.s   loc_3249A
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  #$C00,d2
                bra.w   loc_324DC
; ---------------------------------------------------------------------------

loc_32474:
                move.l  x_pos(a1),d2
                move.l  y_pos(a1),d3
                move.w  x_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d2
                move.w  y_vel(a1),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3
                move.l  d2,x_pos(a1)
                move.l  d3,y_pos(a1)
                rts
; ---------------------------------------------------------------------------

loc_3249A:
                andi.w  #$FFF,y_pos(a1)
                clr.b   (a4)
                clr.b   object_control(a1)
                clr.b   jumping(a1)
                bra.s   loc_32474

; =============== S U B R O U T I N E =======================================

InitializeCnzSpiralExitRoute:
                andi.w  #$F,d0
                add.w   d0,d0
                lea     (off_3255A).l,a2
                adda.w  (a2,d0.w),a2
                move.w  (a2)+,4(a4)
                subq.w  #4,4(a4)
                move.w  (a2)+,d4
                move.w  d4,x_pos(a1)
                move.w  (a2)+,d5
                move.w  d5,y_pos(a1)
                move.l  a2,6(a4)
                move.w  (a2)+,d4
                move.w  (a2)+,d5
                move.w  #$C00,d2

loc_324DC:
                moveq   #0,d0
                move.w  d2,d3
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                bge.s   loc_324EC
                neg.w   d0
                neg.w   d2

loc_324EC:
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                bge.s   loc_324FA
                neg.w   d1
                neg.w   d3

loc_324FA:
                cmp.w   d0,d1
                blo.s   loc_3252C
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                swap    d1
                divs.w  d3,d1
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                beq.s   loc_32518
                swap    d0
                divs.w  d1,d0

loc_32518:
                move.w  d0,x_vel(a1)
                move.w  d3,y_vel(a1)
                tst.w   d1
                bpl.s   loc_32526
                neg.w   d1

loc_32526:
                move.w  d1,2(a4)
                rts
; ---------------------------------------------------------------------------

loc_3252C:
                moveq   #0,d0
                move.w  d4,d0
                sub.w   x_pos(a1),d0
                swap    d0
                divs.w  d2,d0
                moveq   #0,d1
                move.w  d5,d1
                sub.w   y_pos(a1),d1
                beq.s   loc_32546
                swap    d1
                divs.w  d0,d1

loc_32546:
                move.w  d1,y_vel(a1)
                move.w  d2,x_vel(a1)
                tst.w   d0
                bpl.s   loc_32554
                neg.w   d0

loc_32554:
                move.w  d0,2(a4)
                rts
; End of function InitializeCnzSpiralExitRoute

; ---------------------------------------------------------------------------
off_3255A:
                dc.w    word_32562-off_3255A
                dc.w    word_32570-off_3255A
                dc.w    word_3257E-off_3255A
                dc.w    word_3258C-off_3255A
word_32562:     dc.w    $C
                dc.w    $1390,  $2D0
                dc.w    $1230,  $2D0
                dc.w    $1230,  $300
word_32570:     dc.w    $C
                dc.w    $13F0,  $2D0
                dc.w    $1560,  $2D0
                dc.w    $1560,  $280
word_3257E:     dc.w    $C
                dc.w    $2090,  $650
                dc.w    $2030,  $650
                dc.w    $2030,  $680
word_3258C:     dc.w    $C
                dc.w    $20F0,  $650
                dc.w    $21E0,  $650
                dc.w    $21E0,  $600
