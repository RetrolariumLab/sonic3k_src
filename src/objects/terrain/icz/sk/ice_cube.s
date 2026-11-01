; Owner: objects/terrain/icz/sk
; Responsibility: IceCap moving ice cube controller and private motion or fragment data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZIceCube:
                jsr     Obj_WaitOffscreen(pc)
                move.l  #loc_8B384,(a0)
                lea     ObjDat_ICZIceCube(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

loc_8B384:
                move.b  (Player_1+anim).w,$3A(a0)
                move.b  (Player_2+anim).w,$3B(a0)
                moveq   #$23,d1
                moveq   #$10,d2
                moveq   #$10,d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectFull).l
                bsr.w   BreakIczIceCubeUnderRollingRider
                jmp     (Sprite_OnScreen_Test).l

; =============== S U B R O U T I N E =======================================

BreakIczIceCubeUnderRollingRider:
                move.b  status(a0),d0
                btst    #p1_standing_bit,d0
                beq.s   loc_8B3C0
                lea     (Player_1).w,a1
                cmpi.b  #2,$3A(a0)
                beq.s   loc_8B3D2

loc_8B3C0:
                btst    #p2_standing_bit,d0
                beq.s   locret_8B430
                lea     (Player_2).w,a1
                cmpi.b  #2,$3B(a0)
                bne.s   locret_8B430

loc_8B3D2:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.w  #-$300,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                btst    #p2_standing_bit,status(a0)
                beq.s   loc_8B41A
                lea     (Player_2).w,a1
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)

loc_8B41A:
                lea     ChildObjDat_8B480(pc),a2
                jsr     CreateChild1_Normal(pc)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                jsr     (Go_Delete_Sprite).l

locret_8B430:
                rts
; End of function BreakIczIceCubeUnderRollingRider

; ---------------------------------------------------------------------------

loc_8B432:
                lea     word_8B478(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #byte_8AB34,$30(a0)
                cmpi.b  #$C,subtype(a0)
                blo.s   loc_8B458
                move.l  #byte_8AB3E,$30(a0)

loc_8B458:
                jsr     (Random_Number).l
                andi.b  #3,d0
                move.b  d0,anim_frame(a0)
                moveq   #0,d0
                jmp     Set_IndexedVelocity(pc)
; ---------------------------------------------------------------------------
ObjDat_ICZIceCube:
                dc.l    Map_ICZPlatforms
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,0)
                dc.w    $80
                dc.b    $18, $10,   3, $2E
word_8B478:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,1)
                dc.w    $280
                dc.b    $20, $20, $12,   0
ChildObjDat_8B480:
                dc.w    $C-1
                dc.l    loc_8B432
                dc.b    0,  -8
                dc.l    loc_8B432
                dc.b    0,   8
                dc.l    loc_8B432
                dc.b    -$10,  -8
                dc.l    loc_8B432
                dc.b    $10,  -8
                dc.l    loc_8B432
                dc.b    -$10,   8
                dc.l    loc_8B432
                dc.b    $10,   8
                dc.l    loc_8B432
                dc.b    0,   0
                dc.l    loc_8B432
                dc.b    0,   0
                dc.l    loc_8B432
                dc.b    0,   0
                dc.l    loc_8B432
                dc.b    0,   0
                dc.l    loc_8B432
                dc.b    0,   0
                dc.l    loc_8B432
                dc.b    0,   0
