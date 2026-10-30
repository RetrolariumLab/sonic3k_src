; Owner: game/level/zones/lbz/s3
; Responsibility: Launch Base act-two and Death Egg background deformation, window effects and private geometry
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

LBZ2_Deform:
                move.w  (Camera_Y_pos_copy).w,d0        ; Oh hey, it's more waterline fun, wasn't this just so interesting the first time
                move.w  (Screen_shake_offset).w,d3
                sub.w   d3,d0
                subi.w  #$5F0,d0
                move.w  d0,d1
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d2
                asr.l   #3,d2
                sub.l   d2,d0
                asr.l   #2,d2
                sub.l   d2,d0
                swap    d0
                move.w  d0,d2
                addi.w  #$2C0,d0
                add.w   d3,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w     ; Calculate effective Y position
                sub.w   d1,d2
                move.w  d2,(Events_bg+$10).w            ; Water line equilibrium point
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                tst.w   d2
                beq.w   loc_3EB36                       ; Equilibrium skips ahead
                move.l  d0,d1
                move.l  d0,d3
                asr.l   #6,d3
                move.l  d3,d4
                asr.l   #3,d4
                sub.l   d4,d3
                moveq   #$20-1,d4
                cmpi.w  #-$40,d2
                bgt.s   loc_3EAB6
                lea     (HScroll_table+$01E).w,a1       ; Above water, no art reloading needed

loc_3EA9E:
                swap    d1
                move.w  d1,(a1)+
                swap    d1
                sub.l   d3,d1
                swap    d1
                move.w  d1,(a1)+
                swap    d1
                sub.l   d3,d1
                dbf     d4,loc_3EA9E
                bra.w   loc_3EB36
; ---------------------------------------------------------------------------

loc_3EAB6:
                lea     (HScroll_table+$11E).w,a1       ; Below water

loc_3EABA:
                swap    d1
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                swap    d1
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                dbf     d4,loc_3EABA
                cmpi.w  #$40,d2
                bge.s   loc_3EB36                       ; No art reloading needed if out of range
                lea     (HScroll_table+$09E).w,a1
                lea     (a1),a5
                lea     (LBZ_WaterlineScroll_Data).l,a6
                move.w  d2,d1
                bmi.s   loc_3EB0E
                move.w  d1,d3                           ; Below water
                neg.w   d3
                addi.w  #$40,d3
                lsl.w   #6,d3
                adda.w  d3,a6
                subq.w  #1,d1
                moveq   #0,d3
                lsr.w   #1,d1
                bcc.s   loc_3EB00

loc_3EAF8:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),(a1)+

loc_3EB00:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),(a1)+
                dbf     d1,loc_3EAF8
                bra.s   loc_3EB36
; ---------------------------------------------------------------------------

loc_3EB0E:
                move.w  d1,d3                           ; Above water
                addi.w  #$40,d3
                lsl.w   #6,d3
                adda.w  d3,a6
                neg.w   d1
                subq.w  #1,d1
                moveq   #0,d3
                lsr.w   #1,d1
                bcc.s   loc_3EB2A

loc_3EB22:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),-(a1)

loc_3EB2A:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),-(a1)
                dbf     d1,loc_3EB22

loc_3EB36:
                lea     (HScroll_table+$1E2).w,a1       ; Below the water area moving up (from Knuckles area of course)
                move.l  d0,d1
                asr.l   #1,d1
                move.l  d1,d3
                asr.l   #3,d3
                swap    d1
                move.w  d1,(Camera_X_pos_BG_copy).w     ; Effective X
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                swap    d1
                move.w  d1,(Events_bg+$12).w            ; Art reloading for the bricks in Knuckles' area
                move.w  d1,-(a1)
                swap    d1
                lea     LBZ2_BGUWDeformRange(pc),a5     ; This is an array of counters used for deformation sizes underwater
                sub.l   d3,d1                           ; Likely because the underwater wavy effect necessitates specifying deformation line-by-line
                moveq   #4,d4

loc_3EB60:
                sub.l   d3,d1
                swap    d1
                move.w  (a5)+,d5

loc_3EB66:
                move.w  d1,-(a1)
                move.w  d1,-(a1)
                move.w  d1,-(a1)
                move.w  d1,-(a1)
                dbf     d5,loc_3EB66
                swap    d1
                dbf     d4,loc_3EB60
                moveq   #$40-1,d3
                tst.w   d2
                bmi.s   loc_3EB82
                sub.w   d2,d3                           ; Only perform as much addition line-by-line deformation as needed
                bcs.s   loc_3EB90

loc_3EB82:
                swap    d1
                lsr.w   #1,d3
                bcc.s   loc_3EB8A

