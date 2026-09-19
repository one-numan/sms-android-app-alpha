# Action Items: Subject Teacher – Academics Screen Design & Implementation

## 1. Scope & Existing Design System Preservation
- [ ] Design and implement the "Subject Teacher – Academics" screen as the natural next screen after Subject Teacher → Portal.
- [ ] Preserve the existing approved visual design system:
  - Color palette, typography, font sizes, and weights
  - Card style, border radius, spacing system, shadows, and borders
  - Icon styling, header style, button style, and bottom navigation
- [ ] Do NOT redesign the overall product or introduce a new visual theme.
- [ ] Focus strictly on information architecture, data representation, and usability.

## 2. Subject Teacher Role Context & Constraints
- [ ] Tailor the screen specifically for the **Subject Teacher** role (one or multiple subjects across multiple classes/sections).
- [ ] Do NOT assume the teacher is a Class Teacher.
- [ ] Derive content strictly from real subject assignments; do NOT invent mock subjects, classes, students, marks, assignments, schedules, statistics, percentages, or pending counts.
- [ ] Display meaningful empty states if data is absent.

## 3. Screen Purpose & Workspace Principles
- [ ] Provide quick access to actual academic responsibilities:
  1. My Subjects
  2. My Classes / Teaching Assignments
  3. Results / Marks
  4. Academic Records
- [ ] Treat the screen strictly as a practical operational workspace, NOT an analytics dashboard.
- [ ] Avoid unnecessary KPI cards (Total Students, Average Performance, Completion %, Academic Score, Teaching Efficiency, Performance Index) unless genuinely provided by backend.

## 4. Screen Structure & Vertical Hierarchy
- [ ] Follow strict vertical hierarchy:
  1. HEADER
  2. ACADEMIC CONTEXT
  3. MY TEACHING
  4. ACADEMIC WORK
  5. RECENT / PENDING ACADEMIC ITEMS
  6. BOTTOM NAVIGATION
- [ ] Ensure layout is compact, highly scannable, and requires minimal scrolling.

## 5. Header Specifications
- [ ] Use existing application header layout.
- [ ] Display title: `Academics`.
- [ ] Optionally display subtitle below title: `Academic Year 2026–27`.
- [ ] Hide technical implementation details (database IDs, internal UUIDs, API details, sync timestamps, backend status, system identifiers).
- [ ] Include standard notification and profile controls.

## 6. Academic Context & Filters
- [ ] Provide a compact academic context selector below the header (Academic Year `2026–27`).
- [ ] Provide a compact, horizontally scrollable subject filter when multiple subjects/classes exist (e.g., `[ All Subjects ]` or `[ Mathematics ▼ ]` / `[ All ] [ Mathematics ] [ Science ]`).
- [ ] Avoid consuming excessive vertical screen space.

## 7. My Teaching Section Architecture
- [ ] Title section: `My Teaching` as the primary functional area.
- [ ] Display actual subject and class assignments as compact cards/list items:
  - Subject (e.g., `Mathematics`)
  - Class / Grade & Section (e.g., `Grade 5 • Section A`)
  - Teacher assignment context (e.g., `Subject Teacher`)
  - Room / Location only if real timetable/classroom data exists
- [ ] Make distinctions between multiple sections of the same subject obvious (e.g., `Mathematics 5-A` vs `Mathematics 5-B`).
- [ ] Exclude fake student counts, workload scores, completion percentages, and employee IDs.

## 8. Teaching Assignment Interaction & Navigation
- [ ] Tapping an assignment card opens the relevant academic context for `Subject + Class + Section` (e.g., Mathematics Grade 5-A).
- [ ] Provide access to academic records genuinely supported by the system without inventing new workflows.

## 9. Academic Work Section & Workflow Cards
- [ ] Create section: `Academic Work` using a simple 2-column or compact list layout.
- [ ] Include only supported teacher workflows:
  - `Marks / Results`: view or manage student academic results
  - `Academic Records`: access available academic records for assigned classes/subjects
  - `Examinations`: access examination schedules/records if supported by backend
- [ ] Do NOT add unimplemented modules: Homework, Assignments, Lesson Planner, Question Bank, Study Material, Online Tests, Grading Analytics.

## 10. Marks / Results Capabilities & Permission Gating
- [ ] Prominently feature `Marks & Results` ("Enter, review, or view academic marks").
- [ ] Gate actions strictly by backend permissions:
  - If view-only: show `View Results`
  - If entry permitted: show `Enter Marks`
  - If both supported: show `View Results` and `Enter Marks`
- [ ] Never assume permissions without backend confirmation.

