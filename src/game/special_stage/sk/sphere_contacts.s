; Owner: game/special_stage/sk
; Responsibility: Sphere and ring contact responses, ring enclosure conversion, emerald completion and private geometry/mapping tables
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
Pal_SStage_Emeralds:
                binclude "data/General/Special Stage/Palettes/Emeralds.bin"
                even

; =============== S U B R O U T I N E =======================================

sub_9D5E:
                move.w  (Special_stage_X_pos).w,d0
                sub.w   (Special_stage_prev_X_pos).w,d0
                btst    #6,(Special_stage_angle).w
                bne.s   loc_9D76
                move.w  (Special_stage_Y_pos).w,d0
                sub.w   (Special_stage_prev_Y_pos).w,d0

loc_9D76:
                tst.b   (Special_stage_angle).w
                bmi.s   loc_9D7E
                neg.w   d0

loc_9D7E:
                asr.w   #2,d0
                add.w   d0,(V_scroll_value_BG).w
                moveq   #0,d1
                move.b  (Special_stage_angle).w,d1
                asl.w   #2,d1
                move.w  d1,(H_scroll_buffer+2).w
                move.w  (Special_stage_X_pos).w,(Special_stage_prev_X_pos).w
                move.w  (Special_stage_Y_pos).w,(Special_stage_prev_Y_pos).w
                rts
; End of function sub_9D5E

; =============== S U B R O U T I N E =======================================

Animate_SSRings:
                lea     (SStage_extra_sprites+$07).w,a1
                subq.b  #1,(Rings_frame_timer).w
                bpl.s   loc_9DC2
                move.b  #7,(Rings_frame_timer).w
                addi.b  #$10,(Rings_frame).w
                cmpi.b  #$30,(Rings_frame).w
                blo.s   loc_9DC2
                move.b  #0,(Rings_frame).w

loc_9DC2:
                move.b  (Rings_frame).w,anim(a1)
                rts
; End of function Animate_SSRings

; =============== S U B R O U T I N E =======================================

Find_SStageCollisionResponseSlot:
                lea     (SStage_collision_response_list).w,a2
                move.w  #$20-1,d0

loc_9DD2:
                tst.b   (a2)
                beq.s   locret_9DDC
                addq.w  #8,a2
                dbf     d0,loc_9DD2

locret_9DDC:
                rts
; End of function Find_SStageCollisionResponseSlot

; =============== S U B R O U T I N E =======================================

Touch_SSSprites:
                lea     (SStage_collision_response_list).w,a0
                move.w  #$20-1,d7

loc_9DE6:
                moveq   #0,d0
                move.b  (a0),d0
                beq.s   loc_9DF4
                lsl.w   #2,d0
                movea.l off_9DFC-4(pc,d0.w),a1
                jsr     (a1)

loc_9DF4:
                addq.w  #8,a0
                dbf     d7,loc_9DE6
                rts
; End of function Touch_SSSprites

; ---------------------------------------------------------------------------
off_9DFC:
                dc.l    Touch_SSSprites_Ring
                dc.l    Touch_SSSprites_BlueSphere
; ---------------------------------------------------------------------------

Touch_SSSprites_Ring:
                subq.b  #1,2(a0)
                bpl.s   locret_9E2C
                move.b  #5,2(a0)
                moveq   #0,d0
                move.b  3(a0),d0
                addq.b  #1,3(a0)
                movea.l 4(a0),a1
                move.b  byte_9E2E(pc,d0.w),d0
                move.b  d0,(a1)
                bne.s   locret_9E2C
                clr.l   (a0)
                clr.l   4(a0)

locret_9E2C:
                rts
; ---------------------------------------------------------------------------
byte_9E2E:
                dc.b    6,   7,   8,   9,   0
                even
; ---------------------------------------------------------------------------

Touch_SSSprites_BlueSphere:
                subq.b  #1,2(a0)
                bpl.s   locret_9E86
                move.b  #9,2(a0)
                movea.l 4(a0),a1
                cmpi.b  #2,(a1)
                bne.s   loc_9E62
                bsr.w   Decrement_BlueSphere_Count
                move.b  #$A,(a1)
                bsr.s   Sphere_To_Rings
                beq.s   locret_9E60
                move.b  #4,(a1)
                clr.l   (a0)
                clr.l   4(a0)

