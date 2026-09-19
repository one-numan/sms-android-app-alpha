# Action Items: Class Teacher Daily Roll Call Register Screen Refinement

## 1. Scope & Visual Design Preservation
- [ ] Refine the existing Class Teacher Daily Roll Call Register screen (`daily_roll_call_screen.dart`).
- [ ] Preserve the existing approved visual design; do not redesign the application's visual identity.
- [ ] Retain the warm cream / ivory / cocoa visual system, color palette, background, cards, border radius, spacing, shadows, and button styles.
- [ ] Retain typography (Newsreader / Manrope) and overall application shell styling (header and navigation).
- [ ] Focus improvements exclusively on attendance-taking UX, information hierarchy, usability, accuracy, interaction states, and edge-case handling.

## 2. Screen Purpose & Core Workflow
- [ ] Treat screen strictly as an operational classroom tool, not an analytics dashboard.
- [ ] Enforce the 5-step operational workflow:
  1. Select / confirm class and date
  2. Review student roster
  3. Mark attendance
  4. Review attendance summary
  5. Submit register

## 3. Icon System Rules
- [ ] Do NOT use emojis anywhere on the screen.
- [ ] Do NOT use Unicode symbols as decorative icons.
- [ ] Use the consistent Material Symbols / Material Icons system matching the application.
- [ ] Maintain consistent icon sizing, weights, styles, and alignments throughout.

## 4. Core Attendance Authorization & Class Binding
- [ ] Restrict attendance taking strictly to the teacher's authorized Class Teacher roster.
- [ ] Derive class assignment dynamically from the teacher's profile (do not hardcode `Grade 5-A`).
- [ ] Prevent the teacher from accidentally taking attendance for an unrelated class.

## 5. Header & Page Header
- [ ] Maintain the existing school header: `One Numan Public School`, `2026–27`, and secondary label `Class Teacher Workspace`.
- [ ] Retain notification/profile shell controls without cluttering with redundant teacher info.
- [ ] Display clear Page Header below application shell:
  - Title: `Daily Roll Call`
  - Class: `Grade 5-A` (or assigned class)
  - Date: formatted school day (e.g., `Wednesday, 25 Oct 2026`)
- [ ] Provide date selector action; restrict historical modification permissions according to backend rules.

## 6. Date Handling & Temporal Edge Cases
- [ ] Use real-time school/local date dynamically (never hardcode in production).
- [ ] Holiday / Non-Working Day:
  - Hide normal attendance marking roster.
  - Display holiday state with calendar name if available (e.g., `School Holiday • Diwali Holiday • No attendance is required for this date.`).
  - Block accidental attendance submission on non-working days.
- [ ] Future Date:
  - Disallow attendance marking by default (`Attendance is not available for future dates.`) unless explicitly supported.
- [ ] Past Date:
  - Display as historical attendance.
  - Make read-only by default; enable edit controls only if official editing permissions exist.

## 7. Attendance Snapshot & Metrics Calculation
- [ ] Provide a compact, simplified attendance snapshot at the top:
  - Example: `32 Students • 29 Present • 2 Absent • 1 Late`
  - Only show "Late" if supported by data model.
- [ ] Dynamically calculate attendance percentage (e.g., `90.6%`); never hardcode.
- [ ] Remove non-standard jargon (e.g., `Queued`, `Tardy`).

## 8. Critical Distinction: Unknown vs. Absent
- [ ] Treat unrecorded attendance strictly as `Not Marked`; NEVER classify unrecorded students as `Absent`.
- [ ] Accurately reflect unrecorded counts in summary (e.g., 29 Present, 2 Absent, 1 Not Marked; total = 32).

## 9. Supported Attendance States & Labels
- [ ] Restrict statuses strictly to backend-supported values (e.g., Present, Absent, Late, Excused/Leave, Not Marked).
- [ ] Provide clear, accessible full-text labels (`Present`, `Absent`, `Late`, `Leave / Excused`) alongside or instead of standalone letters (`P`, `A`, `L`, `E`).

## 10. Safe "Mark All Present" Action
- [ ] Provide "Mark All Present" action to populate current draft only; DO NOT automatically submit the register.
- [ ] Display a confirmation dialog before overwriting existing exception states (e.g., "Mark all students as Present? This will change the current attendance selections. [Cancel] [Continue]").
- [ ] Never silently overwrite previously entered attendance.

## 11. Student Roster Display & Row Information
- [ ] Display essential row information only:
  - Student avatar / initials
  - Student full name
  - Roll number (e.g., `Roll No. 01`)
  - Admission number if needed (e.g., `ADM-0892`)
  - Attendance action controls (`[Present] [Absent] [Late]`)
- [ ] Remove term attendance percentages from rows (e.g., remove `96% Term Attendance`).
- [ ] Do NOT display addresses, phone numbers, parent names, or medical details on roster rows.

## 12. Search & Filter Interactions
- [ ] Support class-scoped search by:
  - Student name
  - Roll number
  - Admission number (if supported)
