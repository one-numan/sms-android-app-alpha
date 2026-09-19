# One Numan Public School (ONPS) — Android FAQ & Knowledge Base Documentation

**Version:** 1.0.0  
**Target Platform:** Android (Flutter Engine / Native ARM64)  
**Storage Architecture:** Local SQLite (`sqflite: ^2.3.3+1`, `path: ^1.9.0`)  
**Design System:** Espresso Heritage Academic (`#FCFAF6` Canvas, `#3E2A22` Primary Dark, `#D4AF37` Gold Accents)  
**Status:** [COMPLETED & VERIFIED ON PHYSICAL DEVICE]  

---

## 1. Executive Summary & Purpose

The **Help & FAQs Knowledge Base Module** delivers an offline-first, zero-latency repository of institutional answers tailored for One Numan Public School (ONPS). Designed for students, parents, faculty, and administrative personnel, the system operates completely independently of external network availability through a local SQLite database (`onps_erp.db`), pre-seeded on first install.

### Key Capabilities
- **Zero-Network Offline Access**: 14+ pre-seeded institutional questions categorized across 6 operational domains.
- **Offline Full-Text Search**: Instant search queries across question titles and full answer texts.
- **Interactive Helpfulness Feedback**: Local SQLite vote counting (`helpful_votes`, `unhelpful_votes`) with voter deduplication via `SharedPreferences`.
- **Persistent Bookmarking**: Star/favorite questions persisted directly in SQLite.
- **Role & Domain Filtering**: Horizontal filter chips to narrow queries by workflow (`fees`, `academics`, `attendance`, `transport`, `security`, `general`, or `favorites`).
- **Emergency Helpdesk Escalation**: Direct one-tap contact buttons for the school administrative office and technical support desk.

---

## 2. Institutional FAQ Catalog by Domain & Persona

All questions and answers represent production-grade school workflows:

### Category A: Fees, Receipts & Online Payments (`fees`)
*Target Personas: Parent, Student, Accountant*

1. **How do I pay school tuition fees online?**
   * **Answer**: Go to the **Fees** tab from the bottom navigation bar or dashboard, tap **View Itemized Fees & Pay**, select your pending term installment (Term 1, Term 2, or Annual), choose UPI, Net Banking, or Credit/Debit Card, and complete payment. Instant digital acknowledgment is generated upon success.
   * **Tags**: `Fees & Billing`, `Online Payments`, `UPI`

2. **Where can I download official fee receipts for income tax (80C)?**
   * **Answer**: Navigate to **Fees → Fee Ledger**, tap any completed transaction, and tap **Download PDF Receipt**. All receipts carry the official school seal, affiliation number, and authorized accountant stamp.
   * **Tags**: `Tax Exemption`, `80C`, `Receipts`

3. **What is the late fee policy and grace period?**
   * **Answer**: Term fees are due by the 15th of the billing month. A grace period of 7 calendar days is provided. A nominal late fee of ₹50/day applies thereafter up to a maximum cap of ₹1,000 before term examinations.
   * **Tags**: `Late Fees`, `Grace Period`, `Policy`

---

### Category B: Academics, Examinations & CBSE (`academics`)
*Target Personas: Student, Parent, Teacher, Principal*

4. **When and how are Term Report Cards published?**
   * **Answer**: Academic report cards are published within 7 business days of evaluation completion. Parents and students can view them via **Academics → Report Card** to review scholastic scores, percentiles, faculty observations, and CBSE 9-point scale grading.
   * **Tags**: `Report Cards`, `CBSE`, `Grades`

5. **What is the CBSE passing criteria and grading system?**
   * **Answer**: Students must secure a minimum of 33% marks in each subject (both theory and practical/internal assessments separately) and aggregate 33% overall to qualify. Grades follow the standard CBSE 9-point scale ($A1$ to $E$).
   * **Tags**: `Passing Marks`, `Grading Scale`, `CBSE`

6. **How do teachers submit term marks into the system?**
   * **Answer**: Faculty members open the **Marks Entry Desk** from their dashboard, choose their assigned Class and Subject, input student scores with validation checks, and submit for Class Teacher and Principal sign-off.
   * **Tags**: `Marks Entry`, `Faculty`, `Validation`

---

### Category C: Attendance & Student Leave Applications (`attendance`)
*Target Personas: Parent, Student, Class Teacher*

