# ONPS School ERP — Role & Permission Matrix (`ROLE_PERMISSIONS.md`)

> **Authorization Source**: Derived from `AuthState` in `lib/data/mock_data.dart`, navigation route guards, and bottom navigation configurations.

---

## 1. Persona Access Capability Matrix

| Capability / Operational Desk | Student | Parent | Subject Teacher | Class Teacher | Principal | Vice Principal | Accountant | Librarian | Super Admin |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **View Own Dashboard** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **View Student Profile File** | Self | Child | Read-Only | Read-Only | Full | Full | Read-Only | Read-Only | Full |
| **View Report Cards** | Self | Child | Assigned | Homeroom | Full | Full | ❌ | ❌ | Full |
| **Submit Marks Entry** | ❌ | ❌ | Assigned | Homeroom | Audit | Audit | ❌ | ❌ | Full |
| **Mark Daily Roll Call** | ❌ | ❌ | ❌ | Homeroom | Audit | Audit | ❌ | ❌ | Full |
| **Apply / Review Student Leave** | Self | Child | ❌ | Approve | Audit | Audit | ❌ | ❌ | Full |
| **View Fee Ledger & Receipts** | Self | Child | ❌ | ❌ | Audit | Audit | Full | ❌ | Full |
| **Issue / Collect Books** | ❌ | ❌ | ❌ | ❌ | Audit | Audit | ❌ | Full | Full |
| **Manage Inventory & Supplies** | ❌ | ❌ | ❌ | ❌ | Audit | Audit | ❌ | ❌ | Full |
| **Draft Notices & Circulars** | ❌ | ❌ | Draft | Draft | Author | Author | ❌ | ❌ | Full |
| **Approve Circular Queue** | ❌ | ❌ | ❌ | ❌ | Approve | Approve | ❌ | ❌ | Full |
| **Manage Teacher Roster (CRUD)**| ❌ | ❌ | ❌ | ❌ | Full | Full | ❌ | ❌ | Full |
| **Universal Role Switcher** | Demo | Demo | Demo | Demo | Full | Full | Demo | Demo | Full |

---

## 2. Detailed Role Authorization Rules

### 2.1 Student Persona
- Restricted strictly to self-data (`student_id` matching active auth state).
- Read-only access to report cards, fee ledger, timetable, notices, digital ID, and bus route.
- Cannot view other students' records or access administrative/teacher tools.

### 2.2 Parent Persona
- Context bounded by `wardIds`. Switches view between assigned children.
- Full access to apply for student leave, view report cards, download fee receipts, and track child's bus transit.

### 2.3 Subject Teacher Persona
- Authorized to enter, edit, and submit marks for assigned `ClassSubject` combinations.
- Access to teaching timetable and subject student directories.
- Cannot mark morning roll call or approve student leave applications unless holding a Class Teacher assignment.

### 2.4 Class Teacher Persona
- Full operational control over assigned homeroom section (`5-A`).
- Authorized to perform daily morning roll call (P/A/L/E), approve student leave requests, review homeroom report cards, and inspect homeroom student files.

### 2.5 Principal & Vice Principal Persona
- Strategic and executive access across all 13 grades and 61 sections.
- Authorized to add/edit/delete faculty, approve draft circulars in the moderation queue, inspect all student files, review section allocations, and oversee admissions.
