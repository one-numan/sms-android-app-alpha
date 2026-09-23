# ANDROID MOCKDATA REMEDIATION PHASE 4

**Target Package:** `com.onps.sms_android_app_alpha`  
**Date:** September 21, 2026  
**Phase:** 4.0.3 — Production MockData Remediation Plan  
**Status:** `PASS_WITH_REMAINING_FINDINGS`

---

## 1. Authentication Gate

- **Behavior Verified:**
  - HTTP 401 Unauthorized → `ApiClient` triggers `AuthState.signOut()`.
  - Tokens cleared (`TokenStorage.clearSession()`).
  - User identity (`_currentUsername`) reset to `''`.
  - Role state reset.
  - Persona state (`_userProfile`) set to `null`.
  - `GoRouter` refresh listenable triggers immediate redirect to `/login`.
- **Zero Persona Leak:** Unauthenticated users or expired sessions can **never** render `Good Morning, Rajesh Sharma` or any mock dashboard layout under a 401 error.

---

## 2. Production MockData Before

- **Total Production Screens Accessing MockData:** 22 screens
- **Default Auth Persona:** `'rajesh.sharma'` default initialized in `AuthState`
- **Error Fallback Behavior:** Fallback to static `MockData` on API exception

---

## 3. Production MockData After

- **Total Production Screens Accessing MockData:** 14 screens (8 screens remediated to consume live APIs or dynamic state exclusively)
- **Default Auth Persona:** `_currentUsername = ''`, `_userProfile = null` in `AuthState`
- **Error Handling:** 401 triggers `/login` redirect; 400/403/404/500 render clean error state with NO fallback to `MockData`.

---

## 4. Remediated Screens

| Screen | Old Source | New Source | API | Status |
|--------|------------|------------|-----|--------|
| **Parent Dashboard** | Hardcoded/Mock Fallback | LIVE_API | `GET /api/v1/parent/dashboard/` | REMEDIATED |
| **Student Hub** | Hardcoded/Mock Fallback | LIVE_API | `GET /api/v1/student/hub/` | REMEDIATED |
| **Class Teacher Dashboard** | MockData | LIVE_API | `GET /api/v1/teacher/class-dashboard/` | REMEDIATED |
| **Subject Teacher Dashboard** | MockData.teachers[1] | LIVE_API / Dynamic State | `GET /api/v1/teacher/subject-dashboard/` | REMEDIATED |
| **Subject Teacher Cohorts** | MockData.teachers[1] | LIVE_API / Dynamic State | `GET /api/v1/teacher/subject-dashboard/` | REMEDIATED |
| **Accountant Dashboard** | MockData.feePayments | LIVE_API | `GET /api/v1/accounts/dashboard/` | REMEDIATED |
| **Notice Board** | MockData.announcements | LIVE_API | `GET /api/v1/announcements/` | REMEDIATED |
| **Inventory Desk** | MockData.inventory | LIVE_API | `GET /api/v1/inventory/items` | REMEDIATED |

---

## 5. Remaining Production MockData

| Screen | Mock Source | Reason | Status |
|--------|-------------|--------|--------|
| **Teacher Timetable** | `MockData.timetable` | Missing Django REST API | `BACKEND_SERVICE_MISSING` |
| **Class Timetable** | `MockData.timetable` | Missing Django REST API | `BACKEND_SERVICE_MISSING` |
| **Faculty Allocation** | `MockData.teachers` | Missing Django REST API | `BACKEND_SERVICE_MISSING` |
| **Staff Directory** | `MockData.teachers` | Missing Django REST API | `BACKEND_SERVICE_MISSING` |
| **Class Info** | `MockData.classes` | Missing Django REST API | `BACKEND_SERVICE_MISSING` |
| **Class Student Directory** | `MockData.students` | Missing Django REST API | `BACKEND_SERVICE_MISSING` |
| **Student Dossier** | `MockData.students` | Missing Django REST API | `BACKEND_SERVICE_MISSING` |
| **Digital Student ID Card** | `MockData.students` | Missing Django REST API | `BACKEND_SERVICE_MISSING` |
| **Faculty Leave** | `MockData.leaves` | Missing Django REST API | `BACKEND_SERVICE_MISSING` |
| **Announcement Approval** | `MockData.announcements` | Missing Django REST API | `BACKEND_SERVICE_MISSING` |
| **Admissions Enquiry** | `MockData.enquiries` | Missing Django REST API | `BACKEND_SERVICE_MISSING` |
| **Applications Enrollment** | `MockData.applications` | Missing Django REST API | `BACKEND_SERVICE_MISSING` |
| **Librarian Dashboard** | `MockData.books` | Missing Django REST API | `BACKEND_SERVICE_MISSING` |
| **Parents Directory** | `MockData.students` | Missing Django REST API | `BACKEND_SERVICE_MISSING` |

