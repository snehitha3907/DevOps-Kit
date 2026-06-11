import requests, os

token = os.environ["GITHUB_TOKEN"]
headers = {"Authorization": f"token {token}"}

# Print repo names for my user.
for repo in requests.get("https://api.github.com/user/repos", headers=headers).json():
    print(repo["name"])
