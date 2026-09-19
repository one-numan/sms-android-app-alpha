# Action Items: Parent – Attendance Screen Design & Implementation

## 1. Scope & Design System Preservation
- [ ] Design and implement the "Parent – Attendance" screen for the existing School ERP mobile application.
- [ ] Preserve the existing approved visual design established by Parent Home and Academics:
  - Color palette, typography, font family, and font hierarchy.
  - Card style, border radius, spacing, header style, navigation style, and button style.
  - Material Symbols / Material Icons and overall visual language.
- [ ] Do NOT redesign the overall product.
- [ ] Focus strictly on making attendance clear, useful, trustworthy, easy to understand, easy to navigate, and mobile-friendly.

## 2. Screen Purpose & Role Distinction (Parent Viewing vs. Teacher Management)
- [ ] Frame the screen strictly as a parent viewing interface answering:
  - Which child am I viewing?
  - What is my child's attendance for the selected period?
  - How many days were present, absent, late, or on leave?
  - What happened on a specific date?
  - Historical attendance records.
- [ ] Exclude all teacher attendance management controls (Mark Attendance, Submit Attendance, Edit Attendance, Mark All Present, and teacher roster tools).

## 3. Multi-Child Support & Complete Attendance Isolation
- [ ] Provide child selector consistent with Parent Home and Academics (e.g., `Diya Sharma • Grade 5-A` vs `Aarav Sharma • Grade 2-B`).
- [ ] Ensure switching children updates ALL attendance data simultaneously:
  - Overall attendance percentage
  - Present, absent, late, and leave counts
  - Monthly calendar status markers
  - Selected date detail
  - Attendance history log
  - Subject-wise attendance (if supported)
- [ ] NEVER mix attendance records between children.
- [ ] Show a compact child identity block if the parent has only one child.

## 4. Header & Exclusion of Technical/Admission Identifiers
- [ ] Maintain standard Parent header: Title `Attendance`, optional session `2026–27`, notification bell, and profile avatar.
- [ ] REMOVE admission numbers (e.g., `ADM-2024-0412`) from parent-facing view.
- [ ] Omit technical system metadata (database IDs, API status, sync timestamps, internal identifiers).

## 5. Child Context Block
- [ ] Display selected child context below the header (e.g., `Diya Sharma • Grade 5-A • Academic Year 2026–27`).
- [ ] Keep the block compact and clearly visible so the active child is unmistakable.

## 6. Attendance Overview Card & Semantic State Distinction
- [ ] Feature `Attendance Overview` as the primary card displaying calculated percentage, recorded days count, and counts breakdown (e.g., `80% Attendance • 25 recorded days • 20 Present · 3 Absent · 2 Late`).
- [ ] Strictly distinguish `Not Marked` from `Absent`; never classify unrecorded attendance as absent.
- [ ] Only display states supported by the backend model (Present, Absent, Late, On Leave, Not Marked).

## 7. Dynamic Attendance Percentage Calculation
- [ ] Calculate percentage dynamically from actual records (`Present Days / Recorded Days`).
- [ ] If no records exist for the period, display `No attendance records yet` (avoid artificial 0%).
- [ ] Never hardcode or fabricate percentages.

## 8. Period & Academic Year Selection
- [ ] Provide compact period filter: `[ This Month ▼ ]`, `[ This Term ▼ ]`, or `[ This Academic Year ▼ ]`.
- [ ] If multiple academic years are available, provide compact session selector (`2026–27 ▼`) that refreshes all data when changed.
- [ ] Avoid complicated date controls at the top.

## 9. Summary Breakdown Layout
- [ ] Display a compact count breakdown (Present, Absent, Late, Leave) below the main percentage.
- [ ] Keep layout visually clean; avoid turning every value into a large KPI card.

