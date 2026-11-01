; Owner: objects/competition/s3
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
                beq.s   loc_35946
                neg.b   d0

loc_35946:
                move.b  d0,$27(a0)
                move.b  #3,anim(a0)
                move.b  #7,anim(a0)
                move.b  #$C7,collision_flags(a0)
                move.l  #loc_35962,(a0)

loc_35962:
                bsr.s   CompetitionItemS3ConsumePickupPlayerContacts
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
                bne.s   loc_359AA
                and.w   (Screen_Y_wrap_value).w,d0

loc_359AA:
                move.w  d0,y_pos(a0)
                move.b  $27(a0),d0
                add.b   d0,angle(a0)
                lea     (Ani_2PItem).l,a1
                jsr     (Animate_Sprite).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CompetitionItemS3ConsumePickupPlayerContacts:
                tst.b   collision_property(a0)
                beq.s   locret_359F4
                lea     (Player_1).w,a2
                bclr    #0,collision_property(a0)
                beq.s   loc_359E2
                bsr.s   CompetitionItemS3DispatchCollectedEffectByAnimation

loc_359E2:
                lea     (Player_2).w,a2
                bclr    #1,collision_property(a0)
                beq.s   loc_359F0
                bsr.s   CompetitionItemS3DispatchCollectedEffectByAnimation

loc_359F0:
                clr.b   collision_property(a0)

locret_359F4:
                rts
; End of function CompetitionItemS3ConsumePickupPlayerContacts

; =============== S U B R O U T I N E =======================================

CompetitionItemS3DispatchCollectedEffectByAnimation:
                moveq   #0,d0
                move.b  anim(a0),d0
                add.w   d0,d0
                move.w  off_35A08(pc,d0.w),d0
                jsr     off_35A08(pc,d0.w)
                rts
; End of function CompetitionItemS3DispatchCollectedEffectByAnimation

; ---------------------------------------------------------------------------
off_35A08:
                dc.w    loc_35A18-off_35A08
                dc.w    loc_35A6A-off_35A08
                dc.w    loc_35ABC-off_35A08
                dc.w    loc_35B7A-off_35A08
                dc.w    loc_35BA4-off_35A08
                dc.w    loc_35BE4-off_35A08
                dc.w    loc_35C08-off_35A08
                dc.w    locret_35C2C-off_35A08
; ---------------------------------------------------------------------------

loc_35A18:
                bset    #Status_SpeedShoes,status_secondary(a2)
                move.b  #(10*60)/8,speed_shoes_timer(a2)
                cmpa.w  #Player_1,a2
                bne.s   loc_35A3E
                move.w  #$C00,(Max_speed).w
                move.w  #$18,(Acceleration).w
                move.w  #$80,(Deceleration).w
                bra.s   loc_35A50
; ---------------------------------------------------------------------------

loc_35A3E:
                move.w  #$C00,(Max_speed_P2).w
                move.w  #$18,(Acceleration_P2).w
                move.w  #$80,(Deceleration_P2).w

loc_35A50:
                move.b  #7,anim(a0)
                move.b  #0,collision_flags(a0)
                move.l  #loc_35FAC,d1
                moveq   #9,d2
                bsr.w   CompetitionItemS3ClonePrefixWithHandlerAndAnimation
                rts
; ---------------------------------------------------------------------------

loc_35A6A:
                bset    #Status_SpeedShoes,status_secondary(a2)
                move.b  #(10*60)/8,speed_shoes_timer(a2)
                cmpa.w  #Player_1,a2
                bne.s   loc_35A90
                move.w  #$300,(Max_speed).w
                move.w  #8,(Acceleration).w
                move.w  #$20,(Deceleration).w
                bra.s   loc_35AA2
; ---------------------------------------------------------------------------

loc_35A90:
                move.w  #$300,(Max_speed_P2).w
                move.w  #8,(Acceleration_P2).w
                move.w  #$20,(Deceleration_P2).w

loc_35AA2:
                move.b  #7,anim(a0)
                move.b  #0,collision_flags(a0)
                move.l  #loc_35FAC,d1
                moveq   #9,d2
                bsr.w   CompetitionItemS3ClonePrefixWithHandlerAndAnimation
                rts
; ---------------------------------------------------------------------------

loc_35ABC:
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
                beq.s   loc_35B4C
                move.w  d3,(Max_speed).w
                move.w  d4,(Acceleration).w
                move.w  d5,(Deceleration).w

