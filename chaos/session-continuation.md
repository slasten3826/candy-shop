# session continuation

How to bring this session back after a reboot.

## This session

```text
session_id  ea82a6aa-c9fa-4b4f-b5b9-61c7fb4cd354
job_id      ea82a6aa
cwd         /home/slasten/codex/fcc-ds41
kind        background (job started with --bg)
started     2026-09-12
```

## Resume after reboot

After the reboot the process is gone, so a plain resume works:

```sh
claude --resume ea82a6aa-c9fa-4b4f-b5b9-61c7fb4cd354
```

While the session is still running this same command refuses on purpose,
to stop two copies of one conversation:

```text
Error: Session ... is running as a background session (ea82a6aa).
Run `claude attach ea82a6aa` to open it, or `claude stop ea82a6aa` first.
Add --fork-session to branch off a copy instead.
```

## While it is still running

```sh
claude attach ea82a6aa      # open it in this terminal
claude logs ea82a6aa        # print recent output without attaching
claude stop ea82a6aa        # stop it; conversation is kept and resumable
claude agents               # list all background sessions
```

## Other flags worth knowing

```text
--fork-session              resume a copy, leave the original untouched
--continue                  continue the most recent conversation in this dir
--session-id <uuid>         start a new conversation with a chosen ID
claude respawn [id]         restart a background session on the current version
```

## What survives a reboot

```text
transcript   ~/.claude/projects/-home-slasten-codex-fcc-ds41/ea82a6aa-....jsonl   yes
registry     ~/.claude/sessions/<pid>.json                                       rewritten
process      PID / background worker                                             no
memory       ~/.claude/projects/-home-slasten-codex-fcc-ds41/memory/            yes
```

The transcript is the conversation. As long as that file exists, the session
can be resumed; the process being gone is expected and does not lose anything.

---

machines only. not for humans.
