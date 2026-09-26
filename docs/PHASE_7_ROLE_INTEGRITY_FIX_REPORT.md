# PHASE 7 — ROLE INTEGRITY HOTFIX REPORT: PRINCIPAL NUMAN = PRINCIPAL ONLY

**Date**: 2026-09-26  
**Status**: COMPLETE & VERIFIED ON HARDWARE  
**Target Repository**: `sms-android-app-alpha` (`/Users/onenuman/Documents/GitHub/sms-android-app-alpha`)  
**Backend Repository**: `sms` (`/Users/onenuman/Documents/sms`)  
**Authoritative Database**: MySQL `onenuma1_school` on `localhost:3306`  
**Physical Device**: Realme RMX5004 (`192.168.0.240:33619`)  

---

## 1. Executive Summary

A critical role-integrity defect previously allowed the Principal user (`principal.numan`) to be treated as both **Principal** and **Class Teacher / Subject Teacher**. When authenticated as Principal, the mobile application and backend services exhibited role pollution:
- Fallback logic in dashboard views and API endpoints allowed users with administrative privileges (`is_staff=True`) to automatically adopt the first available teacher or class in the database when they had no direct assignments.
- Frontend role mapping routed users according to UI tab selection rather than authoritative server-resolved roles.
- Frontend role switching permitted principals to transition into arbitrary academic teacher personas.
- The UI synthesized placeholder classes (e.g. `Class 1 A`, `Deepti Sharma`, `Ajinkya Rahane`) when dashboard payloads were empty or returned 403.

**Resolution**:
Without modifying database records, altering seed data, or introducing hardcoded username hacks, architectural boundaries were enforced across backend role resolution, API dashboard endpoints, permissions, mobile authentication state, route guards, and UI role switcher sheets. Principal Numan is now strictly authenticated, authorized, and presented as **Principal Only**. Real teachers remain 100% operational with their designated class and subject responsibilities.

---

## 2. Problem Statement

### Observed Symptoms
1. `principal.numan` appeared as a Subject Teacher or Class Teacher in mobile and web views.
2. In the Account Profile, `principal.numan` returned a generic `staff` role instead of `principal`.
3. In `apps/reports/api_views.py`, calling `class_teacher_summary` or `subject_teacher_summary` as `principal.numan` did not return `403 Forbidden`; instead, it returned data for arbitrary teachers/classes (`Deepti Sharma`, `Class 1 A`, `Ajinkya Rahane`) due to administrative fallback branches.
4. In Flutter, the login gateway routed users to dashboards based on the selected tab (`_selectedRole`) rather than the authoritative role resolved from the backend session token.
5. In Flutter's `RoleSwitcherSheet`, Principal users were offered options to switch to Class Teacher, Subject Teacher, and Parent dashboards.
6. When arriving at teacher screens from stale cached routes, `ClassTeacherDashboardScreen` synthesized a dummy `Grade 5` / `Grade 1 A` class for `Mohd Numan`.

---

## 3. Database Proof (`principal.numan` is NOT a Teacher)

The authoritative MySQL database (`onenuma1_school`) was queried via Django ORM and direct SQL inspection.

### Query & Findings
```python
user = User.objects.get(username='principal.numan')
# auth_user.id: 38290 (or 23531 on production)
# is_staff: True
# is_superuser: False
# groups: ['Principal']
# hasattr(user, 'teacher'): False
# Teacher.objects.filter(user=user).exists(): False
# Class.objects.filter(class_teacher__user=user).count(): 0
# ClassSubject.objects.filter(teacher__user=user).count(): 0
# Staff record: id=13, designation='Principal', first_name='Mohd', surname='Numan'
```

### Authoritative Reality
- **Teacher record**: ZERO.
- **Class Teacher assignments**: ZERO.
- **Subject Teacher assignments**: ZERO.
- **Timetable entries**: ZERO.
- **Designation**: `Staff.Designation.PRINCIPAL`.
- **Authoritative Role**: `PRINCIPAL` ONLY.

