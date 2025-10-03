#!/usr/bin/env bash
set -euo pipefail
# Usage: install-crypto.sh <sops_version> <age_version>
sops_ver="${1:?sops_version}"
age_ver="${2:?age_version}"

arch="$(uname -m)"
case "$arch" in
  x86_64) a_bin=amd64; a_tgz=amd64 ;;
  aarch64) a_bin=arm64; a_tgz=arm64 ;;
  *) echo "unsupported arch: $arch" >&2; exit 1 ;;
esac

# sops (single binary)
curl -fsSL -o /usr/local/bin/sops \
  "https://github.com/getsops/sops/releases/download/v${sops_ver}/sops-v${sops_ver}.linux.${a_bin}"
chmod +x /usr/local/bin/sops

# age (tarball)
curl -fsSL -o /tmp/age.tgz \
  "https://github.com/FiloSottile/age/releases/download/v${age_ver}/age-v${age_ver}-linux-${a_tgz}.tar.gz"
tar -C /usr/local/bin -xzf /tmp/age.tgz --strip-components=1 "age/age" "age/age-keygen"
rm -f /tmp/age.tgz
