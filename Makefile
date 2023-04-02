.PHONY: all check-syntax run-playbook

# Variables
PLAYBOOK = main.yml
INVENTORY = inventory-fabio.ini

# Default target
all: check-syntax run-playbook

# Check playbook syntax
check-syntax:
	@echo "Checking playbook syntax..."
	@ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) --syntax-check
	@echo "Syntax check passed."

# Run the playbook
run-playbook:
	@echo "Running playbook..."
	@time ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) --ask-become-pass
	@echo "Playbook execution completed."

homebrew:
	@echo "Running playbook..."
	@time ansible-playbook -vvvv $(PLAYBOOK) --inventory=$(INVENTORY) --ask-become-pass --tags homebrew
	@echo "Playbook execution completed."

dotfiles:
	@echo "Running playbook..."
	@time ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) --ask-become-pass --tags dotfiles
	@echo "Playbook execution completed."
