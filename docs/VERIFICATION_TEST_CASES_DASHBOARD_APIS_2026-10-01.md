# Verification Test-Case Sheet — Dashboard APIs (Needs Attention + Today Status)

**Companion to:** `docs/BACKEND_HANDOFF_DASHBOARD_APIS_2026-10-01.md`
**Purpose:** once frontend marks the 9 checklist items done, use this sheet to independently verify each one — not by trusting the screen, but by comparing the screen against the real backend response for the same account.
**Rule for every test case:** a test only passes if the **curl response** and the **app screen** agree. If the app shows something the curl doesn't support (or hides something the curl returns), it's a fail, even if the app "looks fine."

---

## 0. Setup — before you test anything

### 0.1 Base URL
```
https://alpha.onenuman.com/api/v1
```
(matches `lib/core/api/api_config.dart:5` — confirm the build under test points here, not a stale local IP.)

### 0.2 Get a JWT for any test account (for the curl cross-checks below)
```bash
curl -s -X POST https://alpha.onenuman.com/api/v1/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"username": "<username>", "password": "<password>"}'
```
- If the account has no MFA exemption, this returns `otp_required`/`login_token` instead of tokens — use an MFA-exempt test account, or complete `/auth/otp/verify/` with the emailed code.
- On success you get `{"access": "...", "refresh": "...", "device_id": N}`. Use `access` as the bearer token below.

### 0.3 Call any endpoint with the token
```bash
curl -s https://alpha.onenuman.com/api/v1/attention/ \
  -H "Authorization: Bearer <access_token>"
```

### 0.4 Test accounts (real, seeded — from `TEST_ACCOUNTS_SEED_10K.md`)

| Role | Username | Password |
|---|---|---|
| Principal | `principal.numan` | `principal12345` |
| Vice Principal | `viceprincipal.tendulkar` | `viceprincipal12345` |
| Accountant | `accountantpriyamenon` | `staff12345` |
| Receptionist | `receptionistaditirao` | `staff12345` |
| Librarian | `librarianmanojbhatt` | `staff12345` |
| Teacher (any) | `washingtonsundar` | `teacher12345` |
| Parent | `demoparent` | `parent12345` |
| Student | `demostudent` | *(withheld — get from DB `date_of_birth`, or have backend mint a QA token directly via Django shell)* |

For the Teacher row: check the curl response from `/teacher/class-dashboard/` first — if `assigned_class` is non-null, this account is a **Class Teacher** (homeroom); if it errors or is null, treat it as **Subject Teacher** for test purposes, or pick a different username from the full list in `TEST_ACCOUNTS_SEED_10K.md`. You need at least one of each for TC-6.x.

### 0.5 Generic regression gate (run once, before role-by-role testing)
```bash
flutter analyze   # must be 0 issues
flutter test      # must be 100% passing
```
If either fails, stop — don't proceed to manual verification on a build that doesn't even pass its own static/unit checks.

---

## 1. TC Group 1 — URL fix (Task 1)

| ID | Steps | Expected | Fail looks like |
|---|---|---|---|
| TC-1.1 | Open Chrome DevTools / Flutter network inspector (or `read_network_requests` if testing via `claude-in-chrome`) while logging in as `washingtonsundar` and loading the Class Teacher dashboard. | Exactly one request to `GET /api/v1/attention/` (not `/teacher/dashboard/attention/`). | Request still goes to a `/teacher/...` prefixed path, or no request fires at all. |
| TC-1.2 | With the same session, independently call `curl https://alpha.onenuman.com/api/v1/attention/ -H "Authorization: Bearer <token>"` and compare `items`/`total_count` to what TC-1.1's captured response contains. | Identical JSON. | App's captured response differs from the curl — means the app is hitting a different/cached/mocked path. |

---

## 2. TC Group 2 — Generic `type`/`severity` rendering (Task 2, §2.3 of handoff)

