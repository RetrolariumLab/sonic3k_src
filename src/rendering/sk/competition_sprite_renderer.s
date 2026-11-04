; Owner: rendering/sk
; Responsibility: Competition sprite display and its private piece-coordinate lookup tables
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Render_Sprites_CompetitionMode:
                moveq   #($50-2)-1,d7
                moveq   #0,d6
                lea     (Sprite_table_input).w,a5
                lea     (Camera_X_pos_copy).w,a3
; Unlike in Sonic 2, the sprite tables are page-flipped in two-player mode
; This fixes a race-condition where incomplete sprite tables can be uploaded
; to the VDP on lag frames, causing corrupted sprites to appear

; Modify the back buffer
                lea     (Sprite_table+$10).w,a6
                tst.w   (Current_sprite_table_page).w
                beq.s   SKCompRender_TryDrawP1Hud
                lea     (Sprite_table_alternate+$10).l,a6

SKCompRender_TryDrawP1Hud:
                tst.b   (Level_started_flag).w
                beq.s   SKCompRender_BeginTopBucket
                jsr     (Render_HUD_P1).l

SKCompRender_BeginTopBucket:
                move.b  1(a5),(a5)
                beq.w   SKCompRender_NextTopPriority
                lea     2(a5),a4

; Clear the actor's visible bit at the start of the first viewport pass
SKCompRender_ReadAndCullTopActor:
                movea.w (a4)+,a0
                andi.b  #$7F,render_flags(a0)
                move.b  render_flags(a0),d6
                btst    #4,d6
                bne.w   SKCompRender_TickTopBucket
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                btst    #6,d6
                bne.w   SKCompRender_TryDrawTopParent
                btst    #2,d6
                beq.s   SKCompRender_ResolveTopMapping
                moveq   #0,d2
                sub.w   (a3),d0
                move.b  width_pixels(a0),d2
                add.w   d2,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #320,d2
                cmp.w   d2,d0
                bhs.s   SKCompRender_TickTopBucket
                addi.w  #128,d0
                sub.w   d3,d0
                moveq   #0,d2
                sub.w   4(a3),d1
                move.b  height_pixels(a0),d2
                add.w   d2,d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #224/2,d2
                cmp.w   d2,d1
                bhs.s   SKCompRender_TickTopBucket
                addi.w  #128,d1
                sub.w   d3,d1

SKCompRender_ResolveTopMapping:
                ori.b   #$80,render_flags(a0)
                tst.w   d7
                bmi.s   SKCompRender_TickTopBucket
                movea.l mappings(a0),a1
                moveq   #0,d4
                btst    #5,d6
                bne.s   SKCompRender_DrawTopMapping
                move.b  mapping_frame(a0),d4
                add.w   d4,d4
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   SKCompRender_TickTopBucket

SKCompRender_DrawTopMapping:
                move.w  art_tile(a0),d5
                jsr     RenderMappingPieces(pc)

SKCompRender_TickTopBucket:
                subq.b  #2,(a5)
                bne.w   SKCompRender_ReadAndCullTopActor

SKCompRender_NextTopPriority:
                lea     $80(a5),a5
                cmpa.l  #Sprite_table_input_end,a5
                blo.w   SKCompRender_BeginTopBucket
                tst.w   d7
                bmi.s   SKCompRender_TrySwapPlayersInBucket2
                moveq   #0,d0

SKCompRender_HideUnusedTopSprites:
                move.w  d0,(a6)
                addq.w  #8,a6
                dbf     d7,SKCompRender_HideUnusedTopSprites

; Swap only when the first two handles in priority 2 are P1 followed by P2
SKCompRender_TrySwapPlayersInBucket2:
                move.l  (Sprite_table_input+2+($80*2)).w,d0
                cmpi.l  #((Player_1&$FFFF)<<16)|(Player_2&$FFFF),d0
                bne.s   SKCompRender_InitBottomViewport
                swap    d0
                move.l  d0,(Sprite_table_input+2+($80*2)).w

SKCompRender_InitBottomViewport:
                moveq   #$50-1,d7
                lea     (Sprite_table_input).w,a5
                lea     (Camera_X_pos_P2_copy).w,a3
