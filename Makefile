.PHONY: all check-syntax run-playbook

# Variables
CONFIG_ACCENTURE = config-accenture.yml
CONFIG_INSTACART = config-instacart.yml
CONFIG_HOME = config-home.yml
INVENTORY = inventory
PLAYBOOK = main.yml

# Default target
all: check-syntax run-playbook

# Check playbook syntax
check-syntax:
	@echo "Checking playbook syntax..."
	@ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) --syntax-check
	@echo "Syntax check passed."

#######
# ALL #
#######
all:
	@echo "Running playbook..."
	@time ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) --ask-become-pass
	@echo "Playbook execution completed."

all-homebrew:
	@echo "Running playbook..."
	@time ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) --ask-become-pass --tags homebrew
	@echo "Playbook execution completed."

all-dotfiles:
	@echo "Running playbook..."
	@time ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) --ask-become-pass --tags dotfiles
	@echo "Playbook execution completed."

tags:
	@echo "Enter tags (comma separated):"
	@read -p "" tags; \
	echo "Running playbook..."; \
	time ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) --ask-become-pass --tags $$tags; \
	echo "Playbook execution completed."

########
# HOME #
########
home:
	@echo "Running playbook..."
	@time ANSIBLE_CONFIG="$(pwd)/$(CONFIG_HOME)" ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) -l mbpmax --ask-become-pass
	@echo "Playbook execution completed."

home-homebrew:
	@echo "Running playbook..."
	@time ANSIBLE_CONFIG="$(pwd)/$(CONFIG_HOME)" ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) -l mbpmax --ask-become-pass --tags homebrew
	@echo "Playbook execution completed."

home-dotfiles:
	@echo "Running playbook..."
	@time ANSIBLE_CONFIG="$(pwd)/$(CONFIG_HOME)" ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) -l mbpmax --ask-become-pass --tags dotfiles
	@echo "Playbook execution completed."
	@echo "Syntax check passed."
	@echo "Syntax check passed."

############
# MAC MINI #
############
macmini:
	@echo "Running playbook..."
	@time ANSIBLE_CONFIG="$(pwd)/$(CONFIG_HOME)" ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) -l macmini --ask-become-pass
	@echo "Playbook execution completed."

macmini-homebrew:
	@echo "Running playbook..."
	@time ANSIBLE_CONFIG="$(pwd)/$(CONFIG_HOME)" ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) -l macmini --ask-become-pass --tags homebrew
	@echo "Playbook execution completed."

macmini-dotfiles:
	@echo "Running playbook..."
	@time ANSIBLE_CONFIG="$(pwd)/$(CONFIG_HOME)" ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) -l macmini --ask-become-pass --tags dotfiles
	@echo "Playbook execution completed."
	@echo "Syntax check passed."

#############
# ACCENTURE #
#############
accenture:
	@echo "Running playbook..."
	@time ANSIBLE_CONFIG="$(pwd)/$(CONFIG_ACCENTURE)" ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) -l accenture --ask-become-pass
	@echo "Playbook execution completed."

accenture-homebrew:
	@echo "Running playbook..."
	@time ANSIBLE_CONFIG="$(pwd)/$(CONFIG_ACCENTURE)" ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) -l accenture --ask-become-pass --tags homebrew
	@echo "Playbook execution completed."

accenture-dotfiles:
	@echo "Running playbook..."
	@time ANSIBLE_CONFIG="$(pwd)/$(CONFIG_ACCENTURE)" ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) -l accenture --ask-become-pass --tags dotfiles
	@echo "Playbook execution completed."


############
# INSTACART #
############
instacart:
	@echo "Running playbook..."
	@time ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) -l instacart --ask-become-pass
	@echo "Playbook execution completed."

instacart-homebrew:
	@echo "Running playbook..."
	@time ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) -l instacart --ask-become-pass --tags homebrew
	@echo "Playbook execution completed."

instacart-dotfiles:
	@echo "Running playbook..."
	@time ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) -l instacart --ask-become-pass --tags dotfiles
	@echo "Playbook execution completed."