- [ ] Display clean search empty state: `No students found. [Clear search]`.
- [ ] Provide simple status filters for supported states (`All`, `Absent`, `Late`, `Not Marked`, `Leave / Excused`).
- [ ] Ensure search and filters work concurrently without clearing or resetting draft attendance states.
- [ ] Display empty state for filters with zero matches (`No students in this category.`).

## 13. Student Attendance Controls & State Styling
- [ ] Provide clear, accessible tap targets for each status.
- [ ] Ensure selected state is visually obvious using a combination of labels, icons, and state styling (never color alone).

## 14. Attendance Notes, Absence Reasons & Late Arrival
- [ ] Do not display note input fields on every row by default.
- [ ] Show contextual note actions only when relevant (e.g., `Absent → Add note`, `Late → Add note`).
- [ ] Allow viewing/adding absence reasons (e.g., `Medical leave`) only if supported by backend; do not invent fake reasons.
- [ ] If Late is supported, record arrival time (e.g., `08:12 AM`) only from genuine data; remove fabricated reasons like `"Traffic delay"` or `"Parent note submitted"`.

## 15. Leave / Excused Workflow Handling
- [ ] Display approved leave states accurately (e.g., `Leave • Approved`).
- [ ] Do not allow teachers to mark students as "Excused" unless authorized by an approved leave workflow.
- [ ] Prevent contradictory states (e.g., Present + Approved Leave).

## 16. Parent Notifications & Claims Removal
- [ ] Remove automatic claims of notification dispatch (remove `"Notification Dispatched"`, `"Email & In-App notification queued for guardians"`).
- [ ] Show notification statuses (`Pending`, `Sent`, `Failed`) only if backed by actual server confirmation.

## 17. Medical Privacy Protection
- [ ] Completely remove medical diagnoses and prescriptions from the attendance roster (remove `"Seasonal Viral Pyrexia"`, `"Rx Attached"`).
- [ ] Restrict sensitive medical details to authorized sub-screens.

## 18. Dynamic Attendance Summary Calculation
- [ ] Dynamically update top snapshot counters as students change states (e.g., Present, Absent, Late, Not Marked).
- [ ] Ensure total count always equals the true class roster count (e.g., 32 students).

## 19. Prototype Bug Fix: Elimination of Fake Counter Logic
- [ ] Remove existing prototype JavaScript/logic that renders only ~5 students while artificially calculating unseen students into the Present count.
- [ ] Render a complete, internally consistent mock roster where the displayed student cards exactly sum up to the total count (e.g., all 32 student records).

## 20. Submission Lifecycle States
- [ ] Distinguish attendance lifecycle states clearly:
  - `Draft`: register actively being edited.
  - `Ready to Submit`: all student records completed.
  - `Submitted`: register successfully recorded.
  - `Locked`: editing no longer permitted.

## 21. Incomplete Register Handling
- [ ] Highlight unrecorded students (e.g., `8 students not marked`).
- [ ] Disable the submit button until all students are marked if complete attendance is mandatory.
- [ ] Display clear callout: `Complete all attendance records before submission.`.

## 22. Submission Confirmation Modal
- [ ] Show a confirmation modal before finalizing submission:
  - Class name & date
  - Summary breakdown (Total students, Present, Absent, Late)
  - Explicit warning that attendance will be recorded
  - `[Cancel]` and `[Submit]` actions

## 23. Success, Failure & Retry States
- [ ] On success: display `Attendance Submitted` with final breakdown and options (`[Edit Attendance]` if authorized, or `Register Locked`).
- [ ] Remove fake synchronization messages unless genuine sync occurred.
- [ ] On failure: display `Attendance could not be submitted. Retry` without losing current draft data.

## 24. Offline Support & Freshness Timestamps
- [ ] Prepare UI for offline draft states (`Offline • Draft saved on this device • Last updated: 10:32 AM`).
- [ ] Do not pretend offline submission works if backend/local sync is not implemented.
- [ ] Replace technical sync jargon (`"Synced with ONPS Attendance Ledger"`) with clear timestamps.

## 25. Locked Attendance & Official Correction Handling
- [ ] When locked/submitted, convert roster rows to read-only; hide active P/A/L tap controls.
- [ ] Display `Request Correction` action only if an official correction workflow exists.

## 26. Duplicate Submission Prevention
- [ ] Disable submit button immediately upon tap; transition to `Submitting...` state to prevent duplicate submissions.

## 27. Unsaved Changes Navigation Guards
- [ ] Show `Unsaved Attendance` confirmation dialog (`[Stay] [Discard]`) if navigating away with unsaved changes.
- [ ] Show confirmation dialog before switching dates if a draft with changes is active.

## 28. Class Selection & Multi-Class Handling
- [ ] Provide class selector only if teacher has multiple authorized Class Teacher assignments.
- [ ] Switching class must update roster, snapshot, and date context without mixing student datasets.
- [ ] Omit class selector if the teacher manages only one class.