---

## 4. Backend Root Cause Analysis

Four distinct backend root causes were identified:

1. **Role Resolution Order (`apps/students/roles.py`)**:
   `_RESOLUTION_ORDER` evaluated `SCHOOL_ADMIN` before `PRINCIPAL`. Because `principal.numan` has `is_staff=True` (to access Django admin), `matches.add(SCHOOL_ADMIN)` fired and superseded `PRINCIPAL`.
2. **Generic Profile Role (`apps/accounts/services.py`)**:
   `profile_for_user(user)` mapped any user with a `Staff` record to `'role': 'staff'`, ignoring `staff.designation`. Consequently, mobile clients received `role: 'staff'`, preventing the client from identifying executive principal privileges.
3. **Administrative Fallbacks in Permissions (`apps/reports/permissions.py`)**:
   `can_view_class_teacher_dashboard` and `can_view_subject_teacher_dashboard` contained `if is_admin(user): return True`. This granted administrators automatic permission to view teacher dashboards even with zero teaching assignments.
4. **Administrative Fallbacks in Summary APIs (`apps/reports/api_views.py`)**:
   When an admin accessed `class_teacher_summary` or `subject_teacher_summary`, lines such as `candidate_classes = Class.objects.filter(...)` and `Teacher.objects.filter(...).first()` synthesized fake assignments by picking the first class or teacher in the database.

---

## 5. Backend Fixes Applied

### 1. `apps/accounts/services.py`
Resolved specific designation slugs (`principal`, `vice_principal`, `accountant`, `librarian`, `receptionist`) from `Staff.designation` instead of returning generic `'staff'`.
```diff
--- a/apps/accounts/services.py
+++ b/apps/accounts/services.py
@@ -38,7 +38,24 @@ def profile_for_user(user):
     staff = getattr(user, 'staff', None)
     if staff is not None:
+        role = 'staff'
+        desig = (staff.designation or '').strip().lower()
+        if desig == 'principal':
+            role = 'principal'
+        elif desig in ('vice principal', 'vice_principal'):
+            role = 'vice_principal'
+        elif desig == 'accountant':
+            role = 'accountant'
+        elif desig == 'librarian':
+            role = 'librarian'
+        elif desig == 'receptionist':
+            role = 'receptionist'
         return {
-            'role': 'staff',
+            'role': role,
             'record': staff,
             'full_name': f"{staff.first_name} {staff.surname}".strip(),
             'mobile_number': staff.mobile_number,
         }
```

### 2. `apps/accounts/api_views.py`
Ensured `profile()` API endpoint guarantees `role: 'principal'` when designation is `'Principal'`.
```diff
--- a/apps/accounts/api_views.py
+++ b/apps/accounts/api_views.py
@@ -107,6 +107,8 @@ def profile(request):
     if staff:
         user_data['designation'] = staff.designation
         user_data['employee_id'] = staff.employee_id
+        if (staff.designation or '').strip().lower() == 'principal':
+            user_data['role'] = 'principal'
```

### 3. `apps/students/roles.py`
Reordered `_RESOLUTION_ORDER` so `PRINCIPAL` and `VICE_PRINCIPAL` take precedence over `SCHOOL_ADMIN`.
```diff
--- a/apps/students/roles.py
+++ b/apps/students/roles.py
@@ -150,3 +150,3 @@
 _RESOLUTION_ORDER = (
-    SUPER_ADMIN, SCHOOL_ADMIN, PRINCIPAL, VICE_PRINCIPAL,
+    SUPER_ADMIN, PRINCIPAL, VICE_PRINCIPAL, SCHOOL_ADMIN,
     STUDENT, PARENT, CLASS_TEACHER, TEACHER,
```

