# Fake-Data Fallback Elimination — Master Prompt & Status

**Status as of 2026-09-27: `NOT RESOLVED` — 60+ known occurrences, 0 verified fixed.**

This file replaces every previous audit/status doc on this subject (`01_action_items.md`
through `16_action_items.md`, `action_items.md`, `source_of_truth_audit.md`,
`ANDROID_STATIC_DATA_AUDIT.md` + `_PHASE3` + `_PHASE3_FINAL`, `MOCKDATA_SCREENS_AUDIT.md`,
`ANDROID_MOCKDATA_REACHABILITY_FINAL.md`, `ANDROID_MOCKDATA_REMEDIATION_PHASE4.md`,
`FINAL_14_API_MIGRATION_AUDIT.md`). Those are deleted, not archived — they were re-audits
of the same unfixed problem, each narrowing scope and self-declaring
`PASS_WITH_REMAINING_FINDINGS` without ever reaching zero. The most recent of them
(`FINAL_14_API_MIGRATION_AUDIT.md`, dated 2026-09-22) still reported **76 production-reachable
occurrences app-wide** while calling itself final. Do not create a new `_PHASE5` or `_V2`
file when more work is done — **update this file in place** and advance its Status line.

---

## 1. Why this file exists (read this before touching any code)

On 2026-09-27, a fresh independent audit (five parallel reviewers, one per app area) was
run without reading the prior reports first, specifically to check whether the earlier
"remediated" claims held up. They did not. The exact bug the prior docs claimed to have
fixed in `class_teacher_dashboard_screen.dart` and `notice_board_screen.dart` is still
present today, plus dozens more instances the prior audits never found or under-scoped.

**The pattern, in one sentence:** when a real value is missing (a field the backend never
sent, an API call that failed, a lookup that found nothing), the app has repeatedly used a
`??` fallback, a `catch` block, or a hardcoded literal to display something that **looks
exactly like real data** — a name, a phone number, an attendance percentage, a "success"
status — instead of visibly saying "this is missing/failed." A user cannot tell the
difference between a real 40-student headcount and a fake one that happens to also say 40.

This is worse than a crash. A crash gets reported. A wrong-but-plausible number does not —
it gets acted on. Concretely, in this codebase that has already meant: a teacher believes
marks were saved when they weren't (`student_api_service.dart` `submitMarks()`), a Principal
sees a fabricated 8,551/457/499/493 school-wide attendance breakdown that isn't real, and a
student's dossier can show a completely invented parent name, phone number, email, and home
address.

**Do not treat this as cosmetic polish. Treat it as a data-integrity and trust bug.**

---

## 2. The one rule that fixes all of it

Every place in this codebase that reads a value which is supposed to come from a live
backend response must follow exactly one of these two shapes. No third option.

1. **The value is present and valid** → render it, exactly as received. No transformation
   that could paper over a wrong type or wrong shape.
2. **The value is absent, null, malformed, or the request failed** → render an explicit
   "missing" signal appropriate to the context (see table below) **and never a value that
   could be mistaken for real data.**

| Context | Correct "missing" signal | Never do this |
|---|---|---|
| A stat/count on a dashboard tile | `—` (em dash) or a skeleton loader, with the tile still labeled | A specific-looking number (`40`, `255`, `10000`) |
| A percentage | `—%` or "Not available" | A specific-looking percentage (`94.5%`, `95.0%`) |
| A person's name (parent, teacher, staff) | `"Not available"` or omit the row entirely | Any name that looks like a real name, invented or borrowed from another record |
| An address/phone/email | Omit the field/section entirely | A specific fake address, number, or email |
| A whole list/feed (notices, notifications, students) | Empty-state UI: "No notices yet" / "Couldn't load — Retry" | A hardcoded list of plausible-looking items |
| An API write (submit marks, update profile, moderate announcement, reset password) | Propagate the real error to the caller; UI shows a failure toast/dialog with a retry option | Returning `{'status': 'success'}` from a catch block |
| A derived/computed field (e.g. leave days from dates, teacher ID from a slot) | Compute it from the real inputs every time | A getter that returns a constant regardless of input |
| Routing/navigation with a required ID | If the ID is missing, show an error/back-out screen | Silently defaulting to id `'1'` or any other real record |

If two different fallback values already exist for the same field in different files
(e.g. attendance % defaulting to both `94.5` and `90.0` in the same screen depending on
code path — see `class_student_directory_screen.dart:109` vs `:388`), that is itself proof
the values are arbitrary, not meaningful defaults. Delete both; use the same "missing"
signal everywhere per the table above.

