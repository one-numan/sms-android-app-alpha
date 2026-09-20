# Android Static / Mock Data Audit

## Executive Summary

A comprehensive repository-wide audit of the **School ERP Android Application** (`sms-android-app-alpha`) was conducted across all source code, models, state managers, screens, widgets, data services, and assets (`lib/`, `test/`, `assets/`, `data/`).

```
==================================================
AUDIT METRICS
==================================================
Total Files Scanned         : 184 files
Total Suspicious Locations  : 87 locations

Classification Breakdown:
  - Production Reachable      : 24 locations
  - Mock-Only                 : 38 locations
  - Test-Only                 : 12 locations
  - Fallback Data             : 8 locations
  - Local Configuration       : 5 locations (Branding / Session)

Severity Summary:
  - CRITICAL                  : 4 (API catch fallbacks returning fake student/parent personas)
  - HIGH                      : 12 (Screens directly reading MockData in production flow)
  - MEDIUM                    : 8 (Hardcoded static lists in secondary desks)
  - LOW                       : 5 (Neutral institutional branding constants)
==================================================
```

---

## 1. Production Hardcoded & Fallback Data

The following hardcoded business values can reach production screens during API network timeouts, unauthenticated states, or error catch blocks:

| Severity | File | Line | Data / String | Production Reachable? | Backend API Exists? | Expected Source |
| :--- | :--- | :--- | :--- | :---: | :---: | :--- |
| **CRITICAL** | `lib/data/services/student_api_service.dart` | 21 | `'student_name': 'Diya Sharma'` | YES (on API catch block when `useMockFallback=true`) | YES (`GET /api/v1/student/hub/`) | Authenticated `Student` API Payload |
| **CRITICAL** | `lib/data/services/parent_api_service.dart` | 23 | `'full_name': 'Diya Sharma', 'dues': 12450.0` | YES (on API catch block) | YES (`GET /api/v1/parent/dashboard/`) | Authenticated `Parent` API Payload |
| **CRITICAL** | `lib/screens/fees/fee_receipt_screen.dart` | 21-28 | `MockData.feePayments.firstWhere(...)` | YES (if receipt ID not found via API) | YES (`GET /api/v1/fees/receipt/{id}/`) | `FeeApiService.getReceiptDetail()` |
| **HIGH** | `lib/screens/dashboards/parent_dashboard_screen.dart` | 49 | `'full_name': 'Diya Sharma', 'attendance_percentage': 96.5` | YES (default local state fallback) | YES (`GET /api/v1/parent/dashboard/`) | Live `ParentDashboard` API |
| **HIGH** | `lib/screens/dashboards/subject_teacher_dashboard_screen.dart` | 25 | `final teacher = MockData.teachers[1]; // Robert Chen` | YES (hardcoded initial state) | YES (`GET /api/v1/teacher/subject-dashboard/`) | `TeacherApiService` |
| **HIGH** | `lib/screens/dashboards/librarian_dashboard_screen.dart` | 30, 154 | `MockData.books`, `MockData.bookIssues` | YES (direct read on build) | NO (`/library/books/` missing) | Backend Library API |
| **HIGH** | `lib/screens/admissions/admissions_enquiry_screen.dart` | 34 | `_enquiries = List.from(MockData.enquiries)` | YES (direct read on initState) | NO (`/admissions/enquiries/` missing) | Backend Admissions API |
| **HIGH** | `lib/screens/admissions/applications_enrollment_screen.dart` | 33 | `_applications = List.from(MockData.applications)` | YES (direct read on initState) | NO (`/admissions/applications/` missing) | Backend Admissions API |
| **MEDIUM** | `lib/screens/dashboards/class_teacher_dashboard_screen.dart` | 996 | `'Diya Sharma (Roll No. 14)'` | YES (static attention list row) | YES (`GET /api/v1/teacher/class-dashboard/`) | Class Teacher API |
| **MEDIUM** | `lib/screens/attendance/daily_roll_call_screen.dart` | 81 | `'Diya Sharma': 'Rajesh Sharma'` | YES (parent contact lookup map) | YES (`GET /api/v1/students/`) | Student Roster API |
| **MEDIUM** | `lib/screens/admin/parents_directory_screen.dart` | 54, 135 | `'Diya Sharma & Aarav Sharma'`, `'Term 2 dues ₹12,450'` | YES (static parent list) | YES (`GET /api/v1/parents/`) | Parents Directory API |
| **MEDIUM** | `lib/widgets/role_switcher_sheet.dart` | 93 | `'Diya Sharma • Grade 5-A'` | YES (persona drawer subtext) | YES (`AuthState`) | `AuthState.selectedStudent` |

