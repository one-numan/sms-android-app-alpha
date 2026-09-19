# Action Items: Subject Teacher – Attendance Screen Design & Implementation

## 1. Scope & Design System Preservation
- [ ] Design and implement the "Subject Teacher – Attendance" screen for the existing School ERP mobile application.
- [ ] Preserve the existing approved visual design system:
  - Color palette, typography, font hierarchy, card style, border radius, spacing, buttons, navigation, header style, and icon style.
  - Material Symbols / Material Icons and overall visual language.
- [ ] Do NOT redesign the visual identity.
- [ ] Focus strictly on improving usability, information hierarchy, and real-world attendance workflow.

## 2. Subject Teacher Role & Permission Boundaries
- [ ] Tailor the screen strictly for the **Subject Teacher** role across assigned subjects, classes, and sections.
- [ ] Display attendance only for classes/subjects the logged-in teacher is authorized to access.
- [ ] Do NOT assume all subject teachers can mark attendance; enforce backend permissions:
  - If subject-period marking is allowed: provide attendance marking workflow.
  - If view-only: render as a view/information workspace.
  - If unauthorized: do not expose marking controls.
- [ ] Keep Class Teacher attendance responsibilities strictly separate; do not grant Class Teacher permissions to Subject Teachers.

## 3. Primary Purpose & Operational Focus
- [ ] Structure the screen to answer: "Which class/subject am I dealing with, what attendance is relevant right now, and what action can I perform?".
- [ ] Prioritize:
  1. Today's relevant attendance
  2. Current / next teaching assignment
  3. Class + section
  4. Subject
  5. Student attendance status
  6. Attendance history where supported
- [ ] Avoid building an analytics-heavy dashboard.

## 4. Screen Structure & Vertical Hierarchy
- [ ] Organize layout strictly by hierarchy:
  1. HEADER
  2. DATE
  3. SUBJECT / CLASS CONTEXT
  4. CURRENT OR NEXT CLASS
  5. ATTENDANCE ACTION
  6. STUDENT LIST
  7. ATTENDANCE HISTORY / SUMMARY
  8. BOTTOM NAVIGATION
- [ ] Keep the screen practical, lightweight, and fast.

## 5. Header Specifications
- [ ] Use existing application header layout.
- [ ] Set title to `Attendance`.
- [ ] Include standard shell controls: notification, profile, and back navigation.
- [ ] Hide technical metadata (API status, database IDs, employee IDs, sync timestamps, internal system identifiers).

## 6. Date Selector & Day Navigation
- [ ] Clearly display selected date (e.g., `Today • Wednesday, 25 Oct 2026`).
- [ ] Provide a compact date control with previous, current, and next day actions (e.g., `< Wed, 25 Oct >`).
- [ ] If the selected date is current, explicitly display `Today`.
- [ ] Avoid oversized calendar widgets on mobile.

## 7. Teaching Context Selectors (Subject, Class, Section)
- [ ] Provide compact selectors for Subject, Class, and Section (e.g., `[ Mathematics ▼ ] [ Grade 5-A ▼ ]`).
- [ ] If only one assignment exists, display it automatically without forcing unnecessary dropdown interactions.
- [ ] Prevent combining subject and class into a single ambiguous dropdown when multiple assignments exist.

## 8. Current / Next Class Context Card
- [ ] When timetable data exists, display a compact contextual card:
  - `CURRENT CLASS`: Subject, Class, Period, Time, Room, and `[ Take Attendance ]` action (e.g., `Mathematics • Grade 5-A • Period 2 · 09:10–09:50 • Room 204`).
  - `NEXT CLASS`: Subject, Class, Time, and `[ View Attendance ]` (e.g., `Mathematics • Grade 6-B • 10:30 – 11:10`).
- [ ] Only show card when backed by real timetable records; omit section cleanly if data is absent.
- [ ] Do NOT fabricate room numbers, period times, status banners, or countdowns.

## 9. Attendance Snapshot & Counter Semantics
- [ ] Provide a compact summary before the student list (e.g., `32 Students • 29 Present • 2 Absent • 1 Not Marked`).
- [ ] Strictly treat `Not Marked` as distinct from `Absent`; never classify unrecorded students as absent.
- [ ] Display additional states (`Late`, `Excused`, `On Leave`) only if supported by the backend model.

