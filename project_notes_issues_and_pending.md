# One Numan Public School (ONPS) Scholastic ERP — Status, Issues & Pending Items

## 1. Live Physical Device Audit (Realme RMX5004 / Android 16)

During live execution on the physical Android hardware, the following UI/UX issues were captured and documented from live device screenshots:

### A. Text & Card Truncation
- **Inventory Item Titles Truncated:** On `InventoryDeskScreen`, item names such as *"A4 Printing Paper"*, *"Whiteboard Markers"*, *"Footballs"*, and *"Compound Microscopes"* are clipped into *"A4 Pri..."*, *"Whitebo..."*, *"Footbal..."*, *"Microsco..."*.
  - **Root Cause:** The item name, stock quantity pill badge, and `[-]`/`[+]` stepper buttons are all laid out in a single horizontal `Row`. On mobile screens (390px–412px width), the title only receives ~120px of width.
  - **Fix:** Move the `[-]`/`[+]` stepper buttons and status badge to the bottom metadata row so the item title has full width.
- **AppBar Title Truncation:** Titles such as *"Inventory & Stock Desk"* get cut into *"Inventory & St..."* because the AppBar row shares space with the back arrow button and the *"Session 2026-27"* badge chip.
  - **Fix:** Reduce font size from 20 to 18 or place the academic session pill in a subtitle bar below the title.

### B. Segmented Tab Bar Styling
- The custom tab indicator pill in `inventory_desk_screen.dart` has a dark background that sits tightly against the tab labels, slightly crowding *"All Catalog"* and *"Low Stock"*.
  - **Fix:** Adjust tab padding and use an underline or rounded border indicator.

### C. Initial App Routing
- When launched, the app currently opens directly into the active role's dashboard (defaults to Parent Dashboard) rather than showing the Secure Login Gateway (`/login`) or a Persona Chooser first.
  - **Fix:** Set `initialLocation: '/login'` so users start at the branded login gateway and can choose their persona or proceed through authentication.

---

## 1B. Live Physical Device Audit — Session 2 (2026-09-17, Realme RMX5004)

`flutter run` on the physical device via USB, with `adb logcat` and the Flutter console captured for the full session (back-to-back navigation + back-button exit). **No fatal crash occurred** — `adb logcat` recorded **zero** `FATAL EXCEPTION` / `E/AndroidRuntime` entries for the whole session.

### A. RenderFlex Overflow — Parent Dashboard (repeated, 13 occurrences)
- **Location:** `lib/screens/dashboards/parent_dashboard_screen.dart:322` — a `Row` inside `Column ← Expanded ← Row ← Padding ← DecoratedBox ← Padding ← Container`.
- **Symptom:** `A RenderFlex overflowed by N pixels on the right`, N ranging from 0.186px to 27px depending on content/orientation. Recurred on nearly every re-layout (scroll, rotation, navigation back to the dashboard).
- **Fix:** Wrap the overflowing child (likely a label/value text next to an icon or badge) in `Expanded`/`Flexible`, or constrain the `Row`'s children so they fit within `BoxConstraints(0.0<=w<=214.0)`.

### B. Transient Cascading Layout Failure — "infinite width"
- **Symptom:** `BoxConstraints forces an infinite width` thrown once, immediately followed by ~23 `RenderBox was not laid out` / `Cannot hit test a render box that has never been laid out` errors as the render tree unwound. App **self-recovered** on the next frame; no crash.
- **Likely cause:** A widget with unbounded width (e.g. a `TextField`/`Row` without `Expanded`, nested inside a horizontally-scrolling or intrinsic-width ancestor) briefly received infinite constraints, probably during a screen/keyboard transition.
- **Action needed:** Reproduce deliberately (rotate device or open keyboard while on the dashboard) to capture the exact widget file:line, since Flutter's console truncates the detailed widget trace after the first couple of exceptions in a batch.

