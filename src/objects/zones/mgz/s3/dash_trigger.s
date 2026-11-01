; Owner: objects/zones/mgz/s3
; Responsibility: Marble Garden dash trigger state, activation, child sprites and animation resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_MGZDashTrigger:
                move.l  #Map_MGZDashTrigger,mappings(a0)
                move.w  #make_art_tile(ArtTile_MGZMisc1,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$280,priority(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #0,(a2)+
                move.l  #loc_249FA,(a0)

loc_249FA:
                move.w  #$1B,d1
                move.w  #$10,d2
                move.w  x_pos(a0),d4
                lea     (byte_24B6C).l,a2
                jsr     (CollidePlayersWithHeightProfileSolid).l
                swap    d6
                andi.w  #$33,d6
                beq.s   loc_24A80
                move.b  d6,d0
                andi.b  #$11,d0
                beq.s   loc_24A4E
                lea     (Player_1).w,a1
                cmpi.b  #9,anim(a1)
                bne.s   loc_24A4E
                move.w  #$3C,$30(a0)
                move.b  #1,$32(a0)
                move.b  status(a1),d0
                add.b   status(a0),d0
                andi.b  #1,d0
                bne.s   loc_24A4E
                move.b  #-1,$32(a0)

loc_24A4E:
                andi.b  #$22,d6
                beq.s   loc_24A80
                lea     (Player_2).w,a1
                cmpi.b  #9,anim(a1)
                bne.s   loc_24A80
                move.w  #$3C,$30(a0)
                move.b  #1,$32(a0)
                move.b  status(a1),d0
                add.b   status(a0),d0
                andi.b  #1,d0
                bne.s   loc_24A80
                move.b  #-1,$32(a0)

loc_24A80:
                tst.w   $30(a0)
                beq.s   loc_24AFE
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                subq.w  #1,$30(a0)
                bne.s   loc_24AA8
                move.b  #0,(a3)
                move.b  #0,mapping_frame(a0)
                bra.s   loc_24AFE
; ---------------------------------------------------------------------------

loc_24AA8:
                move.b  #1,(a3)
                move.b  status(a0),d6
                andi.w  #standing_mask,d6
                beq.s   loc_24AD0
                move.w  d6,d0
                andi.w  #p1_standing,d0
                beq.s   loc_24AC4
                lea     (Player_1).w,a1
                bsr.s   ReboundPlayerFromActiveMgzDashTrigger

loc_24AC4:
                andi.w  #p2_standing,d6
                beq.s   loc_24AD0
                lea     (Player_2).w,a1
                bsr.s   ReboundPlayerFromActiveMgzDashTrigger

loc_24AD0:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   loc_24AEA
                move.b  #1,anim_frame_timer(a0)
                move.b  $32(a0),d0
                add.b   d0,$1D(a0)
                andi.b  #3,$1D(a0)

loc_24AEA:
                tst.b   mapping_frame(a0)
                beq.s   loc_24AF8
                move.b  #0,mapping_frame(a0)
                bra.s   loc_24AFE
; ---------------------------------------------------------------------------

loc_24AF8:
                move.b  #4,mapping_frame(a0)

loc_24AFE:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

ReboundPlayerFromActiveMgzDashTrigger:
                move.w  x_pos(a0),d1
                subi.w  #$10,d1
                btst    #0,status(a0)
                beq.s   loc_24B18
                addi.w  #2*$10,d1

loc_24B18:
                move.w  y_pos(a0),d2
                addi.w  #$10,d2
                sub.w   x_pos(a1),d1
                sub.w   y_pos(a1),d2
                jsr     (GetArcTan).l
                jsr     (GetSineCosine).l
                muls.w  #-$700,d1
                asr.l   #8,d1
                move.w  d1,x_vel(a1)
                muls.w  #-$700,d0
                asr.l   #8,d0
                move.w  d0,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_RollJump,status(a1)
                bclr    #Status_Push,status(a1)
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                moveq   #signextendB(sfx_SmallBumpers),d0
                jsr     (Play_SFX).l
                rts
; End of function ReboundPlayerFromActiveMgzDashTrigger

; ---------------------------------------------------------------------------
byte_24B6C:
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $10
                dc.b    $F
                dc.b    $F
                dc.b    $E
                dc.b    $E
                dc.b    $D
                dc.b    $C
                dc.b    $A
                dc.b    8
                dc.b    6
                dc.b    4
                dc.b    0
                dc.b    -4
                dc.b    -8
                dc.b    -$A
                dc.b    -$A
                dc.b    -$A
                dc.b    -$A
                dc.b    -$A
                dc.b    -$A
Map_MGZDashTrigger:
                include "src/objects/shared/zones/mgz/mappings/dash_trigger.s"
