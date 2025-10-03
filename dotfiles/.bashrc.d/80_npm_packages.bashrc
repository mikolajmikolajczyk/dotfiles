# Install mermaid-cli if not already installed
if ! command -v mmdc >/dev/null 2>&1; then
  npm install -g @mermaid-js/mermaid-cli
fi

# Install backport if not already installed
if ! command -v backport >/dev/null 2>&1; then
  npm install -g backport
fi

# Install GitHub Copilot CLI if not already installed
if ! command -v copilot >/dev/null 2>&1; then
  npm install -g @github/copilot
fi
