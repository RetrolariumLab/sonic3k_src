; Owner: objects/shared/sk
; Responsibility: Shared rock initialization, active state and character contact or release logic
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
byte_1F9D0:
                dc.b    $18, $27
                dc.b    $18, $17
                dc.b    $18,  $F
                dc.b    $E,  $F
                dc.b    $10, $28
                dc.b    $28, $10
                dc.b    $28, $10
                dc.b    $10, $20
; ---------------------------------------------------------------------------

Obj_AIZLRZEMZRock:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d2
                lsr.w   #4,d0
                andi.b  #7,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                move.b  byte_1F9D0(pc,d0.w),width_pixels(a0)
                move.b  byte_1F9D0+1(pc,d0.w),d1
                move.b  d1,height_pixels(a0)
                move.b  d1,y_radius(a0)
                move.l  #Map_AIZRock,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc1,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                move.w  x_pos(a0),$2E(a0)
                move.w  #$40,child_dx(a0)
                cmpi.w  #1,(Current_zone_and_act).w
                bne.s   loc_1FA42
                move.l  #Map_AIZRock2,mappings(a0)
                move.w  #make_art_tile(ArtTile_AIZMisc2,2,0),art_tile(a0)

loc_1FA42:
                cmpi.w  #$1200,(Current_zone_and_act).w
                bne.s   loc_1FA5E
                move.l  #Map_EMZRock,mappings(a0)
                move.w  #make_art_tile(ArtTile_EMZMisc,3,1),art_tile(a0)
                move.b  #0,mapping_frame(a0)

loc_1FA5E:
                cmpi.b  #9,(Current_zone).w
                bne.s   loc_1FA8C
                move.l  #Map_LRZBreakableRock,mappings(a0)
                move.w  #make_art_tile($0D3,2,0),art_tile(a0)
                addq.b  #4,mapping_frame(a0)
                tst.b   (Current_act).w
                beq.s   loc_1FA8C
                move.l  #Map_LRZBreakableRock2,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,3,0),art_tile(a0)

loc_1FA8C:
                andi.w  #$F,d2
                cmpi.w  #$F,d2
                bne.s   loc_1FAA0
                move.l  #loc_20002,(a0)
                bra.w   loc_20002
; ---------------------------------------------------------------------------

loc_1FAA0:
                move.l  #loc_1FAF2,(a0)
                btst    #2,subtype(a0)
                beq.s   loc_1FAB8
                move.l  #loc_1FD08,(a0)
                bra.w   loc_1FD08
; ---------------------------------------------------------------------------

loc_1FAB8:
                btst    #3,subtype(a0)
                beq.s   loc_1FACA
                move.l  #loc_1FF48,(a0)
                bra.w   loc_1FF48
; ---------------------------------------------------------------------------

loc_1FACA:
                move.w  respawn_addr(a0),d0
                beq.s   loc_1FAF2
                movea.w d0,a2
                move.b  (a2),d0
                andi.w  #$7F,d0
                beq.s   loc_1FAF2
                sub.w   d0,x_pos(a0)
                neg.w   d0
                addi.w  #$40,d0
                move.w  d0,child_dx(a0)
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)

loc_1FAF2:
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
                beq.s   loc_1FB3A
                bsr.w   UpdatePlayersPushingRockLeft

loc_1FB3A:
                btst    #0,subtype(a0)
                beq.s   loc_1FB4C
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_1FB62

loc_1FB4C:
                tst.w   (Competition_mode).w
                bne.s   loc_1FB5C
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

loc_1FB5C:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_1FB62:
                cmpi.b  #$18,d0
                bne.s   loc_1FB90
                cmpi.b  #2,$32(a0)
                beq.s   loc_1FB78
                cmpi.b  #2,$33(a0)
                bne.s   loc_1FB4C

loc_1FB78:
                lea     (Player_1).w,a1
                move.b  $32(a0),d0
                bsr.s   ReleaseRockRiderWithConditionalBounce
                lea     (Player_2).w,a1
                move.b  $33(a0),d0
                bsr.s   ReleaseRockRiderWithConditionalBounce
                bra.w   loc_1FBF8
; ---------------------------------------------------------------------------

loc_1FB90:
                move.b  d0,d1
                andi.b  #8,d1
                beq.s   loc_1FBE0
                cmpi.b  #2,$32(a0)
                bne.s   loc_1FB4C
                lea     (Player_1).w,a1
                bsr.s   BouncePlayerAfterRockTopBreak
                bra.s   loc_1FBF8

