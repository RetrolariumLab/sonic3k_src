; Owner: objects/shared/sk
; Responsibility: Breakable wall contact, player response, fracture geometry and fragment creation with zone-specific mappings
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_BreakableWall:
                move.b  #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.l  #loc_21568,(a0)
                move.b  subtype(a0),d0
                bpl.s   loc_21340
                tst.b   (Level_trigger_array).w
                beq.s   loc_21340
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_21340:
                andi.b  #$F,d0
                move.b  d0,mapping_frame(a0)
                move.l  #Map_AIZBreakableWall,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.l  #word_2193A,$34(a0)
                move.l  #word_2196A,$38(a0)
                cmpi.b  #1,(Current_zone).w
                bne.s   loc_213D6
                move.l  #Map_HCZBreakableWall,mappings(a0)
                move.w  #make_art_tile($001,3,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #word_2199A,$34(a0)
                move.l  #word_219BA,$38(a0)
                cmpi.b  #2,mapping_frame(a0)
                bne.s   loc_213D6
                move.w  #make_art_tile(ArtTile_HCZ2KnuxWall,2,0),art_tile(a0)
                move.b  #$18,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #word_2199A,$34(a0)
                move.l  #word_219BA,$38(a0)
                move.l  #loc_21818,(a0)
                rts
; ---------------------------------------------------------------------------

loc_213D6:
                cmpi.b  #2,(Current_zone).w
                bne.s   loc_21428
                move.l  #Map_MGZBreakableWall,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$28,height_pixels(a0)
                move.l  #word_21A2A,$34(a0)
                move.l  #word_219DA,$38(a0)
                btst    #4,subtype(a0)
                beq.s   loc_21418
                move.l  #loc_21818,(a0)
                rts
; ---------------------------------------------------------------------------

loc_21418:
                cmpi.b  #2,mapping_frame(a0)
                bne.s   loc_21428
                move.l  #loc_2172E,(a0)
                rts
; ---------------------------------------------------------------------------

loc_21428:
                cmpi.b  #3,(Current_zone).w
                bne.s   loc_2146A
                move.l  #Map_CNZSOZBreakableWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_CNZMisc+$CF,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #word_21A7A,$34(a0)
                move.l  #word_21A9A,$38(a0)
                cmpi.b  #2,mapping_frame(a0)
                bne.s   loc_2146A
                move.l  #loc_21818,(a0)
                rts
; ---------------------------------------------------------------------------

loc_2146A:
                cmpi.b  #6,(Current_zone).w
                bne.s   loc_214A4
                move.l  #Map_LBZBreakableWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_LBZ2Misc,1,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #word_2199A,$34(a0)
                move.l  #word_219BA,$38(a0)
                move.l  #loc_21818,(a0)
                rts
; ---------------------------------------------------------------------------

loc_214A4:
                cmpi.b  #7,(Current_zone).w
                bne.s   loc_214DE
                move.l  #Map_MHZBreakableWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_MHZMisc+$4,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #word_21A7A,$34(a0)
                move.l  #word_21A9A,$38(a0)
                move.l  #loc_21818,(a0)
                rts
; ---------------------------------------------------------------------------

loc_214DE:
                cmpi.b  #8,(Current_zone).w
                bne.s   loc_21536
                move.l  #Map_CNZSOZBreakableWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZMisc+$C3,2,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #word_21A7A,$34(a0)
                move.l  #word_21A9A,$38(a0)
                move.l  #loc_21818,(a0)
                cmpi.b  #4,mapping_frame(a0)
                bne.s   locret_21534
                move.b  #$30,height_pixels(a0)
                move.l  #word_2193A,$34(a0)
                move.l  #word_2196A,$38(a0)

locret_21534:
                rts
; ---------------------------------------------------------------------------

loc_21536:
                cmpi.b  #9,(Current_zone).w
                bne.s   loc_21568
                move.l  #Map_LRZBreakableWall,mappings(a0)
                move.w  #make_art_tile(ArtTile_LRZ2Misc,3,0),art_tile(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                move.l  #word_21A7A,$34(a0)
                move.l  #word_21A9A,$38(a0)

