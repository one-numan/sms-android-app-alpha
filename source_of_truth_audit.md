# ONPS ERP — Source of Truth Analysis & Data Audit
**Scope:** Static analysis of `lib/models/`, `lib/data/mock/`, `lib/router.dart`, and all `lib/screens/**/*.dart`.
**Objective:** Establish the absolute source of truth regarding existing business entities, role permissions, real data availability, and business logic before making navigation/screen changes.

---

## 1. Project Data Model Summary

Based exclusively on `lib/models/models.dart`, the following entities currently exist in the codebase:

### User & Staff Models
- **Teacher:** Fields: `id`, `name`, `dateOfBirth`, `mobile`, `alternateMobile`, `email`, `gender`, `joinDate`, `address`, `subjectSpecialization`.
- **Staff:** Fields: `id`, `name`, `designation` (Principal, Vice Principal, Accountant, Receptionist, Librarian), `mobile`, `email`, `gender`, `dateOfBirth`, `joinDate`, `address`.
- **Parent:** Fields: `id`, `name`, `mobile`, `email`.
- **ParentStudentLink:** Connects `Parent` and `Student` via `relation` (father, mother, guardian).

### Academic & Student Models
- **Student:** Fields: `id`, `firstName`, `middleName`, `lastName`, `dateOfBirth`, `mobile`, `alternateMobile`, `email`, `gender`, `admissionDate`, `rollNumber`, `address`, `dwellingType`, `grade`, `section`.
- **SchoolClass:** Fields: `id`, `grade`, `section`, `className`, `classTeacherName`.
  *(Note: It resolves `classTeacherId` via `'TCH-$id'`, implying a 1-to-1 strict relationship for class teachers).*
- **Subject:** Fields: `id`, `name`, `subjectType` (Theory, Practical), `testWeight`, `examWeight`.
- **StudentMarks:** Fields: `studentId`, `subjectName`, `firstAssessment`, `halfYearly`, `secondAssessment`, `finalExam`.

### Attendance & Leave Models
- **StudentAttendanceRecord:** Fields: `studentId`, `date`, `status` (present, absent, late, onLeave), `markedBy`, `markedAt`.
- **TeacherLeaveRequest:** Fields: `id`, `teacherName`, `leaveType` (sickLeave, casualLeave, earnedLeave, other), `startDate`, `endDate`, `reason`, `status`.

### Administrative Models
- **AdmissionsEnquiry:** Tracks prospective leads (`EnquiryStatus`).
- **AdmissionsApplication:** Tracks submitted enrollments (`ApplicationStatus`).
- **FeeStructure:** Fields: `id`, `className`, `session`, `feeHead`, `amount`.
- **FeePayment:** Fields: `id`, `studentId`, `amount`, `paymentDate`, `mode`, `referenceNumber`, `remarks`.
- **Holiday & SchoolEvent:** Tracks academic calendar.
- **Announcement:** Tracks global notices (`status`: pending, pendingApproval, published, rejected).

### Auxiliary Models
- **Book & BookIssue:** Basic library circulation tracking.
- **TransportRoute:** Bus tracking (route name, driver, vehicle number, stops).
- **InventoryItem:** Tracks physical campus assets.
- **TimetableSlot:** Maps day/period to class, subject, and teacher.

---

## 2. Role & Permission Matrix

Permissions are handled via `AuthState` and `UserRole` enum.
A teacher may theoretically act as both a Class Teacher and Subject Teacher, but the UI currently forces the user into a specific `UserRole` state. The data model inherently allows a `Teacher` to be assigned to a `SchoolClass` (as Class Teacher) and multiple `TimetableSlot` items (as Subject Teacher).