## 10. Monthly Interactive Calendar (7-Column Layout & Visual Markers)
- [ ] Render monthly calendar with standard 7-column layout (M T W T F S S).
- [ ] Visually distinguish attendance states (Present, Absent, Late, Leave, Holiday, Not Marked).
- [ ] Do NOT rely on color alone; include distinct visual markers (dots, symbols, icons) alongside color.
- [ ] Keep calendar clean and accessible, avoiding overly decorative clutter.

## 11. Date Detail View
- [ ] Tapping a calendar date updates the `Selected Date` panel below:
  - Date (e.g., `25 October 2026`)
  - Status (e.g., `Present`, `Absent`, `Late`, `Leave approved`)
  - Check-in time (e.g., `Check-in: 07:48 AM`) only if real check-in data exists
  - Authorized absence reason / leave details only if backed by real data (never invent reasons)

## 12. Today's Attendance State (`Not Marked` vs. `Absent`)
- [ ] If today has an attendance record, display `TODAY • Present • 07:48 AM Check-in recorded`.
- [ ] If today has not been marked yet, display `TODAY • Attendance not marked yet`.
- [ ] NEVER display `Absent` simply because an attendance record is missing today.

## 13. Chronological Attendance History & Pagination
- [ ] Provide a compact chronological history log below the calendar (e.g., Date, Status, Check-in Time).
- [ ] Include `[ View More ]` pagination or lazy loading; avoid loading hundreds of historical records at once.

## 14. History Filter Chips & Horizontal Scrolling
- [ ] Provide simple history filter chips (`All`, `Present`, `Absent`, `Late`, `Leave`) matching supported backend states.
- [ ] Make the filter chip row horizontally scrollable without causing page-level overflow.

## 15. Subject-Wise Attendance (Secondary & Strictly Data-Driven)
- [ ] Position `Subject Attendance` as a secondary section below the main history log.
- [ ] Display subject attendance only if the backend genuinely tracks subject-specific attendance (e.g., `Mathematics • 24 / 25 sessions • 96%`).
- [ ] Do NOT show this section if the school tracks only daily class attendance.
- [ ] NEVER infer subject attendance from timetable records.

## 16. Timetable Separation Guardrails
- [ ] Completely remove full timetable schedules (Period 1, Period 2, Period 3...) from Parent Attendance.
- [ ] Delegate class scheduling to the dedicated Timetable screen.

## 17. Exclusion of Teacher Workflow Details
- [ ] Do NOT display teacher workflow details (e.g., remove `Marked by Anita Desai`) on attendance rows.
- [ ] Focus strictly on Date, Status, Time, and authorized attendance details.

## 18. Exclusion of Unverified Regulatory Claims
- [ ] Do NOT hardcode regulatory claims (e.g., remove `CBSE Minimum: 75%`, `CBSE regulations require...`).
- [ ] Only show a link to `School Attendance Policy` if officially provided and configured by the school.

## 19. Configured Attendance Threshold Alerts
- [ ] Display an `Attendance Notice` only when an attendance threshold is explicitly configured by the school/backend and breached.
- [ ] Do NOT invent 75% thresholds or label children "at risk" based on arbitrary frontend rules.

## 20. Calendar Month Navigation
- [ ] Provide simple month navigation (e.g., `< October 2026 >`).
- [ ] Restrict navigation to periods with available attendance records.

## 21. Attendance State Visual Treatments
- [ ] Apply semantic treatments with visible text labels:
  - Present: positive / green
  - Absent: danger / red
  - Late: warning / amber
  - Leave: informational / blue
  - Not Marked / Holiday: neutral
- [ ] Never communicate state through color alone.

## 22. Privacy Protection & Individual Child Boundaries
- [ ] Restrict visible data strictly to the selected child's authorized records.
- [ ] Exclude other students, class attendance averages, teacher private notes, medical diagnoses, and internal IDs.

## 23. Exclusion of Peer/Class Comparisons & Rankings
- [ ] Do NOT display class average attendance, school averages, attendance rankings, or comparison metrics.

