# App Host

Main Flutter application that aggregates routes and widgets from the features (`create`, `history`, `home`) and initializes DI before running.

## Responsibilities

- Initialize dependencies via `configureDependencies()`.
- Compose feature routes in `routes.dart`.
- Run `MaterialApp.router` with `AppRouter` (from the `router` package).
- Act as the container for global theming and future app-wide settings.

## Relevant structure

- `lib/main.dart` — main entrypoint.
- `lib/app.dart` — root widget (`App`) with theme and router configuration.
- `lib/routes.dart` — aggregates routes exported by features.
- `lib/dependencies/` — DI setup (`injectable.dart`, generated code).

## Run only the app

From the repo root (using Melos):
```
melos exec -c 1 --scope=app -- flutter run -d <device_id>
```

Or directly:
```
cd app
flutter run -d <device_id>
```

List devices:
```
flutter devices
```

## Code generation (DI)

Regenerate files when annotations change:
```
melos run generate
```
Or
```
dart run melos run generate
```

## Next improvements

- Theming (colors, dark mode).
- Internationalization.
- Logging/observability.
- Real network integration (as the `network` package evolves).

## License

Internal use within this workspace.

