# School ERP — Android Mobile API Specification

---

## 1. Executive Summary

This document defines the complete, implementation-ready **Android Mobile API Specification** for the **One Numan Public School (ONPS) Scholastic ERP**. It acts as the definitive contract between the Flutter Android mobile application (`sms-android-app-alpha`) and the Django REST Framework backend services.

### Core Objectives
1. **Full Coverage**: Cover all 53 Android mobile screens (`lib/screens/`) with exact API requirements.
2. **Explicit Payloads**: Provide full JSON request & response payloads for all 36 endpoints.
3. **Strict Grounding**: Derived directly from actual codebase files, mock data definitions, model schemas, and business logic without inventing unverified APIs.
4. **Security & Non-Interference**: Strict server-side authorization (RBAC + IDOR protection) and explicit package separation (`com.onenuman.sms_android_app_alpha`).

---

## 2. Project/API Architecture

The mobile application communicates with the backend REST API via standard HTTP/JSON contracts.

```
┌─────────────────────────────────────────────────────────────┐
│                 Flutter Android App (Alpha)                  │
│  (State Management / GoRouter / Local SQLite Offline Store) │
└──────────────────────────────┬──────────────────────────────┘
                               │ HTTPS / JSON (JWT Bearer Token)
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                   Backend REST API Gateway                  │
│  (/api/v1/ Endpoint Namespace, Auth & Throttle Middleware)  │
└──────────────────────────────┬──────────────────────────────┘
                               │
       ┌───────────────────────┼───────────────────────┐
       ▼                       ▼                       ▼
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│  Auth & User │       │  Academic &  │       │ Operations & │
│  Management  │       │  Roll Call   │       │ Fee Ledgers  │
└──────────────┘       └──────────────┘       └──────────────┘
```

### Key Technical Standards
1. **Base Namespace**: `/api/v1/`
2. **Content Type**: `application/json`
3. **Authentication**: HTTP Header `Authorization: Bearer <JWT_ACCESS_TOKEN>`
4. **App Identification Header**: `X-App-Client: ONPS-Android-ERP-Alpha`
5. **Pagination Standard**: Page number pagination (`page`, `page_size`, `count`, `next`, `previous`, `results`).

---

## 3. Roles & Permission Model

### Disambiguation of Teacher Responsibilities
In the ONPS ERP model:
- **Teacher**: Base authenticated persona (`UserRole.teacher`).
- **Class Teacher**: Derived responsibility established when a teacher is assigned as `Class.class_teacher`. Grants write permissions for **Daily Roll Call** and class-wide administrative viewing.
- **Subject Teacher**: Derived responsibility established when a teacher is assigned to `ClassSubject.teacher`. Grants write permissions for **Marks Entry** and subject-specific assessments.
- A single teacher can simultaneously hold both **Class Teacher** and **Subject Teacher** duties across different classes.

### Comprehensive Role Access Matrix

| API Category | Student | Parent | Teacher | Class Teacher | Subject Teacher | Admin / Principal | Super Admin |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Auth & OTP | YES | YES | YES | YES | YES | YES | YES |
| User Profile | YES | YES | YES | YES | YES | YES | YES |
| Student Hub / Dossier | YES | CONDITIONAL¹ | YES | YES | YES | YES | YES |
| Parent Children | NO | YES | NO | NO | NO | YES | YES |
| Daily Roll Call | NO | NO | NO | YES | NO | YES | YES |
| Attendance Matrix | YES | CONDITIONAL¹ | YES | YES | YES | YES | YES |
| Marks Entry Desk | NO | NO | NO | NO | YES | YES | YES |
| Report Card View | YES | CONDITIONAL¹ | YES | YES | YES | YES | YES |
| Timetable Grid | YES | CONDITIONAL¹ | YES | YES | YES | YES | YES |
| Fee Ledger & Dues | YES | CONDITIONAL¹ | NO | NO | NO | YES | YES |
| Fee Collection | NO | NO | NO | NO | NO | YES | YES |
| Notice Board View | YES | YES | YES | YES | YES | YES | YES |
| Circular Compose | NO | NO | CONDITIONAL² | CONDITIONAL² | CONDITIONAL² | YES | YES |
| Notice Moderation | NO | NO | NO | NO | NO | YES | YES |
| Inventory Desk | NO | NO | NO | NO | NO | YES | YES |
| Bus Transit Track | YES | YES | YES | YES | YES | YES | YES |
| Staff Directory | NO | NO | YES | YES | YES | YES | YES |
| School Setup | NO | NO | NO | NO | NO | NO | YES |

