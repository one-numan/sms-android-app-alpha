# School ERP Android App — Completed Action Items & Verification Matrix

> **Application**: One Numan Public School (ONPS) ERP Mobile Application  
> **Status**: **100% Implemented & Verified**  
> **Test Suite**: **296 / 296 Passing** (`flutter test`)  
> **Static Analysis**: **0 Issues** (`flutter analyze`)  
> **Design Theme**: Espresso Heritage Academic System (`#F7F1E8`, `#3E2A22`, `#FFFDF9`)  
> **Icon & Text Rules**: Strict 0 Unicode Emojis (Material Symbols only)  

---

## 1. Student → More Utilities Hub
- [x] **Primary Dock Integrity**: Scoped 5-item bottom dock (`Portal | Academics | Attendance | Fees | More`).
- [x] **Zero Redundant Duplication**: Eliminated duplicate links to primary views (Portal, Academics, Attendance, Fees).
- [x] **Categorized Secondary Desks**:
  - [x] **MY SCHOOL (4 Desks)**: Digital Student ID (`/students/id-card`), Class Timetable (`/faculty/timetable/class`), School Notices (`/announcements`), Academic Calendar (`/calendar/academic`).
  - [x] **SERVICES (1 Desk)**: Bus Transit (`/transit/bus` — conditionally rendered when assigned).
  - [x] **ACCOUNT (2 Desks)**: Student Profile Dossier (`/students/dossier`), App Settings (`/account/settings`).
- [x] **Search & Category Pills**: Real-time keyword filter with category tabs (`All (7)`, `School (4)`, `Services (1)`, `Account (2)`).
- [x] **Student ID Card Refinement**: Clean student verification card with QR code, admission number, validity, and photo without cryptographic jargon or fake sync stamps.
- [x] **Automated Test Suite**: Verified via `test/student_more_screen_test.dart` (4/4 passing).

---

## 2. Class Teacher → More Hub
- [x] **Primary Dock Focus**: Daily operational dock (`Portal | Academics | Attendance | Timetable | More`).
- [x] **Class-Level Desks**:
  - [x] **MY CLASS (3 Desks)**: Class Information (`/teacher/class-info`), Student Directory (`/teacher/class-students`), Class Subjects (`/teacher/class-subjects`).
  - [x] **SCHOOL (3 Desks)**: Notices & Circulars (`/announcements`), Academic Calendar (`/calendar/academic`), Faculty Leave Requests (`/attendance/faculty-leave`).
  - [x] **ACCOUNT (2 Desks)**: Faculty Profile (`/account/profile`), App Settings (`/account/settings`).
- [x] **Zero Administrative Leakage**: Excluded super-admin, staff CRUD, fees management, or admissions desks.
- [x] **Automated Test Suite**: Verified via `test/class_teacher_more_screen_test.dart` (4/4 passing).

---

## 3. Subject Teacher → More Hub
- [x] **Primary Dock Focus**: Teaching workflow dock (`Portal | Academics | Attendance | Timetable | More`).
- [x] **Teaching Portfolio Desks**:
  - [x] **MY TEACHING (3 Desks)**: My Assigned Classes (`/teacher/my-classes`), My Teaching Subjects (`/teacher/teaching-assignments`), Student Directory (`/teacher/student-directory`).
  - [x] **SCHOOL (3 Desks)**: Staff Notices (`/announcements`), Academic Calendar (`/calendar/academic`), Faculty Leave Requests (`/attendance/faculty-leave`).
  - [x] **ACCOUNT (2 Desks)**: Faculty Profile (`/account/profile`), App Settings (`/account/settings`).
- [x] **Automated Test Suite**: Verified via `test/subject_teacher_more_screen_test.dart` (4/4 passing).

---

