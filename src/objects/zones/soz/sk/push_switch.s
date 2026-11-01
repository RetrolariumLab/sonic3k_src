; Owner: objects/zones/soz/sk
; Responsibility: Push-switch contact, player pushing, trigger state and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SOZPushSwitch:
                move.l  #Map_SOZPushSwitch,mappings(a0)
                move.w  #make_art_tile(ArtTile_SOZMisc+$8C,2,0),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$30,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                move.w  #$300,priority(a0)
                move.b  #1,mapping_frame(a0)
                move.w  x_pos(a0),$44(a0)
                bset    #6,render_flags(a0)
                move.w  #1,mainspr_childsprites(a0)
                lea     sub2_x_pos(a0),a2
                move.w  x_pos(a0),d0
                addi.w  #$10,d0
                btst    #0,status(a0)
                beq.s   loc_418D4
                subi.w  #2*$10,d0

loc_418D4:
                move.w  d0,(a2)+
                move.w  y_pos(a0),(a2)+
                move.w  #0,(a2)+
                move.l  #loc_418E4,(a0)

loc_418E4:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                moveq   #0,d1
                move.b  (a3),d1
                move.w  d1,$36(a0)
                move.b  (Player_1+status).w,$30(a0)
                move.b  (Player_2+status).w,$31(a0)
                move.w  #$17,d1
                move.w  #$10,d2
                move.w  #$11,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                moveq   #0,d4
                bsr.w   UpdatePlayerPushOrReturnForSozSwitch
                move.w  $36(a0),d0
                lsr.w   #2,d0
                btst    #0,status(a0)
                beq.s   loc_41934
                neg.w   d0

loc_41934:
                add.w   $44(a0),d0
                move.w  d0,x_pos(a0)
                tst.b   subtype(a0)
                bpl.s   loc_41946
                bsr.w   PressSozSwitchWithRegisteredRock

