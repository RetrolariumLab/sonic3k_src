; Owner: objects/shared/tension_bridge/s3
; Responsibility: Tension bridge initialization, coordinated segments, player state and active control
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_TensionBridge:
                move.l  #loc_37DDE,(a0)
                move.l  #Map_TensionBridge,mappings(a0)
                move.w  #make_art_tile(ArtTile_HCZ2BlockPlat+$10,2,0),art_tile(a0)
                move.w  #$200,priority(a0)
                cmpi.b  #5,(Current_zone).w
                bne.s   loc_37CDC
                move.l  #loc_37E80,(a0)
                move.l  #Map_ICZTensionBridge,mappings(a0)
                move.w  #make_art_tile(ArtTile_ICZMisc1,2,0),art_tile(a0)
                tst.b   subtype(a0)
                bpl.s   loc_37CDC
                move.l  #loc_37F44,(a0)
                andi.b  #$7F,subtype(a0)

loc_37CDC:
                tst.b   subtype(a0)
                bpl.s   loc_37CEE
                move.l  #loc_37DB4,(a0)
                andi.b  #$7F,subtype(a0)

loc_37CEE:
                move.b  #4,render_flags(a0)
                move.b  #$80,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  y_pos(a0),d2
                move.w  d2,$3C(a0)
                move.w  x_pos(a0),d3
                lea     subtype(a0),a2
                moveq   #0,d1
                move.b  (a2),d1
                move.w  d1,d0
                lsr.w   #1,d0
                lsl.w   #4,d0
                sub.w   d0,d3
                swap    d1
                move.w  #8,d1
                bsr.s   CreateTensionBridgeSpriteBank
                move.w  $30(a1),d0
                subq.w  #8,d0
                move.w  d0,x_pos(a1)
                move.l  a1,$30(a0)
                swap    d1
                subq.w  #8,d1
                bls.s   loc_37D50
                move.w  d1,d4
                bsr.s   CreateTensionBridgeSpriteBank
                move.l  a1,$34(a0)
                move.w  d4,d0
                add.w   d0,d0
                add.w   d4,d0
                move.w  sub2_x_pos(a1,d0.w),d0
                subq.w  #8,d0
                move.w  d0,x_pos(a1)

loc_37D50:
                bra.w   loc_37DDE

; =============== S U B R O U T I N E =======================================

CreateTensionBridgeSpriteBank:
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_37DB2
                move.l  #loc_37E7A,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  mappings(a0),mappings(a1)
                move.w  art_tile(a0),art_tile(a1)
                move.b  render_flags(a0),render_flags(a1)
                move.w  priority(a0),priority(a1)
                bset    #6,render_flags(a1)
                move.b  #$40,width_pixels(a1)
                move.b  #8,height_pixels(a1)
                move.w  d1,mainspr_childsprites(a1)
                subq.b  #1,d1
                lea     sub2_x_pos(a1),a2

loc_37DA2:
                move.w  d3,(a2)+
                move.w  d2,(a2)+
                move.w  #0,(a2)+
                addi.w  #$10,d3
                dbf     d1,loc_37DA2

locret_37DB2:
                rts
; End of function CreateTensionBridgeSpriteBank

; ---------------------------------------------------------------------------

loc_37DB4:
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                lea     (a3,d0.w),a3
                tst.b   (a3)
                beq.s   loc_37DDE
                move.l  #loc_37F0A,(a0)
                move.b  #$E,$34(a0)
                move.l  #loc_37EE2,d4
                bra.w   loc_37FC6
; ---------------------------------------------------------------------------

loc_37DDE:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_37DF4
                tst.b   $3E(a0)
                beq.s   loc_37E20
                subq.b  #4,$3E(a0)
                bra.s   loc_37E1C
; ---------------------------------------------------------------------------

loc_37DF4:
                andi.b  #$10,d0
                beq.s   loc_37E10
                move.b  $3F(a0),d0
                sub.b   $3B(a0),d0
                beq.s   loc_37E10
                bcc.s   loc_37E0C
                addq.b  #1,$3F(a0)
                bra.s   loc_37E10
; ---------------------------------------------------------------------------

loc_37E0C:
                subq.b  #1,$3F(a0)

loc_37E10:
                cmpi.b  #$40,$3E(a0)
                beq.s   loc_37E1C
                addq.b  #4,$3E(a0)

loc_37E1C:
                bsr.w   BendTensionBridgeSegments

loc_37E20:
                moveq   #0,d1
                move.b  subtype(a0),d1
                lsl.w   #3,d1
                move.w  d1,d2
                addq.w  #8,d1
                add.w   d2,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                bsr.w   CollidePlayersWithTensionBridge

loc_37E38:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.s   loc_37E4C
                rts
