# Action Items: Admissions Desk — AppBar Truncation & Bottom Sheet Viewport Polish

> **Screen**: Admissions Enquiry & Prospect Intake Desk (`AdmissionsEnquiryScreen`)  
> **Source File**: `lib/screens/admissions/admissions_enquiry_screen.dart`  
> **Device Audited**: Realme RMX5004 (Android 16, API 36)  
> **Capture Timestamp**: 2026-09-19 14:13 IST  
> **Design Theme**: Espresso Heritage Academic (`#F7F1E8`, `#3E2A22`, `#FFFDF9`)  
> **Icon & Rule Standard**: Strict 0 Unicode Emojis (Material Symbols / Icons only)

---

## 1. Live Physical Device Audit Findings

### Issue A: AppBar Title Truncated to "Admi..."
- **Location**: `lib/screens/admissions/admissions_enquiry_screen.dart:200–216`
- **Component**: `AppTopBar(title: 'Admissions Desk', actions: [ ElevatedButton.icon(label: 'New Intake', ...), ... ])`
- **Symptom**: On mobile screen widths (360px–412px), the title is aggressively clipped into `"Admi..."`.
- **Root Cause**:
  - The AppBar row contains:
    1. Leading back button (~48px)
    2. Large `ElevatedButton.icon` with "New Intake" label & padding (~130px)
    3. Trailing search icon, notification bell, and 3-dots popup menu (~120px)
  - This leaves less than 70px for the title `"Admissions Desk"`, causing text truncation.
- **Required Fix**:
  - Replace the text-heavy `ElevatedButton.icon` in the AppBar actions with a clean, compact `IconButton(icon: Icon(Icons.person_add_alt_1), tooltip: 'New Intake')` or move the primary "New Intake" action to a Floating Action Button (FAB) / Intake Pipeline card header.

---

### Issue B: Modal Bottom Sheet Viewport & Navigation Bar Clipping
- **Location**: `lib/screens/admissions/admissions_enquiry_screen.dart:37–181` (`_showNewEnquiryDialog`)
- **Component**: `showModalBottomSheet` for "New Admission Prospect Intake".
- **Symptom**: The primary submission button `"Record Prospect Intake"` is cut off at the bottom by the Android 3-button/gesture navigation bar. When the software keyboard opens, the inputs lack scrollability.
- **Root Cause**:
  - The bottom sheet container lacks a `SafeArea` wrapper at the bottom and does not wrap its input fields inside a `SingleChildScrollView`.
- **Required Fix**:
  - Wrap the modal content in `SafeArea` and `SingleChildScrollView(physics: BouncingScrollPhysics(), child: ...)`.
  - Ensure proper `viewInsets.bottom` keyboard padding is maintained.

---

## 2. Comprehensive Action Items Checklist

### 1. AppBar Header Polish
- [ ] **Eliminate AppBar Title Truncation**:
  - In `lib/screens/admissions/admissions_enquiry_screen.dart:200–216`, replace `ElevatedButton.icon` with a compact `IconButton` with tooltip `'New Intake'` or integrate a dedicated Floating Action Button (`FloatingActionButton.extended`).
  - Verify `'Admissions Desk'` displays in full without truncation across all mobile viewports (320px–412px).

### 2. Modal Intake Sheet Refinements
- [ ] **Wrap Bottom Sheet in `SafeArea` & `SingleChildScrollView`**:
  - Add `SafeArea` to prevent clipping behind the Android navigation bar.
  - Wrap the column of text fields in `SingleChildScrollView` to support smooth scrolling when the keyboard rises.
- [ ] **Input Field Polish**:
  - Ensure proper input validation and dismiss keyboard on sheet submit.

### 3. Verification & Testing
- [ ] **Automated Widget Tests**:
  - Add widget tests verifying full title rendering and modal scrollability without overflow or truncation.
- [ ] **Static Analysis**:
  - Run `flutter analyze` and confirm 0 errors, 0 warnings, 0 lints.
- [ ] **Full Test Suite**:
  - Run `flutter test` and confirm all tests pass.
- [ ] **Live Device Verification**:
  - Deploy to connected physical device (`RMX5004`) and verify clean AppBar layout and bottom sheet presentation.
