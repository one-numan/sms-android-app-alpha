# AUTHENTICATION_GATE_FIX_REPORT.md — Phase 4.0.1 Authentication Failure Gate Verification

**Target Architecture:** School Management ERP Android App (`sms-android-app-alpha`)  
**Backend Gateway:** `https://alpha.onenuman.com/api/v1`  
**Physical Device:** Wireless ADB `192.168.0.240:36409` (Realme RMX5004, Android 16)  
**Verification Date:** September 21, 2026  
**Final Status:** **AUTHENTICATION_GATE_FIXED_PASS**

---

## 1. Root Cause Analysis

During Phase 4 physical device testing, when an HTTP 401 Unauthorized response occurred during an API call, the application displayed an inline error banner (`ApiException [401]: Unauthorized session. Please log in again.`), but **continued to render the protected Parent Dashboard screen with static data ("Good Morning, Rajesh Sharma")**.

The investigation revealed three distinct architectural defects:

1. **Default AuthState State Contamination (`lib/data/mock/auth_state.dart`):**
   - The `AuthState` constructor initialized `_isAuthenticated = true`, `_currentRole = UserRole.parent`, and `_currentUsername = 'rajesh.sharma'` by default.
   - On unauthenticated app starts, `GoRouter`'s guard (`if (!isAuth && !isPublicRoute) return '/login'`) evaluated `isAuth == true` and allowed navigation directly to `/` (`ParentDashboardScreen`).

2. **Hardcoded UI Personas (`lib/screens/dashboards/parent_dashboard_screen.dart` & `student_hub_screen.dart`):**
   - `ParentDashboardScreen` (Line 211) hardcoded `'Good Morning, Rajesh Sharma'` directly in the header widget instead of deriving the name from the authenticated user profile.
   - `StudentHubScreen` (Line 82) fell back to `'Bushra Malik'` if backend `_hubData` was null.

3. **Absence of Centralized 401 Session Teardown (`lib/core/api/api_client.dart`):**
   - `ApiClient._handleResponse` threw `UnauthorizedException()` on HTTP 401, but no central listener intercepted this exception to trigger session teardown.
   - Individual dashboard screens caught exceptions in local `catch (e)` blocks, setting an inline `_errorMessage` banner without invalidating `AuthState` or clearing `TokenStorage`.
   - Because `authState.signOut()` was never called, `authState.isAuthenticated` remained `true`, preventing `GoRouter` from redirecting the user to `/login`.

---

## 2. Why "Rajesh Sharma" Was Rendered

`Rajesh Sharma` was rendered on unauthenticated startup or after an HTTP 401 error because:
1. `AuthState` started with `_isAuthenticated = true` and `_currentUsername = 'rajesh.sharma'`.
2. `GoRouter` allowed access to `/parent/dashboard`.
3. `ParentDashboardScreen` called `ParentApiService.getDashboard()`.
4. The server returned HTTP 401 (`{"detail": "Authentication credentials were not provided."}`).
5. `ParentDashboardScreen` caught the 401 exception locally and set `_errorMessage`.
6. The widget tree rendered an error banner at the top of the body, but fell through to render the hardcoded `'Good Morning, Rajesh Sharma'` dashboard card below it.

---

## 3. JWT & Authentication State Flow

```
APP LAUNCH / REQUEST
        │
  TokenStorage Check
        │
  Valid Bearer Token?
   ├── NO  ──> Set AuthState.isAuthenticated = false ──> GoRouter redirects to /login
   │
   └── YES ──> Execute API Request (ApiClient)
                    │
              Backend HTTP Response
               ├── 200 OK  ──> Render Authenticated Role Dashboard
               │
               └── 401 Unauthorized
                        ↓
             ApiClient Interceptor
                        ↓
             TokenStorage.clearSession()
                        ↓
             ApiClient.onUnauthorized Callback
                        ↓
             AuthState.signOut()
                        ↓
             GoRouter detects !isAuthenticated
                        ↓
             Redirect to /login (Protected screen unmounted)
```

---

## 4. Centralized 401 Handling & Session Clearing

- **`ApiClient` Interceptor (`lib/core/api/api_client.dart`):**
  Added static `onUnauthorized` callback hook. When status code `401` is received:
  ```dart
  case 401:
    TokenStorage.clearSession();
    onUnauthorized?.call();
    throw const UnauthorizedException();
  ```

