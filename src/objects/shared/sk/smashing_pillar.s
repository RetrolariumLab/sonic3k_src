; Owner: objects/shared/sk
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
                bne.s   loc_2925E
                move.l  #Map_MGZSmashingPillar,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.w  #$280,priority(a0)

loc_2925E:
                move.b  #4,render_flags(a0)
                move.w  y_pos(a0),$30(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #3,d0
                move.w  d0,$38(a0)
                move.l  #loc_2927C,(a0)

loc_2927C:
                tst.b   $32(a0)
                bne.s   loc_292C8
                move.w  y_vel(a0),d0
                addi.w  #$80,y_vel(a0)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,$34(a0)
                move.w  $34(a0),d2
                cmp.w   $38(a0),d2
                blo.s   loc_292DC
                clr.w   y_vel(a0)
                move.w  $38(a0),$34(a0)
                move.b  #1,$32(a0)
                tst.b   render_flags(a0)
                bpl.s   loc_292DC
                moveq   #signextendB(sfx_Crash),d0
                cmpi.b  #2,(Current_zone).w
                beq.s   loc_292C0
                moveq   #signextendB(sfx_MechaLand),d0

loc_292C0:
                jsr     (Play_SFX).l
                bra.s   loc_292DC
; ---------------------------------------------------------------------------

loc_292C8:
                move.w  $34(a0),d2
                beq.s   loc_292D6
                subq.w  #1,d2
                move.w  d2,$34(a0)
                bra.s   loc_292DC
; ---------------------------------------------------------------------------

loc_292D6:
                move.b  #0,$32(a0)

loc_292DC:
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
                bne.s   loc_29314
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_29314:
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   loc_29324
                lea     (Player_1).w,a1
                bsr.w   sub_24280

loc_29324:
                andi.b  #8,d6
                beq.s   loc_29332
                lea     (Player_2).w,a1
                bsr.w   sub_24280

loc_29332:
                jmp     (Sprite_OnScreen_Test).l
; End of function Obj_MGZLBZSmashingPillar
