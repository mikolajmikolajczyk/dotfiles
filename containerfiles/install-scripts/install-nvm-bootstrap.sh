#!/usr/bin/env bash
set -euo pipefail
# Usage: install-nvm-bootstrap.sh <nvm_version>
nvm_ver="${1:?nvm_version}"

# nvm is per-user; install loader that performs a one-time install in $HOME on first interactive shell.
cat >/etc/profile.d/10-nvm.sh <<'EOF'
# nvm per-user bootstrap (installed at first login, sourced thereafter)
export NVM_VERSION="${NVM_VERSION_OVERRIDE:-__NVM_VER__}"
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
export PATH="$HOME/.local/bin:$PATH"
if [ -n "$PS1" ]; then
  if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    mkdir -p "$NVM_DIR"
    curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash >/dev/null 2>&1 || true
  fi
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
fi
EOF
# inject version
sed -i "s/__NVM_VER__/${nvm_ver}/g" /etc/profile.d/10-nvm.sh
chmod 0644 /etc/profile.d/10-nvm.sh
