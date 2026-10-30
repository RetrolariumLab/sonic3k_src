; Owner: objects/shared/sk
; Responsibility: Collapsing platforms and bridges, player release, fragment creation, collapse timing and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CollapsingPlatform:
                move.l  #Map_AIZCollapsingPlatform,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                cmpi.w  #1,(Current_zone_and_act).w
                bne.s   loc_20522
                move.l  #Map_AIZCollapsingPlatform2,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)

loc_20522:
                move.l  #byte_20CB6,$30(a0)
                move.l  #byte_20E9E,$3C(a0)
                move.b  #$3C,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                cmpi.b  #5,(Current_zone).w
                bne.s   loc_20570
                move.l  #Map_ICZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.l  #byte_20CD4,$30(a0)
                move.l  #byte_20EDE,$3C(a0)
                move.b  #$30,width_pixels(a0)
                move.b  #$30,height_pixels(a0)

loc_20570:
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #7,$38(a0)
                move.b  subtype(a0),mapping_frame(a0)
                ori.b   #$80,status(a0)
                move.l  #loc_20594,(a0)

loc_20594:
                tst.b   $3A(a0)
                beq.s   loc_205A6
                tst.b   $38(a0)
                beq.w   ObjPlatformCollapse_CreateFragments
                subq.b  #1,$38(a0)

loc_205A6:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   sub_205B6
                move.b  #1,$3A(a0)

; =============== S U B R O U T I N E =======================================

sub_205B6:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                movea.l $3C(a0),a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
                bra.w   Sprite_OnScreen_Test
; End of function sub_205B6

; ---------------------------------------------------------------------------

loc_205CE:
                subq.b  #1,$38(a0)
                bne.s   loc_205DA
                move.l  #loc_20620,(a0)

loc_205DA:
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

loc_205DE:
                bsr.w   sub_205B6
                subq.b  #1,$38(a0)
                bne.s   locret_2061E
                move.l  #loc_20620,(a0)
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   sub_205FC
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6

; =============== S U B R O U T I N E =======================================

sub_205FC:
                btst    d6,status(a0)
                beq.s   locret_2061E
                bclr    d6,status(a0)
                bclr    #Status_OnObj,status(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,prev_anim(a1)

locret_2061E:
                rts
; End of function sub_205FC

; ---------------------------------------------------------------------------

loc_20620:
                tst.b   render_flags(a0)
                bpl.w   Delete_Current_Sprite
                bsr.w   MoveSprite
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

Obj_CollapsingBridge:
                move.l  #loc_2095E,(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                cmpi.b  #6,(Current_zone).w
                bne.s   loc_206B8
                move.b  subtype(a0),d0
                andi.w  #$3F,d0
                add.w   d0,d0
                add.w   d0,d0
                addq.w  #8,d0
                bcc.s   loc_2065E
                move.b  #-1,d0

loc_2065E:
                move.b  d0,$38(a0)
                btst    #6,subtype(a0)
                bne.s   loc_20696
                move.l  #Map_LBZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.l  #LBZBridgeCollapse_TimerArray,$30(a0)
                move.l  #LBZBridgeCollapse_TimerFlipArray,$34(a0)
                bra.s   loc_206B8
; ---------------------------------------------------------------------------

loc_20696:
                move.l  #Map_LBZCollapsingLedge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                move.l  #LBZLedgeCollapse_TimerArray,$30(a0)

loc_206B8:
                cmpi.b  #1,(Current_zone).w
                bne.w   loc_20752
                move.l  #Map_HCZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,1),art_tile(a0)
                move.b  subtype(a0),d0
                bpl.s   loc_206EA
                move.b  d0,d1
                andi.b  #$F,d1
                move.b  d1,$40(a0)
                move.l  #loc_20AF6,(a0)
                andi.b  #$70,d0

