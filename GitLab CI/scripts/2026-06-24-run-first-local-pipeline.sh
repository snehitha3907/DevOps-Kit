#!/bin/sh

mkdir -p /tmp/gitlab-local-pipeline
cd /tmp/gitlab-local-pipeline || exit 1

cat > .gitlab-ci.yml <<'EOF'
stages:
  - build
  - test
  - deploy

build-job:
  stage: build
  script:
    - echo "Building the app..."
    - mkdir -p build
    - echo "built" > build/output.txt
  artifacts:
    paths:
      - build/

test-job:
  stage: test
  script:
    - echo "Running tests..."
    - test -f build/output.txt && echo "Build artifact found"

deploy-job:
  stage: deploy
  script:
    - echo "Deploying to staging..."
    - echo "Done"
EOF

echo "Created .gitlab-ci.yml. Running pipeline with GitLab Runner..."
gitlab-runner exec docker build-job
gitlab-runner exec docker test-job
