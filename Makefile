.PHONY: all check-syntax run-playbook

# Variables
CONFIG_ACCENTURE = config-accenture.yml
CONFIG_EPLEXITY = config-eplexity.yml
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
# EPLEXITY #
############
eplexity:
	@echo "Running playbook..."
	@time ANSIBLE_CONFIG="$(pwd)/$(CONFIG_EPLEXITY)" ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) -l eplexity --ask-become-pass
	@echo "Playbook execution completed."

eplexity-homebrew:
	@echo "Running playbook..."
	@time ANSIBLE_CONFIG="$(pwd)/$(CONFIG_EPLEXITY)" ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) -l eplexity --ask-become-pass --tags homebrew
	@echo "Playbook execution completed."

eplexity-dotfiles:
	@echo "Running playbook..."
	@time ANSIBLE_CONFIG="$(pwd)/$(CONFIG_EPLEXITY)" ansible-playbook $(PLAYBOOK) --inventory=$(INVENTORY) -l eplexity --ask-become-pass --tags dotfiles
	@echo "Playbook execution completed."
