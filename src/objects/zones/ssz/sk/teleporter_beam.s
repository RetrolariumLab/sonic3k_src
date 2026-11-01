; Owner: objects/zones/ssz/sk
; Responsibility: Teleporter beam spawning, expansion, animation and transition effects
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_TeleporterBeam:
                move.l  #Obj_TeleporterBeamSpawn,(a0)
                move.b  #$44,render_flags(a0)           ; Multisprite mode
                move.b  #$80,height_pixels(a0)
                move.b  #$18,width_pixels(a0)
                move.w  #$80,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$88,3,1),art_tile(a0)
                move.l  #Map_SSZHPZTeleporter,mappings(a0)
                move.w  #1,mainspr_childsprites(a0)
                move.w  y_pos(a0),$44(a0)
                subi.w  #$88,$44(a0)
                move.b  #$10,$47(a0)                    ; Wait 16 frames
                cmpi.b  #3,(Current_zone).w
                bne.s   loc_45908
                move.w  #$24EE,art_tile(a0)             ; If in CNZ, use this VRAM offset
                bra.s   Obj_TeleporterBeamSpawn
; ---------------------------------------------------------------------------

loc_45908:
                cmpi.b  #$16,(Current_zone).w
                bne.s   Obj_TeleporterBeamSpawn
                move.w  #make_art_tile(ArtTile_HPZTeleporter,3,0),art_tile(a0)  ; If in HPZ, use this VRAM offset

Obj_TeleporterBeamSpawn:
                tst.b   $47(a0)
                beq.s   loc_45922
                subq.b  #1,$47(a0)
                bra.s   locret_45990
; ---------------------------------------------------------------------------

loc_45922:
                btst    #0,(Level_frame_counter+1).w
                beq.s   locret_45990                    ; Do a flickering effect
                lea     sub2_x_pos(a0),a1               ; Sprite attribute table to a1
                move.w  y_pos(a0),d0
                move.w  mainspr_childsprites(a0),d1
                subq.w  #1,d1

loc_45938:
                move.w  x_pos(a0),(a1)                  ; Same X coordinate for all sprites
                move.w  d0,sub2_y_pos-sub2_x_pos(a1)    ; Different Y coordinate offset from base
                tst.w   d1
                bne.s   loc_45960
                eori.b  #-1,$46(a0)                     ; If the last listed sprite
                beq.s   loc_45954
                move.b  #1,sub2_mapframe-sub2_x_pos(a1)  ; Use mapping 1 on the first frame
                bra.s   loc_4596C
; ---------------------------------------------------------------------------

loc_45954:
                move.b  #2,sub2_mapframe-sub2_x_pos(a1)  ; Mapping 2 on the second frame + add new sprite
                addq.w  #1,mainspr_childsprites(a0)
                bra.s   loc_4596C
; ---------------------------------------------------------------------------

loc_45960:
                move.b  #2,sub2_mapframe-sub2_x_pos(a1)
                subi.w  #$20,d0
                addq.w  #next_subspr,a1

loc_4596C:
                dbf     d1,loc_45938
                cmpi.w  #7,mainspr_childsprites(a0)
                blo.s   loc_4598A
                tst.b   $46(a0)                         ; When seven sprites have been made, test $46
                bne.s   loc_4598A
                move.l  #Obj_TeleporterBeamWait,(a0)    ; When last sprite uses mapping frame 2, go to next phase
                move.b  #$10,$47(a0)

loc_4598A:
                jsr     (Draw_Sprite).l

locret_45990:
                rts
; ---------------------------------------------------------------------------

Obj_TeleporterBeamWait:
                subq.b  #1,$47(a0)
                beq.s   loc_459A8
                btst    #0,(Level_frame_counter+1).w
                beq.s   locret_459A6
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_459A6:
                rts
; ---------------------------------------------------------------------------

loc_459A8:
                move.l  #Obj_TeleporterBeamExpand,(a0)
                move.w  #2,mainspr_childsprites(a0)     ; Use two large sprites for the beam