## 11. Recent / Pending Academic Items (Lightweight Activity)
- [ ] Add a lightweight `Recent Activity` section only when backed by real data (e.g., `Mathematics • Grade 5-A • Marks updated`).
- [ ] If no recent activity exists, omit the section or display a minimal text note: `No recent academic activity`; avoid empty card containers.
- [ ] Never fabricate recent activity.

## 12. Empty States Implementation
- [ ] No teaching assignments found: display `My Teaching` with `No teaching assignments found. Your assigned subjects and classes will appear here.`.
- [ ] Academic module has no data: display `No records available`.
- [ ] Avoid misleading `0%`, `0 pending`, or artificial zero-state statistics.

## 13. Multiple Subjects & Multi-Class Handling
- [ ] Ensure layout adapts gracefully to:
  - 1 subject + 1 class
  - 1 subject + many classes
  - many subjects + many classes
- [ ] Prevent visual clutter using compact assignment cards and horizontally scrollable subject filter pills.

## 14. Dual Role (Class Teacher + Subject Teacher) Boundary Isolation
- [ ] Keep this screen strictly as the Subject Teacher academic workspace.
- [ ] Do NOT duplicate Class Teacher responsibilities, homeroom management, or class-wide attendance here.
- [ ] Do NOT introduce `My Class` into this screen unless that feature already exists in current navigation/models.

## 15. Mobile-First Responsive Design (320px–480px+)
- [ ] Verify layout across standard Android widths: 320px, 360px, 375px, 390px, 412px, 430px, 480px+.
- [ ] For 320–360px: enforce clean single-column layout; avoid cramped multi-column grids.
- [ ] For larger widths: use compact 2-column grid only where it improves usability.
- [ ] Enforce minimum touch target of 44px for all interactive buttons and cards.
- [ ] Prevent horizontal page overflow, clipped text, or overlapping cards.
- [ ] Handle long subject names and long class names with graceful wrapping.

## 16. Bottom Navigation Integration
- [ ] Retain Subject Teacher navigation: `Portal | Academics | Attendance | Timetable | More`.
- [ ] Ensure `Academics` is visibly active.
- [ ] Do NOT alter bottom navigation for Student, Class Teacher, Admin, Superadmin, or Parent.

## 17. Attendance & Timetable Separation Guardrails
- [ ] Do NOT duplicate full attendance workflows inside Academics (refer attendance to dedicated `Attendance` tab).
- [ ] Do NOT duplicate full timetable schedules inside Academics (refer timetable to dedicated `Timetable` tab).

## 18. Information Priority Alignment
- [ ] High Priority: Assigned subjects, assigned classes/sections, marks/results, academic records.
- [ ] Medium Priority: Examinations, recent academic activity.
- [ ] Low Priority: Secondary contextual information.
- [ ] Remove: Decorative statistics, generic dashboard cards, fake progress indicators, duplicated attendance/timetable, unsupported future modules, technical metadata.

## 19. Visual Design & Professional Icon Standards
- [ ] Strictly adhere to School ERP design language (ivory/cream surfaces, cocoa accents, Newsreader/Manrope typography).
- [ ] Use Material Symbols / Material Icons consistently.
- [ ] Do NOT use emojis, random icon sets, excessive gradients, heavy shadows, oversized illustrations, or decorative charts.

## 20. Loading, Error & Offline States
- [ ] Display skeleton placeholders matching the exact layout during data fetching.
- [ ] On failure: show simple error `Academic information couldn't be loaded. [ Retry ]` without exposing stack traces or API exceptions.
- [ ] Structure architecture to be compatible with future offline caching without claiming fake offline support.

## 21. Accessibility & Performance Benchmarks
- [ ] Ensure strong text contrast, readable fonts, and clear touch-friendly controls.
- [ ] Provide meaningful icon labels; avoid icon-only critical actions.
- [ ] Never rely on color alone to communicate status.
- [ ] Keep the screen lightweight and responsive on low/mid-range Android devices (no heavy charts, animations, or nested cards).

## 22. Backend Data Relationship Model
- [ ] Bind UI strictly to real relationships: Teacher → Subject assignment → Class → Section → Academic records / Marks.
- [ ] Do not invent frontend-only fake models or relationships.

## 23. Final Quality & Usability Verification Checklist
- [ ] Verify existing design system is preserved without redesign.
- [ ] Verify Subject Teacher role context is respected without Class Teacher bleed.
- [ ] Verify actual assignments are displayed without fake data or unsupported modules.
- [ ] Verify Marks & Results access aligns with permissions (View / Enter).
- [ ] Verify Attendance and Timetable are not duplicated.
- [ ] Verify multi-subject and multi-class filtering works smoothly.
- [ ] Verify empty, loading, and error states render correctly.
- [ ] Verify responsive widths (320px to 480px+) with no horizontal overflow.
- [ ] Verify minimum 44px touch targets and graceful text wrapping for long names.
- [ ] Verify bottom navigation shows Academics selected.
- [ ] Confirm no emojis are used anywhere.

