.PHONY: help test lint lint-fish lint-prettier format format-fish format-prettier check ci release-install release

# Colors
GREEN  := \033[0;32m
YELLOW := \033[0;33m
CYAN   := \033[0;36m
RED    := \033[0;31m
NC     := \033[0m
BOLD   := \033[1m

help:  ## Show this help
	@echo "$(BOLD)fzf.fish Development Commands$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-16s$(NC) %s\n", $$1, $$2}'

test:  ## Run test suite
	@echo "$(YELLOW)Running tests...$(NC)"
	@fishtape tests/*/*.fish

lint-fish:  ## Check fish formatting
	@echo "$(YELLOW)Checking fish formatting...$(NC)"
	@fish_indent --check **/*.fish

lint-prettier:  ## Check prettier formatting
	@echo "$(YELLOW)Checking prettier formatting...$(NC)"
	@bunx prettier --check .

lint: lint-fish lint-prettier  ## Check all formatting

format-fish:  ## Auto-fix fish formatting
	@echo "$(YELLOW)Formatting fish files...$(NC)"
	@fish_indent -w **/*.fish

format-prettier:  ## Auto-fix prettier formatting
	@echo "$(YELLOW)Formatting with prettier...$(NC)"
	@bunx prettier --write .

format: format-fish format-prettier  ## Auto-fix all formatting

check: lint test  ## Run all checks

ci: check  ## Simulate CI locally
	@echo "$(GREEN)✓ All CI checks passed$(NC)"

RELEASE_DEPS := semantic-release @semantic-release/changelog @semantic-release/git conventional-changelog-conventionalcommits

release-install:  ## Install semantic-release dependencies
	@echo "$(YELLOW)Installing release dependencies...$(NC)"
	@bun install -D $(RELEASE_DEPS)

# semantic-release does not support the bun runtime
# https://github.com/semantic-release/semantic-release/issues/3527
release: release-install  ## Run semantic-release (CI only)
	@echo "$(YELLOW)Running semantic-release...$(NC)"
	@npx semantic-release
