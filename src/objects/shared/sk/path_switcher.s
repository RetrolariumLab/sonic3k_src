; Owner: objects/shared/sk
; Responsibility: Shared foreground priority and collision-path switcher state and geometric contact helpers
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_PathSwap:
                move.l  #Map_PathSwap,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,1,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #$40,height_pixels(a0)
                move.w  #$280,priority(a0)
                move.b  subtype(a0),d0
                btst    #2,d0
                beq.s   loc_1CD3C
                andi.w  #7,d0
                move.b  d0,mapping_frame(a0)
                andi.w  #3,d0
                add.w   d0,d0
                move.w  word_1CD34(pc,d0.w),$32(a0)
                move.w  y_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   loc_1CD06
                move.b  #1,$34(a0)

loc_1CD06:
                lea     (Player_2).w,a1
                cmp.w   y_pos(a1),d1
                bhs.s   loc_1CD16
                move.b  #1,$35(a0)

loc_1CD16:
                move.l  #loc_1CEF2,(a0)
                tst.w   (Competition_mode).w
                beq.w   loc_1CEF2
                move.l  #loc_1CF1A,(a0)
                move.w  #make_art_tile(ArtTile_2PArt_3+$C,3,0),art_tile(a0)
                bra.w   loc_1CF1A
; ---------------------------------------------------------------------------
word_1CD34:
                dc.w    $20,   $40,   $80,  $100
; ---------------------------------------------------------------------------

loc_1CD3C:
                andi.w  #3,d0
                move.b  d0,mapping_frame(a0)
                add.w   d0,d0
                move.w  word_1CD34(pc,d0.w),$32(a0)
                move.w  x_pos(a0),d1
                lea     (Player_1).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   loc_1CD60
                move.b  #1,$34(a0)

loc_1CD60:
                lea     (Player_2).w,a1
                cmp.w   x_pos(a1),d1
                bhs.s   loc_1CD70
                move.b  #1,$35(a0)

loc_1CD70:
                move.l  #loc_1CD8A,(a0)
                tst.w   (Competition_mode).w
                beq.s   loc_1CD8A
                move.l  #loc_1CDB2,(a0)
                move.w  #make_art_tile(ArtTile_2PArt_3+$C,3,0),art_tile(a0)
                bra.s   loc_1CDB2
; ---------------------------------------------------------------------------

loc_1CD8A:
                tst.w   (Debug_placement_mode).w
                bne.w   loc_1CDAC
                move.w  x_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   SwitchPlayerPathOnXCrossing
                lea     (Player_2).w,a1
                bsr.s   SwitchPlayerPathOnXCrossing
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_1CDAC:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_1CDB2:
                move.w  x_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   SwitchPlayerPathOnXCrossing
                lea     (Player_2).w,a1
                bsr.s   SwitchPlayerPathOnXCrossing
                lea     (Breathing_bubbles).w,a1
                tst.w   (Debug_mode_flag).w
                beq.w   SwitchPlayerPathOnXCrossing
                bsr.s   SwitchPlayerPathOnXCrossing
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

SwitchPlayerPathOnXCrossing:
                tst.b   (a2)+
                bne.w   loc_1CE6C
                cmp.w   x_pos(a1),d1
                bhi.w   locret_1CEF0
                move.b  #1,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   locret_1CEF0
                cmp.w   d3,d4
                bge.w   locret_1CEF0
                move.b  subtype(a0),d0
                bpl.s   loc_1CE1C
                btst    #Status_InAir,status(a1)
                bne.w   locret_1CEF0

loc_1CE1C:
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   loc_1CE26
                neg.w   d2

loc_1CE26:
                cmpi.w  #$40,d2
                bhs.w   locret_1CEF0
                btst    #0,render_flags(a0)
                bne.s   loc_1CE54
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #3,d0
                beq.s   loc_1CE54
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_1CE54:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #5,d0
                beq.w   locret_1CEF0
                ori.w   #high_priority,art_tile(a1)
                bra.w   locret_1CEF0
; ---------------------------------------------------------------------------

loc_1CE6C:
                cmp.w   x_pos(a1),d1
                bls.w   locret_1CEF0
                move.b  #0,-1(a2)
                move.w  y_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  y_pos(a1),d4
                cmp.w   d2,d4
                blt.w   locret_1CEF0
                cmp.w   d3,d4
                bge.w   locret_1CEF0
                move.b  subtype(a0),d0
                bpl.s   loc_1CEA8
                btst    #Status_InAir,status(a1)
                bne.w   locret_1CEF0

