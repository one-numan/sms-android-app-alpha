# Action Items: Parent – Fees & Dues Screen Design & Implementation

## 1. Scope & Design System Preservation
- [ ] Design and implement the "Parent – Fees & Dues" screen for the existing School ERP mobile application.
- [ ] Strictly preserve the existing approved visual design established by Parent Home, Academics, and Attendance:
  - Color palette, typography, font family, and font hierarchy.
  - Card styling, border radius, spacing system, header style, and button styles.
  - Bottom navigation bar design and styling.
  - Material Symbols / Material Icons and overall visual personality.
- [ ] Do NOT redesign the overall product.
- [ ] Maintain core screen qualities: CLEAR, TRUSTWORTHY, EASY TO UNDERSTAND, EASY TO PAY, and EASY TO VERIFY.
- [ ] Strictly avoid turning this screen into an accountant or admin fee-management dashboard.

## 2. Screen Purpose & Parent Financial Clarity
- [ ] Structure the screen to answer essential parent financial questions within seconds:
  - Which child are these fees for?
  - How much is currently due?
  - When is it due?
  - What is the fee for?
  - What has already been paid?
  - Can I pay the outstanding amount?
  - Can I view/download the official receipt?
- [ ] Ensure immediate comprehension of total financial obligations without digging through complex menus.

## 3. Multi-Child Support & Financial Data Isolation
- [ ] Provide child selector consistent with Parent Home, Academics, and Attendance (e.g., `Diya Sharma • Grade 5-A` vs. `Aarav Sharma • Grade 2-B`).
- [ ] Ensure switching children updates ALL fee information simultaneously:
  - Outstanding balance and due amounts
  - Itemized fee components and due dates
  - Payment history ledger and receipt access
  - Underlying fee structure breakdown
  - Payment status indicators
- [ ] Strictly isolate financial records between siblings—NEVER mix or cross-contaminate fees between children.
- [ ] Render a compact child identity block if the parent has only one registered child.

## 4. Header & Exclusion of Technical/Admission Identifiers
- [ ] Use the existing Parent application header:
  - Title: `Fees`
  - Retain existing back/navigation behavior, search (if part of app), notifications icon, and profile/more controls.
- [ ] Strip internal student admission numbers (e.g., `ADM-2024-0412`), database IDs, API status tokens, and sync timestamps from the parent-facing UI.

## 5. Child & Account Context
- [ ] Display compact child identity immediately below the header:
  - Child full name (e.g., `Diya Sharma`)
  - Class and section (e.g., `Grade 5-A`)
  - Academic session (e.g., `Academic Session 2026–27`)
- [ ] Avoid generic accounting terminology such as "Student Account"; use parent-friendly headings like `Fee Summary` or `Fees & Dues`.

## 6. Primary Fee Summary Card
- [ ] Implement prominent primary overview card:
  - Header/Tag: `TOTAL DUE` or `OUTSTANDING`
  - Large, visually prominent amount (e.g., `₹12,450`)
  - Explicit due date text (e.g., `Due by 15 Nov 2026` or `Next payment due 15 Nov 2026`)
  - Term indicator where applicable (e.g., `Term 2`)
- [ ] Eliminate unnecessary friction—ensure the parent never has to search for the total payable amount.

## 7. Semantic Payment Status Treatments
- [ ] Implement explicit, mutually exclusive payment statuses derived strictly from actual due dates and backend records:
  - `Outstanding`: Current active balance
  - `Paid`: Completely settled fee component
  - `Partially Paid`: Component with partial settlement recorded
  - `Overdue`: Past the official due date without full settlement
  - `Due Soon`: Approaching due date within configured threshold (never label as "Due Soon" simply because an amount exists)
  - `No Outstanding Dues`: All current fees are fully settled
- [ ] Calculate all status indicators dynamically from due dates and payment ledgers.

## 8. Financial Total Calculation Integrity
- [ ] Calculate all financial values dynamically from real fee records:
  $$\text{Outstanding Balance} = \text{Fee Structure} + \text{Applicable Charges} - \text{Payments} - \text{Adjustments/Concessions}$$
- [ ] Prohibit hardcoded or mock currency amounts in production.
- [ ] Use only fields and adjustments explicitly supported by the backend ledger; do not invent frontend accounting rules.