---

## 3. Full findings inventory (2026-09-27 audit)

Status column values: `OPEN` (not yet fixed), `FIXED` (changed + runtime-verified per
§5), `NEEDS-BACKEND` (frontend fix depends on a missing/incorrect API field — backend
ticket required first).

### 🔴 Critical — silent write failure reported as success
| # | File | Line | Status |
|---|---|---|---|
| 1 | `lib/data/services/student_api_service.dart` | `submitMarks()`, 128-147 | OPEN |
| 2 | `lib/data/services/account_api_service.dart` | `updateProfile()`, 23-30 | OPEN |
| 3 | `lib/data/services/auth_api_service.dart` | `verifyOtp()` 40-63, `resetPassword()` 65-78 | OPEN |
| 4 | `lib/data/services/announcement_api_service.dart` | `moderateAnnouncement()`, 33-44 | OPEN |

### 🔴 Critical — whole screens of fabricated data, not test-gated
| # | File | Line | Status |
|---|---|---|---|
| 5 | `lib/screens/calendar_announcements/notification_center_screen.dart` | 29-70 (no API call at all) | OPEN |
| 6 | `lib/screens/admin/parents_directory_screen.dart` | 182 (empty result), 189 (any error), 888-890 (header count) | OPEN |
| 7 | `lib/screens/dashboards/principal_dashboard_screen.dart` | 71-91 | OPEN |
| 8 | `lib/screens/calendar_announcements/notice_board_screen.dart` | 147-156 | NEEDS-BACKEND — `apps/announcements/api_views.py` `NoticeSerializer` never returns `post_type`/`author`/`audience`/`category`; add the fields or stop reading them |
| 9 | `lib/screens/calendar_announcements/events_desk_screen.dart` | 77-79 | NEEDS-BACKEND (same root cause as #8) |

### 🟠 High — fabricates identity/PII or targets the wrong real record
| # | File | Line | Status |
|---|---|---|---|
| 10 | `lib/screens/students/student_dossier_screen.dart` | 118-126 (father/mother name, phone, email, address, GPA, attendance%) | OPEN |
| 11 | `lib/screens/attendance/daily_roll_call_screen.dart` | 73-106, 182 (hardcoded ~32-name father-name map + `'Rajesh <surname>'` fallback) | OPEN |
| 12 | `lib/screens/account/account_profile_screen.dart` | 114-116 (hardcodes "Mohd Numan" for any Principal with a missing name) | OPEN |
| 13 | `lib/data/mock/auth_state.dart` | 236-237 (same "Mohd Numan" hardcode, root cause shared with #12) | OPEN |
| 14 | `lib/models/models.dart` | 485 — `TeacherLeaveRequest.days` getter always returns `2`, ignores real dates | OPEN |
| 15 | `lib/models/models.dart` | 863 — `TimetableSlot.teacherId` getter always returns `'TCH-001'` | OPEN |
| 16 | `lib/router.dart` | 351, 358, 373 — missing nav `id` silently defaults to real student id `'1'` | OPEN |
| 17 | `lib/router.dart` | 722 — `/student/:id/timetable` ignores `:id`, always renders `'Class X-A'` | OPEN |
| 18 | `lib/data/mock/mock_data.dart` → `class_teacher_dashboard_screen.dart:184,196` | `MockData.classes` (fake teacher names, e.g. "Anita Desai") used as a live fallback | OPEN |
| 19 | `lib/models/models.dart` | 671-677 — fee receipt `session ?? '2026-27'`, `feeHead ?? 'Tuition Fee'`, `receivedBy ?? 'Accounts Officer'` | OPEN |
| 20 | `lib/models/models.dart` | 319-322 — teacher address fallback (New Delhi / Central / 110054) | OPEN |
| 21 | `lib/models/models.dart` | 788 — `driverName ?? 'Assigned Staff'` | OPEN |
| 22 | `lib/screens/fees/fee_ledger_screen.dart` | 323 — `payment_mode ?? 'Online'` | OPEN |
| 23 | `lib/screens/fees/fee_receipt_screen.dart` | 190 — `className ?? 'Class 10-A'` on an official receipt | OPEN |
| 24 | `lib/screens/admissions/admissions_enquiry_screen.dart` | 390 — `grade_interested ?? 'Grade 1'` | OPEN |
| 25 | `lib/screens/faculty/faculty_allocation_screen.dart` | 385-386 — `total_faculty`/`allocated_count` both `?? 255` | OPEN |
| 26 | `lib/screens/attendance/faculty_leave_screen.dart` | 130-133 — leave balances `?? 6/8/12` | OPEN |
| 27 | `lib/screens/students/all_students_ledger_screen.dart` | 110-114 — `count ?? 10000` | OPEN |
| 28 | `lib/screens/faculty/class_student_directory_screen.dart` | 109, 388 — two different fake attendance % (94.5 vs 90.0) | OPEN |
| 29 | `lib/screens/dashboards/subject_teacher_cohorts_screen.dart` | 105-112, 126-128, 354-356 — hardcoded `attendance: 95%`, `avgScore: 78%` | OPEN |
| 30 | `lib/screens/dashboards/subject_teacher_dashboard_screen.dart` | 100 — hardcoded `students: 35` | OPEN |
| 31 | `lib/screens/dashboards/class_teacher_dashboard_screen.dart` | 421 (`totalStudents ?? 40`, dead `isTest?40:40`), 533 (present-count always `total-1`), 652 (`"24 / $total Recorded"` literal), 1154-1165 (`sample_student_name`/`sample_roll_no` keys that no API ever sets) | OPEN |
| 32 | `lib/screens/admin/account_settings_screen.dart` | 191 — static `"1 active session"`, file has zero API calls | OPEN |
| 33 | `lib/screens/admin/school_setup_screen.dart` | 123-156 — hardcoded `status: 'Operational'` per module, fake "Reset Fixtures" button | OPEN |

### 🟡 Medium
| # | File | Line | Status |
|---|---|---|---|
| 34 | `lib/screens/faculty/staff_directory_screen.dart` | 353-355 — `empId ?? 'EMP-102'` | OPEN |
| 35 | `lib/screens/faculty/class_info_screen.dart` | 359 — `weekly_periods ?? 4` | OPEN |
| 36 | `lib/screens/faculty/subject_teacher_assignments_screen.dart` | 139 (`avgStudents ?? 30`), 57-70/153-154 (hardcoded FA/SA weightage 30/70, 40/60 — confirm with backend whether this should be API-driven) | OPEN |
| 37 | `lib/screens/fees/fee_ledger_screen.dart` | 90, 134 — session hardcoded `'2026-27'` | OPEN |
| 38 | `lib/screens/admissions/applications_enrollment_screen.dart` | 102 — static `'Session 2026-27'` badge | OPEN |
| 39 | `lib/screens/auth/security_lockout_screen.dart` | 24 — fixed 840s countdown; backend has real 15/30/45-min tiers + `locked_until` (`apps/accounts/api_views.py:184`) | OPEN |
| 40 | `lib/screens/library_transport_inventory/bus_transit_screen.dart` | 288 — hardcoded stop `"Civil Lines Metro Gate 2"` for every student/route | OPEN |
| 41 | `lib/models/models.dart` | 716, 719, 722, 787, 829-839 — `Book`/`InventoryItem`/bus `capacity` fallbacks | OPEN |
| 42 | `lib/screens/admin/parents_directory_screen.dart` | 258 — `has_portal_account ?? true` | OPEN |

### Low / cleanup (not urgent, but part of closing this out)
| # | Item | Status |
|---|---|---|
| 43 | `Mock*Repository` classes in `lib/data/mock/mock_data.dart` — confirmed dead code (zero references outside their own definitions) | DELETE |
| 44 | `lib/core/api/api_config.dart:15` `useMockFallback` flag — declared, never referenced anywhere; gives false confidence a safety switch exists | DELETE-OR-WIRE-UP |
| 45 | `lib/data/mock/auth_state.dart:212` — `'demo12345'` fallback password when none supplied to `login()` | OPEN |
| 46 | `lib/screens/calendar_announcements/announcement_approval_screen.dart:241` — reads `created_at`, backend actually sends `submitted_at` (`apps/announcements/api_views.py:149`); currently falls back to blank, not a fake value, but the key mismatch should still be fixed | OPEN |

**Note on unrelated in-progress work found in this repo's working tree:** as of this
audit, `git status` shows uncommitted changes to `lib/data/mock/auth_state.dart`,
`lib/data/services/student_api_service.dart`, `daily_roll_call_screen.dart`,
`class_info_screen.dart`, `class_subjects_screen.dart`,
`subject_teacher_assignments_screen.dart`, `subject_teacher_classes_screen.dart`,
`teacher_timetable_screen.dart`, and `bottom_nav_bar.dart`. These are **role-resolution
and class-roster feature work** (distinguishing class-teacher vs. subject-teacher role,
adding a `getClassRoster()` method), unrelated to this fake-data audit. Do not assume they
already fix any item above — check the current diff before editing those files further, and
don't silently discard that work.

---

## 4. The single prompt (copy-paste this to run the fix)

```
Repo: sms-android-app-alpha (Flutter). Read MOCKDATA_FAKE_FALLBACK_MASTER.md in the repo
root in full before doing anything else — it is the single source of truth for this task,
replacing several prior audit docs that were deleted because they kept declaring partial
success without ever reaching zero. Do not create a new audit/status file; update
MOCKDATA_FAKE_FALLBACK_MASTER.md's status table in place as you go.

GOAL: every location listed in section 3 of that file must stop returning a
plausible-looking fake value when the real value is missing, null, or the request failed.
Apply the single rule in section 2: present-and-valid data renders as-is; anything else
renders an explicit, unmistakable "missing" signal (em dash, empty-state message, failure
toast with retry, error screen) — never a specific-looking number, name, address, status,
or list that could be mistaken for something real.

ORDER OF WORK (highest risk first):
1. Critical, item group 1-4 (services returning fake success on failure) — propagate the
   real error instead; the UI layer must catch it and show a failure state with retry.
   These are silent data-loss bugs (e.g. a teacher's marks submission fails but the app
   says it saved) — treat as the highest priority in the whole list.
2. Critical, item group 5-9 (whole-screen fabricated data) — replace with real empty/error
   states. For items 8 and 9, the root cause is the backend's NoticeSerializer
   (apps/announcements/api_views.py in the sibling Django repo) never sending
   post_type/author/audience/category — either get those fields added on the backend or
   stop reading keys that don't exist; do not paper over it with another frontend fallback.
3. High, items 10-33 — in priority order: PII fabrication first (10-13), then logic bugs
   disguised as fallbacks (14-15, these are not even fallbacks — they're getters that
   ignore their real inputs and must be rewritten to compute the actual value), then
   navigation/id fallbacks (16-17), then the remaining dashboard/screen-level hardcoded
   stats (18-33).
4. Medium, items 34-42.
5. Cleanup, items 43-46.

CONSTRAINTS:
- Do not introduce a new inconsistent fallback while fixing an old one. If you find a
  second occurrence of the same field with a different fake default elsewhere in the app
  (there is at least one already known: attendance % defaults to both 94.5 and 90.0 in
  class_student_directory_screen.dart), unify both to the same real "missing" signal per
  the table in section 2, and note it in the status table even if it wasn't separately
  numbered.
- Do not touch the unrelated in-progress role-resolution/class-roster changes already
  sitting uncommitted in this working tree (see the note at the end of section 3) beyond
  what's required to fix a listed item in the same file — check `git diff <file>` before
  editing any file that already has pending changes.
- Where a fix depends on a backend field that doesn't exist (marked NEEDS-BACKEND), do not
  invent a frontend workaround that re-introduces a fallback. Either wire up the real field
  once it exists, or ship the honest empty/error state and file the backend gap separately.

VERIFICATION (mandatory before marking any row FIXED — this is where every prior audit
failed):
- A code read is not verification. For each item, force the missing/failed condition for
  real (strip the field from a test API response, disconnect the network, hit an endpoint
  that 500s, or use an account whose backend record actually lacks the field) and confirm
  the UI shows the honest missing-state, not the old fake value and not a crash.
- Prefer an automated widget/integration test that asserts on the missing-state per fixed
  screen where the test infra supports it; fall back to a manual on-device check (physical
  device or emulator) and note in the status table how it was verified (test name, or
  "manual: <what you did>").
- Only after that verification passes, change the row's Status to FIXED in section 3, and
  update the Status line at the top of the file with the new open count.
- If you fix something partially or discover the real fix requires backend changes you
  can't make from this repo, mark it NEEDS-BACKEND with a one-line note on exactly what
  the backend must add/change — do not mark it FIXED and do not leave it silently OPEN with
  no explanation.

When every row in section 3 is FIXED or NEEDS-BACKEND (with the backend gap filed), update
the Status line at the top of this file to reflect that, listing any remaining
NEEDS-BACKEND items explicitly. Do not declare the file/task done while any row is still OPEN.
```

---

## 5. Verification log

Record each verified fix here as it happens — item number, what was changed, how it was
verified, and by whom/when. Keep section 3's Status column and this log in sync.

| Item # | Change summary | Verified how | Date |
|---|---|---|---|
| _(none yet — 0 of 46 fixed as of 2026-09-27)_ | | | |
