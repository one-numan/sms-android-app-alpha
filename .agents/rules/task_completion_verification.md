# TASK COMPLETION & STATE VERIFICATION RULE

## Purpose

Never declare a task complete based only on implementation intent, code changes, or a previous report.

Before ending EVERY task, independently verify the CURRENT repository state and determine exactly:

1. What is DONE
2. What is PARTIALLY DONE
3. What is PENDING
4. What is BLOCKED
5. What is NOT VERIFIED
6. What should be the NEXT TASK

The final status must reflect actual evidence from the current repository.

---

## 1. Re-read the Original Task

Before finalizing:

- Re-read the original user/task requirements.
- Extract every explicit requirement.
- Include small requirements and constraints.
- Do not silently omit requirements.

Create an internal checklist:

[ ] Requirement 1
[ ] Requirement 2
[ ] Requirement 3
...

Every requirement must receive a final status.

---

## 2. Verify the Actual Implementation

For every requirement, inspect the current implementation.

Verify relevant:

- files
- backend code
- database/query logic
- API endpoints
- serializers
- API clients
- services
- models
- state management
- screens
- widgets
- routing
- authentication
- authorization
- error handling
- loading states
- empty states
- fallback behavior

Never mark something DONE simply because code was written.

---

## 3. Mandatory Status Definitions

Use ONLY these statuses:

### DONE
Requirement is implemented and independently verified with evidence.

### PARTIALLY DONE
Some required parts work, but one or more required parts remain incomplete.

### PENDING
Requirement has not yet been completed.

### BLOCKED
Requirement cannot currently be completed because of a known external or technical blocker.

### NOT VERIFIED
Implementation may exist, but sufficient verification has not been performed.

### NOT APPLICABLE
Requirement does not apply to the current task, with a clear reason.

---

## 4. Data Lineage Verification

For every data-driven feature, verify the complete lineage:

DATABASE
↓
BACKEND MODEL / QUERY
↓
API
↓
API CLIENT
↓
SERVICE
↓
MODEL
↓
STATE
↓
SCREEN
↓
UI

If any required layer is missing or disconnected:

Do NOT mark the feature DONE.

Mark it PARTIALLY DONE or NOT VERIFIED as appropriate.

Never replace missing backend data with hardcoded or mock data merely to make the UI appear complete.

---

## 5. API Verification

For every API created or modified, verify:

- route exists
- HTTP method
- authentication requirement
- role/permission requirement
- request parameters
- request body
- response structure
- empty response behavior
- error response
- 401 behavior
- 403 behavior
- 404 behavior
- object-level authorization
- Flutter/client consumption

An API existing in Django is NOT sufficient.

An API is only considered complete when its required consumer is also correctly connected and verified.

---

## 6. Authentication & Security Verification

For authentication-related tasks verify:

- login
- logout
- JWT/session lifecycle
- expired token behavior
- stale token behavior
- 401 handling
- protected routes
- role resolution
- session cleanup
- account switching
- selected user/child state
- object-level authorization
- IDOR protection

Never classify authentication behavior as PASS without verification.

---

## 7. Android Credential Rule

Before EVERY login attempt during Android, emulator, or physical-device testing:

1. Verify the exact username.
2. Verify the exact matching password.
3. Clear the username field.
4. Clear the password field.
5. Enter the verified username.
6. Enter the verified matching password.
7. Re-check the credential pair.
8. Submit.

Never assume a previously entered password is correct.

Never reuse another persona's password.

Never rely on stale autofill.

If intentionally testing invalid credentials, explicitly label:

INVALID CREDENTIAL TEST

Never expose passwords in:

- logs
- screenshots
- terminal output
- reports
- documentation
- commits

A login failure caused by unverified credentials must NOT be classified as an application/backend defect.

---

## 8. Mock / Static Data Verification

At the end of every relevant task, search for:

- MockData
- mockData
- hardcoded personas
- hardcoded student names
- hardcoded teacher names
- hardcoded classes
- hardcoded attendance
- hardcoded marks
- hardcoded fees
- demo data
- sample data
- fallback personas
- fake API responses

Classify every finding as:

- production
- test-only
- development-only
- UI-only
- legitimate fixture

Production-reachable mock data must never be presented as live data.

Do not substitute one real user's data for another user's missing data.

---

## 9. Search for Incomplete Work

Run appropriate repository searches for:

TODO
FIXME
HACK
TEMP
PLACEHOLDER
NOT IMPLEMENTED
IMPLEMENT LATER
COMING SOON
sample
demo
mock
fallback

Inspect relevant results and determine whether they affect the current task.

Do not blindly remove legitimate development/test comments.

