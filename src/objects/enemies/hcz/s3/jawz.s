; Owner: objects/enemies/hcz/s3
; Responsibility: Jawz swimming enemy and its private object attribute record
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Jawz:
                jsr     (Obj_WaitOffscreen).l
                lea     ObjDat_Jawz(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_556CA,(a0)
                move.w  #-$200,d4
                jmp     Set_VelocityXTrackSonic(pc)
; ---------------------------------------------------------------------------

loc_556CA:
                jsr     (MoveSprite2).l
                lea     byte_55722(pc),a1
                jsr     Animate_RawNoSST(pc)
                moveq   #0,d0
                move.b  collision_property(a0),d0
                bne.s   loc_556E4
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

loc_556E4:
                add.w   d0,d0
                movea.w word_55710-2(pc,d0.w),a1
                cmpi.b  #2,anim(a1)
                beq.s   loc_55708
                cmpi.b  #9,anim(a1)
                beq.s   loc_55708
                lea     (ChildObjDat_49BF4).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

loc_55708:
                move.w  a1,$44(a0)
                jmp     EnemyDefeat_Score(pc)
; ---------------------------------------------------------------------------
word_55710:
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_1
ObjDat_Jawz:
                dc.l    Map_Jawz
                dc.w    make_art_tile(ArtTile_Jawz,1,1)
                dc.w    $280
                dc.b    $1C,  $C,   0, $D7
byte_55722:
                dc.b    0,   0,   1, $FC
                even
; End of function Obj_Jawz
