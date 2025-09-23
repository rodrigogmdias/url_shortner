# router

Pequena camada de conveniência sobre o `go_router` para padronizar rotas no monorepo e integrar com DI via `injectable`/`get_it`.

## Visão geral

Este pacote expõe:

- `AppRoute`: um wrapper leve para declarar rotas de forma tipada e compor rotas filhas. Converte para `GoRoute`.
- `AppRouter`: orquestra a lista de `AppRoute`, cria um `GoRouter` com suporte a `initialLocation` e `errorBuilder` padrão.
- `DefaultNotFound`: tela 404 simples usada como fallback.
- `RouterPackageModule`: módulo de micro‑pacote do `injectable` (para integração DI no app host).

Exportações públicas em `router.dart`:

- `src/app_route.dart`
- `src/app_router.dart`
- `src/dependencies/injectable.module.dart`

## Dependências

- flutter
- go_router
- get_it
- injectable (+ build_runner e injectable_generator para código gerado)

Veja `pubspec.yaml` para as versões gerenciadas por workspace.

## Instalação

O pacote já está parte do workspace Melos. Em um projeto externo, adicione no `pubspec.yaml` e rode:

```
melos bootstrap
flutter pub get
```

Se for usar a integração de DI do `injectable`, também gere os arquivos:

```
dart run build_runner build --delete-conflicting-outputs
```

## Como usar

### 1) Defina suas rotas com `AppRoute`

```dart
// em algum package de feature ou no app
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

Cada `AppRoute` é convertido para `GoRoute` via `toGoRoute()`, preservando `path`, `name`, `builder` e rotas filhas.

### 2) Crie o `AppRouter` com a lista de rotas

```dart
final appRouter = AppRouter(
	routes,
	initialLocation: '/', // opcional
);

// Em um MaterialApp.router
MaterialApp.router(
	routerConfig: appRouter.routerConfig,
);
```

O `AppRouter` aplica um `errorBuilder` padrão que renderiza `DefaultNotFound` exibindo a URL.

### 3) Navegação

Como usa `go_router`, a navegação é a mesma API:

```dart
// por name
context.goNamed('details');

// por path
context.go('/details');
```

## Integração com DI (`injectable`/`get_it`)

O pacote expõe um `MicroPackageModule` gerado (`RouterPackageModule`) para ser incluído no `init` do app host. No app, algo como:

```dart
// app/lib/dependencies/injectable.dart
import 'package:injectable/injectable.dart';
import 'injectable.config.dart';

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

// Em algum ponto, o código gerado chama:
// await RouterPackageModule().init(gh);
```

No micro‑pacote `router`, existe também um `@InjectableInit.microPackage()` exposto em `src/dependencies/injectable.dart` (caso precise evoluir o módulo com bindings próprios futuramente).

## Personalizações

- Substituir a página 404: altere `AppRouter` para aceitar um `errorBuilder` customizado ou forneça outra implementação de `DefaultNotFound` no app host.
- Guardas/redirecionamentos: como a base é `go_router`, você pode estender `AppRoute` para incluir `redirect`/`routes` com `GoRoute` avançado se necessário.

## Exemplos rápidos

### Declarando uma rota com parâmetros

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

### Rotas aninhadas

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

## Estrutura do pacote

- `lib/router.dart`: exporta a API pública.
- `lib/src/app_route.dart`: declaração de `AppRoute` e conversão para `GoRoute`.
- `lib/src/app_router.dart`: infraestrutura do `GoRouter` e `routerConfig`.
- `lib/src/default_not_found.dart`: tela de fallback 404.
- `lib/src/dependencies/…`: integrações `injectable`.

## Desenvolvimento

- Formatação e fixes automáticos:
	- `dart format .`
	- `dart fix --apply`
- Gerar código de DI (quando houver alterações nas anotações):
	- `dart run build_runner build --delete-conflicting-outputs`

## Licença

Uso interno no workspace. Ajuste conforme a política do projeto.

