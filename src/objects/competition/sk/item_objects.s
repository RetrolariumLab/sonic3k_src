; Owner: objects/competition/sk
; Responsibility: Competition item selection, collection, effects, object motion and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_2PItem:
                move.l  #Map_2PItem,mappings(a0)
                move.w  #make_art_tile(ArtTile_2PArt_3,0,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.b  #4,x_radius(a0)
                move.b  #8,y_radius(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                move.b  subtype(a0),angle(a0)
                moveq   #1,d0
                bclr    #0,status(a0)
                beq.s   loc_363B4
                neg.b   d0

loc_363B4:
                move.b  d0,$27(a0)
                move.b  #3,anim(a0)
                move.b  #7,anim(a0)
                move.b  #$C7,collision_flags(a0)
                move.l  #loc_363D0,(a0)

loc_363D0:
                bsr.s   CompetitionItemSKConsumePickupPlayerContacts
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asl.w   #3,d1
                move.w  d1,d2
                add.w   d1,d1
                add.w   d1,d2
                add.w   d1,d1
                add.w   d2,d1
                asr.w   #8,d1
                add.w   $30(a0),d1
                and.w   (Screen_X_wrap_value).w,d1
                addi.w  #$400,d1
                move.w  d1,x_pos(a0)
                asl.w   #3,d0
                move.w  d0,d2
                add.w   d0,d0
                add.w   d0,d2
                add.w   d0,d0
                add.w   d2,d0
                asr.w   #8,d0
                add.w   $32(a0),d0
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_36418
                and.w   (Screen_Y_wrap_value).w,d0

loc_36418:
                move.w  d0,y_pos(a0)
                move.b  $27(a0),d0
                add.b   d0,angle(a0)
                lea     (Ani_2PItem).l,a1
                jsr     (Animate_Sprite).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CompetitionItemSKConsumePickupPlayerContacts:
                tst.b   collision_property(a0)
                beq.s   locret_36462
                lea     (Player_1).w,a2
                bclr    #0,collision_property(a0)
                beq.s   loc_36450
                bsr.s   CompetitionItemSKDispatchCollectedEffectByAnimation

loc_36450:
                lea     (Player_2).w,a2
                bclr    #1,collision_property(a0)
                beq.s   loc_3645E
                bsr.s   CompetitionItemSKDispatchCollectedEffectByAnimation

loc_3645E:
                clr.b   collision_property(a0)

locret_36462:
                rts
; End of function CompetitionItemSKConsumePickupPlayerContacts

; =============== S U B R O U T I N E =======================================

CompetitionItemSKDispatchCollectedEffectByAnimation:
                moveq   #0,d0
                move.b  anim(a0),d0
                add.w   d0,d0
                move.w  off_36476(pc,d0.w),d0
                jsr     off_36476(pc,d0.w)
                rts
; End of function CompetitionItemSKDispatchCollectedEffectByAnimation

; ---------------------------------------------------------------------------
off_36476:
                dc.w    loc_36486-off_36476
                dc.w    loc_364D8-off_36476
                dc.w    loc_3652A-off_36476
                dc.w    loc_365E8-off_36476
                dc.w    loc_36612-off_36476
                dc.w    loc_36652-off_36476
                dc.w    loc_36676-off_36476
                dc.w    locret_3669A-off_36476
; ---------------------------------------------------------------------------

loc_36486:
                bset    #Status_SpeedShoes,status_secondary(a2)
                move.b  #(10*60)/8,speed_shoes_timer(a2)
                cmpa.w  #Player_1,a2
                bne.s   loc_364AC
                move.w  #$C00,(Max_speed).w
                move.w  #$18,(Acceleration).w
                move.w  #$80,(Deceleration).w
                bra.s   loc_364BE
; ---------------------------------------------------------------------------

loc_364AC:
                move.w  #$C00,(Max_speed_P2).w
                move.w  #$18,(Acceleration_P2).w
                move.w  #$80,(Deceleration_P2).w

loc_364BE:
                move.b  #7,anim(a0)
                move.b  #0,collision_flags(a0)
                move.l  #loc_36A1A,d1
                moveq   #9,d2
                bsr.w   CompetitionItemSKClonePrefixWithHandlerAndAnimation
                rts
