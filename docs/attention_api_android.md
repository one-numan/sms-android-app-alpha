# Needs Attention feed — Android API reference (2026-09-27)

One endpoint. Every signed-in role gets the same JSON shape back, populated
with a different set of items depending on who's asking. This doc has a
real, captured example response for every role — every JSON block below
was pulled by actually calling `apps.common.attention.attention_items_for`
against real accounts in the dev database, not hand-typed. Three items (a
pending leave request, an upcoming holiday, a low-stock item) don't
currently exist in the dev data, so those three were seeded inside a
database transaction that was rolled back immediately after capturing the
response — the dev database is unchanged; the JSON is real output.

## 1. Endpoint

```
GET /api/v1/attention/
```

- **Auth:** same as every other endpoint under `/api/v1/` —
  `Authorization: Bearer <JWT access token>` (see `docs/jwt_auth_android.md`).
- **Query params:** none.
- **Pagination:** none. `items` is a plain array, unlike the paginated
  `{"count", "next", "previous", "results"}` envelope on list endpoints such
  as `/announcements/` (`apps/api/pagination.py`). Every item here is
  already a cheap count or small aggregate, so there's nothing to page
  through.
- **Cost:** a bounded number of queries regardless of role or school size —
  at most one small aggregate query per relevant domain, and irrelevant
  domains cost nothing (a fee query never runs for a librarian, a library
  query never runs for an accountant). See `apps/common/attention.py` for
  the implementation — role context (which teacher/parent/student/group
  this is, if any) is resolved once per request and threaded through every
  domain check.

## 2. Response envelope

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

`summary` is a count per `domain`, so a badge/notification-dot can show a
total (or break one out per tab, e.g. a red dot on "Fees" specifically)
without the client counting the array or making a second call.

## 3. Item fields

| Field | Type | Meaning |
|---|---|---|
| `id` | string | Stable slug, `"<domain>.<thing>"`. Safe as a list key / for client-side dedup. |
| `domain` | string | Which backend app it came from — `attendance`, `announcements`, `admissions`, `fees`, `library`, `inventory`, `calendar` today. Treat as open-ended, not an enum — more domains will be added later (§8). |
| `type` | string | `actionable_queue` — a real action is waiting (approve/reject); render a CTA. `alert_count` — a condition worth surfacing; tapping it should open the relevant existing list screen, the card itself has no action. `reminder` — informational only, no action needed. |
| `severity` | string | `critical` / `warning` / `info` — drives color, not shown as text. Nothing emits `critical` yet; it's reserved for a future policy-driven threshold (e.g. a low-attendance flag) — don't assume it never appears. |
| `title` | string | Ready-to-render sentence, already pluralized and formatted (currency, counts). Don't rebuild it from `count` client-side. |
| `count` | integer or `null` | Present when the item is fundamentally "a number of things" (a queue length, a book count). `null` for items that aren't a count at all (a single due amount, a named holiday) — don't coerce it to `0`. |
| `action_label` | string or `null` | Button text for an `actionable_queue`/`alert_count` item. `null` for a `reminder` — render no button at all, not a disabled one. |
| `deep_link` | object | `{"screen": "<key>", "params": {}}`. `params` is always `{}` today; reserved for a screen that needs an id (e.g. one specific student). Glossary below. |

## 4. `deep_link.screen` glossary

| `screen` | Domain | Where it should go |
|---|---|---|
| `faculty_leave_review` | attendance | The leave-request review queue (principal/VP action screen). |
| `my_leave_requests` | attendance | The signed-in teacher's own leave request history/status. |
| `moderation_queue` | announcements | The notice/circular approval queue. |
| `admissions_applications` | admissions | The applications list, ideally pre-filtered to Pending. |
| `fee_defaulters` | fees | School-wide defaulters report (accountant/leadership only). |
| `fee_ledger` | fees | The signed-in parent/student's own fee ledger. |
| `library_overdue` | library | School-wide overdue-loans list (librarian/leadership only). |
| `my_library_loans` | library | The signed-in parent/student's own (child's) loans. |
| `inventory_low_stock` | inventory | Inventory filtered to at/below reorder level. |
| `calendar` | calendar | The school calendar / holiday list. |
| `birthdays` | calendar | The birthday list screen. |

