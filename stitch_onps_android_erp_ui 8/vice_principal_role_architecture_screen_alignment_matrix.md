# One Numan Public School (ONPS) — Android ERP Mobile Suite
## Vice Principal Role Architecture & Screen Alignment Matrix
**Design System:** Espresso Heritage Academic (`DESIGN_SYSTEM_1`)  
**Target Viewport:** Android Mobile (390–412px, 844px height)  
**Django Permission Gate:** `is_principal_tier` (`apps/common/permissions.py`)  
**Role Equivalence:** Vice Principal ∈ `PRINCIPAL_TIER_GROUPS` (Identical permissions and feature access to Principal).

---

### 1. Executive Role Summary & Architecture

In the ONPS backend architecture (`apps/common/permissions.py`), **Vice Principal** and **Principal** are unified under `PRINCIPAL_TIER_GROUPS`:

```python
# apps/common/permissions.py
PRINCIPAL_TIER_GROUPS = ['Principal', 'Vice Principal']

def is_principal_tier(user):
    return user.is_authenticated and (
        user.is_superuser or 
        user.groups.filter(name__in=PRINCIPAL_TIER_GROUPS).exists()
    )
```

Because every permission check in the ONPS Django application gates on `is_principal_tier`, **Vice Principal and Principal share 100% feature parity, operational dashboards, administrative desks, and bottom dock navigation**. 

When an authenticated user logs in with the Vice Principal designation (e.g. Dr. K. Radhakrishnan, Vice Principal & Academic Administrator), the auto-navigator routes directly into the Executive Command Hub with full executive authority across:
- All 24 Principal/Leadership modules (Accounts, Library, Faculty Allocation, Admissions, Calendar, Announcements Approval, Student Registry, Inventory, Staff Directory).
- The unified **5-Tab Executive Bottom Dock**: `Hub`, `Academics`, `Accounts`, `Roster`, `More`.

---

### 2. Complete 24-Module Operational Mapping Matrix

