# BACKEND API SPECIFICATION FOR MOCKDATA ELIMINATION

**Target Application:** ONPS Scholastic Mobile ERP (`com.onenuman.sms_android_app_alpha`)  
**Date:** September 21, 2026  
**Purpose:** Technical specification of required Django REST Framework API endpoints, request payloads, response schemas, models, and edge cases to permanently replace `MockData` across all 14 remaining production screens.

---

## EXECUTIVE SUMMARY & ARCHITECTURE

The application requires **14 missing backend endpoints** under the base URI `/api/v1/`.

### Mandatory Standards Across All Endpoints
1. **Authentication:** Bearer JWT Token in `Authorization: Bearer <access_token>` header.
2. **Unauthorized Handling (HTTP 401):** Standard response `{ "detail": "Unauthorized session. Please log in again." }`. Mobile app clears session and redirects to `/login`.
3. **Forbidden Handling (HTTP 403):** Returned when user role lacks required permission. Response: `{ "detail": "Access denied for this resource." }`.
4. **Data Wrapper:** All responses wrap data in standard JSON object `{ "status": "success", "data": ... }` or DRF pagination envelope `{ "count": 100, "next": "...", "previous": "...", "results": [...] }`.

---

## 1. TEACHER TIMETABLE & CLASS TIMETABLE

### 1.1 Teacher Timetable Screen
- **Screen:** `TeacherTimetableScreen`
- **Route:** `/faculty/timetable/teacher`
- **Current Mock Source:** `MockData.timetable`, `MockData.teachers`

#### Endpoint: `GET /api/v1/faculty/timetable/teacher/`
- **Query Parameters:**
  - `teacher_id` (optional, string): Filter by specific teacher UUID. Defaults to active logged-in teacher.
  - `day_of_week` (optional, integer): `1` (Monday) to `6` (Saturday).
- **Request Headers:** `Authorization: Bearer <jwt_token>`

#### Expected Response Payload (HTTP 200)
```json
{
  "status": "success",
  "data": {
    "teacher_id": "TCH-2024-0012",
    "teacher_name": "Robert Chen",
    "department": "Science",
    "weekly_load": 24,
    "schedule": [
      {
        "id": "TSL-101",
        "day_of_week": 1,
        "day_name": "Monday",
        "period_number": 2,
        "start_time": "09:15 AM",
        "end_time": "10:00 AM",
        "class_id": "CLS-9B",
        "class_name": "Grade 9-B",
        "subject_code": "SCI-09",
        "subject_name": "Physics",
        "room_number": "Lab 2"
      }
    ]
  }
}
```

#### Edge Cases
- **No Timetable Assigned:** Return empty array `schedule: []` with `weekly_load: 0`. Render clean "No scheduled periods" UI.
- **Teacher Not Found (404):** `{ "detail": "Teacher profile not found." }`

---

### 1.2 Class Timetable Screen
- **Screen:** `ClassTimetableScreen`
- **Route:** `/faculty/timetable/class`
- **Current Mock Source:** `MockData.timetable`, `MockData.classes`

#### Endpoint: `GET /api/v1/faculty/timetable/class/`
- **Query Parameters:**
  - `class_id` (required, string): e.g. `CLS-5A` or `Grade 5-A`
  - `day_of_week` (optional, integer): `1` to `6`

#### Expected Response Payload (HTTP 200)
```json
{
  "status": "success",
  "data": {
    "class_id": "CLS-5A",
    "class_name": "Grade 5-A",
    "class_teacher": "Anita Desai",
    "total_periods_per_day": 8,
    "slots": [
      {
        "period_number": 1,
        "start_time": "08:30 AM",
        "end_time": "09:15 AM",
        "subject_name": "Mathematics",
        "teacher_name": "Suresh Gupta",
        "is_break": false
      },
      {
        "period_number": 4,
        "start_time": "11:00 AM",
        "end_time": "11:30 AM",
        "subject_name": "Recess / Lunch",
        "teacher_name": "",
        "is_break": true
      }
    ]
  }
}
```

