# One Numan Public School (ONPS) — Android ERP Mobile Suite
## Master Sequential Production Roster & Operational Screen Architecture
**Design System:** Espresso Heritage Academic (`DESIGN_SYSTEM_1`)  
**Target Viewport:** Android Mobile (390–412px, 844px height)  
**Backend Alignment:** Django 5.1.4 (26 Modular Apps, 63 Relational Tables)  
**Navigation Engine:** Flutter `go_router` / Material Navigator 2.0

---

### Executive Summary & Sequence Index

This canonical roster establishes the definitive operational sequence for the entire **One Numan Public School (ONPS)** Android ERP mobile application suite. Every screen is organized sequentially by operational lifecycle, role access tier, and backend data dependencies.

```
Cold Boot ➔ Screen 01 (Gateway) ──┬── [Pending 2FA] ───────────────➔ Screen 02 (OTP Verification)
                                  ├── [5x Failed Logins] ──────────➔ Screen 02b (Security Lockout)
                                  ├── [Forgot Password] ───────────➔ Screen 03 (Password Reset)
                                  └── [Authenticated Session] ─────┐
                                                                   ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                             ROLE-BASED POST-AUTH DISPATCH ENGINE                                │
├───────────────────────────────┬─────────────────────────────────┬────────────────────────────────┤
│ 1. Principal / Leadership     │ 2. Faculty / Class Teacher      │ 3. Student / Parent Scholastic │
│ ➔ Screen 02c (Morning Brief)  │ ➔ Screen 18 (Teacher Dashboard) │ ➔ Screen 28 (Student Hub)      │
│ ➔ Screen 24 (Exec Command)    │ ➔ Screen 19 (Roll Call)         │ ➔ Screen 05 (Parent Portal)    │
│ ➔ Specialized Exec Desks      │ ➔ Screen 20 (Marks Entry Desk)  │ ➔ Screen 06 (Student 360)      │
└───────────────────────────────┴─────────────────────────────────┴────────────────────────────────┘
```

---

### Phase 1: Authentication, Access Security & Multi-Device Governance

| Seq # | Screen ID | Canonical Title | Primary Role / Target | Backend App & Models | Description & Key Features |
| :---: | :---: | :--- | :--- | :--- | :--- |
| **01** | `SCREEN_28` | **01 - Secure Login Gateway** | Public / All Roles | `apps.accounts`<br>`auth.User`<br>`accounts.UserDevice` | Unified single-door entry with dynamic 4-persona selector (**Student**, **Staff**, **Parent**, **Teacher**), dynamic CTA button (*"Sign in as [Role] →"*), biometric unlock, and MAX=3 device governance advisory. |
| **02** | `SCREEN_66` | **02 - 2-Factor OTP & Device Eviction** | Pending 2FA | `apps.accounts`<br>`accounts.LoginOTP`<br>`accounts.UserDevice` | 6-digit cryptographic TOTP entry with 30s countdown, masked SMS/email recipient, and explicit FIFO eviction notice for oldest session. |
| **02b**| `SCREEN_32` | **02b - Security Lockout & OTP Cooldown** | Locked Session | `apps.accounts`<br>`accounts.OTPLockout`<br>`accounts.LoginActivity` | Progressive cooldown timer (Tier 1: 5m, Tier 2: 15m, Tier 3: 60m), lockout reason telemetry, and emergency direct IT Helpdesk dialer. |
| **02c**| `SCREEN_19` | **02c - Principal Executive Morning Briefing & Transition** | Principal | `apps.reports`<br>`reports.MorningTelemetry` | High-level session handshake: greeting, today's weather/campus status, quick security metrics, and direct transition button to Command Hub. |
| **03** | `SCREEN_39` | **03 - Password Reset & Recovery** | Public / Recovery | `apps.accounts`<br>`auth.User`<br>`accounts.PasswordReset` | Identity confirmation via registered Mobile/Email, OTP dispatch, and dual-entry password reset with strength meter. |
| **04** | `SCREEN_35` | **04 - Multi-Device Session Revocation** | Authenticated User | `apps.accounts`<br>`accounts.UserDevice` | Inventory of active sessions (max 3), current handheld indicator, IP/geo metadata, and one-tap remote eviction triggers. |