## 9. Outstanding Dues Itemization
- [ ] Create an explicit `Outstanding Dues` section itemizing all unpaid/active fees.
- [ ] For each outstanding fee item, display:
  - Fee Name (e.g., `Tuition Fee`, `Laboratory Fee`, `Transport Fee`, `Annual Activity Fund`)
  - Component Amount (e.g., `₹8,500`)
  - Due Date (e.g., `Due 15 Nov 2026`)
  - Calculated Status badge (e.g., `Due Soon`, `Overdue`)
- [ ] Display only genuine fee categories present in backend data; do not fabricate sample categories.

## 10. Fee Item Detail View
- [ ] Allow tapping any fee item to open a detailed modal or expandable breakdown:
  - Fee title and total component amount
  - Due date and academic session
  - Term / installment designation (e.g., `Term 2`)
  - Current status (e.g., `Due`, `Overdue`, `Partially Paid`)
  - Billing period, installment number, concessions, and approved adjustments if provided by backend
- [ ] Exclude internal accounting ledger codes or database keys.

## 11. Total Outstanding Reconciliation
- [ ] Display reconciled `Total Outstanding` at the bottom of the outstanding dues section.
- [ ] Guarantee mathematical parity across:
  - Primary Fee Summary card
  - Sum of itemized outstanding dues
  - Primary Payment Action button label
- [ ] Eliminate any discrepancy between displayed numbers.

## 12. Payment Action Workflow
- [ ] Provide a prominent primary call-to-action button:
  - Label format: `Pay Outstanding Dues ₹12,450` or `Pay ₹12,450`
- [ ] Support individual fee selection (`Select Fees to Pay` -> `Pay Selected ₹X,XXX`) ONLY if the payment backend supports line-item partial payment.
- [ ] Prevent creation of unsupported partial-payment or custom-amount inputs if the backend mandates full term settlement.

## 13. Payment Safety & Child Confirmation
- [ ] Implement an explicit payment confirmation step prior to initiating the payment gateway:
  - Highlight payable amount prominently (e.g., `You're about to pay ₹12,450`)
  - Re-verify child identity explicitly: child name (e.g., `Diya Sharma`) and grade (e.g., `Grade 5-A`)
  - Clarify fee description (e.g., `Term 2 Outstanding Dues`)
  - Action button: `[ Proceed to Payment ]`
- [ ] Prevent accidental payment for the wrong sibling when managing multiple children.

## 14. Payment Success Handling
- [ ] Trigger payment success screen ONLY after payment gateway and ERP backend verify transaction:
  - Confirmation header: `Payment Successful`
  - Confirmed amount paid (e.g., `₹12,450`)
  - Child name and grade confirmation
  - Official ERP receipt number (e.g., `Receipt: REC-2026-0891`)
  - Action shortcuts: `[ View Receipt ]`, `[ Download Receipt ]`, and `[ Share Receipt ]` (if supported)
- [ ] Prohibit displaying false or optimistic payment success before backend confirmation.

## 15. Payment Failure Handling
- [ ] Handle failed or cancelled transactions gracefully:
  - Status banner: `Payment could not be completed.`
  - Keep outstanding dues intact—do NOT deduct amount or mark items as paid without payment provider confirmation.
  - Provide retry action: `[ Try Again ]`
  - Never generate fake or placeholder receipts on failed attempts.

## 16. Payment History Ledger
- [ ] Provide a compact `Payment History` section strictly separated from outstanding dues.
- [ ] Render chronological rows displaying:
  - Official Receipt Number (e.g., `REC-2026-0891`)
  - Transaction Date (e.g., `10 Jun 2026`)
  - Settled Amount (e.g., `₹14,200`)
  - Payment Method (e.g., `UPI`, `Cheque`, `Card`, `Net Banking`—only actual methods stored in backend)
  - Status indicator (e.g., `Paid`)
  - Direct action: `[ View Receipt ]`
- [ ] Provide `[ View All Payment History ]` pagination if numerous historical records exist.

## 17. Official Receipts Access
- [ ] Enable opening or downloading the official receipt for every completed transaction.
- [ ] Receipt view details:
  - Receipt number and payment date
  - Paid amount and line-item fee component distribution
  - Payment mode and gateway reference / transaction ID
  - School name, affiliation, and authorized stamp/signature details
- [ ] Guard against exposing sensitive banking or payment gateway tokens.

