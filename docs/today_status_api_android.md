# Teacher "Today" status — Android API spec (IMPLEMENTED)

**Status: Live in production backend and integrated in Flutter/Android client.**
Endpoint: `GET /api/v1/teacher/today-status/`
Client Integration: Screen 14 (Class Teacher Dashboard) and Screen 15 (Subject Teacher Dashboard).
Full backend and client contract verified per `docs/BACKEND_HANDOFF_DASHBOARD_APIS_2026-10-01.md`.

## 0. Why this endpoint

Today, "is school open," "what period is running now," and "has this
class's attendance been marked" are each either missing entirely or
computed client-side from data that has no date/holiday awareness:

- `apps/school_calendar` has models (`Holiday`, `Event`) but **no REST
  API at all** — only Django server-rendered views.
- `apps/timetable`'s `teacher_timetable`/`class_timetable`/`timetable`
  endpoints return a pure **weekly template** keyed by `day_of_week`
  (int) — no `date` field, no holiday cross-reference. A holiday that
  falls on a Monday still returns Monday's periods.
- `apps/reports.api_views.class_teacher_summary` (the endpoint behind
  `/teacher/class-dashboard/`) sets `roll_call_status` to `'PENDING'`
  purely from whether `StudentAttendance` rows exist for
  `(class_section, today)` — it never checks whether today is even a
  teaching day, so a Sunday shows "Attendance Not Marked" same as a
  real pending Monday.

This endpoint consolidates all three checks into one call so the
Android "today" dashboard section doesn't have to reconstruct any of
this client-side (see `.agents/rules/12-android-client-contract.md`
rule 8: never trust/derive business truth on the client).

## 1. Endpoint

```
GET /api/v1/teacher/today-status/
```

- **Auth:** `Authorization: Bearer <JWT access token>`, same as every
  other endpoint under `/api/v1/`.
- **Query params:** none. The teacher is resolved from
  `request.user` via `apps.teachers.selectors.teacher_for_user`, same
  pattern as `teacher_timetable` (`apps/timetable/api_views.py:118`).
- **Role scope:** works for both Class Teacher and Subject Teacher —
  see `attendance` field semantics below. Not intended for
  Student/Parent/Principal callers (a Principal without a Teacher
  profile gets `TEACHER_PROFILE_NOT_FOUND`, matching existing
  `teacher_timetable` behavior at `apps/timetable/api_views.py:119-123`
  which falls back to `Teacher.objects.first()` for principal/staff —
  **decide during implementation whether that fallback is appropriate
  here too, or whether this endpoint should 404 cleanly instead**).

## 2. Response envelope

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

## 3. Field reference

| Field | Type | Meaning |
|---|---|---|
| `date` | string (`YYYY-MM-DD`) | Server's current date, for the client to display/compare against. |
| `is_teaching_day` | bool | Whether school is in session today, for this teacher's scope. Source: new shared selector, see §6. |
| `day_type` | enum | `WORKING` \| `WEEKLY_OFF` \| `HOLIDAY`. |
| `reason` | string \| null | Human-readable explanation. `null` on a plain `WORKING` day; populated for `WEEKLY_OFF`/`HOLIDAY`, and also for a notable `WORKING` day (e.g. a declared compensatory working day that would otherwise look like a weekly-off day — see scenario 7). |
| `current_period` | object \| null | Same shape as `next_period`. `null` if no period is running right now. |
| `next_period` | object \| null | `{period_number, subject_name, class_name, room_number, start_time, end_time}` — same field names as the existing `teacher_timetable` schedule items (`apps/timetable/api_views.py:149-161`) for client-side reuse. `null` if none remain today. |
| `attendance` | object \| null | **`null` entirely if this teacher has no homeroom class** (pure Subject Teacher) — presence of this key is what tells Android whether to show the "Take Attendance" card at all; do not derive that from role name client-side. |
| `attendance.class_id` / `class_name` | string | The teacher's homeroom class. |
| `attendance.status` | enum | `NOT_MARKED` \| `PARTIAL` \| `MARKED` \| `NOT_APPLICABLE` (`NOT_APPLICABLE` when `is_teaching_day` is false). |
| `attendance.marked_count` / `total_students` | int | Only present when `status == "PARTIAL"`. |
| `attendance.can_take_attendance` | bool | Whether the action is allowed at all — `false` only when `is_teaching_day` is false. **Re-marking on an already-`MARKED` day is intentionally still `true`** — `apps.attendance.services.mark_class_attendance` already does an upsert for teacher corrections (`apps/attendance/services.py:39-40`), so this endpoint must not contradict that by locking the action once marked. |

## 4. Scenarios