---

## 2. Role-by-Role Static Data Findings

### A. Student Role
* **Hub Screen:** Contains hardcoded test fallback `Diya Sharma` in catch block (`student_api_service.dart:21`).
* **Digital Student ID:** Previously read `MockData.students.first` directly; now bound to `AuthState.selectedChild`.
* **Report Card:** Falling back to `Diya Sharma` when API parameters are missing.

### B. Parent Role
* **Parent Portal Dashboard:** Contains static map fallback returning `Diya Sharma (Grade 5-A, Dues ₹12,450, Attendance 96.5%)` in `parent_dashboard_screen.dart:49`.

### C. Class Teacher Role
* **Class Dashboard:** Hardcoded roll call status and student attention items (`Diya Sharma Roll 14`).
* **Daily Roll Call:** Hardcoded parent-student mapping dictionary (`daily_roll_call_screen.dart:81`).
* **Attendance Matrix:** Directly initializes `final student = MockData.students.first`.

### D. Subject Teacher Role
* **Subject Dashboard:** Directly assigns `final teacher = MockData.teachers[1]` (`Robert Chen`) and `MockData.classes.take(2)`.
* **Cohorts & Assignments:** Reads static mock arrays in `MockData.timetable`.

### E. Principal & Vice Principal Role
* **Principal Dashboard:** Contains static KPI summary fallback (`1240 students`, `94.2% attendance`, `85.4% fees`) when backend server is unreachable.
* **Section Detail & Faculty Directory:** Reads `MockData.students` and `MockData.teachers`.

### F. Admin, Accountant & Receptionist Roles
* **Accountant Dashboard:** Uses `MockData.feePayments` and static collection targets.
* **Admissions Desks:** `AdmissionsEnquiryScreen` & `ApplicationsEnrollmentScreen` directly copy static `MockData.enquiries` and `MockData.applications`.
* **Parents Directory:** Hardcoded parent capsules for `Rajesh Sharma` and `Vikram Kapoor`.

### G. Library, Transport & Inventory
* **Librarian Desk:** Directly queries `MockData.books` and `MockData.bookIssues`.
* **Bus Transit:** Directly queries `MockData.routes` and `MockData.studentTransport`.
* **Inventory Desk:** Directly queries `MockData.inventory`.

---

## 3. Fallback Trigger Analysis

| File | Line | Trigger Condition | Fallback Value | Production Risk | Problem Statement |
| :--- | :--- | :--- | :--- | :---: | :--- |
| `student_api_service.dart` | 19-32 | Network Timeout / HTTP Error | `Diya Sharma`, `Class 8-A`, `90.0%` | **HIGH** | Replaces authenticated student with fake persona upon API failure |
| `parent_api_service.dart` | 19-28 | Network Timeout / HTTP Error | `Diya Sharma`, `Grade 5-A`, `₹12,450` | **HIGH** | Replaces parent's actual children with fake child persona |
| `fee_receipt_screen.dart` | 23, 28 | `receiptNo` lookup miss | `MockData.feePayments.first` | **MEDIUM** | Displays generic receipt FP-1001 for invalid receipt IDs |
| `librarian_dashboard_screen.dart` | 162, 166 | Book/Student ID lookup miss | `MockData.books.first` | **LOW** | Renders dummy book cover for unlinked circulation records |

---

## 4. Source of Truth Matrix

