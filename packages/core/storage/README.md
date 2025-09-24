# storage

Armazenamento simples em memória reativo utilizado para prototipar histórico de URLs encurtadas. Fornece operações de chave/valor, listas serializadas em JSON e observação reativa de mudanças.

## Principais APIs (`MemoryStorage`)

- `save(key, value)` — salva string.
- `delete(key)` — remove chave.
- `watch(key)` — stream de mudanças (inclui valor inicial).
- `addToList(key, value)` — adiciona elemento serializado a uma lista JSON persistida em string.
- `getList(key, fromJson)` — retorna lista desserializada.
- `watchList(key, fromJson)` — stream reativa da lista inteira.
- `clearList(key)` — limpa lista.

## Exemplo

```dart
final storage = MemoryStorage();
await storage.save('foo', 'bar');

storage.watch('foo').listen((value) {
	// reage a mudanças
});

await storage.addToList('items', {'id': 1});
final items = await storage.getList('items', (json) => json as Map<String, dynamic>);
```

## Uso em Features

- `create` adiciona `ShortUrl` em `'shortened_urls'` via `addToList`.
- `history` observa `watchList('shortened_urls')` para renderizar atualizações em tempo quase real.

## Limitações

- Não persistente (tudo é perdido ao reiniciar o app).
- Operações com listas desnormalizadas (re-escreve array inteiro a cada inclusão).
- Sem locking / concorrência segura para múltiplos isolates.

## Evolução Sugerida

- Substituir por Hive, Isar ou implementação abstraída via interface.
- Introduzir TTL / expiração para histórico.
- Migração para storage criptografado quando houver sensibilidade de dados.

## Desenvolvimento

```
dart format .
dart fix --apply
```

## Licença

Uso interno no workspace.

