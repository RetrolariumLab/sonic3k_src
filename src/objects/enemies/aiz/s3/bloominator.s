; Owner: objects/enemies/aiz/s3
; Responsibility: Bloominator enemy states, projectiles and child resources, including the shared callback projectile initializer referenced by enemy child records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

loc_54B46:
                movea.l $3E(a0),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #loc_54B5A,(a0)
                bset    #3,shield_reaction(a0)

loc_54B5A:
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
                dc.w    loc_54B86-Bloominator_Index
                dc.w    loc_54B9E-Bloominator_Index
                dc.w    loc_54BC2-Bloominator_Index
; ---------------------------------------------------------------------------

loc_54B86:
                lea     ObjDat_Bloominator(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.w  #$1F,$2E(a0)
                move.l  #loc_54BAA,$34(a0)

locret_54B9C:
                rts
; ---------------------------------------------------------------------------

loc_54B9E:
                tst.b   render_flags(a0)
                bpl.w   locret_54B9C
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

loc_54BAA:
                move.b  #4,routine(a0)
                move.l  #byte_54C3E,$30(a0)
                move.l  #loc_54BF8,$34(a0)
                rts
; ---------------------------------------------------------------------------

loc_54BC2:
                jsr     Animate_RawMultiDelay(pc)
                beq.s   locret_54B9C
                cmpi.b  #6,d0
                beq.s   loc_54BD4
                cmpi.b  #$E,d0
                bne.s   locret_54B9C

loc_54BD4:
                moveq   #signextendB(sfx_Projectile),d0
                jsr     (Play_SFX).l
                lea     ChildObjDat_54C26(pc),a2
                jsr     CreateChild2_Complex(pc)
                bne.s   locret_54BF6
                addq.b  #1,$39(a0)
                btst    #0,$39(a0)
                beq.s   locret_54BF6
                neg.w   x_vel(a1)

locret_54BF6:
                rts
; ---------------------------------------------------------------------------

loc_54BF8:
                move.b  #2,routine(a0)
                move.w  #2*60,$2E(a0)
                move.l  #loc_54BAA,$34(a0)
                rts
; ---------------------------------------------------------------------------
ObjDat_Bloominator:
                dc.l    Map_Bloominator
                dc.w    make_art_tile(ArtTile_Bloominator,1,0)
                dc.w    $200
                dc.b    $C, $18,   0, $23
ObjDat3_54C1A:
                dc.l    Map_Bloominator
                dc.w    make_art_tile(ArtTile_Bloominator,1,0)
                dc.w    $280
                dc.b    8,   8,   4, $98
ChildObjDat_54C26:
                dc.w    1-1
                dc.l    loc_54B46
                dc.l    ObjDat3_54C1A
                dc.l    0
                dc.l    MoveSprite
                dc.b    0,-$10
                dc.w    $100, -$500
byte_54C3E:
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
