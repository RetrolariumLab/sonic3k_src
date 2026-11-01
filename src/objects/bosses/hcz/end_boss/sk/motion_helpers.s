; Owner: objects/bosses/hcz/end_boss/sk
; Responsibility: Hydrocity end-boss child priority, motion, palette, collision, callback and debris helpers with their private indexed tables
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

SetHCZBossBombStackPriority:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_6B8FE(pc,d0.w),priority(a0)
                rts
; End of function SetHCZBossBombStackPriority

; ---------------------------------------------------------------------------
word_6B8FE:
                dc.w    $280
                dc.w    $200
                dc.w    $180
; ---------------------------------------------------------------------------

loc_6B904:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  word_6B912(pc,d0.w),$40(a0)
                rts
; ---------------------------------------------------------------------------
word_6B912:
                dc.w    $101
                dc.w    $100

; =============== S U B R O U T I N E =======================================

SynchronizeHCZBossVortexHeightVisual:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  $39(a1),d0
                cmp.b   $39(a0),d0
                beq.s   locret_6B946
                move.b  d0,$39(a0)
                move.b  byte_6B948+1(pc,d0.w),d1
                ext.w   d1
                move.w  (Water_level).w,d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                lsl.w   #2,d0
                move.l  off_6B954(pc,d0.w),$30(a0)
                clr.b   anim_frame_timer(a0)

locret_6B946:
                rts
; End of function SynchronizeHCZBossVortexHeightVisual

; ---------------------------------------------------------------------------
byte_6B948:
                dc.b    -8
                dc.b    -8
                dc.b    -$10
                dc.b    -$18
                dc.b    -$20
                dc.b    -$28
                dc.b    -$28
                dc.b    0
                dc.b    0
                dc.b    6
                dc.b    -$42
                dc.b    $19
                even
off_6B954:
                dc.l    byte_6BE19
                dc.l    byte_6BE1E
                dc.l    byte_6BE23
                dc.l    byte_6BE28
                dc.l    byte_6BE2D
                dc.l    byte_6BE2D

; =============== S U B R O U T I N E =======================================

ConfigureHCZBossGeyserLayerFromSubtype:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$2E(a0)
                move.w  word_6B98E(pc,d0.w),d1
                move.w  (Water_level).w,d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                add.w   d0,d0
                move.l  off_6B998(pc,d0.w),$30(a0)
                rts
; End of function ConfigureHCZBossGeyserLayerFromSubtype

; ---------------------------------------------------------------------------
word_6B98E:
                dc.w    -8
                dc.w    -$18
                dc.w    -$28
                dc.w    -$38
                dc.w    -$48
off_6B998:
                dc.l    byte_6BE3F
                dc.l    byte_6BE76
                dc.l    byte_6BEA5
                dc.l    byte_6BECC
                dc.l    byte_6BEEB

; =============== S U B R O U T I N E =======================================

PullBothPlayersTowardHCZBossVortex:
                move.w  x_pos(a0),d0
                move.w  (Water_level).w,d1
                addq.w  #8,d1
                move.l  #$20000,d2
                lea     (Player_1).w,a1
                bsr.w   PullDeepPlayerWithHCZVortexDisplacement
                lea     (Player_2).w,a1
; End of function PullBothPlayersTowardHCZBossVortex

; =============== S U B R O U T I N E =======================================

PullDeepPlayerWithHCZVortexDisplacement:
                tst.b   object_control(a1)
                bne.s   locret_6B9E0
                cmp.w   y_pos(a1),d1
                bhs.s   locret_6B9E0
                cmp.w   x_pos(a1),d0
                bhs.s   loc_6B9DC
                neg.l   d2

loc_6B9DC:
                add.l   d2,x_pos(a1)

locret_6B9E0:
                rts
; End of function PullDeepPlayerWithHCZVortexDisplacement

; =============== S U B R O U T I N E =======================================

CaptureBothPlayersInHCZBossVortex:
                movea.w parent3(a0),a1
                moveq   #0,d0
                move.b  $39(a1),d0
                lsl.w   #2,d0
                lea     word_6BAC2(pc),a1
                lea     (a1,d0.w),a1
                moveq   #$42,d4
                lea     (Player_1).w,a2
                bsr.w   CaptureAndLiftPlayerInHCZBossVortex
                moveq   #$43,d4
                lea     (Player_2).w,a2
; End of function CaptureBothPlayersInHCZBossVortex

; =============== S U B R O U T I N E =======================================

CaptureAndLiftPlayerInHCZBossVortex:
                movea.w parent3(a0),a3
                btst    #7,status(a3)
                bne.w   ReleasePlayerFromHCZBossVortex
                cmpi.b  #6,routine(a2)
                bhs.w   loc_6BAB2
                tst.b   invulnerability_timer(a2)
                bne.w   loc_6BAB2
                tst.b   object_control(a2)
                beq.s   loc_6BA32
                tst.b   (a0,d4.w)
                bne.s   loc_6BA6C