---

# Original Prompt

Design and implement the “Subject Teacher – Academics” screen for an existing School ERP mobile application.

IMPORTANT:
This is an EXISTING application with an established visual design system. Do NOT redesign the overall product.

Preserve the existing:
- color palette
- typography
- font sizes and weights
- card style
- border radius
- spacing system
- icons style
- header style
- bottom navigation style
- button style
- shadows/borders
- overall visual language

The goal is to improve INFORMATION ARCHITECTURE, DATA REPRESENTATION, and USABILITY — not to introduce a new visual theme.

The screen must feel like the natural next screen after:
Subject Teacher → Portal

==================================================
1. ROLE CONTEXT
==================================================

This screen is specifically for a SUBJECT TEACHER.

The teacher may teach:
- one subject
- multiple subjects
- multiple classes/sections

Do NOT assume the teacher is a Class Teacher.

The screen must be based on the teacher’s actual subject assignments.

Do not create fake:
- subjects
- classes
- students
- marks
- assignments
- schedules
- statistics
- percentages
- pending counts

If data does not exist, show a meaningful empty state instead.

==================================================
2. PURPOSE OF THE SCREEN
==================================================

The Academics screen should provide quick access to the teacher's actual academic responsibilities.

Primary academic areas:

1. My Subjects
2. My Classes / Teaching Assignments
3. Results / Marks
4. Academic Records

Do NOT turn this into a large analytics dashboard.

Avoid unnecessary KPI cards such as:
- Total Students
- Average Performance
- Completion %
- Academic Score
- Teaching Efficiency
- Performance Index

unless those values are genuinely available from the backend.

This is a WORKSPACE, not an analytics report.

==================================================
3. SCREEN STRUCTURE
==================================================

Use this hierarchy:

HEADER
↓
ACADEMIC CONTEXT
↓
MY TEACHING
↓
ACADEMIC WORK
↓
RECENT / PENDING ACADEMIC ITEMS
↓
BOTTOM NAVIGATION

Keep the screen compact and scannable on mobile.

==================================================
4. HEADER
==================================================

Use the existing application header design.

Display:

Academics

Below it, optionally show:

Academic Year
2026–27

Do not show unnecessary technical information.

Do not show:
- database IDs
- internal IDs
- API information
- synchronization timestamps
- backend status
- system identifiers

Use the existing notification/profile controls from the application.

==================================================
5. ACADEMIC CONTEXT
==================================================

Immediately below the header, show a compact academic context selector.

Example:

Academic Year
2026–27

If the application already has an academic-year selector, reuse the existing component.

Do NOT create multiple large selectors.

If the teacher has multiple subjects/classes, provide a compact filter:

[ All Subjects ]

or

[ Mathematics ▼ ]

Do not consume excessive vertical space.

==================================================
6. MY TEACHING SECTION
==================================================

Title:

My Teaching

This is the most important section of the screen.

Display the teacher's actual subject/class assignments.

Example structure:

Mathematics
Grade 5 • Section A
Subject Teacher

Mathematics
Grade 6 • Section B
Subject Teacher

Science
Grade 7 • Section A
Subject Teacher

Each assignment should be a compact card/list item.

Show only useful information:

- Subject
- Class / Grade
- Section
- Teacher assignment context

Optional:
- room, only if actual timetable/classroom data exists

Do NOT show:
- fake student counts
- fake workload scores
- fake completion percentages
- teacher employee IDs

If the same subject is taught to multiple sections, make the distinction obvious.

For example:

Mathematics
5-A

Mathematics
5-B

These should not appear as one ambiguous “Mathematics” card.

==================================================
7. ASSIGNMENT INTERACTION
==================================================

When the teacher taps a teaching assignment, open the relevant academic context.

The destination should show academic information for:

Subject + Class + Section

For example:

Mathematics
Grade 5-A

Then provide access to the academic records actually supported by the system.

Do not invent new workflows.

==================================================
8. ACADEMIC WORK SECTION
==================================================

Create a section:

Academic Work

Use a simple 2-column or compact list layout depending on the existing design system.

Prioritize only useful teacher workflows.

Recommended items:

Marks / Results
View or manage student academic results where supported.

Academic Records
Access available academic records for assigned classes/subjects.

Examinations
Access examination-related information if the backend supports examinations.

Do NOT add:

Homework
Assignments
Lesson Planner
Question Bank
Study Material
Online Tests
Grading Analytics

unless these features already exist in the actual project/backend.

The current project should not display future/unimplemented modules simply because they are common in other school ERP products.

==================================================
9. MARKS / RESULTS
==================================================

Marks / Results should be a prominent academic function because it is directly related to subject teaching.

Display something like:

Marks & Results

Enter, review, or view academic marks

Only show actions that the teacher is actually authorized to perform.

If the teacher can only view marks:

View Results

If the teacher can enter marks:

Enter Marks

If both are supported:

View Results
Enter Marks

Do not assume permissions.

Permissions must come from the actual application/backend.

==================================================
10. RECENT / PENDING ACADEMIC ITEMS
==================================================

If actual backend data supports it, add a small section:

Recent Activity

Examples:

Mathematics
Grade 5-A
Marks updated

Science
Grade 7-B
Result published

Keep this section lightweight.

Do NOT manufacture activity.

If there is no recent activity, simply omit the section or show:

No recent academic activity

Do not fill the screen with an empty card.

==================================================
11. EMPTY STATE
==================================================

If the teacher has no subject assignments:

My Teaching

No teaching assignments found.

Your assigned subjects and classes will appear here.

Do not show fake sample data.

If a particular academic module has no data:

No records available

Do not show misleading “0%”, “0 pending”, or artificial statistics.

==================================================
12. MULTIPLE SUBJECTS / CLASSES
==================================================

The design must work when a teacher has:

1 subject + 1 class

1 subject + many classes

many subjects + many classes

The layout must not become crowded.

Use:

Subject filters
and/or
compact assignment cards

rather than creating a giant dashboard.

Example:

[ All ] [ Mathematics ] [ Science ]

Then:

Mathematics
5-A
Subject Teacher

Mathematics
6-A
Subject Teacher

Science
7-B
Subject Teacher

The filter should be horizontally scrollable if necessary.

==================================================
13. CLASS TEACHER + SUBJECT TEACHER
==================================================

A teacher can potentially be both:

Class Teacher
and
Subject Teacher.

Do NOT create a separate account or separate visual identity.

This screen remains the Subject Teacher academic workspace.

If the teacher also has Class Teacher responsibilities, those responsibilities should be accessed through the appropriate Class Teacher workflow rather than duplicating everything here.

Do not add “My Class” unless that feature already exists in the current navigation/data model.

==================================================
14. MOBILE-FIRST RESPONSIVE DESIGN
==================================================

This is extremely important.

The screen must work correctly across:

320px
360px
375px
390px
412px
430px
480px+

Do not design only for a large Android phone.

At narrow widths:

- no horizontal page overflow
- no clipped text
- no overlapping cards
- no fixed-width desktop components
- no tiny buttons
- no unreadable text
- no excessive padding
- no multi-column layout that becomes cramped

For 320–360px width, prefer a single-column layout.

For larger phones, a compact 2-column grid may be used only where it genuinely improves usability.

Subject/class cards should remain readable at all widths.

Long subject names must wrap naturally.

Long class names must not break the layout.

Buttons must remain comfortably tappable.

Minimum practical touch target:
44px.

==================================================
15. BOTTOM NAVIGATION
==================================================

Use the EXISTING Subject Teacher bottom navigation:

Portal
Academics
Attendance
Timetable
More

Academics must be the active tab.

Do not modify navigation for:
- Student
- Class Teacher
- Admin
- Superadmin
- Parent

This screen is only for the Subject Teacher role.

==================================================
16. ATTENDANCE SEPARATION
==================================================

Do NOT duplicate the full attendance workflow inside Academics.

Attendance already has its own dedicated bottom-navigation destination.

Academics may reference academic records, but attendance marking/history should remain under:

Attendance

This avoids duplicated functionality and makes navigation easier to understand.

==================================================
17. TIMETABLE SEPARATION
==================================================

Do NOT duplicate the complete timetable inside Academics.

The dedicated:

Timetable

tab handles timetable information.

Academics should focus on academic records and teaching-related academic work.

==================================================
18. INFORMATION PRIORITY
==================================================

Use this priority:

HIGH PRIORITY
- Assigned subjects
- Assigned classes/sections
- Marks/results
- Academic records

MEDIUM PRIORITY
- Examinations
- Recent academic activity

LOW PRIORITY
- Secondary information

REMOVE:
- decorative statistics
- generic dashboards
- meaningless KPIs
- fake progress indicators
- duplicated attendance
- duplicated timetable
- unsupported future features
- technical system information

Every element must answer:

“Will this help a subject teacher understand or perform their academic work?”