locret_9E60:
                rts
; ---------------------------------------------------------------------------

loc_9E62:
                move.b  #0,2(a0)
                move.w  (Special_stage_X_pos).w,d0
                or.w    (Special_stage_Y_pos).w,d0
                andi.w  #$E0,d0
                beq.s   locret_9E86
                cmpi.b  #$A,(a1)
                bne.s   loc_9E80
                move.b  #1,(a1)

loc_9E80:
                clr.l   (a0)
                clr.l   4(a0)

locret_9E86:
                rts

; =============== S U B R O U T I N E =======================================

Decrement_BlueSphere_Count:
                move.w  d0,-(sp)
                move.b  #-1,(Special_stage_sphere_HUD_flag).w  ; Set flag to update HUD
                subq.w  #1,(Special_stage_spheres_left).w  ; Decrement Count
                bne.s   loc_9E9C                        ; If Count is 0
                move.b  #1,(Special_stage_clear_routine).w  ; Set flag to clear special stage

loc_9E9C:
                move.w  (sp)+,d0
                rts
; End of function Decrement_BlueSphere_Count

; =============== S U B R O U T I N E =======================================

sub_9EA0:
                lea     (SStage_layout_buffer+$100).w,a3
                moveq   #0,d1
                move.w  #$400-1,d0

loc_9EAA:
                cmpi.b  #2,(a3)+
                bne.s   loc_9EB2
                addq.w  #1,d1

loc_9EB2:
                dbf     d0,loc_9EAA
                move.w  d1,(Special_stage_spheres_left).w
                rts
; End of function sub_9EA0

; =============== S U B R O U T I N E =======================================

; Arguments
; a1: Address of Position in Map
; Mutates:
; d0-d6/a2-a5
; Returns:
; d1/CCR: 1 is transformed. 0 otherwise
;
; First Calls Find_Red_Sphere_Loop to:
; Check if there are and loops of red spheres
; Turn 1 blue sphere per loop to a ring
; Add the position of those rings to the ring queue
;
; If the queue is empty, return 0
;
; The use a breath first search algorithm to using the queue
; to fill out each area of blue spheres, turning them into
; rings and adding them to the queue, and updating the HUD
;
; Lastly check all neighbors of the queue for red spheres
; that can be turning into rings, and do so
;
; Play the sfx_RingLoss sfx and return 1
Sphere_To_Rings:
                lea     (SStage_layout_buffer+$100).w,a2
                move.l  a1,d5
                sub.l   a2,d5                           ; position index = position address - start address
                bsr.s   Find_Red_Sphere_Loop            ; returns ring queue end in a5
                moveq   #0,d6
                move.l  a5,d1                           ; ring queue end (from Find_Red_Sphere_Loop)
                lea     (SStage_blue_sphere_to_ring_queue).w,a4  ; ring queue start
                sub.l   a4,d1                           ; remaining entries count = end - start
                beq.s   locret_9F42                     ; if empty queue, return 0

; For each ring in the queue, find its blue sphere neighbors, then
; turn those blue spheres into rings, and add those positions
; to the queue
Blue_To_Ring_Next_Ring_B:
                move.w  (a4)+,d5                        ; read ring from queue
                lea     (SStage_8_Directions).l,a3      ; load directions table
                move.w  #8-1,d0

Blue_To_Ring_Next_Direction_B:                          ; Loop[neighbors of ring]
                move.w  (a3)+,d2                        ; get next direction
                add.w   d5,d2                           ; neighbor = ring + direction
                andi.w  #$3FF,d2                        ; truncate to map size
                cmpi.b  #2,(a2,d2.w)                    ; If the neighbor is Blue
                bne.s   Blue_To_Ring_Continue_B
                bsr.w   Decrement_BlueSphere_Count
                move.b  #4,(a2,d2.w)                    ; Change to ring
                move.w  d2,(a5)+                        ; Add to queue
                addq.w  #2,d1                           ; increment remaining entries count

