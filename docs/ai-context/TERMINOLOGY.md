# ONPS School ERP — Approved Terminology & Lexicon (`TERMINOLOGY.md`)

> **Lexicon Standard**: Strict compliance with K-12 Indian / CBSE school conventions.

---

## 1. Mandated Term Replacements (Banned vs. Approved Terms)

| Banned / Prohibited Term | Approved Institutional Term | Context & Placement |
| :--- | :--- | :--- |
| ❌ **Dossier** / **Student Dossier** | ✅ **Student File** / **Student 360 File** | All user interfaces, PDF export buttons, bottom sheets, and screen titles. |
| ❌ **Cohort** / **Cohorts** | ✅ **Class** / **Class List** | Grade/Section student groupings and faculty teaching assignments. |
| ❌ **Roster** | ✅ **Student List** / **Class List** / **Register** | Student directory ledgers, roll call register, and section enrollments. |
| ❌ **Applicant Dossier** | ✅ **Applicant File** | Admissions and enrollment review desks. |
| ❌ **Unit Test 1 / Mid-Term** | ✅ **First Assessment / Half Yearly** | Examination term labels (strictly CBSE 4-Term Pattern). |
| ❌ **Faculty-0842** | ✅ **Mrs. Anita Desai (Mathematics)** | Staff identification (Name + Designation/Subject only, 0 fabricated IDs). |
| ❌ **Room 304** | ✅ **Class 5-A** | Class section locations (Homeroom pattern, 0 arbitrary room numbers). |

---

## 2. Technical Identifiers vs. User Microcopy
- **Rule**: Do NOT rename Dart variable names, model class fields, or database column names that already exist in code (e.g., `student_dossier_screen.dart`, `StudentDossierScreen`, `assignedCohort`).
- **User-Facing Strings**: Only user-visible text labels, App Top Bar titles, tooltips, dialogs, and exported PDF titles must display the approved institutional terminology.

---

## 3. CBSE Terminology Dictionary

### 3.1 Examination Terms
1. **First Assessment**: Periodic Assessment 1 (50 Marks).
2. **Half Yearly**: Mid-Year Comprehensive Exam (100 Marks).
3. **Second Assessment**: Periodic Assessment 2 (50 Marks).
4. **Final Exam**: Annual Year-End Evaluation (100 Marks).

### 3.2 Attendance Terms
- **Roll Call Register**: Daily morning attendance tracking workflow.
- **4-State Matrix**: `P` (Present), `A` (Absent), `L` (Late), `E` (Excused / On Leave).