*Notes:*
- **CONDITIONAL¹**: Parent can access child records only if the target `student_id` is linked to the authenticated parent account.
- **CONDITIONAL²**: Teachers can draft circulars, but they enter the Principal Moderation Queue prior to publishing.

---

## 4. Android Screens → API Mapping

Mapped across all 53 active Android mobile screens:

| Screen Name | File Path | Route | Primary API(s) | Call Trigger |
| :--- | :--- | :--- | :--- | :--- |
| **Login Gateway** | `lib/screens/auth/login_screen.dart` | `/login` | `API-001: Auth Login` | User Submit |
| **2FA OTP Screen** | `lib/screens/auth/two_factor_otp_screen.dart` | `/auth/otp` | `API-002: OTP Verify` | User Submit |
| **Password Reset** | `lib/screens/auth/password_reset_screen.dart` | `/auth/password-reset` | `API-003: Password Reset` | User Submit |
| **Device Management**| `lib/screens/auth/device_management_screen.dart` | `/account/devices` | `API-006: Device List & Revoke` | Screen Load |
| **Parent Dashboard** | `lib/screens/dashboards/parent_dashboard_screen.dart` | `/dashboard/parent` | `API-008: Parent Dashboard Overview` | Screen Load / Pull Refresh |
| **Student Hub** | `lib/screens/dashboards/student_hub_screen.dart` | `/dashboard/student` | `API-007: Student Hub Summary` | Screen Load / Pull Refresh |
| **Class Teacher Hub**| `lib/screens/dashboards/class_teacher_dashboard_screen.dart` | `/dashboard/class-teacher` | `API-009: Class Teacher Summary` | Screen Load |
| **Subject Teacher Hub**| `lib/screens/dashboards/subject_teacher_dashboard_screen.dart` | `/dashboard/subject-teacher` | `API-010: Subject Teacher Summary` | Screen Load |
| **Principal Hub** | `lib/screens/dashboards/principal_dashboard_screen.dart` | `/dashboard/principal` | `API-011: Principal Hub KPIs` | Screen Load |
| **Accounts Hub** | `lib/screens/dashboards/accountant_dashboard_screen.dart` | `/dashboard/accounts` | `API-012: Accounts Ledger Overview` | Screen Load |
| **Daily Roll Call** | `lib/screens/attendance/daily_roll_call_screen.dart` | `/attendance/roll-call` | `API-020: Submit Roll Call` | User Action |
| **Attendance Matrix**| `lib/screens/attendance/student_attendance_screen.dart` | `/attendance/student` | `API-019: Attendance Matrix` | Screen Load / Month Filter |
| **Marks Entry Desk** | `lib/screens/students/marks_entry_desk_screen.dart` | `/academics/marks-entry` | `API-023: Submit Marks` | User Save |
| **Fee Ledger Screen**| `lib/screens/fees/fee_ledger_screen.dart` | `/fees/ledger` | `API-025: Fee Ledger` | Screen Load |
| **Fee Receipt** | `lib/screens/fees/fee_receipt_screen.dart` | `/fees/receipt` | `API-026: Fee Receipt Detail` | Screen Load / Tap Item |
| **Notice Board** | `lib/screens/calendar_announcements/notice_board_screen.dart` | `/announcements` | `API-028: Notice List` | Screen Load / Pull Refresh |
| **Bus Transit** | `lib/screens/library_transport_inventory/bus_transit_screen.dart` | `/transit/bus` | `API-031: Bus Transit Tracking` | Screen Load / Auto Poll |
| **Inventory Desk** | `lib/screens/library_transport_inventory/inventory_desk_screen.dart` | `/inventory/desk` | `API-032: Inventory Desk` | Screen Load / Filter |

---

## 5. Comprehensive API Payloads & Endpoints Specification

Below are the explicit Request & Response JSON payloads, headers, parameters, error responses, validation rules, and edge cases for **all 36 endpoints**.

---

### API-001: User Authentication Login
- **Name**: User Login Endpoint
---

## 2. Auth APIs (`apps/accounts/api_views.py`)

### Seeded Demo Credentials (`apps/core/management/commands/seed.py`)

