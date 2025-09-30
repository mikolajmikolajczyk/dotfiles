#!/usr/bin/env bash
set -euo pipefail
# Usage: install-k8s-tooling.sh <kubectl_ver> <helm_ver> <kustomize_ver> <k9s_ver> <enable_k9s> <enable_krew>
kubectl_ver="${1:?kubectl_ver}"; helm_ver="${2:?helm_ver}"; kustomize_ver="${3:?kustomize_ver}"
k9s_ver="${4:?k9s_ver}"; enable_k9s="${5:-1}"; enable_krew="${6:-1}"

arch="$(uname -m)"
case "$arch" in x86_64) a=amd64 ;; aarch64) a=arm64 ;; *) echo "unsupported arch: $arch" >&2; exit 1 ;; esac

# kubectl
curl -fsSL -o /usr/local/bin/kubectl "https://dl.k8s.io/release/v${kubectl_ver}/bin/linux/${a}/kubectl"
chmod +x /usr/local/bin/kubectl

# helm
curl -fsSL "https://get.helm.sh/helm-v${helm_ver}-linux-${a}.tar.gz" -o /tmp/helm.tgz
tar -xzf /tmp/helm.tgz -C /tmp && mv "/tmp/linux-${a}/helm" /usr/local/bin/helm
rm -rf /tmp/helm.tgz "/tmp/linux-${a}"

# kustomize
curl -fsSL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v${kustomize_ver}/kustomize_v${kustomize_ver}_linux_${a}.tar.gz" -o /tmp/kustomize.tgz
tar -xzf /tmp/kustomize.tgz -C /usr/local/bin
rm -f /tmp/kustomize.tgz

# kubectx/kubens
curl -fsSL -o /usr/local/bin/kubectx "https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx"
curl -fsSL -o /usr/local/bin/kubens  "https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens"
chmod +x /usr/local/bin/kubectx /usr/local/bin/kubens

# krew (+ resource-capacity)
if [[ "${enable_krew}" == "1" ]]; then
  OS=linux; ARCH="${a}"; KREW="krew-${OS}_${ARCH}"
  tmp="$(mktemp -d)"; pushd "$tmp" >/dev/null
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz"
  tar -zxf "${KREW}.tar.gz"
  KREW_ROOT="/usr/local/krew" "./${KREW}" install krew
  popd >/dev/null; rm -rf "$tmp"
  KREW_ROOT="/usr/local/krew" kubectl krew update
  KREW_ROOT="/usr/local/krew" kubectl krew install resource-capacity
fi

# k9s
if [[ "${enable_k9s}" == "1" ]]; then
  curl -fsSL -o /tmp/k9s.tgz "https://github.com/derailed/k9s/releases/download/v${k9s_ver}/k9s_Linux_${a}.tar.gz"
  tar -xzf /tmp/k9s.tgz -C /tmp && mv /tmp/k9s /usr/local/bin/k9s && chmod +x /usr/local/bin/k9s
  rm -f /tmp/k9s.tgz
fi
