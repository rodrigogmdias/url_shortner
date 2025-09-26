# storage

Simple reactive in-memory storage used to prototype the history of shortened URLs. Provides key/value operations, JSON-serialized lists, and reactive change observation.

## Main APIs (`MemoryStorage`)

- `save(key, value)` — save a string value.
- `delete(key)` — remove a key.
- `watch(key)` — change stream (includes the initial value).
- `addToList(key, value)` — append a serialized element to a list persisted as a JSON string.
- `getList(key, fromJson)` — return a deserialized list.
- `watchList(key, fromJson)` — reactive stream of the whole list.
- `clearList(key)` — clear a list.

## Example

```dart
final storage = MemoryStorage();
await storage.save('foo', 'bar');

storage.watch('foo').listen((value) {
  // react to changes
});

await storage.addToList('items', {'id': 1});
final items = await storage.getList('items', (json) => json as Map<String, dynamic>);
```

## Usage in features

- `create` adds `ShortUrl` into `'shortened_urls'` via `addToList`.
- `history` observes `watchList('shortened_urls')` to render near-real-time updates.

## Limitations

- Non-persistent (everything is lost when the app restarts).
- List operations are denormalized (rewrites the entire array on each append).
- No locking / concurrency safety for multiple isolates.

## Suggested evolution

- Replace with Hive, Isar, or an abstracted storage interface.
- Introduce TTL/expiration for history.
- Migrate to encrypted storage when data sensitivity increases.

## Development

```
dart format .
dart fix --apply
```

## License

Internal use within this workspace.

