; Owner: objects/zones/fbz/sk
; Responsibility: Magnetic spike-ball activation, motion and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZMagneticSpikeBall:
                move.l  #Map_FBZMagneticSpikeBall,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$CA,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                tst.b   subtype(a0)
                beq.s   loc_3B16E
                bmi.s   loc_3B122
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$9A,collision_flags(a0)
                move.l  #Sprite_CheckDeleteTouch3,(a0)
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

loc_3B122:
                btst    #0,subtype(a0)
                bne.s   loc_3B146
                ori.w   #high_priority,art_tile(a0)
                move.b  #$30,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.l  #loc_3B1FC,(a0)
                bra.w   loc_3B1FC
; ---------------------------------------------------------------------------

loc_3B146:
                move.w  #make_art_tile(ArtTile_FBZMisc+$C9,1,1),art_tile(a0)
                move.b  #$24,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.b  #4,mapping_frame(a0)
                move.w  #$200,priority(a0)
                move.l  #loc_3B238,(a0)
                bra.w   loc_3B238
; ---------------------------------------------------------------------------

loc_3B16E:
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$A,y_radius(a0)
                move.b  #$9A,collision_flags(a0)
                move.l  #loc_3B18C,(a0)

loc_3B18C:
                jsr     (MoveSprite2).l
                addi.w  #$58,y_vel(a0)
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_3B1B2
                add.w   d1,y_pos(a0)
                move.w  #0,y_vel(a0)
                move.l  #loc_3B1B2,(a0)

loc_3B1B2:
                tst.b   (_unkF7C1).w
                beq.s   loc_3B1BE
                move.l  #loc_3B1C4,(a0)

loc_3B1BE:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

loc_3B1C4:
                jsr     (MoveSprite2).l
                subi.w  #$18,y_vel(a0)
                jsr     (ObjCheckCeilingDist).l
                tst.w   d1
                bpl.s   loc_3B1EA
                sub.w   d1,y_pos(a0)
                move.w  #0,y_vel(a0)
                move.l  #loc_3B1EA,(a0)

loc_3B1EA:
                tst.b   (_unkF7C1).w
                bne.s   loc_3B1F6
                move.l  #loc_3B18C,(a0)

loc_3B1F6:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

loc_3B1FC:
                tst.b   (_unkF7C1).w
                beq.s   loc_3B232
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #5,mapping_frame(a0)
                blo.s   loc_3B214
                move.b  #1,mapping_frame(a0)

loc_3B214:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   loc_3B22C
                tst.b   render_flags(a0)
                bpl.s   loc_3B22C
                moveq   #signextendB(sfx_MagneticSpike),d0
                jsr     (Play_SFX).l

loc_3B22C:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_3B232:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_3B238:
                tst.b   (_unkF7C1).w
                beq.s   loc_3B256
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #7,mapping_frame(a0)
                blo.s   loc_3B250
                move.b  #5,mapping_frame(a0)

loc_3B250:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_3B256:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------
Map_FBZMagneticSpikeBall:
                include "src/objects/shared/zones/fbz/mappings/magnetic_spike_ball.s"
; End of function Obj_FBZMagneticSpikeBall
