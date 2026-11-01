; Owner: objects/zones/dez/sk
; Responsibility: Conveyor belt player contact and transport response
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_DEZConveyorBelt:
                move.b  subtype(a0),d0
                andi.w  #$7F,d0
                lsl.w   #3,d0
                move.w  d0,$32(a0)
                add.w   d0,d0
                move.w  d0,$34(a0)
                move.w  #2,$30(a0)
                btst    #0,status(a0)
                beq.s   loc_4783C
                neg.w   $30(a0)

loc_4783C:
                move.l  #loc_47842,(a0)

loc_47842:
                lea     (Player_1).w,a1
                bsr.s   CarryGroundedPlayerOnDezBelt
                lea     (Player_2).w,a1
                bsr.s   CarryGroundedPlayerOnDezBelt
                jmp     (Delete_Sprite_If_Not_In_Range).l

; =============== S U B R O U T I N E =======================================

CarryGroundedPlayerOnDezBelt:
                move.w  x_pos(a1),d0
                sub.w   x_pos(a0),d0
                add.w   $32(a0),d0
                cmp.w   $34(a0),d0
                bhs.s   locret_47890
                move.w  y_pos(a1),d1
                sub.w   y_pos(a0),d1
                addi.w  #$30,d1
                cmpi.w  #$60,d1
                bhs.s   locret_47890
                btst    #Status_InAir,status(a1)
                bne.s   locret_47890
                move.w  $30(a0),d0
                subi.w  #$30,d1
                bcs.s   loc_4788C
                neg.w   d0

loc_4788C:
                add.w   d0,x_pos(a1)

locret_47890:
                rts
; End of function CarryGroundedPlayerOnDezBelt
