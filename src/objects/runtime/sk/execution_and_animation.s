; Owner: objects/runtime/sk
; Responsibility: Sprite table initialization, object execution, movement, deletion, draw queuing and animation interfaces
; Source provenance and ranges: config/reconstruction/source_layout.json

; =============== S U B R O U T I N E =======================================

Init_SpriteTable:
                clr.w   (Spritemask_flag).w
                if      Sprite_table_page_flip_pending<>(Current_sprite_table_page+2)
                clr.w   (Current_sprite_table_page).w
                clr.w   (Sprite_table_page_flip_pending).w
                else
                clr.l   (Current_sprite_table_page).w   ; Clears both Current_sprite_table_page and Sprite_table_page_flip_pending!
                endif
                tst.w   (Competition_mode).w
                beq.s   loc_1AA9E
                lea     (Sprite_table).w,a0
                bsr.s   Init_SpriteTable2
                bsr.s   Init_SpriteTable_2Player
                lea     (Sprite_table_alternate).l,a0
                bsr.s   Init_SpriteTable2
                bsr.s   Init_SpriteTable_2Player
                lea     (Sprite_table_P2).l,a0
                bsr.s   Init_SpriteTable2
                lea     (Sprite_table_P2_alternate).l,a0
                bra.s   Init_SpriteTable2
; ---------------------------------------------------------------------------

loc_1AA9E:
                lea     (Sprite_table).w,a0
; End of function Init_SpriteTable

; =============== S U B R O U T I N E =======================================

Init_SpriteTable2:
                moveq   #0,d0
                moveq   #1,d1
                moveq   #$50-1,d7

                .loop:
                move.w  d0,(a0)
                move.b  d1,3(a0)
                addq.w  #1,d1
                addq.w  #8,a0
                dbf     d7,.loop
                move.b  d0,-5(a0)
                rts
; End of function Init_SpriteTable2

; =============== S U B R O U T I N E =======================================

Init_SpriteTable_2Player:
                lea     -$280(a0),a0
                move.l  #$EB0301,(a0)+
                move.l  #1,(a0)+
                move.l  #$EB0302,(a0)+
                move.l  #0,(a0)
                rts
; End of function Init_SpriteTable_2Player

; =============== S U B R O U T I N E =======================================

Process_Sprites:
                tst.b   (Teleport_active_flag).w
                bne.s   locret_1AB0C
                lea     (Object_RAM).w,a0
                tst.w   (Competition_mode).w
                bne.s   loc_1AAFA
                cmpi.b  #$C,(Player_1+routine).w
                beq.s   loc_1AAFA
                cmpi.b  #6,(Player_1+routine).w
                bhs.s   loc_1AB0E

loc_1AAFA:
                moveq   #(Object_RAM_end-Object_RAM)/object_size-1,d7
; End of function Process_Sprites

; =============== S U B R O U T I N E =======================================

sub_1AAFC:
                move.l  (a0),d0
                beq.s   loc_1AB04
                movea.l d0,a1
                jsr     (a1)

loc_1AB04:
                lea     next_object(a0),a0
                dbf     d7,sub_1AAFC

locret_1AB0C:
                rts
; End of function sub_1AAFC

; ---------------------------------------------------------------------------

loc_1AB0E:                                              ; this is broken?
                moveq   #((Dynamic_object_RAM+object_size)-Object_RAM)/object_size-1,d7
                bsr.s   sub_1AAFC
                moveq   #((Level_object_RAM+object_size)-(Dynamic_object_RAM+object_size))/object_size-1,d7
                bsr.s   sub_1AB1A
                moveq   #(Object_RAM_end-(Level_object_RAM+object_size))/object_size-1,d7
                bra.s   sub_1AAFC

; =============== S U B R O U T I N E =======================================

sub_1AB1A:
                move.l  (a0),d0
                beq.s   loc_1AB28
                tst.b   render_flags(a0)
                bpl.s   loc_1AB28
                jsr     Draw_Sprite(pc)

loc_1AB28:
                lea     next_object(a0),a0
                dbf     d7,sub_1AB1A
                rts
; End of function sub_1AB1A

