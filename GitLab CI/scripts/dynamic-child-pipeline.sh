#!/usr/bin/env bash
# last_verified: 2026-10-02 · GitLab CI/CD n/a
#
# dynamic-child-pipeline.sh — scaffold a parent pipeline that writes its child
# pipeline config at job time and then triggers it.
#
# Purpose: a static trigger job points `trigger: include:` at a file that is
#   already committed. A dynamic child pipeline points it at a file that does
#   not exist until an earlier job in the same pipeline creates it, so the file
#   has to be handed forward as an artifact before anything can trigger it.
# When to use: when the set of jobs is only knowable at run time — one job per
#   service discovered from a manifest, per tenant in a request body, per leg
#   of a matrix — rather than written down in a `.gitlab-ci.yml` by hand.
# Prerequisites: bash 4 or newer on the host that runs this, and a GitLab
#   project with a runner that can execute shell jobs. The component files this
#   script stubs out are the real input to the child config; edit them, they are
#   the part meant to change.
# Verify: run this script, then lint both files. The child config only exists
#   after the generator has run once, so lint the generator's output too:
#     ./generate-child.sh && gitlab-ci-lint child-pipeline.yml

set -euo pipefail

PROJECT_DIR="."
COMPONENTS="api,worker"
FORCE=0

usage() {
    cat <<'USAGE'
Usage: dynamic-child-pipeline.sh [options]

  --project-dir DIR   Directory to write into (default: .)
  --components LIST   Comma-separated component names to stub out
                      (default: api,worker)
  --force             Overwrite files that already exist
  -h, --help          Show this help

Writes, relative to --project-dir:
  .gitlab-ci.yml                        parent pipeline: prepare job, trigger job
  .gitlab/ci/child/generate-child.sh     writes the child config at job time
  .gitlab/ci/components/<name>.yml      one job fragment per component
USAGE
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --project-dir)
            [[ $# -ge 2 ]] || { echo "ERROR: --project-dir needs a value" >&2; exit 2; }
            PROJECT_DIR="$2"
            shift 2
            ;;
        --components)
            [[ $# -ge 2 ]] || { echo "ERROR: --components needs a value" >&2; exit 2; }
            COMPONENTS="$2"
            shift 2
            ;;
        --force)
            FORCE=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "ERROR: unknown argument: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

PARENT_CI="${PROJECT_DIR}/.gitlab-ci.yml"
CHILD_DIR="${PROJECT_DIR}/.gitlab/ci/child"
GEN_SCRIPT="${CHILD_DIR}/generate-child.sh"
COMPONENT_DIR="${PROJECT_DIR}/.gitlab/ci/components"
CHILD_CONFIG_REL=".gitlab/ci/child/child-pipeline.yml"

if [[ -e "$PARENT_CI" && $FORCE -ne 1 ]]; then
    echo "ERROR: ${PARENT_CI} already exists; pass --force to overwrite it" >&2
    exit 1
fi

IFS=',' read -r -a COMPONENT_NAMES <<< "$COMPONENTS"
if [[ ${#COMPONENT_NAMES[@]} -eq 0 ]]; then
    echo "ERROR: --components was empty" >&2
    exit 1
fi

for name in "${COMPONENT_NAMES[@]}"; do
    if [[ -z "$name" ]]; then
        continue
    fi
    # The name is interpolated into YAML and into a job key, and the generator
    # derives job names from it, so keep it to characters that cannot mean
    # anything structural.
    if [[ ! "$name" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
        echo "ERROR: component name '${name}' must be lowercase letters, digits and dashes" >&2
        exit 1
    fi
done

mkdir -p "$CHILD_DIR" "$COMPONENT_DIR"

# ---------------------------------------------------------------------------
# 1. Parent pipeline
#
# Nothing here is interpolated — the child config path is the same for every
# project that uses this scaffold, so the whole file is a literal heredoc and
# cannot be corrupted by whatever happens to be in the shell's environment.
# ---------------------------------------------------------------------------
cat > "$PARENT_CI" <<'PARENT_CI_EOF'
# .gitlab-ci.yml — parent pipeline for a dynamic child pipeline.
# Written by dynamic-child-pipeline.sh. It is yours now; edit it directly.

stages:
  - prepare
  - trigger

# The prepare job writes this file. The trigger job reads it. Keeping the path
# in one variable means the two can never drift apart.
variables:
  CHILD_CONFIG: .gitlab/ci/child/child-pipeline.yml

child-config:
  stage: prepare
  script:
    - bash .gitlab/ci/child/generate-child.sh
    - echo "--- generated child config ---"
    - cat "${CHILD_CONFIG}"
  artifacts:
    # Without this, the file exists only inside the prepare job and the
    # trigger job below has nothing to include.
    paths:
      - .gitlab/ci/child/child-pipeline.yml
    expire_in: 1 hour

run-child:
  stage: trigger
  needs:
    - job: child-config
      artifacts: true
  trigger:
    include:
      - local: .gitlab/ci/child/child-pipeline.yml
    strategy: depend
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
PARENT_CI_EOF

echo "wrote ${PARENT_CI}"

# ---------------------------------------------------------------------------
# 2. Generator that runs inside the prepare job
#
# Also a literal heredoc: this script is written into the user's project, not
# executed here, so nothing about this shell's state should leak into it.
# ---------------------------------------------------------------------------
cat > "$GEN_SCRIPT" <<'GENERATOR_EOF'
#!/usr/bin/env bash
# last_verified: 2026-10-02 · GitLab CI/CD n/a
#
# generate-child.sh — writes the child pipeline config from whatever component
# fragments are in .gitlab/ci/components/ at the moment the job runs.
#
# The output path is hard-coded because the parent's trigger job names it as a
# literal. Change one, change both.

set -euo pipefail

PROJECT_ROOT="${CI_PROJECT_DIR:-$(pwd)}"
COMPONENT_DIR="${PROJECT_ROOT}/.gitlab/ci/components"
OUT="${PROJECT_ROOT}/.gitlab/ci/child/child-pipeline.yml"

if [[ ! -d "$COMPONENT_DIR" ]]; then
    echo "ERROR: no component directory at ${COMPONENT_DIR}" >&2
    exit 1
fi

declare -A seen_stage=()
stages=()

# Append a stage to the list the first time it is seen, keeping first-seen
# order. A stage a fragment's jobs refer to but that was never declared is what
# makes GitLab reject a child pipeline, so order is derived from the fragments
# themselves rather than from a hand-maintained list.
register_stage() {
    local stage="$1"
    if [[ -z "${seen_stage[$stage]:-}" ]]; then
        seen_stage[$stage]=1
        stages+=("$stage")
    fi
}

# First pass: collect stage names. The '# stage:' header orders the component
# (it is the stage the component itself belongs to); any further 'stage:' lines
# inside the fragment belong to its jobs and are appended after it. A component
# with no header is a mistake worth failing on, not guessing around.
for file in "${COMPONENT_DIR}"/*.yml; do
    [[ -e "$file" ]] || continue
    header="$(sed -n 's/^# stage:[[:space:]]*//p' "$file" | head -n 1)"
    if [[ -z "$header" ]]; then
        echo "ERROR: $(basename "$file") has no '# stage:' header" >&2
        exit 1
    fi
    register_stage "$header"
    while IFS= read -r used; do
        [[ -n "$used" ]] && register_stage "$used"
    done < <(sed -n 's/^[[:space:]]*stage:[[:space:]]*//p' "$file")
done

if [[ ${#stages[@]} -eq 0 ]]; then
    echo "ERROR: no component files in ${COMPONENT_DIR}; nothing to generate" >&2
    exit 1
fi

# Second pass: emit the config. The ${stages[@]+...} guard keeps set -u quiet if
# the array is ever empty on an older bash.
{
    echo "# generated by generate-child.sh — do not edit by hand"
    echo "# components: $(cd "$COMPONENT_DIR" && ls ./*.yml | tr '\n' ' ')"
    echo "stages:"
    for stage in ${stages[@]+"${stages[@]}"}; do
        echo "  - ${stage}"
    done
    for file in "${COMPONENT_DIR}"/*.yml; do
        [[ -e "$file" ]] || continue
        echo
        echo "# --- $(basename "$file") ---"
        # Drop the '# stage:' directive; it has been hoisted into stages: above.
        sed '1{/^# stage:/d;}' "$file"
    done
} > "$OUT"

echo "wrote ${OUT} (${#stages[@]} stage(s), $(find "$COMPONENT_DIR" -maxdepth 1 -name '*.yml' | wc -l) component(s))"
GENERATOR_EOF

chmod +x "$GEN_SCRIPT"
echo "wrote ${GEN_SCRIPT}"

# ---------------------------------------------------------------------------
# 3. Component fragments — the part that is actually meant to be edited
#
# This heredoc is unquoted because the component name has to land in the YAML,
# so it is validated against ^[a-z0-9][a-z0-9-]*$ above, before it gets here.
# ---------------------------------------------------------------------------
stubbed=0
skipped=0
for name in "${COMPONENT_NAMES[@]}"; do
    [[ -n "$name" ]] || continue
    target="${COMPONENT_DIR}/${name}.yml"
    if [[ -e "$target" && $FORCE -ne 1 ]]; then
        echo "kept   ${target} (exists)"
        skipped=$((skipped + 1))
        continue
    fi
    cat > "$target" <<COMPONENT_EOF
# stage: build
#
# Everything below is pasted into the child pipeline verbatim, so keep this file
# to job definitions: no stages: key, no include:, no workflow:.
${name}-build:
  stage: build
  script:
    - echo "Building ${name} on \$CI_COMMIT_SHORT_SHA"

${name}-test:
  stage: test
  script:
    - echo "Testing ${name}"
  needs:
    - ${name}-build
COMPONENT_EOF
    echo "wrote  ${target}"
    stubbed=$((stubbed + 1))
done

# ---------------------------------------------------------------------------
# 4. Lint what was just written
#
# The child config does not exist until the generator runs, so the generator is
# run here too — that way both files are checked before anyone pushes.
# ---------------------------------------------------------------------------
validate_yaml() {
    local file="$1"
    if command -v gitlab-ci-lint >/dev/null 2>&1; then
        gitlab-ci-lint "$file" >/dev/null && echo "  ok (gitlab-ci-lint) ${file}"
    elif python3 -c 'import yaml' >/dev/null 2>&1; then
        python3 -c 'import sys, yaml; yaml.safe_load(open(sys.argv[1]))' "$file" \
            && echo "  ok (python yaml) ${file}"
    else
        echo "  skipped ${file} — no gitlab-ci-lint and no python yaml module"
    fi
}

echo ""
echo "linting:"
validate_yaml "$PARENT_CI"

if (cd "$PROJECT_DIR" && bash "$GEN_SCRIPT" >/dev/null); then
    validate_yaml "${PROJECT_DIR}/${CHILD_CONFIG_REL}"
    rm -f "${PROJECT_DIR}/${CHILD_CONFIG_REL}"
else
    echo "ERROR: the generator failed on the stubs just written; fix the component files first" >&2
    exit 1
fi

echo ""
echo "Done. ${stubbed} component file(s) written, ${skipped} left alone."
echo "Next: edit the fragments in .gitlab/ci/components/, commit all of it, push to the default branch."
