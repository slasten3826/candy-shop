# authorship and harness change, 2026-09-12

Two related things happened on the same day as the snapshot. Both are recorded
here because the commit history shows the effect but not the cause.

## What the history shows

```text
0183722  Initial candy-shop snapshot (2026-09-12)
54b9907  Add local companion for redacted facts
```

Both carry a trailer:

```text
Co-Authored-By: Claude Code <noreply@anthropic.com>
```

GitHub therefore renders a second contributor, "Claude", with no avatar,
next to the repository owner. On a public repository that reads as though two
people built the snapshot. One person did.

## Why the trailer was there

The agent harness running the session instructed the assistant to append that
line to every commit message. It was not a decision by the operator or by the
assistant; it was a default the harness applied. The operator had not chosen
it and, on seeing the rendered contributor list, asked that it stop.

## What was changed to stop it

The harness reads `~/.claude/settings.json`. The default was disabled there:

```json
{
  "theme": "dark",
  "model": "claude-3-freecc-no-thinking/deepseek/deepseek-flash",
  "includeCoAuthoredBy": false
}
```

`includeCoAuthoredBy: false` stops the trailer from being added to future
commits and pull request bodies. Commits `0183722` and `54b9907` keep the
trailer; history is not being rewritten. This document is the record instead.

## What this snapshot's commits should be pinned to

Local git identity for this repository, which is already public in the
repository URL:

```text
user.name   slasten
user.email  slasten@users.noreply.github.com
```

No global git identity is set on this machine, so the local one is what these
commits use.

## The same change is a harness decision, not a one-off

The operator is deliberately configuring a personal harness: defaults the tool
ships with are being turned off when they do not fit how this repository should
present itself. Attribution is the first such default. Treat future surprises
of the same kind — something appearing in commits, PR bodies, or output that
the operator did not ask for — as candidates for the same treatment: identify
where the default lives, decide, record it here.

---

machines only. not for humans.
