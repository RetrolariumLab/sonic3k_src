; Owner: objects/cutscenes/sk
; Responsibility: Knuckles cutscene pillar actor and private mapping
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LBZKnuxPillar:
                lea     ObjDat_LBZKnuxPillar(pc),a1
                jsr     (SetUp_ObjAttributes).l
                bclr    #1,render_flags(a0)
                beq.s   loc_62ADA
                bset    #7,art_tile(a0)

loc_62ADA:
                bclr    #0,render_flags(a0)
                beq.s   loc_62AE8
                move.w  #0,priority(a0)

loc_62AE8:
                move.l  #loc_62AEE,(a0)

loc_62AEE:
                move.w  (Events_bg+$14).w,d0
                add.w   d0,y_pos(a0)
                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
Map_LBZKnuxPillar:
                include "src/objects/shared/zones/lbz/map_knuckles_pillar.s"
; End of function Obj_LBZKnuxPillar
