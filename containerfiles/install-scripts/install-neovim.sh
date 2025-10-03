#!/usr/bin/env bash
# Usage: install-neovim.sh <version>
# Installs official prebuilt Neovim to /opt/nvim-<tag> and symlinks /usr/local/bin/nvim -> /opt/nvim/bin/nvim
# Examples:
#   install-neovim.sh 0.10.3
#   install-neovim.sh nightly
set -euo pipefail

ver="${1:?missing neovim version (e.g. 0.10.3 or nightly)}"

# Detect architecture -> package name
arch="$(uname -m)"
case "$arch" in
x86_64) pkg="nvim-linux-x86_64.tar.gz" ;;
aarch64) pkg="nvim-linux-arm64.tar.gz" ;;
*)
  echo "Unsupported arch: ${arch}. Supported: x86_64, aarch64" >&2
  exit 1
  ;;
esac

# Compose GitHub tag and URL. For nightly the tag is literally "nightly".
if [[ "$ver" == "nightly" ]]; then
  tag="nightly"
else
  # Accept "0.10.3" or "v0.10.3"
  tag="${ver#v}"
  tag="v${tag}"
fi

url="https://github.com/neovim/neovim/releases/download/${tag}/${pkg}"

# Prepare temp dir and cleanup
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

echo "[nvim] Downloading ${url}"
if ! curl -fL -o "${tmpdir}/nvim.tgz" "$url"; then
  echo "Download failed. Check if the version/tag exists for your arch:"
  echo "  - nightly: ${url/\/${pkg}/}"
  echo "  - release: https://github.com/neovim/neovim/releases/tag/${tag}"
  exit 1
fi

# Install into a versioned directory and point /opt/nvim symlink to it
target="/opt/nvim-${tag}"
echo "[nvim] Installing to ${target}"
install -d -m 0755 "$target"
tar -xzf "${tmpdir}/nvim.tgz" -C "$target" --strip-components=1

# Update symlinks
ln -sfn "$target" /opt/nvim
install -d -m 0755 /usr/local/bin
ln -sfn /opt/nvim/bin/nvim /usr/local/bin/nvim

# Verify
echo -n "[nvim] Installed: "
/usr/local/bin/nvim --version | head -n1

echo "[nvim] Done."
