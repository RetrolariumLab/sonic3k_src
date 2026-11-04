; Owner: objects/enemies/hcz/s3
; Responsibility: Blastoid launcher, projectiles, helper callback and private construction records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Blastoid:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Blastoid_Index(pc,d0.w),d1
                jsr     Blastoid_Index(pc,d1.w)
                bsr.w   ResolveBlastoidContactAndLevelTrigger
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Blastoid_Index:
                dc.w    loc_55748-Blastoid_Index
                dc.w    loc_55750-Blastoid_Index
                dc.w    loc_55774-Blastoid_Index
; ---------------------------------------------------------------------------

loc_55748:
                lea     ObjDat_Blastoid(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_55750:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                blo.s   loc_5575C
                rts
; ---------------------------------------------------------------------------

loc_5575C:
                move.b  #4,routine(a0)
                move.l  #byte_557F6,$30(a0)
                move.l  #loc_5579E,$34(a0)

locret_55772:
                rts
; ---------------------------------------------------------------------------

loc_55774:
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   locret_55772
                bmi.s   locret_55772
                cmpi.b  #1,mapping_frame(a0)
                bne.s   locret_55772
                tst.b   render_flags(a0)
                bpl.w   locret_55772
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_557DE(pc),a2
                jmp     CreateChild5_ComplexAdjusted(pc)
; ---------------------------------------------------------------------------

loc_5579E:
                move.b  #2,routine(a0)
                rts

; =============== S U B R O U T I N E =======================================

ResolveBlastoidContactAndLevelTrigger:
                jsr     Check_PlayerCollision(pc)
                beq.w   locret_55772
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                st      (a3,d0.w)
                jmp     EnemyDefeat_Score(pc)
; End of function ResolveBlastoidContactAndLevelTrigger

; ---------------------------------------------------------------------------
; unused
                dc.w    Player_1
                dc.w    Player_2
ObjDat_Blastoid:
                dc.l    Map_Blastoid
                dc.w    make_art_tile(ArtTile_Blastoid,1,1)
                dc.w    $280
                dc.b    $14,  $C,   0, $D7
ObjDat3_557D2:
                dc.l    Map_Blastoid
                dc.w    make_art_tile(ArtTile_Blastoid,1,1)
                dc.w    $280
                dc.b    4,   4,   2, $98
ChildObjDat_557DE:
                dc.w    1-1
                dc.l    S3CallbackShot_InitDeflectable
                dc.l    ObjDat3_557D2
                dc.l    byte_55805
                dc.l    Move_AnimateRaw
                dc.b    -$14,  -7
                dc.w    -$200, -$100
byte_557F6:
                dc.b    0, $7F
                dc.b    1,   4
                dc.b    0,   9
                dc.b    1,   4
                dc.b    0,   9
                dc.b    1,   4
                dc.b    0, $3F
                dc.b    $F4
byte_55805:
                dc.b    0,   2,   3, $FC
                even
