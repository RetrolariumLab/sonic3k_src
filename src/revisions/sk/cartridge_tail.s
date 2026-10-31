; Owner: revisions/sk
; Responsibility: Original fixed cartridge boundary and preserved product padding
; Source provenance and ranges: config/reconstruction/source_layout.json

; AS would automatically strip this padding if we didn't specifically declare one byte at the end
                if      (*)&(*-1)
                cnop    -1,2<<lastbit(*)
                dc.b    $FF
                else
                even
                endif

EndOfROM:
                org     $200000                         ; needed if you want to combine the ROM with Sonic 3 or Sonic 2 and the UPMEM
