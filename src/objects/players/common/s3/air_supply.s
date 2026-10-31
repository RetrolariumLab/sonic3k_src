; Owner: objects/players/common/s3
; Responsibility: Player underwater air countdown, warning numbers, small bubbles and air timer restoration
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
; Small bubbles from Sonic's face while underwater
; ---------------------------------------------------------------------------
Obj_AirCountdown:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  AirCountdown_Index(pc,d0.w),d1
                jmp     AirCountdown_Index(pc,d1.w)
; ---------------------------------------------------------------------------
AirCountdown_Index:
                dc.w    AirCountdown_Init-AirCountdown_Index
                dc.w    AirCountdown_Animate-AirCountdown_Index
                dc.w    AirCountdown_ChkWater-AirCountdown_Index
                dc.w    AirCountdown_Display-AirCountdown_Index
                dc.w    AirCountdown_Delete-AirCountdown_Index
                dc.w    AirCountdown_Countdown-AirCountdown_Index
                dc.w    AirCountdown_AirLeft-AirCountdown_Index
                dc.w    AirCountdown_DisplayNumber-AirCountdown_Index
                dc.w    AirCountdown_Delete-AirCountdown_Index
; ---------------------------------------------------------------------------

AirCountdown_Init:
                addq.b  #2,routine(a0)
                move.l  #Map_Bubbler,mappings(a0)
                tst.b   parent+1(a0)
                beq.s   loc_16F36
                move.l  #Map_Bubbler2,mappings(a0)

loc_16F36:
                move.w  #make_art_tile(ArtTile_Bubbles,0,0),art_tile(a0)
                move.b  #$84,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  subtype(a0),d0
                bpl.s   loc_16F64
                addq.b  #8,routine(a0)
                andi.w  #$7F,d0
                move.b  d0,$37(a0)
                bra.w   AirCountdown_Countdown
; ---------------------------------------------------------------------------

loc_16F64:
                move.b  d0,anim(a0)
                move.w  x_pos(a0),$34(a0)
                move.w  #-$100,y_vel(a0)

AirCountdown_Animate:
                lea     (Ani_AirCountdown).l,a1
                jsr     (Animate_Sprite).l

AirCountdown_ChkWater:
                move.w  (Water_level).w,d0
                cmp.w   y_pos(a0),d0                    ; has bubble reached the water surface?
                blo.s   AirCountdown_Wobble             ; if not, branch
; pop the bubble:
                move.b  #6,routine(a0)
                addq.b  #7,anim(a0)
                cmpi.b  #$D,anim(a0)
                beq.s   AirCountdown_Display
                bcs.s   AirCountdown_Display
                move.b  #$D,anim(a0)
                bra.s   AirCountdown_Display
; ---------------------------------------------------------------------------

AirCountdown_Wobble:
                tst.w   (WindTunnel_flag).w
                beq.s   loc_16FB0
                addq.w  #4,$34(a0)

loc_16FB0:
                move.b  angle(a0),d0
                addq.b  #1,angle(a0)
                andi.w  #$7F,d0
                lea     (AirCountdown_WobbleData).l,a1
                move.b  (a1,d0.w),d0
                ext.w   d0
                add.w   $34(a0),d0
                move.w  d0,x_pos(a0)
                bsr.w   AirCountdown_ShowNumber
                jsr     (MoveSprite2).l
                tst.b   render_flags(a0)
                bpl.s   loc_16FE6
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_16FE6:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
; AirCountdown_Display and AirCountdown_DisplayNumber were split in this
; game, unlike Sonic 2, to fix a bug where the countdown numbers corrupted
; if they reached the surface of the water
; (The start of ARZ Act 1 is a good place to see this)

AirCountdown_Display:
                bsr.s   AirCountdown_ShowNumber
                lea     (Ani_AirCountdown).l,a1
                jsr     (Animate_Sprite).l
                bsr.w   AirCountdown_Load_Art
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

AirCountdown_Delete:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

AirCountdown_AirLeft:
                movea.l $40(a0),a2                      ; a2=character
                cmpi.b  #12,air_left(a2)                ; check air remaining
                bhi.s   loc_17044                       ; if higher than 12, branch
                subq.w  #1,$3C(a0)
                bne.s   AirCountdown_Display2
                move.b  #$E,routine(a0)
                addq.b  #7,anim(a0)
                bra.s   AirCountdown_Display
; ---------------------------------------------------------------------------

AirCountdown_Display2:
                lea     (Ani_AirCountdown).l,a1
                jsr     (Animate_Sprite).l
                bsr.w   AirCountdown_Load_Art
                tst.b   render_flags(a0)
                bpl.s   loc_17044
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_17044:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

AirCountdown_DisplayNumber:
                movea.l $40(a0),a2                      ; a2=character
                cmpi.b  #12,air_left(a2)
                bhi.s   AirCountdown_Delete
                bsr.s   AirCountdown_ShowNumber
                lea     (Ani_AirCountdown).l,a1
                jsr     (Animate_Sprite).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