### C. "Bad state: No element" on Back-Button Exit
- **Symptom:** `Bad state: No element` (Dart `StateError`) thrown at the moment the Android back button triggers `PlatformPlugin.popSystemNavigator` and the activity finishes.
- **Likely cause:** A `.first` / `.firstWhere()` / `.single` call on an empty `Iterable`/`List` inside a `dispose()`, route-pop listener, or navigator observer that fires during teardown.
- **Fix:** Search for `.first`, `.firstWhere(`, `.single` calls in dispose/pop paths (route observers, stream listeners) and guard with `.firstOrNull` / an empty check.

### D. Noise (not app bugs, safe to ignore)
- `OplusScrollToTopManager ... unregisterSystemUIBroadcastReceiver failed: Receiver not registered` — Realme/ColorOS UI framework cleanup race, harmless.
- `OplusPredictiveBackController: NoSuchMethodException` — OEM predictive-back shim, unrelated to app code.
- `mali_gralloc: Unrecognized and/or unsupported format 0x38/0x3b` — GPU driver buffer-format warning, cosmetic/driver-level.
- Also relevant: app manifest does not set `android:enableOnBackInvokedCallback="true"`, which is why `WindowOnBackDispatcher` logs "OnBackInvokedCallback is not enabled for the application" on every back press — worth setting for Android 13+ predictive back support.

---

## 2. Completed & Working (Current Inventory)

1. **43 Fully Implemented Screens:**
   - **Auth & Sessions (6):** Secure Login Gateway, 2FA OTP & Device Eviction, Cooldown & Lockout, Animated Morning Briefing Sequence, Password Reset Recovery, Multi-Device Session Revocation.
   - **Dashboards (9):** Parent Portal, Student Self-Service Hub, Class Teacher Daily Operations, Subject Teacher Assessment, Subject Teacher Classes Roster, Principal Executive Hub, Accounts & Fee Collection, Library Circulation, Super Admin ERP Directory.
   - **Students & Academics (5):** Student 360 Dossier (7 tabs), CBSE 4-Term Report Card, Teacher Assessment Marks Entry Desk, All Students Directory Ledger, Digital Student ID Card.
   - **Attendance & Faculty (7):** Daily Roll Call (P/A/L/E), Student Monthly Attendance Matrix, Faculty Leave Application & Tracker, Class Timetable, Faculty Timetable Grid, Staff Directory, Faculty Allocation Matrix.
   - **Admissions (2):** Admissions Enquiry Intake Desk, Principal Admissions & Enrollment.
   - **Fees & Financials (2):** Fee Ledger & Dues Summary (read-only dues), Official Fee Payment Receipt Voucher.
   - **Transit & Supplies (2):** Bus Transit Route & Stop Timeline, Inventory Supplies & Low Stock Desk.
   - **Calendar, Notices & Alerts (7):** Gazetted Holidays Calendar, Institutional Events Desk, Schedule Event Form, Moderated Notice Board, Compose Circular Form, Principal Moderation Queue, Push Notification Center.
   - **Admin & Setup (3):** Cross-Entity Search, Parents Directory, Institutional School Setup.
2. **Universal Role Switcher:**
   - Instant switcher bottom sheet across all 9 personas (`Parent`, `Student`, `Class Teacher`, `Subject Teacher`, `Principal`, `Vice Principal`, `Accountant`, `Librarian`, `Super Admin`).
3. **Hard-Rule Compliance:**
   - **Zero Telecom SMS:** Notifications are strictly email and in-app push.
   - **No Live Payment Gateway:** Fee screens are read-only dues summaries.
   - **Authentic CBSE Terminology:** Exactly 4 exam terms (`First Assessment`, `Half Yearly`, `Second Assessment`, `Final Exam`).
   - **No Fabricated Staff IDs:** Clean Name + Designation/Subject only.
   - **No Room Numbers:** Clean class and period timetable without room fields.
4. **Compilation & Packaging:**
   - `flutter analyze`: **0 errors, 0 warnings, 0 lints**.
   - `flutter test`: **All smoke and widget tests passed**.
   - `flutter build apk --debug`: Successfully built `app-debug.apk` (151 MB).
   - `adb install`: Successfully installed and running on Realme RMX5004 device.

---

## 3. Pending Items (Roadmap to Production)

