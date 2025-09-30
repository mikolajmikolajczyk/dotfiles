#!/usr/bin/env bash
# Install essential CLI tooling and build basics.
set -euo pipefail

dnf -y update
dnf -y install \
  git \
  gnupg2 \
  git-crypt \
  make \
  openssl \
  bash-completion \
  wget \
  curl \
  mc \
  podman-remote \
  jq \
  ca-certificates \
  tar \
  gzip \
  unzip \
  xz \
  which \
  shadow-utils \
  findutils \
  clang \
  gcc \
  fzf \
  ripgrep \
  tree \
  fd-find \
  wl-clipboard \
  ImageMagick \
  ghostscript \
  texlive \
  pre-commit \
  just \
  firefox \
  hadolint \
  lua \
  lua-devel \
  compat-lua \
  luarocks

dnf -y copr enable wezfurlong/wezterm-nightly
dnf -y install wezterm

dnf clean all
rm -rf /var/cache/dnf