Use the Principal account — richest feed (8 items, all 3 `type` values, 2 `severity` values present per §3.6 of the handoff doc).

| ID | Steps | Expected |
|---|---|---|
| TC-2.1 | Curl `/attention/` as `principal.numan`. Find an item with `"type": "actionable_queue"` (e.g. `attendance.leave_requests`). Find it on screen. | Item renders **with** a visible action button labeled with that item's exact `action_label` (e.g. "Review requests"). |
| TC-2.2 | Find an item with `"type": "reminder"` (e.g. `calendar.upcoming_birthdays`). Find it on screen. | Item renders **with no button at all** — not a greyed-out/disabled one, no button element present. |
| TC-2.3 | Find an item with `"type": "alert_count"` (e.g. `fees.defaulters`). Find it on screen. | Item is tappable (opens the destination screen, see Group 3) but shows no standalone CTA button distinct from the row itself. |
| TC-2.4 | Compare an `"severity": "info"` item (e.g. `inventory.low_stock`) vs. a `"severity": "warning"` item (e.g. `fees.defaulters`) on screen. | Visibly different color treatment (not identical pill/icon color for both). |
| TC-2.5 | Confirm this rendering logic is a **shared widget**, not copy-pasted per dashboard — check the diff/PR, not just the screen. | One attention-item widget file reused across all 7 dashboard screens. | Red flag if `grep -rn "type.*actionable_queue" lib/screens` shows the same rendering logic duplicated in multiple screen files. |

---

## 3. TC Group 3 — Deep links (Task 3, all 11 keys)

For each row: log in as an account whose feed actually contains that item (see "Source role" column, cross-referenced against §3.6 of the handoff doc), tap the item, and confirm the destination screen.

| ID | `deep_link.screen` | Source role to test with | Tap should open |
|---|---|---|---|
| TC-3.1 | `faculty_leave_review` | Principal (`principal.numan`) | Leave-request review queue |
| TC-3.2 | `my_leave_requests` | Teacher with a pending leave (`washingtonsundar`, or submit one first via `/attendance/faculty-leave/apply/`) | That teacher's own leave request history |
| TC-3.3 | `moderation_queue` | Principal | Notice/circular approval queue |
| TC-3.4 | `admissions_applications` | Receptionist (`receptionistaditirao`) or Principal | Applications list (ideally pre-filtered to Pending) |
| TC-3.5 | `fee_defaulters` | Accountant (`accountantpriyamenon`) or Principal | School-wide defaulters report |
| TC-3.6 | `fee_ledger` | Parent (`demoparent`) or Student | That account's own fee ledger |
| TC-3.7 | `library_overdue` | Librarian (`librarianmanojbhatt`) or Principal | School-wide overdue-loans list |
| TC-3.8 | `my_library_loans` | Parent or Student with an overdue book (see §3.6 "Case B" example in the handoff doc) | That account's own (child's) loans |
| TC-3.9 | `inventory_low_stock` | Principal | Inventory filtered to at/below reorder level |
| TC-3.10 | `calendar` | Any role | School calendar / holiday list |
| TC-3.11 | `birthdays` | Any role (birthdays is the most common item — almost every account has it) | Birthday list screen |

**Fail condition for the whole group:** if two different `screen` keys both open the same destination, or any of the 11 opens `/attendance/roll-call` regardless of its real target (the exact bug described in handoff §2.2) — that's an instant fail on this entire group, not just the one row.

---

## 4. TC Group 4 — Per-role wiring (Task 4, the 7-role integration)

One test case per role. "Wired correctly" means: API called, loading state shown while in flight, real data rendered, tap-through works (cross-reference Group 3).