---

## 10. Test Verification

Run the appropriate validation commands.

For Flutter tasks, normally run:

flutter analyze
flutter test

When applicable:

flutter build apk --release --split-per-abi

For backend tasks, run the relevant backend test suite and API checks.

Do not modify tests merely to make them pass.

Record:

- command
- result
- number of tests
- failures
- skipped tests
- analyzer result
- build result

Passing tests alone does NOT prove the entire task is complete.

---

## 11. Physical Device Verification

If the task requires Android/device testing:

- verify the physical device
- install the correct build
- launch the application
- perform the required flow
- verify the actual UI/result
- capture evidence when appropriate

If physical testing was not performed:

Report:

PHYSICAL QA: NOT VERIFIED

Never report PASS when the required physical test was not performed.

---

## 12. UI Verification

For affected production screens verify:

- real data
- loading state
- empty state
- error state
- retry behavior
- navigation
- back navigation
- role-specific visibility
- responsive layout
- no unintended static persona
- no unintended mock/fallback data

Do not consider a screen complete merely because it compiles.

---

## 13. Documentation Verification

If the task requires documentation:

Verify that:

- documentation exists
- documentation matches current implementation
- test results are current
- commit hashes are correct
- no stale claims remain
- no contradictory status exists

If documentation is outdated:

mark the requirement PENDING.

---

## 14. Git Verification

Before finalizing, run:

git status
git log --oneline -10

Check:

- current branch
- working tree
- modified files
- untracked files
- generated artifacts
- temporary files
- accidental secrets
- local commits

Do NOT push to remote unless the user explicitly requested a push.

Report whether remote push occurred.

---

## 15. Final Verification Table

Every task completion response MUST contain:

| Requirement | Status | Evidence | Remaining Work |
|-------------|--------|----------|----------------|
| Requirement 1 | DONE | file/test/API | None |
| Requirement 2 | PARTIALLY DONE | evidence | Missing ... |
| Requirement 3 | PENDING | evidence | ... |
| Requirement 4 | NOT VERIFIED | reason | ... |

Do not omit unfinished requirements.

---

## 16. Final Report

The final response MUST contain these sections:

### DONE

List only independently verified completed work.

### PARTIALLY DONE

List anything where implementation exists but the full requirement is incomplete.

### PENDING

List every unfinished requirement.

### BLOCKED

List every blocker and explain:

- what is blocked
- why
- dependency
- required action

If none:

None.

### NOT VERIFIED

List anything implemented but not sufficiently tested or verified.

If none:

None.

### VALIDATION

Report:

- flutter analyze
- flutter test
- backend tests if applicable
- release build if applicable
- physical QA if applicable

### GIT

Report:

- branch
- latest commit
- working tree
- local commits
- remote push

### NEXT TASK

Identify ONE concrete next task based only on the remaining PENDING, BLOCKED, or NOT VERIFIED items.

Do not automatically start the next task.

---

## 17. Overall Task Status

Use exactly ONE final status:

TASK COMPLETE

TASK COMPLETE WITH FINDINGS

TASK INCOMPLETE

TASK BLOCKED

Rules:

- If all required items are DONE → TASK COMPLETE
- If all required implementation is complete but non-blocking findings remain → TASK COMPLETE WITH FINDINGS
- If any required item is PENDING or NOT VERIFIED → TASK INCOMPLETE
- If a required item cannot proceed because of a blocker → TASK BLOCKED

Never call a task COMPLETE when required work is still pending or unverified.

---

## 18. Evidence Rule

Every important completion claim must have evidence.

Valid evidence includes:

- source file
- API endpoint
- database query
- test result
- analyzer result
- build result
- physical-device result
- git commit
- screenshot/evidence file

Do not invent evidence.

Do not infer successful verification from intention.

Do not copy completion claims from previous reports without rechecking the current repository.

---

## 19. No False Completion

The following are NOT sufficient to declare completion:

- "Code has been written."
- "API has been created."
- "Screen has been implemented."
- "Tests were added."
- "APK builds."
- "Previous phase passed."
- "Previous report said it was complete."

Completion requires current verification.

---

## 20. Final Principle

Every task must end with a clear state transition:

CURRENT STATE
↓
IMPLEMENTATION
↓
VALIDATION
↓
INDEPENDENT VERIFICATION
↓
DONE / PARTIALLY DONE / PENDING / BLOCKED / NOT VERIFIED
↓
NEXT TASK

The purpose of this rule is to prevent unfinished work from being incorrectly reported as complete.

The repository's CURRENT VERIFIED STATE is always more authoritative than previous plans, intentions, or reports.