; ---------------------------------------------------------------------------
; Subroutine to make an object move and fall downward increasingly fast
; This moves the object horizontally and vertically
; and also applies gravity to its speed
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MoveSprite:
                move.w  x_vel(a0),d0                    ; load x speed
                ext.l   d0
                lsl.l   #8,d0                           ; shift velocity to line up with the middle 16 bits of the 32-bit position
                add.l   d0,x_pos(a0)                    ; add x speed to x position ; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
                move.w  y_vel(a0),d0                    ; load y speed
                addi.w  #$38,y_vel(a0)                  ; increase vertical speed (apply gravity)
                ext.l   d0
                lsl.l   #8,d0                           ; shift velocity to line up with the middle 16 bits of the 32-bit position
                add.l   d0,y_pos(a0)                    ; add old y speed to y position ; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
                rts
; End of function MoveSprite

; ---------------------------------------------------------------------------
; Subroutine translating object speed to update object position
; This moves the object horizontally and vertically
; but does not apply gravity to it
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

MoveSprite2:
                move.w  x_vel(a0),d0                    ; load horizontal speed
                ext.l   d0
                lsl.l   #8,d0                           ; shift velocity to line up with the middle 16 bits of the 32-bit position
                add.l   d0,x_pos(a0)                    ; add to x-axis position ; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
                move.w  y_vel(a0),d0                    ; load vertical speed
                ext.l   d0
                lsl.l   #8,d0                           ; shift velocity to line up with the middle 16 bits of the 32-bit position
                add.l   d0,y_pos(a0)                    ; add to y-axis position ; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
                rts
; End of function MoveSprite2

; =============== S U B R O U T I N E =======================================

MoveSprite_TestGravity:
                tst.b   (Reverse_gravity_flag).w
                beq.s   MoveSprite

                move.w  x_vel(a0),d0                    ; load x speed
                ext.l   d0
                lsl.l   #8,d0                           ; shift velocity to line up with the middle 16 bits of the 32-bit position
                add.l   d0,x_pos(a0)                    ; add x speed to x position ; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
                move.w  y_vel(a0),d0                    ; load y speed
                addi.w  #$38,y_vel(a0)                  ; increase vertical speed (apply gravity)
                neg.w   d0                              ; reverse it
                ext.l   d0
                lsl.l   #8,d0                           ; shift velocity to line up with the middle 16 bits of the 32-bit position
                add.l   d0,y_pos(a0)                    ; add old y speed to y position ; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
                rts
; End of function MoveSprite_TestGravity

; =============== S U B R O U T I N E =======================================

MoveSprite_TestGravity2:
                tst.b   (Reverse_gravity_flag).w
                beq.s   MoveSprite2

                move.w  x_vel(a0),d0                    ; load horizontal speed
                ext.l   d0
                lsl.l   #8,d0                           ; shift velocity to line up with the middle 16 bits of the 32-bit position
                add.l   d0,x_pos(a0)                    ; add to x-axis position ; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
                move.w  y_vel(a0),d0                    ; load vertical speed
                neg.w   d0                              ; reverse it
                ext.l   d0
                lsl.l   #8,d0                           ; shift velocity to line up with the middle 16 bits of the 32-bit position
                add.l   d0,y_pos(a0)                    ; add to y-axis position ; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
                rts
; End of function MoveSprite_TestGravity2

; =============== S U B R O U T I N E =======================================

Delete_Current_Sprite:
                movea.l a0,a1
; End of function Delete_Current_Sprite

; =============== S U B R O U T I N E =======================================

Delete_Referenced_Sprite:
                moveq   #bytesToLcnt(object_size-2),d0
                moveq   #0,d1

                .loop:
                move.l  d1,(a1)+
                dbf     d0,.loop
                move.w  d1,(a1)+
                rts
; End of function Delete_Referenced_Sprite

; =============== S U B R O U T I N E =======================================

Draw_Sprite:
                lea     (Sprite_table_input).w,a1
                adda.w  priority(a0),a1

loc_1ABCE:
                cmpi.w  #$7E,(a1)
                bhs.s   loc_1ABDC
                addq.w  #2,(a1)
                adda.w  (a1),a1
                move.w  a0,(a1)

locret_1ABDA:
                rts
; ---------------------------------------------------------------------------

loc_1ABDC:
                cmpa.w  #Sprite_table_input+($80*7),a1
                beq.s   locret_1ABDA
                adda.w  #$80,a1
                bra.s   loc_1ABCE
; End of function Draw_Sprite

; =============== S U B R O U T I N E =======================================

Animate_Sprite:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   loc_1AC00
                move.b  d0,prev_anim(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)

