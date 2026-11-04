; Owner: objects/zones/fbz/sk
; Responsibility: Platform block placement, motion, player riding and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
SKFBZPlatBlocks_SubtypeDimensions:
                dc.b    $10, $10
                dc.b    $20, $10
                dc.b    $30, $10
                dc.b    $40, $10
                even
; ---------------------------------------------------------------------------

Obj_FBZPlatformBlocks:
                move.b  subtype(a0),d0
                lsr.w   #4,d0
                andi.w  #7,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                move.b  SKFBZPlatBlocks_SubtypeDimensions(pc,d0.w),width_pixels(a0)
                move.b  SKFBZPlatBlocks_SubtypeDimensions+1(pc,d0.w),height_pixels(a0)
                move.l  #Map_FBZPlatformBlocks,mappings(a0)
                move.w  #make_art_tile(ArtTile_FBZMisc+$94,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.w  x_pos(a0),$44(a0)
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lsl.w   #4,d0
                move.w  d0,$30(a0)
                bne.s   SKFBZPlatBlocks_StartHeightDrivenMotion
                move.l  #SKFBZPlatBlocks_ResolveSolidAndDraw,(a0)
                bra.w   SKFBZPlatBlocks_ResolveSolidAndDraw
; ---------------------------------------------------------------------------

SKFBZPlatBlocks_StartHeightDrivenMotion:
                move.l  #SKFBZPlatBlocks_TryExtendForP1,(a0)

SKFBZPlatBlocks_TryExtendForP1:
                move.w  (Player_1+y_pos).w,d0
                sub.w   y_pos(a0),d0
                bcs.s   SKFBZPlatBlocks_TryRetractForP1
                cmpi.w  #$20,d0
                blt.s   SKFBZPlatBlocks_SignOffsetByFacing
                move.w  $30(a0),d1
                cmp.w   $32(a0),d1
                beq.s   SKFBZPlatBlocks_SignOffsetByFacing
                addq.w  #8,$32(a0)
                bra.s   SKFBZPlatBlocks_SignOffsetByFacing
; ---------------------------------------------------------------------------

SKFBZPlatBlocks_TryRetractForP1:
                cmpi.w  #-$28,d0
                bge.s   SKFBZPlatBlocks_SignOffsetByFacing
                tst.w   $32(a0)
                beq.s   SKFBZPlatBlocks_SignOffsetByFacing
                subq.w  #8,$32(a0)

SKFBZPlatBlocks_SignOffsetByFacing:
                move.w  $32(a0),d0
                btst    #0,status(a0)
                beq.s   SKFBZPlatBlocks_ApplyOffsetFromBase
                neg.w   d0

SKFBZPlatBlocks_ApplyOffsetFromBase:
                add.w   $44(a0),d0
                move.w  d0,x_pos(a0)

SKFBZPlatBlocks_ResolveSolidAndDraw:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.w  $44(a0),d0
                jmp     (Sprite_OnScreen_Test2).l
; ---------------------------------------------------------------------------
Map_FBZPlatformBlocks:
                include "src/objects/shared/zones/fbz/mappings/platform_blocks.s"
; End of function Obj_FBZPlatformBlocks