Blue_To_Ring_Continue_B:
                dbf     d0,Blue_To_Ring_Next_Direction_B  ; Loop[neighbors of ring]:end
                subq.w  #2,d1                           ; decrement remaining entries count
                bne.s   Blue_To_Ring_Next_Ring_B        ; If more rings in queue, get next ring
                move.l  a5,d1                           ; reset queue end
                lea     (SStage_blue_sphere_to_ring_queue).w,a4  ; reset queue start
                sub.l   a4,d1                           ; reset remaining entries count
                beq.s   locret_9F42                     ; if empty queue (how?), return 0

; For each ring in the queue, find its red sphere neighbors, then
; turn those red spheres into rings
Blue_To_Ring_Next_Ring_R:
                move.w  (a4)+,d5                        ; read ring from queue
                lea     (SStage_8_Directions).l,a3      ; load directions table
                move.w  #8-1,d0

Blue_To_Ring_Next_Direction_R:                          ; Loop[neighbors of ring]
                move.w  (a3)+,d2                        ; get next direction
                add.w   d5,d2                           ; neighbor = ring + direction
                andi.w  #$3FF,d2                        ; truncate to map size
                cmpi.b  #1,(a2,d2.w)                    ; If the current neighbor is Red
                bne.s   Blue_To_Ring_Continue_R
                move.b  #4,(a2,d2.w)                    ; Change to ring

Blue_To_Ring_Continue_R:
                dbf     d0,Blue_To_Ring_Next_Direction_R  ; Loop[neighbors or ring]:end
                subq.w  #2,d1                           ; decrement remaining entries count
                bne.s   Blue_To_Ring_Next_Ring_R
                moveq   #signextendB(sfx_RingLoss),d0   ; load and play Ring Loss SFX
                jsr     (Play_SFX).l
                moveq   #1,d1                           ; Return 1

locret_9F42:
                rts
; End of function Sphere_To_Rings

; =============== S U B R O U T I N E =======================================

; Arguments
; d5: Index in Map Of Touched Sphere
; a2: Address of the Special Stage Map
; Mutates
; d0-d4/d6/a3-a5
; Returns:
; a5: 1 past the end of ring queue
;
; First checks if the touched sphere has any blue sphere neighbors,
; while also turning any touched neighbors into red spheres
; If there are none, return early
;
; Next check if the contiguous vertical and horizontal span
; of spheres and rings starting from the touched sphere is
; at least 3 spheres long each
; Otherwise, return early
;
; Then use a depth first search traversal algorithm to walk
; a path of red spheres to find valid loops. For each loop
; try to find an enclosed blue sphere. If one is found,
; turn it into a ring, and add its index to the ring queue
; and increment the queue pointer
Find_Red_Sphere_Loop:
                lea     (SStage_blue_sphere_to_ring_queue).w,a5  ; Load special stage map pointer
                lea     (SStage_8_Directions).l,a3      ; Load directions pointer
                moveq   #0,d2                           ; Blue sphere counter
                move.w  #8-1,d0

Red_Loop_Check_Neighbors:                               ; Loop[neighbors of touched]
                move.w  (a3)+,d1                        ; get next direction
                add.w   d5,d1                           ; neighbor = touched + direction
                andi.w  #$3FF,d1                        ; truncate to map size
                cmpi.b  #$A,(a2,d1.w)                   ; If neighbor is $A (TOUCHED)
                bne.s   loc_9F6A
                move.b  #1,(a2,d1.w)                    ; change to RedSphere

loc_9F6A:
                cmpi.b  #2,(a2,d1.w)                    ; If neighbor is Blue
                bne.s   loc_9F74
                addq.w  #1,d2                           ; increment count

loc_9F74:
                dbf     d0,Red_Loop_Check_Neighbors     ; Loop[neighbors of touched]:end
                tst.w   d2                              ; If there are no blue sphere neighbors
                beq.w   locret_A076                     ; return
                moveq   #0,d2                           ; Horizontal span length
                move.w  d5,d1                           ; scanning index
                moveq   #$10-1,d3

Red_Loop_Count_Horizontal_Left:                         ; Loop[left until empty (max 16)]
                addq.w  #1,d2                           ; increment horizontal span length
                addi.w  #-1,d1                          ; move index left
                tst.b   (a2,d1.w)                       ; If index is empty (map[index] == 0)
                beq.s   loc_9F94                        ; break
                dbf     d3,Red_Loop_Count_Horizontal_Left  ; Loop[left until empty (max 16)]:end

