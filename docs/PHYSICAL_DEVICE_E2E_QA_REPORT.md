# Physical Device E2E QA & Real Device Validation Interim Report

**Document Date:** September 24, 2026  
**Phase:** Phase 4.2 — Physical Device E2E QA  
**Execution Environment:** Physical Hardware via Wireless ADB  
**Git Rule Compliance:** Local only (`git push` strictly prohibited)  
**Status:** IN PROGRESS — PAUSED UPON USER REQUEST  

---

## 1. Device Information & Health

| Attribute | Device Value |
|---|---|
| **Model** | Realme RMX5004 / RMX5004IN |
| **Android Version** | Android 16 |
| **API Level** | API 36 (`android-arm64`) |
| **Connection** | Wireless ADB (`192.168.0.240:44561`) |
| **ADB Reverse** | `adb reverse tcp:8000 tcp:8000` (Active) |
| **Target Package** | `com.onenuman.sms_android_app_alpha` |
| **Installation Status** | Installed and running on physical hardware |

---

## 2. Infrastructure & Real Backend Connectivity

- **Live Production/Alpha Backend:** `https://alpha.onenuman.com/api/v1` (Active & responding with valid JWTs)
- **Local Micro-service Backend:** `http://127.0.0.1:8000/api/v1` via MySQL database (`sms_db`)
- **Authentication Mode:** Live JWT tokens via `POST /api/v1/auth/login/`
- **Zero MockData Compliance:** Strict production API responses; zero mock fallbacks enabled.

---

## 3. What Has Been Completed (DONE)

### Step 1 — Device Health & Port Forwarding
- [x] Connected to wireless debugging at `192.168.0.240:44561`.
- [x] Confirmed reverse port forwarding `tcp:8000 -> tcp:8000`.
- [x] Verified package `com.onenuman.sms_android_app_alpha` is registered and active.

### Step 2 — Clean Application State
- [x] Launched app and confirmed clean initial login screen.
- [x] Verified token persistence and tested full clean Sign Out flow.
- [x] Evidence captured: `docs/screenshots/00_login_clean_state.png`.

### Step 7 — Principal E2E Validation
- [x] **Account:** `principal.numan` / `principal12345` (Mohd Numan)
- [x] **Authentication:** Live JWT token received and stored.
- [x] **Morning Briefing:** Screen smoothly loaded with executive identity.
- [x] **Dashboard:** Live statistics rendered:
  - 352 Students
  - 22 Active Faculty
  - 94.6% Daily Attendance
  - 32 Classes (NUR to XII)
  - Evidence: `docs/screenshots/01_principal_dashboard.png`
- [x] **Academics Tab:** Live K-12 data loaded:
  - 13 Classes, 64 Sections, 255 Faculty allocated.
  - Evidence: `docs/screenshots/02_principal_academics.png`
- [x] **Students Directory:** Live students loaded from Django backend (1,240 records).
  - Evidence: `docs/screenshots/03_principal_students.png`
- [x] **Notices & Circulars:** 17 live school notices and circulars loaded from API.
  - Evidence: `docs/screenshots/04_principal_notices.png`
- [x] **All Modules Sheet:** 18 administrative and operational modules displayed.
  - Evidence: `docs/screenshots/05_principal_more.png`
- [x] **Parents Directory:** Live empty state verified ("0 Registered Parents", "No Parents Found - No parent records returned from directory service").
  - Evidence: `docs/screenshots/parents_directory_current.png`
- [x] **Sign Out:** Verified sign out returns cleanly to login gateway with cleared state.
  - Evidence: `docs/screenshots/post_signout_actual.png`

### Step 8 — Accountant E2E Validation (Partial)
- [x] **Account:** `accountantpriyamenon` / `staff12345` (Priya Menon)
- [x] **Authentication:** Live authentication via `POST /api/v1/auth/login/` with JWT issued.
- [x] **User Profile API:** Verified live response from `GET /api/v1/account/profile/` (`Priya Menon`, role: `staff`).
- [x] **Accounts & Fees Desk Dashboard:** Successfully opened and verified live financial metrics:
  - Total Fee Collections Realized: `₹8,44,53,779` (100.0% Realized)
  - Expected: `₹1,73,41,700`
  - Outstanding: `₹0`
  - Payment modes: Online Transfer, Cash, Cheque, UPI, Card
  - Evidence: `docs/screenshots/06_accountant_dashboard.png`
