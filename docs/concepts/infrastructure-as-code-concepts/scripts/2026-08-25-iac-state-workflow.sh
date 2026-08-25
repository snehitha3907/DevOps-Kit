#!/usr/bin/env bash
# last_verified: 2026-08-25 · Terraform/OpenTofu · n/a
#
# IaC state workflow practice — plan, apply, and rollback with backup.
# I built this to practice the full state lifecycle: init → plan → apply → verify → backup → rollback.
# Uses OpenTofu CLI but works identically with Terraform (swap tofu for terraform).

STATE_DIR="$(mktemp -d)"
BACKUP_DIR="${STATE_DIR}/backups"
TOFU="tofu"  # or "terraform" — doesn't matter for the pattern

mkdir -p "$BACKUP_DIR"
cd "$STATE_DIR" || { echo "could not enter ${STATE_DIR}"; exit 1; }

echo "=== IaC State Workflow Sandbox ==="
echo "Working dir: ${STATE_DIR}"
echo ""

# --- Step 1: Bootstrap a tiny OpenTofu project ---
# I always start with a minimal resource so I can see the state file shape
# without any distractions. null_resource is perfect — it creates nothing
# external but still exercises the full state lifecycle.
cat > main.tf <<'EOF'
terraform {
  required_version = ">= 1.0"
}

resource "null_resource" "demo" {
  triggers = {
    value = "v1"
  }
}

output "demo_id" {
  value = null_resource.demo.id
}
EOF

echo "[init] Initializing..."
$TOFU init -input=false -no-color

# --- Step 2: Plan before apply ---
# Plan is the safety net — I always check what will change before touching
# real state. Saving the plan to a file means apply can't drift from what
# I reviewed.
echo "[plan] Planning..."
$TOFU plan -out=tfplan -input=false -no-color

# --- Step 3: Apply the plan ---
echo "[apply] Applying..."
$TOFU apply -input=false -auto-approve -no-color tfplan

# --- Step 4: Snapshot state before making changes ---
# Before I mutate anything, I copy the state file to a timestamped backup.
# This is the "rollback point" — if the next apply breaks things, I can
# restore this snapshot and get back to a known-good state.
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup-${TIMESTAMP}.tfstate"
echo "[backup] Snapshotting state to $BACKUP_FILE"
cp terraform.tfstate "$BACKUP_FILE"

echo "[show] Current state:"
$TOFU show -no-color

# --- Step 5: Mutate the resource (simulate a change) ---
# I change the trigger value from v1 to v2 — this forces null_resource
# to replace itself, which is the simplest way to exercise state mutation.
echo "[mutate] Changing trigger to v2..."
sed -i 's/value = "v1"/value = "v2"/' main.tf
$TOFU plan -input=false -no-color
$TOFU apply -input=false -auto-approve -no-color

echo "[show] State after mutation:"
$TOFU show -no-color

# --- Step 6: Rollback — restore the backup ---
# This is the whole point: copy the backup over the current state, then
# plan to see what needs to change to get back to v1. In a real project
# you'd follow this with 'tofu apply' to actually undo the change.
echo "[rollback] Restoring state from $BACKUP_FILE"
cp "$BACKUP_FILE" terraform.tfstate
echo "[plan] Plan after rollback (shows what would restore v1):"
$TOFU plan -input=false -no-color

echo ""
echo "=== Rollback complete ==="
echo "Run 'tofu apply' to actually restore v1 if desired."

# --- Cleanup ---
echo "[destroy] Cleaning up..."
$TOFU destroy -input=false -auto-approve -no-color
rm -f tfplan
echo "=== Sandbox cleaned up — temp dir removed ==="