loc_9F94:
                move.w  d5,d1                           ; scanning index
                moveq   #$10-1,d3

Red_Loop_Count_Horizontal_Right:                        ; Loop[right until empty (max 16)]
                addq.w  #1,d2                           ; increment horizontal span length
                addi.w  #1,d1                           ; move index right
                tst.b   (a2,d1.w)                       ; If index is empty (map[index] == 0)
                beq.s   loc_9FA8                        ; break
                dbf     d3,Red_Loop_Count_Horizontal_Right  ; Loop[right until empty (max 16)]:end

loc_9FA8:
                cmpi.w  #4,d2                           ; If horizontal span is less than 3 (< 4 because touched is double counted)
                blo.w   locret_A076                     ; then return
                moveq   #0,d2                           ; Vertical span length
                move.w  d5,d1                           ; scanning index
                moveq   #$10-1,d3

Red_Loop_Count_Vertically_Up:                           ; Loop[up until empty (max 16)]
                addq.w  #1,d2                           ; increment vertical span length
                addi.w  #-$20,d1                        ; move index up
                tst.b   (a2,d1.w)                       ; If index is empty (map[index] == 0)
                beq.s   loc_9FC6                        ; break
                dbf     d3,Red_Loop_Count_Vertically_Up  ; Loop[up until empty (max 16)]:end

loc_9FC6:
                move.w  d5,d1                           ; scanning index
                moveq   #$10-1,d3

Red_Loop_Count_Vertically_Down:                         ; Loop[down until empty (max 16)]
                addq.w  #1,d2                           ; increment vertical span length
                addi.w  #$20,d1                         ; move index up
                tst.b   (a2,d1.w)                       ; If index is empty (map[index] == 0)
                beq.s   loc_9FDA                        ; break
                dbf     d3,Red_Loop_Count_Vertically_Down  ; Loop[down until empty (max 16)]:end

loc_9FDA:
                cmpi.w  #4,d2                           ; If vertical span is less than 3 (< 4 because touched is double counted)
                blo.w   locret_A076                     ; then return
                lea     (SStage_red_sphere_dfs_walk_stack).w,a4
                lea     (SStage_4_Directions).l,a3      ; Load Directions Pointer
                moveq   #0,d6                           ; Walk Stack Size
                moveq   #0,d3                           ; Direction Index Lower Bound
                moveq   #6,d4                           ; Direction Index
                add.w   d3,d4
                move.w  d5,d0                           ; Current Walk Position

Red_Loop_Find_Next:
                move.w  (a3,d4.w),d1                    ; Next Direction = directions[direction index]
                add.w   d0,d1                           ; Next Candidate = current position + next direction
                andi.w  #$3FF,d1                        ; truncate to map size
                move.b  (a2,d1.w),d2                    ; load map entry at candidate position
                cmpi.b  #$8A,d2                         ; If candidate sphere is $8A (Processed + Touched)
                beq.s   Red_Loop_Processes_Loop         ; Loop found. Process Loop
                cmpi.b  #1,d2                           ; If candidate is not a Red Sphere
                bne.s   Red_Loop_Decrement              ; Decrement direction Index
                cmpi.w  #2,d6                           ; If walk stack size < 2
                blo.s   Red_Loop_Push_Stack             ; Push current state to walk stack
                move.w  d1,d2
                sub.w   -6(a4),d2                       ; Difference between candidate position and position at walk_stack[-2]
                cmpi.w  #-1,d2                          ; If the difference is one square away in any direction
                beq.s   Red_Loop_Decrement              ; Candidate is not part of the loop. Decrement direction Index
                cmpi.w  #1,d2                           ; Else Push current state to walk stack
                beq.s   Red_Loop_Decrement
                cmpi.w  #$20,d2                         ; [S-1] -> [Current]
                beq.s   Red_Loop_Decrement              ; ^          V
                cmpi.w  #-$20,d2                        ; [S-2]    [Candidate]
                beq.s   Red_Loop_Decrement

Red_Loop_Push_Stack:
                ori.b   #$80,(a2,d0.w)                  ; Mark current position as being processed
                move.b  d3,(a4)+                        ; Push direction index to walk stack
                move.b  d4,(a4)+                        ; Push direction index lower bound to walk stack
                move.w  d0,(a4)+                        ; Push current position to walk stack
                addq.w  #1,d6                           ; Increment walk stack size

