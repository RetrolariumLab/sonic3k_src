; Owner: objects/zones/lrz/sk
; Responsibility: Spike-ball movement, collision, rock debris and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZSpikeBall:
                move.l  #Map_LRZSpikeBall,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZBigSpike,1,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  #$20,x_radius(a0)
                move.b  #$20,y_radius(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                tst.b   subtype(a0)
                bne.s   loc_437F8
                ori.w   #high_priority,art_tile(a0)
                move.b  #$8F,collision_flags(a0)
                move.l  #loc_4397E,(a0)
                bra.w   loc_4397E
; ---------------------------------------------------------------------------

loc_437F8:
                move.l  #loc_437FE,(a0)

loc_437FE:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d1
                add.w   $44(a0),d1
                move.w  d1,x_pos(a0)
                move.b  #0,collision_flags(a0)
                andi.w  #drawing_mask,art_tile(a0)
                tst.b   angle(a0)
                bpl.s   loc_43830
                ori.w   #high_priority,art_tile(a0)
                move.b  #$8F,collision_flags(a0)

loc_43830:
                lea     (Player_1).w,a1
                move.w  y_pos(a1),d0
                sub.w   $46(a0),d0
                addi.w  #$40,d0
                cmpi.w  #$80,d0
                bhs.s   loc_4385C
                move.w  x_pos(a1),d0
                sub.w   $44(a0),d0
                bcc.s   loc_4385C
                tst.w   (Debug_placement_mode).w
                bne.s   loc_4385C
                move.b  #1,$30(a0)

loc_4385C:
                tst.b   $30(a0)
                beq.s   loc_4387E
                move.b  subtype(a0),d0
                cmp.b   angle(a0),d0
                bne.s   loc_4387E
                move.l  #loc_4389E,(a0)
                move.w  #-$400,x_vel(a0)
                move.w  #0,y_vel(a0)

loc_4387E:
                subq.b  #2,angle(a0)
                tst.b   $30(a0)
                bne.s   loc_43892
                move.w  $44(a0),d0
                jmp     (SKTouchCull_TestAnchorAndDraw).l
; ---------------------------------------------------------------------------

loc_43892:
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4389E:
                btst    #1,status(a0)
                bne.s   loc_4390E
                jsr     (MoveSprite2).l
                moveq   #-$20,d3
                add.w   x_pos(a0),d3
                jsr     (ObjCheckLeftWallDist_Part2).l
                tst.w   d1
                bpl.s   loc_438CC
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)
                move.b  #0,$30(a0)

loc_438CC:
                jsr     (ObjCheckFloorDist).l
                cmpi.w  #$E,d1
                bgt.s   loc_43906
                add.w   d1,y_pos(a0)
                move.w  #0,y_vel(a0)
                tst.w   x_vel(a0)
                beq.s   loc_438FA
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   loc_438FA
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l

loc_438FA:
                subi.w  #4,x_vel(a0)
                bsr.w   EmitLrzSpikeBallGroundDebris
                bra.s   loc_43948
; ---------------------------------------------------------------------------

loc_43906:
                bset    #1,status(a0)
                bra.s   loc_43948
; ---------------------------------------------------------------------------

loc_4390E:
                moveq   #-$20,d3
                add.w   x_pos(a0),d3
                jsr     (ObjCheckLeftWallDist_Part2).l
                tst.w   d1
                bpl.s   loc_43928
                sub.w   d1,x_pos(a0)
                move.w  #0,x_vel(a0)

loc_43928:
                jsr     (MoveSprite).l
                jsr     (ObjCheckFloorDist).l
                tst.w   d1
                bpl.s   loc_43948
                add.w   d1,y_pos(a0)
                bclr    #1,status(a0)
                move.w  #0,y_vel(a0)

loc_43948:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_43966
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   loc_43966
                move.b  #0,mapping_frame(a0)

loc_43966:
                tst.b   $30(a0)
                beq.s   loc_43978
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_43978:
                jmp     (Sprite_CheckDeleteTouch3).l
; ---------------------------------------------------------------------------

loc_4397E:
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                asr.w   #2,d1
                add.w   $44(a0),d1
                move.w  d1,x_pos(a0)
                btst    #1,status(a0)
                bne.s   loc_439A4
                jsr     (ObjCheckFloorDist).l
                add.w   d1,y_pos(a0)

loc_439A4:
                tst.b   render_flags(a0)
                bpl.s   loc_439BC
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   loc_439BC
                moveq   #signextendB(sfx_MechaLand),d0
                jsr     (Play_SFX).l

loc_439BC:
                bsr.w   EmitLrzSpikeBallGroundDebris
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_439DE
                move.b  #3,anim_frame_timer(a0)
                addq.b  #1,mapping_frame(a0)
                cmpi.b  #3,mapping_frame(a0)
                blo.s   loc_439DE
                move.b  #0,mapping_frame(a0)

loc_439DE:
                subq.b  #2,angle(a0)
                move.w  $44(a0),d0
                jmp     (SKTouchCull_TestAnchorAndDraw).l

; =============== S U B R O U T I N E =======================================

EmitLrzSpikeBallGroundDebris:
                move.w  (Level_frame_counter).w,d0
                andi.w  #3,d0
                bne.s   locret_43A6A
                tst.b   render_flags(a0)
                bpl.s   locret_43A6A
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   locret_43A6A
                move.l  #loc_43A6C,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addi.w  #$20,y_pos(a1)
                move.l  #Map_LRZRockDebris,mappings(a1)
                move.w  #make_art_tile($0D3,2,1),art_tile(a1)
                ori.b   #$84,render_flags(a1)
                move.w  #0,priority(a1)
                move.b  #4,width_pixels(a1)
                move.b  #4,height_pixels(a1)
                jsr     (Random_Number).l
                andi.w  #$1FF,d0
                subi.w  #$100,d0
                move.w  d0,x_vel(a1)
                asr.w   #4,d0
                add.w   d0,x_pos(a1)
                swap    d0
                andi.w  #$1FF,d0
                addi.w  #-$400,d0
                move.w  d0,y_vel(a1)

locret_43A6A:
                rts
; End of function EmitLrzSpikeBallGroundDebris

; ---------------------------------------------------------------------------

loc_43A6C:
                tst.b   render_flags(a0)
                bpl.s   loc_43A88
                addq.b  #1,mapping_frame(a0)
                andi.b  #3,mapping_frame(a0)
                jsr     (MoveSprite).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_43A88:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_LRZSpikeBall:
                include "src/objects/shared/zones/lrz/mappings/spike_ball.s"
Map_LRZRockDebris:
                include "src/objects/shared/zones/lrz/mappings/rock_debris.s"
