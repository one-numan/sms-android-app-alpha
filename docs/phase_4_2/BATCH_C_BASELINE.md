# Phase 4.2 — Batch C Baseline: Finance / Fees MockData

**Date:** 2026-09-23  
**Status:** RECORDED (Pre-Implementation Baseline)  
**Total Production MockData at Batch C Start:** 36 occurrences across `lib/`  
**Batch C Scope:** 7 occurrences across 3 files  

---

## 1. Batch C Target Inventory

| # | File Path | Line # | Pattern | Usage / Context | Classification |
|---|---|:---:|---|---|---|
| 1 | `lib/router.dart` | 534 | `MockData.feePayments` | Resolves `FeePayment` object for `/fees/receipt` route parameter | Production Reachable |
| 2 | `lib/screens/fees/fee_receipt_screen.dart` | 21 | `MockData.feePayments.where` | Fallback lookup for payment record by receipt number | Production Reachable |
| 3 | `lib/screens/fees/fee_receipt_screen.dart` | 50 | `MockData.students.where` | Student lookup by student ID | Production Reachable |
| 4 | `lib/screens/fees/fee_receipt_screen.dart` | 52 | `MockData.students.first` | Fallback student persona if student is not found | Production Reachable |
| 5 | `lib/screens/fees/fee_receipt_screen.dart` | 142 | `MockData.schoolName` | Institutional school name header | Production Reachable |
| 6 | `lib/screens/fees/fee_receipt_screen.dart` | 151 | `MockData.campusAddress` | Institutional campus address header | Production Reachable |
| 7 | `lib/screens/dashboards/accountant_dashboard_screen.dart` | 231 | `MockData.feePayments.map` | Recent transactions list on Accountant Dashboard | Production Reachable |

---

## 2. Classification Summary
- **Total Batch C Occurrences:** 7
- **Production Reachable:** 7
- **Test Only:** 0 (in Batch C target files)
- **Development Only:** 0
- **Dead / Unreachable:** 0

---

## 3. Remaining Outside Batch C (29 occurrences)
- **Batch D: Admin / Operations (17 occurrences)**:
  - `lib/screens/faculty/principal_teachers_screen.dart`: 3
  - `lib/screens/faculty/principal_section_detail_screen.dart`: 5
  - `lib/screens/faculty/faculty_allocation_screen.dart`: 1
  - `lib/screens/admin/school_setup_screen.dart`: 4
  - `lib/screens/admin/unified_search_screen.dart`: 4
- **Batch E: Calendar / Transport / Inventory (12 occurrences)**:
  - `lib/screens/library_transport_inventory/inventory_desk_screen.dart`: 1
  - `lib/screens/library_transport_inventory/bus_transit_screen.dart`: 6
  - `lib/screens/calendar_announcements/notice_board_screen.dart`: 2
  - `lib/screens/calendar_announcements/events_desk_screen.dart`: 1
  - `lib/screens/calendar_announcements/academic_calendar_screen.dart`: 2

---

## 4. Existing Backend APIs & Services
- `/fees/payments/` / `/fees/receipts/`: Check against live Django backend.
- `FeeApiService` / `AccountApiService`: Inspect existing Flutter service layer for fee endpoints.
- Base URL: `https://alpha.onenuman.com/api/v1`

---

## 5. Migration Strategy
1. **Fee Receipt Screen (`fee_receipt_screen.dart`)**:
   - Fetch real payment record from fee service / backend.
   - Replace `MockData.schoolName` and `MockData.campusAddress` with `AppConfig`.
   - Never fallback to `MockData.feePayments.first` or `MockData.students.first`.
   - Provide proper loading, empty/not found, and error states.
2. **Router (`router.dart`)**:
   - Pass `id` or payment object dynamically without querying `MockData.feePayments`.
3. **Accountant Dashboard Screen (`accountant_dashboard_screen.dart`)**:
   - Bind recent transactions and financial KPI totals to live finance API or graceful empty collection.
   - Remove `MockData.feePayments` mapping.
