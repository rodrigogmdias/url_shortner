# home

Feature que compõe a tela inicial do app agregando `CreateWidget` (encurtar URL) e `HistoryWidget` (histórico). Também expõe rotas via `homeRoutes` para integração no roteador principal.

## Rotas

`homeRoutes` fornece:

```dart
AppRoute(path: '/', builder: (_, __) => const HomePage());
```

## Composição de UI

`HomePage`:
- Campo + botão para encurtar (feature create).
- Lista / estado vazio / loading (feature history).

Estrutura simplificada:
```dart
Column(
	children: [
		CreateWidget(),
		Expanded(child: HistoryWidget()),
	],
)
```

## Extensões futuras

- AppBar com tema / branding.
- Responsividade (layout adaptativo desktop/web).
- Seções adicionais (analytics de cliques por URL, etc.).

## Integração

No app host (ex: `routes.dart`) agregue `homeRoutes` às demais rotas de features antes de criar o `AppRouter`.

## Desenvolvimento

```
dart format .
```

## Licença

Uso interno no workspace.

