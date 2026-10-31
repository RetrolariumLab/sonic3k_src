# Preservation revisions

`assets/manifest.json` owns input file identities and hashes.
`config/revision_profiles.json` owns build entries, defines and composition.

| Profile | Entry or composition     | Bytes   | Region define      | Runtime machine                         |
| ------- | ------------------------ | ------- | ------------------ | --------------------------------------- |
| `s3-us` | `src/revisions/s3.s`     | 2097152 | `S3_Region=85` (U) | `genesis`                               |
| `s3-eu` | `src/revisions/s3.s`     | 2097152 | `S3_Region=69` (E) | `megadriv`                              |
| `s3-jp` | `src/revisions/s3.s`     | 2097152 | `S3_Region=74` (J) | `megadrij`                              |
| `sk`    | `src/revisions/sk.s`     | 2097152 | none               | `genesis`, empty upper cartridge window |
| `s3k`   | `sk` followed by `s3-us` | 4194304 | component-owned    | `genesis`                               |

The accepted S3 regional images differ at exactly byte 0x1f0, the header region
character. Source emits that define directly; no binary delta or region patch
file is applied. Startup reads the region, so all three have direct runtime
checks rather than inferred equivalence. The Sonic & Knuckles base image and
S3&K composite also have separate runtime checks.

Excluded scope is explicit in the profile registry: community modifications,
Knuckles in Sonic 2, prototypes and unverified dumps. The upstream complete
build is a modification rather than a preservation revision. A new profile
requires a verified input identity, source-owned differences, extraction
ownership, exact build comparison and justified runtime coverage.