; =============== S U B R O U T I N E =======================================

ReleaseRockRiderWithConditionalBounce:
                cmpi.b  #2,d0
                bne.s   loc_1FBCC
; End of function ReleaseRockRiderWithConditionalBounce

; =============== S U B R O U T I N E =======================================

BouncePlayerAfterRockTopBreak:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.w  #-$300,y_vel(a1)

loc_1FBCC:
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                rts
; End of function BouncePlayerAfterRockTopBreak

; ---------------------------------------------------------------------------

loc_1FBE0:
                andi.b  #$10,d0
                beq.w   loc_1FB4C
                cmpi.b  #2,$33(a0)
                bne.w   loc_1FB4C
                lea     (Player_2).w,a1
                bsr.s   BouncePlayerAfterRockTopBreak

loc_1FBF8:
                move.w  $38(a0),(Chain_bonus_counter).w
                andi.b  #$E7,status(a0)
                tst.w   (Competition_mode).w
                bne.w   loc_1FC9C
                move.l  #loc_1FC16,(a0)
                bsr.w   ShatterRockWithDefaultVelocities

loc_1FC16:
                cmpi.b  #9,(Current_zone).w
                beq.s   loc_1FC60
                move.l  #loc_1FC24,(a0)

loc_1FC24:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_1FC42
                move.b  #2,anim_frame_timer(a0)
                move.b  mapping_frame(a0),d0
                addq.b  #1,d0
                cmpi.b  #7,d0
                blo.s   loc_1FC3E
                moveq   #3,d0

loc_1FC3E:
                move.b  d0,mapping_frame(a0)

loc_1FC42:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.b   render_flags(a0)
                bpl.s   loc_1FC5A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_1FC5A:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_1FC60:
                move.l  #loc_1FC66,(a0)

loc_1FC66:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_1FC84
                move.b  #7,anim_frame_timer(a0)
                move.b  mapping_frame(a0),d0
                addq.b  #1,d0
                andi.b  #3,d0
                add.b   $3C(a0),d0
                move.b  d0,mapping_frame(a0)

loc_1FC84:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.b   render_flags(a0)
                bpl.s   loc_1FC5A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_1FC9C:
                bsr.s   CloneCompetitionRockForRespawn
                move.b  #3,mapping_frame(a0)
                move.l  #loc_1FCAE,(a0)
                bsr.w   ShatterRockWithDefaultVelocities

loc_1FCAE:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)
                tst.b   render_flags(a0)
                bpl.w   loc_1FC5A
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CloneCompetitionRockForRespawn:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   locret_1FCF0
                moveq   #$48,d0

loc_1FCD4:
                move.w  (a0,d0.w),(a1,d0.w)
                subq.w  #2,d0
                bcc.s   loc_1FCD4
                move.l  (a0),$44(a1)
                move.l  #loc_1FCF2,(a1)
                move.b  #7,mapping_frame(a1)
                moveq   #0,d0

locret_1FCF0:
                rts
; End of function CloneCompetitionRockForRespawn

; ---------------------------------------------------------------------------

loc_1FCF2:
                tst.b   render_flags(a0)
                bmi.s   loc_1FD02
                move.l  $44(a0),(a0)
                move.b  #0,mapping_frame(a0)

loc_1FD02:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_1FD08:
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
                bne.s   loc_1FD4E