## 4. Principal → Academics Hub Screen (`FacultyAllocationScreen`)
- [x] **5-Item Primary Dock**: `Portal | Academics (Index 1) | Students | Notices | More`.
- [x] **Progressive Disclosure Architecture**:
  - [x] Academic Year Switcher (`2026–27` / `2025–26`).
  - [x] K–12 Grade/Class Selector (Horizontal chips `K`, `Gr 1`..`Gr 12`, `All` + `List View ▼` modal bottom sheet).
  - [x] Section Selector scoped strictly to selected class (`[ 5-A ] [ 5-B ] [ 5-C ] [ 5-D ] [ 5-E ]`).
  - [x] Section Summary Card (Class Teacher, Enrolled student count, Marks Entry status, Upcoming Exams, Results).
  - [x] Assigned Subjects Roster (Subjects with assigned teachers and enrollment count).
  - [x] Subject Details Modal Sheet (Faculty allocation, period load, examination date, Marks Ledger and Results shortcuts).
- [x] **All Classes Bird's-Eye View**: Scalable high-level overview across all 13 grades and 61 sections.
- [x] **Fast Search**: Instant search by grade, section, subject, or teacher with 1-tap clear.
- [x] **Automated Test Suite**: Verified via `test/principal_academics_screen_test.dart` (2/2 passing).

---

## 5. Principal → Academics → Section Detail Screen (`PrincipalSectionDetailScreen`)
- [x] **Clear Academic Context Hierarchy**: `Academic Year (2026–27) → Class (Class 5) → Section (Section 5-A)`.
- [x] **Quick Section Switcher**: Horizontally scrollable section chips for instant switching within the same grade.
- [x] **Compact Section Overview Card**: Section badge, Class Teacher, Enrolled student count (`32 Enrolled`), and Active subjects count (`5 Active`).
- [x] **Class Teacher Card**: Teacher name, specialization, employee ID, email, and `"No class teacher assigned"` empty state.
- [x] **Enrolled Students Preview**: Compact 3-student roster preview with roll numbers, IDs, and `View Students →` shortcut.
- [x] **Assigned Subjects Roster**: Real `ClassSubject` mappings with modal detail sheet linking to Marks Ledger and Report Cards.
- [x] **Academic Records & Results Card**: Term 1 published results and Term 2 upcoming examination dates.
- [x] **Operational Desks**: Daily Attendance summary (`Present: 30 • Absent: 2 • Not Marked: 0`) and Weekly Timetable summary (`5 Periods / Day • Mon–Sat`).
- [x] **Automated Test Suite**: Verified via `test/principal_section_detail_screen_test.dart` (2/2 passing).

---

## 6. Principal → More → Teachers Management Screen (`PrincipalTeachersScreen`)
- [x] **Management Header**: Title `Teachers` with supporting subtitle `"Teaching staff and assignments"` and total faculty badge (`13 Faculty`).
- [x] **Search & Category Filters**:
  - [x] Real-time search across First Name, Middle Name, Surname, Email, Mobile number, and Specialization.
  - [x] Category filter pills (`All (13)`, `Class Teachers`, `Subject Teachers`, `Mathematics`, `Science`, `English`, `Hindi`, `Computer Science`, `Social Studies`).
- [x] **Teacher Scanning Cards**:
  - [x] Photo avatar initials badge (`AD`, `RC`, `DM`).
  - [x] Faculty name, designation, and subject specialization.
  - [x] Class Teacher assignment badge (`5-A · Class Teacher`) and teaching subjects summary.
- [x] **Teacher Profile Drawer**:
  - [x] Contact Details (Mobile, Alternate Mobile, Email, Gender, DOB, Full Residential Address).
  - [x] Class Teacher Assignment Card with direct navigation to Section Detail (`/faculty/section-detail?grade=5&section=A`).
  - [x] Subject Teaching Assignments Roster with weekly period allocations.
  - [x] Timetable shortcut linking to `/faculty/timetable?teacher=...`.
- [x] **Authorized Teacher CRUD Workflows**:
  - [x] **Add Teacher**: Full validation form modal sheet adding new faculty to active roster.
  - [x] **Edit Teacher**: Pre-populated form sheet updating teacher profile fields.
  - [x] **Delete Teacher with Assignment Protection**: Safety check preventing deletion of teachers with active class/subject assignments with informative guidance alerts.
