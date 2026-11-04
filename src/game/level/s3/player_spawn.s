; Owner: game/level/s3
; Responsibility: Active-character loading, level-owned HUD and power-up creation, and player spawn setup
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

LevelLoad_ActiveCharacter:
                cmpi.b  #GameMode_Demo+$80,(Game_mode).w
                beq.s   loc_4DAE
                tst.w   (Competition_mode).w
                bne.s   loc_4DAE
                move.w  (Player_option).w,(Player_mode).w  ; Move selected character to active character
                rts
; ---------------------------------------------------------------------------

loc_4DAE:
                move.w  #0,(Player_mode).w
                rts
; End of function LevelLoad_ActiveCharacter

; =============== S U B R O U T I N E =======================================

SpawnLevelMainSprites:
                move.l  #Obj_ResetCollisionResponseList,(Reserved_object_3).w
                bsr.w   SpawnLevelMainSprites_SpawnPlayers
                bsr.w   SpawnLevelMainSprites_SpawnPowerup
                tst.b   (Last_star_post_hit).w
                bne.w   locret_4EC6
                tst.b   (Special_bonus_entry_flag).w
                bne.w   locret_4EC6
                lea     (Player_1).w,a1
                lea     (Player_2).w,a2
                cmpi.w  #0,(Current_zone_and_act).w
                bne.s   loc_4DFE
                cmpi.w  #2,(Player_mode).w
                beq.s   locret_4DFC
                move.l  #Obj_AIZPlaneIntro,(Dynamic_object_RAM+(object_size*2)).w
                clr.b   (Level_started_flag).w
                rts
; ---------------------------------------------------------------------------

locret_4DFC:
                rts
; ---------------------------------------------------------------------------

loc_4DFE:
                cmpi.w  #$100,(Current_zone_and_act).w
                bne.s   loc_4E36
                move.b  #$1B,anim(a1)
                bset    #Status_InAir,status(a1)
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_4E20
                move.b  #1,jumping(a1)

loc_4E20:
                tst.l   (a2)
                beq.s   loc_4E36
                move.b  #$1B,anim(a2)
                bset    #Status_InAir,status(a2)
                move.b  #1,jumping(a2)

loc_4E36:
                cmpi.w  #$200,(Current_zone_and_act).w
                bne.s   loc_4E5A
                move.b  #$1B,anim(a1)
                bset    #Status_InAir,status(a1)
                tst.l   (a2)
                beq.s   loc_4E5A
                move.b  #$1B,anim(a2)
                bset    #Status_InAir,status(a2)

loc_4E5A:
                cmpi.w  #$300,(Current_zone_and_act).w
                bne.s   loc_4E94
                cmpi.w  #1,(Player_mode).w
                bne.s   loc_4E86
                move.l  #Obj_Tails,(Player_2).w
                move.w  (Player_1+x_pos).w,(Player_2+x_pos).w
                move.w  (Player_1+y_pos).w,(Player_2+y_pos).w
                move.w  #0,(Tails_CPU_routine).w
                bra.s   loc_4E94
; ---------------------------------------------------------------------------

loc_4E86:
                cmpi.w  #2,(Player_mode).w
                bne.s   loc_4E94
                move.w  #$20,(Tails_CPU_routine).w

loc_4E94:
                cmpi.w  #$500,(Current_zone_and_act).w
                bne.s   loc_4EB6
                cmpi.w  #2,(Player_mode).w
                blo.s   loc_4EAE
                move.l  #Obj_LevelIntroICZ1Tails,(Dynamic_object_RAM+(object_size*2)).w
                bra.s   loc_4EB6
; ---------------------------------------------------------------------------

loc_4EAE:
                move.l  #Obj_LevelIntroICZ1,(Dynamic_object_RAM+(object_size*2)).w

loc_4EB6:
                cmpi.w  #$600,(Current_zone_and_act).w
                bne.s   locret_4EC6
                move.l  #Obj_LevelIntro_PlayerLaunchFromGround,(Dynamic_object_RAM+(object_size*2)).w

locret_4EC6:
                rts
; End of function SpawnLevelMainSprites

; =============== S U B R O U T I N E =======================================

SpawnLevelMainSprites_SpawnPowerup:
                cmpi.b  #$E,(Current_zone).w
                bhs.s   locret_4EF0
                lea     (Player_1).w,a1
                move.b  (Saved_status_secondary).w,d0
                clr.b   (Saved_status_secondary).w
                andi.b  #(1<<Status_FireShield)|(1<<Status_LtngShield)|(1<<Status_BublShield),d0
                bne.s   loc_4EF2
                move.b  (Saved2_status_secondary).w,d0
                clr.b   (Saved2_status_secondary).w
                andi.b  #(1<<Status_FireShield)|(1<<Status_LtngShield)|(1<<Status_BublShield),d0
                bne.s   loc_4EF2

