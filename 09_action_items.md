# Action Items: Parent Home / Parent Portal Screen Design & Implementation

## 1. Scope & Existing Visual System Preservation
- [ ] Design and implement the "Parent Home / Parent Portal" screen (`parent_dashboard_screen.dart`).
- [ ] Preserve the existing approved visual design:
  - Color palette, typography, font family, and font hierarchy.
  - Card style, border radius, spacing, header style, bottom navigation, button style, and icon style.
  - Material Symbols / Material Icons and overall visual personality.
- [ ] Do NOT redesign the visual system; focus strictly on usefulness, clarity, and scannability.

## 2. Primary Purpose & Child-Centric Focus
- [ ] Structure the screen to answer the parent's core questions immediately:
  1. Which child am I viewing?
  2. Is my child present today?
  3. Is there anything important I need to know?
  4. Is any fee/payment due?
  5. Is there any academic update?
  6. Is there anything requiring my attention?
  7. Where can I quickly access important child services?
- [ ] Maintain a child-centric tone ("My child's school today"), avoiding an administrative dashboard feel.

## 3. Multi-Child Architecture & Data Isolation
- [ ] Support multi-child switching via prominent child selector (e.g., `Diya Sharma • Grade 5-A` vs `Aarav Sharma • Grade 2-B`).
- [ ] Ensure switching child refreshes all child-specific data simultaneously:
  - Attendance records
  - Academic updates and report cards
  - Fee dues and balances
  - Timetable previews
  - Transport tracking
  - Relevant notices
  - Quick service shortcuts
- [ ] NEVER mix or leak data between different children.
- [ ] Visually highlight the currently active child clearly.

## 4. Header & Action Controls
- [ ] Preserve compact header layout: School branding (`ONPS`), Search, Notifications, and More actions.
- [ ] Display notification badge only when real unread notifications exist; avoid fabricated counts.
- [ ] Omit technical system metadata (database IDs, API status, sync timestamps, internal identifiers).

## 5. Child Selector Implementation
- [ ] Position child selector near the top of the screen.
- [ ] Use horizontally scrollable chips/cards for multi-child parents.
- [ ] For single-child parents, display child identity cleanly (e.g., `Diya Sharma • Grade 5-A` with optional profile photo) without wasteful horizontal scroll areas.
- [ ] Protect sensitive personal child data from unnecessary exposure.

## 6. Today's Attendance Status Block
- [ ] Prominently display "How is my child today?" status at the top of the body:
  - `Present Today • 07:48 AM check-in`
  - `Absent Today`
  - `Attendance not marked yet`
  - `Late` (only if supported by backend)
- [ ] Strictly distinguish `Not Marked` from `Absent`; never classify unrecorded attendance as absent.

## 7. Monthly Attendance Summary & Navigation
- [ ] Display compact monthly attendance metrics derived from real records (e.g., `Monthly Attendance • 60% • 3 of 5 recorded days • Present 3 · Late 0 · Absent 2`).
- [ ] If no monthly records exist, display `No attendance records available yet` (avoid artificial 0%).
- [ ] Provide shortcut action `[ View Attendance → ]` routing to dedicated Parent Attendance screen without inlining the entire attendance history.

## 8. Important Attention Section (`Needs Your Attention`)
- [ ] Display `Needs Your Attention` section only when genuine actionable items exist:
  - Fee payments due (e.g., `Fee Payment Due • ₹12,500 due • Due in 18 days • [ View Fees → ]`)
  - Circular acknowledgements
  - Attendance concerns
  - Published report cards / exam results (e.g., `New Report Card Available • Term 2 results are available • [ View Results → ]`)
  - Pending documents/actions
- [ ] If no items require attention, display `You're all caught up.` or omit the section cleanly; do not render large empty placeholder cards.