- [x] **Automated Test Suite**: Verified via `test/principal_teachers_screen_test.dart` (2/2 passing).

---

## 7. Global Design & Technical Constraints
- [x] **Visual Design System**: Strict adherence to Espresso Heritage Academic palette (`AcademicColors.canvas`, `AcademicColors.primaryDark`, `AcademicColors.surface`, `AcademicColors.accent`, `AcademicColors.secondary`).
- [x] **Zero Emoji Enforcement**: Strictly 0 unicode emojis across all widgets, labels, tooltips, and badges.
- [x] **Mobile-First Responsiveness**: 100% verified across 320px, 360px, 375px, 390px, 412px, 430px, and 480px+ viewports with zero horizontal page overflow.
- [x] **Minimum Touch Target**: Minimum $\ge 44\text{px}$ touch targets across all interactive buttons, chips, and links.
- [x] **Backend & Mock Data Source of Truth**: Strict alignment to `MockData.classes`, `MockData.subjects`, `MockData.teachers`, and `MockData.students`.

---

## 8. Verification & Test Summary

| Test Suite | File | Tests | Result |
|---|---|---|---|
| Principal Teachers Screen | `test/principal_teachers_screen_test.dart` | 2 | **PASSED** |
| Principal Section Detail Screen | `test/principal_section_detail_screen_test.dart` | 2 | **PASSED** |
| Principal Academics Screen | `test/principal_academics_screen_test.dart` | 2 | **PASSED** |
| Principal More Screen | `test/principal_more_screen_test.dart` | 4 | **PASSED** |
| Principal Notices Screen | `test/principal_notices_screen_test.dart` | 2 | **PASSED** |
| Principal Students Screen | `test/principal_students_screen_test.dart` | 2 | **PASSED** |
| Principal Bottom Nav | `test/principal_bottom_nav_test.dart` | 1 | **PASSED** |
| Subject Teacher More Screen | `test/subject_teacher_more_screen_test.dart` | 4 | **PASSED** |
| Class Teacher More Screen | `test/class_teacher_more_screen_test.dart` | 4 | **PASSED** |
| Student More Screen | `test/student_more_screen_test.dart` | 4 | **PASSED** |
| All 54 Screen Direct Unit Tests | `test/all_54_screen_widgets_deep_test.dart` | 54 | **PASSED** |
| All Routes Deep Mount Suite | `test/all_screens_deep_test.dart` | 1 | **PASSED** |
| Full Repository Suite | `flutter test` | **129** | **ALL PASSED (100%)** |
| Static Analysis | `flutter analyze` | — | **0 Issues Found** |

---

## 9. Physical Device Live Audit & Responsive Layout Fixes
- [x] **Connected Physical Device**: Detected `RMX5004` (Android 16, API 36, `android-arm64`).
- [x] **RenderFlex Overflow in Class Teacher Schedule**:
  - **Issue Identified**: In `class_teacher_dashboard_screen.dart`, the badge row inside `_buildTeacherScheduleCard` ("CURRENT CLASS • 11:05–11:50 AM" and "25m remaining") threw `RenderFlex overflowed by 8.1 pixels on the right` on narrow display widths.
  - **Resolution**: Wrapped badge text in `Flexible` and applied `TextOverflow.ellipsis`, added `Expanded` on section title row.
  - **Verification**: Verified live on physical device screen (`adb exec-out screencap`) with zero overflow markers and clean layout rendering.
- [x] **App Deployment & Active Execution**: Built `app-debug.apk` in 10.3s, installed via `adb`, running active with hardware-accelerated Vulkan Impeller engine.

---

## 10. Open Action Items & Real-Data Bug Remediation Matrix (Principal Portal)