---

## 6. Missing Backend Modules

| Module | Required API | Current Status |
|--------|--------------|----------------|
| **Faculty Timetables** | `GET /api/v1/faculty/timetable/` | `BACKEND_SERVICE_MISSING` |
| **Faculty Allocation** | `GET/POST /api/v1/faculty/allocation/` | `BACKEND_SERVICE_MISSING` |
| **Staff Directory** | `GET /api/v1/faculty/staff/` | `BACKEND_SERVICE_MISSING` |
| **Student Dossier** | `GET /api/v1/students/<id>/dossier/` | `BACKEND_SERVICE_MISSING` |
| **Digital Student ID Card** | `GET /api/v1/students/<id>/id-card/` | `BACKEND_SERVICE_MISSING` |
| **Faculty Leave Management** | `GET/POST /api/v1/attendance/faculty-leave/` | `BACKEND_SERVICE_MISSING` |
| **Announcement Approval** | `GET/POST /api/v1/announcements/approval/` | `BACKEND_SERVICE_MISSING` |
| **Admissions & Enquiries** | `GET/POST /api/v1/admissions/enquiry/` | `BACKEND_SERVICE_MISSING` |
| **Librarian & Book Circulation** | `GET/POST /api/v1/library/books/` | `BACKEND_SERVICE_MISSING` |
| **Parents Directory** | `GET /api/v1/parents/directory/` | `BACKEND_SERVICE_MISSING` |
| **Unified Search** | `GET /api/v1/admin/search/` | `BACKEND_SERVICE_MISSING` |
| **School Setup** | `GET/PATCH /api/v1/admin/school-setup/` | `BACKEND_SERVICE_MISSING` |

---

## 7. Persona/Hardcoded Data

- **Default Username Initializer:** Removed `_currentUsername = 'rajesh.sharma'` default from `AuthState`. Unauthenticated username is `''`.
- **Role Switcher Sheet:** Removed `Shubman Gill` / `Rajesh Sharma` hardcoded fallback checks. Uses dynamic `AuthState.fullName`.

---

## 8. Error Handling

- **SUCCESS:** Renders live backend API payload.
- **LOADING:** Displays progress indicator widget.
- **EMPTY:** Displays legitimate empty state UI.
- **401 Unauthorized:** Clears token, clears `AuthState`, redirects to `/login`.
- **403 Forbidden / 404 / 500 Network Error:** Displays red error alert banner, **NEVER** falls back to `MockData`.

---

## 9. AuthState

- Clean unauthenticated representation (`_isAuthenticated = false`, `_currentUsername = ''`, `_userProfile = null`).
- Unauthenticated requests trigger immediate redirect via `GoRouter`.

---

## 10. Automated Tests

- `flutter analyze`: **PASSED** (0 issues)
- `flutter test`: **PASSED** (207 / 207 tests passed)
- `flutter build apk --debug`: **PASSED** (`build/app/outputs/flutter-apk/app-debug.apk`)

---

## 11. Physical Device Verification

- **Device:** RMX5004 (`build/app/outputs/flutter-apk/app-debug.apk`)
- **No Session:** Launches directly to `/login`.
- **Valid Login:** Routes to correct persona dashboard.
- **401 Unauthorized:** Clears tokens and redirects to `/login`. Zero dashboard leak.
- **Logout:** Clears state and returns to `/login`.

---

## 12. Remaining Risks

1. **14 Missing Backend Microservices:** Until Django endpoints are implemented, these 14 screens remain backed by static `MockData`.
2. **Offline/Test Mode:** `ApiConfig.useMockFallback` remains available exclusively for offline unit/widget testing.

---

## 13. Recommended Next QA Phase

With Phase 4.0.3 remediation complete, the project is ready for persona-specific QA walkthroughs in the following order:

```text
Authentication Gate (PASSED)
        ↓
P0 fixed (PASSED)
        ↓
P1 API-backed MockData remediation (COMPLETED)
        ↓
Backend-missing modules documented (COMPLETED)
        ↓
Final MockData scan (COMPLETED)
        ↓
Class Teacher QA
        ↓
Subject Teacher QA
        ↓
Parent QA
        ↓
Student QA
        ↓
Admin/Principal QA
        ↓
Offline/cache QA
```
