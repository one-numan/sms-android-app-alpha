# ONPS School ERP — Implementation Status Ledger (`IMPLEMENTATION_STATUS.md`)

> **Tracked Progress**: Synchronized with live project state as of September 2026.

---

## 1. Status Summary Dashboard
- **Completed & Verified Screens**: 53 / 53
- **Automated Test Suite**: **129 / 129 Passing** (`flutter test`)
- **Static Analyzer**: **0 Errors, 0 Warnings, 0 Lints** (`flutter analyze`)
- **Physical Device Deployment**: Verified on Realme RMX5004 (Android 16 / API 36)

---

## 2. Granular Track Status

### 2.1 Completed (Verified in Code & Tests)
- [x] **53 UI Screens & Dashboards**: Built with Espresso Heritage Academic theme.
- [x] **Universal Role Switcher**: Instant switching between 9 personas.
- [x] **Help & FAQ Knowledge Base**: SQLite offline storage (`onps_erp.db`) pre-seeded with 14 production FAQ records.
- [x] **Principal Executive Tools**: 13-grade K-12 section matrix, section detail, and teacher management desk with assignment validation.
- [x] **Role-Based Bottom Navigation**: Scoped 5-item bottom docks for Student, Parent, Class Teacher, Subject Teacher, and Principal.
- [x] **Zero Emoji Enforcement**: 100% compliance across all 53 screen widgets.

### 2.2 In Progress (Current Iteration)
- [/] **Navigation Audit & Route Exception Resolution**: Registering missing route aliases (`/notices`, `/students/digital-id`, `/attendance/student-leave`, `/principal/announcements/approval`).
- [/] **AI Context Knowledge Base Setup**: Populating `docs/ai-context/` for multi-model interoperability.

### 2.3 Next (Immediate Backlog)
- [ ] **Needs Attention Feed Integration (`GET /api/v1/attention/`)**:
  - Live, shipped backend endpoint (`docs/attention_api_android.md`).
  - Wire cross-role attention feed across all 7 role dashboards with dynamic `type`-based rendering and 11 deep-link destinations.
- [ ] **Teacher "Today" Status Integration (`GET /api/v1/teacher/today-status/`)**:
  - Spec defined (`docs/today_status_api_android.md`).
  - Authoritatively replaces client-side school open/off checks, teaching period list-index guessing, and attendance gating.
- [ ] **Native PDF Export Wiring**: Connect PDF buttons (Fee Receipt, Report Card, Timetable) to `pdf` and `path_provider` packages.
- [ ] **Android 13+ Predictive Back Callback**: Add `android:enableOnBackInvokedCallback="true"` in `AndroidManifest.xml`.
- [ ] **Deep Link Back Guard**: Ensure safe pop/go navigation on deep-linked secondary screens (`if (context.canPop()) context.pop() else context.go('/')`).

### 2.4 Deferred / Future Phase
- [ ] **Django 5.1.4 REST API Connector**: Replace `MockData` singleton with repository HTTP endpoints & JWT auth tokens.
- [ ] **Firebase Cloud Messaging (FCM)**: Native push notification payload handler.
- [ ] **Camera QR Scanner**: Mobile scanner integration for digital ID turnstile validation.