7. **How do parents apply for student leave?**
   * **Answer**: Open **Attendance → Apply for Leave**, select the date range, choose the leave category (Medical, Family Event, Emergency), attach a doctor's certificate if duration $>2$ days, and submit for Class Teacher approval.
   * **Tags**: `Leave Application`, `Medical Certificate`, `Absence`

8. **What is the mandatory attendance threshold for CBSE board exams?**
   * **Answer**: CBSE mandates a minimum of **75% aggregate attendance** throughout the academic session to be eligible for board examinations. Automated SMS and push notifications are triggered if a student's attendance drops below 80%.
   * **Tags**: `Attendance Threshold`, `75 Percent`, `CBSE Rule`

---

### Category D: Bus Transit & Safe Student Commute (`transport`)
*Target Personas: Parent, Student, Transport Officer*

9. **How can I track my ward's school bus live?**
   * **Answer**: Navigate to **More → Bus Transit**. If enrolled in school transit, you will see real-time GPS positioning, driver contact, vehicle registration number, and estimated time of arrival (ETA) at your designated stop.
   * **Tags**: `Live GPS`, `Bus Tracking`, `ETA`

10. **How do I change my assigned bus stop or route?**
    * **Answer**: Submit an official transit change request under **Transit Desk → Request Stop Change** at least 5 business days prior to the start of the upcoming month.
    * **Tags**: `Stop Change`, `Route Reallocation`, `Transit Desk`

---

### Category E: Digital Student ID & Campus Security (`security`)
*Target Personas: Student, Parent, Security Desk*

11. **How does the Digital Student ID Card work?**
    * **Answer**: Open **Digital ID** from your student profile. The card features an animated holographic crest, dynamic security QR code for library and turnstile verification, bus pass metadata, and emergency blood group info.
    * **Tags**: `Digital ID`, `Holographic Crest`, `QR Gate Access`

12. **What should I do if my student's physical RFID badge is lost?**
    * **Answer**: Immediately report it under **Digital ID → Report Lost Card** to instantly revoke turnstile access. A duplicate physical card can be requested for ₹150 at the Reception Desk.
    * **Tags**: `Lost Card`, `RFID Revocation`, `Duplicate Badge`

---

### Category F: General, Calendar & Grievances (`general`)
*Target Personas: All Roles*

13. **What are the official school operating hours?**
    * **Answer**: Summer Wing: 07:30 AM – 01:45 PM | Winter Wing: 08:00 AM – 02:15 PM. Administrative and Accounts desks remain open until 03:30 PM on weekdays and 01:00 PM on working Saturdays.
    * **Tags**: `School Hours`, `Office Timings`, `Schedules`

14. **How do I book a Parent-Teacher Meeting (PTM)?**
    * **Answer**: Upcoming PTM schedules are posted on the **Notice Board**. For urgent academic consultations, parents can request a 15-minute slot through the Class Teacher's profile screen.
    * **Tags**: `PTM Booking`, `Teacher Consultation`, `Parent Connect`

---

## 3. SQLite Database Architecture (`sqflite`)

### 3.1 Database Specifications
* **Database File**: `onps_erp.db` (Stored in Android application sandbox via `getDatabasesPath()`)
* **Current Version**: `1`
* **Driver**: Native SQLite engine embedded in Android OS, bound via Flutter `sqflite` C-bindings.

### 3.2 Relational Schema
```sql
CREATE TABLE IF NOT EXISTS faqs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    category TEXT NOT NULL,        -- 'fees', 'academics', 'attendance', 'transport', 'security', 'general'
    target_roles TEXT NOT NULL,    -- 'all', 'parent', 'student', 'teacher', 'principal'
    display_order INTEGER NOT NULL DEFAULT 0,
    is_favorite INTEGER NOT NULL DEFAULT 0,     -- 0 = false, 1 = true
    helpful_votes INTEGER NOT NULL DEFAULT 0,
    unhelpful_votes INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Performance Indexes
CREATE INDEX IF NOT EXISTS idx_faqs_category ON faqs (category);
CREATE INDEX IF NOT EXISTS idx_faqs_target_roles ON faqs (target_roles);
CREATE INDEX IF NOT EXISTS idx_faqs_favorite ON faqs (is_favorite);
```

### 3.3 Database Operations & Queries
- **Category & Role Filtering**:
  ```sql
  SELECT * FROM faqs 
  WHERE category = ? 
    AND (target_roles LIKE '%all%' OR target_roles LIKE ?)
  ORDER BY display_order ASC;
  ```