; ---------------------------------------------------------------------------

loc_364D8:
                bset    #Status_SpeedShoes,status_secondary(a2)
                move.b  #(10*60)/8,speed_shoes_timer(a2)
                cmpa.w  #Player_1,a2
                bne.s   loc_364FE
                move.w  #$300,(Max_speed).w
                move.w  #8,(Acceleration).w
                move.w  #$20,(Deceleration).w
                bra.s   loc_36510
; ---------------------------------------------------------------------------

loc_364FE:
                move.w  #$300,(Max_speed_P2).w
                move.w  #8,(Acceleration_P2).w
                move.w  #$20,(Deceleration_P2).w

loc_36510:
                move.b  #7,anim(a0)
                move.b  #0,collision_flags(a0)
                move.l  #loc_36A1A,d1
                moveq   #9,d2
                bsr.w   CompetitionItemSKClonePrefixWithHandlerAndAnimation
                rts
; ---------------------------------------------------------------------------

loc_3652A:
                lea     (Player_1).w,a2
                lea     (Player_2).w,a3
                move.b  status_secondary(a2),d0
                move.b  status_secondary(a3),status_secondary(a2)
                move.b  d0,status_secondary(a3)
                move.b  speed_shoes_timer(a2),d0
                move.b  speed_shoes_timer(a3),speed_shoes_timer(a2)
                move.b  d0,speed_shoes_timer(a3)
                move.w  (Max_speed).w,d0
                move.w  (Acceleration).w,d1
                move.w  (Deceleration).w,d2
                move.w  (Max_speed_P2).w,d3
                move.w  (Acceleration_P2).w,d4
                move.w  (Deceleration_P2).w,d5
                move.w  d0,-(sp)
                lea     (Character_Speeds).l,a1
                moveq   #0,d0
                move.b  character_id(a2),d0
                lsl.w   #3,d0
                lea     (a1,d0.w),a1
                move.w  (a1)+,(Max_speed).w
                move.w  (a1)+,(Acceleration).w
                move.w  (a1)+,(Deceleration).w
                lea     (Character_Speeds).l,a1
                moveq   #0,d0
                move.b  character_id(a3),d0
                lsl.w   #3,d0
                lea     (a1,d0.w),a1
                move.w  (a1)+,(Max_speed_P2).w
                move.w  (a1)+,(Acceleration_P2).w
                move.w  (a1)+,(Deceleration_P2).w
                move.w  (sp)+,d0
                btst    #Status_SpeedShoes,status_secondary(a2)
                beq.s   loc_365BA
                move.w  d3,(Max_speed).w
                move.w  d4,(Acceleration).w
                move.w  d5,(Deceleration).w

loc_365BA:
                btst    #Status_SpeedShoes,status_secondary(a3)
                beq.s   loc_365CE
                move.w  d0,(Max_speed_P2).w
                move.w  d1,(Acceleration_P2).w
                move.w  d2,(Deceleration_P2).w

loc_365CE:
                move.b  #7,anim(a0)
                move.b  #0,collision_flags(a0)
                move.l  #loc_36A1A,d1
                moveq   #9,d2
                bsr.w   CompetitionItemSKClonePrefixWithHandlerAndAnimation
                rts
; ---------------------------------------------------------------------------

loc_365E8:
                move.b  #7,anim(a0)
                move.b  #0,collision_flags(a0)
                move.l  #loc_36A1A,d1
                moveq   #8,d2
                bsr.w   CompetitionItemSKClonePrefixWithHandlerAndAnimation
                cmpa.w  #Player_1,a2
                bne.s   loc_3660C
                jmp     (GiveRing).l
; ---------------------------------------------------------------------------

loc_3660C:
                jmp     (GiveRing_Tails).l
; ---------------------------------------------------------------------------

loc_36612:
                move.b  #7,anim(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)
                lea     (Breathing_bubbles).w,a1
                tst.l   (a1)
                moveq   #subtype,d0