## 24. Mobile-First Responsive Design (320px–480px+)
- [ ] Support screen widths: 320px, 360px, 375px, 390px, 412px, 430px, 480px+.
- [ ] Enforce single-column layout on 320–360px; avoid desktop tables or multi-column grids.
- [ ] Ensure the overall PAGE never horizontally scrolls (only filter chips may scroll).
- [ ] Ensure touch targets meet minimum 44px where practical.

## 25. Calendar Optimization on Small Screens
- [ ] Ensure 7-column monthly calendar fits comfortably within 320px.
- [ ] Prioritize tapability and readability over extreme compactness.

## 26. Loading, Error & Future Offline States
- [ ] Use skeleton loaders matching overview, calendar, and history rows during data fetching.
- [ ] On failure: show `Unable to load attendance information. [ Retry ]` without exposing technical exceptions or stack traces.
- [ ] If history fails but summary succeeds, keep summary visible.
- [ ] Architect UI for future cached offline records without falsely displaying `Synced` badges.

## 27. Performance & Lazy-Loading Standards
- [ ] Use performant list rendering and load calendar data strictly for the active month.

## 28. Bottom Navigation Integration
- [ ] Use established Parent bottom navigation: `Portal | Academics | Attendance | Fees | More`.
- [ ] Ensure `Attendance` is visibly active.
- [ ] Do NOT add Timetable, Results, or Transport as bottom-nav tabs.

## 29. Data Source & Modeling Integrity
- [ ] Bind UI strictly to real models: Parent → Student/Child → StudentClass → Attendance records.
- [ ] Do not create fake attendance, fake dates, or fake check-in times.

## 30. Final Product Principles & Quality Verification Checklist
- [ ] Verify screen is calm, trustworthy, and child-specific without teacher management controls.
- [ ] Verify multi-child switching refreshes all attendance modules cleanly.
- [ ] Verify `Not Marked` is distinct from `Absent` across all sections.
- [ ] Verify monthly calendar and date detail interaction works smoothly.
- [ ] Verify full timetable and regulatory claims are removed.
- [ ] Verify responsive layout across 320px–480px+ with zero horizontal page overflow.
- [ ] Confirm no emojis are used and existing icon system is preserved.

---

# Original Prompt

Design and implement the “Parent – Attendance” screen for the existing School ERP mobile application.

IMPORTANT:
This is an EXISTING School ERP application.

The Parent Home and Parent Academics screens already establish the visual design system.

DO NOT redesign the overall product.

Preserve the existing:
- color palette
- typography
- font family
- font hierarchy
- card style
- border radius
- spacing
- header style
- navigation style
- button style
- Material Symbols / Material Icons
- overall visual language

The goal is to make Parent Attendance:
- extremely clear
- useful
- trustworthy
- easy to understand
- easy to navigate
- mobile friendly

Do NOT make this a teacher attendance-management screen.

==================================================
1. PRIMARY PURPOSE
==================================================

The Parent Attendance screen should answer:

1. Which child am I viewing?
2. What is my child's attendance for the current period?
3. How many days were present?
4. How many days were absent?
5. Were there any late/leave records if supported?
6. What happened on a particular date?
7. Can I view attendance history easily?

The parent is VIEWING attendance.

The parent is NOT marking attendance.

Do not include:
- Mark Attendance
- Submit Attendance
- Edit Attendance
- Mark All Present
- Teacher controls
- Attendance management controls

==================================================
2. MULTI-CHILD SUPPORT
==================================================

A parent may have multiple children.

The selected child must remain consistent with Parent Home and Parent Academics.

Example:

[ Diya Sharma ]
Grade 5-A

[ Aarav Sharma ]
Grade 2-B

When the parent switches children, ALL attendance information must update.

This includes:
- attendance percentage
- present count
- absent count
- late count
- leave count
- calendar
- attendance history
- subject-wise attendance if supported

