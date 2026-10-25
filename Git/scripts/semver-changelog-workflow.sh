# last_verified: 2026-10-25 · Git n/a

# Git workflow automation: semantic versioning + conventional changelog generation.
#
# Scans conventional commits since the latest semver tag (v*), picks a bump
# level (BREAKING CHANGE -> major, feat -> minor, fix -> patch; highest wins),
# writes a grouped changelog, and creates the annotated release tag.
#
# Usage:
#   ./semver-changelog-workflow.sh [--major|--minor|--patch] [--no-push] [--changelog FILE]
#
# This is one way to automate release tagging from conventional commits; the
# bump can be overridden with a flag when the commit history is ambiguous.

FORCE_BUMP=""
NO_PUSH=0
CHANGELOG_FILE="CHANGELOG.md"

die() {
    echo "ERROR: $*" >&2
    exit 1
}

have_git() {
    command -v git >/dev/null 2>&1 || die "git is not installed or not on PATH"
}

in_repo() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "not inside a git repository"
}

clean_tree() {
    if ! git diff --quiet || ! git diff --cached --quiet; then
        die "working tree has uncommitted changes; commit or stash first"
    fi
}

parse_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --major) FORCE_BUMP="major" ;;
            --minor) FORCE_BUMP="minor" ;;
            --patch) FORCE_BUMP="patch" ;;
            --no-push) NO_PUSH=1 ;;
            --changelog)
                [ $# -gt 1 ] || die "--changelog requires a path"
                CHANGELOG_FILE="$2"
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [--major|--minor|--patch] [--no-push] [--changelog FILE]"
                exit 0
                ;;
            *) die "unknown argument: $1" ;;
        esac
        shift
    done
}

latest_tag() {
    git describe --tags --abbrev=0 --match='v*' 2>/dev/null || true
}

split_version() {
    # Echoes "MAJOR MINOR PATCH" for a v-prefixed semver tag.
    local v="${1#v}"
    case "$v" in
        ""|*[!0-9.]*) die "tag '$1' is not a semantic version" ;;
    esac
    local major="${v%%.*}"
    local rest="${v#*.}"
    if [ "$major" = "$rest" ]; then
        echo "$major 0 0"; return
    fi
    local minor="${rest%%.*}"
    local tail="${rest#*.}"
    if [ "$minor" = "$tail" ]; then
        echo "$major $minor 0"; return
    fi
    local patch="${tail#*.}"
    if [ "$patch" = "$tail" ]; then
        echo "$major $minor 0"; return
    fi
    echo "$major $minor $patch"
}

commits_since() {
    local since="$1"
    local pattern='^(feat|fix|chore|docs|refactor|test|build|ci|perf|style)'
    if [ -z "$since" ]; then
        git log --reverse --format='%s' -E --grep="$pattern"
    else
        git log --reverse "${since}..HEAD" --format='%s' -E --grep="$pattern"
    fi
}

auto_bump() {
    # Picks the highest bump level implied by the conventional commits.
    local since="$1"
    local level="patch"
    local msg
    while IFS= read -r msg; do
        [ -z "$msg" ] && continue
        case "$msg" in
            *BREAKING\ CHANGE*|*"!"*) level="major" ;;
            feat*) [ "$level" != "major" ] && level="minor" ;;
            fix*) [ "$level" = "patch" ] && level="patch" ;;
        esac
    done < <(commits_since "$since")
    echo "$level"
}

bump_version() {
    # $1 = bump level, $2..4 = major minor patch ; echoes vMAJOR.MINOR.PATCH
    local level="$1" major="$2" minor="$3" patch="$4"
    case "$level" in
        major) major=$((major + 1)); minor=0; patch=0 ;;
        minor) minor=$((minor + 1)); patch=0 ;;
        patch) patch=$((patch + 1)) ;;
        *) die "unknown bump level: $level" ;;
    esac
    echo "v${major}.${minor}.${patch}"
}

write_changelog() {
    local since="$1" new_tag="$2"
    {
        echo "# Changelog"
        echo
        echo "## ${new_tag}"
        echo
        local type label commits
        for type in feat fix chore docs refactor test build ci perf style; do
            case "$type" in
                feat) label="Features" ;;
                fix) label="Bug Fixes" ;;
                docs) label="Documentation" ;;
                refactor) label="Refactoring" ;;
                test) label="Tests" ;;
                build) label="Builds" ;;
                ci) label="Continuous Integration" ;;
                perf) label="Performance" ;;
                style) label="Styles" ;;
            esac
            commits=$(git log --reverse "${since}..HEAD" --format='- %s (%h)' -E --grep="^${type}" 2>/dev/null || true)
            [ -z "$commits" ] && continue
            echo "### ${label}"
            echo
            echo "$commits"
            echo
        done
    } > "$CHANGELOG_FILE"
}

main() {
    parse_args "$@"
    have_git
    in_repo
    clean_tree

    local since new_tag bump parts
    since=$(latest_tag)
    parts=($(split_version "$( [ -n "$since" ] && echo "$since" || echo "v0.0.0" )"))
    [ ${#parts[@]} -eq 3 ] || die "could not parse version parts from '$since'"

    if [ -n "$FORCE_BUMP" ]; then
        bump="$FORCE_BUMP"
    else
        bump=$(auto_bump "$since")
    fi

    new_tag=$(bump_version "$bump" "${parts[0]}" "${parts[1]}" "${parts[2]}")

    git rev-list -n1 "$new_tag" >/dev/null 2>&1 && die "tag '$new_tag' already exists"

    write_changelog "$since" "$new_tag"

    git add "$CHANGELOG_FILE"
    git commit -m "chore(release): prepare ${new_tag}" >/dev/null 2>&1 || true
    git tag -a "$new_tag" -m "${new_tag}

$(cat "$CHANGELOG_FILE")"

    echo "Created ${new_tag} (bump: ${bump}) and wrote ${CHANGELOG_FILE}"

    if [ "$NO_PUSH" -eq 1 ]; then
        echo "Skipping push (--no-push). Run: git push origin ${new_tag}"
    else
        git push origin "$new_tag" || die "failed to push tag '$new_tag'"
        echo "Pushed ${new_tag} to origin"
    fi
}

main "$@"
