# create

Feature responsible for shortening URLs and persisting the result in in-memory storage. Exposes `CreateWidget` and registers dependencies via `injectable`.

## Flow

1. The user enters a URL in the `DesignTextField`.
2. On submit (`DesignButton`), `CreateCubit` calls `CreateUseCase`.
3. The use case delegates to `CreateRepository` that simulates (future: calls an API) and persists `ShortUrl` into `MemoryStorage` (list key: `shortened_urls`).
4. The `history` feature receives an update via stream and lists the newly created item.

## Key classes

- `CreateWidget` — UI component (input + button + loading states via BlocBuilder).
- `CreateCubit` / `CreateState` — Manages states: initial, loading, success, error.
- `CreateUseCase` — Domain boundary for creation.
- `CreateRepository` — Interacts with storage (future: network + cache).
- `ShortUrl` — Simple model (originalUrl, shortUrl).

## Quick usage

```dart
CreateWidget(); // place inside a page (e.g., HomePage)
```

Success/error reactions can be added via `BlocListener` (the widget is ready; UI feedback is to be implemented).

## Future extensions

- URL validation (regex or `validators` package).
- Real network error handling.
- Visual feedback (SnackBar / Banner) on success/error.
- Automatically copy the shortened URL.

## Tests (to add)

- Mock `CreateUseCase` validating state transitions.
- Integration test adding an item and verifying the history stream.

## Development

Regenerate DI when new annotations are added:
```
dart run build_runner build --delete-conflicting-outputs
```

Format:
```
dart format .
```

## License

Internal use within this workspace.