AirCountdown_ShowNumber:
                tst.w   $3C(a0)
                beq.s   locret_170B4
                subq.w  #1,$3C(a0)
                bne.s   locret_170B4
                cmpi.b  #7,anim(a0)
                bhs.s   locret_170B4
                move.w  #$F,$3C(a0)
                clr.w   y_vel(a0)
                move.b  #$80,render_flags(a0)
                move.w  x_pos(a0),d0
                sub.w   (Camera_X_pos).w,d0
                addi.w  #$80,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a0),d0
                sub.w   (Camera_Y_pos).w,d0
                addi.w  #$80,d0
                move.w  d0,y_pos(a0)
                move.b  #$C,routine(a0)

locret_170B4:
                rts
; End of function AirCountdown_ShowNumber

; ---------------------------------------------------------------------------
AirCountdown_WobbleData:
                dc.b    0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2
                dc.b    2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
                dc.b    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2
                dc.b    2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0
                dc.b    0,-1,-1,-1,-1,-1,-2,-2,-2,-2,-2,-3,-3,-3,-3,-3
                dc.b    -3,-3,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4
                dc.b    -4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-3
                dc.b    -3,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1

; Amazing, this S1 leftover is *still* here
; This was used by LZ's water ripple effect in REV01
                dc.b    0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2
                dc.b    2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
                dc.b    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2
                dc.b    2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0
                dc.b    0,-1,-1,-1,-1,-1,-2,-2,-2,-2,-2,-3,-3,-3,-3,-3
                dc.b    -3,-3,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4
                dc.b    -4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-3
                dc.b    -3,-3,-3,-3,-3,-3,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1

; =============== S U B R O U T I N E =======================================

AirCountdown_Load_Art:
                moveq   #0,d1
                move.b  mapping_frame(a0),d1
                cmpi.b  #9,d1
                blo.s   locret_171FC
                cmpi.b  #$13,d1
                bhs.s   locret_171FC
                cmp.b   $32(a0),d1
                beq.s   locret_171FC
                move.b  d1,$32(a0)
                subi.w  #9,d1
                move.w  d1,d0
                add.w   d1,d1
                add.w   d0,d1
                lsl.w   #6,d1
                addi.l  #ArtUnc_AirCountdown,d1
                move.w  #tiles_to_bytes(ArtTile_DashDust),d2
                tst.b   parent+1(a0)
                beq.s   loc_171F2
                move.w  #tiles_to_bytes(ArtTile_DashDust_P2),d2

loc_171F2:
                move.w  #$60,d3
                jsr     (Add_To_DMA_Queue).l

locret_171FC:
                rts
; End of function AirCountdown_Load_Art

; ---------------------------------------------------------------------------

AirCountdown_Countdown:
                movea.l $40(a0),a2                      ; a2=character
                tst.w   $30(a0)
                bne.w   loc_1730C
                cmpi.b  #6,routine(a2)
                bhs.w   locret_17410
                btst    #Status_BublShield,status_secondary(a2)
                bne.w   locret_17410
                btst    #Status_Underwater,status(a2)
                beq.w   locret_17410
                subq.w  #1,$3C(a0)
                bpl.w   loc_17324
                move.w  #60-1,$3C(a0)
                move.w  #1,$3A(a0)
                jsr     (Random_Number).l
                andi.w  #1,d0
                move.b  d0,$38(a0)
                moveq   #0,d0
                move.b  air_left(a2),d0                 ; check air remaining
                cmpi.w  #25,d0
                beq.s   AirCountdown_WarnSound          ; play ding sound if air is 25
                cmpi.w  #20,d0
                beq.s   AirCountdown_WarnSound          ; play ding sound if air is 20
                cmpi.w  #15,d0
                beq.s   AirCountdown_WarnSound          ; play ding sound if air is 15
                cmpi.w  #12,d0
                bhi.s   AirCountdown_ReduceAir
                bne.s   loc_17278
                tst.b   parent+1(a0)
                bne.s   loc_17278
                moveq   #signextendB(mus_Drowning),d0
                jsr     (Play_Music).l

loc_17278:
                subq.b  #1,$36(a0)
                bpl.s   AirCountdown_ReduceAir
                move.b  $37(a0),$36(a0)
                bset    #7,$3A(a0)
                bra.s   AirCountdown_ReduceAir
; ---------------------------------------------------------------------------

AirCountdown_WarnSound:
                tst.b   parent+1(a0)
                bne.s   AirCountdown_ReduceAir
                moveq   #signextendB(sfx_AirDing),d0
                jsr     (Play_SFX).l