loc_6BA32:
                move.w  y_pos(a0),d0
                move.w  y_pos(a2),d2
                add.w   (a1),d0
                cmp.w   d0,d2
                blo.w   locret_6BB00
                add.w   2(a1),d0
                cmp.w   d0,d2
                bhs.w   locret_6BB00
                move.w  x_pos(a0),d0
                move.w  x_pos(a2),d2
                sub.w   d2,d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   locret_6BB00
                tst.b   object_control(a2)
                bne.s   loc_6BA6C
                bsr.w   InitializeHCZBossVortexPlayerCapture

loc_6BA6C:
                move.w  y_pos(a0),d0
                move.w  y_pos(a2),d2
                add.w   (a1)+,d0
                cmp.w   d0,d2
                blo.w   ReleasePlayerFromHCZBossVortex
                move.w  x_pos(a2),d0
                move.w  x_vel(a2),d1
                move.w  #$80,d2
                sub.w   x_pos(a0),d0
                cmpi.w  #-$12,d0
                ble.s   ReleasePlayerFromHCZBossVortex
                cmpi.w  #$12,d0
                bge.s   ReleasePlayerFromHCZBossVortex
                tst.w   d0
                bmi.s   loc_6BA9E
                neg.w   d2

loc_6BA9E:
                add.w   d2,d1
                move.w  d1,x_vel(a2)
                ext.l   d1
                lsl.l   #8,d1
                add.l   d1,x_pos(a2)
                subq.w  #2,y_pos(a2)
                rts
; ---------------------------------------------------------------------------

loc_6BAB2:
                jsr     (Displace_PlayerOffObject).l
                clr.b   (a0,d4.w)
                clr.b   object_control(a2)
                rts
; End of function CaptureAndLiftPlayerInHCZBossVortex

; ---------------------------------------------------------------------------
word_6BAC2:
                dc.w    -$18,   $48
                dc.w    -$20,   $58
                dc.w    -$28,   $68
                dc.w    -$30,   $78
                dc.w    -$38,   $88
                dc.w    -$48,   $88

; =============== S U B R O U T I N E =======================================

InitializeHCZBossVortexPlayerCapture:
                st      (a0,d4.w)
                bset    #Status_InAir,status(a2)
                move.b  #1,object_control(a2)
                move.b  #$18,anim(a2)
                clr.b   spin_dash_flag(a2)
                clr.w   x_vel(a2)
                clr.w   y_vel(a2)
                clr.w   ground_vel(a2)

locret_6BB00:
                rts
; End of function InitializeHCZBossVortexPlayerCapture

; =============== S U B R O U T I N E =======================================

ReleasePlayerFromHCZBossVortex:
                clr.b   (a0,d4.w)
                bset    #Status_InAir,status(a2)
                clr.b   object_control(a2)
                move.b  #2,anim(a2)
                move.w  #-$200,y_vel(a2)
                rts
; End of function ReleasePlayerFromHCZBossVortex

; ---------------------------------------------------------------------------

loc_6BB1E:
                tst.b   $42(a0)
                beq.s   loc_6BB2E
                clr.b   $42(a0)
                lea     (Player_1).w,a2
                bsr.s   ReleasePlayerFromHCZBossVortex

loc_6BB2E:
                tst.b   $43(a0)
                beq.s   locret_6BB3E
                clr.b   $43(a0)
                lea     (Player_2).w,a2
                bsr.s   ReleasePlayerFromHCZBossVortex

locret_6BB3E:
                rts

; =============== S U B R O U T I N E =======================================

ApplyHCZBossGeyserToBothPlayers:
                cmpi.b  #$30,anim_frame(a0)
                bhs.s   locret_6BB90
                lea     word_6BB92(pc),a1
                lea     (Player_1).w,a2
                bsr.w   LaunchPlayerInsideHCZBossGeyserRectangle
                lea     word_6BB92(pc),a1
                lea     (Player_2).w,a2
; End of function ApplyHCZBossGeyserToBothPlayers

; =============== S U B R O U T I N E =======================================

LaunchPlayerInsideHCZBossGeyserRectangle:
                tst.b   object_control(a2)
                bne.s   locret_6BB90
                move.w  x_pos(a0),d0
                move.w  x_pos(a2),d1
                add.w   (a1)+,d0
                cmp.w   d0,d1
                blo.s   locret_6BB90
                add.w   (a1)+,d0
                cmp.w   d0,d1
                bhs.s   locret_6BB90
                move.w  y_pos(a0),d0
                move.w  y_pos(a2),d1
                add.w   (a1)+,d0
                cmp.w   d0,d1
                blo.s   locret_6BB90
                add.w   (a1)+,d0
                cmp.w   d0,d1
                bhs.s   locret_6BB90
                move.w  #-$800,y_vel(a2)

