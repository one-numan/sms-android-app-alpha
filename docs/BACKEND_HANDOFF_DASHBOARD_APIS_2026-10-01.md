# Backend → Frontend Handoff: Dashboard APIs (Needs Attention + Today Status)

**From:** Backend team lead
**To:** Android/Flutter frontend team
**Date:** 2026-10-01
**Status:** 🔴 **Blocking for production launch** — one shipped-looking feature is silently broken, and 6 of 7 roles have zero integration.

---

## 0. Why this doc exists

Both dashboard APIs below are **live on the backend today** — shipped, tested, routed. But auditing the current Android code against the actual routes turned up a real bug (not just a missing-integration gap): the one dashboard that *does* call the attention feed is calling a URL that doesn't exist, fails silently, and renders an empty "all caught up" state in production regardless of what's actually pending. That's worse than not integrating it at all, because it looks correct in a demo.

This doc is the complete, current contract for both endpoints — every field, every role's real response shape, every error case — so the frontend pass can be done once, correctly, against the real backend instead of against the two source docs this consolidates (`docs/attention_api_android.md`, `docs/today_status_api_android.md`), one of which is itself stale (see §3.0).

---

## 1. What's actually shipped on the backend

| Endpoint | Route | Scope | Status |
|---|---|---|---|
| Needs Attention feed | `GET /api/v1/attention/` | **All 7 authenticated roles** — one endpoint, server-side role-scoped | Shipped `33a25a2` (2026-09-27) |
| Today Status | `GET /api/v1/teacher/today-status/` | Class Teacher + Subject Teacher only (by design) | Shipped `d0b6bb3` (2026-09-27) |

Both are real, tested, in production code today — `apps/common/attention.py`, `apps/common/api_views.py`, `apps/reports/api_views.py`. Nothing here is "proposed" or "planned," despite what `docs/today_status_api_android.md`'s own header currently says (see §3.0).

---

## 2. What's missing / broken in Android — the blocking list

### 2.1 🔴 Bug: attention feed is called at the wrong URL (silently fails to empty)

- **File:** `lib/data/services/teacher_api_service.dart:31`
- **Calls:** `GET /teacher/dashboard/attention/`
- **Real route:** `GET /api/v1/attention/` (`apps/api/urls.py:128`, confirmed in `apps/common/attention.py` and `docs/attention_api_android.md:16`)

The wrong-URL request 404s. The `try/catch` at `teacher_api_service.dart:36` swallows it and returns `{'total_count': 0, 'items': []}`. The Class Teacher dashboard (`class_teacher_dashboard_screen.dart`) then renders its "Needs Attention" card as genuinely empty — **no error, no crash, just wrong data** — no matter how many real leave requests, defaulters, or overdue books exist. This is the only dashboard currently wired to this endpoint at all, and it doesn't work.

**Fix:** change the path string to `/attention/`.

### 2.2 🔴 Bug: `deep_link` from the API is never read — navigation is hardcoded and wrong per item

- **File:** `class_teacher_dashboard_screen.dart:1127`
- **Current code:** `item['action_route']?.toString() ?? '/attendance/roll-call'`

The backend doesn't send an `action_route` field — it sends `deep_link: {"screen": "<key>", "params": {}}` (11 possible keys, see §3.4). Since `action_route` is never present, **every single attention item — fee defaulters, overdue books, pending admissions, whatever — routes to the attendance roll-call screen** when tapped. A confirmed `grep` across the whole `lib/` tree finds zero references to `deep_link` anywhere in the codebase — this contract isn't partially done, it's not started.

**Fix:** read `item['deep_link']['screen']` and map each of the 11 keys (§3.4) to its real route.

### 2.3 🔴 No `type`-based rendering — severity and action semantics are invisible

The spec (§3.5 below) is explicit: render by `type` (`actionable_queue` / `alert_count` / `reminder`), not by hardcoding one visual treatment. Current code (`class_teacher_dashboard_screen.dart:1083-1150`) renders every item identically — same icon, same "Review" button regardless of whether the item has an action at all (`reminder` items should show **no button**), and never reads `severity` to drive color (everything is the warning pill, even `info`-severity reminders like upcoming birthdays).

### 2.4 🔴 6 of 7 roles have no integration at all

Only Class Teacher calls the endpoint (and does so incorrectly, per §2.1). Confirmed by grep across `lib/data/services/`:

