; Owner: game/level/sk
; Responsibility: Active-character loading, level-owned HUD and power-up creation, and player spawn setup
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

LevelLoad_ActiveCharacter:
                cmpi.b  #GameMode_Demo+$80,(Game_mode).w
                beq.s   loc_67CC
                tst.w   (Competition_mode).w
                bne.s   loc_67CC
                move.w  (Player_option).w,(Player_mode).w  ; Move selected character to active character
                rts
; ---------------------------------------------------------------------------

loc_67CC:
                move.w  #3,(Player_mode).w              ; If loading a demo OR 2P mode enabled (?)
                cmpi.b  #7,(Current_zone).w
                beq.s   locret_67EC
                move.w  #0,(Player_mode).w
                tst.w   (SK_alone_flag).w
                beq.s   locret_67EC
                move.w  #1,(Player_mode).w

locret_67EC:
                rts
; End of function LevelLoad_ActiveCharacter

; =============== S U B R O U T I N E =======================================

SpawnLevelMainSprites:
                move.l  #Obj_ResetCollisionResponseList,(Reserved_object_3).w
                bsr.w   SpawnLevelMainSprites_SpawnPlayers
                bsr.w   SpawnLevelMainSprites_SpawnPowerup
                tst.b   (Last_star_post_hit).w
                bne.w   locret_69B6
                tst.b   (Special_bonus_entry_flag).w
                bne.w   locret_69B6
                lea     (Player_1).w,a1
                lea     (Player_2).w,a2
                cmpi.w  #0,(Current_zone_and_act).w
                bne.s   loc_6834
                cmpi.w  #2,(Player_mode).w
                bhs.s   locret_6832
                move.l  #Obj_AIZPlaneIntro,(Dynamic_object_RAM+(object_size*2)).w
                clr.b   (Level_started_flag).w

locret_6832:
                rts
; ---------------------------------------------------------------------------

loc_6834:
                cmpi.w  #$100,(Current_zone_and_act).w
                bne.s   loc_6886
                move.b  #$1B,anim(a1)
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_685C
                move.w  #($21<<8)|$21,anim(a1)          ; and prev_anim
                move.b  #1,anim_frame(a1)
; Bug: this tries to clear Knuckles' anim_frame_timer, but Knuckles is in a1
                move.b  #0,anim_frame_timer(a0)

loc_685C:
                bset    #Status_InAir,status(a1)
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_6870
                move.b  #1,jumping(a1)

loc_6870:
                tst.l   (a2)
                beq.s   loc_6886
                move.b  #$1B,anim(a2)
                bset    #Status_InAir,status(a2)
                move.b  #1,jumping(a2)

loc_6886:
                cmpi.w  #$900,(Current_zone_and_act).w
                bne.s   loc_6896
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_68A6

loc_6896:
                cmpi.w  #$1600,(Current_zone_and_act).w
                beq.s   loc_68A6
                cmpi.w  #$200,(Current_zone_and_act).w
                bne.s   loc_68C2

loc_68A6:
                move.b  #$1B,anim(a1)
                bset    #Status_InAir,status(a1)
                tst.l   (a2)
                beq.s   loc_68C2
                move.b  #$1B,anim(a2)
                bset    #Status_InAir,status(a2)

loc_68C2:
                cmpi.w  #$700,(Current_zone_and_act).w
                bne.s   loc_68D0
                tst.w   (SK_alone_flag).w
                beq.s   loc_68D8

loc_68D0:
                cmpi.w  #$300,(Current_zone_and_act).w
                bne.s   loc_690A

loc_68D8:
                cmpi.w  #1,(Player_mode).w
                bne.s   loc_68FC
                move.l  #Obj_Tails,(Player_2).w
                move.w  (Player_1+x_pos).w,(Player_2+x_pos).w
                move.w  (Player_1+y_pos).w,(Player_2+y_pos).w
                move.w  #0,(Tails_CPU_routine).w
                bra.s   loc_690A
; ---------------------------------------------------------------------------

loc_68FC:
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_690A
                move.w  #$20,(Tails_CPU_routine).w

loc_690A:
                cmpi.w  #$500,(Current_zone_and_act).w
                bne.s   loc_692E
                cmpi.w  #2,(Player_mode).w
                blo.s   loc_6926
                bne.s   loc_692E
                move.l  #Obj_LevelIntroICZ1Tails,(Dynamic_object_RAM+(object_size*2)).w
                bra.s   loc_692E
; ---------------------------------------------------------------------------