loc_3EB88:
                move.w  d1,-(a1)

loc_3EB8A:
                move.w  d1,-(a1)
                dbf     d3,loc_3EB88

loc_3EB90:
                lea     (HScroll_table).w,a1            ; With that over with, we can actually do some normal stuff
                lea     LBZ2_CloudDeformArray(pc),a5
                move.l  d0,d1
                asr.l   #6,d1
                move.l  d1,d3
                move.l  (HScroll_table+$1E2).w,d4
                addi.l  #$E00,(HScroll_table+$1E2).w    ; Move clouds
                moveq   #$D-1,d5

loc_3EBAC:
                move.w  (a5)+,d6
                add.l   d4,d1
                swap    d1
                move.w  d1,(a1,d6.w)
                swap    d1
                add.l   d3,d1
                dbf     d5,loc_3EBAC
                move.l  d0,d1                           ; And now just do the rest of the deformation
                asr.l   #4,d1
                move.l  d1,d3
                asr.l   #1,d3
                lea     (HScroll_table+$01A).w,a1
                swap    d1
                move.w  d1,(a1)+
                swap    d1
                add.l   d3,d1
                swap    d1
                move.w  d1,(a1)+
                tst.w   d2
                bpl.s   loc_3EBEC                       ; If below water, just do the full deformation
                moveq   #$40-1,d4
                add.w   d2,d4
                bmi.s   loc_3EC0A                       ; If above water far enough that entire waterline shows, skip ahead
                cmpi.w  #$30,d4
                blo.s   loc_3EBFE
                subi.w  #$30,d4
                bra.s   loc_3EBEE
; ---------------------------------------------------------------------------

loc_3EBEC:
                moveq   #$10-1,d4

loc_3EBEE:
                moveq   #$18-1,d5

loc_3EBF0:
                move.w  d1,(a1)+                        ; First $30 pixels have their own deformation
                move.w  d1,(a1)+
                dbf     d5,loc_3EBF0
                swap    d1
                add.l   d3,d1
                swap    d1

loc_3EBFE:
                lsr.w   #1,d4                           ; As do the last $10 pixels
                bcc.s   loc_3EC04

loc_3EC02:
                move.w  d1,(a1)+

loc_3EC04:
                move.w  d1,(a1)+
                dbf     d4,loc_3EC02

loc_3EC0A:
                moveq   #$3F,d0                         ; And yet, there's more, cause we now have the wavy effects to go!
                sub.w   d2,d0
                bmi.s   locret_3EC42                    ; If high enough, no waviness needed
                addi.w  #$60,d0                         ; Otherwise, keep it up
                cmpi.w  #$E0,d0
                blo.s   loc_3EC1E
                move.w  #$E0-1,d0

loc_3EC1E:
                lea     (HScroll_table+$1DE).w,a1
                lea     LBZ_WaterWaveArray(pc),a5       ; Water wave array
                move.w  (Level_frame_counter).w,d1
                asr.w   #1,d1
                andi.w  #$7E,d1
                adda.w  d1,a5
                lsr.w   #1,d0
                bcc.s   loc_3EC3A

loc_3EC36:
                move.w  -(a5),d3
                add.w   d3,-(a1)

loc_3EC3A:
                move.w  -(a5),d3
                add.w   d3,-(a1)
                dbf     d0,loc_3EC36

locret_3EC42:
                rts
; End of function LBZ2_Deform

; =============== S U B R O U T I N E =======================================

LBZ2_DeathEggDeform:
                move.w  (Camera_Y_pos_copy).w,d0        ; Oh no, I'm not commenting all of this again
                move.w  (Screen_shake_offset).w,d3
                sub.w   d3,d0
                subi.w  #$5F0,d0
                sub.w   (Events_bg+$02).w,d0
                sub.w   (Events_bg+$06).w,d0
                move.w  d0,d1
                swap    d0
                clr.w   d0
                asr.l   #1,d0
                move.l  d0,d2
                asr.l   #3,d2
                sub.l   d2,d0
                asr.l   #2,d2
                sub.l   d2,d0
                swap    d0
                move.w  d0,d2
                addi.w  #$2C0,d0
                add.w   d3,d0
                bpl.s   loc_3EC90
                moveq   #0,d3
                move.w  d0,d4

loc_3EC7C:
                addi.w  #$100,d3
                addi.w  #$100,d4
                bmi.s   loc_3EC7C
                cmp.w   (_unkEEA0).w,d3
                blo.s   loc_3EC90
                move.w  d3,(_unkEEA0).w

loc_3EC90:
                add.w   (_unkEEA0).w,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                tst.w   (_unkEEA0).w
                beq.s   loc_3ECAE

