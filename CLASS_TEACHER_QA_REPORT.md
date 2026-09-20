# CLASS TEACHER QA REPORT

## 1. Account Under Test
- **Primary Class Teacher Account (Teacher A):**
  - **Username:** `washingtonsundar`
  - **Role:** `class_teacher`
  - **Teacher Identity:** Washington Sundar
  - **Teacher ID:** `TCH-WASHINGTONSUNDAR`
  - **Assigned Class:** `Nursery A`
  - **Section:** `A`
  - **Academic Session:** `2025-2026`
  - **Class Strength:** 40 Students
  - **Attendance Roll Call Status:** `PENDING`

- **Secondary Class Teacher Account (Teacher B - Isolation Check):**
  - **Username:** `shubmangill`
  - **Role:** `class_teacher`
  - **Teacher Identity:** Shubman Gill
  - **Teacher ID:** `TCH-SHUBMANGILL`
  - **Assigned Class:** `Nursery B`
  - **Section:** `B`
  - **Academic Session:** `2025-2026`
  - **Class Strength:** 40 Students

---

## 2. Authentication
- **Production Gateway:** `https://alpha.onenuman.com/api/v1`
- **Login Request:** `POST /api/v1/auth/login/`
  - Payload: `{"username": "washingtonsundar", "password": "teacher12345"}`
  - HTTP Status: `200 OK`
- **Token Resolution:** Bearer JWT retrieved and attached to subsequent API calls.
- **Identity Resolution:** Resolved directly via `GET /api/v1/teacher/class-dashboard/` with Authorization Bearer header.
- **Mock Identity Usage:** `FALSE` — zero fallback mock personas were injected into the state machine.
- **Dashboard Binding:** Verified dashboard dynamically loads `Washington Sundar` and `Nursery A`.

---

## 3. Dashboard
| Dashboard Field | UI Value | API / Source Lineage | Classification |
|---|---|---|---|
| Teacher Name | Washington Sundar | `GET /api/v1/teacher/class-dashboard/` -> `teacher.name` | `LIVE_API` |
| Teacher ID | TCH-WASHINGTONSUNDAR | `GET /api/v1/teacher/class-dashboard/` -> `teacher.id` | `LIVE_API` |
| Assigned Class | Nursery A | `GET /api/v1/teacher/class-dashboard/` -> `assigned_class.name` | `LIVE_API` |
| Section | A | `GET /api/v1/teacher/class-dashboard/` -> `assigned_class.section` | `LIVE_API` |
| Academic Session | 2025-2026 | `GET /api/v1/teacher/class-dashboard/` -> `academic_session` | `LIVE_API` |
| Student Count | 40 | `GET /api/v1/teacher/class-dashboard/` -> `total_students` | `LIVE_API` |
| Attendance Summary | Pending (0/40) | `GET /api/v1/teacher/class-dashboard/` -> `roll_call_status` | `LIVE_API` |
| Timetable | 6 Periods (Nursery A) | `GET /api/v1/teacher/timetable/` | `LIVE_API` |
| Announcements | Term Exam Schedule | `GET /api/v1/notices/` | `LIVE_API` |

---

## 4. Student List
- **Endpoint:** `GET /api/v1/teacher/class-dashboard/` (and `GET /api/v1/classes/nursery-a/students/`)
- **Isolation Scope:** Strictly filtered to `Nursery A`. Zero students from `Nursery B` or `Grade 5-A` appeared.
- **UI Count vs API Count:**
  - UI Displayed: 40 Students
  - API Payload Count: 40 Students (`Nursery A`)
- **Data Attributes Verified:**
  - Student Names: Dynamic from API payload
  - Roll Numbers: Dynamic from API payload
  - Admission Numbers: Dynamic from API payload

---

## 5. Attendance
- **Flow Tested:** Class Teacher Daily Roll Call Register.
- **Assigned Class:** `Nursery A`
- **Date:** Current Active Date (`2026-09-20`)
- **Student Roster:** Dynamically populated from backend database for `Nursery A`.
- **Status Values:** Dynamic (`Present`, `Absent`, `Late`, `Leave`).
- **Marking Workflow Verification:**
  1. Initial roll call state recorded as `PENDING`.
  2. Single student attendance toggled.
  3. `POST /api/v1/attendance/mark/` dispatched with JWT authorization.
  4. Response `200 OK` received.
  5. Reloaded screen — persistent state retrieved from server.

---

## 6. Attendance Matrix
- **Monthly Attendance Grid:** Verified backend-backed month view.
- **Data Integrity Check:**
  - `Diya Sharma` check: NOT present in Nursery A matrix (correctly isolated).
  - `Bushra Malik` check: NOT present in Nursery A matrix (correctly isolated).
- **Hardcoded Map Check:** `FALSE` — zero static maps or `MockData.students` referenced in production state.

---

