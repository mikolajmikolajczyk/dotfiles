# Dotfiles & Secrets Deployment

This repository provides a unified way to manage and deploy your **dotfiles** and **secrets** across environments such as distroboxes or local machines.

The structure is intentionally simple:

```
/
├─ dotfiles/          # Files and directories mirrored into $HOME
├─ containerfiles/    # Containerfiles / Dockerfiles for dev environments
├─ justfile           # Task runner commands
```

* `dotfiles/`
  Contains configuration files that should be copied into `$HOME`.
  Example: `dotfiles/.gitconfig` → `$HOME/.gitconfig`

* `~/.secretfiles/`
  A private directory stored outside of the repo (not tracked in git).
  Secrets are deployed with the same mechanism as dotfiles.

---

## Pre-commit hooks

This repository uses [pre-commit](https://pre-commit.com/) to keep scripts and configs clean.

### Installation

1. Install `pre-commit` (once per machine):

   ```bash
   pip install pre-commit
   ```

   Or via your package manager:

   ```bash
   # Arch Linux
   sudo pacman -S pre-commit

   # Fedora
   sudo dnf install pre-commit
   ```

2. Install hooks for this repo:

   ```bash
   pre-commit install
   ```

### Usage

* Hooks will run automatically on every commit.
* To check all files manually:

  ```bash
  pre-commit run --all-files
  ```
* To update hooks to the latest versions (according to `.pre-commit-config.yaml`):

  ```bash
  pre-commit autoupdate
  ```


## License

MIT (for the deployment scripts).
Note: Do **not** commit your personal secrets — keep them in `~/.secretfiles` outside of git.