- **Offline Full-Text Search**:
  ```sql
  SELECT * FROM faqs 
  WHERE (question LIKE '%query%' OR answer LIKE '%query%')
  ORDER BY display_order ASC;
  ```
- **Vote Increment**:
  ```sql
  UPDATE faqs 
  SET helpful_votes = helpful_votes + 1, updated_at = CURRENT_TIMESTAMP 
  WHERE id = ?;
  ```
- **Favorite Toggle**:
  ```sql
  UPDATE faqs 
  SET is_favorite = ?, updated_at = CURRENT_TIMESTAMP 
  WHERE id = ?;
  ```

---

## 4. Architecture & File Structure

```
lib/
├── models/
│   └── faq_model.dart                   # FaqItem entity, serialization & helpers
├── data/
│   ├── local/
│   │   └── faq_database.dart            # SQLite DB singleton & 14 seed records
│   └── repositories/
│       └── faq/
│           └── faq_repository.dart      # Business logic & vote deduplication
├── screens/
│   └── help/
│       └── faq_screen.dart              # UI view with search & accordion cards
└── router.dart                          # Route registration (/help/faqs, /faqs, /help)
```

---

## 5. UI / UX Design Specifications

Built strictly under the **Espresso Heritage Academic Design System**:

| UI Component | Token / Style | Implementation Detail |
| :--- | :--- | :--- |
| **Canvas Background** | `#FCFAF6` (`AcademicColors.canvas`) | Warm ivory cream matte background eliminating clinical white glare |
| **Primary Typography** | `GoogleFonts.newsreader` (700 Serif) | Academic editorial hierarchy for question titles |
| **Body Typography** | `GoogleFonts.manrope` (400/500 Sans) | High-legibility geometric sans-serif for answers |
| **Category Chips** | `#3E2A22` Active / `#FCFAF6` Inactive | Horizontal scrolling pill row with gold accents |
| **Card Accordion** | Border: `#E8E2D9`, Radius: `14px` | Smooth expand/collapse state with micro-animations |
| **Helpfulness Voting**| Green `AcademicColors.success` / Red `error` | Tap to record feedback; disables buttons once voted |
| **Contact Desk** | Rounded Surface Card (`#FFFFFF`) | Direct telephone and email actions for administration |

---

## 6. Route Navigation & 3-Dots Menu Integration

The FAQ screen is directly accessible system-wide from any screen through the universal top bar:

### 6.1 Top Bar 3-Dots Menu (`AppTopBar`)
- Every screen in the application features the `Icons.more_vert` (3-dots) menu button.
- Selecting **`Help & FAQ`** from the 3-dots dropdown immediately navigates to `/help/faqs`:
  ```dart
  case 'help':
    context.push('/help/faqs');
    break;
  ```
- Displays current user identity header (`fullName`, `roleTitle`, avatar initials).

### 6.2 Role-Aware Personalized Display
When opened, the FAQ screen dynamically inspects the active user persona from `AuthState`:
- **Personalized Header Banner**: Displays user's name, role badge, and role-specific icon (e.g. `Icons.family_restroom` for Parent, `Icons.psychology` for Teacher, `Icons.school` for Student, `Icons.account_balance_wallet` for Accountant, `Icons.admin_panel_settings` for Principal).
- **"For Me" vs "All FAQs" 1-Tap Toggle**:
  - `For Me` (Default): Automatically filters SQLite database by `target_roles = 'all' OR target_roles LIKE '%<role>%'`.
  - `All FAQs`: Expands results to all institutional topics across the entire institution.
- **Dynamic Role Switching**: If the user switches role via `RoleSwitcherSheet`, the FAQ view automatically re-queries SQLite to display the newly active persona's relevant FAQs.

### 6.3 Additional Entry Points
1. **Account Settings Screen** (`/account/settings`):
   - Tile: `School FAQs & Knowledge Base` → `context.push('/help/faqs')`
2. **Global Module Grid Sheet**:
   - Module: `School FAQs` (Parent & Student section) → `context.push('/help/faqs')`

---

## 7. Verification & Automated Quality Standards

- **Unit Tests**: `test/faq_model_test.dart`
  - `toMap` / `fromMap` serialization integrity: **PASS**
  - Category icon and title resolution: **PASS**
  - Institutional seed dataset validity: **PASS**
- **Static Analysis**: `flutter analyze` reports **0 issues**.
- **Physical Device Deployment**: Installed and verified on **Realme RMX5004** (Android 14) over local ADB at `192.168.0.111:37701`.
