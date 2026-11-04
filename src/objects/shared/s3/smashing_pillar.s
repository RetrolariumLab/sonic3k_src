; Owner: objects/shared/s3
; Responsibility: Shared Marble Garden and Launch Base smashing pillar collision and mapping selection
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MGZLBZSmashingPillar:
                move.l  #Map_LBZSmashingSpikes,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZTubeTrans,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$80,priority(a0)
                cmpi.b  #2,(Current_zone).w
                bne.s   S3SmashingPillar_InitDropOriginAndTravel
                move.l  #Map_MGZSmashingPillar,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.w  #$280,priority(a0)

S3SmashingPillar_InitDropOriginAndTravel:
                move.b  #4,render_flags(a0)
                move.w  y_pos(a0),$30(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$38(a0)
                move.l  #S3SmashingPillar_TickDropOrRetract,(a0)

S3SmashingPillar_TickDropOrRetract:
                tst.b   $32(a0)
                bne.s   S3SmashingPillar_RetractOnePixel
                move.w  y_vel(a0),d0
                addi.w  #$80,y_vel(a0)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,$34(a0)
                move.w  $34(a0),d2
                cmp.w   $38(a0),d2
                blo.s   S3SmashingPillar_SetPosAndCheckContacts
                clr.w   y_vel(a0)
                move.w  $38(a0),$34(a0)
                move.b  #1,$32(a0)
                tst.b   render_flags(a0)
                bpl.s   S3SmashingPillar_SetPosAndCheckContacts
                moveq   #signextendB(sfx_Crash),d0
                cmpi.b  #2,(Current_zone).w
                beq.s   S3SmashingPillar_PlayImpactAndCollide
                moveq   #signextendB(sfx_MechaLand),d0

S3SmashingPillar_PlayImpactAndCollide:
                jsr     (Play_SFX).l
                bra.s   S3SmashingPillar_SetPosAndCheckContacts
; ---------------------------------------------------------------------------

S3SmashingPillar_RetractOnePixel:
                move.w  $34(a0),d2
                beq.s   S3SmashingPillar_EndRetractAtOrigin
                subq.w  #1,d2
                move.w  d2,$34(a0)
                bra.s   S3SmashingPillar_SetPosAndCheckContacts
; ---------------------------------------------------------------------------

S3SmashingPillar_EndRetractAtOrigin:
                move.b  #0,$32(a0)

S3SmashingPillar_SetPosAndCheckContacts:
                move.w  $30(a0),d0
                add.w   $34(a0),d0
                move.w  d0,y_pos(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                swap    d6
                andi.w  #4|8,d6
                bne.s   S3SmashingPillar_TryHurtP1UnderPillar
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

S3SmashingPillar_TryHurtP1UnderPillar:
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   S3SmashingPillar_TryHurtP2UnderPillar
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3SmashingPillar_TryHurtP2UnderPillar:
                andi.b  #8,d6
                beq.s   S3SmashingPillar_CullAndDraw
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerFromSolidHazard

S3SmashingPillar_CullAndDraw:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_LBZSmashingSpikes:
                include "src/objects/shared/zones/lbz/mappings/smashing_spikes.s"
Map_MGZSmashingPillar:
                include "src/objects/shared/zones/mgz/mappings/smashing_pillar.s"
; End of function Obj_MGZLBZSmashingPillar