## 10. Attendance Action Workflow
- [ ] Provide `[ Mark All Present ]` as a convenience draft action (not auto-submitting).
- [ ] Allow individual student status changes after marking all present.
- [ ] Display `All students marked` with `[ Submit Attendance ]` once all records are filled.
- [ ] If already submitted, display `Attendance Submitted`; do not repeatedly show an active Submit button if no changes exist.

## 11. Student List & Compact Marking Controls
- [ ] Core student rows must display:
  - Roll number
  - Student full name
  - Current attendance state
  - Fast, compact controls (`[ Present ] [ Absent ]` or `[ Present ] [ Absent ] [ Late ]` if supported)
- [ ] Avoid oversized cards; optimize for rapid classroom marking.

## 12. Search Functionality & Standards
- [ ] Provide compact `Search students` input supporting search by student name and roll number.
- [ ] Use a proper search icon (do NOT use a microphone icon as a search/clear substitute).
- [ ] Provide a clear (`×`) button when text is entered.

## 13. Filter Chips & Horizontal Scrolling
- [ ] Provide simple attendance filters: `All`, `Not Marked`, `Present`, `Absent` (plus `Late`, `Leave`, `Excused` if supported).
- [ ] Display counts on chips (e.g., `[ All 32 ] [ Not Marked 1 ] [ Present 29 ] [ Absent 2 ]`).
- [ ] Make filter chip row horizontally scrollable without causing full-page horizontal overflow.

## 14. Student Detail View & Privacy Boundaries
- [ ] Tapping a student row optionally opens a compact detail bottom sheet showing: Student Name, Roll Number, Current Status, and Attendance History.
- [ ] Omit sensitive personal data (internal database IDs, technical tokens, confidential notes, medical diagnoses, guardian contact info) from the attendance view.

## 15. Attendance History Presentation
- [ ] Provide clear chronological attendance history for the selected student, subject, and class (Date + Status, e.g., `25 Oct: Present`, `24 Oct: Present`, `23 Oct: Absent`).
- [ ] Avoid complex or heavy analytics charts.

## 16. Subject-Specific Attendance Scoping
- [ ] Explicitly display attendance relationship: `Subject + Class + Section + Date` (e.g., `Mathematics • Grade 5-A • 25 Oct 2026`).
- [ ] Do not accidentally display or mix class-wide daily roll call data with subject-period attendance.

## 17. Class Teacher vs. Subject Teacher Separation
- [ ] Maintain clean workflow separation for teachers with dual assignments.
- [ ] Do not show "Mark Class Attendance" to a Subject Teacher lacking Class Teacher permissions.

## 18. Already Submitted State & Modification Permissions
- [ ] If attendance for the selected context is submitted:
  - Display `Attendance Submitted` and final summary (e.g., `32 Students • 30 Present • 2 Absent`).
  - Provide `[ View / Edit ]` action only if authorized to modify submitted records.

## 19. Unsaved Changes Visual State & Navigation Guards
- [ ] Display `Unsaved changes` indicator when draft changes are pending submission.
- [ ] Prompt with confirmation dialog (`You have unsaved attendance changes. [ Stay ] [ Leave ]`) if navigating away with unsaved edits.
- [ ] Prevent silent data loss.

## 20. Empty States Implementation
- [ ] No assignments: `No attendance classes available. Your assigned classes and subjects will appear here.`.
- [ ] No students: `No students found for this class.`.
- [ ] No attendance recorded: `Attendance has not been marked for this date.`.
- [ ] Do not display fake students or artificial counters.

## 21. Loading & Error States
- [ ] Render skeleton placeholders matching date, context selectors, and student list items during loading.
- [ ] On failure: display `Unable to load attendance. [ Retry ]` without exposing stack traces, API exceptions, or technical errors.

## 22. Future Offline Compatibility
- [ ] Architect UI to distinguish locally saved drafts from server-submitted records in future offline updates.
- [ ] Never display `Synced` unless actual synchronization has occurred.