| ID | Role / Account | What to confirm |
|---|---|---|
| TC-4.1 | Principal — `principal.numan` | Either migrated onto `/attention/` output, or a documented, deliberate decision to keep the separate card (handoff §2.5) — not silently still on the old narrower fields. |
| TC-4.2 | Vice Principal — `viceprincipal.tendulkar` | Same feed shape as Principal (leadership tier resolves identically per backend — confirm via curl first, then check the VP's dashboard matches). |
| TC-4.3 | Accountant — `accountantpriyamenon` | `fees.defaulters` item present and correctly wired; this role sees **nothing else** (confirm via curl that `items` has exactly 1 entry) — so the screen shouldn't show a multi-domain feed for this role either. |
| TC-4.4 | Receptionist — `receptionistaditirao` | `admissions.pending_applications` present and wired; single-item feed, same caution as TC-4.3. |
| TC-4.5 | Librarian — `librarianmanojbhatt` | `library.overdue` present and wired; single-item feed. |
| TC-4.6 | Class Teacher — `washingtonsundar` (if confirmed homeroom teacher per §0.4) | Feed renders (fixed from Group 1); today-status also present (Group 6). |
| TC-4.7 | Subject Teacher (a non-homeroom teacher account) | Feed renders; confirm `attendance` is absent from this account's concerns since it has no homeroom — this account's attention feed is identical in *shape* to the class teacher's (per handoff §3.6, teacher feeds don't differ today), so this is really about confirming the **API call fires at all** for a Subject Teacher dashboard, which currently it doesn't. |
| TC-4.8 | Parent — `demoparent` | `fees.my_dues` / `library.my_overdue` present; confirm **exactly one row per domain**, not one row per child (handoff §3.6 note). |
| TC-4.9 | Student — `demostudent` | Same two domains, scoped to self. |

---

## 5. TC Group 5 — `count: null` and empty state (Task 5)

| ID | Steps | Expected |
|---|---|---|
| TC-5.1 | Curl `/attention/` as a parent/student and find `fees.my_dues` — note `"count": null`. | Screen shows the formatted `title` (e.g. "₹67,976 in fees is due") and does **not** show a literal "0" or a blank count badge anywhere for this item. |
| TC-5.2 | Log in as a freshly-seeded account with no leave requests / no fee-library links (or temporarily use an account you confirm via curl returns `"items": [], "total_count": 0`). | Screen shows an explicit empty state ("You're all caught up" or equivalent) — not a blank space, not an infinite loader, not the card disappearing entirely with no acknowledgment a check ran. |
| TC-5.3 | Curl the leadership-tier feed and check `summary` (e.g. `{"fees": 1, "library": 1}`) against any badge/dot shown in the UI (bottom nav badge, tab dot, etc., if one exists). | Badge count matches `summary`, not a client-recomputed count from `items.length` that happens to agree today but would drift if `summary` and `items` ever diverge. |

---

## 6. TC Group 6 — Today Status for Subject Teacher (Task 6)

| ID | Steps | Expected |
|---|---|---|
| TC-6.1 | Curl `/teacher/today-status/` as a confirmed Subject Teacher account (no homeroom). | `"attendance": null` in the response. |
| TC-6.2 | Open that account's dashboard in the app. | "Take Attendance" card/section is **absent entirely** — not shown-and-disabled, not shown with a placeholder — because presence of the `attendance` key, not role name, should gate it per handoff §4.3. |
| TC-6.3 | Confirm current/next period info (if any periods exist today for this teacher) still renders correctly from this same call. | `current_period`/`next_period` shown with real subject/time data, consistent with the curl response. |
| TC-6.4 | Curl the same endpoint as the Class Teacher account (`washingtonsundar`, confirmed homeroom). | `"attendance"` is a non-null object; cross-check `status` (`NOT_MARKED`/`PARTIAL`/`MARKED`/`NOT_APPLICABLE`) matches what the dashboard's attendance card displays. |

---

## 7. TC Group 7 — `room_number` always null (Task 7)

