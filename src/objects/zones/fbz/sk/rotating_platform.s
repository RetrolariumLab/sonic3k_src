; Owner: objects/zones/fbz/sk
; Responsibility: Rotating platform phase, motion, collision and player riding
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_FBZRotatingPlatform:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lsl.w   #3,d0
                lea     SKFBZOrbitPlat_OrbitGroupConfigs(pc,d0.w),a2
                moveq   #0,d1
                move.b  (a2)+,d1
                move.b  (a2)+,d2
                movea.l a0,a1
                bra.w   SKFBZOrbitPlat_InitOrbitMember
; ---------------------------------------------------------------------------
SKFBZOrbitPlat_OrbitGroupConfigs:
                dc.b    6-1,   0, $5C, $44, $2C, $D4, $BC, $A4
                dc.b    6-1,   1, $5C, $44, $2C, $D4, $BC, $A4
                dc.b    6-1, $21, $5C, $44, $2C, $D4, $BC, $A4
                dc.b    4-1,   0, $44, $2C, $D4, $BC,   0,   0
                dc.b    4-1,   1, $44, $2C, $D4, $BC,   0,   0
                dc.b    4-1,   9, $44, $2C, $D4, $BC,   0,   0
                dc.b    2-1,   0, $2C, $D4,   0,   0,   0,   0
                dc.b    2-1,   1, $2C, $D4,   0,   0,   0,   0
                dc.b    2-1,   3, $2C, $D4,   0,   0,   0,   0
                dc.b    3-1,   0, $5C, $44, $2C,   0,   0,   0
                dc.b    3-1,   1, $5C, $44, $2C,   0,   0,   0
                dc.b    2-1,   0, $44, $2C,   0,   0,   0,   0
                dc.b    2-1,   1, $44, $2C,   0,   0,   0,   0
                dc.b    1-1,   0, $2C,   0,   0,   0,   0,   0
                dc.b    1-1,   1, $2C,   0,   0,   0,   0,   0
                even
; ---------------------------------------------------------------------------

; A failed allocation still consumes the current attempt and allows the remaining attempts
SKFBZOrbitPlat_TryAllocateOrbitMember:
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKFBZOrbitPlat_NextOrbitAttempt

SKFBZOrbitPlat_InitOrbitMember:
                move.l  #SKFBZOrbitPlat_UpdateSolidOrbit,(a1)
                move.l  #Map_FBZRotatingPlatform,mappings(a1)
                move.w  #make_art_tile(ArtTile_FBZMisc+$F2,1,0),art_tile(a1)
                ori.b   #4,render_flags(a1)
                move.b  #$C,width_pixels(a1)
                move.b  #$C,height_pixels(a1)
                move.w  #$280,priority(a1)
                move.b  status(a0),status(a1)
                bset    #7,status(a1)
                move.w  x_pos(a0),$44(a1)
                move.w  y_pos(a0),$46(a1)
                move.b  (a2)+,$30(a1)
                lsr.b   #1,d2
                bcc.s   SKFBZOrbitPlat_NextOrbitAttempt
                move.l  #SKFBZOrbitPlat_UpdateHazardOrbit,(a1)
                move.w  #make_art_tile(ArtTile_FBZMisc+$CA,1,0),art_tile(a1)
                move.b  #1,mapping_frame(a1)
                move.b  #$86,collision_flags(a1)

SKFBZOrbitPlat_NextOrbitAttempt:
                dbf     d1,SKFBZOrbitPlat_TryAllocateOrbitMember

SKFBZOrbitPlat_UpdateSolidOrbit:
                move.w  x_pos(a0),-(sp)
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                move.w  $30(a0),d2
                muls.w  d2,d1
                muls.w  d2,d0
                swap    d1
                swap    d0
                add.w   $44(a0),d1
                add.w   $46(a0),d0
                move.w  d1,x_pos(a0)
                move.w  d0,y_pos(a0)
                move.w  #$17,d1
                move.w  #$C,d2
                move.w  #$D,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                moveq   #1,d1
                btst    #0,status(a0)
                beq.s   SKFBZOrbitPlat_StepSolidPhaseAndDraw
                neg.w   d1

SKFBZOrbitPlat_StepSolidPhaseAndDraw:
                add.b   d1,angle(a0)
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------

SKFBZOrbitPlat_UpdateHazardOrbit:
                move.w  x_pos(a0),-(sp)
                move.b  angle(a0),d0
                jsr     (GetSineCosine).l
                move.w  $30(a0),d2
                muls.w  d2,d1
                muls.w  d2,d0
                swap    d1
                swap    d0
                add.w   $44(a0),d1
                add.w   $46(a0),d0
                move.w  d1,x_pos(a0)
                move.w  d0,$14(a0)
                move.w  #$17,d1
                move.w  #$C,d2
                move.w  #$D,d3
                move.w  (sp)+,d4
                jsr     (SolidObjectFull).l
                moveq   #1,d1
                btst    #0,status(a0)
                beq.s   SKFBZOrbitPlat_StepHazardPhaseAndDraw
                neg.w   d1

SKFBZOrbitPlat_StepHazardPhaseAndDraw:
                add.b   d1,angle(a0)
                move.w  $44(a0),d0
                jmp     (SKTouchCull_TestAnchorAndDraw).l
; ---------------------------------------------------------------------------
Map_FBZRotatingPlatform:
                include "src/objects/shared/zones/fbz/mappings/rotating_platform.s"
; End of function Obj_FBZRotatingPlatform
