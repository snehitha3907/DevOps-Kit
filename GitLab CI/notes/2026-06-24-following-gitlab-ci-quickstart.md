# Following the GitLab CI/CD quickstart

I went through the official GitLab CI/CD quickstart at about.gitlab.com/ci-cd/. The primer already covered the big picture, so this was about actually running a pipeline.

## Steps

Created a project on GitLab.com, then added a `.gitlab-ci.yml`:

```yaml
stages:
  - build
  - test

build-job:
  stage: build
  script:
    - echo "Building..."
    - mkdir -p artifacts

test-job:
  stage: test
  script:
    - echo "Testing..."
```

Pushed it to the repo. A pipeline started automatically. I watched it in CI/CD > Pipelines. The build and test jobs ran in sequence.

## What tripped me up

- I expected `artifacts:` to work without a `pages:` or `dependencies:` setup. The quickstart doesn't go into artifacts. I added `artifacts:` anyway and got confused when the file disappeared after the next job.
- The pipeline starts on push automatically. There's no manual trigger needed. I was looking for a "Run" button but the push detection is instant.
- The default runner is the shared GitLab SaaS runner. If you're self-hosting, you need to register your own runner first — that was covered in the primer and the install script.
- The quickstart assumes you already have a project. I spent a few minutes creating a blank project and cloning it locally before I could push the YAML.
- The YAML indentation is strict. I used spaces but had a mix of 2 and 4 spaces on different lines — GitLab rejected the push. Lint tool under CI/CD > Pipelines caught it.

## What worked

The pipeline ran end-to-end. Both jobs passed. I saw green checkmarks and timestamps in the UI. The whole thing took maybe 5 minutes from push to pass.
