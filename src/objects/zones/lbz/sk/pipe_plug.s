; Owner: objects/zones/lbz/sk
; Responsibility: Launch Base pipe-plug collision, player response, object smash helpers and fragment geometry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZPipePlug:
                move.b  #$10,y_radius(a0)
                move.l  #Map_LBZPipePlug,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZ2Misc-$4,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #SKLBZPipePlug_LeftDebrisSpeeds,$3C(a0)
                move.b  #4,render_flags(a0)
                move.w  #$200,priority(a0)              ; priority is used as a word at first but copied as a byte later which is a bug
                move.b  #7,mapping_frame(a0)
                move.l  #SKLBZPipePlug_SaveSpeedsAndResolveSolid,(a0)

SKLBZPipePlug_SaveSpeedsAndResolveSolid:
                move.w  (Player_1+x_vel).w,$30(a0)
                move.w  (Player_2+x_vel).w,$32(a0)
                move.w  #$1B,d1
                move.w  #$20,d2
                move.w  #$21,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.b  status(a0),d0
                andi.b  #$60,d0
                bne.s   SKLBZPipePlug_TryRollingP1Smash

SKLBZPipePlug_DrawIntactPlug:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKLBZPipePlug_TryRollingP1Smash:
                lea     (Player_1).w,a1
                move.w  $30(a0),d1
                btst    #p1_pushing_bit,status(a0)
                beq.s   SKLBZPipePlug_TryRollingP2Smash
                cmpi.b  #2,anim(a1)                     ; check animation 2
                bne.s   SKLBZPipePlug_TryRollingP2Smash  ; if not go to loc_274A2
                move.w  d1,d0
                bpl.s   SKLBZPipePlug_CheckP1SmashSpeed
                neg.w   d0

SKLBZPipePlug_CheckP1SmashSpeed:
                cmpi.w  #$480,d0
                blo.s   SKLBZPipePlug_TryRollingP2Smash
                bclr    #p2_pushing_bit,status(a0)
                beq.s   SKLBZPipePlug_ClearP1Push
                lea     (Player_2).w,a2
                bclr    #Status_Push,status(a2)
                cmpi.b  #2,anim(a2)
                bne.s   SKLBZPipePlug_ClearP1Push
                move.w  $32(a0),x_vel(a2)
                move.w  x_vel(a2),ground_vel(a2)
                bra.s   SKLBZPipePlug_ClearP1Push
; ---------------------------------------------------------------------------

SKLBZPipePlug_TryRollingP2Smash:
                lea     (Player_2).w,a1
                move.w  $32(a0),d1
                btst    #p2_pushing_bit,status(a0)
                beq.s   SKLBZPipePlug_DrawIntactPlug
                cmpi.b  #2,anim(a1)
                bne.s   SKLBZPipePlug_DrawIntactPlug
                move.w  d1,d0
                bpl.s   SKLBZPipePlug_CheckP2SmashSpeed
                neg.w   d0

SKLBZPipePlug_CheckP2SmashSpeed:
                cmpi.w  #$480,d0
                blo.w   SKLBZPipePlug_DrawIntactPlug
                bclr    #p2_pushing_bit,status(a0)
                beq.s   SKLBZPipePlug_ClearP1Push
                bclr    #Status_Push,(Player_2+status).w  ; set Tails as not pushing against an object

SKLBZPipePlug_ClearP1Push:
                bclr    #p1_pushing_bit,status(a0)
                beq.s   SKLBZPipePlug_RestoreSpeedAndPickDebris
                bclr    #Status_Push,(Player_1+status).w

SKLBZPipePlug_RestoreSpeedAndPickDebris:
                move.w  d1,x_vel(a1)
                addq.w  #4,x_pos(a1)
                lea     (SKLBZPipePlug_LeftDebrisSpeeds).l,a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   SKLBZPipePlug_SelectSmashEffect
                subi.w  #2*4,x_pos(a1)
                lea     (SKLBZPipePlug_RightDebrisSpeeds).l,a4