; For subsequent steps of a walk, you don't want the next position to consider making a complete
; 180 degree turn. The following code is used to limit the new position's range of movement directions
; It's done by defining the lower bound index as one less than the current direction (looping to index 3 if -1),
; and by defining the upper bound index as two more than the new lower bound,
;
; As an example, given that the 4-way direction table is [L, U, R, D, L, U],
; let's say the direction from current to candidate is Right (index 2)
; Then the new lower bound index would be 1, and the new upper bound would be 3
; which is the range [U, R, D], which excludes going LEFT i.e. turning 180 degrees
;
; These offsets are multiplied by 2 as each direction is 2 bytes long
                move.w  d4,d3
                subq.w  #2,d3
                andi.w  #6,d3                           ; lower_bound = (index - 2) & 6
                move.w  #4,d4
                add.w   d3,d4                           ; index = 4 + lower_bound
                move.w  d1,d0                           ; current position = candidate position
                bra.s   Red_Loop_Find_Next
; ---------------------------------------------------------------------------

Red_Loop_Decrement:
                subq.w  #2,d4                           ; Decrement direction index
                cmp.w   d3,d4                           ; If index >= lower bound,
                bge.s   Red_Loop_Find_Next              ; check next candidate
        ; Else this position is done, pop the stack to get previous

Red_Loop_Pop_Stack:
                moveq   #0,d3
                moveq   #0,d4
                move.w  -(a4),d0                        ; Pop current position from walk stack
                move.b  -(a4),d4                        ; Pop direction index from walk stack
                move.b  -(a4),d3                        ; Pop direction index lower bound from walk stack
                subq.w  #1,d6                           ; Decrement walk stack size
                bcs.s   locret_A076                     ; If walk stack was empty,
        ; No more loops to find. Return
                andi.b  #$7F,(a2,d0.w)                  ; Unmark current position as being processed
                subq.w  #2,d4                           ; Decrement direction index
                cmp.w   d3,d4                           ; If index >= lower bound,
                bge.s   Red_Loop_Find_Next              ; check next candidate
                bra.s   Red_Loop_Pop_Stack              ; Else this position is done, pop the stack to get previous
; ---------------------------------------------------------------------------

locret_A076:
                rts
; ---------------------------------------------------------------------------

; Once a loop has been detected, this code finds which direction
; is "inside" the loop, and checks if there is a blue sphere
; which would then be turned into a ring, and whose position
; is added to the ring queue

; To find the "inside" direction, rewalk the red sphere path
; keeping track of the direction of each step
; Once you find a direction that is different from the initial direction,
; then apply that directional offset to either the touched
; sphere, or the first step of the walk, depending on if the
; touched sphere is at a corner

; [R] [R] [R] [T]<[R] [R]
; V
; [T]>[B] [R] [R]>[B] [R]
; V   V
; [R] [B] [R] [R] [B] [R]
; V   V
; [R]>[R] [R] [R]>[R] [R]
Red_Loop_Processes_Loop:
                movem.l d0/d3-d4/d6/a4,-(sp)
                sub.w   d5,d0                           ; Direction (start -> last walk)
                move.w  d0,d4
                neg.w   d4                              ; Final Direction of loop (last walk -> start)
                lea     (SStage_red_sphere_dfs_walk_stack+6).w,a4  ; &WalkPath[1].position
                move.w  (a4),d2                         ; Second Position of Path
                sub.w   d5,d2                           ; Initial direction
                move.w  d5,d3                           ; Walk position head (starts at touched)

Red_Loop_Walk_Forward:
                move.w  (a4)+,d0                        ; Next step of walk (starts at second)
                addq.w  #2,a4
                sub.w   d3,d0                           ; Direction from walk position to next step
                cmp.w   d2,d0                           ; If next direction != initial direction
                bne.s   Red_Loop_Direction_Changed      ; break
                add.w   d0,d3                           ; Otherwise move walk position forward
                bra.s   Red_Loop_Walk_Forward
; ---------------------------------------------------------------------------