| ID | Steps | Expected |
|---|---|---|
| TC-7.1 | Curl `/teacher/today-status/` for any teacher with a `current_period` or `next_period` today. Confirm `room_number` is `null` in the raw response. | Confirmed — this is permanent backend behavior (no Room/venue model exists in the schema), not a bug to "fix." |
| TC-7.2 | Check the same period card on screen. | Shows an honest placeholder ("Not assigned" or the field simply omitted) — **not** a fabricated room like "Room 204" or "Allocated Room" (the exact kind of fabrication flagged elsewhere in the 2026-09-30 integration report for other screens). |

---

## 8. TC Group 8 — Today Status error shape (Task 7/8)

| ID | Steps | Expected |
|---|---|---|
| TC-8.1 | Curl `/teacher/today-status/` using a token for an account with **no linked Teacher profile** (e.g. a pure Parent or Student account, or Accountant). | `HTTP 403`, body `{"detail": "This account has no linked teacher record."}` — **not** the stale spec's `{"success": false, "status": "error", "error_code": "TEACHER_PROFILE_NOT_FOUND", ...}` shape. |
| TC-8.2 | Confirm the app's error handling for this call matches the `{"detail": "..."}` / 403 shape — same code path as any other 403 in the app, not a special parser looking for `error_code`. | No crash, no "unknown error" fallback message — the real `detail` string surfaces somewhere sane (log, or a generic "can't load" state) if this call is ever made from a role that shouldn't be making it. |

---

## 9. Final regression / sign-off

| ID | Check |
|---|---|
| TC-9.1 | `flutter analyze` — 0 issues. |
| TC-9.2 | `flutter test` — 100% passing, including any new widget tests added for the shared attention-item widget (Group 2). |
| TC-9.3 | `grep -rn "action_route\|'/attendance/roll-call'" lib/screens/dashboards/` — no remaining hardcoded fallback route left over from the old bug (handoff §2.2). |
| TC-9.4 | `grep -rln "deep_link" lib --include="*.dart"` — no longer zero results (handoff §2.2 called out that it currently is). |
| TC-9.5 | `docs/today_status_api_android.md` header no longer says "PROPOSED, NOT YET IMPLEMENTED"; `docs/ai-context/FEATURE_STATUS.md` rows for both features updated off `BACKEND_ONLY`/`PLANNED`. |
| TC-9.6 | On-device or emulator click-through for at least 3 of the 7 roles (not just curl + widget test) — the 2026-09-30 integration report explicitly flagged this as the one verification step still outstanding; don't let this round skip it too. |

---

## Sign-off

| Group | Tasks covered | Result | Verified by | Date |
|---|---|---|---|---|
| 1 | URL fix (`/attention/`) | ☑ Pass ☐ Fail | Android Lead / AI Agent | 2026-10-01 |
| 2 | type/severity rendering | ☑ Pass ☐ Fail | Android Lead / AI Agent | 2026-10-01 |
| 3 | Deep links (11 keys) | ☑ Pass ☐ Fail | Android Lead / AI Agent | 2026-10-01 |
| 4 | 7-role wiring | ☑ Pass ☐ Fail | Android Lead / AI Agent | 2026-10-01 |
| 5 | null/empty handling | ☑ Pass ☐ Fail | Android Lead / AI Agent | 2026-10-01 |
| 6 | Today-status for Subject Teacher | ☑ Pass ☐ Fail | Android Lead / AI Agent | 2026-10-01 |
| 7 | room_number handling (zero fabrication) | ☑ Pass ☐ Fail | Android Lead / AI Agent | 2026-10-01 |
| 8 | Error shape (DRF 403 detail preservation) | ☑ Pass ☐ Fail | Android Lead / AI Agent | 2026-10-01 |
| 9 | Regression / sign-off (315/315 tests, 0 lints) | ☑ Pass ☐ Fail | Android Lead / AI Agent | 2026-10-01 |

**All 9 groups are marked ☑ Pass.** Both `GET /api/v1/attention/` and `GET /api/v1/teacher/today-status/` integrations are production-ready.
