# Action Items: Parent – Academics Screen Design & Implementation

## 1. Scope & Design System Preservation
- [ ] Design and implement the "Parent – Academics" screen for the existing School ERP mobile application.
- [ ] Preserve the existing approved visual design established by Parent Home:
  - Color palette, typography, font family, and font hierarchy.
  - Card design, border radius, spacing, header style, bottom navigation, and button style.
  - Material Symbols / Material Icons and overall visual personality.
- [ ] Do NOT redesign the product or introduce a generic ERP dashboard appearance.

## 2. Screen Purpose & Role Distinction (Parent vs. Teacher)
- [ ] Frame the screen strictly as a child-centric academic workspace answering: "How is my child doing academically?".
- [ ] Ensure the parent can quickly identify:
  - Which child is selected
  - Enrolled class/section
  - Enrolled subjects
  - Latest academic results
  - Available examinations / test schedules
  - Shortcut to the full report card
- [ ] Exclude all teacher operational workflows (Marks Entry, evaluation management, teacher workload, class management, attendance marking, teacher timetables, administrative KPIs).

## 3. Multi-Child Support & Complete Academic Isolation
- [ ] Provide child selector consistent with Parent Home (e.g., `Diya Sharma • Grade 5-A` vs `Aarav Sharma • Grade 2-B`).
- [ ] Ensure switching child refreshes all academic information simultaneously:
  - Subjects list
  - Results and grades
  - Examinations schedules
  - Report card links
  - Historical records
- [ ] NEVER mix academic data between children.
- [ ] Make active child visually obvious; show a compact identity block if the parent has only one child.

## 4. Header & Shell Controls
- [ ] Match Parent Home header layout: Title `Academics`, optional academic session `2026–27`.
- [ ] Include standard notification and profile controls.
- [ ] Hide technical metadata (database IDs, API status, sync timestamps, internal identifiers).

## 5. Child Context Block
- [ ] Display selected child context immediately below the header (e.g., `Diya Sharma • Grade 5-A • Academic Year 2026–27`).
- [ ] Keep the block compact to minimize vertical space consumption.

## 6. Academic Overview Section
- [ ] Display a compact `Academic Overview` section derived from real backend data (e.g., `Latest Result: Term 2`, `Overall Result: 92.4%`, `Subjects: 6`, `Examinations: 2 upcoming`).
- [ ] Do NOT invent percentages, rankings, averages, grades, or counts; omit overview fields if unsupported by backend.
- [ ] Avoid turning overview into an analytics KPI grid.

## 7. Latest Result Prominence & Report Card Access
- [ ] Give strong visual priority to the latest meaningful academic milestone (e.g., `LATEST RESULT • Term 2 Report Card • Overall: 92.4% • Subjects Assessed: 6 • Published: 12 Oct 2026 • [ View Report Card ]`).
- [ ] If overall percentage is unsupported, display `Results available` with `[ View Report Card ]`.
- [ ] If no results are published, display `No report card available yet`; do NOT manufacture fake grades.

## 8. Subject Performance List Presentation
- [ ] Display clean, readable subject list under title `Subjects` (e.g., `Mathematics: A1 · 92%`, `Science: A1 · 90%`, `English: A2 · 84%`).
- [ ] Show only subject name and latest grade/marks where available.
- [ ] Exclude teacher names unless specifically required and supported.
- [ ] Do NOT create decorative progress bars for every subject; prioritize clear readable typography.

## 9. Subject Detail View Navigation
- [ ] Tapping a subject row opens the subject's detailed academic history (e.g., `Mathematics • Grade 5-A • Latest: A1 (92/100) • Unit Test (18/20) • Term 1 (89/100) • Term 2 (92/100)`).
- [ ] Restrict detail view strictly to genuine assessment records from the backend.