Red_Loop_Direction_Changed:
        ; Corner Check
                cmp.w   d4,d0                           ; If new direction != final direction
                beq.s   Red_Loop_Blue_Check
                cmp.w   d4,d2                           ; and initial direction != final direction
                beq.s   Red_Loop_Blue_Check
                add.w   d2,d0                           ; add initial direction to new direction

Red_Loop_Blue_Check:
                add.w   d5,d0                           ; Sphere to check (touched position + new direction)
                cmpi.b  #2,(a2,d0.w)                    ; If checked sphere is Blue
                beq.s   Red_Loop_Blue_To_Ring           ; Turn into ring
                cmpi.b  #4,(a2,d0.w)                    ; Else return to DFS walk
                beq.s   Red_Loop_Return_To_DFS
                bra.s   Red_Loop_Return_To_DFS
; ---------------------------------------------------------------------------

Red_Loop_Blue_To_Ring:
                bsr.w   Decrement_BlueSphere_Count
                move.b  #4,(a2,d0.w)                    ; Turn blue sphere into a ring
                move.w  d0,(a5)+                        ; and add ring position to ring queue

Red_Loop_Return_To_DFS:
                movem.l (sp)+,d0/d3-d4/d6/a4
                bra.s   Red_Loop_Decrement
; End of function Find_Red_Sphere_Loop

; ---------------------------------------------------------------------------
SStage_8_Directions:
                dc.w    -$21
                dc.w    -$20
                dc.w    -$1F
                dc.w    -1
                dc.w    1
                dc.w    $1F
                dc.w    $20
                dc.w    $21
SStage_4_Directions:
                dc.w    -1
                dc.w    -$20
                dc.w    1
                dc.w    $20
                dc.w    -1
                dc.w    -$20

; =============== S U B R O U T I N E =======================================

Load_SSSprite_Mappings:
                lea     (SStage_extra_sprites).w,a1
                lea     (MapPtr_A10A).l,a0
                moveq   #bytesToXcnt($70,8),d1

loc_A0F2:
                move.l  (a0)+,(a1)+
                move.l  (a0)+,(a1)+
                dbf     d1,loc_A0F2
                lea     (SStage_collision_response_list).w,a1
                move.w  #bytesToLcnt($100),d1

loc_A102:
                clr.l   (a1)+
                dbf     d1,loc_A102
                rts
; End of function Load_SSSprite_Mappings

; ---------------------------------------------------------------------------
MapPtr_A10A:
                dc.l    Map_SStageSphere
                dc.w    make_art_tile(ArtTile_SStage_Sphere,0,1), $0000
                dc.l    Map_SStageSphere
                dc.w    make_art_tile(ArtTile_SStage_Sphere,0,1), $0000
                dc.l    Map_SStageSphere
                dc.w    make_art_tile(ArtTile_SStage_Sphere,2,1), $0000
                dc.l    Map_SStageSphere
                dc.w    make_art_tile(ArtTile_SStage_Sphere,1,1), $0000
                dc.l    Map_SStageRing
                dc.w    make_art_tile(ArtTile_SStage_Ring,2,1), $0000
                dc.l    Map_SStageSphere
                dc.w    make_art_tile(ArtTile_SStage_Sphere,3,1), $0000
                dc.l    Map_SStageRing
                dc.w    make_art_tile(ArtTile_SStage_Ring,2,1), $8030
                dc.l    Map_SStageRing
                dc.w    make_art_tile(ArtTile_SStage_Ring,2,1), $8031
                dc.l    Map_SStageRing
                dc.w    make_art_tile(ArtTile_SStage_Ring,2,1), $8032
                dc.l    Map_SStageRing
                dc.w    make_art_tile(ArtTile_SStage_Ring,2,1), $8033
                dc.l    Map_SStageSphere
                dc.w    make_art_tile(ArtTile_SStage_Sphere,2,1), $0000
                dc.l    Map_SStageChaosEmerald
                dc.w    make_art_tile(ArtTile_SStage_Ring,3,1), $0000
                dc.l    Map_SStageSphere
                dc.w    make_art_tile(ArtTile_SStage_Sphere,2,1), $0000
                dc.l    Map_SStageSuperEmerald
                dc.w    make_art_tile(ArtTile_SStage_Ring,3,1), $0000
