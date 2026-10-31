; Owner: objects/checkpoint/sk
; Responsibility: The original three star-post star graphics streams, retaining the documented original size defect
; Source provenance and ranges: config/reconstruction/source_layout.json
; [BUG]: These three files have incorrect Moduled Kosinski headers!
; The size specified in the header reflects the compressed data ($60)
; rather than the uncompressed data ($C0). This causes only the first 3
; out of 6 tiles to be loaded from each file. This can be easily seen
; by pausing after activating a starpost, as the corner of the larger
; star sprite will be the wrong color due to using leftover tile data
; in VRAM
ArtKosM_StarPost_Stars1:
                binclude "data/General/Sprites/Starpost/Starpost Stars 1.kosm"
                even
ArtKosM_StarPostStars2:
                binclude "data/General/Sprites/Starpost/Starpost Stars 2.kosm"
                even
ArtKosM_StarPostStars3:
                binclude "data/General/Sprites/Starpost/Starpost Stars 3.kosm"
                even
