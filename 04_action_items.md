# Action Items: Faculty Timetable Screen Refinement

## 1. Scope & Visual Design Preservation
- [ ] Refine the existing Faculty Timetable screen accessed via Class Teacher Login → Bottom Navigation → Timetable.
- [ ] Preserve the existing approved visual design; do NOT redesign the visual identity.
- [ ] Retain warm ivory background, cocoa/brown primary color, Newsreader / Manrope typography, rounded cards, spacing, borders, shadows, header layout, Material Symbols, and bottom navigation.
- [ ] Avoid introducing gradients, excessive shadows, new color systems, glassmorphism, neon colors, large decorative illustrations, or unnecessary animations.
- [ ] Improve information architecture, hierarchy, usability, and edge cases while keeping the screen visually recognizable.

## 2. Screen Purpose & Role Logic
- [ ] Ensure the screen serves strictly as a practical daily scheduling tool answering:
  - What classes do I have today?
  - Which period is next?
  - What subject am I teaching?
  - Which class/section am I teaching?
  - Where is the class located?
  - What time does the period start and end?
  - Are there free periods or breaks?
- [ ] Avoid turning the timetable into an analytics dashboard or generic KPI screen.
- [ ] Implement unified role logic: display the teacher's actual scheduled teaching periods regardless of whether they act as Class Teacher, Subject Teacher, or both.
- [ ] Do not hardcode the timetable based solely on Class Teacher class assignments.

## 3. Icon System Rules
- [ ] Do NOT use emojis anywhere on the screen.
- [ ] Do NOT use Unicode characters as decorative icons.
- [ ] Use the consistent Material Symbols / Material Icons library with uniform sizing, weights, styles, and alignments.

## 4. Header & Action Controls
- [ ] Maintain the top app bar: Title `Faculty Timetable`, Back button, PDF, Search, Notifications, and More actions.
- [ ] Ensure every header action serves a genuine functional purpose.

## 5. PDF Action
- [ ] Retain the PDF action for timetable export/download if supported by backend/workflow.
- [ ] If PDF generation is not yet implemented, keep the UI ready for future integration without displaying fake download success messages.

## 6. Search Functionality
- [ ] Provide search scoped strictly to the teacher's timetable (search by subject, class, section, room); do not search the entire school database.
- [ ] Hide search if the daily/weekly period count is small to preserve interface simplicity.

## 7. Faculty Identity & Profile Header
- [ ] Display faculty identity block dynamically derived from the authenticated teacher profile (e.g., `Anita Desai`, `Mathematics · Senior Faculty`, avatar/initial `A`).
- [ ] Do not hardcode teacher identity values in production.

## 8. Teacher Subject & Workload Representation
- [ ] Dynamically derive subject and designation lines from the profile, gracefully handling multiple subjects.
- [ ] Calculate workload dynamically from actual timetable data; explain scope clearly (e.g., `Today's Classes: 2` or `Weekly Teaching Slots: 24`).
- [ ] Never hardcode static labels like `2 Teaching Slots` without dynamic backing.

## 9. Academic Session Context
- [ ] Display academic session context (e.g., `2026–27`) derived dynamically from current school session data.
- [ ] Support historical session selection only if authorized and supported by backend.

## 10. Horizontal Date / Day Selector
- [ ] Retain horizontal date/day selector (e.g., `MON 14`, `TUE 15`, `WED 16`, `THU 17`, `FRI 18`, `SAT 19`).
- [ ] Ensure the selected day is visually distinct and controls the timetable displayed below.
- [ ] Use actual calendar dates for the academic session; never use hardcoded date values.

## 11. Date Navigation & Working Week Scoping
- [ ] Scope the selector to the school's actual operating schedule (e.g., Monday–Saturday; exclude non-working days like Sunday unless officially scheduled).
- [ ] Align working days strictly with the academic calendar.

## 12. Today Indicator
- [ ] Clearly mark the current calendar date with a lightweight `Today` label (e.g., `MON 14 Today`) without relying solely on color.

## 13. Week Navigation
- [ ] Provide simple, intuitive week navigation (Previous Week, Current Week, Next Week) without a heavy, complex calendar picker.

## 14. Timetable Content & Card Structure
- [ ] Replace empty state with structured timetable cards when periods exist.
- [ ] Structure card hierarchy:
  1. Period number & start/end time (e.g., `Period 2 • 09:00 – 09:40`)
  2. Subject (e.g., `Mathematics`)
  3. Class / Section (e.g., `Grade 5-A`)
  4. Room / Location (e.g., `Room 204`)
