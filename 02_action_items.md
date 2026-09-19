# Action Items: Class Teacher Home / Portal / Hub Screen Refinement

## 1. Important Context & Scope
- [ ] Refine the existing Class Teacher-specific home screen (`class_teacher_dashboard_screen.dart`).
- [ ] Preserve the existing approved visual design; do not redesign the visual identity.
- [ ] Improve information hierarchy, usefulness, data representation, clarity, and daily workflow.
- [ ] Remove unnecessary and redundant information to create a practical daily workspace for managing the teacher's assigned class.
- [ ] Use realistic mock data representing real ERP data models; do not invent unsupported backend functionality.

## 2. Core Purpose & Identification
- [ ] Structure the screen to answer: "What do I need to know and do for my class today?".
- [ ] Enable the teacher to understand within a few seconds:
  1. Assigned class
  2. Total student count
  3. Today's attendance status
  4. Current or next class
  5. Important work needing attention
  6. Important notices
  7. Direct access to high-frequency class-management actions
- [ ] Avoid turning the screen into an administrative dashboard, school-wide analytics console, or generic teacher profile.

## 3. Role Context & Assignment Priority
- [ ] Frame the workspace strictly around the teacher's assigned class.
- [ ] Do not display data for unrelated classes unless authorized by another valid teaching relationship.
- [ ] Prioritize Class Teacher responsibilities over Subject Teacher duties on the Home screen.
- [ ] Keep a unified teacher account/app without splitting into separate apps.

## 4. Visual Design Preservation
- [ ] Preserve existing application design language:
  - Color palette, background, and shadows
  - Typography (Newsreader / Manrope)
  - Card styling, border radius, and spacing
  - Header style, bottom navigation, icon style, and button styles
- [ ] Avoid introducing a new visual theme, excessive gradients, decorative filler illustrations, or oversized cards.
- [ ] Maintain a calm, professional, and information-dense layout without crowding.

## 5. Icon System Rules
- [ ] Do NOT use emojis anywhere on the screen.
- [ ] Do NOT use Unicode symbols as decorative icons.
- [ ] Use the consistent Material Symbols / Material Icons system matching the existing app.
- [ ] Maintain uniform icon sizing, weights, styles, and alignments.

## 6. Header
- [ ] Maintain existing top application header:
  - School name: `One Numan Public School`
  - Academic session: `2026–27`
  - Secondary label: `Academic Records`
  - Notification icon and teacher profile/avatar
- [ ] Avoid duplicating the teacher's full profile in the header.

## 7. Teacher Identity & Class Context
- [ ] Display a compact greeting below the header:
  - Example: `Good Morning, Mrs. Desai`
  - Subject/Department: `Senior Mathematics`
  - Role & Class: `Class Teacher • Grade 5-A` (visually prominent; do NOT use "Homeroom")
  - Academic year: `AY 2026–27`

## 8. Class Summary
- [ ] Prominently establish the assigned class context:
  - Section title: `My Class`
  - Class: `Grade 5-A`
  - Student count: `32 Students`
- [ ] Display gender-wise student counts (e.g., `17 Boys • 15 Girls`) only if the data exists and is appropriate; do not invent demographic stats.

## 9. Today's Attendance
- [ ] Display a compact attendance summary:
  - Title: `Today's Attendance`
  - Count: `31 / 32 Present`
  - Calculated percentage: `96.9%` (dynamically calculated, never hardcoded in production)
- [ ] If attendance is not marked:
  - Display `Not Marked` and `[ Take Attendance ]`
  - NEVER display `0%` or `0 / 32 Present` for unrecorded attendance.
- [ ] If attendance is partially recorded (and backend supports it):
  - Display actual recorded state (e.g., `24 / 32 Recorded • 8 Remaining` with `[ Continue Attendance ]`).

## 10. Attendance Action
- [ ] Provide an obvious primary attendance action button (`Take Attendance` or `Continue Attendance` based on state).
- [ ] Avoid multiple competing attendance buttons.
- [ ] Ensure the action opens the attendance workflow specifically for the assigned class.

