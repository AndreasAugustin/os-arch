SHELL := /bin/bash
.DEFAULT_GOAL := help

###########################
# VARIABLES
###########################

##########################
# MAPPINGS
###########################

###########################
# Repo targets
############################

.PHONY: update
update: ## update repository with actual home
	cp ~/.zshrc .dot/.zshrc

###########################
# TARGETS
###########################

.PHONY: help
help:  ## help target to show available commands with information
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) |  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: markdownlint
markdownlint: ## Validate markdown files
	docker-compose run docs markdownlint .github/ --ignore node_modules
	docker-compose run docs markdownlint . --ignore node_modules

.PHONY: clean
clean: ## clean all build artefacts
	docker-compose run -w /app/packages/oh-my-zsh dev ./clean.sh

.PHONY: build
build: ## build all packages
	docker-compose run -w /app/packages/oh-my-zsh dev makepkg

.PHONY: install
install: ## installall packages
	docker-compose run -w /app/packages/oh-my-zsh dev makepkg --install

.PHONY: zsh
zsh: ## open dev container with build environment
	docker-compose run --service-ports dev /bin/zsh

.PHONY: prune
prune: clean ## delete the whole environment
	docker-compose down -v --rmi all --remove-orphans
