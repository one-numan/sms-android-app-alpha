# One Numan Public School (ONPS) — Android ERP Mobile Suite
## Class Teacher Portal Feature Architecture & Screen Alignment Matrix
**Design System:** Espresso Heritage Academic (`DESIGN_SYSTEM_1`)  
**Target Viewport:** Android Mobile (390–412px, 844px height)  
**Django Permission Gate:** `is_class_teacher` (`Class.class_teacher == request.user.teacher_profile`)  
**Strict Exclusions Enforced:** No Bursar/Fee ledgers, no Transport logistics, no Inventory desks, no un-scoped "See All" registries, no Admin Panel.

---

### 1. Executive Summary & Role Definition

A **Class Teacher** in ONPS is an authenticated `Teacher` account where `Class.class_teacher` points to them for at least one homeroom section (e.g., Mrs. Anita Desai for **Grade 5-A**). 

Unlike staff group roles, attendance marking, announcements authoring for their class/grade, and homeroom academic operations are directly gated on this database relationship out of the box.

```
[ Teacher Login ] ➔ [ Class Teacher Detected (Grade 5-A) ]
         │
         ├──➔ 1. Class Teacher Dashboard (Screen 18)
         │       • Class Selector: [ Grade 5-A (Homeroom) ▼ ]
         │       • 4 KPIs: Class Strength (32), Present Today (29), Absent Today (2), Below 75% Attendance (1)
         │       • Action Toolbar: [ Mark Attendance ], [ Print Summary ], [ Export (Excel/CSV) ▼ ], [ Class Dashboard ]
         │       • Cards: Today's Roster, Today's Tasks, Today's Schedule, Lowest Attendance, Class Toppers, Subject Averages
         │
         ├──➔ 2. My Classes & Class Dashboard (Screen 18b)
         │       • Homeroom Section Summary (Grade 5-A, 32 Enrolled, 10 Subjects)
         │       • Quick Routes: [ Mark Attendance ], [ Monthly Register ], [ Timetable ], [ Class Dashboard ]
         │       • Homeroom Roster Table: Roll No, Student Name, Today's Attendance, Profile Action
         │
         ├──➔ 3. Interactive Mark Attendance Register (Screen 19)
         │       • Date picker, Search (Roll / Name), Filter by status (All, Present, Absent, Late, Leave, Not Marked)
         │       • Batch Actions: [ Mark All Present ], [ Mark All Absent ], [ Clear All ], [ Undo / Redo ]
         │       • Student Cards: Interactive radio / 4-state cycle (P / A / L / E)
         │       • Footer: [ Submit Attendance ], [ Discard / Restore Draft ], [ Classic Page Switch ], [ Monthly Register ]
         │
         ├──➔ 4. Monthly Attendance Register (Screen 11 / 19b)
         │       • Month Selector (Prev / Next), [ Mark Today ]
         │       • Search Student, Matrix table: Student vs Day 1...Day 31
         │
         ├──➔ 5. Faculty Leave Desk (Screen 22)
         │       • Apply for Leave (Type, Start Date, End Date, Reason, Proxy Assignment, Submit)
         │       • My Leave Requests Table: Applied Date, Type, Dates, Days, Reason, Status (Approved/Pending)
         │
         ├──➔ 6. My Timetable (Screen 21)
         │       • Monday–Saturday period grid (Periods 1–6) across assigned grades & homeroom
         │
         ├──➔ 7. Enter Subject Marks (Screen 20)
         │       • Scoped to subjects taught (Mathematics: 5-A, 5-B, 6-A)
         │       • Fields: Class-Subject, Student, Session, FA1, Half-Yearly, FA2 (Max 25), Final Exam, Save
         │
         ├──➔ 8. Student 360 Profile Dossier — Homeroom Student View (Screen 06)
         │       • Tab 1: Profile (Demographics, Address, Guardians, Behavior & Discipline Remarks list + [ + Add Remark ] form)
         │       • Tab 2: Academics (Marks trend chart, Report card table, Total, %, Grade)
         │       • Tab 3: Attendance (Present, Absent, Late, Leave counters + Trend chart)
         │       • Tab 4: Awards (Honor list + [ + Add Award ] category, session, note form)
         │       • Tab 5: Activity Log (Classroom timeline)
         │
         ├──➔ 9. School Calendar & Gazetted Holidays (Screen 14)
         │       • Add Event: Title, Date/End date, Time, Category, Description, Visible to [Class 5-A / Teachers / Role]
         │       • Birthdays: Next 7/30/90 days, Who (Students / Teachers)
         │       • Month View: Prev / Today / Next / List View
         │       • All Holidays: Gazetted & school holiday listing
         │
         └──➔ 10. Announcements & Circulars (Screen 13 / 23)
                 • New Post: Post as (Announcement / Notice Board), Title, Body, Audience ([Class 5-A], [Teachers]), Submit for Approval
                 • My Posts: Title, Type, Audience, Status, Row action [ Delete ]
                 • Notice Board & All Announcements feed with search
```

