; Data owner: objects/shared/hud_icon
; Provenance and source range: config/reconstruction/source_layout.json
Map_HUD_:
                dc.w    SharedHUDMap_OrdinaryBaseFrame00-Map_HUD_
                dc.w    HUDMap_ZeroRingsBlinkFrame01-Map_HUD_
                dc.w    HUDMap_NineMinuteBlinkFrame02-Map_HUD_
                dc.w    HUDMap_BothWarningsBlinkFrame03-Map_HUD_
                dc.w    SharedHUDMap_RingOnlyBaseFrame04-Map_HUD_
                dc.w    HUDMap_RingOnlyBlinkFrame05-Map_HUD_
SharedHUDMap_OrdinaryBaseFrame00:   dc.w    $A
                dc.b    $80, $D,$20,  0,  0,  0
                dc.b    $80, $D,$20,$18,  0,$20
                dc.b    $80, $D,$20,$20,  0,$40
                dc.b    $90, $D,$20,$10,  0,  0
                dc.b    $90, $D,$20,$28,  0,$28
                dc.b    $A0, $D,$20,  8,  0,  0
                dc.b    $A0,  1,$20,  0,  0,$20
                dc.b    $A0,  9,$20,$30,  0,$30
                dc.b    $40,  5,  1, $A,  0,  0
                dc.b    $40, $D,$21, $E,  0,$10
HUDMap_ZeroRingsBlinkFrame01:   dc.w    8
                dc.b    $80, $D,$20,  0,  0,  0
                dc.b    $80, $D,$20,$18,  0,$20
                dc.b    $80, $D,$20,$20,  0,$40
                dc.b    $90, $D,$20,$10,  0,  0
                dc.b    $90, $D,$20,$28,  0,$28
                dc.b    $A0,  9,$20,$30,  0,$30
                dc.b    $40,  5,  1, $A,  0,  0
                dc.b    $40, $D,$21, $E,  0,$10
HUDMap_NineMinuteBlinkFrame02:  dc.w    9
                dc.b    $80, $D,$20,  0,  0,  0
                dc.b    $80, $D,$20,$18,  0,$20
                dc.b    $80, $D,$20,$20,  0,$40
                dc.b    $90, $D,$20,$28,  0,$28
                dc.b    $A0, $D,$20,  8,  0,  0
                dc.b    $A0,  1,$20,  0,  0,$20
                dc.b    $A0,  9,$20,$30,  0,$30
                dc.b    $40,  5,  1, $A,  0,  0
                dc.b    $40, $D,$21, $E,  0,$10
HUDMap_BothWarningsBlinkFrame03:    dc.w    7
                dc.b    $80, $D,$20,  0,  0,  0
                dc.b    $80, $D,$20,$18,  0,$20
                dc.b    $80, $D,$20,$20,  0,$40
                dc.b    $90, $D,$20,$28,  0,$28
                dc.b    $A0,  9,$20,$30,  0,$30
                dc.b    $40,  5,  1, $A,  0,  0
                dc.b    $40, $D,$21, $E,  0,$10
SharedHUDMap_RingOnlyBaseFrame04:   dc.w    5
                dc.b    $80, $D,$20,  8,  0,  0
                dc.b    $80,  1,$20,  0,  0,$20
                dc.b    $80,  9,$20,$30,  0,$30
                dc.b    $40,  5,  1, $A,  0,  0
                dc.b    $40, $D,$21, $E,  0,$10
HUDMap_RingOnlyBlinkFrame05:    dc.w    3
                dc.b    $80,  9,$20,$30,  0,$30
                dc.b    $40,  5,  1, $A,  0,  0
                dc.b    $40, $D,$21, $E,  0,$10
