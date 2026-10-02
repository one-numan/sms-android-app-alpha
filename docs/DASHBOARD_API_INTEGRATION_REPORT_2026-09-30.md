# Dashboard API Integration — Report (2026-09-30)

## Scope

Integrate the 11 role dashboards against the live backend
(`http://127.0.0.1:8000`), correcting card/field mapping, links, and
null/empty handling — without changing existing UI/UX (layout, colors,
components, navigation style). No backend code was touched.

Verification method: real login against the running backend for each
role (`curl` against `/api/v1/auth/login/` + each dashboard endpoint),
comparing actual JSON field names/shapes against what the Flutter code
was reading, then fixing mismatches. Followed by `flutter analyze`
(clean, 0 issues) and `flutter test` (315/315 passing) after every
file changed.

**Not done in this pass:** on-device/emulator click-through with the
running backend. Everything below is verified at the code + automated
test level, not by visually driving the app. That verification is
what this session is doing next.

---

## New screens (didn't exist before)

### Receptionist — Front Desk Dashboard
- `lib/screens/dashboards/front_desk_dashboard_screen.dart`
- `lib/data/services/receptionist_api_service.dart`
- Wired to `GET /api/v1/receptionist/dashboard/`. Shows new/total
  enquiries, enquiries-by-status, pending/total applications,
  applications-by-status, recent enquiries list, pending applications
  list.
- Previously the receptionist role had **no dashboard at all** — login
  and the bottom nav's first tab both dropped straight into the
  enquiry list screen. Fixed:
  - `lib/screens/auth/login_screen.dart` — post-login route for
    receptionist now goes to `/dashboard/receptionist`.
  - `lib/widgets/bottom_nav_bar.dart` — receptionist's first tab
    renamed "Enquiries" → "Desk", now points at the new dashboard
    (matches the same Hub/Desk/Portal pattern every other role's first
    tab already uses).
  - `lib/router.dart` — added `/dashboard/receptionist` route; root
    `/` for the receptionist role now resolves to this screen.

### Super Admin — System Telemetry
- `lib/screens/dashboards/telemetry_dashboard_screen.dart`
- `lib/data/services/telemetry_api_service.dart`
- Wired to `GET /api/v1/telemetry/dashboard/?days=7|30|90`. Period
  chips (7/30/90 days) drive the query param and refetch. Shows total
  error count, web vs. API error split, top categories, top features,
  recent errors list with severity badges.
