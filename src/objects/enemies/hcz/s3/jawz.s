; Owner: objects/enemies/hcz/s3
; Responsibility: Jawz swimming enemy and its private object attribute record
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Jawz:
                jsr     (Obj_WaitOffscreen).l
                lea     ObjDat_Jawz(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #S3Jawz_SwimAndCheckContact,(a0)
                move.w  #-$200,d4
                jmp     Set_VelocityXTrackSonic(pc)
; ---------------------------------------------------------------------------

S3Jawz_SwimAndCheckContact:
                jsr     (MoveSprite2).l
                lea     HCZJawzS3_UniformSwimTwoFrameLoop(pc),a1
                jsr     Animate_RawNoSST(pc)
                moveq   #0,d0
                move.b  collision_property(a0),d0
                bne.s   S3Jawz_ResolveContact
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------

S3Jawz_ResolveContact:
                add.w   d0,d0
                movea.w HCZJawzS3_ThreeContactPlayerWordHandles-2(pc,d0.w),a1
                cmpi.b  #2,anim(a1)
                beq.s   S3Jawz_StorePlayerAndDefeat
                cmpi.b  #9,anim(a1)
                beq.s   S3Jawz_StorePlayerAndDefeat
                lea     (HCZBossS3_ExplosionChild).l,a2
                jsr     CreateChild1_Normal(pc)
                jmp     Go_Delete_Sprite(pc)
; ---------------------------------------------------------------------------

S3Jawz_StorePlayerAndDefeat:
                move.w  a1,$44(a0)
                jmp     EnemyDefeat_Score(pc)
; ---------------------------------------------------------------------------
HCZJawzS3_ThreeContactPlayerWordHandles:
                dc.w    Player_1
                dc.w    Player_2
                dc.w    Player_1
ObjDat_Jawz:
                dc.l    Map_Jawz
                dc.w    make_art_tile(ArtTile_Jawz,1,1)
                dc.w    $280
                dc.b    $1C,  $C,   0, $D7
HCZJawzS3_UniformSwimTwoFrameLoop:
                dc.b    0,   0,   1, $FC
                even
; End of function Obj_Jawz