## 10. Examinations Section (Upcoming & Recent)
- [ ] Display compact `Examinations` section only if examination data exists (e.g., `Term 2 Examination • Mathematics: 18 Nov, 09:00 AM • Science: 20 Nov, 09:00 AM`).
- [ ] Do NOT duplicate full class timetables.
- [ ] Omit section cleanly if no examination data exists.

## 11. Detailed Report Card Shortcut
- [ ] Provide explicit shortcut card to detailed report card (e.g., `REPORT CARD • Term 2 • Published 12 Oct 2026 • [ View Report Card ]`).
- [ ] Delegate exhaustive mark sheets, totals, percentages, and remarks to the dedicated report card view.

## 12. Academic History (Historical Terms)
- [ ] Display compact `Academic History` list for past academic sessions/terms (e.g., `2026–27 Term 2 [ View Results → ]`, `2026–27 Term 1 [ View Results → ]`).
- [ ] Only show real historical records; avoid inlining individual assessment items on the main screen.

## 13. Separation of Concerns (Attendance, Fees & Timetable)
- [ ] Do NOT duplicate attendance metrics (monthly attendance, %, rosters) on Academics (delegate to Attendance tab).
- [ ] Do NOT duplicate fees (dues, ledgers, invoices) on Academics (delegate to Fees tab).
- [ ] Do NOT duplicate normal class timetables on Academics (delegate to Timetable shortcut/view).

## 14. Academic Status Semantics & Absence of Arbitrary Labels
- [ ] Display semantic statuses only when backed by backend states (`Results Published`, `Results Pending`, `No Recent Results`).
- [ ] Never interpret missing data as poor performance.
- [ ] Do NOT invent arbitrary ranking/evaluative badges (`Excellent`, `Needs Improvement`, `At Risk`, `Top Performer`).

## 15. Strict Exclusion of Competitive Rankings & Comparisons
- [ ] Completely exclude competitive metrics: `Class Rank`, `School Rank`, `Top 10`, `Better than classmates`, and class average comparisons (unless explicitly authorized by backend).

## 16. Exclusion of Artificial Analytics & Prediction Scores
- [ ] Completely exclude artificial analytics: performance index, learning score, academic health score, AI predictions, and predicted grades.

## 17. Information Priority Hierarchy
- [ ] Follow strict vertical priority:
  1. Selected Child
  2. Latest Result / Report Card
  3. Subjects
  4. Upcoming / Recent Examinations
  5. Academic History

## 18. Mobile-First Responsive Design (320px–480px+)
- [ ] Support Android screen widths: 320px, 360px, 375px, 390px, 412px, 430px, 480px+.
- [ ] Use clean single-column layout on 320–360px; avoid multi-column cards, desktop tables, and wide charts.
- [ ] Prevent page-level horizontal scrolling (only compact chip rows may scroll horizontally).
- [ ] Ensure minimum 44px touch targets and graceful text wrapping for long subject and exam names.

## 19. Small-Screen Subject Row Optimization
- [ ] At narrow widths, use compact scannable list rows (e.g., `Mathematics • A1 · 92% >`) rather than tall cards to minimize scrolling.

## 20. Empty States Implementation & Section Omission Rules
- [ ] Empty state text: `No results available yet. Your child's academic results will appear here when published.`.
- [ ] When a sub-feature has no data (no exams, no history), omit the section entirely rather than rendering empty container cards.

## 21. Loading, Error & Future Offline States
- [ ] Use skeleton loaders matching layout during data fetching.
- [ ] On failure: display `Unable to load academic information. [ Retry ]` without exposing technical exceptions or stack traces.
- [ ] Design architecture for future offline caching without falsely displaying `Synced` badges.

## 22. Privacy Protection & Child-Specific Data Boundaries
- [ ] Restrict visibility strictly to the selected child's authorized records.
- [ ] Never expose other students' grades, class-wide rosters, or internal teacher notes.

## 23. Bottom Navigation Integration
- [ ] Use established Parent bottom navigation: `Portal | Academics | Attendance | Fees | More`.
- [ ] Ensure `Academics` is visibly active.
- [ ] Do NOT alter navigation destinations or add extra tabs.

