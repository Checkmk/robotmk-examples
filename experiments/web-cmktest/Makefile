-include .env

SITE ?= v250

.PHONY: config
config: scripts/config.sh
	@bash scripts/config.sh "$(SITE)"