- [ ] Maintain subtle, scannable visual hierarchy without overloading cards.

## 15. Subject, Class / Section & Room Representation
- [ ] Display actual assigned subject and class/section for every period (e.g., Grade 5-A vs Grade 6-B).
- [ ] Display room only when available in timetable data; omit field cleanly if absent (do NOT display `Room TBD` unless explicitly defined by backend).
- [ ] Support special locations where applicable (e.g., `Online`, `Lab 2`, `Auditorium`, `Library`) without fabricating meeting links.

## 16. Current Period State (`LIVE NOW` / `Current Period`)
- [ ] When viewing today's timetable, highlight active period with a subtle `LIVE NOW` or `Current Period` indicator based on real-time clock.
- [ ] Avoid large, disruptive dashboard-style banners.

## 17. Next Period State (`Next`)
- [ ] Highlight the immediate upcoming teaching period today with a clean `Next` indicator.

## 18. Completed Period State (`Completed`)
- [ ] Render past periods today as `Completed` with subtle visual de-emphasis, without inventing artificial timestamps (e.g., avoid `Completed at 09:41`).

## 19. Free Period Handling
- [ ] Display lightweight, visually secondary `Free Period` cards (e.g., `Period 3 • 10:00 – 10:40 • Free Period`) only if backend timetable provides explicit period slots.
- [ ] Do not fabricate free period records if unstructured.

## 20. Break / Lunch Representation
- [ ] Represent non-teaching blocks (Lunch, Break, Assembly) as secondary schedule items (e.g., `Lunch Break • 12:30 – 01:00`).

## 21. Empty States Implementation
- [ ] No classes on selected day: display calendar icon with `No scheduled periods • You have no teaching periods on Monday.`.
- [ ] No classes today: display `No scheduled periods today.`.
- [ ] Timetable not configured: display `Timetable not available • The school timetable has not been configured for this teacher.`.
- [ ] Zero assigned teaching slots: display `No teaching periods assigned.`.
- [ ] Clearly distinguish empty states from loading and error states.

## 22. Loading & Error States
- [ ] Render skeleton cards during data fetching; ensure loading is never confused with an empty timetable.
- [ ] On failure: display `Unable to load timetable. [Retry]` without showing a false empty state.

## 23. Chronological Ordering & Multiple Periods
- [ ] Strictly sort timetable periods chronologically by start time / official period sequence.
- [ ] Never display periods out of sequence (e.g., Period 5 before Period 2).

## 24. Conflict Handling (Overlapping & Duplicate Periods)
- [ ] If data contains overlapping teaching periods, display actual records and flag with `Schedule conflict • Two teaching periods overlap at 10:00 AM.`.
- [ ] Do not silently merge overlapping or duplicate records.

## 25. Class Teacher vs. Subject Teacher Context
- [ ] Do not label every entry as the teacher's Class Teacher section (e.g., avoid labelling everything `Homeroom 5-A`).
- [ ] Show the exact assigned class for each period.

## 26. Attendance Integration & Permissions
- [ ] Provide `[Take Attendance]` action on a timetable card ONLY when:
  - The period is currently active / applicable for attendance
  - The teacher has explicit attendance permissions for that class
- [ ] Do not add attendance buttons to all cards indiscriminately.

## 27. Timetable Card Detail Navigation
- [ ] Allow tapping a timetable card to open a detail view (Subject, Class, Section, Period, Times, Room, Teacher) without slowing down main list scanning.

## 28. PDF / Share & Shell Controls
- [ ] Support `View PDF`, `Download PDF`, and `Share` only when functionality is real; do not display fake success toasts.
- [ ] Wire notification icon to actual teacher notifications; do not invent timetable-specific notifications.
- [ ] Populate More menu strictly with supported options (Refresh, View Week, Export, Settings).

## 29. Day View vs. Week View Architecture
- [ ] Maintain day-focused timetable with horizontal date selector as the primary mobile experience.
- [ ] Offer week view as an optional secondary view if supported; do not force dense desktop tables onto mobile.

## 30. Mobile UX, Touch Targets & Scroll Behavior
- [ ] Optimize for one-handed vertical scrolling on Android phones with readable text and generous touch targets.
- [ ] Keep date selector pinned/accessible while timetable cards scroll smoothly.

## 31. Bottom Navigation Alignment
- [ ] Align with teacher bottom navigation (`Portal`, `Attendance`, `My Class`, `Academics`, `More`), highlighting `Timetable`.

