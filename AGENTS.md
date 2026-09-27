# ONPS School Management System — AI Agent Constitution

## 0. Purpose
These rules are mandatory for AI coding agents working on the ONPS School Management System and Android/Flutter client.

> **Database/backend is the source of truth. Android/Flutter represents backend truth. UI must never invent production business truth.**

## 1. Rule Priority
1. Security and authorization
2. Data integrity and source of truth
3. API/client contract stability
4. Existing architecture
5. Functional requirements
6. UI/UX
7. Performance
8. Cosmetic preferences

## 2. Mandatory AI Workflow

Scale effort to the task. For a trivial/mechanical task (running or
building the app, a one-line fix, a docs/rule edit), just do it and
read only the one rule file that's directly relevant, if any — don't
read every numbered rule file first. The steps below are for
substantial work (new feature, auth/data/contract-affecting change).

Before changing code:
1. Read relevant rules.
2. Inspect existing implementation.
3. Trace affected data flow.
4. Identify root cause.
5. Search consumers/dependencies.
6. Make the smallest safe change.
7. Run relevant validation.
8. Re-read requirements.
9. Classify every requirement.
10. Report actual status.

Never claim completion merely because code was written.

## 3. Root-Cause-First
Trace defects through:
`Database → Django model/queryset → service/selector → permission/RBAC → serializer → API → Flutter service → model → provider/state → UI`.

Do not patch a lower layer to hide an authoritative upper-layer defect.

## 4. Database Source of Truth
Production values must come from authoritative backend/database data. Never invent or hardcode business counts, attendance, marks, fees, timetable, class membership, roles, permissions, or dashboard metrics.

## 5. Data Lineage
Important values must be traceable:
`MySQL → Django → Service/Selector → Permission → Serializer → REST API → Flutter API Service → Model → State → UI`.

## 6. Count Consistency
For the same scope, counts must agree across screens. If they differ, investigate session, class, filtering, permissions, pagination, active/deleted records and query differences. Never hardcode one screen to match another.

## 7. Academic Session
Academic session is a first-class scope. Never mix records from different sessions.

## 8. Class/Section Identity
Use stable IDs, never display labels as identity. Display examples:
`Nursery A → N - A`, `LKG A → L - A`, `UKG A → U - A`, `Grade 1 A → 1 - A`, `Grade 10 A → 10 - A`.

## 9. Role Identity
Roles are distinct: Principal, Teacher, Class Teacher, Subject Teacher, Student, Parent, Staff/Accountant and other configured roles. Never infer role from username, email, display name, `is_staff`, `is_superuser`, or frontend defaults.

## 10. Authentication ≠ Role ≠ Authorization
Successful authentication does not prove role, dashboard entitlement, assignment, or resource authorization. Authorization is server-side.

## 11. Principal Integrity
A Principal must not automatically become Teacher/Class Teacher/Subject Teacher because of admin, staff, superuser, or fallback logic. Explicit backend assignments determine those capabilities.

## 12. Teacher Integrity
Teacher, Class Teacher and Subject Teacher are distinct. Actual assignments determine classes, subjects, timetable, attendance and marks scope. Never inject an arbitrary teacher/class/subject when assignment is absent.

## 13. No Role Fallback
Never fall back to another role, first available teacher, first class, first subject, or arbitrary assignment. Return the correct empty/error state.

## 14. Authorization / IDOR
Every protected resource requires server-side authorization. Verify authenticated identity, role, ownership, assignment, session and resource scope. Never trust client IDs without authorization.

## 15. Data Isolation
Test login/logout, role switch, token refresh, invalid credentials, back navigation, restart and cache reuse. Protected data must not leak across users or sessions.

## 16. API Contract
REST APIs are contracts. Before changing an endpoint field name/type/structure/semantics, search Android/Flutter consumers and coordinate breaking changes.

## 17. API States
Keep loading, success, empty, authentication failure, authorization failure, validation failure, network failure and server failure distinct. Never turn an error into fake success/empty data.

## 18. Mock Data
Production code must not depend on mock/fake data. Audit mock classes, static personas, fake counts, hardcoded records, fallback JSON, placeholder dashboards and default role injection. Test fixtures must be isolated.

## 19. Offline Cache
SQLite/local cache is a client representation, not a competing source of truth. Backend is authoritative when connected. Cache needs freshness, session isolation and safe synchronization.

## 20. Freshness
Attendance, timetable, fees, notices, marks and roster data must not silently appear permanently fresh. Implement appropriate refresh/sync semantics.

## 21. Timetable
Current/next period must use actual date/time/day/session/assignment, not list index.

## 22. Attendance
Attendance is scoped by the backend-defined student/teacher/date/session rules. Never fabricate it.

## 23. Marks
Marks are session scoped and follow backend assessment definitions. Never trust client-calculated totals or grades.

## 24. Fees
Fees, balances, payment state, receipts and transaction status are backend authoritative. Never trust client totals/payment status.

## 25. Digital Identity
Digital IDs use authoritative data. QR/barcode payloads must not expose unnecessary sensitive data.

