---
last_verified: 2026-09-20
tool_version: n/a
sources: []
---

# GitHub release automation: tags, milestones, and Releases end-to-end

## Purpose

I wanted to turn a release from a manual, five-tab chore into something I could trigger
from a CI job and trust. This doc records how I wired tags, milestones, and GitHub Releases
together so a single push of a tag produces a published release with notes, assets, and a
milestone attached — and how I back out of it when something goes wrong.

## Prerequisites

- `gh` authenticated with `repo` scope (Releases need it; read-only `public_repo` is not enough).
- A tag pushed to the repository. Releases are built on tags, not commits, so the tag has
  to exist before the release step runs.
- Default branch write access if you want the auto-generated notes to land on the right
  base.

## Steps

1. **Create the tag locally and push it.** A lightweight tag is enough for Releases, but an
   annotated tag carries a message that shows up in the release notes.

   ```bash
   git tag -a v1.4.2 -m "Release v1.4.2: add retry on upload, pin action hashes"
   git push origin v1.4.2
   ```

2. **Create the milestone first, or let the release own it.** Milestones are labels with a
   due date, and a release can attach to one after the fact. I create the milestone in the
   web UI before cutting the tag so the number is known when the release is created.

   ```bash
   gh milestone create "v1.4.2" --due 2026-10-01 --title "v1.4.2"
   ```

3. **Create the release from the tag.** `gh release create` derives the title and body from
   the tag when you omit them, but I pass both explicitly so the generated notes stay stable
   across re-runs.

   ```bash
   gh release create v1.4.2 \
     --title "v1.4.2" \
     --notes "Add retry on upload, pin action hashes, and document the rollback path." \
     --milestone "v1.4.2"
   ```

4. **Attach assets.** Assets are uploaded against the release, not the tag, so a re-upload
   after a failed build lands on the same release instead of creating a second one.

   ```bash
   gh release upload v1.4.2 dist/binary-linux-amd64 dist/binary-darwin-amd64
   ```

5. **Generate notes automatically.** For the next release, let GitHub build the notes from
   the milestone and the PRs merged since the last tag. This is the part that keeps the
   changelog honest.

   ```bash
   gh release create v1.5.0 --generate-notes --notes-from-tag-to-tag v1.4.2..v1.5.0
   ```

## Verify

- `gh release list` shows the tag, title, and publish state. A draft release shows
  `draft` in the state column.
- Open the release page and confirm the milestone badge matches the milestone you created.
- `gh release view v1.4.2 --json assets --jq '.assets[].name'` lists every uploaded asset.

## Common errors

- **A tag that has never been pushed fails silently.** `gh release create` works against
  the remote tag, so create the tag and push it in the same step.
- **`--generate-notes` with no previous tag produces an empty body.** Always pass a range or
  a previous tag when generating notes for the first release after a rename.
- **Re-running `gh release create` on the same tag errors with "already exists".** Use
  `gh release edit` to change title, notes, or milestone on an existing release instead of
  creating a new one.

## Rollback

If a release went out with the wrong notes or an unwanted asset, delete the release (not the
tag) and recreate it. The tag stays, so the next release picks up from the same point.

```bash
gh release delete v1.4.2 --yes
gh release create v1.4.2 --title "v1.4.2" --notes "..." --milestone "v1.4.2"
```

## References

- `gh release create --help` — lists every flag used above, including `--generate-notes`
  and `--notes-from-tag-to-tag`, and shows the draft/published state values.
- `gh milestone create --help` — milestone title, due date, and search syntax.
- `gh release upload --help` — attaching build artifacts to an existing release.
- `gh release view --help` — reading back a release's title, body, and assets as JSON.