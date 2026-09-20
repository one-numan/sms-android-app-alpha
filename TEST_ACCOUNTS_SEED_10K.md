# Test Accounts — `seed_10k` demo dataset

Source: `apps/core/management/commands/seed_10k.py` (fixed `random.seed(20260917)`, deterministic on a fresh DB).
Run with: `python manage.py seed_10k` (add `--flush` to rebuild).

**Do not use for production.** These are synthetic QA/demo credentials only — every account
below uses a shared, non-random password that is hardcoded in the seed script itself.

## Students (QA Login Test Accounts — password: `student12345`)

| # | Username | Password | Student Name | Admission No | Roll No | Class & Section | Academic Session | Data Attributes |
|---|----------|----------|--------------|--------------|---------|-----------------|------------------|-----------------|
| 1 | `student.bushra` | `student12345` | Bushra Malik | `ADM-2026-0001` | `#1` | Class 8-A | `2026-27` | Complete Data (Dues: ₹53,579.75, Report Card: Grade A1, Attendance: 92%) |
| 2 | `student.diya` | `student12345` | Diya Sharma | `ADM-2024-0412` | `#14` | Grade 5-A | `2026-27` | Secondary Cohort (Dues: ₹12,450.00, Report Card: Grade B2, Attendance: 80%) |

## Teachers (10 of ~65, shared password: `teacher12345`)

Deterministic first 10 from the seed's cricketer name pool + fixed RNG seed:

| # | Username | Name | Email |
|---|----------|------|-------|
| 1 | `washingtonsundar` | Washington Sundar | washingtonsundar@school.example |
| 2 | `shubmangill` | Shubman Gill | shubmangill@school.example |
| 3 | `souravganguly` | Sourav Ganguly | souravganguly@school.example |
| 4 | `gautamgambhir` | Gautam Gambhir | gautamgambhir@school.example |
| 5 | `shikhapandey` | Shikha Pandey | shikhapandey@school.example |
| 6 | `anujapatil` | Anuja Patil | anujapatil@school.example |
| 7 | `renukasingh` | Renuka Singh | renukasingh@school.example |
| 8 | `minnumani` | Minnu Mani | minnumani@school.example |
| 9 | `rahuldravid` | Rahul Dravid | rahuldravid@school.example |
| 10 | `ishantsharma` | Ishant Sharma | ishantsharma@school.example |

All other teachers created by this seed (Indian men's/women's cricket squad names) use the same
password: `teacher12345`.

## Principal & Vice Principal (1 each — fixed usernames, not randomized)

| Role | Username | Password |
|------|----------|----------|
| Principal (Mohd Numan) | `principal.numan` | `principal12345` |
| Vice Principal (Sachin Tendulkar) | `viceprincipal.tendulkar` | `viceprincipal12345` |

## Notes

- Verify the exact 10 usernames above against a real DB before relying on them.
- These accounts exist after `seed_10k` has actually been run against the target database.
- Student credentials use the shared QA test password `student12345`.
