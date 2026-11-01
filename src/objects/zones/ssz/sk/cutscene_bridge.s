; Owner: objects/zones/ssz/sk
; Responsibility: Cutscene bridge state, coordinated movement and player interaction
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_SSZCutsceneBridge:
                move.b  #$44,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #$60,width_pixels(a0)
                move.w  #$180,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$20,2,1),art_tile(a0)
                move.l  #Map_SSZCollapsingBridge,mappings(a0)
                move.w  x_pos(a0),$12(a0)
                move.w  #3,mainspr_childsprites(a0)
                bset    #7,status(a0)
                move.w  #$C0,$2E(a0)
                lea     loc_44FA2(pc),a1
                tst.b   (Last_star_post_hit).w
                beq.s   loc_44F9E
                lea     loc_4501A(pc),a1

loc_44F9E:
                move.l  a1,(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

loc_44FA2:
                move.w  $2E(a0),d1
                tst.w   (Events_bg+$08).w
                beq.s   loc_45006
                cmpi.w  #$68,d1
                bne.s   loc_44FBA
                moveq   #signextendB(sfx_DoorOpen),d0
                jsr     (Play_SFX).l

loc_44FBA:
                subq.w  #2,d1
                move.w  d1,$2E(a0)
                bne.s   loc_45006
                clr.b   (Events_bg+$05).w
                clr.w   (Camera_min_X_pos).w
                move.w  #$19A0,(Camera_max_X_pos).w
                move.w  #-$100,(Camera_min_Y_pos).w
                move.w  #$1000,d0
                move.w  d0,(Camera_max_Y_pos).w
                move.w  d0,(Camera_target_max_Y_pos).w
                move.w  #$140,(Saved_X_pos).w
                move.w  #$C6C,(Saved_Y_pos).w
                move.b  #1,(Last_star_post_hit).w
                jsr     (Save_Level_Data).l
                clr.l   (Saved_timer).w
                moveq   #0,d1
                move.l  #loc_4501A,(a0)

loc_45006:
                add.w   $12(a0),d1
                move.w  x_pos(a0),d4
                move.w  d1,x_pos(a0)
                bsr.s   UpdateSszCutsceneBridgeSolidAndPieces
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_4501A:
                move.w  x_pos(a0),d4
                bsr.s   UpdateSszCutsceneBridgeSolidAndPieces
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

UpdateSszCutsceneBridgeSolidAndPieces:
                moveq   #$60,d1
                moveq   #$10,d2
                moveq   #9,d3
                jsr     (SolidObjectTop).l
                lea     sub2_x_pos(a0),a1
                move.w  x_pos(a0),d0
                subi.w  #$40,d0
                moveq   #2,d1

loc_45040:
                move.w  d0,(a1)+
                move.w  y_pos(a0),(a1)+
                addq.w  #2,a1
                addi.w  #$40,d0
                dbf     d1,loc_45040
                rts
; End of function UpdateSszCutsceneBridgeSolidAndPieces

; ---------------------------------------------------------------------------

loc_45052:
                move.l  #loc_4507E,(a0)
                bset    #7,render_flags(a0)
                move.b  #$10,height_pixels(a0)
                move.b  #8,width_pixels(a0)
                move.w  #$200,priority(a0)
                move.w  #make_art_tile(ArtTile_SSZMisc+$20,2,1),art_tile(a0)
                move.l  #Map_SSZCollapsingBridge,mappings(a0)

loc_4507E:
                tst.b   render_flags(a0)
                bmi.s   loc_4508A
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_4508A:
                move.w  $2E(a0),d0
                beq.s   loc_45098
                subq.w  #1,d0
                move.w  d0,$2E(a0)
                bra.s   loc_4509E
; ---------------------------------------------------------------------------

loc_45098:
                jsr     (MoveSprite).l

loc_4509E:
                jmp     (Draw_Sprite).l
