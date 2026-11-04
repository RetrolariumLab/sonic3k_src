; Owner: objects/zones/hcz/s3
; Responsibility: Hydrocity breakable bar attachment, movement, breakage and shared player geometry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
S3BreakableBar_AttrsBySubtype:
                dc.b    $14, $28, $20,   0
                dc.b    $24, $48, $30,   1
                dc.b    $34, $68, $40,   2
                even
; ---------------------------------------------------------------------------

Obj_HCZBreakableBar:
                move.l  #Map_HCZBreakableBar,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZMisc,2,0),art_tile(a0)
                move.b  #4,render_flags(a0)
                move.w  #$200,priority(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,d1
                andi.b  #$F,d0
                mulu.w  #60,d0
                move.w  d0,$30(a0)
                andi.w  #$30,d1
                lsr.w   #2,d1
                lea     S3BreakableBar_AttrsBySubtype(pc,d1.w),a1
                tst.b   subtype(a0)
                bpl.s   S3BreakableBar_InitVerticalBar
                moveq   #0,d0
                move.b  (a1)+,d0
                move.w  d0,$36(a0)
                move.b  (a1)+,d0
                move.w  d0,$38(a0)
                move.b  (a1)+,width_pixels(a0)
                move.b  #4,height_pixels(a0)
                move.b  (a1)+,d0
                addq.b  #4,d0
                move.b  d0,mapping_frame(a0)
                move.l  #S3BreakableBar_TickHorizontalBreakTimer,(a0)
                bra.w   S3BreakableBar_TickHorizontalBreakTimer
; ---------------------------------------------------------------------------

S3BreakableBar_InitVerticalBar:
                moveq   #0,d0
                move.b  (a1)+,d0
                move.w  d0,$36(a0)
                move.b  (a1)+,d0
                move.w  d0,$38(a0)
                move.b  #4,width_pixels(a0)
                move.b  (a1)+,height_pixels(a0)
                move.b  (a1)+,mapping_frame(a0)
                move.l  #S3BreakableBar_TickVerticalBreakTimer,(a0)

S3BreakableBar_TickVerticalBreakTimer:
                lea     $32(a0),a2
                tst.w   $30(a0)
                beq.s   S3BreakableBar_UpdateVerticalRiders
                tst.w   (a2)
                beq.s   S3BreakableBar_UpdateVerticalRiders
                subq.w  #1,$30(a0)
                beq.w   S3BreakableBar_ReleaseVerticalP1

S3BreakableBar_UpdateVerticalRiders:
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d1
                moveq   #0,d2
                bsr.s   UpdatePlayerOnHczVerticalBreakableBar
                addq.w  #1,a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2).w,d1
                moveq   #1,d2
                bsr.s   UpdatePlayerOnHczVerticalBreakableBar
                tst.b   $3A(a0)
                bne.w   S3BreakableBar_ReleaseVerticalP1
                bra.w   Sprite_OnScreen_Test

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnHczVerticalBreakableBar:
                tst.b   (a2)
                beq.s   S3BreakableBar_TickVerticalRegrabDelay
                move.w  y_pos(a0),d0
                sub.w   $36(a0),d0
                btst    #button_up+8,d1
                beq.s   S3BreakableBar_TrySlideRiderDown
                subq.w  #1,y_pos(a1)
                cmp.w   y_pos(a1),d0
                blo.s   S3BreakableBar_TrySlideRiderDown
                move.w  d0,y_pos(a1)

S3BreakableBar_TrySlideRiderDown:
                add.w   $38(a0),d0
                btst    #button_down+8,d1
                beq.s   S3BreakableBar_TryReleaseVerticalRider
                addq.w  #1,y_pos(a1)
                cmp.w   y_pos(a1),d0
                bhs.s   S3BreakableBar_TryReleaseVerticalRider
                move.w  d0,y_pos(a1)

S3BreakableBar_TryReleaseVerticalRider:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d1
                beq.w   S3BreakableBar_VerticalGrabReturn
                clr.b   (a2)
                move.b  #$3C,2(a2)
                bclr    d2,(_unkF7C7).w
                andi.b  #$FE,object_control(a1)
                btst    #6,subtype(a0)
                bne.s   S3BreakableBar_VerticalReleaseReturn
                move.b  #1,$3A(a0)

S3BreakableBar_VerticalReleaseReturn:
                rts
; ---------------------------------------------------------------------------