## 23. Mobile Responsiveness & Touch Target Standards
- [ ] Test and support widths: 320px, 360px, 375px, 390px, 412px, 430px, 480px+.
- [ ] Enforce single-column layout on 320–360px; avoid desktop-style tables or cramped grids.
- [ ] Ensure minimum 44px touch targets for all buttons, chips, and controls.
- [ ] Prevent horizontal page scrolling (only filter chips scroll horizontally).
- [ ] Allow graceful wrapping for student names without clipping roll numbers or buttons.

## 24. Large Class Performance & Scalability
- [ ] Implement smooth, performant vertical scrolling capable of handling 10, 30, 50, and 100+ students without lag or nested scroll traps.

## 25. Bottom Navigation Integration
- [ ] Use Subject Teacher navigation: `Portal | Academics | Attendance | Timetable | More`.
- [ ] Ensure `Attendance` is visibly active.
- [ ] Do NOT modify navigation for Student, Class Teacher, Admin, Superadmin, or Parent.

## 26. Cross-Screen Deduplication Guardrails
- [ ] Do not turn Attendance into a timetable, academic marks ledger, fee console, or class teacher hub.
- [ ] Limit timetable data to the compact current/next class contextual card.

## 27. Privacy Protection & Medical Shielding
- [ ] Exclude medical diagnoses, prescriptions, guardian chats, and private student notes from the attendance roster.

## 28. Professional Icon System Standards
- [ ] Use Material Symbols / Material Icons consistently (`calendar`, `search`, `chevron`, `check`, `close`, `history`, `filter_list`, `arrow_back`, `arrow_forward`).
- [ ] Do NOT use emojis or mixed icon styles.

## 29. Visual Priority Order
- [ ] Structure visual weight:
  1. Date
  2. Subject + Class + Section
  3. Attendance status
  4. Student list
  5. Marking controls
  6. Submit / save state
  7. History

## 30. Ideal 7-Step User Flow Alignment
- [ ] Verify complete operational flow:
  1. Open Attendance (Today auto-selected)
  2. Assigned subject/class context displayed
  3. Live status summary visible (Present / Absent / Not Marked)
  4. Search or scroll students
  5. Mark attendance (counters update immediately)
  6. Review draft summary
  7. Submit attendance with clear confirmation

## 31. Final Product Principle Verification
- [ ] Ensure screen is FAST, CLEAR, ACCURATE, EASY TO MARK, and EASY TO REVIEW.
- [ ] Restrict features strictly to supported models: Teacher assignments, Class, Section, Subject, Student, Attendance, Timetable, and Permissions.
- [ ] Deliver a production-quality Subject Teacher attendance workspace without emojis or visual redesign.

---

# Original Prompt

Design and implement the “Subject Teacher – Attendance” screen for the existing School ERP mobile application.

IMPORTANT:
This is an existing School ERP application.

Do NOT redesign the visual system.

Preserve exactly the existing:
- color palette
- typography
- font hierarchy
- card style
- border radius
- spacing
- buttons
- navigation
- header style
- icon style
- Material Symbols / Material Icons
- overall visual language

The goal is to improve usability, information hierarchy, and real-world attendance workflow.

==================================================
1. ROLE
==================================================

This screen is specifically for a SUBJECT TEACHER.

A subject teacher may teach:
- one subject
- multiple subjects
- multiple classes
- multiple sections

The screen must display attendance only for classes/subjects that the logged-in teacher is actually authorized to access.

Do NOT assume that every subject teacher can mark attendance for every class.

Use the existing backend permission and assignment model.

IMPORTANT:
The project defines Class Teacher attendance responsibility separately.

Do not silently give Subject Teachers Class Teacher attendance permissions.

If the existing backend allows a subject teacher to mark subject-period attendance, show that workflow.

If the backend only allows the Class Teacher to mark daily class attendance, the Subject Teacher screen should be a VIEW/attendance-information workspace rather than inventing marking permissions.

==================================================
2. PRIMARY PURPOSE
==================================================

The screen should answer:

“Which class/subject am I dealing with, what attendance is relevant right now, and what action can I perform?”

