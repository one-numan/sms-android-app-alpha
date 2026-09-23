# Phase 4.2 Changelog

## [Batch A — Shared Infrastructure / Auth / Profile] — 2026-09-23

### Added
- `lib/core/config/app_config.dart`: Centralized institutional production configuration:
  - `schoolName` = 'One Numan Public School'
  - `academicSession` = 'Session 2026-27'
  - `affiliation` = 'CBSE Affiliation #2130456'
  - `schoolAbbr` = 'ONPS'
  - `campusAddress` = 'Plot 4A, Knowledge Park V, Greater Noida, UP'
  - `appVersion` = 'v2.4.0-PROD'
- `test/batch_a_mockdata_elimination_test.dart`: 10 comprehensive unit/widget tests for Batch A requirements:
  - No JWT -> Unauthenticated state
  - Valid JWT -> Authenticated state
  - Real profile load (`/api/v1/account/profile/`)
  - 401 handling -> Clear token, profile, role, child index
  - Sign-out -> Zero stale user identity
  - Missing profile fields -> Fallback to "Not available", never demo personas
  - Re-login with different user -> Complete isolation

### Modified
- `lib/data/mock/auth_state.dart`:
  - Removed default persona `_currentUsername = 'rajesh.sharma'`
  - Guarded `MockData.students` with `isTest` check; in production returns empty `Student`
  - In `signOut()`, completely reset `_currentRole = UserRole.student`, `_userProfile = null`, `_currentUsername = ''`, `_authenticatedStudent = null`
  - Zero fallback to demo personas on unauthenticated or failed profile states
- `lib/screens/account/account_profile_screen.dart`:
  - Removed all `fallbackProfile` objects and dependencies
  - Dynamically calculates tier via `_getRoleTier()`
  - Safely falls back to `"Not available"` if fields are missing from backend
  - Directly binds to authenticated `AuthState.userProfile`
- `lib/screens/account/account_settings_screen.dart`:
  - Purged `MockData.session` and `MockData.schoolName`
  - Uses `AppConfig.academicSession`, `AppConfig.schoolName`, and `AppConfig.affiliation`
- `lib/widgets/account_profile_sheet.dart`:
  - Removed 10 hardcoded role profiles from `getProfileForRole()`
  - Renders live `auth.userProfile` or neutral `"Not available"`
  - Replaced static branding with `AppConfig`
- `lib/widgets/account_settings_sheet.dart`:
  - Purged `MockData.session`
  - Uses `AppConfig.academicSession`
- `lib/screens/auth/login_screen.dart`:
  - Replaced `MockData.session` and `MockData.schoolName` with `AppConfig`
  - Dynamic branding from configuration
- `lib/screens/auth/morning_briefing_transition_screen.dart`:
  - Removed hardcoded "Dr. M. Chacko" and static quotes
  - Renders authenticated user's name and role or executive greeting
  - Replaced static school branding with `AppConfig`
- `lib/widgets/app_top_bar.dart`:
  - Removed `AccountProfileSheet.getProfileForRole` fallback
  - Renders live `auth.userProfile` / authenticated identity in 3-dots popup menu
- `lib/screens/help/faq_screen.dart`:
  - Uses dynamic role title and initials from live `auth`
- `test/staff_login_test.dart`:
  - Updated expected greeting to dynamic authenticated name `Principal` instead of hardcoded `Dr. M. Chacko`

### Verified
- `flutter analyze`: 0 issues
- `flutter test`: 217/217 passed
- `flutter build apk --debug`: Success
- Physical Realme RMX5004 tested over Wireless ADB:
  - Real user `principal.numan` logged in (ID #256, Mohd Numan, Session 2026-27)
  - Account Profile Screen & Sheet verified on device
  - Account Settings Screen & Sheet verified on device
  - Sign-out verified on device
  - Batch A Production-Reachable MockData: **0**
