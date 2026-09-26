# ONPS School ERP — Known Issues & Route Exceptions (`KNOWN_ISSUES.md`)

> **Bug & Defect Tracking**: Non-duplicating repository of active route exceptions, visual clipping issues, and navigation dead ends.

---

## 1. Route Exceptions (Missing Routes / GO EXCEPTIONS)

### Issue ISSUE-NAV-01: Missing `/notices` Route
- **Severity**: Medium
- **Affected Role**: Parent
- **Affected Screen**: Parent Dashboard (`ParentDashboardScreen`)
- **Problem**: Action chip links to `/notices`, but router previously defined only `/announcements`.
- **Resolution**: Route alias `GoRoute(path: '/notices', redirect: (_, __) => '/announcements')` added in `lib/router.dart`.
- **Status**: **FIXED**

---

### Issue ISSUE-NAV-02: Missing `/students/digital-id` Route
- **Severity**: Medium
- **Affected Role**: Student, Parent
- **Affected Screen**: Student Hub (`StudentHubScreen`)
- **Problem**: Card button links to `/students/digital-id`, but router registered `/students/id-card`.
- **Resolution**: Route alias `GoRoute(path: '/students/digital-id', redirect: (_, __) => '/students/id-card')` added in `lib/router.dart`.
- **Status**: **FIXED**

---

### Issue ISSUE-NAV-03: Missing `/attendance/student-leave` Route
- **Severity**: Medium
- **Affected Role**: Parent, Student
- **Affected Screen**: Parent Dashboard
- **Problem**: Leave application button points to unregistered route `/attendance/student-leave`.
- **Resolution**: Route `/attendance/student-leave` registered to `FacultyLeaveScreen` in `lib/router.dart`.
- **Status**: **FIXED**

---

### Issue ISSUE-NAV-04: Missing `/principal/announcements/approval` Route
- **Severity**: Medium
- **Affected Role**: Principal
- **Affected Screen**: Principal Dashboard (`PrincipalDashboardScreen`)
- **Problem**: Moderation card links to `/principal/announcements/approval`, but canonical route is `/principal/moderation`.
- **Resolution**: Route alias `/principal/announcements/approval` added in `lib/router.dart`.
- **Status**: **FIXED**

---

## 2. Navigation Dead Ends & Misdirections

### Issue ISSUE-DEAD-01: Fee Payment Gateway Self-Loop
- **Severity**: Low
- **Affected Role**: Student, Parent
- **Affected Screen**: Fee Ledger Screen (`/fees/ledger`)
- **Problem**: Tapping "Pay Fee Now" redirects to `/fees/ledger` (self-loop).
- **Status**: **FIXED** (Zero fake live payment transactions rule enforced; Read-Only Fee Ledger verified).

---

### Issue ISSUE-DEAD-02: Library Desk Misdirection for Students & Bus Track Misdirection for Parents
- **Severity**: Low
- **Affected Roles**: Student, Parent
- **Affected Screens**: Student Hub (`StudentHubScreen`), Parent Dashboard (`ParentDashboardScreen`)
- **Problem**:
  1. Student Hub "Books on Loan" KPI card navigated to `/library/desk` (Librarian Circulation Desk).
  2. Parent Dashboard "Bus Track" action chip navigated to `/library/desk`.
- **Resolution**:
  1. Student Hub "Books on Loan" opens a dedicated modal bottom sheet displaying active loans and overdue count, keeping students out of the staff circulation desk.
  2. Parent Dashboard "Bus Track" navigates to `/transit/bus` (`BusTransitScreen`).
- **Status**: **FIXED**

---

## 3. Physical Device QA Findings Remediation (B1–B6)

| Bug ID | Description | Severity | Area | Status |
|:-------|:------------|:---------|:-----|:-------|
| **B1** | Fee Receipt back navigation `GoException: /dashboard/accounts` | High | Flutter | **FIXED** |
| **B2** | Parent Attendance missing `student_id` parameter (HTTP 400) | High | Flutter | **FIXED** |
| **B3** | Parent child selector showing hardcoded "Diya/Aarav Sharma" | Medium | Flutter | **FIXED** |
| **B4** | Fee Ledger calling non-existent `/api/v1/fees/student/` (HTTP 404) | Medium | Flutter | **FIXED** |
| **B5** | Student Digital ID self-call passing fallback `'1'` causing 403 IDOR | Low | Flutter / Backend | **FIXED (Client)** |
| **B6** | Stale JWT token sent during login causing 401 rejection | Low | Flutter | **FIXED** |
