# WIRELESS DEBUGGING — USE THE SCRIPT, NEVER ASK FOR IP:PORT

The dev device connects over Android Wireless Debugging. The port Android
assigns changes every time Wireless Debugging is toggled on the phone —
asking the user for the current IP:port is never reliable and must not be
the first move.

## What to do instead

Run this before any `adb`/`flutter run` device work:

```bash
./scripts/adb-wireless.sh
```

It auto-discovers the device via `adb mdns services` and connects — no
manual IP or port needed, even after the port has changed.

## Rules

- **Never** ask the user to open Developer Options and read out the
  IP:port. Run the script first.
- **Never** hardcode an IP:port you saw in a previous session — it is
  almost certainly stale.
- If the script exits non-zero with "couldn't connect", the device has
  not been paired on this Wi-Fi network yet. Only then ask the user to
  run the one-time pairing command it prints
  (`adb pair <ip>:<pairing_port>`) from the phone's "Pair device with
  pairing code" screen. This pairing step is per-network and rare, not
  the normal path.
- If `adb devices` already shows a `device` (not `unauthorized`/`offline`)
  entry, the connection is already live — do not reconnect or touch it.

## Installing the APK over Wireless Debugging — known hang, use the workaround

On this project's Realme (ColorOS) test device, a direct network-streamed
install reliably hangs at "Package Manager is committing the install" —
observed to hang 30+ minutes across every variant tried (`adb install`,
`-r -d`, `--no-streaming`, plain `flutter run`). This is a device/OS
install-path issue, not a build problem — the APK itself builds fine and
the device stays connected throughout.

**Do not repeatedly retry `adb install` variants when it hangs.** After
one hang (state stuck / no "Success" for ~30–60s past a normal-sized
push), switch immediately to the proven workaround — push the APK to
device storage, then install it locally via the device's own package
manager:

```bash
adb -s <device> push build/app/outputs/flutter-apk/app-debug.apk /data/local/tmp/app.apk
adb -s <device> shell pm install -r -d /data/local/tmp/app.apk
```

This has consistently succeeded where the direct network install hangs.
Prefer it as the default install method on this device rather than
rediscovering it after a long timeout each time.