## 29. Access Control & Authorization Security
- [ ] Enforce backend/session authorization; never allow access via manually entered class IDs.
- [ ] Hide all internal database IDs, employee IDs, UUIDs, and tokens.

## 30. Bottom Navigation & Detail Screen Navigation
- [ ] Standardize bottom navigation on Teacher architecture: `Portal`, `Attendance`, `My Class`, `Academics`, `More`.
- [ ] Ensure student card tap opens student details via dedicated action area without interfering with quick attendance marking.

## 31. Mobile UX & One-Handed Classroom Usability
- [ ] Optimize for one-handed mobile use: comfortable touch targets, readable fonts, smooth scrolling, and accessible search/filters.
- [ ] Avoid cramped desktop tables or miniature buttons.

## 32. Sticky Bottom Submission Bar
- [ ] Provide sticky bottom bar displaying live counts (e.g., `29 Present • 2 Absent • 1 Late`) and `[Submit Daily Register]` button.
- [ ] Change state to disabled or `[Complete Attendance]` when records are missing.
- [ ] Remove long backend sync disclaimers from the bar.

## 33. Loading & Error States
- [ ] Use skeleton loader rows while loading roster.
- [ ] Handle roster load failure with `Unable to load class roster. [Retry]`.
- [ ] Handle submission failure with retry options without clearing user input.

## 34. Edge Cases: Empty Class, Large Class, Long & Duplicate Names
- [ ] Empty class: display `My Class • No students are currently assigned to this class.` (avoid `0 / 0 Present`).
- [ ] Large class: test performance and scrolling with 20, 32, 50, and 60+ students.
- [ ] Long names: graceful wrapping/truncation without breaking layout or controls.
- [ ] Duplicate names: clearly distinguish via roll number and admission number.

## 35. Timetable / Period Semantics Alignment
- [ ] Clearly demarcate daily roll call from period-level attendance; do not confuse day-based register with timetable period attendance.

## 36. Removals from Current Design
- [ ] Remove:
  - Employee ID
  - Term attendance percentage on every row
  - `"Notification Dispatched"`
  - `"Email & In-App notification queued for guardians"`
  - Fabricated reasons (`"Traffic delay"`, `"Parent note submitted"`)
  - Medical diagnosis (`"Seasonal Viral Pyrexia"`, `"Rx Attached"`)
  - Status jargon (`"Queued"`, `"Tardy"`)
  - Technical sync jargon (`"Synchronizes with ONPS Attendance Ledger"`)
  - Artificial student counter logic and fake synchronization toasts
  - Internal database IDs and UUIDs

## 37. Deep Testing Verification Checklist
- [ ] Test 1: 32 students, no attendance marked (32 Not Marked, submit disabled).
- [ ] Test 2: All students Present (32 Present, Ready to Submit).
- [ ] Test 3: 29 Present, 2 Absent, 1 Late (summary matches roster exactly).
- [ ] Test 4: One Absent changes to Present (counters update dynamically).
- [ ] Test 5: One student becomes Not Marked (counted as incomplete, not absent).
- [ ] Test 6: Mark All Present (populates draft without auto-submitting).
- [ ] Test 7: Mark All Present with exceptions (confirmation before overwrite).
- [ ] Test 8: Search by name (filters matching student only).
- [ ] Test 9: Search by roll number (filters matching student only).
- [ ] Test 10: Search by admission number (filters matching student only).
- [ ] Test 11: Search with no result (clear empty state).
- [ ] Test 12: Filter Absent (displays only absent students).
- [ ] Test 13: Filter Late (displays only late students).
- [ ] Test 14: Filter Not Marked (displays only incomplete students).
- [ ] Test 15: Search + filter together (both criteria work concurrently).
- [ ] Test 16: School holiday selected (normal roster hidden, holiday name shown).
- [ ] Test 17: Future date selected (restricted future state).
- [ ] Test 18: Past submitted register (read-only state).
- [ ] Test 19: Past editable register (editable only if authorized).
- [ ] Test 20: Teacher has no assigned class (no fake roster).
- [ ] Test 21: Teacher has multiple authorized classes (class selector works cleanly).
- [ ] Test 22: Unauthorized class access attempted (access denied).
- [ ] Test 23: Submission starts (button enters submitting state, blocks double taps).
- [ ] Test 24: Submission succeeds (locked/submitted confirmation state).
- [ ] Test 25: Submission fails (error + retry, draft retained).
- [ ] Test 26: Navigating back with unsaved changes (unsaved changes warning).
- [ ] Test 27: Changing date with unsaved changes (warning before switching).
- [ ] Test 28: Offline without support (no fake submission claims).
- [ ] Test 29: Offline with draft support (draft state clearly represented).
- [ ] Test 30: Network returns after offline draft (syncs only if supported).
- [ ] Test 31: Duplicate student names (roll/admission numbers disambiguate).
- [ ] Test 32: Long student names (no layout overflow).
- [ ] Test 33: 50+ students roster (smooth scrolling, stable UI).
- [ ] Test 34: No attendance reason available (no fake reason shown).
- [ ] Test 35: Medical info exists (diagnoses/Rx hidden on roster).
- [ ] Test 36: Notification workflow unavailable (no dispatch claims).
- [ ] Test 37: Notification workflow pending (pending shown only when confirmed).
- [ ] Test 38: Notification fails (failure status shown if supported).
- [ ] Test 39: Partial attendance data loaded (missing records not fabricated).
- [ ] Test 40: 32 students in roster (all counters calculate strictly from those 32 records).

