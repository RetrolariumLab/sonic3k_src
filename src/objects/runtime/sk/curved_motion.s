; Owner: objects/runtime/sk
; Responsibility: Gravity variants and circular or angle-indexed object motion with their private lookup tables
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

MoveSprite_LightGravity:
                moveq   #$20,d1

MoveSprite_CustomGravity:
                move.w  x_vel(a0),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a0)
                move.w  y_vel(a0),d0
                add.w   d1,y_vel(a0)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a0)
                rts
; End of function MoveSprite_LightGravity

; =============== S U B R O U T I N E =======================================

MoveSprite_NormGravity:
                moveq   #$38,d1
                move.w  x_vel(a1),d0
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,x_pos(a1)
                move.w  y_vel(a1),d0
                add.w   d1,y_vel(a1)
                ext.l   d0
                lsl.l   #8,d0
                add.l   d0,y_pos(a1)
                rts
; End of function MoveSprite_NormGravity

; =============== S U B R O U T I N E =======================================

MoveSprite_Circular:
                move.b  $3C(a0),d0
                jsr     (GetSineCosine).l
                move.w  $3A(a0),d2
                move.w  d2,d3
                muls.w  d0,d2
                swap    d2
                muls.w  d1,d3
                swap    d3
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d0
                add.w   d2,d0
                move.b  child_dx(a0),d4
                ext.w   d4
                add.w   d4,d0
                move.w  d0,x_pos(a0)
                move.w  y_pos(a1),d1
                add.w   d3,d1
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d1
                move.w  d1,y_pos(a0)
                rts
; End of function MoveSprite_Circular

; =============== S U B R O U T I N E =======================================

MoveSprite_CircularSimple:
                move.b  $3C(a0),d0
                jsr     (GetSineCosine).l
                swap    d0
                clr.w   d0
                swap    d1
                clr.w   d1
                asr.l   d2,d0
                asr.l   d2,d1
                movea.w parent3(a0),a1
                move.l  x_pos(a1),d2
                move.l  y_pos(a1),d3
                add.l   d0,d2
                add.l   d1,d3
                move.l  d2,x_pos(a0)
                move.l  d3,y_pos(a0)
                rts
; End of function MoveSprite_CircularSimple

; ---------------------------------------------------------------------------

MoveSprite_CircularSimpleCheckFlip:
                move.b  $3C(a0),d0
                jsr     (GetSineCosine).l
                swap    d0
                clr.w   d0
                swap    d1
                clr.w   d1
                asr.l   d2,d0
                asr.l   d2,d1
                movea.w parent3(a0),a1
                move.l  x_pos(a1),d2
                move.l  y_pos(a1),d3
                btst    #0,render_flags(a1)
                beq.s   loc_84C9E
                neg.l   d0

loc_84C9E:
                add.l   d0,d2
                add.l   d1,d3
                move.l  d2,x_pos(a0)
                move.l  d3,y_pos(a0)
                rts

; =============== S U B R O U T I N E =======================================

MoveSprite_CircularSimpleOffset:
                move.b  $3C(a0),d0
                jsr     (GetSineCosine).l
                swap    d0
                clr.w   d0
                swap    d1
                clr.w   d1
                asr.l   d2,d0
                asr.l   d2,d1
                movea.w parent3(a0),a1
                move.l  x_pos(a1),d2
                move.l  y_pos(a1),d3
                move.b  child_dx(a0),d4
                ext.w   d4
                swap    d4
                clr.w   d4
                add.l   d4,d2
                move.b  child_dy(a0),d4
                ext.w   d4
                swap    d4
                clr.w   d4
                add.l   d4,d3
                add.l   d0,d2
                add.l   d1,d3
                move.l  d2,x_pos(a0)
                move.l  d3,y_pos(a0)
                rts
; End of function MoveSprite_CircularSimpleOffset

; =============== S U B R O U T I N E =======================================

MoveSprite_AtAngleLookup:
                moveq   #0,d0
                move.b  $3C(a0),d0
                move.w  d0,d1
                andi.w  #$3F,d0
                lsr.w   #5,d1
                andi.w  #6,d1
                movea.w parent3(a0),a1
                lea     $40(a2),a3
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                move.w  d0,d4
                not.w   d4
                move.w  AtAngle_LookupIndex(pc,d1.w),d1
                jsr     AtAngle_LookupIndex(pc,d1.w)
                add.w   d5,d2
                add.w   d6,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                rts