locret_6BB90:
                rts
; End of function LaunchPlayerInsideHCZBossGeyserRectangle

; ---------------------------------------------------------------------------
word_6BB92:
                dc.w    -$C,   $18
                dc.w    -$38,   $40

; =============== S U B R O U T I N E =======================================

AccelerateHCZBossBubbleTowardParentX:
                movea.w parent3(a0),a1
                move.w  x_pos(a0),d0
                move.w  x_vel(a0),d1
                move.w  #$80,d2
                sub.w   x_pos(a1),d0
                tst.w   d0
                bmi.s   loc_6BBB4
                neg.w   d2

loc_6BBB4:
                add.w   d2,d1
                move.w  d1,x_vel(a0)
                ext.l   d1
                lsl.l   #8,d1
                add.l   d1,x_pos(a0)
                rts
; End of function AccelerateHCZBossBubbleTowardParentX

; =============== S U B R O U T I N E =======================================

HandleHCZEndBossThreeColorHitFlashOrDefeat:
                tst.l   (a0)
                beq.s   locret_6BC1A
                tst.b   collision_flags(a0)
                bne.s   locret_6BC1A
                tst.b   collision_property(a0)
                beq.s   loc_6BC1C
                tst.b   $20(a0)
                bne.s   loc_6BBE8
                move.b  #$20,$20(a0)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l

loc_6BBE8:
                bset    #6,status(a0)
                moveq   #0,d0
                btst    #0,$20(a0)
                bne.s   loc_6BBFA
                addq.w  #2*3,d0

loc_6BBFA:
                lea     word_6BC30(pc),a1
                lea     word_6BC36(pc,d0.w),a2
                jsr     (CopyWordData_3).l
                subq.b  #1,$20(a0)
                bne.s   locret_6BC1A
                bclr    #6,status(a0)
                move.b  $25(a0),collision_flags(a0)

locret_6BC1A:
                rts
; ---------------------------------------------------------------------------

loc_6BC1C:
                move.l  #Wait_FadeToLevelMusic,(a0)
                move.l  #loc_6B0B0,$34(a0)
                jmp     (BossDefeated_StopTimer).l
; End of function HandleHCZEndBossThreeColorHitFlashOrDefeat

; ---------------------------------------------------------------------------
word_6BC30:
                dc.w    Normal_palette_line_2+$14, Normal_palette_line_2+$16, Normal_palette_line_2+$1C
word_6BC36:
                dc.w    6,   $20,  $624
                dc.w    $EEE,  $EEE,  $EEE

; =============== S U B R O U T I N E =======================================

StartHCZBossColumnDescentAfterRootDeath:
                movea.w $44(a0),a1
                btst    #7,status(a1)
                beq.s   locret_6BC6E
                bset    #7,status(a0)
                move.l  #loc_6B3C8,(a0)
                move.w  #$100,y_vel(a0)
                move.l  #Go_Delete_Sprite_2,$34(a0)
                jsr     (Displace_PlayerOffObject).l

locret_6BC6E:
                rts
; End of function StartHCZBossColumnDescentAfterRootDeath

; =============== S U B R O U T I N E =======================================

MarkHCZBossVortexDetachedWhenColumnDies:
                movea.w parent3(a0),a1
                btst    #7,status(a1)
                beq.s   locret_6BC88
                bset    #7,status(a0)
                move.b  #4,routine(a0)

locret_6BC88:
                rts
; End of function MarkHCZBossVortexDetachedWhenColumnDies

; =============== S U B R O U T I N E =======================================

UpdateHCZBossColumnHeightAndCheckCallback:
                move.w  $3A(a0),d0
                sub.w   y_pos(a0),d0
                bcs.s   loc_6BCAC
                andi.w  #$F0,d0
                lsr.w   #4,d0
                move.b  d0,$39(a0)
                tst.w   y_vel(a0)
                bpl.s   locret_6BCAA
                cmpi.b  #5,d0
                bhs.s   loc_6BCAC

locret_6BCAA:
                rts
; ---------------------------------------------------------------------------

loc_6BCAC:
                movea.l $34(a0),a2
                jmp     (a2)
; End of function UpdateHCZBossColumnHeightAndCheckCallback

; ---------------------------------------------------------------------------

loc_6BCB2:
                lea     (byte_303EA).l,a3
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                subi.w  #$80,d3
                moveq   #8-1,d1

loc_6BCC6:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_6BD1E
                move.l  #loc_3011A,(a1)
                move.l  #Map_HCZWaterWallDebris,mappings(a1)
                move.w  #make_art_tile(ArtTile_HCZCutsceneGeyser+$58,2,0),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  #$280,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.w  (a3)+,x_vel(a1)
                move.w  (a3)+,y_vel(a1)
                move.b  d1,mapping_frame(a1)
                dbf     d1,loc_6BCC6

locret_6BD1E:
                rts
