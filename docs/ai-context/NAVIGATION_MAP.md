# ONPS School ERP — Role Navigation Map (`NAVIGATION_MAP.md`)

> **Navigation Architecture**: Bounded by primary bottom navigation dock (`lib/widgets/bottom_nav_bar.dart`), quick action cards on dashboards, and role-specific "More" sheets (`lib/screens/more/`).

---

## 1. Role-Wise Primary Navigation Structure

### 1.1 Student Persona Navigation
- **Primary Bottom Navigation Dock (5 Items)**:
  1. `Portal` $\rightarrow$ `/dashboard/student`
  2. `Academics` $\rightarrow$ `/students/report-card`
  3. `Attendance` $\rightarrow$ `/attendance/student`
  4. `Fees` $\rightarrow$ `/fees/ledger`
  5. `More` $\rightarrow$ `/more/student`
- **Student "More Hub" Utilities**:
  - *My School*: Digital Student ID (`/students/id-card`), Class Timetable (`/faculty/timetable/class`), School Notices (`/announcements`), Academic Calendar (`/calendar/academic`).
  - *Services*: Bus Transit (`/transit/bus`).
  - *Account*: Student Profile Dossier (`/students/dossier`), App Settings (`/account/settings`).

---

### 1.2 Parent Persona Navigation
- **Primary Bottom Navigation Dock (5 Items)**:
  1. `Portal` $\rightarrow$ `/dashboard/parent`
  2. `Academics` $\rightarrow$ `/students/report-card`
  3. `Attendance` $\rightarrow$ `/attendance/student`
  4. `Fees` $\rightarrow$ `/fees/ledger`
  5. `More` $\rightarrow$ `/more/parent`
- **Parent Quick Actions & Desks**:
  - Multi-Student Selector (Header dropdown)
  - Leave Application (`/attendance/student-leave` — *Requires alias fix*)
  - Bus Transit Tracker (`/transit/bus`)
  - Fee Payment Receipts (`/fees/receipt`)

---

### 1.3 Subject Teacher Persona Navigation
- **Primary Bottom Navigation Dock (5 Items)**:
  1. `Portal` $\rightarrow$ `/dashboard/subject-teacher`
  2. `Academics` $\rightarrow$ `/academics/marks-entry`
  3. `Attendance` $\rightarrow$ `/attendance/student`
  4. `Timetable` $\rightarrow$ `/faculty/timetable`
  5. `More` $\rightarrow$ `/more/subject-teacher`
- **Subject Teacher Desks**:
  - My Assigned Classes (`/teacher/my-classes`)
  - Teaching Subjects (`/teacher/teaching-assignments`)
  - Student Directory (`/teacher/student-directory`)
  - Staff Notices (`/announcements`)
  - Faculty Leave (`/attendance/faculty-leave`)

---

### 1.4 Class Teacher Persona Navigation
- **Primary Bottom Navigation Dock (5 Items)**:
  1. `Portal` $\rightarrow$ `/dashboard/class-teacher`
  2. `Academics` $\rightarrow$ `/academics/marks-entry`
  3. `Attendance` $\rightarrow$ `/attendance/roll-call`
  4. `Timetable` $\rightarrow$ `/faculty/timetable/class`
  5. `More` $\rightarrow$ `/more/class-teacher`
- **Class Teacher Desks**:
  - Class Information (`/teacher/class-info`)
  - Student Directory (`/teacher/class-students`)
  - Homeroom Subjects (`/teacher/class-subjects`)
  - Leave Requests Approval (`/attendance/faculty-leave`)

---

### 1.5 Principal Persona Navigation
- **Primary Bottom Navigation Dock (5 Items)**:
  1. `Portal` $\rightarrow$ `/dashboard/principal`
  2. `Academics` $\rightarrow$ `/faculty/allocation`
  3. `Students` $\rightarrow$ `/students/directory`
  4. `Notices` $\rightarrow$ `/announcements`
  5. `More` $\rightarrow$ `/more/principal`
- **Principal Executive Desks**:
  - Teachers Management (`/principal/teachers`)
  - Section Details (`/faculty/section-detail`)
  - Moderation Queue (`/principal/moderation`)
  - Admissions & Enrollment (`/admissions/enrollment`)
  - Inventory Desk (`/inventory/desk`)

---

## 2. Universal Navigation Elements
- **Universal Role Switcher Sheet**: Accessible via top app bar persona chip or settings to switch instant active view across 9 roles.
- **Account Profile Sheet**: Triggered via user profile avatar icon (`lib/widgets/account_profile_sheet.dart`).
- **Global Search**: Floating action / top bar action triggering `/search` across students, teachers, circulars, and classes.
