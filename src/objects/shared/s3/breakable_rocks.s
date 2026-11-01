; Owner: objects/shared/s3
; Responsibility: Shared Angel Island, Lava Reef and Endless Mine rock states, player breakage, fragments and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
byte_1D64E:
                dc.b    $18, $27
                dc.b    $18, $17
                dc.b    $18,  $F
                dc.b    $E,  $F
; ---------------------------------------------------------------------------

Obj_AIZLRZEMZRock:
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsr.w   #4,d0
                andi.b  #7,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                move.b  byte_1D64E(pc,d0.w),width_pixels(a0)
                move.b  byte_1D64E+1(pc,d0.w),d1
                move.b  d1,height_pixels(a0)
                move.b  d1,y_radius(a0)
                move.l  #Map_AIZRock,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc1,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.w  x_pos(a0),$2E(a0)
                move.w  #$40,child_dx(a0)
                cmpi.w  #1,(Current_zone_and_act).w
                bne.s   loc_1D6B6
                move.l  #Map_AIZRock2,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,0),art_tile(a0)

loc_1D6B6:
                cmpi.w  #$1200,(Current_zone_and_act).w
                bne.s   loc_1D6D2
                move.l  #Map_EMZRock,mappings(a0)
                move.w  #make_art_tile(ArtTile_EMZMisc,3,1),art_tile(a0)
                move.b  #0,mapping_frame(a0)

loc_1D6D2:
                move.l  #loc_1D712,(a0)
                btst    #2,subtype(a0)
                beq.s   loc_1D6EA
                move.l  #loc_1D8E0,(a0)
                bra.w   loc_1D8E0
; ---------------------------------------------------------------------------

loc_1D6EA:
                move.w  respawn_addr(a0),d0
                beq.s   loc_1D712
                movea.w d0,a2
                move.b  (a2),d0
                andi.w  #$7F,d0
                beq.s   loc_1D712
                sub.w   d0,x_pos(a0)
                neg.w   d0
                addi.w  #$40,d0
                move.w  d0,child_dx(a0)
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)