## 26. Navigation
Routes must correspond to real screens. Before changing routes inspect router, role navigation, deep links, back stack and tests.

## 27. State Preservation
Do not unintentionally destroy tab state, scroll position, filters, selections, pagination or loaded data.

## 28. UI Design
Use professional icons, no emoji UI, mobile-first layouts, consistent spacing, readable hierarchy and responsive sizing.

## 29. Role Colors
Principal=Gold; Class Teacher=Purple; Subject Teacher=Green; Student=Blue; Staff=Platinum.

## 30. Dashboard
Dashboards are not DB dumps. Class Teacher priority:
`Greeting → My Class → Today's Attendance → Today's Teaching Schedule → Quick Actions → Needs Attention → Important Notices`.

Avoid duplicate sections.

## 31. Shared Components
Before modifying a shared component, find all consumers and assess role/screen impact. Prefer screen-scoped changes when the requirement is screen-specific.

## 32. Credential Entry — Mandatory
Before EVERY Android login:
1. Verify exact username against authoritative seed data.
2. Verify exact matching password.
3. Clear username.
4. Clear password.
5. Enter username.
6. Enter password.
7. Re-check pair integrity.
8. Submit.

Never assume a previous password, reuse another persona's password, or allow stale autofill. Negative tests must be labeled `INVALID CREDENTIAL TEST`. Never expose passwords. Do not classify a login failure as an app/backend defect until credentials are independently verified.

## 33. Security Logging
Never log passwords, access/refresh tokens, secrets, or unnecessary sensitive information. Redact sensitive values.

## 34. Physical Device Testing
When requested, verify device connectivity, package, backend environment, credentials, network path, real API responses, crashes/ANRs and session lifecycle. Do not claim physical verification if it was not performed.

## 35. Local Backend
A physical Android device cannot reach the host backend through `127.0.0.1`. Use a LAN-accessible backend address and verify connectivity independently.

## 36. Real Data Validation
For critical values validate:
`Database → API → Flutter model → UI`.

## 37. Testing
Use relevant backend tests, API tests, `flutter analyze`, `flutter test`, integration/device tests, auth/RBAC, network failure, cache and lifecycle tests as applicable.

## 38. Failure Classification
Use:
`APPLICATION DEFECT`, `BACKEND DEFECT`, `DATA/SEED DEFECT`, `TEST DEFECT`, `ENVIRONMENT DEFECT`, `INFRASTRUCTURE DEFECT`, `CREDENTIAL ERROR`, `NOT VERIFIED`.

## 39. No False Verification
Never claim tested, verified, passed, API-compatible, crash-free or production-ready without actual verification.

## 40. Definition of Done
A task is DONE only after requirements are understood, implementation inspected, root cause addressed, dependencies checked, validation run and inspected, blockers resolved, Git checked, and status reported.

## 41. Required Status
Every task must use:
`DONE`, `PARTIALLY DONE`, `PENDING`, `BLOCKED`, `NOT VERIFIED`, `NOT APPLICABLE`.

## 42. Final Report
For substantial tasks report:
`STATUS`, `CHANGES`, `VALIDATION`, `KNOWN ISSUES`, `GIT`, `NEXT TASK`.

## 43. Git Safety
Never push remotely unless explicitly authorized. Before completion inspect:
`git status`, `git diff`, `git log -1`.

## 44. Database Safety
Never silently modify authoritative data to make UI/tests pass. Migrations, seeds and destructive changes must be explicit.

## 45. Minimum Change
Prefer the smallest safe change that solves the root cause. Do not refactor unrelated code during focused fixes.

## 46. Existing Architecture First
Inspect existing services, selectors, repositories, providers, API clients and shared widgets before introducing new patterns.

## 47. Documentation
API, auth/RBAC, schema, deployment and testing procedure changes require relevant documentation updates.

## 48. AI Communication
Explicitly distinguish `VERIFIED`, `NOT VERIFIED`, `ASSUMPTION`, and `BLOCKED`.

## 49. Conflict Resolution
Preserve security and data integrity first, inspect actual behavior, make the smallest compatible correction and document conflicts.

## 50. Master Principle
> **Backend/database owns business truth. API owns the contract. Flutter/Android consumes the contract. UI presents the state. No layer may silently invent or override authoritative truth.**

Detailed rules:
- `.agents/rules/01-data-source-of-truth.md`
- `.agents/rules/02-role-identity.md`
- `.agents/rules/03-authorization-rbac.md`
- `.agents/rules/04-api-data-lineage.md`
- `.agents/rules/05-flutter-architecture.md`
- `.agents/rules/06-ui-design-system.md`
- `.agents/rules/07-offline-cache.md`
- `.agents/rules/08-security.md`
- `.agents/rules/09-mock-data.md`
- `.agents/rules/10-testing-verification.md`
- `.agents/rules/11-credential-entry.md`
- `.agents/rules/12-git-release.md`
- `.agents/rules/13-android-client-contract.md`
- `.agents/rules/14-run-and-verify.md`
- `.agents/rules/wireless_debugging_rule.md`
- `.agents/rules/task_completion_verification.md`
