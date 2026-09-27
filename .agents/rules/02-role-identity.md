# Role Identity
Roles are distinct: Principal, Teacher, Class Teacher, Subject Teacher, Student, Parent, Staff/Accountant and configured roles.
Never infer role from username, email, display name, `is_staff`, `is_superuser` or frontend defaults.
Principal does not become a teacher role without explicit backend assignment. Never select the first available teacher/class/subject as fallback.
