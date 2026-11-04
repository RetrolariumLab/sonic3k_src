; Owner: objects/enemies/hcz/sk
; Responsibility: Jawz swimming enemy and its private object attribute record
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Jawz:
                jsr     (Obj_WaitOffscreen).l
                lea     ObjDat_Jawz(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #SKJawz_SwimAndCheckContact,(a0)
                move.w  #-$200,d4
                jmp     Set_VelocityXTrackSonic(pc)
; ---------------------------------------------------------------------------

SKJawz_SwimAndCheckContact:
                jsr     (MoveSprite2).l
                lea     HCZJawzSK_UniformSwimTwoFrameLoop(pc),a1
                jsr     Animate_RawNoSST(pc)
                moveq   #0,d0
                move.b  collision_property(a0),d0
                bne.s   SKJawz_ResolveContact
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

SKJawz_ResolveContact:
                add.w   d0,d0
                movea.w HCZJawzSK_ThreeContactPlayerWordHandles-2(pc,d0.w),a1
                jsr     (Check_PlayerAttack).l
                bne.s   SKJawz_StorePlayerAndDefeat
                lea     (ChildObjDat_6BDB2).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

SKJawz_StorePlayerAndDefeat:
                move.w  a1,$44(a0)
                jsr     EnemyDefeated(pc)
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------
HCZJawzSK_ThreeContactPlayerWordHandles:
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_2
ObjDat_Jawz:
                dc.l    Map_Jawz
                dc.w    make_art_tile(ArtTile_Jawz,1,1)
                dc.w    $280
                dc.b    $1C,  $C,   0, $D7
HCZJawzSK_UniformSwimTwoFrameLoop:
                dc.b    0,   0,   1, $FC
                even
; End of function Obj_Jawz
