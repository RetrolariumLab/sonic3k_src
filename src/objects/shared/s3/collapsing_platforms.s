; Owner: objects/shared/s3
; Responsibility: Collapsing platforms and bridges, player release, fragment creation, collapse timing and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CollapsingPlatform:
                move.l  #Map_AIZCollapsingPlatform,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                cmpi.w  #1,(Current_zone_and_act).w
                bne.s   loc_1DE40
                move.l  #Map_AIZCollapsingPlatform2,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)

loc_1DE40:
                move.l  #byte_1E49C,$30(a0)
                move.l  #byte_1E658,$3C(a0)
                move.b  #$3C,width_pixels(a0)
                move.b  #$20,height_pixels(a0)
                cmpi.b  #5,(Current_zone).w
                bne.s   loc_1DE8E
                move.l  #Map_ICZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.l  #byte_1E4BA,$30(a0)
                move.l  #byte_1E698,$3C(a0)
                move.b  #$30,width_pixels(a0)
                move.b  #$30,height_pixels(a0)

loc_1DE8E:
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                move.b  #7,$38(a0)
                move.b  subtype(a0),mapping_frame(a0)
                ori.b   #$80,status(a0)
                move.l  #loc_1DEB2,(a0)

loc_1DEB2:
                tst.b   $3A(a0)
                beq.s   loc_1DEC4
                tst.b   $38(a0)
                beq.w   ObjPlatformCollapse_CreateFragments
                subq.b  #1,$38(a0)

loc_1DEC4:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   sub_1DED4
                move.b  #1,$3A(a0)

; =============== S U B R O U T I N E =======================================

sub_1DED4:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                movea.l $3C(a0),a2
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTopSloped2).l
                bra.w   Sprite_OnScreen_Test
; End of function sub_1DED4

; ---------------------------------------------------------------------------

loc_1DEEC:
                tst.b   $38(a0)
                beq.s   loc_1DF3C
                tst.b   $3A(a0)
                bne.s   loc_1DF00
                subq.b  #1,$38(a0)
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

loc_1DF00:
                bsr.w   sub_1DED4
                subq.b  #1,$38(a0)
                bne.s   locret_1DF3A
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   sub_1DF18
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6

; =============== S U B R O U T I N E =======================================

sub_1DF18:
                btst    d6,status(a0)
                beq.s   locret_1DF3A
                bclr    d6,status(a0)
                bclr    #Status_OnObj,status(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,prev_anim(a1)

locret_1DF3A:
                rts
; End of function sub_1DF18

; ---------------------------------------------------------------------------

loc_1DF3C:
                bsr.w   MoveSprite
                tst.b   render_flags(a0)
                bpl.w   Delete_Current_Sprite
                bra.w   Draw_Sprite
; ---------------------------------------------------------------------------

Obj_CollapsingBridge:
                move.l  #loc_1E150,(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$280,priority(a0)
                cmpi.b  #6,(Current_zone).w
                bne.s   loc_1DFD4
                move.b  subtype(a0),d0
                andi.w  #$3F,d0
                add.w   d0,d0
                add.w   d0,d0
                addq.w  #8,d0
                bcc.s   loc_1DF7A
                move.b  #-1,d0

loc_1DF7A:
                move.b  d0,$38(a0)
                btst    #6,subtype(a0)
                bne.s   loc_1DFB2
                move.l  #Map_LBZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.l  #LBZBridgeCollapse_TimerArray,$30(a0)
                move.l  #LBZBridgeCollapse_TimerFlipArray,$34(a0)
                bra.s   loc_1DFD4
; ---------------------------------------------------------------------------

loc_1DFB2:
                move.l  #Map_LBZCollapsingLedge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                move.l  #LBZLedgeCollapse_TimerArray,$30(a0)

loc_1DFD4:
                cmpi.b  #1,(Current_zone).w
                bne.w   loc_1E06E
                move.l  #Map_HCZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,1),art_tile(a0)
                move.b  subtype(a0),d0
                bpl.s   loc_1E006
                move.b  d0,d1
                andi.b  #$F,d1
                move.b  d1,$40(a0)
                move.l  #loc_1E2E8,(a0)
                andi.b  #$70,d0

