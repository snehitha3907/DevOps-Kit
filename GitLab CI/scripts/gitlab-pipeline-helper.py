# last_verified: 2026-10-23 · GitLab CI python-gitlab

"""Reusable helper over the GitLab REST API (python-gitlab)."""

import os
import sys

import gitlab


def client():
    url = os.environ.get("GITLAB_URL")
    token = os.environ.get("GITLAB_TOKEN")
    if not url or not token:
        raise SystemExit("GITLAB_URL and GITLAB_TOKEN are required")
    return gitlab.Gitlab(url, private_token=token)


def summarise_pipeline(project_id, commit_sha):
    gl = client()
    project = gl.projects.get(project_id)
    pipelines = project.pipelines.list(sha=commit_sha)
    if not pipelines:
        print("no pipeline for", commit_sha)
        return
    for p in pipelines:
        print(f"pipeline {p.id}: status={p.status} ref={p.ref}")
        for j in p.jobs.list(get_all=True):
            print(f"  job {j.id} {j.name}: {j.status}")


def failing_traces(project_id, pipeline_id):
    gl = client()
    project = gl.projects.get(project_id)
    pipeline = project.pipelines.get(pipeline_id)
    for j in pipeline.jobs.list(get_all=True):
        if j.status == "failed":
            job = project.jobs.get(j.id)
            trace = job.trace().decode("utf-8", errors="replace")
            print(f"=== {job.name} ({job.id}) ===")
            for line in trace.splitlines():
                if "error" in line.lower() or "fail" in line.lower():
                    print(line)


def retry_job(project_id, job_id):
    gl = client()
    project = gl.projects.get(project_id)
    project.jobs.get(job_id).retry()
    print("retried", job_id)


def cancel_job(project_id, job_id):
    gl = client()
    project = gl.projects.get(project_id)
    project.jobs.get(job_id).cancel()
    print("cancelled", job_id)


def main():
    if len(sys.argv) < 2:
        print("usage: gitlab-pipeline-helper.py <summarise|traces|retry|cancel> ...")
        sys.exit(1)
    cmd = sys.argv[1]
    if cmd == "summarise":
        summarise_pipeline(sys.argv[2], sys.argv[3])
    elif cmd == "traces":
        failing_traces(sys.argv[2], sys.argv[3])
    elif cmd == "retry":
        retry_job(sys.argv[2], sys.argv[3])
    elif cmd == "cancel":
        cancel_job(sys.argv[2], sys.argv[3])
    else:
        raise SystemExit("unknown command")


if __name__ == "__main__":
    main()