### 4.1 Holiday (weekly-off), Class Teacher
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
    "attendance": {
      "class_id": "CLS-12",
      "class_name": "Grade Nursery B",
      "status": "NOT_APPLICABLE",
      "can_take_attendance": false
    }
  }
}
```

### 4.2 Holiday, Subject Teacher (no homeroom)
```json
{
  "success": true,
  "data": {
    "date": "2026-09-27",
    "is_teaching_day": false,
    "day_type": "HOLIDAY",
    "reason": "Gazetted Holiday — Gandhi Jayanti",
    "current_period": null,
    "next_period": null,
    "attendance": null
  }
}
```

### 4.3 Working day, before first period
```json
{
  "success": true,
  "data": {
    "date": "2026-09-29",
    "is_teaching_day": true,
    "day_type": "WORKING",
    "reason": null,
    "current_period": null,
    "next_period": {
      "period_number": 1,
      "subject_name": "English",
      "class_name": "Grade 2 F",
      "room_number": "Room 429",
      "start_time": "09:00 AM",
      "end_time": "09:40 AM"
    },
    "attendance": {
      "class_id": "CLS-12",
      "class_name": "Grade Nursery B",
      "status": "NOT_MARKED",
      "can_take_attendance": true
    }
  }
}
```

### 4.4 Working day, currently inside a period
```json
{
  "success": true,
  "data": {
    "date": "2026-09-29",
    "is_teaching_day": true,
    "day_type": "WORKING",
    "reason": null,
    "current_period": {
      "period_number": 1,
      "subject_name": "English",
      "class_name": "Grade 2 F",
      "room_number": "Room 429",
      "start_time": "09:00 AM",
      "end_time": "09:40 AM"
    },
    "next_period": {
      "period_number": 2,
      "subject_name": "Mathematics",
      "class_name": "Grade 2 F",
      "room_number": "Room 429",
      "start_time": "09:45 AM",
      "end_time": "10:25 AM"
    },
    "attendance": {
      "class_id": "CLS-12",
      "class_name": "Grade Nursery B",
      "status": "MARKED",
      "can_take_attendance": true
    }
  }
}
```

### 4.5 Working day, day's teaching over
```json
{
  "success": true,
  "data": {
    "date": "2026-09-29",
    "is_teaching_day": true,
    "day_type": "WORKING",
    "reason": null,
    "current_period": null,
    "next_period": null,
    "attendance": {
      "class_id": "CLS-12",
      "class_name": "Grade Nursery B",
      "status": "MARKED",
      "can_take_attendance": true
    }
  }
}
```

### 4.6 Attendance partially marked
```json
{
  "attendance": {
    "class_id": "CLS-12",
    "class_name": "Grade Nursery B",
    "status": "PARTIAL",
    "marked_count": 32,
    "total_students": 40,
    "can_take_attendance": true
  }
}
```

### 4.7 Compensatory working day (declared working Sunday)
```json
{
  "success": true,
  "data": {
    "date": "2026-10-04",
    "is_teaching_day": true,
    "day_type": "WORKING",
    "reason": "Compensatory working day (in lieu of Oct 2 holiday)",
    "current_period": null,
    "next_period": { "...": "same shape as §4.3" },
    "attendance": { "...": "same shape as §4.3" }
  }
}
```

### 4.8 Teaching day, but this teacher has no periods today (personal light day, not a school holiday)
```json
{
  "success": true,
  "data": {
    "date": "2026-09-29",
    "is_teaching_day": true,
    "day_type": "WORKING",
    "reason": null,
    "current_period": null,
    "next_period": null,
    "attendance": {
      "class_id": "CLS-12",
      "class_name": "Grade Nursery B",
      "status": "NOT_MARKED",
      "can_take_attendance": true
    }
  }
}
```
Note: identically shaped to §4.5 by design — Flutter must distinguish
"day over" from "holiday" using `is_teaching_day`/`day_type`, never by
inferring it from `current_period`/`next_period` both being null.

### 4.9 Error — no teacher profile
```json
{
  "success": false,
  "status": "error",
  "message": "No teacher profile found for this account.",
  "error_code": "TEACHER_PROFILE_NOT_FOUND"
}
```
Matches the standard error envelope in
`.agents/rules/12-android-client-contract.md` §3, routed through
`apps.api.exceptions.telemetry_exception_handler`.

## 5. Open policy decisions for implementation

1. **Holiday scoping is whole-school only today.** `Holiday`
   (`apps/school_calendar/models.py:27-66`) has no class/section field.
   If a per-class exception (e.g. one class on a field trip while the
   rest of school is in session, or vice versa) needs to affect
   `is_teaching_day`/`attendance` for that specific class, `Holiday`
   needs a scoping field first (see `Event`'s existing
   `AudienceMixin` pattern for a precedent) — that's a migration, not
   just this endpoint.
2. **Should `submit_roll_call` itself reject writes on a non-teaching
   day**, or is surfacing `can_take_attendance: false` here enough to
   just hide the button client-side while leaving the write endpoint
   permissive (e.g. for a genuine makeup class held on a holiday)?
   Recommend defaulting to permissive (UI-level gating only) unless
   there's a specific reason to hard-block server-side.
3. **Principal/staff fallback**: decide whether this endpoint should
   mirror `teacher_timetable`'s `Teacher.objects.first()` fallback for
   principal/staff callers with no Teacher profile of their own, or
   return `TEACHER_PROFILE_NOT_FOUND` cleanly instead (§1).

## 6. Suggested internal composition (avoid duplicating logic)

Per `.agents/rules/02-django-architecture.md`, this view should
compose existing/new selectors rather than reimplement:

- **New**: `apps.school_calendar.selectors.day_status(date, class_section=None)`
  → `(is_teaching_day, day_type, reason)`. Used by this endpoint AND
  should be retrofitted into `teacher_timetable`/`class_timetable`
  and `class_teacher_summary` so all three stop disagreeing with each
  other (see `.agents/rules/01-database.md` count-consistency
  principle).
- **Existing**: `apps.attendance.selectors.attendance_for_class_on_date`
  (`apps/attendance/selectors.py:19-22`) for the `attendance` block.
- **Existing**: `apps.timetable.selectors.list_timetable_slots` for
  today's schedule, filtered/compared against real wall-clock time to
  pick `current_period`/`next_period` (this comparison is new logic —
  today's `_slot_json`/`teacher_timetable` never do it, per §0).
