# Slashfiles

This repository contains overlay files for the root filesystem (`/`) across various operating systems.

- Inspired by the traditional `dotfiles` repository for user home directories.
- `slashfiles` overlays are intended for `/` (root) level configurations.
- Each branch corresponds to a different operating system (e.g., `qubes`, `fedora`, `debian`).

## Purpose

- Maintain system configuration separately from user configuration.
- Simplify migrations and backups between systems.
- Enable efficient version control and deployment of root-level changes.

## Safety

This repository is intended to be synchronized manually into system roots with careful controls.
Never automate without auditing changes.

---