loc_1FD38:
                tst.w   (Competition_mode).w
                bne.s   loc_1FD48
                move.w  $2E(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

loc_1FD48:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_1FD4E:
                lea     (Player_1).w,a1
                move.w  $30(a0),d1
                move.w  d6,d0
                andi.w  #1,d0
                beq.w   loc_1FDEA
                tst.b   subtype(a0)
                bpl.s   loc_1FD72
                cmpi.b  #2,character_id(a1)
                beq.s   loc_1FDA4
                bra.w   loc_1FDEA
; ---------------------------------------------------------------------------

loc_1FD72:
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   loc_1FDA4
                cmpi.b  #2,character_id(a1)
                beq.s   loc_1FDA4
                btst    #Status_FireShield,status_secondary(a1)
                bne.s   loc_1FD90
                btst    #p1_pushing_bit,status(a0)
                beq.s   loc_1FDEA

loc_1FD90:
                cmpi.b  #2,anim(a1)
                bne.s   loc_1FDEA
                move.w  d1,d0
                bpl.s   loc_1FD9E
                neg.w   d0

loc_1FD9E:
                cmpi.w  #$480,d0
                blo.s   loc_1FDEA

loc_1FDA4:
                bclr    #p1_pushing_bit,status(a0)
                bsr.w   BreakRockFromSideImpact
                btst    #p2_pushing_bit,status(a0)
                beq.w   loc_1FD38
                lea     (Player_2).w,a1
                cmpi.b  #2,character_id(a1)
                beq.s   loc_1FDCE
                cmpi.b  #2,anim(a1)
                bne.w   loc_1FD38

loc_1FDCE:
                move.w  $36(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #p2_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)
                bra.w   loc_1FD38
; ---------------------------------------------------------------------------

loc_1FDEA:
                lea     (Player_2).w,a1
                move.w  $36(a0),d1
                btst    #p2_pushing_bit,status(a0)
                beq.w   loc_1FD38
                tst.b   subtype(a0)
                bpl.s   loc_1FE0E
                cmpi.b  #2,character_id(a1)
                beq.s   loc_1FE2E
                bra.w   loc_1FD38
; ---------------------------------------------------------------------------

loc_1FE0E:
                cmpi.b  #2,character_id(a1)
                beq.s   loc_1FE2E
                cmpi.b  #2,anim(a1)
                bne.w   loc_1FD38
                move.w  d1,d0
                bpl.s   loc_1FE26
                neg.w   d0

loc_1FE26:
                cmpi.w  #$480,d0
                blo.w   loc_1FD38

loc_1FE2E:
                bclr    #p2_pushing_bit,status(a0)

; =============== S U B R O U T I N E =======================================

BreakRockFromSideImpact:
                bsr.w   DetachPlayersStandingOnRock
                tst.w   (Competition_mode).w
                bne.w   loc_1FECE
                move.w  d1,x_vel(a1)
                addq.w  #4,x_pos(a1)
                lea     (word_202F4).l,a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   loc_1FE64
                subi.w  #8,x_pos(a1)
                lea     (word_20314).l,a4

loc_1FE64:
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                cmpi.b  #2,character_id(a1)
                bne.s   loc_1FE9E
                cmpi.b  #1,double_jump_flag(a1)
                bne.s   loc_1FE9E
                move.b  #2,double_jump_flag(a1)
                move.b  #$21,anim(a1)
                bclr    #Status_Facing,status(a1)
                tst.w   x_vel(a1)
                bpl.s   loc_1FE9E
                bset    #Status_Facing,status(a1)

loc_1FE9E:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                cmpi.b  #9,(Current_zone).w
                bne.s   loc_1FEBE
                subq.b  #4,d0
                move.l  #loc_1FC66,(a0)
                add.w   d0,d0
                bsr.w   SpawnLavaReefRockFragments
                bra.w   loc_1FC66
; ---------------------------------------------------------------------------

loc_1FEBE:
                move.l  #loc_1FC16,(a0)
                add.w   d0,d0
                bsr.w   SpawnRockFragments
                bra.w   loc_1FC16
; ---------------------------------------------------------------------------

loc_1FECE:
                move.w  d1,x_vel(a1)
                addq.w  #4,x_pos(a1)
                lea     (word_20370).l,a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   loc_1FEF2
                subi.w  #8,x_pos(a1)
                lea     (word_20388).l,a4

loc_1FEF2:
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                bsr.w   CloneCompetitionRockForRespawn
                move.l  #loc_1FCAE,(a0)
                move.b  #3,mapping_frame(a0)
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                bsr.w   SpawnRockFragments
                bra.w   loc_1FCAE
; End of function BreakRockFromSideImpact

; =============== S U B R O U T I N E =======================================

DetachPlayersStandingOnRock:
                bclr    #p1_standing_bit,status(a0)
                beq.s   loc_1FF32
                bset    #Status_InAir,(Player_1+status).w
                bclr    #Status_OnObj,(Player_1+status).w

loc_1FF32:
                bclr    #p2_standing_bit,status(a0)
                beq.s   locret_1FF46
                bset    #Status_InAir,(Player_2+status).w
                bclr    #Status_OnObj,(Player_2+status).w

locret_1FF46:
                rts
; End of function DetachPlayersStandingOnRock