## 18. Secondary Fee Structure Breakdown
- [ ] Implement secondary `Fee Structure` section below payment actions:
  - Clearly distinguish **Fee Structure** (total annual/term charges applicable) from **Outstanding Dues** (unpaid amount required now).
  - List standard fee components and their full scheduled amounts.
- [ ] Prevent parents from confusing standard scheduled fees with immediate payable dues.

## 19. Session Reconciliation (Paid vs. Due)
- [ ] Provide clear session-level financial reconciliation if supported by ERP:
  - Total Session Fees (e.g., `₹26,650`)
  - Total Paid to date (e.g., `₹14,200`)
  - Current Outstanding (e.g., `₹12,450`)
- [ ] Reconcile arithmetic accurately including concessions, scholarships, discounts, and adjustments.

## 20. Term / Installment Organization
- [ ] Adapt layout to the school's configured billing cycles (Term, Installment, Quarter, or Monthly billing).
- [ ] Present term context clearly (e.g., `Term 2 • Due 15 Nov 2026`).

## 21. Overdue Dues Treatment
- [ ] Highlight overdue fees with professional, calm urgency:
  - Semantic warning/danger styling (e.g., `Overdue • ₹4,500 • Due 05 Oct 2026`)
  - Immediate `[ Pay Now ]` action
- [ ] Prohibit alarming, aggressive, or punitive language.
- [ ] Never add penalty or late fee amounts unless explicitly calculated and provided by backend data.

## 22. Upcoming Dues (Future Obligations)
- [ ] Display future unbilled or non-payable dues in a secondary `Upcoming` section (e.g., `Upcoming • ₹8,000 • Due 15 Dec 2026`).
- [ ] Never mix future unbilled dues into the current payable outstanding total.

## 23. Zero Dues & Empty States
- [ ] Implement friendly zero-balance state when all dues are paid:
  - Banner/Card: `No Outstanding Dues`
  - Subtext: `All current fees are paid.`
  - Shortcut to previous receipts: `[ View Payment History ]`
  - Suppress large empty "Pay" button.
- [ ] Handle unconfigured fee data gracefully:
  - Message: `Fee information is not available yet. Please contact the school office for details.`
  - Do NOT display `₹0` unless zero represents a verified zero-balance ledger.

## 24. Partial Payments, Concessions & Adjustments
- [ ] Handle partial payments transparently if supported by backend (Total Fee, Paid, Remaining Balance).
- [ ] Display concessions, scholarships, or discounts transparently (e.g., `Standard Fee ₹15,000`, `Concession −₹2,500`, `Payable ₹12,500`).
- [ ] Display refunds and accounting adjustments in detailed modals (`View Details`), avoiding complex bookkeeping clutter on the main overview.

## 25. Multiple Due Dates Sorting & History Filtering
- [ ] Deterministically sort outstanding items with multiple due dates: Overdue first, followed by Due Soon, then Upcoming.
- [ ] Provide simple filter chips for transaction history (`All`, `Due`, `Paid`, `Overdue`) only if record volume warrants it.

## 26. Academic Year Scoping
- [ ] Scope all fee balances, outstanding items, fee structures, and payment history to the selected Academic Year (e.g., `2026–27`).
- [ ] Refresh all financial components instantly when academic year selection changes.

## 27. Child Switching Workflow & Safeguards
- [ ] When switching siblings (e.g., Diya to Aarav), synchronously update:
  - Fee summary and outstanding balance
  - Itemized dues list
  - Fee structure
  - Payment history and receipts
- [ ] Ensure payment modal strictly re-binds to the currently selected child before transaction execution.

## 28. Privacy & Data Boundaries
- [ ] Ensure absolute privacy: show only the selected child's financial data.
- [ ] Never expose other students' fees, class billing statistics, internal accounting notes, staff workflows, or gateway secrets.

## 29. Mobile-First Responsive Design (320px–480px+)
- [ ] Ensure flawless single-column rendering across 320px, 360px, 375px, 390px, 412px, 430px, and 480px+.
- [ ] Strictly prevent page-level horizontal scrolling.
- [ ] Ensure currency amounts never clip or overlap on narrow viewports (320px–360px).
- [ ] Wrap long fee item titles and receipt numbers naturally without breaking layouts.

## 30. Standardized Currency Formatting
- [ ] Enforce consistent Indian Rupee formatting across all financial surfaces (e.g., `₹12,450`).
- [ ] Do not mix `₹12,450.00`, `₹12,450`, and `12,450 INR` inconsistently.