loc_41946:
                move.w  $36(a0),d1
                move.b  d1,(a3)
                move.w  $44(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_41966
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_41966:
                move.w  respawn_addr(a0),d0
                beq.s   loc_41972
                movea.w d0,a2
                bclr    #7,(a2)

loc_41972:
                tst.w   $36(a0)
                bne.s   loc_4197E
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4197E:
                move.l  #loc_41984,(a0)

loc_41984:
                move.w  respawn_addr(a0),d0
                beq.s   loc_41996
                movea.w d0,a2
                tst.b   (a2)
                bpl.s   loc_41996
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_41996:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                moveq   #0,d1
                move.b  (a3),d1
                move.w  d1,$36(a0)
                bsr.w   ReturnSozPushSwitchProgress
                move.w  $36(a0),d1
                move.b  d1,(a3)
                tst.w   $36(a0)
                bne.s   locret_419C4
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

locret_419C4:
                rts

; =============== S U B R O U T I N E =======================================

UpdatePlayerPushOrReturnForSozSwitch:
                moveq   #0,d5
                move.b  status(a0),d3
                andi.b  #pushing_mask,d3
                beq.w   ReturnSozPushSwitchProgress
                move.w  x_pos(a0),d2
                lea     (Player_1).w,a1
                move.b  $30(a0),d0
                moveq   #p1_pushing_bit,d6
                bsr.s   ApplyPlayerPushToSozSwitch
                tst.w   d5
                bne.s   locret_419F8
                lea     (Player_2).w,a1
                move.b  $31(a0),d0
                moveq   #p2_pushing_bit,d6
                bsr.s   ApplyPlayerPushToSozSwitch
                tst.w   d5
                beq.s   ReturnSozPushSwitchProgress

locret_419F8:
                rts
; End of function UpdatePlayerPushOrReturnForSozSwitch

; =============== S U B R O U T I N E =======================================

ApplyPlayerPushToSozSwitch:
                btst    d6,d3
                beq.s   locret_41A6A
                cmp.w   x_pos(a1),d2
                bcc.s   loc_41A38
                btst    #5,d0
                beq.s   locret_41A6A
                btst    #0,status(a0)
                beq.s   locret_41A6A
                cmpi.w  #$80,$36(a0)
                beq.s   loc_41A34
                addq.w  #1,$36(a0)
                move.w  $36(a0),d0
                andi.w  #3,d0
                bne.s   loc_41A34
                subq.w  #1,x_pos(a1)
                moveq   #signextendB(sfx_PushBlock),d0
                jsr     (Play_SFX).l

loc_41A34:
                moveq   #1,d5
                rts
; ---------------------------------------------------------------------------

loc_41A38:
                btst    #5,d0
                beq.s   locret_41A6A
                btst    #0,status(a0)
                bne.s   locret_41A6A
                cmpi.w  #$80,$36(a0)
                beq.s   loc_41A34
                addq.w  #1,$36(a0)
                move.w  $36(a0),d0
                andi.w  #3,d0
                bne.s   loc_41A34
                addq.w  #1,x_pos(a1)
                moveq   #signextendB(sfx_PushBlock),d0
                jsr     (Play_SFX).l
                moveq   #1,d5

locret_41A6A:
                rts
; End of function ApplyPlayerPushToSozSwitch

; =============== S U B R O U T I N E =======================================

ReturnSozPushSwitchProgress:
                move.b  subtype(a0),d0
                andi.w  #$70,d0
                bne.s   loc_41A82
                subq.w  #1,$34(a0)
                bpl.s   locret_41AA6
                move.w  #9,$34(a0)

loc_41A82:
                tst.w   $36(a0)
                beq.s   locret_41AA6
                moveq   #signextendB(sfx_DoorClose),d0
                subq.w  #1,$36(a0)
                beq.s   loc_41A9E
                subq.b  #1,$3A(a0)
                bpl.s   loc_41AA4
                move.b  #3,$3A(a0)
                moveq   #signextendB(sfx_DoorMove),d0

loc_41A9E:
                jsr     (Play_SFX).l

loc_41AA4:
                moveq   #1,d4

locret_41AA6:
                rts
; End of function ReturnSozPushSwitchProgress

; =============== S U B R O U T I N E =======================================

PressSozSwitchWithRegisteredRock:
                move.w  (_unkF7C4).w,d0
                beq.w   locret_41B54
                movea.w d0,a2
                cmpi.l  #loc_405D6,(a2)
                beq.s   loc_41AC2
                move.w  #0,(_unkF7C4).w
                rts
; ---------------------------------------------------------------------------

loc_41AC2:
                move.w  x_pos(a2),d2
                sub.w   x_pos(a0),d2
                addi.w  #$1B,d2
                cmpi.w  #$37,d2
                bhs.s   loc_41B4E
                move.w  y_pos(a2),d3
                sub.w   y_pos(a0),d3
                addi.w  #$C,d3
                cmpi.w  #$18,d3
                bhs.s   loc_41B4E
                move.b  status(a0),d0
                cmpi.w  #$1C,d2
                blo.s   loc_41AF4
                eori.b  #1,d0

loc_41AF4:
                andi.b  #1,d0
                bne.s   loc_41B24
                cmpi.w  #$80,$36(a0)
                beq.s   loc_41B24
                moveq   #4,d1
                add.w   d4,d1
                move.w  $38(a0),d0
                cmp.w   x_pos(a2),d0
                bne.s   loc_41B12
                moveq   #1,d1

loc_41B12:
                add.w   d1,$36(a0)
                cmpi.w  #$80,$36(a0)
                blo.s   loc_41B24
                move.w  #$80,$36(a0)

loc_41B24:
                move.w  $36(a0),d0
                lsr.w   #2,d0
                btst    #0,status(a0)
                beq.s   loc_41B34
                neg.w   d0

loc_41B34:
                add.w   $44(a0),d0
                move.w  d0,x_pos(a0)
                subi.w  #$1C,d0
                cmpi.w  #$1C,d2
                blo.s   loc_41B4A
                addi.w  #$38,d0

loc_41B4A:
                move.w  d0,x_pos(a2)

loc_41B4E:
                move.w  x_pos(a2),$38(a0)

locret_41B54:
                rts
; End of function PressSozSwitchWithRegisteredRock

; ---------------------------------------------------------------------------
Map_SOZPushSwitch:
                include "src/objects/shared/zones/soz/mappings/push_switch.s"
