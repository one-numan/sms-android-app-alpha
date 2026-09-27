---
name: run
description: Build, connect, launch and drive the ONPS Android app (Flutter) on a real/wireless device to see a change working. Use when asked to run, start, build, or screenshot the app, or to confirm a change works end-to-end.
---

# ONPS Android App — Run Skill

This is a Flutter app (`sms_android_app_alpha`). It talks to the ONPS
Django backend over REST; it is a client, never a source of business
truth (see `AGENTS.md` §4, §16).

The full procedure (device connection, backend LAN reachability,
build/run commands, login/credential rule, verification, tests,
reporting) is defined once, canonically, for **all** AI coding agents
— not just Claude — in:

```text
.agents/rules/14-run-and-verify.md
```

Read and follow that file. Do not redefine or duplicate its steps
here; if this skill and that rule file ever disagree, the rule file
wins and this file is stale and should be updated to match.
