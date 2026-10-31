; Owner: objects/enemies/aiz/sk
; Responsibility: Bloominator enemy states, projectiles and child resources, including the shared callback projectile initializer referenced by enemy child records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_86D4A:
                movea.l $3E(a0),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_86D5E,(a0)
                bset    #3,shield_reaction(a0)

loc_86D5E:
                movea.l $34(a0),a1
                jsr     (a1)
                jmp     (Sprite_CheckDeleteTouchXY).l
; ---------------------------------------------------------------------------

Obj_Bloominator:
                jsr     (Obj_WaitOffscreen).l
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Bloominator_Index(pc,d0.w),d1
                jsr     Bloominator_Index(pc,d1.w)
                jmp     (Sprite_CheckDeleteTouch).l
; ---------------------------------------------------------------------------
Bloominator_Index:
                dc.w    loc_86D8A-Bloominator_Index
                dc.w    loc_86DA2-Bloominator_Index
                dc.w    loc_86DC6-Bloominator_Index
; ---------------------------------------------------------------------------

loc_86D8A:
                lea     ObjDat_Bloominator(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #$1F,$2E(a0)
                move.l  #loc_86DAE,$34(a0)

locret_86DA0:
                rts
; ---------------------------------------------------------------------------

loc_86DA2:
                tst.b   render_flags(a0)
                bpl.w   locret_86DA0
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_86DAE:
                move.b  #4,routine(a0)
                move.l  #byte_86E42,$30(a0)
                move.l  #loc_86DFC,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_86DC6:
                jsr     Animate_RawMultiDelay(pc)
                beq.s   locret_86DA0
                cmpi.b  #6,d0
                beq.s   loc_86DD8
                cmpi.b  #$E,d0
                bne.s   locret_86DA0

loc_86DD8:
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_86E2A(pc),a2
                jsr     CreateChild2_Complex(pc)
                bne.s   locret_86DFA
                addq.b  #1,$39(a0)
                btst    #0,$39(a0)
                beq.s   locret_86DFA
                neg.w   x_vel(a1)

locret_86DFA:
                rts
; ---------------------------------------------------------------------------

loc_86DFC:
                move.b  #2,routine(a0)
                move.w  #2*60,$2E(a0)
                move.l  #loc_86DAE,$34(a0)
                rts
; ---------------------------------------------------------------------------
ObjDat_Bloominator:
                dc.l    Map_Bloominator
                dc.w    make_art_tile(ArtTile_Bloominator,1,0)
                dc.w    $200
                dc.b    $C, $18,   0, $23
ObjDat3_86E1E:
                dc.l    Map_Bloominator
                dc.w    make_art_tile(ArtTile_Bloominator,1,0)
                dc.w    $280
                dc.b    8,   8,   4, $98
ChildObjDat_86E2A:
                dc.w    1-1
                dc.l    loc_86D4A
                dc.l    ObjDat3_86E1E
                dc.l    0
                dc.l    MoveSprite
                dc.b    0,-$10
                dc.w    $100, -$500
byte_86E42:
                dc.b    0,   7
                dc.b    1,   9
                dc.b    2,   4
                dc.b    3,   4
                dc.b    0,   9
                dc.b    1,   9
                dc.b    2,   4
                dc.b    3,   4
                dc.b    0,   0
                dc.b    $F4
                even