### 4. `apps/reports/permissions.py`
Removed administrative bypasses from teacher dashboard permission checks.
```diff
--- a/apps/reports/permissions.py
+++ b/apps/reports/permissions.py
@@ -23,4 +23,2 @@ def can_view_class_teacher_dashboard(user):
     if not user.is_authenticated:
         return False
-    if is_admin(user):
-        return True
@@ -37,4 +35,2 @@ def can_view_subject_teacher_dashboard(user):
     if not user.is_authenticated:
         return False
-    if is_admin(user):
-        return True
```

### 5. `apps/reports/api_views.py`
Eliminated candidate class/teacher fallback fabrication in mobile summary APIs.
```diff
--- a/apps/reports/api_views.py
+++ b/apps/reports/api_views.py
@@ -74,7 +74,2 @@ def class_teacher_summary(request):
         assigned_class = Class.objects.filter(class_teacher=teacher).first()
-        if not assigned_class and request.user.is_staff:
-            candidate_classes = Class.objects.filter(is_active=True).order_by('name')
-            if candidate_classes.exists():
-                assigned_class = candidate_classes.first()
@@ -141,5 +136,1 @@ def subject_teacher_summary(request):
-        if not teacher and request.user.is_staff:
-            teacher = Teacher.objects.filter(is_active=True).first()
```

### 6. `apps/reports/views.py`
Restricted admin viewing of web teacher dashboards to explicitly provided query parameters (`?class_id=` or `?teacher_id=`).
```diff
--- a/apps/reports/views.py
+++ b/apps/reports/views.py
@@ -159,3 +159,4 @@ def class_teacher_dashboard(request):
-    if is_admin(request.user):
-        assigned_class = Class.objects.first()
+    if is_admin(request.user) and request.GET.get('class_id'):
+        assigned_class = get_object_or_404(Class, pk=request.GET.get('class_id'))
@@ -211,3 +212,4 @@ def subject_teacher_dashboard(request):
-    if is_admin(request.user):
-        teacher = Teacher.objects.first()
+    if is_admin(request.user) and request.GET.get('teacher_id'):
+        teacher = get_object_or_404(Teacher, pk=request.GET.get('teacher_id'))
```

---

## 6. Backend Verification (Tests Passing)

### Regression Test Suite: `apps/api/tests_mobile_endpoints.py`
Three dedicated regression tests were added:
1. `test_principal_cannot_access_class_teacher_dashboard`: Confirms HTTP 403 Forbidden when Principal calls `/api/v1/teacher/class-dashboard/`.
2. `test_principal_cannot_access_subject_teacher_dashboard`: Confirms HTTP 403 Forbidden when Principal calls `/api/v1/teacher/subject-dashboard/`.
3. `test_principal_profile_returns_principal_role`: Confirms `/api/v1/account/profile/` returns `role: 'principal'` and `designation: 'Principal'`.

### Test Execution Results
```bash
python manage.py test apps.reports.tests apps.students.tests.ResolveRoleTests apps.api.tests_mobile_endpoints
```
**Output**:
```text
Ran 158 tests in 51.530s
OK
Destroying test database for alias 'default'...
```
- Total tests executed: **158**
- Failures: **0**
- Errors: **0**
- Status: **100% PASS**

---

## 7. Mobile / Flutter Root Cause Analysis

Four root causes were identified in `sms-android-app-alpha`:

1. **Login Role Redirection (`login_screen.dart`)**:
   `_handleSignIn()` routed users using `_navigateForRole(_selectedRole)` where `_selectedRole` was the UI tab chosen on the login screen. If a user logged in on the "Teacher" tab with `principal.numan` credentials, the UI attempted to navigate to `/teacher/class-dashboard`.
2. **Missing Dynamic Profile Role Resolution (`auth_state.dart`)**:
   `AuthState` retained `_currentRole = role` from whatever was passed into `login()`. It did not parse the `/account/profile/` response to align `_currentRole` with the server's authoritative role.
3. **Unfiltered Role Switcher (`role_switcher_sheet.dart`)**:
   `RoleSwitcherSheet` displayed all institutional roles (Principal, Class Teacher, Subject Teacher, Accountant, etc.) without verifying whether the active session held credentials or permissions for those roles.