#### Edge Cases
- **Invalid `class_id` (404):** Return `{ "detail": "Class not found." }`.
- **Unassigned Slots:** `subject_name: "Free Period"`, `teacher_name: ""`.

---

## 2. FACULTY ALLOCATION & STAFF DIRECTORY

### 2.1 Faculty Allocation Screen
- **Screen:** `FacultyAllocationScreen`
- **Route:** `/faculty/allocation`
- **Current Mock Source:** `MockData.teachers`, `MockData.classes`

#### Endpoint: `GET /api/v1/faculty/allocations/`
- **Query Parameters:**
  - `academic_year` (optional): e.g. `2026-2027`
  - `department` (optional): `Science`, `Mathematics`, `Humanities`

#### Expected Response Payload (HTTP 200)
```json
{
  "status": "success",
  "data": {
    "total_faculty": 42,
    "allocated_count": 40,
    "unallocated_count": 2,
    "allocations": [
      {
        "teacher_id": "TCH-001",
        "teacher_name": "Anita Desai",
        "designation": "Senior PGT",
        "department": "Mathematics",
        "assigned_class_teacher_of": "Grade 5-A",
        "subject_allocations": [
          { "class_name": "Grade 5-A", "subject": "Mathematics", "periods_per_week": 6 },
          { "class_name": "Grade 6-B", "subject": "Mathematics", "periods_per_week": 5 }
        ]
      }
    ]
  }
}
```

#### Mutation Endpoint: `POST /api/v1/faculty/allocations/assign/`
- **Request Body Payload:**
```json
{
  "teacher_id": "TCH-001",
  "class_id": "CLS-5A",
  "subject_id": "SUB-MATH-05",
  "is_class_teacher": true
}
```
- **Response (HTTP 200):** `{ "status": "success", "message": "Faculty allocation updated successfully." }`

#### Edge Cases
- **Conflict Warning (409 Conflict):** If teacher load exceeds maximum allowed (e.g. >30 periods/week), return HTTP 409 `{ "detail": "Teacher weekly load limit exceeded (Current: 30, Maximum: 30)." }`.

---

### 2.2 Staff Directory Screen
- **Screen:** `StaffDirectoryScreen`
- **Route:** `/faculty/staff`
- **Current Mock Source:** `MockData.teachers`

#### Endpoint: `GET /api/v1/faculty/staff/`
- **Query Parameters:**
  - `search` (optional): Name, ID, or mobile search term.
  - `role` (optional): `classTeacher`, `subjectTeacher`, `librarian`, `accountant`
  - `page` & `page_size`

#### Expected Response Payload (HTTP 200)
```json
{
  "count": 45,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": "TCH-2024-008",
      "full_name": "Robert Chen",
      "email": "robert.chen@onps.edu.in",
      "mobile": "+91 98765 43210",
      "department": "Science",
      "designation": "Head of Science Department",
      "joining_date": "2018-07-01",
      "status": "Active",
      "avatar_url": "https://cdn.onps.edu.in/avatars/tch_008.jpg"
    }
  ]
}
```

#### Edge Cases
- **Empty Search Query:** Returns `results: []`. Render clean empty state UI with "No faculty matching search criteria".

---

## 3. CLASS INFO & CLASS STUDENT DIRECTORY

### 3.1 Class Info Screen
- **Screen:** `ClassInfoScreen`
- **Route:** `/faculty/class-info`
- **Current Mock Source:** `MockData.classes`, `MockData.students`

#### Endpoint: `GET /api/v1/classes/<class_id>/summary/`
- **URL Path Parameter:** `class_id` (e.g., `CLS-5A`)

#### Expected Response Payload (HTTP 200)
```json
{
  "status": "success",
  "data": {
    "class_id": "CLS-5A",
    "grade": "5",
    "section": "A",
    "class_name": "Grade 5-A",
    "class_teacher": {
      "id": "TCH-001",
      "name": "Anita Desai",
      "mobile": "+91 98765 11111"
    },
    "total_students": 38,
    "boys_count": 20,
    "girls_count": 18,
    "room_number": "Room 204",
    "subjects": [
      { "subject_name": "Mathematics", "teacher_name": "Anita Desai", "periods_per_week": 6 },
      { "subject_name": "Science", "teacher_name": "Robert Chen", "periods_per_week": 5 }
    ]
  }
}
```

