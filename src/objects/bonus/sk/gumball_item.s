; Owner: objects/bonus/sk
; Responsibility: Gumball item collection, effect selection, player response and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_GumballItem:
                move.l  #PachinkoGumball_ConsumeContactsAndDraw,(a0)

PachinkoGumball_InitSubtypeMapping:
                move.l  #Map_PachinkoFItem,mappings(a0)
                move.w  #make_art_tile(ArtTile_PachinkoMain+$AB,3,0),art_tile(a0)
                move.b  subtype(a0),d0
                beq.s   PachinkoGumball_SetStationaryContact
                move.l  #Map_GumballBonus,mappings(a0)
                move.w  #make_art_tile(ArtTile_PachinkoGumballs,0,0),art_tile(a0)
                addq.b  #7,d0
                move.b  d0,mapping_frame(a0)

PachinkoGumball_SetStationaryContact:
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$200,priority(a0)
                move.b  #$D7,collision_flags(a0)

; A scheduled deletion does not skip the current cull and draw path
PachinkoGumball_ConsumeContactsAndDraw:
                tst.b   collision_property(a0)
                beq.s   PachinkoGumball_CullBeforeContactDraw
                bsr.s   PachinkoGumball_ConsumeBothContacts

PachinkoGumball_CullBeforeContactDraw:
                move.w  y_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_Y_pos_coarse_back).w,d0
                cmpi.w  #$200,d0
                bhi.w   PachinkoGumball_ReleaseRespawnOnCull
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

PachinkoGumball_ReleaseRespawnOnCull:
                move.w  respawn_addr(a0),d0
                beq.s   PachinkoGumball_DeleteAfterCull
                movea.w d0,a2
                bclr    #7,(a2)

PachinkoGumball_DeleteAfterCull:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

PachinkoGumball_ConsumeBeforeMove:
                tst.b   collision_property(a0)
                beq.s   PachinkoGumball_MoveThenAccelerateUp
                bsr.s   PachinkoGumball_ConsumeBothContacts

PachinkoGumball_MoveThenAccelerateUp:
                jsr     (MoveSprite2).l
                subi.w  #4,y_vel(a0)
                bra.s   PachinkoGumball_CullBeforeContactDraw

; =============== S U B R O U T I N E =======================================

; Apply the reward for each queued player in order, even when the first schedules deletion
PachinkoGumball_ConsumeBothContacts:
                lea     (Player_1).w,a1
                bclr    #0,collision_property(a0)
                beq.s   PachinkoGumball_CheckSecondContact
                bsr.s   PachinkoGumball_DeleteAndApplyReward

PachinkoGumball_CheckSecondContact:
                lea     (Player_2).w,a1
                bclr    #1,collision_property(a0)
                beq.s   PachinkoGumball_ClearContactBits
                bsr.s   PachinkoGumball_DeleteAndApplyReward

PachinkoGumball_ClearContactBits:
                clr.b   collision_property(a0)
                rts
; End of function PachinkoGumball_ConsumeBothContacts

; =============== S U B R O U T I N E =======================================

; Subtype chooses a height-based ring award, a sound-only result or a shared gumball effect
PachinkoGumball_DeleteAndApplyReward:
                move.l  #Delete_Current_Sprite,(a0)
                moveq   #0,d1
                moveq   #1,d2
                move.b  subtype(a0),d1
                cmpi.b  #3,d1
                beq.s   PachinkoGumball_AwardRingsByYBand
                cmpi.b  #2,d1
                beq.s   PachinkoGumball_PlayBumperForType0Or2
                subq.w  #1,d1
                bcs.s   PachinkoGumball_PlayBumperForType0Or2
                moveq   #0,d0
                move.w  a1,d0
                jmp     (SKGumball_DispatchRewardType).l
; ---------------------------------------------------------------------------

PachinkoGumball_PlayBumperForType0Or2:
                moveq   #signextendB(sfx_SmallBumpers),d0
                jsr     (Play_SFX).l
                rts
; ---------------------------------------------------------------------------

PachinkoGumball_AwardRingsByYBand:
                move.b  y_pos(a0),d0
                andi.w  #$F,d0
                lea     (SKPachinko_HighYBandRingAwardBytes).l,a1
                move.b  (a1,d0.w),d0
                add.w   d0,(Saved_ring_count).w
                jmp     (AddRings).l
; End of function PachinkoGumball_DeleteAndApplyReward

; ---------------------------------------------------------------------------
Map_PachinkoFItem:
                include "src/objects/shared/zones/pachinko/mappings/f_item.s"