loc_1D712:
                move.w  (Chain_bonus_counter).w,$38(a0)
                move.b  (Player_1+anim).w,$32(a0)
                move.b  (Player_2+anim).w,$33(a0)
                move.b  (Player_1+status).w,$3A(a0)
                move.b  (Player_2+status).w,$3B(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                btst    #1,subtype(a0)
                beq.s   loc_1D75A
                bsr.w   UpdatePlayersPushingRockLeft

loc_1D75A:
                btst    #0,subtype(a0)
                beq.s   loc_1D76C
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_1D782

loc_1D76C:
                tst.w   (Competition_mode).w
                bne.s   loc_1D77C
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

loc_1D77C:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_1D782:
                cmpi.b  #$18,d0
                bne.s   loc_1D7B0
                cmpi.b  #2,$32(a0)
                beq.s   loc_1D798
                cmpi.b  #2,$33(a0)
                bne.s   loc_1D76C

loc_1D798:
                lea     (Player_1).w,a1
                move.b  $32(a0),d0
                bsr.s   ReleaseRockRiderWithConditionalBounce
                lea     (Player_2).w,a1
                move.b  $33(a0),d0
                bsr.s   ReleaseRockRiderWithConditionalBounce
                bra.w   loc_1D818
; ---------------------------------------------------------------------------

loc_1D7B0:
                move.b  d0,d1
                andi.b  #8,d1
                beq.s   loc_1D800
                cmpi.b  #2,$32(a0)
                bne.s   loc_1D76C
                lea     (Player_1).w,a1
                bsr.s   BouncePlayerAfterRockTopBreak
                bra.s   loc_1D818

; =============== S U B R O U T I N E =======================================

ReleaseRockRiderWithConditionalBounce:
                cmpi.b  #2,d0
                bne.s   loc_1D7EC
; End of function ReleaseRockRiderWithConditionalBounce

; =============== S U B R O U T I N E =======================================

BouncePlayerAfterRockTopBreak:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.w  #-$300,y_vel(a1)

loc_1D7EC:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                rts
; End of function BouncePlayerAfterRockTopBreak

; ---------------------------------------------------------------------------

loc_1D800:
                andi.b  #$10,d0
                beq.w   loc_1D76C
                cmpi.b  #2,$33(a0)
                bne.w   loc_1D76C
                lea     (Player_2).w,a1
                bsr.s   BouncePlayerAfterRockTopBreak

loc_1D818:
                move.w  $38(a0),(Chain_bonus_counter).w
                andi.b  #$E7,status(a0)
                tst.w   (Competition_mode).w
                bne.w   loc_1D874
                move.l  #loc_1D836,(a0)
                bsr.w   ShatterRockWithDefaultVelocities

loc_1D836:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_1D854
                move.b  #2,anim_frame_timer(a0)
                move.b  mapping_frame(a0),d0
                addq.b  #1,d0
                cmpi.b  #7,d0
                blo.s   loc_1D850
                moveq   #3,d0

loc_1D850:
                move.b  d0,mapping_frame(a0)

loc_1D854:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.b   render_flags(a0)
                bpl.w   loc_1D86E
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_1D86E:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_1D874:
                bsr.s   CloneCompetitionRockForRespawn
                move.b  #3,mapping_frame(a0)
                move.l  #loc_1D886,(a0)
                bsr.w   ShatterRockWithDefaultVelocities

loc_1D886:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.b   render_flags(a0)
                bpl.w   loc_1D86E
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CloneCompetitionRockForRespawn:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   locret_1D8C8
                moveq   #$48,d0

loc_1D8AC:
                move.w  (a0,d0.w),(a1,d0.w)
                subq.w  #2,d0
                bcc.s   loc_1D8AC
                move.l  (a0),$44(a1)
                move.l  #loc_1D8CA,(a1)
                move.b  #7,mapping_frame(a1)
                moveq   #0,d0

locret_1D8C8:
                rts
; End of function CloneCompetitionRockForRespawn

; ---------------------------------------------------------------------------

loc_1D8CA:
                tst.b   render_flags(a0)
                bmi.s   loc_1D8DA
                move.l  $44(a0),(a0)
                move.b  #0,mapping_frame(a0)

loc_1D8DA:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_1D8E0:
                move.w  (Player_1+x_vel).w,$30(a0)
                move.w  (Player_2+x_vel).w,$36(a0)
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
                andi.w  #3,d6
                bne.s   loc_1D926

loc_1D910:
                tst.w   (Competition_mode).w
                bne.s   loc_1D920
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

loc_1D920:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_1D926:
                lea     (Player_1).w,a1
                move.w  $30(a0),d1
                move.w  d6,d0
                andi.w  #1,d0
                beq.w   loc_1D9BE
                tst.b   subtype(a0)
                bpl.s   loc_1D948
                cmpi.b  #2,character_id(a1)
                beq.s   loc_1D97A
                bra.s   loc_1D9BE
; ---------------------------------------------------------------------------

loc_1D948:
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   loc_1D97A
                btst    #Status_FireShield,status_secondary(a1)
                bne.s   loc_1D966
                cmpi.b  #2,character_id(a1)
                beq.s   loc_1D97A
                btst    #p1_pushing_bit,status(a0)
                beq.s   loc_1D9BE

loc_1D966:
                cmpi.b  #2,anim(a1)
                bne.s   loc_1D9BE
                move.w  d1,d0
                bpl.s   loc_1D974
                neg.w   d0

loc_1D974:
                cmpi.w  #$480,d0
                blo.s   loc_1D9BE

loc_1D97A:
                bclr    #p1_pushing_bit,status(a0)
                bsr.w   BreakRockFromSideImpact
                btst    #p2_pushing_bit,status(a0)
                beq.s   loc_1D910
                lea     (Player_2).w,a1
                cmpi.b  #2,character_id(a1)
                beq.s   loc_1D9A2
                cmpi.b  #2,anim(a1)
                bne.w   loc_1D910

loc_1D9A2:
                move.w  $36(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #p2_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)
                bra.w   loc_1D910
; ---------------------------------------------------------------------------

loc_1D9BE:
                lea     (Player_2).w,a1
                move.w  $36(a0),d1
                btst    #p2_pushing_bit,status(a0)
                beq.w   loc_1D910
                tst.b   subtype(a0)
                bpl.s   loc_1D9E2
                cmpi.b  #2,character_id(a1)
                beq.s   loc_1DA02
                bra.w   loc_1D910
; ---------------------------------------------------------------------------

loc_1D9E2:
                cmpi.b  #2,character_id(a1)
                beq.s   loc_1DA02
                cmpi.b  #2,anim(a1)
                bne.w   loc_1D910
                move.w  d1,d0
                bpl.s   loc_1D9FA
                neg.w   d0

loc_1D9FA:
                cmpi.w  #$480,d0
                blo.w   loc_1D910

loc_1DA02:
                bclr    #p2_pushing_bit,status(a0)

; =============== S U B R O U T I N E =======================================

BreakRockFromSideImpact:
                bsr.w   DetachPlayersStandingOnRock
                tst.w   (Competition_mode).w
                bne.s   loc_1DA58
                move.w  d1,x_vel(a1)
                addq.w  #4,x_pos(a1)
                lea     (word_1DC30).l,a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   loc_1DA36
                subi.w  #8,x_pos(a1)
                lea     (word_1DC50).l,a4

loc_1DA36:
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                move.l  #loc_1D836,(a0)
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                bsr.w   SpawnRockFragments
                bra.w   loc_1D836
; ---------------------------------------------------------------------------

loc_1DA58:
                move.w  d1,x_vel(a1)
                addq.w  #4,x_pos(a1)
                lea     (word_1DCAC).l,a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   loc_1DA7C
                subi.w  #8,x_pos(a1)
                lea     (word_1DCC4).l,a4

loc_1DA7C:
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                bsr.w   CloneCompetitionRockForRespawn
                move.l  #loc_1D886,(a0)
                move.b  #3,mapping_frame(a0)
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                bsr.w   SpawnRockFragments
                bra.w   loc_1D886
; End of function BreakRockFromSideImpact

; =============== S U B R O U T I N E =======================================

DetachPlayersStandingOnRock:
                bclr    #p1_standing_bit,status(a0)
                beq.s   loc_1DABC
                bset    #Status_InAir,(Player_1+status).w
                bclr    #Status_OnObj,(Player_1+status).w

loc_1DABC:
                bclr    #p2_standing_bit,status(a0)
                beq.s   locret_1DAD0
                bset    #Status_InAir,(Player_2+status).w
                bclr    #Status_OnObj,(Player_2+status).w

locret_1DAD0:
                rts
; End of function DetachPlayersStandingOnRock

; =============== S U B R O U T I N E =======================================

UpdatePlayersPushingRockLeft:
                move.b  status(a0),d3
                andi.b  #pushing_mask,d3
                beq.w   locret_1DAFA
                move.w  x_pos(a0),d2
                lea     (Player_1).w,a1
                move.b  $3A(a0),d0
                moveq   #p1_pushing_bit,d6
                bsr.s   StepPushableRockLeftForPlayer
                lea     (Player_2).w,a1
                move.b  $3B(a0),d0
                moveq   #p2_pushing_bit,d6
                bsr.s   StepPushableRockLeftForPlayer

locret_1DAFA:
                rts
; End of function UpdatePlayersPushingRockLeft

; =============== S U B R O U T I N E =======================================

StepPushableRockLeftForPlayer:
                btst    d6,d3
                beq.s   locret_1DB4C
                cmp.w   x_pos(a1),d2
                bhs.s   locret_1DB4C
                btst    #5,d0
                beq.s   locret_1DB4C
                subq.w  #1,$40(a0)
                bpl.s   locret_1DB4C
                move.w  #$10,$40(a0)
                tst.w   $42(a0)
                beq.s   locret_1DB4C
                subq.w  #1,$42(a0)
                subq.w  #1,x_pos(a0)
                subq.w  #1,x_pos(a1)
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)
                move.w  respawn_addr(a0),d0
                beq.s   locret_1DB4C
                movea.w d0,a2
                move.b  $43(a0),d0
                subi.b  #$40,d0
                neg.b   d0
                move.b  d0,(a2)
                bset    #7,(a2)

locret_1DB4C:
                rts
; End of function StepPushableRockLeftForPlayer

; =============== S U B R O U T I N E =======================================

ShatterRockWithDefaultVelocities:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                lea     (off_1DC28).l,a4
                adda.w  (a4,d0.w),a4
; End of function ShatterRockWithDefaultVelocities

; =============== S U B R O U T I N E =======================================

SpawnRockFragments:
                lea     (off_1DBEA).l,a3
                adda.w  (a3,d0.w),a3
                move.w  (a3)+,d1
                move.l  (a0),d4
                move.b  render_flags(a0),d5
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  #3,d6
                movea.l a0,a1
                bra.s   loc_1DB88
; ---------------------------------------------------------------------------

loc_1DB82:
                bsr.w   AllocateObjectAfterCurrent
                bne.s   loc_1DBE2

loc_1DB88:
                move.l  d4,(a1)
                move.l  mappings(a0),mappings(a1)
                move.b  d5,render_flags(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.b  (a3)+,d0
                ext.w   d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  art_tile(a0),art_tile(a1)
                ori.w   #high_priority,art_tile(a1)
                move.w  #$80,priority(a1)
                move.b  #$18,width_pixels(a1)
; Bug: This only covers the width, when it
; should be covering the height as the width
; has already been defined
                move.b  #$18,width_pixels(a1)
                move.w  (a4)+,x_vel(a1)
                move.w  (a4)+,y_vel(a1)
                move.b  d6,mapping_frame(a1)
                addq.b  #1,d6
                cmpi.b  #7,d6
                blo.s   loc_1DBDE
                move.w  #3,d6

loc_1DBDE:
                dbf     d1,loc_1DB82

loc_1DBE2:
                moveq   #signextendB(sfx_Collapse),d0
                jmp     (Play_SFX).l
; End of function SpawnRockFragments

; ---------------------------------------------------------------------------
off_1DBEA:
                dc.w    word_1DBF2-off_1DBEA
                dc.w    word_1DC04-off_1DBEA
                dc.w    word_1DC10-off_1DBEA
                dc.w    word_1DC1A-off_1DBEA
word_1DBF2:
                dc.w    8-1
                dc.b    -8, -$18
                dc.b    $B, -$1C
                dc.b    -4,  -$C
                dc.b    $C,   -4
                dc.b    -$C,    4
                dc.b    4,   $C
                dc.b    -$C,  $1C
                dc.b    $C,  $1C
word_1DC04:
                dc.w    5-1
                dc.b    -4,  -$C
                dc.b    $B,  -$C
                dc.b    -4,   -4
                dc.b    -$C,   $C
                dc.b    $C,   $C
word_1DC10:
                dc.w    4-1
                dc.b    -4,   -4
                dc.b    $C,   -4
                dc.b    -$C,    4
                dc.b    $C,    4
word_1DC1A:
                dc.w    6-1
                dc.b    -8,   -8
                dc.b    8,   -8
                dc.b    -8,    0
                dc.b    8,    0
                dc.b    -8,    8
                dc.b    8,    8
off_1DC28:
                dc.w    word_1DC30-off_1DC28
                dc.w    word_1DC70-off_1DC28
                dc.w    word_1DC84-off_1DC28
                dc.w    word_1DC94-off_1DC28
word_1DC30:
                dc.w    -$300, -$300
                dc.w    -$2C0, -$280
                dc.w    -$2C0, -$280
                dc.w    -$280, -$200
                dc.w    -$280, -$180
                dc.w    -$240, -$180
                dc.w    -$240, -$100
                dc.w    -$200, -$100
word_1DC50:
                dc.w    $300, -$300
                dc.w    $2C0, -$280
                dc.w    $2C0, -$280
                dc.w    $280, -$200
                dc.w    $280, -$180
                dc.w    $240, -$180
                dc.w    $240, -$100
                dc.w    $200, -$100
word_1DC70:
                dc.w    -$200, -$200
                dc.w    $200, -$200
                dc.w    -$100, -$1E0
                dc.w    -$1B0, -$1C0
                dc.w    $1C0, -$1C0
word_1DC84:
                dc.w    -$100, -$200
                dc.w    $100, -$1E0
                dc.w    -$1B0, -$1C0
                dc.w    $1C0, -$1C0
word_1DC94:
                dc.w    -$B0, -$1E0
                dc.w    $B0, -$1D0
                dc.w    -$80, -$200
                dc.w    $80, -$1E0
                dc.w    -$D8, -$1C0
                dc.w    $E0, -$1C0
word_1DCAC:
                dc.w    -$2C0, -$280
                dc.w    -$280, -$200
                dc.w    -$280, -$180
                dc.w    -$240, -$180
                dc.w    -$240, -$100
                dc.w    -$200, -$100
word_1DCC4:
                dc.w    $2C0, -$280
                dc.w    $280, -$200
                dc.w    $280, -$180
                dc.w    $240, -$180
                dc.w    $240, -$100
                dc.w    $200, -$100
Map_AIZRock:
                include "src/objects/shared/zones/aiz/mappings/rock.s"
Map_AIZRock2:
                include "src/objects/shared/zones/aiz/mappings/rock_2.s"
Map_EMZRock:
                include "src/objects/shared/zones/emz/mappings/rock.s"
