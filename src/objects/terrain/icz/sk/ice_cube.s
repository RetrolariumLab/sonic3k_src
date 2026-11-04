; Owner: objects/terrain/icz/sk
; Responsibility: IceCap moving ice cube controller and private motion or fragment data
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_ICZIceCube:
                jsr     Obj_WaitOffscreen(pc)
                move.l  #SKICZIceCube_ResolveSolidAndTryBreak,(a0)
                lea     ObjDat_ICZIceCube(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------

SKICZIceCube_ResolveSolidAndTryBreak:
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
                beq.s   SKICZIceCube_TryBreakForRollingP2
                lea     (Player_1).w,a1
                cmpi.b  #2,$3A(a0)
                beq.s   SKICZIceCube_BounceRiderAndBreak

SKICZIceCube_TryBreakForRollingP2:
                btst    #p2_standing_bit,d0
                beq.s   SKICZIceCube_BreakReturn
                lea     (Player_2).w,a1
                cmpi.b  #2,$3B(a0)
                bne.s   SKICZIceCube_BreakReturn

SKICZIceCube_BounceRiderAndBreak:
                bset    #Status_Roll,status(a1)
                move.b  #$E,y_radius(a1)
                move.b  #7,x_radius(a1)
                move.b  #2,anim(a1)
                move.w  #-$300,y_vel(a1)
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)
                move.b  #2,routine(a1)
                btst    #p2_standing_bit,status(a0)
                beq.s   SKICZIceCube_SpawnShardsAndDelete
                lea     (Player_2).w,a1
                bset    #Status_InAir,status(a1)
                bclr    #Status_OnObj,status(a1)

SKICZIceCube_SpawnShardsAndDelete:
                lea     SKICZIceCube_CubeShardChildren(pc),a2
                jsr     CreateChild1_Normal(pc)
                moveq   #signextendB(sfx_BossHit),d0
                jsr     (Play_SFX).l
                jsr     (Go_Delete_Sprite).l

SKICZIceCube_BreakReturn:
                rts
; End of function BreakIczIceCubeUnderRollingRider

; ---------------------------------------------------------------------------

SKICZIceCube_InitCubeShard:
                lea     SKICZIceCube_ShardAttrs(pc),a1
                jsr     SetUp_ObjAttributes2(pc)
                move.l  #AnimateRaw_MoveChkDel,(a0)
                move.l  #SKICZFreezer_LargeIceShardAnim,$30(a0)
                cmpi.b  #$C,subtype(a0)
                blo.s   SKICZIceCube_SetShardFrameAndSpeed
                move.l  #SKICZFreezer_MediumIceShardAnim,$30(a0)

SKICZIceCube_SetShardFrameAndSpeed:
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
SKICZIceCube_ShardAttrs:
                dc.w    make_art_tile(ArtTile_ICZMisc1,2,1)
                dc.w    $280
                dc.b    $20, $20, $12,   0
SKICZIceCube_CubeShardChildren:
                dc.w    $C-1
                dc.l    SKICZIceCube_InitCubeShard
                dc.b    0,  -8
                dc.l    SKICZIceCube_InitCubeShard
                dc.b    0,   8
                dc.l    SKICZIceCube_InitCubeShard
                dc.b    -$10,  -8
                dc.l    SKICZIceCube_InitCubeShard
                dc.b    $10,  -8
                dc.l    SKICZIceCube_InitCubeShard
                dc.b    -$10,   8
                dc.l    SKICZIceCube_InitCubeShard
                dc.b    $10,   8
                dc.l    SKICZIceCube_InitCubeShard
                dc.b    0,   0
                dc.l    SKICZIceCube_InitCubeShard
                dc.b    0,   0
                dc.l    SKICZIceCube_InitCubeShard
                dc.b    0,   0
                dc.l    SKICZIceCube_InitCubeShard
                dc.b    0,   0
                dc.l    SKICZIceCube_InitCubeShard
                dc.b    0,   0
                dc.l    SKICZIceCube_InitCubeShard
                dc.b    0,   0
