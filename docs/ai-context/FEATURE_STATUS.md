# ONPS School ERP — Feature Status Ledger (`FEATURE_STATUS.md`)

> **Canonical Status Codes**:
> - `IMPLEMENTED`: Fully functional with mock repository / SQLite data.
> - `PARTIALLY_IMPLEMENTED`: UI built and wired to models; missing native export or API endpoint.
> - `UI_ONLY`: Interface exists; logic pending implementation.
> - `BACKEND_ONLY`: Model/schema ready; UI screen pending.
> - `PLANNED`: Documented in roadmap; not yet built.
> - `NOT_IMPLEMENTED`: Excluded from current release scope.
> - `BLOCKED`: Waiting on external dependency or hardware feature.
> - `UNKNOWN`: Requires verification against codebase.

---

## 1. Domain Feature Status Matrix

| Feature Domain | Feature Name | Status | Current Reality / Implementation Detail |
| :--- | :--- | :--- | :--- |
| **Authentication** | Secure Login Gateway | `IMPLEMENTED` | Role chooser & credential submission (`/login`). |
| **Authentication** | 2FA OTP & Device Eviction | `IMPLEMENTED` | OTP verification modal & session revocation (`/auth/otp-eviction`). |
| **Authentication** | Password Reset | `IMPLEMENTED` | Mobile/email recovery flow (`/auth/password-reset`). |
| **Student Hub** | Student 360 Dossier | `IMPLEMENTED` | 7-tab profile view (`/students/dossier`). |
| **Student Hub** | Digital Student ID Card | `IMPLEMENTED` | Animated holographic crest & QR gate code (`/students/id-card`). |
| **Academics** | CBSE 4-Term Report Card | `IMPLEMENTED` | Scholastic & co-scholastic grades (`/students/report-card`). |
| **Academics** | Faculty Marks Entry Desk | `IMPLEMENTED` | Subject score validation & sign-off (`/academics/marks-entry`). |
| **Academics** | Principal Academics Hub | `IMPLEMENTED` | 13-grade K-12 section matrix (`/faculty/allocation`). |
| **Attendance** | Daily Morning Roll Call | `IMPLEMENTED` | 4-state register (`P`/`A`/`L`/`E`) (`/attendance/roll-call`). |
| **Attendance** | Monthly Attendance Matrix| `IMPLEMENTED` | High-density calendar grid (`/attendance/student`). |
| **Attendance** | Faculty Leave Tracker | `IMPLEMENTED` | Leave submission & principal sign-off (`/attendance/faculty-leave`). |
| **Fees & Finance** | Fee Ledger & Dues | `IMPLEMENTED` | Read-only itemized term dues (`/fees/ledger`). |
| **Fees & Finance** | Official Fee Receipt | `IMPLEMENTED` | Signed receipt voucher view (`/fees/receipt`). |
| **Fees & Finance** | Online Payment Gateway | `NOT_IMPLEMENTED` | Intentionally excluded (Read-only dues policy). |
| **Transit** | Bus Route & Stop Timeline | `IMPLEMENTED` | Route sequence, driver details, stop times (`/transit/bus`). |
| **Transit** | Live WebSocket GPS Stream | `PLANNED` | Static route timeline active; live GPS pending API. |
| **Inventory** | Supplies & Low Stock Desk | `IMPLEMENTED` | Item catalog, reorder threshold alerts (`/inventory/desk`). |
| **Help & FAQs** | Offline FAQ Knowledge Base | `IMPLEMENTED` | Pre-seeded SQLite `onps_erp.db` query engine (`/help/faqs`). |
| **Announcements** | Moderated Notice Board | `IMPLEMENTED` | Circular listing & category filtering (`/announcements`). |
| **Announcements** | Compose Circular Form | `IMPLEMENTED` | Target persona selector & drafting (`/announcements/compose`). |
| **Announcements** | Principal Moderation Queue| `IMPLEMENTED` | Approval / rejection workflow (`/principal/moderation`). |
| **Calendar** | Gazetted Holidays Calendar | `IMPLEMENTED` | National & institutional holiday listing (`/calendar/holidays`). |
| **Faculty Mgmt** | Principal Teachers Desk | `IMPLEMENTED` | Faculty CRUD & assignment validation (`/principal/teachers`). |
| **Dashboards** | Needs Attention Feed (`/attention/`) | `BACKEND_ONLY` | Shipped on backend (`docs/attention_api_android.md`); mobile client integration pending. |
| **Dashboards** | Teacher Today Status (`/teacher/today-status/`) | `PLANNED` | Proposed Android API spec (`docs/today_status_api_android.md`) for day/time/attendance truth. |
| **Export Engine** | Native PDF Receipt Export | `PARTIALLY_IMPLEMENTED`| UI trigger active; `pdf` package wiring pending. |
| **Academics** | Student Homework Desk | `PLANNED` | Excluded from current UI to avoid fake workflows. |

