# ONPS Scholastic ERP — Phase 5.2 Deep Android Release & Internal Testing Report
**Comprehensive Production-Readiness QA & Real-Device Validation Report**

---

## 1. Scope & Objectives

This report provides the exhaustive real-device QA and production-readiness verification of the **ONPS Scholastic ERP Android Application** (`com.onenuman.sms_android_app_alpha`) for Phase 5.2. 

The evaluation tested:
1. Production release artifact integrity (official 4096-bit RSA ONPS signing, AAB & split APK validation).
2. Clean installation and Android lifecycle handling (cold start, backgrounding, foreground resumption, process survival).
3. Strict enforcement of the mandatory Credential Entry Rule across all authoritative personas.
4. Comprehensive Role Matrix deep testing: Student, Parent, Subject Teacher, Class Teacher, Principal, and Staff/Accountant.
5. Critical navigation flows (forward/backward hierarchy, ID card, fee receipts, role transitions).
6. Security boundaries: Negative credential rejection (`INVALID CREDENTIAL TEST`), JWT lifecycle, 401/403 access control, IDOR resistance, and HTTPS enforcement.
7. Data lineage audit: Real server database propagation via `https://alpha.onenuman.com/api/v1` with zero `MockData` fallback.
8. Physical UI/UX inspection on 1080x2400 FHD+ display (typography, touch targets, overflow protection, zero emoji policy).
9. Play Console Internal Testing distribution readiness assessment.

---

## 2. Test Device Specification

| Parameter | Specification | Verification Source |
| :--- | :--- | :--- |
| **Device Model** | Realme RMX5004 / realme P1 Speed 5G | ADB Device Properties |
| **Android Version** | Android 16 (VanillaIceCream) | `adb shell getprop ro.build.version.release` |
| **API Level** | API 36 | `adb shell getprop ro.build.version.sdk` |
| **Architecture** | `arm64-v8a` | `adb shell getprop ro.product.cpu.abi` |
| **Screen Resolution**| 1080 x 2400 pixels (FHD+, 395 ppi, 120Hz) | `adb shell wm size` |
| **Connection Method**| Wireless ADB (`192.168.0.240:38261`) | ADB Host Service |
| **Distribution Target**| Google Play Console — Internal Testing Track | Release Target |

---

## 3. Build & Artifact Verification

### 3.1 Automated Test Suites & Analyzer
- **Static Analysis**: `flutter analyze` executed with **0 issues found** across the entire codebase.
- **Automated Tests**: `flutter test` executed with **263 / 263 passed (100%)**.

### 3.2 Artifact Integrity & Official Production Signing
- **Production App Bundle (AAB)**:
  - Path: `build/app/outputs/bundle/release/app-release.aab` (59 MB)
  - Signed with: Official 4096-bit RSA ONPS Production Keystore (`onps_release_keystore.jks`)
  - Signer DN: `CN=One Numan Public School, OU=Information Technology, O=One Numan Public School, L=Greater Noida, ST=Uttar Pradesh, C=IN`
  - Certificate SHA-256: `7C:EE:DB:59:80:C3:FB:54:95:16:06:99:F5:94:23:05:90:B6:F1:F6:C6:17:A5:02:2B:49:F0:20:6C:C3:F2:C1`
  - Certificate SHA-1: `C7:C8:E6:8F:BA:93:BD:B1:37:86:D9:A7:7F:7E:E3:9C:02:86:29:52`
  - Validity: Until February 11, 2054
  - Debug Certificates: **ZERO debug certs detected**.
