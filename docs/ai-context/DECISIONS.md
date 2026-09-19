# ONPS School ERP — Architecture & Design Decisions (`DECISIONS.md`)

> **Record of Architectural Decisions (ADR)**: Permanent record of core structural, visual, and operational decisions.

---

## Decision ADR-01: In-Memory Mock Repository First
- **Decision**: Finalize UI presentation and navigation routing against `MockData` singleton prior to connecting live backend REST APIs.
- **Reason**: Allows fast validation of full operational flows across 9 user roles on physical devices without backend server latency or network failures.
- **Status**: **Accepted**

---

## Decision ADR-02: Offline SQLite FAQ Engine
- **Decision**: Use native SQLite (`sqflite: ^2.3.3+1`) for the Help & FAQ Knowledge Base (`onps_erp.db`).
- **Reason**: Guarantees zero-latency full-text search and offline access for institutional help even when cellular network is unavailable.
- **Status**: **Accepted**

---

## Decision ADR-03: Subject Teacher & Class Teacher Role Model
- **Decision**: Model Subject Teacher and Class Teacher as operational assignments attached to a `Teacher` entity, not separate permanent user classes.
- **Reason**: Teachers in K-12 schools frequently hold homeroom class responsibilities while simultaneously teaching subject courses across multiple grades.
- **Status**: **Accepted**

---

## Decision ADR-04: Read-Only Fee Dues Policy
- **Decision**: Mobile application presents read-only dues summaries and official fee receipt vouchers; live monetary transactions are handled off-app or via simulated accounts office reconciliation.
- **Reason**: Complies with institutional accounting security and prevents incomplete payment gateway states on mobile devices.
- **Status**: **Accepted**

---

## Decision ADR-05: Strict Zero Emoji Mandate
- **Decision**: Prohibit unicode emojis across all screen widgets, tooltips, dialogs, and navigation labels.
- **Reason**: Standardizes visual presentation under the Espresso Heritage Academic Design System using high-clarity Material Symbols exclusively.
- **Status**: **Accepted**
