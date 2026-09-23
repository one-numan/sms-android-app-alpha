# MockData Screen Audit Report

This report lists all screens and modules in the SMS Android application that currently rely on `MockData` instead of fetching dynamic data from backend API endpoints.

---

## 1. Faculty & Timetable Module
* **Faculty Timetable Screen** ([`teacher_timetable_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/faculty/teacher_timetable_screen.dart)): Teacher selection dropdowns and weekly period schedules.
* **Class Timetable Screen** ([`class_timetable_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/faculty/class_timetable_screen.dart)): Class-wise daily timetable slots and period allocations.
* **Faculty Allocation Desk** ([`faculty_allocation_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/faculty/faculty_allocation_screen.dart)): Teacher workload and subject assignment lists.
* **Staff Directory / Teachers List** ([`staff_directory_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/faculty/staff_directory_screen.dart), [`principal_teachers_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/faculty/principal_teachers_screen.dart)): Faculty profiles, departments, and contacts.
* **Class & Section Detail Screens** ([`class_info_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/faculty/class_info_screen.dart), [`class_student_directory_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/faculty/class_student_directory_screen.dart), [`principal_section_detail_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/faculty/principal_section_detail_screen.dart)): Class rosters, class teachers, and student list tables.

---

## 2. Students & Academics Module
* **All Students Ledger** ([`all_students_ledger_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/students/all_students_ledger_screen.dart)): Student directory, class filters, search lists, and active roll numbers.
* **Student Profile Dossier** ([`student_dossier_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/students/student_dossier_screen.dart)): Detailed student profile, guardian details, and health/attendance history.
* **Academic Report Card** ([`academic_report_card_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/students/academic_report_card_screen.dart)): Term marks breakdown, grade calculations, and attendance percentage summaries.
* **Marks Entry Desk** ([`marks_entry_desk_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/students/marks_entry_desk_screen.dart)): Exam list, subject mark entry tables, and grade submission forms.
* **Digital Student ID Card** ([`digital_student_id_card_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/students/digital_student_id_card_screen.dart)): ID card badge information and QR metadata.

---

## 3. Attendance & Leave Desk
* **Daily Roll Call Screen** ([`daily_roll_call_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/attendance/daily_roll_call_screen.dart)): Section-wise attendance marking list for students.
* **Faculty Leave Management** ([`faculty_leave_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/attendance/faculty_leave_screen.dart)): Staff leave requests, approval lists, and leave balance stats.

---

## 4. Announcements, Events & Calendar
* **Notice Board** ([`notice_board_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/calendar_announcements/notice_board_screen.dart)): School announcements and category-filtered circular notices.
* **Announcement Approval Desk** ([`announcement_approval_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/calendar_announcements/announcement_approval_screen.dart)): Pending announcement approvals for principals/admins.
* **Events Desk** ([`events_desk_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/calendar_announcements/events_desk_screen.dart)): Upcoming school events, dates, and event management lists.
* **Academic Calendar** ([`academic_calendar_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/calendar_announcements/academic_calendar_screen.dart)): Holiday list, academic term dates, and calendar events.

---

## 5. Admissions & Fee Desk
* **Admissions Enquiry Desk** ([`admissions_enquiry_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/admissions/admissions_enquiry_screen.dart)): Incoming student admission enquiries and lead status tracking.
* **Applications & Enrollment** ([`applications_enrollment_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/admissions/applications_enrollment_screen.dart)): Submitted admission applications, document review status, and student enrollment queues.
* **Fee Receipt Desk** ([`fee_receipt_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/fees/fee_receipt_screen.dart)): Receipt generation, fee breakdowns, and student transaction records.
* **Accountant Dashboard** ([`accountant_dashboard_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/dashboards/accountant_dashboard_screen.dart)): Recent fee collection feeds and payment history widgets.

---

## 6. Library, Transport & Inventory
* **Library Desk** ([`librarian_dashboard_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/dashboards/librarian_dashboard_screen.dart)): Book catalog search, active book issues, due dates, and fine logs.
* **Bus Transit Desk** ([`bus_transit_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/library_transport_inventory/bus_transit_screen.dart)): Bus routes, vehicle rosters, driver contacts, and transit tracking data.
* **Inventory Desk** ([`inventory_desk_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/library_transport_inventory/inventory_desk_screen.dart)): Asset stock lists, item categories, and stock allocation tables.

---

## 7. Admin & Search
* **Parents Directory** ([`parents_directory_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/admin/parents_directory_screen.dart)): Parent contact entries, linked children, and occupation data.
* **Unified Global Search** ([`unified_search_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/admin/unified_search_screen.dart)): Search results across students, staff, classes, and notices.
* **School Setup Desk** ([`school_setup_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/admin/school_setup_screen.dart)): Campus info, affiliation text, and active session configurations.

---

## Currently Integrated with Real API
* **Login & Authentication Screen** ([`login_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/auth/login_screen.dart)): Real authentication API calls via `AuthApiService`.
* **User Profile & Account Info** ([`account_api_service.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/core/api/account_api_service.dart)): User profile data (Name, Role, Email, User ID) loaded dynamically upon login.
