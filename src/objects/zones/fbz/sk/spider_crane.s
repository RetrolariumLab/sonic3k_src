; Owner: objects/zones/fbz/sk
; Responsibility: Spider crane coordinated movement, player collision and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZSpiderCrane:
                move.l  #Map_FBZSpiderCrane,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc2+$67,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$60,height_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.w  y_pos(a0),$46(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #0,(a2)+
                move.b  #$A,mapping_frame(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                lsl.w   #2,d0
                move.w  d0,$38(a0)
                move.l  #SKFBZCrane_TryExtendForP1,(a0)

SKFBZCrane_TryExtendForP1:
                lea     (Player_1).w,a1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.s   SKFBZCrane_DrawWaitingCrane
                tst.w   (Debug_placement_mode).w
                bne.s   SKFBZCrane_DrawWaitingCrane
                move.l  #SKFBZCrane_StepExtension,(a0)

SKFBZCrane_DrawWaitingCrane:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKFBZCrane_StepExtension:
                cmpi.w  #$40,$34(a0)
                bhs.s   SKFBZCrane_PlaceAndTryCaptureP1
                addq.w  #1,$34(a0)

SKFBZCrane_PlaceAndTryCaptureP1:
                move.w  $34(a0),d0
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                move.w  y_pos(a0),sub2_y_pos(a0)
                move.w  $34(a0),d0
                addq.w  #7,d0
                lsr.w   #3,d0
                move.b  d0,sub2_mapframe(a0)
                lea     (Player_1).w,a1
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$10,d0
                cmpi.w  #$20,d0
                bhs.w   SKFBZCrane_DrawExtendingCrane
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                subi.w  #5,d0
                cmpi.w  #$14,d0
                bhs.w   SKFBZCrane_DrawExtendingCrane
                btst    #Status_InAir,status(a1)
                bne.s   SKFBZCrane_DrawExtendingCrane
                move.b  #$E,anim(a1)
                move.b  #$C1,object_control(a1)
                clr.b   spin_dash_flag(a1)
                moveq   #0,d0
                move.b  d0,status(a1)
                move.w  d0,x_vel(a1)
                move.w  d0,y_vel(a1)
                move.b  default_y_radius(a1),y_radius(a1)
                move.b  default_x_radius(a1),x_radius(a1)
                move.l  #SKFBZCrane_CenterP1AndTrySpawnClaw,(a0)

SKFBZCrane_DrawExtendingCrane:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKFBZCrane_CenterP1AndTrySpawnClaw:
                move.w  x_pos(a0),(Player_1+x_pos).w
                move.w  y_pos(a0),d0
                addi.w  #$10,d0
                move.w  d0,(Player_1+y_pos).w
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKFBZCrane_SetCapturedPoseAndRetract
                move.l  #SKFBZCrane_DrawReleasedCrane,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  #$280,priority(a1)
                move.b  #$18,width_pixels(a1)
                move.b  #$18,height_pixels(a1)
                move.b  #$B,mapping_frame(a1)
                move.w  a1,$3C(a0)

SKFBZCrane_SetCapturedPoseAndRetract:
                move.b  #9,mapping_frame(a0)
                move.l  #SKFBZCrane_RetractOrBeginTravel,(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKFBZCrane_RetractOrBeginTravel:
                tst.w   $34(a0)
                beq.s   SKFBZCrane_SyncClawAndP1Y
                subq.w  #1,$34(a0)
                bne.s   SKFBZCrane_SyncClawAndP1Y
                move.l  #SKFBZCrane_AccelerateTravel,(a0)

SKFBZCrane_SyncClawAndP1Y:
                move.w  $34(a0),d0
                add.w   $46(a0),d0
                move.w  d0,y_pos(a0)
                move.w  y_pos(a0),sub2_y_pos(a0)
                move.w  $34(a0),d0
                addq.w  #7,d0
                lsr.w   #3,d0
                move.b  d0,sub2_mapframe(a0)
                movea.w $3C(a0),a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  x_pos(a0),(Player_1+x_pos).w
                move.w  y_pos(a0),d0
                addi.w  #$10,d0
                move.w  d0,(Player_1+y_pos).w
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKFBZCrane_AccelerateTravel:
                tst.b   $36(a0)
                bne.s   SKFBZCrane_SlowAndTryReleaseP1
                addi.l  #$1000,$30(a0)
                move.w  x_pos(a0),d0
                sub.w   $44(a0),d0
                cmp.w   $38(a0),d0
                blt.s   SKFBZCrane_MoveAndSyncClawAndP1X
                move.b  #1,$36(a0)
                bra.s   SKFBZCrane_MoveAndSyncClawAndP1X
; ---------------------------------------------------------------------------

SKFBZCrane_SlowAndTryReleaseP1:
                subi.l  #$1000,$30(a0)
                bne.s   SKFBZCrane_MoveAndSyncClawAndP1X
                lea     (Player_1).w,a1
                move.b  #0,anim(a1)
                move.b  #0,object_control(a1)
                bset    #Status_InAir,status(a1)
                move.l  #SKFBZCrane_DrawReleasedCrane,(a0)
                move.b  #$A,mapping_frame(a0)
                movea.w $3C(a0),a1
                move.b  #0,mapping_frame(a1)

SKFBZCrane_MoveAndSyncClawAndP1X:
                move.l  $30(a0),d0
                add.l   d0,x_pos(a0)
                move.w  x_pos(a0),x_vel(a0)
                movea.w $3C(a0),a1
                move.w  x_pos(a0),x_pos(a1)
                move.w  x_pos(a0),(Player_1+x_pos).w
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKFBZCrane_DrawReleasedCrane:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_FBZSpiderCrane:
                include "src/objects/shared/zones/fbz/mappings/spider_crane.s"
; End of function Obj_FBZSpiderCrane
