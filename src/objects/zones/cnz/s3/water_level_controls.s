; Owner: objects/zones/cnz/s3
; Responsibility: Carnival Night cork floor and button controls for water-level cutscenes
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_CNZWaterLevelCorkFloor:
                jsr     (Obj_WaitOffscreen).l
                move.l  #loc_45624,(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.s   loc_45624
                move.l  #Obj_CorkFloor,(a1)
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.b  #1,subtype(a1)
                move.w  a1,$44(a0)

loc_45624:
                movea.w $44(a0),a1
                cmpi.l  #loc_29838,(a1)
                beq.s   loc_45636
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

loc_45636:
                tst.b   (_unkFAA2).w
                bne.s   loc_45646
                st      (_unkFAA2).w
                move.w  #$958,(Target_water_level).w

loc_45646:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------

Obj_CNZWaterLevelButton:
                lea     ObjDat_CutsceneButton(pc),a1
                jsr     (SetUp_ObjAttributes).l
                move.l  #loc_4566A,(a0)
                addq.w  #4,y_pos(a0)
                lea     PLC_CutsceneButton(pc),a1
                jmp     (Load_PLC_Raw).l
; ---------------------------------------------------------------------------

loc_4566A:
                move.w  #$1B,d1
                move.w  #4,d2
                move.w  #5,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                move.b  #0,mapping_frame(a0)
                move.b  status(a0),d0
                andi.b  #standing_mask,d0
                beq.s   loc_456C0
                move.b  #1,mapping_frame(a0)
                tst.b   (_unkFAA3).w
                beq.s   loc_456C0
                clr.b   (_unkFAA3).w
                move.w  #$A58,(Target_water_level).w
                moveq   #signextendB(sfx_Geyser),d0
                jsr     (Play_SFX).l
                jsr     (AllocateObject).l
                bne.s   loc_456C0
                move.l  #loc_44E04,(a1)
                st      subtype(a1)

loc_456C0:
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

sub_456C6:
                jsr     (AllocateObject).l
                bne.s   locret_456DA
                move.l  #Obj_Song_Fade_Transition,(a1)
                move.b  #mus_Knuckles,subtype(a1)

locret_456DA:
                rts
; End of function sub_456C6

; ---------------------------------------------------------------------------
ObjSlot_CutsceneKnux:
                dc.w    1-1
                dc.w    make_art_tile(ArtTile_CutsceneKnux,1,1)
                dc.w    $2E,     0
                dc.l    Map_CutsceneKnux
                dc.w    $180
                dc.b    $1C, $18, $16,   0
ObjDat_CutsceneButton:
                dc.l    Map_Button
                dc.w    make_art_tile(ArtTile_GrayButton,0,1)
                dc.w    $100
                dc.b    $10,   8,   0,   0
ObjDat3_456FA:
                dc.l    Map_LBZKnuxBomb
                dc.w    make_art_tile(ArtTile_LBZKnuxBomb,1,1)
                dc.w    $80
                dc.b    8,   8,   0,   0
ObjDat3_45706:
                dc.l    Map_LBZKnuxPillar
                dc.w    make_art_tile(ArtTile_Explosion,2,0)
                dc.w    $280
                dc.b    $10, $10,   0,   0
ObjDat_LBZKnuxPillar:
                dc.l    Map_LBZKnuxPillar
                dc.w    make_art_tile(ArtTile_Explosion,2,0)
                dc.w    $280
                dc.b    $10, $80,   1,   0
ObjDat3_4571E:
                dc.l    Map_AIZCorkFloor
                dc.w    make_art_tile($001,2,0)
                dc.w    $180
                dc.b    $10, $18,   0,   0
ChildObjDat_4572A:
                dc.w    1-1
                dc.l    loc_44A78
ChildObjDat_45730:
                dc.w    1-1
                dc.l    loc_44DD8
                dc.b    -$20,-$6C
ChildObjDat_45738:
                dc.w    1-1
                dc.l    loc_45136
                dc.b    -$40,   0
ChildObjDat_45740:
                dc.w    1-1
                dc.l    loc_4519E
                dc.b    -8,-$10
ChildObjDat_45748:
                dc.w    4-1
                dc.l    loc_451CE
ChildObjDat_4574E:
                dc.w    4-1
                dc.l    loc_45330
                dc.b    2, $24
ChildObjDat_45756:
                dc.w    1-1
                dc.l    loc_448EE
                dc.b    0, $18
DPLCPtr_CutsceneKnux:
                dc.l    ArtUnc_CutsceneKnux
                dc.l    DPLC_CutsceneKnux
byte_45766:
                dc.b    7,   1,   2,   3, $FC
byte_4576B:
                dc.b    5,  $A,  $B,  $C,  $D,  $E,  $F, $10, $11, $FC
byte_45775:
                dc.b    1, $12, $13, $14, $15, $FC
byte_4577B:
                dc.b    1,   8,   4,   8,   5,   8,   6,   8,   7, $FC
byte_45785:
                dc.b    7, $1C, $1C, $1D
                dc.b    $F8, byte_4578B-byte_45785
byte_4578B:
                dc.b    7, $1E, $1F, $FC
byte_4578F:
                dc.b    $16,   7
                dc.b    $16,   7
                dc.b    $17,   7
                dc.b    $18,   7
                dc.b    $19, $13
                dc.b    $1A,   7
                dc.b    $1B,   0
                dc.b    $F4
byte_4579E:
                dc.b    $20,   5
                dc.b    $21,   5
                dc.b    $22, $14
                dc.b    $23,   3
                dc.b    $24,  $F
                dc.b    $21,   5
                dc.b    $20,   5
                dc.b    $F4
                even
Pal_CutsceneKnux:
                binclude "data/General/Sprites/Knuckles/Cutscene/Pal.bin"
                even
Pal_CNZFlash:
                binclude "data/Levels/CNZ/Palettes/Flash.bin"
                even