NEVER mix attendance records between children.

If the parent has only one child, show a compact child identity block.

==================================================
3. HEADER
==================================================

Use the existing Parent application header.

Title:

Attendance

Optional:

2026–27

Keep:
- notification
- profile
- existing header controls

Do not show:
- admission ID
- database ID
- internal student ID
- API information
- synchronization timestamps
- technical system information

The existing screen currently exposes an admission identifier such as ADM-2024-0412. REMOVE this from the parent-facing UI unless there is a specific legitimate parent-facing reason for displaying it.

==================================================
4. CHILD CONTEXT
==================================================

Immediately below the header:

Diya Sharma
Grade 5-A

Academic Year
2026–27

The selected child must be obvious.

Do not make the parent guess whose attendance they are viewing.

==================================================
5. ATTENDANCE OVERVIEW
==================================================

This should be the primary card.

Title:

Attendance Overview

Example:

80%

Attendance

25 recorded days

20 Present
3 Absent
2 Late

Only show states supported by the actual attendance model.

IMPORTANT:

Do NOT automatically assume:

Missing record = Absent.

Attendance states must remain distinct.

Possible states:

Present
Absent
Late
On Leave
Not Marked

Only display states that actually exist in the backend.

==================================================
6. ATTENDANCE PERCENTAGE
==================================================

Calculate the percentage from actual attendance records.

Example:

Present Days
20

Recorded Days
25

Attendance
80%

Do NOT hard-code or fake percentages.

If there are no valid recorded days:

Attendance

No attendance records yet.

Do not show:

0%

unless 0% is mathematically and semantically valid according to the application's attendance rules.

==================================================
7. PERIOD SELECTOR
==================================================

The parent should be able to understand attendance for a meaningful period.

Provide a simple selector:

This Month
This Term
This Academic Year

Example:

[ This Month ▼ ]

or:

This Academic Year

If the backend supports specific academic terms, allow:

Term 1
Term 2
Term 3

Do not create filters that the backend cannot support.

Avoid complicated date controls at the top.

==================================================
8. SUMMARY BREAKDOWN
==================================================

Below the main percentage, show a compact breakdown:

Present
20

Absent
3

Late
2

Leave
0

Only include applicable states.

Keep this visually simple.

Do not turn every value into a large KPI card.

The parent should understand the summary immediately.

==================================================
9. MONTHLY CALENDAR
==================================================

The calendar is one of the most useful parts of this screen.

Provide:

October 2026

<              >

M  T  W  T  F  S  S

1  2  3  4  5  6  7
8  9 10 11 12 13 14
15 16 17 18 19 20 21
22 23 24 25 26 27 28
29 30 31

Use the existing design language to visually distinguish attendance states.

For example:

Present
Absent
Late
Leave
Holiday
Not Marked

IMPORTANT:

Do not rely on color alone.

Each state should have:
- color
- clear visual indicator
- accessible label

For example, use a small dot/marker or state symbol inside the date.

Do not make the calendar overly decorative.

==================================================
10. DATE DETAIL
==================================================

When the parent taps a date, show the attendance record for that day.

Example:

25 October 2026

Present

Check-in:
07:48 AM

If check-in data actually exists.

For absent:

25 October 2026

Absent

If a reason or leave information is available and authorized:

Leave approved

Only show additional details when actual backend data supports them.

Do not invent absence reasons.

==================================================
11. TODAY
==================================================

If today has an attendance record, clearly identify it.

Example:

TODAY

Present

07:48 AM
Check-in recorded

If today has not been marked:

TODAY

Attendance not marked yet

IMPORTANT:

Do NOT show:

Absent

just because there is currently no attendance record.

This distinction is critical.

==================================================
12. ATTENDANCE HISTORY
==================================================

Provide a chronological history below the calendar.

Title:

Attendance History

Example:

25 Oct
Present
07:48 AM

24 Oct
Present
07:52 AM

23 Oct
Late
08:18 AM

22 Oct
Absent

Keep each row compact.

The parent should be able to scan many days quickly.

Provide:

[ View More ]

if there are many records.

Do not load hundreds of records into the initial screen.

==================================================
13. HISTORY FILTER
==================================================

Provide simple filters if useful:

All
Present
Absent
Late
Leave

Only show filters for states supported by the backend.

On narrow screens, the filter row may horizontally scroll.

The PAGE itself must never horizontally scroll.

==================================================
14. SUBJECT-WISE ATTENDANCE
==================================================

Subject-wise attendance can be useful, but it should be SECONDARY.

Only show it if the backend genuinely tracks attendance by subject.

Example:

Subject Attendance

Mathematics
24 / 25 sessions
96%

English
23 / 24 sessions
95.8%

Science
22 / 24 sessions
91.7%

Keep this section below the main attendance history.

Do not make subject-wise attendance the primary attendance view.

If the system tracks only daily class attendance and does NOT track subject attendance:

DO NOT SHOW THIS SECTION.

Do not infer subject attendance from timetable data.

==================================================
15. TIMETABLE SEPARATION
==================================================

The existing Attendance prototype contains a complete daily timetable.

DO NOT duplicate the full timetable inside Parent Attendance.

Attendance should focus on:

attendance records.

If useful, a selected date may show a small contextual detail such as:

Attendance recorded

but the full:

Period 1
Period 2
Period 3
Break
Period 4

schedule belongs to the Timetable experience.

Do not turn Attendance into a timetable screen.

==================================================
16. TEACHER INFORMATION
==================================================

Do NOT display teacher names on every attendance row by default.

For example, avoid:

Marked by Anita Desai

unless the parent has a genuine need to know who recorded the attendance and the backend explicitly supports this parent-facing information.

The parent primarily needs:

Date
Status
Time
Relevant attendance detail

Do not expose internal staff workflow information unnecessarily.

==================================================
17. ATTENDANCE RULES / REGULATIONS
==================================================

Do NOT add generic regulatory claims such as:

“CBSE Minimum: 75%”

or:

“CBSE regulations require...”

unless the school application has an official, current, verified policy source and intentionally provides this information to parents.

Do not hard-code regulatory/legal requirements into the UI.

If the school has its own attendance policy and the backend provides it, a simple:

School Attendance Policy

link may be shown.

Otherwise, omit this section.

Do not make the attendance screen a policy page.

==================================================
18. ATTENDANCE ALERT
==================================================

If the system supports meaningful parent alerts, show a small section:

Attendance Notice

Example:

Your child's attendance has fallen below the school's configured attendance threshold.

[ View Attendance ]

IMPORTANT:

Do not create a threshold such as 75% unless that threshold is actually configured by the school/backend.

Do not label a child “at risk” based on an arbitrary frontend rule.

Do not make medical or behavioral interpretations.

==================================================
19. MONTH NAVIGATION
==================================================

Allow the parent to move between months:

< September
October
November >

or:

<        October 2026        >

Keep it simple.

The parent should be able to review previous months without opening a complicated date picker.

Only allow periods for which the application can retrieve attendance data.

==================================================
20. ACADEMIC YEAR FILTER
==================================================

If multiple academic years are available, provide a compact selector.

Example:

Academic Year
2026–27 ▼

Do not mix attendance records across academic years.

When the academic year changes, refresh:

- summary
- calendar
- history
- subject attendance

==================================================
21. ATTENDANCE STATES
==================================================

Use consistent semantic states.

Recommended:

Present
→ positive/green treatment

Absent
→ danger treatment

Late
→ warning treatment

Leave
→ informational treatment

Not Marked
→ neutral treatment

Holiday
→ neutral/informational treatment

Do not use color alone.

Text labels must always remain visible.

==================================================
22. PRIVACY
==================================================