loc_35B4C:
                btst    #Status_SpeedShoes,status_secondary(a3)
                beq.s   loc_35B60
                move.w  d0,(Max_speed_P2).w
                move.w  d1,(Acceleration_P2).w
                move.w  d2,(Deceleration_P2).w

loc_35B60:
                move.b  #7,anim(a0)
                move.b  #0,collision_flags(a0)
                move.l  #loc_35FAC,d1
                moveq   #9,d2
                bsr.w   CompetitionItemS3ClonePrefixWithHandlerAndAnimation
                rts
; ---------------------------------------------------------------------------

loc_35B7A:
                move.b  #7,anim(a0)
                move.b  #0,collision_flags(a0)
                move.l  #loc_35FAC,d1
                moveq   #8,d2
                bsr.w   CompetitionItemS3ClonePrefixWithHandlerAndAnimation
                cmpa.w  #Player_1,a2
                bne.s   loc_35B9E
                jmp     (GiveRing).l
; ---------------------------------------------------------------------------

loc_35B9E:
                jmp     (GiveRing_Tails).l
; ---------------------------------------------------------------------------

loc_35BA4:
                move.b  #7,anim(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)
                lea     (Breathing_bubbles).w,a1
                tst.l   (a1)
                moveq   #subtype,d0

loc_35BBA:
                move.w  (a0,d0.w),(a1,d0.w)
                subq.w  #2,d0
                bcc.s   loc_35BBA
                move.l  #loc_35C2E,(a1)
                move.b  #4,anim(a1)
                move.w  top_solid_bit(a2),top_solid_bit(a1)
                tst.w   art_tile(a2)
                bpl.s   locret_35BE2
                ori.w   #high_priority,art_tile(a1)

locret_35BE2:
                rts
; ---------------------------------------------------------------------------

loc_35BE4:
                move.b  #7,anim(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)
                move.l  #loc_35C48,d1
                moveq   #5,d2
                bsr.w   CompetitionItemS3ClonePrefixWithHandlerAndAnimation
                bne.s   locret_35C06
                move.w  top_solid_bit(a2),top_solid_bit(a1)

locret_35C06:
                rts
; ---------------------------------------------------------------------------

loc_35C08:
                move.b  #7,anim(a0)
                clr.b   collision_flags(a0)
                clr.b   collision_property(a0)
                move.l  #loc_35C50,d1
                moveq   #6,d2
                bsr.w   CompetitionItemS3ClonePrefixWithHandlerAndAnimation
                bne.s   locret_35C2A
                move.w  top_solid_bit(a2),top_solid_bit(a1)

locret_35C2A:
                rts
; ---------------------------------------------------------------------------

locret_35C2C:
                rts
; ---------------------------------------------------------------------------

loc_35C2E:
                move.w  #-$400,ground_vel(a0)
                move.b  #0,angle(a0)
                move.b  #0,status(a0)
                move.l  #loc_35E3C,d2
                bra.s   loc_35C56
; ---------------------------------------------------------------------------

loc_35C48:
                move.l  #loc_35D54,d2
                bra.s   loc_35C56
; ---------------------------------------------------------------------------

loc_35C50:
                move.l  #loc_35C9E,d2

loc_35C56:
                move.l  d2,-(sp)
                jsr     (MoveSprite).l
                jsr     (ObjCheckFloorDist).l
                move.l  (sp)+,d2
                tst.w   d1
                bpl.s   loc_35C76
                add.w   d1,y_pos(a0)
                move.l  d2,(a0)
                move.b  #$C7,collision_flags(a0)

loc_35C76:
                cmpi.w  #-$100,(Camera_min_Y_pos).w
                bne.s   loc_35C86
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)

loc_35C86:
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$60,d0
                cmp.w   y_pos(a0),d0
                bge.s   loc_35C9A
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_35C9A:
                bra.w   loc_35FAC
; ---------------------------------------------------------------------------

loc_35C9E:
                tst.b   collision_property(a0)
                beq.s   loc_35CC4
                lea     (Player_1).w,a2
                bclr    #0,collision_property(a0)
                beq.s   loc_35CB2
                bsr.s   CompetitionItemS3ApplyPlaneMatchedUpwardFlipLaunch

loc_35CB2:
                lea     (Player_2).w,a2
                bclr    #1,collision_property(a0)
                beq.s   loc_35CC0
                bsr.s   CompetitionItemS3ApplyPlaneMatchedUpwardFlipLaunch