New domains will only ever add new keys to this list, never repurpose an
existing one.

## 5. Every role, with a real captured response

### 5.1 Leadership tier — `super_admin` · `school_admin` · `principal` · `vice_principal`

All four resolve to the same underlying check (`is_principal_tier`,
`apps/common/permissions.py`) and get an identical feed — no behavioral
difference between them today. This is the richest role: the school-wide
view of every queue.

Sees: `attendance.leave_requests` · `announcements.moderation_queue` ·
`admissions.pending_applications` · `fees.defaulters` · `library.overdue` ·
`inventory.low_stock` · `calendar.next_holiday` · `calendar.upcoming_birthdays`

Captured for `principal.numan`, with the three currently-empty domains
seeded for illustration (see the note at the top of this doc):

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "attendance.leave_requests", "domain": "attendance",
        "type": "actionable_queue", "severity": "warning",
        "title": "1 leave request awaiting your review", "count": 1,
        "action_label": "Review requests",
        "deep_link": {"screen": "faculty_leave_review"}
      },
      {
        "id": "announcements.moderation_queue", "domain": "announcements",
        "type": "actionable_queue", "severity": "warning",
        "title": "2 notices waiting for approval", "count": 2,
        "action_label": "Review queue",
        "deep_link": {"screen": "moderation_queue"}
      },
      {
        "id": "admissions.pending_applications", "domain": "admissions",
        "type": "actionable_queue", "severity": "warning",
        "title": "90 applications awaiting review", "count": 90,
        "action_label": "View applications",
        "deep_link": {"screen": "admissions_applications"}
      },
      {
        "id": "fees.defaulters", "domain": "fees",
        "type": "alert_count", "severity": "warning",
        "title": "10000 students have pending fees (₹623,312,970 total)", "count": 10000,
        "action_label": "View defaulters",
        "deep_link": {"screen": "fee_defaulters"}
      },
      {
        "id": "library.overdue", "domain": "library",
        "type": "alert_count", "severity": "warning",
        "title": "214 books overdue", "count": 214,
        "action_label": "View overdue loans",
        "deep_link": {"screen": "library_overdue"}
      },
      {
        "id": "inventory.low_stock", "domain": "inventory",
        "type": "alert_count", "severity": "info",
        "title": "1 inventory item at or below reorder level", "count": 1,
        "action_label": "View inventory",
        "deep_link": {"screen": "inventory_low_stock"}
      },
      {
        "id": "calendar.next_holiday", "domain": "calendar",
        "type": "reminder", "severity": "info",
        "title": "Diwali on 2026-10-15", "count": null,
        "action_label": null, "deep_link": {"screen": "calendar"}
      },
      {
        "id": "calendar.upcoming_birthdays", "domain": "calendar",
        "type": "reminder", "severity": "info",
        "title": "194 birthdays this week", "count": 194,
        "action_label": null, "deep_link": {"screen": "birthdays"}
      }
    ],
    "summary": {
      "attendance": 1, "announcements": 1, "admissions": 1,
      "fees": 1, "library": 1, "inventory": 1, "calendar": 2
    },
    "total_count": 8
  }
}
```

The 10,000-defaulter / ₹623M figure is real dev-seed scale (a much larger
synthetic dataset than one school), kept as-is deliberately — it's a good
stress case for number formatting (large counts, comma-grouped currency,
title-string wrapping at small screen widths).

### 5.2 Accountant

Sees: `fees.defaulters` only. Nothing outside `fees` ever reaches this
role — an accountant with no linked teacher/parent/student profile touches
exactly one domain's query.

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "fees.defaulters", "domain": "fees",
        "type": "alert_count", "severity": "warning",
        "title": "10000 students have pending fees (₹623,312,970 total)", "count": 10000,
        "action_label": "View defaulters",
        "deep_link": {"screen": "fee_defaulters"}
      }
    ],
    "summary": {"fees": 1},
    "total_count": 1
  }
}
```