; End of function MoveSprite_AtAngleLookup

; ---------------------------------------------------------------------------
AtAngle_LookupIndex:
                dc.w    AtAngle_00_3F-AtAngle_LookupIndex
                dc.w    AtAngle_40_7F-AtAngle_LookupIndex
                dc.w    AtAngle_80_BF-AtAngle_LookupIndex
                dc.w    AtAngle_C0_FF-AtAngle_LookupIndex
; ---------------------------------------------------------------------------

AtAngle_00_3F:
                moveq   #0,d5
                move.b  (a2,d0.w),d5
                moveq   #0,d6
                move.b  (a3,d4.w),d6
                rts
; ---------------------------------------------------------------------------

AtAngle_40_7F:
                moveq   #0,d5
                move.b  (a3,d4.w),d5
                moveq   #0,d6
                move.b  (a2,d0.w),d6
                neg.w   d6
                rts
; ---------------------------------------------------------------------------

AtAngle_80_BF:
                moveq   #0,d5
                move.b  (a2,d0.w),d5
                neg.w   d5
                moveq   #0,d6
                move.b  (a3,d4.w),d6
                neg.w   d6
                rts
; ---------------------------------------------------------------------------

AtAngle_C0_FF:
                moveq   #0,d5
                move.b  (a3,d4.w),d5
                neg.w   d5
                moveq   #0,d6
                move.b  (a2,d0.w),d6
                rts

; =============== S U B R O U T I N E =======================================

MoveSprite_CircularLookup:
                moveq   #0,d0
                move.b  $3C(a0),d0
                move.w  d0,d1
                andi.w  #$3F,d0
                lsr.w   #5,d1
                andi.w  #6,d1
                movea.w parent3(a0),a1
                lea     $40(a2),a3
                move.w  x_pos(a1),d2
                move.w  y_pos(a1),d3
                move.b  child_dx(a0),d4
                ext.w   d4
                btst    #0,render_flags(a0)
                beq.s   loc_84DAA
                neg.w   d4

loc_84DAA:
                add.w   d4,d2
                move.b  child_dy(a0),d4
                ext.w   d4
                add.w   d4,d3
                move.w  d0,d4
                not.w   d4
                lea     AtAngle_LookupIndex(pc),a4
                move.w  (a4,d1.w),d1
                jsr     (a4,d1.w)
                btst    #0,render_flags(a0)
                beq.s   loc_84DCE
                neg.w   d5

loc_84DCE:
                add.w   d5,d2
                add.w   d6,d3
                move.w  d2,x_pos(a0)
                move.w  d3,y_pos(a0)
                rts
; End of function MoveSprite_CircularLookup

; =============== S U B R O U T I N E =======================================

MoveSprite_AngleYLookup:
                moveq   #0,d0
                move.b  $3C(a0),d0
                move.w  d0,d1
                andi.w  #$3F,d0
                lsr.w   #5,d1
                andi.w  #6,d1
                movea.w parent3(a0),a1
                lea     $40(a2),a3
                move.w  y_pos(a1),d3
                move.w  d0,d4
                not.w   d4
                move.w  AngleY_LookupIndex(pc,d1.w),d1
                jsr     AngleY_LookupIndex(pc,d1.w)
                add.w   d1,d3
                move.w  d3,y_pos(a0)
                rts
; End of function MoveSprite_AngleYLookup

; ---------------------------------------------------------------------------
AngleY_LookupIndex:
                dc.w    loc_84E16-AngleY_LookupIndex
                dc.w    loc_84E1E-AngleY_LookupIndex
                dc.w    loc_84E28-AngleY_LookupIndex
                dc.w    loc_84E32-AngleY_LookupIndex
; ---------------------------------------------------------------------------

loc_84E16:
                moveq   #0,d1
                move.b  (a3,d4.w),d1
                rts
; ---------------------------------------------------------------------------

loc_84E1E:
                moveq   #0,d1
                move.b  (a2,d0.w),d1
                neg.w   d1
                rts
