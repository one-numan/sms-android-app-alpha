# ONPS Scholastic ERP — Phase 5 & 5.1 Release Packaging & Production Signing Report
**Phase 5.1: Official Production Release Signing, Certificate Verification & Play Store Packaging**

---

## 1. Executive Summary & Verdict

- **Overall Task Verdict**: **TASK COMPLETE WITH FINDINGS**
- **Production Signing Verdict**: **PRODUCTION SIGNING: VERIFIED (PASS)**
  - Keystore: Official 4096-bit RSA ONPS Production Release Keystore (`onps_release_keystore.jks`)
  - Signer Subject: `CN=One Numan Public School, OU=Information Technology, O=One Numan Public School, L=Greater Noida, ST=Uttar Pradesh, C=IN`
  - Certificate SHA-256: `7C:EE:DB:59:80:C3:FB:54:95:16:06:99:F5:94:23:05:90:B6:F1:F6:C6:17:A5:02:2B:49:F0:20:6C:C3:F2:C1`
  - Validity: 10,000 days (until February 11, 2054)
- **Release Packaging Verdict**: **PASS** (Both Google Play App Bundle `.aab` and split release `.apk` artifacts compile cleanly with zero errors)
- **Target Application**: `com.onenuman.sms_android_app_alpha` (Release Build v1.0.0+1)
- **Physical Handheld Smoke Validation**: Realme RMX5004 / RMX5004IN (Android 16 / API 36 / arm64-v8a)
- **Backend Environment**: Live Production Endpoint `https://alpha.onenuman.com/api/v1` (`useMockFallback = false`)
- **Git Compliance**: ZERO git pushes performed. Keystore and `key.properties` strictly ignored in version control.

---

## 2. Release Configuration Audit

| Attribute | Specification | Verification Source / Command |
| :--- | :--- | :--- |
| **Application ID** | `com.onenuman.sms_android_app_alpha` | `android/app/build.gradle.kts` & `aapt dump badging` |
| **Version Name** | `1.0.0` | `pubspec.yaml` & `aapt dump badging` |
| **Version Code (Base)** | `1` | `pubspec.yaml` |
| **Version Code (Split arm64)**| `2001` (1000 * 2 + 1) | `aapt dump badging` |
| **Minimum SDK** | `24` (Android 7.0 Nougat) | `aapt dump badging` |
| **Target SDK** | `36` (Android 16) | `aapt dump badging` |
| **Compile SDK** | `36` (Android 16) | `android/app/build.gradle.kts` |
| **Build Types** | `release` & `debug` | `android/app/build.gradle.kts` |
| **JVM Target** | `JavaVersion.VERSION_17` | `android/app/build.gradle.kts` |

---

## 3. Official Production Signing & Certificate Verification

### 3.1 Security Architecture
The release signing configuration in `android/app/build.gradle.kts` utilizes secure externalized credentials:
1. **Local Secret File**: `android/key.properties` (strictly ignored by `.gitignore` and `android/.gitignore`).
2. **Keystore Storage**: `android/keystore/` (strictly ignored by `.gitignore` and `android/.gitignore`).
3. **CI/CD Environment Variables**: Supported via `ONPS_KEYSTORE_FILE`, `ONPS_KEY_ALIAS`, `ONPS_STORE_PASSWORD`, and `ONPS_KEY_PASSWORD`.

### 3.2 Certificate Metadata (Verified via `keytool` & `apksigner`)
- **Keystore Type**: PKCS12 / JKS
- **Key Alias**: `onps_release_key`
- **Owner / Subject**: `CN=One Numan Public School, OU=Information Technology, O=One Numan Public School, L=Greater Noida, ST=Uttar Pradesh, C=IN`
- **Issuer**: `CN=One Numan Public School, OU=Information Technology, O=One Numan Public School, L=Greater Noida, ST=Uttar Pradesh, C=IN`
- **Valid from**: `Sat Sep 26 00:06:32 IST 2026 until: Wed Feb 11 00:06:32 IST 2054`
- **Public Key Algorithm**: `4096-bit RSA key`
- **Signature Algorithm**: `SHA384withRSA`
- **Certificate SHA-256**: `7C:EE:DB:59:80:C3:FB:54:95:16:06:99:F5:94:23:05:90:B6:F1:F6:C6:17:A5:02:2B:49:F0:20:6C:C3:F2:C1`
- **Certificate SHA-1**: `C7:C8:E6:8F:BA:93:BD:B1:37:86:D9:A7:7F:7E:E3:9C:02:86:29:52`

