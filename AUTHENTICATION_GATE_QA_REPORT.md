# AUTHENTICATION GATE QA

## 1. Test Account
- **Role:** Class Teacher
- **Username:** `washingtonsundar`
- **Password:** `teacher12345`
- **Gate Status:** PASS

---

## 2. Login API
- **Target Endpoint:** `https://alpha.onenuman.com/api/v1/auth/login/`
- **HTTP Method:** `POST`
- **Request Payload:** `{"username": "washingtonsundar", "password": "teacher12345", "role": "class_teacher"}`
- **HTTP Response Code:** `200 OK`
- **Access Token Present:** `YES`
- **Refresh Token Present:** `YES`

---

## 3. HTTP Authentication Result
- **HTTP Status:** `200 OK`
- **Handshake Result:** `SUCCESSFUL`
- **Credentials Accepted:** `TRUE`

---

## 4. JWT Verification
- **Token Format:** Standard 3-part Base64 URL encoded JWT string.
- **Redacted Access Token:** `eyJhbGciOiJIUzI1NiIsInR5cCI6Ik...<REDACTED>`
- **Redacted Refresh Token:** `eyJhbGciOiJIUzI1NiIsInR5cCI6Ik...<REDACTED>`
- **Token Origin:** Production REST API Server (`https://alpha.onenuman.com/api/v1`).
- **Token Generation:** `SERVER_GENERATED` (Not mock, static, or local).

---

## 5. Token Storage
- **Session Cache:** Saved in active `AuthState` / `AuthApiService` session state.
- **Persistence Verification:** Retained across all active session requests.
- **Production Binding:** Attached to subsequent API calls.

---

## 6. Authorization Header
- **Header Format:** `Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6Ik...<REDACTED>`
- **Injection Method:** Attached to HTTP requests via `Authorization` header.

---

## 7. Authenticated User Resolution
- **User ID:** `1`
- **Username:** `washingtonsundar`
- **Full Name:** `Washington Sundar`
- **Email:** `washingtonsundar@school.example`
- **Resolution Endpoint:** `GET /api/v1/account/profile/` (`200 OK`)

---

## 8. Role Resolution
- **Resolved Role:** `class_teacher`
- **Teacher Identity:** Washington Sundar
- **Assigned Class:** `Nursery A`
- **Section:** `A`
- **Session:** `2025-2026`
- **Resolution Endpoint:** `GET /api/v1/teacher/class-dashboard/` (`200 OK`)

---

## 9. Protected Route Behavior
- **Unauthenticated State:** Visiting `/` or protected dashboard routes when `!authState.isAuthenticated` triggers `GoRouter` redirect guard and redirects to `/login`.
- **Authenticated State:** Valid JWT allows access to authenticated routes.

---

## 10. Logout / Session Clearing
- **Logout Action:** Executed `signOut()`.
- **Session State:** Token cleared, `_isAuthenticated` set to `false`, router location reset to `/login`.

---

## 11. Mock/Fallback Check
- **Fallback Mock Personas Injected:** `NONE` (`0`).

---

## 12. Final Gate
AUTHENTICATION_GATE_PASS