loc_1CEA8:
                move.w  x_pos(a1),d2
                sub.w   d1,d2
                bcc.s   loc_1CEB2
                neg.w   d2

loc_1CEB2:
                cmpi.w  #$40,d2
                bhs.s   locret_1CEF0
                btst    #0,render_flags(a0)
                bne.s   loc_1CEDE
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #4,d0
                beq.s   loc_1CEDE
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_1CEDE:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #6,d0
                beq.s   locret_1CEF0
                ori.w   #high_priority,art_tile(a1)

locret_1CEF0:
                rts
; End of function SwitchPlayerPathOnXCrossing

; ---------------------------------------------------------------------------

loc_1CEF2:
                tst.w   (Debug_placement_mode).w
                bne.w   loc_1CF14
                move.w  y_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   SwitchPlayerPathOnYCrossing
                lea     (Player_2).w,a1
                bsr.s   SwitchPlayerPathOnYCrossing
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_1CF14:
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_1CF1A:
                move.w  y_pos(a0),d1
                lea     $34(a0),a2
                lea     (Player_1).w,a1
                bsr.s   SwitchPlayerPathOnYCrossing
                lea     (Player_2).w,a1
                bsr.s   SwitchPlayerPathOnYCrossing
                lea     (Breathing_bubbles).w,a1
                tst.w   (Debug_mode_flag).w
                beq.w   SwitchPlayerPathOnYCrossing
                bsr.s   SwitchPlayerPathOnYCrossing
                jmp     (Draw_Sprite).l

; =============== S U B R O U T I N E =======================================

SwitchPlayerPathOnYCrossing:
                tst.b   (a2)+
                bne.w   loc_1CFD4
                cmp.w   y_pos(a1),d1
                bhi.w   locret_1D058
                move.b  #1,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blt.w   locret_1D058
                cmp.w   d3,d4
                bge.w   locret_1D058
                move.b  subtype(a0),d0
                bpl.s   loc_1CF84
                btst    #Status_InAir,status(a1)
                bne.w   locret_1D058

loc_1CF84:
                move.w  y_pos(a1),d2
                sub.w   d1,d2
                bcc.s   loc_1CF8E
                neg.w   d2

loc_1CF8E:
                cmpi.w  #$40,d2
                bhs.w   locret_1D058
                btst    #0,render_flags(a0)
                bne.s   loc_1CFBC
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #3,d0
                beq.s   loc_1CFBC
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_1CFBC:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #5,d0
                beq.w   locret_1D058
                ori.w   #high_priority,art_tile(a1)
                bra.w   locret_1D058
; ---------------------------------------------------------------------------

loc_1CFD4:
                cmp.w   y_pos(a1),d1
                bls.w   locret_1D058
                move.b  #0,-1(a2)
                move.w  x_pos(a0),d2
                move.w  d2,d3
                move.w  $32(a0),d4
                sub.w   d4,d2
                add.w   d4,d3
                move.w  x_pos(a1),d4
                cmp.w   d2,d4
                blt.w   locret_1D058
                cmp.w   d3,d4
                bge.w   locret_1D058
                move.b  subtype(a0),d0
                bpl.s   loc_1D010
                btst    #Status_InAir,status(a1)
                bne.w   locret_1D058

loc_1D010:
                move.w  y_pos(a1),d2
                sub.w   d1,d2
                bcc.s   loc_1D01A
                neg.w   d2

loc_1D01A:
                cmpi.w  #$40,d2
                bhs.s   locret_1D058
                btst    #0,render_flags(a0)
                bne.s   loc_1D046
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)
                btst    #4,d0
                beq.s   loc_1D046
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)

loc_1D046:
                andi.w  #drawing_mask,art_tile(a1)
                btst    #6,d0
                beq.s   locret_1D058
                ori.w   #high_priority,art_tile(a1)

locret_1D058:
                rts
; End of function SwitchPlayerPathOnYCrossing

; ---------------------------------------------------------------------------
Map_PathSwap:
                include "src/objects/shared/level_misc/mappings/path_swap.s"