; ---------------------------------------------------------------------------

loc_37E4C:
                movea.l $30(a0),a1
                jsr     (Delete_Referenced_Sprite).l
                cmpi.b  #8,subtype(a0)
                bls.s   loc_37E68
                movea.l $34(a0),a1
                jsr     (Delete_Referenced_Sprite).l

loc_37E68:
                move.w  respawn_addr(a0),d0
                beq.s   loc_37E74
                movea.w d0,a2
                bclr    #7,(a2)

loc_37E74:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_37E7A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_37E80:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_37E96
                tst.b   $3E(a0)
                beq.s   loc_37EC2
                subq.b  #4,$3E(a0)
                bra.s   loc_37EBE
; ---------------------------------------------------------------------------

loc_37E96:
                andi.b  #p2_standing,d0
                beq.s   loc_37EB2
                move.b  $3F(a0),d0
                sub.b   $3B(a0),d0
                beq.s   loc_37EB2
                bcc.s   loc_37EAE
                addq.b  #1,$3F(a0)
                bra.s   loc_37EB2
; ---------------------------------------------------------------------------

loc_37EAE:
                subq.b  #1,$3F(a0)

loc_37EB2:
                cmpi.b  #$40,$3E(a0)
                beq.s   loc_37EBE
                addq.b  #4,$3E(a0)

loc_37EBE:
                bsr.w   BendTensionBridgeSegments

loc_37EC2:
                moveq   #0,d1
                move.b  subtype(a0),d1
                lsl.w   #3,d1
                move.w  d1,d2
                addq.w  #8,d1
                add.w   d2,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                bsr.w   CollidePlayersWithTensionBridge
                bsr.w   TensionBridge_AnimateRiddenBoards
                bra.w   loc_37E38
; ---------------------------------------------------------------------------

loc_37EE2:
                tst.b   $34(a0)
                beq.s   loc_37EF2
                subq.b  #1,$34(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_37EF2:
                jsr     (MoveSprite).l
                tst.b   render_flags(a0)
                bpl.s   loc_37F04
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_37F04:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_37F0A:
                tst.b   $34(a0)
                beq.s   loc_37F16
                subq.b  #1,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_37F16:
                bclr    #p1_standing_bit,status(a0)
                beq.s   loc_37F2A
                bclr    #Status_OnObj,(Player_1+status).w
                bset    #Status_InAir,(Player_1+status).w

loc_37F2A:
                bclr    #p2_standing_bit,status(a0)
                beq.s   loc_37F3E
                bclr    #Status_OnObj,(Player_2+status).w
                bset    #Status_InAir,(Player_2+status).w

loc_37F3E:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_37F44:
                bsr.w   BendSlopedTensionBridgeSegments
                move.l  #loc_37F4E,(a0)

loc_37F4E:
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                bne.s   loc_37F64
                tst.b   $3E(a0)
                beq.s   loc_37FA6
                subq.b  #4,$3E(a0)
                bra.s   loc_37FA2
; ---------------------------------------------------------------------------

loc_37F64:
                moveq   #0,d1
                move.b  subtype(a0),d1
                lsl.w   #3,d1
                move.w  d1,d2
                addq.w  #8,d1
                add.w   d2,d2
                bsr.w   CacheTensionBridgeRiderSegments
                move.b  status(a0),d0
                andi.b  #p2_standing,d0
                beq.s   loc_37F96
                move.b  $3F(a0),d0
                sub.b   $3B(a0),d0
                beq.s   loc_37F96
                bcc.s   loc_37F92
                addq.b  #1,$3F(a0)
                bra.s   loc_37F96
; ---------------------------------------------------------------------------

loc_37F92:
                subq.b  #1,$3F(a0)

loc_37F96:
                cmpi.b  #$40,$3E(a0)
                beq.s   loc_37FA2
                addq.b  #4,$3E(a0)

loc_37FA2:
                bsr.w   BendSlopedTensionBridgeSegments

loc_37FA6:
                moveq   #0,d1
                move.b  subtype(a0),d1
                lsl.w   #3,d1
                move.w  d1,d2
                addq.w  #8,d1
                add.w   d2,d2
                moveq   #8,d3
                move.w  x_pos(a0),d4
                bsr.w   CollidePlayersWithSlopedTensionBridge
                bsr.w   TensionBridge_AnimateRiddenBoards
                bra.w   loc_37E38
; ---------------------------------------------------------------------------

loc_37FC6:
                movea.l $30(a0),a3
                bsr.s   CollapseTensionBridgeSpriteBank
                cmpi.b  #8,subtype(a0)
                bls.s   locret_37FDA
                movea.l $34(a0),a3
                bsr.s   CollapseTensionBridgeSpriteBank

locret_37FDA:
                rts
