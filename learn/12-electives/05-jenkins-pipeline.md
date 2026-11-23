---
last_verified: 2026-11-23
tool_version: "2.580.2"
sources:
  - https://www.jenkins.io/doc/book/pipeline/syntax/
  - https://www.jenkins.io/changelog-stable/
---

# Rebuild the sample app pipeline in Jenkins

This is the electives stage: you already have a GitHub Actions workflow that builds, tests, scans and publishes the sample app image. Here you rebuild the same pipeline as a declarative Jenkinsfile on Jenkins LTS 2.580.2, so you can compare the two tools side by side.

## What you'll learn

- Write a declarative Jenkinsfile with build, test, scan and push stages
- Keep the top-level agent as `none` so every stage declares its own agent
- Bind registry credentials and scan with Trivy before anything is pushed

## Before you start

- [Scan and publish the image from CI](../05-ci-cd/04-gha-scan-push.md) — the build/scan/publish sequence you are recreating; your sample app repo with a Dockerfile and a passing `npm test`.
- [Jenkins — quick primer](../../jnk/notes/0000-primer-jenkins.md) — what Jenkins is and how a pipeline is structured.
- Jenkins LTS 2.580.2 running with the "Pipeline: Declarative" plugin. Confirm with the version shown at the bottom of any Jenkins page (LTS 2.580.2 requires Java 21 or 25).
- Docker available to the Jenkins agent — the build and scan stages run `docker` commands.
- A registry credential stored in Jenkins (Manage Jenkins → Credentials) with the id `registry-creds`.

## Walkthrough

1. Add a `Jenkinsfile` at the root of your sample app repo. The companion file `Jenkins/scripts/Jenkinsfile` is a ready-to-use copy.

   ```groovy
   pipeline {
       agent none

       environment {
           REGISTRY       = 'registry.example.com'
           IMAGE          = "${REGISTRY}/sample-app:${BUILD_NUMBER}"
           REGISTRY_CREDS = credentials('registry-creds')
       }

       stages {
           stage('Build') {
               agent { label 'docker' }
               steps {
                   checkout scm
                   sh 'docker build -t $IMAGE .'
               }
           }

           stage('Test') {
               agent {
                   docker {
                       image 'node:20-alpine'
                       reuseNode true
                   }
               }
               steps {
                   sh 'npm ci'
                   sh 'npm test'
               }
           }

           stage('Scan') {
               agent { label 'docker' }
               steps {
                   sh '''
                       docker run --rm \
                         -v /var/run/docker.sock:/var/run/docker.sock \
                         aquasec/trivy:0.76.2 image \
                         --severity HIGH,CRITICAL --exit-code 1 \
                         $IMAGE
                   '''
               }
           }

           stage('Push') {
               agent { label 'docker' }
               steps {
                   sh 'echo $REGISTRY_CREDS_PSW | docker login $REGISTRY -u $REGISTRY_CREDS_USR --password-stdin'
                   sh 'docker push $IMAGE'
               }
           }
       }

       post {
           always {
               junit 'target/surefire-reports/*.xml'
               archiveArtifacts artifacts: 'trivy-report.json', allowEmptyArchive: true
           }
           failure {
               echo 'Pipeline failed — check the stage that turned red.'
           }
       }
   }
   ```

   You should see: a pipeline with four stages — Build, Test, Scan, Push — wrapped in a `pipeline { }` block, with the top-level `agent none` forcing each stage to declare its own agent.

   `agent none` at the top means no agent is allocated for the whole run; every stage picks the agent it needs. Build and Push run on a labelled `docker` agent that has the Docker daemon, Test runs inside a `node:20-alpine` container so the app's toolchain is available without installing it on the agent, and Scan runs on the `docker` agent so it can reach the image through the socket. The `environment` block binds the `registry-creds` credential: Jenkins injects `REGISTRY_CREDS`, `REGISTRY_CREDS_USR` and `REGISTRY_CREDS_PSW` automatically. The Trivy stage runs before Push, so a scan that finds HIGH or CRITICAL vulnerabilities exits non-zero (because of `--exit-code 1`) and stops the pipeline before anything is published. The image is tagged with `${BUILD_NUMBER}`, so every published image traces to one build. Pinning `aquasec/trivy:0.76.2` avoids a surprise behaviour change from a new Trivy release.

