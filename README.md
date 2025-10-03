# Dotfiles & Secrets Deployment

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
<!-- [![Build Status](https://img.shields.io/github/actions/workflow/status/mikolajmikolajczyk/dotfiles/main.yml)](https://github.com/mikolajmikolajczyk/dotfiles/actions) -->

Welcome! This repository helps you manage and deploy your **dotfiles** and **secrets** across different environments—be it your laptop, a new work machine, or a containerized devbox. If you ever wanted a way to sync your configuration and bootstrap your favorite environments in seconds, you're in the right place.

---

## ✨ What are Dotfiles and Why Use This Repo?

Dotfiles are configuration files for your favorite tools—think `.bashrc`, `.gitconfig`, `.vimrc`, and so on. Keeping them in sync across your devices can be tricky. This project provides:

- **Unified dotfiles management:** Easily mirror configs to `$HOME` everywhere.
- **Secrets handling:** Clean separation between public configs and private secrets.
- **Dev containers out of the box:** Use prebuilt environments with all your tools, powered by Distrobox and Containerfiles.
- **Automation with [just](https://github.com/casey/just):** One-liner setup and task running.
- **Pre-commit hooks:** Keep your configs and scripts linted and tidy.

---

## 🚀 Quick Start

### 1. Clone this repo

```bash
git clone https://github.com/mikolajmikolajczyk/dotfiles.git
cd dotfiles
```

### 2. Explore available environments

```bash
just list
```
This will list all available `distrobox.ini` files (environments you can assemble).

### 3. Assemble your environment

```bash
just assemble <name>
```
Replace `<name>` with the environment you want to set up (as listed by `just list`). This will configure dotfiles, secrets, and (if desired) containers for you.

---

## 🗂️ Repository Structure

```
/
├── dotfiles/          # Files mirrored into $HOME
├── containerfiles/    # Containerfiles/Dockerfiles for dev environments
├── justfile           # Task runner commands
├── .pre-commit-config.yaml
└── ...
```
- **dotfiles/**
  Configuration files to be copied to `$HOME`.
  Example: `dotfiles/.gitconfig` → `$HOME/.gitconfig`

- **containerfiles/**
  [Dev Containers](containerfiles/README.md) for [Distrobox](https://distrobox.it/).
  Each image comes with compilers, editors, and more—ready to use.

- **justfile**
  [just](https://github.com/casey/just) recipes for setup and daily tasks.

- **~/.secretfiles/**
  Private directory (not in git!) for your secrets.
  Secrets are deployed just like dotfiles, but kept outside version control.
  **Never commit secrets to this repo!**

---

## 🛠️ Features & Use Cases

- **Onboard a new machine in minutes:**
  `git clone` + `just assemble <name>` = up and running.

- **Portable, reproducible dev environments:**
  Use `distrobox` and provided containerfiles to work anywhere.

- **Keep secrets secret:**
  Store sensitive files in `~/.secretfiles` (outside git).

- **Automated sanity checks:**
  Pre-commit hooks for shell scripts, YAML, and more.

---

## 🔍 How It Works

<!--
ASCII DIAGRAM GOES HERE

You can add a deployment workflow, directory structure, or environment bootstrapping diagram.
-->

---

## ⚡ Pre-commit Hooks

This repository uses [pre-commit](https://pre-commit.com/) to keep scripts and configs clean.

### Install pre-commit

```bash
# Using pip
pip install pre-commit

# Or your package manager
sudo pacman -S pre-commit   # Arch Linux
sudo dnf install pre-commit # Fedora
```

### Set up hooks

```bash
pre-commit install
```

Hooks will now run automatically on every commit.
To run checks manually: `pre-commit run --all-files`
To update hooks: `pre-commit autoupdate`

---

## 📦 Dev Containers

See [containerfiles/README.md](containerfiles/README.md) for details.

- Prebuilt images for [distrobox](https://distrobox.it/)
- All the tools you need: compilers, editors, debuggers, language runtimes, etc.
- Designed for convenience and fast onboarding.

---

## 💤 Neovim / LazyVim

Neovim config lives in `dotfiles/.config/nvim/`.
See the [nvim README](dotfiles/.config/nvim/README.md) for details and customization.

---

## 🧭 About This Repo

> **Opinionated by Design:**
> This configuration is intentionally opinionated—it's tailored to the daily workflow and personal programming habits of the author. All included tools, settings, and integrations represent those actually used and valued by the maintainer.
> **Contributions are welcome—especially improvements!**
> However, please note: if a proposed tool or setup isn’t part of the author’s daily toolkit, it will likely not be merged.

---

## 🧑‍💻 How to Contribute

Contributions, suggestions, and questions are welcome—especially if they improve what’s already here!

However, since this repo is closely tied to the author's personal workflow, **pull requests adding tools or configs the author does not use will not be accepted**.

Feel free to fork and adapt for your own needs, or open issues/PRs for fixes and enhancements to existing setups.

---

## 📜 License

MIT License.
See [LICENSE](LICENSE) for details.

**Never commit your personal secrets—keep them in `~/.secretfiles` outside of git.**

---

## 📝 TODO / Placeholders

- [ ] Add ASCII diagrams (deployment flow, directory structure, etc.)
- [ ] Add screenshots or badges (if desired)

---

Happy hacking! 🚀
