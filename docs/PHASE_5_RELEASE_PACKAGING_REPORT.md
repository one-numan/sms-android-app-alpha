# ONPS Scholastic ERP — Phase 5 Release Packaging & Signing Audit Report
**Phase 5: Release Build, Signing Configuration & Production Packaging**

---

## 1. Executive Summary & Verdict

- **Overall Task Verdict**: **TASK COMPLETE WITH FINDINGS**
- **Production Signing Verdict**: **PRODUCTION SIGNING: NOT VERIFIED** (Expected: private production keystore is deliberately held offline and not committed to git)
- **Release Packaging Verdict**: **PASS** (Both Google Play App Bundle `.aab` and split release `.apk` artifacts compile cleanly with zero errors)
- **Target Application**: `com.onenuman.sms_android_app_alpha` (Release Build v1.0.0+1)
- **Target Hardware for Smoke Validation**: Realme RMX5004 / RMX5004IN (Android 16 / API 36 / arm64-v8a)
- **Backend Environment**: Live Production Endpoint `https://alpha.onenuman.com/api/v1` (`useMockFallback = false`)
- **Git Compliance**: ZERO git pushes performed. All changes local.

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

## 3. Signing Configuration & Keystore Status

### 3.1 Security Architecture
The release signing configuration in `android/app/build.gradle.kts` has been updated to use secure externalized credentials:
1. **Local Secret File**: `android/key.properties` (never tracked in git).
2. **CI/CD Environment Variables**:
   - `ONPS_KEYSTORE_FILE`
   - `ONPS_KEY_ALIAS`
   - `ONPS_STORE_PASSWORD`
   - `ONPS_KEY_PASSWORD`
3. **Safe Local Fallback**: When no release keystore is present, it uses the debug signing certificate to allow local staging, compilation, and physical smoke testing without stalling the build.

### 3.2 Keystore Audit
- **Committed Keystore Files**: `0` found (Verified via `git status` and `find`).
- **Gitignore Protection**: `.gitignore` and `android/.gitignore` strictly ignore `key.properties`, `*.jks`, and `*.keystore`.
- **Template Available**: `android/key.properties.example` created with clear documentation for release administrators.
- **Production Keystore Status**: **NOT VERIFIED**. The genuine production signing key is intentionally kept offline in secure vault storage. No fake production credentials were manufactured.

---

## 4. Release Build Artifacts

Both production release compilation flows were executed:

### 4.1 Google Play App Bundle (AAB)
- **Command**: `flutter build appbundle --release`
- **Output Artifact**: `build/app/outputs/bundle/release/app-release.aab`
- **Artifact Size**: `59 MB` (uncompressed bundle payload)
- **Status**: **SUCCESSFUL**

### 4.2 Split-Per-ABI Release APKs
- **Command**: `flutter build apk --release --split-per-abi`
- **Artifacts Generated**:
  - `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (`26 MB`)
  - `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` (`23 MB`)
  - `build/app/outputs/flutter-apk/app-x86_64-release.apk` (`27 MB`)
- **Status**: **SUCCESSFUL**

---

## 5. Certificate & Signature Verification

Signature inspection was conducted via Android SDK `apksigner` (v36.0.0):
```
Command: apksigner verify --verbose --print-certs build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

**Results**:
- **Integrity Verification**: `Verifies: true`
- **V1 Scheme (JAR signing)**: `false`
- **V2 Scheme (APK Signature Scheme v2)**: `true`
- **Signer DN**: `C=US, O=Android, CN=Android Debug`
- **Certificate SHA-256**: `F9:AD:B1:78:67:B7:0E:14:C7:58:6B:41:7B:65:59:0D:E7:88:9D:07:43:F5:49:93:64:3B:CB:0B:50:AA:96:E9`
- **Audit Classification**: The artifact uses the local fallback debug certificate because the official private production keystore has not been provisioned on this workstation.
- **Status**: **PRODUCTION SIGNING: NOT VERIFIED**.

---

## 6. R8 / ProGuard Optimization Status

- **Configuration**:
  - `isMinifyEnabled = false`
  - `isShrinkResources = false`
- **ProGuard Rules**: `android/app/proguard-rules.pro` was provisioned with baseline Flutter engine, reflection, annotation, and data model preservation rules.
- **Rationale**: For the alpha release, disabling R8 code shrinking and obfuscation prevents reflection and JSON serialization regressions with dynamic models (`sqflite`, `go_router`, and nested REST responses) while ensuring zero startup regressions.
- **Status**: **VERIFIED INTENTIONAL**.

---

## 7. Environment & API Configuration

| Parameter | Configured Value | Verification Status |
| :--- | :--- | :--- |
| **API Base URL** | `https://alpha.onenuman.com/api/v1` | Verified in `lib/core/api/api_config.dart` |
| **MockData Fallback** | `useMockFallback = false` | Verified in `lib/core/api/api_config.dart` |
| **Localhost / 127.0.0.1** | `0` occurrences in `lib/` | Verified via regex search across codebase |
| **Hardcoded Tokens / Keys**| `0` found | Verified via ripgrep (`api_key`, `Bearer`, `secret`) |
| **Client Header** | `X-App-Client: ONPS-Android-ERP-Alpha` | Verified in `lib/core/api/api_config.dart` |
| **Backend Connectivity** | HTTP 200/400 JSON API responses | Verified via `curl -I https://alpha.onenuman.com/api/v1/auth/login/` |