Obj_TeleporterBeamExpand:
                btst    #0,(Level_frame_counter+1).w
                beq.w   locret_45A64
                move.w  $44(a0),d0
                move.w  d0,d1
                sub.w   (Camera_Y_pos).w,d1
                cmpi.w  #$68,d1
                ble.s   loc_459D6
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$68,d0                         ; Ensure that object base Y is always centered or above the screen

loc_459D6:
                move.w  d0,y_pos(a0)
                move.w  x_pos(a0),d1
                moveq   #0,d2
                move.b  $46(a0),d2                      ; $46 should be 0 starting out
                move.w  d2,d3
                cmpi.w  #$12,d2                         ; Maximum of $12
                blo.s   loc_459EE
                moveq   #$12,d2

loc_459EE:
                addq.w  #6,d2
                lsl.w   #3,d3
                lea     word_46734(pc),a1               ; Use if in SSZ or HPZ
                cmpi.b  #$A,(Current_zone).w
                beq.s   loc_45A0A
                cmpi.b  #$16,(Current_zone).w
                beq.s   loc_45A0A
                lea     word_467FC(pc),a1               ; Use if anywhere else

loc_45A0A:
                adda.w  d3,a1
                lea     sub2_x_pos(a0),a2
                move.w  d1,(a2)
                sub.w   d2,(a2)+
                move.w  (a1)+,(a2)
                add.w   d0,(a2)+
                move.w  (a1)+,(a2)+
                move.w  d1,(a2)
                add.w   d2,(a2)+
                move.w  (a1)+,(a2)
                add.w   d0,(a2)+
                move.w  (a1)+,(a2)+
                tst.b   routine(a0)
                beq.s   loc_45A4A
                subq.b  #1,$46(a0)                      ; Contract beam
                bpl.s   loc_45A5E                       ; Branch if beam is still in effect
                move.b  #9,mapping_frame(a0)            ; Change main mapping
                clr.w   mainspr_childsprites(a0)        ; No more sprites
                move.l  #Delete_Current_Sprite,(a0)     ; Delete object
                movea.w parent2(a0),a1
                clr.b   $38(a1)                         ; Set flag to parent indicating completion
                bra.s   loc_45A5E
; ---------------------------------------------------------------------------

loc_45A4A:
                btst    #1,(Level_frame_counter+1).w
                beq.s   loc_45A5E
                cmpi.b  #$18,$46(a0)
                bhs.s   loc_45A5E
                addq.b  #1,$46(a0)                      ; Expand beam

loc_45A5E:
                jsr     (Draw_Sprite).l

locret_45A64:
                rts
; ---------------------------------------------------------------------------

loc_45A66:
                move.l  #loc_45A72,(a0)
                addi.w  #high_priority,art_tile(a0)

loc_45A72:
                tst.w   $32(a0)
                beq.s   loc_45A84
                subq.w  #1,$32(a0)
                bne.s   loc_45AD0
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_45A84:
                tst.w   $2E(a0)
                bne.s   loc_45AB0
                move.w  (Camera_Y_pos).w,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                bne.s   loc_45AD0
                jsr     (AllocateObject).l
                bne.s   loc_45AAE
                move.l  #Obj_SSZEndBoss,(a1)
                move.w  a1,(_unkFAA4).w
                move.w  a1,$30(a0)
                st      $2E(a0)

loc_45AAE:
                bra.s   loc_45AD0
; ---------------------------------------------------------------------------

loc_45AB0:
                movea.w $30(a0),a1
                move.w  x_pos(a1),d0
                cmp.w   x_pos(a0),d0
                bhi.s   loc_45AD0
                move.w  #$20,$32(a0)
                lea     (Child6_CreateBossExplosion).l,a2
                jsr     (CreateChild1_Normal).l