## 31. Mobile-Optimized Payment History Rows
- [ ] Avoid desktop-style wide financial tables.
- [ ] Format payment history as compact cards/rows:
  - Receipt number, payment amount, date, payment mode badge, status, and receipt link.

## 32. Loading, Error & Offline States
- [ ] Implement skeleton loaders matching financial card dimensions; no fake amounts or mock receipts during load.
- [ ] Provide clean error state with `[ Retry ]` button; preserve cached outstanding dues if history fetch fails.
- [ ] Support future offline caching with "Last updated" timestamp.
- [ ] STRICT REQUIREMENT: Never allow the UI to claim a payment was completed offline or generate offline receipts.

## 33. Parent-Friendly Terminology vs. Accountant Jargon
- [ ] Translate bookkeeping terms into clear parent-friendly language:
  - Use `Total Fees` instead of `Total Session Fee`
  - Use `Paid` instead of `Total Amount Paid`
  - Use `Term Fee` instead of `Standard Term Rate`
  - Use `Fee Summary` instead of `Student Account`
- [ ] Keep outstanding dues visually isolated from completed payment history.

## 34. Screen Separation & Bottom Navigation
- [ ] Strictly isolate Fees from Attendance, Timetable, Marks, and Report Cards.
- [ ] Preserve bottom navigation bar with exact 5 destinations:
  - `Portal | Academics | Attendance | Fees | More`
  - `Fees` must be visibly active/selected.

## 35. Final Quality Check & Validation Checklist
- [ ] Verify Parent role permissions and multi-child isolation.
- [ ] Verify mathematical parity between summary, itemized dues, and payment button.
- [ ] Verify status calculations (Overdue, Due Soon, Paid, No Dues).
- [ ] Verify payment safety confirmation before gateway launch.
- [ ] Verify receipt accessibility and absence of fake success states.
- [ ] Verify zero emojis used across UI; Material Symbols used exclusively.
- [ ] Verify responsive layout across 320px to 480px+ without horizontal overflow.

---

# Original Prompt

Design and implement the “Parent – Fees & Dues” screen for the existing School ERP mobile application.

IMPORTANT:
This is an EXISTING School ERP application.

The existing Parent Home, Parent Academics, and Parent Attendance screens already establish the visual design system.

DO NOT redesign the overall product.

Preserve the existing:
- color palette
- typography
- font family
- typography hierarchy
- card style
- border radius
- spacing
- header style
- button style
- bottom navigation
- Material Symbols / Material Icons
- overall visual personality

The goal is to make the Parent Fees screen:

CLEAR
TRUSTWORTHY
EASY TO UNDERSTAND
EASY TO PAY
EASY TO VERIFY

Do not turn this into an accountant/admin fee-management dashboard.

==================================================
1. SCREEN PURPOSE
==================================================

The Parent Fees screen should answer:

1. Which child are these fees for?
2. How much is currently due?
3. When is it due?
4. What is the fee for?
5. What has already been paid?
6. Can I pay the outstanding amount?
7. Can I view/download the receipt?

The parent should understand their financial obligation within seconds.

==================================================
2. MULTI-CHILD SUPPORT
==================================================

A parent may have multiple children.

The selected child must remain consistent with Parent Home, Academics, and Attendance.

Example:

[ Diya Sharma ]
Grade 5-A

[ Aarav Sharma ]
Grade 2-B

When the parent switches child:

ALL fee information must update.

This includes:
- outstanding amount
- fee items
- due dates
- payment history
- receipts
- fee structure
- payment status

NEVER mix fees from different children.

If there is only one child, show a compact child identity block.

==================================================
3. HEADER
==================================================

Use the existing Parent application header.

Title:

Fees

Use the existing:
- back/navigation behavior
- search if already part of the application
- notifications
- profile/more controls

Do not add technical information.

Do NOT show:
- database IDs
- internal student IDs
- API status
- sync timestamps
- backend identifiers

The current prototype shows:

ADM-2024-0412

Do not display this unless the actual product explicitly requires the parent to see the admission number.

==================================================
4. CHILD / ACCOUNT CONTEXT
==================================================

Below the header, show:

Diya Sharma
Grade 5-A
Academic Session 2026–27

Keep this compact.

The parent must immediately know whose fees they are viewing.

Avoid calling it:

Student Account

unless that terminology is already established in the actual application.

Prefer:

Fee Summary

or:

Fees & Dues

==================================================
5. PRIMARY FEE SUMMARY
==================================================

The most important card should show:

TOTAL DUE

Example:

₹12,450

Outstanding

Due by
15 Nov 2026

If there are multiple due dates, show:

Next payment due
15 Nov 2026

Do not make the parent search for the amount.

The outstanding amount must be visually prominent.

==================================================
6. PAYMENT STATUS
==================================================

Clearly distinguish:

Outstanding
Paid
Partially Paid
Overdue
Due Soon

Only use statuses supported by the backend.

Examples:

Due Soon
₹12,450
Due 15 Nov 2026

or:

Overdue
₹5,000
Due 10 Nov 2026

or:

No Outstanding Dues

if everything is paid.

Do NOT use “Due Soon” simply because an amount exists.

Calculate the status from the actual due date.

==================================================
7. IMPORTANT: TOTAL CALCULATION
==================================================

All financial values must come from real fee records.

Do not hard-code:

₹12,450
₹26,650
₹14,200

These are only examples.

The UI must calculate/display actual values from:

Fee Structure
+
Applicable Charges
-
Payments
-
Adjustments/Concessions
=
Outstanding Balance

Only use fields actually supported by the backend.

Do not invent financial calculations in the frontend.

==================================================
8. OUTSTANDING DUES
==================================================

Create:

Outstanding Dues

Each outstanding fee item should clearly show:

Fee Name
Amount
Due Date
Status

Example:

Tuition Fee
₹8,500
Due 15 Nov 2026

Due Soon

Laboratory Fee
₹1,500
Due 15 Nov 2026

Due Soon

Transport Fee
₹2,000
Due 15 Nov 2026

Due Soon

Annual Activity Fund
₹450
Due 15 Nov 2026

Due Soon

Only display fee categories that actually exist.

Do not invent:

Laboratory Fee
Transport Fee
Activity Fund

unless they are real fee components.

==================================================
9. FEE ITEM DETAIL
==================================================

Tapping a fee item should open a detailed view.

Example:

Tuition Fee

Amount
₹8,500

Due Date
15 Nov 2026

Academic Year
2026–27

Term
Term 2

Status
Due

If the backend provides additional information:

- billing period
- installment
- concession
- adjustment

these may be shown.

Do not expose internal accounting identifiers unless necessary.

==================================================
10. TOTAL OUTSTANDING
==================================================

At the end of the outstanding dues section:

Total Outstanding

₹12,450

This must equal the sum of currently payable outstanding items.

Do not show a contradictory amount between:

Summary
Fee items
Payment button

All three must use the same backend-calculated balance.

==================================================
11. PAYMENT ACTION
==================================================

If online payment is supported, provide a clear primary button:

Pay Outstanding Dues
₹12,450

or:

Pay ₹12,450

The button should be prominent.

If the parent can select individual dues:

[ Select Fees to Pay ]

then:

Pay Selected
₹X,XXX

Only provide partial-payment/selection functionality if the actual payment workflow supports it.

Do NOT create a payment interface that the backend cannot support.

==================================================
12. PAYMENT SAFETY
==================================================

Before payment:

Show the amount clearly.

Example:

You're about to pay

₹12,450

For:

Diya Sharma
Grade 5-A

Fee:
Term 2 Outstanding Dues

[ Proceed to Payment ]

This prevents accidental payment for the wrong child.

If multiple children exist, always show the selected child's name before payment confirmation.

==================================================
13. PAYMENT SUCCESS
==================================================

After a successful payment:

Payment Successful

₹12,450

Diya Sharma
Grade 5-A

Receipt
REC-2026-0891

[ View Receipt ]

If the payment system supports receipt download/share:

[ Download Receipt ]

[ Share Receipt ]

Do not claim payment success until the payment backend confirms it.

==================================================
14. PAYMENT FAILURE
==================================================

If payment fails:

Payment could not be completed.

No amount should be marked as paid unless the payment provider/backend confirms the transaction.

Provide:

[ Try Again ]

Do not create a fake receipt.

==================================================
15. PAYMENT HISTORY
==================================================

Show a compact section:

Payment History

Each record should show:

Receipt Number
Date
Amount
Payment Method
Status

Example:

REC-2026-0891
₹14,200
10 Jun 2026
UPI

Paid

[ View Receipt ]

Another:

REC-2025-0422
₹13,800
15 Dec 2025
Cheque

Paid

[ View Receipt ]

Only display payment methods actually stored by the backend.

Do not invent:

UPI
Cheque
Cash
Card

if those values are not available.

==================================================
16. RECEIPTS
==================================================

Every completed payment should provide access to its official receipt if the backend supports receipts.

Example:

View Receipt →

Receipt detail may contain:

- receipt number
- payment date
- amount
- fee components
- payment method
- transaction/reference number where appropriate
- school information

Do not expose sensitive payment information unnecessarily.

==================================================
17. FEE STRUCTURE
==================================================

A fee structure breakdown can be useful, but it should remain SECONDARY.

Title:

Fee Structure

Example:

Tuition Fee
₹8,500

Laboratory Fee
₹1,500

Transport Fee
₹2,000

Annual Activity Fund
₹450

Total
₹12,450

IMPORTANT:

Clearly distinguish:

Fee Structure

from:

Outstanding Dues

A fee structure tells the parent what charges apply.

Outstanding dues tell the parent what they currently need to pay.

Do not make the parent confuse the two.

==================================================
18. PAID VS DUE
==================================================

Do not simply show:

Total Session Fee
₹26,650

Total Paid
₹14,200

unless these values are meaningful and correctly calculated from the actual fee ledger.

If shown, clearly explain:

Session Fees
₹26,650

Paid
₹14,200

Outstanding
₹12,450

The arithmetic must reconcile.

If the application has concessions, discounts, refunds, or adjustments, use the actual accounting model rather than simplifying incorrectly.

==================================================
19. TERM / INSTALLMENT
==================================================

If fees are organized by:

Term
Installment
Quarter
Monthly billing

show the applicable structure.

Example:

Term 2

Outstanding
₹12,450

Due
15 Nov 2026

Do not assume all schools use the same fee cycle.

Use actual backend data.

==================================================
20. OVERDUE FEES
==================================================

If a fee is overdue, make it clear.

Example:

Overdue

₹4,500

Due 05 Oct 2026

[ Pay Now ]

Do not use alarming language.

Keep the design professional.

Do not automatically add penalties unless the backend actually provides the penalty amount.

==================================================
21. UPCOMING DUES
==================================================

If the parent has future dues that are not currently payable, optionally show:

Upcoming

₹8,000

Due 15 Dec 2026

This is useful but secondary.

Do not mix future dues into the current outstanding total.

==================================================
22. NO OUTSTANDING DUES
==================================================

If the child has no unpaid fees:

No Outstanding Dues

All current fees are paid.

If payment history exists:

[ View Payment History ]

Do not show a large empty “Pay” card.

==================================================
23. NO FEE DATA
==================================================

If no fee information is configured:

Fee information is not available yet.

Please contact the school office for details.

Do not show:

₹0

unless ₹0 is a genuine account balance.

==================================================
24. PARTIAL PAYMENT
==================================================

If partial payments are supported:

Clearly show:

Total Fee
₹20,000

Paid
₹8,000

Remaining
₹12,000

If partial payment is NOT supported:

Do not create a “Pay Custom Amount” control.

==================================================
25. CONCESSIONS / SCHOLARSHIPS
==================================================

If the actual fee system supports:

- concession
- scholarship
- discount

show it transparently.

Example:

Standard Fee
₹15,000

Concession
−₹2,500

Payable
₹12,500

Do not hide adjustments inside unexplained numbers.

Do not introduce scholarship information if it is not part of the actual fee data.

==================================================
26. REFUNDS / ADJUSTMENTS
==================================================

If the backend supports refunds or adjustments, they may appear in payment/fee details.

Do not put complex accounting adjustments on the main Home-style summary.

Use:

View Details →

for complex financial information.

==================================================
27. MULTIPLE DUE DATES
==================================================

If different fees have different due dates:

Sort by:

1. Overdue
2. Due soon
3. Upcoming

or another deterministic date-based ordering.

Do not arbitrarily reorder fees.

Each fee must show its own due date.

==================================================
28. FILTERING
==================================================

If there are many fee records, provide simple filters:

All
Due
Paid
Overdue

Only if necessary.

Do not add filters if the account has only a few records.

Keep the UI simple.

==================================================
29. ACADEMIC YEAR
==================================================

Fees must be scoped to the selected academic year.

