; Owner: game/level/zones/lbz/sk
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
                beq.w   loc_546FA                       ; Equilibrium skips ahead
                move.l  d0,d1
                move.l  d0,d3
                asr.l   #6,d3
                move.l  d3,d4
                asr.l   #3,d4
                sub.l   d4,d3
                moveq   #$20-1,d4
                cmpi.w  #-$40,d2
                bgt.s   loc_5467A
                lea     (HScroll_table+$01E).w,a1       ; Above water, no art reloading needed

loc_54662:
                swap    d1
                move.w  d1,(a1)+
                swap    d1
                sub.l   d3,d1
                swap    d1
                move.w  d1,(a1)+
                swap    d1
                sub.l   d3,d1
                dbf     d4,loc_54662
                bra.w   loc_546FA
; ---------------------------------------------------------------------------

loc_5467A:
                lea     (HScroll_table+$11E).w,a1       ; Below water

loc_5467E:
                swap    d1
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                swap    d1
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                dbf     d4,loc_5467E
                cmpi.w  #$40,d2
                bge.s   loc_546FA                       ; No art reloading needed if out of range
                lea     (HScroll_table+$09E).w,a1
                lea     (a1),a5
                lea     (LBZ_WaterlineScroll_Data).l,a6
                move.w  d2,d1
                bmi.s   loc_546D2
                move.w  d1,d3                           ; Below water
                neg.w   d3
                addi.w  #$40,d3
                lsl.w   #6,d3
                adda.w  d3,a6
                subq.w  #1,d1
                moveq   #0,d3
                lsr.w   #1,d1
                bcc.s   loc_546C4

loc_546BC:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),(a1)+

loc_546C4:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),(a1)+
                dbf     d1,loc_546BC
                bra.s   loc_546FA
; ---------------------------------------------------------------------------

loc_546D2:
                move.w  d1,d3                           ; Above water
                addi.w  #$40,d3
                lsl.w   #6,d3
                adda.w  d3,a6
                neg.w   d1
                subq.w  #1,d1
                moveq   #0,d3
                lsr.w   #1,d1
                bcc.s   loc_546EE

loc_546E6:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),-(a1)

loc_546EE:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),-(a1)
                dbf     d1,loc_546E6

loc_546FA:
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
                lea     (LBZ2_BGUWDeformRange).l,a5     ; This is an array of counters used for deformation sizes underwater
                sub.l   d3,d1                           ; Likely because the underwater wavy effect necessitates specifying deformation line-by-line
                moveq   #4,d4

loc_54726:
                sub.l   d3,d1
                swap    d1
                move.w  (a5)+,d5

loc_5472C:
                move.w  d1,-(a1)
                move.w  d1,-(a1)
                move.w  d1,-(a1)
                move.w  d1,-(a1)
                dbf     d5,loc_5472C
                swap    d1
                dbf     d4,loc_54726
                moveq   #$40-1,d3
                tst.w   d2
                bmi.s   loc_54748
                sub.w   d2,d3                           ; Only perform as much addition line-by-line deformation as needed
                bcs.s   loc_54756

loc_54748:
                swap    d1
                lsr.w   #1,d3
                bcc.s   loc_54750

loc_5474E:
                move.w  d1,-(a1)

loc_54750:
                move.w  d1,-(a1)
                dbf     d3,loc_5474E

loc_54756:
                lea     (HScroll_table).w,a1            ; With that over with, we can actually do some normal stuff
                lea     (LBZ2_CloudDeformArray).l,a5
                move.l  d0,d1
                asr.l   #6,d1
                move.l  d1,d3
                move.l  (HScroll_table+$1E2).w,d4
                addi.l  #$E00,(HScroll_table+$1E2).w    ; Move clouds
                moveq   #$D-1,d5

loc_54774:
                move.w  (a5)+,d6
                add.l   d4,d1
                swap    d1
                move.w  d1,(a1,d6.w)
                swap    d1
                add.l   d3,d1
                dbf     d5,loc_54774
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
                bpl.s   loc_547B4                       ; If below water, just do the full deformation
                moveq   #$40-1,d4
                add.w   d2,d4
                bmi.s   loc_547D2                       ; If above water far enough that entire waterline shows, skip ahead
                cmpi.w  #$30,d4
                blo.s   loc_547C6
                subi.w  #$30,d4
                bra.s   loc_547B6
; ---------------------------------------------------------------------------

loc_547B4:
                moveq   #$10-1,d4

