# create

Feature responsável por encurtar URLs e persistir o resultado no storage em memória. Expõe `CreateWidget` e registra dependências via `injectable`.

## Fluxo

1. Usuário digita uma URL no `DesignTextField`.
2. Ao clicar em enviar (`DesignButton`), o `CreateCubit` chama `CreateUseCase`.
3. O use case delega ao `CreateRepository` que simula (futuro: chama API) e persiste `ShortUrl` em `MemoryStorage` (lista `shortened_urls`).
4. `History` feature recebe atualização via stream e lista item recém criado.

## Principais classes

- `CreateWidget` — Componente de UI (campo + botão + estados de loading via BlocBuilder).
- `CreateCubit` / `CreateState` — Gerencia estados: initial, loading, success, error.
- `CreateUseCase` — Boundary de domínio para criação.
- `CreateRepository` — Interage com storage (futuro: rede + cache).
- `ShortUrl` — Modelo simples (originalUrl, shortUrl).

## Exemplo de uso direto

```dart
CreateWidget(); // inserido em uma tela (ex: HomePage)
```

Reação ao sucesso/erro pode ser adicionada via `BlocListener` (já preparado no widget, faltando implementação de UI feedback).

## Extensões futuras

- Validação de URL (regex ou pacote `validators`).
- Tratamento de erros de rede reais.
- Feedback visual (SnackBar / Banner) no success/error.
- Copiar automáticamente a URL encurtada.

## Testes (a implementar)

- Mock de `CreateUseCase` validando transições de estado.
- Teste de integração adicionando item e verificando stream de histórico.

## Desenvolvimento

Gerar DI quando houver novas anotações:
```
dart run build_runner build --delete-conflicting-outputs
```

Formatar:
```
dart format .
```

## Licença

Uso interno no workspace.