If not, remove it.

==================================================
19. VISUAL DESIGN
==================================================

Keep the existing School ERP visual language.

Use:
- existing cards
- existing spacing
- existing typography
- existing color system
- existing Material Symbols / Material Icons

Do NOT introduce:
- emojis
- random icon libraries
- excessive gradients
- excessive shadows
- oversized illustrations
- decorative charts
- flashy animations

Icons should communicate function clearly.

==================================================
20. LOADING STATE
==================================================

When academic data is loading:

Use skeleton placeholders that match the actual layout.

Do not show fake data while loading.

Example:

My Teaching
[ skeleton ]
[ skeleton ]

Academic Work
[ skeleton ] [ skeleton ]

==================================================
21. ERROR STATE
==================================================

If academic data cannot be loaded:

Academic information couldn't be loaded.

[ Retry ]

Keep the error state simple.

Do not expose:
- API errors
- stack traces
- database errors
- technical exception messages

==================================================
22. OFFLINE STATE
==================================================

The application is intended to support offline operation later.

Design the UI so that it can eventually distinguish:

Available offline

and

Requires connection

Do not implement fake offline functionality.

If the current system has no offline data yet, simply make the UI architecture compatible with future offline support.

==================================================
23. ACCESSIBILITY
==================================================

Ensure:

- readable text
- sufficient contrast
- clear hierarchy
- touch-friendly controls
- meaningful icon labels
- no icon-only critical actions
- visible selected states
- screen-reader-friendly labels where applicable

Do not communicate important information using color alone.

==================================================
24. PERFORMANCE
==================================================

The screen should remain lightweight.

Do not add:

- heavy charts
- large illustrations
- unnecessary animations
- complex visual effects
- excessive nested cards

The screen should feel fast and native on low/mid-range Android devices.

==================================================
25. IMPORTANT DATA RULE
==================================================

The UI must be designed around REAL backend data.

Expected conceptual data relationships:

Teacher
→ Subject assignment
→ Class
→ Section
→ Academic records / Marks

Use actual project models and API fields when available.

Do not create frontend-only fake academic relationships.

If a field is unavailable, do not invent it.

==================================================
26. FINAL SCREEN HIERARCHY
==================================================

The final screen should roughly follow:

Academics
2026–27

[ All Subjects ▼ ]

MY TEACHING

┌─────────────────────────┐
│ Mathematics             │
│ Grade 5 • Section A     │
│ Subject Teacher      →  │
└─────────────────────────┘

┌─────────────────────────┐
│ Mathematics             │
│ Grade 6 • Section B     │
│ Subject Teacher      →  │
└─────────────────────────┘

ACADEMIC WORK

┌───────────────┐
│ Marks &       │
│ Results    →  │
└───────────────┘

┌───────────────┐
│ Academic      │
│ Records    →  │
└───────────────┘

┌───────────────┐
│ Examinations →│
└───────────────┘

RECENT ACTIVITY
Only show if real data exists.

[ Portal ] [ Academics ] [ Attendance ] [ Timetable ] [ More ]

==================================================
27. UX PRINCIPLE
==================================================

Do not try to make this screen look “feature rich”.

Make it useful.

The teacher should be able to open Academics and immediately understand:

“What subjects do I teach?”
“Which classes do I teach?”
“Where do I access marks/results?”
“What academic records can I work with?”

The screen should require minimal scrolling and minimal decision-making.

Prioritize real workflows over visual decoration.

==================================================
28. FINAL QUALITY CHECK
==================================================

Before completing the implementation, verify:

- Existing design system is preserved.
- Subject Teacher role is respected.
- Actual subject/class assignments are used.
- No fake academic data exists.
- No unsupported modules are displayed.
- Marks/results are easy to access.
- Attendance is not duplicated.
- Timetable is not duplicated.
- Class Teacher functionality is not incorrectly mixed into this screen.
- Multiple subjects work correctly.
- Multiple classes work correctly.
- Empty states work.
- Loading states work.
- Error states work.
- 320px width works.
- 360px width works.
- 390px width works.
- 412px width works.
- 430px width works.
- Long subject names work.
- Long class names work.
- Touch targets are usable.
- No horizontal overflow exists.
- Bottom navigation remains consistent.
- Academics is visibly selected.
- No emojis are used.
- One consistent professional icon system is used.
- No unnecessary KPI/dashboard elements are introduced.

Most importantly:

DO NOT add a feature merely because another school ERP normally has it.

Only show academic information and actions that are supported by the existing School ERP data model and permissions.

The result should feel like a clean, practical, production-quality Subject Teacher academic workspace rather than a generic school ERP template.