S3BreakableBar_TickVerticalRegrabDelay:
                tst.b   2(a2)
                beq.s   S3BreakableBar_TryGrabVerticalBar
                subq.b  #1,2(a2)
                rts
; ---------------------------------------------------------------------------

S3BreakableBar_TryGrabVerticalBar:
                moveq   #0,d1
                move.b  height_pixels(a0),d1
                move.w  y_pos(a0),d0
                sub.w   d1,d0
                move.w  y_pos(a1),d2
                cmp.w   d0,d2
                blo.s   S3BreakableBar_VerticalGrabReturn
                add.w   d1,d0
                add.w   d1,d0
                cmp.w   d0,d2
                bhs.s   S3BreakableBar_VerticalGrabReturn
                move.w  x_pos(a0),d0
                addi.w  #$14,d0
                cmp.w   x_pos(a1),d0
                bhs.s   S3BreakableBar_VerticalGrabReturn
                addi.w  #$10,d0
                cmp.w   x_pos(a1),d0
                blo.s   S3BreakableBar_VerticalGrabReturn
                cmpi.b  #4,routine(a1)
                bhs.s   S3BreakableBar_VerticalGrabReturn
                tst.b   object_control(a1)
                bne.s   S3BreakableBar_VerticalGrabReturn
                move.w  y_pos(a0),d0
                sub.w   $36(a0),d0
                cmp.w   y_pos(a1),d0
                blo.s   S3BreakableBar_ClampGrabToLowerEnd
                move.w  d0,y_pos(a1)

S3BreakableBar_ClampGrabToLowerEnd:
                add.w   $38(a0),d0
                cmp.w   y_pos(a1),d0
                bhs.s   S3BreakableBar_CommitVerticalGrab
                move.w  d0,y_pos(a1)

; The global bit operation uses d2 after the capture check has replaced the player index with Y
S3BreakableBar_CommitVerticalGrab:
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                move.w  x_pos(a0),d0
                addi.w  #$14,d0
                move.w  d0,x_pos(a1)
                bclr    #Status_Facing,status(a1)
                move.b  #$11,anim(a1)
                move.b  #1,object_control(a1)
                bset    d2,(_unkF7C7).w
                move.b  #1,(a2)

S3BreakableBar_VerticalGrabReturn:
                rts
; End of function UpdatePlayerOnHczVerticalBreakableBar

; ---------------------------------------------------------------------------

S3BreakableBar_ReleaseVerticalP1:
                tst.b   $32(a0)
                beq.s   S3BreakableBar_ReleaseVerticalP2
                andi.b  #$FE,(Player_1+object_control).w

S3BreakableBar_ReleaseVerticalP2:
                tst.b   $33(a0)
                beq.s   S3BreakableBar_SplitVerticalBar
                andi.b  #$FE,(Player_2+object_control).w

S3BreakableBar_SplitVerticalBar:
                clr.b   (_unkF7C7).w
                clr.w   $32(a0)
                move.l  #S3BreakableBar_WaitForFragmentMotion,(a0)
                move.b  #3,mapping_frame(a0)
                move.w  #$400,x_vel(a0)
                move.w  #0,y_vel(a0)
                lea     (S3BreakableBar_VerticalFragmentOffsets).l,a4
                lea     (S3BreakableBar_FragmentDelays).l,a2
                moveq   #0,d1
                move.b  height_pixels(a0),d1
                lsr.w   #2,d1
                subq.w  #1,d1
                bsr.w   SplitHczBreakableBarIntoPieces

S3BreakableBar_WaitForFragmentMotion:
                tst.b   $3F(a0)
                beq.s   S3BreakableBar_MoveFragmentWithGravity
                subq.b  #1,$3F(a0)
                bra.s   S3BreakableBar_DrawOrDeleteFragment
; ---------------------------------------------------------------------------

S3BreakableBar_MoveFragmentWithGravity:
                jsr     (MoveSprite2).l
                addi.w  #8,y_vel(a0)

S3BreakableBar_DrawOrDeleteFragment:
                tst.b   render_flags(a0)
                bpl.w   S3LavaMarker_ClearMarkerLoadedBit
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

S3BreakableBar_TickHorizontalBreakTimer:
                lea     $32(a0),a2
                tst.w   $30(a0)
                beq.s   S3BreakableBar_UpdateHorizontalRiders
                tst.w   (a2)
                beq.s   S3BreakableBar_UpdateHorizontalRiders
                subq.w  #1,$30(a0)
                beq.w   S3BreakableBar_ReleaseHorizontalP1