loc_45AD0:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_45AD6:
                jsr     CycleSszHpzTeleporterPalettePair(pc)
                tst.b   routine(a0)
                beq.s   loc_45B16
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_45B16
                move.w  a1,$3C(a0)
                move.l  #Obj_TeleporterBeam,(a1)
                move.w  a0,parent2(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #loc_45B1C,(a0)
                move.w  #-$100,$38(a0)
                moveq   #signextendB(sfx_Charging),d0
                jsr     (Play_SFX).l

loc_45B16:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_45B1C:
                jsr     CycleSszHpzTeleporterPalettePair(pc)
                movea.w (_unkFAA4).w,a1
                movea.w $3C(a0),a2
                cmpi.b  #8,$46(a2)
                blt.w   loc_45B84
                beq.w   loc_45B7E
                cmpi.b  #$18,$46(a2)
                bhs.s   loc_45B6C
                btst    #0,(Level_frame_counter+1).w
                beq.w   loc_45B84
                subq.w  #1,y_pos(a1)
                btst    #1,(Level_frame_counter+1).w
                beq.w   loc_45B84
                moveq   #1,d1
                move.w  x_pos(a1),d0
                cmp.w   x_pos(a0),d0
                beq.s   loc_45B84
                bcs.s   loc_45B66
                neg.w   d1

loc_45B66:
                add.w   d1,x_pos(a1)
                bra.s   loc_45B84
; ---------------------------------------------------------------------------

loc_45B6C:
                clr.l   (a1)
                moveq   #signextendB(sfx_Transporter),d0
                jsr     (Play_SFX).l
                move.l  #loc_45B8A,(a0)
                bra.s   loc_45B84
; ---------------------------------------------------------------------------

loc_45B7E:
                bset    #7,(_unkFAB8).w

loc_45B84:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_45B8A:
                jsr     CycleSszHpzTeleporterPalettePair(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_45B94:
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_45BC8
                cmpi.w  #$240,(Camera_Y_pos).w
                bhs.s   locret_45BF2
                cmpi.w  #$B00,(Player_1+x_pos).w
                blo.s   locret_45BF2
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                st      (SRAM_mask_interrupts_flag).w
                jsr     (SaveGame).l
                move.w  #$A01,d0
                jmp     (StartNewLevel).l
; ---------------------------------------------------------------------------

loc_45BC8:
                movea.w $2E(a0),a1
                cmpi.w  #$1000,x_pos(a1)
                bhs.s   loc_45BDA
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_45BDA:
                move.l  #$40C0408,(Normal_palette_line_4+$2).w
                st      (Palette_cycle_counters+$00).w
                move.l  #loc_45AD6,(a1)
                move.l  #loc_45BF4,(a0)

locret_45BF2:
                rts
; ---------------------------------------------------------------------------

loc_45BF4:
                move.w  #$1600,d0
                cmp.w   (Camera_X_pos).w,d0
                blo.s   loc_45C0C
                cmp.w   (Camera_max_X_pos).w,d0
                beq.s   loc_45C0C
                move.w  d0,(Camera_max_X_pos).w
                clr.w   (Camera_min_Y_pos).w

loc_45C0C:
                lea     (Player_1).w,a1
                lea     (Ctrl_1_logical).w,a2
                lea     (Ctrl_1_locked).w,a3
                lea     $30(a0),a4
                lea     1(a4),a5
                moveq   #0,d6
                bsr.s   AdvanceHpzDeparturePlayerScript
                tst.w   (Player_mode).w
                bne.s   loc_45C42
                lea     (Player_2).w,a1
                lea     (Ctrl_2_logical).w,a2
                lea     (Ctrl_2_locked).w,a3
                lea     $31(a0),a4
                lea     -1(a4),a5
                moveq   #1,d6
                bsr.s   AdvanceHpzDeparturePlayerScript

loc_45C42:
                move.b  subtype(a0),d0
                beq.s   loc_45C72
                subq.b  #1,d0
                bne.s   loc_45C60
                subq.b  #1,$2D(a0)
                bne.s   loc_45C72
                bset    #6,(_unkFAB8).w
                move.w  #(2<<8)|60,subtype(a0)
                bra.s   loc_45C72
; ---------------------------------------------------------------------------

loc_45C60:
                subq.b  #1,$2D(a0)
                bne.s   loc_45C72
                movea.w $2E(a0),a1
                st      routine(a1)
                clr.w   subtype(a0)

loc_45C72:
                tst.b   routine(a0)
                beq.s   locret_45C8C
                subq.w  #1,(Camera_X_pos).w
                btst    #0,routine(a0)
                beq.s   loc_45C88
                subq.w  #1,(Camera_Y_pos).w

loc_45C88:
                subq.b  #1,routine(a0)

locret_45C8C:
                rts

; =============== S U B R O U T I N E =======================================

AdvanceHpzDeparturePlayerScript:
                move.b  (a4),d0
                bmi.w   locret_45DAC
                bne.s   loc_45CC0
                move.w  #$1628,d0
                tst.w   d6
                beq.s   loc_45CA2
                addi.w  #$10,d0

loc_45CA2:
                cmp.w   x_pos(a1),d0
                blo.w   locret_45DAC
                move.w  d0,x_pos(a1)
                clr.w   x_vel(a1)
                clr.w   ground_vel(a1)
                clr.w   (a2)
                st      (a3)
                addq.b  #1,(a4)
                bra.w   locret_45DAC
; ---------------------------------------------------------------------------

loc_45CC0:
                subq.b  #1,d0
                bne.s   loc_45CE4
                btst    #1,status(a1)
                bne.w   locret_45DAC
                move.b  #-$60,2(a4)
                tst.w   d6
                beq.s   loc_45CDE
                move.b  #-$24,2(a4)

loc_45CDE:
                addq.b  #1,(a4)
                bra.w   locret_45DAC
; ---------------------------------------------------------------------------

loc_45CE4:
                subq.b  #1,d0
                bne.s   loc_45D0C
                tst.w   (Player_mode).w
                bne.s   loc_45CF6
                tst.b   2(a5)
                beq.w   locret_45DAC

loc_45CF6:
                move.w  #(1<<8)|60,subtype(a0)
                move.b  #$48,routine(a0)
                st      (Scroll_lock).w
                addq.b  #1,(a4)
                bra.w   locret_45DAC
; ---------------------------------------------------------------------------

loc_45D0C:
                subq.b  #1,d0
                bne.s   loc_45D2E
                tst.w   subtype(a0)
                bne.w   locret_45DAC
                subq.b  #1,2(a4)
                bne.w   locret_45DAC
                move.w  #-$100,x_vel(a1)
                move.w  #$2424,(a2)
                addq.b  #1,(a4)
                bra.s   locret_45DAC
; ---------------------------------------------------------------------------

loc_45D2E:
                subq.b  #1,d0
                bne.s   loc_45D8A
                move.w  #$15C0,d0
                cmp.w   x_pos(a1),d0
                blo.s   loc_45D84
                move.w  d0,x_pos(a1)
                subi.w  #$80,y_pos(a1)
                clr.w   x_vel(a1)
                clr.w   ground_vel(a1)
                move.b  #3,$2E(a1)
                clr.b   anim(a1)
                clr.b   mapping_frame(a1)
                clr.w   (a2)
                moveq   #signextendB(sfx_Transporter),d0
                jsr     (Play_SFX).l
                tst.w   d6
                beq.s   loc_45D6E
                st      (a4)
                rts
; ---------------------------------------------------------------------------

loc_45D6E:
                move.b  #60,2(a4)
                tst.w   (Player_mode).w
                bne.s   loc_45D80
                move.b  #2*60,2(a4)

loc_45D80:
                addq.b  #1,(a4)
                bra.s   locret_45DAC
; ---------------------------------------------------------------------------

loc_45D84:
                move.w  #$2404,(a2)
                bra.s   locret_45DAC
; ---------------------------------------------------------------------------

loc_45D8A:
                subq.b  #1,2(a4)
                bne.s   locret_45DAC
                moveq   #signextendB(cmd_FadeOut),d0
                jsr     (Play_Music).l
                st      (SRAM_mask_interrupts_flag).w
                jsr     (SaveGame).l
                move.w  #$A00,d0
                jmp     (StartNewLevel).l
; ---------------------------------------------------------------------------

locret_45DAC:
                rts
; End of function AdvanceHpzDeparturePlayerScript