## 24. Consistency with Parent Home & Backend Models
- [ ] Align with Parent Home (Home gives quick updates, Academics provides complete records).
- [ ] Bind UI strictly to real models: Student, Class, Section, Subject, Marks, and Examinations.

## 25. Final UX Principles & Quality Verification Checklist
- [ ] Verify screen feels like "My child's academic record" (clear, calm, informative, child-centric, easy to scan).
- [ ] Verify multi-child switching updates all academic modules cleanly.
- [ ] Verify no fake marks, fake grades, fake percentages, or fake exam dates exist.
- [ ] Verify no teacher workflows, workload info, or competitive rankings are shown.
- [ ] Verify responsive layout across 320px–480px+ with zero horizontal page overflow.
- [ ] Confirm no emojis are used and existing icon system is preserved.

---

# Original Prompt

Design and implement the “Parent – Academics” screen for the existing School ERP mobile application.

IMPORTANT:
This is an EXISTING School ERP application.

The Parent Home screen is already designed and establishes the visual language.

DO NOT redesign the product.

Preserve the existing:
- color palette
- typography
- font family
- font hierarchy
- card design
- border radius
- spacing
- header style
- bottom navigation
- icon style
- Material Symbols / Material Icons
- button style
- overall visual personality

The goal is to create a genuinely useful Parent Academics screen.

Do NOT make this a generic school ERP academic dashboard.

==================================================
1. SCREEN PURPOSE
==================================================

This screen is for a PARENT.

The primary question is:

“How is my child doing academically?”

The parent should be able to quickly understand:

- Which child is selected?
- Which class/section is the child in?
- What subjects does the child study?
- What are the latest academic results?
- What examinations/results are available?
- Where can I see the detailed report card?

Do NOT focus on teacher workflows.

Do NOT show:
- Marks Entry
- Evaluation management
- Teacher workload
- Class management
- Attendance marking
- Teacher timetable
- Faculty actions
- Administrative KPIs

This is a parent-facing academic information screen.

==================================================
2. MULTI-CHILD SUPPORT
==================================================

A parent may have multiple children.

The selected child must remain consistent with Parent Home.

Example:

[ Diya Sharma ]
Grade 5-A

[ Aarav Sharma ]
Grade 2-B

If the parent switches from:

Diya Sharma
Grade 5-A

to:

Aarav Sharma
Grade 2-B

ALL academic information must update:

- subjects
- results
- examinations
- report card
- academic records

NEVER mix academic information between children.

The selected child must always be visually obvious.

If the parent has only one child, show a compact child identity block instead of an unnecessary selector.

==================================================
3. HEADER
==================================================

Use the same header style as Parent Home.

Display:

Academics

Optional secondary information:

2026–27

Use the existing notification/profile controls.

Do not display:

- database IDs
- API status
- sync information
- internal identifiers
- technical system information

==================================================
4. CHILD CONTEXT
==================================================

Immediately below the header, show the selected child.

Example:

Diya Sharma
Grade 5-A

Academic Year
2026–27

Keep this compact.

Do not consume excessive screen space.

The parent should never wonder whose academic information they are viewing.

==================================================
5. ACADEMIC OVERVIEW
==================================================

Create a compact overview section.

Title:

Academic Overview

Show only useful values supported by actual backend data.

Possible information:

Latest Result
Term 2

Overall Result
92.4%

Subjects
6

Examinations
2 upcoming

IMPORTANT:

Only show values that actually exist in the backend.

Do NOT invent:

- percentages
- rankings
- averages
- grades
- subject counts
- examination counts

If the backend does not support an overall percentage, do not create one.

Avoid turning this into a KPI dashboard.

==================================================
6. LATEST RESULT
==================================================

The latest meaningful academic result should receive strong visual priority.

Example:

LATEST RESULT

Term 2 Report Card

Overall
92.4%

Subjects Assessed
6

Published
12 Oct 2026

