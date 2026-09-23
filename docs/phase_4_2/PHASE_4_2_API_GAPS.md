# Phase 4.2 API Gaps & Backend Integration Matrix

## Current Status
All Batch A requirements utilized existing live backend endpoints:
- `POST /api/v1/auth/login/`: User credentials authentication
- `GET /api/v1/account/profile/`: Authenticated user profile (ID, username, email, full_name, role, mobile_number)
- `POST /api/v1/auth/logout/`: Token invalidation

## Batch A Gaps
- None. Backend contracts fully satisfied authentication and user identity display. Institutional configuration (`AppConfig`) cleanly encapsulates school name, academic session, CBSE affiliation, and campus address.

## Batch B Investigation & Endpoints to Reuse
For Batch B (Student / Academic), the following live production Django endpoints will be reused:
1. `GET /api/v1/students/` (`StudentApiService.getStudents()`):
   - Already live and paginated. Replaces `MockData.students` in `all_students_ledger_screen.dart` and `marks_entry_desk_screen.dart`.
2. `GET /api/v1/classes/<id>/students/` (`FacultyApiService.getClassStudents(classId)`):
   - Returns live enrolled students for a section. Replaces `MockData.students` in `class_teacher_dashboard_screen.dart`.
3. `GET /api/v1/classes/<id>/summary/` (`FacultyApiService.getClassSummary(classId)`):
   - Returns live class enrollment, attendance KPI, and class teacher details. Replaces `MockData.classes` in class teacher dashboard.
4. `GET /api/v1/students/<id>/report-card/`:
   - Live report card API. Replaces static `MockData.studentMarks` in `academic_report_card_screen.dart`.
5. `GET /api/v1/faculty/staff/` (`FacultyApiService.getStaffDirectory()`):
   - Live staff records. Replaces `MockData.teachers` lookups.

## Batch C Endpoints Reused & Verified
1. `GET /api/v1/fees/receipt/<id>/` / `GET /api/v1/fees/receipts/<id>/` (`FeeApiService.getFeeReceipt(id)`):
   - Returns official signed receipt voucher payload (`receipt_no`, `student_name`, `admission_no`, `amount`, `payment_mode`, `date`, `fee_head`, `remarks`).
   - Integrated into `FeeReceiptScreen` via `FeePayment` model with full empty / error state handling.
2. `GET /api/v1/accounts/dashboard/` (`AccountantApiService.getDashboard()`):
   - Returns institutional revenue metrics (`total_dues_collected`, `total_outstanding_dues`, `total_expected`, `recent_transactions`, payment mode breakdown).
   - Integrated into `AccountantDashboardScreen`.
3. `GET /api/v1/fees/ledger/` (`FeeApiService.getFeeLedger()`):
   - Returns fee transactions list and student ledger summaries. Reused as a robust fallback for transaction history when needed.

## Batch C Gaps
- None. Backend contracts fully satisfy accountant overview and fee receipt generation requirements. Institutional branding cleanly references `AppConfig.schoolName` and `AppConfig.campusAddress`.

