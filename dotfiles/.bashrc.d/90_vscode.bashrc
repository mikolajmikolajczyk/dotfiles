# --- VS Code auto-setup for Fedora with default+env extensions + theme setup ---
__vscode_bootstrap() {
  set -u
  if ! grep -qi '^ID=fedora' /etc/os-release 2>/dev/null; then return 0; fi

  local cache_dir="$HOME/.cache"
  mkdir -p "$cache_dir"
  local install_marker="${VSCODE_SKIP_MARKER:-$cache_dir/vscode-bootstrap.done}"
  local exts_hash_file="$cache_dir/vscode-exts.hash"

  # --- install VSCode if missing ---
  if [[ ! -f "$install_marker" ]]; then
    if ! command -v code >/dev/null 2>&1; then
      echo "[vscode] Installing Visual Studio Code..."
      sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc || true
      sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
      sudo dnf -y makecache || true
      sudo dnf -y install code || echo "[vscode] Failed to install."
    fi
    date > "$install_marker"
  fi

  # --- build extensions list ---
  local default_exts="${VSCODE_DEFAULT_EXTENSIONS:-\
eamodio.gitlens
timdeen.darcula
}"
  local extra_exts="${VSCODE_EXTENSIONS:-}"
  local merged
  merged="$(printf "%s\n%s\n" "$default_exts" "$extra_exts" \
    | tr ', ' '\n\n' | tr -s '\n' \
    | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//' \
    | awk 'NF && !seen[$0]++')"

  command -v code >/dev/null 2>&1 || return 0

  # --- install/update extensions ---
  if [[ -n "$merged" ]]; then
    local new_hash
    new_hash="$(printf "%s" "$merged" | sha256sum | awk '{print $1}')"
    local old_hash=""
    [[ -f "$exts_hash_file" ]] && old_hash="$(cat "$exts_hash_file" 2>/dev/null || true)"
    if [[ "$new_hash" != "$old_hash" ]]; then
      echo "[vscode] Installing/updating extensions..."
      while IFS= read -r ext; do
        [[ -z "$ext" ]] && continue
        code --install-extension "$ext" --force >/dev/null 2>&1 || echo "[vscode] Failed: $ext" >&2
      done <<< "$merged"
      echo "$new_hash" > "$exts_hash_file"
    fi
  fi

  # --- set Darcula theme automatically ---
  local settings="$HOME/.config/Code/User/settings.json"
  mkdir -p "$(dirname "$settings")"
  local theme_name="Darcula Theme"

  if ! grep -q "\"workbench.colorTheme\"" "$settings" 2>/dev/null; then
    echo "[vscode] Setting default theme: $theme_name"
    if [[ -s "$settings" ]]; then
      tmp="$(mktemp)"
      jq --arg theme "$theme_name" '. + {"workbench.colorTheme": $theme}' "$settings" 2>/dev/null >"$tmp" \
        || echo -e "{\n  \"workbench.colorTheme\": \"$theme_name\"\n}" >"$tmp"
      mv "$tmp" "$settings"
    else
      echo -e "{\n  \"workbench.colorTheme\": \"$theme_name\"\n}" >"$settings"
    fi
  fi

  # --- disable telemetry ---
  local argv_file="$HOME/.config/Code/argv.json"
  mkdir -p "$(dirname "$argv_file")"
  echo "[vscode] Disabling telemetry and crash reporter..."
  cat >"$argv_file" <<'EOF'
{
  "enable-crash-reporter": false,
  "enable-telemetry": false
}
EOF

  # also enforce in settings.json (idempotent)
  tmp="$(mktemp)"
  jq '. + {
    "telemetry.telemetryLevel": "off",
    "telemetry.enableCrashReporter": false,
    "telemetry.enableTelemetry": false,
    "update.showReleaseNotes": false,
    "update.mode": "none"
  }' "$settings" 2>/dev/null >"$tmp" || cat >"$settings" <<'EOF'
{
  "telemetry.telemetryLevel": "off",
  "telemetry.enableCrashReporter": false,
  "telemetry.enableTelemetry": false,
  "update.showReleaseNotes": false,
  "update.mode": "none"
}
EOF
  mv "$tmp" "$settings"
}

case $- in *i*) __vscode_bootstrap ;; esac
# --- end VS Code auto-setup ---
