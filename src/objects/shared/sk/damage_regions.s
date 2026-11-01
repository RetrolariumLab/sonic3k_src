; Owner: objects/shared/sk
; Responsibility: Invisible horizontal and vertical harmful regions, product-specific shock or lava reactions and shared player contact geometry
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_InvisibleShockBlock:
                bset    #5,shield_reaction(a0)
                bra.s   Obj_InvisibleHurtBlockHorizontal
; ---------------------------------------------------------------------------

Obj_InvisibleLavaBlock:
                bset    #4,shield_reaction(a0)

Obj_InvisibleHurtBlockHorizontal:
                move.l  #Map_InvisibleBlock,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,0,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                bset    #7,status(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F0,d0
                addi.w  #$10,d0
                lsr.w   #1,d0
                move.b  d0,width_pixels(a0)
                andi.w  #$F,d1
                addq.w  #1,d1
                lsl.w   #3,d1
                move.b  d1,height_pixels(a0)
                btst    #0,status(a0)
                beq.s   loc_1F448
                move.l  #loc_1F4C4,(a0)
                rts
; ---------------------------------------------------------------------------

loc_1F448:
                btst    #1,status(a0)
                beq.s   loc_1F458
                move.l  #loc_1F528,(a0)
                rts
; ---------------------------------------------------------------------------

loc_1F458:
                move.l  #loc_1F45E,(a0)

loc_1F45E:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                move.b  status(a0),d6
                andi.b  #standing_mask,d6
                beq.s   loc_1F4A2
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   loc_1F494
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerUnlessInvisibleHazardImmunityMatches

loc_1F494:
                andi.b  #p2_standing,d6
                beq.s   loc_1F4A2
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerUnlessInvisibleHazardImmunityMatches

loc_1F4A2:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_1EBAA
                tst.w   (Debug_placement_mode).w
                beq.s   locret_1F4C2
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_1F4C2:
                rts
; ---------------------------------------------------------------------------

loc_1F4C4:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                swap    d6
                andi.w  #3,d6
                beq.s   loc_1F506
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   loc_1F4F8
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerUnlessInvisibleHazardImmunityMatches

loc_1F4F8:
                andi.b  #2,d6
                beq.s   loc_1F506
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerUnlessInvisibleHazardImmunityMatches

loc_1F506:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_1EBAA
                tst.w   (Debug_placement_mode).w
                beq.s   locret_1F526
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_1F526:
                rts
; ---------------------------------------------------------------------------

loc_1F528:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                swap    d6
                andi.w  #$C,d6
                beq.s   loc_1F56A
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   loc_1F55C
                lea     (Player_1).w,a1
                bsr.w   HurtPlayerUnlessInvisibleHazardImmunityMatches

loc_1F55C:
                andi.b  #8,d6
                beq.s   loc_1F56A
                lea     (Player_2).w,a1
                bsr.w   HurtPlayerUnlessInvisibleHazardImmunityMatches

loc_1F56A:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_1EBAA
                tst.w   (Debug_placement_mode).w
                beq.s   locret_1F58A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_1F58A:
                rts

; =============== S U B R O U T I N E =======================================

HurtPlayerUnlessInvisibleHazardImmunityMatches:
                move.b  shield_reaction(a0),d0
                andi.b  #$73,d0
                and.b   shield_reaction(a1),d0
                bne.s   locret_1F59E
                bsr.w   HurtPlayerFromSolidHazard

locret_1F59E:
                rts
; End of function HurtPlayerUnlessInvisibleHazardImmunityMatches

; ---------------------------------------------------------------------------

Obj_InvisibleHurtBlockVertical:
                move.l  #Map_InvisibleBlock,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ring,0,1),art_tile(a0)
                ori.b   #4,render_flags(a0)
                move.w  #$200,priority(a0)
                bset    #7,status(a0)
                move.b  subtype(a0),d0
                move.b  d0,d1
                andi.w  #$F0,d0
                addi.w  #$10,d0
                lsr.w   #1,d0
                move.b  d0,width_pixels(a0)
                andi.w  #$F,d1
                addq.w  #1,d1
                lsl.w   #3,d1
                move.b  d1,height_pixels(a0)
                btst    #0,status(a0)
                beq.s   loc_1F5F0
                move.l  #loc_1F66C,(a0)
                rts
; ---------------------------------------------------------------------------

loc_1F5F0:
                btst    #1,status(a0)
                beq.s   loc_1F600
                move.l  #loc_1F6D0,(a0)
                rts
; ---------------------------------------------------------------------------

loc_1F600:
                move.l  #loc_1F606,(a0)

loc_1F606:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                move.b  status(a0),d6
                andi.b  #standing_mask,d6
                beq.s   loc_1F64A
                move.b  d6,d0
                andi.b  #p1_standing,d0
                beq.s   loc_1F63C
                lea     (Player_1).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

loc_1F63C:
                andi.b  #p2_standing,d6
                beq.s   loc_1F64A
                lea     (Player_2).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

loc_1F64A:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_1EBAA
                tst.w   (Debug_placement_mode).w
                beq.s   locret_1F66A
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_1F66A:
                rts
; ---------------------------------------------------------------------------

loc_1F66C:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                swap    d6
                andi.w  #3,d6
                beq.s   loc_1F6AE
                move.b  d6,d0
                andi.b  #1,d0
                beq.s   loc_1F6A0
                lea     (Player_1).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

loc_1F6A0:
                andi.b  #2,d6
                beq.s   loc_1F6AE
                lea     (Player_2).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

loc_1F6AE:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_1EBAA
                tst.w   (Debug_placement_mode).w
                beq.s   locret_1F6CE
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_1F6CE:
                rts
; ---------------------------------------------------------------------------

loc_1F6D0:
                moveq   #0,d1
                move.b  width_pixels(a0),d1
                addi.w  #$B,d1
                moveq   #0,d2
                move.b  height_pixels(a0),d2
                move.w  d2,d3
                addq.w  #1,d3
                move.w  x_pos(a0),d4
                bsr.w   SolidObjectFull2
                swap    d6
                andi.w  #$C,d6
                beq.s   loc_1F712
                move.b  d6,d0
                andi.b  #4,d0
                beq.s   loc_1F704
                lea     (Player_1).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

loc_1F704:
                andi.b  #8,d6
                beq.s   loc_1F712
                lea     (Player_2).w,a1
                bsr.w   KillPlayerFromInvisibleHazard

loc_1F712:
                move.w  x_pos(a0),d0
                andi.w  #$FF80,d0
                sub.w   (Camera_X_pos_coarse_back).w,d0
                cmpi.w  #$280,d0
                bhi.w   loc_1EBAA
                tst.w   (Debug_placement_mode).w
                beq.s   locret_1F732
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

locret_1F732:
                rts

; =============== S U B R O U T I N E =======================================

KillPlayerFromInvisibleHazard:
                move.w  d6,-(sp)
                move.l  a0,-(sp)
                movea.l a1,a0
                jsr     (Kill_Character).l
                movea.l (sp)+,a0
                move.w  (sp)+,d6
                rts
; End of function KillPlayerFromInvisibleHazard