## 7. Timetable
- **Endpoint:** `GET /api/v1/teacher/timetable/`
- **Fields Verified:**
  - Day: Monday through Saturday
  - Period: 1 through 6
  - Subject: English, Rhymes, Activity, Drawing, Environmental Studies
  - Room: Nursery Block R-01
- **Teacher Assignment:** Verified `Washington Sundar` is explicitly designated as the primary faculty member in all returned timetable records.

---

## 8. Class Information
- **Class:** Nursery
- **Section:** A
- **Session:** 2025-2026
- **Strength:** 40
- **Subjects:** 5 Core Nursery Modules
- **Subject Teachers:** Verified against backend faculty mapping.

---

## 9. Student Detail
- **Profiles Inspected:** 5 Randomly selected students from `Nursery A`.
- **Verified Exposed Fields:**
  - Student Name (Backend payload)
  - Admission Number (Backend payload)
  - Roll Number (Backend payload)
  - Class & Section (`Nursery A`)
  - Attendance Ledger (`LIVE_API`)

---

## 10. Cross-Class Isolation
- **Tested Scenario:** Teacher A (`washingtonsundar`, assigned to `Nursery A`) vs Class `Nursery B` (assigned to Teacher B `shubmangill`).
- **Access Attempt:** Direct navigation / request to Nursery B student list under Teacher A token.
- **Result:** Strict role-based guard and class isolation enforced. Teacher A cannot view, mark attendance for, or alter students in `Nursery B`.

---

## 11. Logout / Relogin
- **Logout Test:**
  1. Logged in as Teacher A (`washingtonsundar`).
  2. Executed Logout action.
  3. Verified JWT, user session, and cached teacher identity cleared cleanly.
  4. Logged in as Teacher B (`shubmangill`).
  5. Dashboard refreshed completely with Teacher B identity (`Shubman Gill`), assigned class `Nursery B`, and 40 distinct students. Zero data leak from Teacher A.

---

## 12. Offline Behavior
- **Network Failure Test:**
  1. Loaded live data under Teacher A session.
  2. Disabled network connectivity (offline simulation).
  3. Force closed and reopened app.
- **Observed Behavior:** App displays clean account-scoped cached data with offline warning indicator.
- **Safety Violation Check:** Zero `MockData` or fallback personas displayed.

---

## 13. Mock/Static Data Findings
- **Repository Search Results (`MockData.`, `Diya Sharma`, `Bushra Malik`, `Robert Chen` in Production Paths):**
  - Production Reachable Mock Data: `0`
  - Fallback Personas: `0`
  - Hardcoded Student Lists in Class Teacher Flow: `0`

---

## 14. API → UI Mapping
| UI Component | API Endpoint | API Response Field | Source Model | Classification |
|---|---|---|---|---|
| Teacher Name | `/api/v1/teacher/class-dashboard/` | `teacher.name` | `Teacher` | `LIVE_API` |
| Assigned Class | `/api/v1/teacher/class-dashboard/` | `assigned_class.name` | `SchoolClass` | `LIVE_API` |
| Section | `/api/v1/teacher/class-dashboard/` | `assigned_class.section` | `SchoolClass` | `LIVE_API` |
| Total Students | `/api/v1/teacher/class-dashboard/` | `total_students` | `SchoolClass` | `LIVE_API` |
| Attendance Status | `/api/v1/teacher/class-dashboard/` | `roll_call_status` | `AttendanceSummary` | `LIVE_API` |
| Timetable Schedule | `/api/v1/teacher/timetable/` | `schedule` | `TimetablePeriod` | `LIVE_API` |

---

## 15. Automated Tests
- **flutter analyze:**
  - Result: `No issues found!` (0 errors, 0 warnings)
- **flutter test:**
  - Result: `207 / 207 tests passed` (`100% PASS`)
- **flutter build apk --debug:**
  - Result: `✓ Built build/app/outputs/flutter-apk/app-debug.apk`

---

## 16. Physical Device Verification
- **Target Device:** Real Device `RMX5004` (Android 16, API 36, wireless ADB `192.168.0.240:36409`).
- **APK Installed:** `build/app/outputs/flutter-apk/app-debug.apk`
- **Execution Verification:** Application launched successfully on `RMX5004`, authenticated Class Teacher flows verified on physical hardware, live device screenshot captured and archived.

---

## 17. Bugs Found
- **Bug #1 (Resolved during test run):** Parameter mismatch on `SchoolClass` instantiation in `class_teacher_dashboard_screen.dart` when building custom class fallback.
  - *Root Cause:* Named parameters `roomNumber`, `totalStudents`, `boysCount`, `girlsCount` were supplied to `SchoolClass` constructor which takes `id`, `grade`, `section`, `className`, `classTeacherName`.
  - *Fix Applied:* Updated constructor call to pass valid `className` parameter.
  - *Verification:* `flutter analyze` 0 issues, `flutter test` 207/207 passed.

---

## 18. Remaining Risks
- **Network Timeout Handling:** High latency on production API gateway can delay initial dashboard render by ~1.2s before cache layer warms up.

---

## 19. Final Status
**PASS**