## 38. Final UX & Hierarchy Verification
- [ ] Verify 5-level hierarchy: School/Class/Date → Attendance Snapshot → Search + Filter → Student Roster → Sticky Review/Submit.
- [ ] Confirm accurate attendance calculations, fast classroom workflow, clear pre-submission review, and clean mobile UX without emojis or visual redesign.

---

# Original Prompt

You are refining the existing "Class Teacher Daily Roll Call Register" screen for a modern School ERP Android application.

The uploaded/current screen is the reference implementation.

IMPORTANT:
The existing visual design is already approved.

DO NOT redesign the application's visual identity.

The goal is to improve the attendance-taking UX, information hierarchy, correctness, and edge-case handling while preserving the existing visual language.

==================================================
SCREEN
==================================================

Screen:
Daily Roll Call Register

Role:
Class Teacher

Purpose:
Allow the Class Teacher to accurately record attendance for the students of their assigned class for a selected school day.

The workflow should be:

Select/confirm class and date
        ↓
Review roster
        ↓
Mark attendance
        ↓
Review attendance summary
        ↓
Submit register

This is an operational screen.

It should NOT behave like another analytics dashboard.

==================================================
VISUAL DESIGN
==================================================

Preserve the existing:

- color palette
- typography
- Newsreader / Manrope typography
- background
- cards
- border radius
- spacing
- shadows
- buttons
- navigation
- header
- Material Symbols icon system
- overall visual identity

Do not introduce a new design language.

Do not change the visual style unnecessarily.

The current warm cream / ivory / cocoa visual system should remain.

The improvement should primarily be in:

- information hierarchy
- usability
- accuracy
- interaction states
- data representation

==================================================
ICON RULE
==================================================

DO NOT USE EMOJIS.

Do not use Unicode symbols as icons.

Use the existing Material Symbols / Material Icons system.

Keep icon:
- size
- weight
- style
- alignment

consistent throughout the screen.

==================================================
CORE ATTENDANCE RULE
==================================================

The Class Teacher is responsible for taking attendance for the assigned class.

The screen must operate only on the teacher's authorized class roster.

Do not allow the teacher to accidentally mark attendance for an unrelated class.

The class should come from the teacher's actual Class Teacher assignment.

Do not hardcode:

Grade 5-A

as the production class.

During prototype development, realistic mock data may represent the assigned class.

==================================================
HEADER
==================================================

Keep the existing school header.

Display:

One Numan Public School
2026–27

Secondary:

Class Teacher Workspace

The notification/profile controls may remain if they are part of the existing application shell.

Do not add unnecessary teacher information here.

==================================================
PAGE HEADER
==================================================

Below the application header:

Daily Roll Call

Grade 5-A
Wednesday, 25 Oct 2026

The class and date must be clearly visible.

Provide a date selector/action.

If the teacher can only mark attendance for today, do not create unnecessary historical date controls.

If historical attendance editing is supported:

provide date selection with appropriate permission/state.

Do not imply that teachers can freely modify previously submitted attendance unless the backend/workflow supports it.

==================================================
DATE HANDLING
==================================================

The selected date is extremely important.

Display it clearly.

Example:

Wednesday
25 October 2026

The date must not be hardcoded in production.

Use the actual school/local date.

If the selected date is:

- normal school day
- holiday
- weekend/non-working day
- future date
- past date

handle each case appropriately.

==================================================
HOLIDAY / NON-WORKING DAY
==================================================

If the selected date is a school holiday or non-working day:

Do NOT display a normal attendance roster for marking.

Show:

School Holiday

No attendance is required for this date.

If the school calendar provides the holiday name:

display it.

Example:

Diwali Holiday

No attendance required.

Do not allow accidental attendance submission for a non-working day unless the school explicitly supports attendance on that date.

==================================================
FUTURE DATE
==================================================

If the teacher selects a future date:

Do not automatically allow attendance marking.

If future attendance is not supported:

Show:

Attendance is not available for future dates.

If future attendance is explicitly supported:

clearly indicate that this is scheduled/future attendance.

==================================================
PAST DATE
==================================================

If past attendance is available:

display it as historical attendance.

If editing is permitted:

show an appropriate edit state.

If editing is not permitted:

show the register as read-only.

Do not provide editable attendance controls for locked/submitted records.

==================================================
ATTENDANCE SNAPSHOT
==================================================

Keep the attendance summary at the top, but simplify it.

Recommended:

Attendance

32 Students

29 Present
2 Absent
1 Late