loc_21568:
                move.w  (Player_1+x_vel).w,$30(a0)
                move.w  (Player_2+x_vel).w,$32(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                tst.b   subtype(a0)
                bpl.s   loc_215A4
                tst.b   (Level_trigger_array).w
                beq.s   loc_215AC
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_215A4:
                swap    d6
                andi.w  #3,d6
                bne.s   loc_215B2

loc_215AC:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_215B2:
                lea     (Player_1).w,a1
                move.w  $30(a0),d1
                move.w  d6,d0
                andi.w  #1,d0
                beq.s   loc_2162A
                tst.b   (Super_Sonic_Knux_flag).w
                bne.s   loc_215F4
                cmpi.b  #2,character_id(a1)
                beq.s   loc_215F4
                btst    #Status_FireShield,status_secondary(a1)
                bne.s   loc_215E0
                btst    #p1_pushing_bit,status(a0)
                beq.s   loc_2162A

loc_215E0:
                cmpi.b  #2,anim(a1)
                bne.s   loc_2162A
                move.w  d1,d0
                bpl.s   loc_215EE
                neg.w   d0

loc_215EE:
                cmpi.w  #$480,d0
                blo.s   loc_2162A

loc_215F4:
                bclr    #p1_pushing_bit,status(a0)
                bsr.s   BreakWallFromSideImpact
                btst    #p2_pushing_bit,status(a0)
                beq.s   loc_215AC
                lea     (Player_2).w,a1
                cmpi.b  #2,anim(a1)
                bne.s   loc_215AC
                move.w  $32(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #p2_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)
                bra.s   loc_215AC
; ---------------------------------------------------------------------------

loc_2162A:
                lea     (Player_2).w,a1
                move.w  $32(a0),d1
                btst    #p2_pushing_bit,status(a0)
                beq.w   loc_215AC
                cmpi.b  #2,anim(a1)
                bne.w   loc_215AC
                move.w  d1,d0
                bpl.s   loc_2164C
                neg.w   d0

loc_2164C:
                cmpi.w  #$480,d0
                blo.w   loc_215AC
                bclr    #p2_pushing_bit,status(a0)

; =============== S U B R O U T I N E =======================================

BreakWallFromSideImpact:
                move.w  d1,x_vel(a1)
                addq.w  #4,x_pos(a1)
                movea.l $34(a0),a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   loc_2167A
                subi.w  #8,x_pos(a1)
                movea.l $38(a0),a4

loc_2167A:
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)         ; set Sonic as not pushing an object
                move.l  #loc_21692,(a0)
                addq.b  #1,mapping_frame(a0)
                bsr.s   BreakObjectToPieces

loc_21692:
                jsr     (MoveSprite2).l
                addi.w  #$70,y_vel(a0)                  ; make obj fall
                tst.b   render_flags(a0)
                bpl.s   loc_216AA
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_216AA:
                jmp     (Delete_Current_Sprite).l
; End of function BreakWallFromSideImpact

; =============== S U B R O U T I N E =======================================

BreakObjectToPieces:
                moveq   #signextendB(sfx_Collapse),d0
                jsr     (Play_SFX).l
                move.w  #$80,priority(a0)               ; set priority again when being smashed

BreakObjectToPieces2:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                movea.l mappings(a0),a3                 ; get mapping pointer
                adda.w  (a3,d0.w),a3
                move.w  (a3)+,d1
                subq.w  #1,d1
                bset    #5,render_flags(a0)             ; set static mappings flag
                move.l  (a0),d4
                move.b  render_flags(a0),d5             ; get render flags
                movea.l a0,a1
                bra.s   BreakObjectToPieces_InitObject
; ---------------------------------------------------------------------------
; loc_216E2:
BreakObjectToPieces_Loop:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_2172C
                addq.w  #6,a3                           ; add to mappings

; loc_216EC:
BreakObjectToPieces_InitObject:
                move.l  d4,code(a1)                     ; get object pointer (in Sonic 1 and 2, this copies the object ID)
                move.l  a3,mappings(a1)                 ; get mappings pointer
                move.b  d5,render_flags(a1)             ; get render flags
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  art_tile(a0),art_tile(a1)
                ori.w   #high_priority,art_tile(a1)     ; change fragment's priority
                move.b  priority(a0),priority(a1)       ; copy priority
                move.b  width_pixels(a0),width_pixels(a1)
                move.b  height_pixels(a0),height_pixels(a1)
                move.w  (a4)+,x_vel(a1)
                move.w  (a4)+,y_vel(a1)
                dbf     d1,BreakObjectToPieces_Loop

locret_2172C:
                rts
; End of function BreakObjectToPieces

; ---------------------------------------------------------------------------

loc_2172E:
                move.w  (Player_1+x_vel).w,$30(a0)
                move.w  (Player_2+x_vel).w,$32(a0)
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
                andi.b  #3,d6
                beq.w   loc_217E8
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   loc_217BC
                lea     (Player_1).w,a1
                bclr    #6,$37(a1)
                beq.s   loc_217BC
                move.w  $30(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                bclr    #p1_pushing_bit,status(a0)
                bsr.s   BreakWallAfterLatchedSideCollision
                andi.b  #2,d6
                beq.s   loc_217E8
                lea     (Player_2).w,a1
                bclr    #6,$37(a1)
                beq.s   loc_217E8
                move.w  $32(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                bclr    #p2_pushing_bit,status(a0)
                bra.s   loc_217E8
; ---------------------------------------------------------------------------

loc_217BC:
                andi.b  #2,d6
                beq.s   loc_217E8
                lea     (Player_2).w,a1
                bclr    #6,$37(a1)
                beq.s   loc_217E8
                move.w  $32(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                bclr    #p2_pushing_bit,status(a0)
                bsr.s   BreakWallAfterLatchedSideCollision

loc_217E8:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

BreakWallAfterLatchedSideCollision:
                movea.l $34(a0),a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   loc_21806
                subi.w  #8,x_pos(a1)
                movea.l $38(a0),a4

loc_21806:
                move.l  #loc_21692,(a0)
                addq.b  #1,mapping_frame(a0)
                bsr.w   BreakObjectToPieces
                bra.w   loc_21692
; End of function BreakWallAfterLatchedSideCollision

; ---------------------------------------------------------------------------

loc_21818:
                move.w  (Player_1+x_vel).w,$30(a0)
                move.w  (Player_2+x_vel).w,$32(a0)
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                tst.b   subtype(a0)
                bpl.s   loc_21854
                tst.b   (Level_trigger_array).w
                beq.s   loc_2185C
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_21854:
                swap    d6
                andi.w  #3,d6
                bne.s   loc_21862

loc_2185C:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_21862:
                lea     (Player_1).w,a1
                move.w  $30(a0),d1
                move.w  d6,d0
                andi.w  #1,d0
                beq.s   loc_218B0
                cmpi.b  #2,character_id(a1)
                bne.s   loc_218B0
                bclr    #p1_pushing_bit,status(a0)
                bsr.s   BreakWallFromKnucklesImpact
                btst    #p2_pushing_bit,status(a0)
                beq.s   loc_2185C
                lea     (Player_2).w,a1
                cmpi.b  #2,character_id(a1)
                bne.s   loc_2185C
                move.w  $32(a0),x_vel(a1)
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #p2_pushing_bit,status(a0)
                bclr    #Status_Push,status(a1)
                bra.s   loc_2185C
; ---------------------------------------------------------------------------

loc_218B0:
                lea     (Player_2).w,a1
                move.w  $32(a0),d1
                btst    #p2_pushing_bit,status(a0)
                beq.s   loc_2185C
                cmpi.b  #2,character_id(a1)
                bne.s   loc_2185C
                bclr    #p2_pushing_bit,status(a0)

; =============== S U B R O U T I N E =======================================

BreakWallFromKnucklesImpact:
                move.w  d1,x_vel(a1)
                addq.w  #4,x_pos(a1)
                movea.l $34(a0),a4
                move.w  x_pos(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   loc_218EE
                subi.w  #8,x_pos(a1)
                movea.l $38(a0),a4

loc_218EE:
                move.w  x_vel(a1),ground_vel(a1)
                bclr    #Status_Push,status(a1)
                cmpi.b  #2,character_id(a1)
                bne.s   loc_21928
                cmpi.b  #1,double_jump_flag(a1)
                bne.s   loc_21928
                move.b  #2,double_jump_flag(a1)
                move.b  #$21,anim(a1)
                bclr    #Status_Facing,status(a1)
                tst.w   x_vel(a1)
                bpl.s   loc_21928
                bset    #Status_Facing,status(a1)

loc_21928:
                move.l  #loc_21692,(a0)
                addq.b  #1,mapping_frame(a0)
                bsr.w   BreakObjectToPieces
                bra.w   loc_21692
; End of function BreakWallFromKnucklesImpact

; ---------------------------------------------------------------------------
word_2193A:
                dc.w    $400, -$500
                dc.w    $600, -$600
                dc.w    $600, -$100
                dc.w    $800, -$200
                dc.w    $680,     0
                dc.w    $880,     0
                dc.w    $600,  $100
                dc.w    $800,  $200
                dc.w    $400,  $500
                dc.w    $600,  $600
                dc.w    $300,  $600
                dc.w    $500,  $700
word_2196A:
                dc.w    -$600, -$600
                dc.w    -$400, -$500
                dc.w    -$800, -$200
                dc.w    -$600, -$100
                dc.w    -$880,     0
                dc.w    -$680,     0
                dc.w    -$800,  $200
                dc.w    -$600,  $100
                dc.w    -$600,  $600
                dc.w    -$400,  $500
                dc.w    -$500,  $700
                dc.w    -$300,  $600
word_2199A:
                dc.w    $400, -$500
                dc.w    $600, -$600
                dc.w    $600, -$100
                dc.w    $800, -$200
                dc.w    $600,  $100
                dc.w    $800,  $200
                dc.w    $400,  $500
                dc.w    $600,  $600
word_219BA:
                dc.w    -$600, -$600
                dc.w    -$400, -$500
                dc.w    -$800, -$200
                dc.w    -$600, -$100
                dc.w    -$800,  $200
                dc.w    -$600,  $100
                dc.w    -$600,  $600
                dc.w    -$400,  $500
word_219DA:
                dc.w    $400, -$500
                dc.w    $500, -$580
                dc.w    $600, -$600
                dc.w    $700, -$680
                dc.w    $600, -$100
                dc.w    $700, -$180
                dc.w    $800, -$200
                dc.w    $900, -$280
                dc.w    $680,     0
                dc.w    $780,     0
                dc.w    $880,     0
                dc.w    $980,     0
                dc.w    $600,  $100
                dc.w    $700,  $180
                dc.w    $800,  $200
                dc.w    $900,  $280
                dc.w    $400,  $500
                dc.w    $500,  $580
                dc.w    $600,  $600
                dc.w    $700,  $680
word_21A2A:
                dc.w    -$700, -$680
                dc.w    -$600, -$600
                dc.w    -$500, -$580
                dc.w    -$400, -$500
                dc.w    -$900, -$280
                dc.w    -$800, -$200
                dc.w    -$700, -$180
                dc.w    -$600, -$100
                dc.w    -$980,     0
                dc.w    -$880,     0
                dc.w    -$780,     0
                dc.w    -$680,     0
                dc.w    -$900,  $280
                dc.w    -$800,  $200
                dc.w    -$700,  $180
                dc.w    -$600,  $100
                dc.w    -$700,  $680
                dc.w    -$600,  $600
                dc.w    -$500,  $580
                dc.w    -$400,  $500
word_21A7A:
                dc.w    $400, -$500
                dc.w    $600, -$600
                dc.w    $600, -$100
                dc.w    $800, -$200
                dc.w    $600,  $100
                dc.w    $800,  $200
                dc.w    $400,  $500
                dc.w    $600,  $600
word_21A9A:
                dc.w    -$600, -$600
                dc.w    -$400, -$500
                dc.w    -$800, -$200
                dc.w    -$600, -$100
                dc.w    -$800,  $200
                dc.w    -$600,  $100
                dc.w    -$600,  $600
                dc.w    -$400,  $500
Map_CNZSOZBreakableWall:
                include "src/objects/shared/zones/cnz/mappings/soz_breakable_wall.s"
Map_MHZBreakableWall:
                include "src/objects/shared/zones/mhz/mappings/breakable_wall.s"
Map_LRZBreakableWall:
                include "src/objects/shared/zones/lrz/mappings/breakable_wall.s"