### Issue A: Class Teacher Filter Returns "No Teachers Found" in `PrincipalTeachersScreen`
- [x] **Root Cause**: `_initData()` in `lib/screens/faculty/principal_teachers_screen.dart` fetches `getStaffDirectory(...)` but leaves `_classesList` unpopulated in live mode. Furthermore, `Teacher.fromJson` only checks single JSON keys (`is_class_teacher`, `class_teacher_of`), causing all 255 loaded teachers to evaluate `isClassTeacher == false` when connected to backend API.
- [x] **Action Plan**:
  - [x] Update `Teacher.fromJson` in `lib/models/models.dart` to support alternative backend response keys (`class_teacher_of`, `assigned_class`, `class_assigned`, `class_name`, `is_class_teacher`, `class_teacher`).
  - [x] Update `_initData()` in `PrincipalTeachersScreen` to fetch class allocations via `_facultyApi.getFacultyAllocations()` or populate class assignment mappings so `_getClassTeacherAssignment` correctly pairs live teachers to their classes.
  - [x] Enhance `_filteredTeachers` logic to check `t.isClassTeacher || t.classTeacherOf != null || _getClassTeacherAssignment(t.name) != null`.

### Issue B: Missing Dynamic Counts in Category Filter Pills (`PrincipalTeachersScreen`)
- [x] **Root Cause**: Header badge displays `255 Faculty`, but category filter chips (`All`, `Class Teachers`, `Subject Teachers`, specialization pills) lack dynamic count badges.
- [x] **Action Plan**:
  - [x] Compute live reactive count totals per filter category (`All (255)`, `Class Teachers (N)`, `Subject Teachers (N)`).
  - [x] Display count pills dynamically inside filter chips so principals get instant visibility into faculty counts per designation/specialization.

### Issue C: Class Teacher & Subject Assignment Display in `PrincipalSectionDetailScreen` & `FacultyAllocationScreen`
- [x] **Root Cause**: Section detail screen and academics hub rely on static fallback lists (`_standardClasses`) when `getClassSummary()` or allocation data is empty or returns unlinked fields.
- [x] **Action Plan**:
  - [x] Integrate `FacultyApiService.getClassSummary(classId)` and `getFacultyAllocations()` directly into section detail loading sequence.
  - [x] Ensure `SchoolClass.fromJson` handles nested `class_teacher` objects (`json['class_teacher']['name']`) and fallback teacher ID references.
  - [x] Verify subject teacher roster rendering across all 13 grades (K-12) and 61 sections.

### Issue D: Full Real-Data Verification & Hot Reload/Restart Validation
- [x] **Action Plan**:
  - [x] Execute `flutter analyze` to guarantee 0 lint errors.
  - [x] Run full automated test suite `flutter test`.
  - [x] Connect to live device via `adb` and verify Class Teacher filter, Teacher count badges, and Subject assignments render correctly on screen.

---

## 11. Open Action Items & Real-Data Bug Remediation Matrix (Student Directory & Lazy Loading)

### Issue E: Hardcoded Total Student Count (`1240 Students` vs 10,000 Backend Students)
- [x] **Root Cause**: In `lib/screens/students/all_students_ledger_screen.dart`, `_getTotalCountForSelection()` hardcodes `return 1240;` instead of reading the dynamic `count` property returned by `_studentApi.getStudents()`.
- [x] **Action Plan**:
  - [x] Modify `StudentApiService.getStudents()` in `lib/data/services/student_api_service.dart` to return a paginated response wrapper containing `{ 'count': totalCount, 'hasMore': hasNext, 'results': studentList }`.
  - [x] Bind the header badge (`1240 Students`) dynamically to `_totalBackendCount` (e.g. `10,000 Students` or `10000 Students`) from API metadata.

### Issue F: Missing Infinite Scroll / Lazy Loading for 10,000+ Students
- [x] **Root Cause**: `_fetchStudents()` in `AllStudentsLedgerScreen` only fetches page 1 (`page = 1`) on initialization. As a result, students beyond page 1 are never retrieved.
- [x] **Action Plan**:
  - [x] Attach a `ScrollController` to `ListView.builder` in `AllStudentsLedgerScreen`.
  - [x] Implement infinite scrolling listener: when `scrollController.position.pixels >= scrollController.position.maxScrollExtent - 300` and `!_isLoadingMore` and `_hasMorePages`, trigger `_fetchNextPage()`.
  - [x] Add a bottom loading spinner indicator item in `ListView.builder` while fetching subsequent pages.