- **`AuthState` Integration (`lib/data/mock/auth_state.dart`):**
  Registered `ApiClient.onUnauthorized = signOut;` in constructor.
  - Defaults `_isAuthenticated` to `false` in production runtime.
  - `signOut()` clears:
    - JWT access & refresh tokens via `TokenStorage.clearSession()`
    - `_isAuthenticated = false`
    - `_currentUsername = ''`
    - `_authenticatedStudent = null`
    - `_selectedChildIndex = 0`
    - Triggers `notifyListeners()` to force `GoRouter` redirection.

- **Persistent Storage Cleanup (`TokenStorage`):**
  `TokenStorage.clearSession()` removes `auth_bearer_token`, `auth_refresh_token`, and `auth_active_user_role` from `SharedPreferences`.

---

## 5. Role Routing Verification

Role routing now strictly requires valid authenticated tokens and resolves dynamically:
- `student` → `/student/hub` (`StudentHubScreen`)
- `parent` → `/parent/dashboard` (`ParentDashboardScreen`)
- `class_teacher` → `/teacher/class-dashboard` (`ClassTeacherDashboardScreen`)
- `subject_teacher` → `/teacher/subject-dashboard` (`SubjectTeacherDashboardScreen`)
- `principal` / `vice_principal` → `/principal/dashboard` (`PrincipalDashboardScreen`)
- `accountant` → `/accounts/dashboard` (`AccountantDashboardScreen`)
- `librarian` → `/library/desk` (`LibrarianDashboardScreen`)
- `receptionist` → `/admissions/enquiries` (`AdmissionsEnquiryScreen`)
- `super_admin` → `/admin/modules` (`SuperAdminModulesScreen`)

---

## 6. Codebase Modifications

| File Path | Description of Changes Made |
| :--- | :--- |
| [`lib/core/api/api_client.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/core/api/api_client.dart) | Added `onUnauthorized` callback hook. Automatically invokes `TokenStorage.clearSession()` and `onUnauthorized?.call()` on HTTP 401. |
| [`lib/data/mock/auth_state.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/data/mock/auth_state.dart) | Default `_isAuthenticated` set to `false`. Binds `signOut` to `ApiClient.onUnauthorized`. Enforces `clearSession()` on logout and authentication failure. |
| [`lib/screens/dashboards/parent_dashboard_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/dashboards/parent_dashboard_screen.dart) | Replaced hardcoded `'Good Morning, Rajesh Sharma'` with dynamic `$parentName`. Trigger `context.read<AuthState>().signOut()` on 401. |
| [`lib/screens/dashboards/student_hub_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/lib/screens/dashboards/student_hub_screen.dart) | Removed hardcoded fallback `'Bushra Malik'`. Trigger `context.read<AuthState>().signOut()` on 401. |
| [`test/account_profile_navigation_test.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app-alpha/test/account_profile_navigation_test.dart) | Updated greeting card test expectation to match dynamic header name format. |

---

## 7. Automated Test Verification Results

- **`flutter analyze`:** `0 issues found` (Clean static analysis).
- **`flutter test`:** `207 / 207 tests passed (100% PASS)`.

---

## 8. Physical Device Verification (`RMX5004`)

- **Device ID:** `192.168.0.240:36409` (Realme RMX5004, Android 16)
- **APK Installed:** `build/app/outputs/flutter-apk/app-debug.apk`

### Verified Scenarios:
1. **Fresh Launch without Session:** App opens directly to `/login` (Login Screen). No protected dashboard rendered.
2. **Valid Login:** User authenticates via backend (`/api/v1/auth/login/`), receives JWT, and routes to role dashboard.
3. **HTTP 401 Invalidation:** When a 401 is returned, session tokens are cleared, `AuthState.signOut()` is executed, and app immediately redirects to `/login` (no stale data underneath).

---

## 9. Before vs After Comparison

| Scenario | BEFORE (Phase 4) | AFTER (Phase 4.0.1 Fix) |
| :--- | :--- | :--- |
| **App Launch (No JWT)** | Opens `ParentDashboardScreen` with default `Rajesh Sharma` | Opens `/login` (Login Screen) |
| **HTTP 401 API Failure** | Shows red error banner + renders `Rajesh Sharma` dashboard underneath | Clears tokens, resets `AuthState`, redirects to `/login` |
| **Header Name Fallback** | Hardcoded `'Good Morning, Rajesh Sharma'` | Dynamic `$parentName` / user profile |
| **Student Hub Fallback** | Hardcoded `'Bushra Malik'` | Dynamic `$studentName` / user profile |
| **Central 401 Teardown** | None (local catch only) | Centralized in `ApiClient` + `AuthState` |