4. **Mock Class Fallback in UI (`class_teacher_dashboard_screen.dart`)**:
   When `_dashboardData` was empty, lines 185-191 created a fallback `SchoolClass` using `'Grade 5'` and `'5-A'`, displaying false class information for `Mohd Numan`.

---

## 8. Mobile / Flutter Fixes Applied

### 1. `lib/data/mock/auth_state.dart`
- Added `resolveRoleFromProfile()` to automatically detect `UserRole.principal` from `role: 'principal'`, `designation: 'Principal'`, or group `'Principal'`.
- Added `availableRoles` getter: for Principal users without a `Teacher` record, `availableRoles` strictly returns `[UserRole.principal]`.
- Guarded `switchRole()` to reject transitions to unauthorized roles.
```dart
static UserRole? resolveRoleFromProfile(Map<String, dynamic>? profile) {
  if (profile == null) return null;
  final roleStr = (profile['role'] ?? '').toString().trim().toLowerCase();
  final desigStr = (profile['designation'] ?? '').toString().trim().toLowerCase();

  if (roleStr == 'principal' || desigStr == 'principal') {
    return UserRole.principal;
  }
  if (roleStr == 'vice_principal' || desigStr == 'vice principal') {
    return UserRole.vicePrincipal;
  }
  // ... other roles
}
```

### 2. `lib/screens/auth/login_screen.dart`
Changed post-login navigation to use authoritative `auth.currentRole`:
```diff
--- a/lib/screens/auth/login_screen.dart
+++ b/lib/screens/auth/login_screen.dart
@@ -115,3 +115,3 @@
         if (success && auth.isAuthenticated) {
-          _navigateForRole(_selectedRole);
+          _navigateForRole(auth.currentRole);
```

### 3. `lib/router.dart`
Added global route redirect guard preventing Principal/VicePrincipal from accessing teacher dashboards:
```dart
// Role-guard: Principal/VicePrincipal cannot access Teacher Dashboards
if (isAuth && (authState.currentRole == UserRole.principal || authState.currentRole == UserRole.vicePrincipal)) {
  if (loc.startsWith('/teacher/class-dashboard') ||
      loc.startsWith('/dashboard/class-teacher') ||
      loc.startsWith('/teacher/subject-dashboard') ||
      loc.startsWith('/dashboard/subject-teacher')) {
    return '/dashboard/principal';
  }
}
```

### 4. `lib/screens/dashboards/class_teacher_dashboard_screen.dart`
Removed fallback class fabrication: if a user is not assigned to a class, `assignedClass` is `null` and displays `_buildUnassignedClassState()`.

### 5. `lib/widgets/role_switcher_sheet.dart`
Filtered displayed roles against `authState.availableRoles`:
```dart
final allowedRoles = authState.availableRoles;
final allowedItems = allItems.where((item) => allowedRoles.contains(item.role)).toList();
```

---

## 9. Role Switcher Verification

Verified directly on physical hardware (`192.168.0.240:33619`):
- When logged in as `principal.numan`, tapped **Switch Role**.
- Only ONE role is listed: **Principal Executive Command** (ACTIVE).
- Class Teacher, Subject Teacher, Student, and Parent are completely excluded from the switcher.

---

## 10. Badge Color Verification

Badges were verified both via automated widget tests and physical device screenshots:
- **Principal**: `GOLD ★` (`verified_gold.png` / `verified_principal.png`)
  - Verified on top Principal Dashboard header: Gold badge displayed next to `Principal M...`.
  - Verified in User Account Profile Sheet: Gold badge displayed next to `Mohd Numan` with text "Verified".
- **Class Teacher**: `PURPLE ★` (`verified_purple.png` / `verified_class_teacher.png`)
- **Subject Teacher**: `GREEN ★` (`verified_green.png` / `verified_teacher.png`)
- **Student**: `BLUE ★` (`verified_blue.png` / `verified_student.png`)
- **Staff / Admin**: `PLATINUM ★` (`verified_platinum.png` / `verified_staff.png`)

