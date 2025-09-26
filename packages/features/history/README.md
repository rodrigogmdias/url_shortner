# history

Feature that observes and displays the history of shortened URLs. Updates near real time by listening to the `'shortened_urls'` list from `MemoryStorage`.

## Flow

1. `HistoryWidget` starts and calls `HistoryCubit.load()`.
2. The cubit emits `HistoryLoading` and subscribes to the stream from `LoadHistoryUseCase`.
3. The use case delegates to `HistoryRepository.watchAll()` which returns a reversed `watchList` (newest first).
4. On data emission, the cubit yields `HistoryLoaded` with the list.

## Key classes

- `HistoryWidget` — Renders title + list or empty/loading state.
- `HistoryCubit` / `HistoryState` — States: initial, loading, loaded.
- `LoadHistoryUseCase` — Domain boundary to observe history.
- `HistoryRepository` — Adapts storage to a typed stream of `ShortUrl`.
- `ShortUrl` — Same model as the `create` feature (with `fromJson`).

## UI states

- Loading: list of placeholders.
- Empty: `DesignEmpty` widget with icon and message.
- Loaded: `ListView.separated` of `DesignListItem`.

## Usage

```dart
HistoryWidget(); // typically inside HomePage
```

## Future extensions

- Copy short URL action (`Clipboard.setData`).
- Pagination / maximum number of stored items.
- Filter / search.

## Suggested tests

- Mock the repository to emit empty and non-empty lists.
- Verify state transitions and conditional rendering.

## Development

Regenerate DI when annotations change:
```
dart run build_runner build --delete-conflicting-outputs
```

Format:
```
dart format .
```

## License

Internal use within this workspace.

