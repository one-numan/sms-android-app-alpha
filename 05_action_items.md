# Action Items: Teacher Portal / Teacher Home Screen Refinement

## 1. Scope & Visual Identity Preservation
- [ ] Refine the existing Teacher Portal / Teacher Home screen (`Teacher Portal HTML` reference).
- [ ] Preserve the existing approved visual design; do NOT redesign the visual identity.
- [ ] Retain warm cream background, ivory surfaces, cocoa/brown primary color, Newsreader and Manrope typography, rounded cards, spacing, shadows, border system, Material Symbols, and existing header/bottom navigation.
- [ ] Avoid introducing new color palettes, gradients, glassmorphism, neon colors, excessive shadows, oversized illustrations, unnecessary animations, or unrelated dashboard patterns.
- [ ] Focus improvements on information hierarchy, data representation, teacher workflow, role-aware information, usability, accuracy, mobile experience, and edge cases.

## 2. Screen Role & Primary Purpose
- [ ] Frame the screen as the teacher's operational daily home (first bottom-nav item: `Portal`), not a generic analytics dashboard.
- [ ] Ensure the portal answers 8 core questions within a few seconds:
  1. Who am I?
  2. What class/responsibilities do I have?
  3. What do I need to do today?
  4. What classes do I have today?
  5. What attendance work is pending?
  6. What academic work is pending?
  7. Are there important school notices?
  8. Is there anything requiring my attention?

## 3. Icon System Standards
- [ ] Do NOT use emojis anywhere on the screen.
- [ ] Do NOT use Unicode characters as decorative icons.
- [ ] Use existing Material Symbols / Material Icons with uniform family styling, consistent sizing, consistent stroke/fill treatments, and appropriate touch targets.

## 4. Application Header & Subtitle Refinement
- [ ] Maintain the top app bar structure: School Crest, `One Numan Public School`, `2026–27` (dynamically bound to school session), Notifications, and Profile.
- [ ] Replace the current subtitle `Academic Records` with a workspace-appropriate label: `Teacher Portal` or `Teacher Workspace`.

## 5. Teacher Identity Banner & Profile Data
- [ ] Maintain teacher identity banner dynamically populated from authenticated profile data (e.g., `Good Morning, Anita`, `Mathematics`, `Class Teacher · 5-A`, `AY 2026–27`).
- [ ] Do not hardcode `Mrs. Desai` in production; use actual display name with appropriate title if stored.

## 6. Role & Class Context Derivation
- [ ] Dynamically derive teacher role from actual assignments (Class Teacher, Subject Teacher, or both); avoid permanent static labels like `Teacher Type: Class Teacher`.
- [ ] Show Class Teacher context (e.g., `Class Teacher · 5-A`) only if officially assigned; do not display `Homeroom 5-A` as mock boilerplate if unassigned.
- [ ] Gracefully display multiple teaching assignments without cluttering the banner.

## 7. Academic Session Context
- [ ] Display active academic session (e.g., `AY 2026–27`) derived dynamically from session configuration, never hardcoded.

## 8. Notification Header Action
- [ ] Display unread notification badge/indicator only when real unread notifications exist; do not show a red badge when count is zero.
- [ ] Avoid fabricated notification counts; tapping icon routes directly to the notification screen.

## 9. Portal Content Organization & Hierarchy
- [ ] Organize main content into a strict, logical priority sequence:
  1. Today's Summary (2x2 KPI grid)
  2. Quick Actions
  3. Current / Next Class
  4. Today's Schedule
  5. Pending Work / Needs Attention
  6. Important Notices
- [ ] Avoid visual clutter; do not give equal weight to every element.

## 10. Section 1 — Today's Summary (2x2 KPI Grid)
- [ ] Maintain a refined 2x2 summary grid containing data-driven metrics:
  - Today's Attendance
  - Today's Classes
  - Pending Assessments
  - Important Notices
- [ ] Display metrics only when backed by real underlying data.

## 11. Today's Attendance Metric & Action
- [ ] Display attendance summary for assigned class (e.g., `31 / 32 Present • 96.8%` or `31 Present • 1 Not Marked`).
- [ ] Calculate percentage dynamically from real records; do not hardcode static mock ratios.
- [ ] Provide contextual action: `Take Attendance` or `Complete Attendance` if incomplete; display `Attendance Complete` if already submitted.

## 12. Critical Attendance State Semantics (Not Marked vs. Absent)
- [ ] Enforce strict distinction: `Not Marked` is NOT `Absent`.
- [ ] Ensure unrecorded students are counted as incomplete, never as absent.

## 13. Today's Classes & Period Counts
- [ ] Calculate teaching periods dynamically from timetable (e.g., `4 Periods • 3 Completed · 1 Upcoming`).
- [ ] If no classes are scheduled today, display `No classes scheduled today.` (avoid `0 Periods` as the primary message).

## 14. Current / Next Class Awareness
- [ ] Provide immediate operational awareness of `Now` (current period) or `Next` (upcoming period).
- [ ] Show `Now` only when the real-time clock falls within period start and end times (e.g., `Now • Mathematics • Grade 5-A • 11:05 – 11:50 • Room 204`).
- [ ] Show `Next` only when a real upcoming class exists today; avoid competing "next" classes.

## 15. Pending Assessments KPI
- [ ] Display pending assessment count only when actual tasks exist (e.g., `Pending Assessments • 4 Papers • FA2 Mathematics`).
- [ ] If no assessments are pending, display `No pending assessments` (avoid `0 Papers` unless required by specific design token).
- [ ] Do not invent mock assessment names (e.g., `FA2 Math Roster`).

## 16. School Notices KPI & Priority
- [ ] Display notice KPI based on genuine teacher-relevant notices (e.g., `Important Notices • 1 Important • Dense Fog Advisory`).
- [ ] Prioritize by actual system urgency (`Important`, `Urgent`, `General`); do not fabricate school-wide alerts.

## 17. Quick Actions Architecture
- [ ] Provide a compact set of 3–4 high-value primary actions based on actual permissions.
- [ ] Recommended actions: `Take Attendance`, `Marks / Assessments`, `Timetable`, `Leave`.
- [ ] Avoid large 8–12 button grids.

## 18. Quick Action Specifics
- [ ] `Take Attendance`: routes Class Teacher to Daily Roll Call Register (available only if authorized).
- [ ] `Marks / Assessments`: routes to assessment workflow (do NOT use technical jargon `Marks Entry Terminal`).
- [ ] `Timetable`: routes to Faculty Timetable screen.
- [ ] `Leave`: routes to faculty leave workflow only if the feature exists; remove if unimplemented.

## 19. Unauthorized Action Removal
- [ ] Remove `Compose Circular` from teacher quick actions unless the teacher has explicit administrative communication privileges.

## 20. Today's Academic Schedule Display
- [ ] Display periods in strict chronological order, each showing: Period, Time, Subject, Class, and Room.
- [ ] Calculate schedule progress dynamically; do not hardcode `2 Completed • 1 Live Now • 2 Ahead`.

## 21. Real-Time Period Statuses
- [ ] `Live Now`: highlight current class with contextual `[Take Attendance]` action if applicable and authorized.
- [ ] `Next`: highlight the immediate next class.
- [ ] `Completed`: visually subdued presentation without competing with active classes.
- [ ] Breaks: represent non-teaching blocks (e.g., `Morning Break • 20 min`) subtly; do not invent fake break periods.

## 22. Student Attention & Care Feed Sanitization
- [ ] Restrict attention items strictly to actionable, authorized teacher workflows (e.g., pending leave requests, attendance follow-ups).
- [ ] Do not turn the Portal into an exhaustive student roster (keep it to actionable items e.g., `2 items require attention`).

## 23. Medical & Personal Privacy Protection
- [ ] Completely remove medical diagnoses and prescriptions from the Portal dashboard (remove `Seasonal Viral Pyrexia`, `Rx Attached`).
- [ ] Format leave applications minimally: `Diya Sharma • Leave Application • Oct 28–29 • Pending Review • [Review]`.
- [ ] Restrict sensitive medical documents to authorized sub-screens.
- [ ] Do not expose parent phone numbers, addresses, or private family details on the Portal.

## 24. Actionable Pending Work Section
- [ ] Group pending tasks by supported categories (Attendance, Assessment, Leave Review, Teacher Tasks).
- [ ] If no tasks exist, show a clean empty state: `You're all caught up.`; avoid empty placeholder cards.

## 25. Data Source Rules & Dynamic Calculation in Production
- [ ] Derive all dashboard metrics and counters strictly from real ERP data models.
- [ ] Treat current HTML mock numbers (`31/32 Present`, `04 Papers`, `4 Periods`, `01 Pinned`) strictly as prototype visuals; replace with dynamic calculations in production.

## 26. Role-Based Visibility & Access Control
- [ ] Tailor content visibility to authenticated teacher role:
  - Class Teacher: Attendance, class attention feed, class schedule
  - Subject Teacher: Teaching schedule, subject assessments, subject tasks
  - Dual Role: Combined relevant responsibilities
- [ ] Enforce security and authorization on backend; hide unauthorized administrative actions.

## 27. Bottom Navigation Architecture
- [ ] Retain existing Teacher navigation: `Portal`, `Academics`, `Fees`, `Transport`, `More`.
- [ ] Set `Portal` as active first item.
- [ ] Do NOT add `My Class` to bottom navigation.

## 28. Navigation Boundaries
- [ ] Keep Portal summary-focused with shortcuts to detail screens:
  - Academics: detail workflows for timetable, marks, syllabus
  - Fees: teacher-relevant fee actions only (no accountant-level ledger tools)
  - Transport: accessible via its own tab; no transport KPIs on Portal
  - More: secondary settings and utilities

## 29. Loading, Error & Offline States
- [ ] Provide lightweight skeleton loaders for profile, summary cards, schedule, and attention feed.
- [ ] Implement section-level error handling with `Retry` so failure in one module (e.g., Attendance) does not crash unaffected sections (e.g., Schedule).
- [ ] Design for offline support: display cached data with freshness timestamp (`Offline • Last updated 10:32 AM`); never claim live sync while offline.

## 30. Dynamic Time Calculation & Countdowns
- [ ] Dynamically compute period states and countdowns (`25m left`, `In 1h 25m`) using device clock and timetable period times; never use static countdown labels.

## 31. Mobile UX, Performance & Accessibility
- [ ] Optimize for one-handed use, fast scanning, vertical scrolling, and comfortable touch targets on Android phones.
- [ ] Keep the screen lightweight: avoid heavy animations, large charts, or excessive network calls.
- [ ] Ensure accessibility compliance: readable font contrast, large touch targets, and non-color-dependent status indicators (text + icon + style).

## 32. Deep Testing Verification Checklist
- [ ] Test 1: Successful login routes to Teacher Portal.
- [ ] Test 2: Profile loads correct name and role.
- [ ] Test 3: Class Teacher assigned (class context displayed).
- [ ] Test 4: Subject Teacher only (no fake Class Teacher/Homeroom info).
- [ ] Test 5: Dual role teacher (both responsibilities represented).
- [ ] Test 6: Single class assigned (correct class displayed).
- [ ] Test 7: Multiple teaching assignments (cleanly displayed without collapsing into one).
- [ ] Test 8: Today's attendance exists (correct attendance summary).
- [ ] Test 9: Incomplete attendance (Not Marked not treated as Absent).
- [ ] Test 10: Attendance complete (Attendance Complete state).
- [ ] Test 11: Attendance data unavailable (no fake counts).
- [ ] Test 12: 4 classes today (4 timetable periods displayed).
- [ ] Test 13: No classes today ("No classes scheduled today").
- [ ] Test 14: Current class active ("Live Now" state).
- [ ] Test 15: Between classes ("Next Class" state).
- [ ] Test 16: All classes completed (no "Next" state).
- [ ] Test 17: Pending assessments exist (correct count displayed).
- [ ] Test 18: No pending assessments ("No pending assessments").
- [ ] Test 19: Important notice exists (notice displayed).
- [ ] Test 20: No notices (no fake notice counts).
- [ ] Test 21: Student attention item exists (actionable card displayed).
- [ ] Test 22: Attention item has medical details (diagnoses/Rx hidden on Portal).
- [ ] Test 23: Teacher lacks permission for action (action hidden).
- [ ] Test 24: Marks permission granted (Marks action available).
- [ ] Test 25: Timetable permission granted (Timetable action available).
- [ ] Test 26: Leave module unavailable (Leave action hidden).
- [ ] Test 27: Unauthorized to compose circulars (Compose Circular hidden).
- [ ] Test 28: Zero unread notifications (no red badge).
- [ ] Test 29: Unread notification exists (notification indicator visible).
- [ ] Test 30: Portal loading (skeleton state displayed).
- [ ] Test 31: Attendance section fails (attendance retry button shown).
- [ ] Test 32: Timetable section fails (schedule retry shown without breaking Portal).
- [ ] Test 33: Network unavailable (offline state displayed).
- [ ] Test 34: Slow network (loading state remains visible until data resolves).
- [ ] Test 35: Time changes across periods (current/next status updates dynamically).
- [ ] Test 36: Period concludes (status transitions to Completed).
- [ ] Test 37: Long teacher name (no header overflow).
- [ ] Test 38: Long subject name (no card overflow).
- [ ] Test 39: Many timetable periods (smooth vertical scrolling).
- [ ] Test 40: Empty backend (clean states, no fabricated data).

## 33. Removals from Current Design Checklist
- [ ] Remove:
  - Hardcoded attendance, assessment, class, and notice numbers
  - Hardcoded schedule progress and static countdown timers
  - Fake notification dispatch and synchronization claims
  - Medical diagnoses (`Seasonal Viral Pyrexia`) and prescription indicators (`Rx Attached`)
  - Fake parent communication fields and unnecessary employee/database IDs
  - Unauthorized `Compose Circular` action and unsupported teacher actions
  - Terminology `Marks Entry Terminal` and subtitle `Academic Records`

## 34. Final Design Goal Verification
- [ ] Verify 7-tier hierarchy: Header → Teacher Identity → Today's Summary → Quick Actions → Current/Next Class → Today's Schedule → Needs Attention → Notices.
- [ ] Confirm Teacher bottom navigation: `Portal`, `Academics`, `Fees`, `Transport`, `More` (no `My Class`).
- [ ] Verify fast daily command center usability, clear teacher context, actionable items, and mobile UX without emojis or visual redesign.

---

# Original Prompt

You are refining the existing **Teacher Portal / Teacher Home** screen for a modern School ERP Android application.

The uploaded/current Teacher Portal HTML is the reference implementation.

IMPORTANT:
The existing visual design is already approved.

DO NOT redesign the application's visual identity.

The goal is to improve:

- information hierarchy
- data representation
- teacher workflow
- role-aware information
- usability
- accuracy
- mobile experience
- edge-case handling

while preserving the existing visual language.

==================================================
SCREEN
==================================================

Screen:
Teacher Portal

Role:
Teacher / Class Teacher

Bottom Navigation:

Portal
Academics
Fees
Transport
More

The first bottom-navigation item is:

Portal

This screen is the teacher's operational home.

It should provide a quick overview of what the teacher needs to know or act on today.

It should NOT become a generic analytics dashboard.

==================================================
PRIMARY PURPOSE
==================================================

The Teacher Portal should answer these questions quickly:

1. Who am I?
2. What class/responsibilities do I have?
3. What do I need to do today?
4. What classes do I have today?
5. What attendance work is pending?
6. What academic work is pending?
7. Are there important school notices?
8. Is there anything requiring my attention?

The teacher should be able to open the Portal and understand their current work within a few seconds.

==================================================
VISUAL DESIGN
==================================================

Preserve the existing design exactly as the visual foundation.

Keep:

- warm cream background
- ivory surfaces
- cocoa/brown primary color
- Newsreader typography
- Manrope typography
- rounded cards
- existing spacing
- existing card treatment
- existing shadows
- existing border system
- Material Symbols icons
- existing header
- existing bottom navigation
- overall visual identity

Do NOT introduce:

- new color palette
- gradients
- glassmorphism
- neon colors
- excessive shadows
- oversized illustrations
- unnecessary animations
- unrelated dashboard design patterns

The UI already has a strong visual direction.

Improve the INFORMATION ARCHITECTURE, not the visual identity.

==================================================
ICON RULE
==================================================

DO NOT USE EMOJIS.

Do not use Unicode characters as icons.

Use the existing Material Symbols / Material Icons.

Keep:

- consistent icon family
- consistent icon sizing
- consistent stroke/fill treatment
- appropriate touch targets

==================================================
APPLICATION HEADER
==================================================

Keep the existing application header.

Current structure:

School Crest

One Numan Public School

2026–27

Academic Records

Right side:

Notifications
Profile

The school name and academic year should come from actual application/session configuration.

Do not hardcode them in production.

==================================================
HEADER SUBTITLE
==================================================

The current implementation uses:

Academic Records

For the Teacher Portal, this subtitle should represent the actual Teacher workspace.

Prefer:

Teacher Portal

or:

Teacher Workspace

Do not use an academic-record-specific subtitle on the general Portal screen.

==================================================
TEACHER PROFILE BANNER
==================================================

Keep the existing teacher identity banner.

Current concept:

Good Morning, Mrs. Desai

Senior Mathematics
Homeroom 5-A
AY 2026–27

This is useful, but must be data-driven.

Production example:

Good Morning, Anita

Mathematics
Class Teacher · 5-A
AY 2026–27

Only show Class Teacher context if the teacher actually has that assignment.

==================================================
TEACHER NAME
==================================================

Do not hardcode:

Mrs. Desai

The authenticated teacher's actual display name should be used.

If the school stores title:

Mr.
Mrs.
Ms.
Dr.

use it only if appropriate.

Otherwise:

Good Morning, Anita

is sufficient.

==================================================
TEACHER ROLE
==================================================

The Portal should represent the teacher's actual assignments.

Possible responsibilities:

Class Teacher
Subject Teacher
Both

Do NOT create a permanent fake label such as:

Teacher Type: Class Teacher

Instead, derive responsibility from actual assignments.

Example:

Mathematics · Class Teacher 5-A

or:

Mathematics · Subject Teacher

or:

Mathematics · Class Teacher 5-A + Subject Teacher

Only display what the backend actually supports.

==================================================
CLASS CONTEXT
==================================================

If the teacher is assigned as Class Teacher:

show the class clearly.

Example:

Class Teacher · 5-A

If the teacher is not a Class Teacher:

do not show:

Homeroom 5-A

just because a mockup contains it.

If the teacher has multiple relevant assignments:

represent them without making the header overly complicated.

==================================================
ACADEMIC YEAR
==================================================

Display the active academic session.

Example:

AY 2026–27

The value must come from the actual academic session.

Do not hardcode it in production.

==================================================
NOTIFICATION
==================================================

Keep the notification action.

If unread notifications exist:

show a small notification indicator.

If there are no unread notifications:

do not show a red badge.

Do not fabricate notification counts.

Tapping the icon should open the actual notification screen.

==================================================
TEACHER PORTAL CONTENT
==================================================

The main content should be organized around:

1. Today's Summary
2. Quick Actions
3. Today's Schedule
4. Pending Work / Attention
5. Important Notices

Do not overload the Portal with every feature in the ERP.

==================================================
SECTION 1 — TODAY'S SUMMARY
==================================================

The existing implementation contains a 2x2 KPI grid.

Current metrics:

Today's Attendance
Evaluations
Daily Classes
School Memo

The concept can remain, but the information must be relevant and data-driven.

Recommended metrics:

Today's Attendance
Today's Classes
Pending Assessments
Important Notices

Only show a metric if the underlying data exists.

==================================================
TODAY'S ATTENDANCE
==================================================

If the teacher is responsible for a class attendance workflow:

show:

Today's Attendance

31 / 32 Present

96.8%

or:

31 Present
1 Not Marked

depending on actual data.

The percentage must be calculated from real attendance data.

Do not hardcode:

31/32
96.8%

==================================================
ATTENDANCE STATE
==================================================

Important:

Not Marked is NOT the same as Absent.

Example:

32 students
31 Present
1 Not Marked

must not become:

31 Present
1 Absent

unless the actual attendance record says Absent.

==================================================
ATTENDANCE CARD ACTION
==================================================

If today's attendance is incomplete:

provide an action:

Complete Attendance

or:

Take Attendance

Tapping should open the actual Daily Roll Call workflow.

If attendance is already submitted:

show:

Attendance Complete

Do not show a misleading action.

==================================================
TODAY'S CLASSES
==================================================

Show the number of actual teaching periods for today.

Example:

4
Periods

3 Completed · 1 Upcoming

This must be calculated from the actual timetable.

Do not hardcode:

4 Periods.

==================================================
CURRENT / NEXT CLASS
==================================================

The Portal should provide quick awareness of:

Current Class

or:

Next Class

Example:

Now

Mathematics
Grade 5-A
11:05 – 11:50
Room 204

If there is no current class:

Next

Mathematics
Grade 6-A
01:15 – 02:00
Room 108

Only show Current when the current time actually falls within the period.

Only show Next when there is a real upcoming period.

==================================================
NO CLASSES TODAY
==================================================

If the teacher has no scheduled teaching period today:

show:

No classes scheduled today.

Do not display:

0 Periods

as the main message.

==================================================
PENDING ASSESSMENTS
==================================================

The current screen shows:

04 Papers
FA2 Math Roster

This can be retained only if actual assessment data exists.

Recommended:

Pending Assessments

4 Papers

FA2 Mathematics

The count must represent actual pending work.

Do not invent:

FA2 Math Roster

or any other assessment.

==================================================
ASSESSMENT DATA
==================================================

If the teacher has no pending assessments:

show:

No pending assessments

Do not display:

0 Papers

unless the dashboard design specifically requires it.

==================================================
SCHOOL NOTICES
==================================================

The current implementation shows:

01 Pinned
Dense Fog Advisory

This can be retained if actual school notices exist.

Recommended:

Important Notices

1 Important

Dense Fog Advisory

Only display notices relevant to the teacher.

Do not fabricate school-wide alerts.

==================================================
NOTICE PRIORITY
==================================================

If multiple notices exist:

prioritize based on actual system priority.

Potential categories:

Important
Urgent
General

Do not invent priority levels if the backend does not support them.

==================================================
QUICK ACTIONS
==================================================

The current implementation contains:

Roll Call Register
Marks Entry Terminal
Faculty Leave
Compose Circular

Keep the quick-action concept.

However, quick actions must be based on actual permissions and available modules.

Recommended:

Take Attendance
Marks / Assessments
Timetable
Leave

Only include actions that actually exist.

==================================================
ATTENDANCE QUICK ACTION
==================================================

If the teacher is authorized:

Take Attendance

should open the appropriate attendance screen.

For a Class Teacher:

Daily Roll Call Register

For other teacher workflows:

only show the attendance action if authorized.

==================================================
MARKS QUICK ACTION
==================================================

If marks entry is supported:

Marks / Assessments

should open the teacher's actual assessment workflow.

Do not use:

Marks Entry Terminal

if that terminology does not exist elsewhere in the application.

Use simple user-facing terminology.

==================================================
TIMETABLE QUICK ACTION
==================================================

The Portal may provide:

Timetable

This should open:

Faculty Timetable

This connects the Portal to the timetable screen already designed.

Do not duplicate the entire timetable inside Portal.

==================================================
FACULTY LEAVE
==================================================

If faculty leave functionality exists:

Leave

may be shown as a quick action.

If not implemented:

remove it.

Do not create a fake leave workflow.

==================================================
COMPOSE CIRCULAR
==================================================

Do NOT show:

Compose Circular

unless teachers actually have permission to create school circulars/notices.

A generic teacher should not automatically receive administrative communication privileges.

If the backend has role-based permission:

only show it for authorized teachers.

==================================================
QUICK ACTION COUNT
==================================================

Prefer 3–4 useful quick actions.

Do not create 8–12 small buttons.

The teacher Portal should remain focused.

==================================================
TODAY'S ACADEMIC SCHEDULE
==================================================

Keep the schedule section from the current implementation.

Title:

Today's Schedule

or:

Today's Classes

Show periods in chronological order.

Each period should display:

Period
Time
Subject
Class
Room

Example:

Period 1
08:30 – 09:15
Mathematics
Grade 5-A
Room 102

==================================================
SCHEDULE STATUS
==================================================

Possible states:

Completed
Current
Upcoming

Only use these when actual time data supports them.

Do not hardcode:

2 Completed
1 Live Now
2 Ahead

These must be calculated.

==================================================
CURRENT PERIOD
==================================================

If a class is currently happening:

clearly indicate:

Live Now

Example:

Period 4

11:05 – 11:50

Mathematics
Grade 5-A
Room 204

Live Now

If attendance is applicable:

Take Attendance

Only show the action when authorized.

==================================================
UPCOMING PERIOD
==================================================

Show the next teaching period when useful.

Example:

Next

Period 6

01:15 – 02:00

Mathematics
Grade 6-A
Lab B

Do not show multiple competing "next" classes.

There should be one clear next teaching period.

==================================================
COMPLETED PERIOD
==================================================

Completed periods can be visually subdued.

Example:

Period 1
08:30 – 09:15
Mathematics
Grade 5-A

Completed

Do not make completed classes more visually prominent than current/upcoming classes.

==================================================
BREAKS
==================================================

If actual timetable data includes breaks:

show them subtly.

Example:

Morning Break
20 min

Do not create fake break periods.

==================================================
STUDENT ATTENTION
==================================================

The current screen contains:

Student Attention & Care Feed

This is potentially useful for a Class Teacher.

However, it should ONLY show actionable information that the teacher is actually authorized to see.

Examples:

- pending leave request
- attendance issue
- academic follow-up
- teacher task requiring attention

Do not automatically display sensitive personal information.

==================================================
MEDICAL INFORMATION
==================================================

The current prototype displays:

Seasonal Viral Pyrexia
Rx Attached

Do NOT display detailed medical information on the Portal dashboard.

Instead, if a leave request genuinely requires teacher review:

show:

Diya Sharma
Leave Application
Oct 28–29
Pending Review

Then allow:

Review

Detailed medical documents should only appear inside an authorized detail workflow.

==================================================
PARENT INFORMATION
==================================================

Do not display parent phone numbers, addresses, or other personal information on the Portal.

If a communication workflow exists:

open it through the appropriate authorized action.

==================================================
STUDENT ATTENTION PRIORITY
==================================================

Only show items that require action or awareness.

Do not turn the Portal into a student database.

For example:

Good:

2 items require attention

Bad:

32 students listed on the dashboard.

==================================================
PENDING WORK
==================================================

A teacher should be able to see actual pending work.

Possible categories:

Attendance
Assessment
Leave Review
Other Teacher Tasks

Only display categories supported by the backend.

==================================================
EMPTY PENDING WORK
==================================================

If there are no pending items:

show:

You're all caught up.

Do not show fake cards.

==================================================
PORTAL DATA RULE
==================================================

Every number and status must be derived from actual data.

Examples:

Attendance
→ actual attendance records

Today's Classes
→ actual timetable records

Assessments
→ actual assessment records

Notices
→ actual notice records

Student Attention
→ actual authorized workflow records

Never invent dashboard values.

==================================================
IMPORTANT PROTOTYPE RULE
==================================================

The current HTML contains realistic-looking static data such as:

31/32 Present
04 Papers
4 Periods
2 Completed
1 Live Now
2 Ahead
01 Pinned

These values are acceptable as visual mock data only.

However, the production UI must calculate these values from actual backend data.

Do not preserve hardcoded counters in production.

==================================================
ROLE-BASED VISIBILITY
==================================================

The Portal should adapt to the teacher's permissions.

Example:

Class Teacher:

Attendance
Class-related attention
Class schedule

Subject Teacher:

