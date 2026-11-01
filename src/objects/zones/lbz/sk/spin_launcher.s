; Owner: objects/zones/lbz/sk
; Responsibility: Launch Base spin launcher motion, player capture, launch and release
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_LBZSpinLauncher:
                move.l  #Map_LBZSpinLauncher,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.l  #loc_28DE4,(a0)

loc_28DE4:
                move.w  #$2B,d1
                move.w  #$10,d2
                move.w  x_pos(a0),d4
                lea     (byte_28FF4).l,a2
                lea     $2E(a0),a4
                tst.b   (a4)
                beq.s   loc_28E02
                subq.b  #1,(a4)
                bra.s   loc_28E1E
; ---------------------------------------------------------------------------

loc_28E02:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                movem.l d1-d4,-(sp)
                jsr     (CollidePlayerWithHeightProfileSolid).l
                cmpi.w  #-2,d4
                bne.s   loc_28E1A
                bsr.s   BouncePlayerFromLbzSpinLauncherUnderside

loc_28E1A:
                movem.l (sp)+,d1-d4

loc_28E1E:
                addq.w  #1,a4
                tst.b   (a4)
                beq.s   loc_28E28
                subq.b  #1,(a4)
                bra.s   loc_28E3C
; ---------------------------------------------------------------------------

loc_28E28:
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                jsr     (CollidePlayerWithHeightProfileSolid).l
                cmpi.w  #-2,d4
                bne.s   loc_28E3C
                bsr.s   BouncePlayerFromLbzSpinLauncherUnderside

loc_28E3C:
                move.b  status(a0),d6
                andi.b  #standing_mask,d6
                beq.s   loc_28E70
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   loc_28E5C
                lea     $2E(a0),a4
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.w   EjectStandingPlayerFromLbzSpinLauncher

loc_28E5C:
                andi.b  #p2_standing,d6
                beq.s   loc_28E70
                lea     $2F(a0),a4
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.w   EjectStandingPlayerFromLbzSpinLauncher

loc_28E70:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

BouncePlayerFromLbzSpinLauncherUnderside:
                btst    #0,status(a0)
                bne.s   loc_28EDE
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$18,d0
                cmpi.w  #$30,d0
                bhs.s   locret_28EDC
                move.w  x_pos(a0),d0
                addi.w  #$10,d0
                move.w  d0,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  #0,x_vel(a1)
                move.w  #-$A00,y_vel(a1)
                move.w  #$800,ground_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #0,jumping(a1)
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.b  #$10,(a4)

locret_28EDC:
                rts
; ---------------------------------------------------------------------------

loc_28EDE:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                neg.w   d0
                addi.w  #$18,d0
                cmpi.w  #$30,d0
                bhs.s   locret_28EDC
                move.w  x_pos(a0),d0
                subi.w  #$10,d0
                move.w  d0,x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  #0,x_vel(a1)
                move.w  #-$A00,y_vel(a1)
                move.w  #$800,ground_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #0,jumping(a1)
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.b  #$10,(a4)
                rts
; End of function BouncePlayerFromLbzSpinLauncherUnderside

; =============== S U B R O U T I N E =======================================

EjectStandingPlayerFromLbzSpinLauncher:
                btst    #0,status(a0)
                bne.s   loc_28F9C
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                cmpi.w  #$20,d0
                bhs.s   locret_28EDC
                move.w  x_pos(a0),d0
                addi.w  #$10,d0
                move.w  d0,x_pos(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #0,jumping(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    #Status_Roll,status(a1)
                move.b  #0,anim(a1)
                bclr    d6,status(a0)
                move.b  #$20,(a4)
                rts
; ---------------------------------------------------------------------------

loc_28F9C:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                neg.w   d0
                cmpi.w  #$20,d0
                bhs.w   locret_28EDC
                move.w  x_pos(a0),d0
                subi.w  #$10,d0
                move.w  d0,x_pos(a1)
                move.w  #0,x_vel(a1)
                move.w  #0,y_vel(a1)
                move.w  #0,ground_vel(a1)
                bset    #Status_InAir,status(a1)
                move.b  #0,jumping(a1)
                bclr    #Status_OnObj,status(a1)
                bclr    #Status_Roll,status(a1)
                move.b  #0,anim(a1)
                bclr    d6,status(a0)
                move.b  #$20,(a4)
                rts
; End of function EjectStandingPlayerFromLbzSpinLauncher

; ---------------------------------------------------------------------------
byte_28FF4:
                dc.b    $11
                dc.b    $11
                dc.b    $11
                dc.b    $11
                dc.b    $11
                dc.b    $11
                dc.b    $11
                dc.b    $12
                dc.b    $13
                dc.b    $14
                dc.b    $15
                dc.b    $16
                dc.b    $17
                dc.b    $18
                dc.b    $19
                dc.b    $1A
                dc.b    $1B
                dc.b    $1C
                dc.b    $1D
                dc.b    $1E
                dc.b    $1F
                dc.b    $20
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                dc.b    $21
                even