Prioritize:

1. Today's relevant attendance
2. Current/next teaching assignment
3. Class + section
4. Subject
5. Student attendance status
6. Attendance history where supported

Do NOT create an analytics-heavy attendance dashboard.

==================================================
3. SCREEN HIERARCHY
==================================================

Use:

HEADER
↓
DATE
↓
SUBJECT / CLASS CONTEXT
↓
CURRENT OR NEXT CLASS
↓
ATTENDANCE ACTION
↓
STUDENT LIST
↓
ATTENDANCE HISTORY / SUMMARY
↓
BOTTOM NAVIGATION

Keep the screen practical and fast.

==================================================
4. HEADER
==================================================

Use the existing application header.

Title:

Attendance

Show the existing:
- notification
- profile
- navigation behavior

Do not add technical information.

Do not show:
- API status
- database IDs
- employee IDs
- sync timestamps
- internal system identifiers

==================================================
5. DATE
==================================================

Show the selected attendance date clearly.

Example:

Today
Wednesday, 25 Oct 2026

Provide a simple date selector.

Allow:

Previous day
Selected date
Next day

Do not create an oversized calendar.

For mobile, a compact date control is preferred.

Example:

<   Wed, 25 Oct   >

If the date is today, clearly indicate:

Today

==================================================
6. TEACHING CONTEXT
==================================================

The teacher must be able to select the relevant:

Subject
Class
Section

Use compact selectors.

Example:

Subject
Mathematics ▼

Class
Grade 5-A ▼

If there is only one assignment, do not force unnecessary selection.

Automatically display the assignment.

If multiple assignments exist:

[ Mathematics ▼ ]
[ Grade 5-A ▼ ]

Do not combine everything into one confusing dropdown.

==================================================
7. CURRENT / NEXT CLASS
==================================================

If timetable data exists, show a compact contextual card:

CURRENT CLASS

Mathematics
Grade 5-A

Period 2
09:10 – 09:50

Room 204

[ Take Attendance ]

Only display:
- current period
- subject
- class
- room

when actual timetable data exists.

Do NOT invent:
- room numbers
- period times
- current status
- countdowns

If there is no current class:

NEXT CLASS

Mathematics
Grade 6-B

10:30 – 11:10

[ View Attendance ]

If timetable data is unavailable, omit this section.

==================================================
8. ATTENDANCE STATUS
==================================================

Before the student list, provide a compact summary.

Example:

Attendance

32 Students

Present     29
Absent       2
Not Marked   1

IMPORTANT:

Do not assume “Not Marked” means Absent.

Use separate states:

Present
Absent
Not Marked

Only show additional states such as:

Late
Excused
On Leave

if those states actually exist in the backend attendance model.

Do not manufacture them.

==================================================
9. ATTENDANCE ACTION
==================================================

If the teacher has permission to mark attendance, provide:

[ Mark All Present ]

Then allow individual changes.

This should be a convenience action, not the final submission.

The teacher must still be able to review the list before submitting.

If all students are marked:

All students marked

[ Submit Attendance ]

If attendance has already been submitted:

Attendance Submitted

Do not repeatedly show a “Submit” button if there are no changes.

==================================================
10. STUDENT LIST
==================================================

The student list is the core of this screen.

Each student row/card should contain:

Student name
Roll number

Current attendance state

Example:

01
Aarav Agarwal

Present

or:

02
Ananya Dixit

Absent

Use compact controls.

Recommended interaction:

[ Present ] [ Absent ]

If additional valid states exist:

[ Present ] [ Absent ] [ Late ]

Do not create huge cards for every student.

The teacher should be able to mark attendance quickly.

==================================================
11. SEARCH
==================================================

For classes with many students, provide:

Search students

Search by:

- student name
- roll number

The search field should be compact.

Do not use a microphone icon as a search/clear substitute.

Use a proper search icon.

Provide a clear button when text is entered.

==================================================
12. FILTERS
==================================================

Provide simple attendance filters:

All
Not Marked
Present
Absent

Only add:

Late
Leave
Excused

if supported by the actual attendance system.

Example:

[ All 32 ] [ Not Marked 1 ] [ Present 29 ] [ Absent 2 ]

Make the filter row horizontally scrollable on narrow screens.

Do not allow the filters to create horizontal page overflow.

==================================================
13. STUDENT DETAIL
==================================================

Tapping a student may open a small detail view/bottom sheet.

Show useful information such as:

Student Name
Roll Number
Current Status
Attendance history

Only include information actually available and authorized.

Do not expose unnecessary personal information.

Do not show:
- internal database IDs
- technical identifiers
- confidential notes
- medical information
- guardian contact information

unless the existing authorized workflow explicitly requires it.

==================================================
14. ATTENDANCE HISTORY
==================================================

Provide access to historical attendance only if supported.

Example:

Attendance History →

For the selected:

Student
Subject
Class

Possible information:

Date
Status

Example:

25 Oct
Present

24 Oct
Present

23 Oct
Absent

Do not turn this into a complicated analytics chart.

A teacher primarily needs clear records.

==================================================
15. SUBJECT-SPECIFIC ATTENDANCE
==================================================

This is important.

If the backend tracks attendance against:

Subject + Class + Section + Date

make that relationship explicit.

Example:

Mathematics
Grade 5-A
25 Oct 2026

Do not accidentally display class-wide attendance when the teacher is working with subject attendance.

The UI must clearly communicate the attendance scope.

==================================================
16. CLASS TEACHER VS SUBJECT TEACHER
==================================================

A teacher can be both:

Class Teacher
and
Subject Teacher.

Do not create two accounts.

Do not mix their workflows.

If this user is operating in the Subject Teacher Attendance section:

show the attendance workflow permitted for the subject assignment.

If daily class attendance is restricted to the Class Teacher:

do not show:

“Mark Class Attendance”

to a Subject Teacher who lacks that permission.

Instead show the appropriate available information/action.

Permission must come from the actual application rules.

==================================================
17. ALREADY SUBMITTED
==================================================

If attendance for the selected subject/class/date has already been submitted:

Show:

Attendance Submitted

and the relevant summary.

Example:

32 Students
30 Present
2 Absent

Provide:

[ View / Edit ]

only if the teacher is authorized to modify submitted attendance.

Do not allow unauthorized modification.

==================================================
18. UNSAVED CHANGES
==================================================

If the teacher changes attendance but has not submitted:

Show a clear state:

Unsaved changes

Example:

29 Present
2 Absent
1 Not Marked

[ Save / Submit ]

If the teacher attempts to leave the screen:

show an appropriate confirmation:

You have unsaved attendance changes.

[ Stay ]
[ Leave ]

Do not silently lose attendance changes.

==================================================
19. EMPTY STATES
==================================================

No teaching assignment:

No attendance classes available.

Your assigned classes and subjects will appear here.

No students:

No students found for this class.

No attendance recorded:

Attendance has not been marked for this date.

Do not show fake students.

Do not show fake counters.

==================================================
20. LOADING STATE
==================================================

Use skeleton loading matching the final UI.

Example:

Attendance
[ date skeleton ]

[ class skeleton ]

[ student skeleton ]
[ student skeleton ]
[ student skeleton ]

Do not display fake attendance while loading.

==================================================
21. ERROR STATE
==================================================

If attendance cannot load:

Unable to load attendance.

[ Retry ]

Do not expose:

- API errors
- database errors
- stack traces
- technical exception messages

==================================================
22. OFFLINE DESIGN
==================================================

The application will support offline operation later.

Design the screen so it can eventually support:

Offline available data

and

Changes waiting to sync

If offline attendance marking is supported in the future, the UI should clearly distinguish:

Saved locally

from

Submitted to school system

Do not falsely claim synchronization.

Do not display:

“Synced”

unless synchronization actually happened.

==================================================
23. MOBILE RESPONSIVENESS
==================================================

The screen must work correctly on:

320px
360px
375px
390px
412px
430px
480px+

For 320–360px:

Use a single-column layout.

Do not force:

- large cards
- wide tables
- multiple dense columns
- desktop-style attendance grids

Student rows must remain readable.

Names may wrap.

Roll numbers must remain visible.