; Unlike in Sonic 2, the sprite tables are page-flipped in two-player mode
; This fixes a race-condition where incomplete sprite tables can be uploaded
; to the VDP on lag frames, causing corrupted sprites to appear

; Modify the back buffer
                lea     (Sprite_table_P2).l,a6
                tst.w   (Current_sprite_table_page).w
                beq.s   SKCompRender_TryCallP2HudStub
                lea     (Sprite_table_P2_alternate).l,a6

SKCompRender_TryCallP2HudStub:
                tst.b   (Level_started_flag).w
                beq.s   SKCompRender_BeginBottomBucket
                jsr     (Render_HUD_P2).l

SKCompRender_BeginBottomBucket:
                tst.b   1(a5)
                beq.w   SKCompRender_NextBottomPriority
                lea     2(a5),a4

SKCompRender_ReadAndCullBottomActor:
                movea.w (a4)+,a0
                move.b  render_flags(a0),d6
                btst    #3,d6
                bne.w   SKCompRender_TickBottomBucket
                move.w  x_pos(a0),d0
                move.w  y_pos(a0),d1
                btst    #6,d6
                bne.w   SKCompRender_TryDrawBottomParent
                btst    #2,d6
                beq.s   SKCompRender_ResolveBottomMapping
                moveq   #0,d2
                sub.w   (a3),d0
                move.b  width_pixels(a0),d2
                add.w   d2,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #320,d2
                cmp.w   d2,d0
                bhs.s   SKCompRender_TickBottomBucket
                addi.w  #128,d0
                sub.w   d3,d0
                moveq   #0,d2
                sub.w   4(a3),d1
                move.b  height_pixels(a0),d2
                add.w   d2,d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #224/2,d2
                cmp.w   d2,d1
                bhs.s   SKCompRender_TickBottomBucket
                addi.w  #128,d1
                sub.w   d3,d1

SKCompRender_ResolveBottomMapping:
                addi.w  #224/2,d1
                ori.b   #$80,render_flags(a0)
                tst.w   d7
                bmi.s   SKCompRender_TickBottomBucket
                movea.l mappings(a0),a1
                moveq   #0,d4
                btst    #5,d6
                bne.s   SKCompRender_DrawBottomMapping
                move.b  mapping_frame(a0),d4
                add.w   d4,d4
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   SKCompRender_TickBottomBucket

SKCompRender_DrawBottomMapping:
                move.w  art_tile(a0),d5
                jsr     RenderMappingPieces(pc)

SKCompRender_TickBottomBucket:
                subq.b  #2,1(a5)
                bne.w   SKCompRender_ReadAndCullBottomActor

SKCompRender_NextBottomPriority:
                lea     $80(a5),a5
                cmpa.l  #Sprite_table_input_end,a5
                blo.w   SKCompRender_BeginBottomBucket
                tst.w   d7
                bmi.s   SKCompRender_RequestPageFlip
                moveq   #0,d0

SKCompRender_HideUnusedBottomSprites:
                move.w  d0,(a6)
                addq.w  #8,a6
                dbf     d7,SKCompRender_HideUnusedBottomSprites

SKCompRender_RequestPageFlip:
; The new sprite tables are complete: signal a page flip to
; allow them to be uploaded to the VDP!
                st.b    (Sprite_table_page_flip_pending).w
                rts
; ---------------------------------------------------------------------------

SKCompRender_TryDrawTopParent:
                moveq   #0,d2
                sub.w   (a3),d0
                move.b  width_pixels(a0),d2
                add.w   d2,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #320,d2
                cmp.w   d2,d0
                bhs.w   SKCompRender_TickTopBucket
                addi.w  #128,d0
                sub.w   d3,d0
                moveq   #0,d2
                sub.w   4(a3),d1
                move.b  height_pixels(a0),d2
                add.w   d2,d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #224/2,d2
                cmp.w   d2,d1
                bhs.w   SKCompRender_TickTopBucket
                addi.w  #128,d1
                sub.w   d3,d1
                ori.b   #$80,render_flags(a0)
                tst.w   d7
                bmi.w   SKCompRender_TickTopBucket
                move.w  art_tile(a0),d5
                movea.l mappings(a0),a2
                moveq   #0,d4
                move.b  mapping_frame(a0),d4
                beq.s   SKCompRender_BeginTopChildren
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   SKCompRender_BeginTopChildren
                move.w  d6,d3
                jsr     RenderMappingPiecesClipped(pc)
                move.w  d3,d6
                tst.w   d7
                bmi.w   SKCompRender_TickTopBucket