- Reachable from `super_admin_modules_screen.dart` (new "System
  Telemetry" row) and from the module grid sheet.
- Route: `/admin/telemetry`.

---

## Existing dashboards — bugs found and fixed

Each of these was a real mismatch between what the screen displayed
and what the backend actually returns for that endpoint — not just
"needed the API plugged in."

### Principal Dashboard (`principal_dashboard_screen.dart`)
- **Needs Attention** read `pending_applications_count` /
  `pending_leaves_count` / `pending_circulars_count` — none of these
  keys exist in the real response. The section always rendered empty
  ("All clear") even when there were 181 pending applications. Fixed
  to read the real top-level fields: `applications_pending`,
  `leave_requests_pending`, `pending_circular_moderation`.
- **Fee Collection** read `fee_collection`/`fee_summary` objects that
  don't exist — always showed ₹0 / ₹0. Fixed to read
  `today.fees.{expected,collected}` (falling back to
  `monthly_fee_collection`), with outstanding computed and floored at
  0.
- **Class & Section Progress** read a `class_progress` array that
  doesn't exist — the card was permanently empty in production. Now
  maps `performance.results.top_classes` (real per-class exam
  percentages).
- **Upcoming Events** was two hardcoded fake events ("Term 2
  Examination Commences", "Parent-Teacher Conference") shown
  unconditionally. Now maps `activity.upcoming_holidays`, with an
  honest empty state when there are none.

### Student Hub (`student_hub_screen.dart`)
- **Term Result** card showed hardcoded `Grade A1` always, ignoring
  the real `report_card.{grade,percentage}` the API already returns.
  Fixed.
- **Today's Schedule** read an `item['time']` key that doesn't exist
  in the real payload (`start_time`/`end_time` do) — every schedule
  row showed a blank time. Fixed, now also shows the teacher name per
  period.

### Parent Dashboard (`parent_dashboard_screen.dart`)
- **"Bus Track" quick action** linked to `/library/desk` (copy/paste
  bug). Fixed to `/transit/bus`.

### Subject Teacher Dashboard (`subject_teacher_dashboard_screen.dart`)
- The assigned-classes list was built by calling a *different*
  endpoint (teacher timetable) and fabricating `students: 35` and
  `room: 'Allocated Room'` for every single class, instead of using
  the real per-class data (`assigned_classes`) the subject-dashboard
  endpoint already returns, including real student counts per class.
  Rewired to use the real field directly; removed the now-unused
  timetable-based derivation and the fabricated defaults.

### Subject Teacher Cohorts / My Classes (`subject_teacher_cohorts_screen.dart`)
- Every class card's "Attendance / Avg Score / FA2 Status" strip was
  hardcoded fallback data (`95.0%`, `78.0%`, `'Completed'`) — the
  backend does not provide any of these three fields at all, so every
  student saw fabricated performance numbers on every class, always.
  Per the task's explicit instruction for known backend gaps, these
  are no longer invented — the strip now shows `—` when the backend
  doesn't supply a value, instead of a fake number.

### Class Teacher Dashboard (`class_teacher_dashboard_screen.dart`)
- Total student count defaulted to a hardcoded `40` when data was
  missing (`?? (isTest ? 40 : 40)` — a dead ternary that was always
  40 either way). Fixed to `?? 0` with the existing "No students
  currently assigned" empty state taking over correctly.
- Present/absent count had a guessed fallback (`totalStudents - 1` /
  `24`) instead of just showing 0 when the backend hadn't sent a
  value. Fixed.
- Current/next period card fell back to fabricated specifics
  (`Mathematics`, `Room 204`, `11:05 AM`) when a real schedule slot was
  missing a field. Fixed to honest placeholders (`Not specified`,
  `Not assigned`, `—`).
- Added a `dashboardDataOverride` constructor param (matching the
  existing override pattern already used for other test-only
  injection) so widget tests can supply realistic fixture data instead
  of the fix relying on a silent production fake-default.

### Accountant Dashboard (`accountant_dashboard_screen.dart`)
- Realized/collection percentage was being recomputed client-side
  from `total_collected / total_expected`, duplicating logic the
  backend already does server-side via `collection_percentage` (and
  producing a different number in edge cases where collected exceeds
  expected). Now prefers the backend's own `collection_percentage`
  field.

### Librarian Dashboard (`librarian_dashboard_screen.dart`)
- The "Return" button on an active loan always showed a green
  "Returned: ..." success message — but there is no backend endpoint
  to actually return a book (`library/dashboard/` is GET-only; no
  return action exists server-side). This was a fake-success bug: the
  UI claimed the action worked when nothing happened. Changed the
  message to honestly say returns aren't supported yet, rather than
  lying about the outcome.

### Student Dossier (`student_dossier_screen.dart`)
- Class/section always displayed the literal hardcoded fallback
  **"Grade Nursery A"** for every student, regardless of their actual
  class — the code read `class_name`/`section` keys that don't exist;
  the real field is `class_section`. This would have shown the wrong
  class for essentially every student in a demo. Fixed.
- Guardian phone/email fallback chain didn't check the real field
  names (`primary_contact`, top-level `guardian_mobile` /
  `guardian_email`) — always showed "N/A" even though the data exists.
  Fixed.
- **Fees tab hardcoded "Outstanding Balance: ₹0.00" unconditionally**,
  regardless of the student's actual dues (a student with ₹58,140.38
  outstanding would have shown ₹0.00). Fixed to show the real
  `fee_summary.outstanding_dues` / `total_dues`.
- Academics tab had fully invented rows: "Academic Standing: First
  Class with Distinction" and "Class Rank: 3 of 40" — no such fields
  exist server-side. Replaced with the real `overall_percentage` and
  `rank_in_class`.
- Attendance tab had hardcoded "Days Present: 85 Days" / "Days Absent:
  5 Days" for every student. No such fields exist server-side; removed
  rather than continuing to invent numbers.

### Digital Student ID Card (`digital_student_id_card_screen.dart`)
- Admission number was fabricated as `ADM-2024-<raw numeric id>` when
  the backend only ever returns the internal numeric PK — inventing a
  plausible-looking but fake admission-number format. Fixed to prefer
  real fields (`admission_number`, `barcode`) and fall back to the
  backend's own `STU-<id>` convention instead of a fabricated one.
- "House" fell back to a fixed fake value ("Primary Wing" / "Ruby
  House" in the mock) — backend has no house field at all. Changed
  fallback to "Not assigned".
- QR/verification code never checked the real fields the backend
  actually returns (`qr_code_payload`, `qr_token`, `barcode`,
  `barcode_data`) — always fell back to a generic placeholder. Fixed.
- "EMERGENCY CONTACT (FATHER)" assumed a relation the backend doesn't
  specify; fallback changed to the neutral "EMERGENCY CONTACT" when no
  relation is provided.

---

## Open item

**"School Admin" role**: the task brief states Principal, Vice
Principal, School Admin, and Super Admin "currently share the
Principal dashboard." This codebase has no distinct `schoolAdmin`
role — only `superAdmin`, which lands on the Modules directory screen,
not the Principal dashboard. I did not force Super Admin onto the
Principal dashboard screen, since that's a navigation-structure change
beyond correcting data/mapping — flagging for a decision rather than
guessing.

---

## Verification status

| Check | Status |
|---|---|
| `flutter analyze` | Clean, 0 issues (whole project) |
| `flutter test` | 315/315 passing |
| Backend field names cross-checked via live `curl` per role | Done |
| On-device / emulator visual verification | **Not yet done — next step** |
