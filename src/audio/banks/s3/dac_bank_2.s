; Owner: audio/s3
; Responsibility: Original dac bank 2 allocation and checked private ROM resources
; Source provenance and ranges: config/reconstruction/source_layout.json

; ---------------------------------------------------------------------------
; Dac Bank 2
; ---------------------------------------------------------------------------
DacBank2:       startDACBank

DAC_9B_Data:    include "src/audio/dac/shared/sample_9b.s"
DAC_9C_Data:    include "src/audio/dac/s3/sample_9c.s"
DAC_9D_Data:    include "src/audio/dac/s3/sample_9d.s"
DAC_9E_Data:    include "src/audio/dac/s3/sample_9e.s"
DAC_9F_Data:    include "src/audio/dac/s3/sample_9f.s"
DAC_A0_Data:    include "src/audio/dac/s3/sample_a0.s"
DAC_A1_Data:    include "src/audio/dac/s3/sample_a1.s"
DAC_A2_Data:    include "src/audio/dac/s3/sample_a2.s"
DAC_A3_Data:    include "src/audio/dac/s3/sample_a3.s"
DAC_A4_Data:    include "src/audio/dac/s3/sample_a4.s"
DAC_A5_Data:    include "src/audio/dac/s3/sample_a5.s"
DAC_A6_Data:    include "src/audio/dac/s3/sample_a6.s"
DAC_A7_Data:    include "src/audio/dac/s3/sample_a7.s"
DAC_A8_Data:    include "src/audio/dac/s3/sample_a8.s"
DAC_A9_Data:    include "src/audio/dac/s3/sample_a9.s"
DAC_AA_Data:    include "src/audio/dac/s3/sample_aa.s"

                finishBank
