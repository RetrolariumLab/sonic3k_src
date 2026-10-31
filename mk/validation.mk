.PHONY: check-docs source-2-audit source-2-release-audit source-2-check scaffold-check

check-docs:
	$(PYTHON) -m scripts.run validation.documentation

source-2-audit:
	$(PYTHON) -m scripts.run validation.source_2 metadata

source-2-release-audit:
	$(PYTHON) -m scripts.run validation.source_2 audit

source-2-check:
	$(PYTHON) -m scripts.run validation.source_2 check

# Every prerequisite is ROM-less. The full aggregate additionally requires inputs.
scaffold-check:
	$(MAKE) lint test check-source-layout check-memory-contract check-composition-contract check-z80-contract
	$(MAKE) check-audio-storage check-driver-audio-storage check-numeric-operands check-content-contract
	$(MAKE) check-docs source-2-audit

.PHONY: check-source-ranges

check-source-ranges:
	$(PYTHON) -m scripts.run validation.source_layout --built
