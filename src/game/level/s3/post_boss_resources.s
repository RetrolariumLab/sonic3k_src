; Owner: game/level/s3
; Responsibility: Post-boss graphics load records and zone palettes for monitors, animals, explosions and capsule
; Source provenance and ranges: config/reconstruction/source_layout.json
; ---------------------------------------------------------------------------
PLC_AfterMiniboss_AIZ:  plrlistheader
                plreq   ArtTile_Monitors, ArtNem_Monitors
                plreq   ArtTile_AIZMisc2, ArtNem_AIZMisc2
                plreq   ArtTile_AIZSwingVine, ArtNem_AIZSwingVine
                plreq   ArtTile_AIZBackgroundTree, ArtNem_AIZBackgroundTree
                plreq   ArtTile_Bubbles, ArtNem_Bubbles
                plreq   ArtTile_GrayButton, ArtNem_GrayButton
                plreq   ArtTile_AIZ2FloatingPlatform, ArtNem_AIZCorkFloor2
PLC_AfterMiniboss_AIZ_End:

Pal_AfterMiniboss_AIZ:
                binclude "data/Levels/AIZ/Palettes/Miniboss After.bin"
                even
Pal_AfterMiniboss_ICZ:
                binclude "data/Levels/ICZ/Palettes/Miniboss After.bin"
                even
PLC_MonitorsSpikesSprings:  plrlistheader
                plreq   ArtTile_Monitors, ArtNem_Monitors
                plreq   ArtTile_SpikesSprings, ArtNem_SpikesSprings
PLC_MonitorsSpikesSprings_End:

PLC_Monitors:   plrlistheader
                plreq   ArtTile_Monitors, ArtNem_Monitors
PLC_Monitors_End:

PLC_AnimalsAndExplosion:    plrlistheader               ; unused
                plreq   ArtTile_Explosion, ArtNem_Explosion
                plreq   ArtTile_Animals1, ArtNem_Squirrel
                plreq   ArtTile_Animals2, ArtNem_BlueFlicky
PLC_AnimalsAndExplosion_End:

PLC_BossExplosion:  plrlistheader
                plreq   ArtTile_BossExplosion, ArtNem_BossExplosion
PLC_BossExplosion_End:

PLC_Explosion:  plrlistheader
                plreq   ArtTile_Explosion, ArtNem_Explosion
PLC_Explosion_End:

PLC_EggCapsule: plrlistheader
                plreq   ArtTile_EggCapsule, ArtNem_EggCapsule
PLC_EggCapsule_End:
