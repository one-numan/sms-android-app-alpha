# ONPS School ERP — UI / UX Design & Styling Rules (`UI_UX_RULES.md`)

> **Mandatory Directive**: The visual design of ONPS ERP is APPROVED. **DO NOT REDESIGN**. Preserve existing colors, typography, spacing, card hierarchies, navigation style, and component patterns.

---

## 1. Espresso Heritage Academic Design System Tokens

### 1.1 Color Palette
- **Canvas Background**: `#FCFAF6` (`AcademicColors.canvas`) — Warm ivory cream matte eliminating clinical white glare.
- **Primary Dark**: `#3E2A22` (`AcademicColors.primaryDark`) — Deep espresso brown for headers, primary buttons, and key typography.
- **Surface**: `#F7F1E8` (`AcademicColors.surface`) — Warm soft cream for card containers and inset panels.
- **Accent Gold**: `#D4AF37` (`AcademicColors.accent`) — Academic gold for badges, highlights, and active tab indicators.
- **Secondary Neutral**: `#7C685E` (`AcademicColors.secondary`) — Muted warm taupe for secondary body text and icons.
- **Success Green**: `#2E6F40` — Used strictly for Present status (`P`) and cleared fees.
- **Warning Amber**: `#B87333` — Used strictly for Late status (`L`) and pending reviews.
- **Danger Red**: `#A63A3A` — Used strictly for Absent status (`A`) and overdue items.

---

## 2. Strict Design & Component Rules

### Rule 2.1: Zero Unicode Emoji Policy (HARD RULE)
- **NO UNICODE EMOJIS** in any user interface component, button label, notification text, app bar title, tab, badge, or toast message.
- Use **Material Symbols** or **Material Icons** exclusively (e.g., `Icons.school_outlined`, `Icons.receipt_long_outlined`).

---

### Rule 2.2: Typography Hierarchy
- **Primary Headers**: `GoogleFonts.newsreader` (700 Bold / Serif) — Academic editorial hierarchy for screen titles, modal headers, and hero cards.
- **Body & Subtitles**: `GoogleFonts.inter` or standard sans-serif — Clean readability for data tables, form fields, and metadata labels.

---

### Rule 2.3: Mobile Touch Targets & Responsiveness
- **Touch Target Floor**: Minimum $\ge 44\text{px}$ width and height for all clickable buttons, action chips, list items, and icons.
- **Viewport Bounds**: 100% responsive down to 320px screen width. Horizontal scrolling prohibited on full pages; restricted strictly to horizontal filter chip bars.
- **Text Truncation Guard**: All labels paired next to badges or steppers inside horizontal `Row` containers MUST be wrapped in `Expanded` or `Flexible` with `TextOverflow.ellipsis` to prevent `RenderFlex` overflows.

---

### Rule 2.4: Empty, Loading, and Error States
- Every data view MUST render a clean, branded state widget when data is loading, empty, or un-authenticated:
  - Empty State: Clean icon + newsreader title + short descriptive guidance.
  - Loading State: Circular progress indicator in `AcademicColors.primaryDark` theme.
  - No Fake Data: NEVER fill empty lists with placeholder names, fake grades, or dummy numbers to make screens look busy.
