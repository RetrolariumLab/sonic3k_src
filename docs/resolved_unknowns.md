# Resolved workflow questions

| Question                                        | Resolution and evidence                                                                                                                 |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| Which images are accepted?                      | S3 USA, Europe and Japan, standalone S&K and S3&K; image and revision registries own hashes and builds.                                 |
| Is S3&K another engine copy?                    | It is S&K followed by independently verified S3 USA; `check-lockon` checks all 675 exports against each S3 region.                      |
| Can the toolchain reproduce compressed drivers? | Pinned AS and authentic p2bin produce all five original images; `verify-toolchain` checks executables before assembly.                  |
| How does MAME run standalone S&K?               | An unchanged base image receives an all-FF empty upper bus window, avoiding MAME's bare-cartridge mirror. See [runtime](runtime.md).    |
| Can engine source be separated safely?          | All 1980 units have semantic owners; historical procedures, symbols, RAM and physical byte coverage are checked alongside exact images. |
| Can raw scripts share continuations?            | Closed source graphs retain aliases, stored roots and actual consumer ABIs; [raw animations](raw_animations.md) describes the contract. |
| Does extraction alone make sound editable?      | Closed SMPS3/4 banks, FM values, envelopes and PCM/DPCM additionally have typed models, tests and full container reconstruction.        |
| Must encoders reproduce an original compressor? | Zero-edit output retains its exact stream. Forced encoding proves decoded equivalence; changed output must fit its allocation.          |
| Can one inline writer erase another?            | All families compose validated patches together against one original owner, then hash and build the resulting source.                   |

These decisions resolve workflow and storage questions. They do not resolve
every inherited label or expand finite runtime coverage; see
[remaining limits](unknowns.md).