; Subtype $1F raises the water and skips the tunnel and exhaust actors
SKLBZPipePlug_SelectSmashEffect:
                move.w  x_vel(a1),ground_vel(a1)
                move.b  subtype(a0),d1
                beq.s   SKLBZPipePlug_BeginPlugFracture
                cmpi.b  #$1F,d1
                bne.s   SKLBZPipePlug_TrySpawnTunnel
                move.b  #1,(KnucklesLbzPipePlugWaterReleaseFlag).w
                move.w  #$660,(Target_water_level).w
                tst.b   (Super_Sonic_Knux_flag).w
                beq.s   SKLBZPipePlug_TrySpawnExhaust
                move.b  #2,(Water_speed).w
                bra.s   SKLBZPipePlug_TrySpawnExhaust
; ---------------------------------------------------------------------------

SKLBZPipePlug_TrySpawnTunnel:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKLBZPipePlug_BeginPlugFracture
                move.l  #Obj_AutomaticTunnelDelayed,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                addq.w  #2,y_pos(a1)                    ; move object spawn 2 pixels downwards
                move.b  #7,anim_frame_timer(a1)         ; set delay timer
                move.b  d1,subtype(a1)

SKLBZPipePlug_TrySpawnExhaust:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKLBZPipePlug_BeginPlugFracture
                move.l  #Obj_TunnelExhaustControl,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                subi.w  #$20,y_pos(a1)                  ; move object spawn point 20 pixels upwards
                move.w  #1,y_vel(a1)                    ; set vertical speed to 1
                move.b  d1,subtype(a1)                  ; copy subtype from d1

SKLBZPipePlug_BeginPlugFracture:
                move.l  #SKLBZPipePlug_MoveCornerDebris,(a0)
                bsr.s   PipePlugSmashObject

SKLBZPipePlug_MoveCornerDebris:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)                  ; make object fall
                tst.b   render_flags(a0)
                bpl.w   SKLBZPipePlug_DeleteHiddenDebris
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLBZPipePlug_DeleteHiddenDebris:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

SKLBZPipePlug_AnimatePlugChip:
                moveq   #0,d0                           ; pretty useless in here
                move.b  anim_frame(a0),mapping_frame(a0)
                addq.b  #1,anim_frame(a0)
                cmpi.b  #6,anim_frame(a0)
                blo.s   SKLBZPipePlug_MovePlugChip
                move.b  #0,anim_frame(a0)

SKLBZPipePlug_MovePlugChip:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)                  ; make object fall
                tst.b   render_flags(a0)
                bpl.w   SKLBZPipePlug_DeleteHiddenDebris
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
SKLBZPipePlug_ChipStartFrames:
                dc.b    0
                dc.b    1
                dc.b    2
                dc.b    3
                dc.b    5
                dc.b    0
                dc.b    0
                dc.b    1
                dc.b    2
                dc.b    3
                dc.b    5
                dc.b    0
                even

; =============== S U B R O U T I N E =======================================

PipePlugSmashObject:
                lea     (SKLBZPipePlug_ChipStartFrames).l,a5
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                movea.l mappings(a0),a3
                lea     2*$D(a3),a2                     ; mappings +$1A bytes
                adda.w  (a3,d0.w),a2
                move.l  #SKLBZPipePlug_AnimatePlugChip,d4
                move.b  render_flags(a0),d5
                moveq   #$C-1,d1                        ; set times to loop

SKLBZPipePlug_TrySpawnAnimatedChips:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKLBZPipePlug_PlayCollapseSound
                move.l  d4,(a1)
                move.l  a3,mappings(a1)
                move.b  d5,render_flags(a1)
                move.w  art_tile(a0),art_tile(a1)
