import requests
import os
import sys

GITHUB_API = "https://api.github.com"

def get_headers():
    token = os.environ.get("GITHUB_TOKEN")
    if not token:
        print("Error: GITHUB_TOKEN environment variable not set", file=sys.stderr)
        sys.exit(1)
    return {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json"
    }

def create_repo(headers, name, private, description):
    url = f"{GITHUB_API}/user/repos"
    payload = {
        "name": name,
        "private": private,
        "description": description,
        "auto_init": True
    }
    resp = requests.post(url, headers=headers, json=payload)
    if resp.status_code == 201:
        print(f"Created repo: {resp.json()['html_url']}")
        return resp.json()
    print(f"Failed to create repo: {resp.status_code} {resp.text}", file=sys.stderr)
    sys.exit(1)

def set_branch_protection(headers, owner, repo, branch="main"):
    url = f"{GITHUB_API}/repos/{owner}/{repo}/branches/{branch}/protection"
    payload = {
        "required_status_checks": {
            "strict": True,
            "contexts": ["continuous-integration"]
        },
        "enforce_admins": True,
        "required_pull_request_reviews": {
            "required_approving_review_count": 1,
            "dismiss_stale_reviews": True
        }
    }
    resp = requests.put(url, headers=headers, json=payload)
    if resp.status_code == 200:
        print(f"Branch protection enabled on {branch}")
    else:
        print(f"Warning: Branch protection returned {resp.status_code}", file=sys.stderr)

def add_collaborator(headers, owner, repo, collaborator, permission="push"):
    url = f"{GITHUB_API}/repos/{owner}/{repo}/collaborators/{collaborator}"
    resp = requests.put(url, headers=headers, json={"permission": permission})
    if resp.status_code in (201, 204):
        print(f"Added {collaborator} as {permission} collaborator")
    else:
        print(f"Failed to add collaborator: {resp.status_code} {resp.text}", file=sys.stderr)

def main():
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <repo-name> <collaborator> [--private]", file=sys.stderr)
        sys.exit(1)

    repo_name = sys.argv[1]
    collaborator = sys.argv[2]
    private = "--private" in sys.argv

    headers = get_headers()
    repo = create_repo(headers, repo_name, private, description="Provisioned by script")
    owner = repo["owner"]["login"]
    set_branch_protection(headers, owner, repo_name)
    add_collaborator(headers, owner, repo_name, collaborator)
    print(f"Done: repo {repo_name} ready at {repo['html_url']}")

if __name__ == "__main__":
    main()