| Role | Attention feed wired? | File that should call it |
|---|---|---|
| Leadership (Principal/VP/Super Admin) | ⚠️ Partial — see §2.5 | `principal_api_service.dart` |
| Accountant | ❌ Not wired | `accountant_api_service.dart` |
| Librarian | ❌ Not wired | `library_api_service.dart` |
| Receptionist | ❌ Not wired | `receptionist_api_service.dart` |
| Teacher (Class) | ⚠️ Wired, but broken — §2.1 | `teacher_api_service.dart` |
| Teacher (Subject) | ❌ Not wired | `teacher_api_service.dart` |
| Parent | ❌ Not wired | `parent_api_service.dart` |
| Student | ❌ Not wired | `student_api_service.dart` |

### 2.5 ⚠️ Principal dashboard has a *different*, narrower "Needs Attention" card

`principal_dashboard_screen.dart` shows a "Needs Attention" section, but it's built from `principal/dashboard/`'s own fields (`applications_pending`, `leave_requests_pending`, `pending_circular_moderation`) — not from `/attention/`. It works (real data, per the 2026-09-30 integration report), but it means the leadership tier is missing `fees.defaulters`, `library.overdue`, `inventory.low_stock`, and the calendar reminders that `/attention/` would also give them (§3.5, §5.1) — and if this feed's logic ever changes server-side, the principal dashboard won't pick it up because it isn't calling it. **Decide:** migrate the Principal card onto `/attention/` for consistency, or deliberately keep it separate — but it should be a decision, not an accident.

### 2.6 ❌ Today Status: wired for Class Teacher, missing for Subject Teacher

