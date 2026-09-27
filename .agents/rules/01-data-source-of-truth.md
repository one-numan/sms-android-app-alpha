# Data Source of Truth
Backend database is authoritative for production business data.
Required lineage:
`DB → Django → Service/Selector → Permission → Serializer → API → Flutter → State → UI`.
Never hardcode production counts, attendance, marks, fees, timetable, roles, permissions or dashboard metrics. Trace incorrect values backward before changing code.