loc_35CC0:
                clr.b   collision_property(a0)

loc_35CC4:
                lea     (Ani_2PItem).l,a1
                jsr     (Animate_Sprite).l
                tst.b   routine(a0)
                beq.s   loc_35CDC
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_35CDC:
                cmpi.b  #9,anim(a0)
                beq.s   loc_35CEA
                jsr     (Add_SpriteToCollisionResponseList).l

loc_35CEA:
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CompetitionItemS3ApplyPlaneMatchedUpwardFlipLaunch:
                move.w  top_solid_bit(a2),d0
                cmp.w   top_solid_bit(a0),d0
                beq.s   loc_35CFC
                rts
; ---------------------------------------------------------------------------

loc_35CFC:
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
                beq.s   loc_35D4C
                neg.b   flip_angle(a2)
                neg.w   ground_vel(a2)

loc_35D4C:
                moveq   #signextendB(sfx_SmallBumpers),d0
                jmp     (Play_SFX).l
; End of function CompetitionItemS3ApplyPlaneMatchedUpwardFlipLaunch

; ---------------------------------------------------------------------------

loc_35D54:
                tst.b   collision_property(a0)
                beq.s   loc_35D7A
                lea     (Player_1).w,a2
                bclr    #0,collision_property(a0)
                beq.s   loc_35D68
                bsr.s   CompetitionItemS3BeginGroundedMomentumTrap

loc_35D68:
                lea     (Player_2).w,a2
                bclr    #1,collision_property(a0)
                beq.s   loc_35D76
                bsr.s   CompetitionItemS3BeginGroundedMomentumTrap

loc_35D76:
                clr.b   collision_property(a0)

loc_35D7A:
                lea     (Ani_2PItem).l,a1
                jsr     (Animate_Sprite).l
                tst.b   $3C(a0)
                beq.s   loc_35DC6
                movea.w $3E(a0),a1
                subq.b  #1,$3C(a0)
                beq.s   loc_35DBA
                move.w  #$20,d1
                move.w  ground_vel(a1),d0
                bpl.s   loc_35DAE
                add.w   d1,ground_vel(a1)
                bcc.s   loc_35DD2
                move.w  #0,ground_vel(a1)
                bra.s   loc_35DBA
; ---------------------------------------------------------------------------

loc_35DAE:
                sub.w   d1,ground_vel(a1)
                bcc.s   loc_35DD2
                move.w  #0,ground_vel(a1)

loc_35DBA:
                move.w  #5,move_lock(a1)
                andi.b  #$7F,status_secondary(a1)

loc_35DC6:
                tst.b   routine(a0)
                beq.s   loc_35DD2
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_35DD2:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CompetitionItemS3BeginGroundedMomentumTrap:
                move.w  top_solid_bit(a2),d0
                cmp.w   top_solid_bit(a0),d0
                bne.s   locret_35E3A
                tst.b   status_secondary(a2)
                bmi.s   locret_35E3A
                btst    #Status_InAir,status(a2)
                bne.s   locret_35E3A
                tst.w   ground_vel(a2)
                beq.s   locret_35E3A
                move.b  #9,anim(a0)
                move.b  #0,collision_flags(a0)
                move.w  #$200,d1
                move.w  ground_vel(a2),d0
                bpl.s   loc_35E16
                neg.w   d0
                neg.w   d1

loc_35E16:
                cmpi.w  #$200,d0
                bhs.s   loc_35E20
                add.w   d1,ground_vel(a2)

loc_35E20:
                asl     ground_vel(a2)
                move.b  #$1B,anim(a2)
                ori.b   #$80,status_secondary(a2)
                move.w  a2,$3E(a0)
                move.b  #$3C,$3C(a0)

locret_35E3A:
                rts
; End of function CompetitionItemS3BeginGroundedMomentumTrap

; ---------------------------------------------------------------------------

loc_35E3C:
                tst.b   collision_property(a0)
                beq.s   loc_35E62
                lea     (Player_1).w,a2
                bclr    #0,collision_property(a0)
                beq.s   loc_35E50
                bsr.s   CompetitionItemS3ExplodeRollingHazardAndAttemptPlayerHurt

loc_35E50:
                lea     (Player_2).w,a2
                bclr    #1,collision_property(a0)
                beq.s   loc_35E5E
                bsr.s   CompetitionItemS3ExplodeRollingHazardAndAttemptPlayerHurt

loc_35E5E:
                clr.b   collision_property(a0)