S3BreakableBar_UpdateHorizontalRiders:
                lea     (Player_1).w,a1
                move.w  (Ctrl_1).w,d1
                moveq   #0,d2
                bsr.s   UpdatePlayerOnHczHorizontalBreakableBar
                addq.w  #1,a2
                lea     (Player_2).w,a1
                move.w  (Ctrl_2).w,d1
                moveq   #1,d2
                bsr.s   UpdatePlayerOnHczHorizontalBreakableBar
                tst.b   $3A(a0)
                bne.w   S3BreakableBar_ReleaseHorizontalP1
                bra.w   Sprite_OnScreen_Test

; =============== S U B R O U T I N E =======================================

UpdatePlayerOnHczHorizontalBreakableBar:
                tst.b   (a2)
                beq.s   S3BreakableBar_TickHorizontalRegrabDelay
                move.w  x_pos(a0),d0
                sub.w   $36(a0),d0
                btst    #button_left+8,d1
                beq.s   S3BreakableBar_TrySlideRiderRight
                subq.w  #1,x_pos(a1)
                cmp.w   x_pos(a1),d0
                blo.s   S3BreakableBar_TrySlideRiderRight
                move.w  d0,x_pos(a1)

S3BreakableBar_TrySlideRiderRight:
                add.w   $38(a0),d0
                btst    #button_right+8,d1
                beq.s   S3BreakableBar_TryReleaseHorizontalRider
                addq.w  #1,x_pos(a1)
                cmp.w   x_pos(a1),d0
                bhs.s   S3BreakableBar_TryReleaseHorizontalRider
                move.w  d0,x_pos(a1)

S3BreakableBar_TryReleaseHorizontalRider:
                andi.w  #button_A_mask|button_B_mask|button_C_mask,d1
                beq.w   S3BreakableBar_HorizontalGrabReturn
                clr.b   (a2)
                move.b  #$3C,2(a2)
                bclr    d2,(_unkF7C7).w
                andi.b  #$FE,object_control(a1)
                btst    #6,subtype(a0)
                bne.s   S3BreakableBar_HorizontalReleaseReturn
                move.b  #1,$3A(a0)

S3BreakableBar_HorizontalReleaseReturn:
                rts
; ---------------------------------------------------------------------------

S3BreakableBar_TickHorizontalRegrabDelay:
                tst.b   2(a2)
                beq.s   S3BreakableBar_TryGrabHorizontalBar
                subq.b  #1,2(a2)
                rts
; ---------------------------------------------------------------------------

S3BreakableBar_TryGrabHorizontalBar:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  x_pos(a0),d0
                sub.w   d1,d0
                move.w  x_pos(a1),d2
                cmp.w   d0,d2
                blo.s   S3BreakableBar_HorizontalGrabReturn
                add.w   d1,d0
                add.w   d1,d0
                cmp.w   d0,d2
                bhs.s   S3BreakableBar_HorizontalGrabReturn
                move.w  y_pos(a0),d0
                subi.w  #$14,d0
                cmp.w   y_pos(a1),d0
                bhs.s   S3BreakableBar_HorizontalGrabReturn
                addi.w  #$10,d0
                cmp.w   y_pos(a1),d0
                blo.s   S3BreakableBar_HorizontalGrabReturn
                cmpi.b  #4,routine(a1)
                bhs.s   S3BreakableBar_HorizontalGrabReturn
                tst.b   object_control(a1)
                bne.s   S3BreakableBar_HorizontalGrabReturn
                move.w  x_pos(a0),d0
                sub.w   $36(a0),d0
                cmp.w   x_pos(a1),d0
                blo.s   S3BreakableBar_ClampGrabToRightEnd
                move.w  d0,x_pos(a1)

S3BreakableBar_ClampGrabToRightEnd:
                add.w   $38(a0),d0
                cmp.w   x_pos(a1),d0
                bhs.s   S3BreakableBar_CommitHorizontalGrab
                move.w  d0,x_pos(a1)

; The global bit operation uses d2 after the capture check has replaced the player index with X
S3BreakableBar_CommitHorizontalGrab:
                clr.w   x_vel(a1)
                clr.w   y_vel(a1)
                move.w  y_pos(a0),d0
                subi.w  #$14,d0
                move.w  d0,y_pos(a1)
                move.b  #$14,anim(a1)
                move.b  #1,object_control(a1)
                bset    d2,(_unkF7C7).w
                move.b  #1,(a2)

