; Owner: objects/zones/ssz/sk
; Responsibility: Swinging carrier coordination, player attachment, travel and release
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_SSZSwingingCarrier:
                move.l  #loc_46142,(a0)
                move.b  #4,render_flags(a0)
                move.b  #8,height_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$74,2,0),art_tile(a0)
                move.l  #Map_SSZElevatorBar,mappings(a0)
                moveq   #$30,d0
                moveq   #1,d1
                tst.b   subtype(a0)
                bpl.s   loc_4610C
                moveq   #8,d0
                moveq   #4,d1

loc_4610C:
                move.b  d0,width_pixels(a0)
                move.b  d1,mapping_frame(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_46142
                move.w  a1,$38(a0)
                move.l  #loc_461A8,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  status(a0),status(a1)
                move.b  subtype(a0),subtype(a1)
                move.w  a0,parent2(a1)

loc_46142:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bls.s   loc_46172
                move.w  $38(a0),d0
                beq.s   loc_46160
                movea.w d0,a1
                st      routine(a1)

loc_46160:
                move.w  respawn_addr(a0),d0
                beq.s   loc_4616C
                movea.w d0,a1
                bclr    #7,(a1)

loc_4616C:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_46172:
                tst.b   subtype(a0)
                bmi.s   loc_46192
                move.l  #$20000,d0
                move.l  #$821,d1
                jsr     Gradual_SwingOffset(pc)
                addi.w  #$41,d0
                move.w  d0,$20(a0)
                bra.s   loc_461A2
; ---------------------------------------------------------------------------

loc_46192:
                moveq   #1,d0
                btst    #0,status(a0)
                beq.s   loc_4619E
                neg.w   d0

loc_4619E:
                add.w   d0,$20(a0)

loc_461A2:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_461A8:
                move.l  #loc_461FE,(a0)
                move.b  #$44,render_flags(a0)
                move.b  #$68,height_pixels(a0)
                move.b  #$68,width_pixels(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$74,3,0),art_tile(a0)
                move.l  #Map_SSZElevatorBar,mappings(a0)
                move.b  subtype(a0),d0
                andi.w  #3,d0
                addq.w  #6,d0
                move.w  d0,mainspr_childsprites(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_461FE
                move.w  a1,$12(a0)
                move.l  #loc_46284,(a1)
                move.b  status(a0),status(a1)
                move.b  subtype(a0),subtype(a1)
                move.w  a0,$2E(a1)

loc_461FE:
                tst.b   routine(a0)
                beq.s   loc_46216
                move.w  $12(a0),d0
                beq.s   loc_46210
                movea.w d0,a1
                st      routine(a1)

loc_46210:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_46216:
                movea.w parent2(a0),a1
                move.w  #$180,d1
                move.w  $20(a1),d0
                subi.w  #$40,d0
                andi.w  #$FF,d0
                cmpi.w  #$80,d0
                blo.s   loc_46234
                move.w  #$100,d1

loc_46234:
                move.w  d1,priority(a0)
                move.w  $20(a1),d0
                jsr     (GetSineCosine).l
                swap    d1
                clr.w   d1
                asr.l   #4,d1
                swap    d0
                clr.w   d0
                asr.l   #4,d0
                move.l  x_pos(a0),d3
                move.l  y_pos(a0),d2
                clr.w   d2
                move.w  mainspr_childsprites(a0),d4
                subq.w  #1,d4
                lea     sub2_x_pos(a0),a1

loc_46262:
                add.l   d1,d3
                add.l   d0,d2
                swap    d3
                swap    d2
                move.w  d3,(a1)+
                move.w  d2,(a1)+
                move.b  #2,1(a1)
                swap    d3
                swap    d2
                addq.w  #2,a1
                dbf     d4,loc_46262
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_46284:
                move.l  #loc_462B6,(a0)
                move.b  #4,render_flags(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #$18,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$74,3,0),art_tile(a0)
                move.l  #Map_SSZElevatorBar,mappings(a0)
                move.b  #3,mapping_frame(a0)

loc_462B6:
                tst.b   routine(a0)
                beq.s   loc_462C2
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_462C2:
                movea.w $2E(a0),a1
                move.w  mainspr_childsprites(a1),d0
                subq.w  #1,d0
                add.w   d0,d0
                move.w  d0,d1
                add.w   d0,d0
                add.w   d1,d0
                move.w  sub2_x_pos(a1,d0.w),x_pos(a0)
                move.w  sub2_y_pos(a1,d0.w),d0
                addi.w  #$C,d0
                move.w  d0,y_pos(a0)
                moveq   #$23,d1
                moveq   #8,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                swap    d6
                move.w  d6,-(sp)
                lea     (Player_1).w,a1
                lea     (Ctrl_1_logical).w,a2
                lea     $30(a0),a3
                moveq   #p1_standing_bit,d5
                bsr.s   sub_46324
                move.w  (sp)+,d6
                lsr.w   #1,d6
                lea     (Player_2).w,a1
                lea     (Ctrl_2_logical).w,a2
                lea     $32(a0),a3
                moveq   #p2_standing_bit,d5
                bsr.s   sub_46324
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_46324:
                tst.b   (a3)
                bne.s   loc_4639A
                tst.b   object_control(a1)
                bne.s   locret_46348
                cmpi.b  #4,routine(a1)
                bhs.s   locret_46348
                btst    d5,status(a0)
                bne.s   loc_4634A
                andi.w  #5,d6
                beq.s   locret_46348
                jsr     (sub_24280).l

locret_46348:
                rts
; ---------------------------------------------------------------------------

loc_4634A:
                moveq   #signextendB(sfx_Roll),d0
                jsr     (Play_SFX).l
                st      (a3)
                move.b  #1,object_control(a1)
                clr.w   y_vel(a1)
                clr.w   x_vel(a1)
                clr.w   ground_vel(a1)
                clr.b   spin_dash_flag(a1)
                bset    #Status_Roll,status(a1)
                move.b  #2,anim(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                tst.b   subtype(a0)
                bpl.s   loc_4639A
                move.b  status(a0),d0
                andi.w  #1,d0
                andi.b  #$FE,status(a1)
                or.b    d0,status(a1)

loc_4639A:
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),d0
                subi.w  #$C,d0
                move.w  d0,y_pos(a1)
                tst.b   subtype(a0)
                bpl.s   loc_463FC
                movem.l d5/a1-a3,-(sp)
                jsr     (SonicOnObjHitFloor).l
                movem.l (sp)+,d5/a1-a3
                tst.w   d1
                bpl.s   loc_463FC
                add.w   d1,y_pos(a1)
                cmpi.w  #-$10,d1
                bgt.s   loc_463FC
                clr.b   (a3)
                bclr    d5,status(a0)
                clr.b   object_control(a1)
                bclr    #Status_OnObj,status(a1)
                move.w  #$800,d0
                btst    #0,status(a0)
                beq.s   loc_463EC
                neg.w   d0

loc_463EC:
                move.w  d0,x_vel(a1)
                move.w  d0,ground_vel(a1)
                moveq   #signextendB(sfx_Dash),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------

loc_463FC:
                move.w  (a2),d0
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d0
                beq.s   locret_46424
                clr.b   (a3)
                move.w  #-$680,y_vel(a1)
                clr.b   object_control(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,jumping(a1)
                moveq   #signextendB(sfx_Jump),d0
                jsr     (Play_SFX).l

locret_46424:
                rts
; End of function sub_46324