loc_35E62:
                bsr.w   CompetitionItemS3MoveRollingHazardOnTerrainOrInAir
                move.b  angle(a0),d0
                addi.b  #$10,d0
                lsr.b   #5,d0
                addi.b  #$11,d0
                move.b  d0,mapping_frame(a0)
                move.w  (Camera_max_Y_pos).w,d0
                addi.w  #$60,d0
                cmp.w   y_pos(a0),d0
                bge.s   loc_35E8C
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_35E8C:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

CompetitionItemS3ExplodeRollingHazardAndAttemptPlayerHurt:
                move.w  top_solid_bit(a2),d0
                cmp.w   top_solid_bit(a0),d0
                beq.s   loc_35EA4
                rts
; ---------------------------------------------------------------------------

loc_35EA4:
                move.l  #loc_35FAC,(a0)
                move.b  #$B,anim(a0)
                movea.l a2,a1
                jmp     (HurtPlayerFromSolidHazard).l
; End of function CompetitionItemS3ExplodeRollingHazardAndAttemptPlayerHurt

; =============== S U B R O U T I N E =======================================

CompetitionItemS3MoveRollingHazardOnTerrainOrInAir:
                btst    #1,status(a0)
                bne.s   loc_35F22
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
                bne.s   locret_35F20
                jsr     (ProbeLeftWallUsingYRadius).l
                tst.w   d1
                bpl.s   locret_35F20
                sub.w   d1,x_pos(a0)
                move.l  #loc_35FAC,(a0)
                move.b  #$B,anim(a0)

locret_35F20:
                rts
; ---------------------------------------------------------------------------

loc_35F22:
                subi.w  #$10,x_vel(a0)
                cmpi.w  #-$400,x_vel(a0)
                bgt.s   loc_35F36
                move.w  #-$400,x_vel(a0)

loc_35F36:
                jsr     (MoveSprite).l
                move.w  (Screen_Y_wrap_value).w,d0
                and.w   d0,y_pos(a0)
                move.w  (Screen_X_wrap_value).w,d0
                and.w   d0,x_pos(a0)
                addi.w  #$400,x_pos(a0)
                jsr     (ChkFloorEdge).l
                tst.w   d1
                bpl.s   loc_35F6E
                add.w   d1,y_pos(a0)
                bclr    #1,status(a0)
                move.b  #0,angle(a0)
                rts
; ---------------------------------------------------------------------------

loc_35F6E:
                move.b  angle(a0),d0
                beq.s   loc_35F88
                bpl.s   loc_35F7E
                addq.b  #2,d0
                bcc.s   loc_35F84
                moveq   #0,d0
                bra.s   loc_35F84
; ---------------------------------------------------------------------------

loc_35F7E:
                subq.b  #2,d0
                bcc.s   loc_35F84
                moveq   #0,d0

loc_35F84:
                move.b  d0,angle(a0)

loc_35F88:
                move.b  angle(a0),d0
                bne.s   locret_35FAA
                jsr     (ProbeLeftWallUsingYRadius).l
                tst.w   d1
                bpl.s   locret_35FAA
                sub.w   d1,x_pos(a0)
                move.l  #loc_35FAC,(a0)
                move.b  #$B,anim(a0)
                rts
; ---------------------------------------------------------------------------

locret_35FAA:
                rts
; ---------------------------------------------------------------------------

loc_35FAC:
                lea     (Ani_2PItem).l,a1
                jsr     (Animate_Sprite).l
                tst.b   routine(a0)
                beq.s   loc_35FC4
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_35FC4:
                jmp     (Draw_Sprite).l
; End of function CompetitionItemS3MoveRollingHazardOnTerrainOrInAir

; =============== S U B R O U T I N E =======================================

CompetitionItemS3ClonePrefixWithHandlerAndAnimation:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   locret_35FE8
                moveq   #subtype,d0

loc_35FD6:
                move.w  (a0,d0.w),(a1,d0.w)
                subq.w  #2,d0
                bcc.s   loc_35FD6
                move.l  d1,(a1)
                move.b  d2,anim(a1)
                moveq   #0,d0

locret_35FE8:
                rts
; End of function CompetitionItemS3ClonePrefixWithHandlerAndAnimation

; ---------------------------------------------------------------------------
Ani_2PItem:
                include "src/game/competition/shared/animations/item.s"
Map_2PItem:
                include "src/game/competition/shared/mappings/item.s"
