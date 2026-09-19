# Action Items: Subject Teacher Bottom Navigation Update

## 1. Scope & Strict Role Isolation Guardrails
- [ ] Update the bottom navigation strictly and exclusively for the **Subject Teacher** role.
- [ ] Do NOT modify bottom navigation or UI for any other roles:
  - Student
  - Parent
  - Class Teacher
  - Admin
  - Superadmin
  - Any other role
- [ ] Implement role-aware navigation routing (conditionally display Subject Teacher navigation only when authenticated role/responsibility is Subject Teacher).

## 2. 5-Tab Subject Teacher Bottom Navigation Specification
- [ ] Set exact 5 primary bottom-navigation destinations for Subject Teacher:
  `Portal | Academics | Attendance | Timetable | More`
- [ ] Ensure `Portal` is the default landing screen upon login.
- [ ] Do NOT introduce `My Class` into the Subject Teacher bottom navigation.

## 3. Destination 1: Portal (Daily Operational Home)
- [ ] Label: `Portal`.
- [ ] Serve as the daily operational home providing:
  - Teacher identity & subject context
  - Today's classes & teaching summary
  - Current / next class awareness
  - Pending assessments
  - Important notices
  - Subject-related actionable items and quick actions
- [ ] Avoid turning Portal into an analytics dashboard.

## 4. Destination 2: Academics (Subject Teaching Workflows)
- [ ] Label: `Academics`.
- [ ] House subject-teaching academic workflows:
  - Assessments
  - Marks Entry
  - Academic Records
  - Examination-related workflows
- [ ] Omit unsupported modules.
- [ ] Do NOT duplicate full timetable or attendance views inside Academics (use shortcuts/previews).

## 5. Destination 3: Attendance (Permission-Based Access)
- [ ] Label: `Attendance`.
- [ ] Enforce role-based attendance permissions:
  - If authorized to mark period/class attendance: provide attendance marking workflow.
  - If authorized only to view: provide view-only attendance.
  - If unauthorized: do not expose attendance-marking actions.
- [ ] Preserve existing Class Teacher attendance workflows without modification.

## 6. Destination 4: Timetable (Dedicated Faculty Timetable)
- [ ] Label: `Timetable`.
- [ ] Open the dedicated `Faculty Timetable` screen displaying:
  - Day, Date, Period, Start/End times, Subject, Class/Section, Room (if available).
- [ ] Derive timetable strictly from the teacher's actual assigned teaching periods.

## 7. Destination 5: More (Secondary Teacher Features)
- [ ] Label: `More`.
- [ ] House secondary features that do not require permanent navigation bar placement:
  - Faculty Leave
  - Notices
  - Transport
  - Profile
  - Settings
  - Help
- [ ] Restrict items to supported features the Subject Teacher is authorized to access.

## 8. Role Precedence & Dual Assignment Handling
- [ ] Handle dual-responsibility teachers (Class Teacher + Subject Teacher) according to system precedence:
  - If a teacher with both roles is designated primarily as Class Teacher, preserve the Class Teacher experience.
  - Apply Subject Teacher navigation only when the active context/role is explicitly Subject Teacher.
- [ ] Reuse existing authentication and role/permission models; do not invent artificial role flags.

## 9. Visual Identity & Existing UI Design Preservation
- [ ] Preserve existing approved visual design:
  - Color palette, warm ivory/cream background, cocoa/brown accents
  - Typography (Newsreader / Manrope)
  - Card styling, spacing, borders, rounded corners, shadows
  - Bottom navigation bar styling and active/inactive visual treatments
- [ ] Do not redesign visual identity.

## 10. Icon System Specifications (Material Symbols Mapping)
- [ ] Do NOT use emojis or Unicode characters.
- [ ] Use Material Symbols / Material Icons matching existing application style:
  - Portal: `dashboard`
  - Academics: `menu_book`
  - Attendance: `how_to_reg`
  - Timetable: `calendar_month`
  - More: `apps`
- [ ] Maintain consistent icon sizing, weights, and touch targets.

## 11. Active Navigation States & Behavior
- [ ] Highlight only the currently selected destination (never multiple items simultaneously).
- [ ] Ensure correct screen mapping:
  - Portal → Subject Teacher Portal
  - Academics → Subject Teacher Academic workspace
  - Attendance → Subject Teacher Attendance workflow/view
  - Timetable → Faculty Timetable
  - More → Subject Teacher secondary hub