loc_1E006:
                move.b  d0,d1
                andi.w  #$F,d0
                lsl.w   #4,d0
                addq.w  #8,d0
                move.b  d0,$38(a0)
                andi.w  #$F0,d1
                lsr.w   #2,d1
                lea     byte_1E03E(pc,d1.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,subtype(a0)
                add.w   d1,d1
                lea     off_1E04E(pc,d1.w),a1
                move.l  (a1)+,$30(a0)
                move.l  (a1)+,$34(a0)
                bra.s   loc_1E06E
; ---------------------------------------------------------------------------
byte_1E03E:
                dc.b    $40, $10, 0, $80
                dc.b    $50, $10, 3, $80
                dc.b    $40, $10, 6,   0
                dc.b    $50, $20, 9, $80
off_1E04E:
                dc.l    byte_1E508, byte_1E518
                dc.l    byte_1E528, byte_1E53C
                dc.l    byte_1E550, byte_1E550
                dc.l    byte_1E55F, byte_1E577
; ---------------------------------------------------------------------------

loc_1E06E:
                cmpi.b  #2,(Current_zone).w
                bne.s   loc_1E0F0
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
                lea     byte_1E0CC(pc,d1.w),a1
                move.b  (a1)+,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.b  (a1)+,subtype(a0)
                add.w   d1,d1
                lea     off_1E0D8(pc,d1.w),a1
                move.l  (a1)+,$30(a0)
                move.l  (a1)+,$34(a0)
                cmpi.w  #$10,d1
                bne.s   loc_1E0F0
                move.l  #loc_1E1C2,(a0)
                rts
; ---------------------------------------------------------------------------
byte_1E0CC:
                dc.b    $40, $20,   0, $80
                dc.b    $30, $20,   3, $80
                dc.b    $40, $20,   6, $80
off_1E0D8:
                dc.l    byte_1E58F, byte_1E5AF
                dc.l    byte_1E5CF, byte_1E5E7
                dc.l    byte_1E58F, byte_1E5AF
; ---------------------------------------------------------------------------

loc_1E0F0:
                cmpi.b  #5,(Current_zone).w
                bne.s   loc_1E150
                move.b  subtype(a0),d0
                bpl.s   loc_1E112
                move.b  d0,d1
                andi.b  #$F,d1
                move.b  d1,$40(a0)
                move.l  #loc_1E2E8,(a0)
                andi.b  #$70,d0

loc_1E112:
                move.b  d0,d1
                andi.w  #$F,d0
                lsl.w   #4,d0
                addq.w  #8,d0
                move.b  d0,$38(a0)
                move.l  #Map_ICZCollapsingBridge,mappings(a0)
                move.w  #make_art_tile($001,2,0),art_tile(a0)
                move.b  #$50,width_pixels(a0)
                move.b  #$38,height_pixels(a0)
                move.l  #byte_1E5FF,$30(a0)
                move.l  #byte_1E62B,$34(a0)
                move.b  #3,mapping_frame(a0)

loc_1E150:
                tst.b   $3A(a0)
                beq.s   loc_1E19A
                tst.b   $38(a0)
                bne.s   loc_1E196
                movea.l $30(a0),a4
                tst.b   subtype(a0)                     ; does this object have a subtype?
                bpl.s   loc_1E192                       ; if yes, branch to here
                move.b  status(a0),d0                   ; if bit 7 of subtype set, collapse platform in direction dependent on player position
                andi.b  #standing_mask,d0
                beq.s   loc_1E192
                move.w  (Player_1+x_pos).w,d1
                andi.b  #8,d0
                bne.s   loc_1E17E
                move.w  (Player_2+x_pos).w,d1

loc_1E17E:
                cmp.w   x_pos(a0),d1                    ; compare object x pos with player's x pos (Sonic, Tails)
                bhs.s   loc_1E192                       ; if it's higher than player's x pos (x coordinates), then branch
                movea.l $34(a0),a4                      ; if it's less, get pointer to a4
                bchg    #0,status(a0)                   ; reverse status (flipping for this case)
                addq.b  #1,mapping_frame(a0)            ; add 1 to mapping frame

loc_1E192:
                bra.w   CollapsingPtfmHandlePlayerAndSmash
; ---------------------------------------------------------------------------

loc_1E196:
                subq.b  #1,$38(a0)

loc_1E19A:
                move.b  status(a0),d0                   ; Check if player is standing on platform
                andi.b  #standing_mask,d0
                beq.s   loc_1E1AA
                move.b  #1,$3A(a0)                      ; Turn on collapsing timer

loc_1E1AA:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                bra.w   Sprite_OnScreen_Test
; ---------------------------------------------------------------------------

loc_1E1C2:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  #$10,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_1E244
                move.b  (Player_1+status_tertiary).w,d1
                andi.b  #8,d0
                bne.s   loc_1E1EE
                move.b  (Player_2+status_tertiary).w,d1

loc_1E1EE:
                tst.b   d1
                bpl.s   loc_1E244
                bclr    #p1_standing_bit,status(a0)
                beq.s   loc_1E204
                lea     (Player_1).w,a1
                bclr    #Status_OnObj,status(a1)

loc_1E204:
                bclr    #p2_standing_bit,status(a0)
                beq.s   loc_1E216
                lea     (Player_2).w,a1
                bclr    #Status_OnObj,status(a1)

loc_1E216:
                lea     (word_1E268).l,a4
                addq.b  #1,mapping_frame(a0)
                move.w  #$80,priority(a0)
                move.l  #loc_1E248,(a0)
                jsr     (BreakObjectToPieces).l
                move.w  respawn_addr(a0),d0             ; was obj spawned by layout?
                beq.s   loc_1E242                       ; if not, branch to function
                movea.w d0,a1                           ; if yes, get addr of respawn_table
                bclr    #7,(a1)                         ; set as unloaded
                clr.w   respawn_addr(a0)                ; clear that addr

loc_1E242:
                bra.s   loc_1E248
; ---------------------------------------------------------------------------

loc_1E244:
                bra.w   Sprite_OnScreen_Test
; ---------------------------------------------------------------------------

loc_1E248:
                jsr     (MoveSprite2).l
                addi.w  #$18,y_vel(a0)                  ; make object fall
                tst.b   render_flags(a0)                ; is sprite on screen?
                bpl.w   loc_1E262                       ; no delete
                jmp     (Draw_Sprite).l                 ; if yes, then display
; ---------------------------------------------------------------------------

loc_1E262:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
word_1E268:
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

loc_1E2E8:
                tst.b   $3A(a0)
                beq.s   loc_1E332
                tst.b   $38(a0)
                bne.s   loc_1E32E
                movea.l $30(a0),a4
                tst.b   subtype(a0)
                bpl.s   loc_1E32A
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_1E32A
                move.w  (Player_1+x_pos).w,d1
                andi.b  #8,d0
                bne.s   loc_1E316
                move.w  (Player_2+x_pos).w,d1

loc_1E316:
                cmp.w   x_pos(a0),d1
                bhs.s   loc_1E32A
                movea.l $34(a0),a4
                bchg    #0,status(a0)
                addq.b  #1,mapping_frame(a0)

loc_1E32A:
                bra.w   CollapsingPtfmHandlePlayerAndSmash
; ---------------------------------------------------------------------------

loc_1E32E:
                subq.b  #1,$38(a0)

loc_1E332:
                move.b  $40(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                tst.b   (a3)
                beq.s   loc_1E350
                move.b  #1,$3A(a0)
                clr.w   respawn_addr(a0)

loc_1E350:
                bra.w   loc_1E1AA
; ---------------------------------------------------------------------------

Obj_PlatformCollapseWait:
                tst.b   $38(a0)
                beq.w   Obj_PlatformCollapseFall
                tst.b   $3A(a0)
                bne.s   Obj_PlatformCollapseWaitHandlePlayer
                subq.b  #1,$38(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_PlatformCollapseFall:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)                ; is obj on screen?
                bpl.s   loc_1E37E                       ; if not, delete
                jmp     (Draw_Sprite).l                 ; if yes, display
; ---------------------------------------------------------------------------

loc_1E37E:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_PlatformCollapseWaitHandlePlayer:
                subq.b  #1,$38(a0)
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
                beq.s   locret_1E400
                move.w  d1,d2
                add.w   d2,d2
                btst    #Status_InAir,status(a1)
                bne.s   loc_1E3E4
                move.w  x_pos(a1),d0                    ; gets player's range from object
                sub.w   x_pos(a0),d0
                add.w   d1,d0
                bmi.s   loc_1E3E4
                cmp.w   d2,d0
                bhs.s   loc_1E3E4
                btst    #0,status(a0)
                beq.s   loc_1E3D8
                neg.w   d0
                add.w   d2,d0

loc_1E3D8:
                lsr.w   #4,d0
                move.b  (a2),d2
                sub.b   (a2,d0.w),d2
                cmp.b   d2,d3
                bhi.s   locret_1E400

loc_1E3E4:
                bclr    d6,status(a0)
                bclr    #Status_OnObj,status(a1)
                bclr    #Status_Push,status(a1)
                bset    #Status_InAir,status(a1)
                move.b  #1,prev_anim(a1)

locret_1E400:
                rts
; End of function Check_CollapsePlayerRelease

; ---------------------------------------------------------------------------
; in s2disasm: Obj1F_CreateFragments
CollapsingPtfmHandlePlayerAndSmash:
                move.l  #Obj_PlatformCollapseWait,(a0)
                addq.b  #1,mapping_frame(a0)
                bra.s   ObjPlatformCollapse_SmashObject
; ---------------------------------------------------------------------------

ObjPlatformCollapse_CreateFragments:
                move.l  #loc_1DEEC,(a0)
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
                move.l  (a0),d4
                move.b  render_flags(a0),d5             ; get render type
                movea.l a0,a1
                bra.s   GetFragmentsSpriteProperties
; ---------------------------------------------------------------------------

GetFragmentsSlotsloop:
                bsr.w   AllocateObjectAfterCurrent
                bne.s   FragmentsDrawAndPlaySfx
                addq.w  #6,a3                           ; in Sonic 2's mapping format, this is just addq.w #8,a3 due to different mapping format sizes (addq.w #5,a3 for Sonic 1)

GetFragmentsSpriteProperties:
                move.l  d4,(a1)
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
byte_1E49C:
                dc.b    $30, $2C, $28, $24, $20, $1C, $2E, $2A, $26, $22, $1E, $1A, $2C, $28, $24, $20, $1C, $18, $2A, $26
                dc.b    $22, $1E, $1A, $16, $28, $24, $20, $1C, $18, $14
byte_1E4BA:
                dc.b    $30, $2C, $28, $24, $20, $1C, $2E, $2A, $26, $22, $1E, $1A, $2C, $28, $24, $20, $1C, $18, $2A, $26
                dc.b    $22, $1E, $1A, $16, $28, $24, $20, $1C, $18, $14, $12, $10
LBZBridgeCollapse_TimerArray:
                dc.b    $20, $1C, $18, $14, $10,  $C,   8,   4, $1E, $1A, $16, $12,  $E,  $A,   6,   2
LBZBridgeCollapse_TimerFlipArray:
                dc.b    $20,   4,   8,  $C, $10, $14, $18, $1C,   2,   6,  $A,  $E, $12, $16, $1A, $1E
LBZLedgeCollapse_TimerArray:
                dc.b    $20, $18, $10,   8, $1E, $16,  $E,   6, $1C, $14,  $C,   4, $1A, $12
byte_1E508:
                dc.b    $20, $1C, $18, $14, $10,  $C,   8,   4, $1E, $1A, $16, $12,  $E,  $A,   6,   2
byte_1E518:
                dc.b    $20,   4,   8,  $C, $10, $14, $18, $1C,   2,   6,  $A,  $E, $12, $16, $1A, $1E
byte_1E528:
                dc.b    $28, $24, $20, $1C, $18, $14, $10,  $C,   8,   4, $26, $22, $1E, $1A, $16, $12,  $E,  $A,   6,   2
byte_1E53C:
                dc.b    $28,   4,   8,  $C, $10, $14, $18, $1C, $20, $24,   2,   6,  $A,  $E, $12, $16, $1A, $1E, $22, $26
byte_1E550:
                dc.b    $1C,   4,   8,  $C, $10, $14, $18,   2,   6,  $A,  $E, $12, $16, $1A, $1E
byte_1E55F:
                dc.b    $30, $2A, $24, $1E, $18, $12,  $C,   6, $2E, $28, $22, $1C, $16, $10,  $A,   4, $2C, $26, $20, $1A
                dc.b    $14,  $E,   8,   2
byte_1E577:
                dc.b    $30,   6,  $C, $12, $18, $1E, $24, $2A,   4,  $A, $10, $16, $1C, $22, $28, $2E,   2,   8,  $E, $14
                dc.b    $1A, $20, $26, $2C
byte_1E58F:
                dc.b    $40, $38, $30, $28, $20, $18, $10,   8, $3E, $36, $2E, $26, $1E, $16,  $E,   6, $3C, $34, $2C, $24
                dc.b    $1C, $14,  $C,   4, $3A, $32, $2A, $22, $1A, $12,  $A,   2
byte_1E5AF:
                dc.b    $40,   8, $10, $18, $20, $28, $30, $38,   6,  $E, $16, $1E, $26, $2E, $36, $3E,   4,  $C, $14, $1C
                dc.b    $24, $2C, $34, $3C,   2,  $A, $12, $1A, $22, $2A, $32, $3A
byte_1E5CF:
                dc.b    $30, $28, $20, $18, $10,   8, $2E, $26, $1E, $16,  $E,   6, $2C, $24, $1C, $14,  $C,   4, $2A, $22
                dc.b    $1A, $12,  $A,   2
byte_1E5E7:
                dc.b    $30,   8, $10, $18, $20, $28,   6,  $E, $16, $1E, $26, $2E,   4,  $C, $14, $1C, $24, $2C,   2,  $A
                dc.b    $12, $1A, $22, $2A
byte_1E5FF:
                dc.b    $28, $24, $20, $1C, $18, $14, $10,  $C,   8,   4, $27, $23, $1F, $1B, $17, $13,  $F,  $B,   7,   3
                dc.b    $26, $22, $1E, $1A, $16, $12,  $E,  $A,   6,   2, $25, $21, $1D, $19, $15, $11,  $D,   9,   5,   1
                dc.b    4,   3,   2,   1
byte_1E62B:
                dc.b    $28,   4,   8,  $C, $10, $14, $18, $1C, $20, $24,   3,   7,  $B,  $F, $13, $17, $1B, $1F, $23, $27
                dc.b    2,   6,  $A,  $E, $12, $16, $1A, $1E, $22, $26,   1,   5,   9,  $D, $11, $15, $19, $1D, $21, $25
                dc.b    1,   2,   3,   4,   0
byte_1E658:
                dc.b    $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F, $1F
                dc.b    $1F, $1F, $1E, $1E, $1D, $1D, $1C, $1C, $1B, $1B, $1A, $1A, $19, $19, $18, $18, $17, $17, $16, $16
                dc.b    $15, $15, $14, $14, $13, $13, $12, $12, $11, $11, $10, $10,  $F,  $F,  $E,  $E,  $E,  $E,  $E,  $E
                dc.b    $E,  $E,  $E,  $E
byte_1E698:
                dc.b    $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F
                dc.b    $2F, $2F, $2F, $2F, $2E, $2E, $2E, $2E, $2E, $2E, $2E, $2E, $2D, $2D, $2D, $2D, $2D, $2D, $2D, $2D
                dc.b    $2D, $2D, $2D, $2D, $2D, $2C, $2B, $2A
Map_AIZCollapsingPlatform:
                include "src/objects/shared/zones/aiz/mappings/collapsing_platform.s"
Map_AIZCollapsingPlatform2:
                include "src/objects/shared/zones/aiz/mappings/collapsing_platform_2.s"
Map_LBZCollapsingBridge:
                include "src/objects/shared/zones/lbz/mappings/collapsing_bridge.s"
Map_LBZCollapsingLedge:
                include "src/objects/shared/zones/lbz/mappings/collapsing_ledge.s"
Map_HCZCollapsingBridge:
                include "src/objects/shared/zones/hcz/mappings/collapsing_bridge.s"
Map_MGZCollapsingBridge:
                include "src/objects/shared/zones/mgz/mappings/collapsing_bridge.s"
Map_ICZCollapsingBridge:
                include "src/objects/shared/zones/icz/mappings/collapsing_bridge.s"