; this is not a bug because the design of this object is that priority is set to $200
; copying priority as a byte would lead to $8 being 0x02 and $9 being 00 by default would still end up as $200 anyway but if you
; change priority to something like $280 it would bug up so using a word here would be better
                move.b  priority(a0),priority(a1)
                move.b  width_pixels(a0),width_pixels(a1)
                move.w  (a4)+,x_vel(a1)
                move.w  (a4)+,y_vel(a1)
                move.b  (a5)+,mapping_frame(a1)
                move.b  mapping_frame(a1),anim_frame(a1)
                move.b  (a2),d0                         ; get pixels dy
                addq.w  #4,a2                           ; skip 4 bytes
                ext.w   d0
                add.w   y_pos(a0),d0                    ; add a0 y pos to d0
                move.w  d0,y_pos(a1)                    ; save in new object
                move.w  (a2)+,d0                        ; get pixels dy
                add.w   x_pos(a0),d0
                move.w  d0,x_pos(a1)
                dbf     d1,SKLBZPipePlug_TrySpawnAnimatedChips
; don't know why they didn't use the subroutine instead of making a copy
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                movea.l mappings(a0),a3
                adda.w  (a3,d0.w),a3
                move.w  (a3)+,d1
                subq.w  #1,d1
                moveq   #3,d1
                bset    #5,render_flags(a0)
                move.l  (a0),d4
                move.b  render_flags(a0),d5
                movea.l a0,a1
                bra.s   SKLBZPipePlug_InitCornerDebris
; ---------------------------------------------------------------------------

SKLBZPipePlug_TrySpawnNextCorner:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   SKLBZPipePlug_PlayCollapseSound
                addq.w  #6,a3

SKLBZPipePlug_InitCornerDebris:
                move.l  d4,(a1)
                move.l  a3,mappings(a1)
                move.b  d5,render_flags(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  art_tile(a0),art_tile(a1)
; this is not a bug because the design of this object is that priority is set to $200
; copying priority as a byte would lead to $8 being 0x02 and $9 being 00 by default would still end up as $200 anyway but if you
; change priority to something like $280 it would bug up so using a word here would be better
                move.b  priority(a0),priority(a1)
                move.b  width_pixels(a0),width_pixels(a1)
                move.w  (a4)+,x_vel(a1)
                move.w  (a4)+,y_vel(a1)
                dbf     d1,SKLBZPipePlug_TrySpawnNextCorner

SKLBZPipePlug_PlayCollapseSound:
                moveq   #signextendB(sfx_Collapse),d0
                jmp     (Play_SFX).l
; End of function PipePlugSmashObject

; ---------------------------------------------------------------------------
SKLBZPipePlug_LeftDebrisSpeeds:
                dc.w    -$380, -$240
                dc.w    -$300, -$250
                dc.w    -$280, -$260
                dc.w    -$200, -$260
                dc.w    -$180, -$250
                dc.w    -$100, -$240
                dc.w    -$380,  -$C0
                dc.w    -$300,  -$D0
                dc.w    -$280,  -$E0
                dc.w    -$200,  -$E0
                dc.w    -$180,  -$D0
                dc.w    -$100,  -$C0
                dc.w    -$400, -$2C0
                dc.w    -$100, -$2C0
                dc.w    -$400,  -$80
                dc.w    -$100,  -$80
SKLBZPipePlug_RightDebrisSpeeds:
                dc.w    $100, -$240
                dc.w    $180, -$250
                dc.w    $200, -$260
                dc.w    $280, -$260
                dc.w    $300, -$250
                dc.w    $380, -$240
                dc.w    $100,  -$C0
                dc.w    $180,  -$D0
                dc.w    $200,  -$E0
                dc.w    $280,  -$E0
                dc.w    $300,  -$D0
                dc.w    $380,  -$C0
                dc.w    $100, -$2C0
                dc.w    $400, -$2C0
                dc.w    $100,  -$80
                dc.w    $400,  -$80