loc_36628:
                move.w  (a0,d0.w),(a1,d0.w)
                subq.w  #2,d0
                bcc.s   loc_36628
                move.l  #loc_3669C,(a1)
                move.b  #4,anim(a1)
                move.w  top_solid_bit(a2),top_solid_bit(a1)
                tst.w   art_tile(a2)
                bpl.s   locret_36650
                ori.w   #high_priority,art_tile(a1)

locret_36650:
                rts
; ---------------------------------------------------------------------------

loc_36652:
                move.b  #7,anim(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)
                move.l  #loc_366B6,d1
                moveq   #5,d2
                bsr.w   CompetitionItemSKClonePrefixWithHandlerAndAnimation
                bne.s   locret_36674
                move.w  top_solid_bit(a2),top_solid_bit(a1)

locret_36674:
                rts
; ---------------------------------------------------------------------------

loc_36676:
                move.b  #7,anim(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)
                move.l  #loc_366BE,d1
                moveq   #6,d2
                bsr.w   CompetitionItemSKClonePrefixWithHandlerAndAnimation
                bne.s   locret_36698
                move.w  top_solid_bit(a2),top_solid_bit(a1)

locret_36698:
                rts
; ---------------------------------------------------------------------------

locret_3669A:
                rts
; ---------------------------------------------------------------------------

loc_3669C:
                move.w  #-$400,ground_vel(a0)
                move.b  #0,angle(a0)
                move.b  #0,status(a0)
                move.l  #loc_368AA,d2
                bra.s   loc_366C4
; ---------------------------------------------------------------------------

loc_366B6:
                move.l  #loc_367C2,d2
                bra.s   loc_366C4
; ---------------------------------------------------------------------------

loc_366BE:
                move.l  #loc_3670C,d2

loc_366C4:
                move.l  d2,-(sp)
                jsr     (MoveSprite).l
                jsr     (ObjCheckFloorDist).l
                move.l  (sp)+,d2
                tst.w   d1
                bpl.s   loc_366E4
                add.w   d1,y_pos(a0)
                move.l  d2,(a0)
                move.b  #$C7,collision_flags(a0)

loc_366E4:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_366F4
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_366F4:
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$60,d0
                cmp.w   y_pos(a0),d0
                bge.s   loc_36708
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_36708:
                bra.w   loc_36A1A
; ---------------------------------------------------------------------------

loc_3670C:
                tst.b   collision_property(a0)
                beq.s   loc_36732
                lea     (Player_1).w,a2
                bclr    #0,collision_property(a0)
                beq.s   loc_36720
                bsr.s   CompetitionItemSKApplyPlaneMatchedUpwardFlipLaunch

loc_36720:
                lea     (Player_2).w,a2
                bclr    #1,collision_property(a0)
                beq.s   loc_3672E
                bsr.s   CompetitionItemSKApplyPlaneMatchedUpwardFlipLaunch

loc_3672E:
                clr.b   collision_property(a0)

loc_36732:
                lea     (Ani_2PItem).l,a1
                jsr     (Animate_Sprite).l
                tst.b   routine(a0)
                beq.s   loc_3674A
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_3674A:
                cmpi.b  #9,anim(a0)
                beq.s   loc_36758
                jsr     (Add_SpriteToCollisionResponseList).l

loc_36758:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CompetitionItemSKApplyPlaneMatchedUpwardFlipLaunch:
                move.w  top_solid_bit(a2),d0
                cmp.w   top_solid_bit(a0),d0
                beq.s   loc_3676A
                rts
; ---------------------------------------------------------------------------

loc_3676A:
                move.b  #$A,anim(a0)
                move.w  #-$A00,y_vel(a2)
                bset    #Status_InAir,status(a2)
                bclr    #Status_RollJump,status(a2)
                bclr    #Status_Push,status(a2)
                clr.b   jumping(a2)
                move.w  #1,ground_vel(a2)
                move.b  #1,flip_angle(a2)
                move.b  #0,anim(a2)
                move.b  #0,flips_remaining(a2)
                move.b  #4,flip_speed(a2)
                btst    #Status_Facing,status(a2)
                beq.s   loc_367BA
                neg.b   flip_angle(a2)
                neg.w   ground_vel(a2)