Example:

Academic Year
2026–27 ▼

When the year changes, update:

- outstanding dues
- fee structure
- payment history
- receipts

Do not mix payments from different academic years without clearly identifying them.

==================================================
30. CHILD SWITCHING
==================================================

If the parent has:

Diya Sharma
Grade 5-A

and:

Aarav Sharma
Grade 2-B

switching the child must update:

Fee summary
Outstanding dues
Fee structure
Payment history
Receipts

The payment action must also use the selected child.

Before payment, confirm:

Child:
Diya Sharma

==================================================
31. PRIVACY
==================================================

Only show the selected child's financial information.

Never expose:

- another child's fees
- another parent's information
- internal accounting notes
- staff-only financial information
- database identifiers
- internal payment processing details

==================================================
32. MOBILE-FIRST DESIGN
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

No wide financial tables.

No desktop-style ledger.

No tiny text.

No clipped amounts.

No overlapping content.

Currency values must remain clearly readable.

Long fee names must wrap naturally.

Long receipt numbers must not break the layout.

The PAGE must never have horizontal overflow.

==================================================
33. CURRENCY DISPLAY
==================================================

Use Indian Rupee formatting.

Example:

₹12,450.00

or:

₹12,450

Use one consistent format throughout the application.

Do not mix:

₹12,450.00
₹12,450
12,450 INR

randomly.

Follow the existing product currency formatting.

==================================================
34. PAYMENT HISTORY ON MOBILE
==================================================

Do not use a wide table.

Use compact rows:

REC-2026-0891

₹14,200
10 Jun 2026 · UPI

Paid

View Receipt →

This is easier to read on small screens.

==================================================
35. LOADING STATE
==================================================

Use skeleton placeholders.

Do not show fake:

- balances
- fee amounts
- receipt numbers
- payment dates

while loading.

==================================================
36. ERROR STATE
==================================================

If fees cannot be loaded:

Unable to load fee information.

[ Retry ]

Do not expose:

- API errors
- database errors
- stack traces
- payment gateway technical messages

If only payment history fails, keep outstanding dues visible if available.

==================================================
37. OFFLINE SUPPORT
==================================================

The application will support offline operation later.

Fee information can be cached for viewing where appropriate.

However:

DO NOT allow the UI to falsely claim that a payment was completed while offline.

Payment requires appropriate online confirmation unless the actual payment architecture explicitly supports another flow.

If cached information is displayed:

Last updated

may be shown when appropriate.

Do not claim:

Paid just now
Payment successful
Receipt generated

without backend confirmation.

==================================================
38. PAYMENT SECURITY / TRUST
==================================================

The payment flow should feel trustworthy.

Before payment:

show:
- selected child
- amount
- fee purpose

After payment:

show:
- confirmed amount
- payment status
- receipt/reference if confirmed

Never make the parent uncertain about:

“What am I paying for?”

==================================================
39. HOME SCREEN RELATIONSHIP
==================================================

Parent Home should show only a summary:

₹12,500 Outstanding
Due in 18 days

Fees screen should provide the details:

Outstanding Dues
Fee breakdown
Payment
Payment history
Receipts

Do not duplicate the complete ledger on Home.

==================================================
40. ACADEMICS / ATTENDANCE SEPARATION
==================================================

Do not show:

Attendance
Marks
Report Card
Subject Performance

on the Fees screen.

Keep each Parent section focused.

==================================================
41. BOTTOM NAVIGATION
==================================================

Use exactly:

Portal
Academics
Attendance
Fees
More

Fees must be the active/selected tab.

Do NOT change the Parent bottom navigation.

Do not add:

Payments
Transport
Results

as separate bottom-navigation items.

==================================================
42. RECOMMENDED FINAL SCREEN
==================================================

HEADER

← Fees                         Search  Bell  More

CHILD CONTEXT

Diya Sharma
Grade 5-A
Academic Session 2026–27

FEE SUMMARY

┌───────────────────────────────┐
│ OUTSTANDING                   │
│                               │
│ ₹12,450                       │
│                               │
│ Due by 15 Nov 2026            │
│ Term 2                        │
└───────────────────────────────┘

OUTSTANDING DUES

Tuition Fee
₹8,500
Due 15 Nov 2026

Laboratory Fee
₹1,500
Due 15 Nov 2026

Transport Fee
₹2,000
Due 15 Nov 2026