---

### 3.2 Class Student Directory Screen
- **Screen:** `ClassStudentDirectoryScreen`
- **Route:** `/faculty/class-students`
- **Current Mock Source:** `MockData.students`

#### Endpoint: `GET /api/v1/classes/<class_id>/students/`
- **Query Parameters:**
  - `search` (optional): Student name or roll number.

#### Expected Response Payload (HTTP 200)
```json
{
  "status": "success",
  "data": {
    "class_id": "CLS-5A",
    "class_name": "Grade 5-A",
    "students": [
      {
        "id": "ADM-2024-0412",
        "roll_number": 14,
        "full_name": "Diya Sharma",
        "gender": "Female",
        "guardian_name": "Rajesh Sharma",
        "guardian_mobile": "+91 98765 43210",
        "attendance_percentage": 96.5,
        "fee_status": "Clear"
      }
    ]
  }
}
```

---

## 4. STUDENT DOSSIER & DIGITAL STUDENT ID CARD

### 4.1 Student Dossier Screen
- **Screen:** `StudentDossierScreen`
- **Route:** `/student/dossier`
- **Current Mock Source:** `MockData.students`

#### Endpoint: `GET /api/v1/students/<student_id>/dossier/`

#### Expected Response Payload (HTTP 200)
```json
{
  "status": "success",
  "data": {
    "id": "ADM-2024-0412",
    "admission_number": "ADM-2024-0412",
    "roll_number": 14,
    "full_name": "Diya Sharma",
    "date_of_birth": "2015-08-14",
    "gender": "Female",
    "blood_group": "B+",
    "class_section": "Grade 5-A",
    "admission_date": "2024-04-01",
    "guardian_details": {
      "father_name": "Rajesh Sharma",
      "mother_name": "Sunita Sharma",
      "primary_contact": "+91 98765 43210",
      "email": "rajesh.sharma@example.com",
      "residential_address": "42, Heritage Park, Civil Lines, New Delhi - 110054"
    },
    "academic_summary": {
      "overall_percentage": 92.4,
      "rank_in_class": 3,
      "attendance_percentage": 96.5
    },
    "fee_summary": {
      "total_annual_fee": 48000.0,
      "amount_paid": 35550.0,
      "outstanding_dues": 12450.0
    }
  }
}
```

---

### 4.2 Digital Student ID Card Screen
- **Screen:** `DigitalStudentIdCardScreen`
- **Route:** `/student/id-card`
- **Current Mock Source:** `MockData.students`

#### Endpoint: `GET /api/v1/students/<student_id>/id-card/`

#### Expected Response Payload (HTTP 200)
```json
{
  "status": "success",
  "data": {
    "student_id": "ADM-2024-0412",
    "full_name": "Diya Sharma",
    "class_section": "Grade 5-A",
    "roll_number": "14",
    "date_of_birth": "14 Aug 2015",
    "blood_group": "B+",
    "emergency_contact": "+91 98765 43210",
    "valid_through": "March 2027",
    "barcode_data": "STU-ADM-2024-0412",
    "qr_code_payload": "https://verify.onps.edu.in/id/ADM-2024-0412",
    "photo_url": "https://cdn.onps.edu.in/students/diya_sharma.png"
  }
}
```

---

## 5. FACULTY LEAVE & ANNOUNCEMENT APPROVAL

### 5.1 Faculty Leave Screen
- **Screen:** `FacultyLeaveScreen`
- **Route:** `/attendance/faculty-leave`
- **Current Mock Source:** `MockData.leaves`

#### Endpoint: `GET /api/v1/attendance/faculty-leave/`
- **Query Parameters:** `status` (`pending`, `approved`, `rejected`), `teacher_id`