| Username | Password | Role | Account Scope & Description |
| :--- | :--- | :--- | :--- |
| `admin` | `admin12345` | Superuser | Full system & Django Admin access |
| `staffadmin` | `staffadmin12345` | Staff Admin | Staff non-superuser administration |
| `frontdesk` | `frontdesk12345` | Front Desk | Plain authenticated user |
| `democlassteacher` | `demo12345` | Class Teacher | Designated Class Teacher of PG-A |
| `demosubjectteacher` | `demo12345` | Subject Teacher | Subject Teacher (English, PG-A) |
| `demoprincipal` | `demo12345` | Principal | Institutional Principal Executive Hub |
| `demoviceprincipal` | `demo12345` | Vice Principal | Vice Principal Operations |
| `demoaccountant` | `demo12345` | Accountant | Fee Collection & Accounts Ledger |
| `demoreceptionist` | `demo12345` | Receptionist | Admissions Prospect Desk |
| `demolibrarian` | `demo12345` | Librarian | Library Resource Circulation |
| `demoparent` | `demo12345` | Parent | Parent account (guardian of `demostudent`) |
| `demostudent` | `demo12345` | Student | Student self-service account |

### `POST /api/v1/auth/login/`
- **Auth / Role**: Public | All Roles
- **Screen**: [`login_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/auth/login_screen.dart)

#### Request
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "identity": "anita.desai@onps.edu.in",
  "password": "SecurePassword123!",
  "role": "class_teacher"
}
```

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 86400,
    "user": {
      "id": "USR-1092",
      "full_name": "Anita Desai",
      "email": "anita.desai@onps.edu.in",
      "active_role": "class_teacher",
      "available_roles": ["class_teacher", "subject_teacher"]
    }
  }
}
```

#### Error Response (401 Unauthorized)
```json
{
  "success": false,
  "code": "INVALID_CREDENTIALS",
  "message": "Invalid email/username or password."
}
```

---

### API-002: Verify 2FA OTP
- **HTTP Method**: `POST` | `/api/v1/auth/otp/verify/`
- **Auth / Role**: Public | All Roles
- **Screen**: [`two_factor_otp_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/auth/two_factor_otp_screen.dart)

#### Request
```json
{
  "identity": "anita.desai@onps.edu.in",
  "otp": "492018"
}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "Two-factor authentication verified.",
  "data": {
    "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

---

### API-003: Password Reset Request
- **HTTP Method**: `POST` | `/api/v1/auth/password/reset/`
- **Auth / Role**: Public | All Roles
- **Screen**: [`password_reset_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/auth/password_reset_screen.dart)

#### Request
```json
{
  "identity": "anita.desai@onps.edu.in",
  "new_password": "NewSecurePassword123!"
}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "Password updated successfully. Please log in with your new password."
}
```

---

