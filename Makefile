.PHONY: help test lint format check ci

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
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-12s$(NC) %s\n", $$1, $$2}'

test:  ## Run test suite
	@echo "$(YELLOW)Running tests...$(NC)"
	@fishtape tests/*/*.fish

lint:  ## Check formatting
	@echo "$(YELLOW)Checking fish formatting...$(NC)"
	@fish_indent --check **/*.fish
	@echo "$(YELLOW)Checking prettier formatting...$(NC)"
	@bunx prettier --check .

format:  ## Auto-fix formatting
	@echo "$(YELLOW)Formatting fish files...$(NC)"
	@fish_indent -w **/*.fish
	@echo "$(YELLOW)Formatting with prettier...$(NC)"
	@bunx prettier --write .

check: lint test  ## Run all checks

ci: check  ## Simulate CI locally
	@echo "$(GREEN)✓ All CI checks passed$(NC)"