or:

32 Students
29 Present • 2 Absent • 1 Late

If "Late" is supported by the actual attendance model/workflow.

Do not display unnecessary terminology such as:

Queued
Tardy

unless those are actual system statuses.

The percentage may be shown if it is useful:

90.6%

But it must be calculated from the actual attendance state.

Do not manually hardcode the percentage.

==================================================
IMPORTANT: UNKNOWN VS ABSENT
==================================================

This is critical.

If attendance has not been marked for a student:

the status must be:

Not Marked

It must NOT be:

Absent

For example:

32 total students
29 present
2 absent
1 not marked

must not be represented as:

30 present
2 absent

unless that is actually what the data says.

Missing attendance is not the same as absence.

==================================================
ATTENDANCE STATES
==================================================

Only support statuses that the actual backend/data model supports.

Potential states include:

Present
Absent
Late
Excused / Leave
Not Marked

Do not automatically introduce all of these if the backend does not support them.

The current prototype uses:

P
A
L
E

If these statuses are retained in the UI, provide a clear accessible meaning.

Prefer full labels in the interface where space allows:

Present
Absent
Late
Leave / Excused

Do not rely exclusively on single letters.

==================================================
MARK ALL PRESENT
==================================================

A "Mark All Present" action may be retained.

However, it must be safe.

When tapped:

Do not immediately submit the register.

It should only change the current attendance draft.

The teacher must still review the roster and explicitly submit.

If the register already contains exceptions:

Warn before overwriting existing states.

Example:

Mark all students as Present?

This will change the current attendance selections.

Cancel
Continue

Do not silently overwrite previously entered attendance.

==================================================
STUDENT ROSTER
==================================================

The roster is the main part of the screen.

Each student row should show only useful information.

Recommended:

[Avatar/Initials]

Aarav Agarwal
Roll No. 01
Admission No. 0892

[Present] [Absent] [Late]

Avoid showing too much information on every row.

Do NOT display each student's term attendance percentage by default.

For example, remove:

96% Term Attendance

unless it is specifically needed for the teacher's workflow.

Historical attendance belongs in the student's attendance/detail view.

==================================================
STUDENT IDENTITY
==================================================

Useful row information:

- Student name
- Roll number
- Admission number, if needed

Optional:

Student photo

Do not display unnecessary personal information.

Do not display:

- address
- phone number
- parent information
- medical details

on every attendance row.

==================================================
SEARCH
==================================================

Keep student search.

Search should support:

- student name
- roll number
- admission number

Only search within the teacher's assigned class roster.

Example:

Search student by name or roll number

If admission number is searchable:

Search student by name, roll number or admission number

Do not search the entire school.

==================================================
SEARCH EMPTY STATE
==================================================

If no student matches:

No students found.

Clear search

Do not show a blank screen.

==================================================
FILTERS
==================================================

Provide simple attendance filters if useful:

All
Absent
Late
Not Marked
Leave / Excused

Only show filters for supported statuses.

Do not show:

On Leave 0

simply because the UI template has the filter.

If no students match a filter:

No students in this category.

==================================================
FILTER + SEARCH
==================================================

Search and filters must work together.

Example:

Filter:
Absent

Search:
Diya

Expected:
Only matching absent students are displayed.

Changing filters must not reset the attendance state.

==================================================
STUDENT ATTENDANCE CONTROL
==================================================

Each student needs a clear way to set the attendance state.

The interaction should be:

Present
Absent
Late
Leave/Excused

only when supported.

The selected state must be visually obvious.

Do not depend only on color.

Use:

- label
- icon
- state styling

where appropriate.

==================================================
ATTENDANCE NOTES
==================================================

Do not show note fields for every student by default.

A note/action should appear only when necessary.

Examples:

Absent → Add note

Late → Add note

Leave → View/request details

Only implement these if the backend supports attendance notes/reasons.

Do not invent parent communications.

==================================================
ABSENCE REASON
==================================================

If the backend supports an absence reason:

allow the teacher to add/view it.

Example:

Absent

Reason:
Medical leave

If the backend does not support reasons:

do not add a fake reason field.

==================================================
LATE ARRIVAL
==================================================

If Late is supported:

allow appropriate late information only if the system supports it.

For example:

Late
Arrival: 08:12 AM

Do not automatically create:

"Traffic delay"

"Parent note submitted"

or any other reason.

Those are only valid when actual data exists.

==================================================
LEAVE / EXCUSED
==================================================

If Leave/Excused is supported:

display the appropriate state.

Example:

Leave
Approved

Do not automatically allow the teacher to mark a student "Excused" if the underlying school workflow requires an approved leave request.

The UI should respect the actual authorization/workflow.

==================================================
PARENT NOTIFICATIONS
==================================================

Do NOT assume that changing a student to Absent automatically sends a notification.

The current prototype contains:

"Notification Dispatched"

and:

"Email & In-App notification queued for guardians"

Do not show these as automatic behavior unless the actual backend/workflow supports it.

