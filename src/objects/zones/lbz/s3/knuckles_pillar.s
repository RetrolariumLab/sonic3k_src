; Owner: objects/zones/lbz/s3
; Responsibility: Launch Base Knuckles cutscene pillar creation, motion and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZKnuxPillar:
                lea     ObjDat_LBZKnuxPillar(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #1,render_flags(a0)
                beq.s   S3LBZKnuxPillar_ClearFlipAndSetPriority
                bset    #7,art_tile(a0)

S3LBZKnuxPillar_ClearFlipAndSetPriority:
                bclr    #0,render_flags(a0)
                beq.s   S3LBZKnuxPillar_StartBackgroundFollower
                move.w  #0,priority(a0)

S3LBZKnuxPillar_StartBackgroundFollower:
                move.l  #S3LBZKnuxPillar_FollowBackgroundY,(a0)

S3LBZKnuxPillar_FollowBackgroundY:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_LBZKnuxPillar:
                include "src/objects/shared/zones/lbz/mappings/knuckles_pillar.s"
; End of function Obj_LBZKnuxPillar