#### Expected Response Payload (HTTP 200)
```json
{
  "status": "success",
  "data": {
    "leave_balance": {
      "casual_leave_remaining": 6,
      "sick_leave_remaining": 8,
      "earned_leave_remaining": 12
    },
    "applications": [
      {
        "id": "LEV-2026-091",
        "teacher_name": "Robert Chen",
        "leave_type": "Casual Leave",
        "from_date": "2026-09-25",
        "to_date": "2026-09-26",
        "reason": "Attending Academic Research Conference",
        "substitute_teacher": "Anita Desai",
        "status": "Pending",
        "applied_on": "2026-09-20"
      }
    ]
  }
}
```

#### Mutation Endpoint: `POST /api/v1/attendance/faculty-leave/apply/`
- **Body:** `{ "leave_type": "Casual Leave", "from_date": "2026-09-25", "to_date": "2026-09-26", "reason": "..." }`

---

### 5.2 Announcement Approval Screen
- **Screen:** `AnnouncementApprovalScreen`
- **Route:** `/announcements/approval`
- **Current Mock Source:** `MockData.announcements`

#### Endpoint: `GET /api/v1/announcements/approval-desk/`
- **Query Parameters:** `status` (`pending_approval`, `approved`, `rejected`)

#### Expected Response Payload (HTTP 200)
```json
{
  "status": "success",
  "data": {
    "pending_count": 3,
    "announcements": [
      {
        "id": "ANC-MOD-042",
        "title": "Annual Inter-School Physics Olympiad 2026",
        "author": "Robert Chen (Science Dept)",
        "target_audience": "Grades 9 to 12",
        "content": "Registration opens tomorrow for the annual physics olympiad...",
        "submitted_at": "2026-09-21 10:30 AM",
        "priority": "High"
      }
    ]
  }
}
```

#### Mutation Endpoint: `POST /api/v1/announcements/approval-desk/<id>/action/`
- **Body:** `{ "action": "approve" }` or `{ "action": "reject", "rejection_reason": "Incomplete dates" }`

---

## 6. ADMISSIONS ENQUIRY & APPLICATIONS ENROLLMENT

### 6.1 Admissions Enquiry Screen
- **Screen:** `AdmissionsEnquiryScreen`
- **Route:** `/admissions/enquiry`
- **Current Mock Source:** `MockData.enquiries`

#### Endpoint: `GET /api/v1/admissions/enquiries/`
- **Query Parameters:** `status` (`new`, `in_progress`, `converted`, `closed`), `search`

#### Expected Response Payload (HTTP 200)
```json
{
  "count": 18,
  "results": [
    {
      "id": "ENQ-2026-0042",
      "parent_name": "Vikram Kapoor",
      "applicant_name": "Aarav Kapoor",
      "seeking_grade": "Grade 1",
      "mobile": "+91 98111 22233",
      "email": "vikram.k@example.com",
      "enquiry_date": "2026-09-18",
      "status": "New",
      "notes": "Inquired about school transport availability."
    }
  ]
}
```

---

### 6.2 Applications & Enrollment Screen
- **Screen:** `ApplicationsEnrollmentScreen`
- **Route:** `/admissions/applications`
- **Current Mock Source:** `MockData.applications`

#### Endpoint: `GET /api/v1/admissions/applications/`
- **Query Parameters:** `academic_session` (`2026-2027`), `stage` (`applied`, `interview_scheduled`, `accepted`, `enrolled`)

#### Expected Response Payload (HTTP 200)
```json
{
  "status": "success",
  "data": {
    "total_applications": 120,
    "enrolled_count": 84,
    "pending_review": 12,
    "applications": [
      {
        "application_number": "APP-2026-0142",
        "applicant_name": "Aarav Sharma",
        "grade_applied": "Grade 2-B",
        "parent_name": "Rajesh Sharma",
        "contact_number": "+91 98765 43210",
        "application_date": "2026-02-15",
        "status": "Interview Scheduled",
        "documents_verified": true
      }
    ]
  }
}
```

---

## 7. LIBRARIAN DASHBOARD & PARENTS DIRECTORY

### 7.1 Librarian Dashboard Screen
- **Screen:** `LibrarianDashboardScreen`
- **Route:** `/librarian/dashboard`
- **Current Mock Source:** `MockData.books`, `MockData.bookIssues`

