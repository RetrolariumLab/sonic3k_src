; Owner: objects/ending/sk
; Responsibility: Ending plane and Knuckles pose actors, motion and private state dispatch tables
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_5DFEE:
                move.l  #Map_SonicPlaneEnding,mappings(a0)
                move.w  #make_art_tile(ArtTile_Ending_PlaneExtra,0,0),art_tile(a0)
                move.w  #$380,priority(a0)
                move.b  #1,mapping_frame(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.l  #loc_5E08A,(a0)
                bset    #0,render_flags(a0)
                move.w  #$220,x_pos(a0)
                move.w  #$B0,y_pos(a0)
                move.w  #-$100,x_vel(a0)
                bsr.w   EndingInitializeGentleVerticalSwing
                moveq   #signextendB(mus_CreditsK),d0
                jsr     (Play_Music).l
                lea     ChildObjDat_601CA(pc),a2
                jsr     (CreateChild6_Simple).l
                lea     ChildObjDat_601D0(pc),a2
                jsr     (CreateChild1_Normal).l
                bclr    #0,(_unkFAB8).w
                jsr     (AllocateObject).l
                bne.s   loc_5E07A
                move.l  #Obj_5DE60,(a1)
                move.w  a0,parent3(a1)
                move.w  #$190,x_pos(a1)
                move.w  #$DC,y_pos(a1)
                st      subtype(a1)

loc_5E07A:
                lea     (ArtKosM_SonicPlaneEnding).l,a1
                move.w  #tiles_to_bytes(ArtTile_Ending_PlaneExtra),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

loc_5E08A:
                cmpi.w  #$EEE,(Normal_palette+$2).w
                bne.s   loc_5E0AC
                bset    #7,$38(a0)
                bne.s   loc_5E0AC
                st      (_unkFAC1).w
                jsr     (AllocateObject).l
                bne.s   loc_5E0AC
                move.l  #loc_5DF58,(a1)

loc_5E0AC:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                cmpi.w  #$60,x_pos(a0)
                bhs.s   loc_5E0D0
                move.l  #loc_5E0D6,(a0)
                bset    #4,$38(a0)
                clr.b   5(a0)

loc_5E0D0:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5E0D6:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5E0F0(pc,d0.w),d1
                jsr     off_5E0F0(pc,d1.w)
                jsr     (SKScene_LoadKnuxArtToSceneTiles).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_5E0F0:
                dc.w    loc_5E0F8-off_5E0F0
                dc.w    loc_5E142-off_5E0F0
                dc.w    loc_5E170-off_5E0F0
                dc.w    locret_5E188-off_5E0F0
; ---------------------------------------------------------------------------

loc_5E0F8:
                move.b  #2,routine(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.w  #make_art_tile(ArtTile_CutsceneKnux,0,1),art_tile(a0)
                move.w  #$180,priority(a0)
                move.b  #7,mapping_frame(a0)
                move.w  #$1E0,x_pos(a0)
                move.w  #$E0,y_pos(a0)
                move.w  #-$200,x_vel(a0)
                clr.w   y_vel(a0)
                lea     (Pal_ContinueScreen+$60).l,a1
                lea     (Normal_palette).w,a2
                moveq   #bytesToLcnt($20),d6

loc_5E13A:
                move.l  (a1)+,(a2)+
                dbf     d6,loc_5E13A
                rts
; ---------------------------------------------------------------------------

loc_5E142:
                lea     (SKSceneAnim_KnuxTravelLoopDelay4).l,a1
                jsr     (Animate_RawNoSSTCheckResult).l
                jsr     (MoveSprite2).l
                cmpi.w  #$120,x_pos(a0)
                bhs.s   locret_5E16E
                move.b  #4,routine(a0)
                move.b  #$55,mapping_frame(a0)
                move.w  #(2*60)-1,$2E(a0)

locret_5E16E:
                rts
; ---------------------------------------------------------------------------

loc_5E170:
                subq.w  #1,$2E(a0)
                bpl.w   locret_5FF1A
                move.b  #6,routine(a0)
                st      (Events_fg_4).w
                clr.b   (_unkFAC1).w
                rts
; ---------------------------------------------------------------------------

locret_5E188:
                rts