Parent Attendance must only show the selected child's attendance.

Never show:
- other students
- class attendance statistics
- other children's attendance
- teacher private notes
- internal administrative comments
- medical diagnosis
- private guardian communication
- internal attendance IDs

unless explicitly supported and authorized.

==================================================
23. NO CLASS COMPARISON
==================================================

Do NOT show:

Class average attendance
School average
Rank
Top attendance
Better than classmates

unless explicitly supported by the product requirements.

The parent's screen should focus on their child.

==================================================
24. MOBILE-FIRST DESIGN
==================================================

The screen must work correctly on:

320px
360px
375px
390px
412px
430px
480px+

At 320–360px:

Use a single-column layout.

The attendance summary must remain readable.

The calendar must remain usable.

History rows must not overflow.

Subject rows must wrap naturally.

Do NOT use:
- wide tables
- desktop attendance matrices
- large multi-column dashboards

The page must never have horizontal overflow.

Only intentional controls such as filter chips may horizontally scroll.

==================================================
25. CALENDAR ON SMALL SCREENS
==================================================

The calendar must fit comfortably within 320px.

Use:

7 equal columns.

Dates should have adequate touch targets.

Do not make the calendar so small that dates become difficult to tap.

Minimum practical touch target:

44px where possible.

If 44px cells make the calendar too tall, prioritize tapability and readability over compactness.

==================================================
26. LOADING STATE
==================================================

Use skeleton loading.

Do not show fake:

- percentage
- present count
- absent count
- dates
- history
- subject statistics

while loading.

==================================================
27. ERROR STATE
==================================================

If attendance cannot be loaded:

Unable to load attendance information.

[ Retry ]

Do not show:
- API errors
- database errors
- stack traces
- technical messages

If only history fails but the summary is available, keep the summary visible.

==================================================
28. OFFLINE SUPPORT
==================================================

The application will support offline operation later.

Design the screen so cached attendance records can eventually be displayed.

If cached data is being shown, it should be possible to distinguish it from newly synchronized information.

Do not falsely display:

Synced
Updated now

unless that actually happened.

A future implementation may show:

Last updated

when appropriate.

==================================================
29. PERFORMANCE
==================================================

Attendance may contain hundreds of historical records.

Use a performant scrolling list.

Do not render the entire attendance history unnecessarily.

Use pagination or lazy loading when the actual implementation requires it.

The calendar should load only the necessary month's data.

==================================================
30. BOTTOM NAVIGATION
==================================================

Use exactly:

Portal
Academics
Attendance
Fees
More

Attendance must be the active tab.

Do NOT change the Parent bottom navigation.

Do NOT add:

Timetable
Results
Transport

as bottom navigation items.

Those belong in the appropriate parent sections.

==================================================
31. RELATION TO OTHER PARENT SCREENS
==================================================

Parent Home:

Shows a quick attendance summary.

Parent Academics:

Shows academic records/results.

Parent Attendance:

Shows COMPLETE attendance information.

Parent Fees:

Shows fees/payment information.

Parent More:

Shows secondary services.

Do not duplicate complete attendance information on Home or Academics.

==================================================
32. IDEAL PARENT FLOW
==================================================

Parent opens:

Attendance

↓

Selected child:

Diya Sharma
Grade 5-A

↓

Sees:

Attendance
80%

20 Present
3 Absent
2 Late

↓

Selects:

October 2026

↓

Sees monthly calendar.

↓

Taps:

23 Oct

↓

Sees:

23 October

Late

08:18 AM

↓

Scrolls:

Attendance History

↓

Can optionally open:

Subject Attendance

This should take very few interactions.

==================================================
33. RECOMMENDED FINAL SCREEN
==================================================

HEADER

ONPS                         Bell  Profile

Attendance
2026–27

CHILD

Diya Sharma
Grade 5-A

[ This Academic Year ▼ ]