All 4 test cases in `test/principal_role_integrity_test.dart` passed.

---

## 11. Regression Check on Real Teachers

Genuine teachers (e.g. `washingtonsundar`, assigned to Nursery A) were verified against the backend:
1. `profile_for_user(u)`: Returns `role: 'teacher'`, `record: <Teacher: Washington Sundar>`.
2. `dashboards_for(u)`: Returns `[class_teacher, subject_teacher]`.
3. `resolve_role(u, student)`: Returns `class_teacher` for assigned class students.
4. `dashboards_for(principal.numan)`: Returns `[principal, accountant, librarian]` (NO teacher dashboards).

---

## 12. Files Modified

### Backend (`/Users/onenuman/Documents/sms`)
| File | Changes |
| :--- | :--- |
| `apps/accounts/services.py` | Maps `Staff.designation` to specific role slugs (`principal`, etc.) |
| `apps/accounts/api_views.py` | Sets `user_data['role'] = 'principal'` for Principal designation |
| `apps/students/roles.py` | Places `PRINCIPAL, VICE_PRINCIPAL` before `SCHOOL_ADMIN` in resolution order |
| `apps/reports/permissions.py` | Removes `is_admin` bypass from teacher dashboard permissions |
| `apps/reports/api_views.py` | Removes fallback class/teacher synthesis in teacher summary APIs |
| `apps/reports/views.py` | Requires query parameters for admin preview of teacher web views |
| `apps/api/tests_mobile_endpoints.py` | Adds 3 regression tests for principal role and dashboard isolation |

### Frontend (`/Users/onenuman/Documents/GitHub/sms-android-app-alpha`)
| File | Changes |
| :--- | :--- |
| `lib/data/mock/auth_state.dart` | Role resolution from profile, `availableRoles` gating, `switchRole` guard |
| `lib/router.dart` | Route guard redirecting Principal away from teacher dashboard URLs |
| `lib/screens/auth/login_screen.dart` | Routes post-login based on `auth.currentRole` rather than tab selection |
| `lib/screens/dashboards/class_teacher_dashboard_screen.dart` | Eliminates fake class synthesis when unassigned |
| `lib/widgets/role_switcher_sheet.dart` | Filters role options using `authState.availableRoles` |
| `test/principal_role_integrity_test.dart` | Automated regression test suite for role integrity & badge colors |

---

## 13. Security & Integrity Posture

1. **Principle of Least Privilege**: Users only receive access to dashboards and APIs for which structural or contractual assignments exist in the database.
2. **Authoritative State Resolution**: The client UI cannot dictate roles or permissions via form selections or URL parameters; the signed JWT and server profile dictate client state.
3. **No Credential Leakage**: Adhered strictly to the Android testing credential entry rule without exposing passwords in logs, screenshots, or reports.
4. **Zero Username Hardcoding**: All checks rely on structural relations (`Teacher`, `Staff.designation`, Django Groups), ensuring generalizability to future staff and principals.

---

## 14. Final Sign-off Checklist

- [x] Database records left completely untouched (NO new teacher records, NO fake assignments).
- [x] Backend `apps.reports` endpoints return 403 Forbidden for Principal accessing teacher APIs.
- [x] Backend `dashboards_for(principal.numan)` contains `principal`, excludes `class_teacher` and `subject_teacher`.
- [x] Flutter login redirects `principal.numan` to Principal Briefing / Dashboard regardless of tab tapped.
- [x] Flutter `RoleSwitcherSheet` restricts Principal to `Principal Executive Command` only.
- [x] Flutter verification badge shows **GOLD ★** for Principal.
- [x] Genuine teachers (`washingtonsundar`) retain full access to Class & Subject Teacher dashboards.
- [x] 158/158 backend tests passing.
- [x] 4/4 Flutter role integrity regression tests passing.
- [x] `flutter analyze` reports 0 issues.
- [x] Physical device execution verified and screen-captured.