| Role | Actual Implemented Capability / Access |
|------|----------------------------------------|
| **Super Admin** | Accesses `/dashboard/modules`. Can view system-level modules. |
| **Principal / VP** | Reads all students, staff, classes. Reads attendance matrices, financial dashboards. Can approve `TeacherLeaveRequest` and `Announcement`. |
| **Class Teacher** | Reads students in assigned class. Marks `StudentAttendanceRecord`. Reads/Writes `StudentMarks`. Submits `TeacherLeaveRequest`. |
| **Subject Teacher** | Reads students in assigned subject cohorts. Reads/Writes `StudentMarks`. Submits `TeacherLeaveRequest`. |
| **Parent** | Reads `Student`, `StudentMarks`, `StudentAttendanceRecord`, `FeePayment` belonging to their children (via `AuthState.selectedChildIndex`). |
| **Student** | Reads their own `Student`, `StudentMarks`, `StudentAttendanceRecord`, `FeePayment`. |
| **Accountant** | Reads/Writes `FeePayment` and `FeeStructure`. |
| **Librarian** | Reads/Writes `Book` and `BookIssue`. |

---

## 3. Real Data Availability Matrix

All data is currently served via `MockData` (In-Memory Static Repository). There are NO actual HTTP API calls or SQLite databases implemented yet.

| Module | Classification | Notes |
|--------|----------------|-------|
| **Student / Parent** | C. STATIC/DEMO DATA | `MockData.students` provides deep mocks. |
| **Classes / Subjects** | C. STATIC/DEMO DATA | `MockData.classes` and `MockData.subjects`. |
| **Teacher / Staff** | C. STATIC/DEMO DATA | `MockData.teachers` and `MockData.staffMembers`. |
| **Attendance** | C. STATIC/DEMO DATA | `MockData.attendanceRecords`. |
| **Marks / Exams** | C. STATIC/DEMO DATA | `MockData.studentMarks`. |
| **Fees & Payments** | C. STATIC/DEMO DATA | `MockData.feeStructures` and `MockData.feePayments`. |
| **Timetable** | C. STATIC/DEMO DATA | `MockData.timetable`. |
| **Transport** | C. STATIC/DEMO DATA | `MockData.routes`. |
| **Library** | C. STATIC/DEMO DATA | `MockData.books`, `MockData.bookIssues`. |
| **Calendar / Events** | C. STATIC/DEMO DATA | `MockData.holidays`, `MockData.events`. |
| **Notices** | C. STATIC/DEMO DATA | `MockData.announcements`. |
| **Admissions** | C. STATIC/DEMO DATA | `MockData.enquiries`, `MockData.applications`. |

> **Conclusion:** The application relies entirely on 20 comprehensive lists in `MockData` to populate the UI. The UI components are fully wired to these static data models.

---

## 4. Existing Screen → Data Source Matrix

| Screen | Main Purpose | Actual Data Source | Displayed Data |
|--------|--------------|--------------------|----------------|
| `StudentHubScreen` | Student portal | `AuthState.selectedChild`, `MockData` | Real (mock) student info, KPIs. |
| `ParentDashboardScreen`| Parent portal | `AuthState.selectedChild`, `MockData` | Child switcher, child KPIs. |
| `PrincipalDashboardScreen`| Admin portal | `MockData` (filtered) | Aggregate metrics, pending approvals. |
| `AcademicReportCardScreen`| Exam Results | `MockData.studentMarks` | Grades and score totals. |
| `FeeLedgerScreen` | Financials | `MockData.feePayments` | Payment history, outstanding balances. |
| `DailyRollCallScreen` | Marking presence | `MockData.students` (filtered by class) | Student list with segmented controls. |
| `NoticeBoardScreen` | Global notices | `MockData.announcements` | Published announcements. |
| `StudentDossierScreen`| Deep profile | `MockData.students` | Personal, contact, and transport info. |

---

## 5. Existing Route → Screen Matrix

*(Detailed exhaustive matrix is available in the deep connectivity audit. Summary: 53 screens correctly mapped in `router.dart` utilizing `go_router` context and path parameters).*

---

## 6. Broken Navigation

The UI attempts to reach the following routes which do NOT exist in the router or codebase:

