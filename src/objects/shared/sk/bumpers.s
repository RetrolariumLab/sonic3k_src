; Owner: objects/shared/sk
; Responsibility: Shared bumper response, competition and product-specific bonus variants and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_Bumper:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.b  #$D7,collision_flags(a0)
                move.w  x_pos(a0),$30(a0)
                move.w  y_pos(a0),$32(a0)
                cmpi.b  #$14,(Current_zone).w
                bne.s   loc_32E3C
                move.l  #Map_PachinkoBumper,mappings(a0)
                move.w  #make_art_tile(ArtTile_PachinkoMain,3,0),art_tile(a0)
                move.l  #loc_32EF0,(a0)
                bra.w   loc_32EF0
; ---------------------------------------------------------------------------

loc_32E3C:
                tst.w   (Competition_mode).w
                beq.s   loc_32E5A
                move.l  #Map_2PBumper,mappings(a0)
                move.w  #make_art_tile(ArtTile_BPZMisc,1,0),art_tile(a0)
                move.l  #loc_32FF0,(a0)
                bra.w   loc_32FF0
; ---------------------------------------------------------------------------

loc_32E5A:
                move.l  #Map_Bumper,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$13,2,0),art_tile(a0)
                move.l  #loc_32EAA,(a0)
                move.b  subtype(a0),d0
                beq.s   loc_32EAA
                move.b  d0,angle(a0)
                move.l  #loc_32E7E,(a0)

loc_32E7E:
                move.b  (Level_frame_counter+1).w,d0
                btst    #0,status(a0)
                beq.s   loc_32E8C
                neg.b   d0

loc_32E8C:
                add.b   angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d1
                asr.w   #2,d0
                add.w   $30(a0),d1
                add.w   $32(a0),d0
                move.w  d1,x_pos(a0)
                move.w  d0,y_pos(a0)

loc_32EAA:
                tst.b   collision_property(a0)
                beq.s   loc_32EB4
                bsr.w   ReboundPlayersTouchingBumper

loc_32EB4:
                lea     (Ani_Bumper).l,a1
                jsr     (Animate_Sprite).l
                move.w  $30(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_32EDE
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_32EDE:
                move.w  respawn_addr(a0),d0
                beq.s   loc_32EEA
                movea.w d0,a2
                bclr    #7,(a2)

loc_32EEA:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_32EF0:
                tst.b   collision_property(a0)
                beq.s   loc_32EF8
                bsr.s   ReboundPlayersTouchingBumper

loc_32EF8:
                lea     (Ani_Bumper).l,a1
                jsr     (Animate_Sprite).l
                move.w  y_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_Y_pos_coarse_back).w,d0
                cmpi.w  #$200,d0
                bhi.s   loc_32F22
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_32F22:
                move.w  respawn_addr(a0),d0
                beq.s   loc_32F2E
                movea.w d0,a2
                bclr    #7,(a2)

loc_32F2E:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

ReboundPlayersTouchingBumper:
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   loc_32F42
                bsr.s   ReboundPlayerFromBumperAndAwardScore

loc_32F42:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   loc_32F50
                bsr.s   ReboundPlayerFromBumperAndAwardScore

loc_32F50:
                clr.b   collision_property(a0)
                rts
; End of function ReboundPlayersTouchingBumper

; =============== S U B R O U T I N E =======================================

ReboundPlayerFromBumperAndAwardScore:
                move.w  x_pos(a0),d1
                move.w  y_pos(a0),d2
                sub.w   x_pos(a1),d1
                sub.w   y_pos(a1),d2
                jsr     (GetArcTan).l
                move.b  (Level_frame_counter).w,d1
                andi.w  #3,d1
                add.w   d1,d0
                jsr     (GetSineCosine).l
                muls.w  #-$700,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a1)
                muls.w  #-$700,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                bclr    #Status_Push,status(a1)
                clr.b   jumping(a1)
                move.b  #1,anim(a0)
                moveq   #signextendB(sfx_Bumper),d0
                jsr     (Play_SFX).l
                move.w  respawn_addr(a0),d0
                beq.s   loc_32FC4
                movea.w d0,a2
                cmpi.b  #$8A,(a2)
                bhs.s   locret_32FEE
                addq.b  #1,(a2)

loc_32FC4:
                moveq   #1,d0
                movea.w a1,a3
                jsr     (HUD_AddToScore).l
                jsr     (AllocateObject).l
                bne.s   locret_32FEE
                move.l  #Obj_EnemyScore,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  #4,mapping_frame(a1)

locret_32FEE:
                rts
; End of function ReboundPlayerFromBumperAndAwardScore

; ---------------------------------------------------------------------------

loc_32FF0:
                tst.b   collision_property(a0)
                beq.w   loc_3307C
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   loc_33006
                bsr.s   ReboundPlayerFromCompetitionBumper

loc_33006:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   loc_33014
                bsr.s   ReboundPlayerFromCompetitionBumper

loc_33014:
                clr.b   collision_property(a0)
                bra.w   loc_3307C

; =============== S U B R O U T I N E =======================================

ReboundPlayerFromCompetitionBumper:
                move.w  x_pos(a0),d1
                move.w  y_pos(a0),d2
                sub.w   x_pos(a1),d1
                sub.w   y_pos(a1),d2
                jsr     (GetArcTan).l
                move.b  (Level_frame_counter).w,d1
                andi.w  #3,d1
                add.w   d1,d0
                jsr     (GetSineCosine).l
                muls.w  #-$700,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a1)
                muls.w  #-$700,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                bclr    #Status_Push,status(a1)
                clr.b   jumping(a1)
                move.b  #1,anim(a0)
                moveq   #signextendB(sfx_SmallBumpers),d0
                jsr     (Play_SFX).l
                rts
; End of function ReboundPlayerFromCompetitionBumper

; ---------------------------------------------------------------------------

loc_3307C:
                lea     (Ani_Bumper).l,a1
                jsr     (Animate_Sprite).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Ani_Bumper:
                include "src/objects/shared/level_misc/animations/bumper.s"
Map_PachinkoBumper:
                include "src/objects/shared/zones/pachinko/mappings/bumper.s"