If notification dispatch is genuinely implemented:

show the status only after the system confirms it.

Possible states:

Notification pending
Notification sent
Notification failed

Do not claim success before confirmation.

==================================================
MEDICAL INFORMATION
==================================================

Do NOT display medical diagnoses, prescriptions, or medical details directly on the attendance roster.

For example, do NOT show:

Seasonal Viral Pyrexia
Rx Attached

If the attendance/leave workflow legitimately contains sensitive supporting information:

show only the minimum information required.

Detailed sensitive information belongs inside an authorized detail view.

==================================================
ATTENDANCE SUMMARY CALCULATION
==================================================

The summary must update dynamically when the teacher changes a student's state.

Example:

32 students

Initially:

29 Present
2 Absent
1 Late

If one Absent becomes Present:

30 Present
1 Absent
1 Late

If one student becomes Not Marked:

29 Present
1 Absent
1 Late
1 Not Marked

The total must remain 32.

Never artificially calculate the remaining students.

==================================================
IMPORTANT PROTOTYPE BUG TO REMOVE
==================================================

The existing prototype displays only a handful of student cards but claims:

32 students

The current JavaScript artificially adds unseen students into the Present count.

DO NOT KEEP THIS BEHAVIOR.

For the prototype:

Either:

A. display a complete realistic mock roster

OR

B. clearly represent a complete roster through the UI prototype without fake counter logic.

The displayed students and summary must remain internally consistent.

Never create:

"32 students"

while only rendering 5 students and artificially calculating the other 27.

==================================================
SUBMISSION STATE
==================================================

The screen should distinguish:

Draft
Ready to Submit
Submitted
Locked

Do not use vague technical wording.

Recommended:

Draft

while attendance is being edited.

Ready to Submit

when all required attendance records are completed.

Submitted

after successful submission.

Locked

when editing is no longer allowed.

==================================================
INCOMPLETE REGISTER
==================================================

If some students are still Not Marked:

show:

8 students not marked

The Submit button should be disabled if the school requires complete attendance.

If the school allows partial submission:

follow the actual backend rule.

Do not assume.

Recommended UX:

Complete all attendance records before submission.

[ Submit Register ]

disabled until complete.

==================================================
SUBMISSION CONFIRMATION
==================================================

Before submitting a complete register:

Show a confirmation summary.

Example:

Submit Attendance?

Grade 5-A
25 Oct 2026

32 Students
29 Present
2 Absent
1 Late

Once submitted, attendance will be recorded.

Cancel
Submit

Do not claim notifications will be sent unless the backend confirms that workflow.

==================================================
SUCCESS STATE
==================================================

After successful submission:

Show:

Attendance Submitted

Grade 5-A
25 Oct 2026

32 Students
29 Present
2 Absent
1 Late

The register is now recorded.

If editing is allowed:

Edit Attendance

If editing is not allowed:

Register Locked

Do not show fake "synchronized successfully" messages unless synchronization actually occurred.

==================================================
SUBMISSION FAILURE
==================================================

If submission fails:

Attendance could not be submitted.

Your draft is still محفوظ locally / retained in the current session.

Retry

Do not lose the teacher's entered attendance.

If offline/local draft storage is implemented later:

show appropriate offline draft state.

Do not claim local persistence if it is not implemented.

==================================================
OFFLINE SUPPORT
==================================================

The application may eventually support offline attendance.

Design the UI for this possibility.

Possible state:

Offline

Draft saved on this device

Last synced:
10:32 AM

Only show this if actual local/offline functionality exists.

If offline attendance is not yet implemented:

do not pretend that the register can be submitted offline.

==================================================
DATA FRESHNESS
==================================================

Use timestamps only when they are useful.

Avoid technical messages such as:

Synced with ONPS Attendance Ledger

unless this is a real user-facing workflow.

Prefer:

Last updated
10:32 AM

when appropriate.

==================================================
LOCKED ATTENDANCE
==================================================

If attendance has already been submitted and is locked:

The roster should become read-only.

Show:

Attendance Submitted

or:

Register Locked

Do not show active P/A/L controls.

If correction is allowed through an official process:

show:

Request Correction

only if that workflow actually exists.

==================================================
DUPLICATE SUBMISSION
==================================================

If the teacher presses Submit multiple times:

Do not create duplicate attendance records.

The UI should transition:

Ready to Submit
→ Submitting
→ Submitted

Disable the submit action while submission is in progress.

==================================================
NAVIGATION AWAY FROM UNSAVED DRAFT
==================================================

If the teacher has changed attendance but has not submitted:

and attempts to leave:

show:

Unsaved Attendance

Your attendance changes have not been submitted.

Stay
Discard

Only show this confirmation when there are actual unsaved changes.

==================================================
DATE CHANGE WITH UNSAVED DATA
==================================================

If the teacher changes the date while a draft exists:

warn before discarding/changing the draft.

Example:

Unsaved Attendance

Save draft
Discard changes
Cancel

Only implement options supported by the actual application.

