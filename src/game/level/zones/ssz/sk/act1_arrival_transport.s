; Owner: game/level/zones/ssz/sk
; Responsibility: Sky Sanctuary arrival beam, player transport, timed character placement and Knuckles scene support
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_57C1E:
                jsr     (AllocateObjectAfterCurrent).l
                beq.s   loc_57C28
                rts
; ---------------------------------------------------------------------------

loc_57C28:
                move.l  #loc_57CD2,(a0)
                move.w  #$1000,y_pos(a0)
                move.w  #-$100,$38(a0)
                move.w  a1,$3C(a0)
                move.l  #Obj_TeleporterBeamExpand,(a1)
                move.b  #$44,render_flags(a1)
                move.b  #$80,height_pixels(a1)
                move.b  #$18,width_pixels(a1)
                move.w  #$80,priority(a1)
                move.w  #make_art_tile(ArtTile_SSZMisc+$88,3,1),art_tile(a1)
                move.l  #Map_SSZHPZTeleporter,mappings(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.w  #2,mainspr_childsprites(a1)
                move.w  y_pos(a0),$44(a1)
                subi.w  #$88,$44(a1)
                move.b  #$18,$46(a1)
                move.w  a0,$48(a1)
                tst.b   (Current_act).w
                bne.s   loc_57CAC
                jsr     (CreateNewSprite4).l
                bne.s   loc_57CAC
                move.l  #Obj_57E34,(a1)
                move.w  #$60,subtype(a1)

loc_57CAC:
                st      (Events_bg+$04).w
                lea     (Player_1).w,a1
                move.w  (Camera_Y_pos).w,d0
                addi.w  #$65,d0
                move.w  d0,y_pos(a1)
                move.b  #3,object_control(a1)
                moveq   #0,d0
                move.b  d0,anim(a1)
                move.b  d0,mapping_frame(a1)
                rts
; ---------------------------------------------------------------------------

loc_57CD2:
                jsr     (CycleSszHpzTeleporterPalettePair).l
                lea     (Player_1).w,a1
                move.w  x_pos(a0),x_pos(a1)
                tst.b   $2D(a0)
                bne.w   loc_57D50
                move.b  #1,object_control(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.w  #-1,y_vel(a1)
                move.w  y_pos(a1),d1
                move.w  d1,$3E(a0)
                tst.b   (Current_act).w
                beq.s   loc_57D18
                bset    #7,art_tile(a1)
                bra.s   loc_57D3C
; ---------------------------------------------------------------------------

loc_57D18:
                tst.w   (Player_mode).w
                bne.s   loc_57D3C
                jsr     (CreateNewSprite4).l
                bne.s   loc_57D3C
                move.l  #Obj_57DCC,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  d1,$3E(a1)
                move.w  #$C,subtype(a1)

loc_57D3C:
                clr.b   (Scroll_lock).w
                movea.w $3C(a0),a1
                st      5(a1)
                move.l  #Obj_57D64,(a0)
                rts
; ---------------------------------------------------------------------------

loc_57D50:
                subi.w  #8,y_pos(a1)
                subq.b  #1,$2D(a0)
                beq.s   locret_57D62
                subi.w  #8,(Camera_Y_pos).w

locret_57D62:
                rts
; ---------------------------------------------------------------------------

Obj_57D64:
                jsr     (CycleSszHpzTeleporterPalettePair).l
                lea     (Player_1).w,a1
                move.l  #$20000,d0
                move.l  #$800,d1
                jsr     (Gradual_SwingOffset).l
                add.w   $3E(a0),d0
                move.w  d0,y_pos(a1)
                tst.l   $2E(a0)
                bmi.s   locret_57DA0
                clr.b   object_control(a1)
                clr.b   anim(a1)
                clr.b   (Events_bg+$04).w
                move.l  #loc_57DA2,(a0)

locret_57DA0:
                rts
; ---------------------------------------------------------------------------

loc_57DA2:
                move.w  (Camera_Y_pos).w,d0
                cmp.w   (Camera_max_Y_pos).w,d0
                bne.s   loc_57DC6
                cmp.w   (Camera_min_Y_pos).w,d0
                beq.s   loc_57DB6
                move.w  d0,(Camera_min_Y_pos).w

loc_57DB6:
                move.w  $3A(a0),d0
                or.b    $38(a0),d0
                bne.s   loc_57DC6
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_57DC6:
                jmp     (CycleSszHpzTeleporterPalettePair).l
; ---------------------------------------------------------------------------

Obj_57DCC:
                lea     (Player_2).w,a1
                tst.w   subtype(a0)
                beq.s   loc_57DFA
                subq.w  #1,subtype(a0)
                bne.s   locret_57E32
                move.w  x_pos(a0),x_pos(a1)
                move.b  #1,$2E(a1)
                move.b  #2,anim(a1)
                bset    #Status_Roll,status(a1)
                move.w  #-1,y_vel(a1)

loc_57DFA:
                move.l  #$20000,d0
                move.l  #$800,d1
                jsr     (Gradual_SwingOffset).l
                add.w   $3E(a0),d0
                move.w  d0,y_pos(a1)
                tst.l   $2E(a0)
                bmi.s   locret_57E32
                clr.b   object_control(a1)
                clr.b   anim(a1)
                clr.w   (Tails_CPU_flight_timer).w
                move.w  #6,(Tails_CPU_routine).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

locret_57E32:
                rts
; ---------------------------------------------------------------------------

Obj_57E34:
                tst.w   subtype(a0)
                beq.s   loc_57E64
                subq.w  #1,subtype(a0)
                bne.s   locret_57E94
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   locret_57E94
                move.l  #Obj_CutsceneKnuckles,(a1)
                move.w  #$100,x_pos(a1)
                move.b  #$2C,subtype(a1)
                move.w  a1,$20(a0)
                move.w  #$C4E,$3E(a0)

loc_57E64:
                movea.w $20(a0),a1
                move.l  #$20000,d0
                move.l  #$800,d1
                jsr     (Gradual_SwingOffset).l
                add.w   $3E(a0),d0
                move.w  d0,y_pos(a1)
                tst.l   $2E(a0)
                bmi.s   locret_57E94
                bset    #0,(_unkFAB8).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

locret_57E94:
                rts
