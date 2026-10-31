.PHONY: prepare-core check-core

prepare-core:
	$(PYTHON) -m scripts.run authoring.core_compression prepare

check-core:
	$(PYTHON) -m scripts.run authoring.core_compression check
