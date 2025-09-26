# router

Small convenience layer on top of `go_router` to standardize routes in the monorepo and integrate with DI via `injectable`/`get_it`.

## Overview

This package exposes:

- `AppRoute`: a lightweight wrapper to declare typed routes and compose child routes. Converts to `GoRoute`.
- `AppRouter`: orchestrates a list of `AppRoute`, builds a `GoRouter` with support for `initialLocation` and a default `errorBuilder`.
- `DefaultNotFound`: simple 404 fallback screen.
- `RouterPackageModule`: injectable micro-package module (for DI integration in the host app).

Public exports in `router.dart`:

- `src/app_route.dart`
- `src/app_router.dart`
- `src/dependencies/injectable.module.dart`

## Dependencies

- flutter
- go_router
- get_it
- injectable (+ build_runner and injectable_generator for generated code)

See `pubspec.yaml` for workspace-managed versions.

## Installation

This package is already part of the Melos workspace. In an external project, add it to `pubspec.yaml` and run:

```
melos bootstrap
flutter pub get
```

If using `injectable` DI integration, generate code as well:

```
dart run build_runner build --delete-conflicting-outputs
```

## How to use

### 1) Define your routes with `AppRoute`

```dart
// in a feature package or the app
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:router/router.dart';

final routes = <AppRoute>[
  AppRoute(
    path: '/',
    name: 'home',
    builder: (context, state) => const HomePage(),
    routes: [
      AppRoute(
        path: 'details',
        name: 'details',
        builder: (context, state) => const DetailsPage(),
      ),
    ],
  ),
];
```

Each `AppRoute` is converted to a `GoRoute` via `toGoRoute()`, preserving `path`, `name`, `builder`, and child routes.

### 2) Create the `AppRouter` with the route list

```dart
final appRouter = AppRouter(
  routes,
  initialLocation: '/', // optional
);

// Inside a MaterialApp.router
MaterialApp.router(
  routerConfig: appRouter.routerConfig,
);
```

`AppRouter` applies a default `errorBuilder` that renders `DefaultNotFound` showing the URL.

### 3) Navigation

Since this uses `go_router`, navigation is the same API:

```dart
// by name
context.goNamed('details');

// by path
context.go('/details');
```

## DI integration (`injectable`/`get_it`)

This package exposes a generated `MicroPackageModule` (`RouterPackageModule`) to be included in the host app init. In the app, something like:

```dart
// app/lib/dependencies/injectable.dart
import 'package:injectable/injectable.dart';
import 'injectable.config.dart';

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

// Somewhere, the generated code calls:
// await RouterPackageModule().init(gh);
```

In the `router` micro‑package, there is also an `@InjectableInit.microPackage()` exposed in `src/dependencies/injectable.dart` (in case the module evolves to include its own bindings).

## Customization

- Replace the 404 page: change `AppRouter` to accept a custom `errorBuilder` or provide another `DefaultNotFound` implementation in the host app.
- Guards/redirects: since the base is `go_router`, you can extend `AppRoute` to include `redirect`/`routes` with advanced `GoRoute` usage if needed.

## Quick examples

### Declaring a route with parameters

```dart
AppRoute(
  path: '/user/:id',
  name: 'user',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return UserPage(id: id);
  },
);
```

### Nested routes

```dart
AppRoute(
  path: '/settings',
  name: 'settings',
  builder: (c, s) => const SettingsPage(),
  routes: [
    AppRoute(
      path: 'profile',
      name: 'settings_profile',
      builder: (c, s) => const ProfileSettingsPage(),
    ),
  ],
);
```

## Package structure

- `lib/router.dart`: exports the public API.
- `lib/src/app_route.dart`: `AppRoute` declaration and conversion to `GoRoute`.
- `lib/src/app_router.dart`: `GoRouter` infrastructure and `routerConfig`.
- `lib/src/default_not_found.dart`: 404 fallback screen.
- `lib/src/dependencies/…`: `injectable` integrations.

## Development

- Formatting and fixes:
  - `dart format .`
  - `dart fix --apply`
- Generate DI code (when annotations change):
  - `dart run build_runner build --delete-conflicting-outputs`

## License

Internal use within this workspace. Adjust according to the project policy.

