; Owner: objects/enemies/hcz/s3
; Responsibility: Buggernaut parent and baby flight states with private movement, animation and child records
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_Buggernaut:
                jsr     (Obj_WaitOffscreen).l

Obj_Buggernaut_2:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Buggernaut_Index(pc,d0.w),d1
                jsr     Buggernaut_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouch(pc)
; ---------------------------------------------------------------------------
Buggernaut_Index:
                dc.w    S3Buggernaut_InitAdultAndTryBaby-Buggernaut_Index
                dc.w    S3Buggernaut_TickAdultIdle-Buggernaut_Index
                dc.w    S3Buggernaut_ChasePlayerAboveWater-Buggernaut_Index
; ---------------------------------------------------------------------------

; Increment the count after the creation request regardless of its result
S3Buggernaut_InitAdultAndTryBaby:
                lea     ObjDat_Buggernaut(pc),a1
                jsr     SetUp_ObjAttributes(pc)
                move.l  #AniRaw_Buggernaut,$30(a0)
                lea     ChildObjDat_Buggernaught_Baby(pc),a2
                jsr     CreateChild1_Normal(pc)
                addq.b  #1,$39(a0)

S3Buggernaut_BeginAdultIdle:
                move.b  #2,routine(a0)
                move.w  #$3F,$2E(a0)
                move.l  #S3Buggernaut_BeginAdultChase,$34(a0)
                rts
; ---------------------------------------------------------------------------

S3Buggernaut_TickAdultIdle:
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

S3Buggernaut_BeginAdultChase:
                move.b  #4,routine(a0)
                move.w  #$7F,$2E(a0)
                move.l  #S3Buggernaut_BeginAdultIdle,$34(a0)

S3Buggernaut_AdultChaseReturn:
                rts
; ---------------------------------------------------------------------------

S3Buggernaut_ChasePlayerAboveWater:
                tst.b   render_flags(a0)
                bpl.s   S3Buggernaut_AdultChaseReturn
                jsr     Find_SonicTails(pc)
                jsr     Change_FlipX(pc)
                move.w  #$200,d0
                moveq   #$10,d1
                jsr     Chase_Object(pc)
                bsr.w   KeepChasingBuggernautAboveWaterSurface
                jsr     (MoveSprite2).l
                jsr     Animate_Raw(pc)
                jmp     Obj_Wait(pc)
; ---------------------------------------------------------------------------

Obj_Buggernaught_Baby:
                moveq   #0,d0
                move.b  routine(a0),d0
                move.w  Buggernaught_Baby_Index(pc,d0.w),d1
                jsr     Buggernaught_Baby_Index(pc,d1.w)
                jmp     Sprite_CheckDeleteTouchXY(pc)
; ---------------------------------------------------------------------------
Buggernaught_Baby_Index:
                dc.w    S3Buggernaut_InitBaby-Buggernaught_Baby_Index
                dc.w    S3Buggernaut_AnimateAndCheckParent-Buggernaught_Baby_Index
                dc.w    S3Buggernaut_UpdateOrphanFlight-Buggernaught_Baby_Index
; ---------------------------------------------------------------------------

S3Buggernaut_InitBaby:
                lea     ObjDat3_Buggernaught_Baby(pc),a1
                jsr     SetUp_ObjAttributes3(pc)
                move.l  #AniRaw_Buggernaut_Baby,$30(a0)
                rts
; ---------------------------------------------------------------------------

S3Buggernaut_AnimateAndCheckParent:
                jsr     Animate_Raw(pc)
                movea.w parent3(a0),a1
                cmpi.l  #Obj_Buggernaut_2,(a1)
                beq.s   HCZBuggernautS3_BabyCopyLiveParentFacing
                bsr.w   ReparentBuggernautBabyToAvailableAdult
                beq.s   S3Buggernaut_PickOrphanEscape

HCZBuggernautS3_BabyCopyLiveParentFacing:
                bclr    #0,render_flags(a0)
                btst    #0,render_flags(a1)
                beq.s   S3Buggernaut_ChaseParentAboveWater
                bset    #0,render_flags(a0)

S3Buggernaut_ChaseParentAboveWater:
                move.w  #$200,d0
                moveq   #$20,d1
                jsr     Chase_Object(pc)
                bsr.w   KeepChasingBuggernautAboveWaterSurface
                jmp     (MoveSprite2).l
; ---------------------------------------------------------------------------

S3Buggernaut_PickOrphanEscape:
                move.b  #4,routine(a0)
                move.w  x_pos(a0),d0
                move.w  #$200,d1
                bset    #0,render_flags(a0)
                cmp.w   (Player_1+x_pos).w,d0
                bhs.s   S3Buggernaut_StoreOrphanVelocity
                neg.w   d1
                bclr    #0,render_flags(a0)

S3Buggernaut_StoreOrphanVelocity:
                move.w  d1,x_vel(a0)
                rts
; ---------------------------------------------------------------------------

S3Buggernaut_UpdateOrphanFlight:
                jsr     Animate_Raw(pc)
                jmp     (MoveSprite2).l

; =============== S U B R O U T I N E =======================================

ReparentBuggernautBabyToAvailableAdult:
                lea     (Dynamic_object_RAM+object_size).w,a2
                move.w  #((Breathing_bubbles)-(Dynamic_object_RAM+object_size))/object_size-1,d0

S3Buggernaut_FindAdultForAdoption:
                cmpi.l  #Obj_Buggernaut_2,(a2)
                beq.s   S3Buggernaut_TrySetAdoptiveParent

S3Buggernaut_NextAdoptionCandidate:
                lea     next_object(a2),a2
                dbf     d0,S3Buggernaut_FindAdultForAdoption
                moveq   #0,d0
                rts
; ---------------------------------------------------------------------------

S3Buggernaut_TrySetAdoptiveParent:
                move.b  $39(a2),d1
                addq.b  #1,d1
                cmpi.b  #4,d1
                bhi.s   S3Buggernaut_NextAdoptionCandidate
                move.b  d1,$39(a2)
                move.w  a2,parent3(a0)
                rts
; End of function ReparentBuggernautBabyToAvailableAdult

; =============== S U B R O U T I N E =======================================

KeepChasingBuggernautAboveWaterSurface:
                move.w  y_pos(a0),d0
                move.w  (Water_level).w,d1
                subi.w  #8,d1
                cmp.w   d1,d0
                blo.s   S3Buggernaut_WaterAvoidanceReturn
                move.w  #-$200,y_vel(a0)

S3Buggernaut_WaterAvoidanceReturn:
                rts
; End of function KeepChasingBuggernautAboveWaterSurface

; ---------------------------------------------------------------------------
ObjDat_Buggernaut:
                dc.l    Map_Buggernaut
                dc.w    make_art_tile(ArtTile_Buggernaut,1,1)
                dc.w    $280
                dc.b    $10,  $C,   0, $17
ObjDat3_Buggernaught_Baby:
                dc.w    $280
                dc.b    $C,  $C,   3,   0
ChildObjDat_Buggernaught_Baby:
                dc.w    1-1
                dc.l    Obj_Buggernaught_Baby
                dc.b    $20,   0
AniRaw_Buggernaut:
                dc.b    0,   0,   1,   2, $FC
AniRaw_Buggernaut_Baby:
                dc.b    0,   3,   4,   5, $FC
                even
