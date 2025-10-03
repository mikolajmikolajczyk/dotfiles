# Auto-install Rust toolchain on first shell if not already installed
if ! command -v rustc >/dev/null 2>&1; then
  echo "[rustup] Installing Rust (stable, minimal profile)..."
  export RUSTUP_HOME="$HOME/.rustup"
  export CARGO_HOME="$HOME/.cargo"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --profile minimal --no-modify-path
  # ensure PATH is updated for this session
  export PATH="$CARGO_HOME/bin:$PATH"
  echo "[rustup] Installed: $(rustc --version)"
  . "$HOME/.cargo/env"
else
  # ensure PATH is set if installed already
  export RUSTUP_HOME="$HOME/.rustup"
  export CARGO_HOME="$HOME/.cargo"
  export PATH="$CARGO_HOME/bin:$PATH"
  . "$HOME/.cargo/env"
fi
