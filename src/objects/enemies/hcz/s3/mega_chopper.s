; Owner: objects/enemies/hcz/s3
; Responsibility: Mega Chopper swimming, player attachment, damage and private animation
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MegaChopper:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  MegaChopper_Index(pc,d0.w),d1
                jsr     MegaChopper_Index(pc,d1.w)
                btst    #7,status(a0)
                bne.w   EnemyDefeat_Score
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
MegaChopper_Index:
                dc.w    loc_55D66-MegaChopper_Index
                dc.w    loc_55D8A-MegaChopper_Index
                dc.w    loc_55E02-MegaChopper_Index
                dc.w    loc_55E40-MegaChopper_Index
; ---------------------------------------------------------------------------

loc_55D66:
                lea     ObjDat_MegaChopper(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AniRaw_MegaChopper,$30(a0)
                clr.w   child_dx(a0)                    ; and child_dy
                bclr    #1,render_flags(a0)
                beq.s   locret_55D88
                bset    #7,art_tile(a0)

locret_55D88:
                rts
; ---------------------------------------------------------------------------

loc_55D8A:
                bsr.w   sub_55F18
                jsr     Animate_Raw(pc)
                jsr     Find_SonicTails(pc)
                move.b  (V_int_run_count+3).w,d4
                andi.b  #7,d4
                bne.s   loc_55DAC
                moveq   #1,d4
                tst.w   d1
                bne.s   loc_55DA8
                neg.w   d4

loc_55DA8:
                add.w   d4,y_pos(a0)

loc_55DAC:
                move.w  y_pos(a0),d4
                move.w  (Water_level).w,d5
                addq.w  #8,d5
                cmp.w   d5,d4
                bhi.s   loc_55DC2
                btst    #Status_Underwater,status(a1)
                beq.s   loc_55DDA

loc_55DC2:
                move.w  #$200,d0
                move.w  #8,d1
                jsr     (Chase_ObjectXOnly).l
                jsr     Change_FlipXWithVelocity(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_55DDA:
                move.b  #4,routine(a0)
                move.w  #$200,d4
                bset    #0,render_flags(a0)
                tst.w   d0
                bne.s   loc_55DF6
                neg.w   d4
                bclr    #0,render_flags(a0)

loc_55DF6:
                move.w  d4,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_55E02:
                bsr.w   sub_55F18
                jsr     Animate_Raw(pc)
                tst.w   y_vel(a0)
                bmi.s   loc_55E30
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.s   loc_55E30
                move.w  y_vel(a0),d0
                addi.w  #-$20,d0
                move.w  d0,y_vel(a0)
                beq.s   loc_55E34
                bmi.s   loc_55E34
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_55E30:
                jmp     MoveSprite_LightGravity(pc)
; ---------------------------------------------------------------------------

loc_55E34:
                move.b  #2,routine(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_55E40:
                move.b  #0,mapping_frame(a0)
                btst    #2,(V_int_run_count+3).w
                beq.s   loc_55E54
                move.b  #2,mapping_frame(a0)

loc_55E54:
                movea.w $44(a0),a1
                cmpi.b  #4,routine(a1)
                beq.w   loc_55EE6
                cmpi.b  #2,anim(a1)
                beq.s   loc_55EE6
                cmpi.b  #9,anim(a1)
                beq.s   loc_55EE6
                jsr     Check_LRControllerShake(pc)
                bne.s   loc_55EE6
                btst    #2,$38(a0)
                beq.s   loc_55E8C
                move.w  (Ctrl_1).w,d0
                andi.w  #($8C<<8)|$8C,d0
                move.w  d0,(Ctrl_1_logical).w

loc_55E8C:
                move.w  x_pos(a1),d0
                move.b  child_dx(a0),d1
                ext.w   d1
                move.b  $38(a0),d2
                andi.b  #1,d2
                move.b  render_flags(a1),d3
                andi.b  #1,d3
                eor.b   d2,d3
                beq.s   loc_55EBA
                bchg    #0,render_flags(a0)
                bchg    #0,$38(a0)
                neg.b   child_dx(a0)

loc_55EBA:
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),d0
                move.b  child_dy(a0),d1
                ext.w   d1
                bpl.s   loc_55ED8
                cmpi.b  #8,anim(a1)
                bne.s   loc_55ED8
                addi.w  #$10,d1

loc_55ED8:
                add.w   d1,d0
                move.w  d0,y_pos(a0)
                bsr.w   sub_55FEA
                beq.w   locret_55D88

loc_55EE6:
                bclr    #2,$38(a0)
                beq.s   loc_55EF2
                clr.b   (Ctrl_1_locked).w

loc_55EF2:
                move.l  #MoveChkDel,(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #$200,d0
                btst    #0,render_flags(a0)
                beq.s   loc_55F0C
                neg.w   d0

loc_55F0C:
                move.w  d0,x_vel(a0)
                move.w  #-$200,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

sub_55F18:
                move.b  collision_property(a0),d0
                beq.w   locret_55D88
                clr.b   collision_property(a0)
                andi.w  #3,d0
                move.w  d0,d2
                lsl.w   #2,d0
                lea     word_55FD6-4(pc),a2
                lea     (a2,d0.w),a2
                movea.w (a2)+,a1
                move.w  a1,$44(a0)
                btst    #Status_Invincible,status_secondary(a1)
                bne.w   loc_55FE2
                move.w  y_pos(a0),d1
                sub.w   y_pos(a1),d1
                cmpi.w  #-$10,d1
                blt.w   locret_55D88
                cmpi.w  #$10,d1
                bge.w   locret_55D88
                move.w  a1,$44(a0)
                cmpi.b  #2,anim(a1)
                beq.s   loc_55FE2
                cmpi.w  #1,d2
                bne.s   loc_55F7C
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                bset    #2,$38(a0)

loc_55F7C:
                movea.w (a2)+,a3
                move.w  a3,$3E(a0)
                move.w  (a3),parent3(a0)
                move.b  #6,routine(a0)
                move.w  #0,priority(a0)
                move.w  #60,$2E(a0)
                move.w  x_pos(a0),d0
                sub.w   x_pos(a1),d0
                move.b  d0,child_dx(a0)
                bclr    #0,render_flags(a0)
                tst.w   d0
                bpl.s   loc_55FB4
                bset    #0,render_flags(a0)

loc_55FB4:
                move.w  y_pos(a0),d0
                sub.w   y_pos(a1),d0
                move.b  d0,child_dy(a0)
                bclr    #0,$38(a0)
                btst    #0,render_flags(a1)
                beq.s   locret_55FD4
                bset    #0,$38(a0)

locret_55FD4:
                rts
; ---------------------------------------------------------------------------
word_55FD6:
                dc.w    Player_1, Ctrl_1
                dc.w    Player_2, Ctrl_2
                dc.w    Player_1, Ctrl_1
; ---------------------------------------------------------------------------

loc_55FE2:
                bset    #7,status(a0)
                rts

; =============== S U B R O U T I N E =======================================

sub_55FEA:
                subq.w  #1,$2E(a0)
                bpl.s   loc_56032
                move.w  #60-1,$2E(a0)
                ori.b   #1,(Update_HUD_ring_count).w
                bset    #7,$38(a0)
                move.w  (Ring_count).w,d0
                subq.w  #1,d0
                bmi.s   loc_56044
                beq.s   loc_5601C
                cmpi.w  #10,(Ring_count).w
                beq.s   loc_5601C
                cmpi.w  #100,(Ring_count).w
                bne.s   loc_56022

loc_5601C:
                ori.b   #$80,(Update_HUD_ring_count).w

loc_56022:
                move.w  d0,(Ring_count).w
                moveq   #signextendB(sfx_RingRight),d0
                jsr     (Play_SFX).l

loc_5602E:
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

loc_56032:
                bclr    #7,$38(a0)
                beq.s   loc_5602E
                andi.b  #$FE,(Update_HUD_ring_count).w
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

loc_56044:
                movea.l a0,a2
                movea.w $44(a0),a1
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l a2,a0
                moveq   #1,d0
                rts
; End of function sub_55FEA

; ---------------------------------------------------------------------------
ObjDat_MegaChopper:
                dc.l    Map_MegaChopper
                dc.w    make_art_tile(ArtTile_MegaChopper,1,0)
                dc.w    $280
                dc.b    $20, $20,   0, $D7
AniRaw_MegaChopper:
                dc.b    2,   0,   1, $FC
                even