### 3.3 Artifact Signing Verification
1. **App Bundle (`app-release.aab`)**:
   - Verified via `keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab`
   - Signer #1: `CN=One Numan Public School, OU=Information Technology, O=One Numan Public School, L=Greater Noida, ST=Uttar Pradesh, C=IN`
   - Digest: `7C:EE:DB:59:80:C3:FB:54:95:16:06:99:F5:94:23:05:90:B6:F1:F6:C6:17:A5:02:2B:49:F0:20:6C:C3:F2:C1`
   - Debug Certificate Check: **ZERO debug certs present**.
2. **Release APK (`app-arm64-v8a-release.apk`)**:
   - Verified via `apksigner verify --verbose --print-certs`
   - V2 Scheme: `true`
   - Signer #1: `CN=One Numan Public School, OU=Information Technology, O=One Numan Public School, L=Greater Noida, ST=Uttar Pradesh, C=IN`
   - Digest: `7C:EE:DB:59:80:C3:FB:54:95:16:06:99:F5:94:23:05:90:B6:F1:F6:C6:17:A5:02:2B:49:F0:20:6C:C3:F2:C1`

---

## 4. Release Build Artifacts

| Artifact | Path | Size | Signing |
| :--- | :--- | :--- | :--- |
| **Play App Bundle** | `build/app/outputs/bundle/release/app-release.aab` | `62 MB` | Production (4096-bit RSA) |
| **Split APK (arm64)** | `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` | `26.8 MB` | Production (4096-bit RSA) |
| **Split APK (arm32)** | `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` | `24.5 MB` | Production (4096-bit RSA) |
| **Split APK (x86_64)**| `build/app/outputs/flutter-apk/app-x86_64-release.apk` | `28.5 MB` | Production (4096-bit RSA) |

---

## 5. R8 / ProGuard Optimization Status

- **Configuration**:
  - `isMinifyEnabled = false`
  - `isShrinkResources = false`
- **ProGuard Rules**: Provisioned in `android/app/proguard-rules.pro` with baseline Flutter preservation rules.
- **Rationale**: For the alpha release, disabling R8 code shrinking prevents reflection/serialization regressions with dynamic models (`sqflite`, `go_router`, and nested REST responses) while ensuring zero startup regressions.
- **Status**: **VERIFIED INTENTIONAL**.

---

## 6. Environment & API Configuration

| Parameter | Configured Value | Verification Status |
| :--- | :--- | :--- |
| **API Base URL** | `https://alpha.onenuman.com/api/v1` | Verified in `lib/core/api/api_config.dart` |
| **MockData Fallback** | `useMockFallback = false` | Verified in `lib/core/api/api_config.dart` |
| **Localhost / 127.0.0.1** | `0` occurrences in `lib/` | Verified via regex search across codebase |
| **Hardcoded Tokens / Keys**| `0` found | Verified via ripgrep (`api_key`, `Bearer`, `secret`) |
| **Client Header** | `X-App-Client: ONPS-Android-ERP-Alpha` | Verified in `lib/core/api/api_config.dart` |
| **Backend Connectivity** | HTTP 200/400 JSON API responses | Verified via live HTTP/2 connection |

---

## 7. Android Manifest & Permissions

### 7.1 Permissions Declared
Inspected via `aapt dump badging`:
1. `android.permission.INTERNET` (Required for REST API connectivity)
2. `android.permission.ACCESS_NETWORK_STATE` (Required for connectivity detection)
3. `com.onenuman.sms_android_app_alpha.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` (Android 14+ platform security)