==================================================
CLASS CHANGE
==================================================

If the teacher has multiple authorized class assignments:

provide a class selector.

Changing class must update:

- roster
- attendance summary
- schedule/context

Do not mix students from different classes.

If the teacher has only one Class Teacher assignment:

do not add an unnecessary class selector.

==================================================
ACCESS CONTROL
==================================================

The teacher must only access the attendance register for classes they are authorized to manage.

The UI must not rely on a manually entered class ID.

Do not expose another class's students.

==================================================
BOTTOM NAVIGATION
==================================================

Use the application's Teacher navigation.

For the Class Teacher experience, the conceptual navigation is:

Portal
Attendance
My Class
Academics
More

The current screen is:

Attendance

Do not keep:

Dashboard
Roll Call
Classes
Notices

as separate competing navigation concepts if the final Teacher navigation has already been standardized.

The exact final navigation can remain consistent with the overall Teacher application architecture.

==================================================
STUDENT DETAIL NAVIGATION
==================================================

Tapping a student should optionally open the student's teacher-authorized detail view.

The attendance register itself should remain fast for marking attendance.

Do not make every row open a large profile screen accidentally when the teacher is trying to tap attendance controls.

Use a dedicated student detail action or carefully defined tap area.

==================================================
MOBILE UX
==================================================

This is primarily an Android phone screen.

Optimize for one-handed use.

The teacher may be standing in a classroom while taking attendance.

Therefore:

- attendance controls must be easy to tap
- student names must be readable
- scrolling must be smooth
- search must be easy to reach
- summary must remain understandable
- submit action must remain accessible

Do not make tiny attendance buttons.

Do not create dense desktop-style tables.

==================================================
STICKY SUBMISSION BAR
==================================================

A sticky bottom submission area may be retained.

It should contain:

29 Present
2 Absent
1 Late

or the appropriate current summary.

Then:

[ Submit Daily Register ]

The submit button should clearly indicate its state.

If incomplete:

[ Complete Attendance ]

or disabled Submit.

Do not include technical backend text such as:

"Synchronizes with ONPS Attendance Ledger & sends automated email / in-app notifications"

unless those exact workflows are real and useful to the teacher.

Keep the sticky bar concise.

==================================================
LOADING STATES
==================================================

When loading the roster:

show lightweight skeleton rows.

When submitting:

button state:

Submitting...

Disable duplicate taps.

Do not show a spinner indefinitely.

==================================================
ERROR STATES
==================================================

Roster loading failure:

Unable to load class roster.

Retry

Submission failure:

Attendance could not be submitted.

Retry

Do not erase the teacher's current draft.

==================================================
EMPTY CLASS
==================================================

If no students are assigned:

My Class

No students are currently assigned to this class.

Do not show:

0 / 0 Present

as the primary state.

==================================================
LARGE CLASS
==================================================

Test with:

20 students
32 students
50 students
60+ students

The UI must remain usable.

Search and filters should work efficiently.

Do not attempt to display all students inside a fixed-height dashboard card.

==================================================
LONG NAMES
==================================================

Test:

A very long student name.

Expected:

Name wraps or truncates gracefully.

Roll number and attendance controls remain accessible.

No layout overflow.

==================================================
DUPLICATE NAMES
==================================================

If two students have the same name:

use additional identifying information such as:

Roll No.
Admission No.

Do not identify students solely by name.

==================================================
ABSENT STUDENT CASE
==================================================

When a student is marked Absent:

the row should clearly indicate:

Absent

Do not automatically add a reason.

Do not automatically send a notification unless confirmed by the backend.

==================================================
LATE STUDENT CASE
==================================================

When a student is marked Late:

show:

Late

Do not automatically create a reason.

Do not automatically add arrival time unless actual data exists.

==================================================
LEAVE CASE
==================================================

If a student has an approved leave:

show the appropriate leave/approved state.

Do not allow contradictory states such as:

Present + Approved Leave

unless the attendance model explicitly allows such a combination.

==================================================
ATTENDANCE + TIMETABLE
==================================================

This screen represents daily/class attendance.

If attendance is day-based:

do not imply that the teacher is marking attendance for individual timetable periods.

If attendance is period-based:

the screen should clearly indicate the period/class for which attendance is being recorded.

Do not invent period-level attendance.

==================================================
AUDIT / RECORD INFORMATION
==================================================

Do not expose internal database identifiers.

Do not display:

- database ID
- API ID
- employee ID
- internal UUID
- cryptographic token
- internal synchronization identifier

The teacher needs operational information, not backend implementation details.

==================================================
DEEP TESTING
==================================================

Before finalizing the UI, test all of the following.

TEST 1
32 students, no attendance marked.

Expected:
32 Not Marked.
Submit disabled if complete attendance is required.

TEST 2
All students Present.

Expected:
32 Present.
100% only if percentage is appropriate.
Ready to Submit.

TEST 3
29 Present, 2 Absent, 1 Late.

Expected:
Summary exactly matches roster.

TEST 4
One student changes from Absent to Present.