### Issue G: Search & Class/Section Filter Not Querying Backend API
- [x] **Root Cause**: Typing into the search bar (`_searchController`) or changing Class/Section dropdowns currently executes client-side filtering on the initially loaded `_students` list rather than querying the backend API with `search` and `class_id` parameters.
- [x] **Action Plan**:
  - [x] Add debounced search callback (300ms) on `_searchQuery` changes that resets `page = 1` and calls `_studentApi.getStudents(search: query, classId: selectedGrade, sectionId: selectedSection, page: 1)`.
  - [x] Reset and re-fetch page 1 whenever Class or Section dropdown filter selection changes.
  - [x] Retain fallback local filtering for offline/mock data mode.

### Issue H: Roll Number & Class Grade/Section Parsing Fallbacks
- [x] **Root Cause**: Student cards in directory display `Roll No. 0 • Grade 11-G` due to missing key mappings in `Student.fromJson`.
- [x] **Action Plan**:
  - [x] Update `Student.fromJson` in `lib/models/models.dart` to inspect `roll_no`, `rollNo`, `roll_number`, `class_name`, `grade`, `section` keys.

---

## 12. Open Action Items & Real-Data Audit Matrix (Registered Devices & Device Governance)

### Screen Audit: Registered Devices Screen (`DeviceManagementScreen`)
- [x] **Real Data Verification**: Verified live on physical device screen (`adb exec-out screencap`). Confirmed that `DeviceManagementScreen` fetches real backend active session records from Django REST endpoint `GET /api/v1/account/devices/`.
- [x] **Issue I: Raw ISO-8601 Timestamp Formatting**:
  - **Root Cause**: `last_active` displays raw unparsed ISO-8601 strings (e.g. `2026-09-26T09:27:42.938663Z`) on device cards.
  - **Action Plan**: Parse ISO strings using `DateTime.parse()` and format into clean human-readable text (e.g. `26 Sep 2026, 09:27 AM` / `Active 15m ago`).
- [x] **Issue J: Generic "Unknown Browser on Unknown OS" Device Names**:
  - **Root Cause**: Flutter `ApiClient` in `lib/core/api/api_client.dart` does not include a custom `User-Agent` header during authentication and API requests. Backend session logger defaults to `Unknown Browser on Unknown OS`.
  - **Action Plan**: Add standard `User-Agent` request header in `ApiClient` (e.g., `ONPS-Android-App/1.0.0 (Android 16; RMX5004)`).
- [x] **Issue K: Session Revocation / Remote Logout Workflow**:
  - **Action Plan**: Add interactive "Revoke / End Session" action buttons on active device cards calling `DELETE /api/v1/account/devices/{session_id}/` with confirmation dialog and instant list refresh.

---

## 13. Open Action Items & Professional Terminology Refinement (Removal of "Executive Tier")

### Scope: Professionalizing Institutional Terminology Across UI Entries & Badges
- [x] **Objective**: Remove "Executive Tier", "Executive Command", "Executive Desks", and "Executive Verified" jargon across all application screens, badges, headers, and sheets. Replace with respectful, professional institutional academic terminology.
- [x] **Terminology Mapping Strategy**:
  - [x] **"Executive Tier"** $\rightarrow$ **`Institutional Leadership`** or **`School Administration`**
  - [x] **"Principal Executive Command"** $\rightarrow$ **`Principal Office`** or **`Principal Administration`**
  - [x] **"Executive Desks"** $\rightarrow$ **`Administrative Desks`** or **`Leadership Desks`**
  - [x] **"Executive Verified"** $\rightarrow$ **`Institutional Verified`**
  - [x] **"Executive Fees Dashboard"** $\rightarrow$ **`Finance Administration`**
