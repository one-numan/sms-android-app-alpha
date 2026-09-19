# ONPS School ERP — Project Context (`PROJECT_CONTEXT.md`)

> **Primary AI Entry Point**: Every AI agent (Gemini, Claude, ChatGPT, Antigravity) working on the ONPS School ERP MUST read this document before touching any code.

---

## 1. Project Overview & Business Purpose
- **Project Name**: One Numan Public School (ONPS) Scholastic ERP
- **Product Nature**: Existing, multi-persona School Management System / School ERP application built as an offline-first mobile application backed by an authoritative relational data model schema.
- **Current Core Mandate**: Preserve existing visual UI/UX (Espresso Heritage Academic theme), respect verified data contracts & business rules, eliminate fake/hallucinated data, correct broken/missing navigation, and maintain strict multi-model project context.

---

## 2. Technology Stack & Technical Architecture
- **Frontend Framework**: Flutter (Dart) targeting Android ARM64 (`minSdkVersion: 21`, `targetSdkVersion: 34`).
- **State Management & Data Layer**:
  - In-Memory Repository Layer (`MockData` singleton in `lib/data/mock_data.dart`) serving state across all 53 screens.
  - Native SQLite Engine (`sqflite: ^2.3.3+1`, database file `onps_erp.db`) powering zero-latency full-text FAQ & knowledge base queries.
  - Planned backend connector: REST API integration targeting Django 5.1.4.
- **Routing**: `go_router` (`lib/router.dart`) with centralized path declarations and parameter handling.
- **Design System**: Espresso Heritage Academic Palette (`#FCFAF6` Canvas, `#3E2A22` Primary Dark, `#D4AF37` Accent Gold, `#F7F1E8` Surface).
- **Iconography**: Standard Material Symbols & Material Icons exclusively. **STRICT RULE: 0 Unicode Emojis**.

---

## 3. Supported Personas & User Roles
1. **Student**: Self-service profile, report cards, digital ID card, fee dues (read-only), attendance matrix, timetable, bus transit tracking, notice board.
2. **Parent**: Multi-student oversight, fee payment receipts, report cards, leave applications, bus transit, notice board, PTM booking.
3. **Subject Teacher**: Subject-wise assessment marks entry desk, teaching timetable, section student roster, leave requests, staff notices.
4. **Class Teacher**: Morning roll call register (P/A/L/E), homeroom student list, class timetable, leave request approval, marks sign-off.
5. **Principal**: Executive dashboard, 13-grade K-12 academic overview, section details, teacher directory & CRUD, circular drafting & moderation queue, admissions approval.
6. **Vice Principal**: Academic monitoring, substitute teacher allocation, discipline logs, assembly supervision.
7. **Accountant**: Fee collection ledger, receipt voucher generation, dues clearance tracking, student list (read-only dues).
8. **Librarian**: Book catalog search, circulation issue/return desk, overdue fine tracking.
9. **Super Admin**: System-wide configuration, role switcher, multi-device session management, audit logs.

*Note*: Teacher roles are dynamic assignments, not distinct user entities. A single teacher can hold both Class Teacher and Subject Teacher assignments simultaneously.

---

## 4. Current Development Phase & Architectural Decisions
- **Phase**: **Finalizing UI/UX Data Contracts against In-Memory & Relational Schema (Pre-API Integration)**.
- **Key Decision 1 (Accepted)**: Screen presentation and navigation must consume verified domain structures from `lib/models/models.dart` and `lib/data/mock_data.dart` or SQLite `onps_erp.db`. No inline mock data or fake strings in UI files.
- **Key Decision 2 (Accepted)**: Read-Only Dues Enforcement. Mobile application does not execute live monetary transactions via payment gateways; displays audited dues summaries and receipt vouchers.
- **Key Decision 3 (Accepted)**: Zero Telecom SMS Policy. School notices and circulars are delivered strictly via in-app push notifications and email.

---

## 5. Navigation & Context Map
Before working on specific components, consult these deeper context files:
- [BUSINESS_LOGIC.md](file:///Users/onenuman/Documents/GitHub/sms-android-app/docs/ai-context/BUSINESS_LOGIC.md): Verified K-12 operational rules.
- [DATA_MODEL.md](file:///Users/onenuman/Documents/GitHub/sms-android-app/docs/ai-context/DATA_MODEL.md): Exact entity schemas, fields, and relationships.
- [ROLE_PERMISSIONS.md](file:///Users/onenuman/Documents/GitHub/sms-android-app/docs/ai-context/ROLE_PERMISSIONS.md): Capability and access matrix.
- [SCREEN_INVENTORY.md](file:///Users/onenuman/Documents/GitHub/sms-android-app/docs/ai-context/SCREEN_INVENTORY.md): Complete list of all 53 screens.
- [ROUTE_MAP.md](file:///Users/onenuman/Documents/GitHub/sms-android-app/docs/ai-context/ROUTE_MAP.md): Router paths, aliases, and missing routes.
- [NAVIGATION_MAP.md](file:///Users/onenuman/Documents/GitHub/sms-android-app/docs/ai-context/NAVIGATION_MAP.md): Role-wise bottom dock, sheets, and action flows.
- [FEATURE_STATUS.md](file:///Users/onenuman/Documents/GitHub/sms-android-app/docs/ai-context/FEATURE_STATUS.md): Implemented vs planned status per domain.
- [UI_UX_RULES.md](file:///Users/onenuman/Documents/GitHub/sms-android-app/docs/ai-context/UI_UX_RULES.md): Espresso Heritage design rules & zero emoji mandate.
- [TERMINOLOGY.md](file:///Users/onenuman/Documents/GitHub/sms-android-app/docs/ai-context/TERMINOLOGY.md): Approved school lexicon.
- [KNOWN_ISSUES.md](file:///Users/onenuman/Documents/GitHub/sms-android-app/docs/ai-context/KNOWN_ISSUES.md): Active bugs, route exceptions, and dead ends.
- [DECISIONS.md](file:///Users/onenuman/Documents/GitHub/sms-android-app/docs/ai-context/DECISIONS.md): Key technical architectural decisions.
- [CHANGELOG.md](file:///Users/onenuman/Documents/GitHub/sms-android-app/docs/ai-context/CHANGELOG.md): Record of AI and developer modifications.
