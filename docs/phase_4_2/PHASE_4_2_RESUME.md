# Phase 4.2 Resume Instructions

## 1. What has already been completed?
- Baseline audit across the entire codebase (`lib/`).
- Initialized persistent tracking architecture in `docs/phase_4_2/`.
- **Batch A (Shared Authentication / Profile / Settings / Login / Briefing) is 100% completed and verified**:
  - `AuthState`: Default persona removed; unauthenticated by default; sign-out purges all state; 401 cleared.
  - `AccountProfileScreen` & `AccountProfileSheet`: All `fallbackProfile` objects purged; dynamically binds to backend `/api/v1/account/profile/`; neutral "Not available" for unpopulated fields.
  - `AccountSettingsScreen` & `AccountSettingsSheet`: MockData session/school replaced with centralized `AppConfig`.
  - `LoginScreen` & `MorningBriefingTransitionScreen`: Replaced MockData with `AppConfig` and live user greeting.
  - Zero production-reachable MockData in Batch A.
- **Batch B (Student / Academic) is 100% completed and verified**:
  1. `AllStudentsLedgerScreen`: Binds to `StudentApiService.getStudents()`, live search, grade/section filtering, error handling, 0 MockData.
  2. `MarksEntryDeskScreen`: Binds to `StudentApiService.getStudents(classId: '1')`, dynamic score controllers, 0 MockData.
  3. `AcademicReportCardScreen`: Purged 8 MockData references; binds to `StudentApiService.getReportCard()`, dynamic session, empty states, 0 MockData.
  4. `DailyRollCallScreen`: Teacher identity and class assignment resolved from authenticated `AuthState.userProfile`, 0 MockData.
  5. `ClassTeacherDashboardScreen`: Student count, attendance calculations, announcements bound to live API / dashboard summary, 0 MockData.
  6. `SubjectTeacherDashboardScreen`: Dynamic class allocations, 0 MockData.
  7. `SubjectTeacherCohortsScreen`: Dynamic class cohorts roster, 0 MockData.
  - Zero production-reachable MockData in Batch B.
- **Batch C (Finance / Fees) is 100% completed and verified**:
  1. `lib/router.dart`: Removed `MockData.feePayments` parameter lookup on line 534; passed path `id` directly to `FeeReceiptScreen`; removed unused `mock_data.dart` import.
  2. `FeeReceiptScreen`: Purged 5 MockData references; binds to `FeeApiService.getFeeReceipt()`; renders real `FeePayment` voucher; header uses `AppConfig.schoolName` and `AppConfig.campusAddress`; explicit loading, error, and empty not-found states; 0 MockData.
  3. `AccountantDashboardScreen`: Purged `MockData.feePayments`; binds to `AccountantApiService.getDashboard()` and `FeeApiService.getFeeLedger()`; renders live realization KPI, total collections, dues, and payment modes breakdown; empty state card when no transactions exist; 0 MockData.
  - Zero production-reachable MockData in Batch C.
  - Quality gates: `flutter analyze` (0 issues), `flutter test` (227/227 passed), `flutter build apk --debug` (success, 13.7s).

## 2. What files were changed in Batch C?
- `lib/models/models.dart`: Added optional student metadata to `FeePayment` and added `factory FeePayment.fromJson(Map<String, dynamic> json)`.
- `lib/data/services/fee_api_service.dart`: Updated `getFeeReceipt()` to return typed `FeePayment?` model.
- `lib/router.dart`: Removed `MockData.feePayments` lookup and removed unused import.
- `lib/screens/fees/fee_receipt_screen.dart`: Rewritten to stateful live API widget with 0 MockData.
- `lib/screens/dashboards/accountant_dashboard_screen.dart`: Rewritten to stateful live API widget with 0 MockData.
- `test/batch_c_mockdata_elimination_test.dart`: Added 10 dedicated verification tests.

## 3. What APIs were used in Batch C?
- `GET /api/v1/fees/receipt/<id>/` (official receipt voucher, verified 200 OK)
- `GET /api/v1/accounts/dashboard/` (accountant dashboard metrics, verified 200 OK)
- `GET /api/v1/fees/ledger/` (student ledger balance & transactions, verified 200 OK)

## 4. What remains?
- **Batch D**: Admin / Operations (17 production MockData references across 5 files)
  - `lib/screens/faculty/principal_teachers_screen.dart` (3)
  - `lib/screens/faculty/principal_section_detail_screen.dart` (4)
  - `lib/screens/faculty/faculty_allocation_screen.dart` (1)
  - `lib/screens/admin/school_setup_screen.dart` (4)
  - `lib/screens/admin/unified_search_screen.dart` (5)
- **Batch E**: Calendar / Transport / Inventory (12 production MockData references across 5 files)
- **Final Batch**: Global cleanup, residual dependency verification, & `docs/phase_4_2/PHASE_4_2_FINAL_REPORT.md`

## 5. What is currently broken?
Nothing. The app compiles cleanly, all 227 tests pass, and zero analyzer issues exist.

## 6. What tests passed?
227/227 tests in `flutter test` passed (including 10 dedicated Batch C tests in `test/batch_c_mockdata_elimination_test.dart`).

## 7. What tests failed?
0 tests failed.

## 8. What should NOT be changed?
- Batch A files (Auth, Profile, Settings, Login, Briefing)
- Batch B files (Student ledger, marks entry, report card, roll call, teacher dashboards)
- Batch C files (Fee receipt, accountant dashboard, router fee routes)
- The 14 previously migrated screens from Phase 4.1
- Do not delete `lib/data/mock/mock_data.dart` yet (it will be cleaned up in the final batch after global verification).
- Do NOT begin Batch D until instructed by the user.

## 9. Next Immediate Action
Create Git Checkpoint for Batch C:
`git commit -m "phase4.2: batch-c checkpoint finance-elimination"`
Then STOP and wait for next instruction.