loc_6926:
                move.l  #Obj_LevelIntroICZ1,(Dynamic_object_RAM+(object_size*2)).w

loc_692E:
                cmpi.w  #$600,(Current_zone_and_act).w
                bne.s   loc_693E
                move.l  #Obj_LevelIntro_PlayerLaunchFromGround,(Dynamic_object_RAM+(object_size*2)).w

loc_693E:
                cmpi.w  #$700,(Current_zone_and_act).w
                bne.s   loc_695A
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_695A
                move.b  #$1B,anim(a1)
                bset    #Status_InAir,status(a1)

loc_695A:
                cmpi.w  #$800,(Current_zone_and_act).w
                bne.s   loc_6986
                move.l  #Obj_LevelIntro_PlayerFallIntoGround,(Dynamic_object_RAM+(object_size*2)).w
                move.b  #2,anim(a1)
                bset    #Status_InAir,status(a1)
                tst.l   (a2)
                beq.s   loc_6986
                move.b  #2,anim(a2)
                bset    #Status_InAir,status(a2)

loc_6986:
                cmpi.w  #$300,(Current_zone_and_act).w
                beq.s   loc_69A6
                cmpi.w  #$B00,(Current_zone_and_act).w
                beq.s   loc_69AE
                cmpi.w  #$1601,(Current_zone_and_act).w
                beq.s   loc_69AE
                cmpi.w  #$900,(Current_zone_and_act).w
                bne.s   locret_69B6

loc_69A6:
                cmpi.w  #3,(Player_mode).w
                bne.s   locret_69B6

loc_69AE:
                move.l  #Obj_LevelIntro_PlayerRun,(Dynamic_object_RAM+(object_size*2)).w

locret_69B6:
                rts
; End of function SpawnLevelMainSprites

; =============== S U B R O U T I N E =======================================

SpawnLevelMainSprites_SpawnPowerup:
                cmpi.w  #$D01,(Current_zone_and_act).w
                beq.s   locret_6A00
                cmpi.b  #$13,(Current_zone).w
                beq.s   loc_69E0
                cmpi.b  #$14,(Current_zone).w
                beq.s   loc_69E0
                cmpi.b  #$16,(Current_zone).w
                bhs.s   loc_69E0
                cmpi.b  #$E,(Current_zone).w
                bhs.s   locret_6A00

loc_69E0:
                lea     (Player_1).w,a1
                move.b  (Saved_status_secondary).w,d0
                clr.b   (Saved_status_secondary).w
                andi.b  #(1<<Status_FireShield)|(1<<Status_LtngShield)|(1<<Status_BublShield),d0
                bne.s   loc_6A02
                move.b  (Saved2_status_secondary).w,d0
                clr.b   (Saved2_status_secondary).w
                andi.b  #(1<<Status_FireShield)|(1<<Status_LtngShield)|(1<<Status_BublShield),d0
                bne.s   loc_6A02

locret_6A00:
                rts
; ---------------------------------------------------------------------------

loc_6A02:
                btst    #Status_FireShield,d0
                beq.s   loc_6A28
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                bset    #Status_FireShield,status_secondary(a1)
                move.l  #Obj_FireShield,(Shield).w
                move.w  a1,(Shield+parent).w
                rts
; ---------------------------------------------------------------------------

loc_6A28:
                btst    #Status_LtngShield,d0
                beq.s   loc_6A4E
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                bset    #Status_LtngShield,status_secondary(a1)
                move.l  #Obj_LightningShield,(Shield).w
                move.w  a1,(Shield+parent).w
                rts
; ---------------------------------------------------------------------------

loc_6A4E:
                btst    #Status_BublShield,d0
                beq.s   locret_6A74
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                bset    #Status_BublShield,status_secondary(a1)
                move.l  #Obj_BubbleShield,(Shield).w
                move.w  a1,(Shield+parent).w
                rts
; ---------------------------------------------------------------------------

locret_6A74:
                rts
; End of function SpawnLevelMainSprites_SpawnPowerup

; =============== S U B R O U T I N E =======================================

SpawnLevelMainSprites_SpawnPlayers:
                cmpi.w  #$1300,(Current_zone_and_act).w
                blo.s   loc_6A8A
                cmpi.w  #$1600,(Current_zone_and_act).w
                bhs.s   loc_6A8A
                clr.b   (Update_HUD_timer).w

