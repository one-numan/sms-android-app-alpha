# Authorization and RBAC
Authentication, role and authorization are separate. Backend must verify identity, role, ownership, assignment, academic session and resource scope. Flutter navigation is not authorization. Every client-provided resource ID must be authorization-checked server-side. Prevent IDOR and cross-user leakage.
