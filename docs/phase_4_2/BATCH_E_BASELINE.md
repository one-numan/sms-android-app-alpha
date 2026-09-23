# Batch E Fresh Baseline: Calendar / Transport / Inventory / Events / Notices

**Date**: September 23, 2026  
**Status**: BASELINE_ESTABLISHED  
**Target**: Eliminate all 11 production-reachable MockData occurrences from Batch E.

---

## 1. Global Baseline Audit

- **Total Matches in `lib/`**: 41
- **MockData Repository (`lib/data/mock/mock_data.dart`)**: 26
- **Test-environment only guard (`lib/data/mock/auth_state.dart:68-70`)**: 3
- **Batch A/B/C/D Production MockData**: **0** (All previous batches verified clean)
- **Batch E Production-Reachable Targets**: **11** references across 5 files

---

## 2. Batch E File Breakdown

| Target File | Line Numbers | MockData Reference | Entity | Lineage |
| :--- | :--- | :--- | :--- | :--- |
| `lib/screens/library_transport_inventory/inventory_desk_screen.dart` | 39 | `MockData.inventory` | Inventory items | `InventoryApiService.getInventoryItems()` $\rightarrow$ UI |
| `lib/screens/library_transport_inventory/bus_transit_screen.dart` | 33, 48, 50, 355, 376 | `MockData.routes`, `MockData.students` | Bus routes, students | `TransitApiService.getStudentTransit()` $\rightarrow$ UI |
| `lib/screens/calendar_announcements/events_desk_screen.dart` | 33 | `MockData.events` | Institutional events | `AnnouncementApiService` / Events API $\rightarrow$ UI |
| `lib/screens/calendar_announcements/academic_calendar_screen.dart` | 28, 29 | `MockData.holidays`, `MockData.events` | Calendar holidays & events | Calendar / Holidays API $\rightarrow$ UI |
| `lib/screens/calendar_announcements/notice_board_screen.dart` | 53, 107 | `MockData.announcements` | Circulars & notices | `AnnouncementApiService.getAnnouncements()` $\rightarrow$ UI |

---

## 3. Existing vs Missing APIs

1. **Inventory**:
   - `InventoryApiService` exists in `lib/data/services/inventory_api_service.dart`.
   - Has `GET /api/v1/inventory/items/` returning `List<dynamic>`.
2. **Transport / Transit**:
   - `TransitApiService` exists in `lib/data/services/transit_api_service.dart`.
   - Has `GET /api/v1/transport/student-route/` and `GET /api/v1/transport/routes/`.
3. **Notices**:
   - `AnnouncementApiService` exists in `lib/data/services/announcement_api_service.dart`.
   - Has `GET /api/v1/announcements/` returning `List<dynamic>`.
4. **Events & Calendar**:
   - Announcement/events APIs or structured session dates provide live data.

---

## 4. Execution Plan
1. **Target 1: Inventory Desk** (`inventory_desk_screen.dart`): Purge `MockData.inventory`, bind to `InventoryApiService`, add loading/error/empty state.
2. **Target 2: Bus Transit** (`bus_transit_screen.dart`): Purge `MockData.routes` and `MockData.students`, bind to `TransitApiService`, handle genuine empty/error state.
3. **Target 3: Events Desk** (`events_desk_screen.dart`): Purge `MockData.events`, bind to live event service/models.
4. **Target 4: Academic Calendar** (`academic_calendar_screen.dart`): Purge `MockData.holidays` and `MockData.events`, load from live service.
5. **Target 5: Notice Board** (`notice_board_screen.dart`): Purge fallback `MockData.announcements`, strictly display live notices or genuine empty state.
6. Verify 0 production MockData remains across entire app.
7. Run `flutter analyze`, `flutter test`, `flutter build apk --debug`.
8. Checkpoint locally (NO PUSH).
