# Basic make settings
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Used instead of .PHONY for modularity
# See: https://www.gnu.org/software/make/manual/html_node/Force-Targets.html
FORCE:

# Depend on $(THIS_MAKEFILE) to invalidate targets when their makefile changes
define THIS_MAKEFILE
$(lastword $(MAKEFILE_LIST))
endef

# Define the hostname in a way that works in chroot
HOSTNAME != cat /etc/hostname
