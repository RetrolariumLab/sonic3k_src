; Owner: objects/effects/sk
; Responsibility: Explosion, fire-shield dissipation and delayed explosion state families with their shared mapping
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_Explosion:                                          ; this object is reused from prev title
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Explosion_Index(pc,d0.w),d1
                jmp     Explosion_Index(pc,d1.w)
; ---------------------------------------------------------------------------
Explosion_Index:
                dc.w    SKExplosion_TrySpawnAnimal-Explosion_Index
                dc.w    SKExplosion_PlayBreakAndInit-Explosion_Index
                dc.w    SKExplosion_TickUntilFrame5-Explosion_Index
                dc.w    SKExplosion_InitVisuals-Explosion_Index
; ---------------------------------------------------------------------------

SKExplosion_TrySpawnAnimal:
                addq.b  #2,routine(a0)
                jsr     (AllocateObject).l
                bne.s   SKExplosion_PlayBreakAndInit
                move.l  #Obj_Animal,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  $3E(a0),$3E(a1)                 ; $3E is copied all the way from touch response in here (value didn't change for the variable same as sonic 2)

SKExplosion_PlayBreakAndInit:
                moveq   #signextendB(sfx_Break),d0
                jsr     (Play_SFX).l
                addq.b  #2,routine(a0)

SKExplosion_InitVisuals:
                move.l  #Map_Explosion,mappings(a0)
                move.w  art_tile(a0),d0
                andi.w  #high_priority,d0
                ori.w   #make_art_tile(ArtTile_Explosion,0,0),d0
                move.w  d0,art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$80,priority(a0)
                move.b  #0,collision_flags(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #3,anim_frame_timer(a0)
                move.b  #0,mapping_frame(a0)
                move.l  #SKExplosion_TickUntilFrame5,(a0)

SKExplosion_TickUntilFrame5:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKExplosion_DrawNormal
                move.b  #7,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #5,mapping_frame(a0)
                beq.w   Delete_Current_Sprite

SKExplosion_DrawNormal:
                jmp     (Draw_Sprite).l
; End of function Obj_Explosion
; ---------------------------------------------------------------------------

Obj_FireShield_Dissipate:
                move.l  #Map_Explosion,mappings(a0)
                move.w  #make_art_tile(ArtTile_Explosion,0,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #3,anim_frame_timer(a0)
                move.b  #1,mapping_frame(a0)
                move.l  #SKExplosion_MoveAndTickFireFade,(a0)

SKExplosion_MoveAndTickFireFade:
                jsr     (MoveSprite2).l
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKExplosion_DrawFireFade
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #5,mapping_frame(a0)
                beq.w   Delete_Current_Sprite

SKExplosion_DrawFireFade:
                jmp     (Draw_Sprite).l
; End of function Obj_FireShield_Dissipate
; ---------------------------------------------------------------------------

SKExplosion_InitHighPriorityDelayed:
                move.l  #Map_Explosion,mappings(a0)
                move.w  #make_art_tile(ArtTile_Explosion,0,1),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$100,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #0,mapping_frame(a0)
                move.l  #SKExplosion_WaitUntilUnderflow,(a0)

SKExplosion_WaitUntilUnderflow:
                subq.b  #1,anim_frame_timer(a0)
                bmi.s   SKExplosion_ActivateDelayed
                rts
; ---------------------------------------------------------------------------

SKExplosion_ActivateDelayed:
                move.b  #3,anim_frame_timer(a0)
                move.l  #SKExplosion_MoveDelayedToFrame5,(a0)

SKExplosion_MoveDelayedToFrame5:
                jsr     (MoveSprite2).l
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   SKExplosion_DrawDelayed
                move.b  #7,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #5,mapping_frame(a0)
                beq.w   Delete_Current_Sprite

SKExplosion_DrawDelayed:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_Explosion:
                include "src/objects/shared/enemy_misc/mappings/explosion.s"
; End of function SKExplosion_InitHighPriorityDelayed
