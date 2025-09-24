# URL Shortener Monorepo (Flutter + Melos)

Monorepo modular Flutter gerenciado com Melos para um encurtador de URLs. Inclui um app host e pacotes reutilizáveis (core e features) seguindo padrões de DI, roteamento tipado e design system simples.

## Estrutura do workspace

- `app/` — Aplicação Flutter (host) e composição final de rotas.
- `packages/core/design/` — Design System (botões, textos, inputs, list items, empty states).
- `packages/core/network/` — (placeholder) Camada de rede futura.
- `packages/core/router/` — Abstrações de roteamento sobre `go_router`.
- `packages/core/storage/` — Armazenamento em memória reativo usado para histórico.
- `packages/features/create/` — Feature para criar (encurtar) uma URL.
- `packages/features/history/` — Feature para listar histórico de URLs encurtadas.
- `packages/features/home/` — Agrega widgets principais (`CreateWidget` + `HistoryWidget`).

The Melos workspace is declared in the root `pubspec.yaml` using the `workspace:` section, and custom Melos scripts live under the `melos:` key.

## Stack técnica

- Flutter (Dart >= 3.9)
- Melos (gerenciamento monorepo)
- DI: `get_it` + `injectable` (+ build_runner)
- State management: `bloc` para features
- Routing: `go_router` via pacote `router`
- Storage: in-memory reativo (`MemoryStorage`) simples para protótipo

## Pré‑requisitos

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

## Setup (bootstrap do workspace)

From the repository root, bootstrap all packages and link local dependencies:

```zsh
# Using global melos
melos bootstrap

# Or using local executable
dart run melos bootstrap
```

This will run `flutter pub get`/`dart pub get` across all packages and set up path dependencies.

## Geração de código (DI / build_runner)

This workspace uses `injectable` and `build_runner` for code generation. A Melos script named `generate` is already defined in the root `pubspec.yaml`.

```zsh
# Using global melos
melos run generate

# Or using local executable
dart run melos run generate
```

This runs build_runner where required (for example, generating `injectable.config.dart`).

## Executar a aplicação

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

## Comandos Melos comuns

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

## Notas

- The app initializes dependency injection via `configureDependencies()` in `app/lib/dependencies/injectable.dart` before running `App()`.
- Routes are composed in `app/lib/routes.dart` by aggregating feature routes (e.g., from the `home` package) and provided to `AppRouter` in `app/lib/app.dart`.

## Troubleshooting / Dicas

- Se alterar anotações de DI ou adicionar módulos, rode novamente a geração de código.
- Se houver problemas de dependências:
  - `melos clean && melos bootstrap`
  - `flutter clean` dentro de `app/` e depois bootstrap
- Para builds iOS, abra o Xcode ao menos uma vez (licenças) e mantenha CocoaPods atualizado.

## Próximos passos

- Implementar camada real de rede no pacote `network`.
- Persistência durável (SharedPreferences / Isar / Hive) em vez de armazenamento em memória.
- Testes unitários + widget tests para features.