loc_1AC00:
                subq.b  #1,anim_frame_timer(a0)
                bcc.s   locret_1AC36
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                move.b  (a1),anim_frame_timer(a0)
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                move.b  1(a1,d1.w),d0
                bmi.s   loc_1AC38

loc_1AC1C:
                move.b  d0,mapping_frame(a0)
                move.b  status(a0),d1
                andi.b  #3,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                addq.b  #1,anim_frame(a0)

locret_1AC36:
                rts
; ---------------------------------------------------------------------------

loc_1AC38:
                addq.b  #1,d0                           ; Code FF - Repeat animation from beginning
                bne.s   loc_1AC48
                move.b  #0,anim_frame(a0)
                move.b  1(a1),d0
                bra.s   loc_1AC1C
; ---------------------------------------------------------------------------

loc_1AC48:
                addq.b  #1,d0                           ; Code FE - Repeat animation from earlier point
                bne.s   loc_1AC5C
                move.b  2(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                sub.b   d0,d1
                move.b  1(a1,d1.w),d0
                bra.s   loc_1AC1C
; ---------------------------------------------------------------------------

loc_1AC5C:
                addq.b  #1,d0                           ; Code FD - Start new animation
                bne.s   loc_1AC68
                move.b  2(a1,d1.w),anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_1AC68:
                addq.b  #1,d0                           ; Code FC - Increment routine counter
                bne.s   loc_1AC7A
                addq.b  #2,routine(a0)
                clr.b   anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)
                rts
; ---------------------------------------------------------------------------

loc_1AC7A:
                addq.b  #1,d0                           ; Code FB - Move offscreen
                bne.s   locret_1AC86
                move.w  #$7F00,x_pos(a0)
                rts
; ---------------------------------------------------------------------------

locret_1AC86:
                rts
; End of function Animate_Sprite

; =============== S U B R O U T I N E =======================================

Animate_SpriteIrregularDelay:
                moveq   #0,d0
                move.b  anim(a0),d0
                cmp.b   prev_anim(a0),d0
                beq.s   loc_1ACA0
                move.b  d0,prev_anim(a0)
                clr.b   anim_frame(a0)
                clr.b   anim_frame_timer(a0)

loc_1ACA0:
                subq.b  #1,anim_frame_timer(a0)
                bcc.s   locret_1ACDA
                add.w   d0,d0
                adda.w  (a1,d0.w),a1
                moveq   #0,d1
                move.b  anim_frame(a0),d1
                add.w   d1,d1
                move.b  (a1,d1.w),d0
                bmi.s   loc_1ACDC

loc_1ACBA:
                move.b  1(a1,d1.w),anim_frame_timer(a0)
                move.b  d0,mapping_frame(a0)
                move.b  status(a0),d1
                andi.b  #3,d1
                andi.b  #$FC,render_flags(a0)
                or.b    d1,render_flags(a0)
                addq.b  #1,anim_frame(a0)

locret_1ACDA:
                rts
; ---------------------------------------------------------------------------

loc_1ACDC:
                addq.b  #1,d0
                bne.s   loc_1ACEA
; Bug: S3 did not clear d1, making loc_1ACBA run a frame short with each loop
; This was fixed, but apart from the Blue Spheres title, the only other effect
; is that the wink animation on the S3 title now runs a frame too long
                moveq   #0,d1
                move.b  d1,anim_frame(a0)
                move.b  (a1),d0
                bra.s   loc_1ACBA
; ---------------------------------------------------------------------------

loc_1ACEA:
                addq.b  #1,d0
                bne.s   loc_1AD00
                move.b  1(a1,d1.w),d0
                sub.b   d0,anim_frame(a0)
                add.w   d0,d0
                sub.b   d0,d1
                move.b  (a1,d1.w),d0
                bra.s   loc_1ACBA
; ---------------------------------------------------------------------------

loc_1AD00:
                addq.b  #1,d0
                bne.s   loc_1AD0C
                move.b  1(a1,d1.w),anim(a0)
                rts
; ---------------------------------------------------------------------------

loc_1AD0C:
                addq.b  #1,d0
                bne.s   locret_1AD1E
                addq.b  #2,routine(a0)
                clr.b   anim_frame_timer(a0)
                addq.b  #1,anim_frame(a0)
                rts
; ---------------------------------------------------------------------------

locret_1AD1E:
                rts
; End of function Animate_SpriteIrregularDelay