## 32. Data Model & Source of Truth Rules
- [ ] Drive UI strictly from real timetable models (Teacher, Date/Day, Session, Period, Start/End Time, Subject, Class, Section, Room, Status).
- [ ] Do not create fake backend fields or invent data.

## 33. Strict Data Consistency (Workload vs. Displayed Periods)
- [ ] Enforce 100% mathematical consistency: Workload count must match the exact number of displayed timetable cards for the selected day (e.g., if Today's Classes = 2, exactly 2 teaching cards must be shown).

## 34. Privacy & Performance Standards
- [ ] Restrict visible data to timetable information; never expose student personal details, parent phone numbers, medical records, database IDs, UUIDs, or tokens.
- [ ] Maintain fast, lightweight rendering without heavy animations or excessive API requests.
- [ ] Meet accessibility standards: strong contrast, accessible touch targets, and text labels for all status states (avoid color-only coding).

## 35. Deep Testing Verification Checklist
- [ ] Test 1: 2 classes on Monday (exactly 2 cards displayed).
- [ ] Test 2: No classes on Monday ("No scheduled periods on Monday").
- [ ] Test 3: Classes every day (each selected day shows only that day's records).
- [ ] Test 4: Different classes across days (correct class/section per period).
- [ ] Test 5: Multiple subjects taught (correct subject per record).
- [ ] Test 6: Class Teacher of 5-A teaching 6-B (both appear correctly).
- [ ] Test 7: Class Teacher with no subject periods (no fabricated teaching slots).
- [ ] Test 8: Timetable not configured ("Timetable not available").
- [ ] Test 9: Data loading (skeleton cards displayed).
- [ ] Test 10: Data loading failure (Error state + Retry).
- [ ] Test 11: Empty day data (empty state, not error state).
- [ ] Test 12: Current calendar day selected ("Today" indicator visible).
- [ ] Test 13: Past day selected (historical timetable).
- [ ] Test 14: Future day selected (future timetable if supported).
- [ ] Test 15: Academic year changed (reflects selected session).
- [ ] Test 16: Long subject name (no text overflow).
- [ ] Test 17: Long class/section name (no layout break).
- [ ] Test 18: Long teacher name (header remains usable).
- [ ] Test 19: Missing room data (room field omitted cleanly).
- [ ] Test 20: Multiple periods (strictly chronological order).
- [ ] Test 21: Large number of periods (smooth vertical scrolling).
- [ ] Test 22: Overlapping timetable records (conflict banner shown, not hidden).
- [ ] Test 23: Current teaching period (LIVE NOW shown only when time matches).
- [ ] Test 24: Upcoming teaching period ("Next" indicator on next period).
- [ ] Test 25: All periods concluded (no "Next" indicator).
- [ ] Test 26: Free period between classes (free period shown if supported).
- [ ] Test 27: Lunch / Break (secondary non-teaching block shown).
- [ ] Test 28: Take Attendance button (visible only when authorized for period).
- [ ] Test 29: Card tap (opens correct timetable detail).
- [ ] Test 30: Day change (timetable refreshes immediately).
- [ ] Test 31: Week change (correct week data displayed).
- [ ] Test 32: Search by subject (filters matching records only).
- [ ] Test 33: Search by class (filters matching records only).
- [ ] Test 34: Search with no matches (clear empty state).
- [ ] Test 35: PDF action (functional only if export implemented).
- [ ] Test 36: Notification icon (routes to actual notifications).
- [ ] Test 37: Offline state (no false server sync claims).
- [ ] Test 38: Slow network (loading state remains visible, not false empty).
- [ ] Test 39: Duplicate timetable record (represented without artificial merging).
- [ ] Test 40: Zero teaching slots (workload clearly shows zero without fake numbers).

## 36. Current Screen Specific Changes (Keep vs. Improve)
- [ ] KEEP: Faculty Timetable header, Anita Desai profile block, workload area, academic session, horizontal day selector, clean empty state, approved visual design.
- [ ] IMPROVE:
  1. Make workload scope explicit
  2. Make date/day selection data-driven
  3. Show actual timetable cards when periods exist
  4. Show period number
  5. Show start/end time
  6. Show subject
  7. Show class/section
  8. Show room only when available
  9. Clearly distinguish Current / Next / Completed
  10. Handle Free Period / Break only when supported
  11. Improve loading state
  12. Improve error state
  13. Improve empty state
  14. Prevent fake data
  15. Separate Class Teacher from Subject Teacher responsibilities
  16. Keep screen focused on schedule rather than dashboard metrics

## 37. Final Hierarchy & Design Goal Verification
- [ ] Align screen hierarchy: Header → Teacher Identity → Workload / Academic Session → Day Selector → Selected Day → Timetable Cards → Empty / Error / Loading States.
- [ ] Verify rapid schedule scanning, clear time/room details, current/next period awareness, and clean mobile UX without emojis or visual redesign.

---

# Original Prompt

You are refining the existing **Faculty Timetable** screen for a modern School ERP Android application.

The uploaded screenshot is the reference for the current implementation.

IMPORTANT:
The existing visual design is already approved.

DO NOT redesign the application's visual identity.

The goal is to improve the **Faculty Timetable data representation, information hierarchy, timetable usability, and edge-case handling** while preserving the existing visual language.

This screen is accessed through:

Class Teacher Login
→ Bottom Navigation
→ Timetable

==================================================
SCREEN
==================================================

Screen:
Faculty Timetable

Role:
Teacher / Class Teacher

Purpose:
Allow a teacher to view their assigned teaching schedule for the selected academic date.

The timetable must represent the teacher's actual assigned teaching periods.

It should answer:

- What classes do I have today?
- Which period is next?
- What subject am I teaching?
- Which class/section am I teaching?
- Where is the class?
- What time does the period start/end?
- Do I have any free periods?

This is a timetable screen.

It should NOT become another dashboard or analytics screen.

==================================================
IMPORTANT ROLE LOGIC
==================================================

A Class Teacher may also be a Subject Teacher.

Do NOT create a separate timetable experience simply because the user logged in as:

Class Teacher.

The timetable should be based on the teacher's actual timetable assignments.

A teacher may have:

- Class Teacher responsibility
- Subject Teacher responsibility
- Both

The screen should show the teacher's actual scheduled teaching periods.

Do not hardcode the timetable based only on the Class Teacher assignment.

==================================================
VISUAL DESIGN
==================================================

Preserve the existing visual design from the uploaded screen.

Keep:

- existing color palette
- warm ivory background
- cocoa/brown primary color
- typography
- typography hierarchy
- rounded cards
- spacing
- borders
- shadows
- header layout
- Material Symbols icons
- overall visual language
- bottom navigation

Do NOT introduce:

- gradients
- excessive shadows
- new color systems
- glassmorphism
- neon colors
- large decorative illustrations
- unnecessary animations

The application already has an established visual identity.

Improve the information architecture, not the visual identity.

==================================================
ICON RULE
==================================================

DO NOT USE EMOJIS.

Do not use Unicode characters as icons.

Use the existing Material Symbols / Material Icons library.

Icons should be:

- consistent
- simple
- professional
- appropriately sized
- visually aligned

==================================================
CURRENT HEADER
==================================================

Keep the existing top app bar structure.

Current concept:

Faculty Timetable

Left:
Back button

Right:
PDF
Search
Notifications
More

Do not automatically remove these actions.

However, each action must have a real purpose.

==================================================
PDF ACTION
==================================================

If timetable PDF export/download is actually supported:

Keep the PDF action.

Possible behavior:

Export Timetable
or
Download Timetable

If PDF generation is not implemented:

Do not make the icon appear functional.

It can remain part of the prototype if the final UI is being prepared for future API integration, but do not show fake success messages.

==================================================
SEARCH
==================================================

Search should only be included if it is useful for the teacher's timetable.

For a small weekly timetable, search may not be necessary.

If retained:

allow searching by:

- subject
- class
- section
- room

Example:

Search timetable

Do not search the entire school database.

Only search the teacher's timetable.

If there are only a few periods:

consider hiding search to keep the interface simple.

==================================================
FACULTY IDENTITY
==================================================

Keep the faculty identity block.

Example:

Anita Desai

Mathematics · Senior Faculty

Avatar/initial:

A

This information should come from the authenticated teacher profile.

Do NOT hardcode:

Anita Desai

in the production implementation.

==================================================
TEACHER SUBJECT
==================================================

The subject/designation line should represent the actual teacher profile.

Example:

Mathematics · Senior Faculty

Do not assume that a teacher teaches only one subject if the backend supports multiple subjects.

If multiple subjects exist:

display appropriately without making the header unnecessarily large.

==================================================
TEACHER WORKLOAD
==================================================

Current UI:

Workload: 2 Teaching Slots

This can be retained.

But the value must be calculated from actual timetable data.

Do NOT hardcode:

2 Teaching Slots

Possible interpretation:

Today's Teaching Slots

or:

Weekly Teaching Slots

The label must clearly communicate which period is being counted.

For example:

Today's Classes: 2

or:

Weekly Teaching Slots: 24

Do not show a number without explaining the scope.

==================================================
ACADEMIC YEAR
==================================================

Keep:

2026–27

as the academic-year selector/context.

It must come from the current academic session.

Do not hardcode it in production.

If multiple academic sessions are available:

allow the appropriate selection only if the application supports historical timetable viewing.

==================================================
DATE SELECTOR
==================================================

Keep the horizontal date/day selector.

Current concept:

MON
14

TUE
15

WED
16

THU
17

FRI
18

SAT
19

The selected day must be visually distinct.

The selected date controls the timetable shown below.

Do NOT use hardcoded dates.

Use the actual calendar date for the academic session.

==================================================
DATE NAVIGATION
==================================================

The date selector should allow the teacher to move between relevant school days.

If the school operates Monday–Saturday:

show the appropriate school week.

If Sunday is not a school day:

do not necessarily show it as a timetable day.

If the school calendar supports different working days:

follow the actual academic calendar.

==================================================
TODAY INDICATOR
==================================================

If the selected date is today:

clearly indicate:

Today

without making the interface visually heavy.

Example:

MON
14
Today

Do not rely only on the selected color.

==================================================
WEEK NAVIGATION
==================================================

If the teacher needs to view another week:

provide a simple week navigation mechanism.

Possible:

Previous Week
Current Week
Next Week

Do not add a complicated calendar unless required.

The main goal is fast timetable viewing.

==================================================
TIMETABLE CONTENT
==================================================

When teaching periods exist, replace the current empty state with timetable cards.

Each timetable item should contain:

Period number
Time
Subject
Class / Section
Room

Example:

Period 2

09:00 – 09:40

Mathematics

Grade 5-A

Room 204

The information hierarchy should be:

1. Period / time
2. Subject
3. Class / section
4. Room

==================================================
TIMETABLE CARD
==================================================

Recommended structure:

--------------------------------
Period 2
09:00 – 09:40

Mathematics

Grade 5-A
Room 204
--------------------------------

Use subtle visual hierarchy.

Do not overload the card.

==================================================
SUBJECT
==================================================

The subject should come from the actual timetable assignment.

Example:

Mathematics

Do not invent subjects.

If the timetable contains multiple subjects:

each period should show its actual subject.

==================================================
CLASS / SECTION
==================================================

Always show the class/section where useful.

Example:

Grade 5-A

or:

Class 5-A

This is especially important because a teacher may teach multiple classes.

Do not assume every period belongs to the Class Teacher's own class.

For example:

Teacher:
Anita Desai

Class Teacher:
5-A

Monday:

Period 2 → Mathematics → 5-A
Period 5 → Mathematics → 6-B

Both should appear if both are actual timetable assignments.

==================================================
ROOM
==================================================

Show room/location when actual timetable data provides it.

Example:

Room 204

If room information does not exist:

do not show:

Room TBD

unless the backend explicitly represents it as TBD.

Simply omit the field.

==================================================
ONLINE / SPECIAL CLASS
==================================================

If the timetable supports special locations such as:

Online
Lab
Auditorium
Library

show the actual location.

Do not invent meeting links.

==================================================
CURRENT PERIOD
==================================================

If the selected date is today and the current time falls within a scheduled period:

clearly indicate:

LIVE NOW

or:

Current Period

Example:

Period 2
09:00 – 09:40

Mathematics
Grade 5-A
Room 204

CURRENT

The current-period state should be subtle but noticeable.

Do not create a large dashboard-style banner.

==================================================
NEXT PERIOD
==================================================

If there is an upcoming teaching period today:

clearly indicate:

Next

Example:

NEXT

Period 5
11:50 – 12:30

Mathematics
Grade 6-B
Room 108

This helps the teacher quickly understand what is coming next.

==================================================
COMPLETED PERIOD
==================================================

Past periods may show:

Completed

or simply remain normal with a subtle visual distinction.

Do not add unnecessary timestamps such as:

Completed at 09:41

unless actual attendance/timetable data supports this.

==================================================
FREE PERIOD
==================================================

If there is a gap between two teaching periods:

show a lightweight:

Free Period

Example:

Period 3
10:00 – 10:40

Free Period

Do not make free periods visually compete with teaching periods.

If the backend does not provide explicit period structure:

do not fabricate free-period records.

==================================================
BREAK / LUNCH
==================================================

If the timetable contains:

Lunch
Break
Assembly

represent them as non-teaching schedule blocks.

Example:

Lunch Break
12:30 – 01:00

Keep these visually secondary.

==================================================
NO SCHEDULED PERIODS
==================================================

The current screen shows:

No scheduled periods on Mon

This empty state is correct when the selected day genuinely has no classes.

Improve the presentation slightly:

[calendar icon]

No scheduled periods

You have no teaching periods on Monday.

Do not show a fake timetable card.

Do not show:

0 classes

unless useful.

==================================================
NO SCHEDULE FOR TODAY
==================================================

If today has no classes:

show:

No scheduled periods today.

This should be clearly distinguished from:

data failed to load.

==================================================
DATA LOADING
==================================================

When timetable data is loading:

show skeleton timetable cards.

Do not immediately show:

No scheduled periods

while data is still loading.

Important:

Loading
≠
Empty

==================================================
DATA ERROR
==================================================

If timetable loading fails:

Unable to load timetable.

Retry

Do not display:

No scheduled periods

because the data may simply be unavailable.

==================================================
NO TIMETABLE CONFIGURED
==================================================

If the school has not configured the teacher timetable:

show:

Timetable not available

The school timetable has not been configured for this teacher.

Do not represent this as:

No scheduled periods

because these are different states.

==================================================
TEACHER WITH NO TEACHING SLOTS
==================================================

If a teacher genuinely has no assigned teaching periods:

show:

No teaching periods assigned.

Do not fabricate workload numbers.

==================================================
MULTIPLE PERIODS
==================================================

If the teacher has many periods in a day:

show them in chronological order.

Example:

Period 1
08:00 – 08:40
Mathematics
5-A

Period 2
08:40 – 09:20
Mathematics
6-A

Period 4
10:10 – 10:50
Mathematics
7-B

Do not reorder based on subject or class.

Always use timetable order.

==================================================
CHRONOLOGICAL ORDER
==================================================

Timetable periods must be sorted by:

start time

or official period sequence.

Never display:

Period 5
before
Period 2

unless the actual timetable structure explicitly requires it.

==================================================
OVERLAPPING PERIODS
==================================================

If backend data contains overlapping periods:

do not silently merge them.

Show the actual records and, where appropriate, flag the conflict.

Example:

Schedule conflict

Two teaching periods overlap at 10:00 AM.

This should be an administrative/data issue, not silently hidden by the UI.

==================================================
DUPLICATE PERIOD
==================================================

If duplicate timetable records exist:

do not artificially combine them unless the backend defines them as duplicates.

The UI should preserve the source data accurately.

==================================================
CLASS TEACHER CONTEXT
==================================================

If the teacher is Class Teacher of 5-A:

do not automatically show every timetable entry as:

Homeroom 5-A.

Only show the actual class assigned to that period.

Class Teacher status and teaching timetable are related but not identical.

==================================================
ATTENDANCE CONNECTION
==================================================

If a current teaching period is an attendance-taking period and the actual application supports attendance integration:

provide an appropriate action:

Take Attendance

This should only appear when:

- attendance is applicable
- teacher is authorized
- the period/class supports attendance

Do not automatically add a Take Attendance button to every timetable card.

==================================================
ATTENDANCE PERMISSION
==================================================

Do not assume every teacher can take attendance for every class.

Follow the actual attendance permission rules.

For Class Teacher attendance:

the Class Teacher should be able to access the appropriate class attendance workflow.

For Subject Teacher:

only provide attendance functionality if the actual system authorizes it.

==================================================
TIMETABLE CARD ACTIONS
==================================================

A timetable card may open a detail view.

Possible detail information:

Subject
Class
Section
Period
Start time
End time
Room
Teacher

Do not add unsupported information.

Keep the main timetable screen fast.

==================================================
PDF / SHARE
==================================================

If supported:

allow:

View PDF
Download PDF
Share

Do not show these actions if they do not exist.

Do not display fake download completion messages.

==================================================
NOTIFICATION ICON
==================================================

Keep notification icon only as part of the application shell.

It should open actual teacher notifications.

Do not create fake timetable notifications.

==================================================
MORE MENU
==================================================

Use the existing More icon only for real secondary actions.

Potential actions:

- Refresh
- View Week
- Export
- Settings

Only include actions that actually exist.

Do not fill the menu with unnecessary options.

==================================================
WEEK VIEW VS DAY VIEW
==================================================

The current UI is a day-focused timetable with a horizontal date selector.

Keep this as the primary experience.

If a weekly overview is useful and supported:

provide it as a secondary view.

Example:

Day View
Week View

Do not force a dense weekly grid onto the mobile screen.

The primary Android experience should remain easy to scan.

==================================================
MOBILE UX
==================================================

This is an Android phone screen.

Optimize for:

- one-handed use
- vertical scrolling
- readable text
- large enough touch targets
- clear date selection
- easy period scanning

Avoid desktop timetable grids.

Avoid tiny text.

Avoid horizontally scrolling complex tables.

==================================================
SCROLL BEHAVIOR
==================================================

The timetable list should scroll naturally.

The teacher identity/header may remain static where appropriate.

The day selector can remain visible if it improves usability.

Do not consume excessive vertical space with repeated headers.

==================================================
BOTTOM NAVIGATION
==================================================

This screen is opened from the Teacher application's bottom navigation:

Portal
Attendance
My Class
Academics
More

The active section should be:

Timetable

If Timetable is a secondary feature under More rather than a primary bottom-nav item, maintain the application's existing navigation architecture.

Do not create a separate bottom-navigation system just for timetable.

==================================================
DATA SOURCE RULE
==================================================

The UI must be driven by actual timetable records.

Do not hardcode:

- teacher name
- subject
- class
- room
- workload
- academic year
- date
- period times
- number of teaching slots

Prototype mock data is acceptable for UI generation/testing.

But mock data must behave like real structured records.

==================================================
DATA MODEL CONCEPT
==================================================

Each timetable record should conceptually contain information such as:

Teacher
Date / Day
Academic Session
Period
Start Time
End Time
Subject
Class
Section
Room
Status

Only use fields that actually exist in the project's backend.

Do NOT create fake backend fields just to populate the UI.

==================================================
IMPORTANT DATA CONSISTENCY
==================================================

The following values must always agree:

Workload
+
Displayed timetable periods
+
Selected date
+
Teacher assignment

Example:

If the selected Monday contains 2 teaching periods:

Today's Classes: 2

and exactly 2 timetable cards should be visible.

Do NOT show:

Workload: 2 Teaching Slots

while showing 0 or 5 actual Monday periods.

==================================================
NO FAKE DATA
==================================================

Never create fake:

- teaching periods
- rooms
- classes
- subjects
- attendance
- workload
- schedule conflicts
- notifications
- PDF downloads
- synchronization messages

Realistic mock data can be used for prototype rendering, but it must be internally consistent.

==================================================
PRIVACY
==================================================

Only show teacher/student information required for the timetable.

Do not expose:

- student personal details
- parent phone numbers
- medical information
- internal IDs
- database IDs
- API IDs
- authentication tokens
- technical synchronization identifiers

==================================================
PERFORMANCE
==================================================

The screen should remain lightweight.

Avoid:

- unnecessary animations
- huge illustrations
- complex charts
- excessive network calls
- unnecessary API requests for every card

The timetable should load quickly.

==================================================
ACCESSIBILITY
==================================================

Ensure:

- readable contrast
- adequate touch targets
- clear selected-day state
- text labels for important states
- icons are not the only indication of meaning

Do not communicate important information through color alone.

==================================================
DEEP TESTING
==================================================

Before finalizing the screen, test all of the following.

TEST 1
Teacher has 2 classes on Monday.

Expected:
Exactly 2 timetable records displayed.

TEST 2
Teacher has no classes Monday.

Expected:
No scheduled periods on Monday.

TEST 3
Teacher has classes every day.

Expected:
Each selected day displays only that day's periods.

TEST 4
Teacher has different classes on different days.

Expected:
Correct class/section appears for each period.

TEST 5
Teacher teaches multiple subjects.

Expected:
Correct subject appears for each timetable record.

TEST 6
Teacher is Class Teacher of 5-A but teaches 6-B.

Expected:
Timetable correctly shows both where assigned.

TEST 7
Teacher is only Class Teacher and has no subject periods.

Expected:
Timetable does not fabricate teaching slots.

TEST 8
Teacher has no timetable configured.

Expected:
Timetable not available state.

TEST 9
Timetable API/data loading.

Expected:
Skeleton/loading state.

TEST 10
Timetable data request fails.

Expected:
Error state + Retry.

TEST 11
Data returns empty for Monday.

Expected:
Empty state, not error state.

TEST 12
Current day.

Expected:
Today indicator.

TEST 13
Past day.

Expected:
Historical timetable.

TEST 14
Future day.

Expected:
Future timetable only if the school data supports it.

TEST 15
Academic year changes.

Expected:
Timetable reflects selected/current academic session.

TEST 16
Long subject name.

Expected:
No overflow.

TEST 17
Long class/section name.

Expected:
No layout break.

TEST 18
Long teacher name.

Expected:
Header remains usable.

TEST 19
Missing room.

Expected:
Room field omitted rather than displaying fake information.

TEST 20
Multiple periods.

Expected:
Chronological order.

TEST 21
Large number of periods.

Expected:
Smooth vertical scrolling.

TEST 22
Two overlapping timetable records.

Expected:
Conflict is not silently hidden.

TEST 23
Current teaching period.

Expected:
Current/Live state only when current time actually falls within the period.

TEST 24
Upcoming teaching period.

Expected:
Next state only for the actual next period.

TEST 25
All periods completed.

Expected:
No "Next" state.

TEST 26
Free period between classes.

Expected:
Free period shown only if period structure supports it.

TEST 27
Lunch/break.

Expected:
Secondary non-teaching schedule block.

TEST 28
Take Attendance action.

Expected:
Visible only when teacher has attendance permission and the period supports it.

TEST 29
Teacher taps a timetable card.

Expected:
Correct timetable detail opens.

TEST 30
Teacher changes day while viewing timetable.

Expected:
Correct timetable data refreshes immediately.

TEST 31
Teacher changes week.

Expected:
Correct week data displayed.

TEST 32
Search by subject.

Expected:
Only matching teacher timetable records.

TEST 33
Search by class.

Expected:
Only matching records.

TEST 34
Search with no results.

Expected:
Clear empty state.

TEST 35
PDF action.

Expected:
Only works if PDF generation/export is implemented.

TEST 36
Notification icon.

Expected:
Opens actual notification area.

TEST 37
Offline.

Expected:
Do not falsely claim timetable was refreshed from server.

TEST 38
Slow network.

Expected:
Loading state remains clear and does not show false empty state.

TEST 39
Duplicate timetable record.

Expected:
Data is represented consistently without fake merging.

TEST 40
Teacher has zero teaching slots.

Expected:
No fake workload value.

==================================================
CURRENT SCREEN SPECIFIC CHANGES
==================================================

Starting from the uploaded screenshot:

KEEP:

Faculty Timetable
Anita Desai
Mathematics · Senior Faculty
Workload
Academic Year
Horizontal day selector
Clean empty state
Existing visual design

IMPROVE:

1. Make workload scope explicit.
2. Make date/day selection data-driven.
3. Show actual timetable cards when periods exist.
4. Show period number.
5. Show start/end time.
6. Show subject.
7. Show class/section.
8. Show room only when available.
9. Clearly distinguish Current / Next / Completed where appropriate.
10. Handle Free Period / Break only when supported.
11. Improve loading state.
12. Improve error state.
13. Improve empty state.
14. Prevent fake data.
15. Keep Class Teacher and Subject Teacher responsibilities separate.
16. Keep the screen focused on timetable rather than dashboard metrics.

==================================================
RECOMMENDED FINAL HIERARCHY
==================================================

The screen should visually follow:

HEADER
Faculty Timetable

↓

TEACHER IDENTITY
Anita Desai
Mathematics · Senior Faculty

↓

WORKLOAD / ACADEMIC SESSION
Today's Classes: 2
2026–27

↓

DAY SELECTOR
MON 14
TUE 15
WED 16
THU 17
FRI 18
SAT 19

↓

SELECTED DAY

Monday

↓

TIMETABLE

Period 2
09:00 – 09:40
Mathematics
Grade 5-A
Room 204

Period 5
11:50 – 12:30
Mathematics
Grade 6-B
Room 108

↓

EMPTY / ERROR / LOADING STATE
when applicable

==================================================
FINAL DESIGN GOAL
==================================================

The final Faculty Timetable screen should feel like a professional teacher's daily scheduling tool.

It should answer the teacher's questions immediately:

"What do I teach today?"

"Which class?"

"Which period?"

"What time?"

"Where?"

"What is my next class?"

At the same time, it must remain visually consistent with the existing School ERP design.

DO NOT redesign the entire UI.

DO NOT add unnecessary dashboard KPIs.

DO NOT invent timetable data.

DO NOT invent attendance permissions.

DO NOT invent rooms.

DO NOT invent notifications.

DO NOT invent PDF functionality.

DO NOT use emojis.

DO NOT expose backend/database information.

DO NOT create separate timetable logic for Class Teacher and Subject Teacher.

Use the teacher's actual timetable assignments as the source of truth.

The priority is:

ACCURATE TIMETABLE DATA
+
FAST DAILY SCHEDULE SCANNING
+
CLEAR CLASS/SUBJECT/TIME INFORMATION
+
CURRENT/NEXT PERIOD CONTEXT
+
CLEAN MOBILE UX
+
CONSISTENCY WITH THE EXISTING SCHOOL ERP DESIGN
