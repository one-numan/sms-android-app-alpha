# ONPS School ERP — Business Logic & Domain Rules (`BUSINESS_LOGIC.md`)

> **Source of Truth Priority**: Code contracts in `lib/models/models.dart` & `lib/data/mock_data.dart` override external ERP assumptions. Unverified ideas are marked `UNKNOWN / NEEDS VERIFICATION`.

---

## 1. Core Educational & Administrative Workflows

### Rule 1.1: Student → Class / Section Structure
- **Business Rule**: Every enrolled student belongs to exactly one `SchoolClass` (Grade 1 through 12, plus Kindergarten) and one `Section` (e.g., `5-A`, `10-B`).
- **Source in Code**: `Student.classId`, `Student.sectionId` in `lib/models/models.dart`.
- **Affected Roles**: Student, Parent, Class Teacher, Subject Teacher, Principal, Accountant.
- **Affected Screens**: Student Dossier, Roll Call, Marks Entry, Fee Ledger, Section Detail.
- **Notes/Limitations**: Students cannot belong to multiple sections simultaneously.

---

### Rule 1.2: Teacher Assignments (Class Teacher vs. Subject Teacher)
- **Business Rule**:
  - A `Teacher` can be assigned as the **Class Teacher** of at most one `Section` per academic year.
  - A `Teacher` can teach one or more `Subject`s across multiple `ClassSubject` assignments.
  - Class Teacher and Subject Teacher are NOT distinct user types; they are assigned operational roles attached to a faculty member.
- **Source in Code**: `Teacher.isClassTeacher`, `Teacher.assignedClassId`, `Teacher.assignedSectionId`, `SchoolClass.classTeacherId`, `ClassSubject.teacherId`.
- **Affected Roles**: Subject Teacher, Class Teacher, Principal.
- **Affected Screens**: Class Teacher Operations, Subject Teacher Assessment, Principal Teachers Management, Principal Section Detail.

---

### Rule 1.3: Attendance Management & 4-State Matrix
- **Business Rule**:
  - Morning Roll Call is marked strictly using 4 official status codes:
    - `P`: Present
    - `A`: Absent
    - `L`: Late (arrived after assembly bell)
    - `E`: On Leave / Excused (approved leave request)
  - CBSE Compliance: Students must maintain $\ge 75\%$ aggregate annual attendance to be eligible for board examinations. Automated notifications trigger when attendance drops below 80%.
- **Source in Code**: `StudentAttendanceRecord.status`, `Student.attendancePercentage` in `lib/models/models.dart`.
- **Affected Roles**: Student, Parent, Class Teacher, Principal.
- **Affected Screens**: Roll Call Screen, Student Attendance Matrix Screen.

---

### Rule 1.4: Examination & Marks Entry (CBSE 4-Term Pattern)
- **Business Rule**:
  - Academic evaluation strictly follows the CBSE 4-Term Assessment Windows:
    1. **First Assessment**: Periodic Assessment 1 (50 Marks max).
    2. **Half Yearly**: Mid-Year Comprehensive Examination (100 Marks max).
    3. **Second Assessment**: Periodic Assessment 2 (50 Marks max).
    4. **Final Exam**: Annual / Year-End Evaluation (100 Marks max).
  - Passing Criteria: Minimum 33% marks in each subject (both theory and practical separately) and 33% overall aggregate. Grades follow CBSE 9-point scale ($A1$ to $E$).
- **Source in Code**: `StudentMarks.examTerm`, `StudentMarks.marksObtained`, `StudentMarks.maxMarks`.
- **Affected Roles**: Subject Teacher, Class Teacher, Student, Parent, Principal.
- **Affected Screens**: Marks Entry Desk, Report Card Screen, Principal Academics Hub.

---

### Rule 1.5: Parent → Student (Multi-Student) Ownership
- **Business Rule**: A parent account can be linked to one or multiple students enrolled in the school. The parent dashboard and fee views switch context based on the selected active student.
- **Source in Code**: `Parent.wardIds` list in `lib/models/models.dart`.
- **Affected Roles**: Parent, Principal, Accountant.
- **Affected Screens**: Parent Dashboard, Fee Ledger, Report Card.

---

### Rule 1.6: Fee Ledger & Read-Only Dues
- **Business Rule**:
  - Fee structures are billed term-wise (Term 1, Term 2, Annual).
  - In-app payment gateways are read-only / simulated dues clearance summaries. Actual payments issue official signed Fee Payment Receipt Vouchers upon accounts office reconciliation.
  - Late fee policy: ₹50/day after 7-day grace period (due on 15th of billing month), capped at ₹1,000.
- **Source in Code**: `FeeReceipt`, `FeeStructure` models in `lib/models/models.dart`.
- **Affected Roles**: Student, Parent, Accountant.
- **Affected Screens**: Fee Ledger Screen, Receipt Voucher Screen, Accounts Dashboard.

---

### Rule 1.7: Notice Board, Circulars & Governance Workflow
- **Business Rule**:
  - Teachers and administrative staff draft circulars targeting specific roles (Parents, Faculty, Students).
  - Administrative circulars pass through the Principal Moderation Queue (`/principal/moderation`) before public dispatch.
  - Zero Telecom SMS Policy: Circulars and urgent alerts are dispatched via in-app push and email exclusively.
- **Source in Code**: `Announcement.targetRole`, `Announcement.status` in `lib/models/models.dart`.
- **Affected Roles**: All Roles, Principal.
- **Affected Screens**: Notice Board, Compose Circular, Principal Moderation Queue.

---

## 2. Unverified Rules / Unknown Domain Aspects
- **Homework Submission Workflow**: `UNKNOWN / NEEDS VERIFICATION` (No backend model or assignment table currently exists).
- **Online Library Renewal**: `UNKNOWN / NEEDS VERIFICATION` (Library circulation exists, online renewal pending backend specification).
- **Transport Live GPS Stream Integration**: `UNKNOWN / NEEDS VERIFICATION` (Bus routes and stops are documented; live WebSocket GPS protocol pending API integration).