## 9. Fees Summary & Outstanding Balance Card
- [ ] Display high-level fees summary answering "Do I owe anything?" (e.g., `FEES • ₹12,500 Outstanding • Due in 18 days • [ View Fee Details → ]`).
- [ ] If no dues exist, show `Fees • No outstanding dues`.
- [ ] Avoid accountant-style invoice tables or full ledgers on the Home screen (delegate to Fees tab).

## 10. Academic Update & Report Card Announcements
- [ ] Display meaningful recent academic milestones only when real data exists (e.g., `Term 2 Report Card • Cumulative: 92.4% • [ View Report Card → ]` or `Latest Result • Mathematics A1 • [ View Results → ]`).
- [ ] Exclude unsupported academic KPIs, artificial performance scores, peer rankings, and comparison charts.
- [ ] Omit section cleanly if no recent academic updates exist.

## 11. School Communication & Important Notices
- [ ] Display compact `Important Notices` section highlighting the top 1–2 relevant communications (e.g., `School Circular • Winter uniform schedule • Today • [ View All ]` or `Important Notice • Parent-teacher meeting • Friday, 4:00 PM • [ View Details ]`).
- [ ] Avoid long circular lists on Home.

## 12. Transport Status (Conditional Display)
- [ ] Display compact transport card only if the selected child uses school transport and live/route data exists (e.g., `TRANSPORT • Safe Transit Route #4 • On Schedule • Bus DL-01-AB-1294 • [ View Transport → ]`).
- [ ] Omit transport section completely if child does not use transport or data is unconfigured (never show empty "No Transport" cards).

## 13. Student Quick Services Shortcuts
- [ ] Provide compact quick-service grid:
  - `Student 360`: shortcut to child consolidated profile, admission, academics, and records.
  - `Timetable`: shortcut to child schedule (with optional contextual `Next Class` preview if data exists).
  - `Digital ID`: shortcut to child digital student ID card without security jargon.
  - `Circulars`: shortcut to school circulars.
- [ ] Use existing Material Symbols / Icons; avoid heavy dashboard card treatments.

## 14. Exclusions & Unwanted Dashboard Elements Removal
- [ ] Remove:
  - School-wide statistics and administrative KPIs
  - Class-wide performance charts and academic comparison graphs
  - Full fee ledger tables and full attendance rosters
  - Complete timetable schedules
  - Technical sync timestamps, database IDs, and backend error codes
  - Fake AI insights and generic motivational banners

## 15. Information & Visual Card Priority Hierarchy
- [ ] Prioritize vertical order:
  1. Child selector
  2. Today's attendance
  3. Needs your attention
  4. Fees / Academic updates
  5. Important notices
  6. Transport (if active)
  7. Student quick services
- [ ] Remove empty sections rather than displaying multiple empty placeholder cards.

## 16. Mobile-First Responsive Design (320px–480px+)
- [ ] Optimize for Android screen widths: 320px, 360px, 375px, 390px, 412px, 430px, 480px+.
- [ ] At 320–360px: ensure clean vertical stacking; avoid cramped multi-column cards.
- [ ] Ensure quick-service cards scale gracefully or wrap into compact grids.
- [ ] Prevent page-level horizontal scrolling (only the child selector chip row may scroll horizontally).
- [ ] Ensure minimum 44px touch targets and graceful wrapping for long student and notice names.

## 17. Scroll Behavior & Page Layout
- [ ] Maintain smooth vertical page scrolling.
- [ ] Keep header and child selector accessible near the top.
- [ ] Avoid nested scroll containers.

## 18. Loading, Error & Future Offline States
- [ ] Provide skeleton loaders for child selector, today's status, fees, and academic update blocks.
- [ ] Implement section-level error handling with `[ Retry ]` so partial failures do not crash the entire portal.
- [ ] Architecture UI for future cached offline viewing without falsely displaying `Synced` badges.

## 19. Notification Badge Behavior
- [ ] Reflect real unread counts on notification bell (e.g., `1`, `3`, `9+`); hide badge completely when count is zero.

