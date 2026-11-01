; Owner: objects/enemies/hcz/sk
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
                bne.s   loc_87F76
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_87F76:
                jsr     EnemyDefeated(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
MegaChopper_Index:
                dc.w    loc_87F88-MegaChopper_Index
                dc.w    loc_87FAC-MegaChopper_Index
                dc.w    loc_88024-MegaChopper_Index
                dc.w    loc_88062-MegaChopper_Index
; ---------------------------------------------------------------------------

loc_87F88:
                lea     ObjDat_MegaChopper(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AniRaw_MegaChopper,$30(a0)
                clr.w   child_dx(a0)                    ; and child_dy
                bclr    #1,render_flags(a0)
                beq.s   locret_87FAA
                bset    #7,art_tile(a0)

locret_87FAA:
                rts
; ---------------------------------------------------------------------------

loc_87FAC:
                bsr.w   loc_8813A
                jsr     Animate_Raw(pc)
                jsr     Find_SonicTails(pc)
                move.b  (V_int_run_count+3).w,d4
                andi.b  #7,d4
                bne.s   loc_87FCE
                moveq   #1,d4
                tst.w   d1
                bne.s   loc_87FCA
                neg.w   d4

loc_87FCA:
                add.w   d4,y_pos(a0)

loc_87FCE:
                move.w  y_pos(a0),d4
                move.w  (Water_level).w,d5
                addq.w  #8,d5
                cmp.w   d5,d4
                bhi.s   loc_87FE4
                btst    #Status_Underwater,status(a1)
                beq.s   loc_87FFC

loc_87FE4:
                move.w  #$200,d0
                move.w  #8,d1
                jsr     (Chase_ObjectXOnly).l
                jsr     Change_FlipXWithVelocity(pc)
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_87FFC:
                move.b  #4,routine(a0)
                move.w  #$200,d4
                bset    #0,render_flags(a0)
                tst.w   d0
                bne.s   loc_88018
                neg.w   d4
                bclr    #0,render_flags(a0)

loc_88018:
                move.w  d4,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_88024:
                bsr.w   loc_8813A
                jsr     Animate_Raw(pc)
                tst.w   y_vel(a0)
                bmi.s   loc_88052
                move.w  y_pos(a0),d0
                cmp.w   (Water_level).w,d0
                blo.s   loc_88052
                move.w  y_vel(a0),d0
                addi.w  #-$20,d0
                move.w  d0,y_vel(a0)
                beq.s   loc_88056
                bmi.s   loc_88056
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

loc_88052:
                jmp     MoveSprite_LightGravity(pc)
; ---------------------------------------------------------------------------

loc_88056:
                move.b  #2,routine(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_88062:
                move.b  #0,mapping_frame(a0)
                btst    #2,(V_int_run_count+3).w
                beq.s   loc_88076
                move.b  #2,mapping_frame(a0)

loc_88076:
                movea.w $44(a0),a1
                cmpi.b  #4,routine(a1)
                beq.w   loc_88108
                cmpi.b  #2,anim(a1)
                beq.s   loc_88108
                cmpi.b  #9,anim(a1)
                beq.s   loc_88108
                jsr     Check_LRControllerShake(pc)
                bne.s   loc_88108
                btst    #2,$38(a0)
                beq.s   loc_880AE
                move.w  (Ctrl_1).w,d0
                andi.w  #($8C<<8)|$8C,d0
                move.w  d0,(Ctrl_1_logical).w

loc_880AE:
                move.w  x_pos(a1),d0
                move.b  child_dx(a0),d1
                ext.w   d1
                move.b  $38(a0),d2
                andi.b  #1,d2
                move.b  render_flags(a1),d3
                andi.b  #1,d3
                eor.b   d2,d3
                beq.s   loc_880DC
                bchg    #0,render_flags(a0)
                bchg    #0,$38(a0)
                neg.b   child_dx(a0)

loc_880DC:
                add.w   d1,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),d0
                move.b  child_dy(a0),d1
                ext.w   d1
                bpl.s   loc_880FA
                cmpi.b  #8,anim(a1)
                bne.s   loc_880FA
                addi.w  #$10,d1

loc_880FA:
                add.w   d1,d0
                move.w  d0,y_pos(a0)
                bsr.w   DrainGlobalRingFromAttachedMegaChopper
                beq.w   locret_87FAA

loc_88108:
                bclr    #2,$38(a0)
                beq.s   loc_88114
                clr.b   (Ctrl_1_locked).w

loc_88114:
                move.l  #MoveChkDel,(a0)
                move.b  #2,mapping_frame(a0)
                move.w  #$200,d0
                btst    #0,render_flags(a0)
                beq.s   loc_8812E
                neg.w   d0

loc_8812E:
                move.w  d0,x_vel(a0)
                move.w  #-$200,y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_8813A:
                move.b  collision_property(a0),d0
                beq.w   locret_87FAA
                clr.b   collision_property(a0)
                andi.w  #3,d0
                move.w  d0,d2
                lsl.w   #2,d0
                lea     word_881EA-4(pc),a2
                lea     (a2,d0.w),a2
                movea.w (a2)+,a1
                move.w  a1,$44(a0)
                move.w  y_pos(a0),d1
                sub.w   y_pos(a1),d1
                cmpi.w  #-$10,d1
                blt.w   locret_87FAA
                cmpi.w  #$10,d1
                bge.w   locret_87FAA
                jsr     Check_PlayerAttack(pc)
                bne.w   loc_881F6
                cmpi.w  #1,d2
                bne.s   loc_88190
                clr.w   (Ctrl_1_logical).w
                st      (Ctrl_1_locked).w
                bset    #2,$38(a0)

loc_88190:
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
                bpl.s   loc_881C8
                bset    #0,render_flags(a0)

loc_881C8:
                move.w  y_pos(a0),d0
                sub.w   y_pos(a1),d0
                move.b  d0,child_dy(a0)
                bclr    #0,$38(a0)
                btst    #0,render_flags(a1)
                beq.s   locret_881E8
                bset    #0,$38(a0)

locret_881E8:
                rts
; ---------------------------------------------------------------------------
word_881EA:
                dc.w    Player_1, Ctrl_1
                dc.w    Player_2, Ctrl_2
                dc.w    Player_1, Ctrl_1
; ---------------------------------------------------------------------------

loc_881F6:
                bset    #7,status(a0)
                rts

; =============== S U B R O U T I N E =======================================

DrainGlobalRingFromAttachedMegaChopper:
                subq.w  #1,$2E(a0)
                bpl.s   loc_88246
                move.w  #60-1,$2E(a0)
                ori.b   #1,(Update_HUD_ring_count).w
                bset    #7,$38(a0)
                move.w  (Ring_count).w,d0
                subq.w  #1,d0
                bmi.s   loc_88258
                beq.s   loc_88230
                cmpi.w  #10,(Ring_count).w
                beq.s   loc_88230
                cmpi.w  #100,(Ring_count).w
                bne.s   loc_88236

loc_88230:
                ori.b   #$80,(Update_HUD_ring_count).w

loc_88236:
                move.w  d0,(Ring_count).w
                moveq   #signextendB(sfx_RingRight),d0
                jsr     (Play_SFX).l

loc_88242:
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

loc_88246:
                bclr    #7,$38(a0)
                beq.s   loc_88242
                andi.b  #$FE,(Update_HUD_ring_count).w
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

loc_88258:
                movea.l a0,a2
                movea.w $44(a0),a1
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l a2,a0
                moveq   #1,d0
                rts
; End of function DrainGlobalRingFromAttachedMegaChopper

; ---------------------------------------------------------------------------
ObjDat_MegaChopper:
                dc.l    Map_MegaChopper
                dc.w    make_art_tile(ArtTile_MegaChopper,1,0)
                dc.w    $280
                dc.b    $20, $20,   0, $D7
AniRaw_MegaChopper:
                dc.b    2,   0,   1, $FC
                even
