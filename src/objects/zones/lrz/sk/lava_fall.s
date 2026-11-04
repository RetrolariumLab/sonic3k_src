; Owner: objects/zones/lrz/sk
; Responsibility: Lava-fall animation, state, player collision and sprite resources
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------

Obj_LRZLavaFall:
                moveq   #0,d0
                move.b  subtype(a0),d0
                move.w  d0,$30(a0)
                move.l  #SKLRZLavaFall_TryEmitParticle,(a0)

; The global frame window gates the local emission timer as well as spawning
SKLRZLavaFall_TryEmitParticle:
                move.w  (Level_frame_counter).w,d0
                andi.w  #$FF,d0
                cmp.w   $30(a0),d0
                blo.w   SKLRZLavaFall_CullSource
                subq.b  #1,anim_frame_timer(a0)
                bpl.w   SKLRZLavaFall_CullSource
                move.b  #5,anim_frame_timer(a0)
                jsr     (AllocateObjectAfterCurrent).l
                bne.w   SKLRZLavaFall_CullSource
                move.l  #SKLRZLavaFall_TickParticle,(a1)
                addq.b  #1,$25(a0)
                cmpi.b  #2,$25(a0)
                blo.s   SKLRZLavaFall_InitParticle
                move.b  #0,$25(a0)
                move.l  #SKLRZLavaFall_TryPlayParticleSound,(a1)

SKLRZLavaFall_InitParticle:
                move.w  x_pos(a0),x_pos(a1)
                move.w  y_pos(a0),y_pos(a1)
                move.l  #Map_LRZLavaFall,mappings(a1)
                move.w  #make_art_tile($0D3,2,0),art_tile(a1)
                ori.b   #$84,render_flags(a1)
                move.w  #$300,priority(a1)
                move.b  #$20,width_pixels(a1)
                move.b  #$20,height_pixels(a1)
                move.b  #$99,collision_flags(a1)
                bset    #4,shield_reaction(a1)
                move.w  #$800,y_vel(a1)
                move.w  #$1C,$2E(a1)
                btst    #0,status(a0)
                beq.s   SKLRZLavaFall_CullSource
                move.w  #$24,$2E(a1)

SKLRZLavaFall_CullSource:
                jmp     (Delete_Sprite_If_Not_In_Range).l
; ---------------------------------------------------------------------------

SKLRZLavaFall_TryPlayParticleSound:
                tst.b   render_flags(a0)
                bpl.s   SKLRZLavaFall_TickParticle
                move.b  (Level_frame_counter+1).w,d0
                andi.b  #$F,d0
                bne.s   SKLRZLavaFall_TickParticle
                moveq   #signextendB(sfx_LavaFall),d0
                jsr     (Play_SFX).l

SKLRZLavaFall_TickParticle:
                subq.w  #1,$2E(a0)
                bmi.s   SKLRZLavaFall_DeleteParticle
                jsr     (MoveSprite2).l
                jsr     (Add_SpriteToCollisionResponseList).l
                jmp     (Draw_Sprite).l
; ---------------------------------------------------------------------------

SKLRZLavaFall_DeleteParticle:
                jmp     (Delete_Current_Sprite).l
; ---------------------------------------------------------------------------
Map_LRZLavaFall:
                include "src/objects/shared/zones/lrz/mappings/lava_fall.s"
; End of function Obj_LRZLavaFall