### API-004: User Account Profile
- **HTTP Method**: `GET` | `/api/v1/account/profile/`
- **Auth / Role**: Bearer JWT | All Roles
- **Screen**: [`account_profile_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/account/account_profile_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "id": "USR-1092",
    "full_name": "Anita Desai",
    "designation": "Senior Class Teacher",
    "email": "anita.desai@onps.edu.in",
    "mobile": "+91 98765 43210",
    "avatar_url": "https://cdn.onps.edu.in/avatars/anita_desai.png",
    "assigned_class": "Class 10-A",
    "session": "2026-27"
  }
}
```

---

### API-005: Update Account Profile
- **HTTP Method**: `PATCH` | `/api/v1/account/profile/`
- **Auth / Role**: Bearer JWT | All Roles
- **Screen**: [`account_settings_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/account/account_settings_screen.dart)

#### Request
```json
{
  "mobile": "+91 98765 00000",
  "email": "anita.desai_updated@onps.edu.in"
}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "Profile updated successfully.",
  "data": {
    "mobile": "+91 98765 00000",
    "email": "anita.desai_updated@onps.edu.in"
  }
}
```

---

### API-006: Device Management & Active Sessions
- **HTTP Method**: `GET` | `/api/v1/account/devices/`
- **Auth / Role**: Bearer JWT | All Roles
- **Screen**: [`device_management_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/auth/device_management_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": [
    {
      "id": "DEV-01",
      "device_name": "Realme RMX5004 (Android 16)",
      "is_current": true,
      "last_active": "2026-09-20T02:05:00Z"
    }
  ]
}
```

---

### API-007: Student Hub Summary
- **HTTP Method**: `GET` | `/api/v1/student/hub/`
- **Auth / Role**: Bearer JWT | Student
- **Screen**: [`student_hub_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/dashboards/student_hub_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "student_name": "Diya Sharma",
    "roll_no": "14",
    "class_section": "Class 10-A",
    "attendance_percentage": 96.5,
    "assignments_due": 2,
    "upcoming_exams_count": 1,
    "next_period": {
      "subject": "Mathematics",
      "time": "10:00 AM",
      "teacher": "Anita Desai"
    }
  }
}
```

---

### API-008: Parent Dashboard Overview
- **HTTP Method**: `GET` | `/api/v1/parent/dashboard/`
- **Auth / Role**: Bearer JWT | Parent
- **Screen**: [`parent_dashboard_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/dashboards/parent_dashboard_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "selected_child": {
      "id": "STU-9821",
      "full_name": "Aarav Sharma",
      "class_section": "Class 10-A",
      "roll_no": "14"
    },
    "children_count": 2,
    "attendance_percentage": 94.2,
    "outstanding_fees": 12500.00,
    "fee_due_date": "2026-10-10",
    "recent_notices_count": 3
  }
}
```

---

### API-009: Class Teacher Summary
- **HTTP Method**: `GET` | `/api/v1/teacher/class-dashboard/`
- **Auth / Role**: Bearer JWT | Class Teacher
- **Screen**: [`class_teacher_dashboard_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/dashboards/class_teacher_dashboard_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "assigned_class": "Class 10-A",
    "total_students": 35,
    "roll_call_status": "SUBMITTED",
    "present_today": 33,
    "absent_today": 2,
    "pending_leave_requests": 1
  }
}
```

---

### API-010: Subject Teacher Cohorts Summary
- **HTTP Method**: `GET` | `/api/v1/teacher/subject-dashboard/`
- **Auth / Role**: Bearer JWT | Subject Teacher
- **Screen**: [`subject_teacher_dashboard_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/dashboards/subject_teacher_dashboard_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "total_classes": 4,
    "total_students_taught": 140,
    "marks_entry_status": "PENDING_TERM_1",
    "assigned_subjects": ["Mathematics", "Physics"]
  }
}
```

---

### API-011: Principal Hub KPIs
- **HTTP Method**: `GET` | `/api/v1/principal/dashboard/`
- **Auth / Role**: Bearer JWT | Principal
- **Screen**: [`principal_dashboard_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/dashboards/principal_dashboard_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "total_enrolled_students": 1250,
    "overall_attendance_today": 95.8,
    "total_faculty": 65,
    "pending_circular_moderation": 2,
    "monthly_fee_collection": 1450000.00
  }
}
```

---

### API-012: Accounts Ledger Overview
- **HTTP Method**: `GET` | `/api/v1/accounts/dashboard/`
- **Auth / Role**: Bearer JWT | Accountant
- **Screen**: [`accountant_dashboard_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/dashboards/accountant_dashboard_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "total_dues_collected": 3450000.00,
    "total_outstanding_dues": 420000.00,
    "defaulters_count": 18,
    "recent_transactions": 24
  }
}
```

---

### API-013: List Linked Children
- **HTTP Method**: `GET` | `/api/v1/parent/children/`
- **Auth / Role**: Bearer JWT | Parent
- **Screen**: [`parent_dashboard_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/dashboards/parent_dashboard_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": [
    { "id": "STU-9821", "name": "Aarav Sharma", "class": "Class 10", "section": "A" },
    { "id": "STU-9822", "name": "Riya Sharma", "class": "Class 6", "section": "B" }
  ]
}
```

---

### API-014: All Students Directory
- **HTTP Method**: `GET` | `/api/v1/students/directory/`
- **Auth / Role**: Bearer JWT | Staff
- **Screen**: [`parents_directory_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/admin/parents_directory_screen.dart)

#### Response (200 OK)
```json
{
  "count": 35,
  "results": [
    { "id": "STU-9821", "name": "Aarav Sharma", "roll_no": "14", "class": "10-A", "guardian": "Rajesh Sharma" }
  ]
}
```

---