- [x] **Bug Discovered & Fixed:**
  - Route `/dashboard/accounts` was called upon navigating back / fees desk, causing `GoException: no routes for location: /dashboard/accounts`.
  - Fixed in [app_top_bar.dart](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/widgets/app_top_bar.dart) and [router.dart](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/router.dart).
- [x] **Test Suite Verification:**
  - `flutter analyze`: **0 issues found**.
  - `flutter test`: **257 / 257 tests passed**.

---

## 4. Discovered Bugs & Fix Summary

### Bug B1: Missing Route Alias `/dashboard/accounts`
- **Severity:** P1 (Major Functional Issue)
- **Component:** Routing (`GoRouter` / `AppTopBar`)
- **Symptoms:** When an accountant navigated to sub-screens or triggered back navigation without a pop stack, `AppTopBar._dashboardRouteForRole` directed to `/dashboard/accounts`, which was missing in `router.dart`, resulting in an unhandled `GoException` error page.
- **Root Cause:** Route was defined as `/dashboard/accountant` and `/accounts/dashboard`, but `_dashboardRouteForRole` in `app_top_bar.dart` used `/dashboard/accounts`.
- **Resolution:**
  1. Harmonized `AppTopBar._dashboardRouteForRole` to point to `/dashboard/accountant`, `/dashboard/librarian`, and `/dashboard/modules`.
  2. Added fallback route aliases `/dashboard/accounts`, `/dashboard/library`, and `/dashboard/admin` in `router.dart` so legacy or external links never throw a `GoException`.
- **Verification:** Ran `flutter analyze` (0 issues) and `flutter test` (257/257 passed).

---

## 5. What is Pending (TO DO UPON RESUMPTION)

When resuming this physical device test session:

1. **Deploy Built APK:**
   - Install the latest debug APK with the route fix:
     ```bash
     adb -s 192.168.0.240:44561 install -r build/app/outputs/flutter-apk/app-debug.apk
     ```

2. **Step 8 — Accountant E2E (Complete Flow):**
   - Verify Fee Ledger, Receipts, Student Dues, and Outstanding balances.

3. **Step 6 — Class Teacher E2E:**
   - Account: `shubmangill` / `teacher12345` (Shubman Gill)
   - Verify: Class Roster, Roll Call / Attendance, Timetable, Students list.
   - Capture screenshot evidence.

4. **Step 5 — Subject Teacher E2E:**
   - Account: `washingtonsundar` / `teacher12345` (Washington Sundar)
   - Verify: Subject Teacher Desk, Cohorts, Assigned subjects/classes, Timetable.
   - Capture screenshot evidence.

5. **Step 4 — Parent E2E:**
   - Account: `nawazuddinsiddiqui` / `parent12345` (Nawazuddin Siddiqui)
   - Verify: Parent Portal, Enrolled children, Child switcher, Child-specific data isolation.
   - Capture screenshot evidence.

6. **Step 3 — Student E2E:**
   - Account: `bushramalik011122` / `01112022` (Bushra Malik)
   - Verify: Student Hub, Attendance stats, Report Card, Fee Dues, Timetable.
   - Capture screenshot evidence.

7. **Step 9 to 12 — Resilience & Security:**
   - Cross-role isolation check (verify unauthorized URLs return 403 or redirect).
   - Session expiry / 401 scenario.
   - Network failure scenario (verify offline state / retry button, no MockData).

8. **Step 18 to 22 — Final QA Sign-off & Report Finalization:**
   - Finalize complete QA matrix in `docs/PHYSICAL_DEVICE_E2E_QA_REPORT.md`.
   - Local git commit (strictly NO `git push`).