loc_547B6:
                moveq   #$18-1,d5

loc_547B8:
                move.w  d1,(a1)+                        ; First $30 pixels have their own deformation
                move.w  d1,(a1)+
                dbf     d5,loc_547B8
                swap    d1
                add.l   d3,d1
                swap    d1

loc_547C6:
                lsr.w   #1,d4                           ; As do the last $10 pixels
                bcc.s   loc_547CC

loc_547CA:
                move.w  d1,(a1)+

loc_547CC:
                move.w  d1,(a1)+
                dbf     d4,loc_547CA

loc_547D2:
                moveq   #$3F,d0                         ; And yet, there's more, cause we now have the wavy effects to go!
                sub.w   d2,d0
                bmi.s   locret_5480A                    ; If high enough, no waviness needed
                addi.w  #$60,d0                         ; Otherwise, keep it up
                cmpi.w  #$E0,d0
                blo.s   loc_547E6
                move.w  #$E0-1,d0

loc_547E6:
                lea     (HScroll_table+$1DE).w,a1
                lea     LBZ_WaterWaveArray(pc),a5       ; Water wave array
                move.w  (Level_frame_counter).w,d1
                asr.w   #1,d1
                andi.w  #$7E,d1
                adda.w  d1,a5
                lsr.w   #1,d0
                bcc.s   loc_54802

loc_547FE:
                move.w  -(a5),d3
                add.w   d3,-(a1)

loc_54802:
                move.w  -(a5),d3
                add.w   d3,-(a1)
                dbf     d0,loc_547FE

locret_5480A:
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
                sub.w   (Events_fg_3).w,d0
                add.w   d3,d0
                bpl.s   loc_5485C
                moveq   #0,d3
                move.w  d0,d4

loc_54848:
                addi.w  #$100,d3
                addi.w  #$100,d4
                bmi.s   loc_54848
                cmp.w   (_unkEEA0).w,d3
                blo.s   loc_5485C
                move.w  d3,(_unkEEA0).w

loc_5485C:
                tst.w   (Events_fg_3).w
                bne.s   loc_5486C
                cmpi.w  #$100,d0
                bne.s   loc_5486C
                move.w  d0,(Events_fg_3).w

loc_5486C:
                add.w   (_unkEEA0).w,d0
                move.w  d0,(Camera_Y_pos_BG_copy).w
                tst.w   (_unkEEA0).w
                beq.s   loc_5488A

loc_5487A:
                cmpi.w  #$100,d0
                blo.s   loc_54886
                subi.w  #$100,d0
                bra.s   loc_5487A
; ---------------------------------------------------------------------------

loc_54886:
                move.w  d0,(Camera_Y_pos_BG_copy).w

loc_5488A:
                tst.w   (_unkEE9C).w
                bmi.s   loc_54894
                sub.w   d1,d2
                bpl.s   loc_54898

loc_54894:
                move.w  #$7FFF,d2

loc_54898:
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

loc_548B6:
                swap    d1
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                swap    d1
                move.w  d1,-(a1)
                swap    d1
                sub.l   d3,d1
                dbf     d4,loc_548B6
                cmpi.w  #$40,d2
                bge.s   loc_54906
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
                bcc.s   loc_548FA

loc_548F2:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),(a1)+

loc_548FA:
                move.b  (a6)+,d3
                add.w   d3,d3
                move.w  (a5,d3.w),(a1)+
                dbf     d1,loc_548F2

loc_54906:
                lea     (HScroll_table+$0EC).w,a1
                move.l  d0,d1
                asr.l   #1,d1
                move.l  d1,d3
                asr.l   #3,d3
                moveq   #7-1,d4

loc_54914:
                sub.l   d3,d1
                dbf     d4,loc_54914
                moveq   #$60-1,d3
                sub.w   d2,d3
                bcs.s   loc_5492E
                swap    d1
                lsr.w   #1,d3
                bcc.s   loc_54928

loc_54926:
                move.w  d1,-(a1)

loc_54928:
                move.w  d1,-(a1)
                dbf     d3,loc_54926

loc_5492E:
                lea     (HScroll_table+$00C).w,a1
                lea     (LBZ2_CloudDeformArray).l,a5
                move.l  d0,d1
                asr.l   #6,d1
                move.l  d1,d3
                move.l  (HScroll_table+$1E2).w,d4
                addi.l  #$E00,(HScroll_table+$1E2).w
                moveq   #$D-1,d5