SKCompRender_BeginTopChildren:
                move.w  mainspr_childsprites(a0),d3
                subq.w  #1,d3
                bcs.w   SKCompRender_TickTopBucket
                lea     sub2_x_pos(a0),a0

SKCompRender_DrawTopChild:
                move.w  (a0)+,d0
                sub.w   (a3),d0
                addi.w  #128,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  (a0)+,d1
                sub.w   4(a3),d1
                addi.w  #128,d1
                and.w   (Screen_Y_wrap_value).w,d1
                addq.w  #1,a0
                moveq   #0,d4
                move.b  (a0)+,d4
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   SKCompRender_TryNextTopChild
                move.w  d6,-(sp)
                jsr     RenderMappingPiecesClipped(pc)
                move.w  (sp)+,d6

SKCompRender_TryNextTopChild:
                tst.w   d7
                dbmi    d3,SKCompRender_DrawTopChild
                bra.w   SKCompRender_TickTopBucket
; ---------------------------------------------------------------------------

SKCompRender_TryDrawBottomParent:
                moveq   #0,d2
                sub.w   (a3),d0
                move.b  width_pixels(a0),d2
                add.w   d2,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #320,d2
                cmp.w   d2,d0
                bhs.w   SKCompRender_TickBottomBucket
                addi.w  #128,d0
                sub.w   d3,d0
                moveq   #0,d2
                sub.w   4(a3),d1
                move.b  height_pixels(a0),d2
                add.w   d2,d1
                and.w   (Screen_Y_wrap_value).w,d1
                move.w  d2,d3
                add.w   d2,d2
                addi.w  #224/2,d2
                cmp.w   d2,d1
                bhs.w   SKCompRender_TickBottomBucket
                addi.w  #240,d1
                sub.w   d3,d1
                ori.b   #$80,render_flags(a0)
                tst.w   d7
                bmi.w   SKCompRender_TickBottomBucket
                move.w  art_tile(a0),d5
                movea.l mappings(a0),a2
                moveq   #0,d4
                move.b  mapping_frame(a0),d4
                beq.s   SKCompRender_BeginBottomChildren
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   SKCompRender_BeginBottomChildren
                move.w  d6,d3
                jsr     RenderMappingPiecesClipped(pc)
                move.w  d3,d6
                tst.w   d7
                bmi.w   SKCompRender_TickBottomBucket

SKCompRender_BeginBottomChildren:
                move.w  mainspr_childsprites(a0),d3
                subq.w  #1,d3
                bcs.w   SKCompRender_TickBottomBucket
                lea     sub2_x_pos(a0),a0

SKCompRender_DrawBottomChild:
                move.w  (a0)+,d0
                sub.w   (a3),d0
                addi.w  #128,d0
                and.w   (Screen_X_wrap_value).w,d0
                move.w  (a0)+,d1
                sub.w   4(a3),d1
                addi.w  #128,d1
                and.w   (Screen_Y_wrap_value).w,d1
                addi.w  #224/2,d1
                addq.w  #1,a0
                moveq   #0,d4
                move.b  (a0)+,d4
                add.w   d4,d4
                lea     (a2),a1
                adda.w  (a1,d4.w),a1
                move.w  (a1)+,d4
                subq.w  #1,d4
                bmi.s   SKCompRender_TryNextBottomChild
                move.w  d6,-(sp)
                jsr     RenderMappingPiecesClipped(pc)
                move.w  (sp)+,d6

SKCompRender_TryNextBottomChild:
                tst.w   d7
                dbmi    d3,SKCompRender_DrawBottomChild
                bra.w   SKCompRender_TickBottomBucket