## 11. Today's Schedule
- [ ] Display a compact schedule section titled `Today's Schedule`.
- [ ] For each schedule entry, display: period, start/end time, class, subject, room, and status (e.g., `Completed`, `Next`).
- [ ] Only show genuine teacher schedule information; do not invent rooms, teachers, subjects, periods, or statuses.

## 12. Current Class & Live State
- [ ] Calculate current class dynamically from real-time clock and timetable data:
  - Display `NOW`, subject, class, period time, room, and action (e.g., `[ Take Attendance ]`).
  - Calculate remaining time dynamically (`current time` + `period end time`); do NOT hardcode `LIVE (25m left)`.
- [ ] If between classes, show `Next Class`.
- [ ] If on a break, display `Break` with time (e.g., `10:00–10:20`); do not format breaks as classes.
- [ ] If the school day has concluded, display `No more classes today.`.

## 13. Quick Actions
- [ ] Provide a compact group of maximum ~4 high-value primary actions:
  - `Take Attendance`
  - `My Class`
  - `Marks / Assessments`
  - `Timetable`
- [ ] Do not include administrative workflows (e.g., `Faculty Leave`, `Compose Circular`) unless authorized and active for this role.
- [ ] Avoid large 8–12 action button grids.

## 14. Pending Work (Needs Attention)
- [ ] Display a compact `Needs Attention` section only when actionable items exist (e.g., attendance incomplete, marks pending, unacknowledged notices, student requests).
- [ ] Hide the section completely if there are no pending tasks; do not show an empty placeholder container.
- [ ] Only show items backed by real data; do not invent tasks.

## 15. Marks / Evaluations
- [ ] Display a compact pending marks indicator only if real pending evaluation tasks exist (e.g., `Marks Pending • 2 assessments • Mathematics FA2 • [ Review ]`).
- [ ] Derive numbers from actual pending records; do not display static placeholders (e.g., `04 Papers`).
- [ ] Do not create generic "Evaluation" KPIs merely to fill space; hide if no marks tasks are pending.

## 16. Student Attention & Privacy
- [ ] Show data-driven student attention items (e.g., leave requests: `Diya Sharma • Roll No. 14 • Leave request 18–19 Sep • [ Review ]`).
- [ ] Do NOT display medical diagnoses or prescription details on the Home dashboard (e.g., remove `"Seasonal Viral Pyrexia"`, `"Rx Attached"`).
- [ ] Restrict sensitive medical details to authorized sub-screens.

## 17. Important Notices
- [ ] Display an `Important Notices` section containing only relevant, authorized notices with unread/pinned indicators.
- [ ] Do not display school-wide notice counts if the teacher lacks access.
- [ ] Remove fake notices and decorative alert cards.
- [ ] Hide the section or use a minimal empty state if no notices exist.

## 18. School-Wide Information Removal
- [ ] Remove all school-wide metrics from the Class Teacher Home:
  - Total school student count
  - Total school attendance
  - Total school fees and revenue
  - School-wide academic performance
  - Unrelated department statistics

