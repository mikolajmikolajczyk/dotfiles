#!/usr/bin/env bash
# Setup global Starship init and a minimal default /etc/skel config.
set -euo pipefail

# Global init for bash; users can enable fish/zsh in their own dotfiles.
cat >/etc/profile.d/starship.sh <<'EOSH'
#!/usr/bin/env bash
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi
EOSH
chmod 0644 /etc/profile.d/starship.sh

# Minimal default Starship config in /etc/skel so new users inherit it.
install -d -m 0755 /etc/skel/.config/starship
cat >/etc/skel/.config/starship.toml <<'TOML'
# Minimal Starship configuration for a clean, informative prompt
add_newline = true

[character]
success_symbol = "➜ "
error_symbol = "✗ "

[directory]
truncate_to_repo = true
truncation_length = 3

[git_branch]
format = "on [$symbol$branch]($style) "

[git_status]
conflicted = "=!"
diverged = "⇕"
modified = "*"
renamed = "»"
staged = "+"
untracked = "?"
TOML
