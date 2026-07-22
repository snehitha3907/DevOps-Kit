#!/usr/bin/env bash
# last_verified: 2026-07-22 - n/a

# kp - Pod troubleshooting shell function
# Combines logs, describe, exec, and port-forward into one interactive call.
#
# Usage: kp <pod-name> [namespace]
#   kp my-pod              # interactive menu, default namespace
#   kp my-pod kube-system  # interactive menu in specific namespace

kp() {
  local pod="$1"
  local ns="${2:-default}"

  if [[ -z "$pod" ]]; then
    echo "Usage: kp <pod-name> [namespace]" >&2
    return 1
  fi

  if ! kubectl get pod "$pod" -n "$ns" &>/dev/null; then
    echo "Error: pod '$pod' not found in namespace '$ns'" >&2
    return 1
  fi

  echo "=== Pod: $pod (ns: $ns) ==="
  echo "1) Logs (tail -f)"
  echo "2) Describe"
  echo "3) Exec (interactive shell)"
  echo "4) Port-forward"
  echo "q) Quit"
  read -rp "Choice: " choice

  case "$choice" in
    1) kubectl logs -f "$pod" -n "$ns" ;;
    2) kubectl describe pod "$pod" -n "$ns" ;;
    3) kubectl exec -it "$pod" -n "$ns" -- sh -c "exec \$(command -v bash || command -v sh)" ;;
    4)
      read -rp "Local port: " lport
      read -rp "Pod port: " pport
      kubectl port-forward "$pod" -n "$ns" "$lport:$pport"
      ;;
    q) return 0 ;;
    *) echo "Invalid choice" >&2; return 1 ;;
  esac
}
