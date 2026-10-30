; Owner: objects/zones/dez/sk
; Responsibility: Straight and curved energy bridge activation, segment state and player collision
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_DEZEnergyBridge:
                move.l  #Map_DEZEnergyBridge,mappings(a0)
                move.b  #$40,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                bset    #7,status(a0)
                bsr.s   sub_47DDE
                sub.w   d1,d0
                bcc.s   loc_47E5C
                neg.w   d0
                move.w  d0,$34(a0)
                move.l  #loc_47E8C,(a0)
                bra.s   loc_47E8C
; ---------------------------------------------------------------------------

loc_47E5C:
                move.l  #loc_47E62,(a0)

loc_47E62:
                move.w  (Level_frame_counter).w,d0
                add.w   $30(a0),d0
                and.w   $32(a0),d0
                beq.s   loc_47E76
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_47E76:
                move.b  subtype(a0),d0
                andi.b  #3,d0
                addq.b  #2,d0
                lsl.w   #5,d0
                move.w  d0,$34(a0)
                move.l  #loc_47E8C,(a0)

loc_47E8C:
                subq.w  #1,$34(a0)
                bne.s   loc_47EAA
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   sub_47EE8
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.s   sub_47EE8
                move.l  #loc_47E62,(a0)
                bra.s   loc_47EBE
; ---------------------------------------------------------------------------

loc_47EAA:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                move.w  #9,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l

loc_47EBE:
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #3,d0
                move.b  d0,mapping_frame(a0)
                tst.b   render_flags(a0)
                bpl.s   loc_47EE2
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   loc_47EE2
                moveq   #signextendB(sfx_EnergyZap),d0
                jsr     (Play_SFX).l

loc_47EE2:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_47EE8:
                bclr    d6,status(a0)
                beq.s   locret_47EFA
                bclr    #Status_OnObj,status(a1)
                bset    #Status_InAir,status(a1)

locret_47EFA:
                rts
; End of function sub_47EE8

; ---------------------------------------------------------------------------

Obj_DEZEnergyBridgeCurved:
                move.l  #Map_DEZEnergyBridgeCurved,mappings(a0)
                move.b  #$50,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                bsr.w   sub_47DDE
                sub.w   d1,d0
                bcc.s   loc_47F26
                neg.w   d0
                move.w  d0,$34(a0)
                move.l  #loc_47F56,(a0)
                bra.s   loc_47F56
; ---------------------------------------------------------------------------

loc_47F26:
                move.l  #loc_47F2C,(a0)

loc_47F2C:
                move.w  (Level_frame_counter).w,d0
                add.w   $30(a0),d0
                and.w   $32(a0),d0
                beq.s   loc_47F40
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_47F40:
                move.b  subtype(a0),d0
                andi.b  #3,d0
                addq.b  #2,d0
                lsl.w   #5,d0
                move.w  d0,$34(a0)
                move.l  #loc_47F56,(a0)

loc_47F56:
                subq.w  #1,$34(a0)
                bne.s   loc_47F62
                move.l  #loc_47F2C,(a0)

loc_47F62:
                lea     (Player_1).w,a1
                moveq   #p1_standing_bit,d6
                bsr.s   sub_47F9C
                lea     (Player_2).w,a1
                moveq   #p2_standing_bit,d6
                bsr.s   sub_47F9C
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #3,d0
                move.b  d0,mapping_frame(a0)
                tst.b   render_flags(a0)
                bpl.s   loc_47F96
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #7,d0
                bne.s   loc_47F96
                moveq   #signextendB(sfx_EnergyZap),d0
                jsr     (Play_SFX).l

loc_47F96:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_47F9C:
                tst.w   $34(a0)
                beq.s   loc_47FD8
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                addi.w  #$50,d0
                cmpi.w  #$A0,d0
                bhs.s   loc_47FD8
                move.w  y_pos(a1),d0
                sub.w   y_pos(a0),d0
                addi.w  #$30,d0
                cmpi.w  #$60,d0
                bhs.s   loc_47FD8
                bset    d6,status(a0)
                move.b  #$E,top_solid_bit(a1)
                move.b  #$F,lrb_solid_bit(a1)
                rts
; ---------------------------------------------------------------------------

loc_47FD8:
                bclr    d6,status(a0)
                beq.s   locret_47FF6
                tst.w   $34(a0)
                bne.s   loc_47FEA
                bset    #Status_InAir,status(a1)

loc_47FEA:
                move.b  #$C,top_solid_bit(a1)
                move.b  #$D,lrb_solid_bit(a1)

locret_47FF6:
                rts
; End of function sub_47F9C

; ---------------------------------------------------------------------------
Map_DEZEnergyBridge:
                include "src/objects/shared/zones/dez/map_energy_bridge.s"
Map_DEZEnergyBridgeCurved:
                include "src/objects/shared/zones/dez/map_energy_bridge_curved.s"