Attendance controls must remain tappable.

Minimum touch target:
44px.

There must be:

NO horizontal page scrolling.

Only intentionally scrollable components such as filter chips may scroll horizontally.

==================================================
24. LARGE CLASS SUPPORT
==================================================

The screen must work with:

10 students
30 students
50 students
100+ students

Do not render an unnecessarily heavy UI.

Use a performant scrolling list.

Avoid nested scrolling containers.

Keep each student row compact.

The teacher should be able to mark attendance quickly without excessive scrolling.

==================================================
25. BOTTOM NAVIGATION
==================================================

Use the existing Subject Teacher navigation:

Portal
Academics
Attendance
Timetable
More

Attendance must be the active tab.

Do not modify navigation for:

Student
Class Teacher
Admin
Superadmin
Parent

==================================================
26. DO NOT DUPLICATE OTHER SCREENS
==================================================

Do not turn Attendance into:

Timetable
Academics dashboard
Fee dashboard
Teacher profile
Class Teacher dashboard

Attendance should remain focused on attendance.

Timetable information may appear only as small contextual information for the current/next teaching period.

==================================================
27. PRIVACY
==================================================

This is a teacher-facing screen.

Do not expose unnecessary sensitive student information.

Do not display:

- medical diagnosis
- medical attachments
- private guardian communications
- internal student notes

unless the existing authorized attendance workflow specifically requires it.

Keep the attendance screen focused on academic attendance.

==================================================
28. ICONS
==================================================

Use the same professional icon library already used by the application.

Prefer existing Material Symbols / Material Icons.

Examples:

calendar
search
chevron
check
close
history
filter_list
arrow_back
arrow_forward

Do not introduce emojis.

Do not mix multiple icon styles.

==================================================
29. VISUAL PRIORITY
==================================================

The visual priority must be:

1. Date
2. Subject + Class + Section
3. Attendance status
4. Student list
5. Marking controls
6. Submit/save state
7. History

Do not give decorative elements more visual importance than attendance controls.

==================================================
30. IDEAL USER FLOW
==================================================

A subject teacher opens:

Attendance

↓
Today is automatically selected.

↓
Their relevant teaching assignment is shown.

Example:

Mathematics
Grade 5-A

↓
Teacher sees:

32 Students
29 Present
2 Absent
1 Not Marked

↓
Teacher searches/scrolls students.

↓
Teacher marks remaining student.

↓
System updates counters immediately.

↓
Teacher reviews.

↓
Teacher selects:

Submit Attendance

↓
Confirmation:

Attendance submitted successfully.

The entire workflow should require minimal taps.

==================================================
31. FINAL SCREEN EXAMPLE
==================================================

Attendance

Today
Wednesday, 25 Oct 2026

[ Mathematics ▼ ]
[ Grade 5-A ▼ ]

CURRENT CLASS

Mathematics
Grade 5-A
Period 2 · 09:10–09:50

[ Take Attendance ]

ATTENDANCE

32 Students

29 Present · 2 Absent · 1 Not Marked

[ Mark All Present ]

[ Search students... ]

[ All 32 ] [ Not Marked 1 ] [ Present 29 ] [ Absent 2 ]

01  Aarav Agarwal
    Roll No. 01

    [ Present ] [ Absent ]

02  Ananya Dixit
    Roll No. 02

    [ Present ] [ Absent ]

03  Diya Sharma
    Roll No. 03

    [ Present ] [ Absent ]

...

[ Submit Attendance ]

Bottom navigation:

Portal | Academics | Attendance | Timetable | More

==================================================
32. IMPORTANT PRODUCT PRINCIPLE
==================================================

Do NOT optimize for “more features”.

Optimize for:

FAST
CLEAR
ACCURATE
EASY TO MARK
EASY TO REVIEW

A teacher should be able to open this screen and understand the attendance context within seconds.

Do not add features just because other School ERP products have them.

Only implement workflows supported by the existing project's:

- Teacher assignments
- Class
- Section
- Subject
- Student
- Attendance
- Timetable
- Permissions

The final result should feel like a practical production School ERP attendance workspace, not a generic dashboard template.
