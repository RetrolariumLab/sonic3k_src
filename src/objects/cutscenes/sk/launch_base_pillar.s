; Owner: objects/cutscenes/sk
; Responsibility: Knuckles cutscene pillar actor and private mapping
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZKnuxPillar:
                lea     ObjDat_LBZKnuxPillar(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #1,render_flags(a0)
                beq.s   SKLBZPillar_ConsumeFlipAndSetPriority
                bset    #7,art_tile(a0)

SKLBZPillar_ConsumeFlipAndSetPriority:
                bclr    #0,render_flags(a0)
                beq.s   SKLBZPillar_InstallBGDisplacement
                move.w  #0,priority(a0)

SKLBZPillar_InstallBGDisplacement:
                move.l  #SKLBZPillar_ApplyBGDeltaAndCull,(a0)

SKLBZPillar_ApplyBGDeltaAndCull:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_LBZKnuxPillar:
                include "src/objects/shared/zones/lbz/mappings/knuckles_pillar.s"
; End of function Obj_LBZKnuxPillar