- [ ] Preserve navigation state cleanly across tab switches.

## 12. Cross-Destination Deduplication Rules
- [ ] Prevent duplicating complete full-screen modules across tabs.
- [ ] Portal may include a "Next Class" card with a `[View Timetable]` shortcut that navigates to the Timetable tab.
- [ ] Portal may display attendance status with a `[View Attendance]` shortcut that navigates to the Attendance tab.

## 13. Subject Teacher Portal Hierarchy & Content Focus
- [ ] Focus Subject Teacher Portal strictly on "Today's Teaching" rather than Homeroom/Class Teacher administration.
- [ ] Align hierarchy:
  1. Teacher Identity
  2. Today's Teaching Summary
  3. Current / Next Class
  4. Quick Actions
  5. Today's Schedule
  6. Pending Assessments
  7. Important Notices
- [ ] Exclude Class Teacher-only elements (Homeroom management, class-wide roll call, student care feeds) unless dual roles exist.

## 14. Dynamic Subject Context & Teaching Counts
- [ ] Emphasize subjects actually taught (e.g., `Good Morning, Anita • Mathematics • Subject Teacher • AY 2026–27`).
- [ ] Handle multiple subjects dynamically; do not hardcode.
- [ ] Derive today's class count dynamically from timetable (e.g., `Today's Classes: 4 Periods`).

## 15. Current & Next Class Display Rules
- [ ] Display `Current Class` with subject, class/section, period time, and room only when active according to device clock.
- [ ] Display `Next Class` for the immediate upcoming teaching period.
- [ ] Avoid fake countdown timers.

## 16. Quick Actions Scoping
- [ ] Restrict quick actions to supported academic tasks: `Marks Entry`, `Assessments`, `Attendance`, `Timetable`.
- [ ] Remove `Compose Circular` unless explicit administrative privileges exist.

## 17. Deep Testing Verification Checklist
- [ ] Test 1: Subject Teacher login displays `Portal | Academics | Attendance | Timetable | More`.
- [ ] Test 2: Class Teacher login preserves existing Class Teacher navigation.
- [ ] Test 3: Student login preserves existing Student navigation.
- [ ] Test 4: Admin login preserves existing Admin navigation.
- [ ] Test 5: Superadmin login preserves existing Superadmin navigation.
- [ ] Test 6: Tapping Portal activates Portal tab and screen.
- [ ] Test 7: Tapping Academics activates Academics tab and screen.
- [ ] Test 8: Tapping Attendance activates Attendance tab and screen.
- [ ] Test 9: Tapping Timetable activates Timetable tab and screen.
- [ ] Test 10: Tapping More activates More tab and screen.
- [ ] Test 11: Subject Teacher with attendance permission sees attendance workflow.
- [ ] Test 12: Subject Teacher without attendance permission has marking controls restricted/hidden.
- [ ] Test 13: Dual-role teacher follows role precedence without incorrect navigation overwrite.
- [ ] Test 14: Multiple subjects taught reflect dynamically in Portal and Timetable.
- [ ] Test 15: Multiple classes taught appear accurately in Timetable.
- [ ] Test 16: No classes today displays "No classes scheduled today".
- [ ] Test 17: Active class displays Current Class card.
- [ ] Test 18: Between classes displays Next Class card.
- [ ] Test 19: All classes finished displays no upcoming class state.
- [ ] Test 20: Pending assessments display correct count.
- [ ] Test 21: No pending assessments displays "No pending assessments".
- [ ] Test 22: No timetable configured displays unavailable/empty state (no fake cards).
- [ ] Test 23: Timetable tab displays only teacher's authorized schedule.
- [ ] Test 24: More tab displays only authorized secondary features.
- [ ] Test 25: Logout clears navigation state cleanly.
- [ ] Test 26: Switching user accounts updates navigation to the new role immediately.
- [ ] Test 27: Direct route access to Subject Teacher routes by Student is denied/redirected.
- [ ] Test 28: Direct route access enforced by role permissions for Class Teacher.
- [ ] Test 29: Browser/app refresh preserves correct role-specific navigation.
- [ ] Test 30: Authenticated Subject Teacher landing defaults to Portal screen.

## 18. Final Implementation Checklist
- [ ] Implement navigation strictly for Subject Teacher.
- [ ] Final destination order: `Portal | Academics | Attendance | Timetable | More`.
- [ ] Confirm no emojis are used and existing visual design language is preserved 100%.

---

# Original Prompt

You are updating the School ERP Android application's bottom navigation specifically for the **Subject Teacher role**.

IMPORTANT:
This change is ONLY for users whose role/responsibility is **Subject Teacher**.

DO NOT change the bottom navigation for:

- Student
- Parent
- Class Teacher
- Admin
- Superadmin
- Any other role

The existing navigation and UI for all other roles must remain unchanged.

==================================================
SUBJECT TEACHER BOTTOM NAVIGATION
==================================================

Replace the current Subject Teacher bottom navigation with:

Portal | Academics | Attendance | Timetable | More

Use exactly these 5 primary destinations.

==================================================
1. PORTAL
==================================================

Label:

Portal

Purpose:

Subject Teacher's daily operational home.

The Portal should provide:

- Teacher identity
- Today's classes
- Current / next class
- Today's teaching summary
- Pending assessments
- Important notices
- Subject-related actionable items
- Quick actions

Do not turn Portal into an analytics dashboard.

Portal should be the default landing screen after Subject Teacher login.

==================================================
2. ACADEMICS
==================================================

Label:

Academics

Purpose:

Subject Teacher's academic work.

This section should contain subject-teaching academic workflows such as:

- Assessments
- Marks Entry
- Academic Records
- Examination-related work
- Other academic features actually supported by the backend

Do not add unsupported modules.

Do not duplicate the complete timetable or attendance workflow here if those have dedicated bottom-navigation destinations.

==================================================
3. ATTENDANCE
==================================================

Label:

Attendance

Purpose:

Provide attendance functionality available to the Subject Teacher.

IMPORTANT:

Do NOT assume that every Subject Teacher can mark attendance for every class.

Attendance access must follow the actual application's permission/assignment rules.

If the backend permits Subject Teachers to record attendance for their assigned teaching period/class:

show the appropriate attendance workflow.

If Subject Teachers are only allowed to view attendance:

provide view-only attendance.

If Subject Teachers do not have attendance permission:

do not expose attendance-marking actions.

Do not change the Class Teacher attendance permissions.

The Class Teacher's existing attendance workflow must remain unchanged.

==================================================
4. TIMETABLE
==================================================

Label:

Timetable

Purpose:

Show the Subject Teacher's actual teaching timetable.

Open:

Faculty Timetable

The timetable should show:

- Day
- Date
- Period
- Start time
- End time
- Subject
- Class / Section
- Room, if available

The timetable must come from the teacher's actual timetable assignments.

Do not show the Class Teacher's timetable unless the logged-in teacher actually has those assignments.

Example:

Period 2
09:15 – 10:00

Mathematics

Grade 5-B
Room 204

==================================================
5. MORE
==================================================

Label:

More

Purpose:

Secondary teacher features that do not need permanent bottom-navigation space.

Potential features include:

- Faculty Leave
- Notices
- Transport
- Profile
- Settings
- Help
- Other supported secondary features

Only show features that actually exist and that the Subject Teacher is authorized to access.

==================================================
ROLE ISOLATION
==================================================

This is the MOST IMPORTANT requirement.

The new navigation:

Portal | Academics | Attendance | Timetable | More

must ONLY be applied to:

Subject Teacher.

Do not globally replace the navigation component.

Use role-aware navigation.

Conceptually:

if user role/responsibility == Subject Teacher:
    use Subject Teacher navigation

otherwise:
    preserve existing navigation for that role

Do not modify:

Student navigation
Class Teacher navigation
Admin navigation
Superadmin navigation
Parent navigation

==================================================
CLASS TEACHER VS SUBJECT TEACHER
==================================================

A teacher may have both responsibilities:

- Class Teacher
- Subject Teacher

Do NOT incorrectly force the Subject Teacher navigation simply because the teacher teaches a subject.

Determine the effective role/navigation from the application's actual role and assignment/permission model.

If the application treats a teacher with both responsibilities as a Class Teacher first:

preserve the existing Class Teacher experience.

If the application's role system explicitly distinguishes the Subject Teacher experience:

apply the Subject Teacher navigation accordingly.

Do not create a new role field just for this UI change unless the backend already supports it.

==================================================
EXISTING UI DESIGN
==================================================

DO NOT redesign the application's visual identity.

Preserve:

- existing colors
- typography
- Newsreader
- Manrope
- card styling
- spacing
- borders
- rounded corners
- shadows
- Material Symbols
- bottom navigation styling
- active/inactive navigation states

Only change the navigation destinations for Subject Teacher.

==================================================
ICON RULE
==================================================

Do NOT use emojis.

Use the existing Material Symbols / Material Icons.

Recommended icons:

Portal:
dashboard

Academics:
menu_book

Attendance:
how_to_reg

Timetable:
calendar_month

More:
apps

Keep icon sizing and styling consistent with the existing application.

==================================================
ACTIVE NAVIGATION
==================================================

The selected destination must clearly show the active state.

Example:

Portal
→ active when Teacher Portal is open

Academics
→ active when Academic section is open

Attendance
→ active when Attendance is open

Timetable
→ active when Faculty Timetable is open

More
→ active when More Hub is open

Do not highlight multiple navigation items simultaneously.

==================================================
NAVIGATION BEHAVIOR
==================================================

Subject Teacher:

Portal
→ Subject Teacher Portal

Academics
→ Subject Teacher Academic workspace

Attendance
→ Subject Teacher Attendance workflow/view

Timetable
→ Faculty Timetable

More
→ Subject Teacher secondary features

Each destination should preserve navigation state appropriately.

==================================================
DO NOT DUPLICATE FEATURES
==================================================

Avoid putting the same feature into multiple primary destinations unnecessarily.

For example:

Timetable belongs primarily under:

Timetable

Do not create another full timetable screen inside:

Portal
and
Academics.

Portal may show a small "Next Class" preview with a button:

View Timetable

that opens the dedicated Timetable screen.

Similarly:

Portal may show today's attendance status with:

View Attendance

that opens Attendance.

==================================================
SUBJECT TEACHER PORTAL
==================================================

The Subject Teacher Portal should focus on:

Today's Teaching

not Class Teacher administration.

Recommended hierarchy:

Teacher Identity

↓

Today's Teaching Summary

↓

Current / Next Class

↓

Quick Actions

↓

Today's Schedule

↓

Pending Assessments

↓

Important Notices

Avoid Class Teacher-specific items such as:

- Homeroom management
- Class-wide roll call responsibility
- Class Teacher-only student care workflows
- Class Teacher-only administrative actions

unless the teacher actually has both responsibilities.

==================================================
SUBJECT CONTEXT
==================================================

The Subject Teacher Portal should emphasize the subjects the teacher actually teaches.

Example:

Good Morning, Anita

Mathematics
Subject Teacher

AY 2026–27

If the teacher teaches multiple subjects:

show the actual subjects appropriately.

Do not hardcode:

Mathematics

unless it is real data.

==================================================
TODAY'S TEACHING
==================================================

Show the actual number of teaching periods.

Example:

Today's Classes
4 Periods

This must be calculated from the timetable.

Do not hardcode the number.

==================================================
CURRENT / NEXT CLASS
==================================================

If a class is currently active:

show:

Current Class

Mathematics
Grade 5-B
09:15 – 10:00
Room 204

If no class is currently active:

show the next actual teaching period.

Example:

Next Class

Mathematics
Grade 6-A
11:15 – 12:00
Room 108

Do not show fake countdowns.

==================================================
ACADEMIC QUICK ACTIONS
==================================================

Potential Subject Teacher quick actions:

Marks Entry
Assessments
Attendance
Timetable

Only include actions actually supported by the backend.

Do not add:

Compose Circular

unless the teacher has explicit permission.

==================================================
ATTENDANCE PERMISSION
==================================================

The UI must respect the actual attendance model.

Do not assume:

Subject Teacher = Can mark attendance.

The application should determine whether attendance is:

- Markable
- View-only
- Not available

based on actual permissions.

==================================================
TIMETABLE PERMISSION
==================================================

Subject Teacher should be able to view their timetable if the feature is available.

The timetable must only expose the teacher's authorized schedule.

==================================================
MORE SECTION
==================================================

Keep secondary features out of the bottom navigation.

Possible:

Faculty Leave
Notices
Transport
Profile
Settings

Only display supported features.

==================================================
NO NEW ROLE LOGIC UNLESS REQUIRED
==================================================

Do not introduce unnecessary backend changes.

This task is primarily a UI/navigation change.

Reuse the existing authentication and role/permission system.

If a role/permission already exists for Subject Teacher:

use it.

Do not create duplicate role definitions.

==================================================
DEEP TESTING
==================================================

TEST 1
Login as Subject Teacher.

Expected:

Portal | Academics | Attendance | Timetable | More

TEST 2
Login as Class Teacher.

Expected:

Existing Class Teacher navigation remains unchanged.

TEST 3
Login as Student.

Expected:

Existing Student navigation remains unchanged.

TEST 4
Login as Admin.

Expected:

Existing Admin navigation remains unchanged.

TEST 5
Login as Superadmin.

Expected:

Existing Superadmin navigation remains unchanged.

TEST 6
Subject Teacher opens Portal.

Expected:
Portal is active.

TEST 7
Subject Teacher opens Academics.

Expected:
Academics is active.

TEST 8
Subject Teacher opens Attendance.

Expected:
Attendance is active.

TEST 9
Subject Teacher opens Timetable.

Expected:
Timetable is active.

TEST 10
Subject Teacher opens More.

Expected:
More is active.

TEST 11
Subject Teacher has attendance permission.

Expected:
Attendance workflow available.

TEST 12
Subject Teacher has no attendance-marking permission.

Expected:
Marking controls are hidden/restricted.

TEST 13
Subject Teacher is also Class Teacher.

Expected:
Application follows the actual role/assignment precedence instead of blindly changing navigation.

TEST 14
Subject Teacher teaches multiple subjects.

Expected:
Portal/timetable reflect actual subjects.

TEST 15
Subject Teacher teaches multiple classes.

Expected:
Correct classes appear in timetable.

TEST 16
Subject Teacher has no classes today.

Expected:
No classes scheduled today.

TEST 17
Subject Teacher has a current class.

Expected:
Current Class displayed.

TEST 18
Subject Teacher has no current class but has an upcoming class.

Expected:
Next Class displayed.

TEST 19
Subject Teacher has no upcoming classes.

Expected:
No upcoming class state.

TEST 20
Subject Teacher has pending assessments.

Expected:
Correct assessment information.

TEST 21
Subject Teacher has no pending assessments.

Expected:
No pending assessments state.

TEST 22
Subject Teacher has no timetable.

Expected:
Timetable unavailable/empty state, not fake data.

TEST 23
Subject Teacher opens Timetable.

Expected:
Only their actual timetable is shown.

TEST 24
Subject Teacher opens More.

Expected:
Only authorized secondary features are shown.

TEST 25
Navigation after logout.

Expected:
No previous teacher navigation remains accessible.

TEST 26
Switch from Subject Teacher account to another role.

Expected:
Navigation updates according to the new role.

TEST 27
Directly open a Subject Teacher route while logged in as Student.

Expected:
Access is denied or redirected appropriately.

TEST 28
Directly open a Subject Teacher route while logged in as Class Teacher.

Expected:
Role/permission rules are enforced.

TEST 29
Refresh application.

Expected:
Correct role-specific navigation remains.

TEST 30
Reload app with authenticated Subject Teacher.

Expected:
Portal remains the default landing screen.

==================================================
FINAL REQUIREMENT
==================================================

Implement this navigation ONLY for:

SUBJECT TEACHER

Final Subject Teacher navigation:

Portal | Academics | Attendance | Timetable | More

Do not change the navigation of any other role.

Do not introduce My Class.

Do not move Class Teacher functionality into Subject Teacher navigation.

Do not remove existing Class Teacher attendance behavior.

Do not invent permissions.

Do not invent modules.

Do not redesign the existing visual system.

Do not use emojis.

The primary goal is:

ROLE-SPECIFIC NAVIGATION
+
CLEAR SUBJECT TEACHER WORKFLOW
+
DIRECT ACCESS TO ATTENDANCE
+
DIRECT ACCESS TO TIMETABLE
+
ACADEMIC WORK MANAGEMENT
+
NO IMPACT ON OTHER ROLES
