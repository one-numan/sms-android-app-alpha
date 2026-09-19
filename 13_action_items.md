# Action Items: Student 360 Profile Dossier Screen Refinement & Device Audit Fixes

> **Screen**: Student 360 File (`StudentDossierScreen`)  
> **Source File**: `lib/screens/students/student_dossier_screen.dart`  
> **Device Audited**: Realme RMX5004 (Android 16, API 36)  
> **Capture Timestamp**: 2026-09-19 13:56 IST  
> **Design Theme**: Espresso Heritage Academic (`#F7F1E8`, `#3E2A22`, `#FFFDF9`)  
> **Icon & Rule Standard**: Strict 0 Unicode Emojis (Material Symbols / Icons only)

---

## 1. Live Physical Device Audit Findings

### Issue A: RenderFlex Overflow in Academics Tab (`RIGHT OVERFLOWED BY 27 PIXELS`)
- **Location**: `lib/screens/students/student_dossier_screen.dart:256–269`
- **Component**: Header Row of `Term 1 Academic Summary` inside `_buildTabContent` (Academics Tab).
- **Symptom**: Yellow/black hazard stripes displayed on the right edge of the academic summary card with `A RenderFlex overflowed by 27 pixels on the right`.
- **Root Cause**: The unconstrained `Row` contains both `Text('Term 1 Academic Summary', style: GoogleFonts.newsreader(...))` and `PillBadge.success('Cumulative 92.4%')` inside an `InsetCard` with 16px horizontal padding. On standard mobile viewports (360px–412px), the combined intrinsic width of the title and pill badge exceeds available container width.
- **Required Fix**:
  - Wrap the section title in `Expanded` or `Flexible` with `TextOverflow.ellipsis`.
  - Alternatively, structure header into a responsive layout that wraps gracefully on compact screens.

---

## 2. Comprehensive Action Items Checklist

### 1. Layout & Overflow Fixes
- [ ] **Fix Academics Tab Header Row**:
  - In `lib/screens/students/student_dossier_screen.dart`, wrap the `Text('Term 1 Academic Summary', ...)` widget in `Expanded(child: ...)` inside the `Row` to ensure `PillBadge.success` has dedicated space and title truncates or fits without overflow.
- [ ] **Audit All 7 Tab Cards for Unconstrained Rows**:
  - [ ] **Tab 0 (Profile)**: Verify `_buildSectionCard` and `_buildInfoRow` across long addresses and names.
  - [ ] **Tab 1 (Academics)**: Fix summary card header and verify subject row alignments.
  - [ ] **Tab 2 (Attendance)**: Verify `Attendance Standing` header and stat rows.
  - [ ] **Tab 3 (Fees)**: Verify `Fee Realization Ledger` header and currency strings.
  - [ ] **Tab 4 (Transport)**: Verify `Assigned Safe Transit` details and route numbers.
  - [ ] **Tab 5 (Documents)**: Verify `Official Verification Documents` status labels.
  - [ ] **Tab 6 (Awards)**: Verify `Honors & Commendations` long commendation text.

### 2. Header & Action Buttons Polish
- [ ] **Student Hero Card Metadata Wrap**:
  - Ensure student name, `Enrolled` badge, Roll #, and Admission # wrap cleanly across small viewports (320px–360px).
- [ ] **Hero Action Buttons (`Digital ID Card` & `Student File PDF`)**:
  - Maintain minimum $\ge 44\text{px}$ touch targets and verify labels do not clip on narrow widths.

### 3. Horizontal Tab Bar Navigation
- [ ] **Tab Bar Scroll Affordance**:
  - Verify horizontal choice chips (`Profile`, `Academics`, `Attendance`, `Fees`, `Transport`, `Documents`, `Awards`) scroll smoothly and maintain selected state contrast in Espresso Heritage theme.

### 4. Verification & Testing
- [ ] **Automated Widget Tests**:
  - Add or update widget tests in `test/` verifying zero RenderFlex overflow across phone screen constraints (320px, 360px, 390px, 412px).
- [ ] **Static Analysis**:
  - Run `flutter analyze` and confirm 0 errors, 0 warnings, 0 lints.
- [ ] **Full Test Suite**:
  - Run `flutter test` and confirm all test suites pass.
- [ ] **Live Device Verification**:
  - Deploy to connected physical device (`RMX5004`) and capture live screenshot to confirm resolution of the 27px overflow.