locret_4EF0:
                rts
; ---------------------------------------------------------------------------

loc_4EF2:
                btst    #Status_FireShield,d0
                beq.s   loc_4F18
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                bset    #Status_FireShield,status_secondary(a1)
                move.l  #Obj_FireShield,(Shield).w
                move.w  a1,(Shield+parent).w
                rts
; ---------------------------------------------------------------------------

loc_4F18:
                btst    #Status_LtngShield,d0
                beq.s   loc_4F3E
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                bset    #Status_LtngShield,status_secondary(a1)
                move.l  #Obj_LightningShield,(Shield).w
                move.w  a1,(Shield+parent).w
                rts
; ---------------------------------------------------------------------------

loc_4F3E:
                btst    #Status_BublShield,d0
                beq.s   locret_4F64
                andi.b  #$8E,status_secondary(a1)
                bset    #Status_Shield,status_secondary(a1)
                bset    #Status_BublShield,status_secondary(a1)
                move.l  #Obj_BubbleShield,(Shield).w
                move.w  a1,(Shield+parent).w
                rts
; ---------------------------------------------------------------------------

locret_4F64:
                rts
; End of function SpawnLevelMainSprites_SpawnPowerup

; =============== S U B R O U T I N E =======================================

SpawnLevelMainSprites_SpawnPlayers:
                tst.w   (Competition_mode).w
                bne.w   loc_501A
                move.w  (Player_mode).w,d0
                bne.s   loc_4FC2
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

loc_4FC2:
                subq.w  #1,d0
                bne.s   loc_4FE6
                move.l  #Obj_Sonic,(Player_1).w
                move.l  #Obj_DashDust,(Dust).w
                move.l  #Obj_InstaShield,(Shield).w
                move.w  #Player_1,(Shield+parent).w
                rts
; ---------------------------------------------------------------------------

loc_4FE6:
                subq.w  #1,d0
                bne.s   loc_5008
                move.l  #Obj_Tails,(Player_1).w
                move.l  #Obj_DashDust,(Dust_P2).w
                addi.w  #4,(Player_1+y_pos).w
                move.w  #0,(Tails_CPU_routine).w
                rts
; ---------------------------------------------------------------------------

loc_5008:
                move.l  #Obj_Sonic,(Player_1).w
                move.l  #Obj_DashDust,(Dust).w
                rts
; ---------------------------------------------------------------------------

loc_501A:
                move.b  (P1_character).w,d0
                bsr.s   S3Comp_SelectPlayerHandler
                move.l  d1,(Player_1).w
                move.b  (P1_character).w,(Player_1+character_id).w
                move.w  (Player_1+x_pos).w,(Player_2+x_pos).w
                move.w  (Player_1+y_pos).w,(Player_2+y_pos).w
                move.l  #Obj_DashDust2P,(Dust).w
                tst.b   (Not_ghost_flag).w
                beq.s   loc_505C
                move.b  (P2_character).w,d0
                bsr.s   S3Comp_SelectPlayerHandler
                move.l  d1,(Player_2).w
                move.b  (P2_character).w,(Player_2+character_id).w
                move.l  #Obj_DashDust2P,(Dust_P2).w

loc_505C:
                bra.s   loc_507C
; End of function SpawnLevelMainSprites_SpawnPlayers

; =============== S U B R O U T I N E =======================================

; Character byte 1 selects Tails2P. Every other value selects Sonic2P
S3Comp_SelectPlayerHandler:
                tst.b   d0
                bne.s   loc_5068
                move.l  #Obj_Sonic2P,d1

loc_5068:
                subq.b  #1,d0
                bne.s   loc_5074
                move.l  #Obj_Tails2P,d1
                rts
; ---------------------------------------------------------------------------

loc_5074:
                move.l  #Obj_Sonic2P,d1
                rts
; End of function S3Comp_SelectPlayerHandler

; ---------------------------------------------------------------------------

loc_507C:
                lea     (Target_palette_line_2).w,a2
                lea     (Pal_Level_2P).l,a1
                move.w  #bytesToWcnt(Target_palette_line_3-Target_palette_line_2),d0

loc_508A:
                move.w  (a1)+,(a2)+
                dbf     d0,loc_508A
                rts
