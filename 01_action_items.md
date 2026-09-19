# Action Items: Digital Student ID Card Screen Refinement

## 1. Scope & Design Preservation
- [ ] Preserve existing visual design completely; do not redesign the application.
- [ ] Preserve the color palette, typography, fonts, font weights, and overall visual style.
- [ ] Preserve card design, border radius, spacing system, and page margins.
- [ ] Preserve navigation bar, header style, button style, and overall visual identity.
- [ ] Focus strictly on improving information hierarchy and removing redundant/unnecessary operational details.
- [ ] Ensure the screen remains visually recognizable.

## 2. Screen Information
- [ ] Target screen: Digital Student ID Card (`/student/digital-id-sheet` or `/students/id-card`).
- [ ] Target Flutter file: `digital_student_id_card_screen.dart`.
- [ ] Keep the screen focused exclusively on student-facing identification and practical verification.
- [ ] Remove elements that make it behave like a technical security dashboard, transport management screen, school administration screen, backend verification console, or campus access instruction page.

## 3. Primary Purpose & Identification Focus
- [ ] Structure the screen to clearly answer: "Who is this student?" and "Can this student identity be verified?".
- [ ] Prioritize elements in order: School identity, student photo, student name, class/section, roll number, admission number, optional identity/emergency info, verification QR, card validity, share/PDF actions.

## 4. Header
- [ ] Maintain the existing application header style.
- [ ] Set Title to `Digital Student ID`.
- [ ] Set Subtitle to `Verified Student Identity` (or `Digital Student ID`); do not use `Verified Gate & Transport Pass` unless defined by backend.
- [ ] Include header actions: Back, Share, and Download PDF using the existing icon style.
- [ ] Do not add extra actions to the header.

## 5. School Identity
- [ ] Display school name at top of card: `ONE NUMAN PUBLIC SCHOOL`.
- [ ] Display academic session: `2026–27`.
- [ ] Retain school logo/crest if present.
- [ ] If school affiliation is officially required, display it in a small secondary line; do not display the CBSE affiliation number prominently as student identity information.

## 6. Student Photo
- [ ] Keep student photograph prominent as a primary verification element.
- [ ] Display Student Photo and Student Name (e.g., `DIYA SHARMA`).
- [ ] Show a clean profile placeholder if a real photo is unavailable; do not invent photo data.

## 7. Student Basic Information
- [ ] Display core structured identity fields in a compact, easy-to-scan grid/list:
  - [ ] Student Name (e.g., `DIYA SHARMA`)
  - [ ] Class / Section (e.g., `Grade 5 • Section A`)
  - [ ] Roll Number (e.g., `14`)
  - [ ] Admission Number (e.g., `ADM-2024-0412`)
- [ ] Avoid unnecessarily large cards for individual fields.

## 8. Optional Student Information
- [ ] Display optional fields only if present in actual data model and appropriate for student view:
  - [ ] Date of Birth (e.g., `14 Apr 2015`)
  - [ ] Blood Group (e.g., `B+`)
  - [ ] House (e.g., `Blue Cheetahs`)
- [ ] Do not invent mock values for these fields.
- [ ] Hide fields if data is absent, sensitive, or omitted for minimalism; do not display empty/dash placeholders.

## 9. Emergency Contact
- [ ] Retain emergency contact section if practical data exists:
  - [ ] Contact Name (e.g., `Rajesh Sharma`)
  - [ ] Contact Number (e.g., `+91 XXXXX XXXXX`)
  - [ ] Relationship label (`Father` or `Guardian`) if available and useful.
- [ ] Do not expose unnecessary contact details beyond authorized access.
- [ ] Do not show fake emergency contacts or empty cards when unavailable.

## 10. QR Verification
- [ ] Keep QR code simple for student verification:
  - [ ] Title: `Student Verification`
  - [ ] QR Code display
  - [ ] Optional short identifier: `ONPS-VERIFY-2026-ADM0412`
- [ ] Remove internal security implementation details (encrypted security tokens, cryptographic signatures, internal hashes, encryption algorithms, database IDs, backend implementation details).

## 11. Verification Status
- [ ] Display a verified badge/indicator (e.g., `Verified` with check icon) only if an actual verification state exists in backend.
- [ ] Do not show `Verified` merely because a QR code is rendered.
- [ ] Remove `CBSE Live` or any implied external verification service that does not exist.