S3BreakableBar_HorizontalGrabReturn:
                rts
; End of function UpdatePlayerOnHczHorizontalBreakableBar

; ---------------------------------------------------------------------------

S3BreakableBar_ReleaseHorizontalP1:
                tst.b   $32(a0)
                beq.s   S3BreakableBar_ReleaseHorizontalP2
                andi.b  #$FE,(Player_1+object_control).w

S3BreakableBar_ReleaseHorizontalP2:
                tst.b   $33(a0)
                beq.s   S3BreakableBar_SplitHorizontalBar
                andi.b  #$FE,(Player_2+object_control).w

S3BreakableBar_SplitHorizontalBar:
                clr.b   (_unkF7C7).w
                clr.w   $32(a0)
                move.l  #S3BreakableBar_WaitForFragmentMotion,(a0)
                move.b  #7,mapping_frame(a0)
                move.w  #0,x_vel(a0)
                move.w  #-$400,y_vel(a0)
                lea     (S3BreakableBar_HorizontalFragmentOffsets).l,a4
                lea     (S3BreakableBar_FragmentDelays).l,a2
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                lsr.w   #2,d1
                subq.w  #1,d1
                bsr.w   SplitHczBreakableBarIntoPieces
                bra.w   S3BreakableBar_WaitForFragmentMotion
; ---------------------------------------------------------------------------
S3BreakableBar_FragmentDelays:
                dc.b    7,   5,   2,   0,   1,   3,   4,   6,   7,   5,   2,   0,   1,   3,   4,   6,   8,   9,  $A,  $B
                dc.b    $C,  $D,  $E,  $F
                even
S3BreakableBar_VerticalFragmentOffsets:
                dc.w    0,  -$1C
                dc.w    0,  -$14
                dc.w    0,   -$C
                dc.w    0,    -4
                dc.w    0,     4
                dc.w    0,    $C
                dc.w    0,   $14
                dc.w    0,   $1C
                dc.w    0,   $24
                dc.w    0,  -$24
                dc.w    0,   $2C
                dc.w    0,  -$2C
                dc.w    0,   $34
                dc.w    0,  -$34
                dc.w    0,   $3C
                dc.w    0,  -$3C
S3BreakableBar_HorizontalFragmentOffsets:
                dc.w    -$1C,     0
                dc.w    -$14,     0
                dc.w    -$C,     0
                dc.w    -4,     0
                dc.w    4,     0
                dc.w    $C,     0
                dc.w    $14,     0
                dc.w    $1C,     0
                dc.w    $24,     0
                dc.w    -$24,     0
                dc.w    $2C,     0
                dc.w    -$2C,     0
                dc.w    $34,     0
                dc.w    -$34,     0
                dc.w    $3C,     0
                dc.w    -$3C,     0

; =============== S U B R O U T I N E =======================================

SplitHczBreakableBarIntoPieces:
                move.w  x_pos(a0),d2
                move.w  y_pos(a0),d3
                move.w  priority(a0),d4
                movea.l a0,a1
                bra.s   S3BreakableBar_InitFragmentAndAdvance
; ---------------------------------------------------------------------------

S3BreakableBar_TryAllocateNextFragment:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   S3BreakableBar_PlayCollapseSound

S3BreakableBar_InitFragmentAndAdvance:
                move.l  (a0),(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  #$84,render_flags(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  (a4)+,d0
                add.w   d2,d0
                move.w  d0,x_pos(a1)
                move.w  (a4)+,d0
                add.w   d3,d0
                move.w  d0,y_pos(a1)
                move.w  d4,priority(a1)
                move.b  #4,width_pixels(a1)
                move.b  #4,height_pixels(a1)
                move.b  mapping_frame(a0),mapping_frame(a1)
                move.w  x_vel(a0),x_vel(a1)
                move.w  y_vel(a0),y_vel(a1)
                move.b  (a2)+,$3F(a1)
                dbf     d1,S3BreakableBar_TryAllocateNextFragment

S3BreakableBar_PlayCollapseSound:
                moveq   #signextendB(sfx_Collapse),d0
                jmp     (Play_SFX).l
; End of function SplitHczBreakableBarIntoPieces

; ---------------------------------------------------------------------------
Map_HCZBreakableBar:
                include "src/objects/shared/zones/hcz/mappings/breakable_bar.s"
