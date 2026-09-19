# ONPS School ERP — Known Issues & Route Exceptions (`KNOWN_ISSUES.md`)

> **Bug & Defect Tracking**: Non-duplicating repository of active route exceptions, visual clipping issues, and navigation dead ends.

---

## 1. Route Exceptions (Missing Routes / GO EXCEPTIONS)

### Issue ISSUE-NAV-01: Missing `/notices` Route
- **Severity**: Medium
- **Affected Role**: Parent
- **Affected Screen**: Parent Dashboard (`ParentDashboardScreen`)
- **Problem**: Action chip links to `/notices`, but router only defines `/announcements`. Triggers GoRouter exception.
- **Recommended Resolution**: Add route alias `GoRoute(path: '/notices', redirect: (_, __) => '/announcements')` in `lib/router.dart`.
- **Status**: Identified (Fix Pending)

---

### Issue ISSUE-NAV-02: Missing `/students/digital-id` Route
- **Severity**: Medium
- **Affected Role**: Student, Parent
- **Affected Screen**: Student Hub (`StudentHubScreen`)
- **Problem**: Card button links to `/students/digital-id`, but router registers `/students/id-card`.
- **Recommended Resolution**: Add route alias `GoRoute(path: '/students/digital-id', redirect: (_, __) => '/students/id-card')`.
- **Status**: Identified (Fix Pending)

---

### Issue ISSUE-NAV-03: Missing `/attendance/student-leave` Route
- **Severity**: Medium
- **Affected Role**: Parent, Student
- **Affected Screen**: Parent Dashboard
- **Problem**: Leave application button points to unregistered route `/attendance/student-leave`.
- **Recommended Resolution**: Wire route to Leave Application sheet or screen in `lib/router.dart`.
- **Status**: Identified (Fix Pending)

---

### Issue ISSUE-NAV-04: Missing `/principal/announcements/approval` Route
- **Severity**: Medium
- **Affected Role**: Principal
- **Affected Screen**: Principal Dashboard (`PrincipalDashboardScreen`)
- **Problem**: Moderation card links to `/principal/announcements/approval`, but canonical route is `/principal/moderation`.
- **Recommended Resolution**: Add route alias in `lib/router.dart`.
- **Status**: Identified (Fix Pending)

---

## 2. Navigation Dead Ends & Misdirections

### Issue ISSUE-DEAD-01: Fee Payment Gateway Self-Loop
- **Severity**: Low
- **Affected Role**: Student, Parent
- **Affected Screen**: Fee Ledger Screen (`/fees/ledger`)
- **Problem**: Tapping "Pay Fee Now" redirects to `/fees/ledger` (self-loop).
- **Recommended Resolution**: Open receipt voucher (`/fees/receipt`) or clear dues modal sheet.
- **Status**: Identified (Fix Pending)

---

### Issue ISSUE-DEAD-02: Library Desk Misdirection for Students
- **Severity**: Low
- **Affected Role**: Student
- **Affected Screen**: Student Hub Screen (`/dashboard/student`)
- **Problem**: Tapping "Library Desk" redirects to `/dashboard/library` (Librarian Circulation Desk).
- **Recommended Resolution**: Show student book search modal or student library loans sheet instead of librarian desk.
- **Status**: Identified (Fix Pending)

---

## 3. Physical Device Layout & Performance Observations

### Issue ISSUE-UI-01: RenderFlex Overflow in Parent Dashboard (Row 322)
- **Severity**: Medium
- **Affected Screen**: `lib/screens/dashboards/parent_dashboard_screen.dart`
- **Problem**: Row content exceeds available width by 0.18px to 27px depending on viewport.
- **Recommended Resolution**: Wrap title text in `Expanded` or `Flexible` with `TextOverflow.ellipsis`.
- **Status**: Identified (Fix Pending)

---

### Issue ISSUE-UI-02: Inventory Item Title Truncation
- **Severity**: Low
- **Affected Screen**: `lib/screens/inventory/inventory_desk_screen.dart`
- **Problem**: Title text clipped into `"A4 Pri..."` on narrow screens due to horizontal stepper buttons sharing space.
- **Recommended Resolution**: Relocate steppers to bottom metadata row.
- **Status**: Identified (Fix Pending)
