# URL Shortener Monorepo (Flutter + Melos)

Modular Flutter monorepo managed with Melos for a simple URL shortener. It includes a host app and reusable packages (core and features) following DI patterns, typed routing, and a lightweight design system.

## Workspace structure

- `app/` — Flutter host application and final route composition.
- `packages/core/design/` — Design System (buttons, texts, inputs, list items, empty states, toasts).
- `packages/core/network/` — HTTP layer built on Dio with typed errors and DI wiring.
- `packages/core/router/` — Routing abstractions on top of `go_router`.
- `packages/core/storage/` — Reactive in-memory storage used for history.
- `packages/features/create/` — Feature to create (shorten) a URL.
- `packages/features/history/` — Feature to list the history of shortened URLs.
- `packages/features/home/` — Composes the main widgets (`CreateWidget` + `HistoryWidget`).

The Melos workspace is declared in the root `pubspec.yaml` using the `workspace:` section, and custom Melos scripts live under the `melos:` key.

## Tech stack

- Flutter (Dart >= 3.9)
- Melos (monorepo management)
- DI: `get_it` + `injectable` (+ build_runner)
- State management: `bloc` for features
- Routing: `go_router` via the `router` package
- Storage: simple reactive in-memory `MemoryStorage` for prototyping

## Prerequisites

Install and configure:

- Flutter SDK that bundles Dart 3.9 (for example, Flutter 3.x that supports Dart 3.9)
- Xcode (for iOS) and/or Android SDK + an emulator/simulator or a physical device
- macOS shell examples below assume `zsh`

Optional (recommended):

- Melos activated globally

```zsh
dart pub global activate melos
```

If you prefer not to install Melos globally, you can run it locally via Dart:

```zsh
# Use local dev_dependency executable
dart run melos <command>
```

## Setup (workspace bootstrap)

From the repository root, bootstrap all packages and link local dependencies:

```zsh
# Using global melos
melos bootstrap

# Or using local executable
dart run melos bootstrap
```

This will run `flutter pub get`/`dart pub get` across all packages and set up path dependencies.

## Code generation (DI / build_runner)

This workspace uses `injectable` and `build_runner` for code generation. A Melos script named `generate` is already defined in the root `pubspec.yaml`.

```zsh
# Using global melos
melos run generate

# Or using local executable
dart run melos run generate
```

This runs build_runner where required (for example, generating `injectable.config.dart`).

## Run the app

Two options:

1) Using Melos to execute within the `app` package directory:

```zsh
# Replace <device_id> with a valid device (see: flutter devices)
melos exec -c 1 --scope=app -- flutter run -d <device_id>

# Or using local executable
dart run melos exec -c 1 --scope=app -- flutter run -d <device_id>
```

2) Directly from the `app` folder:

```zsh
cd app
flutter run -d <device_id>
```

List devices:

```zsh
flutter devices
```

## Common Melos commands

```zsh
# List packages in the workspace
melos list

# Clean .dart_tool across the workspace
melos clean

# Run a command in all packages (example: format)
melos exec -- dart format .

# Run Flutter tests in all packages that contain them
melos exec -- flutter test
```

If using local execution, prefix with `dart run` (for example, `dart run melos list`).

## Notes

- The app initializes dependency injection via `configureDependencies()` in `app/lib/dependencies/injectable.dart` before running `App()`.
- Routes are composed in `app/lib/routes.dart` by aggregating feature routes (e.g., from the `home` package) and provided to `AppRouter` in `app/lib/app.dart`.

## Troubleshooting

- If you change DI annotations or add modules, run code generation again.
- If you run into dependency issues:
  - `melos clean && melos bootstrap`
  - Inside `app/`: `flutter clean` and then bootstrap again
- For iOS builds, open Xcode at least once (licenses) and keep CocoaPods up to date.

## Next steps

- Implement a real network layer usage in features (package `network`).
- Durable persistence (SharedPreferences / Isar / Hive) instead of in-memory storage.
- Unit tests + widget tests for features.


