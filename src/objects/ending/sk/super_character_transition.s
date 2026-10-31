; Owner: objects/ending/sk
; Responsibility: Prepare or revert the super character ending state and coordinate the related palette transition
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

sub_5FC8E:
                clr.b   (Player_1+anim).w
                move.w  #$24,(Palette_frame).w
                move.b  #1,(Super_Sonic_Knux_flag).w

loc_5FC9E:
                move.b  #-1,(Super_palette_status).w
                move.b  #0,(Palette_timer).w
                move.l  #Map_SuperSonic,(Player_1+mappings).w
                rts
; End of function sub_5FC8E

; =============== S U B R O U T I N E =======================================

sub_5FCB4:
                move.b  #-1,(Super_palette_status).w
                move.w  #0,(Palette_frame).w
                move.b  #0,(Palette_frame_Tails).w
                move.b  #1,(Super_Tails_flag).w
                rts
; End of function sub_5FCB4

; =============== S U B R O U T I N E =======================================

sub_5FCCE:
                move.b  #-1,(Super_Sonic_Knux_flag).w
                move.w  #0,(Palette_frame).w
                bra.s   loc_5FC9E
; End of function sub_5FCCE

; ---------------------------------------------------------------------------

loc_5FCDC:
                move.l  #loc_5FCEC,(a0)
                lea     PalSPtr_EndingSuperTails(pc),a1
                jsr     (sub_7C678).l

loc_5FCEC:
                btst    #3,(_unkFAB8).w
                bne.w   loc_5EC36
                jmp     (Run_PalRotationScript).l
; ---------------------------------------------------------------------------

loc_5FCFC:
                move.l  #loc_5FD16,(a0)
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  byte_5FD4E(pc,d0.w),$3A(a0)
                add.w   d0,d0
                move.l  off_5FD52(pc,d0.w),$30(a0)

loc_5FD16:
                tst.b   (Palette_cycle_counters+$00).w
                bne.w   loc_5EC36
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_5FD4C
                move.b  $3B(a0),anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.b  #6,d0
                cmp.b   $3A(a0),d0
                blo.s   loc_5FD3A
                moveq   #0,d0

loc_5FD3A:
                move.b  d0,anim_frame(a0)
                movea.l $30(a0),a1
                adda.w  d0,a1
                lea     (Normal_palette_line_3+$4).w,a2
                move.l  (a1)+,(a2)+
                move.w  (a1)+,(a2)+

locret_5FD4C:
                rts
; ---------------------------------------------------------------------------
byte_5FD4E:
                dc.b    $18,   6
                dc.b    $48,   4
                even
off_5FD52:
                dc.l    PalCycle_SuperSonic+$24
                dc.l    PalCycle_HyperSonic
; ---------------------------------------------------------------------------

loc_5FD5A:
                move.l  #loc_5FD66,(a0)
                move.w  #32-1,$2E(a0)

loc_5FD66:
                subq.w  #1,$2E(a0)
                bpl.w   locret_5FF1A
                jsr     (AllocateObject).l
                bne.s   loc_5FD82
                move.l  #loc_5F26C,(a1)
                move.b  #4,subtype(a1)

loc_5FD82:
                jmp     (Delete_Current_Sprite).l

; =============== S U B R O U T I N E =======================================

sub_5FD88:
                lea     (Player_1).w,a1
                move.w  (Player_mode).w,d0
                andi.w  #3,d0
                move.b  byte_5FDA0(pc,d0.w),mapping_frame(a1)
                jmp     (Player_Load_PLC).l
; End of function sub_5FD88

; ---------------------------------------------------------------------------
byte_5FDA0:
                dc.b    $BA
                dc.b    $BA
                dc.b    $AD
                dc.b    $56
                even

; =============== S U B R O U T I N E =======================================

sub_5FDA4:
                jsr     (AllocateObject).l
                bne.s   locret_5FDD2
                move.w  a1,$44(a0)
                move.l  #Obj_FadeSelectedFromBlack,(a1)
                moveq   #5,d0
                move.w  d0,$3A(a1)
                move.w  d0,$2E(a1)
                move.w  #$F,$3C(a1)
                move.w  #Normal_palette_line_2,$30(a1)
                move.w  #Target_palette_line_2,$32(a1)

locret_5FDD2:
                rts
; End of function sub_5FDA4

; ---------------------------------------------------------------------------

Obj_Ending_RevertSuperSonic:
                move.w  #(2*60)-1,$2E(a0)
                move.l  #loc_5FDE0,(a0)

loc_5FDE0:
                subq.w  #1,$2E(a0)
                bpl.s   locret_5FE0E
                move.l  #loc_5FE10,(a0)
                lea     (Player_1).w,a1
                move.b  #$F,anim(a1)
                move.b  #2,(Super_palette_status).w
                move.w  #$1E,(Palette_frame).w
                move.b  #0,(Super_Sonic_Knux_flag).w
                move.b  #0,(Super_Tails_flag).w

locret_5FE0E:
                rts
; ---------------------------------------------------------------------------

loc_5FE10:
                move.l  #Map_Sonic,(Player_1+mappings).w
                jmp     (Delete_Current_Sprite).l