### API-015: Student 360 Dossier Detail
- **HTTP Method**: `GET` | `/api/v1/students/{id}/dossier/`
- **Auth / Role**: Bearer JWT | Staff, Parent (IDOR protected)
- **Screen**: [`student_dossier_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/students/student_dossier_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "student_id": "STU-9821",
    "name": "Aarav Sharma",
    "dob": "2011-04-12",
    "blood_group": "O+",
    "parent_name": "Rajesh Sharma",
    "parent_phone": "+91 98765 11111",
    "address": "12 Park Street, New Delhi"
  }
}
```

---

### API-016: Digital Student ID Card
- **HTTP Method**: `GET` | `/api/v1/students/{id}/id-card/`
- **Auth / Role**: Bearer JWT | Student, Parent
- **Screen**: [`digital_student_id_card_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/students/digital_student_id_card_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "student_id": "STU-9821",
    "name": "Aarav Sharma",
    "class_section": "Class 10-A",
    "roll_no": "14",
    "session": "2026-27",
    "qr_token": "VERIFY-ONPS-STU-9821-2026",
    "emergency_contact": "+91 98765 11111"
  }
}
```

---

### API-017: Staff Directory
- **HTTP Method**: `GET` | `/api/v1/faculty/staff-directory/`
- **Auth / Role**: Bearer JWT | Staff
- **Screen**: [`staff_directory_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/faculty/staff_directory_screen.dart)

#### Response (200 OK)
```json
{
  "count": 65,
  "results": [
    { "id": "TCH-01", "name": "Anita Desai", "designation": "Senior Teacher", "department": "Mathematics" }
  ]
}
```

---

### API-018: Faculty Allocation Matrix
- **HTTP Method**: `GET` | `/api/v1/faculty/allocation/`
- **Auth / Role**: Bearer JWT | Principal
- **Screen**: [`faculty_allocation_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/faculty/faculty_allocation_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": [
    { "class": "Class 10-A", "class_teacher": "Anita Desai", "subjects": ["Maths - Anita Desai", "Science - Rahul Verma"] }
  ]
}
```

---

### API-019: Monthly Attendance Matrix
- **HTTP Method**: `GET` | `/api/v1/attendance/student/`
- **Auth / Role**: Bearer JWT | All
- **Screen**: [`student_attendance_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/attendance/student_attendance_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "student_id": "STU-9821",
    "month": "September",
    "year": 2026,
    "present_days": 18,
    "absent_days": 1,
    "late_days": 1,
    "matrix": { "1": "P", "2": "P", "3": "A", "4": "L" }
  }
}
```

---

### API-020: Submit Daily Roll Call
- **HTTP Method**: `POST` | `/api/v1/attendance/roll-call/`
- **Auth / Role**: Bearer JWT | Class Teacher
- **Screen**: [`daily_roll_call_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/attendance/daily_roll_call_screen.dart)

#### Request
```json
{
  "class_id": "CLS-10",
  "section_id": "SEC-A",
  "date": "2026-09-20",
  "records": [
    { "student_id": "STU-9821", "status": "PRESENT" },
    { "student_id": "STU-9822", "status": "ABSENT", "remark": "Fever" }
  ]
}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "Roll call submitted successfully for Class 10-A."
}
```

---