## 20. Dynamic Child Switching Lifecycle
- [ ] Ensure child switching immediately refreshes all screen modules to the new child without stale data retention or data cross-contamination.

## 21. Parent Access Control & Security Boundaries
- [ ] Restrict visibility strictly to the authenticated parent's children and authorized school circulars.
- [ ] Never expose other students, teacher personal details, internal staff notes, or administrative metrics.

## 22. Empty State & Card Omission Rules
- [ ] Prefer omitting cards entirely over rendering multiple "Nothing here" placeholder boxes.
- [ ] When necessary, use concise semantic text (e.g., `No attendance recorded`, `No outstanding dues`, `No recent academic updates`).

## 23. Cross-Role Design System Consistency
- [ ] Maintain seamless visual consistency with Student, Teacher, and Subject Teacher portals (same typography, cream/ivory/cocoa palette, card styling, and icons).
- [ ] Differentiate by tailored parent information, not by a separate fragmented theme.

## 24. Bottom Navigation Integration
- [ ] Use established Parent bottom navigation: `Portal | Academics | Attendance | Fees | More`.
- [ ] Ensure `Portal` is visibly selected.
- [ ] Do NOT modify navigation for Student, Class Teacher, Subject Teacher, Admin, or Superadmin.

## 25. Backend Data Relationship Model
- [ ] Bind UI strictly to real relationships: Parent → Child/Student → Class/Section → Attendance / Academics / Fees / Timetable / Transport / Notices.
- [ ] Do not invent frontend-only mock entities.

## 26. Final UX & Quality Verification Checklist
- [ ] Verify visual design system is fully preserved without redesign.
- [ ] Verify active child is obvious and child switching refreshes all modules cleanly.
- [ ] Verify Today's attendance status distinguishes Present, Absent, Late, and Not Marked.
- [ ] Verify attendance percentages derive from actual records.
- [ ] Verify Fees card displays real outstanding dues only.
- [ ] Verify Academic updates and Notices show only genuine, relevant information.
- [ ] Verify Transport appears only when actively used.
- [ ] Verify Quick Services operate on the selected child.
- [ ] Verify responsive layout across 320px–480px+ with zero horizontal page overflow.
- [ ] Verify loading skeletons, section-level error retries, and clean empty state omissions.
- [ ] Confirm no emojis are used anywhere.

---

# Original Prompt

Design and implement the “Parent Home / Parent Portal” screen for the existing School ERP mobile application.

IMPORTANT:
This is an EXISTING application.

The attached/reference Parent Home screen represents the current visual direction.

DO NOT redesign the overall visual system.

Preserve the existing:
- color palette
- typography
- font family
- font hierarchy
- card style
- border radius
- spacing
- header style
- bottom navigation
- button style
- icon style
- Material Symbols / Material Icons
- overall visual personality

The goal is to make the Parent Home screen MORE USEFUL, CLEAR, and EASY TO SCAN — not visually more complicated.

Do not add information merely to make the dashboard look feature-rich.

==================================================
1. PRIMARY PURPOSE
==================================================

The Parent Home screen should answer the parent's most important questions immediately:

1. Which child am I viewing?
2. Is my child present today?
3. Is there anything important I need to know?
4. Is any fee/payment due?
5. Is there any academic update?
6. Is there anything requiring my attention?
7. Where can I quickly access important child services?

The screen should feel like:

“My child's school today”

rather than:

“School administration dashboard”.

==================================================
2. MULTI-CHILD SUPPORT
==================================================

This is one of the most important parts of the design.

A parent may have multiple children enrolled in the school.

The current reference design already has a child selector:

Diya Sharma
Grade 5-A

Aarav Sharma
Grade 2-B

KEEP THIS CONCEPT.

The selected child controls all child-specific information on the page.

When the parent switches child:

- attendance changes
- academic information changes
- fee information changes
- timetable changes
- transport information changes
- notices relevant to that child change
- quick actions remain available but operate on the selected child

NEVER mix information from different children.

Make the selected child visually obvious.

==================================================
3. HEADER
==================================================

Preserve the existing compact header.

Example:

ONPS

Right side:

Search
Notifications
More

Do not add unnecessary information to the header.

Notification should show a badge/count only when there are actual unread notifications.

Search should be useful for supported school information.

Do not display technical information such as:
- database IDs
- API status
- synchronization timestamps
- internal identifiers

==================================================
4. CHILD SELECTOR
==================================================

Place the child selector near the top.

Example:

[ Diya Sharma ]
Grade 5-A

[ Aarav Sharma ]
Grade 2-B

Use horizontally scrollable child chips/cards if multiple children exist.

For a single-child parent:

Do not waste space with unnecessary scrolling.

Show the child clearly:

Diya Sharma
Grade 5-A

Optionally show the child's profile photo if available.

Do not display sensitive unnecessary information.

==================================================
5. TODAY'S STATUS
==================================================

The first major information block should answer:

“How is my child today?”

Example:

TODAY

Present Today
07:48 AM check-in

or:

Absent Today

or:

Attendance not marked yet

or:

Late

Only display the status that actually exists in the attendance data.

IMPORTANT:

Do NOT assume:

No attendance record = Absent.

Clearly distinguish:

Present
Absent
Late
Not Marked

Only show Late if the backend actually supports that state.

==================================================
6. ATTENDANCE SUMMARY
==================================================

The Home screen may show a compact attendance summary.

Example:

Monthly Attendance

3 of 5 recorded days

60%

Present 3
Late 0
Absent 2

But all values must come from actual attendance records.

Do not create fake percentages.

If the current month has no attendance data:

Monthly Attendance

No attendance records available yet.

Do not show:

0%

unless 0% is genuinely calculated from valid recorded attendance data.

Provide a simple action:

[ View Attendance ]

This opens the dedicated Parent Attendance screen.

Do not put the complete attendance history on Home.

==================================================
7. IMPORTANT ATTENTION SECTION
==================================================

This should be one of the most useful parts of the Parent Home.

Create a section only when something genuinely requires parent attention.

Title:

Needs Your Attention

Examples:

Fee payment due
School circular requires acknowledgement
Attendance concern
Exam result published
Important school notice
Document/action pending

Each item should be actionable.

Example:

Fee Payment Due
₹12,500 due
Due in 18 days

[ View Fees ]

Another:

New Report Card Available

Term 2 results are available.

[ View Results ]

IMPORTANT:

Do not create an “attention” item simply because data exists.

Only show items that require or meaningfully benefit from parent attention.

If there is nothing requiring attention:

You’re all caught up.

Do not display an empty large card.

==================================================
8. FEES SUMMARY
==================================================

Fees are important for parents, but the Home screen should show only a summary.

Example:

FEES

₹12,500
Outstanding

Due in 18 days

[ View Fee Details ]

If there are no outstanding fees:

Fees
No outstanding dues

Do not show accountant-style information on Home.

Do not show a large invoice ledger here.

The detailed fee breakdown belongs in:

Fees

The Home card should answer:

“Do I owe anything?”

==================================================
9. ACADEMIC UPDATE
==================================================

Show academic information only when there is meaningful recent information.

Example:

ACADEMIC UPDATE

Term 2 Report Card

Cumulative: 92.4%

[ View Report Card ]

or:

Latest Result

Mathematics
A1

[ View Results ]

Do not show academic KPIs that are not actually supported by the backend.

Avoid unnecessary:

- performance scores
- rankings
- comparison charts
- artificial performance indicators

If no recent academic update exists:

Do not fill the Home screen with fake content.

==================================================
10. SCHOOL COMMUNICATION
==================================================

Parents need important school communication.

Show a compact:

Important Notices

