; Owner: audio/sk
; Responsibility: Original dac bank allocation and checked private ROM resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; ===========================================================================
; DAC Banks
; ===========================================================================
; DAC Bank 1
; ---------------------------------------------------------------------------
DacBank1:       startDACBank

DAC_86_Data:            include "src/audio/dac/shared/sample_86.s"
DAC_81_Data:            include "src/audio/dac/shared/sample_81.s"
DAC_82_83_84_85_Data:   include "src/audio/dac/shared/sample_82_85.s"
DAC_94_95_96_97_Data:   include "src/audio/dac/shared/sample_94_97.s"
DAC_90_91_92_93_Data:   include "src/audio/dac/shared/sample_90_93.s"
DAC_88_Data:            include "src/audio/dac/shared/sample_88.s"
DAC_8A_8B_Data:         include "src/audio/dac/shared/sample_8a_8b.s"
DAC_8C_Data:            include "src/audio/dac/shared/sample_8c.s"
DAC_8D_8E_Data:         include "src/audio/dac/shared/sample_8d_8e.s"
DAC_87_Data:            include "src/audio/dac/shared/sample_87.s"
DAC_8F_Data:            include "src/audio/dac/shared/sample_8f.s"
DAC_89_Data:            include "src/audio/dac/shared/sample_89.s"
DAC_98_99_9A_Data:      include "src/audio/dac/shared/sample_98_9a.s"
DAC_9B_Data:            include "src/audio/dac/shared/sample_9b.s"
DAC_B2_B3_Data:         include "src/audio/dac/sk/sample_b2_b3.s"

                finishBank

                align   $10