loc_367BA:
                moveq   #signextendB(sfx_SmallBumpers),d0
                jmp     (Play_SFX).l
; End of function CompetitionItemSKApplyPlaneMatchedUpwardFlipLaunch

; ---------------------------------------------------------------------------

loc_367C2:
                tst.b   collision_property(a0)
                beq.s   loc_367E8
                lea     (Player_1).w,a2
                bclr    #0,collision_property(a0)
                beq.s   loc_367D6
                bsr.s   CompetitionItemSKBeginGroundedMomentumTrap

loc_367D6:
                lea     (Player_2).w,a2
                bclr    #1,collision_property(a0)
                beq.s   loc_367E4
                bsr.s   CompetitionItemSKBeginGroundedMomentumTrap

loc_367E4:
                clr.b   collision_property(a0)

loc_367E8:
                lea     (Ani_2PItem).l,a1
                jsr     (Animate_Sprite).l
                tst.b   $3C(a0)
                beq.s   loc_36834
                movea.w $3E(a0),a1
                subq.b  #1,$3C(a0)
                beq.s   loc_36828
                move.w  #$20,d1
                move.w  ground_vel(a1),d0
                bpl.s   loc_3681C
                add.w   d1,ground_vel(a1)
                bcc.s   loc_36840
                move.w  #0,ground_vel(a1)
                bra.s   loc_36828
; ---------------------------------------------------------------------------

loc_3681C:
                sub.w   d1,ground_vel(a1)
                bcc.s   loc_36840
                move.w  #0,ground_vel(a1)

loc_36828:
                move.w  #5,move_lock(a1)
                andi.b  #$7F,status_secondary(a1)

loc_36834:
                tst.b   routine(a0)
                beq.s   loc_36840
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_36840:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CompetitionItemSKBeginGroundedMomentumTrap:
                move.w  top_solid_bit(a2),d0
                cmp.w   top_solid_bit(a0),d0
                bne.s   locret_368A8
                tst.b   status_secondary(a2)
                bmi.s   locret_368A8
                btst    #Status_InAir,status(a2)
                bne.s   locret_368A8
                tst.w   ground_vel(a2)
                beq.s   locret_368A8
                move.b  #9,anim(a0)
                move.b  #0,collision_flags(a0)
                move.w  #$200,d1
                move.w  ground_vel(a2),d0
                bpl.s   loc_36884
                neg.w   d0
                neg.w   d1

loc_36884:
                cmpi.w  #$200,d0
                bhs.s   loc_3688E
                add.w   d1,ground_vel(a2)

loc_3688E:
                asl     ground_vel(a2)
                move.b  #$1B,anim(a2)
                ori.b   #$80,status_secondary(a2)
                move.w  a2,$3E(a0)
                move.b  #$3C,$3C(a0)

locret_368A8:
                rts
; End of function CompetitionItemSKBeginGroundedMomentumTrap

; ---------------------------------------------------------------------------

loc_368AA:
                tst.b   collision_property(a0)
                beq.s   loc_368D0
                lea     (Player_1).w,a2
                bclr    #0,collision_property(a0)
                beq.s   loc_368BE
                bsr.s   CompetitionItemSKExplodeRollingHazardAndAttemptPlayerHurt

loc_368BE:
                lea     (Player_2).w,a2
                bclr    #1,collision_property(a0)
                beq.s   loc_368CC
                bsr.s   CompetitionItemSKExplodeRollingHazardAndAttemptPlayerHurt

loc_368CC:
                clr.b   collision_property(a0)

loc_368D0:
                bsr.w   CompetitionItemSKMoveRollingHazardOnTerrainOrInAir
                move.b  angle(a0),d0
                addi.b  #$10,d0
                lsr.b   #5,d0
                addi.b  #$11,d0
                move.b  d0,mapping_frame(a0)
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$60,d0
                cmp.w   y_pos(a0),d0
                bge.s   loc_368FA
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_368FA:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CompetitionItemSKExplodeRollingHazardAndAttemptPlayerHurt:
                move.w  top_solid_bit(a2),d0
                cmp.w   top_solid_bit(a0),d0
                beq.s   loc_36912
                rts
