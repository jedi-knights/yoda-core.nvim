.PHONY: test lint format help

help:
	@echo "Available commands:"
	@echo "  make test    - Run all tests"
	@echo "  make lint    - Check code style"
	@echo "  make format  - Format code with stylua"

test:
	@echo "Running tests..."
	@nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/unit/ { minimal_init = 'tests/minimal_init.lua' }"

lint:
	@echo "Checking code style..."
	@stylua --check lua/

format:
	@echo "Formatting code..."
	@stylua lua/