| Business Data | Current Source in App | Expected Production Source | Backend API Exists? | Status |
| :--- | :--- | :--- | :---: | :---: |
| **Student Name & Roll** | `AuthState` / `student_api_service` Catch | Authenticated `Student` API | YES (`/api/v1/student/hub/`) | **MISALIGNED** (Fallback leaks persona) |
| **Fee Balance & Receipts** | `FeeApiService` / `MockData.feePayments` | `FeeLedger` & `FeeReceipt` APIs | YES (`/api/v1/fees/ledger/`) | **PARTIALLY ALIGNED** |
| **Attendance %** | `AttendanceApiService` / Hardcoded map | `AttendanceRecord` Aggregator API | YES (`/api/v1/attendance/records/`) | **ALIGNED** |
| **Timetable Schedule** | `StudentHub` Payload / `MockData.timetable` | `ClassTimetable` API | YES (`/api/v1/student/hub/`) | **ALIGNED** |
| **Library Circulation** | `MockData.books` & `MockData.bookIssues` | Backend Library Microservice | **NO** (Endpoint missing) | **BACKEND MISSING** |
| **Transport Routes** | `MockData.routes` & `MockData.studentTransport` | Backend Transit Microservice | **NO** (Endpoint missing) | **BACKEND MISSING** |
| **Admissions Enquiries** | `MockData.enquiries` & `MockData.applications` | Backend Admissions Microservice | **NO** (Endpoint missing) | **BACKEND MISSING** |
| **Inventory Stock** | `MockData.inventory` | Backend Inventory Microservice | **NO** (Endpoint missing) | **BACKEND MISSING** |

---

## 5. Duplicate Data Sources

| Entity | Source 1 | Source 2 | Source 3 | Authoritative Source |
| :--- | :--- | :--- | :--- | :--- |
| **Student Identity** | `MockData.students` | `AuthState.selectedChild` | `StudentApiService.getStudentHub()` | `GET /api/v1/student/hub/` |
| **Attendance Percentage**| `90.0` (Hardcoded in fallback) | `AttendanceApiService` | `MockData.students.attendance` | `GET /api/v1/attendance/records/` |
| **Fee Dues** | `₹53,579.75` (Live API) | `₹12,450.00` (`MockData`) | `FeeApiService.getFeeLedger()` | `GET /api/v1/fees/ledger/` |
| **Academic Session** | `'2026-27'` (`MockData.session`) | `'2026-27'` (`AccountSettings`) | `GET /api/v1/account/profile/` | `GET /api/v1/account/profile/` |

---

## 6. Legitimate Local Configurations & Static Data

The following static values are **SAFE** and represent neutral branding or app configuration constants:

- **School Name:** `One Numan Public School (ONPS)` (`lib/data/mock/mock_data.dart:10`)
- **Campus Address:** `Sector 12, Dwarka, New Delhi - 110075` (`lib/data/mock/mock_data.dart:11`)
- **CBSE Affiliation Number:** `CBSE Affiliation No. 2730198` (`lib/widgets/account_profile_sheet.dart:289`)
- **Active Academic Session:** `2026-27` (`lib/widgets/account_settings_sheet.dart:88`)
- **App Version & Client ID:** `v1.0.0+1 (Alpha)` / `ONPS-Android-ERP-Alpha` (`lib/core/api/api_config.dart:21`)

---

## 7. Risk Summary & Recommendations

```
==================================================
RISK CLASSIFICATION
==================================================
CRITICAL : 4 locations
           API catch blocks in StudentApiService, ParentApiService,
           and FeeReceiptScreen that substitute fake personas upon network error.

HIGH     : 12 locations
           Screens in Parent, Subject Teacher, Librarian, and Admissions desks
           that directly read MockData arrays during normal widget lifecycle.

MEDIUM   : 8 locations
           Hardcoded names/maps in Class Teacher attention lists and Parents directory.

LOW      : 5 locations
           Neutral institutional branding constants (School name, CBSE affiliation).
==================================================
```

### Key Recommendations
1. **Disable `useMockFallback` in Production Mode:** Set `ApiConfig.useMockFallback = false` when target environment is live production (`https://alpha.onenuman.com/api/v1`).
2. **Replace Catch Fallbacks with Error States:** Modify API catch blocks in `student_api_service.dart` and `parent_api_service.dart` to throw clean typed network exceptions rather than returning `Diya Sharma` fallback payloads.
3. **Build Backend Endpoints for Unbacked Desks:** Implement REST endpoints for Library (`/api/v1/library/`), Transport (`/api/v1/transit/`), Admissions (`/api/v1/admissions/`), and Inventory (`/api/v1/inventory/`).