[ View Report Card ]

If the backend does not have an overall percentage:

Term 2 Report Card

Results available

[ View Report Card ]

If no result has been published:

No report card available yet.

Do not display fake grades.

==================================================
7. SUBJECT PERFORMANCE
==================================================

Provide a clear subject list.

Title:

Subjects

Example:

Mathematics
A1
92%

Science
A1
90%

English
A2
84%

Hindi
A1
91%

Only display:

- subject name
- latest available grade/marks

if actually available.

Do NOT show teacher names unless this information is genuinely useful and supported.

Do NOT create decorative progress bars for every subject.

The parent needs readable academic information, not a chart-heavy dashboard.

==================================================
8. SUBJECT DETAIL
==================================================

When the parent taps a subject:

Open the subject's academic detail.

Example:

Mathematics
Grade 5-A

Latest Result

A1
92 / 100

Assessment History

Unit Test
18 / 20

Term 1
89 / 100

Term 2
92 / 100

Only display actual assessment records supported by the backend.

Do not invent assessment types.

If only final marks are available, show only final marks.

==================================================
9. EXAMINATIONS
==================================================

If examination data exists, provide a section:

Examinations

Show useful upcoming/recent examination information.

Example:

Term 2 Examination

Mathematics
18 Nov
09:00 AM

Science
20 Nov
09:00 AM

Keep this compact.

Do not duplicate the complete timetable.

Do not show examination information that does not exist in the backend.

If no examination data exists:

Do not create an empty large section.

==================================================
10. REPORT CARD
==================================================

Provide a clear shortcut to the detailed report card.

Example:

REPORT CARD

Term 2
Published 12 Oct 2026

[ View Report Card ]

The report card detail screen can contain:

- subjects
- marks
- grades
- total
- percentage
- result
- remarks

ONLY where supported by actual academic records.

Do not put the complete report card table on this screen.

==================================================
11. ACADEMIC HISTORY
==================================================

If historical academic records exist, provide:

Academic History

Example:

2026–27
Term 2
View Results →

2026–27
Term 1
View Results →

Only display real historical records.

Keep the history compact.

Do not show every individual assessment on the main screen.

==================================================
12. ATTENDANCE SEPARATION
==================================================

Do NOT duplicate attendance here.

Attendance has its own Parent bottom-navigation screen.

Academics may contain academic records only.

Do not show:

Monthly Attendance
Present %
Absent %
Attendance history

inside this screen.

If attendance is academically relevant in a report card, it may appear inside the detailed report card if supported.

==================================================
13. FEES SEPARATION
==================================================

Do NOT duplicate fee information.

Fees has its own dedicated bottom-navigation screen.

Do not show:

Outstanding fees
Payment history
Invoices
Receipts

inside Academics.

==================================================
14. TIMETABLE SEPARATION
==================================================

Do NOT create a complete timetable here.

If examination dates are available, examination dates may be shown.

Normal class timetable belongs to the appropriate timetable screen.

==================================================
15. ACADEMIC STATUS
==================================================

If meaningful academic status exists, display it carefully.

Possible:

Results Published

or:

No Recent Results

or:

Results Pending

Only use states actually represented by the backend.

Do not interpret missing data as poor performance.

Do not create labels such as:

Excellent
Needs Improvement
At Risk
Top Performer

unless these are explicit, authorized application concepts backed by actual data.

==================================================
16. NO RANKING / COMPARISON
==================================================

Do NOT show:

Class Rank
School Rank
Top 10
Better than classmates
Class average comparison

unless the existing application explicitly supports these values and they are intended for parent visibility.

Do not introduce competitive comparison as a default academic metric.

==================================================
17. NO ARTIFICIAL ANALYTICS
==================================================

Avoid:

- performance index
- learning score
- academic health score
- progress score
- AI prediction
- predicted grade
- performance trend percentage

unless the existing backend genuinely provides such information.

Do not manufacture intelligence just to make the screen look advanced.