---

## 8. Android Manifest & Permissions

### 8.1 Permissions Declared
Inspected via `aapt dump badging`:
1. `android.permission.INTERNET` (Required for REST API connectivity)
2. `android.permission.ACCESS_NETWORK_STATE` (Required for connectivity detection)
3. `com.onenuman.sms_android_app_alpha.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` (Android 14+ platform security)

### 8.2 Cleartext Traffic Hardening
- Previously, `AndroidManifest.xml` had `android:usesCleartextTraffic="true"` globally.
- **Hardening Applied**: Removed global `usesCleartextTraffic="true"`.
- **Network Security Config**: Provisioned `android/app/src/main/res/xml/network_security_config.xml` which enforces strict HTTPS (`cleartextTrafficPermitted="false"`) by default across all public domains (including `alpha.onenuman.com`), while scoping cleartext exclusively to local debugging loopback (`localhost`, `127.0.0.1`, `10.0.2.2`).

---

## 9. Physical Release APK Smoke Test (Realme RMX5004)

The release artifact `app-arm64-v8a-release.apk` was installed on physical hardware:
- **Device**: Realme RMX5004 (realme P1 Speed 5G, Android 16, API 36)
- **Install Result**: `Performing Streamed Install` -> `Success`
- **Application Startup**: Launched cleanly without crashes or ANRs.

### 9.1 Credential Verification Protocol Followed
For every login attempt:
1. Username verified against persona test credentials.
2. Matching password verified.
3. Username field cleared.
4. Password field cleared.
5. Username entered.
6. Password entered (masked).
7. Pair integrity confirmed.
8. Submitted only after full verification.
9. Zero passwords logged or exposed.

### 9.2 Focused Smoke Test Matrix

| Persona | Username | Flow Verified | Result | Evidence Artifact |
| :--- | :--- | :--- | :--- | :--- |
| **Student** | `yasminmalik011122` | Login -> Dashboard -> Logout | **PASS** | `docs/evidence/release_08_student_dashboard_loaded.png`<br>`docs/evidence/release_11_student_signed_out.png` |
| **Parent** | `nawazuddinsiddiqui` | Login -> Dashboard -> Child Data (`Bushra Malik`) -> Logout | **PASS** | `docs/evidence/release_13_parent_child_data.png`<br>`docs/evidence/release_14_parent_signed_out.png` |
| **Teacher** | `washingtonsundar` | Login -> Hub Dashboard -> Timetable -> Logout | **PASS** | `docs/evidence/release_16_teacher_dashboard_loaded.png`<br>`docs/evidence/release_17_teacher_signed_out.png` |
| **Staff** | `principal.numan` | Login -> Executive Dashboard -> Metrics -> Logout | **PASS** | `docs/evidence/release_18_staff_dashboard.png`<br>`docs/evidence/release_19_staff_signed_out.png` |

---

## 10. Google Play Package Validation

Verification of `build/app/outputs/bundle/release/app-release.aab`:
- **Package Name**: `com.onenuman.sms_android_app_alpha` (valid, unique alpha identifier)
- **Version Name**: `1.0.0`
- **Version Code**: `1`
- **Target SDK**: `36` (exceeds Google Play's minimum requirement of API 34/35)
- **Min SDK**: `24` (compatible with 96%+ of active Android devices)
- **Architectures Bundled**: `arm64-v8a`, `armeabi-v7a`, `x86_64`
- **Application Label**: `ONPS ERP Alpha`
- **Package Readiness for Play Console Upload**:
  - Code & manifest structure: **READY**
  - Production Keystore Signing: **PENDING RELEASE ADMIN KEYSTORE PROVISIONING**

---

## 11. Security Audit Findings

- [x] No private keystores or `.jks` files committed to repository.
- [x] No `key.properties` credential file committed to repository.
- [x] `.gitignore` explicitly filters `key.properties`, `*.jks`, `*.keystore`.
- [x] Production backend strictly enforces HTTPS with custom Network Security Config.
- [x] Zero hardcoded API tokens or production credentials exist in client source code.
- [x] `useMockFallback = false` prevents any fallback to synthetic mock datasets in release.

---

## 12. Remaining Blockers & Next Actions

1. **Production Keystore Signing**:
   - The official production `.jks` keystore must be supplied via CI/CD secrets (`ONPS_KEYSTORE_FILE`, `ONPS_KEY_ALIAS`, `ONPS_STORE_PASSWORD`, `ONPS_KEY_PASSWORD`) or a local `android/key.properties` file by the authorized release administrator prior to uploading to Google Play Console.
2. **Google Play Console Release**:
   - Create the internal testing track on Google Play Console under the package name `com.onenuman.sms_android_app_alpha`.
   - Upload the production-signed AAB.
