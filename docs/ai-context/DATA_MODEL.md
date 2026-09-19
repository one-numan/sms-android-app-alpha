# ONPS School ERP — Data Model Architecture (`DATA_MODEL.md`)

> **Authoritative Schema**: Mapped directly from `lib/models/models.dart`, `lib/data/mock_data.dart`, and SQLite `onps_erp.db`.

---

## 1. Primary Entity Definitions & Status Matrix

| Entity Name | Primary Keys & Foreign Keys | Core Fields | Implementation Status | Used In Screens |
| :--- | :--- | :--- | :--- | :--- |
| **Student** | `id`, `classId`, `sectionId`, `parentId` | `fullName`, `rollNo`, `admissionNo`, `dob`, `bloodGroup`, `gender`, `attendancePercentage`, `feeStatus`, `emergencyContact` | **IMPLEMENTED** | Student Hub, Student Dossier, Roll Call, Marks Entry, Staff/Student Directory |
| **Parent** | `id`, `wardIds` (List) | `fullName`, `email`, `phone`, `occupation`, `address` | **IMPLEMENTED** | Parent Dashboard, Parents Directory, Student Dossier |
| **Teacher** | `id`, `assignedClassId`, `assignedSectionId` | `fullName`, `email`, `phone`, `designation`, `specialization`, `isClassTeacher` | **IMPLEMENTED** | Principal Teachers, Staff Directory, Section Detail |
| **SchoolClass** | `id`, `classTeacherId` | `name` (e.g. "Class 5"), `gradeLevel`, `sections` (List) | **IMPLEMENTED** | Principal Academics, Section Detail, Timetable |
| **Section** | `id`, `classId`, `classTeacherId` | `name` (e.g. "5-A"), `enrolledCount` | **IMPLEMENTED** | Section Detail, Roll Call, Marks Entry |
| **Subject** | `id` | `name` (e.g. "Mathematics"), `code` (e.g. "MATH-05"), `isElective` | **IMPLEMENTED** | Principal Academics, Class Subjects, Marks Entry |
| **ClassSubject** | `id`, `classId`, `sectionId`, `subjectId`, `teacherId` | `periodsPerWeek`, `weeklySlots` | **IMPLEMENTED** | Section Detail, Class Subjects, Faculty Allocation |
| **StudentAttendanceRecord** | `id`, `studentId`, `classId`, `sectionId` | `date`, `status` (`P`, `A`, `L`, `E`), `remarks` | **IMPLEMENTED** | Daily Roll Call, Student Monthly Attendance Matrix |
| **StudentMarks** | `id`, `studentId`, `subjectId` | `examTerm` ("First Assessment", "Half Yearly", etc.), `marksObtained`, `maxMarks`, `grade`, `remarks` | **IMPLEMENTED** | Marks Entry Desk, Report Card Screen |
| **FeeReceipt** | `id`, `studentId` | `receiptNo`, `termName`, `amountPaid`, `paymentDate`, `paymentMode`, `status` | **IMPLEMENTED** | Fee Ledger Screen, Receipt Voucher Screen |
| **Announcement** | `id`, `authorId` | `title`, `content`, `category`, `publishDate`, `targetRole`, `status` (`Draft`, `Pending`, `Published`) | **IMPLEMENTED** | Notice Board, Compose Circular, Moderation Queue |
| **BusRoute** | `id`, `driverId` | `routeName`, `busNumber`, `driverName`, `driverPhone`, `stops` (List) | **IMPLEMENTED** | Bus Transit Screen |
| **InventoryItem** | `id` | `itemName`, `category`, `quantity`, `unit`, `minThreshold`, `status` | **IMPLEMENTED** | Inventory Desk Screen |
| **FaqItem (SQLite)** | `id` | `question`, `answer`, `category`, `targetRoles`, `displayOrder`, `isFavorite`, `helpfulVotes` | **IMPLEMENTED (SQLite)** | FAQ Knowledge Base Screen (`onps_erp.db`) |

---

## 2. Relational Enums & Code Constants

### Attendance Status Enum (`StudentAttendanceRecord.status`)
- `'P'`: Present
- `'A'`: Absent
- `'L'`: Late
- `'E'`: Excused / On Leave

### Examination Term Enum (`StudentMarks.examTerm`)
- `'First Assessment'`: Periodic Assessment 1 (50 Marks)
- `'Half Yearly'`: Mid-Year Examination (100 Marks)
- `'Second Assessment'`: Periodic Assessment 2 (50 Marks)
- `'Final Exam'`: Annual Evaluation (100 Marks)

### Announcement Target Role Enum (`Announcement.targetRole`)
- `'all'`: Whole School
- `'parent'`: Parents Only
- `'teacher'`: Faculty Only
- `'student'`: Students Only

---

## 3. Data Source Architecture & Real Data Availability
- **Active Operational State**: `MockData` singleton (`lib/data/mock_data.dart`) supplying pre-populated, relational lists for 13 grades, 61 sections, 13 faculty members, and active student registries.
- **SQLite Database**: `onps_erp.db` created via `FaqDatabase.instance` with 14 pre-seeded production FAQ records across 6 domains.
- **API Mapping Target**: Django REST Framework endpoints (`/api/v1/students/`, `/api/v1/attendance/`, `/api/v1/fees/`, `/api/v1/announcements/`).