2. Validate the Jenkinsfile before committing it. Jenkins exposes a validator endpoint:

   ```bash
   curl -X POST -F "jenkinsfile=<$PWD/Jenkinsfile" \
     ${JENKINS_URL}/pipeline-model-converter/validate
   ```

   You should see: `Jenkinsfile successfully validated` when the syntax and structure are correct, or a parse error pointing at the offending line. Every valid declarative pipeline must be wrapped in a `pipeline { }` block with at least one `agent` and a `stages { }` block — the validator rejects anything that is not.

3. Create a Pipeline job in Jenkins (New Item → Pipeline) and point it at your repo: set "Pipeline script from SCM", choose Git, and give the repository URL and credentials. Leave the script path as `Jenkinsfile`.

   You should see: a job whose definition comes from the `Jenkinsfile` in your repo, so the pipeline is versioned with the code.

4. Run the job with "Build Now" and watch the stage view.

   ```bash
   # Trigger from the CLI instead (requires the Jenkins CLI jar)
   java -jar jenkins-cli.jar -s ${JENKINS_URL}/ build sample-app-pipeline -s -v
   ```

   You should see: stages turning green in order — Build, Test, Scan, Push — with the Scan stage failing the run when HIGH or CRITICAL findings exist, and the Push stage never running in that case. The `post { always { ... } }` block archives the JUnit test reports and any Trivy report regardless of the outcome, so you can inspect them after a failure.

## Exercise

In your own repository:

1. Copy the `Jenkinsfile` from the walkthrough to the repo root and commit it.
2. Create a Jenkins Pipeline job pointing at the repo and run it.
3. Confirm all four stages pass and the image is pushed tagged with the build number.
4. Introduce a CRITICAL-level finding in the image and run the job again — confirm the Scan stage fails and Push does not run.
5. Remove the finding and confirm a clean run pushes a new image.

Do not paste the run output inline — run the commands yourself and record the result.

## Check your work

```bash
curl -X POST -F "jenkinsfile=<$PWD/Jenkinsfile" \
  ${JENKINS_URL}/pipeline-model-converter/validate
# Jenkinsfile successfully validated
ls target/surefire-reports/*.xml 2>/dev/null   # JUnit reports archived by post { always }
docker images | grep sample-app                 # local image built by the Build stage
```

You should see: the validator reports `Jenkinsfile successfully validated`, JUnit report files exist under `target/surefire-reports/` after the Test stage, and a `sample-app` image is present locally. On a clean run the job concludes SUCCESS and the registry holds `sample-app:<build-number>`.

## Common mistakes

- Writing Groovy outside `script { }` — Declarative Pipeline only allows scripted steps inside `script { }` blocks; bare Groovy such as a `for` loop at the top level causes `No such DSL method` errors.
- Missing the "Pipeline: Declarative" plugin — without it the `pipeline { }` block is not recognised and the job fails to parse the Jenkinsfile.
- Running builds on the controller — leave the controller with zero executors (`agent none` at the top) so builds never run where Jenkins itself runs.
- Publishing before scanning — if Push runs before Scan, an image with HIGH or CRITICAL findings reaches the registry; keep Scan ahead of Push and use `--exit-code 1`.
- Forgetting `--exit-code 1` — Trivy exits 0 even when it finds vulnerabilities unless you pass `--exit-code 1`, so the gate would never fail.
- A missing Docker daemon on the agent — the build and scan stages fail with a connection error; the agent image must provide Docker, or mount the socket.

## Next

[OpenTofu — quick primer](../../OpenTofu/notes/0000-primer-opentofu.md)
