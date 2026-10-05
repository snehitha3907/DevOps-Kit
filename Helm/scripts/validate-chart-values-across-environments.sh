#!/usr/bin/env bash
# last_verified: 2026-10-05 · Helm n/a
#
# validate-chart-values-across-environments.sh — render and cross-check one chart
# against a values file per environment.
#
# Purpose: catch per-environment values mistakes before they reach the cluster
# by running `helm lint` and `helm template` for every environment with the
# same chart and reporting which environments fail or drift from each other.
#
# When to use: a chart ships defaults in values.yaml and each environment
# layers its own file (optionally over a shared values-common.yaml). Run this
# script in CI or before `helm upgrade` to prove every environment still
# renders, that expected per-environment strings land in the manifests, and
# to see a diff between environments. This is one way to validate values;
# `helm lint --strict` or a schema file covers adjacent checks.
#
# Prerequisites: helm on PATH; a chart directory; one values file per
# environment. Rendering is fully local — no cluster connection is used.
#
# Steps: lint each environment, template each environment into --out-dir,
# run each --expect assertion, then diff every environment against the first.
#
# Verify: exit 0 means every environment linted, rendered, and matched its
# expectations. Exit 1 means a validation failure (see the FAIL lines).
# Exit 2 means a usage error.
#
# Common errors: an environment fails lint while others pass — usually a typo
# or wrong type in that environment's values file; an --expect miss — the
# key is absent or spelled differently in the values layer for that
# environment; empty rendered output — the chart's templates guard on a value
# no file sets.
set -euo pipefail

CHART=""
COMMON=""
OUT_DIR="./rendered-values-check"
RELEASE="values-check"
env_names=()
env_files=()
expects=()

usage() {
  cat <<'USAGE'
Usage: validate-chart-values-across-environments.sh --chart DIR --env NAME=FILE [--env NAME=FILE ...]
         [--common FILE] [--expect ENV:SUBSTRING ...] [--out-dir DIR] [--release NAME]

  --chart DIR          chart directory to lint and render (required)
  --env NAME=FILE      one environment name and its values file (repeatable, at least one required)
  --common FILE        shared values file layered under every environment file (optional)
  --expect ENV:STRING  assert rendered manifest for ENV contains STRING (repeatable, optional)
  --out-dir DIR        where to write <env>.yaml renders (default: ./rendered-values-check)
  --release NAME       release name used for rendering (default: values-check)
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --chart) CHART="${2:-}"; shift 2 ;;
    --common) COMMON="${2:-}"; shift 2 ;;
    --env) env_names+=("${2%%=*}"); env_files+=("${2#*=}"); shift 2 ;;
    --expect) expects+=("$2"); shift 2 ;;
    --out-dir) OUT_DIR="${2:-}"; shift 2 ;;
    --release) RELEASE="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "ERROR: unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ -z "$CHART" ]]; then
  echo "ERROR: --chart is required." >&2; usage >&2; exit 2
fi
if [[ "${#env_names[@]}" -eq 0 ]]; then
  echo "ERROR: at least one --env NAME=FILE is required." >&2; usage >&2; exit 2
fi
if [[ ! -d "$CHART" ]]; then
  echo "ERROR: chart directory not found: $CHART" >&2; exit 2
fi
if [[ -n "$COMMON" && ! -f "$COMMON" ]]; then
  echo "ERROR: common values file not found: $COMMON" >&2; exit 2
fi

failures=0
mkdir -p "$OUT_DIR"

i=0
for name in "${env_names[@]}"; do
  file="${env_files[$i]}"
  i=$((i + 1))
  if [[ ! -f "$file" ]]; then
    echo "FAIL [$name]: values file not found: $file (expected NAME=FILE)" >&2
    failures=$((failures + 1))
    continue
  fi

  lint_args=("$CHART")
  if [[ -n "$COMMON" ]]; then
    lint_args+=(-f "$COMMON")
  fi
  lint_args+=(-f "$file")

  if helm lint "${lint_args[@]}" >/dev/null 2>&1; then
    echo "PASS [$name]: helm lint clean"
  else
    echo "FAIL [$name]: helm lint reported problems" >&2
    helm lint "${lint_args[@]}" >&2 || true
    failures=$((failures + 1))
    continue
  fi

  rendered="$OUT_DIR/$name.yaml"
  template_args=("$RELEASE" "$CHART")
  if [[ -n "$COMMON" ]]; then
    template_args+=(-f "$COMMON")
  fi
  template_args+=(-f "$file")
  if helm template "${template_args[@]}" > "$rendered" 2>/dev/null; then
    if [[ -s "$rendered" ]]; then
      echo "PASS [$name]: rendered to $rendered"
    else
      echo "FAIL [$name]: helm template wrote empty output" >&2
      failures=$((failures + 1))
    fi
  else
    echo "FAIL [$name]: helm template failed" >&2
    failures=$((failures + 1))
  fi
done

if [[ "${#expects[@]}" -gt 0 ]]; then
for assertion in "${expects[@]}"; do
  env="${assertion%%:*}"
  substring="${assertion#*:}"
  rendered="$OUT_DIR/$env.yaml"
  if [[ ! -f "$rendered" ]]; then
    echo "FAIL [expect $env]: no rendered manifest for environment '$env' — check --env names" >&2
    failures=$((failures + 1))
    continue
  fi
  if grep -F -q -- "$substring" "$rendered"; then
    echo "PASS [expect $env]: found '$substring'"
  else
    echo "FAIL [expect $env]: '$substring' not found in $rendered" >&2
    failures=$((failures + 1))
  fi
done
fi

if [[ "${#env_names[@]}" -gt 1 ]]; then
  first="${env_names[0]}"
  j=1
  while [[ "$j" -lt "${#env_names[@]}" ]]; do
    other="${env_names[$j]}"
    j=$((j + 1))
    if [[ -f "$OUT_DIR/$first.yaml" && -f "$OUT_DIR/$other.yaml" ]]; then
      drift_file="$OUT_DIR/drift-$first-vs-$other.diff"
      if diff -u "$OUT_DIR/$first.yaml" "$OUT_DIR/$other.yaml" > "$drift_file" 2>/dev/null; then
        echo "INFO [$first vs $other]: renders are identical"
        rm -f "$drift_file"
      else
        lines=$(wc -l < "$drift_file")
        echo "INFO [$first vs $other]: renders differ ($lines diff lines, see $drift_file)"
      fi
    fi
  done
fi

if [[ "$failures" -gt 0 ]]; then
  echo "RESULT: $failures check(s) failed." >&2
  exit 1
fi
echo "RESULT: all environments rendered and matched expectations."