Annual Activity Fund
₹450
Due 15 Nov 2026

───────────────────────────────

Total Outstanding
₹12,450

[ Pay ₹12,450 ]

FEE STRUCTURE

Tuition Fee                 ₹8,500
Laboratory Fee              ₹1,500
Transport Fee               ₹2,000
Annual Activity Fund          ₹450

Total                       ₹12,450

PAYMENT HISTORY

REC-2026-0891
₹14,200
10 Jun 2026 · UPI
Paid

[ View Receipt ]

REC-2025-0422
₹13,800
15 Dec 2025 · Cheque
Paid

[ View Receipt ]

[ View All Payment History ]

BOTTOM NAVIGATION

Portal | Academics | Attendance | Fees | More

==================================================
43. IMPORTANT: DO NOT COPY ACCOUNTANT UI
==================================================

The current reference contains several accounting-oriented concepts.

Do not blindly copy them.

The parent does NOT need:

- internal student account labels
- internal admission IDs
- complicated accounting terminology
- internal settlement information
- staff/accountant workflow
- technical payment details

Translate financial data into simple parent-friendly language.

Instead of:

“Total Session Fee”

prefer:

“Total Fees”

Instead of:

“Total Amount Paid”

prefer:

“Paid”

Instead of:

“Standard Term Rate”

prefer:

“Term Fee”

Use terminology that a parent can understand immediately.

==================================================
44. IMPORTANT: PAYMENT HISTORY VS OUTSTANDING
==================================================

These must be visually separated.

OUTSTANDING DUES

What the parent needs to pay now.

PAYMENT HISTORY

What the parent has already paid.

Do not combine them into one confusing ledger.

==================================================
45. DATA SOURCE PRINCIPLE
==================================================

Use actual project fee data.

Conceptually:

Parent
→ Student / Child
→ Academic Year
→ Fee Structure
→ Fee Allocation / Charges
→ Payments
→ Outstanding Balance
→ Receipts

Use actual backend models and API fields.

Do not create frontend-only financial records.

Do not invent fee categories.

Do not invent payment records.

Do not invent receipts.

==================================================
46. FINAL UX PRINCIPLE
==================================================

The parent should open Fees and immediately understand:

“Do I need to pay anything?”

If yes:

“How much?”

“When?”

“What is it for?”

Then:

“How can I pay?”

After payment:

“Where is my receipt?”

That is the entire primary workflow.

Keep it simple.

==================================================
47. FINAL QUALITY CHECK
==================================================

Before completing the implementation, verify:

- Parent role is respected.
- Selected child is obvious.
- Multiple children work correctly.
- Switching children updates ALL financial data.
- Academic year is respected.
- Outstanding amount is accurate.
- Fee item totals reconcile.
- Due dates are real.
- Overdue status is real.
- Due Soon status is calculated correctly.
- Paid status is real.
- Partial payment is handled only if supported.
- Concessions are handled only if supported.
- Refunds are handled only if supported.
- Payment history uses real records.
- Receipts use real records.
- Payment button uses the actual outstanding amount.
- Payment confirmation uses the selected child.
- No fake payment success exists.
- No fake receipt exists.
- No fake fee categories exist.
- No fake amounts exist.
- No fake dates exist.
- No internal admission IDs are unnecessarily exposed.
- No accountant-only information is exposed.
- No teacher information is shown.
- No attendance information is duplicated.
- No academic information is duplicated.
- No technical information is shown.
- No unsupported payment features are introduced.
- No regulatory/legal financial claims are hard-coded.
- Currency formatting is consistent.
- Loading state works.
- Error state works.
- Empty state works.
- Offline viewing is compatible with future implementation.
- Payment cannot falsely appear successful offline.
- 320px works.
- 360px works.
- 375px works.
- 390px works.
- 412px works.
- 430px works.
- 480px+ works.
- No page-level horizontal overflow.
- Long fee names work.
- Long receipt numbers work.
- Amounts remain readable.
- Touch targets are usable.
- Existing visual design is preserved.
- Material Symbols / existing icon system is used consistently.
- No emojis are used.
- Bottom navigation remains:

Portal | Academics | Attendance | Fees | More

- Fees is visibly selected.

MOST IMPORTANT:

Do not make this screen an accounting system for parents.

Make it a simple financial information and payment screen where the parent can understand their child's fees, pay what is due, and access official payment receipts with confidence.
