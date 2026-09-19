# ONPS Scholastic ERP — Institutional Terminology & Lexicon Glossary

**One Numan Public School (ONPS) Mobile Application**  
**Design System:** Espresso Heritage Academic  
**Document Version:** 1.0.0 (Updated: September 2026)

---

## 1. Term Adoption: "Student File" (Replacing "Dossier")

The term **"Student File"** replaces **"Dossier"** across all user interfaces, button actions, bottom sheets, and documentation. 

### Why "Student File"?
- **Familiar & Academic:** Universally understood by parents, teachers, and school administrators in CBSE/K-12 schools.
- **Removes Ambiguity:** Avoids the bureaucratic or investigatory/intelligence connotation of "dossier".
- **Compact & Clean:** Fits naturally within mobile card headers, button containers, and pill badges without truncation.

### UI & Lexicon Transition Matrix

| Previous Term | New Adopted Term | Location / Component | Example Context |
| :--- | :--- | :--- | :--- |
| **Student 360 Dossier** | **Student 360 File** | `StudentDossierScreen` AppTopBar | Screen header on Screen 06 |
| **Dossier PDF** | **Student File PDF** | Top action button on Screen 06 | Primary export button |
| **Download Dossier PDF** | **Download Student File (PDF)** | Action chips / menus | Full export action |
| **Share Dossier** | **Share Student File** | Top bar share action | Share bottom sheet prompt |
| **View Dossier** | **Student File** | `ParentsDirectoryScreen` | Student list item tap target |
| **Applicant Dossiers** | **Applicant Files** | `ApplicationsEnrollmentScreen` | Admission review list |
| **Review Dossier** | **Review File** | Admissions review card | Review action button |
| **Rapid Dossier Lookup** | **Rapid Student File Lookup** | Teacher Daily Operations | Global quick search |
| **Direct Dossier Dispatch** | **Direct File Dispatch** | Scoping & Circulars | Targeted recipient selector |
| **Linked Student Dossiers** | **Linked Student Files** | Parent directory cards | Student association indicator |

---

## 1b. Term Adoption: "Class / Section" (Replacing "Cohort")

The term **"Cohort"** is completely replaced across all user-facing interfaces, labels, headings, summaries, and action buttons in favor of standard school terminology:

### UI & Lexicon Transition Matrix

| Previous Term | New Adopted Term | Context / Scope |
| :--- | :--- | :--- |
| **Cohort List / Cohorts** | **Class List / Classes** | When referring to student classes or academic grade groups |
| **Assigned Cohorts** | **Assigned Classes** | Subject teacher teaching assignments |
| **Select Cohort** | **Select Class** | Filter and dropdown selectors |
| **Cohort Student Roster** | **Student List** | Class student enrollments and listings |
| **Cohort Allocation Summary** | **Class Allocation Summary** | Faculty teaching distribution |
| **Cohort Overview** | **Class Overview** | Class performance and metrics summary |

---

## 1c. Term Adoption: "Student List / Class List" (Replacing "Roster")

The term **"Roster"** is completely replaced across all user-facing interfaces, labels, navigation, and dialogs with natural K-12 school terms:

### UI & Lexicon Transition Matrix

| Previous Term | New Adopted Term | Context / Placement |
| :--- | :--- | :--- |
| **Student Roster** | **Student List** | Class student directory and roster buttons |
| **Class Roster / Class [X] Roster** | **Class List / Class [X] Student List** | Class overview and student ledgers |
| **Attendance Roster** | **Attendance List / Register** | Daily morning roll call and attendance review |
| **Faculty Roster** | **Faculty Directory / Staff List** | Teacher management and staff removal dialogs |
| **Subject Roster** | **Subject List** | Assigned subjects per class section |
| **Roster (Nav Item)** | **Students** | Accountant & Receptionist bottom navigation items |
| **Institutional Roster** | **Student Registry / Directory** | Master student directory header subtitle |

---

## 2. Structure of the Student File (7 Pillars)

The **Student File** (`/students/dossier?id=<id>`) consolidates 7 functional domains:

1. **Profile & Demographics:** Legal name, roll number, admission number, date of birth, blood group, chronic allergies, guardian contacts, emergency address.
2. **Academics:** Term-wise assessment records across the 4 CBSE evaluation windows, mentor remarks, and grade trajectory.
3. **Attendance:** Aggregate annual attendance percentage, monthly breakdown, and historical leave applications.
4. **Fees & Dues:** Read-only fee schedule compliance, paid receipt voucher ledger, and clearance status.
5. **Transport:** Assigned bus route number, designated boarding/drop stop, vehicle registration, and driver contact.
6. **Documents:** Attested birth certificate, Aadhaar card, previous school Transfer Certificate (TC), and immunization records.
7. **Awards & Merits:** Extracurricular achievements, house captaincy, sports medals, and institutional commendations.

---

## 3. Core Institutional Terminology Dictionary

### A. Academics & Grading (CBSE Conformance)
*Strict compliance with CBSE examination terminology. No arbitrary term names.*

