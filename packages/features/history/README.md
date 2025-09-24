# history

Feature que observa e exibe o histórico de URLs encurtadas. Atualiza em tempo quase real ao escutar a lista `'shortened_urls'` do `MemoryStorage`.

## Fluxo

1. `HistoryWidget` inicia e chama `HistoryCubit.load()`.
2. Cubit emite `HistoryLoading` e assina a stream de `LoadHistoryUseCase`.
3. Use case delega a `HistoryRepository.watchAll()` que retorna `watchList` invertido (mais recente primeiro).
4. Ao receber dados: estado `HistoryLoaded` com lista.

## Principais classes

- `HistoryWidget` — Renderiza título + lista ou estado vazio / loading.
- `HistoryCubit` / `HistoryState` — Estados: initial, loading, loaded.
- `LoadHistoryUseCase` — Boundary de domínio para observar histórico.
- `HistoryRepository` — Adapta storage para stream tipada de `ShortUrl`.
- `ShortUrl` — Mesmo modelo da feature `create` (com `fromJson`).

## UI States

- Loading: lista de placeholders.
- Empty: widget `DesignEmpty` com ícone e mensagem.
- Loaded: `ListView.separated` de `DesignListItem`.

## Exemplo de uso

```dart
HistoryWidget(); // normalmente dentro da HomePage
```

## Extensões futuras

- Ação de copiar URL curta (`Clipboard.setData`).
- Paginação / limite máximo de itens armazenados.
- Filtro / busca.

## Testes sugeridos

- Mock do repositório emitindo listas vazia e não vazia.
- Verificar transições de estado e renderização condicional.

## Desenvolvimento

Gerar DI (quando houver mudanças de anotação):
```
dart run build_runner build --delete-conflicting-outputs
```

Formatar:
```
dart format .
```

## Licença

Uso interno no workspace.