#### Endpoint: `GET /api/v1/library/dashboard/`

#### Expected Response Payload (HTTP 200)
```json
{
  "status": "success",
  "data": {
    "total_titles": 1420,
    "total_copies": 4800,
    "active_loans": 312,
    "overdue_loans": 14,
    "active_issues": [
      {
        "issue_id": "ISS-8812",
        "book_title": "Concepts of Physics (Vol 1)",
        "isbn": "978-8177091877",
        "student_id": "ADM-2024-0412",
        "student_name": "Diya Sharma",
        "issue_date": "2026-09-10",
        "due_date": "2026-09-24",
        "is_overdue": false
      }
    ]
  }
}
```

---

### 7.2 Parents Directory Screen
- **Screen:** `ParentsDirectoryScreen`
- **Route:** `/parents/directory`
- **Current Mock Source:** `MockData.students`, `MockData.feePayments`

#### Endpoint: `GET /api/v1/parents/directory/`
- **Query Parameters:** `search` (Parent Name, Mobile, or Student ID), `class_id`

#### Expected Response Payload (HTTP 200)
```json
{
  "count": 140,
  "results": [
    {
      "parent_id": "PAR-9042",
      "parent_name": "Rajesh Sharma",
      "occupation": "Senior Software Architect",
      "primary_mobile": "+91 98765 43210",
      "email": "rajesh.sharma@example.com",
      "address": "42, Heritage Park, Civil Lines, New Delhi",
      "enrolled_children": [
        {
          "student_id": "ADM-2024-0412",
          "student_name": "Diya Sharma",
          "class_section": "Grade 5-A",
          "attendance_percentage": 96.5,
          "fee_status": "Term 2 Pending (₹12,450)"
        },
        {
          "student_id": "ADM-2024-0890",
          "student_name": "Aarav Sharma",
          "class_section": "Grade 2-B",
          "attendance_percentage": 94.2,
          "fee_status": "Term 2 Pending (₹8,950)"
        }
      ]
    }
  ]
}
```

---

## SUMMARY MATRIX FOR BACKEND DEVELOPERS

| # | Screen Name | Endpoint Path | HTTP Method | Auth Role Permitted |
|---|-------------|---------------|-------------|---------------------|
| 1 | Teacher Timetable | `/api/v1/faculty/timetable/teacher/` | `GET` | Teacher, Principal, Admin |
| 2 | Class Timetable | `/api/v1/faculty/timetable/class/` | `GET` | All Authenticated Roles |
| 3 | Faculty Allocation | `/api/v1/faculty/allocations/` | `GET`, `POST` | Principal, Vice Principal, Admin |
| 4 | Staff Directory | `/api/v1/faculty/staff/` | `GET` | Staff, Principal, Admin |
| 5 | Class Info | `/api/v1/classes/<id>/summary/` | `GET` | Teachers, Principal, Admin |
| 6 | Class Student Directory | `/api/v1/classes/<id>/students/` | `GET` | Class Teacher, Principal, Admin |
| 7 | Student Dossier | `/api/v1/students/<id>/dossier/` | `GET` | Parents, Teachers, Admin |
| 8 | Digital Student ID Card | `/api/v1/students/<id>/id-card/` | `GET` | Student, Parent, Admin |
| 9 | Faculty Leave | `/api/v1/attendance/faculty-leave/` | `GET`, `POST` | Teachers, Vice Principal, Principal |
| 10 | Announcement Approval | `/api/v1/announcements/approval-desk/` | `GET`, `POST` | Principal, Admin |
| 11 | Admissions Enquiry | `/api/v1/admissions/enquiries/` | `GET`, `POST` | Receptionist, Principal, Admin |
| 12 | Applications Enrollment | `/api/v1/admissions/applications/` | `GET`, `POST` | Receptionist, Principal, Admin |
| 13 | Librarian Dashboard | `/api/v1/library/dashboard/` | `GET`, `POST` | Librarian, Admin |
| 14 | Parents Directory | `/api/v1/parents/directory/` | `GET` | Accountant, Principal, Admin |