loc_6A8A:
                cmpi.w  #$1400,(Current_zone_and_act).w
                bne.s   loc_6AB8
                move.l  #Obj_PachinkoEnergyTrap,(Dynamic_object_RAM+(object_size*2)).w
                move.w  #$78,(Dynamic_object_RAM+(object_size*2)+x_pos).w
                move.w  #$F30,(Dynamic_object_RAM+(object_size*2)+y_pos).w
                move.w  (Saved_ring_count).w,(Ring_count).w
                move.b  (Saved_extra_life_flags).w,(Extra_life_flags).w
                move.b  #1,(Update_HUD_ring_count).w

loc_6AB8:
                cmpi.b  #$15,(Current_zone).w
                beq.w   loc_6B76
                tst.w   (Competition_mode).w
                bne.w   loc_6B94
                move.w  (Player_mode).w,d0
                bne.s   loc_6B1E
                move.l  #Obj_Sonic,(Player_1).w
                move.l  #Obj_DashDust,(Dust).w
                move.l  #Obj_InstaShield,(Shield).w
                move.w  #Player_1,(Shield+parent).w
                move.l  #Obj_Tails,(Player_2).w
                move.w  (Player_1+x_pos).w,(Player_2+x_pos).w
                move.w  (Player_1+y_pos).w,(Player_2+y_pos).w
                subi.w  #$20,(Player_2+x_pos).w
                addi.w  #4,(Player_2+y_pos).w
                move.l  #Obj_DashDust,(Dust_P2).w
                move.w  #0,(Tails_CPU_routine).w
                rts
; ---------------------------------------------------------------------------

loc_6B1E:
                subq.w  #1,d0
                bne.s   loc_6B42
                move.l  #Obj_Sonic,(Player_1).w
                move.l  #Obj_DashDust,(Dust).w
                move.l  #Obj_InstaShield,(Shield).w
                move.w  #Player_1,(Shield+parent).w
                rts
; ---------------------------------------------------------------------------

loc_6B42:
                subq.w  #1,d0
                bne.s   loc_6B64
                move.l  #Obj_Tails,(Player_1).w
                move.l  #Obj_DashDust,(Dust_P2).w
                addi.w  #4,(Player_1+y_pos).w
                move.w  #0,(Tails_CPU_routine).w
                rts
; ---------------------------------------------------------------------------

loc_6B64:
                move.l  #Obj_Knuckles,(Player_1).w
                move.l  #Obj_DashDust,(Dust).w
                rts
; ---------------------------------------------------------------------------

loc_6B76:
                moveq   #0,d0
                move.b  d0,(SStage_scalar_result_0+2).w
                move.w  d0,(SStage_scalar_result_0).w
                move.l  #Obj_Sonic_RotatingSlotBonus,(Player_1).w
                jsr     (SlotsInitializePaddedLayoutDescriptorsAndCage).l
                st      (Deform_lock).w
                rts
; ---------------------------------------------------------------------------

loc_6B94:
                move.b  (P1_character).w,d0
                bsr.s   SKComp_SelectPlayerHandler
                move.l  d1,(Player_1).w
                move.b  (P1_character).w,(Player_1+character_id).w
                move.w  (Player_1+x_pos).w,(Player_2+x_pos).w
                move.w  (Player_1+y_pos).w,(Player_2+y_pos).w
                move.l  #Obj_DashDust2P,(Dust).w
                tst.b   (Not_ghost_flag).w
                beq.s   loc_6BD6
                move.b  (P2_character).w,d0
                bsr.s   SKComp_SelectPlayerHandler
                move.l  d1,(Player_2).w
                move.b  (P2_character).w,(Player_2+character_id).w
                move.l  #Obj_DashDust2P,(Dust_P2).w

loc_6BD6:
                bra.s   loc_6BF6
; End of function SpawnLevelMainSprites_SpawnPlayers

; =============== S U B R O U T I N E =======================================

; Character byte 1 selects Tails2P. Every other value selects Sonic2P
SKComp_SelectPlayerHandler:
                tst.b   d0
                bne.s   loc_6BE2
                move.l  #Obj_Sonic2P,d1

loc_6BE2:
                subq.b  #1,d0
                bne.s   loc_6BEE
                move.l  #Obj_Tails2P,d1
                rts
; ---------------------------------------------------------------------------

loc_6BEE:
                move.l  #Obj_Sonic2P,d1
                rts
; End of function SKComp_SelectPlayerHandler

; ---------------------------------------------------------------------------

loc_6BF6:
                lea     (Target_palette_line_2).w,a2
                lea     (Pal_Level_2P).l,a1
                move.w  #bytesToWcnt($20),d0

loc_6C04:
                move.w  (a1)+,(a2)+
                dbf     d0,loc_6C04
                rts
