.PHONY: verify-emulator golden trace trace-relocated

verify-emulator:
	$(PYTHON) -m scripts.run runtime.runner prepare

golden:
	$(PYTHON) -m scripts.run runtime.runner golden

trace:
	$(PYTHON) -m scripts.run runtime.runner check

trace-relocated:
	$(PYTHON) -m scripts.run runtime.runner matrix
