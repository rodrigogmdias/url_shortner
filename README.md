# URL Shortener Monorepo (Flutter + Melos)

A modular Flutter monorepo managed with Melos. The workspace includes a main application and multiple reusable packages (core and features).

## Workspace layout

- `app/` — Flutter application entrypoint.
- `packages/core/design/` — UI design system components.
- `packages/core/network/` — Networking layer and related utilities.
- `packages/core/router/` — App routing abstractions built on top of `go_router`.
- `packages/features/home/` — Home feature module.

The Melos workspace is declared in the root `pubspec.yaml` using the `workspace:` section, and custom Melos scripts live under the `melos:` key.

## Tech stack

- Flutter (Dart >= 3.9)
- Melos workspace management
- Dependency Injection: `get_it` + `injectable`
- Navigation: `go_router` (wrapped by the `router` package)

## Prerequisites

Ensure you have the following installed and configured:

- Flutter SDK that bundles Dart 3.9 (for example, Flutter 3.x that supports Dart 3.9)
- Xcode (for iOS) and/or Android SDK + an emulator/simulator or a physical device
- macOS shell examples below assume `zsh`

Optional, but recommended for global usage:

- Melos globally activated

```zsh
dart pub global activate melos
```

If you prefer not to install Melos globally, you can run it locally via Dart:

```zsh
# Use local dev_dependency executable
dart run melos <command>
```

## Setup (bootstrap the workspace)

From the repository root, bootstrap all packages and link local dependencies:

```zsh
# Using global melos
melos bootstrap

# Or using local executable
dart run melos bootstrap
```

This will run `flutter pub get`/`dart pub get` across all packages and set up path dependencies.

## Code generation

This workspace uses `injectable` and `build_runner` for code generation. A Melos script named `generate` is already defined in the root `pubspec.yaml`.

```zsh
# Using global melos
melos run generate

# Or using local executable
dart run melos run generate
```

This runs build_runner where required (for example, generating `injectable.config.dart`).

## Run the application

You can run the app in two ways.

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

Tip: list devices with:

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

- If you change DI annotations or add new modules, re-run the code generation step.
- If you see dependency resolution issues, try:
	- `melos clean && melos bootstrap`
	- `flutter clean` inside `app/` (and re-run bootstrap)
- For iOS builds, ensure you have opened Xcode at least once to accept licenses, and that CocoaPods is up to date.