ATTENDANCE OVERVIEW

┌───────────────────────────────┐
│                               │
│             80%               │
│         Attendance            │
│                               │
│ 20 Present · 3 Absent · 2 Late│
│                               │
│ 25 recorded days              │
└───────────────────────────────┘

[ This Month ▼ ]

OCTOBER 2026

<                         >

 M   T   W   T   F   S   S

 1   2   3   4   5   6   7
 8   9  10  11  12  13  14
15  16  17  18  19  20  21
22  23  24  25  26  27  28
29  30  31

Present • Absent • Late • Leave

SELECTED DATE

25 October 2026

Present
07:48 AM · Check-in recorded

ATTENDANCE HISTORY

25 Oct     Present     07:48 AM
24 Oct     Present     07:52 AM
23 Oct     Late        08:18 AM
22 Oct     Absent
21 Oct     Present     07:44 AM

[ View More ]

SUBJECT ATTENDANCE

Mathematics       24 / 25       96%
English           23 / 24       95.8%
Science           22 / 24       91.7%

BOTTOM NAVIGATION

Portal | Academics | Attendance | Fees | More

==================================================
34. IMPORTANT PRODUCT PRINCIPLE
==================================================

This is a PARENT attendance screen.

Do not design it like:

- a teacher attendance register
- a school administrator report
- a timetable
- an attendance management console
- an analytics dashboard

The parent should be able to understand:

“How often is my child attending school?”

and:

“What happened on a particular date?”

within seconds.

Keep the screen calm and trustworthy.

Avoid information overload.

==================================================
35. DATA SOURCE PRINCIPLE
==================================================

Every displayed value must come from actual application data.

Conceptually:

Parent
→ Student / Child
→ StudentClass
→ Attendance records

If subject attendance is supported:

Student
→ Subject/Class relationship
→ Subject attendance records

Do NOT infer subject attendance from timetable data.

Do NOT create fake attendance from sample data.

Do NOT calculate attendance using invalid/unrecorded days.

Do NOT treat missing records as automatically absent.

==================================================
36. FINAL QUALITY CHECK
==================================================

Before completing the implementation, verify:

- Parent role is respected.
- Selected child is always obvious.
- Multiple children work correctly.
- Switching child updates ALL attendance information.
- Academic year is respected.
- Attendance percentage uses real records.
- Recorded days are correctly defined.
- Present is distinct from Absent.
- Not Marked is distinct from Absent.
- Late is shown only if supported.
- Leave is shown only if supported.
- Holidays are shown only if supported.
- Monthly calendar uses real attendance data.
- Date selection works.
- Attendance history uses real records.
- Subject-wise attendance is shown only if actually supported.
- Subject attendance is not inferred from timetable data.
- Full timetable is NOT duplicated.
- Teacher names are not unnecessarily exposed.
- Internal admission IDs are not displayed.
- Regulatory claims are not hard-coded without verified/configured support.
- No class ranking exists.
- No class comparison exists.
- No fake analytics exist.
- No fake attendance percentages exist.
- No fake dates exist.
- No fake check-in times exist.
- Parent permissions are respected.
- Loading state works.
- Error state works.
- Empty state works.
- Offline architecture is compatible with future implementation.
- 320px works.
- 360px works.
- 375px works.
- 390px works.
- 412px works.
- 430px works.
- 480px+ works.
- Calendar works on narrow screens.
- No page-level horizontal overflow.
- Long child names work.
- Long attendance details work.
- Touch targets are usable.
- Existing Parent visual design is preserved.
- Material Symbols / existing icon system is used consistently.
- No emojis are used.
- Bottom navigation remains:

Portal | Academics | Attendance | Fees | More

- Attendance is visibly selected.

MOST IMPORTANT:

Make attendance information easy for a parent to understand.

Do not make the screen “advanced” by adding more information.

Make it accurate, simple, child-specific, and genuinely useful.
