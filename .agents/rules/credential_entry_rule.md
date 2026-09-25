# ANDROID TESTING — CREDENTIAL ENTRY RULE

Before EVERY login attempt during Android debugging and physical-device testing:

1. **Verify Username**: Verify the exact test username against authoritative seed data / credentials list.
2. **Verify Password**: Verify the exact password corresponding specifically to that username.
3. **Clear Username Field**: Clear the existing username field before entering credentials (e.g. keyevents/select-all/delete or double-check input state).
4. **Clear Password Field**: Clear the existing password field before entering credentials to eliminate residual or autofilled text.
5. **Enter Username**: Enter the verified username.
6. **Enter Password**: Enter the verified password.
7. **Re-check Pair Integrity**: Re-check that the intended credential pair is being used for the target persona.
8. **Submit**: ONLY THEN tap Login / Sign In.

---

### Strict Enforcement & Safety Rules

- **No Assumption**: Never assume the previously entered password is correct.
- **No Cross-Persona Reuse**: Never reuse a password from another test persona.
- **No Stale Autofill**: Never allow stale or autofilled credentials to silently remain in the input fields.
- **Explicit Labeling for Negative Tests**: If testing an invalid-password or negative scenario, explicitly label the step in test execution and reporting as: `INVALID CREDENTIAL TEST`.
- **Credential Privacy**: Do NOT record or expose passwords in screenshots, logs, or QA reports.
- **Defect Attribution Guard**: A login failure caused by incorrect test credentials must NOT be classified as an application or backend defect until the credentials have been independently verified against the backend authority.

This credential verification rule is mandatory for all Android debugging, emulator testing, and physical-device QA sessions.