Teaching schedule
Assessments
Subject-related work

Teacher who is both:

combined relevant information

Do not create separate applications.

Use one Teacher Portal with permission-aware content.

==================================================
ACCESS CONTROL
==================================================

The frontend must not be the only security layer.

The backend must enforce permissions.

The UI should only expose actions the authenticated teacher is authorized to perform.

Do not show administrative actions to ordinary teachers.

==================================================
BOTTOM NAVIGATION
==================================================

Keep the actual current Teacher navigation:

Portal
Academics
Fees
Transport
More

Portal must be the active item.

Do NOT introduce:

My Class

unless it is an actual feature in the project.

Do not add new bottom-navigation destinations simply to fill space.

==================================================
ACADEMICS
==================================================

Portal should link into Academics where appropriate.

Examples:

Timetable
Marks
Assessments

Do not duplicate all academic functionality on Portal.

Portal provides shortcuts.

Academics provides the detailed workflows.

==================================================
FEES
==================================================

Do not turn Teacher Portal into a fee-management dashboard.

If Fees exists in the Teacher navigation:

only show teacher-relevant fee information or the appropriate fee section.

Do not show accountant-level information.

==================================================
TRANSPORT
==================================================

Do not add transport KPIs to the Portal unless they are genuinely relevant to the teacher.

Transport remains accessible from its own navigation destination.

==================================================
MORE
==================================================

Secondary features should remain under More.

Do not duplicate every More feature on Portal.

==================================================
REFRESH
==================================================

If the application supports refresh:

allow the teacher to refresh Portal data.

Do not make the user manually refresh every card.

==================================================
LOADING STATE
==================================================

On initial loading:

show lightweight skeletons for:

- teacher profile
- summary cards
- schedule
- attention items

Do not immediately display:

No classes today

while data is still loading.

Loading
is different from
Empty.

==================================================
ERROR STATE
==================================================

If a section fails:

do not make the entire Portal unusable if other sections are available.

For example:

Attendance failed to load.

Retry

while:

Today's Schedule

still works.

Use section-level error handling where practical.

==================================================
OFFLINE STATE
==================================================

The app may later support offline data through local storage.

Design the Portal so that offline state can be represented.

Possible:

Offline
Last updated 10:32 AM

Only show this if actual offline/local-cache functionality exists.

Do not claim:

Synced

when synchronization has not happened.

==================================================
CURRENT TIME
==================================================

Current/Next class status must be calculated from:

- current local date
- current local time
- timetable period start/end

Do not hardcode:

Live Now
25m left
In 1h 25m

==================================================
COUNTDOWN
==================================================

If the UI shows:

25m left

or:

In 1h 25m

it must be dynamically calculated.

Do not use a static countdown.

==================================================
PORTAL PRIORITY
==================================================

The most important content should appear first.

Recommended hierarchy:

1. Teacher Identity
2. Today's Attendance
3. Current / Next Class
4. Quick Actions
5. Today's Schedule
6. Pending Work / Attention
7. Notices

Do not give equal visual weight to every piece of information.

==================================================
RECOMMENDED FINAL SCREEN
==================================================

HEADER

One Numan Public School
2026–27
Teacher Portal

Notifications
Profile

↓

TEACHER IDENTITY

Good Morning, Anita

Mathematics
Class Teacher · 5-A
AY 2026–27

↓

TODAY'S SUMMARY

Today's Attendance
31 / 32 Present

Today's Classes
4 Periods

Pending Assessments
2

Important Notices
1

↓

QUICK ACTIONS

Take Attendance
Marks / Assessments
Timetable
Leave

↓

CURRENT / NEXT CLASS

Now
Mathematics
Grade 5-A
11:05 – 11:50
Room 204

or:

Next
Mathematics
Grade 6-A
01:15 – 02:00
Room 108

↓

TODAY'S SCHEDULE

Chronological teaching periods

↓

NEEDS ATTENTION

Only actual actionable items

↓

IMPORTANT NOTICES

Only relevant actual notices

==================================================
MOBILE UX
==================================================

This is an Android teacher application.

Optimize for:

- one-handed use
- fast scanning
- vertical scrolling
- large touch targets
- readable text
- minimal typing
- quick access to attendance
- quick access to timetable

Do not create desktop-style tables.

Do not make the dashboard excessively dense.

==================================================
PERFORMANCE
==================================================

Keep the Portal lightweight.

Avoid unnecessary:

- animations
- charts
- API calls
- large images
- complex visualizations

The Portal should open quickly.

==================================================
ACCESSIBILITY
==================================================

Important states must not depend only on color.

For example:

Current
Upcoming
Completed

should have:

- text label
- appropriate icon
- visual distinction

Touch targets must be sufficiently large for mobile use.

==================================================
DEEP TESTING
==================================================

