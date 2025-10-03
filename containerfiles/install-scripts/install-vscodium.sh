#!/usr/bin/env bash
set -euo pipefail
# Usage: install-vscodium.sh [stable|insiders]
# Installs VSCodium on Fedora/RHEL/Rocky/CentOS/AlmaLinux from official repo.

channel="${1:-stable}"  # stable | insiders
pkg="codium"
if [[ "$channel" == "insiders" ]]; then
  pkg="codium-insiders"
fi

KEY_URL="https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg"
REPO_URL="https://download.vscodium.com/rpms/"
REPO_FILE="/etc/yum.repos.d/vscodium.repo"

# Must be run as root inside container, or with sudo outside.
if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "This script must be run as root (or with sudo)." >&2
  exit 1
fi

# Import GPG key
rpmkeys --import "$KEY_URL"

# Write repo file
cat >"$REPO_FILE" <<EOF
[gitlab.com_paulcarroty_vscodium_repo]
name=download.vscodium.com
baseurl=${REPO_URL}
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=${KEY_URL}
metadata_expire=1h
EOF

# Install VSCodium
dnf -y makecache
dnf -y install "$pkg"

# Smoke test
if ! command -v codium >/dev/null 2>&1; then
  echo "codium binary not found on PATH after installation." >&2
  exit 1
fi

echo "VSCodium installed successfully."
