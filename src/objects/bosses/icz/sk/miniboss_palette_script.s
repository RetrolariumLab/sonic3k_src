; Owner: objects/bosses/icz/sk
; Responsibility: IceCap miniboss palette script pointers, header, colour frames and script terminator
; Source provenance and ranges: config/reconstruction/source_layout.json
word_719FA:     palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_4+$02, 10, 2-1
                .data:  palscriptdata 8, $EEC, $CC6, $C80, $C60, $C40, $A40, $820, $620, $200, $600
                palscriptdata 8, $EEC, $CC6, $C82, $C80, $C40, $A40, $820, $820, $200, $600
                palscriptdata 8, $EEC, $CC8, $E82, $C82, $C40, $C40, $A20, $820, $200, $600
                palscriptdata 8, $EEE, $EC8, $EA4, $C82, $C60, $C40, $A20, $A20, $400, $600
                palscriptdata 8, $EEE, $EC8, $EA4, $E82, $C60, $C40, $C20, $A20, $400, $600
                palscriptdata 8, $EEE, $EC8, $EA6, $E82, $C62, $C40, $C20, $C20, $600, $800
                palscriptdata 8, $EEE, $EE8, $EC6, $EA2, $C80, $C60, $C20, $C20, $600, $A00
                palscriptdata 8, $EEE, $EEA, $EC6, $EA4, $C82, $C60, $C40, $C20, $800, $C00
                palscriptdata 8, $EEE, $EEA, $EC8, $EA4, $C82, $C60, $C40, $E20, $A00, $C00
                palscriptdata 8, $EEE, $EEA, $EC8, $EA4, $C82, $C60, $C40, $E20, $A00, $E00
                palscriptrun

word_71AE6:     palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                .data:  palscriptdata 8, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr2
                .headr2: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 6, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr3
                .headr3: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 4, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr4
                .headr4: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 2, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr5
                .headr5: palscripthdr Normal_palette_line_2+$14, 1, 0
                palscriptdata 1, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptrept

word_71B52:     palscriptptr .header, .data
                dc.w    0
                .header: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                .data:  palscriptdata 2, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr2
                .headr2: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 4, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr3
                .headr3: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 6, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr4
                .headr4: palscripthdr Normal_palette_line_2+$14, 1, 3-1
                palscriptdata 8, $222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptloop .headr5
                .headr5: palscripthdr Normal_palette_line_2+$14, 1, 5-1
                palscriptdata 10,$222
                palscriptdata 1, $C22
                palscriptdata 1, $EE0
                palscriptrun

; ---------------------------------------------------------------------------
word_71BBE:
                dc.w    $2F8,  $6F8, $4340, $4490
word_71BC6:
                dc.w    $5F8,  $5F8, $4390, $4390
