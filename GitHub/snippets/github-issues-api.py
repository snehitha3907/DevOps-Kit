import requests, os, json

token = os.environ["GITHUB_TOKEN"]
headers = {"Authorization": f"token {token}", "Accept": "application/vnd.github+json"}
owner = "myorg"
repo = "myrepo"

# List open issues
url = f"https://api.github.com/repos/{owner}/{repo}/issues?state=open"
for issue in requests.get(url, headers=headers).json():
    print(f"#{issue['number']}: {issue['title']}")

# Create a new issue
new_issue = {"title": "Bug report", "body": "Description of the issue"}
resp = requests.post(url, headers=headers, data=json.dumps(new_issue))
print(f"Created issue #{resp.json()['number']}")