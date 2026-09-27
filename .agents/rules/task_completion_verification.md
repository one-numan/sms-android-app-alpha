# TASK COMPLETION & STATE VERIFICATION

Applies in full only to **substantial** tasks — a new feature, a bug
fix touching production data/auth/money, a schema or contract change.
For a trivial/mechanical task (running the app, a one-line fix, a
docs/rule edit) just do it and say what you did — don't run the full
ritual below.

## Status Vocabulary

Use only: `DONE`, `PARTIALLY DONE`, `PENDING`, `BLOCKED`,
`NOT VERIFIED`, `NOT APPLICABLE`. Never mark something `DONE` because
code was written — only because it was independently checked.

## Before Calling a Substantial Task Done

1. Re-read the original requirement; list each explicit sub-requirement.
2. Inspect the actual current implementation for each — not what a
   previous report claimed.
3. For data-driven features, confirm the lineage is real end-to-end
   (`database → API → Flutter model → state → UI`) — don't accept a
   screen that renders only because it fell back to mock/cached data.
4. Run the relevant checks: `flutter analyze`, `flutter test` (or the
   specific test file for a narrow change), a release build if
   relevant, physical-device verification if the task required it.
5. `git status` / `git diff` — know what's actually changed and
   whether it's committed, before saying so.

## Evidence, Not Intention

"Code has been written" / "tests were added" / "APK builds" are not
completion evidence by themselves. Cite the actual file, test result,
or command output. Don't copy a completion claim forward from an
earlier report without rechecking current state.

## Reporting a Substantial Task

```
STATUS: DONE | PARTIALLY DONE | PENDING | BLOCKED | NOT VERIFIED
CHANGES: <what actually changed>
VALIDATION: <analyze/test/build/device results actually run>
NOT VERIFIED / REMAINING: <anything not checked, or "None">
GIT: <branch, committed?, pushed? — never say pushed unless it happened>
```

If a required item never got checked, the overall status cannot be
`DONE` — use `PARTIALLY DONE` or `NOT VERIFIED` instead.