; ---------------------------------------------------------------------------
; unused
                ext.l   d1
                lsl.l   #8,d1
                divs.w  d0,d1
                ext.l   d2
                lsl.l   #8,d2
                divs.w  d0,d2
                rts

; =============== S U B R O U T I N E =======================================

sub_A188:
                swap    d0
                move.w  d1,d3
                move.w  d2,d4
                move.w  (SStage_scalar_result_2).w,d0
                muls.w  d0,d3
                muls.w  d0,d4
                move.w  (SStage_scalar_result_2+2).w,d0
                muls.w  d0,d1
                muls.w  d0,d2
                sub.l   d4,d1
                add.l   d1,d1
                add.l   d1,d1
                swap    d1
                add.l   d3,d2
                add.l   d2,d2
                add.l   d2,d2
                swap    d2
                swap    d0
                rts
; End of function sub_A188

; =============== S U B R O U T I N E =======================================

sub_A1B2:
                swap    d2
                move.w  d0,d3
                move.w  d1,d4
                move.w  (SStage_scalar_result_1).w,d2
                muls.w  d2,d3
                muls.w  d2,d4
                move.w  (SStage_scalar_result_1+2).w,d2
                muls.w  d2,d0
                muls.w  d2,d1
                sub.l   d4,d0
                add.l   d0,d0
                add.l   d0,d0
                swap    d0
                add.l   d3,d1
                add.l   d1,d1
                add.l   d1,d1
                swap    d1
                swap    d2
                rts
; End of function sub_A1B2

; =============== S U B R O U T I N E =======================================

sub_A1DC:
                swap    d1
                move.w  d0,d3
                move.w  d2,d4
                move.w  (SStage_scalar_result_0).w,d1
                muls.w  d1,d3
                muls.w  d1,d4
                move.w  (SStage_scalar_result_0+2).w,d1
                muls.w  d1,d0
                muls.w  d1,d2
                sub.l   d4,d0
                add.l   d0,d0
                add.l   d0,d0
                swap    d0
                add.l   d3,d2
                add.l   d2,d2
                add.l   d2,d2
                swap    d2
                swap    d1
                rts
; End of function sub_A1DC

; =============== S U B R O U T I N E =======================================

sub_A206:
                swap    d1
                move.w  d0,d3
                move.w  d2,d4
                move.w  (SStage_scalar_result_3).w,d1
                muls.w  d1,d3
                muls.w  d1,d4
                move.w  (SStage_scalar_result_3+2).w,d1
                muls.w  d1,d0
                muls.w  d1,d2
                sub.l   d4,d0
                add.l   d0,d0
                add.l   d0,d0
                swap    d0
                add.l   d3,d2
                add.l   d2,d2
                add.l   d2,d2
                swap    d2
                swap    d1
                rts
; End of function sub_A206

; =============== S U B R O U T I N E =======================================

sub_A230:
                add.w   d0,d0
                addi.w  #$80,d0
                andi.w  #$1FE,d0
                move.w  ScalarTable2(pc,d0.w),d1
                subi.w  #$80,d0
                andi.w  #$1FE,d0
                move.w  ScalarTable2(pc,d0.w),d0
                rts
; End of function sub_A230

; =============== S U B R O U T I N E =======================================

GetScalars2:
                add.w   d0,d0
                andi.w  #$1FE,d0
                move.w  ScalarTable2(pc,d0.w),(a1)+
                addi.w  #$80,d0
                andi.w  #$1FE,d0
                move.w  ScalarTable2(pc,d0.w),(a1)+
                rts
; End of function GetScalars2

; ---------------------------------------------------------------------------
ScalarTable2:
                binclude "data/General/Special Stage/Scalars.bin"
                even
Map_SStageSphere:
                include "src/game/special_stage/shared/mappings/sphere.s"
Map_SStageRing:
                include "src/game/special_stage/shared/mappings/ring.s"
Map_SStageChaosEmerald:
                include "src/game/special_stage/shared/mappings/chaos_emerald.s"
Map_SStageSuperEmerald:
                include "src/game/special_stage/shared/mappings/super_emerald.s"
; ---------------------------------------------------------------------------

locret_A85C:
                rts
; ---------------------------------------------------------------------------