## 19. Remove Generic KPI Grid
- [ ] Remove the four-card generic "Operational Pulse" grid (e.g., Today's Attendance, Evaluations, Daily Classes, School Memo).
- [ ] Replace with focused priority elements: My Class, Today's Attendance, Current/Next Class, Pending Work, and Important Notices.

## 20. Data Hierarchy Alignment
- [ ] High Priority: Assigned class, student count, today's attendance, current/next class, required teacher action.
- [ ] Medium Priority: Pending marks/evaluations, important notices, student attention items.
- [ ] Low Priority: Secondary statistics, general school info.
- [ ] Eliminate elements that do not assist the teacher in managing the class today.

## 21. Data Availability & Formatting Rules
- [ ] Display data if it exists; calculate if reliably computable; do not invent missing data.
- [ ] Hide optional fields when data is unavailable.
- [ ] Avoid empty placeholders (`—`, `N/A`, `0`) unless semantically meaningful; missing data does not equal zero.

## 22. Teacher Assignment & Multi-Class Rules
- [ ] Dynamically derive the Home screen from actual teacher assignment data (do not hardcode `Grade 5-A`).
- [ ] If assigned to multiple classes (and backend supports it), provide an explicit class selector without combining student counts into a single total.
- [ ] Keep Class Teacher role clearly primary even if also acting as Subject Teacher for other grades (do not mix subject students into the assigned class summary).
- [ ] If no class is assigned, display a clean `No Class Assigned` state rather than mock Class Teacher data.

## 23. Empty States Implementation
- [ ] Case 1 (No students assigned): Display `My Class` with `No students are currently assigned to this class.` (avoid `0 students`).
- [ ] Case 2 (Attendance not marked): Display `Attendance not marked` with `[ Take Attendance ]`.
- [ ] Case 3 (No timetable): Display `No schedule available for today.`.
- [ ] Case 4 (No pending work): Hide the `Needs Attention` section.
- [ ] Case 5 (No notices): Hide the notices section or show a minimal empty state.
- [ ] Case 6 (No marks tasks): Omit evaluation KPIs completely.

## 24. Loading, Error & Offline States
- [ ] Provide lightweight skeleton loaders for teacher/class context, attendance, current/next class, and quick actions without heavy animations.
- [ ] If loading fails: show `Unable to load class information. Retry` without fake data; allow partial sections to remain visible if only one fails.
- [ ] If offline with cached data: show cached data with freshness timestamp (e.g., `Last updated: Today, 8:35 AM`).
- [ ] If offline without cache: show `You're offline and class information is unavailable. Retry`.

## 25. Date & Attendance Semantics
- [ ] Make dashboard date-aware based on current school/device date; do not hardcode static dates (e.g., `Wed, 28 Oct`).
- [ ] Respect school attendance semantics (day-based vs. period-based); do not count holidays or non-working days as absences.

## 26. Security, Authorization & Privacy
- [ ] Restrict visible data strictly to what the logged-in teacher is authorized to access.
- [ ] Never display unrelated classes, other teachers' assignments, private admin information, or unauthorized student data.
- [ ] Shield private student details (medical diagnoses, prescriptions, family records, private contact info) from the Home dashboard.

## 27. Navigation & Summary vs. Detail Separation
- [ ] Support primary conceptual navigation: `Home`, `Attendance`, `My Class`, `Academics`, `More`.
- [ ] Keep Home screen summary-focused; delegate full lists (attendance roster, student profiles, marks sheets, full timetable) to detail screens.

## 28. Responsive Mobile Design & Accessibility
- [ ] Optimize layout for small, standard, and large Android devices without horizontal scrolling.
- [ ] Prevent layout breakage from long teacher, class, subject, or notice names via proper wrapping/truncation.
- [ ] Ensure readable typography, high contrast, comfortable touch targets, and accessible icon labels.
- [ ] Supplement color-based statuses (Present, Absent, Pending, Completed) with explicit text and icons.

## 29. Deep Testing Checklist
- [ ] Test 1: Class Teacher with one assigned class (32 students).
- [ ] Test 2: Class Teacher with no assigned class ("No Class Assigned").
- [ ] Test 3: Attendance fully marked (present/total and calculated % displayed).
- [ ] Test 4: Attendance not marked ("Not Marked" + action; never 0%).
- [ ] Test 5: Attendance partially recorded (partial state shown if supported).
- [ ] Test 6: Current class active (highlighted with live time calculation).
- [ ] Test 7: Break period active (shown as break, not as a class).
- [ ] Test 8: Next class upcoming (displayed correctly).
- [ ] Test 9: School day concluded ("No more classes today.").
- [ ] Test 10: No timetable available (schedule empty state).
- [ ] Test 11: Pending marks present (actionable review cards shown).
- [ ] Test 12: No pending marks (no zero-value evaluation card).
- [ ] Test 13: Relevant notices present (displayed with unread badges).
- [ ] Test 14: No notices (no unnecessary empty notice container).
- [ ] Test 15: Student attention item exists (compact actionable record).
- [ ] Test 16: Medical details attached to request (diagnoses/Rx hidden on Home).
- [ ] Test 17: Dual role (Class Teacher + Subject Teacher; Class Teacher remains primary).
- [ ] Test 18: Multiple subject classes (subject students excluded from class count).
- [ ] Test 19: Full API failure (Error + Retry state).
- [ ] Test 20: Partial section API failure (surviving sections remain usable).
- [ ] Test 21: Offline with cache (cached data with timestamp).
- [ ] Test 22: Offline without cache (offline error state).
- [ ] Test 23: Long teacher name (header remains stable).
- [ ] Test 24: Long class name (no layout overflow).
- [ ] Test 25: Long subject name (graceful text wrapping/truncation).
- [ ] Test 26: Large class size (remains summary-focused).
- [ ] Test 27: No actionable items (clean dashboard without empty cards).
- [ ] Test 28: Period transition (current/next class updates dynamically).
- [ ] Test 29: Cancelled or changed class (shown only if supported by timetable data).
- [ ] Test 30: Missing attendance for scheduled class (not treated as student absence).

## 30. Final UX & Visual Experience
- [ ] Verify the teacher can assess class status and required actions within 2–3 seconds.
- [ ] Verify the hierarchy follows: Class Context → Attendance → Current/Next Class → Quick Actions → Needs Attention → Notices.
- [ ] Confirm no emojis, no generic ERP KPIs, and no decorative clutter exist.
- [ ] Verify approved visual identity is fully preserved.

---

# Original Prompt

You are refining the HOME / PORTAL / HUB screen for a Class Teacher in a modern School ERP Android application.

IMPORTANT CONTEXT

This is a Class Teacher-specific home screen.

The existing visual design is already strong and approved.

Your task is NOT to redesign the visual identity.

Your task is to improve:
- information hierarchy
- usefulness
- data representation
- clarity
- daily workflow
- removal of unnecessary information

The Class Teacher Home should feel like a practical daily workspace for managing the teacher's assigned class.

The UI is currently being designed before API integration.

Use realistic mock data only for visual demonstration, but every piece of information must represent data that could realistically come from the ERP.

Do not invent unsupported backend functionality.

==================================================
CORE PURPOSE
==================================================

The Class Teacher Home should answer:

"What do I need to know and do for my class today?"

Within a few seconds, the teacher should understand:

1. Which class am I responsible for?
2. How many students are in my class?
3. What is today's attendance status?
4. What is my current or next class?
5. What important work needs my attention?
6. Are there important notices?
7. How can I quickly access my most common class-management actions?

This is NOT an administrative dashboard.

This is NOT a school-wide analytics dashboard.

This is NOT a generic teacher profile page.

It is a daily Class Teacher workspace.

==================================================
ROLE CONTEXT
==================================================

A Class Teacher is identified by the class assignment.

The teacher is associated with the assigned class through the Class Teacher relationship.

The Class Teacher has class-specific responsibilities.

The screen must therefore prioritize the teacher's assigned class rather than displaying school-wide information.

Do not show data for unrelated classes unless the teacher is also assigned to those classes through another valid teaching relationship.

If a teacher is both:
- Class Teacher for one class
- Subject Teacher for other classes

the Class Teacher Home should prioritize the Class Teacher responsibility.

Do not create a second account or separate application.

==================================================
VISUAL DESIGN
==================================================

Preserve the existing application design language.

Keep:

- existing color palette
- existing typography
- Newsreader / Manrope typography if already established
- existing card treatment
- existing border radius
- existing spacing
- existing shadows
- existing background
- existing header style
- existing bottom navigation
- existing icon style
- existing button style

Do not introduce a new visual theme.

Do not use excessive gradients.

Do not use decorative illustrations simply to fill space.

Do not turn every item into a large card.

The screen should feel calm, professional and information-dense without becoming crowded.

==================================================
ICON RULE
==================================================

DO NOT USE EMOJIS.

Do not use Unicode symbols as decorative icons.

Use one consistent professional icon system throughout the application.

Prefer the existing Material Symbols / Material Icons system already used by the application.

Maintain consistent:
- icon size
- icon weight
- icon style
- alignment

==================================================
HEADER
==================================================

Keep the existing top application header.

Display:

One Numan Public School
2026–27

Secondary label:

Academic Records

The header may contain:

- notification icon
- teacher profile/avatar

Do not duplicate the teacher's entire profile in the header.

The teacher identity section below the header should provide the personal greeting.

==================================================
TEACHER IDENTITY / CLASS CONTEXT
==================================================

Show a compact teacher greeting.

Example:

Good Morning, Mrs. Desai

Senior Mathematics

Class Teacher • Grade 5-A

AY 2026–27

The most important information is:

Class Teacher
Grade 5-A

The assigned class should be visually prominent.

Do not call the class:

"Homeroom"

unless that terminology is actually used by the school.

Prefer:

Class Teacher • Grade 5-A

or:

Class Teacher
Grade 5-A

==================================================
CLASS SUMMARY
==================================================

Immediately establish the teacher's class context.

Example:

My Class

Grade 5-A

32 Students

This should be the primary context of the dashboard.

If gender-wise student counts are actually available and useful, they may be shown compactly.

Example:

32 Students
17 Boys • 15 Girls

Only show this if the underlying data exists and displaying it is appropriate.

Do not create demographic statistics simply for visual appearance.

==================================================
TODAY'S ATTENDANCE
==================================================

Attendance is one of the most important Class Teacher actions.

Show a compact attendance summary.

Example:

Today's Attendance

31 / 32 Present

96.9%

Action:

Take Attendance

The exact percentage should be calculated from the actual attendance records.

Do not hardcode the percentage in production.

IMPORTANT:

If attendance has NOT yet been marked:

Show:

Today's Attendance

Not Marked

[ Take Attendance ]

Do NOT show:

0%
0 / 32 Present

because missing attendance does not mean everyone is absent.

If attendance is partially recorded, represent the actual state.

Example:

24 / 32 Recorded

8 Remaining

[ Continue Attendance ]

Only use this state if the backend supports partial attendance.

==================================================
ATTENDANCE ACTION
==================================================

The primary attendance action should be obvious.

Example:

Take Attendance

or:

Continue Attendance

Depending on the actual state.

Do not create multiple competing attendance buttons.

When the teacher is responsible for the class, the action should open the attendance workflow for the assigned class.

Do not allow the Class Teacher dashboard to accidentally open attendance for an unrelated class.

==================================================
TODAY'S SCHEDULE
==================================================

Show today's teaching schedule in a compact section.

Title:

Today's Schedule

Each schedule item may contain:

- period
- start time
- end time
- class
- subject
- room
- status

Example:

08:30–09:15
Period 1
Grade 5-A
Mathematics
Room 204

Status:
Completed

Next class:

10:20–11:05
Period 3
Grade 5-A
Science
Lab 2

Status:
Next

Only display teacher schedule information that actually exists.

Do not invent:
- room
- teacher
- subject
- period
- schedule status

==================================================
CURRENT CLASS
==================================================

If timetable data and current time are available, calculate the current class.

Example:

NOW

Mathematics
Grade 5-A
11:05–11:50
Room 204

[ Take Attendance ]

The "LIVE" state must be calculated from actual time and timetable data.

Do NOT hardcode:

LIVE (25m left)

Calculate the remaining time from:

current time
+
period end time

If the teacher is between classes:

Show:

Next Class

If the school day has ended:

No more classes today.

If there is a break:

Break
10:00–10:20

Do not incorrectly show a break as a class.

==================================================
QUICK ACTIONS
==================================================

Provide a small set of high-value Class Teacher actions.

Recommended:

Take Attendance
My Class
Marks / Assessments
Timetable

Only include an action if the corresponding feature exists and the teacher is authorized to use it.

Do NOT create:

Faculty Leave
Compose Circular
or other generic administrative actions

unless those workflows actually exist for this role.

Keep the quick-action section compact.

Maximum approximately 4 primary actions.

Do not create a large grid of 8–12 actions.

==================================================
PENDING WORK
==================================================

If the ERP provides actionable pending work, show a compact section:

Needs Attention

Possible examples:

Attendance not completed
Marks pending
Notice requiring acknowledgement
Student request pending

Only show items that are actually supported by backend data.

Do not invent tasks.

Do not show a "Needs Attention" section when there is nothing to act on.

If there are no pending actions:

do not display an empty section.

==================================================
MARKS / EVALUATIONS
==================================================

If the teacher has actual marks/evaluation responsibilities, show a compact pending indicator.

Example:

Marks Pending

2 assessments

Mathematics
FA2

[ Review ]

The number must come from actual pending records.

Do not display:

04 Papers

unless four actual pending evaluation records exist.

Do not create a generic "Evaluation" KPI merely to fill dashboard space.

The teacher should be able to navigate to the appropriate marks workflow.

==================================================
STUDENT ATTENTION
==================================================

A Class Teacher may need a student attention section.

However, this must be data-driven.

Only show it when there is an actual actionable record.

Examples:

Student request pending

Attendance issue

Approved/awaiting leave request

Important class-related notice

If the backend supports student leave requests, display:

Diya Sharma
Roll No. 14

Leave request
18 Sep

[ Review ]

Do NOT display medical diagnoses or unnecessary medical details on the Home screen.

For example, do NOT display:

"Seasonal Viral Pyrexia"

or:

"Rx Attached"

unless there is a specific authorized workflow requiring this information.

Prefer minimal information:

Leave request
18–19 Sep

[ Review ]

The detailed record can contain additional information if the teacher is authorized to see it.

==================================================
NOTICES
==================================================

Show only relevant notices.

Possible section:

Important Notices

Example:

Parent meeting schedule updated

18 Sep 2026

[ View ]

If there are unread/pinned notices:

show a small indicator.

Do not create a school-wide notice count unless the teacher actually has access to those notices.

Do not show fake notices.

Do not show an alert merely for visual decoration.

==================================================
SCHOOL-WIDE INFORMATION
==================================================

Avoid filling the Class Teacher Home with school-wide metrics.

Do not show:

- total school students
- total school attendance
- total school fees
- total school revenue
- school-wide performance
- unrelated department statistics

unless the teacher's role explicitly requires them.

The Class Teacher Home is class-focused.

==================================================
REMOVE UNNECESSARY KPI GRID
==================================================

Do NOT retain the existing four-card "Operational Pulse" simply because it exists.

Avoid four generic KPIs such as:

Today's Attendance
Evaluations
Daily Classes
School Memo

unless each is genuinely useful and backed by actual data.

Instead prioritize:

1. My Class
2. Today's Attendance
3. Current / Next Class
4. Pending Work
5. Important Notices

The teacher should understand the situation without reading four unrelated metric cards.

==================================================
DATA HIERARCHY
==================================================

Use this priority:

HIGH PRIORITY

1. Assigned class
2. Student count
3. Today's attendance
4. Current / next class
5. Required teacher action

MEDIUM PRIORITY

6. Pending marks/evaluations
7. Important notices
8. Student attention items

LOW PRIORITY

9. Secondary statistics
10. General school information

Remove anything that does not help the teacher manage the class today.

==================================================
DATA RULE
==================================================

Follow this strictly.

IF DATA EXISTS:
Display it.

IF DATA CAN BE RELIABLY CALCULATED:
Calculate it.

IF DATA DOES NOT EXIST:
Do not invent it.

IF DATA IS OPTIONAL:
Hide it when unavailable.

Do not show empty placeholders such as:

—
N/A
0

unless the state has a meaningful semantic interpretation.

Missing data and zero are not the same thing.

==================================================
TEACHER ASSIGNMENT RULE
==================================================

The Home screen must be generated from the teacher's actual assignments.

If the teacher is Class Teacher for:

Grade 5-A

show Grade 5-A.

Do not hardcode Grade 5-A.

If the teacher is Class Teacher for another class:

show that class.

If the teacher has multiple Class Teacher assignments and the backend supports this:

provide an appropriate class selector.

Do not silently combine multiple classes into one incorrect student count.

==================================================
TEACHER WHO IS ALSO SUBJECT TEACHER
==================================================

If the teacher is:

Class Teacher → Grade 5-A

Subject Teacher → Mathematics Grade 6-B

the Home screen should still clearly establish:

Class Teacher
Grade 5-A

Subject teaching responsibilities may appear in schedule/academic information where relevant.

Do not mix the students from Grade 6-B into the Class Teacher's class summary.

==================================================
NO ASSIGNED CLASS
==================================================

If a teacher account has no Class Teacher assignment:

Do not show a fake class.

Show:

No Class Assigned

or the appropriate role state.

The account should then use the appropriate Subject Teacher experience.

Do not create an empty Grade 5-A dashboard.

==================================================
EMPTY STATES
==================================================

CASE 1:
No students assigned.

Show:

My Class

No students are currently assigned to this class.

Do not show:

0 students

as the primary information.

CASE 2:
No attendance marked today.

Show:

Attendance not marked

[ Take Attendance ]

CASE 3:
No timetable available.

Show:

No schedule available for today.

CASE 4:
No pending work.

Hide the Pending Work section.

CASE 5:
No notices.

Hide the notices section or use a minimal empty state where appropriate.

CASE 6:
No marks/evaluation tasks.

Do not display a zero-value evaluation KPI.

==================================================
LOADING STATE
==================================================

Use lightweight skeleton loaders.

The Home screen should not appear broken while data is loading.

Provide skeletons for:

- teacher/class context
- attendance summary
- current/next class
- quick actions where necessary

Avoid excessive loading animation.

==================================================
ERROR STATE
==================================================

If data loading fails:

Unable to load class information.

Retry

Do not display fake data after an API failure.

If some sections load successfully and another fails:

keep available information visible.

Do not blank the entire dashboard unnecessarily.

==================================================
OFFLINE STATE
==================================================

The application may eventually support offline/local cached data.

If cached data is available:

display it with appropriate freshness information when useful.

Example:

Attendance
31 / 32 Present

Last updated:
Today, 8:35 AM

If there is no cached information:

You're offline and class information is unavailable.

Retry

Do not claim live data while offline.

==================================================
DATE HANDLING
==================================================

The dashboard should be date-aware.

For today's information:

Use the actual current school/local date.

Do not hardcode:

Wed, 28 Oct

as a permanent UI value.

During prototype, realistic dates may be shown.

In production, the date must come from the application/device/backend context.

==================================================
ATTENDANCE COUNTING
==================================================

Do not assume attendance calculation rules.

Use the school's actual attendance semantics.

If attendance is day-based:

calculate using attendance days.

If attendance is period-based:

calculate using attendance periods.

Do not count holidays or non-working days as absences unless the school's rules explicitly require it.

==================================================
SECURITY / AUTHORIZATION
==================================================

The Home screen must only show information the logged-in teacher is authorized to access.

Do not show:

- unrelated classes
- unrelated students
- private administrative information
- another teacher's assignments
- unauthorized student information

The Class Teacher should see their assigned class information.

==================================================
PRIVACY
==================================================

Do not expose unnecessary sensitive student information on the Home screen.

Especially avoid displaying:

- medical diagnoses
- medical prescriptions
- private family information
- unnecessary contact information

If an authorized workflow requires such information, show it inside the appropriate detailed screen rather than on the Home dashboard.

==================================================
NAVIGATION
==================================================

The Home screen should provide clear navigation to the teacher's major workflows.

Recommended conceptual navigation:

Home
Attendance
My Class
Academics
More

Do not create a second navigation system inside the dashboard.

Use the existing application navigation style.

The exact bottom navigation can be finalized after all Class Teacher screens are designed.

==================================================
PORTAL VS DETAIL SCREENS
==================================================

The Home screen should provide summaries.

Detailed screens should provide the full information.

Example:

Home:
31 / 32 Present

Attendance:
Full student attendance list and attendance workflow

Home:
32 Students

My Class:
Complete student list and student details

Home:
2 Marks Pending

Marks:
Full assessment/evaluation workflow

Home:
Current Class

Timetable:
Complete daily/weekly timetable

Do not duplicate complete datasets on Home.

==================================================
RESPONSIVE MOBILE DESIGN
==================================================

Optimize for Android phones.

Test:

- small phone
- standard phone
- large phone

The screen must not require horizontal scrolling.

Cards and rows must adapt to long:

- student names
- class names
- subject names
- notice titles

Do not allow long text to break the layout.

==================================================
ACCESSIBILITY
==================================================

Maintain:

- readable font sizes
- sufficient contrast
- clear labels
- comfortable touch targets
- accessible icon labels

Do not rely only on color to communicate status.

For example:

Present
Absent
Pending
Completed

should have text/icon support.

==================================================
DEEP TESTING
==================================================

Before considering this Home screen complete, test every case below.

TEST 1:
Class Teacher has one assigned class with 32 students.

Expected:
Assigned class and student count are visible.

TEST 2:
Class Teacher has no assigned class.

Expected:
No fake class information.

TEST 3:
Attendance has been fully marked.

Expected:
Present/total and calculated percentage are displayed.

TEST 4:
Attendance has not been marked.

Expected:
"Not Marked" + Take Attendance.

Never show 0%.

TEST 5:
Attendance is partially recorded.

Expected:
Show partial state only if backend supports it.

TEST 6:
There is a current class.

Expected:
Current class is highlighted.

TEST 7:
There is a break.

Expected:
Break is shown correctly.

TEST 8:
There is a next class.

Expected:
Next class is shown.

TEST 9:
School day has ended.

Expected:
No more classes today.

TEST 10:
No timetable exists.

Expected:
Clean schedule empty state.

TEST 11:
Teacher has pending marks.

Expected:
Pending marks appear as actionable information.

TEST 12:
Teacher has no pending marks.

Expected:
No unnecessary zero-value evaluation card.

TEST 13:
There is a relevant notice.

Expected:
Notice appears.

TEST 14:
There are no notices.

Expected:
No unnecessary empty notice dashboard.

TEST 15:
Student attention item exists.

Expected:
Compact actionable item.

TEST 16:
Student has medical information attached to a request.

Expected:
Do not expose detailed medical information on Home.

TEST 17:
Teacher is both Class Teacher and Subject Teacher.

Expected:
Class Teacher context remains clearly separated from other teaching assignments.

TEST 18:
Teacher teaches multiple classes as Subject Teacher.

Expected:
Do not mix those students into the Class Teacher class count.

TEST 19:
API/data loading fails.

Expected:
Error + Retry.

TEST 20:
Only one data section fails.

Expected:
Other loaded sections remain usable.

TEST 21:
Device is offline with cached data.

Expected:
Cached information can be displayed appropriately.

TEST 22:
Device is offline without cached data.

Expected:
Clear offline state.

TEST 23:
Long teacher name.

Expected:
Header remains visually stable.

TEST 24:
Long class name.

Expected:
No layout overflow.

TEST 25:
Long subject name.

Expected:
Text wraps/truncates gracefully.

TEST 26:
Many students.

Expected:
Home remains summary-focused rather than displaying the entire student list.

TEST 27:
No actionable items exist.

Expected:
Dashboard remains clean rather than filled with empty cards.

TEST 28:
Current time changes from one period to another.

Expected:
Current/next class state changes accordingly.

TEST 29:
Class is cancelled or changed.

Expected:
Show only if timetable data supports cancellation/change information.

TEST 30:
Attendance is missing for one scheduled class.

Expected:
Do not automatically interpret missing attendance as absent.

==================================================
FINAL HOME SCREEN HIERARCHY
==================================================

Recommended final hierarchy:

HEADER
One Numan Public School
2026–27

↓

TEACHER + CLASS CONTEXT
Good Morning, Mrs. Desai
Class Teacher • Grade 5-A

↓

MY CLASS
Grade 5-A
32 Students

↓

TODAY'S ATTENDANCE
31 / 32 Present
96.9%
[ Take Attendance ]

↓

CURRENT / NEXT CLASS
Current:
Mathematics
11:05–11:50
Room 204

or:

Next:
Science
10:20–11:05

↓

QUICK ACTIONS
Take Attendance
My Class
Marks
Timetable

↓

NEEDS ATTENTION
Only when actual pending items exist

↓

IMPORTANT NOTICES
Only when relevant notices exist

==================================================
FINAL UX TEST
==================================================

The teacher should be able to open this screen and understand the situation within a few seconds.

The screen must prioritize:

CLASS
→ ATTENDANCE
→ CURRENT/NEXT CLASS
→ ACTIONS
→ PENDING WORK
→ NOTICES

Remove anything that does not help the Class Teacher manage the assigned class.

Do not overload the dashboard.

Do not add generic ERP KPIs.

Do not add unsupported features.

Do not invent data.

Do not expose unnecessary student-sensitive information.

Do not use emojis.

Preserve the existing visual identity.

The final result should feel like a focused daily Class Teacher workspace, not an administrative analytics dashboard.