## 12. Card Validity
- [ ] Display card validity using existing compact styling (e.g., `Valid Through 31 Mar 2027`).
- [ ] Bind validity date directly to student ID backend data; do not invent expiration logic.

## 13. Remove Technical Information
- [ ] Remove `"Encrypted Security Token"`.
- [ ] Remove technical token identifiers presented as security implementation details.
- [ ] Remove `"Cryptographically verified offline pass"`.
- [ ] Remove `"Synced Today 08:30 AM"`.
- [ ] Remove internal synchronization information.
- [ ] Remove encryption/cryptographic terminology.

## 14. Remove Redundant Barcode
- [ ] Remove the barcode element, defaulting to QR code verification only (unless the school's scanning system explicitly requires both).

## 15. Remove Campus Access Instructions
- [ ] Remove the large `Campus Access Protocol` paragraph (e.g., "Present this digital pass at the main campus turnstile...").
- [ ] Provide a small secondary action (`How to use ID`) leading to help/instructions only if instructions are genuinely required.

## 16. Transport Decoupling
- [ ] Remove `Transport Pass` branding/terminology from the digital ID screen (keep Transport under `More → Transport`).
- [ ] Do not make transport verification the primary purpose of this screen.

## 17. School Affiliation
- [ ] Display `Affiliated to CBSE` only as a subtle institutional detail if desired.
- [ ] Remove prominent CBSE affiliation number (e.g., `CBSE #2130456`) from student info.
- [ ] Remove `CBSE Live` indicator.

## 18. Principal Signature
- [ ] Remove principal signature if decorative or unauthorized.
- [ ] If retained for official digital IDs, keep it subtle (e.g., `Authorized By: Principal`) and not larger than student identity info.

## 19. Share Action
- [ ] Maintain Share action ready for future-supported digital ID representation sharing without pretending unimplemented functionality is live.

## 20. Download PDF
- [ ] Maintain Download PDF action ready to export essential ID card details without technical/cryptographic clutter or fake sync stamps.

## 21. Final Card Hierarchy Alignment
- [ ] Organize card top-to-bottom:
  1. School Name (`ONE NUMAN PUBLIC SCHOOL`), Academic Session (`2026–27`), `DIGITAL STUDENT ID`
  2. Student Photo, Name (`DIYA SHARMA`), Class/Section (`Grade 5 • Section A`), Roll No. (`14`)
  3. Admission No. (`ADM-2024-0412`), DOB, Blood Group, House (if available)
  4. Student Verification QR & Validity (`Valid Through 31 Mar 2027`)
  5. Emergency Contact (if available)
  6. Authorized By Principal (if genuine)
- [ ] Allow the card to become simpler naturally when optional fields are not present.

## 22. Information Priority Alignment
- [ ] Prioritize High: School Name, Student Photo, Student Name, Class/Section, Roll Number, Admission Number.
- [ ] Prioritize Medium: QR Verification, Card Validity, Emergency Contact.
- [ ] Treat as Optional: Date of Birth, Blood Group, House, Principal Authorization, School Affiliation.
- [ ] Remove: Barcode, cryptographic info, encryption info, sync timestamps, technical token details, campus access instructions, transport pass terminology, fake live verification indicators.

## 23. Data Consistency Across Modules
- [ ] Ensure student data (Name, Class, Section, Roll Number, House) is 100% consistent across Portal, Academics, Attendance, Fees, Profile, and Digital ID screens.
- [ ] Standardize mock student data to avoid conflicting attributes across screens.

## 24. Data Availability Rules
- [ ] If data exists: display it.
- [ ] If data can be calculated: calculate it.
- [ ] If data does not exist: do not invent it.
- [ ] If data is optional: hide the field completely instead of showing empty placeholders (e.g., `—`).

## 25. Empty / Missing Data Edge Cases
- [ ] Student photo unavailable: show clean profile placeholder.
- [ ] DOB unavailable: hide DOB.
- [ ] Blood group unavailable: hide Blood Group.
- [ ] House unavailable: hide House.
- [ ] Emergency contact unavailable: hide Emergency Contact section.
- [ ] QR unavailable: do not display fake QR.
- [ ] Verification unavailable: do not show "Verified".
- [ ] Validity date unavailable: do not invent a date.
- [ ] Principal authorization unavailable: hide authorization section.

## 26. Security & Privacy Cases
- [ ] Do not expose database primary keys, internal UUIDs, API tokens, auth tokens, encryption keys, internal hashes, or private backend metadata.
- [ ] Ensure verification QR contains only what is required for legitimate verification.

## 27. Responsive Mobile Design
- [ ] Verify layout on small, standard, and large Android screens.
- [ ] Prevent horizontal scrolling.
- [ ] Handle long student names without breaking layout.
- [ ] Truncate or wrap long school names gracefully.
- [ ] Ensure long admission numbers fit cleanly.
- [ ] Ensure QR code remains comfortably scannable.
- [ ] Maintain comfortable touch targets for buttons.

## 28. Accessibility Requirements
- [ ] Maintain readable text, sufficient contrast, and clear labels.
- [ ] Maintain accessible touch targets and meaningful icon labels.
- [ ] Do not rely solely on color for verification or validity statuses; use clear text/icon indicators.

## 29. Expired ID Case
- [ ] Show `ID Expired` (or appropriate system state) if validity date has passed.
- [ ] Do not display `Verified` if card is expired.
- [ ] Do not invent expiration behavior if validity is not implemented by backend.

## 30. Share / PDF Edge Cases
- [ ] Show appropriate error state if sharing fails.
- [ ] Show `Unable to generate PDF. Retry` if PDF generation fails; do not pretend file was generated.
- [ ] Respect authorization if student lacks permissions to share or download.

## 31. Final Visual Experience & Deep Test Checklist
- [ ] Verify identity can be determined within 2–3 seconds.
- [ ] Verify student photo and name are prominent.
- [ ] Verify class, section, roll number, and admission number are immediately visible.
- [ ] Verify QR verification and card validity are clear.
- [ ] Verify emergency contact and optional fields only appear when genuine data exists.
- [ ] Verify only one verification code (QR) is shown.
- [ ] Verify CBSE affiliation number, CBSE Live, cryptographic info, sync time, campus access protocol, and transport primary branding are eliminated.
- [ ] Verify no fake data, fake QR, or fake verification indicators are used.
- [ ] Verify student data is consistent with Portal, Academics, Attendance, Fees, and More.
- [ ] Verify screen remains clean on small Android phones without changing existing theme or design.
- [ ] Confirm no emojis are used.

---

# Original Prompt

You are refining the existing "Digital Student ID Card" screen of a School ERP Android student application.

IMPORTANT:

The current visual design is already very good.

DO NOT redesign the application.

DO NOT change the existing:
- color palette
- typography
- fonts
- font weights
- overall visual style
- card design
- border radius
- spacing system
- page margins
- navigation bar
- header style
- button style
- overall visual identity

The goal of this task is ONLY to improve the information hierarchy and remove unnecessary/redundant information from the Digital Student ID screen.

The existing screen should remain visually recognizable after the changes.

==================================================
SCREEN INFORMATION
==================================================

Screen:
Digital Student ID Card

Route:
 /student/digital-id-sheet
or
 /students/id-card

Flutter implementation:
digital_student_id_card_screen.dart

This is a STUDENT-FACING DIGITAL ID CARD.

The screen should represent the student's identity clearly and practically.

It should NOT try to simultaneously behave as:

- a technical security dashboard
- a transport management screen
- a school administration screen
- a backend verification console
- a campus access instruction page

Keep it focused on student identification and practical verification.

==================================================
PRIMARY PURPOSE
==================================================

The screen should answer:

"Who is this student?"

and:

"Can this student identity be verified?"

The student should be able to use the digital ID for appropriate school identification purposes.

Prioritize:

1. School identity
2. Student photo
3. Student name
4. Class / section
5. Roll number
6. Admission number
7. Optional identity/emergency information
8. Verification QR
9. Card validity
10. Share / PDF actions

==================================================
HEADER
==================================================

Keep the existing application header style.

Title:

Digital Student ID

Subtitle:

Verified Student Identity

Do NOT use:

"Verified Gate & Transport Pass"

unless the backend genuinely defines this digital ID as both a gate pass and transport pass.

Prefer:

Digital Student ID

or:

Verified Student Identity

The header should contain:

Back
Share
Download PDF

Use the existing icon style.

Do not add additional actions.

==================================================
SCHOOL IDENTITY
==================================================

At the top of the card, display:

ONE NUMAN PUBLIC SCHOOL

Academic Session:
2026–27

The school logo/crest may remain.

If the school affiliation information is available and officially required, it may be displayed in a small secondary line.

However:

DO NOT prominently display the CBSE affiliation number as student information.

Do not make the affiliation number a major element of the card.

The affiliation number identifies the institution, not the individual student.

==================================================
STUDENT PHOTO
==================================================

Keep the student photograph prominent.

The photo is one of the most important identity-verification elements.

Display:

Student Photo

Student Name

Example:

DIYA SHARMA

If a real student photo is unavailable:

show a clean profile placeholder.

Do not invent a photograph.

==================================================
STUDENT BASIC INFORMATION
==================================================

Display the core student identity information.

Recommended:

Student Name
DIYA SHARMA

Class / Section
Grade 5 • Section A

Roll Number
14

Admission Number
ADM-2024-0412

These are the most important structured identity fields.

Keep them visually easy to scan.

Do not create unnecessarily large cards for each individual field.

Use a compact grid/list arrangement consistent with the existing design.

==================================================
OPTIONAL STUDENT INFORMATION
==================================================

The following information may be displayed if it exists in the actual student data model and is appropriate for student-facing access.

Date of Birth
14 Apr 2015

Blood Group
B+

House
Blue Cheetahs

IMPORTANT:

Do not invent these values.

If a field does not exist or is unavailable:

do not show an empty field.

If the school considers Blood Group sensitive or does not want it displayed on digital IDs:

omit it.

If DOB is not required for identity verification:

it may be omitted to keep the ID minimal.

House is optional and should remain only if it is an actual student attribute.

==================================================
EMERGENCY CONTACT
==================================================

Emergency contact can remain because it has practical value for a school identity card.

Display:

Emergency Contact

Rajesh Sharma
+91 XXXXX XXXXX

If relationship information is available and useful:

Father

or

Guardian

may be shown.

Do not expose unnecessary contact information beyond what the student is authorized to see.

Do not create a fake emergency contact.

If no emergency contact exists:

do not show an empty emergency-contact card.

==================================================
QR VERIFICATION
==================================================

Keep the QR code ONLY if the application actually intends to use a QR-based student verification mechanism.

The QR section should be simple.

Title:

Student Verification

[ QR CODE ]

Optional short identifier:

ONPS-VERIFY-2026-ADM0412

The QR should represent an appropriate student verification identifier/token according to the backend implementation.

IMPORTANT:

Do NOT expose internal security implementation details.

Do NOT display technical information such as:

- encrypted security token
- cryptographic signature
- internal hash
- encryption algorithm
- database ID
- backend implementation details

unless explicitly required for the actual verification workflow.

==================================================
VERIFICATION STATUS
==================================================

A verification indicator may be shown if a real verification state exists.

Example:

Verified

with a professional check icon.

IMPORTANT:

Do not show "Verified" merely because the UI is displaying a QR code.

The status must correspond to an actual verification mechanism or backend state.

Do not show:

CBSE Live

unless there is a real live CBSE verification integration.

Do not imply an external verification service that does not actually exist.

==================================================
CARD VALIDITY
==================================================

Keep card validity because it is useful for a digital ID.

Example:

Valid Through
31 Mar 2027

Use the existing compact styling.

The validity date must come from the appropriate backend/student ID data when implemented.

Do not invent expiration logic.

==================================================
REMOVE TECHNICAL INFORMATION
==================================================

Remove the following from the visible student-facing ID unless a real product requirement specifically requires them:

1. "Encrypted Security Token"

2. Technical token identifiers presented as security implementation details

3. "Cryptographically verified offline pass"

4. "Synced Today 08:30 AM"

5. Internal synchronization information

6. Encryption/cryptographic terminology

These are implementation details rather than student identity information.

If the application uses offline verification internally, keep that implementation behind the scenes.

The student does not need to see how the security system works.

==================================================
REMOVE REDUNDANT BARCODE
==================================================

The current design contains both:

QR Code
and
Barcode

Do NOT show both by default.

Prefer a single QR verification mechanism.

Remove the barcode unless the school's actual scanning system requires a barcode.

If the backend/security system explicitly requires both:

keep both, but make their purposes clear.

Otherwise:

QR only.

==================================================
REMOVE CAMPUS ACCESS INSTRUCTIONS
==================================================

Remove the large:

Campus Access Protocol

paragraph.

Do not display long instructions such as:

"Present this digital pass at the main campus turnstile or school bus terminal..."

This makes the screen feel like an operational/security manual.

The ID should remain self-explanatory.

If instructions are genuinely required:

provide a small secondary action:

How to use ID

which opens a separate help/instruction screen.

Do not place a large paragraph inside the ID card.

==================================================
TRANSPORT
==================================================

Do not make this screen a Transport screen.

Do not use:

"Transport Pass"

unless this exact ID is officially used as a transport pass.

Transport is a separate secondary feature of the application.

It belongs under:

More → Transport

The Digital Student ID may still be used for transport verification if the actual backend supports it, but do not make Transport the primary purpose of this screen.

==================================================
SCHOOL AFFILIATION
==================================================

If desired, display:

Affiliated to CBSE

as a small institutional detail.

However:

Do not prominently display:

CBSE #2130456

as though it identifies the student.

Do not show:

CBSE Live

unless an actual live verification service exists.

==================================================
PRINCIPAL SIGNATURE
==================================================

The principal signature may remain ONLY if it represents an actual official school-issued digital ID.

If the signature is only decorative:

remove it.

Do not create the impression of official authorization if no such digital authorization exists.

If retained:

keep it visually subtle.

Example:

Authorized By
Principal

Do not make the signature larger than the student's identity information.

==================================================
SHARE ACTION
==================================================

Keep:

Share

The Share action should represent sharing the digital ID or its supported representation.

Do not invent functionality.

If implemented:

allow the user to share the appropriate ID representation.

If not implemented yet:

keep the UI ready for future implementation without pretending it already works.

==================================================
DOWNLOAD PDF
==================================================

Keep:

Download PDF

The PDF should contain the same essential student ID information.

Do not generate a PDF containing unnecessary technical information.

The PDF should represent the actual digital student ID.

Avoid including:

- cryptographic implementation details
- synchronization timestamp
- fake verification services
- unnecessary backend identifiers

==================================================
FINAL CARD INFORMATION
==================================================

The recommended final card hierarchy is:

------------------------------------------

ONE NUMAN PUBLIC SCHOOL

Academic Session 2026–27

DIGITAL STUDENT ID

------------------------------------------

[ Student Photo ]

DIYA SHARMA

Grade 5 • Section A
Roll No. 14

------------------------------------------

Admission No.
ADM-2024-0412

Date of Birth
14 Apr 2015

Blood Group
B+

House
Blue Cheetahs

------------------------------------------

Student Verification

[ QR CODE ]

Valid Through
31 Mar 2027

------------------------------------------

Emergency Contact

Rajesh Sharma
+91 XXXXX XXXXX

------------------------------------------

Authorized By
Principal

------------------------------------------

Do not force every optional field into the card.

If the available data is limited, the card should naturally become simpler.

==================================================
INFORMATION PRIORITY
==================================================

Use this priority order:

HIGH PRIORITY

1. School Name
2. Student Photo
3. Student Name
4. Class / Section
5. Roll Number
6. Admission Number

MEDIUM PRIORITY

7. QR Verification
8. Card Validity
9. Emergency Contact

OPTIONAL

10. Date of Birth
11. Blood Group
12. House
13. Principal authorization
14. School affiliation

REMOVE UNLESS REQUIRED

15. Barcode
16. Cryptographic information
17. Encryption information
18. Sync timestamp
19. Technical token details
20. Campus access instructions
21. Transport pass terminology
22. Fake live verification indicators

==================================================
DATA CONSISTENCY
==================================================

VERY IMPORTANT:

The same student must have consistent information across the entire application.

For example:

Portal
→ Student Name
→ Class
→ Section
→ Roll Number
→ House

Digital ID
→ Student Name
→ Class
→ Section
→ Roll Number
→ House

Profile
→ Same student information

Do NOT allow inconsistent mock values.

For example, never show:

Portal:
Class 9-B
Blue Cheetahs

Digital ID:
Grade 5-A
Ruby House

The future API/database must be the single source of truth.

During prototype development, use one consistent mock student dataset across all screens.

==================================================
DATA AVAILABILITY RULE
==================================================

Follow these rules strictly:

IF DATA EXISTS:
Display it.

IF DATA CAN BE CALCULATED:
Calculate it.

IF DATA DOES NOT EXIST:
Do not invent it.

IF DATA IS OPTIONAL:
Hide the field when unavailable.

Do not display empty labels such as:

Blood Group
—

Date of Birth
—

House
—

unless the design system specifically requires an unavailable state.

Prefer hiding unavailable optional fields.

==================================================
EMPTY / MISSING DATA CASES
==================================================

Test:

Student photo unavailable.

Expected:
Profile placeholder.

DOB unavailable.

Expected:
Hide DOB.

Blood group unavailable.

Expected:
Hide Blood Group.

House unavailable.

Expected:
Hide House.

Emergency contact unavailable.

Expected:
Hide Emergency Contact section.

QR unavailable.

Expected:
Do not show a fake QR.

Verification unavailable.

Expected:
Do not show "Verified".

Validity date unavailable.

Expected:
Do not invent a date.

Principal authorization unavailable.

Expected:
Hide authorization section.

==================================================
SECURITY / PRIVACY CASES
==================================================

The digital ID may be shared or viewed outside the application.

Therefore:

Do not expose unnecessary internal identifiers.

Do not expose:

- database primary key
- internal UUID
- API token
- authentication token
- encryption key
- internal hash
- private backend metadata

The QR should contain only what is required for legitimate verification.

==================================================
RESPONSIVE MOBILE DESIGN
==================================================

The screen is designed for Android mobile.

Test:

- small phones
- standard phones
- large phones

The ID must remain readable.

No horizontal scrolling.

Long student names must not break the layout.

Long school names must truncate/wrap gracefully.

Long admission numbers must fit.

QR code must remain large enough to scan.

Buttons must have comfortable touch targets.

==================================================
ACCESSIBILITY
==================================================

Maintain:

- readable text
- sufficient contrast
- clear labels
- accessible touch targets
- meaningful icon labels

Do not rely only on color for:

Verified
Unverified
Valid
Expired

Use text/icon indicators.

==================================================
EXPIRED ID CASE
==================================================

If the validity date has passed:

Show:

ID Expired

or the appropriate system state.

Do not continue showing:

Verified

as though the card were currently valid.

If validity is not implemented by the backend:

do not invent expiration behavior.

==================================================
SHARE / PDF EDGE CASES
==================================================

If sharing fails:

Show an appropriate error state.

If PDF generation fails:

Show:

Unable to generate PDF.

Retry

Do not pretend that the file was generated.

If the student has no permission to share/download:

respect backend/application authorization.

==================================================
FINAL VISUAL RULE
==================================================

The final screen should feel like:

A premium digital school ID card.

It should NOT feel like:

- an ERP admin dashboard
- a cybersecurity console
- a transport dashboard
- a technical verification dashboard
- a document containing backend implementation details

Use whitespace intelligently.

Make the student's identity the visual focus.

==================================================
FINAL DEEP TEST
==================================================

Before finalizing, verify all of these:

1. Can I identify the student within 2–3 seconds?

2. Is the student photo prominent?

3. Is the student name prominent?

4. Are class, section and roll number immediately visible?

5. Is admission number available?

6. Is QR verification easy to find?

7. Is the card validity clear?

8. Is emergency contact available only when valid data exists?

9. Are optional fields hidden when unavailable?

10. Is there only one verification code unless both QR and barcode are genuinely required?

11. Is the CBSE affiliation number removed from the student's identity information?

12. Is "CBSE Live" removed unless real integration exists?

13. Is cryptographic/security implementation information removed?

14. Is synchronization time removed?

15. Is the long Campus Access Protocol removed?

16. Is Transport no longer presented as the primary purpose of the ID?

17. Is principal authorization shown only if genuine?

18. Does Share represent a real future-supported action?

19. Does Download PDF represent a real future-supported action?

20. Is there no fake data?

21. Is there no fake verification?

22. Is there no fake QR?

23. Is the same student data consistent across Portal, Academics, Attendance, Fees, More and Digital ID?

24. Does the screen remain clean on a small Android phone?

25. Does the existing visual design remain unchanged?

==================================================
FINAL INSTRUCTION
==================================================

Refine the existing Digital Student ID screen.

DO NOT create a new visual design.

DO NOT change the application's theme.

DO NOT add new features.

DO NOT invent backend functionality.

DO NOT invent data.

DO NOT use emojis.

Remove unnecessary technical and operational information.

Keep the student's identity and practical verification information as the primary focus.

The final result should be simpler, cleaner, more trustworthy, and easier for a student to use while preserving the existing premium visual quality.