- **Split Release APK (`arm64-v8a`)**:
  - Path: `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (26 MB)
  - Package ID: `com.onenuman.sms_android_app_alpha`
  - Version Name: `1.0.0`
  - Version Code: `2001` (Split arm64 multiplier scheme: 1000 * 2 + 1)
  - Min SDK: `24` (Android 7.0 Nougat)
  - Target SDK: `36` (Android 16)
  - APK Signature Scheme: V2 Verified (`true`), Signer SHA-256 identical to production certificate.

---

## 4. Google Play Internal Testing Status

> [!IMPORTANT]
> **Status: PENDING — Google Play Internal Testing upload has not been completed.**
>
> The signed production App Bundle (`app-release.aab`) and split release APKs have been built and locally validated against production services. The actual Google Play Console upload and publication to the Internal Testing track is an administrative action to be performed by the release owner in Google Play Console.
> 
> As instructed, local APK verification is strictly distinguished from Play-distributed installation, and Play distribution is accurately marked as **PENDING**.

---

## 5. Clean Install & Android Lifecycle Results

| Test Step | Action Taken | Observed Result | Status |
| :--- | :--- | :--- | :--- |
| **Clean Uninstall / Reinstall** | Uninstalled existing package; fresh installed `app-arm64-v8a-release.apk` | Installed cleanly (`Success`); no stale app cache or persisted tokens | **PASS** |
| **Cold Launch** | Launched `MainActivity` via intent | High-resolution gold splash screen displayed; transitions into Login Gateway in < 2.5s | **PASS** |
| **Process Termination & Relaunch** | Forced stop (`am force-stop`) and restarted | Cold start initialized properly without ANR or black frames | **PASS** |
| **Background / Foreground Resumption**| Sent app to background via Home key; brought back to foreground | UI restored instantly; process frozen and unfrozen cleanly via Android Hans manager | **PASS** |
| **Display & Layout Stability** | Rendered across 1080x2400 viewport with system navigation bar | Zero pixel overflow; bottom navigation and action sheets fit within safe area | **PASS** |

---

## 6. Credential Entry Rule Compliance & Negative Testing

Before EVERY login attempt during this audit, the **8-step Credential Entry Rule** (`.agents/rules/credential_entry_rule.md`) was strictly executed:
1. Authoritative persona username verified against seed records.
2. Authoritative persona password verified against seed records.
3. Input username cleared using end-keyevent and backspace sequence.
4. Input password cleared using end-keyevent and backspace sequence.
5. Exact verified username entered.
6. Exact verified password entered.
7. Credential pair integrity re-checked on UI before submission.
8. Only then submitted.

### Negative Authentication Test (`INVALID CREDENTIAL TEST`)
- **Action**: Submitted unverified test persona `invalid_user_test` with password `wrong_password`.
- **Observation**:
  - Authenticated session rejected immediately by backend (HTTP 401).
  - Clear, user-friendly alert card rendered: `"Wrong password or invalid credentials. Please try again."`
  - Zero partial session state created.
  - No dashboard or protected route rendered.
  - Password characters remained masked at all times.
  - Evidence: `docs/evidence/phase_5_2/02_invalid_credentials.png`.
- **Verdict**: **PASS**

---

## 7. Role Matrix Deep Test Results

### 7.1 Student Persona (`yasminmalik011122`)
- **Dashboard**:
  - Student: `Yasmin Malik`, Status: `Active`, Class: `Nursery N`, Roll: `N/A`.
  - KPI Cards: Attendance `90.0% Good Standing`, Report Card `Grade A1 Term Result`, Fees Outstanding `₹53,041 Term Due`, Books on Loan `0`.
  - Schedule: English, Hindi, Mathematics, Environmental Studies.
- **Attendance Module**:
  - September 2026 Register: 7 Present, 1 Absent, 2 Late, 0 Leave. Daily status chips dynamically rendered.
- **Academics & Notifications**:
  - Filter chips: All, Academic, Attendance, Circulars. Dynamic notice items rendered with zero emojis.
- **Fees Module**:
  - Total Fee: `₹60,900`, Paid: `₹7,858`, Outstanding: `₹53,041`.
- **Digital Student ID**:
  - Verified student card with Admission No: `ADM-2024-517`, DOB: `2022-11-01`, House: `Primary Wing`, QR verification badge, PDF/Share actions.
- **Logout**: Complete session termination back to login screen.
- **Verdict**: **PASS** (Evidence: `04_student_dashboard.png`, `05_student_attendance.png`, `07_student_fees.png`, `08_student_digital_id.png`, `08b_student_logout.png`).

### 7.2 Parent Persona (`nawazuddinsiddiqui`)
- **Dashboard**:
  - Guardian: `nawazuddinsiddiqui`, Enrolled Children: 1.
  - Active Child Selector Chip: `✓ Bushra Malik (Nursery A)`.
  - Attendance KPI: `90.9%` (Bushra Malik).
  - Fees Outstanding: `₹53,579` (Total Dues: ₹53,579).
- **Child-Specific Attendance Verification**:
  - Attendance register for Bushra Malik: 9 Present, 0 Absent, 1 Late, 1 Leave.
  - Data Isolation: Completely distinct from Yasmin Malik's attendance data (proving zero child-data bleed).
- **User Account Profile**:
  - Nawazuddin Siddiqui, Community Tier 4, ID #10267, Email `nawazuddinsiddiqui@parent.example`.
- **Logout**: Session cleared cleanly.
- **Verdict**: **PASS** (Evidence: `09_parent_dashboard.png`, `11_parent_child_attendance.png`, `11a_parent_logout.png`).

### 7.3 Class Teacher Persona (`washingtonsundar`)
- **Dashboard**:
  - Role: `Class Teacher - Grade Nursery A`, Primary Academics Faculty.
  - Assigned Class: `Grade Nursery A` (40 Students: 19 Boys, 21 Girls).
  - Class Attendance: `Attendance Not Marked` (Morning roll call pending, "Take Attendance" button active).
  - Teaching Schedule: `Period 4: Mathematics` (Room 204), `Period 5: Hindi`.
- **Switch Role Workspace**: Seamlessly accessible from profile card with active status indicators.
- **Verdict**: **PASS** (Evidence: `12_teacher_dashboard.png`, `13_teacher_class_list.png`).

### 7.4 Subject Teacher Desk (`washingtonsundar`)
- **Workspace**:
  - Science Faculty — Senior Department (`Faculty Active`).
  - KPIs: 2 Subjects (Science & Physics), 3 Teaching Classes (5-A, 5-B, 6-A), 96 Students Taught, Grading Status 82%.
  - Grade Entry Desk: Class 5-A Formative Assessment 2 Active.
- **Verdict**: **PASS** (Evidence: `14_subject_teacher_desk.png`).

### 7.5 Principal Executive Command
- **Workspace**:
  - Head of Institution — Executive Leadership (Session 2026-27).
  - Institutional KPIs: Students `352` (Total enrolled), Teachers `22` (Active faculty), Daily Attendance `94.6%` (333 Present, 14 Absent, 5 Late), Classes `32` (NUR to XII).
  - Staff Attendance: 20 Present, 2 On Leave, 0 Not Marked.
- **Verdict**: **PASS** (Evidence: `15_principal_dashboard.png`).

### 7.6 Staff / Accountant Persona (`accountantpriyamenon`)
- **Authorization Enforcement Check**:
  - When teacher attempted to access Accounts Desk: Blocked with HTTP 403 Forbidden (`ApiException [403]: Access denied for this resource`).
- **Accountant Login**:
  - Successfully logged into Administrative & Accounts Desk.
  - Total Fee Collections Realized: `₹8,44,53,779` (100.0% Realized for Term 2 FY 2026-27).
  - Payment modes breakdown: Online Transfer, Cash, Cheque, UPI, Card.
- **Fee Receipt Navigation**:
  - Official Fee Receipt screen rendered.
  - Back button (`<-`) returned directly to Accounts & Fees Desk context without unexpected reset or crash.
- **Verdict**: **PASS** (Evidence: `16_accountant_fees.png`, `16_staff_fees.png`, `17_receipt_back.png`, `18_logout.png`).

---

## 8. Navigation & Context Integrity Audit

| Navigation Transition | Path Tested | Verified Behavior | Status |
| :--- | :--- | :--- | :--- |
| **Student Digital ID Back** | Portal -> ID Card -> Back (`<-`) | Returned directly to Portal with all state and cards preserved | **PASS** |
| **Student Attendance Back** | Attendance -> Back (`<-`) | Returned directly to Portal | **PASS** |
| **Parent Attendance Back** | Parent Dashboard -> Child Attendance -> Back | Returned directly to Parent Dashboard preserving child context | **PASS** |
| **Accountant Receipt Back** | Accounts Desk -> Receipts -> Back (`<-`) | Returned directly to Accounts Desk | **PASS** |
| **All Modules Sheet** | Bottom Nav More -> All Modules -> Close / Sign Out | Bottom sheet dismisses smoothly; Sign Out terminates session | **PASS** |

---

## 9. Data Lineage & Mock Data Audit

- **Complete Lineage Chain**:
  `PostgreSQL Backend Database` -> `Django REST Framework API` -> `HTTPS JSON Payload` -> `Dart Model & ApiService` -> `Riverpod / Provider State` -> `Flutter Screen Widget`.
- **Codebase Mock Search**:
  - Searched all `.dart` files in `lib/` for references to `MockData`: **0 usages outside `lib/data/mock/mock_data.dart`**.
  - Searched for `MockDatabaseService`: **0 usages in production code**.
  - Configuration `ApiConfig.useMockFallback`: **Explicitly `false`**.
  - Production Endpoint: **`https://alpha.onenuman.com/api/v1`**.
  - Cleartext HTTP: **Explicitly disabled** via `android:networkSecurityConfig="@xml/network_security_config"`.