loc_5494C:
                move.w  (a5)+,d6
                add.l   d4,d1
                swap    d1
                move.w  d1,(a1,d6.w)
                swap    d1
                add.l   d3,d1
                dbf     d5,loc_5494C
                lea     (HScroll_table+$010).w,a1
                lea     (HScroll_table).w,a5
                moveq   #4-1,d1

loc_54968:
                move.l  (a1)+,(a5)+
                dbf     d1,loc_54968
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
                blo.s   loc_549A0
                move.w  #$60-1,d0

loc_549A0:
                lea     (HScroll_table+$0EC).w,a1
                lea     LBZ_WaterWaveArray2(pc),a5
                move.w  (Level_frame_counter).w,d1
                asr.w   #1,d1
                andi.w  #$7E,d1
                adda.w  d1,a5
                lsr.w   #1,d0
                bcc.s   loc_549BC

loc_549B8:
                move.w  -(a5),d3
                add.w   d3,-(a1)

loc_549BC:
                move.w  -(a5),d3
                add.w   d3,-(a1)
                dbf     d0,loc_549B8
                rts
; End of function LBZ2_DeathEggDeform

; =============== S U B R O U T I N E =======================================

LBZ2_DeathEggMoveScreen:
                cmpi.b  #6,(Player_1+routine).w
                bhs.w   locret_54A92                    ; If dying, don't bother
                tst.b   (Scroll_lock).w
                beq.s   loc_549FC                       ; Skip if flag turned off
                move.w  (Player_1+x_pos).w,d0
                sub.w   (Camera_X_pos).w,d0
                subi.w  #$A0,d0
                bcs.s   loc_549E8
                add.w   d0,(Camera_X_pos).w             ; Move screen along with player in Robotnik ship

loc_549E8:
                cmpi.w  #$4390,(Camera_X_pos).w
                bhs.s   loc_549F8
                cmpi.w  #$668,(Camera_Y_pos).w
                blo.s   loc_549FC

loc_549F8:
                clr.b   (Scroll_lock).w                 ; Stop movement when screen edge is reached

loc_549FC:
                tst.w   (Events_bg+$0E).w
                beq.s   loc_54A0A
                subq.w  #1,(Events_bg+$0E).w
                bra.w   locret_54A92
; ---------------------------------------------------------------------------

loc_54A0A:
                cmpi.w  #$4390,(Camera_X_pos).w
                blo.s   loc_54A1A
                move.w  (Camera_max_X_pos).w,d0
                move.w  d0,(Camera_min_X_pos).w

loc_54A1A:
                cmpi.w  #$668,(Camera_Y_pos).w
                blo.s   loc_54A2A
                move.w  (Camera_max_Y_pos).w,d0
                move.w  d0,(Camera_min_Y_pos).w         ; Lock screen when edges are reached

loc_54A2A:
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
                bne.s   loc_54A50
                move.l  (_unkEE9C).w,d1                 ; Get BG movement speed if edge of screen is reached

loc_54A50:
                add.l   d1,4(a1)
                move.w  4(a1),d1
                move.w  d1,d2
                sub.w   $A(a1),d1
                move.w  d2,$A(a1)
                tst.b   (Scroll_lock).w
                beq.s   loc_54A74
                movea.w (Events_bg+$00).w,a5            ; If movement is still going
                add.w   d0,$14(a5)                      ; Add Y movement to screen and Robotnik ship
                add.w   d0,(Camera_Y_pos).w

loc_54A74:
                move.w  (Target_water_level).w,d2
                add.w   d0,d2
                add.w   d1,d2
                cmpi.w  #$F00,d2
                blo.s   loc_54A86
                move.w  #$F80,d2

loc_54A86:
                move.w  d2,(Target_water_level).w
                move.w  d0,(Events_bg+$14).w
                add.w   d1,(Events_bg+$14).w

locret_54A92:
                rts
; End of function LBZ2_DeathEggMoveScreen

; =============== S U B R O U T I N E =======================================

LBZ2_EndFallingAccel:
                tst.w   (_unkEEA2).w
                beq.s   loc_54AA2
                subi.w  #$100,(_unkEEA2).w
                bra.s   locret_54AB4
; ---------------------------------------------------------------------------

loc_54AA2:
                cmpi.l  #$FFFE8000,(_unkEE9C).w
                ble.s   locret_54AB4
                subi.l  #$100,(_unkEE9C).w

locret_54AB4:
                rts
; End of function LBZ2_EndFallingAccel
