; Owner: objects/zones/lbz/s3
; Responsibility: Launch Base moving platform states, intangible falling platforms and shared mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
byte_23D2A:
                dc.b    $20,   8,   0
                even
                dc.b    $20,   8,   1
                even
; ---------------------------------------------------------------------------

Obj_LBZMovingPlatform:
                move.l  #Map_LBZMovingPlatform,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZMisc,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$180,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                bpl.s   loc_23D64
                andi.w  #$7F,d0
                lsl.w   #4,d0
                move.w  d0,$38(a0)
                moveq   #$17,d0
                move.b  d0,subtype(a0)

loc_23D64:
                lsr.w   #2,d0
                andi.w  #$1C,d0
                lea     byte_23D2A(pc,d0.w),a2
                move.b  (a2)+,width_pixels(a0)
                move.b  (a2)+,height_pixels(a0)
                move.b  (a2)+,mapping_frame(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  x_pos(a0),$32(a0)
                move.w  y_pos(a0),$34(a0)
                move.b  status(a0),$2E(a0)
                move.w  #$280,$42(a0)
                move.w  x_pos(a0),$44(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                subq.w  #8,d0
                bcs.s   loc_23DD4
                cmpi.w  #4,d0
                bhs.s   loc_23DC8
                lsl.w   #2,d0
                lea     (Oscillating_table+$2C).w,a2
                lea     (a2,d0.w),a2
                tst.w   (a2)
                bpl.s   loc_23DD4
                bchg    #0,$2E(a0)
                bra.s   loc_23DD4
; ---------------------------------------------------------------------------

loc_23DC8:
                move.w  #$380,$42(a0)
                addi.w  #$100,$44(a0)

loc_23DD4:
                move.b  subtype(a0),d0
                andi.b  #$F,d0
                add.b   d0,d0
                move.b  d0,subtype(a0)
                move.l  #loc_23DE8,(a0)

loc_23DE8:
                move.w  x_pos(a0),-(sp)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  LBZMovingPlatformIndex(pc,d0.w),d1
                jsr     LBZMovingPlatformIndex(pc,d1.w)
                move.w  (sp)+,d4
                tst.b   render_flags(a0)
                bpl.s   loc_23E12
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  #9,d3
                jsr     (SolidObjectTop).l

loc_23E12:
                move.w  $44(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmp.w   $42(a0),d0
                bhi.w   loc_23E2C
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_23E2C:
                tst.b   $3D(a0)
                beq.s   loc_23E3C
                movea.w $3E(a0),a1
                jsr     (Delete_Referenced_Sprite).l

loc_23E3C:
                move.w  respawn_addr(a0),d0
                beq.s   loc_23E48
                movea.w d0,a2
                bclr    #7,(a2)

loc_23E48:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
LBZMovingPlatformIndex:
                dc.w    Platform_Stationary-LBZMovingPlatformIndex
                dc.w    Platform_Horizontal64-LBZMovingPlatformIndex
                dc.w    Platform_Horizontal128-LBZMovingPlatformIndex
                dc.w    Platform_Vertical64-LBZMovingPlatformIndex
                dc.w    Platform_Vertical128-LBZMovingPlatformIndex
                dc.w    Platform_DiagonalUp-LBZMovingPlatformIndex
                dc.w    Platform_DiagonalDown-LBZMovingPlatformIndex
                dc.w    Platform_DiagonalLift-LBZMovingPlatformIndex
                dc.w    Platform_Square32-LBZMovingPlatformIndex
                dc.w    Platform_Square96-LBZMovingPlatformIndex
                dc.w    Platform_Square160-LBZMovingPlatformIndex
                dc.w    Platform_Square224-LBZMovingPlatformIndex
                dc.w    Platform_Horizontal256-LBZMovingPlatformIndex
                dc.w    Platform_FallingDelayed-LBZMovingPlatformIndex
                dc.w    Platform_Falling-LBZMovingPlatformIndex
FloatingPlatformIndex:
                dc.w    Platform_Stationary-FloatingPlatformIndex
                dc.w    Platform_Horizontal64-FloatingPlatformIndex
                dc.w    Platform_Horizontal128-FloatingPlatformIndex
                dc.w    Platform_Vertical64-FloatingPlatformIndex
                dc.w    Platform_Vertical128-FloatingPlatformIndex
                dc.w    Platform_DiagonalUp-FloatingPlatformIndex
                dc.w    Platform_DiagonalDown-FloatingPlatformIndex
                dc.w    Platform_Rising-FloatingPlatformIndex
                dc.w    Platform_Square32-FloatingPlatformIndex
                dc.w    Platform_Square96-FloatingPlatformIndex
                dc.w    Platform_Square160-FloatingPlatformIndex
                dc.w    Platform_Square224-FloatingPlatformIndex
                dc.w    Platform_Horizontal256-FloatingPlatformIndex
; ---------------------------------------------------------------------------

Platform_Stationary:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_23E9C
                tst.b   $3A(a0)
                beq.s   loc_23EA8
                subq.b  #4,$3A(a0)
                bra.s   loc_23EA8
; ---------------------------------------------------------------------------

loc_23E9C:
                cmpi.b  #$40,$3A(a0)
                beq.s   loc_23EA8
                addq.b  #4,$3A(a0)

loc_23EA8:
                move.b  $3A(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #6,d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

Platform_Horizontal64:
                move.w  #64,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$0A).w,d0
                bra.s   sub_23ED4
; ---------------------------------------------------------------------------

Platform_Horizontal128:
                move.w  #128,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0

; =============== S U B R O U T I N E =======================================

sub_23ED4:
                btst    #0,status(a0)
                beq.s   loc_23EE0
                neg.w   d0
                add.w   d1,d0

loc_23EE0:
                move.w  $30(a0),d1
                add.w   d0,d1
                move.w  d1,x_pos(a0)
                rts
; End of function sub_23ED4

; ---------------------------------------------------------------------------

Platform_Vertical64:
                move.w  #64,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$0A).w,d0
                bra.s   loc_23F02
; ---------------------------------------------------------------------------

Platform_Vertical128:
                move.w  #128,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0

loc_23F02:
                btst    #0,status(a0)
                beq.s   loc_23F0E
                neg.w   d0
                add.w   d1,d0

loc_23F0E:
                move.w  $34(a0),d1
                sub.w   d0,d1
                move.w  d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

Platform_DiagonalUp:
                move.w  #128,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                bsr.s   sub_23ED4
                move.w  #64,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                lsr.b   #1,d0
                bra.s   loc_23F02
; ---------------------------------------------------------------------------

Platform_DiagonalDown:
                move.w  #128,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                neg.w   d0
                add.w   d1,d0
                bsr.s   sub_23ED4
                move.w  #64,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$1E).w,d0
                lsr.b   #1,d0
                bra.s   loc_23F02
; ---------------------------------------------------------------------------

Platform_DiagonalLift:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_23F72
                move.w  $38(a0),d2
                move.w  $36(a0),d1
                beq.s   locret_23FA0
                subq.w  #4,d1
                bcc.s   loc_23F6C
                moveq   #0,d1

loc_23F6C:
                move.w  d1,$36(a0)
                bra.s   loc_23F86
; ---------------------------------------------------------------------------

loc_23F72:
                move.w  $38(a0),d2
                move.w  $36(a0),d1
                addq.w  #2,d1
                cmp.w   d2,d1
                blo.s   loc_23F82
                move.w  d2,d1

loc_23F82:
                move.w  d1,$36(a0)

loc_23F86:
                move.w  $32(a0),d0
                sub.w   d1,d0
                move.w  d0,x_pos(a0)
                move.w  d0,$30(a0)
                lsr.w   #1,d1
                move.w  $34(a0),d0
                sub.w   d1,d0
                move.w  d0,y_pos(a0)

locret_23FA0:
                rts
; ---------------------------------------------------------------------------

Platform_Horizontal256:
                move.w  #$7F,d2
                tst.b   $3C(a0)
                bne.s   loc_23FC8
                move.w  $40(a0),d1
                addq.w  #4,d1
                move.w  d1,$40(a0)
                add.w   d1,$36(a0)
                cmp.b   $36(a0),d2
                bhi.s   loc_23FE2
                move.b  #1,$3C(a0)
                bra.s   loc_23FE2
; ---------------------------------------------------------------------------

loc_23FC8:
                move.w  $40(a0),d1
                subq.w  #4,d1
                move.w  d1,$40(a0)
                add.w   d1,$36(a0)
                cmp.b   $36(a0),d2
                bls.s   loc_23FE2
                move.b  #0,$3C(a0)

loc_23FE2:
                moveq   #0,d0
                move.b  $36(a0),d0
                btst    #0,status(a0)
                beq.s   loc_23FF4
                neg.w   d0
                add.w   d2,d0

loc_23FF4:
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

Platform_FallingDelayed:
                tst.w   $3A(a0)
                bne.s   loc_24016
                move.b  status(a0),d0
                andi.b  #$18,d0
                beq.s   locret_24014
                move.w  #30,$3A(a0)

locret_24014:
                rts
; ---------------------------------------------------------------------------

loc_24016:
                subq.w  #1,$3A(a0)
                bne.s   locret_24014
                move.w  #32,$3A(a0)
                addq.b  #2,subtype(a0)
                rts
; ---------------------------------------------------------------------------

Platform_Falling:
                tst.w   $3A(a0)
                beq.s   loc_24056
                subq.w  #1,$3A(a0)
                bne.s   loc_24056
                bclr    #p1_standing_bit,status(a0)
                beq.s   loc_24042
                lea     (Player_1).w,a1
                bsr.s   sub_2408A

loc_24042:
                bclr    #p2_standing_bit,status(a0)
                beq.s   loc_24050
                lea     (Player_2).w,a1
                bsr.s   sub_2408A

loc_24050:
                move.l  #Obj_FallingPlatformIntangible,(a0)

loc_24056:
                move.l  y_pos(a0),d3
                move.w  y_vel(a0),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3
                move.l  d3,y_pos(a0)
                addi.w  #$38,y_vel(a0)
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$120,d0
                cmp.w   y_pos(a0),d0
                bhs.s   locret_24088
                move.w  #$7F00,x_pos(a0)
                move.w  #$7F00,$44(a0)

locret_24088:
                rts

; =============== S U B R O U T I N E =======================================

sub_2408A:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                move.w  y_vel(a0),y_vel(a1)
                rts
; End of function sub_2408A

; ---------------------------------------------------------------------------

Obj_FallingPlatformIntangible:
                move.l  y_pos(a0),d3
                move.w  y_vel(a0),d0
                ext.l   d0
                asl.l   #8,d0
                add.l   d0,d3
                move.l  d3,y_pos(a0)
                addi.w  #$38,y_vel(a0)
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$120,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_240D6
                move.w  #$7F00,x_pos(a0)
                move.w  #$7F00,$44(a0)

loc_240D6:
                bra.w   loc_23E12
; ---------------------------------------------------------------------------

Platform_Rising:
                tst.b   $3C(a0)
                bne.s   loc_240F8
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   locret_240F6
                move.b  #1,$3C(a0)
                move.b  #$C,y_radius(a0)

locret_240F6:
                rts
; ---------------------------------------------------------------------------

loc_240F8:
                jsr     (MoveSprite2).l
                moveq   #8,d1
                move.w  $34(a0),d0
                subi.w  #$80,d0
                cmp.w   y_pos(a0),d0
                bhs.s   loc_24114
                neg.w   d1
                add.w   d1,y_vel(a0)

loc_24114:
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   loc_2412C
                sub.w   d1,y_pos(a0)
                clr.b   $3C(a0)
                clr.w   y_vel(a0)
                rts
; ---------------------------------------------------------------------------

loc_2412C:
                btst    #p1_standing_bit,status(a0)
                beq.s   loc_2414C
                move.l  a0,-(sp)
                lea     (Player_1).w,a0
                jsr     (sub_10BA2).l
                tst.w   d1
                bpl.s   loc_2414A
                jsr     (Kill_Character).l

loc_2414A:
                movea.l (sp)+,a0

loc_2414C:
                btst    #p2_standing_bit,status(a0)
                beq.s   locret_2416C
                move.l  a0,-(sp)
                lea     (Player_2).w,a0
                jsr     (sub_10BA2).l
                tst.w   d1
                bpl.s   loc_2416A
                jsr     (Kill_Character).l

loc_2416A:
                movea.l (sp)+,a0

locret_2416C:
                rts
; ---------------------------------------------------------------------------

Platform_Square32:
                move.w  #32/2,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$2A).w,d0
                lsr.w   #1,d0
                move.w  (Oscillating_table+$2C).w,d3
                bra.s   loc_241AE
; ---------------------------------------------------------------------------

Platform_Square96:
                move.w  #96/2,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$2E).w,d0
                move.w  (Oscillating_table+$30).w,d3
                bra.s   loc_241AE
; ---------------------------------------------------------------------------

Platform_Square160:
                move.w  #160/2,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$32).w,d0
                move.w  (Oscillating_table+$34).w,d3
                bra.s   loc_241AE
; ---------------------------------------------------------------------------

Platform_Square224:
                move.w  #224/2,d1
                moveq   #0,d0
                move.b  (Oscillating_table+$36).w,d0
                move.w  (Oscillating_table+$38).w,d3

loc_241AE:
                tst.w   d3
                bne.s   loc_241BC
                addq.b  #1,$2E(a0)
                andi.b  #3,$2E(a0)

loc_241BC:
                move.b  $2E(a0),d2
                andi.b  #3,d2
                bne.s   loc_241DC
                sub.w   d1,d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                neg.w   d1
                add.w   $34(a0),d1
                move.w  d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_241DC:
                subq.b  #1,d2
                bne.s   loc_241FA
                subq.w  #1,d1
                sub.w   d1,d0
                neg.w   d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                addq.w  #1,d1
                add.w   $30(a0),d1
                move.w  d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_241FA:
                subq.b  #1,d2
                bne.s   loc_24218
                subq.w  #1,d1
                sub.w   d1,d0
                neg.w   d0
                add.w   $30(a0),d0
                move.w  d0,x_pos(a0)
                addq.w  #1,d1
                add.w   $34(a0),d1
                move.w  d1,y_pos(a0)
                rts
; ---------------------------------------------------------------------------

loc_24218:
                sub.w   d1,d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                neg.w   d1
                add.w   $30(a0),d1
                move.w  d1,x_pos(a0)
                rts
; ---------------------------------------------------------------------------
Map_LBZMovingPlatform:
                include "src/objects/shared/zones/lbz/mappings/moving_platform.s"
