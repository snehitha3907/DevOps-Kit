#!/usr/bin/env bash
# last_verified: 2026-10-09 · bash · n/a
# Validate Terraform module structure before publishing.
# Usage: ./validate-module.sh <module-path>

set -euo pipefail

MODULE_PATH="${1:-.}"

echo "Validating module at: ${MODULE_PATH}"

if [[ ! -d "${MODULE_PATH}" ]]; then
  echo "Error: Module path '${MODULE_PATH}' does not exist"
  exit 1
fi

cd "${MODULE_PATH}"

# Check required files
REQUIRED_FILES=("main.tf" "variables.tf" "outputs.tf" "versions.tf" "README.md")
MISSING_FILES=()

for f in "${REQUIRED_FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    MISSING_FILES+=("$f")
  fi
done

if [[ ${#MISSING_FILES[@]} -gt 0 ]]; then
  echo "Error: Missing required files:"
  printf '  %s\n' "${MISSING_FILES[@]}"
  exit 1
fi

echo "✓ All required files present"

# Check versions.tf content
if ! grep -q "required_version" versions.tf; then
  echo "Error: versions.tf must declare required_version"
  exit 1
fi

if ! grep -q "required_providers" versions.tf; then
  echo "Error: versions.tf must declare required_providers"
  exit 1
fi

echo "✓ versions.tf declares required_version and required_providers"

# Terraform format check
echo "Checking terraform fmt..."
if ! terraform fmt -check -diff; then
  echo "Error: terraform fmt check failed. Run 'terraform fmt' to fix."
  exit 1
fi

echo "✓ terraform fmt passed"

# Terraform init (no backend)
echo "Running terraform init -backend=false..."
if ! terraform init -backend=false >/dev/null 2>&1; then
  echo "Error: terraform init failed"
  exit 1
fi

echo "✓ terraform init succeeded"

# Terraform validate
echo "Running terraform validate..."
if ! terraform validate; then
  echo "Error: terraform validate failed"
  exit 1
fi

echo "✓ terraform validate passed"

# Check for .tfstate files in git
if git ls-files --error-unmatch '*.tfstate' '*.tfstate.*' >/dev/null 2>&1; then
  echo "Warning: .tfstate files are tracked in git. Consider adding to .gitignore"
fi

# Check for examples directory
if [[ -d "examples" ]]; then
  echo "✓ examples/ directory present"
  EXAMPLE_COUNT=$(find examples -mindepth 1 -maxdepth 1 -type d | wc -l)
  echo "  Found ${EXAMPLE_COUNT} example(s)"
else
  echo "Warning: No examples/ directory found (recommended for Registry)"
fi

echo ""
echo "=== Validation Summary ==="
echo "Module path: ${MODULE_PATH}"
echo "All checks passed ✓"
echo ""
echo "Module is ready for publishing."