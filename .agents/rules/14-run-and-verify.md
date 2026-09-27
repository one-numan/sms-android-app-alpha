# RUN, BUILD AND VERIFY — ANDROID APP

Applies to any AI coding agent (Claude, Gemini/Antigravity, GPT/Codex,
Cursor, Copilot, or other) launching, building, or verifying this
Flutter app, regardless of IDE.

## 1. Device connection — never ask for IP:port

Governed by `wireless_debugging_rule.md`. Run this before any
`adb`/`flutter run` device work:

```bash
./scripts/adb-wireless.sh
```

Never ask the user to read Developer Options for an IP:port and never
hardcode one from a previous session — the port changes every time
Wireless Debugging is toggled. If it exits non-zero with "couldn't
connect", the device isn't paired on this Wi-Fi yet; only then ask for
the one-time `adb pair <ip>:<pairing_port>`.

## 2. Backend reachability

A physical Android device cannot reach the development machine via
`127.0.0.1`. Point the app at the machine's LAN-reachable IP and verify
the phone can actually reach it before treating a failure as app-side
(see `AGENTS.md` §35, `01-data-source-of-truth.md`).

## 3. Build / run

```bash
flutter pub get
flutter run -d <device-id>                       # debug, hot reload
flutter build apk --release --split-per-abi       # release-shaped build
```

## 4. Login during testing

Do not redefine this procedure here. Follow the canonical Android
Credential Entry Rule (global: `android-cli-plugin/rules/AGENTS.md`;
mirrored for this repo in `11-credential-entry.md`).

## 5. Verify the change, not just the build

A successful build/run is not proof the change works. Drive the actual
flow on-device with the right role/persona: confirm real backend data
renders (not cached/stale/mock — see `09-mock-data.md`), confirm
loading/empty/error states stay distinct, and check for regressions in
unrelated screens.

## 6. Tests

```bash
flutter analyze
flutter test
flutter test test/<specific_file>.dart   # narrow, when only one area changed
```

Do not modify a test merely to make it pass — classify the failure
first (`10-testing-verification.md`).

## 7. Before reporting done

Follow `task_completion_verification.md`: re-check `git status`/`git
diff`, classify every requirement as DONE / PARTIALLY DONE / PENDING /
BLOCKED / NOT VERIFIED / NOT APPLICABLE. Never claim physical-device
verification that wasn't actually performed.