1. `/notices` (from Parent/Principal dashboards)
2. `/students/digital-id` (from Parent dashboard)
3. `/attendance/student-leave` (from Class Teacher dashboard)
4. `/principal/announcements/approval` (from Principal dashboard)

---

## 7. Duplicate/Alias Navigation

The `router.dart` uses massive path aliasing to allow roles to feel distinct while reusing screens.
- **Alias:** `/teacher/student-directory`, `/teacher/class-students` → **Canonical:** `/faculty/directory`
- **Alias:** `/library/desk` → **Canonical:** `LibrarianDashboardScreen`
- **Alias:** `/timetable/class` → **Canonical:** `ClassTimetableScreen`

---

## 8. Screens Existing But Not Reachable

None. Every screen inside `lib/screens/` has at least one entry point from the UI via Bottom Nav or the `ModuleGridSheet`.

---

## 9. Screens That Expose Incorrect/Unsupported Functionality

1. **`FeeLedgerScreen` (Parent/Student)**: Exposes a "Pay" button that triggers a dialog. The backend `FeePayment` model tracks completed payments but has no mechanism (like a `PaymentIntent` or gateway callback url) to initiate a payment.
2. **`LibrarianDashboardScreen` (via `/library/desk` on Student Hub)**: The student taps "Books on Loan" and is taken to the Librarian's operational dashboard which manages all inventory. This exposes the wrong role's dashboard to a student.

---

## 10. Business Logic Risks

1. **Role Overlap:** `ClassTeacher` and `SubjectTeacher` use separate `UserRole` states and separate dashboards. If one physical teacher is both (which is standard), they must log out and switch roles in the UI. The data model (`SchoolClass.classTeacherName` vs `TimetableSlot.teacherName`) supports this, but the UI flow forces strict role silos.
2. **Student Leave Approval:** The Class Teacher UI has a "Review Leave" button for students, but the data model (`StudentAttendanceRecord`) only tracks `onLeave` status. There is no `StudentLeaveRequest` model in `models.dart`. (Only `TeacherLeaveRequest` exists).

---

## 11. Recommended Implementation Order

### Recommendation 1: Fix High-Impact Broken Navigation
- **Why:** Immediate UX failures on Parent and Principal dashboards.
- **Involved:** `/notices` → `/announcements`, `/principal/announcements/approval` → `/announcements/approval`.
- **Data Source:** Existing `MockData.announcements`.
- **Rule:** Re-route existing UI buttons to their canonical router targets.
- **New Screen?** NO.
- **Do NOT Change:** The visual styling of the dashboard cards.

### Recommendation 2: Resolve the "Student Leave" Missing Feature
- **Why:** The UI promises Class Teachers the ability to review student leave, but neither the screen nor the backend model exists.
- **Involved:** `class_teacher_dashboard_screen.dart` (L1017).
- **Business Rule:** Since there is no `StudentLeaveRequest` model, we cannot build a functional approval screen without violating the rule "Do not create new models".
- **Action:** Remove or disable the "Review Student Leave" button from the Class Teacher dashboard until the backend model is implemented.
- **New Screen?** NO.
- **Do NOT Change:** Existing `StudentAttendanceRecord` logic.

### Recommendation 3: Resolve Library Surrogate Issue
- **Why:** Students are being directed to a Librarian dashboard.
- **Involved:** `/library/desk` route mapping in `router.dart`.
- **Business Rule:** Students need to see their `MockData.bookIssues` filtered by their `studentId`.
- **Action:** We must create a true `student_library_desk_screen.dart` to consume `MockData.bookIssues`, and map `/library/desk` for students to this new screen instead of the `LibrarianDashboardScreen`.
- **New Screen?** YES.

### Recommendation 4: Fix Parent Digital ID Route
- **Why:** Quick action fails on Parent Dashboard.
- **Involved:** `/students/digital-id`.
- **Action:** Change the route string in the Parent dashboard to `/students/id-card`.
- **New Screen?** NO.

*(This concludes the Source of Truth Analysis step. We are now ready to execute precise navigation fixes).*
