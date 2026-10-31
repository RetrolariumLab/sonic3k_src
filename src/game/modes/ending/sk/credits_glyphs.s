; Owner: game/modes/ending/sk
; Responsibility: Credits glyph plane mapping and NTSC or PAL scroll delay and speed records for standalone or lock-on endings
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
CreditsText_PlaneMap:
                dc.w    0,  $800,     1,     2          ; A
                dc.w    3,     4,     5,     6          ; B
                dc.w    7,     8,     9,    $A          ; C
                dc.w    3,  $807,    $B,  $809          ; D
                dc.w    3,    $C,     5,    $D          ; E
                dc.w    3,    $C,    $E,    $F          ; F
                dc.w    7,     8,     9,   $10          ; G
                dc.w    $11,  $811,    $E, $180B        ; H
                .LetterI: dc.w    $11,   $12,     0,     0  ; I
                dc.w    $13,  $811,   $14,   $15        ; J
                dc.w    $16,   $17,   $18,   $19        ; K
                dc.w    $11,   $13,    $B,   $1A        ; L
                dc.w    $1B,   $1C,   $1D,   $1E        ; M
                dc.w    $1B,  $811,   $1D,   $1F        ; N
                dc.w    7,  $807,     9,  $809          ; O
                dc.w    $20,   $21,   $22,   $23        ; P
                dc.w    7,  $807,     9,   $24          ; Q
                dc.w    $20,   $21,   $25,   $26        ; R
                dc.w    $821,    $C,   $27,     6       ; S
                dc.w    $28,   $29,   $2A,   $2B        ; T
                dc.w    $11,  $811,  $815,   $15        ; U
                dc.w    $2C,  $82C,   $2D,  $82D        ; V
                dc.w    $2E,  $811,   $2F,   $30        ; W
                dc.w    $31,  $831,   $32,  $832        ; X
                dc.w    $31,   $33,   $2A,   $2B        ; Y
                dc.w    $80C,   $34,   $35,   $36       ; Z
                .Period: dc.w    $13,   $37             ;
                .LeftBracket: dc.w    $38, $1038        ; (
                .RightBracket: dc.w   $838, $1838       ; )
                .Ampersand: dc.w    $39,   $3A,   $3B,   $3C  ; &
                .Exclamation: dc.w   $812,   $3D        ; !
                .QuestionMark: dc.w  $180A,   $3E,   $3F,   $40  ; ?
CreditsText_ScrollDelay:
; S&K NTSC     None  Chaos Emeralds  Super Emeralds
                dc.w    13*60  +0,      11*60 +30,      13*60  +0  ; Sonic
                dc.w    12*60 +30,      12*60 +30,      12*60 +30  ; Tails (unused)
                dc.w    2*60 +45,       2*60  +0,       2*60  +0  ; Knuckles
; S&K PAL      None  Chaos Emeralds  Super Emeralds
                dc.w    11*50  +0,       8*50 +48,      11*50  +0  ; Sonic
                dc.w    1*50 +10,       1*50 +10,       1*50 +10  ; Tails (unused)
                dc.w    2*50 +35,       3*50  +0,       2*50  +0  ; Knuckles
; S3K NTSC     None  Chaos Emeralds  Super Emeralds
                dc.w    12*60 +30,      11*60  +0,              0  ; Sonic
                dc.w    12*60 +30,      12*60 +30,              0  ; Tails
                dc.w    2*60 +45,       2*60  +0,       2*60  +0  ; Knuckles
; S3K PAL      None  Chaos Emeralds  Super Emeralds
                dc.w    10*50 +20,       8*50 +13,              0  ; Sonic
                dc.w    10*50 +20,      10*50 +20,              0  ; Tails
                dc.w    2*50  +0,       3*50  +0,       3*50  +0  ; Knuckles
CreditsText_ScrollSpeed:
; S&K NTSC     None  Chaos Emeralds  Super Emeralds
                dc.w    $C3,            $C3,            $C3  ; Sonic
                dc.w    $100,           $100,           $100  ; Tails (unused)
                dc.w    $BD,            $B1,            $B1  ; Knuckles
; S&K PAL      None  Chaos Emeralds  Super Emeralds
                dc.w    $E8,            $E8,           $100  ; Sonic
                dc.w    $100,           $100,           $100  ; Tails (unused)
                dc.w    $E5,            $D6,           $100  ; Knuckles
; S3K NTSC     None  Chaos Emeralds  Super Emeralds
                dc.w    $CE,            $CE,            $CF  ; Sonic
                dc.w    $CE,            $CE,            $CD  ; Tails
                dc.w    $C8,            $BC,            $BC  ; Knuckles
; S3K PAL      None  Chaos Emeralds  Super Emeralds
                dc.w    $F5,            $F5,            $FD  ; Sonic
                dc.w    $F5,            $F5,            $FB  ; Tails
                dc.w    $F2,            $E2,            $E2  ; Knuckles