- **CBSE 4-Term Assessment Windows:**
  1. **First Assessment:** Periodic Assessment 1 (50 Marks max).
  2. **Half Yearly:** Mid-Year Comprehensive Examination (100 Marks max).
  3. **Second Assessment:** Periodic Assessment 2 (50 Marks max).
  4. **Final Exam:** Annual / Year-End Board Evaluation (100 Marks max).
- **Report Card:** Official CBSE scholastic progress report containing term scores, co-scholastic grades, and homeroom remarks.
- **Marks Entry Desk:** Faculty workspace for entering, reviewing, and publishing subject assessment scores.
- **Academic Session:** The designated school year formatted strictly as `YYYY-YY` (e.g., `Session 2026-27`).

---

### B. Attendance & Roll Call
- **Daily Roll Call:** Class teacher's morning attendance registration workflow.
- **Roll Call Register:** Official class attendance log synchronized with administration.
- **4-State Attendance Matrix (Hard Rule):**
  - **Present (P):** Student attending class in person.
  - **Absent (A):** Unexcused absence.
  - **Late (L):** Arrived after morning assembly bell.
  - **On Leave / Excused (E):** Approved prior leave or medical absence.
- **Monthly Attendance Matrix:** High-density calendar grid visualizing daily student presence and percentage thresholds.

---

### C. Faculty, Classes & Timetable
- **Homeroom Teacher / Class Teacher:** Designated mentor with operational responsibility over a single class section.
- **Subject Teacher:** Specialized instructor managing specific subject courses across multiple sections.
- **Class / Section:** An assigned student group (e.g., `Class 9-B`, `Class 10-A`).
- **Timetable Slot:** Designated period block linking day, period index, subject, and instructor.
- **Faculty Allocation Matrix:** Comprehensive ledger showing teaching workload, weekly period distribution, and section assignments.
- **Zero Fabricated Staff IDs (Hard Rule):** Staff displayed by official Name + Designation/Subject (e.g., `Mrs. Anita Desai • Mathematics`).
- **Zero Room Numbers (Hard Rule):** Classes occupy dedicated homerooms; periods reference subject and teacher only.

---

### D. Fees & Financials
- **Fee Ledger & Dues:** Read-only institutional summary of charges, concessions, and outstanding dues.
- **Read-Only Dues (Hard Rule):** In-app payment gateways are prohibited; screens display audited dues summaries and official clearance statuses only.
- **Fee Payment Receipt Voucher:** Official signed receipt issued upon payment reconciliation by the accounts office.
- **Head-Wise Breakdown:** Line-item division of charges (Tuition, Computer & STEM Lab, Transit, Library, Examination Fee).

---

### E. Transit & Inventory Logistics
- **Transit Route:** Numbered school bus transit line (e.g., `Safe Transit Route #4`).
- **Stop Timeline:** Chronological sequence of pickup/drop stops with scheduled morning and evening arrival times.
- **Central Supplies Desk / Inventory Desk:** Operations workspace tracking institutional consumables.
- **Reorder Threshold:** Minimum unit stock level triggering a low-stock alert.
- **Catalog Item:** Single inventory commodity tracked with quantity and unit of measurement.

---

### F. Notices, Circulars & Governance
- **Notice Board:** Moderated board of official institutional broadcasts.
- **Circular Authoring Desk:** Administrative drafting tool for publishing announcements to targeted audiences (Parents, Faculty, Students).
- **Approval Queue:** Principal moderation workflow for reviewing draft circulars before public dispatch.
- **Gazetted Holidays Calendar:** Institutional roster of national, regional, and restricted holidays.
- **Zero Telecom SMS (Hard Rule):** School notices are transmitted strictly via email and in-app push notifications.

---

### G. Auth & Governance
- **Secure Login Gateway:** Unified branded entry screen for credential submission.
- **Morning Briefing Sequence:** Dynamic animated 3-step operational briefing displayed immediately following teacher/principal authentication.
- **Universal Role Switcher:** Multi-persona bottom sheet enabling staff to switch between authorized operational roles.
- **Device Management:** Security panel displaying active login tokens, IP locations, and remote session revocation controls.

---

## 4. Microcopy & Formatting Rules

| Domain | Rule | Correct Example | Incorrect Example |
| :--- | :--- | :--- | :--- |
| **Student Dossier** | Use *Student File* | `Student 360 File` | `Student Dossier` |
| **PDF Button** | Use *Student File PDF* | `Student File PDF` | `Dossier PDF` |
| **Exam Term** | Use exact CBSE term | `Half Yearly` | `Mid-Term Exam` |
| **Exam Term** | Use exact CBSE term | `First Assessment` | `Unit Test 1` |
| **Staff Title** | Name + Designation | `Robert Chen (Physics)` | `FAC-0842 Robert Chen` |
| **Roll Call** | 4 letters only | `P`, `A`, `L`, `E` | `Present`, `Half-day` |
| **Session** | YYYY-YY with prefix | `Session 2026-27` | `2026/2027` |
