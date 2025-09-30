# Use bash and safe flags
set shell := ["bash", "-euo", "pipefail", "-c"]

# Variables
home           := env_var("HOME")
dotdir         := "dotfiles"
secretsrc      := home + "/.secretfiles"
deploy         := "./scripts/deploy.sh"
containerfiles := "containerfiles"
image_org      := "ghcr.io/mikolajmikolajczyk"
base_image     := image_org + "/distrobox-base:latest"
dailydriver_image := image_org + "/distrobox-dailydriver:latest"

# Default help
default: help

help:
	@echo "Available recipes:"
	@echo "  just build                  # Build all images"
	@echo "  just build-base             # Build base image"
	@echo "  just build-dailydriver      # Build dailydriver image"
	@echo "  just list                   # List available distroboxes"
	@echo "  just assemble <name>        # Assemble a distrobox by name (e.g., just assemble work)"
	@echo "  just check                  # Check dependencies"

# Check dependencies
check:
	command -v rsync >/dev/null || { echo "rsync not found"; exit 1; }
	test -x {{deploy}} || { echo "Making {{deploy}} executable"; chmod +x {{deploy}}; }

# Build all images
build: build-base build-dailydriver

# Base image
build-base:
	podman build \
	  -f {{containerfiles}}/Containerfile.base \
	  -t {{base_image}} .

# Base image
build-dailydriver:
	podman build \
	  -f {{containerfiles}}/Containerfile.dailydriver \
	  -t {{dailydriver_image}} . \
	  --build-arg BASE_IMAGE={{base_image}}

# List available distroboxes
list:
	@echo "Available distroboxes:"
	@for d in ./distroboxes/*; do \
		[ -d "$d" ] && echo "  $(basename "$d")"; \
	done

# Assemble a specific distrobox by name
assemble name:
	@if [ -z "{{name}}" ]; then \
		echo "Please provide a parameter. Possible values:"; \
		for d in ./distroboxes/*; do \
			[ -d "$d" ] && echo "  $(basename "$d")"; \
		done; \
		exit 1; \
	fi
	distrobox assemble create \
		--file distroboxes/{{name}}/distrobox.ini \
		--replace