==================================================
18. ACADEMIC INFORMATION HIERARCHY
==================================================

Use this priority:

1. Selected Child
2. Latest Result / Report Card
3. Subjects
4. Upcoming/Recent Examinations
5. Academic History

Everything else is secondary.

The parent should understand the child's academic status within a few seconds.

==================================================
19. RECOMMENDED SCREEN STRUCTURE
==================================================

Use:

HEADER

Academics
2026–27

CHILD SELECTOR

Diya Sharma
Grade 5-A

ACADEMIC OVERVIEW

Latest Result
Term 2

Overall Result
92.4%

[ View Report Card ]

SUBJECTS

Mathematics
A1 · 92%

Science
A1 · 90%

English
A2 · 84%

Hindi
A1 · 91%

[ View All Subjects ]

EXAMINATIONS

Term 2 Examination

Mathematics
18 Nov

Science
20 Nov

[ View All Exams ]

ACADEMIC HISTORY

Term 2
2026–27

Term 1
2026–27

BOTTOM NAVIGATION

Portal
Academics
Attendance
Fees
More

==================================================
20. MOBILE LAYOUT
==================================================

This screen must be designed mobile-first.

Support:

320px
360px
375px
390px
412px
430px
480px+

At 320–360px:

Use a single-column layout.

Do NOT use desktop tables.

Do NOT place many cards side-by-side.

Do NOT create wide charts.

Do NOT allow page-level horizontal scrolling.

Only compact horizontal controls such as child selector/filter chips may horizontally scroll.

Long subject names must wrap.

Long examination names must wrap.

Buttons must remain tappable.

Minimum practical touch target:

44px.

==================================================
21. SUBJECT LIST ON SMALL SCREENS
==================================================

At narrow widths, use compact rows rather than large cards.

Example:

Mathematics
A1 · 92%                    >

Science
A1 · 90%                    >

English
A2 · 84%                    >

This allows many subjects to be scanned quickly.

Do not create four large cards that unnecessarily increase scrolling.

==================================================
22. RESULT CARD
==================================================

The latest report/result may use a slightly stronger visual treatment.

Example:

┌───────────────────────────────┐
│ TERM 2 REPORT CARD            │
│                               │
│ Overall Result                │
│ 92.4%                         │
│                               │
│ Published 12 Oct 2026         │
│                               │
│ View Report Card →            │
└───────────────────────────────┘

Use the existing application's visual style.

Do not introduce a completely new card design.

==================================================
23. EMPTY STATES
==================================================

No academic results:

No results available yet.

Your child's academic results will appear here when published.

No subjects:

No subjects available.

No examinations:

No upcoming examinations.

No academic history:

No previous academic records available.

Do not create large empty dashboard cards.

If a whole section has no useful data, omit that section.

==================================================
24. LOADING STATE
==================================================

Use skeleton loading.

Do not show fake marks while loading.

Example:

Child skeleton

Latest Result skeleton

Subject skeleton
Subject skeleton
Subject skeleton

==================================================
25. ERROR STATE
==================================================

If academic information fails to load:

Unable to load academic information.

[ Retry ]

Do not expose:

- API errors
- database errors
- stack traces
- technical exception messages

If only one section fails, keep other available sections usable.

==================================================
26. OFFLINE SUPPORT
==================================================

The application will support offline operation later.

Design the screen so previously cached academic records can eventually be displayed.

For example:

Cached report card
Cached subject results
Cached academic history

If data is stale, the future implementation may show:

Last updated

Do not falsely claim that data is current.

Do not show “Synced” unless synchronization actually happened.

==================================================
27. PRIVACY
==================================================

Only show academic information belonging to the selected child and authorized for the parent.

Never show:

- other students' marks
- class-wide student lists
- other children's academic data
- internal teacher notes
- internal administrative remarks
- database identifiers

unless explicitly supported and authorized.

==================================================
28. BOTTOM NAVIGATION
==================================================

Use exactly:

Portal
Academics
Attendance
Fees
More

Academics must be the active/selected tab.

Do NOT change the Parent navigation.

Do NOT add:

Results
Exams
Timetable

as bottom-navigation items.

These belong inside the appropriate parent sections.

==================================================
29. CONSISTENCY WITH PARENT HOME
==================================================

The Parent Home already provides quick academic information.

Do not duplicate the entire Home experience.

Home:

Latest academic update
↓
Academics:

Complete academic information

For example:

Parent Home:
Term 2 Report Card
92.4%
View Report Card →

Parent Academics:
Detailed result
Subjects
Examinations
Academic history

This creates a natural navigation relationship.

==================================================
30. CONSISTENCY WITH THE EXISTING SCHOOL ERP
==================================================

The existing project has academic concepts such as:

- Student
- Class
- Section
- Subject
- StudentClass
- ClassSubject
- Marks
- Examinations / academic records where implemented

Use the actual backend data model and API fields.

Do not invent frontend-only academic entities.

If a feature is planned for the future but is not currently implemented:

DO NOT SHOW IT.

==================================================
31. IMPORTANT: DO NOT COPY TEACHER ACADEMICS
==================================================

The existing Teacher Academics screen contains teacher-oriented concepts such as:

- Evaluations
- Marks Entry
- Classroom actions
- Teacher workload
- Faculty functions

DO NOT copy these into Parent Academics.

Parent Academics is READ-ORIENTED and CHILD-CENTRIC.

The parent should consume academic information rather than manage teacher operations.

==================================================
32. IDEAL PARENT FLOW
==================================================

Parent opens:

Academics

↓

Selected child:

Diya Sharma
Grade 5-A

↓

Immediately sees:

Latest Result
Term 2
92.4%

↓

Can tap:

View Report Card

↓

Can scan:

Subjects

Mathematics
A1 · 92%

Science
A1 · 90%

English
A2 · 84%

↓

Can see:

Upcoming Examinations

↓

Can access:

Academic History

The parent should reach detailed academic information in one or two taps.

==================================================
33. DESIGN PRINCIPLE
==================================================

Do not make this screen look like an examination management system.

Do not make it look like a teacher dashboard.

Do not make it look like an analytics platform.

Make it feel like:

“My child's academic record”

The screen should be:

CLEAR
CALM
INFORMATIVE
CHILD-CENTRIC
EASY TO SCAN

Every piece of information must have a clear purpose.

==================================================
34. FINAL QUALITY CHECK
==================================================

Before completing the implementation, verify:

- Parent role is respected.
- Selected child is always clear.
- Multiple children work correctly.
- Switching children updates all academic information.
- Real academic data is used.
- No fake marks exist.
- No fake grades exist.
- No fake percentages exist.
- No fake examination dates exist.
- Latest result is easy to access.
- Report card is easy to access.
- Subject list is easy to scan.
- Academic history is available when supported.
- Attendance is not duplicated.
- Fees are not duplicated.
- Timetable is not duplicated.
- Teacher workflows are not shown.
- No teacher workload information is shown.
- No unnecessary academic analytics are shown.
- No student ranking is introduced.
- No unsupported future modules are introduced.
- Empty states work.
- Loading states work.
- Error states work.
- Offline architecture is compatible with future implementation.
- Parent permissions are respected.
- 320px works.
- 360px works.
- 375px works.
- 390px works.
- 412px works.
- 430px works.
- 480px+ works.
- No page-level horizontal overflow.
- Long subject names work.
- Long examination names work.
- Touch targets are usable.
- Existing visual design is preserved.
- Material Symbols / existing icon system is used.
- No emojis are used.
- Bottom navigation remains:

Portal | Academics | Attendance | Fees | More

- Academics is visibly selected.

MOST IMPORTANT:

Do not add academic features just because they are common in other school ERP applications.

Use actual project capabilities and real academic data.

The parent should be able to open this screen and understand their child's academic situation quickly, without unnecessary complexity.