AirCountdown_ReduceAir:
                subq.b  #1,air_left(a2)
                bcc.w   loc_17322
                move.b  #$81,object_control(a2)
                move.w  #sfx_Drown,d0
                jsr     (Play_SFX).l
                move.b  #$A,$38(a0)
                move.w  #1,$3A(a0)
                move.w  #$78,$30(a0)
                movea.l a2,a1
                bsr.w   Player_ResetAirTimer
                move.l  a0,-(sp)
                movea.l a2,a0
                bsr.w   Player_TouchFloor
                move.b  #$17,anim(a0)
                bset    #Status_InAir,status(a0)
                bset    #7,art_tile(a0)
                move.w  #0,y_vel(a0)
                move.w  #0,x_vel(a0)
                move.w  #0,ground_vel(a0)
                move.b  #$C,routine(a0)
                movea.l (sp)+,a0
                cmpa.w  #Player_1,a2
                bne.s   locret_1730A
                move.b  #1,(Deform_lock).w

locret_1730A:
                rts
; ---------------------------------------------------------------------------

loc_1730C:
                move.b  #$17,anim(a2)
                subq.w  #1,$30(a0)
                bne.s   loc_17320
                move.b  #6,routine(a2)
                rts
; ---------------------------------------------------------------------------

loc_17320:
                bra.s   loc_17324
; ---------------------------------------------------------------------------

loc_17322:
                bra.s   AirCountdown_MakeItem
; ---------------------------------------------------------------------------

loc_17324:
                tst.w   $3A(a0)
                beq.w   locret_17410
                subq.w  #1,$3E(a0)
                bpl.w   locret_17410

AirCountdown_MakeItem:
                jsr     (Random_Number).l
                andi.w  #$F,d0
                addq.w  #8,d0
                move.w  d0,$3E(a0)
                jsr     (AllocateObject).l
                bne.w   locret_17410
                move.l  (a0),(a1)                       ; load Obj_Air_Countdown
                move.w  x_pos(a2),x_pos(a1)             ; match its X position to Sonic
                moveq   #6,d0
                btst    #Status_Facing,status(a2)
                beq.s   loc_17368
                neg.w   d0
                move.b  #$40,angle(a1)

loc_17368:
                add.w   d0,x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                move.l  $40(a0),$40(a1)
                move.b  #6,subtype(a1)
                tst.w   $30(a0)
                beq.w   loc_173BA
                andi.w  #7,$3E(a0)
                addi.w  #0,$3E(a0)
                move.w  y_pos(a2),d0
                subi.w  #$C,d0
                move.w  d0,y_pos(a1)
                jsr     (Random_Number).l
                move.b  d0,angle(a1)
                move.w  (Level_frame_counter).w,d0
                andi.b  #3,d0
                bne.s   loc_17406
                move.b  #$E,subtype(a1)
                bra.s   loc_17406
; ---------------------------------------------------------------------------
; has something to do with making bubbles come out less regularly
; when Sonic is almost drowning
loc_173BA:
                btst    #7,$3A(a0)
                beq.s   loc_17406
                moveq   #0,d2
                move.b  air_left(a2),d2
                cmpi.b  #12,d2
                bhs.s   loc_17406
                lsr.w   #1,d2
                jsr     (Random_Number).l
                andi.w  #3,d0
                bne.s   loc_173EE
                bset    #6,$3A(a0)
                bne.s   loc_17406
                move.b  d2,subtype(a1)
                move.w  #$1C,$3C(a1)

loc_173EE:
                tst.b   $38(a0)
                bne.s   loc_17406
                bset    #6,$3A(a0)
                bne.s   loc_17406
                move.b  d2,subtype(a1)
                move.w  #$1C,$3C(a1)

loc_17406:
                subq.b  #1,$38(a0)
                bpl.s   locret_17410
                clr.w   $3A(a0)

locret_17410:
                rts

; =============== S U B R O U T I N E =======================================

Player_ResetAirTimer:
                cmpi.b  #12,air_left(a1)
                bhi.s   loc_1744C                       ; branch if countdown hasn't started yet
                cmpa.w  #Player_1,a1
                bne.s   loc_1744C                       ; branch if it isn't player 1
                move.w  (Current_music).w,d0            ; prepare to play current level's music
                btst    #Status_Invincible,status_secondary(a1)
                beq.s   loc_17430                       ; branch if Sonic is not invincible
                move.w  #mus_Invincibility,d0           ; prepare to play invincibility music

loc_17430:
                tst.b   (Super_Sonic_Knux_flag).w
                beq.w   loc_1743C                       ; branch if it isn't Super
                move.w  #mus_Invincibility,d0           ; prepare to play Super Sonic music (same as invincibility in this game)

loc_1743C:
                tst.b   (Boss_flag).w
                beq.s   loc_17446                       ; branch if not in a boss fight
                move.w  #mus_MinibossK,d0               ; prepare to play boss music

loc_17446:
                jsr     (Play_Music).l

loc_1744C:
                move.b  #30,air_left(a1)                ; reset air to full
                rts
; End of function Player_ResetAirTimer

; ---------------------------------------------------------------------------
Ani_AirCountdown:
                include "src/objects/shared/bubbles/animations/air_countdown.s"