loc_3EC9E:
                cmpi.w  #$100,d0
                blo.s   loc_3ECAA
                subi.w  #$100,d0
                bra.s   loc_3EC9E
; ---------------------------------------------------------------------------

loc_3ECAA:
                move.w  d0,(Camera_Y_pos_BG_copy).w

loc_3ECAE:
                tst.w   (_unkEE9C).w
                bmi.s   loc_3ECB8
                sub.w   d1,d2
                bpl.s   loc_3ECBC

loc_3ECB8:
                move.w  #$7FFF,d2

loc_3ECBC:
                move.w  d2,(Events_bg+$10).w
                move.w  (Camera_X_pos_copy).w,d0
                swap    d0
                clr.w   d0
                move.l  d0,d1
                move.l  d0,d3
                asr.l   #6,d3
                move.l  d3,d4
                asr.l   #3,d4
                sub.l   d4,d3
                moveq   #$20-1,d4
                lea     (HScroll_table+$0AC).w,a1

loc_3ECDA:
                swap    d1
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                swap    d1
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                dbf     d4,loc_3ECDA
                cmpi.w  #$40,d2
                bge.s   loc_3ED2A
                lea     (HScroll_table+$02C).w,a1
                lea     (a1),a5
                lea     (LBZ_WaterlineScroll_Data).l,a6
                move.w  d2,d1
                move.w  d1,d3
                neg.w   d3
                addi.w  #$40,d3
                lsl.w   #6,d3
                adda.w  d3,a6
                subq.w  #1,d1
                moveq   #0,d3
                lsr.w   #1,d1
                bcc.s   loc_3ED1E

loc_3ED16:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),(a1)+

loc_3ED1E:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),(a1)+
                dbf     d1,loc_3ED16

loc_3ED2A:
                lea     (HScroll_table+$0EC).w,a1
                move.l  d0,d1
                asr.l   #1,d1
                move.l  d1,d3
                asr.l   #3,d3
                moveq   #7-1,d4

loc_3ED38:
                sub.l   d3,d1
                dbf     d4,loc_3ED38
                moveq   #$60-1,d3
                sub.w   d2,d3
                bcs.s   loc_3ED52
                swap    d1
                lsr.w   #1,d3
                bcc.s   loc_3ED4C

loc_3ED4A:
                move.w  d1,-(a1)

loc_3ED4C:
                move.w  d1,-(a1)
                dbf     d3,loc_3ED4A

loc_3ED52:
                lea     (HScroll_table+$00C).w,a1
                lea     LBZ2_CloudDeformArray(pc),a5
                move.l  d0,d1
                asr.l   #6,d1
                move.l  d1,d3
                move.l  (HScroll_table+$1E2).w,d4
                addi.l  #$E00,(HScroll_table+$1E2).w
                moveq   #$D-1,d5

loc_3ED6E:
                move.w  (a5)+,d6
                add.l   d4,d1
                swap    d1
                move.w  d1,(a1,d6.w)
                swap    d1
                add.l   d3,d1
                dbf     d5,loc_3ED6E
                lea     (HScroll_table+$010).w,a1
                lea     (HScroll_table).w,a5
                moveq   #4-1,d1

loc_3ED8A:
                move.l  (a1)+,(a5)+
                dbf     d1,loc_3ED8A
                move.l  d0,d1
                asr.l   #4,d1
                move.l  d1,d3
                asr.l   #1,d3
                lea     (HScroll_table+$026).w,a1
                swap    d1
                move.w  d1,(a1)+
                swap    d1
                add.l   d3,d1
                swap    d1
                move.w  d1,(a1)+
                swap    d1
                add.l   d3,d1
                swap    d1
                move.w  d1,(a1)+
                moveq   #$40-1,d0
                sub.w   d2,d0
                addi.w  #$20,d0
                cmpi.w  #$60,d0
                blo.s   loc_3EDC2
                move.w  #$60-1,d0

loc_3EDC2:
                lea     (HScroll_table+$0EC).w,a1
                lea     LBZ_WaterWaveArray2(pc),a5
                move.w  (Level_frame_counter).w,d1
                asr.w   #1,d1
                andi.w  #$7E,d1
                adda.w  d1,a5
                lsr.w   #1,d0
                bcc.s   loc_3EDDE

loc_3EDDA:
                move.w  -(a5),d3
                add.w   d3,-(a1)

loc_3EDDE:
                move.w  -(a5),d3
                add.w   d3,-(a1)
                dbf     d0,loc_3EDDA
                rts
; End of function LBZ2_DeathEggDeform

; =============== S U B R O U T I N E =======================================

