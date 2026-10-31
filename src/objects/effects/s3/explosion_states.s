; Owner: objects/effects/s3
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
                dc.w    loc_1C228-Explosion_Index
                dc.w    loc_1C24C-Explosion_Index
                dc.w    loc_1C2A0-Explosion_Index
; ---------------------------------------------------------------------------

loc_1C228:
                addq.b  #2,routine(a0)
                jsr     (AllocateObject).l
                bne.s   loc_1C24C
                move.l  #Obj_Animal,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  $3E(a0),$3E(a1)                 ; $3E is copied all the way from touch response in here (value didn't change for the variable same as sonic 2)

loc_1C24C:
                addq.b  #2,routine(a0)
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
                moveq   #signextendB(sfx_Break),d0
                jsr     (Play_SFX).l
                move.l  #loc_1C2A0,(a0)

loc_1C2A0:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_1C2BA
                move.b  #7,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #5,mapping_frame(a0)
                beq.w   Delete_Current_Sprite

loc_1C2BA:
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
                move.l  #loc_1C2F8,(a0)

loc_1C2F8:
                jsr     (MoveSprite2).l
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_1C318
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #5,mapping_frame(a0)
                beq.w   Delete_Current_Sprite

loc_1C318:
                jmp     (Draw_Sprite).l
; End of function Obj_FireShield_Dissipate
; ---------------------------------------------------------------------------

loc_1C31E:
                move.l  #Map_Explosion,mappings(a0)
                move.w  #make_art_tile(ArtTile_Explosion,0,1),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$100,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$C,height_pixels(a0)
                move.b  #0,mapping_frame(a0)
                move.l  #loc_1C350,(a0)

loc_1C350:
                subq.b  #1,anim_frame_timer(a0)
                bmi.s   loc_1C358
                rts
; ---------------------------------------------------------------------------

loc_1C358:
                move.b  #3,anim_frame_timer(a0)
                move.l  #loc_1C364,(a0)

loc_1C364:
                jsr     (MoveSprite2).l
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_1C384
                move.b  #7,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #5,mapping_frame(a0)
                beq.w   Delete_Current_Sprite

loc_1C384:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Map_Explosion:
                include "src/objects/shared/enemy_misc/mappings/explosion_s3.s"
; End of function loc_1C31E