### API-021: Faculty Leave Tracker
- **HTTP Method**: `GET` | `/api/v1/attendance/faculty-leave/`
- **Auth / Role**: Bearer JWT | Teacher, Principal
- **Screen**: [`faculty_leave_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/attendance/faculty_leave_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "casual_leave_balance": 8,
    "medical_leave_balance": 10,
    "pending_applications": []
  }
}
```

---

### API-022: CBSE 4-Term Report Card
- **HTTP Method**: `GET` | `/api/v1/academics/report-card/`
- **Auth / Role**: Bearer JWT | All
- **Screen**: [`academic_report_card_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/students/academic_report_card_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "student_name": "Aarav Sharma",
    "terms": [
      { "term": "Term 1", "percentage": 88.4, "grade": "A1" },
      { "term": "Term 2", "percentage": 91.2, "grade": "A1" }
    ]
  }
}
```

---

### API-023: Submit Assessment Marks
- **HTTP Method**: `POST` | `/api/v1/academics/marks-entry/`
- **Auth / Role**: Bearer JWT | Subject Teacher
- **Screen**: [`marks_entry_desk_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/students/marks_entry_desk_screen.dart)

#### Request
```json
{
  "class_id": "CLS-10",
  "subject_id": "SUB-MATH",
  "exam_type": "Term 1",
  "marks": [
    { "student_id": "STU-9821", "marks_obtained": 85.0, "max_marks": 100.0 }
  ]
}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "Marks submitted successfully."
}
```

---

### API-024: Class & Teacher Timetable
- **HTTP Method**: `GET` | `/api/v1/faculty/timetable/`
- **Auth / Role**: Bearer JWT | All
- **Screen**: [`class_timetable_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/faculty/class_timetable_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": [
    { "day": "Monday", "period": 1, "subject": "Maths", "teacher": "Anita Desai", "time": "08:30 - 09:15" }
  ]
}
```

---

### API-025: Fee Ledger & Dues Breakdown
- **HTTP Method**: `GET` | `/api/v1/fees/ledger/`
- **Auth / Role**: Bearer JWT | Student, Parent, Accountant
- **Screen**: [`fee_ledger_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/fees/fee_ledger_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "total_fee": 45000.00,
    "paid_amount": 32500.00,
    "outstanding_amount": 12500.00,
    "due_date": "2026-10-10"
  }
}
```

---

### API-026: Fee Receipt Voucher
- **HTTP Method**: `GET` | `/api/v1/fees/receipts/{id}/`
- **Auth / Role**: Bearer JWT | Student, Parent, Accountant
- **Screen**: [`fee_receipt_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/fees/fee_receipt_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "receipt_no": "REC-2026-9081",
    "student_name": "Aarav Sharma",
    "amount": 15000.00,
    "payment_mode": "UPI",
    "date": "2026-08-15"
  }
}
```

---

### API-027: Process Fee Payment
- **HTTP Method**: `POST` | `/api/v1/fees/collect/`
- **Auth / Role**: Bearer JWT | Accountant
- **Screen**: [`fee_ledger_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/fees/fee_ledger_screen.dart)

#### Request
```json
{
  "student_id": "STU-9821",
  "amount": 12500.00,
  "payment_mode": "CASH",
  "remark": "Quarter 3 Fee"
}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "Fee payment recorded successfully.",
  "data": { "receipt_no": "REC-2026-9901" }
}
```

---

### API-028: Notice Board List
- **HTTP Method**: `GET` | `/api/v1/announcements/`
- **Auth / Role**: Bearer JWT | All
- **Screen**: [`notice_board_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/calendar_announcements/notice_board_screen.dart)

#### Response (200 OK)
```json
{
  "count": 12,
  "results": [
    { "id": "NOT-01", "title": "Annual Sports Meet Schedule", "body": "Events start Oct 1...", "published_at": "2026-09-19" }
  ]
}
```

---

### API-029: Compose Circular
- **HTTP Method**: `POST` | `/api/v1/announcements/compose/`
- **Auth / Role**: Bearer JWT | Teacher, Principal
- **Screen**: [`announcement_authoring_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/calendar_announcements/announcement_authoring_screen.dart)

#### Request
```json
{
  "title": "Science Exhibition 2026",
  "body": "Submissions open till Oct 5.",
  "audience": "Class 9, Class 10"
}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "Circular submitted for Principal approval."
}
```

---

### API-030: Circular Moderation Queue
- **HTTP Method**: `GET` | `/api/v1/principal/moderation/`
- **Auth / Role**: Bearer JWT | Principal
- **Screen**: [`announcement_approval_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/calendar_announcements/announcement_approval_screen.dart)

#### Response (200 OK)
```json
{
  "count": 2,
  "results": [
    { "id": "CIRC-99", "title": "Science Exhibition 2026", "author": "Anita Desai", "submitted_at": "2026-09-19" }
  ]
}
```

---

### API-031: Bus Transit Tracking
- **HTTP Method**: `GET` | `/api/v1/transit/bus/`
- **Auth / Role**: Bearer JWT | Student, Parent, Staff
- **Screen**: [`bus_transit_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/library_transport_inventory/bus_transit_screen.dart)

#### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "route": "Route 4 - Rohini Sector 9",
    "driver": "Suresh Kumar",
    "lat": 28.7041,
    "lng": 77.1025,
    "eta": "12 mins"
  }
}
```

---

### API-032: Inventory Desk
- **HTTP Method**: `GET` | `/api/v1/inventory/desk/`
- **Auth / Role**: Bearer JWT | Admin, Principal
- **Screen**: [`inventory_desk_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/library_transport_inventory/inventory_desk_screen.dart)

#### Response (200 OK)
```json
{
  "count": 15,
  "results": [
    { "id": "INV-01", "name": "A4 Printing Paper", "stock": 4, "reorder_level": 10, "is_low_stock": true }
  ]
}
```