`getTodayStatus()` is called correctly (`/teacher/today-status/` — URL matches, this one's fine) from `class_teacher_dashboard_screen.dart` only. The endpoint explicitly supports Subject Teachers too (`attendance` is simply `null` for a teacher with no homeroom — see §4.2) but `subject_teacher_dashboard_screen.dart` never calls it, so Subject Teachers get none of the consolidated day-type/current-period/next-period truth this endpoint exists to provide.

### 2.7 ⚠️ Documentation drift — don't build against the spec docs as-is

- `docs/today_status_api_android.md` still has the header **"PROPOSED, NOT YET IMPLEMENTED"** and says every JSON example is "illustrative... not captured from a real response." That's false as of `d0b6bb3` — the endpoint is live. Its §4.9 error example (`{"success": false, "status": "error", "message": ..., "error_code": "TEACHER_PROFILE_NOT_FOUND"}`) is **also wrong** — see §4.5 below for the real error shape.
- `docs/ai-context/FEATURE_STATUS.md` and `IMPLEMENTATION_STATUS.md` list the attention feed as `BACKEND_ONLY` and today-status as `PLANNED` — both understate reality (partial, buggy code already exists) and should be corrected once this pass lands, not before.

**Use §3 and §4 of this doc as the source of truth, not the two files above, until someone updates them.**

---

## 3. Full contract — Needs Attention feed

### 3.1 Endpoint

```
GET /api/v1/attention/
Authorization: Bearer <JWT access token>
```

No query params. No pagination — `items` is a plain array (every item is already a cheap aggregate; there's nothing to page through). Base URL in the app is `ApiConfig.baseUrl` = `https://alpha.onenuman.com/api/v1` (`lib/core/api/api_config.dart:5`), so the full request is `https://alpha.onenuman.com/api/v1/attention/`.

### 3.2 Response envelope

```json
{
  "success": true,
  "data": {
    "items": [ ],
    "summary": { "fees": 1, "library": 1 },
    "total_count": 2
  }
}
```

`summary` is a count per `domain` — use it for a badge/notification-dot total, or a per-tab dot (e.g. red dot on "Fees"), without counting the array yourself.

### 3.3 Item field reference

| Field | Type | Meaning |
|---|---|---|
| `id` | string | Stable `"<domain>.<thing>"` slug. Safe as a list key / dedup key. |
| `domain` | string | `attendance`, `announcements`, `admissions`, `fees`, `library`, `inventory`, `calendar` today — **open-ended**, more will be added. Don't hardcode a switch over the full set. |
| `type` | string | `actionable_queue` (a real action is waiting — render a CTA) · `alert_count` (a condition worth surfacing — tap opens the relevant list screen, no inline action) · `reminder` (informational — **no button at all**, not a disabled one). |
| `severity` | string | `critical` / `warning` / `info` — drives color only, never shown as text. Nothing emits `critical` today, but it's reserved for a future threshold alert — don't assume it can never appear. |
| `title` | string | Ready-to-render, already pluralized/currency-formatted. **Don't rebuild it from `count` client-side.** |
| `count` | integer \| `null` | `null` means "this item isn't fundamentally a count" (a due amount, a named holiday) — **don't coerce to `0`**, don't hide the item. |
| `action_label` | string \| `null` | Button text. `null` for every `reminder` — render no button. |
| `deep_link` | object | `{"screen": "<key>", "params": {}}`. `params` is always `{}` today (reserved for an id-scoped destination later). See §3.4 for the key glossary. |

### 3.4 `deep_link.screen` → destination glossary (all 11 keys)

| `screen` | Domain | Destination |
|---|---|---|
| `faculty_leave_review` | attendance | Leave-request review queue (principal/VP action screen) |
| `my_leave_requests` | attendance | Signed-in teacher's own leave request history |
| `moderation_queue` | announcements | Notice/circular approval queue |
| `admissions_applications` | admissions | Applications list, ideally pre-filtered to Pending |
| `fee_defaulters` | fees | School-wide defaulters report (accountant/leadership only) |
| `fee_ledger` | fees | Signed-in parent/student's own fee ledger |
| `library_overdue` | library | School-wide overdue-loans list (librarian/leadership only) |
| `my_library_loans` | library | Signed-in parent/student's own (child's) loans |
| `inventory_low_stock` | inventory | Inventory filtered to at/below reorder level |
| `calendar` | calendar | School calendar / holiday list |
| `birthdays` | calendar | Birthday list screen |

New domains only ever **add** keys here — an existing key is never repurposed. Map all 11 now; don't hardcode per-item navigation like the current code does (§2.2).

### 3.5 Build rules (non-negotiable — these are what make the feed future-proof)

1. **Render generically off `type`, never off `id`/`domain`.** Three renderers cover every item today and every one the backend adds later. A `switch(domain)` forces an app release every time a new signal ships.
2. **`count: null` is "not a count," not zero.** Don't filter it out, don't print "0".
3. **`summary` is for badges, `items` is for the list.** They're both precomputed server-side — don't re-derive one from the other.
4. **Sort order is already decided** — the array arrives severity-ordered (critical → warning → info). Don't re-sort unless you're deliberately grouping by domain.

### 3.6 Real response per role (all captured against the live dev DB)

#### Leadership tier — Principal / VP / Super Admin / School Admin
All four resolve identically — same feed, no behavioral difference between them. Richest role: the whole school's queues.

```json
{
  "success": true,
  "data": {
    "items": [
      { "id": "attendance.leave_requests", "domain": "attendance", "type": "actionable_queue", "severity": "warning",
        "title": "1 leave request awaiting your review", "count": 1,
        "action_label": "Review requests", "deep_link": {"screen": "faculty_leave_review"} },
      { "id": "announcements.moderation_queue", "domain": "announcements", "type": "actionable_queue", "severity": "warning",
        "title": "2 notices waiting for approval", "count": 2,
        "action_label": "Review queue", "deep_link": {"screen": "moderation_queue"} },
      { "id": "admissions.pending_applications", "domain": "admissions", "type": "actionable_queue", "severity": "warning",
        "title": "90 applications awaiting review", "count": 90,
        "action_label": "View applications", "deep_link": {"screen": "admissions_applications"} },
      { "id": "fees.defaulters", "domain": "fees", "type": "alert_count", "severity": "warning",
        "title": "10000 students have pending fees (₹623,312,970 total)", "count": 10000,
        "action_label": "View defaulters", "deep_link": {"screen": "fee_defaulters"} },
      { "id": "library.overdue", "domain": "library", "type": "alert_count", "severity": "warning",
        "title": "214 books overdue", "count": 214,
        "action_label": "View overdue loans", "deep_link": {"screen": "library_overdue"} },
      { "id": "inventory.low_stock", "domain": "inventory", "type": "alert_count", "severity": "info",
        "title": "1 inventory item at or below reorder level", "count": 1,
        "action_label": "View inventory", "deep_link": {"screen": "inventory_low_stock"} },
      { "id": "calendar.next_holiday", "domain": "calendar", "type": "reminder", "severity": "info",
        "title": "Diwali on 2026-10-15", "count": null,
        "action_label": null, "deep_link": {"screen": "calendar"} },
      { "id": "calendar.upcoming_birthdays", "domain": "calendar", "type": "reminder", "severity": "info",
        "title": "194 birthdays this week", "count": 194,
        "action_label": null, "deep_link": {"screen": "birthdays"} }
    ],
    "summary": { "attendance": 1, "announcements": 1, "admissions": 1, "fees": 1, "library": 1, "inventory": 1, "calendar": 2 },
    "total_count": 8
  }
}
```
(Large fee/defaulter numbers are real dev-seed scale — good stress case for comma-grouped currency and title wrapping on small screens.)

#### Accountant — `fees` only
```json
{
  "success": true,
  "data": {
    "items": [
      { "id": "fees.defaulters", "domain": "fees", "type": "alert_count", "severity": "warning",
        "title": "10000 students have pending fees (₹623,312,970 total)", "count": 10000,
        "action_label": "View defaulters", "deep_link": {"screen": "fee_defaulters"} }
    ],
    "summary": { "fees": 1 }, "total_count": 1
  }
}
```

#### Librarian — `library` only
```json
{
  "success": true,
  "data": {
    "items": [
      { "id": "library.overdue", "domain": "library", "type": "alert_count", "severity": "warning",
        "title": "214 books overdue", "count": 214,
        "action_label": "View overdue loans", "deep_link": {"screen": "library_overdue"} }
    ],
    "summary": { "library": 1 }, "total_count": 1
  }
}
```

#### Receptionist — `admissions` only
```json
{
  "success": true,
  "data": {
    "items": [
      { "id": "admissions.pending_applications", "domain": "admissions", "type": "actionable_queue", "severity": "warning",
        "title": "90 applications awaiting review", "count": 90,
        "action_label": "View applications", "deep_link": {"screen": "admissions_applications"} }
    ],
    "summary": { "admissions": 1 }, "total_count": 1
  }
}
```

#### Teacher (Class or Subject — identical feed shape today)
No pending leave:
```json
{
  "success": true,
  "data": {
    "items": [
      { "id": "calendar.upcoming_birthdays", "domain": "calendar", "type": "reminder", "severity": "info",
        "title": "8 birthdays this week", "count": 8, "action_label": null, "deep_link": {"screen": "birthdays"} }
    ],
    "summary": { "calendar": 1 }, "total_count": 1
  }
}
```
One pending leave request:
```json
{
  "success": true,
  "data": {
    "items": [
      { "id": "attendance.my_leave_requests", "domain": "attendance", "type": "reminder", "severity": "info",
        "title": "1 of your leave request still pending approval", "count": 1,
        "action_label": null, "deep_link": {"screen": "my_leave_requests"} },
      { "id": "calendar.next_holiday", "domain": "calendar", "type": "reminder", "severity": "info",
        "title": "Diwali on 2026-10-15", "count": null, "action_label": null, "deep_link": {"screen": "calendar"} },
      { "id": "calendar.upcoming_birthdays", "domain": "calendar", "type": "reminder", "severity": "info",
        "title": "8 birthdays this week", "count": 8, "action_label": null, "deep_link": {"screen": "birthdays"} }
    ],
    "summary": { "attendance": 1, "calendar": 2 }, "total_count": 3
  }
}
```
Note: a Class Teacher gets *nothing extra* over a Subject Teacher in this feed today (their own roll-call/marks-entry progress isn't wired into it — that's a backend backlog item, not an Android gap).

#### Parent — one aggregated item per domain, summed across all children
```json
{
  "success": true,
  "data": {
    "items": [
      { "id": "fees.my_dues", "domain": "fees", "type": "alert_count", "severity": "warning",
        "title": "₹67,976 in fees is due", "count": null,
        "action_label": "View fee ledger", "deep_link": {"screen": "fee_ledger"} },
      { "id": "library.my_overdue", "domain": "library", "type": "alert_count", "severity": "warning",
        "title": "1 book overdue", "count": 1,
        "action_label": "View my loans", "deep_link": {"screen": "my_library_loans"} }
    ],
    "summary": { "fees": 1, "library": 1 }, "total_count": 2
  }
}
```
**A parent with 5 children who all owe fees still gets exactly one `fees.my_dues` row and one `library.my_overdue` row — never one per child.** Don't build a variable-length-per-child list here.

#### Student — same shape as Parent, scoped to self
```json
{
  "success": true,
  "data": {
    "items": [
      { "id": "fees.my_dues", "domain": "fees", "type": "alert_count", "severity": "warning",
        "title": "₹67,976 in fees is due", "count": null,
        "action_label": "View fee ledger", "deep_link": {"screen": "fee_ledger"} },
      { "id": "library.my_overdue", "domain": "library", "type": "alert_count", "severity": "warning",
        "title": "1 book overdue", "count": 1,
        "action_label": "View my loans", "deep_link": {"screen": "my_library_loans"} }
    ],
    "summary": { "fees": 1, "library": 1 }, "total_count": 2
  }
}
```

#### Empty state — the single most common real response for a clean record
```json
{
  "success": true,
  "data": { "items": [], "summary": {}, "total_count": 0 }
}
```
Design this as a first-class state ("You're all caught up"), not a loading placeholder or a hidden card — the user needs confirmation the check actually ran.

**One exception to role-gating:** `calendar.next_holiday` is a whole-school fact and can appear for *any* authenticated user, even one with no teacher/parent/student/staff profile at all. Seeing it somewhere unexpected is not a bug.

### 3.7 Errors

| Status | Body | When |
|---|---|---|
| `401` | `{"detail": "Authentication credentials were not provided."}` | Missing/expired token — identical shape to every other `/api/v1/` 401, handle it the same way. |

There is no role-based `403` on this endpoint — every authenticated user gets *a* response, possibly empty. A `403` here means something else broke upstream (bad token audience, disabled account).

---

## 4. Full contract — Today Status

### 4.1 Endpoint

```
GET /api/v1/teacher/today-status/
Authorization: Bearer <JWT access token>
```

No query params. Resolves the teacher from the JWT. **Role scope: Class Teacher and Subject Teacher only.** Unlike `teacher_timetable`, this endpoint does **not** fall back to `Teacher.objects.first()` for a Principal/staff caller with no Teacher profile — it returns a clean 403 instead (§4.5). Don't call this from the Principal/Accountant/Librarian/Receptionist/Parent/Student dashboards.

### 4.2 Response envelope

```json
{
  "success": true,
  "data": {
    "date": "2026-09-27",
    "is_teaching_day": false,
    "day_type": "WEEKLY_OFF",
    "reason": "Weekly Off (Sunday)",
    "current_period": null,
    "next_period": null,
    "attendance": null
  }
}
```

### 4.3 Field reference

| Field | Type | Meaning |
|---|---|---|
| `date` | string `YYYY-MM-DD` | Server's current date. |
| `is_teaching_day` | bool | Whether school is in session today. |
| `day_type` | enum | `WORKING` \| `WEEKLY_OFF` \| `HOLIDAY`. |
| `reason` | string \| `null` | `null` on a plain `WORKING` day; populated for `WEEKLY_OFF`/`HOLIDAY`, and also for a notable `WORKING` day (e.g. a declared compensatory working day — §4.4 scenario). |
| `current_period` | object \| `null` | `null` if no period is running right now. |
| `next_period` | object \| `null` | Shape: `{period_number, subject_name, class_name, room_number, start_time, end_time}`. `null` if none remain today. |
| `attendance` | object \| `null` | **`null` entirely if this teacher has no homeroom class** — a pure Subject Teacher. Presence of this key, not the role name, is what should drive whether the "Take Attendance" card renders at all. |
| `attendance.class_id` / `class_name` | string | Teacher's homeroom class. |
| `attendance.status` | enum | `NOT_MARKED` \| `PARTIAL` \| `MARKED` \| `NOT_APPLICABLE` (`NOT_APPLICABLE` only when `is_teaching_day` is false). |
| `attendance.marked_count` / `total_students` | int | **Only present when `status == "PARTIAL"`.** Don't expect these keys otherwise. |
| `attendance.can_take_attendance` | bool | `false` only when `is_teaching_day` is false. **Re-marking an already-`MARKED` day is still `true`** by design — the backend upserts for corrections, this endpoint must not contradict that by locking the UI once marked. |

**⚠️ `room_number` is always `null`.** The schema has no room/venue model anywhere (`TimetableSlot`/`Period`/`Class` all lack one — confirmed in `apps/reports/api_views.py`'s `today_status`, which hardcodes it to `None` with an explicit comment, not an oversight). Don't build a "Room 204" placeholder when this is missing — show "Not assigned" / nothing, same as the rest of the app already does elsewhere for this exact gap.

### 4.4 Key scenarios (all shapes real/confirmed against the live view)

**Working day, before first period:**
```json
{
  "success": true,
  "data": {
    "date": "2026-09-29", "is_teaching_day": true, "day_type": "WORKING", "reason": null,
    "current_period": null,
    "next_period": { "period_number": 1, "subject_name": "English", "class_name": "Grade 2 F",
      "room_number": null, "start_time": "09:00 AM", "end_time": "09:40 AM" },
    "attendance": { "class_id": "CLS-12", "class_name": "Grade Nursery B", "status": "NOT_MARKED", "can_take_attendance": true }
  }
}
```

**Currently inside a period:**
```json
{
  "success": true,
  "data": {
    "date": "2026-09-29", "is_teaching_day": true, "day_type": "WORKING", "reason": null,
    "current_period": { "period_number": 1, "subject_name": "English", "class_name": "Grade 2 F",
      "room_number": null, "start_time": "09:00 AM", "end_time": "09:40 AM" },
    "next_period": { "period_number": 2, "subject_name": "Mathematics", "class_name": "Grade 2 F",
      "room_number": null, "start_time": "09:45 AM", "end_time": "10:25 AM" },
    "attendance": { "class_id": "CLS-12", "class_name": "Grade Nursery B", "status": "MARKED", "can_take_attendance": true }
  }
}
```

**Attendance partially marked:**
```json
{
  "attendance": {
    "class_id": "CLS-12", "class_name": "Grade Nursery B", "status": "PARTIAL",
    "marked_count": 32, "total_students": 40, "can_take_attendance": true
  }
}
```

**Holiday, Subject Teacher (no homeroom):**
```json
{
  "success": true,
  "data": {
    "date": "2026-09-27", "is_teaching_day": false, "day_type": "HOLIDAY",
    "reason": "Gazetted Holiday — Gandhi Jayanti",
    "current_period": null, "next_period": null, "attendance": null
  }
}
```

**Day over vs. holiday — look identical on the period fields, differ on `day_type`:**
A teaching day where the teacher's periods are simply all finished for the day, and a day with zero periods because it's a holiday, both render `current_period: null, next_period: null`. **Distinguish using `is_teaching_day` / `day_type` — never infer "holiday" from both period fields being null.**

### 4.5 Errors — the real shape (the spec doc's example is wrong)

`today_status` calls `require_teacher(request.user)` (`apps/api/permissions.py:41-46`), which raises DRF's `PermissionDenied` — routed through the standard `telemetry_exception_handler`, i.e. **DRF's default error body, not a custom envelope**:

```
HTTP 403
{
  "detail": "This account has no linked teacher record."
}
```

`docs/today_status_api_android.md:§4.9` currently documents this as `{"success": false, "status": "error", "message": ..., "error_code": "TEACHER_PROFILE_NOT_FOUND"}` — **that shape is not what the live endpoint returns.** Build against the `{"detail": "..."}` / 403 shape above, same as every other permission-denied case elsewhere in the app, not the doc's `error_code` example.

---

## 5. Acceptance checklist — what "done" looks like

- [x] Fix `teacher_api_service.dart:31` — `/teacher/dashboard/attention/` → `/attention/`.
- [x] Wire `GET /attention/` into all 7 role dashboards: Principal/VP (replace or reconcile with the existing custom card, §2.5), Accountant, Librarian, Receptionist, Subject Teacher, Parent, Student. Class Teacher just needs the URL fix.
- [x] Implement the `deep_link.screen` → route map (§3.4, all 11 keys) and use it instead of the current hardcoded `/attendance/roll-call` fallback.
- [x] Render by `type` (3 variants) with `severity`-driven color, not one fixed visual treatment (§2.3, §3.5).
- [x] Handle `count: null` and the empty-feed state explicitly (§3.6).
- [x] Wire `GET /teacher/today-status/` into Subject Teacher's dashboard (currently Class Teacher only).
- [x] Don't fabricate a room number from `today-status`'s `room_number: null` — confirm this already matches the rest of the app's existing "no room data" pattern.
- [x] Update error handling for `today-status` 403s to the real `{"detail": "..."}` shape, not the stale spec's `error_code` example.
- [x] Once this lands: flag `docs/today_status_api_android.md`'s header and `docs/ai-context/FEATURE_STATUS.md` / `IMPLEMENTATION_STATUS.md` for a doc-status update (backend can do this pass, or frontend can PR it — either way, don't leave them saying `PLANNED`/`BACKEND_ONLY` once it's live and correct).

Backend will not re-verify or sign off on either endpoint being "integrated" until the checklist above is complete — a dashboard that calls the feed and renders nothing isn't integration, it's the bug this doc opened with.
