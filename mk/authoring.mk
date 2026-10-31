.PHONY: prepare-core check-core

prepare-core:
	$(PYTHON) -m scripts.run authoring.core_compression prepare

check-core:
	$(PYTHON) -m scripts.run authoring.core_compression check

.PHONY: check-content-contract roundtrip-formats check-content-zero-edit

check-content-contract:
	$(PYTHON) -m scripts.run authoring.formats_workflow check-contract

roundtrip-formats: verify-all check-core
	$(PYTHON) -m scripts.run authoring.formats_workflow roundtrip

check-content-zero-edit: roundtrip-formats
	$(PYTHON) -m scripts.run authoring.formats_workflow zero-edit