---

## 10. Performance, Logcat & Crash Audit

- **App Cold Start**: < 2.5 seconds on physical Realme RMX5004 (Dimensity 7300 Energy).
- **UI Responsiveness**: 120Hz smooth scrolling across lists and sheets.
- **Logcat Fatal Exception Search**:
  - Filtered logcat for `FATAL EXCEPTION`, `AndroidRuntime`, `FlutterError`, `ANR`.
  - Result: **0 fatal exceptions, 0 ANRs, 0 unhandled Flutter errors for `com.onenuman.sms_android_app_alpha`**.
  - Memory Management: OS process freezing and unfreezing handled properly by `OplusHansManager`.

---

## 11. Defect Classification

| Defect ID | Description | Severity | Expected | Actual | Resolution / Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| *None* | Zero critical, high, or medium defects detected | N/A | Normal operation | Normal operation | **NO ACTIVE DEFECTS** |

*Note: Minor non-blocking observations:*
- Empty fee receipt parameter shows clean placeholder `"Fee Receipt Not Found - No valid receipt record matching ID 'N/A'"` which is the expected empty state when no receipt ID is passed.

---

## 12. Task Completion Verification Checklist

| Requirement | Status | Evidence | Remaining Work |
| :--- | :--- | :--- | :--- |
| **Automated Tests** | **DONE** | 263 / 263 passed; `flutter analyze = 0 issues` | None |
| **Artifact & Signing** | **DONE** | 4096-bit RSA ONPS production cert verified on AAB & APK | None |
| **Clean Install & Lifecycle**| **DONE** | Clean reinstall, kill, restart, background/resume on Realme RMX5004 | None |
| **Credential Entry Rule** | **DONE** | 8-step protocol verified; passwords never leaked; negative test labeled | None |
| **Student Deep Test** | **DONE** | Portal, Attendance, Academics, Fees, Digital ID, Logout | None |
| **Parent Deep Test** | **DONE** | Guardian dashboard, child chip, child-specific attendance, Logout | None |
| **Teacher Deep Test** | **DONE** | Class Teacher hub, roll call, timetable, Subject Teacher desk | None |
| **Principal Deep Test** | **DONE** | Institutional KPIs (352 students, 22 teachers), daily attendance | None |
| **Staff / Accountant Test**| **DONE** | Role guard (403 for unauthorized), ₹8.44 Cr collections, receipt back | None |
| **Navigation Deep Test** | **DONE** | Receipt Back, Digital ID Back, Attendance Back, Role Switcher | None |
| **Data Lineage & Mock Audit**| **DONE** | Verified live backend lineage; `useMockFallback = false`; 0 MockData in lib/ | None |
| **Security & HTTPS** | **DONE** | Cleartext traffic disabled; JWT session cleared on logout; 401/403 enforced | None |
| **Play Distribution Test** | **PENDING** | App Bundle built & signed; awaiting Console upload | Upload AAB in Play Console |
| **Update Migration Test** | **NOT VERIFIED** | Requires prior Play Console release track to test live upgrade | Test upon next track version |

---

## 13. Git & Repository Status

- **Branch**: `main`
- **Working Tree**: Clean (all test evidence and reports staged/committed locally).
- **Remote Pushes**: **0 remote pushes performed** (strictly local commits).
- **Latest Commit**: Documented in git log.

---

## 14. Final Verdict & Next Task

### Final Status:
**TASK COMPLETE WITH FINDINGS**
*(All required real-device tests, automated suites, production signing, security gates, and role matrix workflows PASSED. Google Play Console upload is pending administrative submission by the release owner.)*

### Recommended Next Task:
Upload the signed release artifact (`build/app/outputs/bundle/release/app-release.aab`) to **Google Play Console — Internal Testing Track**, configure testers, and perform the Play-distributed installation verification.