---

### Phase 2: Student & Parent Scholastic Portals

| Seq # | Screen ID | Canonical Title | Primary Role / Target | Backend App & Models | Description & Key Features |
| :---: | :---: | :--- | :--- | :--- | :--- |
| **05** | `SCREEN_72` | **05 - Parent Portal Dashboard** | Parent / Guardian | `apps.parents`<br>`parents.ParentStudent`<br>`attendance.StudentAttendance` | Multi-ward switcher capsule, today's attendance summary, pending fee dues alert, latest academic milestone, and 5-tab Parent dock. |
| **06** | `SCREEN_47` | **06 - Student 360 Profile Dossier** | Parent, Student, Faculty | `apps.students`<br>`students.Student`<br>`students.StudentMedical` | Complete 7-tab student dossier (**Profile**, **Academics**, **Attendance**, **Fees**, **Transport**, **Documents**, **Awards**) with dynamic marks scale and PDF export. |
| **07** | `SCREEN_69` | **07 - Academic Report Card** | Parent, Student, Teacher | `apps.examinations`<br>`examinations.Marks`<br>`examinations.GradeScale` | Official CBSE 4-term transcript (FA1, Half-Yearly, FA2, Final) with subject breakdowns, grade bands (A1–E), cumulative GPA, and download voucher. |
| **08** | `SCREEN_63` | **08 - Class Weekly Timetable** | Student, Parent, Teacher | `apps.timetable`<br>`timetable.TimetableSlot`<br>`timetable.Period` | Monday–Saturday period grid (Periods 1–6) scoped to student's class (9-B), live active period indicator, and classroom allocation tags. |
| **09** | `SCREEN_70` | **09 - Fee Ledger & UPI Payment** | Parent | `apps.fees`<br>`fees.FeeStructure`<br>`fees.FeePayment` | Term-wise fee breakdown (Tuition, Lab, Library, Transport), payment status chips, and one-tap instant UPI intent launcher. |
| **10** | `SCREEN_61` | **10 - Official Fee Payment Receipt** | Parent, Bursar | `apps.fees`<br>`fees.FeePayment`<br>`students.Student` | Formally stamped institutional fee voucher with transaction ID, payment mode (UPI/NetBanking), itemized fee head table, and save-to-storage CTA. |
| **11** | `SCREEN_59` | **11 - Student Monthly Attendance Matrix** | Parent, Class Teacher | `apps.attendance`<br>`attendance.StudentAttendance` | Interactive calendar grid with color-coded daily status markers (**P** Present, **A** Absent, **L** Late, **E** Excused) and monthly percentage gauge. |
| **12** | `SCREEN_58` | **12 - Student Leave Application & History** | Parent, Class Teacher | `apps.attendance`<br>`attendance.StudentLeave`<br>`notifications.Notification` | Leave application form (Medical, Casual, Bereavement), date range picker, reason notes, medical slip upload, and historical status tracker. |
| **13** | `SCREEN_55` | **13 - School Notice Board & Moderated Circulars** | All Roles | `apps.announcements`<br>`announcements.Announcement` | Public circular feed with segmented filter (**All Circulars** vs. **Pinned Notices**), red pin indicators, PDF attachment badges, and search. |
| **14** | `SCREEN_62` | **14 - Academic Calendar & Gazetted Holidays** | All Roles | `apps.school_calendar`<br>`school_calendar.Holiday`<br>`school_calendar.Event` | Official CBSE/State holiday list, month-by-month event timeline, countdown to next break, and category filters (Gazetted, Academic, Sports). |
| **15** | `SCREEN_54` | **15 - Central Push Notification Center** | All Roles | `apps.notifications`<br>`notifications.Notification` | Chronological push dispatch history categorized by urgency (**Fee Alert**, **Academic Notice**, **Bus Transit**, **General**), with read/unread states. |
| **16** | `SCREEN_41` | **16 - Central School Library & Circulation Desk** | Student, Parent, Librarian | `apps.library`<br>`library.Book`<br>`library.BookIssue` | Library catalog search, genre chips, active book loans counter, due date badges, and overdue penalty calculator. |
| **17** | `SCREEN_60` | **17 - Student Bus Route & Transit Card** | Parent, Student, Transport | `apps.transport`<br>`transport.Route`<br>`transport.Vehicle` | Assigned bus details (DL-01-AB-1294, North Route #4), morning/afternoon stop timetable, live transit status, and emergency driver dialer. |

---

### Phase 3: Faculty Instruction & Classroom Operations

| Seq # | Screen ID | Canonical Title | Primary Role / Target | Backend App & Models | Description & Key Features |
| :---: | :---: | :--- | :--- | :--- | :--- |
| **18** | `SCREEN_43` | **18 - Teacher Daily Operations Dashboard** | Class Teacher, Faculty | `apps.teachers`<br>`teachers.Teacher`<br>`academics.Class` | Teacher schedule card, today's roll call status, upcoming period alerts, pending assignments, and rapid student dossier lookup. |
| **19** | `SCREEN_67` | **19 - Class Teacher Daily Roll Call Register** | Class Teacher (Grade 5-A) | `apps.attendance`<br>`attendance.StudentAttendance` | Fast-tap multi-state attendance row toggle (**P / A / L / E**), real-time present counter (29/32), and bottom one-tap submittal bar. |
| **20** | `SCREEN_57` | **20 - Subject Teacher Assessment Marks Entry Desk** | Subject Teacher | `apps.examinations`<br>`examinations.Marks`<br>`academics.ClassSubject` | Subject marks entry sheet (Formative Assessment 2, Max 25), numeric stepper keypad, auto-calculating percentages, Draft save, and Final Lock. |
| **21** | `SCREEN_45` | **21 - Teacher Weekly Timetable Grid** | Faculty Members | `apps.timetable`<br>`timetable.TimetableSlot`<br>`timetable.Period` | Faculty weekly teaching grid across assigned grades and sections, free period indicators, and room assignment chips. |
| **22** | `SCREEN_56` | **22 - Faculty Leave Application & Balance Tracker** | Faculty, Staff | `apps.attendance`<br>`attendance.TeacherLeaveRequest` | Real-time leave balance tracker (Casual: 4 left, Medical: 8 left, Earned: 12 left), application form, and substitution teacher assignment. |
| **23** | `SCREEN_52` | **23 - Announcement Authoring & Audience Scoping Form** | Teacher, Staff, Principal | `apps.announcements`<br>`announcements.Announcement` | Composition interface with rich-text editor, multi-tier audience checkboxes (**Whole School**, **Class 9**, **Parents Only**, **Faculty**), and Moderation submit. |

---

### Phase 4: Executive Leadership, Self-Service & Intake

| Seq # | Screen ID | Canonical Title | Primary Role / Target | Backend App & Models | Description & Key Features |
| :---: | :---: | :--- | :--- | :--- | :--- |
| **24** | `SCREEN_25` | **24 - Principal Executive Command & ERP Hub** | Principal, Vice Principal | `apps.reports`<br>`reports.selectors`<br>`attendance.StudentAttendance` | Institutional command dashboard featuring 8 Core KPI tiles, weekly attendance/revenue charts, slide-over navigation drawer, and 5-tab Executive dock. |
| **24b**| `SCREEN_23` | **24b - All ERP Modules Directory Sheet** | Principal, Leadership | `apps.core`<br>`core.modules` | Full-screen interactive modal directory organizing all 18 ONPS ERP sub-modules by functional department with direct routing links. |
| **25** | `SCREEN_53` | **25 - Principal Announcement Moderation & Approval Queue** | Principal, Leadership | `apps.announcements`<br>`announcements.Announcement` | Administrative review queue for pending teacher/staff circulars with side-by-side audience scope inspection, Approve & Publish, and Return with Notes. |
| **26** | `SCREEN_40` | **26 - Unified Cross-Entity ERP Search** | All Authenticated Roles | `apps.core`<br>`core.search` | Global omnibox indexing Students, Faculty, Parents, Classes, Fee Receipts, and Circulars with instant keyboard search. |
| **27** | `SCREEN_42` | **27 - Faculty & Staff Institutional Directory** | All Authenticated Roles | `apps.staff`<br>`teachers.Teacher`<br>`staff.Staff` | Complete institutional contact roster segmented by Department (Academics, Administration, Accounts, Logistics) with direct call/email triggers. |
| **28** | `SCREEN_37` | **28 - Student Self-Service Hub** | Student | `apps.students`<br>`students.Student`<br>`timetable.TimetableSlot` | Streamlined personal workspace with Attendance KPI (`94.2%`), Term 1 Result (`88.5%`), Fee Due card, active period schedule, and borrowed books. |
| **29** | `SCREEN_64` | **29 - Digital Student ID Card Sheet** | Student, Parent, Security | `apps.students`<br>`students.Student`<br>`students.StudentMedical` | Official photographic collegiate identity card with encrypted QR verification token, Code-128 barcode, emergency medical blood group, and contact dialer. |
| **30** | `SCREEN_68` | **30 - Admissions Enquiry & Prospect Intake Desk** | Admissions, Front Desk | `apps.admissions`<br>`admissions.Enquiry`<br>`admissions.Application` | Intake ledger for prospective students, multi-criteria status filter (New, Follow-up, Converted, Closed), search bar, and `+ Log New Enquiry` bottom bar. |

---

### Phase 5: Principal Specialized Executive Desks (Sidebar Map Aligned)

| Seq # | Screen ID | Canonical Title | Primary Role / Target | Backend App & Models | Description & Key Features |
| :---: | :---: | :--- | :--- | :--- | :--- |
| **31** | `SCREEN_2` | **Accounts & Fee Collection Executive Dashboard** | Principal, Bursar | `apps.fees`<br>`fees.FeePayment`<br>`fees.FeeStructure` | Executive fee realization telemetry (Expected ₹18.40L, Realized ₹16.92L, Outstanding ₹1.47L), payment mode breakdown (UPI/NEFT/Cheque/Cash), and class-wise collection ledger. |
| **32** | `SCREEN_16` | **Principal Library & Resource Circulation Dashboard** | Principal, Librarian | `apps.library`<br>`library.Book`<br>`library.BookIssue` | Executive collection metrics (Total Titles, Active Loans, Overdue Items), trending student reads, circulation velocity, and borrower reminder nudge. |
| **33** | `SCREEN_15` | **All Classes & Academic Faculty Allocation Dashboard** | Principal, Academic Dean | `apps.academics`<br>`academics.Class`<br>`academics.ClassSubject` | Master academic matrix of all grades (PG through 12th), section allocations, assigned class teachers, subject-to-teacher mappings, and unassigned warnings. |
| **34** | `SCREEN_11` | **Principal Admissions Applications & Enrollment Desk** | Principal, Registrar | `apps.admissions`<br>`admissions.Application`<br>`admissions.Enquiry` | Official formal enrollment application queue categorized by academic session (2026-27), review states (Pending, Under Review, Approved, Rejected), and applicant dossiers. |
| **35** | `SCREEN_9` | **Principal School Calendar & Institutional Events Desk** | Principal, Administration | `apps.school_calendar`<br>`school_calendar.Holiday`<br>`school_calendar.Event` | Native mobile executive calendar view combining monthly interactive date grid, gazetted holiday indicators, upcoming school events, and `+ Add Event` modal. |
| **36** | `SCREEN_3` | **Student - See All Students Ledger** | Principal, Registrar | `apps.students`<br>`students.Student`<br>`academics.Class` | Comprehensive institutional student ledger featuring multi-criteria bottom filter (Grade, Section, Gender, Admission Year), student dossiers, and quick contact cards. |
| **37** | `SCREEN_5` | **Inventory - All Items & Low Stock Desk** | Principal, Operations Head | `apps.inventory`<br>`inventory.Item`<br>`inventory.Category` | Campus asset and consumables ledger (Textbooks, Lab Equipment, Uniforms, Stationery) with critical **Low Stock Alert Badges** and reorder purchase triggers. |
| **38** | `SCREEN_7` | **Parents - All Parents Directory** | Principal, Front Office | `apps.parents`<br>`parents.Parent`<br>`parents.ParentStudent` | Official parent directory linking guardians to their enrolled wards, emergency phone numbers, residential addresses, and direct communication triggers. |
