# Action Items: Interactive User Profile Navigation on Name & Avatar Taps

> **Feature**: Direct User Account Profile Navigation via Name / Avatar Taps  
> **Target Sheet**: `AccountProfileSheet.show(context)` (`lib/widgets/account_profile_sheet.dart`)  
> **Applicable Roles**: Class Teacher, Subject Teacher, Parent, Student, Principal, Vice Principal, Accountant, Librarian, Super Admin  
> **Timestamp**: 2026-09-19 14:21 IST  
> **Design Theme**: Espresso Heritage Academic (`#F7F1E8`, `#3E2A22`, `#FFFDF9`)  
> **Icon & Rule Standard**: Strict 0 Unicode Emojis (Material Symbols / Icons only)

---

## 1. Requirement & User Intent

### Core UX Behavior:
When a **Class Teacher**, **Subject Teacher**, **Student**, **Parent**, **Principal**, or any other authenticated role taps on:
1. Their **Greeting Banner / Header Card** (e.g. *"Good Morning, Anita Desai"*),
2. Their **Name Title** or **Profile Subtitle**,
3. Their **Photo / Initials Avatar Badge** (e.g. `[AD]`, `[NK]`),

The application must immediately open the **User Account Profile** modal sheet (`AccountProfileSheet.show(context)`), displaying their verified profile credentials, official email, registered phone number, institutional affiliation, academic session, role switch shortcut, and app settings.

---

## 2. Comprehensive Action Items Checklist

### 1. Dashboard Greeting Header Wiring (`InkWell` / `GestureDetector`)

- [x] **Class Teacher Dashboard** ([`lib/screens/dashboards/class_teacher_dashboard_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app/lib/screens/dashboards/class_teacher_dashboard_screen.dart)):
  - Wrapped `_buildTeacherGreetingCard` avatar and greeting column in an `InkWell` with ripple effect, `Semantics(label: 'View account profile')`, and `onTap: () => AccountProfileSheet.show(context)`.
  - Added visual touch feedback (border radius, subtle highlight, chevron icon).

- [x] **Subject Teacher Dashboard** ([`lib/screens/dashboards/subject_teacher_dashboard_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app/lib/screens/dashboards/subject_teacher_dashboard_screen.dart)):
  - Made the greeting header card (`'Good Morning, ${teacher.name}'`, dynamic initials, and avatar) interactive with `onTap: () => AccountProfileSheet.show(context)` and decoupled action buttons.

- [x] **Parent Portal Dashboard** ([`lib/screens/dashboards/parent_dashboard_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app/lib/screens/dashboards/parent_dashboard_screen.dart)):
  - Implemented dedicated Parent Identity Header Card (`'Good Morning, Rajesh Sharma'`, initials `RS`, `Guardian • Wards: Diya (5-A), Aarav (2-B)`) with `onTap: () => AccountProfileSheet.show(context)`. Cleaned child selector tabs to eliminate tap conflicts.

- [x] **Student Self-Service Hub** ([`lib/screens/dashboards/student_hub_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app/lib/screens/dashboards/student_hub_screen.dart)):
  - Enabled tapping on the Student greeting banner / avatar to open `AccountProfileSheet` with decoupled sibling Digital ID button.

- [x] **Principal Executive Hub** ([`lib/screens/dashboards/principal_dashboard_screen.dart`](file:///Users/onenuman/Documents/GitHub/sms-android-app/lib/screens/dashboards/principal_dashboard_screen.dart)):
  - Aligned Principal Executive greeting card with `AccountProfileSheet` credentials (`NK` - Principal Numan Khan, Head of Institution • Executive Leadership) with `onTap: () => AccountProfileSheet.show(context)`.

- [x] **Other Administrative Dashboards**:
  - [x] **Accounts & Fees Hub**: Accountant header taps trigger `AccountProfileSheet`.
  - [x] **Library Circulation Desk**: Librarian header taps trigger `AccountProfileSheet`.
  - [x] **Super Admin Directory Hub**: Super Admin header taps trigger `AccountProfileSheet`.

---

### 2. Touch Target & Accessibility Guidelines
- [x] Ensured the entire greeting card or name/avatar cluster provides $\ge 48\text{px}$ touch targets.
- [x] Added semantic label / tooltip: `"View account profile"`.
- [x] Ensured smooth ripple animations bounded within `borderRadius: BorderRadius.circular(12)`.

---

### 3. Verification & Testing
- [x] **Automated Widget Tests**:
  - Added dedicated widget tests in `test/account_profile_navigation_test.dart` verifying tapping on greeting cards across Parent, Principal, Class Teacher, Subject Teacher, and Student dashboards opens `AccountProfileSheet`.
- [x] **Static Analysis**:
  - Ran `flutter analyze` and confirmed 0 errors, 0 warnings, 0 lints.
- [x] **Full Test Suite**:
  - Ran `flutter test` and confirmed 193/193 passing tests.
- [x] **Physical Device Verification**:
  - Successfully connected to Realme RMX5004 on `192.168.0.240:46409`, built and installed `app-debug.apk`, tapped greeting card on live screen, and verified instant modal opening of the User Account Profile sheet.
