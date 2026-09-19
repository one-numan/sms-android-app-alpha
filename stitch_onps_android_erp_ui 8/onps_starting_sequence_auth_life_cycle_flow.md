# One Numan Public School (ONPS) — Android ERP Application
## Canonical Launch & Starting Sequence Flow Architecture

This document defines the exact sequential runtime flow from application boot/cold launch through onboarding, splash, device initialization, authentication gateway, multi-tier security verification, and automated persona dispatch.

---

### 1. Visual & State Execution Flowchart

```
[ 🚀 App Boot / Cold Launch ]
            │
            ▼
┌────────────────────────────────────────────────────────┐
│  STEP 0: Splash & Institutional Branding Sheet        │
│  - Displays ONPS Academic Crest (1984)                 │
│  - Encrypted Keystore & Biometric Token Check          │
│  - Device Telemetry Registration (apps.accounts)       │
│  - Network & Server Connectivity Handshake             │
└────────────────────────────────────────────────────────┘
            │
            ├─── [Active Valid Session Token Exists?] ────┐
            │                 YES                         │
            ▼ NO                                          ▼
┌────────────────────────────────────────────────────────┐  ┌───────────────────────────────────┐
│  STEP 1: Screen 01 - Unified Login Gateway             │  │ STEP 5: Role-Based Auto-Navigator │
│  - Single-door credential auth (Mobile/User + Pass)    │  │ - Parent -> Parent Portal (05)    │
│  - Android BiometricPrompt trigger (Keystore Vault)    │  │ - Teacher -> Teacher Dash (18)    │
│  - Max 3 Device Notice (FIFO auto-eviction rule)       │  │ - Principal -> Exec Command (24)  │
│  - Forgot Password trigger -> Screen 03                │  │ - Student -> Self-Service (28)    │
└────────────────────────────────────────────────────────┘  └───────────────────────────────────┘
            │
            ├─── [5+ Consecutive Failed Attempts?] ─────┐
            │                 YES                       │
            ▼ NO                                        ▼
┌──────────────────────────────────────────────────┐  ┌─────────────────────────────────────────┐
│  STEP 2: Credential Validation & MFA Check       │  │ STEP 2b: Screen 02b - Security Lockout  │
│  - Query: auth.User + accounts.MFAException      │  │ - accounts.OTPLockout Tier Enforced     │
│  - Check active devices: accounts_userdevice     │  │ - Tier 1: 5m | Tier 2: 15m | Tier 3: 60m│
└──────────────────────────────────────────────────┘  │ - Active Countdown Timer                │
            │                                         │ - Emergency IT Hotline Trigger          │
            ├─── [MFA Exception Granted?] ────┐        └─────────────────────────────────────────┘
            │                 NO              │
            ▼                                 │ YES
┌──────────────────────────────────────────┐  │
│  STEP 3: Screen 02 - 2-Factor OTP        │  │
│  - accounts_loginotp (6-digit SHA256)    │  │
│  - SMS (+91 98*** **210) & Email Code    │  │
│  - FIFO Eviction Notice (Chrome Win 11)  │  │
│  - 30-second Resend countdown            │  │
└──────────────────────────────────────────┘  │
            │                                 │
            ▼ (OTP Verified)                  │
┌──────────────────────────────────────────┐  │
│  STEP 4: Device Session Registration     │  │
│  - Create accounts_userdevice row        │  │
│  - If devices > 3: mark oldest evicted   │  │
│  - Bind session_key & push FCM token     │  │
└──────────────────────────────────────────┘  │
            │                                 │
            ▼◄────────────────────────────────┘
┌────────────────────────────────────────────────────────┐
│  STEP 5: Automated Persona Dispatch Engine             │
│  - Single-Door Resolution via Django Database Models   │
│  - Parent    (parents.ParentStudent)   -> Screen 05    │
│  - Teacher   (teachers.Teacher)         -> Screen 18    │
│  - Principal (reports.selectors)        -> Screen 24    │
│  - Student   (home_student)             -> Screen 28    │
│  - Staff     (admissions.Enquiry)       -> Screen 30    │
└────────────────────────────────────────────────────────┘
```

---

### 2. Screen-by-Screen Starting Sequence Specifications

| Sequence Step | Screen ID & Route | Screen Title | Trigger Condition & Behavior |
| :--- | :--- | :--- | :--- |
| **Step 0** | `Splash / Cold Boot` | **Institutional Splash & Integrity Check** | Cold start of Flutter engine. Checks SQLite local storage, loads device keys, tests CBSE backend connectivity. |
| **Step 1** | `01` (`/login`) | **Unified Institutional Login Gateway** | Main entry screen for unauthenticated users. Single input for Username or 10-digit mobile number, password with reveal, biometric fast-unlock trigger, and multi-device FIFO notice. |
| **Step 2a** | `03` (`/auth/password-reset`) | **Password Reset & Account Recovery** | Triggered if user taps "Forgot Password?" on Step 1. Dispatches password reset link and verification SMS. |
| **Step 2b** | `02b` (`/auth/lockout`) | **Security Lockout & OTP Cooldown** | Triggered when consecutive failed logins reach limit (5 attempts). Enforces cooldown tier (5m, 15m, 60m) with emergency IT hotline dialer. |
| **Step 3** | `02` (`/auth/2fa-otp`) | **2-Factor OTP & Device Eviction Notice** | Step 2 of credential verification. Prompts for 6-digit TOTP sent via SMS/email and warns user that signing in will evict their oldest active device (e.g., Chrome on Windows 11). |
| **Step 4** | `04` (`/auth/devices`) | **Multi-Device Session Governance** | Accessible from user profile or prompted when session conflicts arise. Displays active devices (max 3) with remote one-tap session eviction. |
| **Step 5** | `Auto-Dispatch` | **Post-Auth Persona Landing** | The app detects user permissions and routes automatically: **Parent** -> Screen 05, **Teacher** -> Screen 18, **Principal** -> Screen 24, **Student** -> Screen 28. |

---

### 3. Flutter Implementation of Starting Sequence (`AppLifecycleNavigator`)

```dart
// lib/core/routes/starting_sequence.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';

class StartingSequenceCoordinator {
  static Future<String> determineInitialRoute({
    required BuildContext context,
    required AuthStateNotifier authState,
  }) async {
    // 1. Check if user is locked out due to brute force
    if (authState.isLockedOut) {
      return AppRoutePaths.securityLockout; // Screen 02b
    }

    // 2. Check if user session has pending 2FA
    if (authState.isPending2FA) {
      return AppRoutePaths.twoFactorOtp; // Screen 02
    }

    // 3. Check if user has active authenticated session
    if (authState.isAuthenticated) {
      switch (authState.primaryRole) {
        case UserRole.principal:
        case UserRole.superuser:
          return AppRoutePaths.principalCommand; // Screen 24
        case UserRole.teacher:
          return AppRoutePaths.teacherDashboard; // Screen 18
        case UserRole.parent:
          return AppRoutePaths.parentHome; // Screen 05
        case UserRole.student:
          return AppRoutePaths.studentSelfService; // Screen 28
        case UserRole.staff:
          return AppRoutePaths.admissionsDesk; // Screen 30
        default:
          return AppRoutePaths.parentHome;
      }
    }

    // 4. Default starting entry point
    return AppRoutePaths.login; // Screen 01
  }
}
```