; ---------------------------------------------------------------------------

loc_84E28:
                moveq   #0,d1
                move.b  (a3,d4.w),d1
                neg.w   d1
                rts
; ---------------------------------------------------------------------------

loc_84E32:
                moveq   #0,d1
                move.b  (a2,d0.w),d1
                rts

; =============== S U B R O U T I N E =======================================

MoveSprite_AngleXLookupOffset:
                moveq   #0,d0
                move.b  $3C(a0),d0
                move.b  d0,d1
                rol.b   #3,d1
                andi.w  #6,d1
                move.w  AngleX_LookupIndex(pc,d1.w),d2
                jmp     AngleX_LookupIndex(pc,d2.w)
; End of function MoveSprite_AngleXLookupOffset

; ---------------------------------------------------------------------------
AngleX_LookupIndex:
                dc.w    loc_84E58-AngleX_LookupIndex
                dc.w    loc_84E60-AngleX_LookupIndex
                dc.w    loc_84E6C-AngleX_LookupIndex
                dc.w    loc_84E7C-AngleX_LookupIndex
; ---------------------------------------------------------------------------

loc_84E58:
                move.b  (a1,d0.w),d1
                bra.w   loc_84E8C
; ---------------------------------------------------------------------------

loc_84E60:
                moveq   #$7F,d1
                sub.w   d0,d1
                move.b  (a1,d1.w),d1
                bra.w   loc_84E8C
; ---------------------------------------------------------------------------

loc_84E6C:
                move.w  d0,d1
                andi.w  #$3F,d1
                move.b  (a1,d1.w),d1
                neg.w   d1
                bra.w   loc_84E8C
; ---------------------------------------------------------------------------

loc_84E7C:
                move.w  #$FF,d1
                sub.w   d0,d1
                move.b  (a1,d1.w),d1
                neg.w   d1
                bra.w   loc_84E8C
; ---------------------------------------------------------------------------

loc_84E8C:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.b  child_dx(a0),d3
                ext.w   d3
                add.w   d3,d2
                btst    #0,render_flags(a1)
                beq.s   loc_84EA6
                neg.w   d1

loc_84EA6:
                add.w   d1,d2
                move.w  d2,x_pos(a0)
                move.w  y_pos(a1),d2
                move.b  child_dy(a0),d3
                ext.w   d3
                add.w   d3,d2
                move.w  d2,y_pos(a0)
                rts
; ---------------------------------------------------------------------------
                moveq   #0,d0                           ; Same as above but unused
                move.b  $3C(a0),d0
                move.b  d0,d1
                rol.b   #3,d1
                andi.w  #6,d1
                move.w  off_84ED4(pc,d1.w),d2
                jmp     off_84ED4(pc,d2.w)
; ---------------------------------------------------------------------------
off_84ED4:
                dc.w    loc_84EDC-off_84ED4
                dc.w    loc_84EE4-off_84ED4
                dc.w    loc_84EF0-off_84ED4
                dc.w    loc_84F00-off_84ED4
; ---------------------------------------------------------------------------

loc_84EDC:
                move.b  (a1,d0.w),d1
                bra.w   loc_84F10
; ---------------------------------------------------------------------------

loc_84EE4:
                moveq   #$7F,d1
                sub.w   d0,d1
                move.w  (a1,d1.w),d1
                bra.w   loc_84F10
; ---------------------------------------------------------------------------

loc_84EF0:
                move.w  d0,d1
                andi.w  #$3F,d1
                move.w  (a1,d1.w),d1
                neg.w   d1
                bra.w   loc_84F10
; ---------------------------------------------------------------------------

loc_84F00:
                move.w  #$FF,d1
                sub.w   d0,d1
                move.w  (a1,d1.w),d1
                neg.w   d1
                bra.w   loc_84F10

loc_84F10:
                movea.w parent3(a0),a1
                move.w  x_pos(a1),d2
                move.b  child_dx(a0),d3
                ext.w   d3
                add.w   d3,d2
                move.w  d2,x_pos(a0)
                move.w  y_pos(a1),d2
                move.b  child_dy(a0),d3
                ext.w   d3
                add.w   d3,d2
                add.w   d1,d2
                move.w  d2,y_pos(a0)
                rts