loc_206EA:
                move.b  d0,d1
                andi.w  #$F,d0
                lsl.w   #4,d0
                addq.w  #8,d0
                move.b  d0,$38(a0)
                andi.w  #$F0,d1
                lsr.w   #2,d1
                lea     byte_20722(pc,d1.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,subtype(a0)
                add.w   d1,d1
                lea     off_20732(pc,d1.w),a1
                move.l  (a1)+,$30(a0)
                move.l  (a1)+,$34(a0)
                bra.s   loc_20752
; ---------------------------------------------------------------------------
byte_20722:
                dc.b    $40, $10, 0, $80
                dc.b    $50, $10, 3, $80
                dc.b    $40, $10, 6,   0
                dc.b    $50, $20, 9, $80
off_20732:
                dc.l    byte_20D22, byte_20D32
                dc.l    byte_20D42, byte_20D56
                dc.l    byte_20D6A, byte_20D6A
                dc.l    byte_20D79, byte_20D91
; ---------------------------------------------------------------------------

loc_20752:
                cmpi.b  #2,(Current_zone).w
                bne.s   loc_207D4
                move.l  #Map_MGZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F,d0
                lsl.w   #4,d0
                addq.w  #8,d0
                move.b  d0,$38(a0)
                andi.w  #$F0,d1
                lsr.w   #2,d1
                lea     byte_207B0(pc,d1.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,subtype(a0)
                add.w   d1,d1
                lea     off_207BC(pc,d1.w),a1
                move.l  (a1)+,$30(a0)
                move.l  (a1)+,$34(a0)
                cmpi.w  #$10,d1
                bne.s   loc_207D4
                move.l  #loc_209D0,(a0)
                rts
; ---------------------------------------------------------------------------
byte_207B0:
                dc.b    $40, $20,   0, $80
                dc.b    $30, $20,   3, $80
                dc.b    $40, $20,   6, $80
off_207BC:
                dc.l    byte_20DA9, byte_20DC9
                dc.l    byte_20DE9, byte_20E01
                dc.l    byte_20DA9, byte_20DC9
; ---------------------------------------------------------------------------

loc_207D4:
                cmpi.b  #5,(Current_zone).w
                bne.s   loc_20834
                move.b  subtype(a0),d0
                bpl.s   loc_207F6
                move.b  d0,d1
                andi.b  #$F,d1
                move.b  d1,$40(a0)
                move.l  #loc_20AF6,(a0)
                andi.b  #$70,d0

loc_207F6:
                move.b  d0,d1
                andi.w  #$F,d0
                lsl.w   #4,d0
                addq.w  #8,d0
                move.b  d0,$38(a0)
                move.l  #Map_ICZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$50,width_pixels(a0)
                move.b  #$38,height_pixels(a0)
                move.l  #byte_20E19,$30(a0)
                move.l  #byte_20E45,$34(a0)
                move.b  #3,mapping_frame(a0)

loc_20834:
                cmpi.b  #$16,(Current_zone).w
                bne.s   loc_2084C
                move.l  #Map_HPZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                bra.s   loc_20862
; ---------------------------------------------------------------------------

loc_2084C:
                cmpi.b  #9,(Current_zone).w
                bne.s   loc_208A6
                move.l  #Map_LRZCollapsingPlatform,mappings(a0)
                move.w  #make_art_tile($090,2,0),art_tile(a0)

loc_20862:
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F,d0
                lsl.w   #4,d0
                addq.w  #8,d0
                move.b  d0,$38(a0)
                andi.w  #$70,d1
                lsr.w   #2,d1
                lea     byte_2089A(pc,d1.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                add.w   d1,d1
                lea     off_2089E(pc,d1.w),a1
                move.l  (a1)+,$30(a0)
                move.l  (a1)+,$34(a0)
                bra.s   loc_208A6
; ---------------------------------------------------------------------------
byte_2089A:
                dc.b    $20, $18,   0, $80
off_2089E:
                dc.l    byte_20E85, byte_20E91
; ---------------------------------------------------------------------------

loc_208A6:
                cmpi.b  #4,(Current_zone).w             ; is this FBZ?
                bne.s   loc_20904                       ; if not, branch
                move.l  #Map_FBZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F,d0
                lsl.w   #4,d0
                addq.w  #8,d0
                move.b  d0,$38(a0)
                andi.w  #$F0,d1
                lsr.w   #2,d1
                lea     FBZBridgeSpriteAttribute(pc,d1.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,subtype(a0)
                add.w   d1,d1
                lea     off_208FC(pc,d1.w),a1
                move.l  (a1)+,$30(a0)
                move.l  (a1)+,$34(a0)
                bra.s   loc_20904
; ---------------------------------------------------------------------------
FBZBridgeSpriteAttribute:
; width, height, frame, subtype
                dc.b    $40, $20,   0, $80
off_208FC:
                dc.l    byte_20DA9, byte_20DC9
; ---------------------------------------------------------------------------

loc_20904:
                cmpi.b  #8,(Current_zone).w             ; is this zone 8?
                bne.s   loc_2095E                       ; if not branch
                move.l  #Map_SOZCollapsingBridge,mappings(a0)  ; if yes, set its sprite properties
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1                           ; copy subtype
                andi.w  #$F,d0                          ; read first digit
                lsl.w   #4,d0                           ; multiply amount
                addq.w  #8,d0                           ; add 8 to it
                move.b  d0,$38(a0)                      ; copy the amount we got into $38 (custom variable)
                andi.w  #$70,d1
                lsr.w   #2,d1
                lea     byte_20952(pc,d1.w),a1
                move.b  (a1)+,width_pixels(a0)          ; get width
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                add.w   d1,d1                           ; multiply by 2
                lea     off_20956(pc,d1.w),a1
                move.l  (a1)+,$30(a0)
                move.l  (a1)+,$34(a0)
                bra.s   loc_2095E
; ---------------------------------------------------------------------------
byte_20952:
                dc.b    $20, $30,   0, $80
off_20956:
                dc.l    byte_20E71, byte_20E7B
; ---------------------------------------------------------------------------

loc_2095E:
                tst.b   $3A(a0)
                beq.s   loc_209A8
                tst.b   $38(a0)
                bne.s   loc_209A4
                movea.l $30(a0),a4
                tst.b   subtype(a0)                     ; does this object have a subtype?
                bpl.s   loc_209A0                       ; if yes, branch to here
                move.b  status(a0),d0                   ; if bit 7 of subtype set, collapse platform in direction dependent on player position
                andi.b  #standing_mask,d0
                beq.s   loc_209A0
                move.w  (Player_1+x_pos).w,d1
                andi.b  #8,d0
                bne.s   loc_2098C
                move.w  (Player_2+x_pos).w,d1

loc_2098C:
                cmp.w   x_pos(a0),d1                    ; compare object x pos with player's x pos (Sonic, Tails, Knuckles)
                bhs.s   loc_209A0                       ; if it's higher than player's x pos (x coordinates), then branch
                movea.l $34(a0),a4                      ; if it's less, get pointer to a4
                bchg    #0,status(a0)                   ; reverse status (flipping for this case)
                addq.b  #1,mapping_frame(a0)            ; add 1 to mapping frame

loc_209A0:
                bra.w   CollapsingPtfmHandlePlayerAndSmash
; ---------------------------------------------------------------------------

loc_209A4:
                subq.b  #1,$38(a0)

loc_209A8:
                move.b  status(a0),d0                   ; Check if player is standing on platform
                andi.b  #standing_mask,d0
                beq.s   loc_209B8
                move.b  #1,$3A(a0)                      ; Turn on collapsing timer

loc_209B8:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                bra.w   Sprite_OnScreen_Test
; ---------------------------------------------------------------------------

loc_209D0:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_20A52
                move.b  (Player_1+status_tertiary).w,d1
                andi.b  #8,d0
                bne.s   loc_209FC
                move.b  (Player_2+status_tertiary).w,d1

loc_209FC:
                tst.b   d1
                bpl.s   loc_20A52
                bclr    #p1_standing_bit,status(a0)
                beq.s   loc_20A12
                lea     (Player_1).w,a1
                bclr    #Status_OnObj,status(a1)

loc_20A12:
                bclr    #p2_standing_bit,status(a0)
                beq.s   loc_20A24
                lea     (Player_2).w,a1
                bclr    #Status_OnObj,status(a1)

loc_20A24:
                lea     (word_20A76).l,a4
                addq.b  #1,mapping_frame(a0)
                move.w  #$80,priority(a0)
                move.l  #loc_20A56,(a0)
                jsr     (BreakObjectToPieces).l
                move.w  respawn_addr(a0),d0             ; was obj spawned by layout?
                beq.s   loc_20A50                       ; if not, branch to function
                movea.w d0,a1                           ; if yes, get addr of respawn_table
                bclr    #7,(a1)                         ; set as unloaded
                clr.w   respawn_addr(a0)                ; clear that addr

loc_20A50:
                bra.s   loc_20A56
; ---------------------------------------------------------------------------

loc_20A52:
                bra.w   Sprite_OnScreen_Test
; ---------------------------------------------------------------------------

loc_20A56:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)                  ; make object fall
                tst.b   render_flags(a0)                ; is sprite on screen?
                bpl.w   loc_20A70                       ; no delete
                jmp     (Draw_Sprite).l                 ; if yes, then display
; ---------------------------------------------------------------------------

loc_20A70:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
word_20A76:
                dc.w    -$400, -$A00
                dc.w    -$300, -$A00
                dc.w    -$200, -$A00
                dc.w    -$100, -$A00
                dc.w    $100, -$A00
                dc.w    $200, -$A00
                dc.w    $300, -$A00
                dc.w    $400, -$A00
                dc.w    -$3C0, -$900
                dc.w    -$2C0, -$900
                dc.w    -$1C0, -$900
                dc.w    -$C0, -$900
                dc.w    $C0, -$900
                dc.w    $1C0, -$900
                dc.w    $2C0, -$900
                dc.w    $3C0, -$900
                dc.w    -$380, -$800
                dc.w    -$280, -$800
                dc.w    -$180, -$800
                dc.w    -$80, -$800
                dc.w    $80, -$800
                dc.w    $180, -$800
                dc.w    $280, -$800
                dc.w    $380, -$800
                dc.w    -$340, -$700
                dc.w    -$240, -$700
                dc.w    -$140, -$700
                dc.w    -$40, -$700
                dc.w    $40, -$700
                dc.w    $140, -$700
                dc.w    $240, -$700
                dc.w    $340, -$700
; ---------------------------------------------------------------------------

loc_20AF6:
                tst.b   $3A(a0)
                beq.s   loc_20B40
                tst.b   $38(a0)
                bne.s   loc_20B3C
                movea.l $30(a0),a4
                tst.b   subtype(a0)
                bpl.s   loc_20B38
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_20B38
                move.w  (Player_1+x_pos).w,d1
                andi.b  #8,d0
                bne.s   loc_20B24
                move.w  (Player_2+x_pos).w,d1

loc_20B24:
                cmp.w   x_pos(a0),d1
                bhs.s   loc_20B38
                movea.l $34(a0),a4
                bchg    #0,status(a0)
                addq.b  #1,mapping_frame(a0)

loc_20B38:
                bra.w   CollapsingPtfmHandlePlayerAndSmash
; ---------------------------------------------------------------------------

loc_20B3C:
                subq.b  #1,$38(a0)

loc_20B40:
                move.b  $40(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                tst.b   (a3)
                beq.s   loc_20B5E
                move.b  #1,$3A(a0)
                clr.w   respawn_addr(a0)

loc_20B5E:
                bra.w   loc_209B8
; ---------------------------------------------------------------------------

Obj_PlatformCollapseWait:
                subq.b  #1,$38(a0)
                bne.s   loc_20B6E
                move.l  #Obj_PlatformCollapseFall,(a0)

loc_20B6E:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_PlatformCollapseFall:
                tst.b   render_flags(a0)                ; is obj on screen?
                bpl.s   loc_20B86                       ; if not, delete
                jsr     (MoveSprite).l                  ; if yes, move sprite and display
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_20B86:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_PlatformCollapseWaitHandlePlayer:
                subq.b  #1,$38(a0)
                bne.s   loc_20B98
                move.l  #Obj_PlatformCollapseFall,(a0)

loc_20B98:
                move.b  $38(a0),d3
                movea.l $30(a0),a2
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   Check_CollapsePlayerRelease
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.s   Check_CollapsePlayerRelease
                bra.w   Sprite_OnScreen_Test

; =============== S U B R O U T I N E =======================================

Check_CollapsePlayerRelease:
                btst    d6,status(a0)
                beq.s   locret_20C10
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   loc_20BF4
                move.w  x_pos(a1),d0                    ; gets player's range from object
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_20BF4
                cmp.w   d2,d0
                bhs.s   loc_20BF4
                btst    #0,status(a0)
                beq.s   loc_20BE8
                neg.w   d0
                add.w   d2,d0

loc_20BE8:
                lsr.w   #4,d0
                move.b  (a2),d2
                sub.b   (a2,d0.w),d2
                cmp.b   d2,d3
                bhi.s   locret_20C10

loc_20BF4:
                bclr    d6,status(a0)
                bclr    #Status_OnObj,status(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,prev_anim(a1)

locret_20C10:
                rts
; End of function Check_CollapsePlayerRelease

; ---------------------------------------------------------------------------
; in s2disasm: Obj1F_CreateFragments
CollapsingPtfmHandlePlayerAndSmash:
                move.l  #Obj_PlatformCollapseWaitHandlePlayer,(a0)
                move.l  #Obj_PlatformCollapseWait,d4
                addq.b  #1,mapping_frame(a0)
                bra.s   ObjPlatformCollapse_SmashObject
; ---------------------------------------------------------------------------

ObjPlatformCollapse_CreateFragments:
                move.l  #loc_205DE,(a0)
                move.l  #loc_205CE,d4
                addq.b  #2,mapping_frame(a0)
                movea.l $30(a0),a4

ObjPlatformCollapse_SmashObject:
                moveq   #0,d0
                move.b  mapping_frame(a0),d0
                add.w   d0,d0
                movea.l mappings(a0),a3
                adda.w  (a3,d0.w),a3
                move.w  (a3)+,d1
                subq.w  #1,d1
                bset    #5,render_flags(a0)             ; set flag to "static mappings flag"
                move.b  render_flags(a0),d5             ; get render type
                movea.l a0,a1
                bra.s   GetFragmentsSpriteProperties
; ---------------------------------------------------------------------------

GetFragmentsSlotsloop:
                bsr.w   AllocateObjectAfterCurrent
                bne.s   FragmentsDrawAndPlaySfx
                addq.w  #6,a3                           ; in Sonic 2's mapping format, this is just addq.w #8,a3 due to different mapping format sizes (addq.w #5,a3 for Sonic 1)
                move.l  d4,(a1)

GetFragmentsSpriteProperties:
                move.l  a3,mappings(a1)
                move.b  d5,render_flags(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.w  priority(a0),priority(a1)
                move.b  width_pixels(a0),width_pixels(a1)
                move.b  height_pixels(a0),height_pixels(a1)
                move.b  (a4)+,$38(a1)
                dbf     d1,GetFragmentsSlotsloop

FragmentsDrawAndPlaySfx:
                jsr     (Draw_Sprite).l
                move.w  respawn_addr(a0),d0
                beq.s   .CollapsingPtfmPlaySfx          ; function when object isn't spawned by layout (plays sound anyway)
                movea.w d0,a1
                bclr    #7,(a1)
                clr.w   respawn_addr(a0)

                .CollapsingPtfmPlaySfx:
                moveq   #signextendB(sfx_Collapse),d0
                jmp     (Play_SFX).l
; ---------------------------------------------------------------------------
byte_20CB6:
                dc.b    $30, $2C, $28, $24, $20, $1C, $2E, $2A, $26, $22, $1E, $1A, $2C, $28, $24, $20, $1C, $18, $2A, $26
                dc.b    $22, $1E, $1A, $16, $28, $24, $20, $1C, $18, $14
byte_20CD4:
                dc.b    $30, $2C, $28, $24, $20, $1C, $2E, $2A, $26, $22, $1E, $1A, $2C, $28, $24, $20, $1C, $18, $2A, $26
                dc.b    $22, $1E, $1A, $16, $28, $24, $20, $1C, $18, $14, $12, $10
LBZBridgeCollapse_TimerArray:
                dc.b    $20, $1C, $18, $14, $10,  $C,   8,   4, $1E, $1A, $16, $12,  $E,  $A,   6,   2
LBZBridgeCollapse_TimerFlipArray:
                dc.b    $20,   4,   8,  $C, $10, $14, $18, $1C,   2,   6,  $A,  $E, $12, $16, $1A, $1E
LBZLedgeCollapse_TimerArray:
                dc.b    $20, $18, $10,   8, $1E, $16,  $E,   6, $1C, $14,  $C,   4, $1A, $12
byte_20D22:
                dc.b    $20, $1C, $18, $14, $10,  $C,   8,   4, $1E, $1A, $16, $12,  $E,  $A,   6,   2
byte_20D32:
                dc.b    $20,   4,   8,  $C, $10, $14, $18, $1C,   2,   6,  $A,  $E, $12, $16, $1A, $1E
byte_20D42:
                dc.b    $28, $24, $20, $1C, $18, $14, $10,  $C,   8,   4, $26, $22, $1E, $1A, $16, $12,  $E,  $A,   6,   2
byte_20D56:
                dc.b    $28,   4,   8,  $C, $10, $14, $18, $1C, $20, $24,   2,   6,  $A,  $E, $12, $16, $1A, $1E, $22, $26
byte_20D6A:
                dc.b    $1C,   4,   8,  $C, $10, $14, $18,   2,   6,  $A,  $E, $12, $16, $1A, $1E
byte_20D79:
                dc.b    $30, $2A, $24, $1E, $18, $12,  $C,   6, $2E, $28, $22, $1C, $16, $10,  $A,   4, $2C, $26, $20, $1A
                dc.b    $14,  $E,   8,   2
byte_20D91:
                dc.b    $30,   6,  $C, $12, $18, $1E, $24, $2A,   4,  $A, $10, $16, $1C, $22, $28, $2E,   2,   8,  $E, $14
                dc.b    $1A, $20, $26, $2C
byte_20DA9:
                dc.b    $40, $38, $30, $28, $20, $18, $10,   8, $3E, $36, $2E, $26, $1E, $16,  $E,   6, $3C, $34, $2C, $24
                dc.b    $1C, $14,  $C,   4, $3A, $32, $2A, $22, $1A, $12,  $A,   2
byte_20DC9:
                dc.b    $40,   8, $10, $18, $20, $28, $30, $38,   6,  $E, $16, $1E, $26, $2E, $36, $3E,   4,  $C, $14, $1C
                dc.b    $24, $2C, $34, $3C,   2,  $A, $12, $1A, $22, $2A, $32, $3A
byte_20DE9:
                dc.b    $30, $28, $20, $18, $10,   8, $2E, $26, $1E, $16,  $E,   6, $2C, $24, $1C, $14,  $C,   4, $2A, $22
                dc.b    $1A, $12,  $A,   2
byte_20E01:
                dc.b    $30,   8, $10, $18, $20, $28,   6,  $E, $16, $1E, $26, $2E,   4,  $C, $14, $1C, $24, $2C,   2,  $A
                dc.b    $12, $1A, $22, $2A
byte_20E19:
                dc.b    $28, $24, $20, $1C, $18, $14, $10,  $C,   8,   4, $27, $23, $1F, $1B, $17, $13,  $F,  $B,   7,   3
                dc.b    $26, $22, $1E, $1A, $16, $12,  $E,  $A,   6,   2, $25, $21, $1D, $19, $15, $11,  $D,   9,   5,   1
                dc.b    4,   3,   2,   1
byte_20E45:
                dc.b    $28,   4,   8,  $C, $10, $14, $18, $1C, $20, $24,   3,   7,  $B,  $F, $13, $17, $1B, $1F, $23, $27
                dc.b    2,   6,  $A,  $E, $12, $16, $1A, $1E, $22, $26,   1,   5,   9,  $D, $11, $15, $19, $1D, $21, $25
                dc.b    1,   2,   3,   4
byte_20E71:
                dc.b    $20, $18, $10,   8, $1E, $16, $1C, $14, $1A, $12
byte_20E7B:
                dc.b    $20,   8, $10, $18,   6,  $E,   4,  $C,   2,  $A
byte_20E85:
                dc.b    $18, $12,  $C,   6, $16, $10,  $A,   4, $14,  $E,   8,   2
byte_20E91:
                dc.b    $18,   6,  $C, $12,   4,  $A, $10, $16,   2,   8,  $E, $14,   0
byte_20E9E:
                dc.b    $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F
                dc.b    $1F, $1F, $1E, $1E, $1D, $1D, $1C, $1C, $1B, $1B, $1A, $1A, $19, $19, $18, $18, $17, $17, $16, $16
                dc.b    $15, $15, $14, $14, $13, $13, $12, $12, $11, $11, $10, $10,  $F,  $F,  $E,  $E,  $E,  $E,  $E,  $E
                dc.b    $E,  $E,  $E,  $E
byte_20EDE:
                dc.b    $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F
                dc.b    $2F, $2F, $2F, $2F, $2E, $2E, $2E, $2E, $2E, $2E, $2E, $2E, $2D, $2D, $2D, $2D, $2D, $2D, $2D, $2D
                dc.b    $2D, $2D, $2D, $2D, $2D, $2C, $2B, $2A
Map_LRZCollapsingPlatform:
                include "src/objects/shared/zones/lrz/map_collapsing_platform.s"
Map_HPZCollapsingBridge:
                include "src/objects/shared/zones/hpz/map_collapsing_bridge.s"
Map_FBZCollapsingBridge:
                include "src/objects/shared/zones/fbz/map_collapsing_bridge.s"
Map_SOZCollapsingBridge:
                include "src/objects/shared/zones/soz/map_collapsing_bridge.s"
