; Owner: objects/enemies/hcz/sk
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
                dc.w    loc_8794A-Blastoid_Index
                dc.w    loc_87952-Blastoid_Index
                dc.w    loc_87976-Blastoid_Index
; ---------------------------------------------------------------------------

loc_8794A:
                lea     ObjDat_Blastoid(pc),a1
                jmp     SetUp_ObjAttributes(pc)
; ---------------------------------------------------------------------------

loc_87952:
                jsr     Find_SonicTails(pc)
                cmpi.w  #$80,d2
                blo.s   loc_8795E
                rts
; ---------------------------------------------------------------------------

loc_8795E:
                move.b  #4,routine(a0)
                move.l  #byte_87A10,$30(a0)
                move.l  #loc_879A0,$34(a0)

locret_87974:
                rts
; ---------------------------------------------------------------------------

loc_87976:
                jsr     Animate_RawMultiDelay(pc)
                tst.w   d2
                beq.s   locret_87974
                bmi.s   locret_87974
                cmpi.b  #1,mapping_frame(a0)
                bne.s   locret_87974
                tst.b   render_flags(a0)
                bpl.w   locret_87974
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_879F8(pc),a2
                jmp     CreateChild5_ComplexAdjusted(pc)
; ---------------------------------------------------------------------------

loc_879A0:
                move.b  #2,routine(a0)
                rts

; =============== S U B R O U T I N E =======================================

ResolveBlastoidContactAndLevelTrigger:
                jsr     Check_PlayerCollision(pc)
                beq.w   locret_87974
                jsr     Check_PlayerAttack(pc)
                bne.s   loc_879C4
                tst.b   invulnerability_timer(a1)
                bne.w   locret_87974
                jmp     (HurtCharacter_Directly).l
; ---------------------------------------------------------------------------

loc_879C4:
                addq.w  #4,sp
                move.b  subtype(a0),d0
                andi.w  #$F,d0
                lea     (Level_trigger_array).w,a3
                st      (a3,d0.w)
                jsr     EnemyDefeated(pc)
                jmp     (Draw_Sprite).l
; End of function ResolveBlastoidContactAndLevelTrigger

; ---------------------------------------------------------------------------
ObjDat_Blastoid:
                dc.l    Map_Blastoid
                dc.w    make_art_tile(ArtTile_Blastoid,1,1)
                dc.w    $280
                dc.b    $14,  $C,   0, $D7
ObjDat3_879EC:
                dc.l    Map_Blastoid
                dc.w    make_art_tile(ArtTile_Blastoid,1,1)
                dc.w    $280
                dc.b    4,   4,   2, $98
ChildObjDat_879F8:
                dc.w    1-1
                dc.l    loc_86D4A
                dc.l    ObjDat3_879EC
                dc.l    byte_87A1F
                dc.l    Move_AnimateRaw
                dc.b    -$14,  -7
                dc.w    -$200, -$100
byte_87A10:
                dc.b    0, $7F
                dc.b    1,   4
                dc.b    0,   9
                dc.b    1,   4
                dc.b    0,   9
                dc.b    1,   4
                dc.b    0, $3F
                dc.b    $F4
byte_87A1F:
                dc.b    0,   2,   3, $FC
                even