| # | Sidebar Map Module | Operational Mobile Screen | Current Screen Placeholder | Vice Principal Access Status |
| :---: | :--- | :--- | :---: | :--- |
| **1** | **Role Dashboard (Executive Hub)** | `24 - Principal Executive Command & ERP Hub` | `{{DATA:SCREEN:SCREEN_30}}` / `{{DATA:SCREEN:SCREEN_33}}` | ✅ **Active & Complete** (8 KPIs, At a Glance, Structural Gaps, Attendance/Fee Charts) |
| **2** | **Accounts & Bursar Dashboard** | `Accounts & Fee Collection Executive Dashboard` | `{{DATA:SCREEN:SCREEN_11}}` | ✅ **Active & Complete** (Expected ₹18.40L, Collected, Outstanding, Class & Mode Breakdown) |
| **3** | **Library & Circulation Desk** | `Principal Library & Resource Circulation Dashboard` | `{{DATA:SCREEN:SCREEN_7}}` | ✅ **Active & Complete** (Titles, Loans, Overdue Action, Trending Reads, Executive Audit) |
| **4** | **Class & Faculty Allocation** | `All Classes & Academic Faculty Allocation Dashboard` | `{{DATA:SCREEN:SCREEN_23}}` | ✅ **Active & Complete** (Grades PG–12, Section Class Teachers, Subject-Teacher Mappings) |
| **5** | **Admissions Enquiries Intake** | `Admissions Enquiry & Prospect Intake Desk` | `{{DATA:SCREEN:SCREEN_22}}` / `{{DATA:SCREEN:SCREEN_76}}` | ✅ **Active & Complete** (Lead intake, search by name/parent/mobile, follow-up state) |
| **6** | **Admissions Applications Queue** | `Principal Admissions Applications & Enrollment Desk` | `{{DATA:SCREEN:SCREEN_20}}` | ✅ **Active & Complete** (Formal applications, Pending/Under Review/Approved/Rejected) |
| **7** | **School Calendar & Holidays** | `Principal School Calendar & Institutional Events Desk` | `{{DATA:SCREEN:SCREEN_18}}` / `{{DATA:SCREEN:SCREEN_70}}` | ✅ **Active & Complete** (Month grid, gazetted holidays, Add Event modal with audience scoping) |
| **8** | **Announcement Moderation Queue**| `25 - Principal Announcement Moderation & Approval Queue` | `{{DATA:SCREEN:SCREEN_61}}` | ✅ **Active & Complete** (Approve & Publish, Reject with note, Audience scope inspection) |
| **9** | **Notice Board & Circulars** | `13 - School Notice Board & Moderated Circulars` | `{{DATA:SCREEN:SCREEN_63}}` | ✅ **Active & Complete** (Public and faculty notices, pinned advisories, attachments) |
| **10**| **Student Registry (See All)** | `Student - See All Students Ledger` | `{{DATA:SCREEN:SCREEN_12}}` | ✅ **Active & Complete** (Complete institutional ledger with multi-criteria bottom filter) |
| **11**| **Parents Directory (See All)** | `Parents - All Parents Directory` | `{{DATA:SCREEN:SCREEN_16}}` | ✅ **Active & Complete** (Directory cards, linked wards, emergency contacts, WhatsApp/Call) |
| **12**| **Faculty & Staff Directory** | `27 - Institutional Faculty & Staff Directory` | `{{DATA:SCREEN:SCREEN_56}}` / `{{DATA:SCREEN:SCREEN_50}}` | ✅ **Active & Complete** (Academic, Admin, Accounts, Logistics departments) |
| **13**| **Campus Inventory Desk** | `Inventory - All Items & Low Stock Desk` | `{{DATA:SCREEN:SCREEN_14}}` | ✅ **Active & Complete** (Consumables, lab gear, textbooks, low stock alert badges) |
| **14**| **Fleet Transport & Transit** | `17 - Student Bus Route & Transit Card` | `{{DATA:SCREEN:SCREEN_68}}` | ✅ **Active & Complete** (Vehicles, routes, morning/afternoon schedules, driver contact) |
| **15**| **Examinations Marks Registry** | `20 - Subject Teacher Assessment Marks Entry Desk` | `{{DATA:SCREEN:SCREEN_65}}` | ✅ **Active & Complete** (FA1, Half-Yearly, FA2, Final scores oversight) |
| **16**| **Student 360 Dossier** | `06 - Student 360 Profile Dossier` | `{{DATA:SCREEN:SCREEN_55}}` | ✅ **Active & Complete** (Full 7-tab dossier: Profile, Academics, Attendance, Fees, Transport, Awards) |
| **17**| **Academic Report Card** | `07 - Academic Report Card` | `{{DATA:SCREEN:SCREEN_77}}` | ✅ **Active & Complete** (CBSE 4-Term transcript, cumulative GPA, grade scale A1–E) |
| **18**| **Monthly Attendance Matrix** | `11 - Student Monthly Attendance Matrix` | `{{DATA:SCREEN:SCREEN_67}}` | ✅ **Active & Complete** (Day 1–31 P/A/L/E matrix, percentage indicators) |
| **19**| **Daily Roll Call Register** | `19 - Class Teacher Daily Roll Call Register` | `{{DATA:SCREEN:SCREEN_75}}` | ✅ **Active & Complete** (Executive inspection and override roll call) |
| **20**| **Faculty Leave Management** | `22 - Faculty Leave Application & Balance Tracker` | `{{DATA:SCREEN:SCREEN_64}}` | ✅ **Active & Complete** (Leave application, balances CL/SL/EL, proxy assignment) |
| **21**| **Student Leave History** | `12 - Student Leave Application & History` | `{{DATA:SCREEN:SCREEN_66}}` | ✅ **Active & Complete** (Medical/casual applications, doctor notes, leave ledger) |
| **22**| **Cross-Entity Global Search** | `26 - Unified Cross-Entity ERP Search` | `{{DATA:SCREEN:SCREEN_48}}` / `{{DATA:SCREEN:SCREEN_57}}` | ✅ **Active & Complete** (Global omnibox searching students, staff, classes, receipts) |
| **23**| **Digital Student ID Sheet** | `29 - Digital Student ID Card Sheet` | `{{DATA:SCREEN:SCREEN_72}}` | ✅ **Active & Complete** (Encrypted QR, barcode, emergency medical blood group) |
| **24**| **Official Fee Voucher Receipt**| `10 - Official Fee Payment Receipt` | `{{DATA:SCREEN:SCREEN_69}}` | ✅ **Active & Complete** (Stamped bursar fee voucher with transaction ID & payment mode) |

---

### 3. Role Title Adaptation in Executive UI

To reflect Vice Principal identity on screen when the authenticated user is a Vice Principal (without altering any underlying features or permissions):
- **Executive Header Badge**: Shows `"Vice Principal Desk"` / `"Academic Administration"`.
- **Top Profile Pill**: Displays the Vice Principal's name, avatar, and staff code (e.g. `VP-ADM-102 · Dr. K. Radhakrishnan`).
- **Unified Navigation Dock**: Preserves the standard **Executive 5-Tab Bottom Dock** (`Hub`, `Academics`, `Accounts`, `Roster`, `More`).