TEST 1
Teacher logs in successfully.

Expected:
Teacher Portal opens.

TEST 2
Teacher profile loads.

Expected:
Correct teacher name and role.

TEST 3
Teacher is Class Teacher.

Expected:
Class Teacher context appears.

TEST 4
Teacher is Subject Teacher only.

Expected:
No fake Homeroom/Class Teacher information.

TEST 5
Teacher is both Class Teacher and Subject Teacher.

Expected:
Both responsibilities represented appropriately.

TEST 6
Teacher has one class.

Expected:
Correct class displayed.

TEST 7
Teacher has multiple teaching assignments.

Expected:
Portal does not incorrectly collapse them into one class.

TEST 8
Today's attendance exists.

Expected:
Correct attendance summary.

TEST 9
Attendance incomplete.

Expected:
Not Marked is not treated as Absent.

TEST 10
Attendance complete.

Expected:
Attendance Complete state.

TEST 11
Attendance unavailable.

Expected:
No fake attendance count.

TEST 12
Teacher has four classes today.

Expected:
Four actual timetable periods.

TEST 13
Teacher has no classes today.

Expected:
No classes scheduled today.

TEST 14
Current class is active.

Expected:
Live Now.

TEST 15
No current class but next class exists.

Expected:
Next Class.

TEST 16
All classes completed.

Expected:
No upcoming class shown.

TEST 17
Teacher has pending assessments.

Expected:
Correct count.

TEST 18
No pending assessments.

Expected:
No pending assessments.

TEST 19
Important school notice exists.

Expected:
Notice displayed.

TEST 20
No notices.

Expected:
No fake notice count.

TEST 21
Student attention item exists.

Expected:
Actionable item displayed.

TEST 22
Student attention item contains medical details.

Expected:
Medical details not exposed on main Portal.

TEST 23
Teacher lacks permission for an action.

Expected:
Action is hidden or unavailable.

TEST 24
Teacher has permission for Marks.

Expected:
Marks action available.

TEST 25
Teacher has permission for Timetable.

Expected:
Timetable action available.

TEST 26
Teacher has no leave module.

Expected:
Leave action not displayed.

TEST 27
Teacher is not authorized to compose circulars.

Expected:
Compose Circular not displayed.

TEST 28
Notification count is zero.

Expected:
No fake notification badge.

TEST 29
Notification exists.

Expected:
Notification indicator.

TEST 30
Portal loading.

Expected:
Skeleton state.

TEST 31
Attendance section fails.

Expected:
Attendance error with retry.

TEST 32
Timetable section fails.

Expected:
Schedule error without destroying the entire Portal.

TEST 33
Network unavailable.

Expected:
Correct offline/unavailable state.

TEST 34
Slow network.

Expected:
Loading state remains visible until data resolves.

TEST 35
Current time changes.

Expected:
Current/Next status updates correctly.

TEST 36
Period ends.

Expected:
Current period becomes Completed and next period becomes Current/Upcoming as appropriate.

TEST 37
Long teacher name.

Expected:
No header overflow.

TEST 38
Long subject name.

Expected:
No card overflow.

TEST 39
Many timetable periods.

Expected:
Smooth scrolling.

TEST 40
No backend data.

Expected:
No fabricated values.

==================================================
REMOVE / AVOID FROM CURRENT DESIGN
==================================================

Unless actually supported, remove or replace:

- hardcoded attendance numbers
- hardcoded assessment counts
- hardcoded class counts
- hardcoded schedule progress
- hardcoded notice counts
- fake notification dispatch
- medical diagnosis on dashboard
- prescription indicators
- fake parent communication
- unnecessary employee IDs
- internal database IDs
- synchronization terminology
- technical backend messages
- unauthorized Compose Circular action
- unsupported teacher actions
- fake countdown timers

==================================================
FINAL DESIGN GOAL
==================================================

The Teacher Portal should feel like a professional school teacher's daily command center.

When the teacher opens the first bottom-navigation button, they should immediately understand:

WHO I AM
+
WHAT I HAVE TODAY
+
WHAT I NEED TO DO
+
WHAT NEEDS MY ATTENTION

The Portal should provide quick access to the detailed workflows without duplicating those workflows.

Keep the existing visual design.

Keep:

Portal
Academics
Fees
Transport
More

as the Teacher bottom navigation.

Do NOT add My Class.

Do NOT invent unsupported features.

Do NOT invent data.

Do NOT invent permissions.

Do NOT expose sensitive student information.

Do NOT use emojis.

The priority is:

CLEAR TEACHER CONTEXT
+
TODAY'S WORK
+
CURRENT/NEXT CLASS
+
QUICK ACTIONS
+
ACTIONABLE ATTENTION
+
ACCURATE DATA
+
CLEAN MOBILE UX