### 5.3 Librarian

Sees: `library.overdue` only.

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "library.overdue", "domain": "library",
        "type": "alert_count", "severity": "warning",
        "title": "214 books overdue", "count": 214,
        "action_label": "View overdue loans",
        "deep_link": {"screen": "library_overdue"}
      }
    ],
    "summary": {"library": 1},
    "total_count": 1
  }
}
```

### 5.4 Receptionist

Sees: `admissions.pending_applications` only.

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "admissions.pending_applications", "domain": "admissions",
        "type": "actionable_queue", "severity": "warning",
        "title": "90 applications awaiting review", "count": 90,
        "action_label": "View applications",
        "deep_link": {"screen": "admissions_applications"}
      }
    ],
    "summary": {"admissions": 1},
    "total_count": 1
  }
}
```

### 5.5 Teacher (class teacher or subject teacher)

Both resolve identically today — a class teacher gets nothing extra over a
subject teacher in this feed yet. (That's a real gap the backlog covers:
their own class's roll-call status and marks-entry progress aren't wired
into this feed yet — see §8.)

Sees: `attendance.my_leave_requests` · `calendar.upcoming_birthdays`

**Case A — no pending leave request** (real, captured as-is, no seeding):

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "calendar.upcoming_birthdays", "domain": "calendar",
        "type": "reminder", "severity": "info",
        "title": "8 birthdays this week", "count": 8,
        "action_label": null, "deep_link": {"screen": "birthdays"}
      }
    ],
    "summary": {"calendar": 1},
    "total_count": 1
  }
}
```

**Case B — one pending leave request** (leave + holiday seeded for
illustration, then rolled back):

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "attendance.my_leave_requests", "domain": "attendance",
        "type": "reminder", "severity": "info",
        "title": "1 of your leave request still pending approval", "count": 1,
        "action_label": null, "deep_link": {"screen": "my_leave_requests"}
      },
      {
        "id": "calendar.next_holiday", "domain": "calendar",
        "type": "reminder", "severity": "info",
        "title": "Diwali on 2026-10-15", "count": null,
        "action_label": null, "deep_link": {"screen": "calendar"}
      },
      {
        "id": "calendar.upcoming_birthdays", "domain": "calendar",
        "type": "reminder", "severity": "info",
        "title": "8 birthdays this week", "count": 8,
        "action_label": null, "deep_link": {"screen": "birthdays"}
      }
    ],
    "summary": {"attendance": 1, "calendar": 2},
    "total_count": 3
  }
}
```

### 5.6 Parent

Sees: `fees.my_dues` (any child) · `library.my_overdue` (any child)

**Case A — dues only** (real, one child, no overdue books):

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "fees.my_dues", "domain": "fees",
        "type": "alert_count", "severity": "warning",
        "title": "₹48,839 in fees is due", "count": null,
        "action_label": "View fee ledger", "deep_link": {"screen": "fee_ledger"}
      }
    ],
    "summary": {"fees": 1},
    "total_count": 1
  }
}
```

**Case B — dues and an overdue book together** (real, unmodified — found by
tracing an actual overdue loan back to its parent account):

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "fees.my_dues", "domain": "fees",
        "type": "alert_count", "severity": "warning",
        "title": "₹67,976 in fees is due", "count": null,
        "action_label": "View fee ledger", "deep_link": {"screen": "fee_ledger"}
      },
      {
        "id": "library.my_overdue", "domain": "library",
        "type": "alert_count", "severity": "warning",
        "title": "1 book overdue", "count": 1,
        "action_label": "View my loans", "deep_link": {"screen": "my_library_loans"}
      }
    ],
    "summary": {"fees": 1, "library": 1},
    "total_count": 2
  }
}
```

A parent with multiple children who owe fees or have overdue books still
gets exactly **one** `fees.my_dues` item (dues summed across every child)
and **one** `library.my_overdue` item (overdue count summed across every
child) — never one row per child. Don't expect a variable-length list
here; these two ids are always at most one each.

### 5.7 Student