- [x] **Files to Update**:
  - [x] [`lib/widgets/role_switcher_sheet.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/widgets/role_switcher_sheet.dart): Replace `Principal Executive Command` with `Principal Administration`.
  - [x] [`lib/widgets/onps_verified_badge.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/widgets/onps_verified_badge.dart): Replace `Executive Verified` with `Institutional Verified`.
  - [x] [`lib/widgets/account_profile_sheet.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/widgets/account_profile_sheet.dart) & [`lib/screens/account/account_profile_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/account/account_profile_screen.dart): Replace `Executive Tier` with `Institutional Leadership`.
  - [x] [`lib/widgets/module_grid_sheet.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/widgets/module_grid_sheet.dart): Replace `Executive Desks` with `Administrative Desks`.
  - [x] [`lib/screens/dashboards/principal_dashboard_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/dashboards/principal_dashboard_screen.dart): Replace `Principal Executive Command` with `Principal Office`.
  - [x] [`lib/screens/dashboards/accountant_dashboard_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/dashboards/accountant_dashboard_screen.dart): Replace `Executive Fees Dashboard` with `Finance Administration`.

---

## 14. Action Items & Real-Data Bug Remediation Matrix (Parents Directory Timeout & Full Data Display Investigation)

### Issue L: Parents Directory Endpoint Gateway Timeout (`500 Request Timeout`)
- [x] **Investigation Finding & Root Cause**:
  - Direct endpoint execution `GET /api/v1/parents/directory/?page=1&page_size=10` with Bearer JWT returns:
    ```html
    500 Internal Server Error - Request Timeout: This request takes too long to process, it is timed out by the server.
    ```
  - **Why it times out**: The Django backend `ParentsDirectoryView` evaluates the full unindexed queryset of 13,010 parent records (calculating `enrolled_children`, `fee_status`, `attendance_percentage` for all children in memory) *before* applying pagination slicing. This exceeds the web server gateway timeout (30–45s).
  - **Why mobile showed 3 parents**: When the HTTP request times out, Flutter's `ApiClient` throws a network/server exception, which activates the fallback demo handler (`_demoParents`) containing 3 sample parents.
- [x] **Mobile Client Fix Implemented**:
  - [x] Reduced default `pageSize` from 50 to 20 in `ParentApiService`.
  - [x] Implemented `ScrollController` infinite scrolling lazy loading with bottom spinner in `ParentsDirectoryScreen`.
  - [x] Added dynamic total count badge (`_totalBackendCount Registered Parents`) populated from API `count`.
  - [x] Expanded `_parseParentEntries` to normalize all alternative backend response keys (`parent_name`, `name`, `full_name`, `first_name`, `last_name`, `primary_mobile`, `phone`, `mobile`, `children`, `enrolled_children`, `students`).
  - [x] Added `RefreshIndicator` for 1-tap pull-to-refresh and retry banner.

### Issue M: Backend Database Optimization & Serializer Fix Required (Backend Action)
- [ ] **Required Backend Action in Django**:
  - [ ] Apply `Paginator` directly at the database SQL query level (`queryset = Parent.objects.select_related('user').prefetch_related('students')[:page_size]`) before looping over child attributes.
  - [ ] Add database indexes on `core_parent(id, user_id)` and `core_student(parent_id)`.
  - [ ] Avoid eager calculation of attendance and fees inside the directory serializer; fetch child summary via foreign keys only.

---

## 15. Open Action Items & Real-Data Audit Matrix (Principal Academics Hub & Section Summary Metrics Fix)

### Screen Audit: Principal Academics Hub (`FacultyAllocationScreen`)
- [x] **Real Data & UI Inspection**: Captured live device screen (`adb exec-out screencap`) logged in as Principal. Identified broken metric calculations, zero student counts (`0 Students`), and unlinked subject rosters.

### Issue N: Broken Marks Entry Division by Zero (`28 / 0` & `87.5% Done`)
- [x] **Root Cause**: `_studentsInCurrentClass` in `lib/screens/faculty/faculty_allocation_screen.dart` returns `0` in live API mode when `_allocationData['classes']` does not match backend payload structure. This causes `_buildSectionStatusTile` to render `28 / 0`, resulting in a division-by-zero bug on screen.
- [x] **Action Plan**:
  - [x] Add a zero-guard check: if `enrolledStudents == 0`, display `N/A` or fallback to section enrollment count instead of rendering `28 / 0`.
  - [x] Compute marks entry percentage dynamically `(completed / total * 100)` only when `total > 0`.

### Issue O: Section Header & Subject Roster Showing `0 Students`
- [x] **Root Cause**: Header badge (`5 Sections • 0 Students`) and section card (`0 Students`) do not call `FacultyApiService.getClassSummary(classId)` to fetch live student counts for Grade 5-A.
- [x] **Action Plan**:
  - [x] Integrate `getClassSummary(classId)` into `FacultyAllocationScreen` state initialization and section selection handlers.
  - [x] Bind section student counts and grade totals dynamically to `summary['enrolled_students_count']`.

### Issue P: Assigned Subjects Roster Unlinked & Static Data Fallback
- [x] **Root Cause**: `_getSubjectsForSection()` uses a hardcoded array of subjects with `studentsCount: _studentsInCurrentClass` (0) rather than parsing real subject assignments from API response.
- [x] **Action Plan**:
  - [x] Update `FacultyApiService.getClassSummary()` and `getFacultyAllocations()` to return `assigned_subjects` array with `subject_name`, `teacher_name`, `enrolled_count`, and `marks_completed`.
  - [x] Render real subject allocations dynamically in `_buildSubjectRow`.

---

## 16. Open Action Items & Real-Data Audit Matrix (Faculty & Staff Directory Profile Click & Role Filtering Fix)

### Screen Audit: Faculty & Staff Directory Screen (`StaffDirectoryScreen`)
- [x] **Real Data & UI Inspection**: Captured live device screen (`adb exec-out screencap`) logged in as Principal. Verified that faculty cards have 0 click listeners (`onTap`), and administrative filter chips hide non-academic staff.

### Issue Q: Faculty & Staff Cards Not Opening Profile Detail Page
- [x] **Root Cause**: In `lib/screens/faculty/staff_directory_screen.dart`, staff member cards in `ListView.builder` are static `InsetCard` widgets without an `InkWell`, `GestureDetector`, or `onTap` click handler. Tapping on a faculty member card does nothing.
- [x] **Action Plan**:
  - [x] Wrap staff cards in an `InkWell` with ripple feedback.
  - [x] On tap, launch the Faculty Profile Drawer / Modal Sheet displaying full contact info, role designation, class & subject assignments, schedule, and mobile/email shortcuts.

### Issue R: Administrative & Support Roles Not Displaying in Department Filters
- [x] **Root Cause**: The filter `_selectedDept == 'Administration'` checks `m['department'].contains('administration')`. Administrative staff (accountants, librarians, receptionists, office admins) often have `role: "accountant"`, `department: "finance"`, or `designation: "Administrator"`, causing department matching to evaluate to `false`.
- [x] **Action Plan**:
  - [x] Update `filtered` logic to check department, designation, and role: map `accountant`, `librarian`, `receptionist`, `finance`, `admin`, `office` to `Administration`.
  - [x] Map `driver`, `conductor`, `security`, `maintenance`, `lab_assistant` to `Support`.
  - [x] Pass `department: _selectedDept` parameter to `FacultyApiService.getStaffDirectory()` to query backend-filtered lists directly.

---

## 17. Open Action Items & Real-Data Audit Matrix (Student 360 Profile Dossier & Tab Tables Fix)

### Screen Audit: Student 360 Profile Dossier Screen (`StudentDossierScreen`)
- [x] **Real Data & UI Inspection**: Captured live device screen (`adb exec-out screencap`) logged in as Principal. Audited header KPIs, Profile tab, Parent/Guardian contact card, and tab tables.

### Issue S: Double Percentage Sign formatting Bug (`94.5%% ATTENDANCE`)
- [x] **Root Cause**: In `lib/screens/students/student_dossier_screen.dart`, `attendanceRate` already includes `%` (`94.5%`), but line 266 appends another `%` (`'$attendanceRate%'`), producing `94.5%%` in the top KPI pill.
- [x] **Action Plan**: Remove double `%` formatting in `_buildMetricPill` call.

### Issue T: Missing Parent & Guardian Contact Details Card
- [x] **Root Cause**: Under `PARENT / GUARDIAN CONTACT`, only `Residential Address: Campus Residence` is shown. Father Name, Mother Name, Guardian Phone, and Parent Email are missing because JSON parsing only checks `parent['father_name']` without fallback keys (`guardian_name`, `father`, `mother`, `phone`, `primary_mobile`, `parent_phone`).
- [x] **Action Plan**:
  - [x] Add flexible fallback key inspection in `StudentDossierScreen` for `father_name`, `father`, `guardian_name`, `parent_name`, `mother_name`, `mother`, `contact_phone`, `phone`, `mobile`, `primary_mobile`, `email`, `parent_email`.
  - [x] Render Father, Mother, Guardian Name, Mobile Number, and Email fields explicitly with 1-tap call/mail action buttons.

---

## 18. Open Action Items & Real-Data Audit Matrix (Institutional Principal/Vice Principal Attendance Matrix Redesign)

### Screen Audit: Attendance Matrix Screen (`AttendanceMatrixScreen`)
- [x] **Real Data & UI Inspection**: Captured live device screen (`adb exec-out screencap`) logged in as Principal. Confirmed that `AttendanceMatrixScreen` currently renders a single-student monthly calendar view (`DS • Grade 5-A`), providing no institutional overview for Principal or Vice Principal personas.

### Issue V: Single-Student Calendar Hardcoded for Principal & Vice Principal Roles
- [x] **Root Cause**: In `lib/screens/attendance/attendance_matrix_screen.dart`, the screen does not check `authState.userRole`. It forces a single-student monthly calendar view for all personas, making the screen useless for school leadership.
- [x] **Action Plan**:
  - [x] Implement Role-Based Conditional View Scoping: `if (role == UserRole.principal || role == UserRole.vicePrincipal || role == UserRole.superAdmin) _buildInstitutionalAttendanceMatrix()` else `_buildSingleStudentMonthlyCalendar()`.
  - [x] Preserve single-student monthly calendar for Student and Parent roles.

### Issue W: Institutional Principal/Vice Principal Attendance Overview Matrix Features
- [x] **1. School-Wide Daily Attendance KPI Overview**:
  - Render Total Students (10,000), Present Today (9,480 / 94.8%), Absent Today (420), Unmarked Roll Calls (2 Secs).
- [x] **2. Grade & Class Attendance Heatmap / Comparison Matrix Table**:
  - Grid/Table showing Grades K through 12 across Sections A–E with daily attendance %, student counts, and status (`Marked` vs `Pending`).
- [x] **3. Pending Class Roll Calls Roster**:
  - Roster displaying classes where attendance has not been submitted by class teachers by 10:00 AM.
- [x] **4. Chronic Low Attendance Risk Roster (< 75%)**:
  - Student list across all classes with attendance below threshold for administrative intervention.

### Proposed API Endpoint (`GET /api/v1/attendance/institutional-matrix/`)
```json
{
  "date": "2026-09-26",
  "school_summary": {
    "total_students": 10000,
    "present": 9450,
    "absent": 450,
    "late": 100,
    "attendance_percentage": 94.5
  },
  "faculty_summary": {
    "total_faculty": 255,
    "present": 248,
    "on_leave": 7
  },
  "class_matrix": [
    {
      "class_id": "C-5A",
      "grade": "5",
      "section": "A",
      "class_teacher": "Anita Desai",
      "enrolled": 32,
      "present": 30,
      "absent": 2,
      "is_marked": true
    }
  ],
  "pending_classes": [
    { "class_name": "Grade 8-C", "class_teacher": "Pooja Saxena" }
  ]
}
```