; ---------------------------------------------------------------------------

loc_36912:
                move.l  #loc_36A1A,(a0)
                move.b  #$B,anim(a0)
                movea.l a2,a1
                jmp     (HurtPlayerFromSolidHazard).l
; End of function CompetitionItemSKExplodeRollingHazardAndAttemptPlayerHurt

; =============== S U B R O U T I N E =======================================

CompetitionItemSKMoveRollingHazardOnTerrainOrInAir:
                btst    #1,status(a0)
                bne.s   loc_36990
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                muls.w  ground_vel(a0),d1
                asr.l   #8,d1
                move.w  d1,x_vel(a0)
                muls.w  ground_vel(a0),d0
                asr.l   #8,d0
                move.w  d0,y_vel(a0)
                jsr     (MoveSprite2).l
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)
                move.w  (Screen_X_wrap_value).w,d0
                and.w   d0,x_pos(a0)
                addi.w  #$400,x_pos(a0)
                jsr     (Player_AnglePos).l
                move.b  angle(a0),d0
                bne.s   locret_3698E
                jsr     (ProbeLeftWallUsingYRadius).l
                tst.w   d1
                bpl.s   locret_3698E
                sub.w   d1,x_pos(a0)
                move.l  #loc_36A1A,(a0)
                move.b  #$B,anim(a0)

locret_3698E:
                rts
; ---------------------------------------------------------------------------

loc_36990:
                subi.w  #$10,x_vel(a0)
                cmpi.w  #-$400,x_vel(a0)
                bgt.s   loc_369A4
                move.w  #-$400,x_vel(a0)

loc_369A4:
                jsr     (MoveSprite).l
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)
                move.w  (Screen_X_wrap_value).w,d0
                and.w   d0,x_pos(a0)
                addi.w  #$400,x_pos(a0)
                jsr     (ChkFloorEdge).l
                tst.w   d1
                bpl.s   loc_369DC
                add.w   d1,y_pos(a0)
                bclr    #1,status(a0)
                move.b  #0,angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_369DC:
                move.b  angle(a0),d0
                beq.s   loc_369F6
                bpl.s   loc_369EC
                addq.b  #2,d0
                bcc.s   loc_369F2
                moveq   #0,d0
                bra.s   loc_369F2
; ---------------------------------------------------------------------------

loc_369EC:
                subq.b  #2,d0
                bcc.s   loc_369F2
                moveq   #0,d0

loc_369F2:
                move.b  d0,angle(a0)

loc_369F6:
                move.b  angle(a0),d0
                bne.s   locret_36A18
                jsr     (ProbeLeftWallUsingYRadius).l
                tst.w   d1
                bpl.s   locret_36A18
                sub.w   d1,x_pos(a0)
                move.l  #loc_36A1A,(a0)
                move.b  #$B,anim(a0)
                rts
; ---------------------------------------------------------------------------

locret_36A18:
                rts
; ---------------------------------------------------------------------------

loc_36A1A:
                lea     (Ani_2PItem).l,a1
                jsr     (Animate_Sprite).l
                tst.b   routine(a0)
                beq.s   loc_36A32
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_36A32:
                jmp     (Draw_Sprite).l
; End of function CompetitionItemSKMoveRollingHazardOnTerrainOrInAir

; =============== S U B R O U T I N E =======================================

CompetitionItemSKClonePrefixWithHandlerAndAnimation:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   locret_36A56
                moveq   #subtype,d0

loc_36A44:
                move.w  (a0,d0.w),(a1,d0.w)
                subq.w  #2,d0
                bcc.s   loc_36A44
                move.l  d1,(a1)
                move.b  d2,anim(a1)
                moveq   #0,d0

locret_36A56:
                rts
; End of function CompetitionItemSKClonePrefixWithHandlerAndAnimation

; ---------------------------------------------------------------------------
Ani_2PItem:
                include "src/game/competition/shared/animations/item.s"
Map_2PItem:
                include "src/game/competition/shared/mappings/item.s"
