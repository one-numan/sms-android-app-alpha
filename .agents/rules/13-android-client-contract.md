# Android Client Contract Rules

## 1. API Contract Stability
Before changing an existing endpoint field name, type, structure or semantics, search the Android/Flutter client for consumers. Breaking changes require Android coordination.

## 2. Additive-Only Changes
Prefer adding fields. Removing/renaming/changing meaning or type of consumed fields requires a deprecation/migration window, client coordination, documentation and tests. Never silently break a client.

## 3. Consistent Error Envelope
Use the project's standard error shape:
```json
{"status":"error","message":"Human-readable message","error_code":"STABLE_MACHINE_CODE"}
```
Additional metadata is allowed. Do not create endpoint-specific ad-hoc error formats.

## 4. Consistent Pagination
Use the established `StandardResultsPagination` contract for list endpoints so Android pagination remains generic. Exceptions must be documented, justified and tested.

## 5. UTC + ISO 8601
Server timestamps must be UTC ISO 8601, e.g. `2026-09-27T12:30:00Z`. Never return implicit server-local time. This is critical for timetable, attendance, transactions, notices and sync metadata.

## 6. Nullable vs Default Stability
API nullability is contract. Do not silently change `always present + default` into missing/null or vice versa. Coordinate client migration and update tests/models.

## 7. Idempotent Mobile Writes
Retryable mobile writes must be idempotent or duplicate-safe. Applies to attendance, leave, marks submission, fee/payment operations, transactions and other state-changing actions. Use idempotency keys, unique constraints, request IDs, safe upserts or transactions as appropriate.

## 8. Never Trust Client-Computed Values
Never treat client-sent counts, totals, balances, attendance percentages, grades, permissions, roles, payment state or ownership as authoritative. Recompute or verify server-side.

## 9. Token Contract Stability
Do not silently change access/refresh lifetimes, claims, refresh endpoint/request/response, rotation behavior, expiration semantics or auth failure behavior. Token changes require Android impact analysis and authentication regression tests.

## 10. Mobile-Aware Payloads
Avoid unnecessary deep nesting, duplicate objects, huge collections, unused fields and unbounded lists. Prefer filtering, pagination, scoped queries and compact serializers. Do not remove fields blindly; search actual Android consumers first.

## Contract Change Checklist
- [ ] Android/Flutter consumers searched
- [ ] Field names preserved
- [ ] Field types preserved
- [ ] Semantics preserved
- [ ] Additive change used where possible
- [ ] Error envelope preserved
- [ ] Pagination contract preserved
- [ ] UTC/ISO timestamps preserved
- [ ] Nullability/default contract preserved
- [ ] Idempotency considered
- [ ] Client-computed values not trusted
- [ ] Token contract preserved
- [ ] Payload size reviewed
- [ ] API tests updated
- [ ] Android impact documented

> **Backend correctness includes maintaining a stable, explicit and mobile-safe contract for every supported Android client.**