Expected:
Counters update immediately.

TEST 5
One student changes to Not Marked.

Expected:
Student is counted as incomplete, not absent.

TEST 6
Mark All Present.

Expected:
All currently editable students become Present.
No submission occurs automatically.

TEST 7
Mark All Present when some students already have exceptions.

Expected:
Confirmation before overwriting those states.

TEST 8
Search by name.

Expected:
Correct student only.

TEST 9
Search by roll number.

Expected:
Correct student only.

TEST 10
Search by admission number.

Expected:
Correct student only if supported.

TEST 11
Search returns no result.

Expected:
Clear empty state.

TEST 12
Filter Absent.

Expected:
Only absent students appear.

TEST 13
Filter Late.

Expected:
Only late students appear.

TEST 14
Filter Not Marked.

Expected:
Only incomplete records appear.

TEST 15
Search + filter together.

Expected:
Both conditions work simultaneously.

TEST 16
Holiday selected.

Expected:
No normal attendance marking.

TEST 17
Future date selected.

Expected:
Appropriate restricted state.

TEST 18
Past submitted register.

Expected:
Read-only unless editing is authorized.

TEST 19
Past editable register.

Expected:
Editable only when the workflow allows it.

TEST 20
Teacher has no assigned class.

Expected:
No fake roster.

TEST 21
Teacher has multiple authorized classes.

Expected:
Class selection works without mixing rosters.

TEST 22
Teacher attempts unauthorized class.

Expected:
Access denied.

TEST 23
Submission starts.

Expected:
Button enters submitting state and prevents duplicate submission.

TEST 24
Submission succeeds.

Expected:
Submitted/locked state.

TEST 25
Submission fails.

Expected:
Error + Retry.
Draft remains intact.

TEST 26
Teacher changes attendance and presses Back.

Expected:
Unsaved changes warning.

TEST 27
Teacher changes date with unsaved changes.

Expected:
Unsaved changes warning.

TEST 28
Offline with no offline support.

Expected:
Do not claim successful submission.

TEST 29
Offline with actual local draft support.

Expected:
Draft state is clearly represented.

TEST 30
Network returns after offline draft.

Expected:
Sync behavior only if actual offline synchronization exists.

TEST 31
Duplicate student names.

Expected:
Roll/admission information distinguishes them.

TEST 32
Long student names.

Expected:
No layout overflow.

TEST 33
50+ students.

Expected:
Smooth scrolling and usable controls.

TEST 34
No attendance reason available.

Expected:
Do not invent a reason.

TEST 35
Medical information exists.

Expected:
Do not display unnecessary medical details on roster.

TEST 36
Notification workflow unavailable.

Expected:
No "Notification Dispatched" message.

TEST 37
Notification workflow available but pending.

Expected:
Show Pending only after actual system state confirms it.

TEST 38
Notification fails.

Expected:
Show failure state if the system supports notification status.

TEST 39
Attendance data is partially loaded.

Expected:
Do not fabricate missing students or counts.

TEST 40
Roster contains 32 students.

Expected:
All counters are calculated from those actual 32 records.

==================================================
FINAL INFORMATION HIERARCHY
==================================================

The final screen should follow this hierarchy:

1. SCHOOL / CLASS / DATE
2. ATTENDANCE SUMMARY
3. SEARCH + FILTER
4. STUDENT ROSTER
5. STICKY REVIEW / SUBMIT

The teacher should be able to perform the core action quickly:

Open register
→ See class
→ Mark attendance
→ Review counts
→ Submit

Everything else is secondary.

==================================================
REMOVE FROM CURRENT DESIGN
==================================================

Unless genuinely supported by the backend/workflow, remove:

- Employee ID
- Term attendance percentage on every student
- "Notification Dispatched"
- "Email & In-App notification queued for guardians"
- "Traffic delay"
- "Parent note submitted"
- Medical diagnosis information
- "Rx Attached"
- "Queued"
- "Tardy"
- "Synchronizes with ONPS Attendance Ledger"
- Automatic notification claims
- Cryptographic/security information
- Internal identifiers
- Artificial student counter logic
- Fake synchronization toast
- Fake notification dispatch
- Unnecessary technical backend terminology

==================================================
FINAL DESIGN GOAL
==================================================

The final Daily Roll Call Register must feel like a professional classroom attendance tool.

It should be:

- fast
- clear
- accurate
- easy to operate with one hand
- data-driven
- safe against accidental submission
- safe against confusing missing data with absence
- consistent with the existing application
- ready for future API integration

Do NOT redesign the visual theme.

Do NOT add unsupported features.

Do NOT invent data.

Do NOT invent notifications.

Do NOT invent medical information.

Do NOT invent attendance states.

Do NOT use emojis.

Do NOT expose backend implementation details.

The most important goal is:

ACCURATE ATTENDANCE
+
FAST CLASSROOM WORKFLOW
+
CLEAR REVIEW BEFORE SUBMISSION
+
CLEAN MOBILE UX