### Priority 1: UI Polish & Layout Fixes
- [ ] Fix text truncation on `InventoryDeskScreen` by moving stepper controls to the bottom row.
- [ ] Fix AppBar title truncation across screens with long titles (`InventoryDeskScreen`, `ApplicationsEnrollmentScreen`, `StaffDirectoryScreen`).
- [ ] Add safe back-navigation (`if (context.canPop()) context.pop() else context.go('/')`) to prevent blank screens when opening deep links.
- [ ] Set `/login` as the default entrypoint so users see the brand gateway first.
- [ ] Fix `RenderFlex` overflow in `lib/screens/dashboards/parent_dashboard_screen.dart:322` (Row content exceeds available width — wrap in `Expanded`/`Flexible`).
- [ ] Reproduce and fix the transient "BoxConstraints forces an infinite width" layout crash (likely keyboard/rotation-triggered on the parent dashboard).
- [ ] Fix `Bad state: No element` thrown on Android back-button exit (empty-list `.first`/`.firstWhere()` call during dispose/pop teardown).
- [ ] Set `android:enableOnBackInvokedCallback="true"` in `AndroidManifest.xml` for proper Android 13+ predictive back support.

### Priority 2: Data Persistence (Offline Storage)
- [ ] Currently all data is held in-memory via `MockData`. Any newly added enquiries, adjusted inventory items, or submitted circulars reset on app restart.
- [ ] Implement local SQLite / Hive / SharedPreferences storage to persist state changes locally on the device.

### Priority 3: Django Backend REST API Integration & Critical Feeds
- [ ] Connect repository implementations (`lib/data/repositories/`) to Django 5.1.4 backend REST endpoints (`http://<backend-host>/api/v1/...`).
- [ ] Add JWT authentication token storage and auto-refresh interceptors.
- [ ] Wire multi-device session management to Django `DeviceSession` model.
- [ ] **Needs Attention Feed Integration (`GET /api/v1/attention/`)**:
  - Spec Reference: [`docs/attention_api_android.md`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/docs/attention_api_android.md)
  - Live, shipped endpoint. Needs client-side integration across all 7 role dashboards (`leadership`, `accountant`, `librarian`, `receptionist`, `teacher`, `parent`, `student`).
  - Render dynamically by `type` (`actionable_queue`, `alert_count`, `reminder`), not by hardcoded `id`/`domain`.
  - Handle `count: null` (non-count items like currency/holiday), use `summary` for badge counts, and respect server sort order (severity: critical -> warning -> info).
  - Implement full deep linking support for all 11 destination keys (`faculty_leave_review`, `my_leave_requests`, `moderation_queue`, `admissions_applications`, `fee_defaulters`, `fee_ledger`, `library_overdue`, `my_library_loans`, `inventory_low_stock`, `calendar`, `birthdays`).
  - Render genuine empty state ("You're all caught up") when `items: []`.
- [ ] **Teacher "Today" Status Integration (`GET /api/v1/teacher/today-status/`)**:
  - Spec Reference: [`docs/today_status_api_android.md`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/docs/today_status_api_android.md)
  - Consolidates school operational status (`is_teaching_day`, `day_type`: `WORKING`/`WEEKLY_OFF`/`HOLIDAY`, `reason`), time-aware current & next periods (`current_period`, `next_period`), and authoritative homeroom attendance state (`attendance`: `status`: `NOT_MARKED`/`PARTIAL`/`MARKED`/`NOT_APPLICABLE`, `can_take_attendance`).
  - Eliminates client-side week-dump fallback bugs and list-index guessing on Class Teacher & Subject Teacher dashboards (enforcing Rule 21 & Master Principle).

### Priority 4: Native Device Capabilities
- [ ] **PDF Export:** Connect PDF export buttons (Fee Receipt, Report Card, Timetable) to `pdf` and `path_provider` packages to generate and save signed `.pdf` files to device Downloads.
- [ ] **Barcode / QR Scanner:** Integrate camera permissions and `mobile_scanner` for student ID attendance scanning and inventory asset tagging.
- [ ] **Push Notifications:** Wire Firebase Cloud Messaging (FCM) or WebSocket push for real-time school circular broadcasts.

