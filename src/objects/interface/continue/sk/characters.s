; Owner: objects/interface/continue/sk
; Responsibility: Continue-scene Sonic, Tails, Knuckles, EggRobo and attached icon actor state machines
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Continue_SonicWTails:
                move.l  #Map_ContinueSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Misc,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.w  #$118,x_pos(a0)
                move.w  #$120,y_pos(a0)
                move.l  #loc_5C55C,(a0)

loc_5C55C:
                movea.w (_unkFAA4).w,a1
                btst    #3,$38(a1)
                bne.s   loc_5C582
                move.b  #0,mapping_frame(a0)
                btst    #4,(V_int_run_count+3).w
                beq.s   loc_5C57C
                move.b  #1,mapping_frame(a0)

loc_5C57C:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5C582:
                move.l  #loc_5C588,(a0)

loc_5C588:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5C5A2(pc,d0.w),d1
                jsr     off_5C5A2(pc,d1.w)
                jsr     (Sonic_Load_PLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_5C5A2:
                dc.w    loc_5C5AC-off_5C5A2
                dc.w    loc_5C5D0-off_5C5A2
                dc.w    loc_5C62C-off_5C5A2
                dc.w    loc_5C642-off_5C5A2
                dc.w    locret_5C65E-off_5C5A2
; ---------------------------------------------------------------------------

loc_5C5AC:
                addq.b  #2,routine(a0)
                move.l  #Map_Sonic,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                clr.b   (Player_prev_frame).w
                move.b  #$5A,mapping_frame(a0)
                move.b  #6,anim_frame_timer(a0)
                rts
; ---------------------------------------------------------------------------

loc_5C5D0:
                subq.b  #1,anim_frame_timer(a0)
                bpl.s   locret_5C606
                move.b  #6,anim_frame_timer(a0)
                moveq   #0,d0
                move.b  anim_frame(a0),d0
                addq.w  #2,d0
                cmpi.b  #$A,d0
                bhs.s   loc_5C608
                move.b  d0,anim_frame(a0)
                lea     RawAni_5C622(pc,d0.w),a2
                move.b  (a2)+,mapping_frame(a0)
                bclr    #0,render_flags(a0)
                tst.b   (a2)
                beq.s   locret_5C606
                bset    #0,render_flags(a0)

locret_5C606:
                rts
; ---------------------------------------------------------------------------

loc_5C608:
                move.b  #4,routine(a0)
                move.w  #1,anim(a0)
                move.w  #$600,ground_vel(a0)
                move.w  #$F,$2E(a0)
                rts
; ---------------------------------------------------------------------------
RawAni_5C622:
                dc.b    $5A,   1
                dc.b    $59,   1
                dc.b    $55,   0
                dc.b    $56,   0
                dc.b    $57,   0
                even
; ---------------------------------------------------------------------------

loc_5C62C:
                jsr     (Animate_Sonic).l
                subq.w  #1,$2E(a0)
                bmi.s   loc_5C63A
                rts
; ---------------------------------------------------------------------------

loc_5C63A:
                move.b  #6,routine(a0)
                rts
; ---------------------------------------------------------------------------

loc_5C642:
                jsr     (Animate_Sonic).l
                addq.w  #6,x_pos(a0)
                cmpi.w  #$1E0,x_pos(a0)
                bhs.s   loc_5C656
                rts
; ---------------------------------------------------------------------------

loc_5C656:
                move.b  #8,routine(a0)
                rts
; ---------------------------------------------------------------------------

locret_5C65E:
                rts
; ---------------------------------------------------------------------------

Obj_Continue_SonicAlone:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Continue_SonicAlone_Index(pc,d0.w),d1
                jsr     Continue_SonicAlone_Index(pc,d1.w)
                jsr     (Sonic_Load_PLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
Continue_SonicAlone_Index:
                dc.w    loc_5C684-Continue_SonicAlone_Index
                dc.w    loc_5C6B6-Continue_SonicAlone_Index
                dc.w    loc_5C6E0-Continue_SonicAlone_Index
                dc.w    loc_5C6F4-Continue_SonicAlone_Index
                dc.w    locret_5C716-Continue_SonicAlone_Index
; ---------------------------------------------------------------------------

loc_5C684:
                move.b  #2,routine(a0)
                move.l  #Map_Sonic,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_1,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #$C,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$120,y_pos(a0)

loc_5C6B6:
                movea.w (_unkFAA4).w,a1
                btst    #2,$38(a1)
                bne.s   loc_5C6CC
                lea     byte_5CBC5(pc),a1
                jmp     (Animate_RawNoSSTCheckResult).l
; ---------------------------------------------------------------------------

loc_5C6CC:
                move.b  #4,routine(a0)
                move.b  #$BA,mapping_frame(a0)
                move.w  #7,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_5C6E0:
                subq.w  #1,$2E(a0)
                bpl.s   locret_5C6F2
                move.b  #6,routine(a0)
                move.b  #$21,mapping_frame(a0)

locret_5C6F2:
                rts
; ---------------------------------------------------------------------------

loc_5C6F4:
                addq.w  #6,x_pos(a0)
                cmpi.w  #$1E0,x_pos(a0)
                bhs.s   loc_5C70A
                lea     byte_5CBB4(pc),a1
                jmp     (Animate_RawNoSSTCheckResult).l
; ---------------------------------------------------------------------------

loc_5C70A:
                move.b  #8,routine(a0)
                move.b  #1,(_unkFAA9).w

locret_5C716:
                rts
; ---------------------------------------------------------------------------

Obj_Continue_TailsWSonic:
                move.l  #Map_ContinueSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Misc,0,0),art_tile(a0)
                move.w  #$200,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$14,height_pixels(a0)
                move.w  #$12C,x_pos(a0)
                move.w  #$120,y_pos(a0)
                move.l  #loc_5C74A,(a0)

loc_5C74A:
                movea.w (_unkFAA4).w,a1
                btst    #3,$38(a1)
                bne.s   loc_5C770
                move.b  #5,mapping_frame(a0)
                btst    #5,(V_int_run_count+3).w
                beq.s   loc_5C76A
                move.b  #6,mapping_frame(a0)

loc_5C76A:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5C770:
                move.l  #loc_5C790,(a0)
                addq.w  #4,y_pos(a0)
                lea     (Tails_tails).w,a1
                move.l  #Obj_Tails_Tail,(a1)
                move.w  a0,$30(a1)
                move.l  #loc_5C82C,(Dust).w

loc_5C790:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5C7AA(pc,d0.w),d1
                jsr     off_5C7AA(pc,d1.w)
                jsr     (Tails_Load_PLC).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_5C7AA:
                dc.w    loc_5C7B2-off_5C7AA
                dc.w    loc_5C7E2-off_5C7AA
                dc.w    loc_5C802-off_5C7AA
                dc.w    loc_5C814-off_5C7AA
; ---------------------------------------------------------------------------

loc_5C7B2:
                addq.b  #2,routine(a0)
                move.l  #Map_Tails,mappings(a0)
                move.w  #make_art_tile(ArtTile_Player_2,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                clr.b   (Player_prev_frame_P2).w
                move.w  #5<<8,anim(a0)                  ; and prev_anim
                move.w  #$AD<<8,mapping_frame(a0)       ; and anim_frame
                move.w  #40-1,$2E(a0)
                rts
; ---------------------------------------------------------------------------

loc_5C7E2:
                subq.w  #1,$2E(a0)
                bpl.w   locret_5C4D4
                move.b  #4,routine(a0)
                move.b  #0,anim(a0)
                move.w  #$600,ground_vel(a0)
                move.w  #20-1,$2E(a0)

loc_5C802:
                subq.w  #1,$2E(a0)
                bpl.s   loc_5C80E
                move.b  #6,routine(a0)

loc_5C80E:
                jmp     (Animate_Tails).l
; ---------------------------------------------------------------------------

loc_5C814:
                addq.w  #6,x_pos(a0)
                cmpi.w  #$1E0,x_pos(a0)
                blo.s   loc_5C826
                move.b  #1,(_unkFAA9).w

loc_5C826:
                jmp     (Animate_Tails).l
; ---------------------------------------------------------------------------

loc_5C82C:
                bclr    #2,(Tails_tails+render_flags).w
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

loc_5C838:
                cmpi.w  #3,(Player_mode).w
                beq.s   loc_5C854
                lea     loc_5C8C8(pc),a1
                move.l  a1,(a0)
                move.w  #$40,x_pos(a0)
                move.w  #$120,y_pos(a0)
                jmp     (a1)
; ---------------------------------------------------------------------------

loc_5C854:
                lea     loc_5C85A(pc),a1
                move.l  a1,(a0)

loc_5C85A:
                move.l  #Map_ContinueSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Misc,3,0),art_tile(a0)
                move.w  #$200,priority(a0)
                move.b  #$10,width_pixels(a0)
                move.b  #$18,height_pixels(a0)
                move.w  #$11C,x_pos(a0)
                move.w  #$120,y_pos(a0)
                move.l  #loc_5C88C,(a0)

loc_5C88C:
                move.w  #$2F,$2E(a0)
                movea.w (_unkFAA4).w,a1
                btst    #3,$38(a1)
                beq.s   loc_5C8AC
                move.l  #loc_5C8AC,(a0)
                move.l  #loc_5C972,(Dynamic_object_RAM+(object_size*13)).w

loc_5C8AC:
                subq.w  #1,$2E(a0)
                bpl.s   loc_5C8B8
                move.l  #loc_5C8C8,(a0)

loc_5C8B8:
                lea     byte_5CBC0(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5C8C8:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  off_5C8E2(pc,d0.w),d1
                jsr     off_5C8E2(pc,d1.w)
                jsr     (Knuckles_Load_PLC_661E0).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
off_5C8E2:
                dc.w    loc_5C8EA-off_5C8E2
                dc.w    loc_5C91E-off_5C8E2
                dc.w    loc_5C932-off_5C8E2
                dc.w    locret_5C970-off_5C8E2
; ---------------------------------------------------------------------------

loc_5C8EA:
                addq.b  #2,routine(a0)
                move.l  #Map_Knuckles,mappings(a0)
                move.w  #make_art_tile(ArtTile_CutsceneKnux,3,0),art_tile(a0)
                move.w  #$80,priority(a0)
                move.b  #7,mapping_frame(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$30,height_pixels(a0)
                clr.b   anim_frame_timer(a0)
                clr.b   anim_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_5C91E:
                movea.w (_unkFAA4).w,a1
                btst    #3,$38(a1)
                bne.s   loc_5C92C
                rts
; ---------------------------------------------------------------------------

loc_5C92C:
                move.b  #4,routine(a0)

loc_5C932:
                move.w  x_pos(a0),d0
                addq.w  #6,d0
                move.w  d0,x_pos(a0)
                movea.w (_unkFAA4).w,a1
                cmpi.w  #$120,d0
                blo.s   loc_5C94C
                bset    #2,$38(a1)

loc_5C94C:
                cmpi.w  #$1E0,d0
                bhs.s   loc_5C95C
                lea     byte_5CBB4(pc),a1
                jmp     (Animate_RawNoSSTCheckResult).l
; ---------------------------------------------------------------------------

loc_5C95C:
                move.b  #6,routine(a0)
                cmpi.w  #3,(Player_mode).w
                bne.s   locret_5C970
                move.b  #1,(_unkFAA9).w

locret_5C970:
                rts
; ---------------------------------------------------------------------------

loc_5C972:
                lea     (EggRoboSK_Hover_FullAttributes).l,a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #2,render_flags(a0)
                bset    #0,render_flags(a0)
                move.l  #Obj_Continue_EggRobo_5C9C4,(a0)
                move.w  #$60,x_pos(a0)
                move.w  #$F0,y_pos(a0)
                move.w  #$600,x_vel(a0)
                jsr     (Swing_Setup1).l
                lea     (SKEggRobo_HoverAttachmentChildren).l,a2
                jsr     (CreateChild1_Normal).l
                lea     (ArtKosM_EggRoboBadnik).l,a1
                move.w  #tiles_to_bytes(ArtTile_EggRoboBadnik),d2
                jmp     (Queue_Kos_Module).l
; ---------------------------------------------------------------------------

Obj_Continue_EggRobo_5C9C4:
                jsr     (Swing_UpAndDown).l
                jsr     (MoveSprite2).l
                jsr     (SetEggRoboFrameFromVblankParity).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5C9DC:
                move.l  #Map_ContinueSprites,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Misc,2,0),art_tile(a0)
                move.w  #$380,priority(a0)
                move.b  #7,mapping_frame(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.w  #$120,x_pos(a0)
                move.w  #$F5,y_pos(a0)
                move.l  #loc_5CA14,(a0)

loc_5CA14:
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_5CA1A:
                move.l  #Map_ContinueIcons,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Icons,0,0),art_tile(a0)
                cmpi.w  #3,(Player_mode).w
                bne.s   loc_5CA36
                move.w  #make_art_tile(ArtTile_Continue_Icons,3,0),art_tile(a0)

loc_5CA36:
                move.w  #$380,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                bsr.w   ContinueIcon_SetCenterOutX
                move.w  #$D8,y_pos(a0)
                move.l  #loc_5CA5C,(a0)
                bsr.w   ContinueIcon_SelectCharacterFrames

loc_5CA5C:
                moveq   #0,d0
                btst    #4,(V_int_run_count+3).w
                beq.s   loc_5CA68
                addq.w  #1,d0

loc_5CA68:
                movea.l $30(a0),a1
                move.b  (a1,d0.w),mapping_frame(a0)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

Obj_5CA78:
                move.l  #Map_ContinueIcons,mappings(a0)
                move.w  #make_art_tile(ArtTile_Continue_Icons,0,0),art_tile(a0)
                move.w  #$280,priority(a0)
                move.b  #8,width_pixels(a0)
                move.b  #8,height_pixels(a0)
                move.l  #loc_5CA9E,(a0)

loc_5CA9E:
                lea     byte_5CBBB(pc),a1
                jsr     (Animate_RawNoSST).l
                jmp     (Draw_Sprite).l
