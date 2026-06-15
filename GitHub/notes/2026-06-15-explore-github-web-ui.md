# Exploring the GitHub web UI — profile, repo creation, and issues

I clicked through github.com for the first time with a specific focus on the parts I'd need most: my own profile page, creating a repo from the browser, and the issue tracker.

## Profile page

When I logged in and clicked my avatar → Your profile, I got a landing page showing my pinned repos, contribution grid, and a short bio section. The contribution grid is color-coded by number of commits per day. I didn't have many contributions yet, so most of it was light gray. I could pin up to six repos to the top — that's a nice way to showcase the things I actually care about, separate from my 20+ random experiment repos.

I found the activity log on the right sidebar too, showing recent stars and forks. Not sure how useful that is personally, but it's a quick way to remind yourself what you were looking at last week.

## Repository creation

The big green "New" button in the repo nav lets you create a repo from scratch. The form asks for:
- Repository name (required, URL-friendly)
- Description (optional)
- Public or Private
- Initialize this repository with a README (checkbox)
- Add .gitignore and license (dropdowns)

I checked "Add a README" so I wouldn't have to push an initial commit from the command line. That gave me a repo with a single file ready to view. The `.gitignore` options are organized by language (Node, Python, Go...), and the license dropdown covers the common ones — MIT, Apache 2.0, GPL. I picked MIT for a test project.

I learned that you can't create a repo with a name that already exists globally across GitHub. I tried "test" and got an error immediately. The name has to be unique under your username, even if the repo is private.

## Issue tracker

Opening the Issues tab on a fresh repo showed "No issues open" with a green "New issue" button. Clicking it opens a text form with title and body fields. I saved my first issue and it showed up with a random number (like #1) and an "Open" badge.

The issue list page has filters across the top: Open, Closed, All. You can sort by newest, oldest, most commented, and most reactions. There's also a search bar that supports qualifiers like `is:open label:bug` or `author:@me`. That syntax is more powerful than I expected for a web UI filter.

One thing I missed: issue numbers are per-repo, not global. So `#1` in repo A is unrelated to `#1` in repo B. That's similar to pull requests, which also live in per-repo namespaces.

## What I'd try next

- Add a project board linked to my test repo's issues
- Try the label management UI and see how it affects the issue list
- Open a PR from a branch to get the "Files changed" diff view in the web UI
