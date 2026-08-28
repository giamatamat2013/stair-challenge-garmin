# Stair Challenge

A Garmin Connect IQ watch-app for stair-based workouts — free-form training with
various exercises and drills on stairs, recorded as a real **Stair Climbing**
activity that syncs to Garmin Connect like any built-in activity.

## What it does

- Records a genuine FIT activity (`SPORT_FITNESS_EQUIPMENT` /
  `SUB_SPORT_STAIR_CLIMBING`) via `Toybox.ActivityRecording` — it shows up in
  Garmin Connect as Stair Climbing, not a generic workout.
- Free-form recording: start, pause, resume, and mark a manual **Lap**
  between exercises — no fixed set/rep structure.
- Live display: elapsed time, heart rate, calories, lap count, and floors
  climbed/descended (from `totalAscent`/`totalDescent`, ~3m per floor).
- On devices without a barometric altimeter (e.g. Forerunner 55), the floors
  row is compiled out entirely rather than shown with fake/unreliable data.
- Back button is blocked while an activity is recording or paused, to avoid
  losing a workout by accident — you must explicitly Save or Discard.

## Controls

- **Select** — start → pause → resume
- **Menu** — Lap / Save Activity / Discard
- **Back** — exits the app (only when idle)

## Supported devices

fr55, fr57042mm, fr57047mm, fr970, vivoactive4s (see `manifest.xml`).

## Development

Requires the Connect IQ SDK and a developer key (`developer_key.der`, not
committed — generate your own with `openssl genrsa`/`openssl pkcs8`, or via
the Monkey C extension's "Generate a Developer Key" command, and point
`monkeyC.developerKeyPath` in `.vscode/settings.json` at it).

Press **F5** in VS Code with the Monkey C extension installed — a
`preLaunchTask` starts the Connect IQ Simulator automatically if it isn't
already running.
