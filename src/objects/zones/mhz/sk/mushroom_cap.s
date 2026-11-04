; Owner: objects/zones/mhz/sk
; Responsibility: Mushroom cap initialization, compression, player bounce and mapping resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------

Obj_MHZMushroomCap:
; init routine
                move.w  #$80,priority(a0)
                move.b  subtype(a0),d0                  ; If bit 7 set
                bpl.s   .highspritepriority
                move.w  #$300,priority(a0)

                .highspritepriority:
                move.b  d0,d1
                move.w  #make_art_tile(ArtTile_MHZMisc+$22,2,1),art_tile(a0)  ; Dark-spotted mushroom
                andi.b  #1,d0                           ; If bit 0 set
                beq.s   .lightmushroom
                move.w  #make_art_tile(ArtTile_MHZMisc+$52,2,1),art_tile(a0)  ; Light-spotted mushroom
                move.b  #$14,$36(a0)                    ; Change animation timing a little, so not all mushrooms are synchronized

                .lightmushroom:
                add.b   d1,d1                           ; If bit 6 set
                bpl.s   .highplanepriority
                andi.w  #drawing_mask,art_tile(a0)      ; Strip 'high priority' bit

                .highplanepriority:
                move.l  #Map_MHZMushroomCap,mappings(a0)
                ori.b   #4,render_flags(a0)
                move.b  #$20,width_pixels(a0)
                move.b  #$10,height_pixels(a0)
                bset    #7,status(a0)                   ; ???
                move.w  x_pos(a0),$38(a0)               ; Store initial x_pos
                move.w  y_pos(a0),$3A(a0)               ; Store initial y_pos
                move.l  #Obj_MHZMushroomCap_Main,(a0)

Obj_MHZMushroomCap_Main:
; main routine
                lea     (Ani_MHZMushroomCap).l,a1
                jsr     (Animate_Sprite).l
                tst.b   routine(a0)                     ; Has animation byte_3E1E1 ended?
                beq.s   .animstillgoing
                move.w  #0,anim(a0)                     ; and prev_anim
                move.b  #0,anim_frame(a0)
                clr.b   routine(a0)

                .animstillgoing:
                bsr.s   MHZMushroomCap_UpdatePosition
                move.w  #$18,d1
                moveq   #0,d3
                move.b  mapping_frame(a0),d3
                move.b  SKMHZMushCap_FrameSolidHeights(pc,d3.w),d3
                move.w  x_pos(a0),d4
                jsr     (SolidObjectTop).l
; Bounce player
                lea     (Player_1).w,a1
                moveq   #$30,d5                         ; $30(a0), player's y_vel
                moveq   #p1_standing_bit,d6             ; 'Player standing on this object' bit
                bsr.w   MHZMushroomCap_BounceCharacter
; Bounce sidekick
                lea     (Player_2).w,a1
                moveq   #$32,d5                         ; $32(a0), sidekick's y_vel
                moveq   #p2_standing_bit,d6             ; 'Sidekick standing on this object' bit
                bsr.w   MHZMushroomCap_BounceCharacter

                jmp     (Sprite_OnScreen_Test).l
; ---------------------------------------------------------------------------
SKMHZMushCap_FrameSolidHeights:
                dc.b    $12,   8, $12, $12
                even

; =============== S U B R O U T I N E =======================================

MHZMushroomCap_UpdatePosition:
                moveq   #0,d0
                move.b  (Anim_Counters+$F).w,d0         ; Update according to level animation
                add.b   $36(a0),d0                      ; Add in offset value, so not all mushrooms animate identically
                lea     MHZMushroomCap_Positions(pc,d0.w),a1  ; Get appropriate data
; Update x_pos
                move.b  (a1)+,d0
                ext.w   d0
                add.w   $38(a0),d0                      ; Add initial x_pos
                move.w  d0,x_pos(a0)                    ; Set x_pos
; Update y_pos
                move.b  (a1)+,d1
                ext.w   d1
                add.w   $3A(a0),d1                      ; Add initial y_pos
                move.w  d1,y_pos(a0)                    ; Set y_pos
                rts
; End of function MHZMushroomCap_UpdatePosition

; ---------------------------------------------------------------------------
MHZMushroomCap_Positions:
; X    Y
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    -1,   0
                dc.b    -1,   0
                dc.b    -1,   0
                dc.b    -2,   0
                dc.b    -2,   0
                dc.b    -2,   0
                dc.b    -3,   1
                dc.b    -3,   1
                dc.b    -3,   1
                dc.b    -3,   1
                dc.b    -3,   1
                dc.b    -3,   1
                dc.b    -2,   0
                dc.b    -2,   0
                dc.b    -2,   0
                dc.b    -1,   0
                dc.b    -1,   0
                dc.b    -1,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    2,   0
                dc.b    2,   0
                dc.b    2,   0
                dc.b    3,   1
                dc.b    3,   1
                dc.b    3,   1
                dc.b    3,   1
                dc.b    3,   1
                dc.b    3,   1
                dc.b    2,   0
                dc.b    2,   0
                dc.b    2,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    1,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    0,   0
                dc.b    -1,   0
                dc.b    -1,   0
                dc.b    -1,   0
                dc.b    -2,   0
                dc.b    -2,   0
                dc.b    -2,   0
                even

; =============== S U B R O U T I N E =======================================

MHZMushroomCap_BounceCharacter:
                btst    d6,status(a0)                   ; Is character standing on object?
                bne.s   .characteronmushroom            ; If so, prepare to bounce them
                move.w  y_vel(a1),(a0,d5.w)             ; If not, just store character's y_vel
                rts

                .characteronmushroom:
                move.b  #1,anim(a0)                     ; Set mushroom to 'spring' animation
                cmpi.b  #3,mapping_frame(a0)            ; Are we at an actual 'spring up' frame?
                bne.s   .return                         ; If not, return and don't do anything else to the character
                move.w  (a0,d5.w),d0                    ; Get character's previous y_vel
; These checks make the character bounce higher if they hit the mushroom at a high speed
                move.w  #$660,d1
                cmp.w   d1,d0                           ; Is character going slow?
                blt.s   .bouncecharacter                ; If so, make them bounce low
                move.w  #$760,d1
                cmp.w   d1,d0                           ; Is character going faster?
                blt.s   .bouncecharacter                ; If so, make them bounce high
                move.w  #$860,d1                        ; Otherwise, they're going really fast; make them bounce really high

                .bouncecharacter:
                addi.w  #$20,d1
                neg.w   d1
                move.w  d1,y_vel(a1)                    ; Set character's y_vel, bouncing them
                bset    #Status_InAir,status(a1)        ; Set character's 'in air' bit
                bclr    #Status_OnObj,status(a1)        ; Clear character's 'on object' bit
                clr.b   jumping(a1)
                clr.b   spin_dash_flag(a1)
                move.b  #$10,anim(a1)                   ; Set character to 'spring-jumping' animation
                move.b  #2,routine(a1)
                moveq   #signextendB(sfx_MushroomBounce),d0
                jmp     (Play_SFX).l                    ; Play bounce sound

                .return:
                rts
; End of function MHZMushroomCap_BounceCharacter

; ---------------------------------------------------------------------------
Ani_MHZMushroomCap:
                include "src/objects/shared/zones/mhz/animations/mushroom_cap.s"
Map_MHZMushroomCap:
                include "src/objects/shared/zones/mhz/mappings/mushroom_cap.s"