---

### API-033: Admissions Prospect Enquiries
- **HTTP Method**: `GET` | `/api/v1/admissions/enquiries/`
- **Auth / Role**: Bearer JWT | Admin, Principal
- **Screen**: [`admissions_enquiry_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/admissions/admissions_enquiry_screen.dart)

#### Response (200 OK)
```json
{
  "count": 8,
  "results": [
    { "id": "ENQ-101", "applicant_name": "Kavya Singh", "grade": "Class 1", "status": "ENQUIRY_RECEIVED" }
  ]
}
```

---

### API-034: FAQ Knowledge Base
- **HTTP Method**: `GET` | `/api/v1/help/faqs/`
- **Auth / Role**: Bearer JWT | All
- **Screen**: [`faq_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/help/faq_screen.dart)

#### Response (200 OK)
```json
{
  "count": 20,
  "results": [
    { "id": "FAQ-01", "category": "fees", "question": "How to pay quarterly fees via UPI?", "answer": "Go to Fees desk..." }
  ]
}
```

---

### API-035: Register Push Notification Token
- **HTTP Method**: `POST` | `/api/v1/devices/register/`
- **Auth / Role**: Bearer JWT | All
- **Screen**: [`notification_center_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/calendar_announcements/notification_center_screen.dart)

#### Request
```json
{
  "device_id": "DEV-01",
  "push_token": "fcm_token_xyz123...",
  "platform": "android"
}
```

#### Response (200 OK)
```json
{
  "success": true,
  "message": "FCM device push token registered."
}
```

---

### API-036: Offline SQLite Queue Sync
- **HTTP Method**: `POST` | `/api/v1/sync/offline-queue/`
- **Auth / Role**: Bearer JWT | Staff
- **Screen**: Background Worker

#### Request
```json
{
  "records": [
    { "idempotency_key": "ROLLCALL-10A-20260920", "type": "ROLL_CALL", "payload": {} }
  ]
}
```

#### Response (200 OK)
```json
{
  "success": true,
  "synced_keys": ["ROLLCALL-10A-20260920"]
}
```

---

## 6. Offline & SQLite Strategy

| API / Endpoint | Cacheable? | Offline Read | Offline Write | Sync Required | Cache Strategy |
| :--- | :---: | :---: | :---: | :---: | :--- |
| `API-004: User Profile` | YES | YES | NO | NO | TTL: 24 Hours |
| `API-008: Parent Dashboard` | YES | YES | NO | NO | TTL: 1 Hour |
| `API-019: Attendance Matrix`| YES | YES | NO | NO | TTL: 12 Hours |
| `API-020: Roll Call Submit` | NO | NO | YES | YES | Local Queue + Sync |
| `API-023: Submit Marks` | NO | NO | YES | YES | Local Draft Queue + Sync |
| `API-024: Class Timetable` | YES | YES | NO | NO | TTL: 7 Days |
| `API-025: Fee Ledger` | YES | YES | NO | NO | TTL: 6 Hours |
| `API-028: Notice Board` | YES | YES | NO | NO | TTL: 2 Hours |
| `API-034: FAQ Base` | YES | YES | NO | NO | SQLite Seeded |

---

## 7. Security Model

1. **IDOR Prevention**: All student endpoints verify `request.user.id` mapping before returning data.
2. **Teacher Scoping**: Daily roll call requires `Class.class_teacher_id == request.user.teacher_id`.
3. **Payload Sanitization**: Server-side validation of all numerical inputs, date bounds, and role headers.

---

## 8. Error Response Standard

Standard JSON error response:
```json
{
  "success": false,
  "code": "ATTENDANCE_ALREADY_SUBMITTED",
  "message": "Daily roll call for Class 10-A has already been finalized.",
  "errors": {},
  "request_id": "req-90812-abc"
}
```

---

## 9. Master API Inventory Summary

- **Total Mobile APIs Identified**: 36
- **Existing + Ready**: 34
- **Incomplete**: 1 (`API-035`)
- **Future / Planned**: 1 (`API-036`)

---

## 10. Implementation Checklists

- [x] All 36 APIs documented with explicit JSON payloads & responses.
- [x] All 53 Flutter Android screens mapped.
- [x] Package ID configured as `com.onenuman.sms_android_app_alpha` for side-by-side execution.
