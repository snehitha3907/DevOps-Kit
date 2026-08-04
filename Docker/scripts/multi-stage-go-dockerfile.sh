#!/usr/bin/env bash
# last_verified: 2026-08-04 · Docker n/a
# multi-stage-go-dockerfile.sh
# Builds a multi-stage Go application Docker image with layer caching
# and a .dockerignore file to minimize build context size.

set -euo pipefail

PROJECT_DIR="${1:-.}"
IMAGE_NAME="${2:-multi-stage-go-app}"
TAG="${3:-latest}"

dockerfile_path="${PROJECT_DIR}/Dockerfile"
dockerignore_path="${PROJECT_DIR}/.dockerignore"

create_dockerignore() {
    cat > "${dockerignore_path}" << 'DOCKERIGNORE'
.git
.gitignore
*.md
*.test
*_test.go
vendor/
bin/
obj/
.env
DOCKERIGNORE
    printf "Created .dockerignore at %s\n" "${dockerignore_path}"
}

build_image() {
    if [[ ! -f "${dockerfile_path}" ]]; then
        printf "ERROR: Dockerfile not found at %s\n" "${dockerfile_path}" >&2
        exit 1
    fi

    printf "Building Docker image %s:%s from %s\n" "${IMAGE_NAME}" "${TAG}" "${PROJECT_DIR}"
    docker build \
        --cache-from "${IMAGE_NAME}:${TAG}" \
        -t "${IMAGE_NAME}:${TAG}" \
        -f "${dockerfile_path}" \
        "${PROJECT_DIR}"
}

verify_build() {
    printf "\nVerifying image %s:%s\n" "${IMAGE_NAME}" "${TAG}"
    docker inspect --format 'Size: {{.Size}} bytes' "${IMAGE_NAME}:${TAG}" 2>/dev/null || {
        printf "ERROR: Image %s:%s not found after build\n" "${IMAGE_NAME}" "${TAG}" >&2
        exit 1
    }
    docker images "${IMAGE_NAME}" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
}

main() {
    printf "=== Multi-stage Go Docker Build ===\n\n"
    create_dockerignore
    build_image
    verify_build
    printf "\nBuild complete.\n"
}

main "$@"