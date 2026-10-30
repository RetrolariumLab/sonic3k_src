.DEFAULT_GOAL := help
PYTHON ?= python
RLTOOL ?= rltool
PROFILE ?= s3-us
ROM_ROOT ?=

.PHONY: help init split check-assets build verify verify-all verify-toolchain test audit-private clean

help:
	@$(PYTHON) -m scripts.run build.pipeline help

init:
	$(PYTHON) -m scripts.run build.pipeline init --rom-root "$(ROM_ROOT)"

split:
	$(RLTOOL) assets split
	$(PYTHON) -m scripts.run authoring.driver_payloads split

check-assets:
	$(RLTOOL) assets check
	$(PYTHON) -m scripts.run authoring.driver_payloads check

build:
	$(PYTHON) -m scripts.run build.pipeline build --profile "$(PROFILE)"

verify:
	$(PYTHON) -m scripts.run build.pipeline verify --profile "$(PROFILE)"

verify-all:
	$(PYTHON) -m scripts.run build.pipeline verify-all

verify-toolchain:
	$(PYTHON) -m scripts.run build.pipeline verify-toolchain

test:
	$(PYTHON) -m unittest discover -s tests -v

audit-private:
	$(PYTHON) -m scripts.run validation.private_data

clean:
	$(PYTHON) -m scripts.run build.pipeline clean

.PHONY: lint format format-check

lint:
	$(RLTOOL) lint --project .

format:
	$(RLTOOL) lint --project . --fix --only text
	$(RLTOOL) lint --project . --fix --only assembly
	$(RLTOOL) format --project .
	$(MAKE) lint

format-check: lint

.PHONY: check-lockon

check-lockon:
	$(PYTHON) -m scripts.run validation.lockon

include mk/runtime.mk

.PHONY: check-driver-audio check-driver-audio-storage

check-driver-audio:
	$(PYTHON) -m scripts.run authoring.driver_payloads check --built

check-driver-audio-storage:
	$(PYTHON) -m scripts.run authoring.driver_payloads check --catalog-only
