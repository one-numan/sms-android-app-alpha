# One Numan Public School (ONPS) — Android ERP Mobile Suite
## Subject Teacher Portal Feature Architecture & Screen Alignment Matrix
**Design System:** Espresso Heritage Academic (`DESIGN_SYSTEM_1`)  
**Target Viewport:** Android Mobile (390–412px, 844px height)  
**Django Permission Gate:** `is_subject_teacher` (`ClassSubject.teacher == request.user.teacher_profile` & NOT designated homeroom `Class.class_teacher`)  
**Strict Exclusions Enforced:** No Mark Attendance / Daily Roll Call (gated to Class Teacher), no Monthly Attendance Register, no Fees, no Transport, no Inventory, no Admin Panel, no Approval Queue.

---

### 1. Executive Summary & Role Definition

A **Subject Teacher** in ONPS is an authenticated `Teacher` account who holds one or more `ClassSubject` allocations across various grades/sections (e.g., Mr. Vikram Sen teaching Senior Mathematics / Physics across Grade 9-A, Grade 9-B, Grade 10-A, Grade 11-B), but is **NOT** a designated homeroom Class Teacher.

```
[ Teacher Login ] ➔ [ Subject Teacher Role Detected ]
         │
         ├──➔ 1. Subject Teacher Dashboard (Screen 18c)
         │       • Action Toolbar: [ Print Summary ], [ Export ▼ (Excel/CSV) ], [ See All Marks ]
         │       • 4 KPIs: My Subjects (3), My Classes (4), Students Taught (142), Marks Entry Progress (86.4%)
         │       • Card 1: Marks Entry Pending (Subject-class badges, entered/expected counter)
         │       • Card 2: Today's Teaching Schedule (Periods, Room, Subject, Grade)
         │       • Card 3: Class-wise Average in My Subject (Comparative Bar Chart)
         │       • Card 4: Grade Distribution per Class (Stacked Grade Band Bar Chart: A1–D)
         │       • Card 5: Assessment Progression (FA1 ➔ Half Yearly ➔ FA2 Velocity Trend)
         │
         ├──➔ 2. My Classes & Subject Cohorts (Screen 18d)
         │       • Summary: Class count (4), Total students (142)
         │       • Section cards: Grade 9-A (Math), Grade 9-B (Math), Grade 10-A (Physics)
         │       • Buttons: [ Timetable ], [ Marks Entry ]
         │       • Student Roster Table: Name, Roll No, [ Scoped Profile ]
         │
         ├──➔ 3. Enter Subject Marks Desk (Screen 20)
         │       • Gated strictly to assigned subjects (e.g., Mathematics: 9-A, 9-B, 10-A)
         │       • Fields: Class-Subject, Student, Session, FA1, Half-Yearly, FA2 (Max 25), Final Exam, Save
         │
         ├──➔ 4. Faculty Leave Desk (Screen 22)
         │       • Apply for Leave (Type, Dates, Reason, Proxy Faculty, Submit)
         │       • My Leave Requests Table: Applied Date, Type, Dates, Days, Reason, Status
         │
         ├──➔ 5. My Teaching Timetable Grid (Screen 21)
         │       • Monday–Saturday Period 1–6 timetable grid across assigned grades & lab allocations
         │
         ├──➔ 6. Student 360 Profile Dossier — Subject Scoped View (Screen 06)
         │       • Profile (demographics), Academics (scoped strictly to teacher's subject performance & trend), Attendance summary, Awards (+ Add Award form)
         │
         ├──➔ 7. School Calendar & Gazetted Holidays (Screen 14)
         │       • Add Event (audience scoped to Classes taught or Teachers), Birthdays, Month View, Holidays
         │
         └──➔ 8. Announcements & Circulars (Screen 13 / 23)
                 • New Post (audience scoped to Classes taught / Teachers), My Posts, Notice Board
```

---

### 2. Explicit Feature Comparison: Class Teacher vs. Subject Teacher

| Capability | Class Teacher (Homeroom) | Subject Teacher (Specialist) | Reason / Database Architecture |
| :--- | :---: | :---: | :--- |
| **Mark Daily Roll Call (P/A/L/E)** | ✅ YES (Screen 19) | ❌ NO (Blocked) | `attendance.StudentAttendance` is legally authorized by homeroom mentor only. |
| **Monthly Attendance Register** | ✅ YES (Screen 11) | ❌ NO (Blocked) | Homeroom register administration. |
| **Marks Entry for Assigned Subject** | ✅ YES | ✅ YES (Screen 20) | `examinations.Marks` scoped by `ClassSubject.teacher`. |
| **Class-wise Subject Averages & Grade Bands** | Partial | ✅ YES (Deep Analytics) | Subject teacher tracks cohort-level mastery across sections. |
| **Student Dossier View** | Unrestricted 7-tab | Scoped to Subject Marks | Disciplinary remarks restricted to homeroom mentor. |
| **Bottom Navigation Dock** | `Dashboard`, `Roll Call`, `Classes`, `Notices` | `Dashboard`, `Marks Entry`, `Classes`, `Notices` | "Roll Call" is substituted with "Marks Entry" dock trigger. |
