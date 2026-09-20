---
last_verified: 2026-09-20
tool_version: n/a
---

# GitHub release automation: tags, milestones, and Releases end-to-end

## Purpose

Cutting a release used to mean five browser tabs: push a tag, draft notes by hand,
remember which issues shipped, upload binaries one by one. This doc records the flow
I settled on instead — tag, milestone, and Release wired together through `gh` so one
command publishes a release with notes and assets. This is one way to do it; the
built-in help (`gh release create --help`) documents a few more flags than I use here.

## Prerequisites

- `gh` authenticated against the target repo (release create/upload/delete need push
  access; read-only access is not enough).
- A local checkout of the repo with the default branch up to date.
- Agreement on the tag scheme first (I use `vMAJOR.MINOR.PATCH` annotated tags).

## Steps

1. **Create the tag locally and push it.** An annotated tag carries a message that
   `gh release create` can reuse later via `--notes-from-tag`.

   ```bash
   git tag -a v1.4.2 -m "Release v1.4.2: retry on upload, pinned action hashes"
   git push origin v1.4.2
   ```

   Note: pushing first is habit, not a requirement — if the tag does not exist on
   the remote, `gh release create` auto-creates it from the latest state of the
   default branch. Pass `--verify-tag` to abort instead when the tag is missing,
   or `--target <branch-or-sha>` to base the auto-created tag elsewhere.

2. **Track the release scope with a milestone.** Milestones are not labels — labels
   are free-form tags on issues and PRs, while a milestone is a dated container
   you assign issues and PRs to so you can see what ships in `v1.4.2`. There is no
   `gh milestone` subcommand (I checked `gh --help`: it does not exist), so create
   the milestone in the web UI under Issues → Milestones, or through the API:

   ```bash
   gh api repos/{owner}/{repo}/milestones -f title="v1.4.2"
   ```

   I do this before cutting the tag so every merged PR gets assigned to the
   milestone while the work lands — that is what makes the generated notes in
   step 5 accurate.

3. **Create the release from the tag.** Releases do not attach to milestones —
   `gh release create` has no `--milestone` flag, so do not go looking for one.
   Pass title and notes explicitly so re-runs stay stable:

   ```bash
   gh release create v1.4.2 \
     --title "v1.4.2" \
     --notes "Retry on upload, pinned action hashes, rollback path documented."
   ```

   Assets can go on the same command as trailing file arguments
   (`gh release create v1.4.2 dist/*`), with an optional `#label` suffix per file
   for the display name.

4. **Attach build artifacts to the release.** Assets belong to the release, not
   the tag, so re-uploading after a failed build lands on the same release:

   ```bash
   gh release upload v1.4.2 dist/binary-linux-amd64 dist/binary-darwin-amd64
   ```

   Re-running `upload` with the same filename errors; add `--clobber` to
   overwrite an asset of the same name.

5. **Let GitHub generate the notes next time.** Once PRs are consistently
   assigned to milestones, hand-written notes become the bottleneck. For the
   following release I use auto-generated notes, anchored at the previous tag:

   ```bash
   gh release create v1.5.0 --generate-notes --notes-start-tag v1.4.2
   ```

   There is no `--notes-from-tag-to-tag` range flag — the start of the range is
   `--notes-start-tag`, and the end is the tag being created. Extra context can
   be prepended with `--notes`. For a draft-then-publish flow add `--draft`
   (or `--prerelease` for pre-releases); flip a draft live later with
   `gh release edit v1.5.0 --draft=false`.

## Verify

- `gh release list` shows the tag, title, and publish state of recent releases
  (add `--exclude-drafts` to hide drafts).
- `gh release view v1.4.2 --json assets --jq '.assets[].name'` lists every
  uploaded asset for the tag.
- Open the release page in the browser and confirm the auto-generated notes
  reference the PRs that were assigned to the milestone.
- `git fetch --tags origin` pulls the remote tag state back into the local clone.

## Common errors

- **Re-running `gh release create` on the same tag fails with "already exists".**
  I hit this when a CI retry re-ran the publish step. A release is created once
  per tag — change title, notes, or flags afterwards with `gh release edit`
  instead of creating again.
- **`--generate-notes` on the very first release produces a thin body.** With no
  previous tag to diff against there is little history to summarize; I pass
  `--notes-start-tag` pointing at the earliest meaningful tag, or write `--notes`
  by hand for v1.0-style releases.
- **Confusing milestones with labels.** I did this at first too. If you want a
  release "attached" to a milestone, the actual mechanism is: assign the shipped
  issues/PRs to the milestone, close the milestone when the release goes out,
  and link the milestone in the release notes text.

## Rollback

If a release goes out with wrong notes or a bad asset, delete the release and
recreate it — the tag stays, so the next attempt starts from the same point:

```bash
gh release delete v1.4.2 --yes
gh release create v1.4.2 --title "v1.4.2" --notes "Corrected notes."
```

Add `--cleanup-tag` to `gh release delete` when the tag itself is wrong and must
go too. I prefer deleting just the release first; the tag is cheap to keep and
deleting it rewrites history other clones may already have fetched.

## References

- `gh release create --help` — full flag list for the create step, including
  `--generate-notes`, `--notes-start-tag`, `--notes-from-tag`, `--verify-tag`,
  and `--target`.
- `gh release edit --help` — changing title, notes, draft, and prerelease state
  on an existing release.
- `gh release upload --help` — asset arguments, `#label` display names, and
  `--clobber`.
- `gh release view --help` and `gh release list --help` — reading releases back,
  including `--json`/`--jq` output.
- `gh api --help` — authenticated API access used for the milestone call above;
  `{owner}` and `{repo}` placeholders resolve from the current checkout.
