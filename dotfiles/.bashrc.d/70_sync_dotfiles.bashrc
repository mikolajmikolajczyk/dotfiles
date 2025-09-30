# Dotfiles
alias sync_dotfiles='/repo/scripts/sync-dir.sh /repo/dotfiles "$HOME" --mode dotfiles'

# Secrets (per-container)
alias sync_secrets='/repo/scripts/sync-dir.sh /secrets "$HOME" --mode secrets'

# Global secrets (shared)
alias sync_global_secrets='/repo/scripts/sync-dir.sh /global-secrets "$HOME" --mode secrets'

# All at once
sync_all() {
  sync_dotfiles
  sync_secrets
  sync_global_secrets
}