Only show the most relevant 1–2 items.

Example:

School Circular

Winter uniform schedule

Today

[ View All ]

or:

Important Notice

Parent-teacher meeting
Friday, 4:00 PM

[ View Details ]

Do not display a long list of circulars on Home.

Detailed communication belongs under the relevant screen.

==================================================
11. TRANSPORT
==================================================

If the selected child uses school transport and actual transport data exists, show a compact transport card.

Example:

TRANSPORT

Safe Transit Route #4

On Schedule

Bus DL-01-AB-1294

[ View Transport ]

Only show:
- route
- current status
- vehicle information
- driver information

if those fields actually exist and the parent is authorized to see them.

Do NOT show transport if the child does not use transport.

Do NOT create:

“No Transport”

cards that waste space.

If transport is unavailable/not configured, simply omit the section.

==================================================
12. QUICK SERVICES
==================================================

Keep the existing:

STUDENT QUICK SERVICES

Use compact actions.

Recommended:

Student 360
Timetable
Digital ID
Circulars

Only include actions that actually exist.

These should be quick access points, not large dashboard cards.

Use the existing icon system.

Do not introduce random icons.

==================================================
13. STUDENT 360
==================================================

Student 360 should provide access to the selected child's consolidated information.

It may contain:

- student profile
- class/section
- admission information
- academic information
- attendance
- other supported student records

Do not duplicate all of this information on Home.

Home only provides the shortcut.

==================================================
14. TIMETABLE
==================================================

Quick access to the selected child's timetable.

Home may optionally show a tiny contextual preview:

Next Class

Mathematics
10:00 – 10:40

But only if actual timetable data exists.

Do not duplicate the full timetable.

The Timetable screen handles detailed schedule information.

==================================================
15. DIGITAL ID
==================================================

Quick access to the selected child's Digital ID.

Keep this as a shortcut.

Do not expose technical security information on Home.

The actual Digital ID screen should contain only useful identity information and legitimate verification features.

==================================================
16. CIRCULARS
==================================================

Circulars should open the parent's school communication area.

Home should show only important/recent communication.

Do not duplicate the entire circular list.

==================================================
17. WHAT SHOULD NOT BE ON HOME
==================================================

Do NOT add:

- huge analytics dashboards
- school-wide statistics
- teacher information
- administrative KPIs
- class performance charts
- complicated academic graphs
- fee ledger tables
- full attendance history
- complete timetable
- technical sync information
- database IDs
- backend/API information
- unnecessary profile information
- fake “AI insights”
- generic motivational messages

Do not make the parent Home look like an administrator dashboard.

==================================================
18. INFORMATION PRIORITY
==================================================

Use this priority:

HIGH PRIORITY

1. Selected child
2. Today's attendance
3. Needs attention
4. Outstanding fees
5. Important academic update
6. Important school notice

MEDIUM PRIORITY

7. Transport
8. Quick services

LOW PRIORITY

Everything else.

The parent should see the important information without excessive scrolling.

==================================================
19. CARD PRIORITY
==================================================

Do NOT give every section the same visual weight.

The most important information should visually stand out.

Recommended hierarchy:

Child selector
↓
Today's attendance
↓
Needs attention
↓
Fees / Academic updates
↓
Important notices
↓
Transport
↓
Quick services

If there is no data for a section, REMOVE the section rather than showing an empty card.

==================================================
20. RESPONSIVE MOBILE DESIGN
==================================================

This screen must work correctly on:

320px
360px
375px
390px
412px
430px
480px+

Especially optimize for:

320–360px Android phones.

At narrow widths:

- no horizontal page overflow
- no clipped text
- no overlapping cards
- no fixed desktop widths
- no tiny text
- no oversized cards
- no cramped 2-column layouts

Child selector may horizontally scroll.

Quick services may use a compact 2-column or 4-item layout depending on available width.

Do not force four large cards into a narrow screen.