---

### 2. Feature Audit & Alignment Checklist

| Specification Item | Required Fields & Controls | Current Screen Mapping | Status & Alignment |
| :--- | :--- | :--- | :--- |
| **1. Class Teacher Dashboard** | • Class selector dropdown<br>• Buttons: Mark Attendance, Print, Export (Excel/CSV), Class Dashboard<br>• 4 KPIs: Strength (32), Present (29), Absent (2), Below 75% (1)<br>• Cards: Roster summary, Tasks, Schedule, Lowest Attendance, Class Toppers, Subject Average bar chart | **Screen 18** (`SCREEN_44` / `SCREEN_47`) | Refined into dedicated Class Teacher Executive view (`Screen 18`) meeting 100% of these fields. |
| **2. Interactive Mark Attendance** | • Date picker, Search student, Status radio filter (All/P/A/L/E/Not Marked)<br>• Buttons: Mark All Present, Mark All Absent, Clear All, Undo/Redo<br>• Student row status cycle (P/A/L/E)<br>• Bottom bar: Submit Attendance, Discard/Restore Draft, Classic Switch, Monthly Register | **Screen 19** (`SCREEN_68`) | 100% compliant with CBSE & Django `attendance.StudentAttendance`. |
| **3. Monthly Attendance Register** | • Month switcher, Mark Today, Student search<br>• Day 1...Day 31 P/A/L/E matrix | **Screen 11 / 19b** (`SCREEN_60`) | Fully aligned with interactive calendar & matrix slip download. |
| **4. Faculty Leave Management** | • Apply Leave: Type, Dates, Reason, Proxy, Submit<br>• My Requests table: Applied, Type, Dates, Days, Reason, Status | **Screen 22** (`SCREEN_57`) | Fully aligned with balance ledger (CL: 5, SL: 7, DL: 3) & history. |
| **5. Class Timetable Grid** | • Monday–Saturday Period 1–6 matrix with subject, room, timing | **Screen 21** (`SCREEN_46`) | Fully aligned with 22 contact hours matrix. |
| **6. Subject Marks Entry Desk** | • Class-Subject dropdown (e.g., Math 5-A), Student dropdown, FA1, Half-Yearly, FA2, Final Exam, Save | **Screen 20** (`SCREEN_58`) | Fully aligned with FA2 grading sheet, score steppers, and save/lock actions. |
| **7. Student 360 Homeroom Dossier** | • Tabs: Profile (Demographics + Remarks list + Add Remark form), Academics, Attendance, Awards (+ Add Award form), Activity Log | **Screen 06** (`SCREEN_48`) | Homeroom mentor privileged view with disciplinary remark and award authoring. |
| **8. School Calendar & Birthdays** | • Add Event with Audience scoping (Class/Teachers), Birthdays (7/30/90 days), Month View, Holidays list | **Screen 14** (`SCREEN_63`) | Fully aligned with academic timeline. |
| **9. Announcements & Circulars** | • New Post with Audience scoping (`Class 5-A`), My Posts with delete, Moderated Notice Board | **Screen 23 & 13** (`SCREEN_53` & `SCREEN_56`) | Fully aligned with Class Teacher audience mixin. |
| **10. Strict Exclusions Enforced** | • NO Fees, NO Transport, NO Inventory, NO Admin Panel, NO global See All un-scoped listings | Navigation & Shell | Enforced. Class Teacher bottom navigation uses `4-Tab Faculty Dock` (`Dashboard`, `Register`, `Classes`, `Notices`). |