LBZ2_DeathEggMoveScreen:
                cmpi.b  #6,(Player_1+routine).w
                bhs.w   locret_3EEBC                    ; If dying, don't bother
                tst.b   (Scroll_lock).w
                beq.s   loc_3EE1E                       ; Skip if flag turned off
                move.w  (Player_1+x_pos).w,d0
                sub.w   (Camera_X_pos).w,d0
                subi.w  #$A0,d0
                bcs.s   loc_3EE0A
                add.w   d0,(Camera_X_pos).w             ; Move screen along with player in Robotnik ship

loc_3EE0A:
                cmpi.w  #$4390,(Camera_X_pos).w
                bhs.s   loc_3EE1A
                cmpi.w  #$668,(Camera_Y_pos).w
                blo.s   loc_3EE1E

loc_3EE1A:
                clr.b   (Scroll_lock).w                 ; Stop movement when screen edge is reached

loc_3EE1E:
                tst.w   (Events_bg+$0E).w
                beq.s   loc_3EE2C
                subq.w  #1,(Events_bg+$0E).w
                bra.w   locret_3EEBC
; ---------------------------------------------------------------------------

loc_3EE2C:
                cmpi.w  #$4390,(Camera_X_pos).w
                blo.s   loc_3EE40
                move.w  (Camera_max_X_pos).w,d0
                move.w  d0,(Camera_min_X_pos).w
                move.w  d0,(Camera_target_min_X_pos).w

loc_3EE40:
                cmpi.w  #$668,(Camera_Y_pos).w
                blo.s   loc_3EE54
                move.w  (Camera_max_Y_pos).w,d0
                move.w  d0,(Camera_min_Y_pos).w         ; Lock screen when edges are reached
                move.w  d0,(Camera_target_min_Y_pos).w

loc_3EE54:
                lea     (Events_bg+$02).w,a1
                moveq   #0,d1
                move.w  (_unkEEA2).w,d1                 ; Speed of Death Egg movement
                add.l   d1,(a1)
                move.w  (a1),d0
                move.w  d0,d1
                sub.w   8(a1),d0
                move.w  d1,8(a1)
                move.w  #$2200,d1
                tst.b   (Scroll_lock).w
                bne.s   loc_3EE7A
                move.l  (_unkEE9C).w,d1                 ; Get BG movement speed if edge of screen is reached

loc_3EE7A:
                add.l   d1,4(a1)
                move.w  4(a1),d1
                move.w  d1,d2
                sub.w   $A(a1),d1
                move.w  d2,$A(a1)
                tst.b   (Scroll_lock).w
                beq.s   loc_3EE9E
                movea.w (Events_bg+$00).w,a5            ; If movement is still going
                add.w   d0,$14(a5)                      ; Add Y movement to screen and Robotnik ship
                add.w   d0,(Camera_Y_pos).w

loc_3EE9E:
                move.w  (Target_water_level).w,d2
                add.w   d0,d2
                add.w   d1,d2
                cmpi.w  #$F00,d2
                blo.s   loc_3EEB0
                move.w  #$F80,d2

loc_3EEB0:
                move.w  d2,(Target_water_level).w
                move.w  d0,(Events_bg+$14).w
                add.w   d1,(Events_bg+$14).w

locret_3EEBC:
                rts
; End of function LBZ2_DeathEggMoveScreen

; =============== S U B R O U T I N E =======================================

LBZ2_EndFallingAccel:
                tst.w   (_unkEEA2).w
                beq.s   loc_3EECC
                subi.w  #$100,(_unkEEA2).w
                bra.s   locret_3EEDE
; ---------------------------------------------------------------------------

loc_3EECC:
                cmpi.l  #$FFFE8000,(_unkEE9C).w
                ble.s   locret_3EEDE
                subi.l  #$100,(_unkEE9C).w

locret_3EEDE:
                rts
; End of function LBZ2_EndFallingAccel

; ---------------------------------------------------------------------------
LBZ2_BGDeformArray:
                dc.w    $C0,   $40,   $38,   $18,   $28,   $10,   $10,   $10,   $18
                dc.w    $40,   $20,   $10,   $20,   $70,   $30, $80E0,   $20, $7FFF
LBZ2_DEBGDeformArray:
                dc.w    $38,   $18,   $28,   $10,   $10,   $10,   $18,   $40,   $38,   $18,   $28,   $10
                dc.w    $10,   $10,   $18,   $40,   $20,   $10,   $20,   $70,   $60,   $10, $805F, $7FFF
LBZ2_CloudDeformArray:
                dc.w    $16,  $E,  $A, $14,  $C,   6, $18, $10, $12,   2,   8,   4,   0
LBZ2_BGUWDeformRange:
                dc.w    7,   1,   3,   1,   7