If necessary, allow the quick-service cards to shrink gracefully or become a horizontal scroll.

The PAGE itself must never horizontally scroll.

==================================================
21. SCROLL BEHAVIOR
==================================================

The Home screen should be vertically scrollable.

Keep the header compact.

Keep the child selector accessible near the top.

Do not create deeply nested scroll areas.

Avoid excessive sections.

The user should reach important information quickly.

==================================================
22. LOADING STATE
==================================================

Use skeleton loading.

Do not show fake:

attendance percentages
fees
report cards
transport status

while loading.

Example:

Child selector skeleton

Today's status skeleton

Fee skeleton

Academic update skeleton

==================================================
23. ERROR STATE
==================================================

If a particular data source fails:

Do not make the entire Home unusable.

Example:

Attendance unavailable

[ Retry ]

Other available sections should continue to display.

If the entire Home data fails:

Unable to load your child's information.

[ Retry ]

Do not show technical errors.

==================================================
24. OFFLINE DESIGN
==================================================

The application will support offline operation later.

Design the Home screen so cached information can eventually be displayed.

For example:

Last available attendance
Last available timetable
Last available student information

Do not claim data is current if it is only cached.

Do not display “Synced” unless synchronization actually happened.

The UI should be compatible with future offline-first implementation.

==================================================
25. NOTIFICATION BEHAVIOR
==================================================

Notification badge should reflect actual unread notifications.

Examples:

1
3
9+

If there are no unread notifications:

No badge.

Do not use fake notification counts.

==================================================
26. CHILD SWITCHING BEHAVIOR
==================================================

When the parent changes:

Diya Sharma
→
Aarav Sharma

The screen should refresh all child-specific data.

The transition should be clear but lightweight.

Never leave:

Diya's attendance

combined with:

Aarav's fees

or:

Aarav's timetable.

All child-specific cards must use the currently selected child.

==================================================
27. PARENT PERMISSIONS
==================================================

Only display information the logged-in parent is authorized to view.

Do not expose:

- internal school administration information
- teacher private information
- other students
- internal database information
- private staff notes
- unauthorized student records

Parent Home is strictly scoped to the parent's children and permitted school information.

==================================================
28. EMPTY STATES
==================================================

Use meaningful empty states.

Examples:

No attendance recorded
No outstanding fees
No recent academic updates
No important notices

But prefer:

NO CARD

when an entire section has no meaningful information.

Do not fill the Home screen with multiple “Nothing here” cards.

==================================================
29. DESIGN CONSISTENCY
==================================================

This screen must look like the same product as:

Student Portal
Teacher Portal
Subject Teacher screens
Class Teacher screens

Do not create a separate “Parent theme”.

Maintain the same:

- typography
- spacing
- colors
- cards
- icons
- navigation behavior

The parent role should feel different because of INFORMATION, not because of a completely different visual design.

==================================================
30. BOTTOM NAVIGATION
==================================================

Use the existing Parent navigation:

Portal
Academics
Attendance
Fees
More

Portal must be the active tab.

Do not change the navigation structure unless the existing application already defines a different parent navigation.

==================================================
31. IDEAL PARENT EXPERIENCE
==================================================

The parent opens the app.

They immediately see:

Diya Sharma
Grade 5-A

TODAY

Present
07:48 AM check-in

Then:

Needs Your Attention

Fee payment due
₹12,500
Due in 18 days

Then:

Academic Update

Term 2 Report Card
Available

Then:

Important Notice

Parent-teacher meeting
Friday

Then:

Transport

Route #4
On Schedule

Then:

Student Quick Services

Student 360
Timetable
Digital ID
Circulars

The parent should understand the child's current school status without opening five different screens.

==================================================
32. EXAMPLE FINAL LAYOUT
==================================================

ONPS                         Search  Bell  More

┌───────────────────────────────┐
│ Diya Sharma                   │
│ Grade 5-A                     │
└───────────────────────────────┘

