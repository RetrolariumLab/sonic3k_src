; Owner: game/level/sk
; Responsibility: Flying Battery, Mushroom Hill and Sandopolis object and ring placements with physical list terminators
; Source provenance and ranges: config/reconstruction/source_layout.json
SpriteTerminat9:
                dc.w    $FFFF, 0, 0
MHZ1_Sprites:
                binclude "data/Levels/MHZ/Object Pos/1.bin"
                even
MHZ2_Sprites:
                binclude "data/Levels/MHZ/Object Pos/2.bin"
                even
MHZ1_Rings:
                binclude "data/Levels/MHZ/Ring Pos/1.bin"
                even
MHZ2_Rings:
                binclude "data/Levels/MHZ/Ring Pos/2.bin"
                even
SpriteTerminatA:
                dc.w    $FFFF, 0, 0
SOZ1_Sprites:
                binclude "data/Levels/SOZ/Object Pos/1.bin"
                even
SOZ2_Sprites:
                binclude "data/Levels/SOZ/Object Pos/2.bin"
                even
SOZ1_Rings:
                binclude "data/Levels/SOZ/Ring Pos/1.bin"
                even
SOZ2_Rings:
                binclude "data/Levels/SOZ/Ring Pos/2.bin"
                even
SKLevel_SOZRockRideTrack00:
                dc.w    $A68, $13A0
                dc.w    $D00, $FFFF
SKLevel_SOZRockRideTrack01:
                dc.w    $A70, $19C0
                dc.w    $AD2, $1AF0
                dc.w    $FFFF
SKLevel_SOZRockRideTrack02:
                dc.w    $470, $1F40
                dc.w    $490, $1FA0
                dc.w    $D00, $FFFF
SKLevel_SOZRockRideTrack03:
                dc.w    $AD0, $2D80
                dc.w    $B00, $2E30
                dc.w    $D00, $FFFF
SKLevel_SOZRockRideTrack04:
                dc.w    $450, $24C0
                dc.w    $4F0, $2560
                dc.w    $D00, $FFFF
SKLevel_SOZRockRideTrack05:
                dc.w    $270, $1600
                dc.w    $2D2, $1730
                dc.w    $FFFF
SKLevel_SOZRockRideTrack06:
                dc.w    $A68, $2740
                dc.w    $A80, $2838
                dc.w    $D00, $FFFF
SKLevel_SOZRockRideTrack07:
                dc.w    $5EC, $47F0
                dc.w    $FFFF
SKLevel_SOZRockRideTrack08:
                dc.w    $4E0, $4620
                dc.w    $600, $FFFF
SKLevel_SOZRockRideTrack09:
                dc.w    $630,  $460
                dc.w    $652,  $4F0
                dc.w    $FFFF
SKLevel_SOZRockRideTrack10:
                dc.w    $6F0, $2D70
                dc.w    $FFFF
SKSOZRockRide_UnusedTrackSlots:
                dc.w    $FFFF
