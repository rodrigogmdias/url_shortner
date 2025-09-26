# network

Lightweight HTTP layer for the workspace built on top of Dio, with a small set of primitives and DI wiring (injectable/get_it). It provides:

- A typed service to send requests: `NetworkService`.
- A simple `Endpoint` abstraction to model paths, methods, headers, query/body params, and content encoding.
- Strongly-typed `NetworkResponse<T>` with helpers.
- Unified error types via a sealed `NetworkError` hierarchy.
- A `DioProvider` that configures base URL and timeouts from `NetworkEnvironment`.
- An injectable micro-package module to plug into the app container.

This package is intended to be reused by features (create, history, home) to call backend APIs consistently.

## Exports

From `package:network/network.dart`:

- `Endpoint`, `NetworkRequest`, `NetworkResponse<T>`, `NetworkService`.
- `NetworkEnvironment`.
- `HttpMethod`, `ContentEncoding`.
- `NetworkError` and subtypes (`NetworkParsingError`, `NetworkTimeoutError`, `NetworkConnectionError`, `RequestCancelledError`, `HttpStatusError`).
- Injectable module `NetworkPackageModule` (generated).

## Architecture at a glance

- `NetworkEnvironment` exposes `baseUrl` (the app provides the implementation for each flavor/environment).
- `DioProvider` builds a `Dio` with the `baseUrl` and default timeouts.
- `NetworkServiceImpl`:
  - Maps an `Endpoint` to a `NetworkRequest`.
  - Performs the request using Dio.
  - Optionally decodes `response.data` into `T` using a provided `decoder`.
  - Wraps results in `NetworkResponse<T>` and normalizes errors into `NetworkError` types.

## Setup (DI)

1) Ensure the app container imports the generated module and lists it in `externalPackageModulesAfter` (already wired in the app):

```dart
@InjectableInit(
  externalPackageModulesAfter: [
    ExternalModule(RouterPackageModule),
    ExternalModule(NetworkPackageModule),
    // ...other modules
  ],
)
void configureDependencies() => getIt.init();
```

2) Provide a concrete `NetworkEnvironment` in your app composition root:

```dart
class ProdNetworkEnvironment implements NetworkEnvironment {
  @override
  String get baseUrl => 'https://api.example.com';
}

void registerEnvironment(GetIt getIt) {
  getIt.registerLazySingleton<NetworkEnvironment>(() => ProdNetworkEnvironment());
}
```

3) Run code generation when you change DI annotations in this package or the app:

```bash
dart run build_runner build -d
```

## Defining endpoints

Implement `Endpoint` to describe each call:

```dart
class CreateShortUrlEndpoint implements Endpoint {
  CreateShortUrlEndpoint(this.url);
  final String url;

  @override
  String get path => '/shorten';

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  ContentEncoding get contentEncoding => ContentEncoding.json;

  @override
  Map<String, dynamic>? get bodyParameters => {'url': url};

  // Optional overrides:
  // Map<String, dynamic>? get queryParameters => {...};
  // Map<String, String>? get headers => {'X-Trace-Id': '...'};
}
```

## Making requests

Use `NetworkService.send<T>()`. Pass a `decoder` to map dynamic payloads into your models.

```dart
final service = getIt<NetworkService>();

final res = await service.send<ShortUrlDto>(
  CreateShortUrlEndpoint('https://dart.dev'),
  decoder: (data) => ShortUrlDto.fromJson(data as Map<String, dynamic>),
);

if (res.isSuccess) {
  // T is ShortUrlDto
  final dto = res.data;
}
```

### Extra headers and per-call timeout/cancel

```dart
final cancel = CancelToken();

try {
  final res = await service.send<void>(
    SomeEndpoint(),
    extraHeaders: {'Authorization': 'Bearer <token>'},
    timeout: const Duration(seconds: 5),
    cancelToken: cancel,
  );
} finally {
  cancel.cancel();
}
```

Header precedence: `extraHeaders` override `Endpoint.headers` when keys collide.

### Content encoding

- `ContentEncoding.json`: sets `Content-Type: application/json` and sends `body` as JSON.
- `ContentEncoding.formUrlEncoded`: uses Dio's `FormData.fromMap(...)` to build form data and sets form content-type.
- `ContentEncoding.none`: passes the body as-is and does not force a content-type.

## Error handling

All Dio errors are converted into `NetworkError` types, making them easy to catch and branch on:

```dart
try {
  final res = await service.send<MyDto>(endpoint, decoder: MyDto.fromAny);
  // use res
} on HttpStatusError catch (e) {
  // 4xx/5xx with e.statusCode and optional e.body
} on NetworkTimeoutError {
  // request timed out (either per-call timeout or Dio timeouts)
} on RequestCancelledError {
  // cancel token triggered
} on NetworkConnectionError catch (e) {
  // offline/DNS/SSL issues, see e.message
} on NetworkParsingError catch (e) {
  // decoder failed to parse into T
}
```

`NetworkResponse<T>` exposes status code, headers, and decoded data; the raw Dio Response is not exposed anymore.

## Customizing Dio

If you need interceptors, headers, or other tuning, extend or replace `DioProvider`:

```dart
@LazySingleton(as: DioProvider)
class CustomDioProvider implements DioProvider {
  CustomDioProvider(this.env);
  final NetworkEnvironment env;

  @override
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: env.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
      ),
    );
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  }
}
```

Register your custom provider in DI before the generated module or with an override in tests.

## Testing tips

- Prefer wiring a fake `DioProvider` that returns a stubbed `Dio` (e.g., using `http_mock_adapter`) to avoid real network.
- Test just your endpoint decoders with small payload fixtures to keep failures focused on parsing.
- Use per-call `timeout` and `cancelToken` in tests to simulate edge cases.

## Development helpers

Formatting and static fixes:

```bash
dart format .
dart fix --apply
```