[ Aarav Sharma · Grade 2-B ]

TODAY

┌───────────────────────────────┐
│ Present Today                 │
│ 07:48 AM · Check-in           │
│                               │
│ Monthly Attendance      60%   │
│ 3 of 5 recorded days          │
│                               │
│ Present 3 · Late 0 · Absent 2│
│                               │
│ View Attendance →             │
└───────────────────────────────┘

NEEDS YOUR ATTENTION

┌───────────────────────────────┐
│ Fee Payment Due               │
│ ₹12,500                       │
│ Due in 18 days                │
│                               │
│ View Fees →                   │
└───────────────────────────────┘

ACADEMIC UPDATE

┌───────────────────────────────┐
│ Term 2 Report Card            │
│ Cumulative 92.4%              │
│                               │
│ View Report Card →            │
└───────────────────────────────┘

IMPORTANT NOTICE

Parent-teacher meeting
Friday · 4:00 PM

View Notice →

TRANSPORT

┌───────────────────────────────┐
│ Route #4                      │
│ On Schedule                   │
│ Bus DL-01-AB-1294             │
│                               │
│ View Transport →              │
└───────────────────────────────┘

STUDENT QUICK SERVICES

┌──────────┐ ┌──────────┐
│ Student  │ │ Timetable│
│ 360      │ │          │
└──────────┘ └──────────┘

┌──────────┐ ┌──────────┐
│ Digital  │ │ Circulars│
│ ID       │ │          │
└──────────┘ └──────────┘

Portal | Academics | Attendance | Fees | More

==================================================
33. IMPORTANT DATA RULE
==================================================

The UI must be driven by actual backend data.

Conceptually:

Parent
→ Child / Student
→ Class / Section
→ Attendance
→ Academic Records
→ Fees
→ Timetable
→ Transport
→ Notices

Do not create frontend-only fake relationships.

If the backend does not provide a particular feature:

DO NOT SHOW IT.

If the backend provides the feature but there is no current data:

use an appropriate empty state or omit the card.

==================================================
34. FINAL UX PRINCIPLE
==================================================

The parent Home screen should be:

CLEAR
USEFUL
CALM
FAST
CHILD-CENTRIC

Avoid information overload.

A parent should not have to think:

“Where do I find out what is happening with my child?”

The Home screen should make the answer obvious.

Every card must justify its existence.

If a card does not help the parent understand their child's current school situation or take a useful action, remove it.

==================================================
35. FINAL QUALITY CHECK
==================================================

Before completing the implementation, verify:

- Existing Parent Home visual design is preserved.
- Selected child is always obvious.
- Multiple children work correctly.
- Switching children updates ALL child-specific data.
- Today's attendance is clearly visible.
- Present/Absent/Late/Not Marked are not confused.
- Attendance percentage is based on real records.
- Fees show only real outstanding information.
- Academic updates show only real academic information.
- Important notices are actually relevant.
- Transport appears only when applicable.
- Quick services work for the selected child.
- No unsupported features are added.
- No fake KPIs exist.
- No fake notification counts exist.
- No fake transport status exists.
- No fake academic scores exist.
- No technical/backend information is visible.
- Parent permissions are respected.
- 320px layout works.
- 360px layout works.
- 375px layout works.
- 390px layout works.
- 412px layout works.
- 430px layout works.
- 480px+ layout works.
- No page-level horizontal overflow.
- Long child names work.
- Long notices work.
- Loading states work.
- Error states work.
- Empty states work.
- Offline architecture is supported for future implementation.
- No emojis are used.
- Existing professional icon library is used consistently.
- Bottom navigation remains:
  Portal | Academics | Attendance | Fees | More
- Portal is visibly selected.

MOST IMPORTANT:

Do not make the Parent Home “feature rich” for the sake of appearance.

Make it genuinely useful for a parent checking their child's school status in 10–20 seconds.