Sees: `fees.my_dues` (self) · `library.my_overdue` (self)

Identical shape to a parent's, scoped to the student's own record instead
of "every child." Real example — the same student whose overdue loan
appears in the parent case above, viewed from their own login:

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "fees.my_dues", "domain": "fees",
        "type": "alert_count", "severity": "warning",
        "title": "₹67,976 in fees is due", "count": null,
        "action_label": "View fee ledger", "deep_link": {"screen": "fee_ledger"}
      },
      {
        "id": "library.my_overdue", "domain": "library",
        "type": "alert_count", "severity": "warning",
        "title": "1 book overdue", "count": 1,
        "action_label": "View my loans", "deep_link": {"screen": "my_library_loans"}
      }
    ],
    "summary": {"fees": 1, "library": 1},
    "total_count": 2
  }
}
```

## 6. When there's nothing to show

This is the single most common response for a parent/student/teacher with
a clean record — plan the UI for it as a first-class state, not a loading
placeholder:

```json
{
  "success": true,
  "data": {
    "items": [],
    "summary": {},
    "total_count": 0
  }
}
```

Captured for real — a freshly created account with no leave requests, no
fee/library link, and no upcoming holiday in the calendar at the time.
Render a genuine empty state ("You're all caught up") rather than hiding
the card entirely, so the user has confirmation the check actually ran.

**One domain is never role-gated:** `calendar.next_holiday` is a
whole-school fact (the next holiday applies to literally everyone), so it
can appear for any authenticated user, including one with no
teacher/parent/student/staff profile at all — it isn't evidence of a bug
if it shows up somewhere unexpected. Every other domain is gated by role as
documented above.

## 7. Errors

| Status | Body | When |
|---|---|---|
| `401` | `{"detail": "Authentication credentials were not provided."}` | Missing or expired token — same shape as every other endpoint under `/api/v1/`, handle it exactly where you already handle a 401 from any other call. |

There is no role-based `403` here — every authenticated user gets *a*
response, just possibly an empty one. A `403` would mean something else
broke upstream (bad token audience, disabled account), not "this role
doesn't have an attention feed."

## 8. Build guidance for Android

1. **Render generically off `type`, never off `id` or `domain`.** Three
   renderers — one per `type` — cover every item that exists today and
   every one the backend backlog adds later (attendance thresholds,
   timetable conflicts, transport alerts, document-expiry warnings). A
   `switch(domain)` means an app update every time a new signal ships; a
   `switch(type)` doesn't.
2. **Treat `count: null` as "not a count," not as zero.** A currency-due
   item and a named-holiday item are real, present items with no
   meaningful count — don't filter them out or render "0".
3. **`summary` is for badges, `items` is for the list.** Don't re-derive
   one from the other; both are already computed server-side.
4. **Sort order is already decided.** The array arrives severity-ordered
   (critical, then warning, then info) — don't re-sort client-side unless
   you're deliberately grouping by domain instead.

## 9. Backend pointers (for cross-reference, not needed to integrate)

- Aggregation logic: `apps/common/attention.py` — `attention_items_for(user)`
  resolves role context once, then runs one small provider function per
  domain (`_leave_requests`, `_moderation_queue`, `_admissions_pending`,
  `_fee_defaulters`, `_library_overdue`, `_low_stock`,
  `_upcoming_reminders`), each self-gating on role before touching the
  database.
- View + routing: `apps/common/api_views.py` (`attention_feed`), wired at
  `attention/` in `apps/api/urls.py`.
- The one perf-sensitive piece: `apps/fees/selectors.py::dues_summary()` —
  a `values_list`-based count+total aggregate added specifically so the
  school-wide fee-defaulters check doesn't instantiate a `Student`/`Class`
  row per enrolment (the existing `students_with_dues()` selector does,
  for its own good reason — it needs the actual rows for the defaulters
  *report* page — but the attention feed only needs the headline numbers).

All response bodies in this document were captured live against the dev
database on 2026-09-27; three items were seeded inside a transaction that
was rolled back immediately after capture and left no lasting change.