### 7.2 Cleartext Traffic Hardening
- Global `android:usesCleartextTraffic="true"` completely removed.
- Provisioned `android/app/src/main/res/xml/network_security_config.xml` which enforces strict HTTPS (`cleartextTrafficPermitted="false"`) by default across all public domains (including `alpha.onenuman.com`), while scoping cleartext exclusively to local debugging loopback (`localhost`, `127.0.0.1`, `10.0.2.2`).

---

## 8. Physical Production Release APK Smoke Test (Realme RMX5004)

The newly signed production release artifact `app-arm64-v8a-release.apk` was installed on physical hardware:
- **Device**: Realme RMX5004 (realme P1 Speed 5G, Android 16, API 36)
- **Install Result**: `Performing Streamed Install` -> `Success`
- **Application Startup**: Launched cleanly without crashes, ANRs, or visual regressions.

### 8.1 Verification Flow
1. **App Launch & Gateway**: App opened with branding splash and transitioned smoothly to the Login Gateway (`docs/evidence/prod_release_01_launch.png`, `docs/evidence/prod_release_02_login_gateway.png`).
2. **Student Authentication**:
   - Username: `yasminmalik011122`
   - Credential verification rules strictly adhered to (clear fields, verify matching credentials, masked input, submit).
   - Authenticated against live production endpoint `https://alpha.onenuman.com/api/v1` (`docs/evidence/prod_release_03_student_dashboard.png`).
3. **Student Dashboard & Data**:
   - Name: `Yasmin Malik (Active)`
   - Attendance: `90.0%`
   - Outstanding: `₹53,041`
   - Today's Schedule: English, Hindi, Mathematics, Environmental Studies (`docs/evidence/prod_release_04_student_dashboard_loaded.png`).
4. **Sub-screen Navigation**:
   - Navigated to Attendance Overview: loaded live monthly matrix for September 2026 (7 Present, 1 Absent, 2 Late, 0 Leave) (`docs/evidence/prod_release_05_student_attendance.png`).
5. **Session Logout**:
   - Triggered Sign Out: token purged cleanly and navigated back to Login Gateway (`docs/evidence/prod_release_06_signed_out.png`).

---

## 9. Google Play Package Validation

Verification of `build/app/outputs/bundle/release/app-release.aab`:
- **Package Name**: `com.onenuman.sms_android_app_alpha` (valid, unique alpha identifier)
- **Version Name**: `1.0.0`
- **Version Code**: `1`
- **Target SDK**: `36` (exceeds Google Play's minimum requirement of API 34/35)
- **Min SDK**: `24` (compatible with 96%+ of active Android devices)
- **Architectures Bundled**: `arm64-v8a`, `armeabi-v7a`, `x86_64`
- **Application Label**: `ONPS ERP Alpha`
- **Signing**: Confirmed signed with official production certificate (`CN=One Numan Public School...`). Zero debug certs.
- **Package Readiness for Play Console Upload**: **100% READY FOR PLAY CONSOLE INTERNAL TESTING**.

---

## 10. Security Audit Findings

- [x] No private keystores or `.jks` files committed to repository.
- [x] No `key.properties` credential file committed to repository.
- [x] `.gitignore` explicitly filters `key.properties`, `*.jks`, `*.keystore`, and `**/android/keystore/`.
- [x] Production backend strictly enforces HTTPS with custom Network Security Config.
- [x] Zero hardcoded API tokens or production credentials exist in client source code.
- [x] `useMockFallback = false` prevents any fallback to synthetic mock datasets in release.

---

## 11. Final Action Required

- **Google Play Console Release**:
  - The generated and verified production App Bundle is located at:
    `build/app/outputs/bundle/release/app-release.aab`
  - Upload `app-release.aab` to Google Play Console under the Internal Testing track for `com.onenuman.sms_android_app_alpha`.
