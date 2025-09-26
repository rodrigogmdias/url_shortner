# home

Feature that composes the app home screen by aggregating `CreateWidget` (shorten URL) and `HistoryWidget` (history). It also exposes routes via `homeRoutes` to integrate into the main router.

## Routes

`homeRoutes` provides:

```dart
AppRoute(path: '/', builder: (_, __) => const HomePage());
```

## UI composition

`HomePage` contains:
- Input + button to shorten (create feature).
- List / empty / loading states (history feature).

Simplified structure:
```dart
Column(
  children: [
    CreateWidget(),
    Expanded(child: HistoryWidget()),
  ],
)
```

## Future extensions

- AppBar with theme/branding.
- Responsiveness (desktop/web adaptive layout).
- Additional sections (click analytics per URL, etc.).

## Integration

In the app host (e.g., `routes.dart`), add `homeRoutes` to other feature routes before creating `AppRouter`.

## Development

```
dart format .
```

## License

Internal use within this workspace.

