BREW_DEPS=pre-commit

# Install the global dependencies for the repo
setup:
	for dep in ${BREW_DEPS}; do if !(brew list $$dep >/dev/null); then brew install $$dep; fi done
	yarn install
	pre-commit install
	pre-commit install --hook-type commit-msg
	pre-commit install --hook-type prepare-commit-msg

.PHONY: setup
.SILENT: setup
