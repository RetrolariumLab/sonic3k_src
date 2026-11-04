; Owner: objects/zones/lbz/sk
; Responsibility: Launch Base alarm initialization, animation and player-triggered state
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZAlarm:
                move.b  #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #$D7,collision_flags(a0)
                move.l  #SKLBZAlarm_TickAlarmOrCheckContact,(a0)

SKLBZAlarm_TickAlarmOrCheckContact:
                tst.w   $30(a0)
                beq.s   SKLBZAlarm_TryStartAlarm
                subq.w  #1,$30(a0)
                bne.s   SKLBZAlarm_TrySpawnDelayedFlybot
                move.w  #0,(Anim_Counters+4).w
                bra.s   SKLBZAlarm_AddContactAndCull
; ---------------------------------------------------------------------------

SKLBZAlarm_TryStartAlarm:
                tst.b   collision_property(a0)
                beq.s   SKLBZAlarm_AddContactAndCull
                clr.b   collision_property(a0)
                move.w  #$81,$30(a0)
                move.w  #1,(Anim_Counters+4).w
                btst    #0,subtype(a0)
                bne.s   SKLBZAlarm_ActivationReturn

; =============== S U B R O U T I N E =======================================

SpawnLbzAlarmFlybot:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKLBZAlarm_ActivationReturn
                move.l  #Obj_Flybot767,(a1)
                lea     (Player_1).w,a2
                move.w  x_pos(a2),x_pos(a1)
                move.w  y_pos(a2),y_pos(a1)
                move.b  subtype(a0),d0
                add.w   d0,d0
                add.w   d0,d0
                andi.w  #$C,d0
                move.l  SKLBZAlarm_FlybotSpawnOffsets(pc,d0.w),d0
                add.w   d0,y_pos(a1)
                swap    d0
                add.w   d0,x_pos(a1)

SKLBZAlarm_ActivationReturn:
                rts
; End of function SpawnLbzAlarmFlybot

; ---------------------------------------------------------------------------

SKLBZAlarm_TrySpawnDelayedFlybot:
                btst    #0,subtype(a0)
                beq.s   SKLBZAlarm_TryPlayAlarmSound
                cmpi.w  #$41,$30(a0)
                bne.s   SKLBZAlarm_TryPlayAlarmSound
                bsr.s   SpawnLbzAlarmFlybot

SKLBZAlarm_TryPlayAlarmSound:
                move.w  $30(a0),d0
                andi.b  #$1F,d0
                bne.s   SKLBZAlarm_AlarmSoundReturn
                moveq   #signextendB(sfx_Alarm),d0
                jsr     (Play_SFX).l

SKLBZAlarm_AlarmSoundReturn:
                rts
; ---------------------------------------------------------------------------

SKLBZAlarm_AddContactAndCull:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------
SKLBZAlarm_FlybotSpawnOffsets:
                dc.w    $C0,  -$60
                dc.w    $C0,  -$60
                dc.w    -$C0,  -$60
                dc.w    -$C0,  -$60
